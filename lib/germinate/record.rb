module Germinate
  class Record
    METHODS = [:create, :update, :create_or_update].freeze

    attr_accessor :status

    def initialize(seed, method, key, *values)
      @seed, @method, @keys, @values = seed, method, key, values
    end

    def with(attributes)
      @attributes = attributes
      self
    end

    def execute
      send(@method)
    end

    def create
      unless find
        record = new
        record.save!
        record
      else
        raise ActiveRecord::RecordNotSaved, "Duplicate #{@seed.model.name} found with with #{human_key}"
      end
    end
    private :create

    def update
      if record = find
        record.save!
        record
      else
        raise ActiveRecord::RecordNotFound, "Couldn't find a #{@seed.model.name.downcase} with #{human_key}"
      end
    end
    private :update

    def create_or_update
      begin
        update
      rescue ActiveRecord::RecordNotFound
        create
      end
    end
    private :create_or_update

    def find
      if record = @seed.model.send("find_by_#{@keys}", *@values)
        @status = :updated
        modify(record)
      end
    end
    private :find

    def new
      @status = :created
      modify(@seed.model.new)
    end
    private :new

    def modify(record)
      @keys.to_s.split(/_and_/).each_with_index do |key, index|
        record.send("#{key}=", @values[index])
      end
      record.attributes = @attributes
      record
    end
    private :modify

    def human_key
      "#{@keys.to_s.split(/_and_/).to_sentence} of #{@values.to_sentence}"
    end
  end
end
