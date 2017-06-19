class WizardController < ApplicationController
	include Wicked::Wizard
	
  	steps :question_1, :question_2, :question_3, :question_4, :project_details
	 
  	def show
  		puts "**  show **"
		case step
		when :question_1
			puts "** show Q1**"
			if !params[:qna_id].nil?
				find_qna
			end
			set_str(1)
		when :question_2
			puts "** show Q2**"
			find_qna
			set_str(2)
		when :question_3
			puts "**  show Q3**"
			find_qna
			set_str(3)
		when :question_4
			puts "**  show Q4**"
			find_qna
			set_str(4)
		else :project_details
			puts "**  show pd**"
			#@qna = Qna.new(session[:qna_id])
			if !params[:qna_id].nil?
				puts "not empty"
				@qna = Qna.find(params[:qna_id])
			end
			@project = Project.new(session[:project_id])
			if !@qna.nil?
				@project.qna_id = @qna.id
				session[:project]=@project.attributes
				def_proj_type
			else
				@project_type = "Error"
			end
			if !is_user_signed
				@provide_signin_info = true
			end
		end
    	render_wizard
    end
	
	def update
		puts "****   in update "
		case step
			when :question_2
				puts "**   update Q2**"
				if params[:qna_id].nil?
					puts "new qna"
					@qna = Qna.new(session[:qna_id])
					session[:qna]=@qna.attributes
					@qna.q1 = params[:q]
					@qna.save!
					@qna_id=@qna.id
					set_str(2)
				elsif
					#puts "exist qna"
					find_qna
					#puts "after find_qna"
					@qna.q1 = params[:q]
					@qna.save!
					#@qna_id=@qna.id
					set_str(2)
				end
			when  :question_3
				puts "**   update Q3**"
				find_qna
				@qna.q2 = params[:q]
				@qna.save!
				set_str(3)
			when  :question_4
				puts "**   update Q4**"
				find_qna
				@qna.q3 = params[:q]
				@qna.save!
				puts "**   q1 #{@qna.q1}**"
				if skip_step_4
					#jump_to(:project_details)
					skip_step(:qna_id => @qna.id)
				end
				set_str(4)
			else
				puts "**   update ELSE**"
				find_qna
				@qna.q4 = params[:q]
				@qna.save!
				puts "*** qna id #{@qna.id}"
				@project = Project.new(session[:project_id])
				@project.qna_id = @qna.id
				session[:project]=@project.attributes
				def_proj_type
				if !is_user_signed
					@provide_signin_info = true
				end
			end
    	render_wizard
	end

	private

	def is_user_signed
		if current_user.nil?
			puts "  **** no user"
			return false
    	else
    		puts "current_user.id : #{current_user.id}"	
    		@project.user_id = current_user.id
    		return true
		end
	end

	def find_qna
		#puts "in find qna"
		@qna = Qna.find(params[:qna_id])
		session[:qna]=@qna.attributes
		@qna_id=@qna.id
		#puts "***  in find_qna #{@qna.id}"
	end

	def save_qna
		if @qna.update_attributes(qna_params)
			puts "***  in save_qna #{@qna.id}"
		else
			puts "*** QNA not saved"
			render_wizard(@qna)  
		end
	end
  	
  	def qna_params 
     	params.require(:qna).permit(:q1, :q2, :q3, :q4, :cust) 
  	end

  	def project_params 
    	params.require(:project).permit(:name, :description, :add_street, :add_city, :add_country, :start_date, :plot, :build, :type_id) 
  	end

	def def_proj_type
		puts "*** in def project type"

		if @qna.q1 == "1" and @qna.q2 == "1" and @qna.q3 == "1"
			@project_type = "ApBuyChoose"
		elsif @qna.q1 == "1" and @qna.q2 == "1" and @qna.q3 == "2" and @qna.q4 == "1"
			@project_type = "ApBuyExe"
		elsif @qna.q1 == "1" and @qna.q2 == "1" and @qna.q3 == "2" and @qna.q4 == "2"
			@project_type = "ApBuyPlanExe"
		elsif @qna.q1 == "1" and @qna.q2 == "2" and @qna.q3 == "1"
			@project_type = "ApRemExe"
		elsif @qna.q1 == "1" and @qna.q2 == "2" and @qna.q3 == "2"
			@project_type = "ApRemPlanExe"
		
		elsif @qna.q1 == "2" and @qna.q2 == "1" and @qna.q3 == "1"
			@project_type = "HouBuyChoose"
		elsif @qna.q1 == "2" and @qna.q2 == "1" and @qna.q3 == "2" and @qna.q4 == "1"
			@project_type = "HouBuyExe"
		elsif @qna.q1 == "2" and @qna.q2 == "1" and @qna.q3 == "2" and @qna.q4 == "2"
			@project_type = "HouBuyPlanExe"
		elsif @qna.q1 == "2" and @qna.q2 == "2" and @qna.q3 == "1" and @qna.q4 == "1"
			@project_type = "HouIntRemExe"
		elsif @qna.q1 == "2" and @qna.q2 == "2" and @qna.q3 == "1" and @qna.q4 == "2"
			@project_type = "HouIntRemPlanExe"
		elsif @qna.q1 == "2" and @qna.q2 == "2" and @qna.q3 == "2" and @qna.q4 == "1"
			@project_type = "HouExtRemExe"
		elsif @qna.q1 == "2" and @qna.q2 == "2" and @qna.q3 == "2" and @qna.q4 == "2"
			@project_type = "HouExtRemPlanExe"
		elsif @qna.q1 == "2" and @qna.q2 == "3" and @qna.q3 == "1"
			@project_type = "HouBldChoose"
		elsif @qna.q1 == "2" and @qna.q2 == "3" and @qna.q3 == "2" and @qna.q4 == "1"
			@project_type = "HouBldExe"
		elsif @qna.q1 == "2" and @qna.q2 == "3" and @qna.q3 == "2" and @qna.q4 == "2"
			@project_type = "HouBldPlanExe"
		else
			@project_type = "Error"
		end

 		@type = Type.where("types.code like :code", {:code => "%#{@project_type}%"}).first
		@project.type_id=@type.id
		puts "*** project type #{@type.code}"
	end

  	def set_str(step)
		case step
			when 1
				puts "****   in set_str 1"
				@Q1 = "#{t('wizard.q1')}"
			  #***** if Appartment
				@A1 = "#{t('wizard.a1')}"
			  #***** if House 
				@A2 = "#{t('wizard.a2')}"
			
			when 2
			puts "****   in set_str 2"
				if @qna.q1 == "1" 
				#Appartment 
					@Q2 = "#{t('wizard.q21')}"
					@A11 = "#{t('wizard.a21')}"	
					@A12 = "#{t('wizard.a22')}"
					@A13 = "#{t('wizard.a23')}"
					@image_url = 'wizard/pm_apartment_blue.png' 
				elsif @qna.q1 == "2"
				#House
					@Q2 = "#{t('wizard.q22')}"
					@A11 = "#{t('wizard.a24')}"	
					@A12 = "#{t('wizard.a25')}"	
					@A13 = "#{t('wizard.a26')}"
					@image_url = 'wizard/pm_house_blue.png' 
				else
					@Q2 = "#{t('qna.Q99')}"
				end
			
			when 3
				puts "****   in set_str 3"
				if  (((@qna.q1 == "1") & (@qna.q2 == "1")) || ((@qna.q1 == "2") & (@qna.q2 == "1")) || ((@qna.q1 == "2") & (@qna.q2 == "3")))
				# buy appartment, build or buy house
					@Q3 = "#{t('wizard.q31')}"
					@A31 = "#{t('wizard.a31')}"	
					@A32 = "#{t('wizard.a32')}"	
					if 	(@qna.q1 == "1")
						@image_url = 'wizard/pm_apartment_blue.png' 	
					else
						@image_url = 'wizard/pm_house_blue.png' 
					end	
				elsif ((@qna.q1 == "1") & (@qna.q2 == "2"))
				#Renovate Appartment
					@Q3 = "#{t('wizard.q32')}"
					@A31 = "#{t('wizard.a33')}"		
					@A32 = "#{t('wizard.a34')}"	
					@image_url = 'wizard/pm_apartment_blue.png' 	
				elsif ((@qna.q1 == "2") & (@qna.q2 == "2"))
				#Renovate House 
					@Q3 = "#{t('wizard.q33')}"
					@A31 = "#{t('wizard.a35')}"		
					@A32 = "#{t('wizard.a36')}"	
					@image_url = 'wizard/pm_house_blue.png' 
				else
					@Q3 = "#{t('wizard.q99')}"
				end
			when 4
				@Q4 = "#{t('wizard.q44')}"
				@A41 = "#{t('wizard.a41')}"		
				@A42 = "#{t('wizard.a42')}"	
				if 	(@qna.q1 == "1")
					@image_url = 'wizard/pm_apartment_blue.png' 	
				else
					@image_url = 'wizard/pm_house_blue.png' 
				end				
			else
				puts "****  Error "
		end
	end

	def skip_step_4
		if @qna.q1 == "1" and @qna.q2 == "1" and @qna.q3 == "1"
			true 
		elsif @qna.q1 == "1" and @qna.q2 == "2" 
			true
		elsif @qna.q1 == "2" and @qna.q2 == "1" and @qna.q3 == "1"
			true
		elsif @qna.q1 == "2" and @qna.q2 == "3" and @qna.q3 == "1"
			true
		else
			false
		end
	end
	
end
