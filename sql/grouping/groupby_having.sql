select
    시도.시도,
    count(*) as 거래수
from
    아파트_거래_01 아파트거래
right join
        시군구코드_01 시도
on
    아파트거래.지역코드 = 시도.지역코드
group by
    시도.시도
having
    count(*) > 500000;


-- 실행순서 = from, inner join -> on -> where -> group by -> having -> select -> order by
select -- 6
    extract(year from cast(아파트거래.거래일 as date)) as 거래연도,
    count(*) as 연도별_거래건수
from -- 1
    아파트_거래_01 아파트거래
inner join
        시군구코드_01 시도
on -- 2
    아파트거래.지역코드 = 시도.지역코드
where -- 3
    시도.시도 = '서울특별시'
group by -- 4
    extract(year from cast(아파트거래.거래일 as date))
having -- 5
    count(*) > 0
order by -- 7
    거래연도;