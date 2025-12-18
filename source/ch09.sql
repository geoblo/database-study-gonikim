/*
	9. 서브쿼리 활용하기
    9.1 서브쿼리란
*/
-- 왜 필요할까?
-- JOIN 만으로는 한 번에 답하기 어려운, 여러 단계의 질의를 거쳐야 하는 문제들도 있음
-- 예: 쇼핑몰에서 판매하는 상품들의 평균 가격보다 비싼 상품은?
-- 두 단계로 나누어 생각할 수 있음
-- 1단계: 전체 상품의 평균 가격을 구함 => AVG() 사용
-- 2단계: 그 평균 가격보다 비싼 상품을 찾기 => WHERE 절 사용

-- 위 두 단계를 하나의 작업 단위로 묶고 싶을 때 사용하는 기술이 바로 서브쿼리

-- 무엇? 하나의 쿼리문 안에 포함된 또 다른 SELECT 쿼리
-- 안쪽 서브쿼리의 실행 결과를 받아 바깥쪽 메인쿼리가 실행됨

-- 서브쿼리 실습: 다음 학생 중 성적이 평균보다 높은 학생은?
-- students
-- ----------------------
-- id  | name    | score
-- ----------------------
-- 1   | 엘리스    | 85
-- 2   | 밥       | 78
-- 3   | 찰리     | 92
-- 4   | 데이브    | 65
-- 5   | 이브     | 88

-- sub_query DB 생성 및 진입
CREATE DATABASE sub_query;
USE sub_query;

-- students 테이블 생성
CREATE TABLE students (
	id INTEGER AUTO_INCREMENT, 	-- 아이디(자동으로 1씩 증가)
	name VARCHAR(30), 			-- 이름
	score INTEGER, 				-- 성적
	PRIMARY KEY (id) 			-- 기본키 지정: id
);

-- students 데이터 삽입
INSERT INTO students (name, score)
VALUES
	('엘리스', 85),
	('밥', 78),
	('찰리', 92),
	('데이브', 65),
	('이브', 88);
    
-- 확인
SELECT DATABASE();
SHOW TABLES;
SELECT * FROM students;

-- 평균 점수보다 더 높은 점수를 받은 학생 조회
SELECT *
FROM students
WHERE score > (평균_점수); -- () 괄호 안이 서브쿼리로 작성할 부분

-- 평균 점수 계산
SELECT AVG(score)
FROM students;

-- 위 쿼리를 서브쿼리로 사용
-- 메인쿼리
SELECT *
FROM students
WHERE score > (
	-- 서브쿼리: 평균 점수 계산
	SELECT AVG(score)
	FROM students
);

-- 서브쿼리의 특징 5가지
-- 1) 중첩 구조
-- 메인쿼리 내부에 중첩하여 작성
SELECT 컬럼명1, 컬럼명2, ...
FROM 테이블명
WHERE 컬럼명 연산자 (
	서브쿼리
);

-- 2) 메인쿼리와는 독립적으로 실행됨
-- 서브쿼리 우선 실행 후
-- 그 결과를 받아 메인쿼리가 수행됨

-- 3) 다양한 위치에서 사용 가능
-- SELECT
-- FROM/JOIN
-- WHERE/HAVING 등

-- 4) 단일 값 또는 다중 값을 반환
-- 단일 값 서브쿼리: 특정 값을 반환하는 서브쿼리(1행 1열) - "스칼라 서브쿼리" 라고도 부름
-- 다중 값 서브쿼리: 여러 레코드를 반환하는 서브쿼리(N행 M열) - 가상의 테이블로 쓰이거나 IN, ANY, ALL, EXISTS 연산자와 함께 필터링에 사용됨
-- (다중 행 서브쿼리, 다중 컬럼 서브쿼리, 다중 행 다중 컬럼 서브쿼리 등)

-- 5) 복잡하고 정교한 데이터 분석에 유용
-- 필터링 조건 추출 => 이를 기준으로 메인쿼리를 수행(예: WHERE/HAVING 절에서 사용)
-- 데이터 집계 결과 추출 => 이를 기준으로 메인쿼리를 수행(예: FROM/JOIN 절에서 사용)

