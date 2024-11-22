use bai8;
-- Liệt kê tất cả các thông tin về sản phẩm (products)
SELECT * FROM products;
-- Tìm tất cả các đơn hàng (orders) có tổng giá trị (totalPrice) lớn hơn 500,000
SELECT * FROM orders WHERE totalPrice > 500000;
-- Liệt kê tên và địa chỉ của tất cả các cửa hàng (stores)
SELECT storeName, addressStore FROM stores;
-- Tìm tất cả người dùng (users) có địa chỉ email kết thúc bằng '@gmail.com
SELECT * FROM users WHERE email LIKE '%@gmail.com';
-- Hiển thị tất cả các đánh giá (reviews) với mức đánh giá (rate) bằng 5
SELECT * FROM reviews WHERE rate = 5;
-- Liệt kê tất cả các sản phẩm có số lượng (quantity) dưới 10
SELECT * FROM products WHERE quantity < 10;
-- Tìm tất cả các sản phẩm thuộc danh mục categoryId = 1
SELECT * FROM products WHERE categoryId = 1;
-- Đếm số lượng người dùng (users) có trong hệ thống
SELECT COUNT(*) AS userCount FROM users;
-- Tính tổng giá trị của tất cả các đơn hàng (orders)
SELECT SUM(totalPrice) AS totalOrderValue FROM orders;
-- Tìm sản phẩm có giá cao nhất (price)
SELECT * FROM products WHERE price = (SELECT MAX(price) FROM products);
-- Liệt kê tất cả các cửa hàng đang hoạt động (statusStore = 1)
SELECT * FROM stores WHERE statusStore = 1;
-- Đếm số lượng sản phẩm theo từng danh mục (categories)
SELECT categoryId, COUNT(*) AS productCount FROM products GROUP BY categoryId;
-- Tìm tất cả các sản phẩm mà chưa từng có đánh giá
SELECT * 
FROM products p
LEFT JOIN reviews r ON p.productId = r.productId
WHERE r.productId IS NULL;
-- Hiển thị tổng số lượng hàng đã bán (quantityOrder) của từng sản phẩm
SELECT productId, SUM(quantityOrder) AS totalSold
FROM order_details
GROUP BY productId;
-- Tìm các người dùng (users) chưa đặt bất kỳ đơn hàng nào
SELECT * 
FROM users u
LEFT JOIN orders o ON u.userId = o.userId
WHERE o.userId IS NULL;
-- Hiển thị tên cửa hàng và tổng số đơn hàng được thực hiện tại từng cửa hàng
SELECT s.storeName, COUNT(o.orderId) AS totalOrders
FROM stores s
LEFT JOIN orders o ON s.storeId = o.storeId
GROUP BY s.storeId;
-- Hiển thị thông tin của sản phẩm, kèm số lượng hình ảnh liên quan
SELECT p.*, COUNT(i.imageId) AS imageCount
FROM products p
LEFT JOIN images i ON p.productId = i.productId
GROUP BY p.productId;
-- Hiển thị các sản phẩm kèm số lượng đánh giá và đánh giá trung bình
SELECT p.productId, p.productName, COUNT(r.reviewId) AS reviewCount, AVG(r.rate) AS averageRate
FROM products p
LEFT JOIN reviews r ON p.productId = r.productId
GROUP BY p.productId;
-- Tìm người dùng có số lượng đánh giá nhiều nhất
SELECT userId, COUNT(reviewId) AS reviewCount
FROM reviews
GROUP BY userId
ORDER BY reviewCount DESC
LIMIT 1;
-- Hiển thị top 3 sản phẩm bán chạy nhất (dựa trên số lượng đã bán)
SELECT productId, SUM(quantityOrder) AS totalSold
FROM order_details
GROUP BY productId
ORDER BY totalSold DESC
LIMIT 3;
-- Tìm sản phẩm bán chạy nhất tại cửa hàng có storeId = 'S001'
SELECT od.productId, SUM(od.quantityOrder) AS totalSold
FROM order_details od
JOIN products p ON od.productId = p.productId
WHERE p.storeId = 'S001'
GROUP BY od.productId
ORDER BY totalSold DESC
LIMIT 1;
-- Hiển thị danh sách tất cả các sản phẩm có giá trị tồn kho lớn hơn 1 triệu (giá * số lượng)
SELECT * FROM products WHERE price * quantity > 1000000;
-- Tìm cửa hàng có tổng doanh thu cao nhất
SELECT s.storeId, s.storeName, SUM(od.priceOrder * od.quantityOrder) AS totalRevenue
FROM stores s
JOIN products p ON s.storeId = p.storeId
JOIN order_details od ON p.productId = od.productId
GROUP BY s.storeId
ORDER BY totalRevenue DESC
LIMIT 1;
-- Hiển thị danh sách người dùng và tổng số tiền họ đã chi tiêu
SELECT u.userId, u.userName, SUM(o.totalPrice) AS totalSpent
FROM users u
JOIN orders o ON u.userId = o.userId
GROUP BY u.userId;
-- Tìm đơn hàng có tổng giá trị cao nhất và liệt kê thông tin chi tiết
SELECT * 
FROM orders 
WHERE totalPrice = (SELECT MAX(totalPrice) FROM orders);
-- Tính số lượng sản phẩm trung bình được bán ra trong mỗi đơn hàng
SELECT AVG(quantityOrder) AS avgProductsPerOrder FROM order_details;
-- Hiển thị tên sản phẩm và số lần sản phẩm đó được thêm vào giỏ hàng
SELECT p.productName, COUNT(c.cartId) AS cartCount
FROM products p
LEFT JOIN carts c ON p.productId = c.productId
GROUP BY p.productId;
-- Tìm tất cả các sản phẩm đã bán nhưng không còn tồn kho trong kho hàng
SELECT * FROM products WHERE quantitySold > 0 AND quantity = 0;
-- Tìm các đơn hàng được thực hiện bởi người dùng có email là 'duong@gmail.com'
SELECT o.*
FROM orders o
JOIN users u ON o.userId = u.userId
WHERE u.email = 'duong@gmail.com';
-- Hiển thị danh sách các cửa hàng kèm theo tổng số lượng sản phẩm mà họ sở hữu
SELECT s.storeName, SUM(p.quantity) AS totalProducts
FROM stores s
LEFT JOIN products p ON s.storeId = p.storeId
GROUP BY s.storeId;
-- EX4
-- Tạo view expensive_products
CREATE VIEW expensive_products AS
SELECT productName, price
FROM products
WHERE price > 500000;
-- Truy vấn dữ liệu từ view expensive_products
SELECT * FROM expensive_products;
-- Cập nhật giá trị của view
UPDATE products
SET price = 600000
WHERE productName = 'Product A' AND price > 500000;
-- Xóa view expensive_products
DROP VIEW IF EXISTS expensive_products;
-- Tạo view hiển thị productName và categoryName
CREATE VIEW product_categories AS
SELECT p.productName, c.categoryName
FROM products p
JOIN categories c ON p.categoryId = c.categoryId;
-- Ex5
--  Tạo index trên cột productName của bảng products
CREATE INDEX idx_productName ON products(productName);
-- Hiển thị danh sách các index trong cơ sở dữ liệu
SHOW INDEX FROM products;
-- Xóa index idx_productName
DROP INDEX idx_productName ON products;
-- Tạo procedure getProductByPrice
DELIMITER $$

