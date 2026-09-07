INSERT INTO products(name,category,description,price,stock,rating) VALUES
('Wireless Headphones','Electronics','Immersive wireless audio with all-day battery.',2999,50,4.6),
('Smart Watch','Electronics','Fitness tracking, notifications and bright display.',4499,35,4.5),
('Everyday Sneakers','Fashion','Lightweight sneakers for daily comfort.',2499,70,4.7),
('Minimal Backpack','Fashion','Durable everyday backpack with smart storage.',1899,45,4.4),
('Desk Lamp','Home','Adjustable lamp for a focused workspace.',1299,80,4.3),
('Coffee Maker','Home','Compact coffee maker for fresh coffee at home.',3599,25,4.6)
ON CONFLICT DO NOTHING;

INSERT INTO coupons(code,discount_percent,max_discount) VALUES ('WELCOME10',10,500) ON CONFLICT DO NOTHING;
