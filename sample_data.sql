-- ============================================================
--  Hotel Reservation Database
--  Schema + Synthetic Data (30 entries per table)
-- ============================================================

CREATE DATABASE IF NOT EXISTS hotel_reservation_db;
USE hotel_reservation_db;

-- ------------------------------------------------------------
-- Tables
-- ------------------------------------------------------------

CREATE TABLE Brand (
    brand_id   INT AUTO_INCREMENT PRIMARY KEY,
    brand_name VARCHAR(100) NOT NULL
);

CREATE TABLE Hotel (
    hotel_id       INT AUTO_INCREMENT PRIMARY KEY,
    brand_id       INT          NOT NULL,
    hotel_name     VARCHAR(100) NOT NULL,
    city           VARCHAR(100) NOT NULL,
    province       VARCHAR(100) NOT NULL,
    country        VARCHAR(100) NOT NULL,
    street_address VARCHAR(255) NOT NULL,
    CONSTRAINT fk_hotel_brand
        FOREIGN KEY (brand_id) REFERENCES Brand(brand_id)
);

CREATE TABLE RoomType (
    room_type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name    VARCHAR(50)   NOT NULL,
    capacity     INT           NOT NULL,
    base_price   DECIMAL(10,2) NOT NULL
);

CREATE TABLE Room (
    room_id      INT AUTO_INCREMENT PRIMARY KEY,
    hotel_id     INT         NOT NULL,
    room_type_id INT         NOT NULL,
    room_number  VARCHAR(10) NOT NULL,
    floor_number INT         NOT NULL,
    CONSTRAINT fk_room_hotel
        FOREIGN KEY (hotel_id)     REFERENCES Hotel(hotel_id),
    CONSTRAINT fk_room_roomtype
        FOREIGN KEY (room_type_id) REFERENCES RoomType(room_type_id),
    CONSTRAINT uq_room_number_per_hotel
        UNIQUE (hotel_id, room_number)
);

CREATE TABLE Guest (
    guest_id     INT AUTO_INCREMENT PRIMARY KEY,
    first_name   VARCHAR(50)  NOT NULL,
    last_name    VARCHAR(50)  NOT NULL,
    email        VARCHAR(100) NOT NULL UNIQUE,
    phone_number VARCHAR(20)
);

CREATE TABLE Reservation (
    reservation_id   INT AUTO_INCREMENT PRIMARY KEY,
    guest_id         INT         NOT NULL,
    check_in_date    DATE        NOT NULL,
    check_out_date   DATE        NOT NULL,
    reservation_date DATE        NOT NULL,
    status           VARCHAR(20) NOT NULL,
    CONSTRAINT fk_reservation_guest
        FOREIGN KEY (guest_id) REFERENCES Guest(guest_id),
    CONSTRAINT chk_reservation_dates
        CHECK (check_out_date > check_in_date)
);

CREATE TABLE RoomAssignment (
    reservation_id INT PRIMARY KEY,
    room_id        INT NOT NULL,
    CONSTRAINT fk_roomassignment_reservation
        FOREIGN KEY (reservation_id) REFERENCES Reservation(reservation_id),
    CONSTRAINT fk_roomassignment_room
        FOREIGN KEY (room_id) REFERENCES Room(room_id)
);


-- ============================================================
--  SYNTHETIC DATA
-- ============================================================

-- ------------------------------------------------------------
-- Brand  (6 rows)
-- ------------------------------------------------------------
INSERT INTO Brand (brand_name) VALUES
('Maple Hospitality Group'),
('Pacific Crown Hotels'),
('Northern Comfort Inns'),
('Atlantic Suites Collection'),
('Prairie Star Resorts'),
('CanLux Hotels & Resorts');

