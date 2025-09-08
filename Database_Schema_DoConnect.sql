-- ============================================
-- DoConnect Database Schema
-- Project: DoConnect - Q&A Platform
-- Created: September 8, 2025
-- Description: Complete database schema for DoConnect application
-- ============================================

-- Create Database
CREATE DATABASE DoConnect;
USE DoConnect;

-- ============================================
-- 1. USERS TABLE
-- ============================================
CREATE TABLE Users (
    user_id INT PRIMARY KEY IDENTITY(1,1),
    username NVARCHAR(50) UNIQUE NOT NULL,
    email NVARCHAR(255) UNIQUE NOT NULL,
    password_hash NVARCHAR(255) NOT NULL,
    first_name NVARCHAR(100),
    last_name NVARCHAR(100),
    profile_image NVARCHAR(500),
    bio NTEXT,
    reputation INT DEFAULT 0,
    is_active BIT DEFAULT 1,
    is_admin BIT DEFAULT 0,
    email_verified BIT DEFAULT 0,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    last_login DATETIME2,
    
    -- Constraints
    CONSTRAINT CHK_Users_Email CHECK (email LIKE '%_@__%.__%'),
    CONSTRAINT CHK_Users_Username CHECK (LEN(username) >= 3),
    CONSTRAINT CHK_Users_Reputation CHECK (reputation >= 0)
);

-- ============================================
-- 2. CATEGORIES TABLE
-- ============================================
CREATE TABLE Categories (
    category_id INT PRIMARY KEY IDENTITY(1,1),
    category_name NVARCHAR(100) UNIQUE NOT NULL,
    description NTEXT,
    color_code NVARCHAR(7), -- For UI theming
    is_active BIT DEFAULT 1,
    created_at DATETIME2 DEFAULT GETDATE(),
    created_by INT,
    
    -- Foreign Keys
    CONSTRAINT FK_Categories_CreatedBy FOREIGN KEY (created_by) REFERENCES Users(user_id)
);

-- ============================================
-- 3. TAGS TABLE
-- ============================================
CREATE TABLE Tags (
    tag_id INT PRIMARY KEY IDENTITY(1,1),
    tag_name NVARCHAR(50) UNIQUE NOT NULL,
    description NTEXT,
    usage_count INT DEFAULT 0,
    is_active BIT DEFAULT 1,
    created_at DATETIME2 DEFAULT GETDATE(),
    
    -- Constraints
    CONSTRAINT CHK_Tags_UsageCount CHECK (usage_count >= 0)
);

-- ============================================
-- 4. QUESTIONS TABLE
-- ============================================
CREATE TABLE Questions (
    question_id INT PRIMARY KEY IDENTITY(1,1),
    title NVARCHAR(255) NOT NULL,
    body NTEXT NOT NULL,
    user_id INT NOT NULL,
    category_id INT,
    view_count INT DEFAULT 0,
    vote_score INT DEFAULT 0,
    answer_count INT DEFAULT 0,
    is_approved BIT DEFAULT 0,
    is_deleted BIT DEFAULT 0,
    approved_by INT,
    approved_at DATETIME2,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    
    -- Foreign Keys
    CONSTRAINT FK_Questions_UserId FOREIGN KEY (user_id) REFERENCES Users(user_id),
    CONSTRAINT FK_Questions_CategoryId FOREIGN KEY (category_id) REFERENCES Categories(category_id),
    CONSTRAINT FK_Questions_ApprovedBy FOREIGN KEY (approved_by) REFERENCES Users(user_id),
    
    -- Constraints
    CONSTRAINT CHK_Questions_Title CHECK (LEN(title) >= 10),
    CONSTRAINT CHK_Questions_Body CHECK (LEN(body) >= 20),
    CONSTRAINT CHK_Questions_ViewCount CHECK (view_count >= 0),
    CONSTRAINT CHK_Questions_AnswerCount CHECK (answer_count >= 0)
);

