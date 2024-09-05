--DESKTOP-E2R85TO\SA
--sa
--123456

SELECT*
FROM bank_loan_data
where MONTH(issue_date) = 12 


-- tổng số đơn xin vay
SELECT COUNT(id) AS Total_Loan_Applications FROM bank_loan_data

-- MTD đơn xin vay
/*tổng số lượng các đơn đăng ký vay vốn đã được nhận trong khoảng thời gian tính từ đầu tháng đến hiện tại*/
SELECT COUNT(id) AS MTD_Total__Loan_Applications FROM bank_loan_data
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021

-- PMTD đơn xin vay
-- tổng số lượng các đơn đăng ký vay vốn đã được nhận trong khoảng thời gian từ đầu của tháng đến cuối tháng
SELECT COUNT(id) AS PMTD_Total_Loan_Applications FROM bank_loan_data
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021

-- tổng số tiền được tài trợ
SELECT SUM(loan_amount) AS Total_Funded_Amount FROM bank_loan_data

-- MTD tổng số tiền được tài trợ
-- tổng số tiền được tài trợ cho các khoản vay trong tháng 11 năm 2021
SELECT SUM(loan_amount) AS MTD_Total_Funded_Amount FROM bank_loan_data
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021

-- PMTD tổng số tiền được tài trợ
-- tổng số tiền được tài trợ trong khoảng thời gian từ đầu của tháng đến thời điểm hiện tại.
SELECT SUM(loan_amount) AS PMTD_Total_Funded_Amount FROM bank_loan_data
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021

-- tổng số tiền nhận được 
SELECT SUM(total_payment) AS Total_Amount_Collected FROM bank_loan_data

-- MTD tổng số tiền nhận được
SELECT SUM(total_payment)AS MTD_Total_Amount_received from bank_loan_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021

-- PMTD tổng số tiền nhận được
SELECT SUM(total_payment)AS PMTD_Total_Amount_received from bank_loan_data
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021

-- lãi suất trung bình
SELECT AVG(int_rate)*100 AS Avg_Int_Rate FROM bank_loan_data

-- MTD lãi suất trung bình
SELECT ROUND(AVG(int_rate), 4)*100 AS MTD_Avg_Interest_Rate FROM bank_loan_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021

-- PMTD lãi suất trung bình
SELECT ROUND(AVG(int_rate), 4)*100 AS PMTD_Avg_Interest_Rate FROM bank_loan_data
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021

-- Tỷ lệ nợ trên thu nhập dti
SELECT AVG(dti)*100 AS Avg_DTI FROM bank_loan_data

-- MTD Tỷ lệ nợ trên thu nhập dti
SELECT ROUND(AVG(dti), 4)*100 AS MTD_Avg_DTI FROM bank_loan_data
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021

-- PMTD Tỷ lệ nợ trên thu nhập dti
SELECT ROUND(AVG(dti), 4)*100 AS PMTD_Avg_DTI FROM bank_loan_data
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021
--(MTD - PMTD)/PMTD


-- Good Loan issued
-- tỷ lệ cho vay tốt 
SELECT
    (COUNT(CASE WHEN loan_status = 'Fully Paid' OR loan_status = 'Current' THEN id END) * 100.0) / 
	COUNT(id) AS Good_Loan_Percentage
FROM bank_loan_data

-- đơn xin vay tốt
SELECT COUNT(id) AS Good_Loan_Applications FROM bank_loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'

-- số tiền được tài trợ cho khoản vay tốt
SELECT SUM(loan_amount) AS Good_Loan_Funded_amount FROM bank_loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'

-- số tiền cho vay tốt đã nhận được
SELECT SUM(total_payment) AS Good_Loan_amount_received FROM bank_loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current'

-- Bad Loan Percentage
-- tỷ lệ nợ xấu
SELECT
    (COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END) * 100.0) / 
	COUNT(id) AS Bad_Loan_Percentage
FROM bank_loan_data

-- đơn xin vay nợ khó đòi
SELECT COUNT(id) AS Bad_Loan_Applications FROM bank_loan_data
WHERE loan_status = 'Charged Off'

-- số tiền tài trợ cho khoản vay khó đòi
SELECT SUM(loan_amount) AS Bad_Loan_Funded_amount FROM bank_loan_data
WHERE loan_status = 'Charged Off'

-- số tiền cho vay khó đòi đã nhận
SELECT SUM(total_payment) AS Bad_Loan_amount_received FROM bank_loan_data
WHERE loan_status = 'Charged Off'

-- TRÌNH TRẠNG VAY
SELECT
	loan_status,
    COUNT(id) AS LoanCount,
    SUM(total_payment) AS Total_Amount_Received,
    SUM(loan_amount) AS Total_Funded_Amount,
    AVG(int_rate * 100) AS Interest_Rate,
    AVG(dti * 100) AS DTI
FROM bank_loan_data
GROUP BY loan_status

SELECT 
	loan_status, 
	SUM(total_payment) AS MTD_Total_Amount_Received, 
	SUM(loan_amount) AS MTD_Total_Funded_Amount 
FROM bank_loan_data
WHERE MONTH(issue_date) = 12 
GROUP BY loan_status

-- BANK LOAN REPORT | OVERVIEW
-- THÁNG
SELECT 
	MONTH(issue_date) AS Month_Munber, 
	DATENAME(MONTH, issue_date) AS Month_name, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY MONTH(issue_date), DATENAME(MONTH, issue_date)
ORDER BY MONTH(issue_date)

-- ĐỊNH NGÀY
SELECT 
	address_state AS State, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY address_state
ORDER BY address_state

-- KỲ HẠN
SELECT 
	term AS Term, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY term
ORDER BY term

-- THỜI GIAN LÀM VIỆC CỦA NHÂN VIÊN VAY
SELECT 
	emp_length AS Employee_Length, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY emp_length
ORDER BY emp_length

-- DỰ ĐỊNH
SELECT 
	purpose AS PURPOSE, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY purpose
ORDER BY purpose

-- QUYỀN SỞ HỮU NHÀ ĐẤT
SELECT 
	home_ownership AS Home_Ownership, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY home_ownership
ORDER BY home_ownership

-- kết quả khi áp dụng bộ lọc grade = 'A'  theo mục đích
SELECT 
	purpose AS PURPOSE, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
WHERE grade = 'A'
GROUP BY purpose
ORDER BY purpose