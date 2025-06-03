-- function과 트리거는 DML과 같은 SQL을 실행할 떄 같이 실행되는 기능을 정의하는 것
-- 데이터가 insert 될 때 실행될 function의 from 절에 사용될 테이블 정의
CREATE TABLE public.a_log (
                              log_id serial4 NOT NULL,
                              a_id int NOT NULL,
                              value numeric NULL,
                              action_time timestamp DEFAULT current_timestamp,
                              CONSTRAINT a_log_pkey PRIMARY KEY (log_id)
);

-- function 정의
-- NEW는 트리거 함수 내에서 사용되는 특별한 레코드 변수로, 트리거가 발생한 후 새로 삽입되거나 업데이트된 행의 값을 나타냅니다.
-- 이 변수는 INSERT 또는 UPDATE 트리거에서 사용됩니다.
-- 예를 들어, NEW.id는 새로 삽입되거나 업데이트된 행의 id 값을 의미합니다.
CREATE OR REPLACE FUNCTION log_insert_a()
RETURNS TRIGGER AS $$
BEGIN
INSERT INTO public.a_log (a_id, value)
VALUES (NEW.id, NEW.value);
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

   -- 트리거가 정의될 테이블 정의
CREATE TABLE public.a (
                          id serial4 NOT NULL,
                          value numeric NULL,
                          CONSTRAINT a_pkey PRIMARY KEY (id)
);

-- 트리거를 만들어서 데이터가 insert될 때 위에 정의한 function이 실행되도록 정의
CREATE TRIGGER trigger_log_insert_a
    AFTER INSERT ON public.a
    FOR EACH ROW
    EXECUTE FUNCTION log_insert_a();

-- 실제 데이터를 insert 해서 트리거 호출 되는지 확인
INSERT INTO public.a (value)
VALUES (123.45);

SELECT * FROM public.a_log;