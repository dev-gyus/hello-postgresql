select
    아파트거래.*
from
    아파트_거래_01 아파트거래
where
    아파트거래.지역코드 in
    (select 지역코드 from 시군구코드_01 where 시도 = '서울특별시');