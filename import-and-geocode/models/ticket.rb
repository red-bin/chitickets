class Ticket < ActiveRecord::Base

##<Ticket id: nil, ticket_num: 9189923892, plate_num: "A655681", plate_state: "IL", plate_type: nil, ticket_make: "PAS", issue_date: nil, vio_location: "02/17/2016 09:44 am", vio_code: "3542 W 24TH ST", vio_desc: "0976160F", badge: 687, unit: "0498", ticket_queue: "Paid", hearing_

  def convert_nsew(str)
    case str
    when 'N'
      nsew = 'North'
    when 'S'
      nsew = 'South'
    when 'E'
      nsew = 'East'
    when 'W'
      nsew = 'West'
    else
      raise "Invalid nsew: #{nsew}"
    end
  end

  # 1763 West Wellington Avenue
  def get_hash_key
    addr = self.vio_location.strip  # Strip whitespace
    addr = addr.gsub(/\.$/, "") # Strip trailing .

    street_types = "ST|STREET|STR|BLVD|BOULEVARD|AV|AVE|AVENUE|DR|DRIVE|DRIV|RD|ROAD|GROVE|PL|PLACE|TERR|TERRACE|COURT|PKWY|PARKWAY"
    matches = addr.match(/^(\d+)\s+(N|S|E|W)\s+(.+)\s+(#{street_types})$/)
    if !matches.nil? && matches.captures.length == 4  # Has all 4 components: "3542 W 24TH S" 1:"3542" 2:"W" 3:"24TH" 4:"S"
      num = matches[1]
      nsew = matches[2]
      street = matches[3]
      type = matches[4]
    else
      matches = addr.match(/^(\d+)\s+(N|S|E|W)\s+(.+)$/)
      if !matches.nil?
        num = matches[1]
        nsew = matches[2]
        street = matches[3]
        type = ""
      else
        puts "Bad address format: #{addr}"
        return ""
      end
    end

    nsew = convert_nsew(nsew)

    if matches = street.match(/^(\d+)TH$/)  # 24th
      street = matches[1] + 'th'
    end

    if matches = street.match(/^(\d+)RD$/)  # 23rd
      street = matches[1] + 'rd'
    end

    if matches = street.match(/^(\d+)ST$/)  # 21st
      street = matches[1] + 'st'
    end

    # Fixes for misspelled street names
    street = street.gsub(/\s+ST\s+/, 'Saint') # South St Lawrence -> South Saint Lawrence
    street = street.gsub(/\sMC VICKER/, 'MCVICKER') # 1301 N MC VICKER -> 1301 N MCVICKER
    street = street.gsub(/\sHASTED\s/, 'HALSTED') # HASTED -> HALSTED
    street = street.gsub(/\sSOUTH VINCENENS\s/, 'South Vincennes') # HASTED -> HALSTED
    street = street.gsub(/\sNORTH NEW CASTLE/, 'North Newcastle') # HASTED -> HALSTED

    street = propercase(street)

    if type.blank?
      type = self.get_street_type(nsew, street)
    else
      case type.upcase
      when 'ST', 'STREET', 'STR'
        type = "Street"
      when 'BLVD', 'BOULEVARD'
        type = "Boulevard"
      when 'AV', 'AVE', 'AVENUE'
        type = "Avenue"
      when 'DR', 'DRIVE', 'DRIV'
        type = "Drive"
      when 'RD', "ROAD"
        type = "Road"
      when 'GROVE'
        type = "Grove"
      when 'PL', 'PLACE'
        type = 'Place'
      when 'TERR', 'TERRACE'
        type = 'Terrace'
      when 'COURT'
        type = 'Court'
      when 'PARKWAY', 'PKWY'
      else
        raise "Invalid street type: [#{type}]"
      end
    end

    addr = "#{nsew} #{street} #{type}"
    return "#{num}__#{addr}"
  end

  # We don't know if it's Avenue, Road or what-have-you. Search unique list of all streets for this street.
  # If there's only one match, use its type.
  # If 0 or >1, we can't definitively say what the type is supposed to be, as in the case of 31st Street and 31st Avenue
  def get_street_type(nsew, street)
    key = "#{nsew} #{street}"
    matching_types = []
    $addresses_streets.keys.each do |st|
      hsh = $addresses_streets[st]
      typ = hsh[:type]
      st = hsh[:street]
      next if st.nil?
      if st == key
        matching_types.push(typ)
      end
    end
    if matching_types.length == 1
      return matching_types[0]
    else
      puts "Couldn't find street type: #{key}. Variations: #{matching_types.inspect}"
      return ""
    end
  end

end