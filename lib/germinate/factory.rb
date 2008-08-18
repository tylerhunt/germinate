module Germinate
  class Factory
    def initialize(seed, method)
      @seed, @method = seed, method
    end

    define_method :id do |*args|
      add_record(:id, *args)
    end

    def method_missing(method, *args)
      add_record(method, *args)
    end

    def add_record(key, *values)
      @seed.records << (record = Record.new(@seed, @method, key, *values))
      record
    end
    private :add_record
  end
end
