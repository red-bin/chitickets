# Repo setup:

```
1. Set your mysql server settings in environment.rb
2. ruby setup.rb  --  creates 'tickets' and 'addresses' table, takes about 4 hours
3. ruby geocode.rb  --  reads 'addresses' into memory, uses it to geocode the tickets' addresses. Takes about 12 hours.
```

If you just want the data, a MySQL dump is available here:

https://s3.amazonaws.com/bak.homepc/chitickets_2016-03-21.sql.gz
