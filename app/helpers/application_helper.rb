module ApplicationHelper
	def cost(x)
		if (!x.cost.nil? || x.cost == "0") || (!x.paid.nil? || x.paid == "0" )
			if (!x.cost.nil?)
				x.cost
			else
				"0"
			end
		end
	end
	def paid(x)
		if (!x.cost.nil? || x.cost == "0") || (!x.paid.nil? || x.paid == "0" )
			if (!x.paid.nil?)
				x.paid
			else
				"0"
			end
		end
	end

	def wizard_class_name
		if "#{t :dir}" == "ltr"
			return "rtl"
		else
			return "ltr"
		end
	end

	def mobile?
		user_agent = request.env['HTTP_USER_AGENT'].downcase
		if user_agent.index('ipad').present?
			return false
		elsif request.user_agent =~ /Mobile|webOS/
			return true
		else
			false
		end
	end
end
