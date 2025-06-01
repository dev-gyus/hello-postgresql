-- 문자열 함수들
-- 공백 제거
select trim(' 공백 제거  ');

-- 문자열 내의 특정 부분 문자열을 다른 문자열로 대체합니다.
select replace('hello world', 'world', 'postgreSQL');

-- 문자열 내에서 부분 문자열의 위치를 반환합니다.
select position('world' in 'hello world');

-- 문자열의 각 단어의 첫 글자를 대문자로 변환합니다.
select initcap('hello world');

-- 숫자 함수들
-- 두 숫자를 나눠서 나머지를 반환
select mod(10, 3);

-- 숫자의 지수 값을 반환
select exp(1);

-- 숫자의 자연 로그 값을 반환
select ln(2.71828);

-- 숫자의 제곱근을 반환
select sqrt(16);

-- 숫자 열의 분산을 반환
select variance(value) from public.a;

-- 숫자 열의 표쥰 편차를 반환합니다
select stddev(value) from public.a;

-- 두 숫자 열 간의 상관 계수를 반환
select corr(value, id) from public.a;

-- 날짜 시간 함수
select date_trunc('month', now());

-- 날짜/시간 값에서 특정 필드를 추출
select extract(year from now());
select extract(month from now());
select extract(day from now());

-- 두 날짜/시간 값 간의 간격을 반환
select now() - interval '1 day';