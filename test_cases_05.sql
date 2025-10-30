--TEST :  function FNC_CALCULATE_FINE ,  basic checking and function call
select * from loan;
select FNC_CALCULATE_FINE(due_date,return_date) from loan where loan_id=1002;

--TEST : procedure PRC_RETURN_BOOK
set serveroutput on;
execute PRC_RETURN_BOOK(1001,to_date('2025-09-30','YYYY-MM-DD'));
select * from book_copies;
