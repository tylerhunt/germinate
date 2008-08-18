namespace :db do
  desc "Load all seeds"
  task :seed => :environment do
    require File.join(%W(#{File.dirname(__FILE__)} .. lib germinate))
    include Germinate::Helper

    puts "Seeding #{RAILS_ENV} environment..."

    FileList[File.join(%W(#{RAILS_ROOT} db seed ** *_seed.rb))].each do |file|
      load file
    end

    seed_all
  end
end
