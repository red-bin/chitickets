
require_relative('../../environment')

class CreateTables < ActiveRecord::Migration
  def up
    puts "UP"

    if !ActiveRecord::Base.connection.table_exists? 'tickets'
      # Example:
      # 9189923892;A655681;IL;PAS;PONT;02/17/2016 09:44 am;3542 W 24TH ST;0976160F;EXPIRED PLATES OR TEMPORARY REGISTRATION;687;0498;Paid;

      create_table :tickets do |t|
        t.integer :address_id
        t.integer :ticket_num, :limit => 8
        t.string :plate_num, :limit => 8
        t.string :plate_state, :limit => 2
        t.string :plate_type, :limit => 16
        t.string :ticket_make, :limit => 32
        t.datetime :issue_date
        t.string :vio_location, :limit => 255
        t.string :vio_code, :limit => 128
        t.string :vio_desc, :limit => 255
        t.integer :badge
        t.string :unit, :limit => 64
        t.string :ticket_queue, :limit => 16
        t.string :hearing_dispo, :limit => 255
        t.decimal :lon, {:precision=>10, :scale=>8}
        t.decimal :lat, {:precision=>10, :scale=>8}
      end
    end

    if !ActiveRecord::Base.connection.table_exists? 'addresses'
      # Example:
      # LON,LAT,NUMBER,STREET,UNIT,CITY,DISTRICT,REGION,POSTCODE,ID
      # -87.6733509,41.9357882,1763,West Wellington Avenue,,Chicago,,,60657,

      create_table :addresses do |t|
        t.decimal :lon, {:precision=>10, :scale=>8}
        t.decimal :lat, {:precision=>10, :scale=>8}
        t.integer :number
        t.string :street, :limit => 255
        t.string :unit, :limit => 16
        t.string :city, :limit => 64
        t.string :district, :limit => 255
        t.string :region, :limit => 255
        t.string :postcode, :limit => 5
      end
    end
  end

  def down
    puts "DOWN"

    drop_table :tickets
    drop_table :addresses
  end

end