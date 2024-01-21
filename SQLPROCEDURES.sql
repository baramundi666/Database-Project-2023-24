-- Create procedure to add a customer
CREATE PROCEDURE AddCustomer
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @Balance MONEY,
    @Email VARCHAR(50),
    @City VARCHAR(50),
    @Address VARCHAR(50),
    @PostalCode VARCHAR(50)
AS
BEGIN
    -- Insert the customer into the Customers table
    INSERT INTO Customers (FirstName, LastName, Balance, Email, City, Address, PostalCode)
    VALUES (@FirstName, @LastName, @Balance, @Email, @City, @Address, @PostalCode);
END;

-- Example of calling the AddCustomer procedure
EXEC AddCustomer 'John', 'Doe', 100.00, 'john.doe@example.com', 'City', 'Address', '12345';


-- Create procedure to add a lecturer
CREATE PROCEDURE AddLecturer
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50)
AS
BEGIN
    -- Insert the lecturer into the Lecturers table
    INSERT INTO Lecturers (FirstName, LastName)
    VALUES (@FirstName, @LastName);
END;

-- Example of calling the AddLecturer procedure
EXEC AddLecturer 'Mateusz', 'Kr�l';

-- Create procedure to add a translator
CREATE PROCEDURE AddTranslator
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50)
AS
BEGIN
    -- Insert the translator into the Translator table
    INSERT INTO Translator (FirstName, LastName)
    VALUES (@FirstName, @LastName);
END;

-- Example of calling the AddTranslator procedure
EXEC AddTranslator 'John', 'Smith';


CREATE PROCEDURE AddWebinar
    @WebinarName varchar(50),
    @StartDate datetime,
    @EndDate datetime,
    @PriceInAdvance money,
    @PriceWhole money,
    @LecturerID int,
    @TranslatorID int,
    @LinkNagranie varchar(50) = NULL
AS
BEGIN
    -- Begin a new transaction
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Check if LecturerID exists
        IF NOT EXISTS (SELECT 1 FROM Lecturers WHERE LecturerID = @LecturerID)
        BEGIN
            THROW 50002, 'Lecturer with provided ID does not exist.', 1;
        END

        -- Check if TranslatorID exists
        IF NOT EXISTS (SELECT 1 FROM Translator WHERE TranslatorID = @TranslatorID)
        BEGIN
            THROW 50003, 'Translator with provided ID does not exist.', 1;
        END

		SET IDENTITY_INSERT Webinars ON

        -- Declare a variable to store the generated ServiceID		
		DECLARE @NewServiceID INT;
		SELECT @NewServiceID = ISNULL(MAX(ServiceID),-3) +4 FROM Webinars;

		-- Insert into Services table
        INSERT INTO Services (ServiceID, PriceInAdvance, PriceWhole)
        VALUES (@NewServiceID, @PriceInAdvance, @PriceWhole);

		-- Insert into Webinars table to get a unique ServiceID
        INSERT INTO Webinars (ServiceID,WebinarName, StartDate, EndDate, PriceInAdvance, PriceWhole)
        VALUES (@NewServiceID,@WebinarName, @StartDate, @EndDate, @PriceInAdvance, @PriceWhole);

        -- Insert into Webinars_hist table
        INSERT INTO Webinars_hist (ServiceID, LecturerID, TranslatorID, StartDate, EndDate, LinkNagranie)
        VALUES (@NewServiceID, @LecturerID, @TranslatorID, @StartDate, @EndDate, @LinkNagranie);
		SET IDENTITY_INSERT Webinars OFF

        -- Commit the transaction
        COMMIT;
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error
        ROLLBACK;

        -- Re-throw the error
        THROW;
    END CATCH;
END;



BEGIN TRY
    EXEC AddWebinar
        'Advanced SQL Techniques3',
        '2023-02-01',
        '2023-02-10',
        70.00,
        110.00,
        1,
        1,
        'https://example.com/recordings/advanced-sql';
    PRINT 'Webinar added successfully.';