-- ------------------------------------------------------------
-- Hotel  (10 rows — brands spread across properties)
-- ------------------------------------------------------------
INSERT INTO Hotel (brand_id, hotel_name, city, province, country, street_address) VALUES
(1, 'Maple Leaf Grand',         'Toronto',        'Ontario',           'Canada', '100 King Street West'),
(1, 'Maple Leaf Midtown',       'Toronto',        'Ontario',           'Canada', '88 Bloor Street East'),
(2, 'Pacific Crown Vancouver',  'Vancouver',      'British Columbia',  'Canada', '500 Granville Street'),
(2, 'Pacific Crown Victoria',   'Victoria',       'British Columbia',  'Canada', '210 Government Street'),
(3, 'Northern Comfort Calgary', 'Calgary',        'Alberta',           'Canada', '333 Centre Street NE'),
(3, 'Northern Comfort Edmonton','Edmonton',       'Alberta',           'Canada', '145 Jasper Avenue'),
(4, 'Atlantic Suites Halifax',  'Halifax',        'Nova Scotia',       'Canada', '30 Lower Water Street'),
(4, 'Atlantic Suites Moncton',  'Moncton',        'New Brunswick',     'Canada', '77 Main Street'),
(5, 'Prairie Star Regina',      'Regina',         'Saskatchewan',      'Canada', '200 Victoria Avenue'),
(6, 'CanLux Ottawa Centre',     'Ottawa',         'Ontario',           'Canada', '1 Rideau Street');

-- ------------------------------------------------------------
-- RoomType  (5 rows)
-- ------------------------------------------------------------
INSERT INTO RoomType (type_name, capacity, base_price) VALUES
('Single',       1,  89.99),
('Double',       2, 129.99),
('Queen Suite',  2, 179.99),
('Family Room',  4, 219.99),
('Penthouse',    2, 399.99);

-- ------------------------------------------------------------
-- Room  (30 rows — spread across all 10 hotels)
-- ------------------------------------------------------------
INSERT INTO Room (hotel_id, room_type_id, room_number, floor_number) VALUES
-- Maple Leaf Grand (hotel 1)
(1, 1, '101', 1),
(1, 2, '102', 1),
(1, 3, '201', 2),
(1, 5, '801', 8),
-- Maple Leaf Midtown (hotel 2)
(2, 1, '101', 1),
(2, 2, '102', 1),
(2, 4, '301', 3),
-- Pacific Crown Vancouver (hotel 3)
(3, 2, '101', 1),
(3, 3, '202', 2),
(3, 5, '901', 9),
-- Pacific Crown Victoria (hotel 4)
(4, 1, '101', 1),
(4, 2, '102', 1),
(4, 3, '201', 2),
-- Northern Comfort Calgary (hotel 5)
(5, 1, '101', 1),
(5, 2, '103', 1),
(5, 4, '401', 4),
-- Northern Comfort Edmonton (hotel 6)
(6, 1, '101', 1),
(6, 2, '102', 1),
(6, 3, '205', 2),
-- Atlantic Suites Halifax (hotel 7)
(7, 2, '101', 1),
(7, 3, '201', 2),
(7, 5, '601', 6),
-- Atlantic Suites Moncton (hotel 8)
(8, 1, '101', 1),
(8, 2, '102', 1),
(8, 4, '301', 3),
-- Prairie Star Regina (hotel 9)
(9, 1, '101', 1),
(9, 2, '102', 1),
(9, 3, '201', 2),
-- CanLux Ottawa Centre (hotel 10)
(10, 1, '101', 1),
(10, 3, '201', 2),
(10, 5, '1001', 10);

