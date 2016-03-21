$addresses_unique = {}
$addresses_streets = {}

require_relative('environment')
require 'time'

log_time("Reading addresses into memory")
# Source: https://catalog.data.gov/dataset/ccgisdata-address-point-chicago
if true
  cnt = 0
  Address.all.each do |addr|
    # Hash of all valid addresses
    $addresses_unique[addr.get_hash_key_unique] = addr

    # Hash of all valid street names. E.g.: { "street": "North Link", "type": "Avenue" }. See: ticket.rb#get_street_type
    unless addr.street.nil?
      arr = addr.street.split(/\s+/)
      typ = arr[arr.length - 1]
      street = addr.street.gsub(/\s+#{typ}$/, "") # Shave off the 'Road' or 'Avenue' or whatevs
      $addresses_streets[addr.street] = { :street => street, :type => typ } unless $addresses_streets[addr.street]
    end
  end
  log_time("Done! Begin geocoding.")
end

Ticket.where("lon IS NULL").find_in_batches.each do |ticket_arr|
  ticket_arr.each do |ticket|
    addr = $addresses_unique[ticket.get_hash_key]
    if addr
      ticket.lon = addr.lon
      ticket.lat = addr.lat
      ticket.save
      puts "Address found: #{ticket.get_hash_key}"
    else
      puts "Couldn't find address: #{ticket.get_hash_key}" unless addr
    end
  end
end