desc "Get adventures"
namespace :xyz do 

def select_unique_links(page)
    page.uniq{ |x| x.uri }
  end

  def sold_out?(element)
    if element
      true
    else
      false
    end
  end

  def save_adventure(params)
    db_adventure = Adventure.find_or_initialize_by_title(params[:title])
    db_adventure.title = params[:title]
    db_adventure.sold_out = params[:sold_out]
    db_adventure.city = params[:city]
    db_adventure.state = params[:state]
    db_adventure.zipcode = params[:zipcode]
    db_adventure.description = params[:description]
    db_adventure.latitude = params[:latitude]
    db_adventure.longitude = params[:longitude]
    db_adventure.details = params[:details]
    db_adventure.expiration = params[:expiration]
    db_adventure.price = params[:price]
    db_adventure.save
  end

  task :get_adventures => :environment do
    require 'nokogiri'
    require 'open-uri'
    require 'mechanize'

    agent = Mechanize.new
    adventures_index = agent.get('http://livingsocial.com/adventures')
    adventures_index = select_unique_links adventures_index.links_with(:href => %r{/adventures/})
    adventures_index = adventures_index.select { |a| a.text != 'see our team'}
    puts adventures_index.inspect
    adventures = []
    adventures_index.each do |adventure|
      adventure_page = adventure.click
      title = adventure_page.root.css('.deal-title h1').text.split(" - ").first.strip
      city = adventure_page.root.css('.deal-title p').text.split(%r{\W{2,}})[-2]
      state = adventure_page.root.css('.deal-title p').text.split(",")[-1].strip
      price = adventure_page.root.css('.deal-price').text.split(%r{\D})[-1]
      description = adventure_page.root.css('.description p').text
      lat_long = adventure_page.root.css('.directions a').map { |link| link['href'] }.join("").split("=")[-1]
      latitude = lat_long.split(",")[0].strip
      longitude = lat_long.split(",")[1].strip
      details = adventure_page.root.css('.highlights ul li').text.gsub("\n","--")
      sold_out = sold_out?(adventure_page.root.at_css('div.sold-out'))
      expiration = adventure_page.root.css('.fine-print p').text.split(%r{\b[A-Z]+\b}).last.strip
      zipcode = adventure_page.root.xpath("//br/following-sibling::text()").text.split(" ").last
      params = {title: title,
                sold_out: sold_out,
                city: city,
                state: state,
                zipcode: zipcode,
                description: description,
                latitude: latitude,
                longitude: longitude,
                details: details,
                expiration: expiration,
                price: price}
      puts params.inspect
      adventures << params
    end
    adventures.each do |params|
      db_adventure = Adventure.find_or_initialize_by_title(params[:title])
      db_adventure.title = params[:title]
      db_adventure.sold_out = params[:sold_out]
      db_adventure.city = params[:city]
      db_adventure.state = params[:state]
      db_adventure.zipcode = params[:zipcode]
      db_adventure.description = params[:description]
      db_adventure.latitude = params[:latitude]
      db_adventure.longitude = params[:longitude]
      db_adventure.details = params[:details]
      db_adventure.expiration = params[:expiration]
      db_adventure.price = params[:price]
      db_adventure.save
    end
  end
end