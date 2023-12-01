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
    czas_naprawy DATE,
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





