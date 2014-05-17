require 'ripper'
require 'pp'

class TreeWalker
  attr_reader :visitor
  def initialize(tree, visitor)
    @tree, @visitor = tree, visitor
    @stack = []
  end

  # tree must be from Ripper.sexp_raw
  def walk(tree=@tree, indent='')
    tag, *rest = tree
    @stack.push tag
    #puts "#{indent}#{tag} (#{@stack.reverse.drop(1).reverse.join('/')})"

    hook = :"on_#{tag}"
    if visitor.respond_to?(hook)
      visitor.send(hook, rest)
    end
    
    rest.each do |node|
      if node.is_a? Array
        if node.size == 2 && node.map(&:class).uniq == [Fixnum]
          # it's a location, ignore
        elsif node.first.is_a? Symbol
          # it's a node, recurse!
          walk(node, "#{indent}  ")
        end  
      else
        # it's a details-node, ignore for now
      end
    end

    hook = :"after_#{tag}"
    if visitor.respond_to?(hook)
      visitor.send(hook)
    end
  end
end

class MyParser
  def initialize(source)
    @source = source
    @method_calls = []
    @class_module_stack = []
    @defined_methods = []
  end

  def parse
    tree = Ripper.sexp_raw(@source)
    TreeWalker.new(tree, self).walk

    puts "Methods called:"
    puts @method_calls.map { |mc| "* #{mc}" } * "\n"

    puts "Class/Module stack:"
    puts @class_module_stack

    puts "Defined methods:"
    puts @defined_methods.map(&:inspect) 
  end

  def on_call(node)
    #  [:call,
    #     {{receiver}},
    #     :".",
    #     [:@ident, "upcase", [4, 13]]] 
    receiver, dot, (tag, method_name, loc) = *node
    @method_calls << method_name
  end

  def on_class(node)
    # [:class,
    #    [:const_ref, [:@const, "Hoom", [2, 8]]],
    #    nil,
    #    [:bodystmt, [:stmts_add, [:stmts_new], ...],
    #     nil, nil, nil]]
    const_ref, (const, name, location), rest = *(node.first)
    @class_module_stack.push(name)
  end

  def after_class
    @class_module_stack.pop
  end

  def on_def(node)
    #  [:def,
    #   [:@ident, "heem", [3, 8]],
    #   [:params, nil, nil, nil, nil, nil, nil, nil],
    #   [:bodystmt, [:stmts_add, [:stmts_new], ...  ],
    #    nil, nil, nil]]
    (ident, name, (line, char)) = *(node.first)
    #puts [@class_module_stack * '::', '#', name, ':', line].join('')
    @defined_methods << [@class_module_stack * '::', name, line]
  end

  alias_method :on_module, :on_class
  alias_method :after_module, :after_class
end

ruby = "
  module Hoom
    def heem
      #'hhhh'.upcase
    end
    #class Nested
    #  def peep
    #    'for the birds'
    #  end
    #end
  end
"

# Ok, SexpBuilders go inside-out, bottom-up. I want a SAX-style model, top-down, outside-in.
# This is pretty cool, though.
#class MyParser < Ripper::SexpBuilder
#  def initialize(source)
#    @class_mod_stack = []
#    @defined_methods = []
#    @called_methods = []
#    super(source)
#  end
#
#  def on_class(class_node, parent_node, *rest)
#    @class_mod_stack.push class_node
#    puts "class stack: #{@class_mod_stack.inspect}"
#    super
#  end
#
#  def on_const_ref(const)
#    const
#  end
#
#  def on_const(name)
#    name
#  end
#
#  def on_ident(name)
#    name
#  end
#
#  def on_call(receiver, dot, method_name, *args)
#    @called_methods.push(method_name)
#  end
#end

class XmlGen
  def initialize(source)
    @source = source
  end

  def parse
    tree = Ripper.sexp_raw(@source)
    pp tree
    walk(tree).flatten.join('')
  end

  def walk(tree, indent='')
    xml = []
    tag, *rest = *tree
    xml << "#{indent}<#{tag}"
    rest.each do |node|
    end

  end
end

#pp tree=Ripper.sexp_raw(ruby)
puts ' < breath >'
#MyParser.new(ruby).parse
puts XmlGen.new(ruby).parse

#                                                                               [:program,
# [:program,                                                                     [:stmts_add,                                       
#  [[:class,                                                                      [:stmts_new],
#    [:const_ref, [:@const, "Hoom", [2, 8]]],                                     [:class,
#    nil,                                                                          [:const_ref, [:@const, "Hoom", [3, 8]]],
#    [:bodystmt,                                                                   nil,
#     [[:def,                                                                      [:bodystmt,
#       [:@imdent, "heem", [3, 8]],                                                  [:stmts_add,
#       [:params, nil, nil, nil, nil, nil, nil, nil],                                [:stmts_new],
#       [:bodystmt,                                                                  [:def,
#        [[:call,                                                                     [:@ident, "heem", [3, 8]],
#          [:string_literal,                                                          [:params, nil, nil, nil, nil, nil, nil, nil],
#           [:string_content, [:@tstring_content, "hhhh", [4, 7]]]],                  [:bodystmt,
#          :".",                                                                       [:stmts_add,
#          [:@ident, "upcase", [4, 13]]]],                                              [:stmts_new],
#        nil,                                                                           [:call,
#        nil,                                                                            [:string_literal,
#        nil]]],                                                                          [:string_add,
#     nil,                                                                                 [:string_content],
#     nil,                                                                                 [:@tstring_content, "hhhh", [4, 7]]]],
#     nil]]]]                                                                            :".",
#                                                                                        [:@ident, "upcase", [4, 13]]]],
#                                                                                      nil,
#                                                                                      nil,
#                                                                                      nil]]],
#                                                                                   nil,
#                                                                                   nil,
#                                                                                   nil]]]]


<<XML
<program>
  <class>
    <const_ref><const line="2" char="8">Hoom</const></const_ref>
    nil
    <bodystmt>
      <def>
        <imdent line="3" char="8">heem</imdent>
        <params/>
        <bodystmt>
          <call>
            <string_literal><string_content><tstring_content line="4" char="7">hhhh</tstring_content></string_content></string_literal>
            <ident line="4" char="13">upcase</ident>
          </call>
        </bodystmt>
      </def>
    </bodystmt>
  </class>
</program>
XML
