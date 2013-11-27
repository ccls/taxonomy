class Sunspot::BlastResultsController < SunspotController

	def index
		search_sunspot_for BlastResult
	end

end
__END__