-- Quiz
-- 1. 다음 설명이 맞으면 O, 틀리면 X를 표시하세요.
-- ① 서브쿼리는 메인쿼리 내부에 중첩해 작성한다. (  )
-- ② 서브쿼리는 다양한 위치에서 사용할 수 있다. (  )
-- ③ 서브쿼리는 단일 값만 반환한다. (  )

-- 정답: O, O, X


/*
	9.2 다양한 위치에서의 서브쿼리
*/
-- 1. SELECT 절에서의 서브쿼리
-- 1x1 단일값만 반환하는 서브쿼리(스칼라 서브쿼리)만 사용 가능
-- 이유? 여러 행 또는 여러 컬럼을 반환하면 어떤 값을 선택해야 할 지 몰라 에러 발생

-- 모든 결제 정보에 대한 평균 결제 금액과의 차이는?
SELECT 
	payment_type AS '결제 유형',
    amount AS '결제 금액',
    amount - (평균결제금액) AS '평균 결제 금액과의 차이'
FROM payments;

-- 평균 결제 금액
SELECT AVG(amount)
FROM payments;

-- () 괄호 안에 서브쿼리 넣기
SELECT 
	payment_type AS '결제 유형',
    amount AS '결제 금액',
    amount - (SELECT AVG(amount) FROM payments) AS '평균 결제 금액과의 차이'
FROM payments;

-- 잘못된 사용 예
-- SELECT에 사용하는 서브쿼리는 스칼라 서브쿼리만 가능
SELECT 
	payment_type AS '결제 유형',
    amount AS '결제 금액',
    -- amount - (SELECT AVG(amount), '123' FROM payments) AS '평균 결제 금액과의 차이' -- 다중 컬럼 서브쿼리
    amount - (SELECT amount FROM payments) AS '평균 결제 금액과의 차이' -- 다중 행 서브쿼리
FROM payments;
-- Error Code: 1241. Operand should contain 1 column(s)
-- Error Code: 1242. Subquery returns more than 1 row


-- 2. FROM 절에서의 서브쿼리
-- NxM 반환하는 행과 컬럼의 개수에 제한이 없음
-- 실행 결과가 마치 하나의 독릭된 가상 테이블(View)처럼 사용되기 때문에 테이블 서브쿼리라고 부름
-- 단, 서브쿼리에 별칭 지정 필수

-- 1회 주문 시 평균 상품 개수는? (장바구니 상품 포함)
-- 일단 먼저 1회 주문 당 상품 개수 집계 구하기
-- 1단계: 주문별(order_id)로 그룹화 -> count 집계: SUM()
-- 2단계: 재집계: AVG()
SELECT 
	order_id,
    SUM(count) AS total_count
FROM order_details
GROUP BY order_id; -- 서브쿼리로 사용(테이블 서브쿼리라고 부름)

-- 메인쿼리: 1회 주문 시 평균 상품 개수 집계
SELECT AVG(sub.total_count) -- 별칭으로 접근(권장)
-- SELECT AVG(sub.`SUM(count)`) -- 접근 가능(비권장)
FROM (
	-- 서브쿼리
    SELECT 
		order_id,
		SUM(count) AS total_count -- 외부 쿼리에서 집계 결과를 참조하기 위해 별칭 사용(가독성 + 호환성)
        -- SUM(count) -- SUM(count)라는 컬럼명 자동 생성
	FROM order_details
	GROUP BY order_id
) AS sub; -- 별칭 필수(AS는 생략 가능)


-- 3. JOIN 절에서의 서브쿼리
-- NxM 반환하는 행과 컬럼의 개수에 제한이 없음
-- 실행 결과가 마치 하나의 독릭된 가상 테이블(View)처럼 사용되기 때문에 테이블 서브쿼리라고 부름
-- 단, 서브쿼리에 별칭 지정 필수

-- 상품별 주문 개수를 '배송 완료'와 '장바구니'에 상관없이 상품명과 주문 개수를 조회한다면?
-- 일단 먼저 상품 아이디별 주문 개수 집계 구하기
SELECT 
	product_id,
    SUM(count) AS total_count