END TRY
BEGIN CATCH
    PRINT 'Error: ' + ERROR_MESSAGE();
END CATCH;


CREATE PROCEDURE AddCourse
    @CourseName varchar(50),
    @Type varchar(20),
    @StartDate datetime,
    @EndDate datetime,
    @PriceInAdvance money,
    @PriceWhole money,
    @Limit int = NULL
AS
BEGIN
    -- Begin a new transaction
    BEGIN TRANSACTION;

    BEGIN TRY
		SET IDENTITY_INSERT Courses ON
        
        -- Declare a variable to store the generated ServiceID
        DECLARE @NewServiceID INT;
        SELECT @NewServiceID = ISNULL(MAX(ServiceID),-1) +4 from Courses;

		-- Insert into Services table
        INSERT INTO Services (ServiceID,PriceInAdvance, PriceWhole)
        VALUES (@NewServiceID,@PriceInAdvance, @PriceWhole);


        -- Insert into Courses table
        INSERT INTO Courses (ServiceID, CourseName, Type, StartDate, EndDate, PriceInAdvance, PriceWhole, Limit)
        VALUES (@NewServiceID, @CourseName, @Type, @StartDate, @EndDate, @PriceInAdvance, @PriceWhole, @Limit);

		SET IDENTITY_INSERT Courses OFF

        -- Commit the transaction
        COMMIT;
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error
        ROLLBACK;

        -- Re-throw the error
        THROW;
    END CATCH;
END;


-- Example values for parameters
DECLARE @CourseName varchar(50) = 'SQL Basics';
DECLARE @Type varchar(20) = 'Online';
DECLARE @StartDate datetime = '2024-01-21';
DECLARE @EndDate datetime = '2024-02-21';
DECLARE @PriceInAdvance money = 50.00;
DECLARE @PriceWhole money = 100.00;
DECLARE @Limit int = 50; -- You can adjust this based on your requirements

-- Execute the AddCourse procedure
EXEC AddCourse 
    @CourseName,
    @Type,
    @StartDate,
    @EndDate,
    @PriceInAdvance,
    @PriceWhole,
    @Limit;



CREATE PROCEDURE AddModule
    @ServiceID int,
    @ModuleName varchar(50)
AS
BEGIN
    -- Begin a new transaction
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Check if the ServiceID exists in Courses table
        IF NOT EXISTS (SELECT 1 FROM Courses WHERE ServiceID = @ServiceID)
        BEGIN
            THROW 50001, 'Course with provided ServiceID does not exist.', 1;
        END

        -- Insert into Modules table
        INSERT INTO Modules (ServiceID, ModuleName)
        VALUES (@ServiceID, @ModuleName);

        -- Commit the transaction
        COMMIT;
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error
        ROLLBACK;

        -- Re-throw the error
        THROW;
    END CATCH;
END;

-- Example values for parameters
DECLARE @ServiceIDToAddModuleTo int = 7; -- Replace with the actual ServiceID
DECLARE @ModuleNameToAdd varchar(50) = 'Module1TEST';

-- Execute the AddModule procedure
EXEC AddModule
    @ServiceIDToAddModuleTo,
    @ModuleNameToAdd;



Select dbo.CheckClassDates(1,'2024-01-01','2024-01-30')
CREATE PROCEDURE AddClassCourse
    @ModuleID int,
    @LecturerID int,
    @TranslatorID int,
    @StartDate datetime,
    @EndDate datetime,
	@Type varchar(10),
    @LinkNagranie varchar(50) = NULL
