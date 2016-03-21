
require_relative('environment')
require './db/migrations/db_setup.rb'

# Step 1: create databases if necessary

# Since 'chitickets' doesn't exist yet, connect to default mysql table
$db_config[:database] = 'information_schema'
ActiveRecord::Base.establish_connection($db_config)

sql = "CREATE DATABASE IF NOT EXISTS chitickets"
begin
  exec_sql(sql)
rescue Exception => ex
  puts ex.inspect
  abort "Error creating database"
end

# 'chitickets' db now exists, connect to it
$db_config[:database] = 'chitickets'
ActiveRecord::Base.establish_connection($db_config)
CreateTables.migrate(:up)

if false
  # Clear existing address records
  exec_sql("DELETE FROM addresses")
  exec_sql("ALTER TABLE addresses AUTO_INCREMENT = 1;")

  hsh_dedupe = {}

  # Step 2.1: Import all addresses
  path = "data/city_of_chicago.csv"
  num_entries = `wc -l #{path}`
  file = File.open(path)
  cnt = 0
  while cur_line = file.gets
    cnt += 1
    next if cnt == 1 # Skip column headers

    begin
      # There are occasional errors in CSV, ignore the whole line but log the error
      values = CSV.parse_line(cur_line)
    rescue => ex
      puts "Error at line: #{cnt}: #{ex.inspect} -- #{values.inspect}"
      next
    end

    puts "Processing record ##{cnt} of #{num_entries}: #{values.inspect}" if cnt % 100 == 0
    key = "#{values[2]}__#{values[3]}"
    next if hsh_dedupe[key]
    hsh_dedupe[key] = true
    Address.create!({
      :lon => values[0],
      :lat => values[1],
      :number => values[2],
      :street => values[3],
      :unit => values[4],
      :city => values[5],
      :district => values[6],
      :region => values[7],
      :postcode => values[8]
    })
  end
end

if true
  # Step 3: create ticket records
  exec_sql("DELETE FROM tickets")
  exec_sql("ALTER TABLE tickets AUTO_INCREMENT = 1;")

  # Creating ticket records
  path = "data/tickets_since_2009.txt"
  file = File.open(path)
  num_entries = `wc -l #{path}`
  cnt = 0
  while cur_line = file.gets
    cnt += 1

    cur_line = cur_line.gsub(/"/, '``')
    cur_line = cur_line.gsub(/'/, '`')
    begin
      # There are occasional errors in CSV, ignore the whole line but log the error
      values = CSV.parse_line(cur_line, { :col_sep => ";" })
    rescue => ex
      puts "Error at line: #{cnt}: #{ex.inspect}\n\n#{cur_line}\n\n"
      next
    end
    # 02/17/2016 09:44 am

    begin
      ticket = Ticket.create({
        :ticket_num => values[0],
        :plate_num => values[1],
        :plate_state => values[2],
        :plate_type => values[3],
        :ticket_make => values[4],
        :issue_date => DateTime.strptime(values[5], '%m/%d/%Y %I:%M %P'),
        :vio_location => values[6],
        :vio_code => values[7],
        :vio_desc => values[8],
        :badge => values[9],
        :unit => values[10],
        :ticket_queue => values[11],
        :hearing_dispo => values[12]
      })
    rescue => ex
      puts "Error at line: #{cnt}: #{ex}"
      next
    end

    puts "Processing record ##{cnt} of #{num_entries}: #{values.inspect}" if cnt % 100 == 0  
  end
end