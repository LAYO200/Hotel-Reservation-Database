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

CREATE TABLE RoomStatus (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    code        VARCHAR(50) NOT NULL UNIQUE,
    label       VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE Room (
    room_id      INT AUTO_INCREMENT PRIMARY KEY,
    hotel_id     INT         NOT NULL,
    room_type_id INT         NOT NULL,
    room_number  VARCHAR(10) NOT NULL,
    floor_number INT         NOT NULL,
    status_id    INT         NOT NULL DEFAULT 1,
    CONSTRAINT fk_room_hotel
        FOREIGN KEY (hotel_id)     REFERENCES Hotel(hotel_id),
    CONSTRAINT fk_room_roomtype
        FOREIGN KEY (room_type_id) REFERENCES RoomType(room_type_id),
    CONSTRAINT fk_room_status
        FOREIGN KEY (status_id)    REFERENCES RoomStatus(id),
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

CREATE TABLE ReservationStatus (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    code        VARCHAR(50) NOT NULL UNIQUE,
    label       VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE Reservation (
    reservation_id    INT AUTO_INCREMENT PRIMARY KEY,
    guest_id          INT  NOT NULL,
    hotel_id          INT  NOT NULL,
    check_in_date     DATE NOT NULL,
    check_out_date    DATE NOT NULL,
    reservation_date  DATE NOT NULL,
    cancellation_date DATE DEFAULT NULL,
    status_id         INT  NOT NULL,
    CONSTRAINT fk_reservation_guest
        FOREIGN KEY (guest_id)  REFERENCES Guest(guest_id),
    CONSTRAINT fk_reservation_hotel
        FOREIGN KEY (hotel_id)  REFERENCES Hotel(hotel_id),
    CONSTRAINT fk_reservation_status
        FOREIGN KEY (status_id) REFERENCES ReservationStatus(id),
    CONSTRAINT chk_reservation_dates
        CHECK (check_out_date > check_in_date
               AND reservation_date <= check_in_date)
);

ALTER TABLE Reservation ADD UNIQUE (reservation_id, hotel_id);
ALTER TABLE Room        ADD UNIQUE (room_id, hotel_id);

CREATE TABLE RoomAssignment (
    reservation_id INT PRIMARY KEY,
    room_id        INT NOT NULL UNIQUE,
    hotel_id       INT NOT NULL,
    CONSTRAINT fk_roomassignment_reservation
        FOREIGN KEY (reservation_id) REFERENCES Reservation(reservation_id),
    CONSTRAINT fk_roomassignment_room
        FOREIGN KEY (room_id)        REFERENCES Room(room_id),
    CONSTRAINT fk_roomassignment_hotel
        FOREIGN KEY (hotel_id)       REFERENCES Hotel(hotel_id),
    -- Composite FKs ensure the assigned room is at the same hotel as the reservation
    CONSTRAINT fk_ra_res_hotel
        FOREIGN KEY (reservation_id, hotel_id)
        REFERENCES Reservation(reservation_id, hotel_id),
    CONSTRAINT fk_ra_room_hotel
        FOREIGN KEY (room_id, hotel_id)
        REFERENCES Room(room_id, hotel_id)
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
-- Hotel  (10 rows)
-- ------------------------------------------------------------
INSERT INTO Hotel (brand_id, hotel_name, city, province, country, street_address) VALUES
(1, 'Maple Leaf Grand',          'Toronto',   'Ontario',          'Canada', '100 King Street West'),
(1, 'Maple Leaf Midtown',        'Toronto',   'Ontario',          'Canada', '88 Bloor Street East'),
(2, 'Pacific Crown Vancouver',   'Vancouver', 'British Columbia', 'Canada', '500 Granville Street'),
(2, 'Pacific Crown Victoria',    'Victoria',  'British Columbia', 'Canada', '210 Government Street'),
(3, 'Northern Comfort Calgary',  'Calgary',   'Alberta',          'Canada', '333 Centre Street NE'),
(3, 'Northern Comfort Edmonton', 'Edmonton',  'Alberta',          'Canada', '145 Jasper Avenue'),
(4, 'Atlantic Suites Halifax',   'Halifax',   'Nova Scotia',      'Canada', '30 Lower Water Street'),
(4, 'Atlantic Suites Moncton',   'Moncton',   'New Brunswick',    'Canada', '77 Main Street'),
(5, 'Prairie Star Regina',       'Regina',    'Saskatchewan',     'Canada', '200 Victoria Avenue'),
(6, 'CanLux Ottawa Centre',      'Ottawa',    'Ontario',          'Canada', '1 Rideau Street');

-- ------------------------------------------------------------
-- RoomType  (5 rows)
-- ------------------------------------------------------------
INSERT INTO RoomType (type_name, capacity, base_price) VALUES
('Single',      1,  89.99),
('Double',      2, 129.99),
('Queen Suite', 2, 179.99),
('Family Room', 4, 219.99),
('Penthouse',   2, 399.99);

-- ------------------------------------------------------------
-- RoomStatus  (4 rows)
-- id 1=Vacant, 2=Occupied, 3=Dirty, 4=Clean
-- ------------------------------------------------------------
INSERT INTO RoomStatus (code, label, description) VALUES
('VACANT',   'Vacant',   'Room vacant and inspected'),
('OCCUPIED', 'Occupied', 'Room occupied'),
('DIRTY',    'Dirty',    'Room vacant but not cleaned'),
('CLEAN',    'Clean',    'Room clean but not inspected');


INSERT INTO Room (hotel_id, room_type_id, room_number, floor_number) VALUES
-- Maple Leaf Grand (hotel 1)
(1, 1, '101',  1),   -- room  1  Single
(1, 2, '102',  1),   -- room  2  Double
(1, 3, '201',  2),   -- room  3  Queen Suite
(1, 5, '801',  8),   -- room  4  Penthouse
-- Maple Leaf Midtown (hotel 2)
(2, 1, '101',  1),   -- room  5  Single
(2, 2, '102',  1),   -- room  6  Double
(2, 4, '301',  3),   -- room  7  Family Room
-- Pacific Crown Vancouver (hotel 3)
(3, 2, '101',  1),   -- room  8  Double
(3, 3, '202',  2),   -- room  9  Queen Suite
(3, 5, '901',  9),   -- room 10  Penthouse
-- Pacific Crown Victoria (hotel 4)
(4, 1, '101',  1),   -- room 11  Single
(4, 2, '102',  1),   -- room 12  Double
(4, 3, '201',  2),   -- room 13  Queen Suite
-- Northern Comfort Calgary (hotel 5)
(5, 1, '101',  1),   -- room 14  Single
(5, 2, '103',  1),   -- room 15  Double
(5, 4, '401',  4),   -- room 16  Family Room
-- Northern Comfort Edmonton (hotel 6)
(6, 1, '101',  1),   -- room 17  Single
(6, 2, '102',  1),   -- room 18  Double
(6, 3, '205',  2),   -- room 19  Queen Suite
-- Atlantic Suites Halifax (hotel 7)
(7, 2, '101',  1),   -- room 20  Double
(7, 3, '201',  2),   -- room 21  Queen Suite
(7, 5, '601',  6),   -- room 22  Penthouse
-- Atlantic Suites Moncton (hotel 8)
(8, 1, '101',  1),   -- room 23  Single
(8, 2, '102',  1),   -- room 24  Double
(8, 4, '301',  3),   -- room 25  Family Room
-- Prairie Star Regina (hotel 9)
(9, 1, '101',  1),   -- room 26  Single
(9, 2, '102',  1),   -- room 27  Double
(9, 3, '201',  2),   -- room 28  Queen Suite
-- CanLux Ottawa Centre (hotel 10)
(10, 1, '101',  1),  -- room 29  Single
(10, 3, '201',  2),  -- room 30  Queen Suite
(10, 5, '1001',10);  -- room 31  Penthouse

-- ------------------------------------------------------------
-- Guest  (30 rows)
-- ------------------------------------------------------------
INSERT INTO Guest (first_name, last_name, email, phone_number) VALUES
('Liam',      'Tremblay',   'liam.tremblay@email.ca',       '416-555-0101'),
('Olivia',    'Bouchard',   'olivia.bouchard@email.ca',     '604-555-0202'),
('Noah',      'Gagnon',     'noah.gagnon@email.ca',         '403-555-0303'),
('Emma',      'Lavoie',     'emma.lavoie@email.ca',         '902-555-0404'),
('William',   'Fortin',     'william.fortin@email.ca',      '613-555-0505'),
('Sophia',    'Morin',      'sophia.morin@email.ca',        '514-555-0606'),
('James',     'Pelletier',  'james.pelletier@email.ca',     '780-555-0707'),
('Isabella',  'Cote',       'isabella.cote@email.ca',       '250-555-0808'),
('Benjamin',  'Leblanc',    'benjamin.leblanc@email.ca',    '506-555-0909'),
('Ava',       'Ouellet',    'ava.ouellet@email.ca',         '705-555-1010'),
('Lucas',     'Bergeron',   'lucas.bergeron@email.ca',      '416-555-1111'),
('Mia',       'Gaudet',     'mia.gaudet@email.ca',          '604-555-1212'),
('Ethan',     'Roy',        'ethan.roy@email.ca',           '403-555-1313'),
('Charlotte', 'Nadeau',     'charlotte.nadeau@email.ca',    '902-555-1414'),
('Alexander', 'Poirier',    'alex.poirier@email.ca',        '613-555-1515'),
('Amelia',    'Gosselin',   'amelia.gosselin@email.ca',     '514-555-1616'),
('Henry',     'Thibodeau',  'henry.thibodeau@email.ca',     '780-555-1717'),
('Harper',    'Arsenault',  'harper.arsenault@email.ca',    '250-555-1818'),
('Sebastian', 'Doucet',     'sebastian.doucet@email.ca',    '506-555-1919'),
('Evelyn',    'Belanger',   'evelyn.belanger@email.ca',     '705-555-2020'),
('Daniel',    'Champagne',  'daniel.champagne@email.ca',    '416-555-2121'),
('Scarlett',  'Desrochers', 'scarlett.desrochers@email.ca', '604-555-2222'),
('Michael',   'Fontaine',   'michael.fontaine@email.ca',    '403-555-2323'),
('Luna',      'Girard',     'luna.girard@email.ca',         '902-555-2424'),
('Jackson',   'Huot',       'jackson.huot@email.ca',        '613-555-2525'),
('Penelope',  'Jobin',      'penelope.jobin@email.ca',      '514-555-2626'),
('Owen',      'Lacroix',    'owen.lacroix@email.ca',        '780-555-2727'),
('Layla',     'Martineau',  'layla.martineau@email.ca',     '250-555-2828'),
('Gabriel',   'Noel',       'gabriel.noel@email.ca',        '506-555-2929'),
('Stella',    'Paradis',    'stella.paradis@email.ca',      '705-555-3030');


INSERT INTO ReservationStatus (code, label, description) VALUES
('PENDING',     'Pending',     'Awaiting confirmation or payment'), --id 1
('CONFIRMED',   'Confirmed',   'Reservation is confirmed'), --id 2
('DUEIN',       'Due In',      'Guest is scheduled to check in today'), --id 3
('CHECKEDIN',   'Checked In',  'Guest is checked in'), --id 4
('DUEOUT',      'Due Out',     'Guest is scheduled to check out today'), --id 5
('CHECKEDOUT',  'Checked Out', 'Guest is checked out'), --id 6
('CANCELLED',   'Cancelled',   'Reservation was cancelled'), --id 7
('NOSHOW',      'No Show',     'Guest did not show up on the check-in date'); --id 8

INSERT INTO Reservation (guest_id, hotel_id, check_in_date, check_out_date, reservation_date, cancellation_date, status_id) VALUES
( 1,  1, '2025-07-01', '2025-07-05', '2025-06-01', NULL,         2),  -- Liam      → Maple Leaf Grand
( 2,  3, '2025-07-03', '2025-07-07', '2025-06-05', NULL,         2),  -- Olivia    → Pacific Crown Vancouver
( 3,  5, '2025-07-10', '2025-07-12', '2025-06-10', NULL,         2),  -- Noah      → Northern Comfort Calgary
( 4,  7, '2025-07-14', '2025-07-18', '2025-06-15', NULL,         2),  -- Emma      → Atlantic Suites Halifax
( 5,  1, '2025-07-20', '2025-07-23', '2025-06-18', NULL,         2),  -- William   → Maple Leaf Grand
( 6,  3, '2025-07-25', '2025-07-28', '2025-06-20', NULL,         2),  -- Sophia    → Pacific Crown Vancouver
( 7,  5, '2025-08-01', '2025-08-04', '2025-07-01', '2025-07-15', 7),  -- James     → Northern Comfort Calgary (CANCELLED)
( 8,  7, '2025-08-05', '2025-08-09', '2025-07-03', NULL,         2),  -- Isabella  → Atlantic Suites Halifax
( 9,  9, '2025-08-10', '2025-08-13', '2025-07-05', NULL,         2),  -- Benjamin  → Prairie Star Regina
(10, 10, '2025-08-15', '2025-08-19', '2025-07-08', NULL,         1),  -- Ava       → CanLux Ottawa Centre
(11,  1, '2025-08-20', '2025-08-22', '2025-07-10', NULL,         2),  -- Lucas     → Maple Leaf Grand
(12,  3, '2025-08-25', '2025-08-28', '2025-07-12', NULL,         2),  -- Mia       → Pacific Crown Vancouver
(13,  4, '2025-09-01', '2025-09-05', '2025-07-15', NULL,         2),  -- Ethan     → Pacific Crown Victoria
(14,  5, '2025-09-06', '2025-09-08', '2025-07-18', NULL,         1),  -- Charlotte → Northern Comfort Calgary
(15,  8, '2025-09-10', '2025-09-14', '2025-07-20', NULL,         2),  -- Alexander → Atlantic Suites Moncton
(16,  2, '2025-09-15', '2025-09-18', '2025-07-22', NULL,         2),  -- Amelia    → Maple Leaf Midtown
(17,  6, '2025-09-20', '2025-09-23', '2025-07-25', '2025-08-10', 7),  -- Henry     → Northern Comfort Edmonton (CANCELLED)
(18,  7, '2025-09-25', '2025-09-28', '2025-07-28', NULL,         2),  -- Harper    → Atlantic Suites Halifax
(19,  2, '2025-10-01', '2025-10-04', '2025-08-01', NULL,         2),  -- Sebastian → Maple Leaf Midtown
(20,  9, '2025-10-05', '2025-10-09', '2025-08-05', NULL,         1),  -- Evelyn    → Prairie Star Regina
(21,  1, '2025-10-10', '2025-10-13', '2025-08-08', NULL,         2),  -- Daniel    → Maple Leaf Grand
(22,  4, '2025-10-15', '2025-10-17', '2025-08-10', NULL,         2),  -- Scarlett  → Pacific Crown Victoria
(23,  6, '2025-10-20', '2025-10-24', '2025-08-12', NULL,         2),  -- Michael   → Northern Comfort Edmonton
(24,  8, '2025-10-25', '2025-10-28', '2025-08-15', '2025-09-01', 7),  -- Luna      → Atlantic Suites Moncton (CANCELLED)
(25,  9, '2025-11-01', '2025-11-05', '2025-08-18', NULL,         2),  -- Jackson   → Prairie Star Regina
(26,  2, '2025-11-06', '2025-11-09', '2025-08-20', NULL,         1),  -- Penelope  → Maple Leaf Midtown
(27,  4, '2025-11-10', '2025-11-14', '2025-08-22', NULL,         2),  -- Owen      → Pacific Crown Victoria
(28,  6, '2025-11-15', '2025-11-18', '2025-08-25', NULL,         2),  -- Layla     → Northern Comfort Edmonton
(29,  9, '2025-11-20', '2025-11-23', '2025-08-28', NULL,         2),  -- Gabriel   → Prairie Star Regina
(30, 10, '2025-11-25', '2025-11-29', '2025-09-01', NULL,         1);  -- Stella    → CanLux Ottawa Centre

-- ------------------------------------------------------------
-- res 7  (James,  hotel 5) — CANCELLED, no assignment
-- res 17 (Henry,  hotel 6) — CANCELLED, no assignment
-- res 24 (Luna,   hotel 8) — CANCELLED, no assignment
-- ------------------------------------------------------------
INSERT INTO RoomAssignment (reservation_id, room_id, hotel_id) VALUES
( 1,  3,  1),  -- Liam      → Maple Leaf Grand,          Queen Suite  rm201
( 2,  9,  3),  -- Olivia    → Pacific Crown Vancouver,   Queen Suite  rm202
( 3, 14,  5),  -- Noah      → Northern Comfort Calgary,  Single       rm101
( 4, 21,  7),  -- Emma      → Atlantic Suites Halifax,   Queen Suite  rm201
( 5,  4,  1),  -- William   → Maple Leaf Grand,          Penthouse    rm801
( 6, 10,  3),  -- Sophia    → Pacific Crown Vancouver,   Penthouse    rm901
( 8, 22,  7),  -- Isabella  → Atlantic Suites Halifax,   Penthouse    rm601
( 9, 26,  9),  -- Benjamin  → Prairie Star Regina,       Single       rm101
(10, 31, 10),  -- Ava       → CanLux Ottawa Centre,      Penthouse    rm1001
(11,  1,  1),  -- Lucas     → Maple Leaf Grand,          Single       rm101
(12,  8,  3),  -- Mia       → Pacific Crown Vancouver,   Double       rm101
(13, 11,  4),  -- Ethan     → Pacific Crown Victoria,    Single       rm101
(14, 16,  5),  -- Charlotte → Northern Comfort Calgary,  Family Room  rm401
(15, 23,  8),  -- Alexander → Atlantic Suites Moncton,   Single       rm101
(16,  6,  2),  -- Amelia    → Maple Leaf Midtown,        Double       rm102
(18, 20,  7),  -- Harper    → Atlantic Suites Halifax,   Double       rm101
(19,  5,  2),  -- Sebastian → Maple Leaf Midtown,        Single       rm101
(20, 27,  9),  -- Evelyn    → Prairie Star Regina,       Double       rm102
(21,  2,  1),  -- Daniel    → Maple Leaf Grand,          Double       rm102
(22, 12,  4),  -- Scarlett  → Pacific Crown Victoria,    Double       rm102
(23, 18,  6),  -- Michael   → Northern Comfort Edmonton, Double       rm102
(25, 28,  9),  -- Jackson   → Prairie Star Regina,       Queen Suite  rm201
(26,  7,  2),  -- Penelope  → Maple Leaf Midtown,        Family Room  rm301
(27, 13,  4),  -- Owen      → Pacific Crown Victoria,    Queen Suite  rm201
(28, 19,  6),  -- Layla     → Northern Comfort Edmonton, Queen Suite  rm205
(29, 26,  9),  -- Gabriel   → Prairie Star Regina,       Single       rm101
(30, 30, 10);  -- Stella    → CanLux Ottawa Centre,      Queen Suite  rm201