-- ============================================
-- 5. ANSWERS TABLE
-- ============================================
CREATE TABLE Answers (
    answer_id INT PRIMARY KEY IDENTITY(1,1),
    question_id INT NOT NULL,
    user_id INT NOT NULL,
    body NTEXT NOT NULL,
    vote_score INT DEFAULT 0,
    is_accepted BIT DEFAULT 0,
    is_approved BIT DEFAULT 0,
    is_deleted BIT DEFAULT 0,
    approved_by INT,
    approved_at DATETIME2,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    
    -- Foreign Keys
    CONSTRAINT FK_Answers_QuestionId FOREIGN KEY (question_id) REFERENCES Questions(question_id) ON DELETE CASCADE,
    CONSTRAINT FK_Answers_UserId FOREIGN KEY (user_id) REFERENCES Users(user_id),
    CONSTRAINT FK_Answers_ApprovedBy FOREIGN KEY (approved_by) REFERENCES Users(user_id),
    
    -- Constraints
    CONSTRAINT CHK_Answers_Body CHECK (LEN(body) >= 10)
);

-- ============================================
-- 6. QUESTION TAGS (Many-to-Many Relationship)
-- ============================================
CREATE TABLE Question_Tags (
    question_id INT NOT NULL,
    tag_id INT NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    
    -- Composite Primary Key
    PRIMARY KEY (question_id, tag_id),
    
    -- Foreign Keys
    CONSTRAINT FK_QuestionTags_QuestionId FOREIGN KEY (question_id) REFERENCES Questions(question_id) ON DELETE CASCADE,
    CONSTRAINT FK_QuestionTags_TagId FOREIGN KEY (tag_id) REFERENCES Tags(tag_id)
);

-- ============================================
-- 7. VOTES TABLE
-- ============================================
CREATE TABLE Votes (
    vote_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    question_id INT NULL,
    answer_id INT NULL,
    vote_type INT NOT NULL, -- 1 for upvote, -1 for downvote
    created_at DATETIME2 DEFAULT GETDATE(),
    
    -- Foreign Keys
    CONSTRAINT FK_Votes_UserId FOREIGN KEY (user_id) REFERENCES Users(user_id),
    CONSTRAINT FK_Votes_QuestionId FOREIGN KEY (question_id) REFERENCES Questions(question_id) ON DELETE CASCADE,
    CONSTRAINT FK_Votes_AnswerId FOREIGN KEY (answer_id) REFERENCES Answers(answer_id) ON DELETE CASCADE,
    
    -- Constraints
    CONSTRAINT CHK_Votes_VoteType CHECK (vote_type IN (-1, 1)),
    CONSTRAINT CHK_Votes_OneTarget CHECK ((question_id IS NOT NULL AND answer_id IS NULL) OR (question_id IS NULL AND answer_id IS NOT NULL)),
    
    -- Unique constraint to prevent duplicate votes
    CONSTRAINT UQ_Votes_UserQuestion UNIQUE (user_id, question_id),
    CONSTRAINT UQ_Votes_UserAnswer UNIQUE (user_id, answer_id)
);

-- ============================================
-- 8. COMMENTS TABLE
-- ============================================
CREATE TABLE Comments (
    comment_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    question_id INT NULL,
    answer_id INT NULL,
    body NTEXT NOT NULL,
    is_deleted BIT DEFAULT 0,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),
    
    -- Foreign Keys
    CONSTRAINT FK_Comments_UserId FOREIGN KEY (user_id) REFERENCES Users(user_id),
    CONSTRAINT FK_Comments_QuestionId FOREIGN KEY (question_id) REFERENCES Questions(question_id) ON DELETE CASCADE,
    CONSTRAINT FK_Comments_AnswerId FOREIGN KEY (answer_id) REFERENCES Answers(answer_id) ON DELETE CASCADE,
    
    -- Constraints
    CONSTRAINT CHK_Comments_Body CHECK (LEN(body) >= 5),
    CONSTRAINT CHK_Comments_OneTarget CHECK ((question_id IS NOT NULL AND answer_id IS NULL) OR (question_id IS NULL AND answer_id IS NOT NULL))
);

