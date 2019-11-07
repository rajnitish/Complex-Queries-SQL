--PREAMBLE--

--1--

select a.type,count(b.PaperId) as cnt from Venue a inner join Paper b on a.VenueId=b.VenueId group by a.type order by cnt desc,type asc;

--2--

select sum(cnt)/count(paperid) as AvgNoofAuthorsPerPaper from (select Paperid,count(authorid) as cnt from PaperByAuthors GROUP BY PaperId) as Tab2;

--3--

select distinct Paper.title from (select Tab1.cnt,Tab1.paperId from (select Tab.PaperId, count(Tab.AuthorId) as cnt from (select Paper.PaperId, AuthorId from Paper inner join PaperByAuthors on Paper.PaperId = PaperByAuthors.PaperId ) as Tab GROUP BY Tab.PaperId )as Tab1 where Tab1.cnt>20 ) Tab2 inner join Paper on Tab2.paperId = Paper.paperId ORDER by Paper.title ASC;

--4--

select name from Author inner join (select DISTINCT(authorId) from Author except select Tab3.authorId from (select AuthorId,Tab2.PaperId from (select Tab1.cnt,Tab1.paperId from (select Tab.PaperId, count(Tab.AuthorId) as cnt from (select Paper.PaperId, AuthorId from Paper inner join PaperByAuthors on Paper.PaperId = PaperByAuthors.PaperId ) as Tab GROUP BY Tab.PaperId )as Tab1 where Tab1.cnt = 1 ) Tab2 inner join PaperbyAuthors on Tab2.paperId = PaperByAuthors.paperId) as Tab3) as Tab4 on Tab4.AuthorId = Author.AuthorId ORDER BY name;

--5--

select name from Author inner join (select AuthorId, count(PaperId) as cnt from PaperbyAuthors group by AuthorId order by cnt desc limit 20 offset 0 ) as Tab on Author.AuthorId = Tab.AuthorId order by Tab.cnt desc, name asc;

--6--

select name from Author inner join ( select AuthorId from (select AuthorId,count(Tab2.PaperId) as cnt1 from (select Tab1.cnt,Tab1.paperId from (select Tab.PaperId, count(Tab.AuthorId) as cnt from (select Paper.PaperId, AuthorId from Paper inner join PaperByAuthors on Paper.PaperId = PaperByAuthors.PaperId ) as Tab GROUP BY Tab.PaperId )as Tab1 where Tab1.cnt = 1 ) Tab2 inner join PaperbyAuthors on Tab2.paperId = PaperByAuthors.paperId group by AuthorId ) as Tab3 where Tab3.cnt1 > 50 ) as Tab4 on Author.AuthorId = Tab4.AuthorId order by name asc;

--7--

select Author.name from Author inner join ( (select distinct (tab.AuthorId) from venue inner join (select a.PaperId,a.AuthorId, b.VenueId from PaperByAuthors a inner join Paper b on a.PaperId=b.PaperId) as tab on venue.VenueId = tab.VenueId where venue.type = 'reference' OR venue.type = 'tr' ) except (select distinct (tab.AuthorId) from venue inner join (select a.PaperId,a.AuthorId, b.VenueId from PaperByAuthors a inner join Paper b on a.PaperId=b.PaperId) as tab on venue.VenueId = tab.VenueId where venue.type = 'journals') ) as t1 on t1.AuthorId = Author.AuthorId order by Author.name;

--8--

select Author.name from Author inner join (select AuthorId from Author except (select distinct (tab.AuthorId) from venue inner join (select a.PaperId,a.AuthorId, b.VenueId from PaperByAuthors a inner join Paper b on a.PaperId=b.PaperId) as tab on venue.VenueId = tab.VenueId where venue.type = 'reference' OR venue.type = 'tr' ) order by AuthorId) as tab2 on tab2.AuthorId = Author.AuthorId order by Author.name;

--9--

