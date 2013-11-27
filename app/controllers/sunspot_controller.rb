class SunspotController < ApplicationController

#	before_filter :may_read_required

protected	#	from what and why?

	def search_sunspot_for( search_class )
		@sunspot_search_class = search_class

		#	Formerly a before_filter, but after being genericized,
		#	we don't know the search class until the search begins.
		@sunspot_search_class.methods.include?(:search) ||
			access_denied("Sunspot server probably wasn't started first!", root_path)

		#	This includes a redirect so can't render in action.
		#	Including better condition.  Nevermind.
#		unless @sunspot_search_class.methods.include?(:search)
#			access_denied("Sunspot server probably wasn't started first!", root_path)
#		else
		begin
			@search = @sunspot_search_class.search do

				if params[:q].present?
					fulltext params[:q]
				end

#				self.instance_variable_get('@setup').clazz.sunspot_all_facet_names.each do |p|
				self.instance_variable_get('@setup').clazz.sunspot_all_facets.each do |f|	#	don't use |facet|
					p=f.name

					if f.range

#	undefined method `range_facet_and_filter_for' for #<Sunspot::DSL::Search:0x007fdd3b375850>
#	this adds a duplicate facet to the list of facets that end up being shown
#	need to filter it out somehow.  Got it.
						range_facet_and_filter_for(p,params.dup,f.range)


	#				if child_age_facets.include?(p)
	#					range_facet_and_filter_for(p,params.dup,:start => 1, :step => 2)
	#				elsif parent_age_facets.include?(p)
	#					range_facet_and_filter_for(p,params.dup)
	#				elsif year_facets.include?(p)
	#					range_facet_and_filter_for(p,params.dup,{:start => 1980, :stop => 2010, :step => 5})
					else
						if params[p]
							#
							#	20130423 - be advised that false.blank? is true so the boolean attributes
							#						will not work correctly here.  Need to find another way.
							#			I don't use boolean columns anymore
							#
							params[p] = [params[p].dup].flatten.reject{|x|x.blank?}


							if params[p+'_op'] && params[p+'_op']=='AND'
								unless params[p].blank?	#	empty?	#	blank? works for arrays too
									with(p).all_of params[p]
								else
									params.delete(p)	#	remove the key so doesn't show in view
								end
							else
								unless params[p].blank?	#empty?	# blank? works for arrays too
									with(p).any_of params[p]
								else
									params.delete(p)	#	remove the key so doesn't show in view
								end
							end	#	if params[p+'_op'] && params[p+'_op']=='AND'


						end	#	if params[p]

						#	put this inside the else condition as the if block is
						#	for ranges and it calls facet
						facet p.to_sym, :sort => :index

					end	#	if child_age_facets.include?(p)
					#	facet.sort
					#	This param determines the ordering of the facet field constraints.
					#	    count - sort the constraints by count (highest count first)
					#	    index - to return the constraints sorted in their index order 
					#			(lexicographic by indexed term). For terms in the ascii range, 
					#				this will be alphabetically sorted. 
					#	The default is count if facet.limit is greater than 0, index otherwise.
					#	Prior to Solr1.4, one needed to use true instead of count and false instead of index.
					#	This parameter can be specified on a per field basis. 
#					facet p.to_sym, :sort => :index
				end	#	@sunspot_search_class.sunspot_all_facets.each do |p|
	
				order_by *search_order
	
				if request.format.to_s.match(/csv|json/)
					#	don't paginate csv file.  Only way seems to be to make BIG query
					#	rather than the arbitrarily big number, I could possibly
					#	use the @search.total from the previous search sent as param?
					paginate :page => 1, :per_page => 1000000
				else
					paginate :page => params[:page], :per_page => params[:per_page]||50
				end
			end	#	@search = @sunspot_search_class.search do

		rescue Errno::ECONNREFUSED
			flash[:error] = "Solr seems to be down for the moment."
			redirect_to root_path
		end	#	begin
#		end	#	unless @sunspot_search_class.methods.include?(:search)
	end

	def search_order
		if params[:order] and @sunspot_search_class.sunspot_orderable_column_names.include?(
				params[:order].downcase )
			order_string = params[:order]
			dir = case params[:dir].try(:downcase)
				when 'desc' then 'desc'
				else 'asc'
			end
			return order_string.to_sym, dir.to_sym
		else
			return :id, :asc
		end
	end

	Sunspot::DSL::Search.class_eval do
		def range_facet_and_filter_for(field,params={},options={})
			start = (options[:start] || 20)	#.to_i
			stop  = (options[:stop]  || 50)	#.to_i
			step  = (options[:step]  || 10)	#.to_i
			if params[field]
				any_of do
					params[field].each do |pp|
						if pp =~ /^Under (\d+)$/
							with( field.to_sym ).less_than $1     #	actually less than or equal to
						elsif pp =~ /^Over (\d+)$/
							with( field.to_sym ).greater_than $1  #	actually greater than or equal to
						elsif pp =~ /^\d+\.\.\d+$/
							with( field.to_sym, eval(pp) )
						elsif pp =~ /^\d+$/
							with( field.to_sym, pp )	#	primarily for testing?  No range, just value
						end
					end
				end
			end
			facet field.to_sym do
				#	row "text label for facet in view", block for facet.query
				row "Under #{start}" do
					#	Is less_than just less_than or does it also include equal_to?
					#	Results appear to include equal_to which makes it actually incorrect and misleading.
					with( field.to_sym ).less_than start		#	facet query to pre-show count if selected (NOT A FILTER)
				end
				(start..(stop-step)).step(step).each do |range|
					row "#{range}..#{range+step}" do
						with( field.to_sym, Range.new(range,range+step) )
					end
				end
				row "Over #{stop}" do
					#	Is greater_than just greater_than or does it also include equal_to?
					#	Results appear to include equal_to which makes it actually incorrect and misleading.
					with( field.to_sym ).greater_than stop
				end
			end
		end
	end	#	Sunspot::DSL::Search.class_eval do

end






#Sunspot::DSL::Search.class_eval do
#	#
#	#	Add options to control
#	#		under = nil   (-infinity)   boolean to flag under start???
#	#		over  = nil   (infinity)    boolean to flag over stop???
#	#		start = 20
#	#		step  = 10
#	#		end   = 50
#	#
##
##	TODO change "Under 20" to "20 and under"
##	TODO change "Over 50"  to "50 and over"
