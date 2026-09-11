CREATE DATABASE RaceDay;

USE RaceDay;
GO

--Creates User table for creating auth
--NVARCHAR type to allow characters for strong passwords
CREATE TABLE [USER] (
    user_id INT PRIMARY KEY IDENTITY(1,1),
    username NVARCHAR(100) NOT NULL UNIQUE,
    password_hash NVARCHAR(255) NOT NULL,
    email NVARCHAR(150) NOT NULL UNIQUE,
    role VARCHAR(50) NOT NULL CHECK (role IN ('organiser', 'participant')),
    created_at DATETIME2 DEFAULT GETUTCDATE()
    );

--Creates Organiser table
CREATE TABLE ORGANISER (
    organiser_id INT PRIMARY KEY IDENTITY(1,1),
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    created_at DATETIME2 DEFAULT GETUTCDATE()
);

--Creates Participant table
CREATE TABLE PARTICIPANT (
    participant_id INT PRIMARY KEY IDENTITY(1,1),
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    created_at DATETIME2 DEFAULT GETUTCDATE()
);