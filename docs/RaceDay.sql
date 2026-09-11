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

--Creates Profile table
CREATE TABLE PROFILE (
    profile_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL UNIQUE,
    participant_id INT UNIQUE,
    organiser_id INT UNIQUE,
    created_at DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (user_id) REFERENCES [USER](user_id) ON DELETE CASCADE,
    FOREIGN KEY (participant_id) REFERENCES PARTICIPANT(participant_id) ON DELETE SET NULL,
    FOREIGN KEY (organiser_id) REFERENCES ORGANISER(organiser_id) ON DELETE SET NULL
);

--Creates Events tavle
CREATE TABLE EVENT (
    event_id INT PRIMARY KEY IDENTITY(1,1),
    event_name VARCHAR(200) NOT NULL,
    location VARCHAR(200) NOT NULL,
    latitude DECIMAL(10, 8) NOT NULL,
    longitude DECIMAL(11, 8) NOT NULL,
    event_date DATETIME2 NOT NULL,
    status VARCHAR(50) NOT NULL CHECK (status IN ('scheduled', 'ongoing', 'completed', 'cancelled')),
    created_at DATETIME2 DEFAULT GETUTCDATE()
);

--Creates the category table
CREATE TABLE CATEGORY (
    category_id INT PRIMARY KEY IDENTITY(1,1),
    category_name VARCHAR(100) NOT NULL UNIQUE,
    created_at DATETIME2 DEFAULT GETUTCDATE()
);

--Creates the routes table
--Thisis the proptery of the events
CREATE TABLE ROUTE (
    route_id INT PRIMARY KEY IDENTITY(1,1),
    event_id INT NOT NULL,
    route_name NVARCHAR(200) NOT NULL,
    distance DECIMAL(10, 2) NOT NULL,
    start_location NVARCHAR(200) NOT NULL,
    end_location NVARCHAR(200) NOT NULL,
    map_url NVARCHAR(MAX),
    created_at DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (event_id) REFERENCES EVENT(event_id) ON DELETE CASCADE
);

--Creates the results table
CREATE TABLE RESULTS (
    results_id INT PRIMARY KEY IDENTITY(1,1),
    start_time DATETIME2 NOT NULL,
    finish_time DATETIME2 NOT NULL,
    position INT NOT NULL,
    created_at DATETIME2 DEFAULT GETUTCDATE()
);

--Creates a juntion table Between PARTICIPANT, EVENT and RESULT
--Assited by AI agent
CREATE TABLE ENROLMENT (
    enrolment_id INT PRIMARY KEY IDENTITY(1,1),
    participant_id INT NOT NULL,
    event_id INT NOT NULL,
    results_id INT UNIQUE,
    category_id INT NOT NULL,
    entry_date DATETIME2 DEFAULT GETUTCDATE(),
    status NVARCHAR(50) NOT NULL CHECK (status IN ('registered', 'confirmed', 'started', 'finished', 'withdrawn', 'disqualified')),
    FOREIGN KEY (participant_id) REFERENCES PARTICIPANT(participant_id) ON DELETE CASCADE,
    FOREIGN KEY (event_id) REFERENCES EVENT(event_id) ON DELETE CASCADE,
    FOREIGN KEY (results_id) REFERENCES RESULTS(results_id) ON DELETE SET NULL,
    FOREIGN KEY (category_id) REFERENCES CATEGORY(category_id),
    UNIQUE (participant_id, event_id)
);

--Creates a perfmance_history table
CREATE TABLE PERFORMANCE_HISTORY (
    history_id INT PRIMARY KEY IDENTITY(1,1),
    participant_id INT NOT NULL,
    finish_time DATETIME2,
    finish_position INT,
    recorded_at DATETIME2 DEFAULT GETUTCDATE(),
    FOREIGN KEY (participant_id) REFERENCES PARTICIPANT(participant_id) ON DELETE CASCADE
);