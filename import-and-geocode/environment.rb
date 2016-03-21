
require 'active_record'
require 'csv'
require 'pry'

Dir.glob('./models/*.rb').each do |file|
  puts file
  require file
end

$db_config = {
  :adapter => 'mysql2',
  :encoding => 'utf8',
  :timeout => 5000,
  :database => 'chitickets',
  :username => 'root',
  :password => 'PASSWORD',
  :reconnect => true,
  :socket => '/tmp/mysql.sock'
}

ActiveRecord::Base.establish_connection($db_config)

def exec_sql(sql)
  ActiveRecord::Base.connection.execute(sql)
end

@start = Time.now

def log_time(str)
  from_time = Time.now

  secs = Time.now - @start
  runtime = Time.at(secs).utc.strftime("%H:%M:%S")

  puts "Runtime: #{runtime} -> #{str}\n"
end

def propercase(str)
  return str.gsub(/\w+/) do |word|
    word.capitalize
  end
end