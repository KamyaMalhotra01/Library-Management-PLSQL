-- =========================================================
-- 03_basic_queries_and_views.sql
-- Core Reporting Queries and Views (Day 1 Finalization)
-- This script demonstrates advanced SELECT, JOIN, and GROUP BY skills.
-- =========================================================

-- =========================================================
-- 1. VIEWS: V_BOOK_AVAILABILITY
-- Goal: Calculate real-time inventory status for all book titles.
-- Uses JOIN, GROUP BY, and Conditional Aggregation (SUM with CASE).
-- =========================================================
create or replace view V_BOOK_AVAILABILITY as 
SELECT b.book_id,b.title,count(bc.b_id) as total_count,sum(case when bc.status='A' then 1 else 0 end) as available_copies ,sum(case when bc.status='O' then 1 else 0 end) as on_loan__copies,sum(case when bc.status='D' then 1 else 0 end) as damaged_copies 
FROM book_copies bc join books b on bc.b_id=b.book_id group by b.book_id,b.title;

select * from V_BOOK_AVAILABILITY;


-- =========================================================
-- 2. QUERY: Active Overdue Loans Report
-- Goal: Find all loans that are currently past their due date (due_date in the past) 
-- and have not been returned (return_date IS NULL).
-- =========================================================
select l.loan_id,l.m_id,m.first_name || ' ' || m.last_name,b.title,l.due_date,
trunc(sysdate)-trunc(due_date) as overdue_days
from loan l join members m
on l.m_id=m.member_id
join book_copies bc
on bc.copy_id=l.copy_id
join books b
on b.book_id=bc.b_id
where l.due_date>l.return_date and l.return_date is NULL
order by overdue_days;


-- =========================================================
-- 3. QUERY: Top Borrowers Report
-- Goal: Identify the member who has taken the most loans (demonstrates GROUP BY).
-- =========================================================
select m.first_name|| ' ' || m.last_name as full_name ,count(l.m_id) as books_issued
from loan l join members m
on m.member_id=l.m_id
group by l.m_id,m.first_name,m.last_name
order by books_issued desc;



-- =========================================================
-- 4. QUERY: Unpaid Fines Report
-- Goal: List all members who currently owe the library money (unpaid fines).
-- Uses JOIN across three tables (Members -> Loan -> Fines).
-- =========================================================
select l.loan_id,m.member_id,m.first_name || ' ' || m.last_name,b.title,f.fine_amt,f.fine_date,l.due_date
from fines f join loan l
on l.loan_id=f.l_id
join members m 
on l.m_id=m.member_id
join book_copies bc
on bc.copy_id=l.copy_id
join books b
on b.book_id=bc.b_id
where f.paid_date IS NULL--this means fine are not paid yet
order by f.fine_amt;


-- =========================================================
-- 5. QUERY: Co-Author Analysis
-- Goal: List all books that have more than one author (demonstrates Many-to-Many join).
-- =========================================================
select b.title,count(ba.book_id) from books b 
join book_author ba 
on ba.book_id=b.book_id
group by b.book_id,b.title
having count(ba.book_id)>1; -- Filter for books with more than one author
--if book_author has more same book_id more than once, it means there is co-ownership of book with multiple authors
