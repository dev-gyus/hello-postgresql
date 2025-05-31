-- 제어 구조 함수 (case)
select
    아파트거래.*,
    시도.시도,
    case
        when 아파트거래.거래금액 is null then '거래금액 없음'
        else 아파트거래.거래금액
    end as 거래금액_상태
from
    아파트_거래_01 아파트거래
left join
    시군구코드_01 시도
on
    아파트거래.지역코드 = 시도.지역코드;