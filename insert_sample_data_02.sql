-- =========================================================
-- AITHORS
-- =========================================================
INSERT INTO authors (author_id, first_name, last_name) VALUES (author_seq.NEXTVAL, 'Jane', 'Austen'); 
INSERT INTO authors (author_id, first_name, last_name) VALUES (author_seq.NEXTVAL, 'George', 'Orwell'); 
INSERT INTO authors (author_id, first_name, last_name) VALUES (author_seq.NEXTVAL, 'J.K.', 'Rowling'); 
INSERT INTO authors (author_id, first_name, last_name) VALUES (author_seq.NEXTVAL, 'Stephen', 'King');   
INSERT INTO authors (author_id, first_name, last_name) VALUES (author_seq.NEXTVAL, 'R.K ', 'Narayan'); 
INSERT INTO authors (author_id, first_name, last_name) VALUES (author_seq.NEXTVAL, 'Rabindranath', 'Tagore');
INSERT INTO authors (author_id, first_name, last_name) VALUES (author_seq.NEXTVAL, 'Stephen', 'King');

-- =========================================================
-- BOOKS
-- =========================================================
INSERT INTO books (book_id, title, isbn, no_of_pages, publish_year) VALUES (books_seq.NEXTVAL, '1984', '9780451524935', 328, 1949);
INSERT INTO books (book_id, title, isbn, no_of_pages, publish_year) VALUES (books_seq.NEXTVAL, 'Pride and Prejudice', '9780141439518', 432, 1813);
INSERT INTO books (book_id, title, isbn, no_of_pages, publish_year) VALUES (books_seq.NEXTVAL, 'Animal Farm', '9780451526342', 112, 1945);     
INSERT INTO books (book_id, title, isbn, no_of_pages, publish_year) VALUES (books_seq.NEXTVAL, 'The Shining', '9780385121675', 447, 1977);      
INSERT INTO books (book_id, title, isbn, no_of_pages, publish_year) VALUES (books_seq.NEXTVAL, 'Practical PL/SQL', '9781484218985', 700, 2023);
INSERT INTO books (book_id, title, isbn, no_of_pages, publish_year) VALUES (books_seq.NEXTVAL, 'Chandalika', '9781466947566', 650, 1938);
INSERT INTO books (book_id, title, isbn, no_of_pages, publish_year) VALUES (books_seq.NEXTVAL, 'Malgudi Days', '9788185986173', 700, 1943);


-- =========================================================
-- BOOK AUTHOR-linking books and authors
-- =========================================================
INSERT INTO book_author (author_id, book_id) VALUES (2, 1); -- George Orwell (1984)
INSERT INTO book_author (author_id, book_id) VALUES (1, 2); -- Jane Austen (P&P)
INSERT INTO book_author (author_id, book_id) VALUES (2, 3); -- George Orwell (Animal Farm)
INSERT INTO book_author (author_id, book_id) VALUES (4, 4); -- Stephen King (The Shining)
INSERT INTO book_author (author_id, book_id) VALUES (5, 5); -- Priscilla Smith (PL/SQL)
INSERT INTO book_author (author_id, book_id) VALUES (3, 5); -- J.K. Rowling also contributed(example case -testing : co-ownership of book)
INSERT INTO book_author (author_id, book_id) VALUES (6, 6); -- R.K. Narayan (Malgudi Days)
INSERT INTO book_author (author_id, book_id) VALUES (7, 7); -- Rabindranath Tagore (Chandalika)


-- =========================================================
-- MEMBERS
-- =========================================================
INSERT INTO members (member_id, first_name, last_name, email, phone_no, join_date) VALUES (member_seq.NEXTVAL, 'Amit', 'Kumar', 'amit@test.com', '9876543210',to_date('2024-06-01','YYYY-MM-DD'));--to date: convert string format to a date 
INSERT INTO members (member_id, first_name, last_name, email, phone_no, join_date) VALUES (member_seq.NEXTVAL, 'Smith', 'Jain', 'smit@test.com', '9988776655', to_date('2024-08-15','YYYY-MM-DD')); 
INSERT INTO members (member_id, first_name, last_name, email, phone_no, join_date) VALUES (member_seq.NEXTVAL, 'Alice', 'Cooper', 'alice@test.com', '1122334455', to_date('2023-11-20','YYYY-MM-DD')); 
INSERT INTO members (member_id, first_name, last_name, email, phone_no) VALUES (member_seq.NEXTVAL, 'Seema', 'Singh', 'seema@test.com', '9812092345');
INSERT INTO members VALUES (member_seq.NEXTVAL, 'Kavish', 'Asija', 'kavish@test.com', '1290546700',sysdate);



