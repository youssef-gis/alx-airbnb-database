-- Enable extension 
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS citext;

-- USER Table
CREATE TABLE users (
  user_id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  email CITEXT NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  phone_number VARCHAR(20),
  role VARCHAR(20) NOT NULL CHECK (role IN ('host', 'guest', 'admin')),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- MESSAGE Table
CREATE TABLE messages (
  message_id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
  sender_id UUID NOT NULL,
  recipient_id UUID NOT NULL,
  message_body TEXT NOT NULL,
  sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_sender FOREIGN KEY (sender_id) REFERENCES users (user_id) ON DELETE CASCADE,
  CONSTRAINT fk_recipient FOREIGN KEY (recipient_id) REFERENCES users (user_id) ON DELETE CASCADE
);

-- PROPERTY Table
CREATE TABLE properties (
  property_id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
  host_id UUID NOT NULL,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  location VARCHAR(255) NOT NULL,
  price_per_night DECIMAL(10, 2) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_host FOREIGN KEY (host_id) REFERENCES users (user_id) ON DELETE CASCADE
);

-- BOOKING Table
CREATE TABLE bookings (
  booking_id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
  property_id UUID NOT NULL,
  user_id UUID NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  total_price DECIMAL(10, 2) NOT NULL,
  status VARCHAR(20) NOT NULL CHECK (status IN ('pending', 'confirmed', 'cancelled')),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_property FOREIGN KEY (property_id) REFERENCES properties (property_id) ON DELETE CASCADE,
  CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE
);

-- PAYMENT Table
CREATE TABLE payments (
  payment_id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
  booking_id UUID NOT NULL,
  amount DECIMAL(10, 2) NOT NULL,
  payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  payment_method VARCHAR(20) NOT NULL CHECK (
    payment_method IN ('credit_card', 'paypal', 'bank_transfer')
  ),
  CONSTRAINT fk_booking FOREIGN KEY (booking_id) REFERENCES bookings (booking_id) ON DELETE CASCADE
);

-- REVIEW Table
CREATE TABLE reviews (
  review_id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
  property_id UUID NOT NULL,
  user_id UUID NOT NULL,
  rating INT CHECK (
    rating >= 1
    AND rating <= 5
  ),
  comment TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_review_property FOREIGN KEY (property_id) REFERENCES properties (property_id) ON DELETE CASCADE,
  CONSTRAINT fk_review_user FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE
);

-- Indexes for performance
CREATE INDEX idx_messages_sender ON messages (sender_id);

CREATE INDEX idx_messages_recipient ON messages (recipient_id);

CREATE INDEX idx_properties_host ON properties (host_id);

CREATE INDEX idx_bookings_property ON bookings (property_id);

CREATE INDEX idx_bookings_user ON bookings (user_id);

CREATE INDEX idx_payments_booking ON payments (booking_id);

CREATE INDEX idx_reviews_property ON reviews (property_id);

CREATE INDEX idx_reviews_user ON reviews (user_id);

-- Trigger to auto-update "updated_at"
CREATE OR REPLACE FUNCTION update_timestamp () RETURNS TRIGGER AS $$
BEGIN
   NEW.updated_at = NOW();
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_updated_at BEFORE
UPDATE ON properties FOR EACH ROW
EXECUTE FUNCTION update_timestamp ();