-- ------------------------------------------------------------
-- Guest  (30 rows)
-- ------------------------------------------------------------
INSERT INTO Guest (first_name, last_name, email, phone_number) VALUES
('Liam',      'Tremblay',    'liam.tremblay@email.ca',      '416-555-0101'),
('Olivia',    'Bouchard',    'olivia.bouchard@email.ca',    '604-555-0202'),
('Noah',      'Gagnon',      'noah.gagnon@email.ca',        '403-555-0303'),
('Emma',      'Lavoie',      'emma.lavoie@email.ca',        '902-555-0404'),
('William',   'Fortin',      'william.fortin@email.ca',     '613-555-0505'),
('Sophia',    'Morin',       'sophia.morin@email.ca',       '514-555-0606'),
('James',     'Pelletier',   'james.pelletier@email.ca',    '780-555-0707'),
('Isabella',  'Cote',        'isabella.cote@email.ca',      '250-555-0808'),
('Benjamin',  'Leblanc',     'benjamin.leblanc@email.ca',   '506-555-0909'),
('Ava',       'Ouellet',     'ava.ouellet@email.ca',        '705-555-1010'),
('Lucas',     'Bergeron',    'lucas.bergeron@email.ca',     '416-555-1111'),
('Mia',       'Gaudet',      'mia.gaudet@email.ca',         '604-555-1212'),
('Ethan',     'Roy',         'ethan.roy@email.ca',          '403-555-1313'),
('Charlotte', 'Nadeau',      'charlotte.nadeau@email.ca',   '902-555-1414'),
('Alexander', 'Poirier',     'alex.poirier@email.ca',       '613-555-1515'),
('Amelia',    'Gosselin',    'amelia.gosselin@email.ca',    '514-555-1616'),
('Henry',     'Thibodeau',   'henry.thibodeau@email.ca',    '780-555-1717'),
('Harper',    'Arsenault',   'harper.arsenault@email.ca',   '250-555-1818'),
('Sebastian', 'Doucet',      'sebastian.doucet@email.ca',   '506-555-1919'),
('Evelyn',    'Belanger',    'evelyn.belanger@email.ca',    '705-555-2020'),
('Daniel',    'Champagne',   'daniel.champagne@email.ca',   '416-555-2121'),
('Scarlett',  'Desrochers',  'scarlett.desrochers@email.ca','604-555-2222'),
('Michael',   'Fontaine',    'michael.fontaine@email.ca',   '403-555-2323'),
('Luna',      'Girard',      'luna.girard@email.ca',        '902-555-2424'),
('Jackson',   'Huot',        'jackson.huot@email.ca',       '613-555-2525'),
('Penelope',  'Jobin',       'penelope.jobin@email.ca',     '514-555-2626'),
('Owen',      'Lacroix',     'owen.lacroix@email.ca',       '780-555-2727'),
('Layla',     'Martineau',   'layla.martineau@email.ca',    '250-555-2828'),
('Gabriel',   'Noel',        'gabriel.noel@email.ca',       '506-555-2929'),
('Stella',    'Paradis',     'stella.paradis@email.ca',     '705-555-3030');

-- ------------------------------------------------------------
-- Reservation  (30 rows)
-- ------------------------------------------------------------
INSERT INTO Reservation (guest_id, check_in_date, check_out_date, reservation_date, status) VALUES
( 1, '2025-07-01', '2025-07-05', '2025-06-01', 'confirmed'),
( 2, '2025-07-03', '2025-07-07', '2025-06-05', 'confirmed'),
( 3, '2025-07-10', '2025-07-12', '2025-06-10', 'confirmed'),
( 4, '2025-07-14', '2025-07-18', '2025-06-15', 'pending'),
( 5, '2025-07-20', '2025-07-23', '2025-06-18', 'confirmed'),
( 6, '2025-07-25', '2025-07-28', '2025-06-20', 'confirmed'),
( 7, '2025-08-01', '2025-08-04', '2025-07-01', 'cancelled'),
( 8, '2025-08-05', '2025-08-09', '2025-07-03', 'confirmed'),
( 9, '2025-08-10', '2025-08-13', '2025-07-05', 'confirmed'),
(10, '2025-08-15', '2025-08-19', '2025-07-08', 'pending'),
(11, '2025-08-20', '2025-08-22', '2025-07-10', 'confirmed'),
(12, '2025-08-25', '2025-08-28', '2025-07-12', 'confirmed'),
(13, '2025-09-01', '2025-09-05', '2025-07-15', 'confirmed'),
(14, '2025-09-06', '2025-09-08', '2025-07-18', 'pending'),
(15, '2025-09-10', '2025-09-14', '2025-07-20', 'confirmed'),
(16, '2025-09-15', '2025-09-18', '2025-07-22', 'confirmed'),
(17, '2025-09-20', '2025-09-23', '2025-07-25', 'cancelled'),
(18, '2025-09-25', '2025-09-28', '2025-07-28', 'confirmed'),
(19, '2025-10-01', '2025-10-04', '2025-08-01', 'confirmed'),
(20, '2025-10-05', '2025-10-09', '2025-08-05', 'pending'),
(21, '2025-10-10', '2025-10-13', '2025-08-08', 'confirmed'),
(22, '2025-10-15', '2025-10-17', '2025-08-10', 'confirmed'),
(23, '2025-10-20', '2025-10-24', '2025-08-12', 'confirmed'),
(24, '2025-10-25', '2025-10-28', '2025-08-15', 'cancelled'),
(25, '2025-11-01', '2025-11-05', '2025-08-18', 'confirmed'),
(26, '2025-11-06', '2025-11-09', '2025-08-20', 'pending'),
(27, '2025-11-10', '2025-11-14', '2025-08-22', 'confirmed'),
(28, '2025-11-15', '2025-11-18', '2025-08-25', 'confirmed'),
(29, '2025-11-20', '2025-11-23', '2025-08-28', 'confirmed'),
(30, '2025-11-25', '2025-11-29', '2025-09-01', 'pending');

