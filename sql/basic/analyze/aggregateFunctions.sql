-- 집계 함수를 활용한 데이터 분석
select
    avg(cast(replace(아파트거래.거래금액, ',', '') as numeric)) as 평균_거래금액,
    count(*) as 거래_건수,
    max(cast(replace(아파트거래.거래금액, ',', '') as numeric)) as 최대_거래금액,
    min(cast(replace(아파트거래.거래금액, ',', '') as numeric)) as 최소_거래금액,
    sum(cast(replace(아파트거래.거래금액, ',', '') as numeric)) as 총_거래금액
from
    아파트_거래_01 아파트거래
left join
    시군구코드_01 시도
on
    아파트거래.지역코드 = 시도.지역코드;