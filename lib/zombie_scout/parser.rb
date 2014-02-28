require 'parser/current'

module ZombieScout
  Method = Class.new(Struct.new(:name, :location))

  class Parser < Parser::AST::Processor
    attr_reader :defined_methods, :called_methods

    def initialize(ruby_source)
      @ruby_source = ruby_source
      @defined_methods = []
      @called_methods = []
      node = ::Parser::CurrentRuby.parse(@ruby_source.source)
      process(node)
    end

    def on_def(node)
      method_name, args, body = *node
      stash_method(method_name, node)
      process(body)
    end

    def on_defs(node)
      self_node, method_name, args, body = *node
      stash_method(method_name, node)
      process(body)
    end

    def on_send(node)
      receiver, method_name, *args = *node
      if respond_to?(:"handle_#{method_name}", true)
        send(:"handle_#{method_name}", args, node)
      end
      @called_methods << method_name
      process_all(args)
    end

    private

    def handle_attr_reader(args, node)
      args.each do |arg|
        if_symbol(arg) do |attr_method_name|
          stash_method(attr_method_name, node)
        end
      end
    end

    def handle_attr_writer(args, node)
      args.each do |arg|
        if_symbol(arg) do |attr_method_name|
          stash_method(:"#{attr_method_name}=", node)
        end
      end
    end

    def handle_attr_accessor(args, node)
      args.each do |arg|
        if_symbol(arg) do |attr_method_name|
          stash_method(attr_method_name, node)
          stash_method(:"#{attr_method_name}=", node)
        end
      end
    end

    def handle_def_delegators(args, node)
      args.drop(1).each do |arg|
        if_symbol(arg) do |attr_method_name|
          stash_method(attr_method_name, node)
        end
      end
    end

    def handle_def_delegator(args, node)
      if_symbol(args.last) do |attr_method_name|
        stash_method(attr_method_name, node)
      end
    end

    def handle_scope(args, node)
      if_symbol(args.first) do |attr_method_name|
        stash_method(attr_method_name, node)
      end
    end

    def if_symbol(node)
      maybe_symbol = SymbolExtracter.new.process(node)
      if maybe_symbol.is_a? Symbol
        yield maybe_symbol
      end
    end

    def stash_method(method_name, node)
      line_number = node.location.line
      location = [@ruby_source.path, line_number].join(":")
      @defined_methods << Method.new(method_name, location)
    end
  end

  class SymbolExtracter < ::Parser::AST::Processor
    def on_sym(node)
      node.to_a[0]
    end
  end
end
