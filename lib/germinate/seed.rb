module Germinate
  class Seed
    class_inheritable_accessor :model, :records, :statuses

    class << self
      attr_reader :seeds

      def inherited(subclass)
        subclass.model = $`.constantize if subclass.name =~ /Seed$/
        subclass.records = []
        subclass.statuses = {}
        (@seeds ||= []) << subclass
        @seeds.uniq!
      end

      def method_missing(method, *args)
        if Germinate::Record::METHODS.include?(method)
          yield Germinate::Factory.new(self, method)
        else
          super
        end
      end
    end
  end
end
