require 'nokogiri'
require 'open-uri'
require 'json'
require 'google_drive'
require 'csv'

class Scrappeur 
	attr_accessor :email

def save_as_csv  # methode pour la sauvegarde par csv
  hash_info = []
  hash_info = fusion
    CSV.open("db/emails.csv", "w") do |csv|
      hash_info.length.times do |i|    # rendre l'affichage plus agréable
      	hash_info[i].each do |key,value|
        	csv << [key,value]  # aiditra deux par deux dans un seul ligne les iz roa
      	end
    	end
  	end
end


def save_as_spreadsheet
	hash_info = fusion
	session =  GoogleDrive::Session.from_config ("config.json")
	ws = session.spreadsheet_by_key("1Beecd5gZaX8fuz-8b1_6WYu-nC0xIbA2WCmLP_9WrC8").worksheets[0]	
	ligne = 1
	hash_info.length.times do |i|
  	hash_info[i].each do |key,value|
    	ws[ligne , 1] = key
    	ws[ligne , 2] = value
  	end
    	ligne += 1
	end
		ws.save
end


def save_as_JSON
	email = {}
	email = fusion
	File.open("db/emails.json","w") do |f|
	  f.write(JSON.pretty_generate(email))
	end
end


def get_townhall_email(townhall_url)

	page = Nokogiri::HTML(open(townhall_url))
	email = page.xpath('//body/div/main/section[2]/div/table/tbody/tr[4]/td[2]')
		return email.text
end
def get_townhall_urls
	town_list = []
	tab_lien = []
	page = Nokogiri::HTML(open("https://www.annuaire-des-mairies.com/val-d-oise.html"))
	page.xpath('//a[@class = "lientxt"]').each do |town|
		a = town['href']
		longeur = a.length
		tab_lien << "https://www.annuaire-des-mairies.com"+a[1...longeur]
		town_list << town.text
	end
	return tab_lien, town_list #lien akana mail de liste na village
end

def fusion
	email_list = []
	email_link , name_town = get_townhall_urls
	hash_info = []
	email_link.length.times do |i|
		email_list << get_townhall_email(email_link[i])
		hash_info << {name_town[i] => email_list[i]}
	end
	return hash_info
end
end
