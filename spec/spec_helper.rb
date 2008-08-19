ENV["RAILS_ENV"] ||= "test"

require File.join(%W(#{File.dirname(__FILE__)} .. .. .. .. config environment))
require File.join(%W(#{File.dirname(__FILE__)} .. lib germinate))

Spec::Runner.configure do |config|
  class User
  end

  class UserSeed < Germinate::Seed
  end
end

