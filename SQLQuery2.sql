USE ITI;
GO

CREATE PROCEDURE GetStudentCountPerDepartment
AS
BEGIN
    SELECT 
        D.Dept_Name,
        COUNT(S.St_Id) AS StudentCount
    FROM 
        Department D
    LEFT JOIN 
        Student S ON D.Dept_Id = S.Dept_Id
    GROUP BY 
        D.Dept_Name
    ORDER BY 
        StudentCount DESC;
END;
GO

EXEC GetStudentCountPerDepartment;


-------------------------------------------------------
USE MyCompany;
GO

CREATE OR ALTER PROCEDURE dbo.CheckEmployeesInProjectP1
AS
BEGIN
    DECLARE @EmpCount INT;

    SELECT @EmpCount = COUNT(*)
    FROM dbo.Works_for WF
    INNER JOIN dbo.Project P ON WF.Pno = P.Pnumber
    WHERE P.Pname = 'AL Solimaniah';

    IF @EmpCount >= 3
    BEGIN
        
    END
    ELSE
    BEGIN

        SELECT E.Fname, E.Lname
        FROM dbo.Works_for WF
        INNER JOIN dbo.Project P ON WF.Pno = P.Pnumber
        INNER JOIN dbo.Employee E ON WF.ESSn = E.SSN
        WHERE P.Pname = 'AL Solimaniah';
    END
END;
GO

EXEC dbo.CheckEmployeesInProjectP1;


---------------------------------------------------------


USE MyCompany;
GO

CREATE OR ALTER PROCEDURE dbo.ReplaceEmployeeOnProject
    @OldEmpSSN INT,
    @NewEmpSSN INT,
    @ProjectNumber INT
AS
BEGIN
    DECLARE @Hours INT;

    -- Fetch hours from the old employee
    SELECT @Hours = Hours
    FROM dbo.Works_for
    WHERE ESSn = @OldEmpSSN AND Pno = @ProjectNumber;

    IF @Hours IS NOT NULL
    BEGIN
        -- Delete old employee's record from the project
        DELETE FROM dbo.Works_for
        WHERE ESSn = @OldEmpSSN AND Pno = @ProjectNumber;

        -- Add the new employee with the same number of hours
        INSERT INTO dbo.Works_for (ESSn, Pno, Hours)
        VALUES (@NewEmpSSN, @ProjectNumber, @Hours);
    END
END;
GO
EXEC dbo.ReplaceEmployeeOnProject @OldEmpSSN = 223344, @NewEmpSSN = 223345, @ProjectNumber = 10;