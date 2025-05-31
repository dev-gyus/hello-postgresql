-- 숫자 관련 함수
select
    -- 절댓값
    abs(cast(replace(아파트거래.거래금액, ',', '') as numeric)) as 거래금액_절대값,
    -- 올림
    ceil(cast(아파트거래.전용면적 as numeric)) as 전용면적_올림,
    -- 내림
    floor(cast(아파트거래.전용면적 as numeric)) as 전용면적_내림,
    -- 반올림
    round(cast(아파트거래.전용면적 as numeric), 2) as 전용면적_반올림_소숫점둘째짜리에서,
    -- 제곱
    power(cast(아파트거래.전용면적 as numeric), 2) as 전용면적_제곱
from
        아파트_거래_01 아파트거래
left join
        시군구코드_01 시도
on
    아파트거래.지역코드 = 시도.지역코드;