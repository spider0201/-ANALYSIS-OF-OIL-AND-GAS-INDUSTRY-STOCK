CREATE DATABASE Stock;
USE Stock;
CREATE TABLE Account_Balance (
    account_key NVARCHAR(10),
    account_name NVARCHAR(100),
    sign INT,
    account_type NVARCHAR(10),
    level INT,
    PRIMARY KEY (account_key)
);

CREATE TABLE Account_income (
    account_key NVARCHAR(10),
    account_name NVARCHAR(100),
    sign INT,
    account_type NVARCHAR(10),
    level INT,
    PRIMARY KEY (account_key)
);

CREATE TABLE Account_cashflow (
    account_key NVARCHAR(10),
    account_name NVARCHAR(100),
    sign INT,
    account_type NVARCHAR(10),
    level INT,
    PRIMARY KEY (account_key)
);

CREATE TABLE cashflow (
    account_key NVARCHAR(10),
    End_of_Period BIGINT,
    date DATE,
    stock_name NVARCHAR(100),

);

CREATE TABLE Income (
    account_key NVARCHAR(10),
    End_of_Period BIGINT,
    date DATE,
    stock_name NVARCHAR(100),

);

CREATE TABLE Balance (
    account_key NVARCHAR(10),
    End_of_Period BIGINT,
    date DATE,
    stock_name NVARCHAR(100),

);

CREATE TABLE info_stock (
    symbol NVARCHAR(100),
    organ_name NVARCHAR(100),
    icb_name3 NVARCHAR(100),
    icb_name2 NVARCHAR(100),
    icb_name4 NVARCHAR(100),
    exchange NVARCHAR(10),
    industry NVARCHAR(100),
    company_type NVARCHAR(100),
    no_shareholders BIGINT,
    foreign_percent FLOAT,
    outstanding_share BIGINT,
    issue_share FLOAT,
    established_year INT,
    no_employees INT,
    stock_rating FLOAT,
    delta_in_week FLOAT,
    delta_in_month FLOAT,
    delta_in_year FLOAT,
    short_name NVARCHAR(100),
    website NVARCHAR(100),
    industry_id INT,
    industry_id_v2 INT,
    PRIMARY KEY (symbol)
);
CREATE TABLE history_price (
    date DATE,
    open_price INT,
    high_price INT,
    low_price INT,
    close_price INT,
    volume INT,
    stock_name NVARCHAR(100),

);