select Author.name from Author inner join ( select T5.authorId from ( ( select distinct T3.authorId from (select T2.AuthorId from (select T1.AuthorId,T1.year, count(T1.PaperId) as cnt from (select p1.AuthorId,p1.PaperId,p2.year from PaperByAuthors p1 inner join Paper p2 on p1.PaperId= p2.PaperId) as T1 group by (T1.AuthorId, T1.year)) as T2 where(T2.year=2012 and cnt>=2 ) order by T2.year) as T3 ) intersect ( select distinct Tt3.authorId from (select Tt2.AuthorId from (select Tt1.AuthorId,Tt1.year, count(Tt1.PaperId) as cnt1 from (select pt1.AuthorId,pt1.PaperId,pt2.year from PaperByAuthors pt1 inner join Paper pt2 on pt1.PaperId= pt2.PaperId) as Tt1 group by (Tt1.AuthorId, Tt1.year)) as Tt2 where(Tt2.year=2013 and cnt1>=3 ) order by Tt2.year) as Tt3 ) ) as T5 ) as T4 on T4.AuthorId = Author.AuthorId order by Author.name ;

--10--

select Author.name from Author inner join (select p3.AuthorId, count(p3.PaperId) as cnt from PaperbyAuthors p3 inner join ( select p1.PaperId from Paper p1 inner join venue p2 on p1.venueId = p2.venueId where p2.type = 'journals' And p2.name = 'corr' ) as p4 on p3.PaperId = p4.PaperId group by p3.AuthorId ) as P5 on P5.AuthorId = Author.AuthorId order by cnt desc,Author.name asc limit 20; 

--11--

select Author.name from Author inner join (select T3.AuthorId,cnt from ( select T2.AuthorId, T2.type,T2.name ,count(T2.PaperId) as cnt from (select T1.AuthorId,T1.PaperId,Venue.Type,Venue.name from Venue inner join (select p1.AuthorId , p2.VenueId, p2.PaperId from PaperByAuthors p1 inner join Paper p2 on P1.PaperId = P2.PaperId) as T1 on T1.VenueId = Venue.VenueId) as T2 group by (T2.AuthorId ,T2.type , T2.name) )as T3 where (T3.type = 'journals' and T3.name = 'amc' and cnt >= 4)) as T4 on Author.AuthorId = T4.AuthorId order by Author.name;

--12--

select Author.name from Author inner join ( SELECT t4.authorid FROM ( SELECT tt3.authorid FROM ( SELECT tt2.authorid, tt2.type, tt2.NAME , Count(tt2.paperid) AS cnt FROM ( SELECT tt1.authorid, tt1.paperid, venue.type, venue.NAME FROM venue INNER JOIN ( SELECT pt1.authorid , pt2.venueid, pt2.paperid FROM paperbyauthors pt1 INNER JOIN paper pt2 ON pt1.paperid = pt2.paperid) AS tt1 ON tt1.venueid = venue.venueid) AS tt2 GROUP BY (tt2.authorid ,tt2.type , tt2.NAME)) AS tt3 WHERE ( tt3.type = 'journals' AND tt3.NAME = 'ieicet' AND cnt>=10) ) AS t4 EXCEPT SELECT t5.authorid FROM ( SELECT t3.authorid FROM ( SELECT t2.authorid, t2.type, t2.NAME , count(t2.paperid) AS cnt FROM ( SELECT t1.authorid, t1.paperid, venue.type, venue.NAME FROM venue INNER JOIN ( SELECT p1.authorid , p2.venueid, p2.paperid FROM paperbyauthors p1 INNER JOIN paper p2 ON p1.paperid = p2.paperid) AS t1 ON t1.venueid = venue.venueid) AS t2 GROUP BY (t2.authorid ,t2.type , t2.NAME)) AS t3 WHERE ( t3.type = 'journals' AND t3.NAME = 'tcs') ) AS t5 ) as Tab on Tab.AuthorId = Author.AuthorId order by Author.name; 