-- ------------------------------------------------------------
-- RoomAssignment  (30 rows — each reservation gets one room)
-- room_ids 1-30 match the Room inserts above in order
-- ------------------------------------------------------------
INSERT INTO RoomAssignment (reservation_id, room_id) VALUES
( 1,  3),   -- Liam      → Maple Leaf Grand,          Queen Suite  201
( 2,  9),   -- Olivia    → Pacific Crown Vancouver,   Queen Suite  202
( 3, 14),   -- Noah      → Northern Comfort Calgary,  Single       101
( 4, 20),   -- Emma      → Atlantic Suites Halifax,   Queen Suite  201
( 5,  4),   -- William   → Maple Leaf Grand,          Penthouse    801
( 6, 10),   -- Sophia    → Pacific Crown Vancouver,   Penthouse    901
( 7, 15),   -- James     → Northern Comfort Calgary,  Double       103
( 8, 21),   -- Isabella  → Atlantic Suites Halifax,   Penthouse    601
( 9, 25),   -- Benjamin  → Prairie Star Regina,       Single       101
(10, 30),   -- Ava       → CanLux Ottawa Centre,      Penthouse   1001
(11,  1),   -- Lucas     → Maple Leaf Grand,          Single       101
(12,  8),   -- Mia       → Pacific Crown Vancouver,   Double       101
(13, 11),   -- Ethan     → Pacific Crown Victoria,    Single       101
(14, 16),   -- Charlotte → Northern Comfort Calgary,  Family Room  401
(15, 23),   -- Alexander → Atlantic Suites Moncton,   Single       101
(16,  6),   -- Amelia    → Maple Leaf Midtown,        Double       102
(17, 17),   -- Henry     → Northern Comfort Edmonton, Single       101
(18, 22),   -- Harper    → Atlantic Suites Halifax,   Penthouse    601  -- re-assigned different dates
(19,  5),   -- Sebastian → Maple Leaf Midtown,        Single       101
(20, 27),   -- Evelyn    → Prairie Star Regina,       Double       102
(21,  2),   -- Daniel    → Maple Leaf Grand,          Double       102
(22, 12),   -- Scarlett  → Pacific Crown Victoria,    Double       102
(23, 18),   -- Michael   → Northern Comfort Edmonton, Double       102
(24, 24),   -- Luna      → Atlantic Suites Moncton,   Double       102
(25, 28),   -- Jackson   → Prairie Star Regina,       Queen Suite  201
(26,  7),   -- Penelope  → Maple Leaf Midtown,        Family Room  301
(27, 13),   -- Owen      → Pacific Crown Victoria,    Queen Suite  201
(28, 19),   -- Layla     → Northern Comfort Edmonton, Queen Suite  205
(29, 26),   -- Gabriel   → Prairie Star Regina,       Single       101  -- re-assigned different dates
(30, 29);   -- Stella    → CanLux Ottawa Centre,      Queen Suite  201