-- =========================================================
-- BOOK COPIES
-- =========================================================
-- Book ID 1 (1984)
INSERT INTO book_copies (copy_id, b_id, status) VALUES (book_copy_seq.NEXTVAL, 1, 'A'); -- ID 1 (Available)
INSERT INTO book_copies (copy_id, b_id, status) VALUES (book_copy_seq.NEXTVAL, 1, 'O'); -- ID 2 (On Loan)

-- Book ID 2 (Pride and Prejudice)
INSERT INTO book_copies (copy_id, b_id, status) VALUES (book_copy_seq.NEXTVAL, 2, 'A'); -- ID 3 (Available)
INSERT INTO book_copies (copy_id, b_id, status) VALUES (book_copy_seq.NEXTVAL, 2, 'A'); -- ID 4 (Available)

-- Book ID 3 (Animal Farm)
INSERT INTO book_copies (copy_id, b_id, status) VALUES (book_copy_seq.NEXTVAL, 3, 'D'); -- ID 5 (Damaged)

-- Book ID 4 (The Shining)
INSERT INTO book_copies (copy_id, b_id, status) VALUES (book_copy_seq.NEXTVAL, 4, 'O'); -- ID 6 (On Loan)

-- Book ID 6 (Malgudi Days)
INSERT INTO book_copies (copy_id, b_id, status) VALUES (book_copy_seq.NEXTVAL, 6, 'A'); -- ID 7 (Available)
INSERT INTO book_copies (copy_id, b_id, status) VALUES (book_copy_seq.NEXTVAL, 6, 'A'); -- ID 8 (Available)

-- Book ID 7 (Chandalika)
INSERT INTO book_copies (copy_id, b_id, status) VALUES (book_copy_seq.NEXTVAL, 7, 'O'); -- ID 9 (On Loan)


-- =========================================================
-- LOAN
-- =========================================================
---- Loan 1: Smith Jain (Member 501) takes Copy 2 (Pride and Prejudice). ACTIVE LOAN (due date is in future ,return_date IS NULL)
INSERT INTO loan (loan_id, m_id, copy_id, loan_date, due_date, return_date) 
VALUES (loans_seq.NEXTVAL, 501, 2,sysdate,to_date('2025-11-08','YYYY-MM-DD'), NULL); 

---- Loan 2: Kavish Asija (Member 504) takes Copy 4 (The Shining). OVERDUE LOAN (due_date is past,return_date IS NULL)
INSERT INTO loan (loan_id, m_id, copy_id, loan_date, due_date, return_date) 
VALUES (loans_seq.NEXTVAL, 504, 4,to_date('2025-09-01','YYYY-MM-DD'),to_date('2025-09-10','YYYY-MM-DD'),NULL); 

---- Loan 3: Alice Cooper (Member 502) takes Copy 1 (1984). returns Copy 1 LATE (return_date is NOT NULL. return_date is later than due_date.)
INSERT INTO loan (loan_id, m_id, copy_id, loan_date, due_date, return_date) 
VALUES (loans_seq.NEXTVAL, 502, 1,to_date('2025-08-10','YYYY-MM-DD'),to_date('2025-08-20','YYYY-MM-DD'),to_date('2025-08-30','YYYY-MM-DD')); 


-- =========================================================
-- FINES
-- =========================================================
-- Fine 1: Fine on ALICE COOPER(ID : 1002) late return
INSERT INTO fines (fine_id, l_id, fine_amt, fine_date, paid_date) 
VALUES (fines_seq.NEXTVAL, 1002, 5.00, DATE '2025-08-20', NULL);

-- Fine 2: Paid fine for an old loan (just for report testing)
INSERT INTO fines (fine_id, l_id, fine_amt, fine_date, paid_date) 
VALUES (fines_seq.NEXTVAL,1000, 2.50, DATE '2024-05-01', DATE '2024-05-05');