AS
BEGIN
    -- Begin a new transaction
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Check if ModuleID exists in Modules table
        IF NOT EXISTS (SELECT 1 FROM Modules WHERE ModuleID = @ModuleID)
        BEGIN
            THROW 50001, 'Module with provided ModuleID does not exist.', 1;
        END

        -- Check if LecturerID exists in Lecturers table
        IF NOT EXISTS (SELECT 1 FROM Lecturers WHERE LecturerID = @LecturerID)
        BEGIN
            THROW 50002, 'Lecturer with provided LecturerID does not exist.', 1;
        END

        -- Check if TranslatorID exists in Translator table
        IF NOT EXISTS (SELECT 1 FROM Translator WHERE TranslatorID = @TranslatorID)
        BEGIN
            THROW 50003, 'Translator with provided TranslatorID does not exist.', 1;
        END
		Declare @checkClassDates bit 
		Select @checkClassDates =  dbo.CheckClassDates(@ModuleID, @StartDate, @EndDate)
        -- Check if StartDate and EndDate are between the StartDate and EndDate of the associated course
        IF   @checkClassDates = 0 
        BEGIN
            THROW 50004, 'Class dates are not within the valid range for the associated course.', 1;
        END

        -- Insert into Courses_hist table
        INSERT INTO Courses_hist (ModuleID, LecturerID, TranslatorID, StartDate, EndDate, Type, LinkNagranie)
        VALUES (@ModuleID, @LecturerID, @TranslatorID, @StartDate, @EndDate, @Type, @LinkNagranie);

        -- Commit the transaction
        COMMIT;
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error
        ROLLBACK;

        -- Re-throw the error
        THROW;
    END CATCH;
END;


-- Example values for parameters
DECLARE @ModuleIDToAddClassTo int = 1; -- Replace with the actual ModuleID
DECLARE @LecturerIDForClass int = 1; -- Replace with the actual LecturerID
DECLARE @TranslatorIDForClass int = 1; -- Replace with the actual TranslatorID
DECLARE @StartDateOfClass datetime = '2024-02-01T10:00:00'; -- 1st February 2024, 10 AM
DECLARE @EndDateOfClass datetime = '2024-02-01T11:00:00'; -- 1st February 2024, 11 AM
DECLARE @Type varchar(10) = 'Stationary'; --
DECLARE @LinkNagranieForClass varchar(50) = 'Link to Recording (optional)';

-- Execute the AddClassCourse procedure
EXEC AddClassCourse
    @ModuleIDToAddClassTo,
    @LecturerIDForClass,
    @TranslatorIDForClass,
    @StartDateOfClass,
    @EndDateOfClass,
	@Type,
    @LinkNagranieForClass;



CREATE PROCEDURE AddLanguage
    @LanguageName varchar(50)
AS
BEGIN
    -- Begin a new transaction
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Check if the language already exists
        IF EXISTS (SELECT 1 FROM Languages WHERE LanguageName = @LanguageName)
        BEGIN
            THROW 50001, 'Language with the provided name already exists.', 1;
        END

        -- Insert into Languages table
        INSERT INTO Languages (LanguageName)
        VALUES (@LanguageName);

        -- Commit the transaction
        COMMIT;
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error
        ROLLBACK;

        -- Re-throw the error
        THROW;
    END CATCH;
END;

SELECT * from Languages

CREATE PROCEDURE AddTranslatorLanguage
    @TranslatorID int,
    @LanguageID int
AS
BEGIN
    -- Begin a new transaction
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Check if the TranslatorID exists
        IF NOT EXISTS (SELECT 1 FROM Translator WHERE TranslatorID = @TranslatorID)
        BEGIN
            THROW 50001, 'Translator with the provided ID does not exist.', 1;
        END

        -- Check if the LanguageID exists
        IF NOT EXISTS (SELECT 1 FROM Languages WHERE LanguageID = @LanguageID)
        BEGIN
            THROW 50002, 'Language with the provided ID does not exist.', 1;
        END

        -- Check if the combination of TranslatorID and LanguageID already exists
        IF EXISTS (SELECT 1 FROM Translator_details WHERE TranslatorID = @TranslatorID AND LanguageID = @LanguageID)
        BEGIN
            THROW 50003, 'Translator already has the specified language.', 1;
        END

        -- Insert into Translator_details table
        INSERT INTO Translator_details (TranslatorID, LanguageID)
        VALUES (@TranslatorID, @LanguageID);

        -- Commit the transaction
        COMMIT;
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error
        ROLLBACK;

        -- Re-throw the error
        THROW;
    END CATCH;
