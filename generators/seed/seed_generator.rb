class SeedGenerator < Rails::Generator::NamedBase
  default_options :method => :create_or_update

  attr_reader :model

  def initialize(runtime_args, runtime_options = {})
    super

    begin
      @model = class_name.constantize
    rescue
      raise ArgumentError, "Invalid class name #{class_name}."
    end

    attributes.each do |attribute|
      column = @model.columns.detect { |column| column.name == attribute.name }
      raise ArgumentError, "Invalid column name #{attribute.name}." unless column
      attribute.type = case column.type
        when :integer, :float, :decimal, :boolean then attribute.type
        else "\"#{attribute.type}\""
      end
    end
  end

  def manifest
    record do |m|
      m.directory('db/seed')
      m.template 'seed.rb', "db/seed/#{file_path}_seed.rb"
    end
  end

  def banner
    "Usage: #{$0} #{spec.name} ModelName [field:type, field:type]"
  end
  protected :banner

  def add_options!(opt)
    opt.separator ''
    opt.separator 'Options:'
    opt.on('-m', '--method METHOD', 'Seed method (Default: create_or_update)') do |method|
      raise ArgumentError, "Method must be one of create, update, or create_or_update." unless method =~ /\A(create(_or_update)?|update)\Z/
      options[:method] = method
    end
  end
  protected :add_options!
end
