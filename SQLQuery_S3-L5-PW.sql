CREATE DATABASE PoliziaMunicipale;
USE PoliziaMunicipale;

CREATE TABLE ANAGRAFICA (
    IdAnagrafica INT IDENTITY (1,1) NOT NULL PRIMARY KEY,
    Cognome VARCHAR(50) NOT NULL,
    Nome VARCHAR(50) NOT NULL,
    Indirizzo VARCHAR(100),
    Citta VARCHAR(50),
    CAP VARCHAR(5),
    CF VARCHAR(16) UNIQUE NOT NULL
);

CREATE TABLE TIPO_VIOLAZIONE (
    IdViolazione INT IDENTITY (1,1) NOT NULL PRIMARY KEY,
    Descrizione VARCHAR(255) NOT NULL
);

CREATE TABLE VERBALE (
    IdVerbale INT IDENTITY (1,1) NOT NULL PRIMARY KEY,
    IdAnagrafica INT NOT NULL,
    DataViolazione DATE NOT NULL,
    IndirizzoViolazione VARCHAR(100) NOT NULL,
    NominativoAgente VARCHAR(100) NOT NULL,
    DataTrascrizioneVerbale DATE NOT NULL,
    Importo DECIMAL(10,2) NOT NULL,
    CONSTRAINT FKAnagraficaVerbale FOREIGN KEY (IdAnagrafica) REFERENCES ANAGRAFICA(IdAnagrafica)
);

CREATE TABLE VERBALE_VIOLAZIONE (
    IdVerbale INT NOT NULL,
    IdViolazione INT NOT NULL,
    DecurtamentoPunti INT NOT NULL,
    PRIMARY KEY (IdVerbale, IdViolazione),
    CONSTRAINT FKVerbale FOREIGN KEY (IdVerbale) REFERENCES VERBALE(IdVerbale),
    CONSTRAINT FKViolazioneVerbale FOREIGN KEY (IdViolazione) REFERENCES TIPO_VIOLAZIONE(IdViolazione)
);

INSERT INTO ANAGRAFICA (Cognome, Nome, Indirizzo, Citta, CAP, CF) VALUES
('Rossi', 'Mario', 'Via Roma 10', 'Palermo', '90100', 'RSSMRA80A01H501Z'),
('Bianchi', 'Luca', 'Via Milano 22', 'Milano', '20100', 'BNCLCU75B11F205Z'),
('Verdi', 'Anna', 'Piazza Napoli 5', 'Roma', '00100', 'VRDANN68C21R123X'),
('Esposito', 'Giovanni', 'Corso Vittorio 45', 'Napoli', '80100', 'ESPJHN85M10F839K');

INSERT INTO TIPO_VIOLAZIONE (Descrizione) VALUES
('Eccesso di velocità'),
('Sosta vietata'),
('Guida senza cintura'),
('Semaforo rosso'),
('Uso del cellulare alla guida');

INSERT INTO VERBALE (IdAnagrafica, DataViolazione, IndirizzoViolazione, NominativoAgente, DataTrascrizioneVerbale, Importo) VALUES
(1, '2009-02-15', 'Via Roma 10', 'Agente Rossi', '2009-02-16', 200.00),
(2, '2009-03-01', 'Via Milano 22', 'Agente Bianchi', '2009-03-02', 150.00),
(3, '2023-04-10', 'Piazza Napoli 5', 'Agente Verdi', '2023-04-11', 300.00),
(4, '2023-06-20', 'Corso Vittorio 45', 'Agente Neri', '2023-06-21', 600.00);

INSERT INTO VERBALE_VIOLAZIONE (IdVerbale, IdViolazione, DecurtamentoPunti) VALUES
(1, 1, 3),
(1, 4, 2),
(1, 5, 1),
(2, 2, 0),
(2, 3, 4),
(3, 3, 5),
(3, 5, 8),
(4, 1, 3),
(4, 2, 6);

-- 1.
SELECT COUNT(*) AS NumeroVerbali FROM VERBALE;

-- 2.
SELECT IdAnagrafica, COUNT(*) AS NumeroVerbali FROM VERBALE GROUP BY IdAnagrafica;

-- 3. 
SELECT IdViolazione, COUNT(*) AS NumeroVerbali FROM VERBALE_VIOLAZIONE GROUP BY IdViolazione;

-- 4.
SELECT v.IdAnagrafica, SUM(vv.DecurtamentoPunti) AS TotalePuntiDecurtati 
FROM VERBALE v
JOIN VERBALE_VIOLAZIONE vv ON v.IdVerbale = vv.IdVerbale
GROUP BY v.IdAnagrafica;

-- 5. 
SELECT a.Cognome, a.Nome, v.DataViolazione, v.IndirizzoViolazione, v.Importo, vv.DecurtamentoPunti
FROM VERBALE v
JOIN ANAGRAFICA a ON v.IdAnagrafica = a.IdAnagrafica
JOIN VERBALE_VIOLAZIONE vv ON v.IdVerbale = vv.IdVerbale
WHERE a.Citta = 'Palermo';

-- 6. 
SELECT a.Cognome, a.Nome, a.Indirizzo, v.DataViolazione, v.Importo, vv.DecurtamentoPunti
FROM VERBALE v
JOIN ANAGRAFICA a ON v.IdAnagrafica = a.IdAnagrafica
JOIN VERBALE_VIOLAZIONE vv ON v.IdVerbale = vv.IdVerbale
WHERE v.DataViolazione BETWEEN '2009-02-01' AND '2009-07-31';

-- 7.
SELECT IdAnagrafica, SUM(Importo) AS TotaleImporto FROM VERBALE GROUP BY IdAnagrafica;

-- 8. 
SELECT * FROM ANAGRAFICA WHERE Citta = 'Palermo';

-- 9. 
SELECT v.DataViolazione, v.Importo, vv.DecurtamentoPunti 
FROM VERBALE v
JOIN VERBALE_VIOLAZIONE vv ON v.IdVerbale = vv.IdVerbale
WHERE v.DataViolazione = '2023-02-15';

-- 10. 
SELECT v.NominativoAgente, COUNT(*) AS NumeroViolazioni
FROM VERBALE v
JOIN VERBALE_VIOLAZIONE vv ON v.IdVerbale = vv.IdVerbale
GROUP BY v.NominativoAgente;

-- 11. 
SELECT a.Cognome, a.Nome, a.Indirizzo, v.DataViolazione, v.Importo, vv.DecurtamentoPunti
FROM VERBALE v
JOIN ANAGRAFICA a ON v.IdAnagrafica = a.IdAnagrafica
JOIN VERBALE_VIOLAZIONE vv ON v.IdVerbale = vv.IdVerbale
WHERE vv.DecurtamentoPunti > 5;

-- 12. 
SELECT a.Cognome, a.Nome, a.Indirizzo, v.DataViolazione, v.Importo, vv.DecurtamentoPunti
FROM VERBALE v
JOIN ANAGRAFICA a ON v.IdAnagrafica = a.IdAnagrafica
JOIN VERBALE_VIOLAZIONE vv ON v.IdVerbale = vv.IdVerbale
WHERE v.Importo > 400;
