require 'parser/current'

module ZombieScout
  Method = Class.new(Struct.new(:name, :location))

  class MethodFinder < Parser::AST::Processor
    def initialize(ruby_source)
      @ruby_source = ruby_source
    end

    def find_methods
      @methods = []
      @private_method_calls = []

      node = Parser::CurrentRuby.parse(@ruby_source.source)
      process(node)

      @methods.reject { |method|
        @private_method_calls.include?(method.name)
      }
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

    def on_send(node)
      receiver, method_name, *args = *node
      if respond_to?(:"on_#{method_name}", true)
        send(:"on_#{method_name}", args, node)
      elsif receiver.nil?  # Then it's a private method call
        @private_method_calls << method_name
        process_all(args)
      end
    end

    private

    def on_attr_reader(args, node)
      args.each do |arg|
        attr_method_name = SymbolExtracter.new.process(arg)
        stash_method(attr_method_name, node.location)
      end
    end

    def on_attr_writer(args, node)
      args.each do |arg|
        attr_method_name = SymbolExtracter.new.process(arg)
        stash_method(:"#{attr_method_name}=", node.location)
      end
    end

    def on_attr_accessor(args, node)
      args.each do |arg|
        attr_method_name = SymbolExtracter.new.process(arg)
        stash_method(attr_method_name, node.location)
        stash_method(:"#{attr_method_name}=", node.location)
      end
    end

    def on_def_delegators(args, node)
      args.drop(1).each do |arg|
        attr_method_name = SymbolExtracter.new.process(arg)
        stash_method(attr_method_name, node.location)
      end
    end

    def on_def_delegator(args, node)
      attr_method_name = SymbolExtracter.new.process(args.last)
      stash_method(attr_method_name, node.location)
    end

    def stash_method(method_name, node_location)
      line_number = node_location.line
      location = [@ruby_source.path, line_number].join(":")
      @methods << Method.new(method_name, location)
    end
  end

  class SymbolExtracter < Parser::AST::Processor
    def on_sym(node)
      node.to_a[0]
    end
  end
end
