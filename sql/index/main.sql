create index idx_시군구코드_지역코드 on 시군구코드_01 using btree (지역코드);
create index idx_아파트_거래_지역코드 on 아파트_거래_01 using btree (지역코드);

explain analyze
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
order by
    거래금액_숫자;

-- 인덱스를 거는 컬럼의 값이 중복이 많은경우 즉, 카디널리티가 낮은 경우 인덱스를 걸어도 크게 효과를 보기는 어렵다
-- sort key, sort method의 memory 사용 여부, hash join, hash cond, parallel seq 사용 여부 확인