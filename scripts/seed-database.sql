-- =============================================
-- KidCart Database Schema + Seed Data
-- =============================================

USE master;
GO

IF EXISTS (SELECT * FROM sys.databases WHERE name = 'KidCartDb')
    DROP DATABASE KidCartDb;
GO

CREATE DATABASE KidCartDb;
GO

USE KidCartDb;
GO

-- =============================================
-- TABLES
-- =============================================

CREATE TABLE Categories (
    Id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    Name NVARCHAR(100) NOT NULL,
    Slug NVARCHAR(100) NOT NULL UNIQUE,
    Description NVARCHAR(500),
    ImageUrl NVARCHAR(500),
    ParentCategoryId UNIQUEIDENTIFIER NULL REFERENCES Categories(Id),
    SortOrder INT DEFAULT 0,
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 NULL
);

CREATE TABLE Products (
    Id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    Name NVARCHAR(200) NOT NULL,
    Slug NVARCHAR(200) NOT NULL UNIQUE,
    Description NVARCHAR(MAX) NOT NULL,
    ShortDescription NVARCHAR(500),
    BasePrice DECIMAL(18,2) NOT NULL,
    CompareAtPrice DECIMAL(18,2) NULL,
    CategoryId UNIQUEIDENTIFIER NOT NULL REFERENCES Categories(Id),
    TargetAgeGroup INT NOT NULL, -- 1=Toddler,2=Child,3=Tween,4=Teen,5=College
    Brand NVARCHAR(100),
    SKU NVARCHAR(50),
    IsActive BIT DEFAULT 1,
    IsFeatured BIT DEFAULT 0,
    AverageRating DECIMAL(3,1) DEFAULT 0,
    ReviewCount INT DEFAULT 0,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 NULL
);

CREATE TABLE ProductVariants (
    Id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    ProductId UNIQUEIDENTIFIER NOT NULL REFERENCES Products(Id) ON DELETE CASCADE,
    Name NVARCHAR(200) NOT NULL,
    Size NVARCHAR(50),
    Color NVARCHAR(50),
    SKU NVARCHAR(50),
    PriceAdjustment DECIMAL(18,2) DEFAULT 0,
    StockQuantity INT DEFAULT 0,
    LowStockThreshold INT DEFAULT 5,
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 NULL
);

CREATE TABLE ProductImages (
    Id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    ProductId UNIQUEIDENTIFIER NOT NULL REFERENCES Products(Id) ON DELETE CASCADE,
    Url NVARCHAR(500) NOT NULL,
    AltText NVARCHAR(200),
    SortOrder INT DEFAULT 0,
    IsPrimary BIT DEFAULT 0,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 NULL
);

CREATE TABLE Reviews (
    Id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    ProductId UNIQUEIDENTIFIER NOT NULL REFERENCES Products(Id),
    UserId UNIQUEIDENTIFIER NOT NULL,
    UserDisplayName NVARCHAR(100) NOT NULL,
    Rating INT NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    Title NVARCHAR(200),
    Comment NVARCHAR(2000),
    IsVerifiedPurchase BIT DEFAULT 0,
    IsApproved BIT DEFAULT 1,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 NULL
);

CREATE TABLE Coupons (
    Id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    Code NVARCHAR(50) NOT NULL UNIQUE,
    Description NVARCHAR(500) NOT NULL,
    Type INT NOT NULL, -- 1=Percentage, 2=FixedAmount
    Value DECIMAL(18,2) NOT NULL,
    MinimumOrderAmount DECIMAL(18,2) NULL,
    MaximumDiscount DECIMAL(18,2) NULL,
    UsageLimit INT NULL,
    UsageCount INT DEFAULT 0,
    PerUserLimit INT NULL,
    ValidFrom DATETIME2 NOT NULL,
    ValidTo DATETIME2 NOT NULL,
    IsActive BIT DEFAULT 1,
    RestrictedToAgeGroup INT NULL,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 NULL
);

CREATE TABLE Carts (
    Id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    UserId UNIQUEIDENTIFIER NULL,
    SessionId NVARCHAR(100) NULL,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 NULL
);

CREATE TABLE CartItems (
    Id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    CartId UNIQUEIDENTIFIER NOT NULL REFERENCES Carts(Id) ON DELETE CASCADE,
    ProductId UNIQUEIDENTIFIER NOT NULL REFERENCES Products(Id),
    VariantId UNIQUEIDENTIFIER NULL REFERENCES ProductVariants(Id),
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(18,2) NOT NULL,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 NULL
);

CREATE TABLE Orders (
    Id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    OrderNumber NVARCHAR(30) NOT NULL UNIQUE,
    UserId UNIQUEIDENTIFIER NOT NULL,
    Status INT NOT NULL DEFAULT 1, -- 1=Placed,2=Confirmed,3=Processing,4=Shipped,5=Delivered,6=Cancelled
    ShippingAddress_Line1 NVARCHAR(200),
    ShippingAddress_Line2 NVARCHAR(200),
    ShippingAddress_City NVARCHAR(100),
    ShippingAddress_State NVARCHAR(100),
    ShippingAddress_PostalCode NVARCHAR(20),
    ShippingAddress_Country NVARCHAR(100) DEFAULT 'India',
    SubTotal DECIMAL(18,2) NOT NULL,
    DiscountAmount DECIMAL(18,2) DEFAULT 0,
    ShippingAmount DECIMAL(18,2) DEFAULT 0,
    TaxAmount DECIMAL(18,2) DEFAULT 0,
    TotalAmount DECIMAL(18,2) NOT NULL,
    CouponCode NVARCHAR(50),
    Notes NVARCHAR(1000),
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 NULL
);

CREATE TABLE OrderItems (
    Id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    OrderId UNIQUEIDENTIFIER NOT NULL REFERENCES Orders(Id) ON DELETE CASCADE,
    ProductId UNIQUEIDENTIFIER NOT NULL,
    ProductName NVARCHAR(200) NOT NULL,
    VariantName NVARCHAR(200),
    SKU NVARCHAR(50),
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(18,2) NOT NULL,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 NULL
);

CREATE TABLE PaymentRecords (
    Id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    OrderId UNIQUEIDENTIFIER NOT NULL REFERENCES Orders(Id) ON DELETE CASCADE,
    GatewayName NVARCHAR(50) NOT NULL,
    GatewayTransactionId NVARCHAR(200) NOT NULL,
    Amount DECIMAL(18,2) NOT NULL,
    Currency NVARCHAR(10) DEFAULT 'INR',
    Status INT NOT NULL DEFAULT 1, -- 1=Pending,2=Authorized,3=Captured,4=Failed,5=Refunded
    GatewayResponse NVARCHAR(MAX),
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 NULL
);

CREATE TABLE Wishlists (
    Id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    UserId UNIQUEIDENTIFIER NOT NULL,
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 NULL
);

CREATE TABLE WishlistItems (
    Id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    WishlistId UNIQUEIDENTIFIER NOT NULL REFERENCES Wishlists(Id) ON DELETE CASCADE,
    ProductId UNIQUEIDENTIFIER NOT NULL REFERENCES Products(Id),
    CreatedAt DATETIME2 DEFAULT GETUTCDATE(),
    UpdatedAt DATETIME2 NULL
);

-- INDEXES
CREATE INDEX IX_Products_CategoryId ON Products(CategoryId);
CREATE INDEX IX_Products_AgeGroup ON Products(TargetAgeGroup);
CREATE INDEX IX_Products_IsActive ON Products(IsActive);
CREATE INDEX IX_Products_BasePrice ON Products(BasePrice);
CREATE INDEX IX_Products_IsFeatured ON Products(IsFeatured);
CREATE INDEX IX_Orders_UserId ON Orders(UserId);
CREATE INDEX IX_Orders_Status ON Orders(Status);
CREATE INDEX IX_Reviews_ProductId ON Reviews(ProductId);

-- =============================================
-- SEED DATA: CATEGORIES
-- =============================================

INSERT INTO Categories (Id, Name, Slug, Description, ImageUrl, ParentCategoryId, SortOrder) VALUES
('10000000-0000-0000-0000-000000000001', 'Stationery', 'stationery', 'Pens, pencils, notebooks, art supplies and everything for school', '/images/categories/stationery.jpg', NULL, 1),
('10000000-0000-0000-0000-000000000002', 'Books', 'books', 'Textbooks, storybooks, reference books and educational material', '/images/categories/books.jpg', NULL, 2),
('10000000-0000-0000-0000-000000000003', 'Bags', 'bags', 'School bags, backpacks, lunch bags, laptop bags', '/images/categories/bags.jpg', NULL, 3),
('10000000-0000-0000-0000-000000000004', 'Clothing', 'clothing', 'School uniforms, casual wear, sportswear for all ages', '/images/categories/clothing.jpg', NULL, 4),
('10000000-0000-0000-0000-000000000005', 'Fashion', 'fashion', 'Accessories, watches, sunglasses, jewelry for kids and teens', '/images/categories/fashion.jpg', NULL, 5),
('10000000-0000-0000-0000-000000000006', 'Gifts', 'gifts', 'Birthday gifts, educational toys, creative kits, party supplies', '/images/categories/gifts.jpg', NULL, 6);