-- ============================================
-- 9. FILES/ATTACHMENTS TABLE
-- ============================================
CREATE TABLE Attachments (
    attachment_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    question_id INT NULL,
    answer_id INT NULL,
    original_filename NVARCHAR(255) NOT NULL,
    stored_filename NVARCHAR(255) NOT NULL,
    file_path NVARCHAR(500) NOT NULL,
    file_size BIGINT NOT NULL,
    file_type NVARCHAR(100) NOT NULL,
    mime_type NVARCHAR(100) NOT NULL,
    is_deleted BIT DEFAULT 0,
    uploaded_at DATETIME2 DEFAULT GETDATE(),
    
    -- Foreign Keys
    CONSTRAINT FK_Attachments_UserId FOREIGN KEY (user_id) REFERENCES Users(user_id),
    CONSTRAINT FK_Attachments_QuestionId FOREIGN KEY (question_id) REFERENCES Questions(question_id) ON DELETE CASCADE,
    CONSTRAINT FK_Attachments_AnswerId FOREIGN KEY (answer_id) REFERENCES Answers(answer_id) ON DELETE CASCADE,
    
    -- Constraints
    CONSTRAINT CHK_Attachments_FileSize CHECK (file_size > 0),
    CONSTRAINT CHK_Attachments_OneTarget CHECK ((question_id IS NOT NULL AND answer_id IS NULL) OR (question_id IS NULL AND answer_id IS NOT NULL) OR (question_id IS NULL AND answer_id IS NULL))
);

-- ============================================
-- 10. USER BOOKMARKS TABLE
-- ============================================
CREATE TABLE User_Bookmarks (
    bookmark_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    question_id INT NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    
    -- Foreign Keys
    CONSTRAINT FK_UserBookmarks_UserId FOREIGN KEY (user_id) REFERENCES Users(user_id),
    CONSTRAINT FK_UserBookmarks_QuestionId FOREIGN KEY (question_id) REFERENCES Questions(question_id) ON DELETE CASCADE,
    
    -- Unique constraint to prevent duplicate bookmarks
    CONSTRAINT UQ_UserBookmarks_UserQuestion UNIQUE (user_id, question_id)
);