FROM order_details
GROUP BY product_id;

-- 메인쿼리: 상품명을 포함한 상품별 주문 개수 집계
SELECT 
	p.name AS 상품명,
    sub.total_count AS '주문 개수' -- 서브쿼리에서 구한 데이터를 가져다 씀
FROM products p
JOIN (
	-- 서브쿼리
    SELECT 
		product_id,
		SUM(count) AS total_count
	FROM order_details
	GROUP BY product_id
) AS sub ON p.id = sub.product_id;

-- 또 다른 방법: 일단 필요한 테이블을 붙여놓고(JOIN) 그룹화 및 집계
SELECT 
	p.name AS 상품명,
    SUM(count) AS '주문 개수'
FROM products p
JOIN order_details od ON p.id = od.product_id
GROUP BY p.id, p.name; -- 이식성을 고려한 권장 코드: 명시적으로 GROUP BY에 포함


-- 4. WHERE 절에서의 서브쿼리
-- 1x1, Nx1 반환하는 서브쿼리만 사용 가능(필터링 조건으로 값 또는 값의 목록을 사용하기 때문)

-- 평균 가격보다 비싼 상품을 조회하려면?
SELECT *
FROM products
WHERE price > (평균가격);
-- 평균 가격을 서브쿼리로 구해서 넣으면 됨

SELECT *
FROM products
WHERE price > (
	-- 서브쿼리: 평균가격
    SELECT AVG(price)
    FROM products
);


-- 5. HAVING 절에서의 서브쿼리
-- 1x1, Nx1 반환하는 서브쿼리만 사용 가능(필터링 조건으로 값 또는 값의 목록을 사용하기 때문)

-- 크림 치즈보다 매출이 높은 상품은? (장바구니 상품 포함)
-- 상품x주문상세 조인해서 -> 상품명으로 그룹화 -> 상품별로 매출을 집계
-- 메인쿼리: 전체 상품의 매출을 조회
SELECT 
	p.name AS 상품명,
    SUM(price * count) AS 매출
FROM products p
JOIN order_details od ON p.id = od.product_id
GROUP BY p.name;

-- => 크림 치즈보다 매출이 높은 상품 조회로 변경
SELECT 
	p.name AS 상품명,
    SUM(price * count) AS 매출
FROM products p
JOIN order_details od ON p.id = od.product_id
GROUP BY p.name
HAVING SUM(price * count) > (
	-- 서브쿼리: 크림 치즈의 매출(=8720)
    SELECT SUM(price * count)
	FROM products p
	JOIN order_details od ON p.id = od.product_id
	WHERE p.name = '크림 치즈'
);

-- Quiz
-- 2. 다음 설명이 맞으면 O, 틀리면 X를 표시하세요.
-- ① SELECT 절의 서브쿼리는 단일 값만 반환해야 한다. (  )
-- ② FROM 절과 JOIN 절의 서브쿼리는 별칭을 지정해야 한다. (  )
-- ③ WHERE 절과 HAVING 절의 서브쿼리는 단일 값 또는 다중 행의 단일 컬럼을 반환할 수 있다. (  )

-- 정답: O, O, O


/*
	9.3 IN, ANY, ALL, EXISTS
*/
-- 목록을 다룰 수 있는 특별한 연산자
-- 주로 WHERE 절에서의 서브쿼리와 쓰임

-- 1. IN 연산자
-- 괄호 사이 목록에 포함되는 대상을 찾음

-- 형식
컬럼명 IN (쉼표로 구분된 값 목록);
-- 또는 
컬럼명 IN (다중 행의 단일 컬럼을 반환하는 서브쿼리); -- 1x1, Nx1 

-- IN 연산자 사용 예1: 값 목록을 입력받는 경우
-- Quiz: 상품명이 '우유 식빵', '크림 치즈'인 대상의 id 목록은?
SELECT id
FROM products
WHERE name IN ('우유 식빵', '크림 치즈');