-- Sub-categories
INSERT INTO Categories (Id, Name, Slug, Description, ParentCategoryId, SortOrder) VALUES
('11000000-0000-0000-0000-000000000001', 'Pens & Pencils', 'pens-pencils', 'Writing instruments for all ages', '10000000-0000-0000-0000-000000000001', 1),
('11000000-0000-0000-0000-000000000002', 'Notebooks & Journals', 'notebooks-journals', 'Ruled, unruled, dot grid notebooks', '10000000-0000-0000-0000-000000000001', 2),
('11000000-0000-0000-0000-000000000003', 'Art Supplies', 'art-supplies', 'Colors, brushes, canvases, craft kits', '10000000-0000-0000-0000-000000000001', 3),
('11000000-0000-0000-0000-000000000004', 'Desk Organizers', 'desk-organizers', 'Pen stands, file holders, desk accessories', '10000000-0000-0000-0000-000000000001', 4),
('11000000-0000-0000-0000-000000000005', 'Storybooks', 'storybooks', 'Fiction, fairy tales, adventure stories', '10000000-0000-0000-0000-000000000002', 1),
('11000000-0000-0000-0000-000000000006', 'Textbooks', 'textbooks', 'NCERT, ICSE, CBSE textbooks and guides', '10000000-0000-0000-0000-000000000002', 2),
('11000000-0000-0000-0000-000000000007', 'Reference Books', 'reference-books', 'Dictionaries, encyclopedias, competitive exam prep', '10000000-0000-0000-0000-000000000002', 3),
('11000000-0000-0000-0000-000000000008', 'School Bags', 'school-bags', 'Primary and secondary school backpacks', '10000000-0000-0000-0000-000000000003', 1),
('11000000-0000-0000-0000-000000000009', 'Laptop Bags', 'laptop-bags', 'Sleeves and bags for college students', '10000000-0000-0000-0000-000000000003', 2),
('11000000-0000-0000-0000-000000000010', 'Lunch Bags', 'lunch-bags', 'Insulated tiffin bags and carriers', '10000000-0000-0000-0000-000000000003', 3);

-- =============================================
-- SEED DATA: PRODUCTS (60 realistic products)
-- =============================================

-- STATIONERY - Pens & Pencils
INSERT INTO Products (Id, Name, Slug, Description, ShortDescription, BasePrice, CompareAtPrice, CategoryId, TargetAgeGroup, Brand, SKU, IsActive, IsFeatured, AverageRating, ReviewCount, CreatedAt) VALUES
('20000000-0000-0000-0000-000000000001', 'Rainbow Gel Pen Set (12 Colors)', 'rainbow-gel-pen-set-12', 'A vibrant set of 12 gel pens in rainbow colors. Smooth ink flow, comfortable grip, and fun designs that kids love. Perfect for school projects, drawing, and creative writing. Non-toxic and safe for children.', 'Vibrant 12-color gel pen set for creative kids', 249.00, 399.00, '11000000-0000-0000-0000-000000000001', 2, 'Flair', 'STN-PEN-001', 1, 1, 4.7, 234, DATEADD(day, -15, GETUTCDATE())),
('20000000-0000-0000-0000-000000000002', 'Mechanical Pencil Pro Set', 'mechanical-pencil-pro-set', 'Premium mechanical pencil set with 0.5mm and 0.7mm options. Includes extra lead refills and erasers. Ergonomic design reduces hand fatigue during long study sessions. Ideal for college students.', 'Professional mechanical pencil set for college', 449.00, 599.00, '11000000-0000-0000-0000-000000000001', 5, 'Staedtler', 'STN-PEN-002', 1, 0, 4.8, 189, DATEADD(day, -10, GETUTCDATE())),
('20000000-0000-0000-0000-000000000003', 'Jumbo Triangular Crayons (24 Pack)', 'jumbo-triangular-crayons-24', 'Extra thick triangular crayons designed for tiny hands. Break-resistant, washable, and non-toxic. Bright vivid colors that glide smoothly on paper. Perfect first crayons for toddlers learning to draw.', 'Thick easy-grip crayons for little artists', 199.00, NULL, '11000000-0000-0000-0000-000000000001', 1, 'Crayola', 'STN-PEN-003', 1, 1, 4.9, 312, DATEADD(day, -8, GETUTCDATE())),
('20000000-0000-0000-0000-000000000004', 'Calligraphy Brush Pen Set', 'calligraphy-brush-pen-set', 'Set of 6 calligraphy brush pens with flexible tips. Water-based ink in black and assorted colors. Perfect for hand lettering, journaling, and creative projects. Great for teens into art.', 'Flexible brush pens for lettering and art', 599.00, 799.00, '11000000-0000-0000-0000-000000000001', 4, 'Tombow', 'STN-PEN-004', 1, 0, 4.6, 98, DATEADD(day, -5, GETUTCDATE())),
('20000000-0000-0000-0000-000000000005', 'Sparkle Glitter Pens (8 Pack)', 'sparkle-glitter-pens-8', 'Make your schoolwork shine! 8 glitter gel pens in dazzling colors. Smooth flowing ink with sparkle effect. Great for decorating notebooks, cards, and art projects.', 'Glittery gel pens that make writing fun', 179.00, 249.00, '11000000-0000-0000-0000-000000000001', 2, 'Flair', 'STN-PEN-005', 1, 0, 4.5, 156, DATEADD(day, -20, GETUTCDATE()));

-- STATIONERY - Notebooks
INSERT INTO Products (Id, Name, Slug, Description, ShortDescription, BasePrice, CompareAtPrice, CategoryId, TargetAgeGroup, Brand, SKU, IsActive, IsFeatured, AverageRating, ReviewCount, CreatedAt) VALUES
('20000000-0000-0000-0000-000000000006', 'Campus A4 Notebook 5-Subject (300 Pages)', 'campus-a4-notebook-5-subject', '5-subject spiral notebook with 300 ruled pages. Dividers with pockets for each subject. Durable plastic cover, smooth 70gsm paper. Essential for organized college students.', 'Multi-subject notebook for organized notes', 349.00, 449.00, '11000000-0000-0000-0000-000000000002', 5, 'Classmate', 'STN-NB-001', 1, 1, 4.6, 445, DATEADD(day, -12, GETUTCDATE())),
('20000000-0000-0000-0000-000000000007', 'Unicorn Diary with Lock', 'unicorn-diary-with-lock', 'Magical unicorn-themed diary with a heart-shaped lock and two keys. 120 lined pages with cute illustrations. Glitter cover and rainbow pages. Every little girl''s dream journal!', 'Secret diary with lock for young dreamers', 399.00, NULL, '11000000-0000-0000-0000-000000000002', 2, 'Smiggle', 'STN-NB-002', 1, 1, 4.8, 267, DATEADD(day, -3, GETUTCDATE())),
('20000000-0000-0000-0000-000000000008', 'Dot Grid Bullet Journal (A5)', 'dot-grid-bullet-journal-a5', 'Premium A5 dot grid journal with 180gsm thick pages. Numbered pages, index, and ribbon bookmark. Lay-flat binding, pen-test friendly paper. Perfect for bullet journaling teens.', 'Premium dot grid journal for creative planning', 549.00, 699.00, '11000000-0000-0000-0000-000000000002', 4, 'Archer & Olive', 'STN-NB-003', 1, 0, 4.9, 178, DATEADD(day, -7, GETUTCDATE())),
('20000000-0000-0000-0000-000000000009', 'My First Writing Notebook (Set of 3)', 'my-first-writing-notebook-set', 'Set of 3 wide-ruled notebooks with dotted midlines for handwriting practice. Extra-wide spacing, guides for letter formation. Fun animal covers. Designed for pre-schoolers learning to write.', 'Handwriting practice notebooks for beginners', 149.00, NULL, '11000000-0000-0000-0000-000000000002', 1, 'Navneet', 'STN-NB-004', 1, 0, 4.4, 89, DATEADD(day, -25, GETUTCDATE())),
('20000000-0000-0000-0000-000000000010', 'Aesthetic Pastel Notebook Set (4 Pack)', 'aesthetic-pastel-notebook-set', 'Set of 4 pastel-colored A5 notebooks. Soft-touch covers in lavender, mint, peach, and blush. 80 ruled pages each. Minimal, aesthetic design perfect for tween note-takers.', 'Trendy pastel notebooks for the aesthetic lover', 449.00, 599.00, '11000000-0000-0000-0000-000000000002', 3, 'Doodle Collection', 'STN-NB-005', 1, 1, 4.7, 201, DATEADD(day, -2, GETUTCDATE()));

