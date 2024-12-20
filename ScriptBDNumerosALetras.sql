USE [master]
GO
/****** Object:  Database [NumerosALetras]    Script Date: 12/12/2024 0:03:16 ******/
CREATE DATABASE [NumerosALetras]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'NumerosALetras', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\NumerosALetras.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'NumerosALetras_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\NumerosALetras_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [NumerosALetras] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [NumerosALetras].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [NumerosALetras] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [NumerosALetras] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [NumerosALetras] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [NumerosALetras] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [NumerosALetras] SET ARITHABORT OFF 
GO
ALTER DATABASE [NumerosALetras] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [NumerosALetras] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [NumerosALetras] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [NumerosALetras] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [NumerosALetras] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [NumerosALetras] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [NumerosALetras] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [NumerosALetras] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [NumerosALetras] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [NumerosALetras] SET  DISABLE_BROKER 
GO
ALTER DATABASE [NumerosALetras] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [NumerosALetras] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [NumerosALetras] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [NumerosALetras] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [NumerosALetras] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [NumerosALetras] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [NumerosALetras] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [NumerosALetras] SET RECOVERY FULL 
GO
ALTER DATABASE [NumerosALetras] SET  MULTI_USER 
GO
ALTER DATABASE [NumerosALetras] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [NumerosALetras] SET DB_CHAINING OFF 
GO
ALTER DATABASE [NumerosALetras] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [NumerosALetras] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [NumerosALetras] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [NumerosALetras] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'NumerosALetras', N'ON'
GO
ALTER DATABASE [NumerosALetras] SET QUERY_STORE = OFF
GO
USE [NumerosALetras]
GO
/****** Object:  Table [dbo].[EventLogs]    Script Date: 12/12/2024 0:03:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EventLogs](
	[EventId] [int] IDENTITY(1,1) NOT NULL,
	[ExecutionDate] [datetime] NOT NULL,
	[ExecutionResult] [bit] NOT NULL,
	[ExecutedBy] [uniqueidentifier] NOT NULL,
	[Description] [nvarchar](500) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[EventId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 12/12/2024 0:03:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[UserId] [uniqueidentifier] NOT NULL,
	[FirstName] [nvarchar](100) NOT NULL,
	[LastName] [nvarchar](100) NOT NULL,
	[Username] [nvarchar](50) NOT NULL,
	[PasswordHash] [nvarchar](255) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	[UpdatedAt] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EventLogs] ADD  DEFAULT (getdate()) FOR [ExecutionDate]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT (newid()) FOR [UserId]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [dbo].[EventLogs]  WITH CHECK ADD FOREIGN KEY([ExecutedBy])
REFERENCES [dbo].[Users] ([UserId])
GO
/****** Object:  StoredProcedure [dbo].[CreateUser]    Script Date: 12/12/2024 0:03:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CreateUser]
    @FirstName NVARCHAR(100),
    @LastName NVARCHAR(100),
    @Username NVARCHAR(50),
    @Password NVARCHAR(200),
    @IsActive BIT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Existe usuario
        IF EXISTS (SELECT 1 FROM Users WHERE Username = @Username)
        BEGIN
            RAISERROR ('El Username ya existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Insertar usuario
        INSERT INTO Users (UserId, FirstName, LastName, Username, PasswordHash, IsActive)
        VALUES (NEWID(), @FirstName, @LastName, @Username, @Password, @IsActive);       
        COMMIT TRANSACTION;
        PRINT 'Usuario registrado exitosamente.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;

GO
/****** Object:  StoredProcedure [dbo].[InsertEventLog]    Script Date: 12/12/2024 0:03:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[InsertEventLog]
    @ExecutionResult BIT,
    @ExecutedBy UNIQUEIDENTIFIER,
    @Description NVARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validar el usuario existente
        IF NOT EXISTS (SELECT 1 FROM Users WHERE UserId = @ExecutedBy)
        BEGIN
            RAISERROR ('El usuario no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Insertar el evento en la tabla EventLogs
        INSERT INTO EventLogs (ExecutionDate, ExecutionResult, ExecutedBy, Description)
        VALUES (GETDATE(), @ExecutionResult, @ExecutedBy, @Description);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH       
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
  
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_GetUserByUsername]    Script Date: 12/12/2024 0:03:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetUserByUsername]
    @Username NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        SELECT 
			UserId,
            FirstName,
            LastName,
            Username,
            PasswordHash,
            IsActive
        FROM Users
        WHERE Username = @Username
          AND IsActive = 1;
    END TRY
    BEGIN CATCH
        
        THROW;
    END CATCH
END;
GO
USE [master]
GO
ALTER DATABASE [NumerosALetras] SET  READ_WRITE 
GO
