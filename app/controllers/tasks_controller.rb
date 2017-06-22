class TasksController < ApplicationController
before_action :get_task, only: [:show, :update, :edit, :destroy]
before_action :get_project, only: [:create, :new]
	
	def get_task	
		puts "*** In Tasks#get"
		@task = Task.find(params[:id])
		@project = @task.project
		get_pro
	end

	def get_project	
		puts "*** In Tasks#getproject"
		@project = Project.find(params[:project_id])
		@pro = Pro.new(project_id: :project_id)
	end

	def get_pro	
		puts "****   get_pro #{@task.pro_id}"
		if !@task.pro_id.blank?
			@pro = @task.pro(project_id: :project_id)
		else
			puts "** new pro***"
			@pro = Pro.new(project_id: :project_id)
		end
		#@pro_new = Pro.new(project_id: :project_id)
	end

	def create
		puts "***    In Tasks#create"
		#puts "****   Project_id #{params[:project_id]}"
		@task = Task.new(session[:task_id])
		@task.project_id = params[:project_id]
		session[:task]=@task.attributes
		
		@pro = @task.build_pro
		session[:pro]=@pro.attributes
		if @task.update_attributes(task_params)
			puts "***   if task save"
	    else
	    	puts "*** if not save"
	      render action: "new"
	    end
		redirect_to root_path
	end

	def new
		@task = Task.new(project_id: :id)
		@pro = @task.build_pro
		get_ranges
	end
	
	def index
		@tasks = Task.all
	end
		
	def show
		puts "***    In Tasks#show"
		get_ranges
	end
	
	def edit
		puts "***    In Tasks#edit"
		get_ranges
	end

	def update
		puts "***    In Tasks#update"
		#@pro.project_id = @project.id
		if @task.update_attributes(task_params)
			puts "***   task updated"
			redirect_to root_path
		else 
			puts "***  not saved"
			    render :edit 
		end
	end

	def update_cost_paid
		task = Task.find(params[:id])
    if task.update_attributes(cost: params[:cost], paid: params[:paid])
      render status: 200, json: true
    else
      render status: 400, json: true
    end
	end

	def destroy
		@task.destroy
		redirect_to root_path
	end

 	private
 	def task_params
       	params.require(:task).permit(:code, :name, :phase, :description, :duration, :cost, :status, :est_duration_min, :est_duration_max, :est_cost_min, :est_cost_max, :category, :predecessor, :manual_ind, :ptype, :notes, :project_id, :pro_id, pro_attributes:[:id, :first_name, :last_name, :company_name, :email, :mobile_phone, :phone, :project_id]) 
  	end
 	
  	def get_ranges
  		if !@task.est_cost_min.blank? & !@task.est_cost_max.blank?
			@range_cost = "(" + @task.est_cost_min.to_s + " - " + @task.est_cost_max.to_s + ")"
		else
			@range_cost = ""
		end
		if !@task.est_duration_min.blank? & !@task.est_duration_max.blank?  
			@range_duration = "(" + @task.est_duration_min.to_s + " - " + @task.est_duration_max.to_s + ")"
		else
			range_duration = ""
		end
	end
  
end
