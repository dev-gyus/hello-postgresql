-- 윈도우 함수를 활용해서 데이터 분석
-- 윈도우 함수는 함수() over (partition by {컬럼}) 이 문법임. 잘 알아 둘 것
select
    아파트거래.*,
    시도.시도,
    -- over (partition by {컬럼}) -> 컬럼에 해당하는 row를 기준으로 번호를 매겨주는 함수
    -- row가 조회되는 순서에 따라 번호가 매겨지므로 동번호 없음
    row_number() over (partition by 시도.시도 order by 아파트거래.거래일) as row_num,
	-- over (partition by {컬럼}) -> 컬럼에 해당하는 데이터를 기준으로 순서를 매겨주는 함수
	-- 동순위의 경우 모두 같은 순위를 매기고, 다음 순위에 동순위만큼 늘어난 랭크를 매김
	-- 10위가 5개 row가 있으면 그 다음 순위는 16번부터
    rank() over (partition by 시도.시도 order by 아파트거래.거래일) as rank,
	-- lead({컬럼}, {n번째}) 현재 row를 기준으로 n번째 다음의 row의 컬럼값을 표시하는 함수
    lead(아파트거래.거래금액, 1) over (partition by 시도.시도 order by 아파트거래.거래일) as next_transaction_amount,
	-- lag({컬럼}, {n번째}) 현재 row를 기준으로 n번째 이전의 row의 컬럼값을 표시하는 함수
	-- 이전 row 데이터가 없으면 null값 반환
    lag(아파트거래.거래금액, 1) over (partition by 시도.시도 order by 아파트거래.거래일) as previous_transaction_amount
from
    아파트_거래_01 아파트거래
        left join
    시군구코드_01 시도
    on
        아파트거래.지역코드 = 시도.지역코드;