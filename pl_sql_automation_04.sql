-- =========================================================
-- 1. FUNCTION: FNC_CALCULATE_FINE
-- Goal: Calculate the fine amount based on the due date and return date.
-- Rate: ?5.00 per day late.
-- =========================================================
  set serveroutput on;
  create or replace function FNC_CALCULATE_FINE(f_due_date date,f_return_date date)
  RETURN number--using number to get decimal values
  IS 
  days_cnt int;
  fine_amt constant number:=5;
  fine_total number:=0;
  BEGIN
  if(f_return_date is NOT NULL and f_return_date>f_due_date) then
  days_cnt:=trunc(f_return_date)-trunc(f_due_date);
  fine_total:=fine_amt*days_cnt;
  end if;
  return fine_total;
  EXCEPTION
  when others then
  return 0;-- 0 means there is an error
  END;
  /



-- =========================================================
-- 2. PROCEDURE: PRC_RETURN_BOOK
-- Goal: Process a book return, update loan status, update copy status, and assess fines.
-- =========================================================
create or replace procedure PRC_RETURN_BOOK(p_loan_id in int,p_return_date in date)
IS
p_due_date loan.due_date%type;
p_m_id int;
p_copy_id int;
fine_cost number;
BEGIN
  BEGIN
--get due date
select m_id,copy_id,due_date into p_m_id,p_copy_id,p_due_date from loan where loan_id=p_loan_id and return_date is NULL;
EXCEPTION
--no data found means loan id doesnot exist
WHEN 
  NO_DATA_FOUND then
    RAISE_APPLICATION_ERROR(-20001,'LOAN ID '|| p_loan_id || 'Not found');
  END;
--calculate fine amt- calling function
fine_cost:=FNC_CALCULATE_FINE(p_due_date,p_return_date);
--update return date into loan table
update loan set return_date=p_return_date where loan_id=p_loan_id;
--assess and impose fines
if(fine_cost>0) then
insert into fines values(fines_seq.NEXTVAL,p_loan_id,fine_cost,p_return_date,NULL);
end if;
--update copy status O: on loan to A: available
update book_copies set status='A' where copy_id=(select copy_id from loan where loan_id=p_loan_id);
EXCEPTION 
WHEN OTHERS THEN
RAISE_APPLICATION_ERROR(-20002,'Error processing return for loan id '|| p_loan_id || '-not an acitvie loan');
END;
/

-- =========================================================
-- 3. PROCEDURE: PRC_CHECKOUT_BOOK
-- Goal: Insert new loan record and update book_copies status to 'O'.
-- =========================================================
set serveroutput on;
create or replace procedure PRC_CHECKOUT_BOOK(p_member_id in int,p_book_id in int,p_due_date date)
as
p_copy_id book_copies.copy_id%type;
BEGIN
  BEGIN
    --check availability: fetch 1st available(A) copy_id from all the copies of a book
    select copy_id into p_copy_id from (select copy_id from book_copies where b_id=p_book_id and status='A' order by copy_id asc) where rownum=1;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN RAISE_APPLICATION_ERROR(-20008,'Book_id ' ||  p_book_id || ' is not available');
  END;
    INSERT INTO loan (loan_id, m_id, copy_id, loan_date, due_date, return_date)
    VALUES (loans_seq.NEXTVAL, p_member_id, p_copy_id, SYSDATE, p_due_date, NULL);
    update book_copies set status='O' where copy_id=p_copy_id;
    --EXCEPTION
    --WHEN OTHERS THEN
    --   ROLLBACK;
    --  RAISE_APPLICATION_ERROR(-20009, 'Error during title-based checkout.');
END;
/
select * from books;
EXECUTE PRC_CHECKOUT_BOOK(502,6,to_date('10-11-2025','DD-MM-YYYY'));
EXECUTE PRC_CHECKOUT_BOOK(501,3,to_date('10-11-2025','DD-MM-YYYY'));
select * from loan;

-- =========================================================
-- 4. PROCEDURE: PRC_OVERDUE_REMINDER 
-- Goal: Iterate through all overdue loans and print a reminder for the admin.
-- Demonstrates Explicit Cursor knowledge (Declaration, Open, Fetch, Close).
-- ========================================================
create or replace procedure PRC_OVERDUE_REMINDER
as
--CREATE EXPLICIT CURSOR
cursor overdue_loan_report is
select m.first_name || ' ' || m.last_name as full_name,
b.title,
m.email,
trunc(sysdate)-trunc(l.due_date) as days_late
from loan l 
JOIN members m on l.m_id=m.member_id
JOIN book_copies bc on l.copy_id=bc.copy_id
JOIN books b on b.book_id=bc.b_id
WHERE return_date IS NULL--active loan
AND due_date<sysdate
order by l.due_date;
--declare variables
overdue_loans_rec overdue_loan_report%rowtype;
v_count int;
BEGIN
DBMS_OUTPUT.PUT_LINE('--- OVERDUE LOANS REPORT (' || TO_CHAR(SYSDATE, 'YYYY-MM-DD') || ') ---');
--OPEN CURSOR
OPEN overdue_loan_report;
LOOP
FETCH overdue_loan_report into overdue_loans_rec;
EXIT WHEN overdue_loan_report%NOTFOUND;
  DBMS_OUTPUT.PUT_LINE('NAME : '|| overdue_loans_rec.full_name);
  DBMS_OUTPUT.PUT_LINE('EMAIL : '|| overdue_loans_rec.email);
  DBMS_OUTPUT.PUT_LINE('BOOK ON LOAN : '|| overdue_loans_rec.title);
  DBMS_OUTPUT.PUT_LINE('DAYE LATE : '|| overdue_loans_rec.days_late);
  DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
  v_count := v_count + 1;
END LOOP;
--close cursor
CLOSE overdue_loan_report;
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('TOTAL OVERDUE LOANS FOUND: ' || v_count);
    
EXCEPTION
  WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20000,'NO DATA FOUND');
   WHEN OTHERS THEN
        IF overdue_loan_report%ISOPEN THEN CLOSE overdue_loan_report; END IF;
        RAISE_APPLICATION_ERROR(-20006, 'Error running overdue reminder report.');
END;
/


-- =========================================================
-- 5. TRIGGER 1: TRG_LOAN_AUDIT (Audit Log on LOAN table changes)
-- Goal: Log every UPDATE or DELETE operation on the LOAN table.
-- =========================================================
create or replace trigger TRG_LOAN_AUDIT
before update or delete on loan
FOR EACH ROW
DECLARE

BEGIN

END;
/




-- =========================================================
-- 6. TRIGGER 2: TRG_PREVENT_LOAN_UNAVAILABLE (Inventory Safety Net)
-- Goal: Prevent a loan from being created if the book copy is not 'A' (Available).
-- =========================================================