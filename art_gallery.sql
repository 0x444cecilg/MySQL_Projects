CREATE DATABASE IF NOT EXISTS art_gallery;
USE art_gallery;

-- stored procedure to drop all tables

DELIMITER $$
CREATE PROCEDURE  drop_all_tables ()
BEGIN
    DECLARE _done INT DEFAULT FALSE;
    DECLARE _tableName VARCHAR(255);
    DECLARE _cursor CURSOR FOR
        SELECT table_name
        FROM information_schema.TABLES
        WHERE table_schema = SCHEMA();
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET _done = TRUE;

    SET FOREIGN_KEY_CHECKS = 0;

    OPEN _cursor;

    REPEAT FETCH _cursor INTO _tableName;

    IF NOT _done THEN
        SET @stmt_sql = CONCAT('DROP TABLE ', _tableName);
        PREPARE stmt1 FROM @stmt_sql;
        EXECUTE stmt1;
        DEALLOCATE PREPARE stmt1;
    END IF;

    UNTIL _done END REPEAT;

    CLOSE _cursor;
    SET FOREIGN_KEY_CHECKS = 1;
END$$

DELIMITER ;

call drop_all_tables();

-- creating the tables and inserting values

CREATE TABLE IF NOT EXISTS gallery (
  gid VARCHAR(20) NOT NULL DEFAULT 'NOT NULL',
  gname VARCHAR(25) DEFAULT NULL,
  location VARCHAR(25) DEFAULT NULL,
  PRIMARY KEY (gid)
);

INSERT INTO gallery (gid,  gname ,  location ) VALUES
('NG123', 'NATIONAL GALLERY', 'Washington'),
('BM123', 'BRITISH MUSEUM', 'London'),
('JG123', 'JAHANGIR GALLERY', 'Mumbai'),
('TLM123', 'THE LOUVRE MUSEUM', 'Paris'),
('MM123', 'METROPOLITAN MUSEUM', 'New York'),
('MP123', 'MUSEO NACIONAL DEL PRADO', 'Madrid');


CREATE TABLE IF NOT EXISTS exhibition (
  eid VARCHAR(20) NOT NULL,
  gid_FK VARCHAR(20) DEFAULT NULL,
  startdate DATE DEFAULT NULL,
  enddate DATE DEFAULT NULL,
  PRIMARY KEY (eid),
  FOREIGN KEY (gid_FK) REFERENCES gallery (gid) ON DELETE CASCADE
);

INSERT INTO  exhibition  ( eid ,  gid_FK ,  startdate ,  enddate ) VALUES
('H123', 'BM123', '2022-12-21', '2023-01-05'),
('I123', 'MM123', '2021-01-25', '2022-02-05'),
('J123', 'NG123', '2022-12-01', '2022-12-15'),
('K123', 'TLM123', '2022-12-15', '2023-01-15'),
('L123', 'JG123', '2023-03-09', '2023-03-27'),
('M123', 'MP123', '2022-10-11', '2022-11-15');

CREATE TABLE IF NOT EXISTS artist (
  artistid VARCHAR(20) NOT NULL,
  gid_FK VARCHAR(20) DEFAULT NULL,
  eid_FK VARCHAR(20) DEFAULT NULL,
  fname_a VARCHAR(25) DEFAULT NULL,
  lname_a VARCHAR(25) DEFAULT NULL,
  birthplace VARCHAR(25) DEFAULT NULL,
  style VARCHAR(50) DEFAULT NULL,
  PRIMARY KEY (artistid),
  FOREIGN KEY (gid_FK) REFERENCES gallery (gid) ON DELETE CASCADE,
  FOREIGN KEY (eid_FK) REFERENCES exhibition (eid) ON DELETE CASCADE

);


INSERT INTO  artist  ( artistid ,  gid_FK ,  eid_FK ,  fname_a ,  lname_a ,  birthplace ,  style ) VALUES
('ART1', 'MM123',  'H123', 'Georgia', 'O Keeffe', 'USA', 'Modernism'),
('ART2', 'TLM123', 'I123', 'Pablo', 'Picasso', 'Spain', 'Analytic Cubism'),
('ART3', 'BM123',  'J123', 'Rembrandt', 'van Rijn', 'Netherlands', 'Baroque'),
('ART4', 'JG123',  'K123', 'Theodore', 'Chasseriau', 'France', 'Romanticism'),
('ART5', 'NG123',  'L123', 'Leonardo', 'da Vinci', 'Italy', 'High Renaissance'),
('ART6', 'MP123',  'M123', 'Salvador', 'Dali', 'Spain', 'Surrealism');



CREATE TABLE IF NOT EXISTS customer (
  custid VARCHAR(20) NOT NULL,
  gid_FK VARCHAR(20) DEFAULT NULL,
  fname VARCHAR(25) DEFAULT NULL,
  lname VARCHAR(25) DEFAULT NULL,
  dob DATE DEFAULT NULL,
  address VARCHAR(25) DEFAULT NULL,
  email VARCHAR(25) DEFAULT NULL,
  PRIMARY KEY (custid),
  FOREIGN KEY (gid_FK) REFERENCES gallery (gid) ON DELETE CASCADE


);

