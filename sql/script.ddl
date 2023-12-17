CREATE SEQUENCE pracownik_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE samochod_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE klient_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE zamowienie_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE czesc_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE czesci_fk (
    usluga_serwisowa_id1 INTEGER NOT NULL,
    usluga_serwisowa_id2 INTEGER NOT NULL,
    usluga_serwisowa_id  INTEGER NOT NULL,
    czesc_id            INTEGER NOT NULL
);

ALTER TABLE czesci_fk
    ADD CONSTRAINT czesci_fk_pk PRIMARY KEY ( usluga_serwisowa_id1,
                                              usluga_serwisowa_id2,
                                              usluga_serwisowa_id,
                                              czesc_id);

CREATE TABLE czesc (
    id            INTEGER NOT NULL,
    nazwa         VARCHAR2(100),
    cena          NUMBER(10, 2),
    rok_produkcji INTEGER
);

ALTER TABLE czesc ADD CONSTRAINT czesc_pk PRIMARY KEY ( id );

CREATE TABLE klient (
    id             INTEGER NOT NULL,
    imie           VARCHAR2(100),
    nazwisko       VARCHAR2(100),
    adres          VARCHAR2(100),
    mail           VARCHAR2(100),
    numer_telefonu INTEGER
);

ALTER TABLE klient ADD CONSTRAINT klient_pk PRIMARY KEY ( id );

CREATE TABLE klient_zamowienia_fk (
    zamowienia_id INTEGER NOT NULL,
    klient_id     INTEGER NOT NULL
);

ALTER TABLE klient_zamowienia_fk ADD CONSTRAINT klient_zamowienia_fk_pk PRIMARY KEY ( zamowienia_id,
                                                                                      klient_id );

CREATE TABLE marka (
    nazwa            VARCHAR2(100),
    kraj_pochodzenia VARCHAR2(100),
    klasa            VARCHAR2(10)
);

CREATE TABLE pracownik (
    id             INTEGER NOT NULL,
    imie           VARCHAR2(100),
    nazwisko       VARCHAR2(100),
    adres          VARCHAR2(100),
    mail           VARCHAR2(100),
    numer_telefonu NUMBER,
    doswiadczenie  VARCHAR2(100)
);

ALTER TABLE pracownik ADD CONSTRAINT pracownik_pk PRIMARY KEY ( id );


CREATE TABLE rodzaj_samochodu (
    rodzaj VARCHAR2(100)
);

CREATE TABLE samochod (
    id            INTEGER NOT NULL,
    model         VARCHAR2(100),
    rok_produkcji INTEGER,
    liczba_drzwi  INTEGER,
    liczba_miejsc INTEGER,
    cena          NUMBER(10, 2)
);

ALTER TABLE samochod ADD CONSTRAINT samochod_pk PRIMARY KEY ( id );


CREATE TABLE samochod_zamowienia_fk (
    samochod_id   INTEGER NOT NULL,
    zamowienia_id INTEGER NOT NULL
);

ALTER TABLE samochod_zamowienia_fk ADD CONSTRAINT samochod_zamowienia_fk_pk PRIMARY KEY ( samochod_id,
                                                                                          zamowienia_id );

CREATE TABLE silnik (
    pojemnosc         INTEGER,
    rodzaj_paliwa     VARCHAR2(100),
    spalanie_na_100km NUMBER(10, 2)
);

CREATE TABLE stanowisko (
    nazwa             VARCHAR2(100),
    stawka_za_godzine NUMBER(10, 2)
);

CREATE TABLE usluga_serwisowa (
    opis         VARCHAR2(200),
    wartosc      NUMBER(10, 2),
    czas_naprawy INTEGER NOT NULL,
    pracownik_id INTEGER NOT NULL,
    samochod_id  INTEGER NOT NULL,
    klient_id    INTEGER NOT NULL
);

ALTER TABLE usluga_serwisowa
    ADD CONSTRAINT usluga_serwisowa_pk PRIMARY KEY ( pracownik_id,
                                                     samochod_id,
                                                     klient_id );

ALTER TABLE usluga_serwisowa ADD CONSTRAINT usluga_serwisowa_id2_un UNIQUE ( samochod_id );

CREATE TABLE zamowienie (
    id                 INTEGER NOT NULL,
    data               DATE,
    wartosc_zamowienia NUMBER(10, 2)
);

ALTER TABLE zamowienie ADD CONSTRAINT zamowienie_pk PRIMARY KEY ( id );


ALTER TABLE czesci_fk
    ADD CONSTRAINT czesci_fk_czesc_fk FOREIGN KEY ( czesc_id)
        REFERENCES czesc ( id );

ALTER TABLE czesci_fk
    ADD CONSTRAINT czesci_fk_usluga_serwisowa_fk FOREIGN KEY ( usluga_serwisowa_id1,
                                                               usluga_serwisowa_id2,
                                                               usluga_serwisowa_id )
        REFERENCES usluga_serwisowa ( pracownik_id,
                                      samochod_id,
                                      klient_id );

ALTER TABLE klient_zamowienia_fk
    ADD CONSTRAINT klient_zamowienia_fk FOREIGN KEY ( klient_id )
        REFERENCES klient ( id );

