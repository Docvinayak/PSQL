CREATE DATABASE cdn;
\c cdn;

CREATE TABLE Servers (
    id SERIAL PRIMARY KEY,
    ip_address VARCHAR(255) NOT NULL UNIQUE,
    location VARCHAR(255) NOT NULL,
    capacity INT NOT NULL,
    status VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE Content (
    id SERIAL PRIMARY KEY,
    filename VARCHAR(255) NOT NULL,
    filesize INT NOT NULL,
    filetype VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    expiry_date DATE NOT NULL,
    FOREIGN KEY (filename) REFERENCES Customers(web_site)
);

CREATE TABLE Edge_Locations (
    id SERIAL PRIMARY KEY,
    location_name VARCHAR(255) NOT NULL,
    ip_address VARCHAR(255) NOT NULL UNIQUE,
    latitude DECIMAL(9,6) NOT NULL,
    longitude DECIMAL(9,6) NOT NULL
);

CREATE TABLE Content_Locations (
    id SERIAL PRIMARY KEY,
    content_id INT NOT NULL,
    edge_location_id INT NOT NULL,
    FOREIGN KEY (content_id) REFERENCES Content(id),
    FOREIGN KEY (edge_location_id) REFERENCES Edge_Locations(id)
);

CREATE TABLE Users (
    id SERIAL PRIMARY KEY,
    ip_address VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL
);

CREATE TABLE User_Content (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    content_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (content_id) REFERENCES Content(id)
);

CREATE TABLE Logs (
    id SERIAL PRIMARY KEY,
    date TIMESTAMP NOT NULL DEFAULT NOW(),
    user_id INT NOT NULL,
    content_id INT NOT NULL,
    edge_location_id INT NOT NULL,
    response_code INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (content_id) REFERENCES Content(id),
    FOREIGN KEY (edge_location_id) REFERENCES Edge_Locations(id)
);


CREATE TABLE Customers(
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    web_site VARCHAR(255) NOT NULL UNIQUE,
    sub_domain VARCHAR(255) NOT NULL UNIQUE,
    dataplan INT NOT NULL
);

ALTER TABLE Customers
  ADD CONSTRAINT email_lower_check
  CHECK (email = lower(email));

ALTER TABLE Customers
  ADD CONSTRAINT email_validation CHECK (email ~* '^[A-Za-z0-9._+%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$')

ALTER TABLE Customers
   ADD CONSTRAINT check_positive check (dataplan >= 0);

#'get-Average hit rate for a website'
SELECT logs.content_id, 
(COUNT(content_id)/(SELECT count(*) FROM logs)::decimal)*100 AS AVG_HIT_RATE, 
content.filename FROM logs
JOIN content ON logs.content_id=content.id 
WHERE content.filename='https://apple.com'
GROUP BY logs.content_id,content.filename 
ORDER BY avg_hit_rate DESC;

#'Most request files WITH request count , AND bytes delivered'
SELECT count(content_id) AS counter,
content.filename ,
content.filetype,
content.filesize,
content.filesize*count(content_id) as bit_deliverd
FROM logs
JOIN content ON logs.content_id=content.id 
GROUP BY logs.content_id,content.filename,content.filetype,content.filesize
ORDER BY counter DESC LIMIT 1;



#'Most request files WITH hits, misses'
SELECT count(content_id) AS counter,
response_code,
(COUNT(content_id)/(SELECT count(*) FROM logs)::decimal)*100 AS AVG_HIT_miss_RATE, 
content.filename ,
content.filetype
FROM logs
JOIN content ON logs.content_id=content.id 
WHERE filename = (SELECT filename FROM (SELECT count(content_id) AS counter,
(COUNT(content_id)/(select count(*) from logs)::decimal)*100 as AVG_HIT_miss_RATE, 
content.filename ,
content.filetype
from logs
join content on logs.content_id=content.id 
GROUP BY logs.content_id,content.filename,content.filetype
ORDER BY AVG_HIT_miss_RATE DESC LIMIT 1) AS D)
GROUP BY logs.content_id,content.filename,content.filetype,response_code
ORDER BY filename;

#'search files with extension'
select * from content where filetype like '%.png';

#'used data plan'
SELECT content.filesize*count(content_id) AS used_data,
content.filesize,
(COUNT(content_id)/(SELECT count(*) FROM logs)::decimal)*100 AS AVG_HIT_RATE, 
content.filename FROM logs
JOIN content ON logs.content_id=content.id 
WHERE content.filename='https://apple.com'
GROUP BY logs.content_id,content.filename,content.filesize
ORDER BY avg_hit_rate DESC;
