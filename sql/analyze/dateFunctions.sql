-- 날짜/시간함수를 활용한 데이터 분석
select
    now() as 현재_시간,
    age(now(), to_date(아파트거래.거래일, 'YYYY-MM-DD')) as 거래_경과_시간,
    date_part('year', now()) - date_part('year', to_date(아파트거래.거래일, 'YYYY-MM-DD')) as 거래_경과_년도,
    to_char(now(), 'YYYY-MM-DD HH24:MI:SS') as 현재_시간_포맷
from
    아파트_거래_01 아파트거래
        left join
    시군구코드_01 시도
    on
        아파트거래.지역코드 = 시도.지역코드;