-- STATIONERY - Art Supplies
INSERT INTO Products (Id, Name, Slug, Description, ShortDescription, BasePrice, CompareAtPrice, CategoryId, TargetAgeGroup, Brand, SKU, IsActive, IsFeatured, AverageRating, ReviewCount, CreatedAt) VALUES
('20000000-0000-0000-0000-000000000011', 'Watercolor Paint Set (36 Colors)', 'watercolor-paint-set-36', 'Professional-grade watercolor palette with 36 vibrant colors. Includes 3 brushes, mixing palette, and portable case. Highly pigmented, blendable colors. Perfect for budding artists.', 'Complete watercolor kit for young artists', 899.00, 1299.00, '11000000-0000-0000-0000-000000000003', 3, 'Camel', 'STN-ART-001', 1, 1, 4.8, 145, DATEADD(day, -6, GETUTCDATE())),
('20000000-0000-0000-0000-000000000012', 'Finger Paint Set (6 Colors, Washable)', 'finger-paint-set-washable', 'Non-toxic, washable finger paints in 6 primary colors. Thick consistency perfect for little fingers. Easy to clean from skin and clothes. CE certified safe for toddlers.', 'Safe washable paints for messy fun', 249.00, NULL, '11000000-0000-0000-0000-000000000003', 1, 'Crayola', 'STN-ART-002', 1, 0, 4.6, 198, DATEADD(day, -18, GETUTCDATE())),
('20000000-0000-0000-0000-000000000013', 'Sketching Pencil Kit (Professional)', 'sketching-pencil-kit-pro', 'Complete sketching set: 12 graphite pencils (6H-8B), 3 charcoal pencils, blending stumps, kneaded eraser, sharpener, and zippered carry case. For serious teen and college art students.', 'Professional sketching kit for art students', 699.00, 999.00, '11000000-0000-0000-0000-000000000003', 5, 'Faber-Castell', 'STN-ART-003', 1, 0, 4.9, 112, DATEADD(day, -4, GETUTCDATE()));

-- BOOKS
INSERT INTO Products (Id, Name, Slug, Description, ShortDescription, BasePrice, CompareAtPrice, CategoryId, TargetAgeGroup, Brand, SKU, IsActive, IsFeatured, AverageRating, ReviewCount, CreatedAt) VALUES
('20000000-0000-0000-0000-000000000014', 'The Magic Treehouse Collection (Books 1-8)', 'magic-treehouse-collection-1-8', 'Join Jack and Annie on 8 magical adventures through time! This bestselling box set takes young readers from dinosaurs to ancient Egypt. Perfect chapter books for building reading confidence.', 'Bestselling adventure series box set', 1299.00, 1599.00, '11000000-0000-0000-0000-000000000005', 2, 'Scholastic', 'BK-STR-001', 1, 1, 4.9, 567, DATEADD(day, -30, GETUTCDATE())),
('20000000-0000-0000-0000-000000000015', 'Peppa Pig: My First Library (12 Board Books)', 'peppa-pig-first-library', 'Adorable board book set featuring Peppa Pig! 12 chunky books covering colors, numbers, shapes, animals, and more. Sturdy pages perfect for toddler hands. Great first book collection.', 'Board book set for Peppa-loving toddlers', 599.00, 799.00, '11000000-0000-0000-0000-000000000005', 1, 'Penguin', 'BK-STR-002', 1, 1, 4.8, 423, DATEADD(day, -14, GETUTCDATE())),
('20000000-0000-0000-0000-000000000016', 'Harry Potter Complete Collection (7 Books)', 'harry-potter-complete-collection', 'The entire magical journey in one stunning box set. All 7 Harry Potter novels in paperback with exclusive cover art. An essential collection for every young wizard. Ages 10+.', 'Complete Harry Potter series box set', 2499.00, 3499.00, '11000000-0000-0000-0000-000000000005', 3, 'Bloomsbury', 'BK-STR-003', 1, 1, 5.0, 892, DATEADD(day, -45, GETUTCDATE())),
('20000000-0000-0000-0000-000000000017', 'NCERT Mathematics Class 10', 'ncert-mathematics-class-10', 'Official NCERT textbook for Class 10 Mathematics. Covers all chapters: Real Numbers, Polynomials, Triangles, Statistics, Probability, and more. Essential for CBSE board exam preparation.', 'Official NCERT Math textbook for Class 10', 199.00, NULL, '11000000-0000-0000-0000-000000000006', 3, 'NCERT', 'BK-TXT-001', 1, 0, 4.3, 156, DATEADD(day, -60, GETUTCDATE())),
('20000000-0000-0000-0000-000000000018', 'Atomic Habits by James Clear', 'atomic-habits-james-clear', 'The #1 bestseller on building good habits and breaking bad ones. Proven strategies backed by science. Essential reading for college students looking to optimize their routines and productivity.', 'Life-changing guide to building better habits', 399.00, 599.00, '11000000-0000-0000-0000-000000000007', 5, 'Penguin', 'BK-REF-001', 1, 1, 4.9, 1234, DATEADD(day, -90, GETUTCDATE())),
('20000000-0000-0000-0000-000000000019', 'The Diary of a Wimpy Kid (Book 1)', 'diary-wimpy-kid-1', 'Greg Heffley''s hilarious illustrated diary about surviving middle school. Laugh-out-loud funny with relatable moments every tween knows. The book that launched a phenomenon!', 'Hilarious illustrated diary for tweens', 299.00, 399.00, '11000000-0000-0000-0000-000000000005', 3, 'Puffin', 'BK-STR-004', 1, 0, 4.7, 678, DATEADD(day, -35, GETUTCDATE())),
('20000000-0000-0000-0000-000000000020', 'The Subtle Art of Not Giving a F*ck', 'subtle-art-mark-manson', 'Mark Manson''s counterintuitive approach to living a good life. Raw, refreshing, and brutally honest. A must-read for college students navigating adulting. Contains mature language.', 'Brutally honest guide for college life', 349.00, 499.00, '11000000-0000-0000-0000-000000000007', 5, 'HarperCollins', 'BK-REF-002', 1, 0, 4.5, 567, DATEADD(day, -20, GETUTCDATE()));

-- BAGS
INSERT INTO Products (Id, Name, Slug, Description, ShortDescription, BasePrice, CompareAtPrice, CategoryId, TargetAgeGroup, Brand, SKU, IsActive, IsFeatured, AverageRating, ReviewCount, CreatedAt) VALUES
('20000000-0000-0000-0000-000000000021', 'Dinosaur Adventure Backpack', 'dinosaur-adventure-backpack', 'Roar into school with this 3D dinosaur backpack! Padded shoulder straps, water bottle pocket, front zippered pocket. Lightweight yet durable polyester. Reflective strips for safety. 15L capacity.', 'Fun 3D dinosaur bag for little explorers', 899.00, 1199.00, '11000000-0000-0000-0000-000000000008', 1, 'Wildcraft Kids', 'BAG-SCH-001', 1, 1, 4.7, 234, DATEADD(day, -8, GETUTCDATE())),
('20000000-0000-0000-0000-000000000022', 'Urban Slim Laptop Backpack (15.6")', 'urban-slim-laptop-backpack', 'Sleek, modern laptop backpack with dedicated 15.6" padded compartment. USB charging port, anti-theft back pocket, water-resistant fabric. Minimalist design for college and commute.', 'Modern laptop bag for college students', 1799.00, 2499.00, '11000000-0000-0000-0000-000000000009', 5, 'American Tourister', 'BAG-LAP-001', 1, 1, 4.8, 345, DATEADD(day, -5, GETUTCDATE())),
('20000000-0000-0000-0000-000000000023', 'Floral Canvas School Bag', 'floral-canvas-school-bag', 'Beautiful floral print canvas backpack. Main compartment fits textbooks and folders, front pocket for stationery, side pockets for water bottle. Comfortable padded back and straps. 22L capacity.', 'Pretty floral backpack for school girls', 1299.00, 1599.00, '11000000-0000-0000-0000-000000000008', 3, 'Lavie', 'BAG-SCH-002', 1, 0, 4.6, 189, DATEADD(day, -12, GETUTCDATE())),
('20000000-0000-0000-0000-000000000024', 'Superhero Insulated Lunch Bag', 'superhero-insulated-lunch-bag', 'Keep lunch fresh with this superhero-themed insulated bag! BPA-free PEVA lining, easy-clean interior, sturdy zip closure. Fits standard tiffin boxes. Available in Spider-Man, Batman, and Avengers.', 'Cool superhero lunch bag for kids', 449.00, 599.00, '11000000-0000-0000-0000-000000000010', 2, 'Marvel', 'BAG-LUN-001', 1, 0, 4.5, 167, DATEADD(day, -15, GETUTCDATE())),
('20000000-0000-0000-0000-000000000025', 'Sporty Sling Bag with Earphone Hole', 'sporty-sling-bag-earphone', 'Compact crossbody sling bag perfect for teens on the go. Water-resistant nylon, multiple pockets, adjustable strap. Earphone hole for music lovers. Great for tuitions and outings.', 'Compact crossbody bag for active teens', 699.00, 899.00, '11000000-0000-0000-0000-000000000008', 4, 'Skybags', 'BAG-SCH-003', 1, 0, 4.4, 123, DATEADD(day, -9, GETUTCDATE()));

