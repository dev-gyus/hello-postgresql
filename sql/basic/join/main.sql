select
    아파트거래.*,
    시도.시도
from
    아파트_거래_01 아파트거래
inner join
        시군구코드_01 시도
on
    아파트거래.지역코드 = 시도.지역코드;

select count(AA)
from (select 아파트거래.*,
             시도.시도
      from 아파트_거래_01 아파트거래
               inner join
           시군구코드_01 시도
           on
               아파트거래.지역코드 = 시도.지역코드) as AA;

select count(AA)
from (select * from 아파트_거래_01 아파트거래 right join 시군구코드_01 시도 on 아파트거래.지역코드 = 시도.지역코드) as AA;