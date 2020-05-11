-- BASIC

-- Q1. 
SELECT DEPARTMENT_NAME AS "학과 명", CATEGORY 
FROM tb_department;

-- Q2. 
SELECT 
    DEPARTMENT_NAME || '의 정원은 ' || CAPACITY || '명 입니다. ' AS "학과별 정원"
FROM tb_department;

-- Q3. 
SELECT STUDENT_NAME
FROM TB_STUDENT
WHERE DEPARTMENT_NO='001' AND ABSENCE_YN ='Y' 
            AND SUBSTR(STUDENT_SSN, INSTR(STUDENT_SSN, '-')+1, 1)='2';

-- Q4.
SELECT  STUDENT_NAME 
FROM TB_STUDENT
WHERE (STUDENT_NO = 'A513079' OR 
STUDENT_NO = 'A513090' OR 
STUDENT_NO ='A513091' OR
STUDENT_NO ='A513110' OR
STUDENT_NO ='A513119') 
ORDER BY STUDENT_NO DESC;

-- Q5.
SELECT DEPARTMENT_NAME, CATEGORY
FROM TB_DEPARTMENT
WHERE CAPACITY>=20 AND CAPACITY<=30;

-- Q6.
SELECT PROFESSOR_NAME 
FROM TB_PROFESSOR
WHERE DEPARTMENT_NO IS NULL;
 
-- Q7.
SELECT STUDENT_NAME
FROM TB_STUDENT
WHERE DEPARTMENT_NO IS NULL;

-- Q8.
SELECT CLASS_NO
FROM TB_CLASS
WHERE PREATTENDING_CLASS_NO IS NOT NULL;

-- Q9.
SELECT DISTINCT CATEGORY
FROM TB_DEPARTMENT
ORDER BY CATEGORY;

-- Q10.
SELECT STUDENT_NO, STUDENT_NAME, STUDENT_SSN
FROM TB_STUDENT
WHERE 
    (SUBSTR(ENTRANCE_DATE, 1, 2)) = '02' AND
    ABSENCE_YN ='N' AND
    STUDENT_ADDRESS LIKE '%전주%';
    
    
----------------------------------------------------------------------------------------------------------------------

-- FUNCTION

-- Q1. 
SELECT STUDENT_NO AS "학번", STUDENT_NAME AS "이름", ENTRANCE_DATE AS "입학년도"
FROM TB_STUDENT 
WHERE DEPARTMENT_NO = 002
ORDER BY ENTRANCE_DATE;

-- Q2.
SELECT PROFESSOR_NAME, PROFESSOR_SSN
FROM TB_PROFESSOR
WHERE LENGTH(PROFESSOR_NAME) <>3;

-- Q3. 
SELECT PROFESSOR_NAME AS "교수이름", 
            EXTRACT (YEAR FROM SYSDATE) - (SUBSTR(PROFESSOR_SSN, 1, 2) + 1900) AS "나이"
FROM TB_PROFESSOR
WHERE SUBSTR(PROFESSOR_SSN, 8, 1) = 1
ORDER BY "나이";

-- ★ Q4 (???? SUBSTR 특성을 파악 잘 못해서 못풀었음)
SELECT SUBSTR(PROFESSOR_NAME, 2) AS "이름"
FROM TB_PROFESSOR;

-- Q5.
SELECT STUDENT_NO, STUDENT_NAME
FROM TB_STUDENT
WHERE EXTRACT(YEAR FROM ENTRANCE_DATE) - (SUBSTR(STUDENT_SSN, 1, 2) + 1900) =20;

-- Q6.
SELECT TO_CHAR (TO_DATE ('20201225', 'YYYYMMDD'), 'DY') AS "2020 크리스마스 요일"
FROM DUAL;

-- Q7.
SELECT TO_DATE ('99/10/11' , 'YY/MM/DD') FROM DUAL; -- 2099년
SELECT TO_DATE ('49/10/11', 'YY/MM/DD') FROM DUAL; -- 2049년
SELECT TO_DATE ('99/10/11', 'RR/MM/DD') FROM DUAL; -- 1999년
SELECT TO_DATE ('49/10/11', 'RR/MM/DD') FROM DUAL;  -- 2049년

