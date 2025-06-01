-- 1970 ~ 2023년까지 서울에서 가장 거래가가 높은 아파트
select
    아파트거래.*,
    시도.시도,
    to_number(replace(아파트거래.거래금액, ',', ''), '999999999') as 거래금액_숫자
from
    아파트_거래_01 아파트거래
inner join
        시군구코드_01 시도
on
    아파트거래.지역코드 = 시도.지역코드
where
    시도.시도 = '서울특별시'
order by
    거래금액 desc;

-- 서울에서 건축년도가 1970년이고 10억 넘는 가격으로 거래된 아파트
select
    아파트거래.*,
    시도.시도,
    to_number(replace(아파트거래.거래금액, ',', ''), '999999999') as 거래금액_숫자
from
    아파트_거래_01 아파트거래
        inner join
    시군구코드_01 시도
    on
        아파트거래.지역코드 = 시도.지역코드
where
    시도.시도 = '서울특별시'
  and
    건축년도 = '1970'
  and
    to_number(replace(아파트거래.거래금액, ',', ''), '999999999') >= 100000
order by
    거래금액_숫자 asc;

-- 서울에서 건축년도가 2000년이고 10억 넘는 가격으로 거래된 아파트의 수
select count(*) from (
    select
        아파트거래.*,
        시도.시도,
        to_number(replace(아파트거래.거래금액, ',', ''), '999999999') as 거래금액_숫자
    from
        아파트_거래_01 아파트거래
         inner join
        시군구코드_01 시도
     on
        아파트거래.지역코드 = 시도.지역코드
    where
        시도.시도 = '서울특별시'
    and
        건축년도 = '2000'
    and
        to_number(replace(아파트거래.거래금액, ',', ''), '999999999') >= 100000
    order by
        거래금액_숫자 asc
    ) as AA;

-- 서울 특별시의 연도별 총 아파트 거래금액을 계산하는 쿼리
select
    extract(year from cast(아파트거래.거래일 as date)) as 거래년도,
    sum(to_number(replace(아파트거래.거래금액, ',', ''), '999999999')) as 총_거래_금액
from
    아파트_거래_01 아파트거래
        inner join
    시군구코드_01 시도
    on
        아파트거래.지역코드 = 시도.지역코드
where
    시도.시도 = '서울특별시'
group by
    extract(year from cast(아파트거래.거래일 as date))
-- having
-- 	sum(to_number(replace(아파트거래.거래금액, ',', ''), '999999999')) > 0
order by
    거래년도 asc;

-- 서울 특별시의 연도별 아파트 거래 건수를 계산하는 쿼리
select
    extract(year from cast(아파트거래.거래일 as date)) as 거래년도,
    count(*) as 총_거래_횟수
from
    아파트_거래_01 아파트거래
        inner join
    시군구코드_01 시도
    on
        아파트거래.지역코드 = 시도.지역코드
where
    시도.시도 = '서울특별시'
group by
    extract(year from cast(아파트거래.거래일 as date))
having
    count(*) > 0
order by
    거래년도 asc;

-- 연도별 거래 추이를 분석하고 결과를 구하기
select
    extract(year from to_date(거래일, 'YYYY-MM-DD')) as 거래연도,
    sum(cast(replace(거래금액, ',', '') as numeric)) as 연도별_거래금액
from
    아파트_거래_01 아파트거래
        inner join
    시군구코드_01 시도
    on
        아파트거래.지역코드 = 시도.지역코드
group by
    extract(year from to_date(거래일, 'YYYY-MM-DD'))
order by
    거래연도;

-- 월별 거래금액 비교
select
    to_char(to_date(아파트거래.거래일, 'YYYY-MM-DD'), 'YYYY-MM') as 거래월,
    sum(cast(replace(아파트거래.거래금액, ',', '') as numeric)) as 거래금액
from
    아파트_거래_01 아파트거래
        inner join
    시군구코드_01 시도
    on
        아파트거래.지역코드 = 시도.지역코드
group by
    to_char(to_date(아파트거래.거래일, 'YYYY-MM-DD'), 'YYYY-MM')
order by
    거래월 asc;

-- 지역별 거래량 비교
select
    시도.시도,
    count(*) as 거래량
from
    아파트_거래_01 아파트거래
        inner join
    시군구코드_01 시도
    on
        아파트거래.지역코드 = 시도.지역코드
group by
    시도.시도
order by
    거래량 asc;

-- 전용면적에 따른 거래 금액 분석
select
    round(cast(아파트거래.전용면적 as numeric), 1) as 반올림,
    avg(cast(replace(아파트거래.거래금액, ',', '') as numeric)) as 평균_거래_금액,
    sum(cast(replace(아파트거래.거래금액, ',', '') as numeric)) as 총_거래금액,
    count(*) as 거래량
from
    아파트_거래_01 아파트거래
        inner join
    시군구코드_01 시도
    on
        아파트거래.지역코드 = 시도.지역코드
group by
    round(cast(아파트거래.전용면적 as numeric), 1)
order by
    총_거래금액 asc;

select * from 아파트_거래_01 limit 1;

-- 각 건축년도에 따른 거래량, 평균_거래금액, 총_거래금액, 그리고 연도별로 누적된 거래 금액을 구하는 쿼리
with 거래_데이터 as (
    select
        아파트거래.건축년도,
        cast(replace(아파트거래.거래금액, ',', '') as numeric) as 거래금액,
        count(*) over (partition by 아파트거래.건축년도) as 거래량,
        avg(cast(replace(아파트거래.거래금액, ',', '') as numeric)) over (partition by 아파트거래.건축년도) as 평균_거래금액,
        sum(cast(replace(아파트거래.거래금액, ',', '') as numeric)) over (partition by 아파트거래.건축년도) as 총_거래금액
    from
        아파트_거래_01 아파트거래
            inner join
        시군구코드_01 시도
        on
            아파트거래.지역코드 = 시도.지역코드
)
select distinct on (건축년도)
    건축년도,
    거래량,
    평균_거래금액,
    총_거래금액,
    SUM(거래금액) over (order by 건축년도) as 누적_거래금액
from
    거래_데이터
order by
    건축년도;

-- 조회되는 모든 행에 아래 select절에 대한 결과를 공통적으로 적용 (window 함수)
select
    아파트거래.건축년도,
    cast(replace(아파트거래.거래금액, ',', '') as numeric) as 거래금액,
    count(*) over (partition by 아파트거래.건축년도) as 거래량,
    avg(cast(replace(아파트거래.거래금액, ',', '') as numeric)) over (partition by 아파트거래.건축년도) as 평균_거래금액,
    sum(cast(replace(아파트거래.거래금액, ',', '') as numeric)) over (partition by 아파트거래.건축년도) as 총_거래금액
from
    아파트_거래_01 아파트거래
        inner join
    시군구코드_01 시도
    on
        아파트거래.지역코드 = 시도.지역코드;