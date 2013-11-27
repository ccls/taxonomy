class Object

	#	from CLIC code for sunspot facets
	def html_friendly
		self.to_s.downcase.gsub(/\W/,'_').gsub(/_+/,'_')
	end

end
