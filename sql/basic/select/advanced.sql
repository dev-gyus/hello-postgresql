-- 데이터를 좀 더 깔끔하게 정리하기 위한 쿼리
-- 지역코드, 건축년도에 붙은 .0 제거 및 거래금액 numeric 변환
select
    replace(지역코드, '.0', '') as 지역코드,
    법정동,
    replace(건축년도, '.0', '') as 건축년도,
    to_char(to_date(거래일, 'MM/DD/YYYY HH24:MI:SS'), 'YYYY-MM-DD') as  거래일,
    지번
    층,
    to_char(거래금액::numeric, 'FM999,999,999,999') as 거래금액
from
    아파트_거래_01
where
    지역코드 like '%.0' or
    건축년도 like '%.0' or
    거래일 like '%/%/% %:%';

-- 전용면적 -> 평수 변환
select
	replace(지역코드, '.0', '') as 지역코드,
	법정동,
	replace(건축년도, '.0', '') as 건축년도,
	to_char(to_date(거래일, 'MM/DD/YYYY HH24:MI:SS'), 'YYYY-MM-DD') as 거래일,
	지번,
	ROUND(cast(전용면적 AS numeric), 1) as 전용면적,
	ROUND(cast(전용면적 as numeric) / 3.3058, 2) as 평수,
	층,
    -- ::는 cast() 대신 사용할 수 있음
	to_char(거래금액::numeric, 'FM999,999,999,999') as 거래금액
from
	아파트_거래_01
where
	지역코드 like '%.0' or
	건축년도 like '%.0' or
	거래일 like '%/%/% %:%';