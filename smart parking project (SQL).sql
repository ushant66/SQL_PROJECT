CREATE database SmartParking;

USE SmartParking;

CREATE TABLE ParkingSlot(
    SlotID INT PRIMARY KEY,
    Location VARCHAR(100),
    Status VARCHAR(20)
);

CREATE TABLE Vehicles (
    VehicleID INT PRIMARY KEY,
    OwnerName VARCHAR(100),
    VehicleType VARCHAR(50)
);

CREATE table BOOKINGS (
    BOOKINGID int,
    SLOTID int,
    VEHICALID int,
    ENTERYTIME datetime,
    EXITTIME datetime,
    PAYMENT decimal(8,2),
    FOREIGN KEY (SLOTID) REFERENCES PARKINGSLOTS(SLOTID),
   FOREIGN KEY (VEHICHLEID) REFERENCES VEHICALES(VEHICHLEID)
    );
    
   CREATE TABLE Bookings (
    BookingID INT PRIMARY KEY,
    SlotID INT,
    VehicleID INT,
    EntryTime DATETIME,
    ExitTime DATETIME,
    Payment DECIMAL(8,2),
    FOREIGN KEY (SlotID) REFERENCES ParkingSlot(SlotID),
    FOREIGN KEY (VehicleID) REFERENCES Vehicles(VehicleID)
);
SHOW TABLES;

insert into parkingslot
(SlotID,Location,Status)
values
(1, 'Block A', 'Free'),
(2, 'Block A', 'Free'),
(3, 'Block B', 'Free');

select * from parkingslot;

insert into Vehicles
(VehicleID,OwnerName,vehicleType)
values
(101, 'Ramesh', 'Car'),
(102, 'Suresh', 'Bike'),
(103, 'Priya', 'Car');
select * from Vehicles;

insert into Bookings
(BookingID,SlotID,VehicleID,EntryTime,ExitTime,Payment)
values
(1001, 1, 101, '2025-09-15 09:00:00', '2025-09-15 11:00:00', 50.00),
(1002, 2, 102, '2025-09-15 10:00:00', '2025-09-15 12:30:00', 30.00),
(1003, 1, 103, '2025-09-16 08:00:00', '2025-09-16 11:00:00', 70.00);
select * from Bookings;

select SlotID, count(*)AS TotalBookings
from Bookings
group by SlotID
order by TotalBookings desc;
