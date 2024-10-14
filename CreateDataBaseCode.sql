USE CustomerManagement;

-- Drop tables if they already exist to avoid conflicts
DROP TABLE IF EXISTS CustomerSupportTickets;
DROP TABLE IF EXISTS Payments;
DROP TABLE IF EXISTS ShoppingCart;
DROP TABLE IF EXISTS Wishlists;
DROP TABLE IF EXISTS CustomerReviews;
DROP TABLE IF EXISTS OrderItems;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Categories;
DROP TABLE IF EXISTS Brands;
DROP TABLE IF EXISTS CustomerPreferences;
DROP TABLE IF EXISTS Customers;

-- 1. Customers Table
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100),
    Email NVARCHAR(100) UNIQUE NOT NULL,
    PhoneNumber NVARCHAR(20),
    ShippingAddress NVARCHAR(255),
    BillingAddress NVARCHAR(255),
    DateOfBirth DATE,
    LoyaltyPoints INT DEFAULT 0,
    Preferences NVARCHAR(MAX)
);

-- 2. Customer Preferences Table
CREATE TABLE CustomerPreferences (
    CustomerID INT PRIMARY KEY,
    PreferredCategories NVARCHAR(255),
    PreferredBrands NVARCHAR(255),
    PreferredPaymentMethods NVARCHAR(255),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- 3. Categories Table
CREATE TABLE Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(255),
    Description NVARCHAR(MAX)
);

-- 4. Brands Table
CREATE TABLE Brands (
    BrandID INT IDENTITY(1,1) PRIMARY KEY,
    BrandName NVARCHAR(255),
    Description NVARCHAR(MAX)
);

-- 5. Products Table
CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName NVARCHAR(255),
    CategoryID INT,
    BrandID INT,
    Price DECIMAL(10, 2),
    StockQuantity INT,
    Rating DECIMAL(3, 2),
    Description NVARCHAR(MAX),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
    FOREIGN KEY (BrandID) REFERENCES Brands(BrandID)
);

-- 6. Orders Table
CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT,
    OrderDate DATETIME DEFAULT GETDATE(),
    ShippingAddress NVARCHAR(255),
    BillingAddress NVARCHAR(255),
    OrderTotal DECIMAL(10, 2),
    PaymentMethod NVARCHAR(50),
    OrderStatus NVARCHAR(50),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- 7. Order Items Table
CREATE TABLE OrderItems (
    OrderItemID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    UnitPrice DECIMAL(10, 2),
    TotalPrice AS (Quantity * UnitPrice),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- 8. Customer Reviews Table
CREATE TABLE CustomerReviews (
    ReviewID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT,
    ProductID INT,
    Rating DECIMAL(3, 2),
    ReviewText NVARCHAR(MAX),
    ReviewDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- 9. Wishlists Table
CREATE TABLE Wishlists (
    WishlistID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT,
    ProductID INT,
    AddedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- 10. Shopping Cart Table
CREATE TABLE ShoppingCart (
    CartID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT,
    ProductID INT,
    Quantity INT,
    DateAdded DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- 11. Payments Table
CREATE TABLE Payments (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    PaymentMethod NVARCHAR(50),
    PaymentDate DATETIME DEFAULT GETDATE(),
    Amount DECIMAL(10, 2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- 12. Customer Support Tickets Table
CREATE TABLE CustomerSupportTickets (
    TicketID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT,
    OrderID INT,
    IssueType NVARCHAR(100),
    Description NVARCHAR(MAX),
    Status NVARCHAR(50),
    CreatedDate DATETIME DEFAULT GETDATE(),
    ResolvedDate DATETIME,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