INSERT INTO  customer  ( custid ,  gid_FK ,   fname ,  lname ,  dob ,  address , email ) VALUES
('CG1986', 'MM123',  'Cecil', 'Gilliard', '1986-04-16', 'New York', 'cg123@gmail.com'),
('AK1973', 'TLM123',  'Arika', 'Korrison', '1973-02-04', 'Paris', 'ak123@gmail.com'),
('RE1998', 'BM123',  'Ronan', 'Ea', '1998-09-28', 'Dublin', 're123@gmail.com'),
('CO1984', 'JG123',  'Cihan', 'Oztunc', '1984-10-05', 'Istanbul', 'co123@gmail.com'),
('NU1989', 'NG123',  'Noriko', 'Uzumaki', '1989-06-18', 'Tokyo', 'nu123@gmail.com'),
('SJ1971', 'MP123',  'Shequila', 'Jones', '1971-07-21', 'Johannesburg', 'sj123@gmail.com');


INSERT INTO  customer  ( custid ,  gid_FK ,  fname ,  lname ,  dob ,  address , email ) VALUES
('CG1986', 'MM123',  'Cecil', 'Gilliard', '1986-04-16', 'New York', 'cg123@gmail.com');

CREATE TABLE IF NOT EXISTS artwork (
  artid VARCHAR(20) NOT NULL,
  title VARCHAR(50) DEFAULT NULL,
  created SMALLINT DEFAULT NULL,
  type_of_art VARCHAR(20) DEFAULT NULL,
  price BIGINT DEFAULT NULL,
  eid_FK VARCHAR(20) DEFAULT NULL,
  gid_FK VARCHAR(20) DEFAULT NULL,
  artistid_FK VARCHAR(20) DEFAULT NULL,

  PRIMARY KEY (artid),
  FOREIGN KEY (artistid_FK) REFERENCES artist(artistid) ON DELETE CASCADE,
  FOREIGN KEY (gid_FK) REFERENCES gallery (gid) ON DELETE CASCADE,
  FOREIGN KEY (eid_FK) REFERENCES exhibition (eid) ON DELETE CASCADE
);


INSERT INTO  artwork  ( artid ,  title ,  created ,  type_of_art ,
 price ,  eid_FK ,  gid_FK ,  artistid_FK ) VALUES
('AW01', 'Mona Lisa', 1503, 'Painting', 100000000 , 'K123', 'TLM123', 'ART5' ),
('AW02', 'Poppies', 1927, 'Painting', 15000000 , 'J123', 'NG123', 'ART1'),
('AW03', 'Guernica', 1937, 'Painting', 25000000 , 'I123', 'MM123', 'ART2'),
('AW04', 'The Night Watch', 1642, 'Painting', 9000000 , 'H123', 'BM123', 'ART3'),
('AW05', 'Two Sisters', 1840, 'Sculpture', 2000000 , 'L123', 'JG123', 'ART4'),
('AW06', 'The Persistence of Memory', 1931, 'Painting', '1000000', 'M123', 'MP123', 'ART6');

-- find which customers own art at a particular gallery by id

SELECT cs.fname, cs.lname, cs.email
FROM customer cs WHERE cs.gid_fk = (SELECT gl.gid FROM gallery gl
WHERE gl.gid = 'MM123');

-- get customer name & artpiece by gallery name

SELECT cs.fname, cs.lname, at.title, gy.gname
FROM customer cs
INNER JOIN artwork at ON cs.gid_FK = at.gid_FK
INNER JOIN gallery gy ON cs.gid_FK = gy.gid
WHERE gy.gname = 'JAHANGIR GALLERY';

-- find which gallery has the oldest artpiece

SELECT gy.gname, at.title, MIN(at.created) AS created FROM gallery gy
INNER JOIN artwork at ON gy.gid = at.gid_FK
GROUP BY gname, title ORDER BY MIN(at.created) ASC limit 1;

-- find a particular type of art and WHERE it is located

SELECT gy.gname, at.title, at.type_of_art FROM gallery gy
INNER JOIN artwork at ON gy.gid = at.gid_FK
WHERE at.type_of_art = 'Sculpture';

-- find an exhibition of a particular artpiece

SELECT ex.startdate, ex.enddate, gy.gname, at.title FROM exhibition ex
INNER JOIN gallery gy ON gy.gid = ex.gid_FK
INNER JOIN artwork at ON ex.gid_FK = at.gid_FK
WHERE gy.location = 'London' AND at.title = 'The Night Watch';

-- find which gallery contained the most expensive art and when it will be displayed

SELECT gy.gname, at.title, MAX(at.price) AS price, ex.startdate
FROM gallery gy
INNER JOIN artwork at ON gy.gid = at.gid_FK
INNER JOIN exhibition ex ON at.gid_FK = ex.gid_FK
GROUP BY gname, title, startdate ORDER BY MAX(at.price) DESC limit 1;

-- find the contact info for a customer that owned a piece of art

SELECT cs.fname, cs.lname, cs.address, cs.email, at.title
FROM customer cs
INNER JOIN artwork at ON cs.gid_FK = at.gid_FK
WHERE at.title = 'Poppies';

-- price of an artpiece at specific galley by location

SELECT aw.price FROM artwork aw INNER JOIN gallery gl ON aw.gid_FK = gl.gid WHERE location = "Mumbai";

-- contact email for customer that own an artpiece

SELECT cs.email FROM customer cs INNER JOIN artwork ak ON cs.gid_FK = ak.gid_FK WHERE title = "Mona Lisa";
