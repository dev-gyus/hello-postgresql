select
    아파트거래.*,
    (select 시도 from 시군구코드_01 where 시군구코드_01.지역코드 = 아파트거래.지역코드) as 시도
from
    아파트_거래_01 아파트거래;