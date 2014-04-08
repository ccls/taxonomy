require 'active_record/connection_adapters/abstract_mysql_adapter'

class ActiveRecord::ConnectionAdapters::AbstractMysqlAdapter::Column
	def extract_limit(sql_type)
		case sql_type
		when /^enum\((.+)\)/i
			$1.split(',').map{|enum| enum.strip.length - 2}.max
		when /blob|text/i
			case sql_type
			when /tiny/i
				255 
			when /medium/i
				16777215
			when /long/i
				2147483647 # mysql only allows 2^31-1, not 2^32-1, somewhat inconsistently with the tiny/medium/normal cases
			else
				super # we could return 65535 here, but we leave it undecorated by default
			end 
		when /^bigint/i;		8	 
		when /^int/i;			 4	 
		when /^mediumint/i; 3
		when /^smallint/i;	2
		when /^tinyint/i;	 1	 
		when /^double/i;	 53
		else
			super
		end 
	end
end