-- ★ Q8. (MINUS로 못 푸나?) 보다도 NOT LIKE를 쓰면 좋았다
SELECT STUDENT_NO, STUDENT_NAME
FROM TB_STUDENT
WHERE (EXTRACT (YEAR FROM ENTRANCE_DATE)) <2000;

-- Q9.
SELECT ROUND(AVG(POINT), 1) AS "평점"
FROM TB_GRADE
WHERE STUDENT_NO = 'A517178';

-- Q10.
SELECT DEPARTMENT_NO AS "학과 번호", 
        COUNT (STUDENT_NAME) AS "학생수(명)"
FROM TB_STUDENT
GROUP BY DEPARTMENT_NO
ORDER BY DEPARTMENT_NO;

-- Q11.
SELECT COUNT(*) 
FROM TB_STUDENT
WHERE COACH_PROFESSOR_NO IS NULL;

-- ★ Q12. 
SELECT SUBSTR(TERM_NO, 1, 4) AS "년도", ROUND(AVG(POINT), 1) AS "년도 별 평점"
FROM TB_GRADE
WHERE STUDENT_NO = 'A112113' 
GROUP BY SUBSTR(TERM_NO, 1, 4)
ORDER BY "년도";

-- ★ Q13. 
SELECT DEPARTMENT_NO AS "학과코드명", COUNT (decode(absence_yn,'Y',1)) AS "휴학생 수"
FROM TB_STUDENT
GROUP BY DEPARTMENT_NO
ORDER BY DEPARTMENT_NO;

-- ★★★ Q14. 
SELECT STUDENT_NAME AS "동일 이름" ,
           COUNT (*) AS "동명인 수"
FROM TB_STUDENT
GROUP BY STUDENT_NAME
HAVING COUNT(*)>1
ORDER BY 1;

-- Q15. 
SELECT SUBSTR(TERM_NO, 1, 4) AS "년도", 
            SUBSTR(TERM_NO, 5, 2) AS "학기", 
            ROUND(POINT, 1) AS "평점"
FROM TB_GRADE
GROUP BY ROLLUP SUBSTR(TERM_NO, 1, 4), SUBSTR(TERM_NO, 5, 2)
WHERE STUDENT_NO = 'A112113';


----------------------------------------------------------------------------------------------------------------------


-- OPTION

-- Q1.
SELECT STUDENT_NAME AS "학생 이름", STUDENT_ADDRESS AS "학생 주소"
FROM TB_STUDENT
ORDER BY 1;

-- Q2.
SELECT STUDENT_NAME, STUDENT_SSN
FROM TB_STUDENT
WHERE SUBSTR(ABSENCE_YN, 1, 1)='Y'
ORDER BY STUDENT_SSN DESC;

-- Q3.
SELECT STUDENT_NAME AS "학생이름", STUDENT_NO AS "학번", STUDENT_ADDRESS AS "거주지 주소"
FROM TB_STUDENT
WHERE SUBSTR(STUDENT_ADDRESS, 1, 3) IN ('경기도', '강원도')
AND SUBSTR(STUDENT_NO, 1, 1) = '9'
ORDER BY 1;

-- Q4.
SELECT PROFESSOR_NAME, PROFESSOR_SSN
FROM TB_PROFESSOR
WHERE DEPARTMENT_NO = '005'
ORDER BY PROFESSOR_SSN ASC;

-- Q5.
SELECT STUDENT_NO, POINT
FROM TB_GRADE
WHERE CLASS_NO = 'C3118100'
AND TERM_NO = '200402'
ORDER BY POINT DESC, STUDENT_NO ASC;

-- Q6.
SELECT STUDENT_NO, STUDENT_NAME, DEPARTMENT_NAME
FROM TB_STUDENT
JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
ORDER BY 2 ASC;

-- Q7.
SELECT CLASS_NAME, DEPARTMENT_NAME
FROM TB_CLASS
JOIN TB_DEPARTMENT USING (DEPARTMENT_NO);

