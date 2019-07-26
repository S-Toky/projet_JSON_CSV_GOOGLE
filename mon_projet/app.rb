require 'bundler'
Bundler.require

require_relative 'lib/app/scrappeur'


liste = Scrappeur.new
#liste.save_as_JSON
#liste.save_as_spreadsheet
liste.save_as_csv