-- CLOTHING
INSERT INTO Products (Id, Name, Slug, Description, ShortDescription, BasePrice, CompareAtPrice, CategoryId, TargetAgeGroup, Brand, SKU, IsActive, IsFeatured, AverageRating, ReviewCount, CreatedAt) VALUES
('20000000-0000-0000-0000-000000000026', 'Cotton School Uniform Set (Shirt + Shorts)', 'cotton-school-uniform-set', 'Premium 100% cotton school uniform set. Crisp white shirt with navy blue shorts. Pre-shrunk fabric, reinforced stitching, comfortable fit. Machine washable. Multiple sizes available.', 'Comfortable cotton uniform set for school', 799.00, 999.00, '10000000-0000-0000-0000-000000000004', 2, 'Gini & Jony', 'CLT-UNI-001', 1, 0, 4.3, 234, DATEADD(day, -40, GETUTCDATE())),
('20000000-0000-0000-0000-000000000027', 'Graphic Tee - "Code Like a Girl"', 'graphic-tee-code-like-girl', 'Empowering graphic t-shirt with "Code Like a Girl" design. Super soft 180gsm cotton, relaxed fit. Available in black, white, and heather gray. Perfect for tech-savvy teens.', 'Empowering graphic tee for tech teens', 499.00, NULL, '10000000-0000-0000-0000-000000000004', 4, 'The Souled Store', 'CLT-TEE-001', 1, 1, 4.8, 156, DATEADD(day, -3, GETUTCDATE())),
('20000000-0000-0000-0000-000000000028', 'College Hoodie - Classic Fit', 'college-hoodie-classic-fit', 'Essential college hoodie in premium 320gsm fleece. Kangaroo pocket, adjustable drawstring hood, ribbed cuffs. Oversized fit that''s trending on every campus. Available in 8 colors.', 'Cozy oversized hoodie for campus life', 1299.00, 1799.00, '10000000-0000-0000-0000-000000000004', 5, 'H&M', 'CLT-HOD-001', 1, 1, 4.7, 289, DATEADD(day, -7, GETUTCDATE())),
('20000000-0000-0000-0000-000000000029', 'Raincoat with Fun Print (Waterproof)', 'raincoat-fun-print-waterproof', 'Bright yellow raincoat with adorable duck print. 100% waterproof with sealed seams. Snap buttons, hood with brim, reflective strip. Keep little ones dry and happy on rainy school days!', 'Cute waterproof raincoat for rainy days', 649.00, 899.00, '10000000-0000-0000-0000-000000000004', 1, 'Hopscotch', 'CLT-RCT-001', 1, 0, 4.5, 87, DATEADD(day, -22, GETUTCDATE())),
('20000000-0000-0000-0000-000000000030', 'Track Pants - Slim Fit (Pack of 2)', 'track-pants-slim-fit-2pk', 'Pack of 2 slim-fit track pants in black and navy. Moisture-wicking fabric, elastic waist with drawstring, zippered pockets. Perfect for sports, tuitions, and casual wear.', 'Comfortable track pants combo for active tweens', 899.00, 1199.00, '10000000-0000-0000-0000-000000000004', 3, 'Allen Solly Junior', 'CLT-TRK-001', 1, 0, 4.4, 145, DATEADD(day, -11, GETUTCDATE()));

-- FASHION & ACCESSORIES
INSERT INTO Products (Id, Name, Slug, Description, ShortDescription, BasePrice, CompareAtPrice, CategoryId, TargetAgeGroup, Brand, SKU, IsActive, IsFeatured, AverageRating, ReviewCount, CreatedAt) VALUES
('20000000-0000-0000-0000-000000000031', 'Digital Sports Watch (Waterproof)', 'digital-sports-watch-waterproof', 'Tough digital watch for active kids. Waterproof to 50m, LED backlight, stopwatch, alarm, date display. Durable resin band and case. Perfect for sports and outdoor adventures.', 'Rugged waterproof digital watch for kids', 799.00, 1199.00, '10000000-0000-0000-0000-000000000005', 2, 'Casio', 'FSH-WCH-001', 1, 1, 4.6, 234, DATEADD(day, -13, GETUTCDATE())),
('20000000-0000-0000-0000-000000000032', 'Trendy Sunglasses - UV Protection', 'trendy-sunglasses-uv-protection', 'Stylish polarized sunglasses with 100% UV400 protection. Lightweight TR90 frame, flexible hinges. Comes in 6 trendy colors. Look cool while protecting your eyes on campus.', 'Stylish UV-protected sunglasses for teens', 599.00, 899.00, '10000000-0000-0000-0000-000000000005', 4, 'Vincent Chase', 'FSH-SGL-001', 1, 0, 4.5, 178, DATEADD(day, -6, GETUTCDATE())),
('20000000-0000-0000-0000-000000000033', 'Friendship Bracelet Making Kit', 'friendship-bracelet-making-kit', 'Create 20+ unique bracelets! Includes embroidery floss in 30 colors, letter beads, charms, braiding wheel, and instruction booklet. Perfect sleepover activity and gift for tweens.', 'DIY bracelet kit for creative friends', 499.00, NULL, '10000000-0000-0000-0000-000000000005', 3, 'Craft-tastic', 'FSH-BRC-001', 1, 0, 4.7, 145, DATEADD(day, -8, GETUTCDATE())),
('20000000-0000-0000-0000-000000000034', 'Minimalist Leather Wallet', 'minimalist-leather-wallet', 'Slim bifold wallet in genuine leather. RFID blocking, 6 card slots, bill compartment, coin pocket. Elegant stitching and premium finish. Comes in a gift box. For the sophisticated college student.', 'Premium leather wallet for college students', 899.00, 1299.00, '10000000-0000-0000-0000-000000000005', 5, 'Fossil', 'FSH-WLT-001', 1, 0, 4.8, 167, DATEADD(day, -4, GETUTCDATE())),
('20000000-0000-0000-0000-000000000035', 'Princess Hair Accessories Box (50 pcs)', 'princess-hair-accessories-box', '50-piece hair accessory set: clips, bows, headbands, elastics, and scrunchies in assorted colors and designs. Includes princess-themed storage box. Safe, no-snag materials for fine toddler hair.', 'Complete hair accessory collection for girls', 349.00, 499.00, '10000000-0000-0000-0000-000000000005', 1, 'Li''l Diva', 'FSH-HAR-001', 1, 0, 4.4, 198, DATEADD(day, -16, GETUTCDATE()));

-- GIFTS & TOYS
INSERT INTO Products (Id, Name, Slug, Description, ShortDescription, BasePrice, CompareAtPrice, CategoryId, TargetAgeGroup, Brand, SKU, IsActive, IsFeatured, AverageRating, ReviewCount, CreatedAt) VALUES
('20000000-0000-0000-0000-000000000036', 'STEM Building Blocks (150 pcs)', 'stem-building-blocks-150', 'Engineering-inspired building blocks that teach STEM concepts through play. 150 interlocking pieces, 20 project cards, storage tub. Build bridges, vehicles, robots! Develops spatial thinking.', 'Educational building blocks for future engineers', 1499.00, 1999.00, '10000000-0000-0000-0000-000000000006', 2, 'Lego Education', 'GFT-STM-001', 1, 1, 4.9, 345, DATEADD(day, -10, GETUTCDATE())),
('20000000-0000-0000-0000-000000000037', 'Coding Robot - Learn to Program', 'coding-robot-learn-program', 'Interactive coding robot that teaches programming concepts through play. Block-based coding via tablet app. 30+ activities from basic sequences to loops and conditionals. Screen-free mode available.', 'Fun coding robot for young programmers', 2999.00, 3999.00, '10000000-0000-0000-0000-000000000006', 3, 'Sphero', 'GFT-STM-002', 1, 1, 4.8, 167, DATEADD(day, -5, GETUTCDATE())),
('20000000-0000-0000-0000-000000000038', 'Wooden Puzzle Set (6 Puzzles)', 'wooden-puzzle-set-6', 'Set of 6 chunky wooden puzzles with animal, vehicle, and shape themes. Large knob pieces easy for toddler hands. Develops fine motor skills, shape recognition, and problem solving. Non-toxic paint.', 'Chunky wooden puzzles for toddler development', 699.00, 899.00, '10000000-0000-0000-0000-000000000006', 1, 'Melissa & Doug', 'GFT-PZL-001', 1, 0, 4.7, 234, DATEADD(day, -25, GETUTCDATE())),
('20000000-0000-0000-0000-000000000039', 'Science Experiment Kit (50 Experiments)', 'science-experiment-kit-50', '50 safe science experiments you can do at home! Includes chemicals, test tubes, safety goggles, measuring tools, and illustrated guide. From volcanos to crystals to slime. Real science made fun!', '50 hands-on science experiments in a box', 1299.00, 1699.00, '10000000-0000-0000-0000-000000000006', 3, 'National Geographic', 'GFT-SCI-001', 1, 0, 4.6, 189, DATEADD(day, -14, GETUTCDATE())),
('20000000-0000-0000-0000-000000000040', 'Wireless Bluetooth Speaker (Mini)', 'wireless-bluetooth-speaker-mini', 'Compact waterproof Bluetooth speaker with surprisingly big sound. 10-hour battery, USB-C charging, true wireless pairing. Clip it to your bag, take it to the dorm. Available in 5 colors.', 'Portable speaker for music-loving students', 1499.00, 1999.00, '10000000-0000-0000-0000-000000000006', 5, 'JBL', 'GFT-SPK-001', 1, 1, 4.8, 456, DATEADD(day, -3, GETUTCDATE()));

