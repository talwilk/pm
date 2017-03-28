class ProsController < ApplicationController
before_action :get_pro, only: [:show, :update, :edit]
before_action :get_project, only: [:create]

def get_pro	
	puts "*** In Tasks#get"
	@pro = Pro.find(params[:id])
	@task = Task.find(params[:task_id])
	@project = Project.find(params[:project_id])
end

def get_project	
	puts "*** In pro#getproject"
	@project = Project.find(params[:project_id])
	@task = Task.find(params[:task_id])
end

def new
	@pro = Pro.new(project_id: :project_id)
	@task = Task.find(params[:task_id])
	@project = Project.find(params[:project_id])
end

def create
		puts "***    In Pro#create"
		@pro = Pro.new(session[:pro_id])
		@pro.project_id = params[:project_id]
		#puts " **   task_id : #{params[:task_id]}"	
		session[:pro]=@pro.attributes
		@temp = @pro.company_name
		#puts "$$$$ pro id #{@temp}"
		if @pro.company_name.to_i > 0
			@task.pro_id = @pro.company_name.to_i
			@task.save!
		else
			@pro.company_name = nil
			if @pro.update_attributes(pro_params)
				puts "***   if pro save"
				@task =Task.find(params[:task_id])
				@task.pro_id = @pro.id
				session[:task]=@task.attributes
				if @task.update_attribute(:pro_id, @pro.id)
					puts "***   task updated"
				end
				send_pro_invitation_email
		    else
		    	puts "*** if pro  not save"
		      render action: "new"
		    end
	    end
		redirect_to root_path
	end

def show
	p_id = @pro.id
	@tasks = Task.where("tasks.pro_id = :pro_id", {:pro_id => "#{p_id}"})
	@tasks.order(:phase, :code)
	@task_count = @tasks.count 
	@total_cost = @tasks.sum(:cost) 
end
 
def update
	puts "***    In Pro#update"
	if @pro.update_attributes(pro_params)
		puts "***   pro updated"
		redirect_to project_task_pro_path(@project,@task, @pro)
	else 
		puts "***  not saved"
		    render :edit 
	end
end

def edit
	puts "***    In Pro#edit"
end

private
 	def pro_params
       	params.require(:pro).permit(:id, :first_name, :last_name, :company_name, :email, :phone, :mobile_phone, :category, :project_id) 
  	end
 	
 	def task_params
       	params.require(:task).permit(:code, :name, :phase, :description, :duration, :cost, :status, :est_duration_min, :est_duration_max, :est_cost_min, :est_cost_max, :category, :predecessor, :ptype, :project_id, :pro_id) 
  	end

  	#def invitation_params
    #	params.require(:pro_invitation_form).permit(:email)
  	#end

	def send_pro_invitation_email
		puts "!!! In COMMENT - NOT Sending Pro inviation Email..."

		#@form = ProInvitationForm.new(invitation_params)

	    #if UserMailer.pro_invitation_email(@pro).deliver_now
	    #	puts "Pro Email sent"
	    #else
	    #	puts "ERROR in sending Pro email"
	    #end
	end

end
