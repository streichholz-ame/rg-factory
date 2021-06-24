require 'pry'

class Factory
  class << self
    def new(*args, &block)
      return 'Error' if args.first.empty?

      const_set(args.shift.capitalize, new(*args, &block)) if args.first.is_a? String
      create_class(*args, &block)
    end

    def create_class(*args, &block)
      Class.new do
        attr_accessor(*args)

        define_method :initialize do |*arg_value|
          raise ArgumentError unless arg_value.length == args.length

          args.zip(arg_value).each do |instance_key, instance_value|
            instance_variable_set("@#{instance_key}", instance_value)
          end
        end

        define_method :values do
          instance_variables.map { |arg| instance_variable_get(arg) }
        end

        define_method :members do
          instance_variables.map { |arg| arg.to_s.delete('@').to_sym }
        end

        define_method :eql? do |other|
          instance_of?(other.class) && values == other.values
        end

        define_method :[] do |arg|
          return instance_variable_get("@#{arg}") if [String, Symbol].include? arg.class
          return instance_variable_get(instance_variables[arg]) if arg.is_a? Integer
        end

        define_method :[]= do |arg, value|
          return instance_variable_set("@#{arg}", value) if [String, Symbol].include? arg.class
          return instance_variable_set(instance_variables[arg], value) if arg.is_a? Integer
        end

        define_method :to_h do
          members.zip(values).to_h
        end

        define_method :dig do |*arg|
          arg.inject(to_h) do |hash, key|
            break unless hash[key]

            hash[key]
          end
        end

        define_method :each do |&block|
          members.each { |arg| block.call(public_send(arg)) }
        end

        define_method :each_pair do |&block|
          to_h.each_pair(&block)
        end

        define_method :length do
          instance_variables.length
        end

        define_method :select do |&block|
          values.select(&block)
        end

        define_method :values_at do |*index|
          instance_variables.values_at(*index).map { |arg| instance_variable_get(arg) }
        end

        class_eval(&block) if block
        alias_method :==, :eql?
        alias_method :size, :length
        alias_method :to_a, :values
      end
    end
  end
end