END;


-- Example: Add a record for TranslatorID = 1 and LanguageID = 2
EXEC AddTranslatorLanguage @TranslatorID = 1, @LanguageID = 2;

CREATE PROCEDURE AddSubject
    @LecturerID int,
    @SubjectName varchar(50),
    @SubjectDescription varchar(200),
    @Hours int,
    @Assessment varchar(30)
AS
BEGIN
    -- Begin a new transaction
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Check if the LecturerID exists
        IF NOT EXISTS (SELECT 1 FROM Lecturers WHERE LecturerID = @LecturerID)
        BEGIN
            THROW 50001, 'Lecturer with the provided ID does not exist.', 1;
        END

        -- Insert into Subjects table
        INSERT INTO Subjects (LecturerID, SubjectName, SubjectDescription, Hours, Assessment)
        VALUES (@LecturerID, @SubjectName, @SubjectDescription, @Hours, @Assessment);

        -- Commit the transaction
        COMMIT;
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error
        ROLLBACK;

        -- Re-throw the error
        THROW;
    END CATCH;
END;


-- Example: Add a subject with LecturerID = 1
EXEC AddSubject @LecturerID = 1, @SubjectName = 'Mathematics', @SubjectDescription = 'Introduction to Mathematics', @Hours = 3, @Assessment = 'Exam';
select * from Subjects

CREATE PROCEDURE AddSyllabus
    @SyllabusName varchar(50)
AS
BEGIN
    -- Begin a new transaction
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Check if the Syllabus already exists
        IF EXISTS (SELECT 1 FROM Syllabus WHERE SyllabusName = @SyllabusName)
        BEGIN
            THROW 50001, 'Syllabus with the provided name already exists.', 1;
        END

        -- Insert into Syllabus table
        INSERT INTO Syllabus (SyllabusName)
        VALUES (@SyllabusName);

        -- Commit the transaction
        COMMIT;
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error
        ROLLBACK;

        -- Re-throw the error
        THROW;
    END CATCH;
END;


CREATE PROCEDURE AddSyllabusDetails
    @SyllabusID int,
    @SubjectID int
AS
BEGIN
    -- Begin a new transaction
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Check if the SyllabusID exists
        IF NOT EXISTS (SELECT 1 FROM Syllabus WHERE SyllabusID = @SyllabusID)
        BEGIN
            THROW 50001, 'Syllabus with the provided ID does not exist.', 1;
        END

        -- Check if the SubjectID exists
        IF NOT EXISTS (SELECT 1 FROM Subjects WHERE SubjectID = @SubjectID)
        BEGIN
            THROW 50002, 'Subject with the provided ID does not exist.', 1;
        END

        -- Check if the combination of SyllabusID and SubjectID already exists
        IF EXISTS (SELECT 1 FROM Syllabus_details WHERE SyllabusID = @SyllabusID AND SubjectID = @SubjectID)
        BEGIN
            THROW 50003, 'Subject is already associated with the specified syllabus.', 1;
        END

        -- Insert into Syllabus_details table
        INSERT INTO Syllabus_details (SyllabusID, SubjectID)
        VALUES (@SyllabusID, @SubjectID);

        -- Commit the transaction
        COMMIT;
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error
        ROLLBACK;

        -- Re-throw the error
        THROW;
    END CATCH;
END;


-- Example: Add a record for SyllabusID = 1 and SubjectID = 1
EXEC AddSyllabusDetails @SyllabusID = 1, @SubjectID = 4;

CREATE PROCEDURE AddStudies
    @SyllabusID int,
    @Major varchar(50),
    @StartDate datetime,
    @EndDate datetime,
    @PriceInAdvance money,
    @PriceWhole money,
    @Limit int
