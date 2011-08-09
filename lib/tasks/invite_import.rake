#lib/tasks/invite_import.rake

desc "Imports a CSV file into Invites table"
task :invite_import, [:url] => :environment do |t,args|
  
  require 'open-uri'
  require 'csv'
  
  count = 0
  
  CSV.new(open(args[:url]), :headers => :first_row).each do |line|
    if Invite.create!(:code => line[0], :prefix => line[1])
      count += 1
    end
  end
  
  puts "Done! Imported #{count} invites!"

  # lines = File.new(args[:filename]).readlines
  # header = lines.shift.strip
  # keys = header.split(',')
  # lines.each do |line|
  #   params = {}
  #   values = line.strip.split(',')
  #   keys.each_with_index do |key,i|
  #     params[key] = values[i]
  #   end
  #   Module.const_get(args[:model]).create(params)
  # end
end