--13--

select year , count(PaperId) from Paper where year >=2004 and year <=2013 group by year order by year;

--14--

select count(distinct tab.AuthorId) from(SELECT t1.AuthorId,t2.PaperId, t2.title FROM paperbyauthors t1 INNER JOIN paper t2 ON t1.paperid = t2.paperid where lower(t2.title) like '%query%optimization%') as tab;

--15--

Select T2.title  from (select Paper.title ,T1.cnt from Paper inner join (select Paper2Id,count(Paper1Id) as cnt from Citation group by Paper2Id ) as T1 on Paper.PaperId  =T1.Paper2Id ) as T2 order by T2.cnt desc ,T2.title asc;

--16--

Select T2.title from (select Paper.title ,T1.cnt from Paper inner join (select Paper2Id,count(Paper1Id) as cnt from Citation group by Paper2Id ) as T1 on Paper.PaperId  =T1.Paper2Id ) as T2 where T2.cnt > 10 order by T2.title;

--17--

select distinct c.title from (select a.paperid,a.title,count(b.paper1id)as cntciting from paper a inner join (select paper1id,paper2id from citation)b on a.paperid=b.paper1id group by a.paperid,a.title) c inner join (select a.paperid,a.title,count(b.paper1id)as cntcited from paper a inner join (select paper1id,paper2id from citation)b on a.paperid=b.paper2id group by a.paperid,a.title ) d on c.paperid=d.paperid where d.cntcited-c.cntciting >= 10 order by c.title;

--18--

select distinct Paper.title from Paper inner join (select Paper.PaperId from  Paper except select T1.Paper2Id from (select Paper2Id,count(Paper1Id) as cnt from Citation group by Paper2Id) as T1 ) as T2 on Paper.PaperId = T2.PaperId  order by Paper.title;

--19--

select Author.name from author inner join (select distinct T3.aid1 from (select T2.aid1 from (select T1.pid1,T1.pid2,T1.aid1,a2.AuthorId as aid2 from (select p1.Paper1Id as pid1,p1.Paper2Id as pid2,a1.Authorid as aid1 from citation p1 inner join PaperByAuthors a1 on p1.Paper1Id = a1.PaperId) as T1 inner join PaperByAuthors a2 on T1.pid2= a2.PaperId and T1.pid1 != a2.PaperId) as T2 where T2.aid1=T2.aid2) as T3) as T4 on Author.AuthorId= T4.aid1 order by Author.name;

--20--

select Author.name from Author inner join ( select distinct T4.AuthorId from ( select Ta3.AuthorId from (select Ta2.AuthorId,Ta2.year ,Ta2.type,Ta2.name from (select Ta1.AuthorId,Ta1.year,Venue.type,Venue.name from Venue inner join (select pa1.AuthorId ,pa2.year,pa2.VenueId from PaperByAuthors pa1 inner join Paper pa2 on pa1.PaperId=pa2.PaperId) as Ta1 on Venue.Venueid=Ta1.VenueId) as Ta2 where (Ta2.type = 'journals' and Ta2.name= 'corr' and Ta2.year >=2009 and Ta2.year <=2013) ) as Ta3 except select Tb3.AuthorId from (select Tb2.AuthorId,Tb2.year ,Tb2.type,Tb2.name from (select Tb1.AuthorId,Tb1.year,Venue.type,Venue.name from Venue inner join (select pb1.AuthorId ,pb2.year,pb2.VenueId from PaperByAuthors pb1 inner join Paper pb2 on pb1.PaperId=pb2.PaperId) as Tb1 on Venue.Venueid=Tb1.VenueId) as Tb2 where (Tb2.type = 'journals' and Tb2.name= 'ieicet' and Tb2.year =2009) ) as Tb3 )as T4 ) as T5 on Author.AuthorId=T5.AuthorId order by Author.name;