AS
BEGIN
    -- Begin a new transaction
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Check if the SyllabusID exists
        IF NOT EXISTS (SELECT 1 FROM Syllabus WHERE SyllabusID = @SyllabusID)
        BEGIN
            THROW 50001, 'Syllabus with the provided ID does not exist.', 1;
        END
		SET IDENTITY_INSERT Studies ON
        -- Insert into Services table to get a unique ServiceID
        DECLARE @NewServiceID INT;
        SELECT @NewServiceID = ISNULL(MAX(ServiceID), -2) + 4 FROM Studies;

        INSERT INTO Services (ServiceID, PriceInAdvance, PriceWhole)
        VALUES (@NewServiceID, @PriceInAdvance, @PriceWhole);

        -- Insert into Studies table
        INSERT INTO Studies (ServiceID, SyllabusID, Major, StartDate, EndDate, PriceInAdvance, PriceWhole, Limit)
        VALUES (@NewServiceID, @SyllabusID, @Major, @StartDate, @EndDate, @PriceInAdvance, @PriceWhole, @Limit);

		SET IDENTITY_INSERT Studies OFF

        -- Commit the transaction
        COMMIT;
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error
        ROLLBACK;

        -- Re-throw the error
        THROW;
    END CATCH;
END;

-- Example: Add a study with SyllabusID = 1, Major = 'Computer Science', etc.
EXEC AddStudies @SyllabusID = 1, @Major = 'Computer Science AGH', @StartDate = '2024-02-01', @EndDate = '2026-06-01', @PriceInAdvance = 1000.00, @PriceWhole = 2000.00, @Limit = 50;





-- Create a procedure to add a lecture
CREATE PROCEDURE AddLecture
    @LecturerID int,
    @TranslatorID int,
    @ServiceID int,
    @Type varchar(20),
    @Language varchar(50),
    @StartDate datetime,
    @EndDate datetime,
    @Limit int,
    @LinkNagranie varchar(50) = NULL
AS
BEGIN
    -- Begin a new transaction
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Check if the LecturerID exists
        IF NOT EXISTS (SELECT 1 FROM Lecturers WHERE LecturerID = @LecturerID)
        BEGIN
            THROW 50001, 'Lecturer with the provided ID does not exist.', 1;
        END

        -- Check if the TranslatorID exists
        IF NOT EXISTS (SELECT 1 FROM Translator WHERE TranslatorID = @TranslatorID)
        BEGIN
            THROW 50002, 'Translator with the provided ID does not exist.', 1;
        END

        -- Check if the ServiceID exists
        IF NOT EXISTS (SELECT 1 FROM Services WHERE ServiceID = @ServiceID)
        BEGIN
            THROW 50003, 'Service with the provided ID does not exist.', 1;
        END

        -- Check if the Language is provided and follows the specified check
        IF NOT EXISTS (SELECT 1 FROM Languages WHERE LanguageName = @Language)
        BEGIN
            THROW 50004, 'provvided language doesnt exist.', 1;
        END
		Declare  @checkDates bit
		SELECT @checkDates = dbo.CheckLectureDates(@ServiceID, @StartDate, @EndDate)
        -- Check if lecture dates correspond to study dates
        IF  @checkDates = 0
        BEGIN
            THROW 50005, 'Lecture dates do not correspond to study dates.', 1;
        END

		IF @Limit IS NOT NULL AND EXISTS (
            SELECT 1
            FROM Studies s
            INNER JOIN Lectures l ON s.ServiceID = l.ServiceID
            WHERE l.LectureID = @ServiceID
              AND @Limit < s.Limit
        )
        BEGIN
            THROW 50006, 'Limit should be greater than or equal to the limit of connected studies.', 1;
        END

        -- Insert into Lectures table
        INSERT INTO Lectures (LecturerID, TranslatorID, ServiceID, Type, Language, StartDate, EndDate, Limit, LinkNagranie)
        VALUES (@LecturerID, @TranslatorID, @ServiceID, @Type, @Language, @StartDate, @EndDate, @Limit, @LinkNagranie);

        -- Commit the transaction
        COMMIT;
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error
        ROLLBACK;

        -- Re-throw the error
        THROW;
    END CATCH;
