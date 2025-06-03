-- 데이터베이스 내에서 특정 작업을 수행하는 SQL 코드 블록
-- 복잡한 작업을 단순화하고, 코드 재사용성을 높이며, 데이터베이스 작업을 효율적으로 관리 할 수 있음

-- 프로시저 생성
CREATE PROCEDURE GetApartmentTransactions()
    LANGUAGE SQL
    AS $$
SELECT * FROM 아파트_거래_01;
INSERT INTO public.a (value) VALUES (123.45);
$$;

-- 특정 프로시저를 호출
CALL GetApartmentTransactions();

-- 프로시저를 조회하는 쿼리
SELECT proname, proargtypes, prorettype
FROM pg_proc
WHERE pronamespace = (SELECT oid FROM pg_namespace WHERE nspname = 'public');

-- 테이블 조회
select * from a

-- 프로시저 삭제
DROP PROCEDURE IF EXISTS GetApartmentTransactions;