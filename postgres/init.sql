-- init.sql
-- Create a simple table and insert some initial data
CREATE TABLE IF NOT EXISTS messages (
id SERIAL PRIMARY KEY,
message VARCHAR(255) NOT NULL,
created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Insert initial data if the table is empty
INSERT INTO messages (message) VALUES ('Hello from PostgreSQL!') ON CONFLICT DO NOTHING;
INSERT INTO messages (message) VALUES ('Data retrieval successful.') ON CONFLICT DO NOTHING;