END;


-- Example: Add a lecture
EXEC AddLecture
    @LecturerID = 1,
    @TranslatorID = 1,
    @ServiceID = 2,
    @Type = 'Online',
    @Language = 'English',
    @StartDate = '2024-02-01 10:00:00',
    @EndDate = '2024-02-01 11:00:00',
    @Limit = 100,
    @LinkNagranie = 'https://example.com/lecture1';



-- Create a procedure to add a Single_Studies record
CREATE PROCEDURE AddSingleStudies
    @LectureID int,
    @Major varchar(50),
    @Type varchar(20),
    @Limit int = NULL,
    @PriceInAdvance money,
    @PriceWhole money
AS
BEGIN
    -- Begin a new transaction
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Check if the LectureID exists
        IF NOT EXISTS (SELECT 1 FROM Lectures WHERE LectureID = @LectureID)
        BEGIN
            THROW 50001, 'Lecture with the provided ID does not exist.', 1;
        END

        -- Check the limit for Single_Studies using the function
        IF dbo.CheckLimitForSingleStudies(@LectureID, @Limit) = 0
        BEGIN
            THROW 50002, 'Invalid limit for Single_Studies.', 1;
        END

        -- Insert into Services table to get a unique ServiceID
		SET IDENTITY_INSERT Single_Studies ON
        DECLARE @NewServiceID INT;
        SELECT @NewServiceID = ISNULL(MAX(ServiceID), 0) + 4 FROM Single_Studies;

        INSERT INTO Services (ServiceID, PriceInAdvance, PriceWhole)
        VALUES (@NewServiceID, @PriceInAdvance, @PriceWhole);

        -- Insert into Single_Studies table
        INSERT INTO Single_Studies (ServiceID, LectureID, Major, Type, Limit, PriceInAdvance, PriceWhole)
        VALUES (@NewServiceID, @LectureID, @Major, @Type, @Limit, @PriceInAdvance, @PriceWhole);
		SET IDENTITY_INSERT Single_Studies OFF

        -- Commit the transaction
        COMMIT;
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error
        ROLLBACK;

        -- Re-throw the error
        THROW;
    END CATCH;
END;

-- Example EXEC statement for AddSingleStudies procedure
EXEC AddSingleStudies
    @LectureID = 3, -- Replace with a valid LectureID from your database
    @Major = 'Computer Science',
    @Type = 'Online',
    @Limit = 20, -- Replace with the desired limit (or set to NULL for no limit)
    @PriceInAdvance = 100.00,
    @PriceWhole = 200.00;


-- Create a procedure to add an Internship
CREATE PROCEDURE AddInternship
    @ServiceID int,
    @InternshipName varchar(200),
    @InternshipDescription varchar(200),
    @StartDate datetime,
    @EndDate datetime
AS
BEGIN
    -- Begin a new transaction
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Check if the ServiceID exists
        IF NOT EXISTS (SELECT 1 FROM Studies WHERE ServiceID = @ServiceID)
        BEGIN
            THROW 50001, 'Service with the provided ID does not exist.', 1;
        END

        -- Check if the StartDate and EndDate lie within the boundaries of Studies
        IF NOT EXISTS (
            SELECT 1
            FROM Studies
            WHERE ServiceID = @ServiceID
              AND @StartDate >= StartDate
              AND @EndDate <= EndDate
        )
        BEGIN
            THROW 50002, 'Invalid StartDate or EndDate for the Internship.', 1;
        END

        -- Insert into Internships table
        INSERT INTO Internships (ServiceID, InternshipName, InternshipDescription, StartDate, EndDate)
        VALUES (@ServiceID, @InternshipName, @InternshipDescription, @StartDate, @EndDate);

        -- Commit the transaction
        COMMIT;
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error
        ROLLBACK;

        -- Re-throw the error
        THROW;
    END CATCH;