-- MORE PRODUCTS (additional variety)
INSERT INTO Products (Id, Name, Slug, Description, ShortDescription, BasePrice, CompareAtPrice, CategoryId, TargetAgeGroup, Brand, SKU, IsActive, IsFeatured, AverageRating, ReviewCount, CreatedAt) VALUES
('20000000-0000-0000-0000-000000000041', 'Desk Organizer - Bamboo (Multi-slot)', 'desk-organizer-bamboo', 'Elegant bamboo desk organizer with 7 compartments. Holds pens, phone, sticky notes, clips. Eco-friendly, natural finish. Keeps your study desk tidy and aesthetic.', 'Eco-friendly bamboo desk organizer', 799.00, 999.00, '11000000-0000-0000-0000-000000000004', 5, 'House of Quirk', 'STN-DSK-001', 1, 0, 4.5, 89, DATEADD(day, -7, GETUTCDATE())),
('20000000-0000-0000-0000-000000000042', 'Magnetic Geometry Box', 'magnetic-geometry-box', 'Premium geometry box with magnetic closure. Includes compass, protractor, divider, ruler, set squares, and sharpener. Durable metal case with custom organizer tray.', 'Complete geometry set in magnetic case', 349.00, 499.00, '11000000-0000-0000-0000-000000000004', 3, 'Faber-Castell', 'STN-GEO-001', 1, 0, 4.6, 267, DATEADD(day, -30, GETUTCDATE())),
('20000000-0000-0000-0000-000000000043', 'Motivational Quote Water Bottle (750ml)', 'motivational-quote-water-bottle', 'Stay hydrated with daily motivation! BPA-free Tritan bottle with time markers and motivational quotes. Leak-proof, dishwasher safe, flip-top lid. Frosted design in 4 colors.', 'Motivational water bottle for students', 449.00, 599.00, '10000000-0000-0000-0000-000000000005', 4, 'Cello', 'FSH-BTL-001', 1, 0, 4.4, 178, DATEADD(day, -9, GETUTCDATE())),
('20000000-0000-0000-0000-000000000044', 'LED Desk Lamp (Dimmable, USB)', 'led-desk-lamp-dimmable-usb', '3 color modes, 10 brightness levels, flexible gooseneck. USB powered with built-in phone stand. Eye-caring LED with no flicker. Perfect study companion for late-night sessions.', 'Adjustable LED study lamp with USB', 899.00, 1299.00, '10000000-0000-0000-0000-000000000006', 5, 'Syska', 'GFT-LMP-001', 1, 0, 4.7, 234, DATEADD(day, -6, GETUTCDATE())),
('20000000-0000-0000-0000-000000000045', 'Play-Doh Mega Pack (36 Cans)', 'play-doh-mega-pack-36', 'The ultimate Play-Doh collection! 36 cans in every color imaginable. Non-toxic, soft, and squishy. Hours of creative sculpting fun. Perfect for playdates and rainy day activities.', 'Mega pack of Play-Doh in 36 colors', 999.00, 1499.00, '10000000-0000-0000-0000-000000000006', 1, 'Hasbro', 'GFT-PLY-001', 1, 0, 4.6, 345, DATEADD(day, -20, GETUTCDATE()));

