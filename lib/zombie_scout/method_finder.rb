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
      receiver, method_name, args = *node
      if receiver.nil?  # Then it's a private method call
        @private_method_calls << method_name
      end
      process(args)
    end

    private

    def stash_method(method_name, node_location)
      line_number = node_location.line
      location = [@ruby_source.path, line_number].join(":")
      @methods << Method.new(method_name, location)
    end
  end
end
