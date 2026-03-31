CREATE DATABASE Bokhandel;
USE Bokhandel;
DROP DATABASE bokhandel;

# Skapar tabellen "Böcker"
CREATE TABLE IF NOT EXISTS Bocker(
  ISBN_Nummer VARCHAR(50) PRIMARY KEY,
  Bok_titel VARCHAR(200) NOT NULL,
  Forfattare VARCHAR(200) NOT NULL,
  Pris DECIMAL(10,2) NOT NULL,
  Lagerstatus INT
);

# Infogning av data i tabellen "Böcker"
INSERT INTO bocker(ISBN_Nummer, Bok_titel, Forfattare, Pris, Lagerstatus) VALUES 
("9789178431125", "Mördarens ö", "Camilla Sten", 199.00, 12),
("9789155238879", "Sista arkivet", "Thomas hage", 189.00, 34),
("9780441927312", "The Quantum Orchard", "J.R. Kalmer", 249.00, 8),
("9781603095024", "Vargens Tystnad", "Erika Fahlgren", 175.00, 61),
("9789188942211", "Fragment av stjärnstoft", "Amir Davani", 205.00, 4);

# Visar tabellen böcker och dess inehåll
SELECT * FROM bocker;

# Skapar tabellen med "Kunder"
CREATE TABLE IF NOT EXISTS Kunder(
	Kund_ID INT AUTO_INCREMENT PRIMARY KEY,
	Förnamn VARCHAR(100) NOT NULL,
    Efternamn VARCHAR(100) NOT NULL,
	E_post varchar(100),
	Telefon INT,
	Adress VARCHAR(50),
    Registreringsdatum TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

# Infogar data i tabellen med kunder
INSERT INTO kunder(Förnamn, Efternamn, E_post, Telefon, Adress) VALUES
("Anna", "Svensson", "anna.svensson@mail.com", "473264371", "Brovägen 7B"),
("Erik", "Johansson", "erik.johansson@mail.com", "768575827", "Bilvägen 40"),
("Maria", "Lund", "maria.lund@mail.com", "578478943", "Fågelvägen 10"),
("Johan", "Berg", "johan.berg@mail.com", "685986099" ,"Prästgatan 2C");

# Visar tabellen kunder och dess innehåll
SELECT * FROM kunder;

# Skapar tabellen "beställningar"
CREATE TABLE IF NOT EXISTS Bestallningar(
	Ordernummer_ID INT AUTO_INCREMENT PRIMARY KEY,
    Kund_ID INT NOT NULL,
    Datum TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Kund_ID) REFERENCES kunder(Kund_ID)
);

# Infogar data i tabellen bestallningar
INSERT INTO bestallningar(Kund_ID) VALUES
(1),
(2),
(3),
(4);

# Visar tabellen "Beställningar" och dess innehåll
SELECT * FROM bestallningar;

# Skapar tabellen "Orderrader"
CREATE TABLE IF NOT EXISTS Orderrader(
	Orderad_ID INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    Ordernummer_ID INT NOT NULL,
    ISBN_Nummer VARCHAR(50) NOT NULL,
    Antal INT NOT NULL,
    Pris DECIMAL(10,2),
    FOREIGN KEY(Ordernummer_ID) REFERENCES bestallningar(Ordernummer_ID),
    FOREIGN KEY(ISBN_Nummer) REFERENCES bocker(ISBN_Nummer)
);

SELECT * FROM orderrader;

# Infogar data i tabellen Orderrader
INSERT INTO orderrader(Ordernummer_ID, ISBN_Nummer, Antal, Pris) VALUES
(1, "9789155238879", 1, 189.00),
(1, "9780441927312", 1, 249.00),
(2, "9789188942211", 1, 205.00),
(3, "9789178431125", 1, 199.00),
(4, "9789178431125", 2, 199.00),
(1, "9789188942211", 1, 205.00);

/* Utgår från tabellen beställningar, orderrarder och kunder
och visar ifall kunden har gjort en beställning och isåfall
 summerar det totala beloppet för varje kunds beställning.*/
SELECT
	b.Ordernummer_ID,
    k.Förnamn,
    k.Efternamn,
	SUM(o.Antal * o.Pris) AS Totala_beloppet
FROM bestallningar b
JOIN orderrader o ON b.Ordernummer_ID = o.Ordernummer_ID
JOIN kunder k ON b.Kund_ID = k.Kund_ID
GROUP BY b.Ordernummer_ID, k.Efternamn, k.Förnamn;

# Visar priset på böckerna från bokhandeln från högsta priset till lägsta
SELECT Bok_titel, Pris FROM bocker ORDER BY Pris DESC;

/* Här visas vilken kund som har beställt vad
och antalet böcker av tillgängliga böcker i "biblioteket" 
genom att kombinera olika kolumner från olika tabeller */
SELECT Kun.Förnamn, Kun.Efternamn, O.Antal, bok.Bok_titel
FROM Bestallningar bes
JOIN orderrader o ON o.ordernummer_ID = bes.ordernummer_ID
JOIN Kunder kun ON bes.Kund_ID = Kun.Kund_ID 
JOIN Bocker bok ON O.ISBN_Nummer = Bok.ISBN_Nummer; 

