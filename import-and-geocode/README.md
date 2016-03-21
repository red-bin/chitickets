# Import And Geocode

This is a Ruby library to import the parking ticket database and the chicago addresses database.

Once imported, it will standardize the ticket addresses and look up their lat/longs in the address DB.

Final stats:

17,806,818 ticket records
7,953,378 successfully geocoded

If you just want the final data, a MySQL dump is available here:

https://s3.amazonaws.com/bak.homepc/chitickets_2016-03-21.sql.gz

# Setup:

First download these two files to the ./import-and-geocode/data directory:

```
tickets_since_2009.txt
city_of_chicago.csv
```

Next:

```
1. Set your mysql server settings in environment.rb
2. ruby setup.rb  --  creates and populates 'tickets' and 'addresses' table, takes about 4 hours
3. ruby geocode.rb  --  reads 'addresses' into memory, uses it to geocode the tickets' addresses. Takes about 12 hours.
```
