 IsoCountryCodes.for_select.each do |country_iso|
   Country.create(country_iso: country_iso[1])
 end
 Country.create(country_iso: "RD", enabled_at: Time.zone.now)

 SuperAdmin.create!(email: "master@dilemma.guru", password: "password", full_name: "Super Admin")

t1 = Type.create( code: 'ApBuyChoose', name: 'Looking for new appartment', description: 'Customer looking for a new appartment')
t2 = Type.create( code: 'ApBuyPlanExe', name: 'Buy and remodel appartment - plan and execute', description: 'Customer buying  and remodeling an appartment - planning and executing')
t3 = Type.create( code: 'ApBuyExe', name: 'Buy and remodel appartment - execute only', description: 'Customer bought new apartment and planned remodeling. Need to execute the plans')
t4 = Type.create( code: 'ApRemPlanExe', name: 'Remodel appartment - plan and execute', description: 'Customer remodeling his appartment - planning and executing')
t5 = Type.create( code: 'ApRemExe', name: 'Remodel appartment - execute only', description: 'Customer remodeling an appartment - planned remodeling. Need to execute the plans')
t6 = Type.create( code: 'HouBuyChoose', name: 'Looking for new house', description: 'Customer looking for a new house')
t7 = Type.create( code: 'HouBuyPlanExe', name: 'Buy and remodel house - plan and execute', description: 'Customer buying  and remodeling a house - planning and executing')
t8 = Type.create( code: 'HouBuyExe', name: 'Buy and remodel house - execute only', description: 'Customer bought new house and planned remodeling. Need to execute the plans')
t9 = Type.create( code: 'HouBldChoose', name: 'Looking for new house. Looking for a land', description: 'Customer looking where to build a new house')
t10 = Type.create( code: 'HouBldPlanExe', name: 'Build house - plan and execute', description: 'Customer building a house - need to plan and execute')
t11 = Type.create( code: 'HouBldExe', name: 'Build house - execute only', description: 'Customer building new house and plans are ready. Need to execute the plans')
t12 = Type.create( code: 'HouIntRemPlanExe', name: 'Interior Remodel house - plan and execute', description: 'Customer remodeling a house - planning and executing')
t13 = Type.create( code: 'HouIntRemExe', name: 'Interior Remodel house - execute', description: 'Customer remodeling a house - execution only')
t14 = Type.create( code: 'HouExtRemPlanExe', name: 'Overall Remodel house - plan and execute', description: 'Customer remodeling a house - planning and executing')
t15 = Type.create( code: 'HouExtRemExe', name: 'Overall Remodel house - execute', description: 'Customer remodeling a house - execution only')
t99 = Type.create( code: 'Error', name: 'Error', description: 'Error')

# require 'csv'

# puts "There are now #{Taskindex.count} rows in the Taskindex table"

# csv_text = File.read(Rails.root.join('lib', 'seeds', 'task_db.csv'))
# csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-8')
# csv.each do |row|

#   t = Taskindex.new
#   t.code = row['code']
#   t.phase = row['phase']
#   t.name = row['name']
#   t.category = row['category']
#   t.description = row['description']
#   t.recommend = row['recommendations']
#   t.est_duration_min = row['est_duration_min']
#   t.est_duration_max = row['est_duration_max']
#   t.est_cost_min = row['est_cost_min']
#   t.est_cost_max = row['est_cost_max']
#   t.ptype = row['ptype']
#   t.task_tips = row['task_tips']
#   t.status = "not_started"
#   t.save
#   puts "#{t.code}, #{t.name} saved"
# end

# puts "There are now #{Transaction.count} rows in the transactions table"
