create table books(
book_id int primary key,
title varchar(100),
ISBN varchar(13) unique not null,
no_of_pages int,
publish_year number(4)
);

create table authors(
author_id int primary key,
first_name varchar(50),
last_name varchar(50)
);

create table book_author(
author_id int,
book_id int,
CONSTRAINT pk_composite PRIMARY KEY(author_id,book_id),
CONSTRAINT fk_author FOREIGN KEY(author_id) REFERENCES authors(author_id),
CONSTRAINT fk_book FOREIGN KEY(book_id) REFERENCES books(book_id)
);

create table members(
member_id int primary key,
first_name varchar(50),
last_name varchar(50),
email varchar(100) unique not null,
phone_no varchar(15) not null,
join_date date,
CONSTRAINT chk_phone CHECK(regexp_like(phone_no,'^[0-9]{10}$'))
);

create table book_copies(
copy_id int primary key,
b_id int,
Status char(1) default 'A' NOT NULL,
CONSTRAINT fk_book_id FOREIGN KEY(b_id) REFERENCES books(book_id),
CONSTRAINT chk_status check(status in('A','O','D'))--A:Availabe , O: On loan,D:Damaged
);

create table loan(
loan_id int primary key,
m_id int,--member who borrowed book
copy_id int,--book that is lended
loan_date date,--issue date of book
due_date date,
return_date date,
CONSTRAINT fk_member FOREIGN KEY(m_id) REFERENCES members(member_id),
CONSTRAINT fk_copy FOREIGN KEY(copy_id) REFERENCES book_copies(copy_id),
CONSTRAINT chk_dates CHECK(return_date  IS NULL OR return_date>=loan_date)
);

create table fines(
fine_id int primary key,
l_id int,--loan id
fine_amt number,
fine_date date,--date on which fine was imposed
paid_date date,--date on which it was paid
CONSTRAINT fk_loan FOREIGN KEY(l_id) REFERENCES loan(loan_id)
);

create table audit_log(
log_id int primary key,
table_name varchar(50) NOT NULL,
operation varchar(10) NOT NULL,
old_data varchar(500),
new_data varchar(500),
change_user varchar(100) DEFAULT USER NOT NULL,
change_timestamp date DEFAULT SYSDATE NOT NULL
);
--sequences to automatically get id's
create sequence author_seq START WITH 1 INCREMENT BY 1;
create sequence books_seq START WITH 1 INCREMENT BY 1;
create sequence member_seq START WITH 500 INCREMENT BY 1;
create sequence book_copy_seq START WITH 1 INCREMENT BY 1;
create sequence loans_seq START WITH 1000 INCREMENT BY 1; 
create sequence fines_seq START WITH 100 INCREMENT BY 1; 
create sequence audit_seq START WITH 1 INCREMENT BY 1;
