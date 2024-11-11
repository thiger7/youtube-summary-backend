namespace :db do
  desc 'Load all schema files'
  task load_all_schemas: :environment do
    load(Rails.root.join('db/cache_schema.rb'))
    load(Rails.root.join('db/cable_schema.rb'))
    load(Rails.root.join('db/queue_schema.rb'))
  end
end