-- ============================================
-- 11. USER SESSIONS TABLE (for authentication)
-- ============================================
CREATE TABLE User_Sessions (
    session_id NVARCHAR(255) PRIMARY KEY,
    user_id INT NOT NULL,
    ip_address NVARCHAR(45),
    user_agent NVARCHAR(500),
    is_active BIT DEFAULT 1,
    created_at DATETIME2 DEFAULT GETDATE(),
    expires_at DATETIME2 NOT NULL,
    last_activity DATETIME2 DEFAULT GETDATE(),
    
    -- Foreign Keys
    CONSTRAINT FK_UserSessions_UserId FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- ============================================
-- 12. AUDIT LOG TABLE (for admin tracking)
-- ============================================
CREATE TABLE Audit_Log (
    log_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT,
    action_type NVARCHAR(50) NOT NULL, -- CREATE, UPDATE, DELETE, APPROVE, REJECT
    table_name NVARCHAR(50) NOT NULL,
    record_id INT,
    old_values NTEXT,
    new_values NTEXT,
    ip_address NVARCHAR(45),
    user_agent NVARCHAR(500),
    created_at DATETIME2 DEFAULT GETDATE(),
    
    -- Foreign Keys
    CONSTRAINT FK_AuditLog_UserId FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- ============================================
-- 13. NOTIFICATION TABLE
-- ============================================
CREATE TABLE Notifications (
    notification_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    type NVARCHAR(50) NOT NULL, -- ANSWER, COMMENT, VOTE, MENTION
    title NVARCHAR(255) NOT NULL,
    message NTEXT,
    related_question_id INT,
    related_answer_id INT,
    related_user_id INT,
    is_read BIT DEFAULT 0,
    created_at DATETIME2 DEFAULT GETDATE(),
    
    -- Foreign Keys
    CONSTRAINT FK_Notifications_UserId FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    CONSTRAINT FK_Notifications_RelatedQuestionId FOREIGN KEY (related_question_id) REFERENCES Questions(question_id),
    CONSTRAINT FK_Notifications_RelatedAnswerId FOREIGN KEY (related_answer_id) REFERENCES Answers(answer_id),
    CONSTRAINT FK_Notifications_RelatedUserId FOREIGN KEY (related_user_id) REFERENCES Users(user_id)
);

-- ============================================
-- INDEXES FOR PERFORMANCE
-- ============================================

-- Users table indexes
CREATE INDEX IX_Users_Email ON Users(email);
CREATE INDEX IX_Users_Username ON Users(username);
CREATE INDEX IX_Users_IsActive ON Users(is_active);

-- Questions table indexes
CREATE INDEX IX_Questions_UserId ON Questions(user_id);
CREATE INDEX IX_Questions_CategoryId ON Questions(category_id);
CREATE INDEX IX_Questions_CreatedAt ON Questions(created_at DESC);
CREATE INDEX IX_Questions_IsApproved ON Questions(is_approved);
CREATE INDEX IX_Questions_VoteScore ON Questions(vote_score DESC);
CREATE INDEX IX_Questions_ViewCount ON Questions(view_count DESC);

-- Answers table indexes
CREATE INDEX IX_Answers_QuestionId ON Answers(question_id);
CREATE INDEX IX_Answers_UserId ON Answers(user_id);
CREATE INDEX IX_Answers_CreatedAt ON Answers(created_at DESC);
CREATE INDEX IX_Answers_IsApproved ON Answers(is_approved);
CREATE INDEX IX_Answers_VoteScore ON Answers(vote_score DESC);

-- Votes table indexes
CREATE INDEX IX_Votes_QuestionId ON Votes(question_id);
CREATE INDEX IX_Votes_AnswerId ON Votes(answer_id);
CREATE INDEX IX_Votes_UserId ON Votes(user_id);

-- Tags table indexes
CREATE INDEX IX_Tags_Name ON Tags(tag_name);
CREATE INDEX IX_Tags_UsageCount ON Tags(usage_count DESC);

-- Sessions table indexes
CREATE INDEX IX_UserSessions_UserId ON User_Sessions(user_id);
CREATE INDEX IX_UserSessions_ExpiresAt ON User_Sessions(expires_at);
CREATE INDEX IX_UserSessions_IsActive ON User_Sessions(is_active);

-- Notifications table indexes
CREATE INDEX IX_Notifications_UserId ON Notifications(user_id);
CREATE INDEX IX_Notifications_IsRead ON Notifications(is_read);
CREATE INDEX IX_Notifications_CreatedAt ON Notifications(created_at DESC);

-- ============================================
-- TRIGGERS FOR AUTOMATIC UPDATES
-- ============================================

-- Update answer count when answer is added/removed
CREATE TRIGGER TR_UpdateQuestionAnswerCount
ON Answers
AFTER INSERT, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Update for inserted answers
    IF EXISTS(SELECT * FROM inserted)
    BEGIN
        UPDATE Questions 
        SET answer_count = (
            SELECT COUNT(*) 
            FROM Answers 
            WHERE question_id = inserted.question_id 
            AND is_deleted = 0
        )
        FROM inserted
        WHERE Questions.question_id = inserted.question_id;
    END
    
    -- Update for deleted answers
    IF EXISTS(SELECT * FROM deleted)
    BEGIN
        UPDATE Questions 
        SET answer_count = (
            SELECT COUNT(*) 
            FROM Answers 
            WHERE question_id = deleted.question_id 
            AND is_deleted = 0
        )
        FROM deleted
        WHERE Questions.question_id = deleted.question_id;
    END
END;

-- Update vote scores when votes are added/removed/changed
CREATE TRIGGER TR_UpdateVoteScores
ON Votes
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Update question vote scores
    IF EXISTS(SELECT * FROM inserted WHERE question_id IS NOT NULL) OR 
       EXISTS(SELECT * FROM deleted WHERE question_id IS NOT NULL)
    BEGIN
        UPDATE Questions
        SET vote_score = (
            SELECT ISNULL(SUM(vote_type), 0)
            FROM Votes
            WHERE question_id = Questions.question_id
        )
        WHERE question_id IN (
            SELECT DISTINCT question_id FROM inserted WHERE question_id IS NOT NULL
            UNION
            SELECT DISTINCT question_id FROM deleted WHERE question_id IS NOT NULL
        );
    END
    
    -- Update answer vote scores
    IF EXISTS(SELECT * FROM inserted WHERE answer_id IS NOT NULL) OR 
       EXISTS(SELECT * FROM deleted WHERE answer_id IS NOT NULL)
    BEGIN
        UPDATE Answers
        SET vote_score = (
            SELECT ISNULL(SUM(vote_type), 0)
            FROM Votes
            WHERE answer_id = Answers.answer_id
        )
        WHERE answer_id IN (
            SELECT DISTINCT answer_id FROM inserted WHERE answer_id IS NOT NULL
            UNION
            SELECT DISTINCT answer_id FROM deleted WHERE answer_id IS NOT NULL
        );
    END
END;

-- Update tag usage count
CREATE TRIGGER TR_UpdateTagUsageCount
ON Question_Tags
AFTER INSERT, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Update for inserted tags
    IF EXISTS(SELECT * FROM inserted)
    BEGIN
        UPDATE Tags
        SET usage_count = (
            SELECT COUNT(*)
            FROM Question_Tags qt
            INNER JOIN Questions q ON qt.question_id = q.question_id
            WHERE qt.tag_id = Tags.tag_id
            AND q.is_deleted = 0
        )
        WHERE tag_id IN (SELECT DISTINCT tag_id FROM inserted);
    END
    
    -- Update for deleted tags
    IF EXISTS(SELECT * FROM deleted)
    BEGIN
        UPDATE Tags
        SET usage_count = (
            SELECT COUNT(*)
            FROM Question_Tags qt
            INNER JOIN Questions q ON qt.question_id = q.question_id
            WHERE qt.tag_id = Tags.tag_id
            AND q.is_deleted = 0
        )
        WHERE tag_id IN (SELECT DISTINCT tag_id FROM deleted);
    END
END;

-- ============================================
-- SAMPLE DATA FOR TESTING
-- ============================================

-- Insert sample categories
INSERT INTO Categories (category_name, description, color_code) VALUES
('Programming', 'General programming questions and discussions', '#4f46e5'),
('Web Development', 'Frontend, backend, and full-stack development', '#059669'),
('Database', 'Database design, optimization, and queries', '#dc2626'),
('Mobile Development', 'iOS, Android, and cross-platform development', '#7c3aed'),
('DevOps', 'Deployment, CI/CD, and infrastructure', '#ea580c');

-- Insert sample tags
INSERT INTO Tags (tag_name, description) VALUES
('javascript', 'Questions about JavaScript programming'),
('react', 'React.js framework questions'),
('nodejs', 'Node.js backend development'),
('sql', 'SQL database queries and design'),
('python', 'Python programming language'),
('authentication', 'User authentication and authorization'),
('performance', 'Application performance optimization'),
('database-design', 'Database schema and architecture'),
('docker', 'Docker containerization'),
('security', 'Application and data security');

-- Insert sample admin user
INSERT INTO Users (username, email, password_hash, first_name, last_name, is_admin, email_verified) VALUES
('admin', 'admin@doconnect.com', 'hashed_password_here', 'Admin', 'User', 1, 1);

-- Insert sample regular users
INSERT INTO Users (username, email, password_hash, first_name, last_name, email_verified) VALUES
('john_doe', 'john@example.com', 'hashed_password_here', 'John', 'Doe', 1),
('sarah_miller', 'sarah@example.com', 'hashed_password_here', 'Sarah', 'Miller', 1),
('alex_kumar', 'alex@example.com', 'hashed_password_here', 'Alex', 'Kumar', 1);

-- ============================================
-- STORED PROCEDURES
-- ============================================

-- Get popular questions
CREATE PROCEDURE SP_GetPopularQuestions
    @PageSize INT = 20,
    @PageNumber INT = 1
AS
BEGIN
    SELECT 
        q.question_id,
        q.title,
        q.body,
        q.view_count,
        q.vote_score,
        q.answer_count,
        q.created_at,
        u.username,
        u.first_name,
        u.last_name,
        c.category_name
    FROM Questions q
    INNER JOIN Users u ON q.user_id = u.user_id
    LEFT JOIN Categories c ON q.category_id = c.category_id
    WHERE q.is_approved = 1 AND q.is_deleted = 0
    ORDER BY q.vote_score DESC, q.view_count DESC
    OFFSET (@PageNumber - 1) * @PageSize ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END;

-- Get pending questions for admin
CREATE PROCEDURE SP_GetPendingQuestions
AS
BEGIN
    SELECT 
        q.question_id,
        q.title,
        q.body,
        q.created_at,
        u.username,
        u.first_name,
        u.last_name,
        c.category_name
    FROM Questions q
    INNER JOIN Users u ON q.user_id = u.user_id
    LEFT JOIN Categories c ON q.category_id = c.category_id
    WHERE q.is_approved = 0 AND q.is_deleted = 0
    ORDER BY q.created_at DESC;
END;

-- Get pending answers for admin
CREATE PROCEDURE SP_GetPendingAnswers
AS
BEGIN
    SELECT 
        a.answer_id,
        a.body,
        a.created_at,
        u.username,
        u.first_name,
        u.last_name,
        q.title as question_title,
        q.question_id
    FROM Answers a
    INNER JOIN Users u ON a.user_id = u.user_id
    INNER JOIN Questions q ON a.question_id = q.question_id
    WHERE a.is_approved = 0 AND a.is_deleted = 0
    ORDER BY a.created_at DESC;
END;

-- ============================================
-- VIEWS FOR COMMON QUERIES
-- ============================================

-- View for question list with user info
CREATE VIEW VW_QuestionList AS
SELECT 
    q.question_id,
    q.title,
    q.body,
    q.view_count,
    q.vote_score,
    q.answer_count,
    q.created_at,
    q.updated_at,
    u.username,
    u.first_name,
    u.last_name,
    c.category_name,
    c.color_code as category_color
FROM Questions q
INNER JOIN Users u ON q.user_id = u.user_id
LEFT JOIN Categories c ON q.category_id = c.category_id
WHERE q.is_approved = 1 AND q.is_deleted = 0;

-- View for user statistics
CREATE VIEW VW_UserStats AS
SELECT 
    u.user_id,
    u.username,
    u.first_name,
    u.last_name,
    u.reputation,
    COUNT(DISTINCT q.question_id) as questions_count,
    COUNT(DISTINCT a.answer_id) as answers_count,
    ISNULL(SUM(CASE WHEN v.vote_type = 1 THEN 1 ELSE 0 END), 0) as upvotes_received
FROM Users u
LEFT JOIN Questions q ON u.user_id = q.user_id AND q.is_deleted = 0
LEFT JOIN Answers a ON u.user_id = a.user_id AND a.is_deleted = 0
LEFT JOIN Votes v ON (v.question_id = q.question_id OR v.answer_id = a.answer_id)
GROUP BY u.user_id, u.username, u.first_name, u.last_name, u.reputation;

-- ============================================
-- END OF SCHEMA
-- ============================================

PRINT 'DoConnect database schema created successfully!';
PRINT 'Total tables created: 13';
PRINT 'Total indexes created: Multiple performance indexes';
PRINT 'Total triggers created: 3 automatic update triggers';
PRINT 'Total stored procedures created: 3';
PRINT 'Total views created: 2';
PRINT '';
PRINT 'Next steps:';
PRINT '1. Update password hashes with proper encryption';
PRINT '2. Configure backup and recovery procedures';
PRINT '3. Set up proper user permissions';
PRINT '4. Configure connection strings in application';
PRINT '5. Test all functionality with sample data';