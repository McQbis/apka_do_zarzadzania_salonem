INSERT INTO czesc (id, nazwa, cena, rok_produkcji)
SELECT
    czesc_seq.nextval,
    'Czesc ' || LEVEL,
    ROUND(DBMS_RANDOM.VALUE(10, 500), 2),
    TRUNC(DBMS_RANDOM.VALUE(2000, 2023))
FROM DUAL
CONNECT BY LEVEL <= 10;

INSERT INTO klient (id, imie, nazwisko, adres, mail, numer_telefonu)
SELECT
    klient_seq.nextval,
    'Imie' || LEVEL,
    'Nazwisko' || LEVEL,
    'Adres ' || LEVEL,
    'mail' || LEVEL || '@mail.com',
    ROUND(DBMS_RANDOM.VALUE(100000000, 999999999))
FROM DUAL
CONNECT BY LEVEL <= 10;

INSERT INTO marka (nazwa, kraj_pochodzenia, klasa)
SELECT
    'Marka ' || LEVEL,
    'Kraj ' || LEVEL,
    CASE MOD(LEVEL, 3)
        WHEN 0 THEN 'Klasa A'
        WHEN 1 THEN 'Klasa B'
        ELSE 'Klasa C'
    END
FROM DUAL
CONNECT BY LEVEL <= 10;


INSERT INTO stanowisko (nazwa, stawka_za_godzine)
SELECT
    'Stanowisko_' || LEVEL,
    ROUND(DBMS_RANDOM.VALUE(20, 50), 2)
FROM DUAL
CONNECT BY LEVEL <= 10;

INSERT INTO pracownik (id, imie, nazwisko, adres, mail, numer_telefonu, doswiadczenie, stanowisko_id)
SELECT
    pracownik_seq.nextval,
    'Imie_pracownik_' || LEVEL,
    'Nazwisko_pracownik_' || LEVEL,
    'Adres_pracownik_' || LEVEL,
    'pracownik' || LEVEL || '@firmaprzedsiebiorstwo.com',
    ROUND(DBMS_RANDOM.VALUE(100000000, 999999999)),
    'Doswiadczenie_' || LEVEL,
    'Stanowisko_' || LEVEL
FROM DUAL
CONNECT BY LEVEL <= 10;

INSERT INTO rodzaj_samochodu (rodzaj)
SELECT
    'Rodzaj_' || LEVEL
FROM DUAL
CONNECT BY LEVEL <= 10;

INSERT INTO samochod (id, model, rok_produkcji, liczba_drzwi, liczba_miejsc, cena)
SELECT
    samochod_seq.nextval,
    'Model_' || LEVEL,
    TRUNC(DBMS_RANDOM.VALUE(2000, 2023)),
    ROUND(DBMS_RANDOM.VALUE(3, 5)),
    ROUND(DBMS_RANDOM.VALUE(2, 7)),
    ROUND(DBMS_RANDOM.VALUE(10000, 50000), 2)
FROM DUAL
CONNECT BY LEVEL <= 10;


CREATE SEQUENCE sam_zam_seq START WITH 1 INCREMENT BY 1;

INSERT INTO zamowienie (id, data, wartosc_zamowienia)
SELECT
    zamowienie_seq.nextval,
    TO_DATE('2023-01-01', 'YYYY-MM-DD') + LEVEL,
    ROUND(DBMS_RANDOM.VALUE(100, 500), 2)
FROM DUAL
CONNECT BY LEVEL <= 10;

INSERT INTO samochod_zamowienia_fk (samochod_id, zamowienia_id)
SELECT
    sam_zam_seq.nextval,
    ROUND(DBMS_RANDOM.VALUE(1, 5))
FROM DUAL
CONNECT BY LEVEL <= 10;

INSERT INTO silnik (pojemnosc, rodzaj_paliwa, spalanie_na_100km)
SELECT
    ROUND(DBMS_RANDOM.VALUE(1000, 3000), 2),
    CASE MOD(LEVEL, 2)
        WHEN 0 THEN 'Benzyna'
        ELSE 'Diesel'
    END,
    ROUND(DBMS_RANDOM.VALUE(4, 10), 2)
FROM DUAL
CONNECT BY LEVEL <= 10;

INSERT INTO usluga_serwisowa (opis, wartosc, czas_naprawy, pracownik_id, samochod_id, klient_id)
SELECT
    'Opis_uslugi_' || LEVEL,
    ROUND(DBMS_RANDOM.VALUE(100, 1000), 2),
    ROUND(DBMS_RANDOM.VALUE(1, 10)),
    ROUND(DBMS_RANDOM.VALUE(1, 10)),
    LEVEL,
    ROUND(DBMS_RANDOM.VALUE(1, 10))
FROM DUAL
CONNECT BY LEVEL <= 10;