# Väljer tabellen kunder och filtrerar den baserat på angivna parametrar samt visar den
SELECT * FROM kunder WHERE Förnamn = "Johan" AND E_post = "Johan.berg@mail.com";
SELECT * FROM kunder WHERE E_post = "maria.lund@mail.com";

# Startar en transaktion och gör det möjligt att ångra ändringarna
START TRANSACTION;
UPDATE kunder
SET E_post = "maria_nymail@mail.com"
WHERE Kund_ID = 3;
COMMIT;

# ON CASCADE

ALTER TABLE kundlogg
ADD CONSTRAINT kunder_kundlogg_borttagning
FOREIGN KEY (Kund_ID) REFERENCES kunder (Kund_ID)
ON DELETE CASCADE;


# Tar bort en kund och ångrar sedan ändringen
START TRANSACTION;
DELETE FROM kunder
WHERE Förnamn = "Bertil";
ROLLBACK;
SELECT * FROM kunder;


SELECT * FROM bocker WHERE Pris > 180;

# Visar vem som har beställt en bok
SELECT
	kunder.Förnamn, 
	bestallningar.Ordernummer_ID
FROM kunder
INNER JOIN bestallningar ON kunder.Kund_ID = bestallningar.Kund_ID;

# Visar alla kunder och anger om en kund har gjort en beställning
SELECT
	k.Förnamn,
    k.Efternamn,
    b.Ordernummer_ID
FROM kunder k
LEFT JOIN bestallningar b ON k.Kund_ID = b.Kund_ID;

# Visar kunder som gjort fler än 2 beställningar
SELECT k.Förnamn, k.Efternamn, COUNT(o.Ordernummer_ID) AS Antalet_bestallningar
FROM kunder k
JOIN orderrader o ON k.Kund_ID = o.Ordernummer_ID
GROUP BY k.Förnamn, k.Efternamn
HAVING COUNT(o.Ordernummer_ID) > 2;

# Visar antalet beställningar som kunderna har gjort
SELECT k.Kund_ID, k.Förnamn, k.Efternamn, COUNT(o.Ordernummer_ID) AS Antalet_bestallningar
FROM kunder k
LEFT JOIN orderrader o ON k.Kund_ID = o.Ordernummer_ID
GROUP BY k.Kund_ID, k.Förnamn, k.Efternamn;

# Säkerställer att böcker som läggs till i bokhandeln alltid är > 0 kr
ALTER TABLE bocker
ADD CONSTRAINT CHECK (pris > 0);

INSERT INTO bocker(ISBN_Nummer, Bok_titel, Forfattare, Pris, Lagerstatus) VALUES
("32132155643", "hunter", "jan jansson", "-44", 3);

CREATE INDEX idx_Epost
ON kunder (E_post);

DELIMITER $

/* Minskar lagersaldot med "x" antal böcker som en kund beställer
utgår från tabellen kunder och uppdaterar lagerstatusen i tabellen allteftersom */

CREATE TRIGGER lager_uppdatering
AFTER INSERT ON Orderrader
FOR EACH ROW
BEGIN
	UPDATE bocker
    SET Lagerstatus = Lagerstatus - NEW.Antal
    WHERE ISBN_Nummer = NEW.ISBN_Nummer;
END $

DELIMITER ;

CREATE TABLE Kundlogg (
	logg_ID INT AUTO_INCREMENT PRIMARY KEY,
	kund_ID INT NOT NULL,
    Registreringsdatum TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (kund_ID) REFERENCES Kunder(kund_ID)
);



DELIMITER $
# Trigger loggar varje gång en ny kund registreras
CREATE TRIGGER ny_kund_registrering
AFTER INSERT ON kunder
FOR EACH ROW 
BEGIN 
	INSERT INTO Kundlogg(Kund_ID)
    VALUES (NEW.Kund_ID);
END $

DELIMITER ;

# Visar index satta på tabellen kunder
SHOW INDEX FROM kunder;

# Ser till att lagerstatusen på någon av böckerna alltid är över "0"
START TRANSACTION;
ALTER TABLE bocker
ADD CONSTRAINT Minimum_lagerstatus CHECK (Lagerstatus > 0);
COMMIT;

START TRANSACTION;
INSERT INTO orderrader (ordernummer_ID, ISBN_Nummer, Antal, Pris) VALUES
	(4, "9781603095024", 99999, 175.00);

INSERT INTO kunder (Förnamn, Efternamn, E_post, Telefon, Adress) VALUES
	("Bertil", "Karlsson", "Bertil@mail.com", "66898632", "Lilla lårbensviken 7b");


SELECT * FROM orderrader;
SELECT * FROM kundlogg;
SELECT * FROM orderrader;
SELECT * FROM kunder;
SELECT * FROM bocker;
SELECT * FROM bestallningar;