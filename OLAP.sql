--Tạo bảng dữ liệu dim_account_type
CREATE VIEW dim_account_type AS
SELECT 
    ROW_NUMBER() OVER (ORDER BY account_type) AS account_type_id, -- Tạo ID tự động theo thứ tự
    account_type
FROM (
    SELECT DISTINCT account_type FROM account_balance
    UNION
    SELECT DISTINCT account_type FROM account_income
    UNION
    SELECT DISTINCT account_type FROM account_cashflow
) AS combined_account_types;

--ĐỔ dữ liệu vào bảng dim_account
CREATE TABLE dim_account AS
SELECT 
    ab.account_key,
    ab.account_name,
    ab.sign,
    dat.account_type_id, -- Lấy account_type_id từ dim_account_type
    ab.[level]
FROM account_balance ab
LEFT JOIN dim_account_type dat ON ab.account_type = dat.account_type
UNION ALL
SELECT 
    ai.account_key,
    ai.account_name,
    ai.sign,
    dat.account_type_id, -- Lấy account_type_id từ dim_account_type
    ai.[level]
FROM account_income ai
LEFT JOIN dim_account_type dat ON ai.account_type = dat.account_type
UNION ALL
SELECT 
    ac.account_key,
    ac.account_name,
    ac.sign,
    dat.account_type_id, -- Lấy account_type_id từ dim_account_type
    ac.[level]
FROM account_cashflow ac
LEFT JOIN dim_account_type dat ON ac.account_type = dat.account_type;
--Đổ dữ liệu vào dim_exchange
CREATE VIEW dim_exchange AS 
SELECT 
    ROW_NUMBER() OVER (ORDER BY exchange) AS exchange_id, -- Tạo ID tự động theo thứ tự
    exchange
FROM (
    SELECT DISTINCT exchange FROM  info_stock
    
) AS combined_exchange;
select * from dim_exchange
--Đổ dữ liệu vào dim_company
CREATE view dim_company AS
SELECT 
i.[symbol]
      ,i.[organ_name]
      ,i.[icb_name3]
      ,i.[icb_name2]
      ,i.[icb_name4]
      ,ex.exchange_id
      ,i.[industry]
      ,i.[company_type]
      ,i.[no_shareholders]
      ,i.[foreign_percent]
      ,i.[outstanding_share]
      ,i.[issue_share]
      ,i.[established_year]
      ,i.[no_employees]
      ,i.[stock_rating]
      ,i.[delta_in_week]
      ,i.[delta_in_month]
      ,i.[delta_in_year]
      ,i.[short_name]
      ,i.[website]
      ,i.[industry_id]
      ,i.[industry_id_v2]
FROM info_stock as i
LEFT JOIN dim_exchange ex ON ex.exchange = i.exchange;

--Đổ dữ liệu vào fact_price
CREATE VIEW fact_price as
select * from history_price
--Đổ dữ liệu vào fact_financialaccount
CREATE VIEW fact_financialaccount as
select * from Balance 
UNION
select * from Income
UNION
select * from cashflow

select * from fact_financialaccount