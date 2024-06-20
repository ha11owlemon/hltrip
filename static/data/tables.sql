-- 房屋概览表
CREATE TABLE IF NOT EXISTS house_overview (
    houseId INT AUTO_INCREMENT PRIMARY KEY,
    coverUrl VARCHAR(255) NOT NULL,
    bedCount INT NOT NULL,
    roomCount INT NOT NULL,
    discountPrice DECIMAL(10, 2) NOT NULL,
    originalPrice DECIMAL(10, 2),
    viewCount INT default 0,
    favoriteCount INT default 0,
    dealCount INT default 0,
    houseName VARCHAR(255),
    address VARCHAR(255),
    rentalType ENUM('单间出租', '整套出租') NOT NULL,
    bathroomCount INT NOT NULL,
    kitchenCount INT NOT NULL,
    maxGuests INT NOT NULL,
    houseType ENUM('普通公寓', '别墅/loft', '庄园', '酒店式公寓', '客栈', '复式loft') NOT NULL,
    landlordId INT,
    landlordNickname VARCHAR(255),
    bed218 INT,
    bed215 INT,
    bed212 INT,
    tatami VARCHAR(255),
    commentCount INT,
    rating DECIMAL(3, 1)
);

-- 房屋位置表
CREATE TABLE IF NOT EXISTS house_location (
    locationId INT AUTO_INCREMENT PRIMARY KEY,
    location VARCHAR(255) NOT NULL,
    houseId INT NOT NULL,
    regeocodingAddress VARCHAR(255) NOT NULL,
    province VARCHAR(255) NOT NULL,
    city VARCHAR(255) NOT NULL,
    county VARCHAR(255) NOT NULL,
    town VARCHAR(255)
);

-- 房屋设施表
CREATE TABLE IF NOT EXISTS house_facilities (
    facilitiesId INT AUTO_INCREMENT PRIMARY KEY,
    houseId INT NOT NULL,
    service INT NOT NULL,
    basic INT NOT NULL,
    bathroom INT NOT NULL,
    kitchen INT NOT NULL,
    surrounding INT,
    safety INT NOT NULL,
    entertainment INT NOT NULL,
    leisure INT NOT NULL,
    children INT NOT NULL
);

-- 评论表
CREATE TABLE IF NOT EXISTS comments (
    commentId INT AUTO_INCREMENT PRIMARY KEY,
		houseId INT NOT NULL,
    userId INT NOT NULL,
    username VARCHAR(255) NOT NULL,
    commentContent TEXT,
    landlordReply TEXT,
    landlordId INT,
    hasImage BOOLEAN,
    cleanliness DECIMAL(3, 1) NOT NULL,
    accuracy DECIMAL(3, 1) NOT NULL,
    locationTransport DECIMAL(3, 1) NOT NULL,
    safety DECIMAL(3, 1) NOT NULL,
    valueForMmoney DECIMAL(3, 1) NOT NULL,
    rating DECIMAL(3, 1) NOT NULL
);

-- 评论图片表
CREATE TABLE IF NOT EXISTS comment_images (
    imageId INT AUTO_INCREMENT PRIMARY KEY,
    commentId INT NOT NULL,
    url VARCHAR(255),
    imgPath VARCHAR(255),
    userId INT
);

-- 房源特色表
CREATE TABLE IF NOT EXISTS house_features (
    featureId INT AUTO_INCREMENT PRIMARY KEY,
    houseId INT NOT NULL,
    featureType VARCHAR(255),
    featureContent VARCHAR(255)
);

-- 房屋图片表
CREATE TABLE IF NOT EXISTS house_images (
    imageId INT AUTO_INCREMENT PRIMARY KEY,
    houseId INT NOT NULL,
    imageType ENUM('卧室', '客厅', '卫生间', '厨房', '其他') NOT NULL,
    url VARCHAR(255) NOT NULL,
    imgPath VARCHAR(255),
    uploadTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 政策表
CREATE TABLE IF NOT EXISTS policies (
    policyId INT AUTO_INCREMENT PRIMARY KEY,
    houseId INT NOT NULL,
    cancelPolicy ENUM('1', '2', '30') NOT NULL,
    allowAddGuests INT DEFAULT 0,
    deposit INT DEFAULT 0,
    needToKnow INT
);

-- 用户浏览记录表
CREATE TABLE IF NOT EXISTS user_browsing_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    userId INT NOT NULL,
    houseIds TEXT
);

-- 用户收藏表
CREATE TABLE IF NOT EXISTS user_favorites (
    id INT AUTO_INCREMENT PRIMARY KEY,
    userId INT NOT NULL,
    houseId INT NOT NULL
);

-- 入住人信息表
CREATE TABLE IF NOT EXISTS guest_information (
    id INT AUTO_INCREMENT PRIMARY KEY,
    userId INT NOT NULL,
    idNumber VARCHAR(255) NOT NULL,
    realName VARCHAR(255) NOT NULL
);

-- 预定表
CREATE TABLE IF NOT EXISTS bookings (
    bookingId INT AUTO_INCREMENT PRIMARY KEY,
    houseId INT,
    sdate DATE NOT NULL,
    edate DATE NOT NULL,
    userId INT NOT NULL,
    bstatus ENUM('Booked', 'Cancelled') NOT NULL
);
CREATE TABLE IF NOT EXISTS landlords (
    landlordId INT AUTO_INCREMENT PRIMARY KEY,
		nickname VARCHAR(255),
    avatar VARCHAR(255),
    balance DECIMAL(10, 2)
);
CREATE TABLE IF NOT EXISTS avatars (
    avatarId INT AUTO_INCREMENT PRIMARY KEY,
    url VARCHAR(255),
    imgpath VARCHAR(255),
    uid INT NOT NULL
);