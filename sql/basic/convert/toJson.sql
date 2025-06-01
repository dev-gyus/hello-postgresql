-- 쿼리 결과는 json 타입으로 변환
select
    -- jsonb타입으로 변환하는 함수 (jsonb = postgreSQL에서 제공하는 json을 바이너리 형태로 저장하는 타입)
    jsonb_build_object(
    '아파트거래', to_json(아파트거래),
    '시도', 시도.시도
    ) as json_result
from
    아파트_거래_01 아파트거래
left join
    시군구코드_01 시도
on
    아파트거래.지역코드 = 시도.지역코드;