-- 신규 테이블 생성
create table 아파트_거래(
	지역코드 varchar(255),
	법정동 varchar(255),
	거래일 varchar(255),
	아파트 varchar(255),
	지번 varchar(255),
	전용면적 varchar(255),
	층 varchar(255),
	건축년도 varchar(255),
	거래금액 varchar(255)
);

-- 생성된 테이블 조회
select * from 아파트_거래;

-- 테이블 row 카운팅
select count(*) from 아파트_거래;

-- distinct -> 중복값 제거
select distinct on (지역코드) 지역코드, 법정동 from 아파트_거래;

-- 원본 테이블 복사
create table 아파트_거래_01 as select * from 아파트_거래;

-- 복사한 테이블 조회
select * from 아파트_거래_01;
-- 복사한 테이블 row 카운팅
select count(*) from 아파트_거래_01;