ALTER TABLE klient_zamowienia_fk
    ADD CONSTRAINT klient_zamowienia_fk_zam_fk FOREIGN KEY ( zamowienia_id )
        REFERENCES zamowienie ( id );

ALTER TABLE samochod_zamowienia_fk
    ADD CONSTRAINT samochod_zamowienia_fk_sam_fk FOREIGN KEY ( samochod_id )
        REFERENCES samochod ( id );

ALTER TABLE samochod_zamowienia_fk
    ADD CONSTRAINT samochod_zamowienia_fk_zam_fk FOREIGN KEY ( zamowienia_id )
        REFERENCES zamowienie ( id );

ALTER TABLE usluga_serwisowa
    ADD CONSTRAINT usluga_serwisowa_klient_fk FOREIGN KEY ( klient_id )
        REFERENCES klient ( id );

ALTER TABLE usluga_serwisowa
    ADD CONSTRAINT usluga_serwisowa_pracownik_fk FOREIGN KEY ( pracownik_id )
        REFERENCES pracownik ( id );

ALTER TABLE usluga_serwisowa
    ADD CONSTRAINT usluga_serwisowa_samochod_fk FOREIGN KEY ( samochod_id )
        REFERENCES samochod ( id );

--dodanie stanowisko_id
ALTER TABLE pracownik
ADD stanowisko_id VARCHAR2(100) NOT NULL;

ALTER TABLE stanowisko ADD CONSTRAINT stanowisko_pk PRIMARY KEY (nazwa);

ALTER TABLE pracownik
ADD CONSTRAINT FK_Stanowisko
FOREIGN KEY (stanowisko_id) REFERENCES Stanowisko(nazwa);

--tworzy usluge serwisowa
CREATE PROCEDURE create_usluga_serwisowa (p_opis IN VARCHAR, p_wartosc IN NUMBER, p_czas_naprawy IN NUMBER, p_pracownik_id IN NUMBER, p_samochod_id IN NUMBER, p_klient_id IN NUMBER) IS
BEGIN
    INSERT INTO usluga_serwisowa(OPIS, WARTOSC, CZAS_NAPRAWY, PRACOWNIK_ID, SAMOCHOD_ID, KLIENT_ID)  VALUES (p_opis, p_wartosc, p_czas_naprawy, p_pracownik_id, p_samochod_id, p_klient_id);
END;
/
--informacje o usludze
CREATE FUNCTION get_usluga(p_samochod_id IN NUMBER)
    RETURN usluga_serwisowa%ROWTYPE IS
    vRow usluga_serwisowa%ROWTYPE;
BEGIN 
    SELECT * INTO vROW FROM usluga_serwisowa WHERE samochod_id = p_samochod_id;
    RETURN vRow;
END;
/
--zwraca ilosc_h*placa

CREATE FUNCTION working_time(pracownik IN NUMBER, samochod IN NUMBER, klient IN NUMBER)
RETURN FLOAT IS
    emp_time usluga_serwisowa.wartosc%TYPE := 0;
    pay stanowisko.stawka_za_godzine%TYPE;
BEGIN 
    SELECT czas_naprawy INTO emp_time
    FROM usluga_serwisowa
    WHERE pracownik_id=pracownik AND samochod_id=samochod AND klient_id=klient;
    
    SELECT stawka_za_godzine INTO pay
    FROM stanowisko
    WHERE nazwa = (SELECT stanowisko_id FROM pracownik WHERE id=pracownik);

    return emp_time*pay;
END;

/
--zwraca sume kosztow czesci
CREATE FUNCTION cost(pracownik IN NUMBER, samochod IN NUMBER, klient IN NUMBER)
RETURN FLOAT IS
    parts_sum_cost czesc.cena%TYPE := 0;
    part_id NUMBER;
    part_cost czesc.cena%TYPE;
BEGIN 
    FOR part_rec IN (SELECT * FROM czesci_fk WHERE usluga_serwisowa_id1=pracownik AND usluga_serwisowa_id2=samochod AND usluga_serwisowa_id=klient) LOOP
        part_id := part_rec.czesc_id;
        
        SELECT cena INTO part_cost
        FROM czesc
        WHERE id = part_id;
        
        parts_sum_cost := parts_sum_cost + part_cost;
    END LOOP;
    
    RETURN parts_sum_cost;
END;
/
--usuwanie uslugi
CREATE PROCEDURE delete_usluga(p_pracownik_id IN NUMBER, p_klient_id IN NUMBER, p_samochod_id IN NUMBER) IS
BEGIN
    DELETE FROM samochod WHERE id = p_samochod_id;
    DELETE FROM czesc WHERE id IN (SELECT czesc_id FROM czesci_fk WHERE usluga_serwisowa_id1=p_pracownik_id AND usluga_serwisowa_id2=p_samochod_id AND usluga_serwisowa_id=p_klient_id); 
    DELETE FROM czesci_fk WHERE usluga_serwisowa_id1=p_pracownik_id AND usluga_serwisowa_id2=p_samochod_id AND usluga_serwisowa_id=p_klient_id; 
    DELETE FROM usluga_serwisowa WHERE samochod_id = p_samochod_id AND klient_id = p_klient_id AND samochod_id = p_samochod_id; 
END;








