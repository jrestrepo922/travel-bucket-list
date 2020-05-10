require './config/environment'

if ActiveRecord::Migrator.needs_migration?
  raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
end


use Rack::MethodOverride
use UsersController
use CountriesController
use CitiesController
use SessionsController
run ApplicationController