-- Q8.
SELECT CLASS_NAME, PROFESSOR_NAME
FROM TB_CLASS
JOIN TB_CLASS_PROFESSOR USING (CLASS_NO)
JOIN TB_PROFESSOR USING (PROFESSOR_NO)
ORDER BY 1;

-- ☆ Q9. 해설 필요
SELECT CLASS_NAME, PROFESSOR_NAME
FROM TB_CLASS
JOIN TB_CLASS_PROFESSOR USING (CLASS_NO)
JOIN TB_PROFESSOR P USING (PROFESSOR_NO)
JOIN TB_DEPARTMENT D ON (P.DEPARTMENT_NO=D.DEPARTMENT_NO)
WHERE CATEGORY='인문사회'
ORDER BY 1;

-- Q10. 답지에 DEPARTMENT 왜 있는지 모르겠음
SELECT S.STUDENT_NO AS "학번", 
           STUDENT_NAME AS "학생 이름", 
           ROUND(AVG(POINT),1) AS "전체 평점"
FROM TB_GRADE G
JOIN TB_STUDENT S ON (S.STUDENT_NO=G.STUDENT_NO)
JOIN 
WHERE DEPARTMENT_NO='059'
GROUP BY STUDENT_NO, STUDENT_NAME
ORDER BY STUDENT_NO;

-- ☆ Q11. 답 보고 고침 : 234에서 COACH PROFESSOR로 엮지 않으면 안되는 이유가 231에서 지도교수이름 때문?
SELECT DEPARTMENT_NAME AS "학과이름", STUDENT_NAME AS "학생이름" , PROFESSOR_NAME AS "지도교수이름"
FROM TB_STUDENT S
JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
JOIN TB_PROFESSOR P ON (S.COACH_PROFESSOR_NO=P.PROFESSOR_NO)
WHERE STUDENT_NO = 'A313047';

-- Q12.
SELECT STUDENT_NAME, TERM_NO AS "TERM_NAME"
FROM TB_STUDENT 
JOIN TB_GRADE USING (STUDENT_NO)
JOIN TB_CLASS USING (CLASS_NO)
WHERE SUBSTR(TERM_NO, 1, 4) = '2007'
AND CLASS_NAME='인간관계론'
ORDER BY 1;

-- ☆ Q13. 답지 베낌 ....? 뭔 소리야
SELECT CLASS_NAME, DEPARTMENT_NAME
FROM TB_CLASS 
LEFT JOIN TB_CLASS_PROFESSOR USING (CLASS_NO) 
JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
WHERE CATEGORY = '예체능'
AND PROFESSOR_NO IS NULL;

-- ☆ Q14. NULL값 없음..
SELECT STUDENT_NAME AS "학생이름", NVL(PROFESSOR_NAME, '지도교수 미지정') AS "지도교수"
FROM TB_STUDENT S
JOIN TB_PROFESSOR ON (COACH_PROFESSOR_NO = PROFESSOR_NO)
WHERE S.DEPARTMENT_NO ='020'
ORDER BY STUDENT_NO;

-- Q15. 
SELECT STUDENT_NO AS "학번", STUDENT_NAME AS "이름", DEPARTMENT_NAME AS "학과 이름", AVG(POINT) AS "평점"
FROM TB_STUDENT 
JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
JOIN TB_GRADE USING (STUDENT_NO)
WHERE SUBSTR(ABSENCE_YN, 1, 1)='N'
AND AVG(POINT)>='4.0'
GROUP BY STUDENT_NO, STUDENT_NAME, DEPARTMENT_NAME;


----------------------------------------------------------------------------------------------------------------------

-- SUBQUERY

-- Q1.
-- 전지연 사원이 속해있는 부서원들을 조회하시오 (단, 전지연은 제외)
-- 사번, 사원명, 전화번호, 고용일, 부서명

SELECT EMP_ID, EMP_NAME, PHONE, HIRE_DATE, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_ID=DEPT_CODE)
WHERE DEPT_TITLE = (SELECT DEPT_TITLE
                                FROM EMPLOYEE
                                JOIN DEPARTMENT ON (DEPT_ID=DEPT_CODE)
                                WHERE EMP_NAME ='전지연')
AND EMP_NAME != '전지연';