--21--

select v.name from Venue v inner join ( select T1.VenueId,count(*) as cnt1 from (select v1.name,v1.type,p1.PaperId,p1.title,p1.year,p1.VenueId from Paper p1 inner join Venue v1 on p1.Venueid=v1.Venueid ) as T1 where (T1.year=2009 and T1.type='journals') group by T1.VenueId) as T2 on T2.VenueId=v.VenueId inner join ( select T3.VenueId,count(*) as cnt2 from (select v2.name,v2.type,p2.PaperId,p2.title,p2.year,p2.VenueId from Paper p2 inner join Venue v2 on p2.Venueid=v2.Venueid ) as T3 where (T3.year=2010 and T3.type='journals') group by T3.VenueId) as T4 on T4.VenueId=v.VenueId inner join ( select T5.VenueId,count(*) as cnt3 from (select v3.name,v3.type,p3.PaperId,p3.title,p3.year,p3.VenueId from Paper p3 inner join Venue v3 on p3.Venueid=v3.Venueid ) as T5 where (T5.year=2011 and T5.type='journals') group by T5.VenueId) as T6 on T6.VenueId=v.VenueId inner join ( select T7.VenueId,count(*) as cnt4 from (select v4.name,v4.type,p4.PaperId,p4.title,p4.year,p4.VenueId from Paper p4 inner join Venue v4 on p4.Venueid=v4.Venueid ) as T7 where (T7.year=2012 and T7.type='journals') group by T7.VenueId) as T8 on T8.VenueId=v.VenueId inner join ( select T9.VenueId,count(*) as cnt5 from (select v5.name,v5.type,p5.PaperId,p5.title,p5.year,p5.VenueId from Paper p5 inner join Venue v5 on p5.Venueid=v5.Venueid ) as T9 where (T9.year=2013 and T9.type='journals') group by T9.VenueId) as T10 on T10.VenueId=v.VenueId where ( (T2.cnt1 <= T4.cnt2) and (T4.cnt2 <= T6.cnt3) and (T6.cnt3 <= T8.cnt4) and (T8.cnt4 <= T10.cnt5) ) order by v.name;

--22--

Select tab.name,tab.year from ( SELECT count(p1.paperid) as cnt, p2.NAME,p1.year FROM paper p1 INNER JOIN venue p2 ON p1.venueid = p2.venueid WHERE p2.type = 'journals' GROUP by p2.name,p1.year order by cnt desc,p1.year asc,p2.name asc limit 1 ) as tab;

--23--

select Au.name from author Au inner join (select Tab5.authorid,Tab5.name from (select Tab4.name,Tab3.authorid,(count(Tab3.paperid)) as cnt from paperbyauthors Tab3 inner join(select Tab1.paperid, Tab2.venueid, Tab2.name from paper Tab1 inner join (select Venue.VenueId,Venue.name from venue where type='journals' ) as Tab2 on Tab1.venueid=Tab2.venueid) as Tab4 on Tab3.paperid=Tab4.paperid group by name,authorid) as Tab5 inner join (select Tab7.name,max(Tab7.cnt) as cnt from (select Tab4.name,Tab3.authorid,(count(Tab3.paperid)) as cnt from paperbyauthors Tab3 inner join(select Tab1.paperid, Tab2.venueid, Tab2.name from paper Tab1 inner join (select Venue.VenueId,Venue.name from venue where type='journals' ) as Tab2 on Tab1.venueid=Tab2.venueid) as Tab4 on Tab3.paperid=Tab4.paperid group by name,authorid) as Tab7 group by Tab7.name) as Tab6 on (Tab5.name=Tab6.name and Tab5.cnt = Tab6.cnt)) as Tab8 on Au.authorid=Tab8.authorid order by Au.name;

--24--

select * from Author;

--25--

select * from Author;

--CLEANUP--
