-- Query 1: Show all hotels with their brand

SELECT 
    h.hotel_id,
    h.hotel_name,
    b.brand_name,
    h.city,
    h.province,
    h.country
FROM Hotel h
JOIN Brand b ON h.brand_id = b.brand_id
ORDER BY b.brand_name, h.hotel_name;


-- Query 2: Show all rooms with their hotel and room type

SELECT
    r.room_id,
    h.hotel_name,
    r.room_number,
    r.floor_number,
    rt.type_name,
    rt.capacity,
    rt.base_price
FROM Room r
JOIN Hotel h ON r.hotel_id = h.hotel_id
JOIN RoomType rt ON r.room_type_id = rt.room_type_id
ORDER BY h.hotel_name, r.room_number;


-- Query 3: Show all guests and their reservations

SELECT
    g.guest_id,
    g.first_name,
    g.last_name,
    res.reservation_id,
    res.check_in_date,
    res.check_out_date,
    res.reservation_date,
    res.status
FROM Guest g
JOIN Reservation res ON g.guest_id = res.guest_id
ORDER BY res.check_in_date;


-- Query 4: Show full reservation details

SELECT
    res.reservation_id,
    g.first_name,
    g.last_name,
    b.brand_name,
    h.hotel_name,
    r.room_number,
    rt.type_name,
    res.check_in_date,
    res.check_out_date,
    res.status
FROM Reservation res
JOIN Guest g ON res.guest_id = g.guest_id
JOIN RoomAssignment ra ON res.reservation_id = ra.reservation_id
JOIN Room r ON ra.room_id = r.room_id
JOIN RoomType rt ON r.room_type_id = rt.room_type_id
JOIN Hotel h ON r.hotel_id = h.hotel_id
JOIN Brand b ON h.brand_id = b.brand_id
ORDER BY res.reservation_id;


-- Query 5: Count the number of rooms in each hotel

SELECT
    h.hotel_id,
    h.hotel_name,
    COUNT(r.room_id) AS total_rooms
FROM Hotel h
LEFT JOIN Room r ON h.hotel_id = r.hotel_id
GROUP BY h.hotel_id, h.hotel_name
ORDER BY total_rooms DESC;


-- Query 6: Count how many reservations each guest has made

SELECT
    g.guest_id,
    g.first_name,
    g.last_name,
    COUNT(res.reservation_id) AS total_reservations
FROM Guest g
LEFT JOIN Reservation res ON g.guest_id = res.guest_id
GROUP BY g.guest_id, g.first_name, g.last_name
ORDER BY total_reservations DESC, g.last_name;


-- Query 7: Find available rooms for a specific date range

SELECT
    r.room_id,
    h.hotel_name,
    r.room_number,
    rt.type_name,
    rt.base_price
FROM Room r
JOIN Hotel h ON r.hotel_id = h.hotel_id
JOIN RoomType rt ON r.room_type_id = rt.room_type_id
WHERE r.room_id NOT IN (
    SELECT ra.room_id
    FROM RoomAssignment ra
    JOIN Reservation res ON ra.reservation_id = res.reservation_id
    WHERE '2026-04-11' < res.check_out_date
      AND '2026-04-13' > res.check_in_date
)
ORDER BY h.hotel_name, r.room_number;
