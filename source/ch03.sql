/*
	3. 데이터 필터링하기
    3.1 데이터 필터링이란
*/
-- 무엇? 많은 데이터들 중에 원하는 데이터만 골라내는 작업
-- 주로 WHERE 절을 통해 특정 데이터를 추출

-- 예를 들어
-- (a) SELECT문: 데이터 조회
SELECT 컬럼명1, 컬럼명2, ...
FROM 테이블명
WHERE 조건;

-- (b) UPDATE문: 데이터 수정
UPDATE 테이블명
SET 컬럼명 = 입력값
WHERE 조건;

-- (c) DELETE문: 데이터 삭제
DELETE FORM 테이블명
WHERE 조건;

-- 실습 데이터 준비
-- 2장에서 만든 맵도날드 DB를 활용
-- DB 진입
USE mapdonalds;

-- burger 테이블 조회
SELECT * FROM burgers;

-- burgers 테이블 생성
CREATE TABLE burgers (
	id INTEGER, 		  -- 아이디(정수형 숫자)
	name VARCHAR(50), -- 이름(문자형: 최대 50자)
	price INTEGER, 		-- 가격(정수형 숫자)
	gram INTEGER, 		-- 그램(정수형 숫자)
	kcal INTEGER, 		-- 열량(정수형 숫자)
	protein INTEGER, 	-- 단백질량(정수형 숫자)
	PRIMARY KEY (id) 	-- 기본키 지정: id
);

-- burgers 데이터 삽입
INSERT INTO burgers (id, name, price, gram, kcal, protein)
VALUES
	(1, '빅맨', 5300, 223, 583, 27),
	(2, '베이컨 틈메이러 디럭스', 6200, 242, 545, 27),
	(3, '맨스파이시 상해 버거', 5300, 235, 494, 20),
	(4, '슈비두밥 버거', 6200, 269, 563, 21),
	(5, '더블 쿼터파운드 치즈', 7700, 275, 770, 50);