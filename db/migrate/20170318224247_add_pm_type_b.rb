class AddPmTypeB < ActiveRecord::Migration
  def change
  	create_table :projects do |t|
		t.string   :name
		t.string   :description
		t.string   :address
		t.date     :orig_start_date
		t.date     :cur_start_date
		t.string   :plot
		t.string   :build
		t.string   :orig_budget
		t.string   :cur_budget
		t.string   :email
		t.string   :reserve
		t.belongs_to :type
		t.belongs_to :user
		t.belongs_to :qna
  		t.timestamps
	end

	create_table :pros do |t|
		t.string   :first_name
		t.string   :last_name
		t.string   :company_name
		t.string   :email
		t.string   :mobile_phone
		t.string   :phone
		t.string   :category
		t.belongs_to :project
		t.belongs_to :user
  		t.timestamps
	end

	create_table :tasks do |t|
		t.string   :code
		t.string   :name
		t.string   :phase
		t.string   :description
		t.string   :notes
		t.string   :recommend
		t.string   :status
		t.string   :category
		t.string   :predecessor
		t.string   :ptype
		t.string   :manual_ind
		t.string   :task_type
		t.string   :task_landing_page
		t.string   :task_tips
		t.integer  :est_duration_min
		t.integer  :est_duration_max
		t.integer  :est_cost_min
		t.integer  :est_cost_max
		t.integer  :duration
		t.integer  :cost
		t.integer  :paid
		t.integer  :dilemma_count
		t.string   :dilemma_list
		t.string   :image_url
		t.date     :start_date
		t.date     :cur_start_date
		t.date     :orig_end_date
		t.date     :cur_end_date
		t.belongs_to :project
		t.belongs_to :pro
  		t.timestamps
	end
	
	add_reference :dilemmas, :task, index: true

  end
end
