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
end