-- IN 연산자 사용 예2: 서브쿼리를 입력받는 경우
-- '우유 식빵', '크림 치즈'를 포함하는 주문의 상세 내역
SELECT *
FROM order_details
WHERE product_id IN (
	-- 서브쿼리: 우유 식빵과 크림 치즈의 아이디를 반환(Nx1)
    SELECT id
	FROM products
	WHERE name IN ('우유 식빵', '크림 치즈')
);

-- IN 연산자 사용 예3: 조인과 IN 연산자
-- Quiz: '우유 식빵', '크림 치즈'를 주문한 사용자 아이디와 닉네임은?
SELECT DISTINCT u.id, u.nickname
FROM users u
JOIN orders o ON u.id = o.user_id
JOIN order_details od ON o.id = od.order_id
JOIN products p ON od.product_id = p.id
WHERE p.name IN ('우유 식빵', '크림 치즈');


-- 2. ANY 연산자
-- 지정된 집합의 모든 요소와 비교 연산(>, < 등)을 수행하여 하나라도 만족하는 대상을 찾음

-- 형식
컬럼명 비교연산자 ANY (다중 행의 단일 컬럼을 반환하는 서브쿼리);

-- '우유 식빵'이나 '플레인 베이글'보다 저렴한 상품 목록은?
-- 메인쿼리
SELECT name AS 이름, price AS 가격
FROM products
WHERE price < ANY (
	-- 서브쿼리: 우유 식빵과 플레인 베이글의 가격 조회
    SELECT price
    FROM products
    WHERE name IN ('우유 식빵', '플레인 베이글') -- 2900, 1300
); -- 최대값보다 작으면 참, 결과적으로 2900원 보다 작은 모든 상품 조회

-- 집계 함수 사용으로 대체
SELECT name AS 이름, price AS 가격
FROM products
WHERE price < (
	-- 서브쿼리: 우유 식빵과 플레인 베이글의 가격 조회
    SELECT MAX(price)
    FROM products
    WHERE name IN ('우유 식빵', '플레인 베이글') -- 2900
);


-- 3. ALL 연산자
-- 지정된 집합의 모든 요소와 비교 연산(>, < 등)을 수행하여 모두를 만족하는 대상을 찾음

-- 형식
컬럼명 비교연산자 ALL (다중 행의 단일 컬럼을 반환하는 서브쿼리);

-- '우유 식빵'과 '플레인 베이글'보다 비싼 상품 목록은?
-- 메인쿼리
SELECT name AS 이름, price AS 가격
FROM products
WHERE price > ALL (
	-- 서브쿼리: 우유 식빵과 플레인 베이글의 가격 조회
    SELECT price
    FROM products
    WHERE name IN ('우유 식빵', '플레인 베이글') -- 2900, 1300
); -- 최대값보다 커야 참, 결과적으로 2900원 보다 큰 모든 상품 조회

-- 집계 함수 사용으로 대체
SELECT name AS 이름, price AS 가격
FROM products
WHERE price > (
	-- 서브쿼리: 우유 식빵과 플레인 베이글의 가격 조회
    SELECT MAX(price)
    FROM products
    WHERE name IN ('우유 식빵', '플레인 베이글') -- 2900
);

-- 정리: 두 쿼리 모두 ANY, ALL을 사용했을 때와 완전히 동일한 결과를 반환
-- ANY, ALL 보다는 집계 함수를 사용한 코드가 더 직관적이고 이해하기 쉬움
-- 그래서 ANY, ALL 사용 빈도는 IN 이나 집계 함수에 비해 낮은 편


-- 4. EXISTS 연산자
-- 서브쿼리 결과 행이 1개 이상이면 TRUE => 단 하나의 행이라도 반환하면 서브쿼리 중단하고 TRUE
-- 서브쿼리 결과 행이 0개이면 FALSE => 아무 행도 반환하지 않으면 FALSE
-- 서브쿼리가 반환하는 결과값 자체에는 관심이 없고, 오직 서브쿼리의 결과로 행이 하나라도 존재하는지 여부만 체크

-- 형식
SELECT 컬럼명1, 컬럼명2, ...
FROM 테이블명
WHERE EXISTS (서브쿼리);

-- 






















