class AddPmType < ActiveRecord::Migration
    def change
		create_table :types do |t|
			t.string   :code
			t.string   :name
			t.string   :description
			t.timestamps
		end

		create_table :qnas do |t|
			t.string   :q1
			t.string   :q2
			t.string   :q3
			t.string   :q4
			t.timestamps
		end

		create_table :taskindices do |t|
			t.string   :code
			t.string   :name
			t.string   :phase
			t.string   :description
			t.string   :recommend
			t.string   :status
			t.integer  :duration
			t.integer  :cost
			t.integer  :est_duration_min
			t.integer  :est_duration_max
			t.integer  :est_cost_min
			t.integer  :est_cost_max
			t.string   :category
			t.string   :predecessor
			t.string   :ptype
			t.string   :task_landing_page
			t.string   :task_tips
			t.string   :manual_ind
			t.string   :task_type
			t.timestamps
	 	end
	end
end
