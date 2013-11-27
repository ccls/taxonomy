module ApplicationHelper

	def sort_up_image
		"#{Rails.root}/app/assets/images/sort_up.png"
	end

	def sort_down_image
		"#{Rails.root}/app/assets/images/sort_down.png"
	end

	#	&uarr; and &darr;
	def sort_link(*args)
		options = {
			:image => true
		}.merge(args.extract_options!)
		column = args[0]
		text = args[1]
		#	make local copy so mods to muck up real params which
		#	may still be references elsewhere.
		local_params = params.dup

#
#	May want to NOT flip dir for other columns.  Only the current order.
#	Will wait until someone else makes the suggestion.
#
		order = column.to_s.downcase.gsub(/\s+/,'_')
		dir = ( local_params[:dir] && local_params[:dir] == 'asc' ) ? 'desc' : 'asc'

		local_params[:page] = nil
		link_text = text||column
		classes = ['sortable',order]
		arrow = ''
		if local_params[:order] && local_params[:order] == order
			classes.push('sorted')
			arrow = if dir == 'desc'
				if File.exists?( sort_down_image ) && options[:image]
					image_tag( File.basename(sort_down_image), :class => 'down arrow')
				else
					"<span class='down arrow'>&darr;</span>"
				end
			else
				if File.exists?( sort_up_image ) && options[:image]
					image_tag( File.basename(sort_up_image), :class => 'up arrow')
				else
					"<span class='up arrow'>&uarr;</span>"
				end
			end
		end
		s = "<div class='#{classes.join(' ')}'>"
		s << link_to(link_text.html_safe,local_params.merge(:order => order,:dir => dir))
		s << arrow unless arrow.blank?
		s << "</div>"
		s.html_safe
	end

end
