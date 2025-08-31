-- USERS
INSERT INTO users (first_name, last_name, email, password_hash, phone_number, role)
VALUES
('Alice', 'Johnson', 'alice@example.com', 'hashed_pw1', '+212600000001', 'host'),
('Bob', 'Smith', 'bob@example.com', 'hashed_pw2', '+212600000002', 'guest'),
('Charlie', 'Brown', 'charlie@example.com', 'hashed_pw3', '+212600000003', 'guest'),
('Diana', 'Lopez', 'diana@example.com', 'hashed_pw4', '+212600000004', 'host');

-- PROPERTIES
INSERT INTO properties (host_id, name, description, location, price_per_night)
VALUES
((SELECT user_id FROM users WHERE email = 'alice@example.com'),
 'Seaside Villa', 'Beautiful villa by the beach with pool.', 'Essaouira, Morocco', 120.00),
((SELECT user_id FROM users WHERE email = 'diana@example.com'),
 'City Apartment', 'Modern apartment in the heart of the city.', 'Marrakech, Morocco', 75.00);

-- BOOKINGS
INSERT INTO bookings (property_id, user_id, start_date, end_date, total_price, status)
VALUES
((SELECT property_id FROM properties WHERE name = 'Seaside Villa'),
 (SELECT user_id FROM users WHERE email = 'bob@example.com'),
 '2025-09-10', '2025-09-15', 600.00, 'confirmed'),
((SELECT property_id FROM properties WHERE name = 'City Apartment'),
 (SELECT user_id FROM users WHERE email = 'charlie@example.com'),
 '2025-09-20', '2025-09-22', 150.00, 'pending');

-- PAYMENTS
INSERT INTO payments (booking_id, amount, payment_method)
VALUES
((SELECT booking_id FROM bookings WHERE status = 'confirmed' LIMIT 1), 600.00, 'credit_card');

-- REVIEWS
INSERT INTO reviews (property_id, user_id, rating, comment)
VALUES
((SELECT property_id FROM properties WHERE name = 'Seaside Villa'),
 (SELECT user_id FROM users WHERE email = 'bob@example.com'),
 5, 'Amazing stay! The villa was clean and the host was very helpful.'),
((SELECT property_id FROM properties WHERE name = 'City Apartment'),
 (SELECT user_id FROM users WHERE email = 'charlie@example.com'),
 4, 'Great location, but a bit noisy at night.');

-- MESSAGES
INSERT INTO messages (sender_id, recipient_id, message_body)
VALUES
((SELECT user_id FROM users WHERE email = 'bob@example.com'),
 (SELECT user_id FROM users WHERE email = 'alice@example.com'),
 'Hi Alice, is the Seaside Villa available in October?'),
((SELECT user_id FROM users WHERE email = 'alice@example.com'),
 (SELECT user_id FROM users WHERE email = 'bob@example.com'),
 'Hi Bob, yes it is available. Let me know your dates!');