-- 15 MORE for 60 total
INSERT INTO Products (Id, Name, Slug, Description, ShortDescription, BasePrice, CompareAtPrice, CategoryId, TargetAgeGroup, Brand, SKU, IsActive, IsFeatured, AverageRating, ReviewCount, CreatedAt) VALUES
('20000000-0000-0000-0000-000000000046', 'Personalized Name Labels (100 pcs)', 'personalized-name-labels-100', 'Waterproof, dishwasher-safe name labels for all your child''s belongings. Customize with name and icon. Sticks to bottles, lunchboxes, books, and clothes. Assorted fun designs.', 'Custom waterproof labels for school stuff', 299.00, NULL, '11000000-0000-0000-0000-000000000001', 2, 'Stuck On You', 'STN-LBL-001', 1, 0, 4.5, 123, DATEADD(day, -11, GETUTCDATE())),
('20000000-0000-0000-0000-000000000047', 'Arduino Starter Kit for Beginners', 'arduino-starter-kit-beginners', 'Learn electronics and programming! Includes Arduino Uno board, breadboard, LEDs, sensors, motors, wires, and 15 project guide. Build real circuits from blinking lights to weather stations.', 'Complete Arduino kit for teen makers', 2499.00, 2999.00, '10000000-0000-0000-0000-000000000006', 4, 'Arduino', 'GFT-ARD-001', 1, 1, 4.9, 89, DATEADD(day, -2, GETUTCDATE())),
('20000000-0000-0000-0000-000000000048', 'Ergonomic Study Chair (Adjustable)', 'ergonomic-study-chair-adjustable', 'Height-adjustable study chair with lumbar support. Breathable mesh back, padded seat, 360° swivel, smooth-rolling casters. Grows with your child from tween to college. Max weight 100kg.', 'Adjustable ergonomic chair for students', 4999.00, 6999.00, '10000000-0000-0000-0000-000000000006', 3, 'Green Soul', 'GFT-CHR-001', 1, 0, 4.6, 156, DATEADD(day, -15, GETUTCDATE())),
('20000000-0000-0000-0000-000000000049', 'Tiffin Box Set (Stainless Steel, 3 tier)', 'tiffin-box-set-stainless-3tier', 'Premium stainless steel 3-tier tiffin with insulated carry bag. Leak-proof lids, 300ml each tier. BPA-free, dishwasher safe. Keeps food warm for 4 hours. Fun printed carry bag.', 'Insulated stainless steel lunch box set', 699.00, 899.00, '10000000-0000-0000-0000-000000000003', 2, 'Milton', 'BAG-TFN-001', 1, 0, 4.5, 234, DATEADD(day, -18, GETUTCDATE())),
('20000000-0000-0000-0000-000000000050', 'Scientific Calculator (FX-991EX)', 'scientific-calculator-fx991ex', 'Advanced scientific calculator with 552 functions. Natural textbook display, spreadsheet mode, QR code linking. Solar + battery powered. Essential for Class 11-12 and engineering students.', 'Advanced scientific calculator for students', 1299.00, 1499.00, '11000000-0000-0000-0000-000000000001', 5, 'Casio', 'STN-CAL-001', 1, 0, 4.8, 567, DATEADD(day, -50, GETUTCDATE())),
('20000000-0000-0000-0000-000000000051', 'Comic Drawing Kit with Lightbox', 'comic-drawing-kit-lightbox', 'Everything needed to create comics! A4 LED lightbox, manga markers, comic paper, stencils, and "How to Draw Comics" guide. Unleash your inner manga artist.', 'Complete comic art kit with LED lightbox', 1799.00, 2299.00, '11000000-0000-0000-0000-000000000003', 4, 'Copic', 'STN-ART-004', 1, 0, 4.7, 78, DATEADD(day, -4, GETUTCDATE())),
('20000000-0000-0000-0000-000000000052', 'Warm Winter Jacket - Puffer Style', 'warm-winter-jacket-puffer', 'Lightweight yet warm puffer jacket with synthetic fill. Water-resistant shell, zip pockets, elastic cuffs, detachable hood. Packs into its own pocket! Available in 6 colors.', 'Packable puffer jacket for chilly campus days', 1999.00, 2999.00, '10000000-0000-0000-0000-000000000004', 5, 'Decathlon', 'CLT-JKT-001', 1, 1, 4.7, 198, DATEADD(day, -8, GETUTCDATE())),
('20000000-0000-0000-0000-000000000053', 'Magnetic Alphabet Learning Set', 'magnetic-alphabet-learning-set', '78 colorful magnetic letters (uppercase, lowercase, numbers). Sticks to fridges, whiteboards, and included magnetic board. Builds letter recognition and early reading skills.', 'Magnetic letters for learning ABCs', 399.00, 549.00, '10000000-0000-0000-0000-000000000006', 1, 'LeapFrog', 'GFT-ALF-001', 1, 0, 4.6, 189, DATEADD(day, -12, GETUTCDATE())),
('20000000-0000-0000-0000-000000000054', 'Noise Cancelling Headphones (Student)', 'noise-cancelling-headphones-student', 'Affordable active noise cancelling headphones. 40-hour battery, built-in mic, foldable design. Bluetooth 5.3, multi-device pairing. Block out hostel noise and focus on studies.', 'ANC headphones for focused studying', 2499.00, 3499.00, '10000000-0000-0000-0000-000000000006', 5, 'Sony', 'GFT-HPH-001', 1, 1, 4.8, 345, DATEADD(day, -1, GETUTCDATE())),
('20000000-0000-0000-0000-000000000055', 'Fairy Tale Dress-Up Costume Set', 'fairy-tale-dress-up-costume-set', 'Be a princess, fairy, or superhero! 5 costume sets with accessories (crowns, wands, capes, masks). Premium fabrics, easy Velcro closures. Machine washable. Fits ages 3-6.', 'Magical dress-up set for imaginative play', 1299.00, 1799.00, '10000000-0000-0000-0000-000000000004', 1, 'Disney', 'CLT-COS-001', 1, 0, 4.7, 123, DATEADD(day, -14, GETUTCDATE())),
('20000000-0000-0000-0000-000000000056', 'Trendy Canvas Tote Bag', 'trendy-canvas-tote-bag', 'Oversized canvas tote with aesthetic print. Sturdy cotton canvas, inner pocket, magnetic snap closure. Fits laptop, books, and daily essentials. The IT bag on every college campus.', 'Aesthetic canvas tote for campus style', 599.00, 799.00, '10000000-0000-0000-0000-000000000003', 5, 'Chumbak', 'BAG-TOT-001', 1, 0, 4.5, 167, DATEADD(day, -6, GETUTCDATE())),
('20000000-0000-0000-0000-000000000057', 'Board Games Family Pack (4 Games)', 'board-games-family-pack-4', 'Classic family game night pack! Includes Monopoly Junior, Scrabble Junior, Guess Who, and Connect 4. Perfect for family bonding and rainy day entertainment. Ages 5+.', '4 classic board games for family fun', 1999.00, 2799.00, '10000000-0000-0000-0000-000000000006', 2, 'Hasbro', 'GFT-BRD-001', 1, 0, 4.8, 234, DATEADD(day, -20, GETUTCDATE())),
('20000000-0000-0000-0000-000000000058', 'Portable Whiteboard (A3, Double-sided)', 'portable-whiteboard-a3-double', 'Double-sided A3 whiteboard: one plain, one with grid lines. Includes 4 dry-erase markers, eraser, and stand. Perfect for math practice, brainstorming, and study revision.', 'Portable whiteboard for study sessions', 449.00, 599.00, '11000000-0000-0000-0000-000000000001', 3, 'Writey', 'STN-WBD-001', 1, 0, 4.4, 98, DATEADD(day, -9, GETUTCDATE())),
('20000000-0000-0000-0000-000000000059', 'Yoga Mat for Kids (with Poses Print)', 'yoga-mat-kids-poses-print', 'Child-sized yoga mat (150x60cm) with 12 yoga poses printed on it. Non-slip, easy-clean TPE material. Includes carry strap. Great for PE class and mindfulness practice.', 'Fun yoga mat with printed poses for kids', 599.00, 799.00, '10000000-0000-0000-0000-000000000005', 2, 'Boldfit', 'FSH-YGA-001', 1, 0, 4.5, 67, DATEADD(day, -17, GETUTCDATE())),
('20000000-0000-0000-0000-000000000060', 'Aesthetic Sticker Collection (500 pcs)', 'aesthetic-sticker-collection-500', '500 vinyl stickers in aesthetic, cute, and motivational themes. Waterproof, removable, no residue. Perfect for decorating laptops, water bottles, notebooks, and phone cases.', 'Massive sticker pack for personalizing everything', 299.00, 449.00, '11000000-0000-0000-0000-000000000001', 4, 'StickerBomb', 'STN-STK-001', 1, 1, 4.6, 456, DATEADD(day, -1, GETUTCDATE()));

-- =============================================
-- SEED DATA: PRODUCT VARIANTS
-- =============================================

