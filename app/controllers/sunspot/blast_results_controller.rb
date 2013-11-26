class Sunspot::BlastResultsController < SunspotController

	def index
		search_sunspot_for BlastResults
	end

end
__END__
