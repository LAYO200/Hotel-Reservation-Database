-- Hotel Reservation Database Schema

CREATE TABLE Brand (
    brand_id INT AUTO_INCREMENT PRIMARY KEY,
    brand_name VARCHAR(100) NOT NULL
);

CREATE TABLE Hotel (
    hotel_id INT AUTO_INCREMENT PRIMARY KEY,
    brand_id INT NOT NULL,
    hotel_name VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    province VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    street_address VARCHAR(255) NOT NULL,
    CONSTRAINT fk_hotel_brand
        FOREIGN KEY (brand_id) REFERENCES Brand(brand_id)
);

CREATE TABLE RoomType (
    room_type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL,
    capacity INT NOT NULL,
    base_price DECIMAL(10,2) NOT NULL
);

CREATE TABLE Room (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    hotel_id INT NOT NULL,
    room_type_id INT NOT NULL,
    room_number VARCHAR(10) NOT NULL,
    floor_number INT NOT NULL,
    CONSTRAINT fk_room_hotel
        FOREIGN KEY (hotel_id) REFERENCES Hotel(hotel_id),
    CONSTRAINT fk_room_roomtype
        FOREIGN KEY (room_type_id) REFERENCES RoomType(room_type_id),
    CONSTRAINT uq_room_number_per_hotel
        UNIQUE (hotel_id, room_number)
);

CREATE TABLE Guest (
    guest_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone_number VARCHAR(20)
);

CREATE TABLE Reservation (
    reservation_id INT AUTO_INCREMENT PRIMARY KEY,
    guest_id INT NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    reservation_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL,
    CONSTRAINT fk_reservation_guest
        FOREIGN KEY (guest_id) REFERENCES Guest(guest_id),
    CONSTRAINT chk_reservation_dates
        CHECK (check_out_date > check_in_date)
);

CREATE TABLE RoomAssignment (
    reservation_id INT PRIMARY KEY,
    room_id INT NOT NULL,
    CONSTRAINT fk_roomassignment_reservation
        FOREIGN KEY (reservation_id) REFERENCES Reservation(reservation_id),
    CONSTRAINT fk_roomassignment_room
        FOREIGN KEY (room_id) REFERENCES Room(room_id)
);