-- Rainbow Gel Pens - no variants needed (it's a set)
-- Mechanical Pencil Pro - variants by lead size
INSERT INTO ProductVariants (ProductId, Name, Size, SKU, PriceAdjustment, StockQuantity) VALUES
('20000000-0000-0000-0000-000000000002', '0.5mm Lead', '0.5mm', 'STN-PEN-002-05', 0, 150),
('20000000-0000-0000-0000-000000000002', '0.7mm Lead', '0.7mm', 'STN-PEN-002-07', 0, 120);

-- Dinosaur Backpack - color variants
INSERT INTO ProductVariants (ProductId, Name, Color, SKU, PriceAdjustment, StockQuantity) VALUES
('20000000-0000-0000-0000-000000000021', 'Green Dino', 'Green', 'BAG-SCH-001-GRN', 0, 80),
('20000000-0000-0000-0000-000000000021', 'Blue Dino', 'Blue', 'BAG-SCH-001-BLU', 0, 65),
('20000000-0000-0000-0000-000000000021', 'Red Dino', 'Red', 'BAG-SCH-001-RED', 0, 45);

-- Urban Laptop Backpack - color variants
INSERT INTO ProductVariants (ProductId, Name, Color, SKU, PriceAdjustment, StockQuantity) VALUES
('20000000-0000-0000-0000-000000000022', 'Charcoal Black', 'Black', 'BAG-LAP-001-BLK', 0, 200),
('20000000-0000-0000-0000-000000000022', 'Navy Blue', 'Navy', 'BAG-LAP-001-NVY', 0, 150),
('20000000-0000-0000-0000-000000000022', 'Olive Green', 'Olive', 'BAG-LAP-001-OLV', 100, 75);

-- College Hoodie - size + color variants
INSERT INTO ProductVariants (ProductId, Name, Size, Color, SKU, PriceAdjustment, StockQuantity) VALUES
('20000000-0000-0000-0000-000000000028', 'S - Black', 'S', 'Black', 'CLT-HOD-001-S-BLK', 0, 50),
('20000000-0000-0000-0000-000000000028', 'M - Black', 'M', 'Black', 'CLT-HOD-001-M-BLK', 0, 80),
('20000000-0000-0000-0000-000000000028', 'L - Black', 'L', 'Black', 'CLT-HOD-001-L-BLK', 0, 100),
('20000000-0000-0000-0000-000000000028', 'XL - Black', 'XL', 'Black', 'CLT-HOD-001-XL-BLK', 0, 60),
('20000000-0000-0000-0000-000000000028', 'S - Grey', 'S', 'Grey', 'CLT-HOD-001-S-GRY', 0, 45),
('20000000-0000-0000-0000-000000000028', 'M - Grey', 'M', 'Grey', 'CLT-HOD-001-M-GRY', 0, 70),
('20000000-0000-0000-0000-000000000028', 'L - Grey', 'L', 'Grey', 'CLT-HOD-001-L-GRY', 0, 90),
('20000000-0000-0000-0000-000000000028', 'M - Maroon', 'M', 'Maroon', 'CLT-HOD-001-M-MRN', 0, 55);

-- Graphic Tee - size variants
INSERT INTO ProductVariants (ProductId, Name, Size, Color, SKU, PriceAdjustment, StockQuantity) VALUES
('20000000-0000-0000-0000-000000000027', 'S - Black', 'S', 'Black', 'CLT-TEE-001-S-BLK', 0, 60),
('20000000-0000-0000-0000-000000000027', 'M - Black', 'M', 'Black', 'CLT-TEE-001-M-BLK', 0, 90),
('20000000-0000-0000-0000-000000000027', 'L - White', 'L', 'White', 'CLT-TEE-001-L-WHT', 0, 70),
('20000000-0000-0000-0000-000000000027', 'XL - White', 'XL', 'White', 'CLT-TEE-001-XL-WHT', 0, 40);

-- Puffer Jacket - size variants
INSERT INTO ProductVariants (ProductId, Name, Size, Color, SKU, PriceAdjustment, StockQuantity) VALUES
('20000000-0000-0000-0000-000000000052', 'S - Black', 'S', 'Black', 'CLT-JKT-001-S-BLK', 0, 40),
('20000000-0000-0000-0000-000000000052', 'M - Black', 'M', 'Black', 'CLT-JKT-001-M-BLK', 0, 60),
('20000000-0000-0000-0000-000000000052', 'L - Navy', 'L', 'Navy', 'CLT-JKT-001-L-NVY', 0, 50),
('20000000-0000-0000-0000-000000000052', 'XL - Olive', 'XL', 'Olive', 'CLT-JKT-001-XL-OLV', 100, 30);

-- School Uniform - size variants
INSERT INTO ProductVariants (ProductId, Name, Size, SKU, PriceAdjustment, StockQuantity) VALUES
('20000000-0000-0000-0000-000000000026', 'Size 4-5 yrs', '4-5Y', 'CLT-UNI-001-4', 0, 100),
('20000000-0000-0000-0000-000000000026', 'Size 6-7 yrs', '6-7Y', 'CLT-UNI-001-6', 0, 120),
('20000000-0000-0000-0000-000000000026', 'Size 8-9 yrs', '8-9Y', 'CLT-UNI-001-8', 0, 90),
('20000000-0000-0000-0000-000000000026', 'Size 10-11 yrs', '10-11Y', 'CLT-UNI-001-10', 50, 80);

-- Products with no variants get default stock entry
INSERT INTO ProductVariants (ProductId, Name, SKU, StockQuantity) VALUES
('20000000-0000-0000-0000-000000000001', 'Default', 'STN-PEN-001-DEF', 500),
('20000000-0000-0000-0000-000000000003', 'Default', 'STN-PEN-003-DEF', 300),
('20000000-0000-0000-0000-000000000004', 'Default', 'STN-PEN-004-DEF', 150),
('20000000-0000-0000-0000-000000000005', 'Default', 'STN-PEN-005-DEF', 400),
('20000000-0000-0000-0000-000000000006', 'Default', 'STN-NB-001-DEF', 600),
('20000000-0000-0000-0000-000000000007', 'Default', 'STN-NB-002-DEF', 200),
('20000000-0000-0000-0000-000000000008', 'Default', 'STN-NB-003-DEF', 150),
('20000000-0000-0000-0000-000000000009', 'Default', 'STN-NB-004-DEF', 350),
('20000000-0000-0000-0000-000000000010', 'Default', 'STN-NB-005-DEF', 250),
('20000000-0000-0000-0000-000000000011', 'Default', 'STN-ART-001-DEF', 120),
('20000000-0000-0000-0000-000000000012', 'Default', 'STN-ART-002-DEF', 300),
('20000000-0000-0000-0000-000000000013', 'Default', 'STN-ART-003-DEF', 100),
('20000000-0000-0000-0000-000000000014', 'Default', 'BK-STR-001-DEF', 200),
('20000000-0000-0000-0000-000000000015', 'Default', 'BK-STR-002-DEF', 250),
('20000000-0000-0000-0000-000000000016', 'Default', 'BK-STR-003-DEF', 180),
('20000000-0000-0000-0000-000000000017', 'Default', 'BK-TXT-001-DEF', 500),
('20000000-0000-0000-0000-000000000018', 'Default', 'BK-REF-001-DEF', 300),
('20000000-0000-0000-0000-000000000019', 'Default', 'BK-STR-004-DEF', 250),
('20000000-0000-0000-0000-000000000020', 'Default', 'BK-REF-002-DEF', 200),
('20000000-0000-0000-0000-000000000023', 'Default', 'BAG-SCH-002-DEF', 100),
('20000000-0000-0000-0000-000000000024', 'Default', 'BAG-LUN-001-DEF', 200),
('20000000-0000-0000-0000-000000000025', 'Default', 'BAG-SCH-003-DEF', 150),
('20000000-0000-0000-0000-000000000029', 'Default', 'CLT-RCT-001-DEF', 80),
('20000000-0000-0000-0000-000000000030', 'Default', 'CLT-TRK-001-DEF', 200),
('20000000-0000-0000-0000-000000000031', 'Default', 'FSH-WCH-001-DEF', 300),
('20000000-0000-0000-0000-000000000032', 'Default', 'FSH-SGL-001-DEF', 150),
('20000000-0000-0000-0000-000000000033', 'Default', 'FSH-BRC-001-DEF', 180),
('20000000-0000-0000-0000-000000000034', 'Default', 'FSH-WLT-001-DEF', 120),
('20000000-0000-0000-0000-000000000035', 'Default', 'FSH-HAR-001-DEF', 250),
('20000000-0000-0000-0000-000000000036', 'Default', 'GFT-STM-001-DEF', 150),
('20000000-0000-0000-0000-000000000037', 'Default', 'GFT-STM-002-DEF', 80),
('20000000-0000-0000-0000-000000000038', 'Default', 'GFT-PZL-001-DEF', 200),
('20000000-0000-0000-0000-000000000039', 'Default', 'GFT-SCI-001-DEF', 120),
('20000000-0000-0000-0000-000000000040', 'Default', 'GFT-SPK-001-DEF', 250),
('20000000-0000-0000-0000-000000000041', 'Default', 'STN-DSK-001-DEF', 100),
('20000000-0000-0000-0000-000000000042', 'Default', 'STN-GEO-001-DEF', 350),
('20000000-0000-0000-0000-000000000043', 'Default', 'FSH-BTL-001-DEF', 200),
('20000000-0000-0000-0000-000000000044', 'Default', 'GFT-LMP-001-DEF', 150),
('20000000-0000-0000-0000-000000000045', 'Default', 'GFT-PLY-001-DEF', 250),
('20000000-0000-0000-0000-000000000046', 'Default', 'STN-LBL-001-DEF', 400),
('20000000-0000-0000-0000-000000000047', 'Default', 'GFT-ARD-001-DEF', 60),
('20000000-0000-0000-0000-000000000048', 'Default', 'GFT-CHR-001-DEF', 40),
('20000000-0000-0000-0000-000000000049', 'Default', 'BAG-TFN-001-DEF', 200),
('20000000-0000-0000-0000-000000000050', 'Default', 'STN-CAL-001-DEF', 300),
('20000000-0000-0000-0000-000000000051', 'Default', 'STN-ART-004-DEF', 50),
('20000000-0000-0000-0000-000000000053', 'Default', 'GFT-ALF-001-DEF', 180),
('20000000-0000-0000-0000-000000000054', 'Default', 'GFT-HPH-001-DEF', 100),
('20000000-0000-0000-0000-000000000055', 'Default', 'CLT-COS-001-DEF', 80),
('20000000-0000-0000-0000-000000000056', 'Default', 'BAG-TOT-001-DEF', 200),
('20000000-0000-0000-0000-000000000057', 'Default', 'GFT-BRD-001-DEF', 120),
('20000000-0000-0000-0000-000000000058', 'Default', 'STN-WBD-001-DEF', 150),
('20000000-0000-0000-0000-000000000059', 'Default', 'FSH-YGA-001-DEF', 100),
('20000000-0000-0000-0000-000000000060', 'Default', 'STN-STK-001-DEF', 500);

-- =============================================
-- SEED DATA: PRODUCT IMAGES (using placeholder URLs)
-- =============================================
INSERT INTO ProductImages (ProductId, Url, AltText, SortOrder, IsPrimary)
SELECT Id, '/images/products/' + Slug + '.jpg', Name, 0, 1
FROM Products;

-- =============================================
-- SEED DATA: REVIEWS
-- =============================================
DECLARE @reviewUsers TABLE (UserId UNIQUEIDENTIFIER, Name NVARCHAR(50));
INSERT INTO @reviewUsers VALUES
(NEWID(), 'Priya S.'), (NEWID(), 'Rahul M.'), (NEWID(), 'Anita K.'), (NEWID(), 'Vikram T.'),
(NEWID(), 'Sneha P.'), (NEWID(), 'Arjun D.'), (NEWID(), 'Meera R.'), (NEWID(), 'Karan J.'),
(NEWID(), 'Pooja L.'), (NEWID(), 'Amit B.'), (NEWID(), 'Neha G.'), (NEWID(), 'Rohan S.');

INSERT INTO Reviews (ProductId, UserId, UserDisplayName, Rating, Title, Comment, IsVerifiedPurchase, IsApproved, CreatedAt) VALUES
('20000000-0000-0000-0000-000000000001', NEWID(), 'Priya S.', 5, 'Kids love these!', 'My daughter uses these for all her school projects. Colors are vibrant and the pens last long. Will buy again!', 1, 1, DATEADD(day, -10, GETUTCDATE())),
('20000000-0000-0000-0000-000000000001', NEWID(), 'Rahul M.', 4, 'Good quality', 'Nice gel pens. One pen had slightly less ink but overall great value for money.', 1, 1, DATEADD(day, -8, GETUTCDATE())),
('20000000-0000-0000-0000-000000000003', NEWID(), 'Anita K.', 5, 'Perfect for toddlers', 'These crayons are amazing for my 3-year-old. Thick enough for tiny hands, and the triangular shape prevents rolling off the table. Highly recommend!', 1, 1, DATEADD(day, -5, GETUTCDATE())),
('20000000-0000-0000-0000-000000000007', NEWID(), 'Sneha P.', 5, 'My daughter''s favorite!', 'The lock makes her feel so special. Quality is excellent and she writes in it every night before bed.', 1, 1, DATEADD(day, -2, GETUTCDATE())),
('20000000-0000-0000-0000-000000000014', NEWID(), 'Meera R.', 5, 'Fantastic series!', 'My son (7) is hooked! He finished all 8 books in a month. Great way to develop reading habit.', 1, 1, DATEADD(day, -20, GETUTCDATE())),
('20000000-0000-0000-0000-000000000016', NEWID(), 'Karan J.', 5, 'Magical collection', 'Every kid needs this. Beautiful cover art, good paper quality. My niece was thrilled with this birthday gift!', 1, 1, DATEADD(day, -30, GETUTCDATE())),
('20000000-0000-0000-0000-000000000018', NEWID(), 'Vikram T.', 5, 'Life changing book', 'Read this in my first year of college and it completely transformed my study habits. Must read!', 1, 1, DATEADD(day, -15, GETUTCDATE())),
('20000000-0000-0000-0000-000000000021', NEWID(), 'Amit B.', 5, 'Son loves it!', 'The 3D dinosaur design is so cool. My son proudly carries it to school every day. Very sturdy too.', 1, 1, DATEADD(day, -6, GETUTCDATE())),
('20000000-0000-0000-0000-000000000022', NEWID(), 'Rohan S.', 5, 'Best laptop bag', 'Clean design, fits my 15" MacBook perfectly. The anti-theft pocket is a great feature for college commute.', 1, 1, DATEADD(day, -3, GETUTCDATE())),
('20000000-0000-0000-0000-000000000028', NEWID(), 'Neha G.', 5, 'So cozy!', 'Living in this hoodie. The oversized fit is perfect and it''s so warm. Got it in black and ordering grey too.', 1, 1, DATEADD(day, -4, GETUTCDATE())),
('20000000-0000-0000-0000-000000000036', NEWID(), 'Pooja L.', 5, 'Educational and fun', 'My kids spend hours building things. Much better than screen time. The project cards give great ideas.', 1, 1, DATEADD(day, -7, GETUTCDATE())),
('20000000-0000-0000-0000-000000000040', NEWID(), 'Arjun D.', 5, 'Amazing sound quality', 'Can''t believe the sound from such a small speaker. Perfect for my dorm room. Battery lasts forever.', 1, 1, DATEADD(day, -2, GETUTCDATE())),
('20000000-0000-0000-0000-000000000054', NEWID(), 'Vikram T.', 5, 'Focus mode ON', 'These headphones saved my grades. The noise cancelling blocks out all hostel noise. Worth every rupee.', 1, 1, DATEADD(day, -1, GETUTCDATE()));

-- =============================================
-- SEED DATA: COUPONS
-- =============================================
INSERT INTO Coupons (Code, Description, Type, Value, MinimumOrderAmount, MaximumDiscount, UsageLimit, PerUserLimit, ValidFrom, ValidTo, IsActive, RestrictedToAgeGroup) VALUES
('WELCOME10', 'Welcome discount - 10% off first order', 1, 10, 299, 500, NULL, 1, '2026-01-01', '2026-12-31', 1, NULL),
('BACKTOSCHOOL', 'Back to school - 20% off stationery & books', 1, 20, 499, 1000, 5000, 2, '2026-03-01', '2026-04-30', 1, NULL),
('STUDENT15', 'Student exclusive - 15% off everything', 1, 15, 399, 750, NULL, 3, '2026-01-01', '2026-12-31', 1, NULL),
('FLAT200', 'Flat Rs.200 off on orders above Rs.999', 2, 200, 999, NULL, 2000, 1, '2026-03-15', '2026-04-15', 1, NULL),
('KIDSFIRST', 'Kids category - 25% off for toddlers', 1, 25, 299, 500, 1000, 2, '2026-03-01', '2026-05-31', 1, 1),
('COLLEGE20', 'College special - 20% off', 1, 20, 799, 1500, 3000, 2, '2026-03-01', '2026-06-30', 1, 5),
('SUMMER30', 'Summer sale - 30% off sitewide', 1, 30, 599, 2000, 10000, 1, '2026-04-01', '2026-06-30', 1, NULL),
('FLAT500', 'Flat Rs.500 off on orders above Rs.2499', 2, 500, 2499, NULL, 1000, 1, '2026-03-20', '2026-04-20', 1, NULL);

-- =============================================
-- SEED DATA: SAMPLE ORDERS (for demo)
-- =============================================
DECLARE @userId1 UNIQUEIDENTIFIER = NEWID();
DECLARE @userId2 UNIQUEIDENTIFIER = NEWID();
DECLARE @orderId1 UNIQUEIDENTIFIER = NEWID();
DECLARE @orderId2 UNIQUEIDENTIFIER = NEWID();
DECLARE @orderId3 UNIQUEIDENTIFIER = NEWID();

INSERT INTO Orders (Id, OrderNumber, UserId, Status, ShippingAddress_Line1, ShippingAddress_City, ShippingAddress_State, ShippingAddress_PostalCode, SubTotal, DiscountAmount, ShippingAmount, TaxAmount, TotalAmount, CouponCode, CreatedAt) VALUES
(@orderId1, 'KC-20260325-A1B2C3D4', @userId1, 5, '42 MG Road, Koramangala', 'Bangalore', 'Karnataka', '560034', 2547.00, 254.70, 0, 458.46, 2750.76, 'WELCOME10', DATEADD(day, -5, GETUTCDATE())),
(@orderId2, 'KC-20260328-E5F6G7H8', @userId1, 4, '42 MG Road, Koramangala', 'Bangalore', 'Karnataka', '560034', 1299.00, 0, 49, 233.82, 1581.82, NULL, DATEADD(day, -2, GETUTCDATE())),
(@orderId3, 'KC-20260330-I9J0K1L2', @userId2, 1, '15 Linking Road, Bandra', 'Mumbai', 'Maharashtra', '400050', 3798.00, 500, 0, 683.64, 3981.64, 'FLAT500', GETUTCDATE());

INSERT INTO OrderItems (OrderId, ProductId, ProductName, VariantName, Quantity, UnitPrice) VALUES
(@orderId1, '20000000-0000-0000-0000-000000000001', 'Rainbow Gel Pen Set (12 Colors)', NULL, 2, 249.00),
(@orderId1, '20000000-0000-0000-0000-000000000007', 'Unicorn Diary with Lock', NULL, 1, 399.00),
(@orderId1, '20000000-0000-0000-0000-000000000014', 'The Magic Treehouse Collection (Books 1-8)', NULL, 1, 1299.00),
(@orderId1, '20000000-0000-0000-0000-000000000046', 'Personalized Name Labels (100 pcs)', NULL, 1, 299.00),
(@orderId2, '20000000-0000-0000-0000-000000000028', 'College Hoodie - Classic Fit', 'M - Black', 1, 1299.00),
(@orderId3, '20000000-0000-0000-0000-000000000022', 'Urban Slim Laptop Backpack (15.6")', 'Charcoal Black', 1, 1799.00),
(@orderId3, '20000000-0000-0000-0000-000000000018', 'Atomic Habits by James Clear', NULL, 1, 399.00),
(@orderId3, '20000000-0000-0000-0000-000000000040', 'Wireless Bluetooth Speaker (Mini)', NULL, 1, 1499.00);

INSERT INTO PaymentRecords (OrderId, GatewayName, GatewayTransactionId, Amount, Status) VALUES
(@orderId1, 'Razorpay', 'pay_ABC123456789', 2750.76, 3),
(@orderId2, 'Razorpay', 'pay_DEF987654321', 1581.82, 3),
(@orderId3, 'Razorpay', 'pay_GHI456789012', 3981.64, 1);

PRINT 'Seed data loaded successfully!';
PRINT 'Products: 60';
PRINT 'Categories: 16 (6 root + 10 sub)';
PRINT 'Variants: ~80';
PRINT 'Reviews: 13';
PRINT 'Coupons: 8';
PRINT 'Sample Orders: 3';
GO
