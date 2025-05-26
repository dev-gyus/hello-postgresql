-- 실제 테이블 데이터를 변경하는 작업
update 아파트_거래_01 
    set 거래일 = case
        when 거래일 like '%/%/% %:%' then to_char(to_date(거래일, 'MM/DD/YYYY HH24:MI:SS'), 'YYYY-MM-DD')
        when 거래일 like '% 00:00:00' then to_char(to_date(거래일, 'YYYY-MM-DD HH24:MI:SS'), 'YYYY-MM-DD')
        else 거래일
    end
where 거래일 like '%/%/% %:%' or 거래일 like '% 00:00:00';

-- 지역코드 컬럼 내용 업데이트 하기
update 아파트_거래_01
    set 지역코드 = replace(지역코드, '.0', '')
    where 지역코드 like '%.0';

-- 건축년도 컬럼 내용 업데이트 하기
update 아파트_거래_01
    set 건축년도 = replace(건축년도, '.0', '')
    where 건축년도 like '%.0';

-- 거래금액 컬럼 내용 업데이트 하기
update 아파트_거래_01
    set 거래금액 = to_char(거래금액::numeric, 'FM999,999,999,999');


-- 거래일 형태가 기존과 다른 데이터 찾아서 업데이트하기
-- 데이터 찾기
select *
from public.아파트_거래_01
where 거래일 !~ '^\d{4}-\d{2}-\d{2}$';

-- 데이터 업데이트하기
update public.아파트_거래_01
set 거래일 = to_char(to_date(거래일, 'MM/DD/YYYY'), 'YYYY-MM-DD')
where 거래일 !~ '^\d{4}-\d{2}-\d{2}$';