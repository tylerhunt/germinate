module Germinate
  module Helper
    include ActionView::Helpers::TextHelper

    def seed_all
      Germinate::Seed.seeds.each do |seed|
        print "Seeding #{seed.model.table_name}"

        seed.records.each do |record|
          record.execute
          seed.statuses[record.status] ||= 0
          seed.statuses[record.status] += 1
        end

        print " (#{pluralize(seed.records.length, 'record')}"
        seed.statuses.each_pair do |status, count|
          print ", #{count} #{status}"
        end
        puts ")"
      end
    end
  end
end
