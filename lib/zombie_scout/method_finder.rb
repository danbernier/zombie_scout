require 'parser/current'

module ZombieScout
  Method = Class.new(Struct.new(:name, :location))

  class MethodFinder < Parser::AST::Processor
    def initialize(ruby_source)
      @ruby_source = ruby_source
    end

    def find_methods
      @method_names = []

      node = Parser::CurrentRuby.parse(@ruby_source.source)
      process(node)

      @method_names 
    end

    def on_def(node) 
      method_name, args, body = *node 
      stash_method(method_name, node.location)
      process(body) 
    end

    def on_defs(node)
      self_node, method_name, args, body = *node
      stash_method(method_name, node.location)
      process(body)
    end

    private 

    def stash_method(method_name, node_location)
      line_number = node_location.line
      location = [@ruby_source.path, line_number].join(":")
      @method_names << Method.new(method_name, location)
    end
  end
end
