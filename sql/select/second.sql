create table 시군구코드 as
select distinct on (지역코드)
    지역코드,
    법정동,
    case
        when left(지역코드, 2) = '11' then '서울특별시'
        when left(지역코드, 2) = '26' then '부산광역시'
        when left(지역코드, 2) = '27' then '대구광역시'
        when left(지역코드, 2) = '28' then '인천광역시'
        when left(지역코드, 2) = '29' then '광주광역시'
        when left(지역코드, 2) = '30' then '대전광역시'
        when left(지역코드, 2) = '31' then '울산광역시'
        when left(지역코드, 2) = '41' then '경기도'
        when left(지역코드, 2) = '42' then '강원도'
        when left(지역코드, 2) = '43' then '충청북도'
        when left(지역코드, 2) = '44' then '충청남도'
        when left(지역코드, 2) = '45' then '전라북도'
        when left(지역코드, 2) = '46' then '전라남도'
        when left(지역코드, 2) = '47' then '경상북도'
        when left(지역코드, 2) = '48' then '경상남도'
        when left(지역코드, 2) = '50' then '제주도'
        else '기타'
    end as 시도
from 아파트_거래;