CREATE PROCEDURE getProductByPrice(IN priceInput INT)
BEGIN
    SELECT * FROM products
    WHERE price > priceInput;
END$$

DELIMITER ;
-- Gọi procedure getProductByPrice
CALL getProductByPrice(500000);
-- Tạo procedure getOrderDetails
DELIMITER $$

CREATE PROCEDURE getOrderDetails(IN orderIdInput VARCHAR(255))
BEGIN
    SELECT od.*, p.productName, o.totalPrice
    FROM order_details od
    JOIN products p ON od.productId = p.productId
    JOIN orders o ON od.orderId = o.orderId
    WHERE od.orderId = orderIdInput;
END$$

DELIMITER ;
-- Xóa procedure getOrderDetails:
DROP PROCEDURE IF EXISTS getOrderDetails;
-- Tạo procedure addNewProduct
DELIMITER $$

CREATE PROCEDURE addNewProduct(
    IN productNameInput VARCHAR(255),
    IN priceInput INT,
    IN descriptionInput LONGTEXT,
    IN quantityInput INT
)
BEGIN
    INSERT INTO products (productName, price, description, quantity)
    VALUES (productNameInput, priceInput, descriptionInput, quantityInput);
END$$

DELIMITER ;
-- Tạo procedure deleteProductById
DELIMITER $$

CREATE PROCEDURE deleteProductById(IN productIdInput VARCHAR(255))
BEGIN
    DELETE FROM products WHERE productId = productIdInput;
END$$

DELIMITER ;
-- Tạo procedure searchProductByName
DELIMITER $$

CREATE PROCEDURE searchProductByName(IN searchName VARCHAR(255))
BEGIN
    SELECT * FROM products
    WHERE productName LIKE CONCAT('%', searchName, '%');
END$$

DELIMITER ;
-- Tạo procedure filterProductsByPriceRange
DELIMITER $$

CREATE PROCEDURE filterProductsByPriceRange(IN minPrice INT, IN maxPrice INT)
BEGIN
    SELECT * FROM products
    WHERE price BETWEEN minPrice AND maxPrice;
END$$

DELIMITER ;
-- Tạo procedure paginateProducts
DELIMITER $$

CREATE PROCEDURE paginateProducts(IN pageNumber INT, IN pageSize INT)
BEGIN
    SET @offset = (pageNumber - 1) * pageSize;
    SET @limit = pageSize;

    SET @query = CONCAT(
        'SELECT * FROM products LIMIT ',
        @limit,
        ' OFFSET ',
        @offset
    );

    PREPARE stmt FROM @query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$

DELIMITER ;