-- Q2. ?? MAX로 안되나
-- 고용일이 2000년도 이후인 사원들 중 급여가 가장 높은 사원의
-- 사번, 사원명, 전화번호, 급여, 직급명을 조회하시오.

SELECT *
FROM (SELECT EMP_ID, EMP_NAME, PHONE, SALARY, JOB_NAME
            FROM EMPLOYEE
            JOIN JOB USING(JOB_CODE)
            WHERE (EXTRACT (YEAR FROM HIRE_DATE)) > '2000'
            ORDER BY SALARY DESC)
WHERE ROWNUM <2;
            
            
-- Q3. 
-- 노옹철 사원과 같은 부서, 같은 직급인 사원을 조회하시오. (단, 노옹철 사원은 제외)
-- 사번, 이름, 부서코드, 직급코드, 부서명, 직급명

SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE 
JOIN JOB USING (JOB_CODE)
JOIN DEPARTMENT ON (DEPT_ID=DEPT_CODE)
WHERE (DEPT_CODE, JOB_CODE) = ( SELECT DEPT_CODE, JOB_CODE 
                                                    FROM EMPLOYEE
                                                    WHERE EMP_NAME ='노옹철')
AND EMP_NAME != '노옹철';


--  Q4. 
-- 2000년도에 입사한 사원과 부서와 직급이 같은 사원을 조회하시오
-- 사번, 이름, 부서코드, 직급코드, 고용일

SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = ( SELECT DEPT_CODE, JOB_CODE
                                                    FROM EMPLOYEE
                                                    WHERE HIRE_DATE LIKE '00%');


-- Q5.
-- 77년생 여자 사원과 동일한 부서이면서 동일한 사수를 가지고 있는 사원을 조회하시오
-- 사번, 이름, 부서코드, 사수번호, 주민번호, 고용일

SELECT EMP_ID, EMP_NAME, DEPT_CODE, MANAGER_ID, EMP_NO, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, MANAGER_ID) = ( SELECT DEPT_CODE, MANAGER_ID
                                                        FROM EMPLOYEE
                                                        WHERE (SUBSTR(EMP_NO, 1, 2))='77'
                                                        AND (SUBSTR(EMP_NO,8,1))='2' );
                                                        
                                                        
-- Q6. ★
-- 부서별 입사일이 가장 빠른 사원 // 의
-- 사번, 이름, 부서명(NULL이면 '소속없음'), 직급명, 입사일을 조회하고
-- 입사일이 빠른 순 // 으로 조회하시오
-- 단, 퇴사한 직원은 제외하고 조회..

SELECT EMP_ID, EMP_NAME, NVL(DEPT_TITLE, '소속 없음'), JOB_NAME, HIRE_DATE
FROM EMPLOYEE 
LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
JOIN JOB USING (JOB_CODE)

WHERE HIRE_DATE IN (SELECT HIRE_DATE
                                 FROM EMPLOYEE
                                 WHERE ENT_YN = 'N'
                                GROUP BY NVL(DEPT_TITLE, '소속 없음')

ORDER BY HIRE_DATE;

SELECT EMP_ID, EMP_NAME, NVL(DEPT_TITLE, '소속 없음'), JOB_NAME, HIRE_DATE
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
LEFT JOIN JOB USING (JOB_CODE)
WHERE (DEPT_CODE,HIRE
_DATE) IN (
SELECT DEPT_CODE, MIN(HIRE_DATE) FROM EMPLOYEE GROUP BY DEPT_CODE
) AND ENT_YN != 'Y';


-- Q7. ★
-- 직급별 나이가 가장 어린 직원의
-- 사번, 이름, 직급명, 나이, 보너스 포함 연봉을 조회하고
-- 나이순으로 내림차순 정렬하세요
-- 단 연봉은 \124,800,000 으로 출력되게 하세요. (\ : 원 단위 기호)

SELECT EMP_ID, EMP_NAME, JOB_NAME, 
            (EXTRACT (YEAR FROM SYSDATE)) - (EXTRACT(YEAR FROM (TO_DATE (EMP_NO, 'RR')))) AS "나이", 
            SALARY*(1+BONUS)
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE);





            



