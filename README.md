# chitickets

The data dir was created with this guy below. To extract it all, just do a "zcat * > tickets.csv":

split -l1000000 --filter='gzip > $FILE.gz' <(zcat A50462_TcktsIssdSince2009.txt.gz)

Plotting Chicago parking tickets to find invalid tickets. 

Data comes from FOIA:
Please provide to me all possible information on all parking tickets between 2009 and the present day. This should include any information related to the car (make, etc), license plate, ticket, ticketer, ticket reason(s), financial information (paid, etc), court information (contested, etc), situational (eg, time, location), and photos/videos.  Ideally, this should also include any relevant ticket-related information stored within CANVAS.

My past requests for license plate information have been denied, but for a number of reasons, I believe that they should be included, including the Tribune receiving it in one of their FOIAs 0.

I believe that video/photo information should also be releasable through FOIA, as it's already been made public at 1, provided 0.

0 http://apps.chicagotribune.com/news/local/red-light-camera-tickets/
1 http://www.chicagophotociteweb.com/ 

This information will be used for data analysis for research.

Thanks in advance,
Matt Chapman
