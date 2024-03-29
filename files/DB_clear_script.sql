USE [u_makrol]
GO
ALTER TABLE [dbo].[Webinars_hist] DROP CONSTRAINT [Webinars_hist_Webinars]
GO
ALTER TABLE [dbo].[Webinars_hist] DROP CONSTRAINT [Webinars_hist_Translator]
GO
ALTER TABLE [dbo].[Webinars_hist] DROP CONSTRAINT [Webinars_hist_Lecturers]
GO
ALTER TABLE [dbo].[Webinars_attendance] DROP CONSTRAINT [Webinars_attendance_Webinars_hist]
GO
ALTER TABLE [dbo].[Webinars_attendance] DROP CONSTRAINT [Webinars_attendance_Customers]
GO
ALTER TABLE [dbo].[Webinars] DROP CONSTRAINT [Webinars_Services]
GO
ALTER TABLE [dbo].[Translator_details] DROP CONSTRAINT [Translator_details_Translator]
GO
ALTER TABLE [dbo].[Translator_details] DROP CONSTRAINT [Translator_details_Languages]
GO
ALTER TABLE [dbo].[Syllabus_details] DROP CONSTRAINT [Syllabus_details_Syllabus]
GO
ALTER TABLE [dbo].[Syllabus_details] DROP CONSTRAINT [Syllabus_details_Subjects]
GO
ALTER TABLE [dbo].[Subjects] DROP CONSTRAINT [Subjects_Lecturers]
GO
ALTER TABLE [dbo].[Studies] DROP CONSTRAINT [Studies_Syllabus]
GO
ALTER TABLE [dbo].[Studies] DROP CONSTRAINT [Studies_Cennik]
GO
ALTER TABLE [dbo].[Single_Studies] DROP CONSTRAINT [Services_Single_Studies]
GO
ALTER TABLE [dbo].[Single_Studies] DROP CONSTRAINT [Lectures_Single_Studies]
GO
ALTER TABLE [dbo].[Orders] DROP CONSTRAINT [Orders_Customers]
GO
ALTER TABLE [dbo].[Order_details] DROP CONSTRAINT [Order_details_Orders]
GO
ALTER TABLE [dbo].[Order_details] DROP CONSTRAINT [Order_details_Cennik]
GO
ALTER TABLE [dbo].[Modules] DROP CONSTRAINT [Modules_Courses]
GO
ALTER TABLE [dbo].[Lectures_attendance] DROP CONSTRAINT [Lectures_details_Customers]
GO
ALTER TABLE [dbo].[Lectures_attendance] DROP CONSTRAINT [Lectures_attendance_Lectures]
GO
ALTER TABLE [dbo].[Lectures] DROP CONSTRAINT [Lectures_Translator]
GO
ALTER TABLE [dbo].[Lectures] DROP CONSTRAINT [Lectures_Studies]
GO
ALTER TABLE [dbo].[Lectures] DROP CONSTRAINT [Lectures_Lecturers]
GO
ALTER TABLE [dbo].[Internships_passed] DROP CONSTRAINT [Internships_passed_Internships]
GO
ALTER TABLE [dbo].[Internships_passed] DROP CONSTRAINT [Internships_passed_Customers]
GO
ALTER TABLE [dbo].[Internships] DROP CONSTRAINT [Internships_Studies]
GO
ALTER TABLE [dbo].[Exams] DROP CONSTRAINT [Exams_Studies]
GO
ALTER TABLE [dbo].[Exams] DROP CONSTRAINT [Exams_Customers]
GO
ALTER TABLE [dbo].[Diplomas] DROP CONSTRAINT [Diplomas_Exams]
GO
ALTER TABLE [dbo].[Courses_hist] DROP CONSTRAINT [Courses_hist_Translator]
GO
ALTER TABLE [dbo].[Courses_hist] DROP CONSTRAINT [Courses_hist_Modules]
GO
ALTER TABLE [dbo].[Courses_hist] DROP CONSTRAINT [Courses_hist_Lecturers]
GO
ALTER TABLE [dbo].[Courses_attendance] DROP CONSTRAINT [Courses_attendance_Customers]
GO
ALTER TABLE [dbo].[Courses_attendance] DROP CONSTRAINT [Courses_attendance_Courses_hist]
GO
ALTER TABLE [dbo].[Courses] DROP CONSTRAINT [Courses_Cennik]
GO
/****** Object:  Table [dbo].[Translator_details]    Script Date: 21.01.2024 22:05:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Translator_details]') AND type in (N'U'))
DROP TABLE [dbo].[Translator_details]
GO
/****** Object:  Table [dbo].[Translator]    Script Date: 21.01.2024 22:05:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Translator]') AND type in (N'U'))
DROP TABLE [dbo].[Translator]
GO
/****** Object:  Table [dbo].[Syllabus_details]    Script Date: 21.01.2024 22:05:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Syllabus_details]') AND type in (N'U'))
DROP TABLE [dbo].[Syllabus_details]
GO
/****** Object:  Table [dbo].[Syllabus]    Script Date: 21.01.2024 22:05:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Syllabus]') AND type in (N'U'))
DROP TABLE [dbo].[Syllabus]
GO
/****** Object:  Table [dbo].[Subjects]    Script Date: 21.01.2024 22:05:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Subjects]') AND type in (N'U'))
DROP TABLE [dbo].[Subjects]
GO
/****** Object:  Table [dbo].[Lecturers]    Script Date: 21.01.2024 22:05:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Lecturers]') AND type in (N'U'))
DROP TABLE [dbo].[Lecturers]
GO
/****** Object:  Table [dbo].[Languages]    Script Date: 21.01.2024 22:05:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Languages]') AND type in (N'U'))
DROP TABLE [dbo].[Languages]
GO
/****** Object:  Table [dbo].[Internships_passed]    Script Date: 21.01.2024 22:05:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Internships_passed]') AND type in (N'U'))
DROP TABLE [dbo].[Internships_passed]
GO
/****** Object:  Table [dbo].[Internships]    Script Date: 21.01.2024 22:05:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Internships]') AND type in (N'U'))
DROP TABLE [dbo].[Internships]
GO
/****** Object:  Table [dbo].[Exams]    Script Date: 21.01.2024 22:05:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Exams]') AND type in (N'U'))
DROP TABLE [dbo].[Exams]
GO
/****** Object:  Table [dbo].[Diplomas]    Script Date: 21.01.2024 22:05:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Diplomas]') AND type in (N'U'))
DROP TABLE [dbo].[Diplomas]
GO
/****** Object:  View [dbo].[AttendanceList]    Script Date: 21.01.2024 22:05:03 ******/
DROP VIEW [dbo].[AttendanceList]
GO
/****** Object:  Table [dbo].[Lectures_attendance]    Script Date: 21.01.2024 22:05:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Lectures_attendance]') AND type in (N'U'))
DROP TABLE [dbo].[Lectures_attendance]
GO
/****** Object:  Table [dbo].[Courses_attendance]    Script Date: 21.01.2024 22:05:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Courses_attendance]') AND type in (N'U'))
DROP TABLE [dbo].[Courses_attendance]
GO
/****** Object:  Table [dbo].[Webinars_attendance]    Script Date: 21.01.2024 22:05:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Webinars_attendance]') AND type in (N'U'))
DROP TABLE [dbo].[Webinars_attendance]
GO
/****** Object:  View [dbo].[FutureEventsAttendance]    Script Date: 21.01.2024 22:05:04 ******/
DROP VIEW [dbo].[FutureEventsAttendance]
GO
/****** Object:  Table [dbo].[Webinars_hist]    Script Date: 21.01.2024 22:05:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Webinars_hist]') AND type in (N'U'))
DROP TABLE [dbo].[Webinars_hist]
GO
/****** Object:  View [dbo].[DebtorsList]    Script Date: 21.01.2024 22:05:04 ******/
DROP VIEW [dbo].[DebtorsList]
GO
/****** Object:  Table [dbo].[Customers]    Script Date: 21.01.2024 22:05:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Customers]') AND type in (N'U'))
DROP TABLE [dbo].[Customers]
GO
/****** Object:  View [dbo].[FinancialRaport]    Script Date: 21.01.2024 22:05:04 ******/
DROP VIEW [dbo].[FinancialRaport]
GO
/****** Object:  Table [dbo].[Single_Studies]    Script Date: 21.01.2024 22:05:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Single_Studies]') AND type in (N'U'))
DROP TABLE [dbo].[Single_Studies]
GO
/****** Object:  UserDefinedFunction [dbo].[GetStudiesSchedule]    Script Date: 21.01.2024 22:05:04 ******/
DROP FUNCTION [dbo].[GetStudiesSchedule]
GO
/****** Object:  UserDefinedFunction [dbo].[GetCustomerSchedule]    Script Date: 21.01.2024 22:05:04 ******/
DROP FUNCTION [dbo].[GetCustomerSchedule]
GO
/****** Object:  Table [dbo].[Services]    Script Date: 21.01.2024 22:05:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Services]') AND type in (N'U'))
DROP TABLE [dbo].[Services]
GO
/****** Object:  Table [dbo].[Order_details]    Script Date: 21.01.2024 22:05:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Order_details]') AND type in (N'U'))
DROP TABLE [dbo].[Order_details]
GO
/****** Object:  Table [dbo].[Modules]    Script Date: 21.01.2024 22:05:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Modules]') AND type in (N'U'))
DROP TABLE [dbo].[Modules]
GO
/****** Object:  Table [dbo].[Lectures]    Script Date: 21.01.2024 22:05:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Lectures]') AND type in (N'U'))
DROP TABLE [dbo].[Lectures]
GO
/****** Object:  Table [dbo].[Courses_hist]    Script Date: 21.01.2024 22:05:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Courses_hist]') AND type in (N'U'))
DROP TABLE [dbo].[Courses_hist]
GO
/****** Object:  Table [dbo].[Courses]    Script Date: 21.01.2024 22:05:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Courses]') AND type in (N'U'))
DROP TABLE [dbo].[Courses]
GO
/****** Object:  Table [dbo].[Webinars]    Script Date: 21.01.2024 22:05:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Webinars]') AND type in (N'U'))
DROP TABLE [dbo].[Webinars]
GO
/****** Object:  Table [dbo].[Studies]    Script Date: 21.01.2024 22:05:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Studies]') AND type in (N'U'))
DROP TABLE [dbo].[Studies]
GO
/****** Object:  UserDefinedFunction [dbo].[GetCustomerCart]    Script Date: 21.01.2024 22:05:04 ******/
DROP FUNCTION [dbo].[GetCustomerCart]
GO
/****** Object:  Table [dbo].[Orders]    Script Date: 21.01.2024 22:05:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Orders]') AND type in (N'U'))
DROP TABLE [dbo].[Orders]
GO