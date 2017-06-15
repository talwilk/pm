class ProjectsController < ApplicationController
	before_action :get_project , only: [:show, :update, :edit]

	def get_project
		puts "*** In Projects#get"
		@project = Project.find(params[:id])
		@type = @project.type
	end

	def new
		@project = Project.new(type_id: 8)
		get_gen_task_list
	end

	def create
		puts "***    In Projects#create"
		@project = Project.new(session[:projecy_id])
		session[:project]=@project.attributes
		
		@project.update_attributes(project_params)
		
		@project.orig_start_date = @project.cur_start_date
		@email = @project.email
		puts "email: #{@project.email}"

		if current_user.nil?
			puts "  **** user not signin"

			puts "  **** check if this email have user"
			@user = User.where("users.email = :email", {:email => @email}).first
			if !@user.nil?
				puts "User found! user.id : #{@user.id}"	
    			@project.user_id = @user.id
    		end

    	else
    		puts "current_user.id : #{current_user.id}"	
    		@project.user_id = current_user.id
		end

		if @project.update_attributes(project_params)
			save_project_tasks
	    else
	    	render wizard_path(:project_details)
	    	return
	    end

		if @project.user_id.nil?
			redirect_to new_user_registration_path(:email => @email)
		else
			redirect_to user_session_path(:email => @email)
		end
	end

	def index
		@projects = Project.all
		@projects.order(:id)
	end

	def show
		puts "***    In Projects#show"
		get_task_list
	end

	def update
		puts "***    In Projects#update"
		if @project.update_attributes(project_params)
			puts "***    going to render"
		redirect_to root_path

		else
			puts "***    error"
		end	
	end
	
	def edit
	end

	private  

  	def project_params 
    	params.require(:project).permit(:name, :description, :add_street, :add_city, :add_country, :orig_start_date, :plot, :build, :address, :email, :orig_budget, :type_id, :user_id, :qna_id) 
  	end

  	def task_params     	
    	params.require(:task).permit(:code, :name, :phase, :description, :duration, :cost, :est_duration_min, :est_duration_max, :est_cost_min, :est_cost_max, :category, :predecessor, :type, :project_id) 
  	end

  	def user_params
  		params.require(:user).permit(:email, :username)
  	end

  	def get_gen_task_list
  		puts "***  in Get gen Tasks"
  		v_type = @project.type.code
		@tasks = Taskindex.where("taskindices.ptype LIKE :type_code", {:type_code => "%#{v_type}%"})
  	end
  	
 #  	def get_task_list
 #  		puts "***  in Get Tasks"
 #  		v_id = @project.id
	# 	@tasks = Task.where("tasks.project_id = :project_id", {:project_id => "#{v_id}"})
	# 	@tasks.order(:phase, :code)

	# 	@total_duration = @tasks.sum(:duration) 
	# 	@total_end_date = @project.orig_start_date + @total_duration.days
	# 	@total_cost = @tasks.sum(:cost) 
	# 	@total_paid = @tasks.sum(:paid) 
	# 	@task_count = @tasks.count 
	# 	@complete_task_count = @tasks.where(status: 'completed').count 

	# 	@tasks_hash = {}

	# 	@tasks.each do |t|
	# 		case t.status
	# 			when 'not_started'
	# 				t.task_type = "wizard/pending.png"
	# 			when 'in_progress'
	# 				t.task_type = "wizard/in_progress.png"
	# 			when 'completed'
	# 				t.task_type = "wizard/completed.png"
 # 				else
 # 					t.task_type = "Error"
	# 		end
	# 		#puts "task id #{t.id}"
	# 		t.dilemma_count = Dilemma.where(task_id: t.id).count
	# 		puts "task phase #{t.phase}"
			
	# 		@tasks_hash[t.phase] ||= {}
	# 		@tasks_hash[t.phase][t.id] ||= []
 #    		@tasks_hash[t.phase][t.id] << t 
 #  		end
 #  		@tasks_hash = @tasks_hash.sort_by {|a,b| a }
 #  	end

  	def save_project_tasks
	  		v_type = @project.type.code
			@tasksind = Taskindex.where("taskindices.ptype LIKE :type_id", {:type_id => "%#{v_type}%"})
		  	@tasksind.each do |t|
			@task = Task.new(project_id: @project.id)
			session[:task]=@task.attributes
			@task.code = t.code
			@task.name = t.name
			@task.phase = t.phase
			@task.description = t.description
			@task.duration = t.duration
			@task.cost = t.cost
			@task.est_duration_min = t.est_duration_min
			@task.duration = t.est_duration_min
			@task.est_duration_max = t.est_duration_max
			@task.est_cost_min =t.est_cost_min
			@task.cost =t.est_cost_min
			@task.est_cost_max =t.est_cost_max
			@task.category =t.category
			@task.predecessor =t.predecessor
			@task.status = 'not_started'
			puts "*** tips #{t.task_tips}"
			if !t.task_tips.nil?
				@task.task_tips = t.task_tips.gsub! '|', '"'
			end
			@task.recommend = t.recommend
			@task.start_date = @project.orig_start_date
			@task.cur_start_date = @project.orig_start_date
			#@days=@task.est_duration_min.to_s
			#puts "days #{@days}"
			#if !@days="" || !@project.orig_start_date.nil?
				#@task.cur_end_date = @project.orig_start_date + @days.days
				@task.cur_end_date = @project.cur_start_date
			 	#@task.orig_end_date = @project.orig_start_date + @days.days
				@task.orig_end_date = @project.cur_start_date
			#end
			#@task.ptype =t.ptype
			if @task.save
				puts "*** Task saved"
			else 
				puts "***  Task not save"
				render action: "new"
			end
  		end	
	end


 # 	def update_note(notes)
	# 	puts "***  in update project from JS"

	# 	get_project
	# 	@project.notes = notes

	#   	if @project.update_attributes(project_params)
	#     	@updated = "true"
	#     	format.js
	#   	else
	#     	@updated = "false"
	#     	format.js #this will load update_note.js.erb
	#   	end
	# end

end
