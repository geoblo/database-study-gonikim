/*
	8. 그룹화 분석하기
	8.1 그룹화란
*/
-- 그룹화: 데이터를 특정 기준에 따라 나누는 것
-- 그룹화 분석: 그룹별 데이터를 요약하거나 분석하는 것
-- 예: 전체 학생의 평균 키도 의미가 있으나, '성별'로 나누어 평균키를 구하면 조금 더 유의미한 정보를 얻음
-- 또는 어떤 상품 카테고리가 가장 인기가 많은지 '카테고리별' 주문 건수, '카테고리별' 매출액

-- 그룹화 분석 기초 실습
-- 학생의 키 데이터를 성별에 따라 나누어 분석해보기
-- group_analysis DB 생성 및 진입
CREATE DATABASE group_analysis;
USE group_analysis;

CREATE TABLE students (
	id INT AUTO_INCREMENT,
    gender VARCHAR(10),
    height DECIMAL(4, 1),
    PRIMARY KEY (id)
);

INSERT INTO students (gender, height)
VALUES
	('male', 176.6),
	('female', 165.5),
	('female', 159.3),
	('male', 172.8),
	('female', 160.7),
	('female', 170.2),
	('male', 182.1);
    
-- 확인
SELECT * FROM students;

-- 전체 집계: 전체 학생의 평균 키 구하기
SELECT AVG(height)
FROM students;

-- 남학생의 평균 키
SELECT AVG(height)
FROM students
WHERE gender = 'male';

-- 여학생의 평균 키
SELECT AVG(height)
FROM students
WHERE gender = 'female';

-- 그룹화 분석: 각 성별 평균 키 구하기
-- GROUP BY: 특정 컬럼의 값이 같은 행들을 하나의 그룹으로 묶어주는 역할
SELECT 그룹화_컬럼, 집계_함수(일반_컬럼) -- 각 그룹에 대한 통계를 낼 수 있음
FROM 테이블명
WHERE 조건
GROUP BY 그룹화_컬럼; -- 그룹화의 기준이 될 컬럼

SELECT gender, AVG(height)
FROM students
GROUP BY gender;

-- 그룹화의 특징 3가지
-- 1) 집계 함수와 함께 사용해야 함
-- 그룹별 유의미한 분석을 얻기 위해서는 집계 함수를 사용해야 함
-- 단순 GROUP BY 절만 사용하는 것은 데이터를 그룹으로 묶기만 함
SELECT gender
FROM students
GROUP BY gender;

-- 2) 여러 컬럼으로 그룹화 할 수 있다.
SELECT 그룹화_컬럼1, 그룹화_컬럼2, 집계_함수(일반_컬럼)
FROM 테이블명
WHERE 조건
GROUP BY 그룹화_컬럼1, 그룹화_컬럼2; -- 컬럼1로 먼저 그룹화하고, 그 안에서 다시 컬럼2로 그룹화

-- 예: 특정 도시의 연도별 총매출 집계
CREATE TABLE sales (
	id INT AUTO_INCREMENT,
    city VARCHAR(50) NOT NULL, -- 도시명
    sale_date DATE NOT NULL, -- 판매 날짜
    amount INT NOT NULL, -- 판매 금액
    PRIMARY KEY (id)
);

INSERT INTO sales (city, sale_date, amount) 
VALUES
	('Seoul', '2023-01-15', 1000),
	('Seoul', '2023-05-10', 2000),
	('Seoul', '2023-08-29', 2500),
	('Seoul', '2024-02-14', 4000),
	('Busan', '2023-03-05', 1500),
	('Busan', '2024-05-10', 1800),
	('Busan', '2024-07-20', 3000),
	('Incheon', '2023-11-25', 1200),
	('Incheon', '2024-03-19', 2200),
	('Incheon', '2024-09-12', 3300);

SELECT * FROM sales;

-- 일단 먼저 특정 도시별 총매출 집계
SELECT city, SUM(amount)
FROM sales
GROUP BY city;

-- 특정 도시의 연도별 총매출 집계
SELECT 
	city AS '도시', 
    YEAR(sale_date) AS '판매 연도', 
    SUM(amount) AS '총 매출'
FROM sales
GROUP BY city, YEAR(sale_date);

-- 3) SELECT 절에 올 수 있는 컬럼이 제한적이다.
-- 사용 가능한 컬럼:
-- - 그룹화 컬럼: GROUP BY 절에서 지정한 컬럼(그룹을 대표하는 값이라 가능)
-- - 집계된 컬럼: 집계 함수에 사용된 컬럼(그룹 전체를 요약한 값이라 가능)

-- 잘못된 컬럼 사용 예시
SELECT id, gender, AVG(height) -- 집계되지 않은 id 컬럼은 사용 못함
FROM students
GROUP BY gender;

-- 이렇게는 가능
SELECT SUM(id), gender, AVG(height)
FROM students
GROUP BY gender;

-- Quiz
-- 1. 다음 설명이 맞으면 O, 틀리면 X를 표시하시오.
-- ① 그룹화 분석이란 데이터를 특정 그룹으로 나누어 분석하는 것이다. (  )
-- ② GROUP BY 절에는 반드시 하나의 컬럼만 지정해야 한다. (  )
-- ③ 그룹화된 쿼리에서 SELECT 절에 포함된 컬럼은 GROUP BY 절에서 지정한 그룹화 컬럼이거나 집계 함수에 사용된 컬럼이어야 한다. (  )

-- 정답: O, X, O


/*
	8.2 그룹화 필터링, 정렬, 조회 개수 제한
*/
-- 결제 테이블 생성
CREATE TABLE payments (
	id INT AUTO_INCREMENT,
    amount INT, -- 결제 금액
    ptype VARCHAR(50), -- 결제 유형
    PRIMARY KEY (id)
);

INSERT INTO payments (amount, ptype)
VALUES
	(33640, 'SAMSONG CARD'),
	(33110, 'SAMSONG CARD'),
	(31200, 'LOTTI CARD'),
	(69870, 'COCOA PAY'),
	(32800, 'COCOA PAY'),
	(42210, 'LOTTI CARD'),
	(46060, 'LOTTI CARD'),
	(42520, 'SAMSONG CARD'),
	(23070, 'COCOA PAY');
















