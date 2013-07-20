require 'csv'

desc "Import teams from csv file"
task :import => [:environment] do

  file = "lib/stops_unique.csv"

  CSV.foreach(file, :headers => true) do |row|
    Route.create(:stop_id => row[0], :name => row[1])
  end
end