require 'csv'
namespace :app do

	task :import => ['app:names:import','app:nodes:import','app:identifiers:import'] do
	end	#	task :import => :environment do 

end	#	namespace :app