END;

-- Example EXEC statement for AddInternship procedure
EXEC AddInternship
    @ServiceID = 2, -- Replace with a valid ServiceID from your database
    @InternshipName = 'Software Development Internship',
    @InternshipDescription = 'A hands-on internship in software development.',
    @StartDate = '2024-02-01T10:00:00', -- Replace with the desired StartDate
    @EndDate = '2024-02-29T17:00:00'; -- Replace with the desired EndDate




-- Create a procedure to add a service to the cart
CREATE PROCEDURE AddToCart
    @CustomerID INT,
    @ServiceID INT
AS
BEGIN
    -- Begin a new transaction
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Check if the given ServiceID exists in the database
        IF NOT EXISTS (SELECT 1 FROM Services WHERE ServiceID = @ServiceID)
        BEGIN
            THROW 50001, 'Service with the provided ID does not exist.', 1;
        END

        -- Check if there is an existing cart for the customer
        DECLARE @CartOrderID INT;
        SELECT @CartOrderID = dbo.IsThereCart(@CustomerID);

        IF @CartOrderID IS NULL
        BEGIN
            -- If no cart exists, create a new Order
            INSERT INTO Orders (CustomerID, OrderDate, PaymentAssesed, PaymentPaid, PaymentWaived, DueDate, OrderStatus)
            VALUES (@CustomerID, GETDATE(), 0, 0, 0, DATEADD(DAY, 30, GETDATE()), 'InCart');

            -- Get the newly created OrderID
            SET @CartOrderID = SCOPE_IDENTITY();
        END
		IF @CartOrderID is not NULL
		BEGIN
			SET @CartOrderID = @CartOrderID;
		END
        -- Add the service to the cart by inserting a record into Order_details
        INSERT INTO Order_details (ServiceID, OrderID, UnitPrice)
        VALUES (@ServiceID, @CartOrderID, 0);

        -- Commit the transaction
        COMMIT;
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error
        ROLLBACK;

        -- Re-throw the error
        THROW;
    END CATCH;
END;

select * from services
-- Example EXEC statement for AddToCart procedure
EXEC AddToCart
    @CustomerID = 1, -- Replace with a valid CustomerID from your database
    @ServiceID = 3;  -- Replace with a valid ServiceID from your database

select * from orders 
select * from Order_details
Select dbo.IsThereCart(1)


-- Create a procedure to delete a service from the cart
CREATE PROCEDURE DeleteFromCart
    @CustomerID INT,
    @ServiceID INT
AS
BEGIN
    -- Begin a new transaction
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Check if the given ServiceID exists in the database
        IF NOT EXISTS (SELECT 1 FROM Services WHERE ServiceID = @ServiceID)
        BEGIN
            THROW 50001, 'Service with the provided ID does not exist.', 1;
        END

        -- Check if there is an existing cart for the customer
        DECLARE @CartOrderID INT;
        SET @CartOrderID = dbo.IsThereCart(@CustomerID);

        -- If there is no cart, do nothing
        IF @CartOrderID IS NULL
        BEGIN
            RETURN;
        END

        -- Delete the record from Order_details with the given ServiceID
        DELETE FROM Order_details
        WHERE OrderID = @CartOrderID AND ServiceID = @ServiceID;

        -- Commit the transaction
        COMMIT;
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of an error
        ROLLBACK;

        -- Re-throw the error
        THROW;
    END CATCH;
END;


-- Example EXEC statement for DeleteFromCart procedure
EXEC DeleteFromCart
    @CustomerID = 1, -- Replace with a valid CustomerID from your database
    @ServiceID = 3;  -- Replace with a valid ServiceID from your database


