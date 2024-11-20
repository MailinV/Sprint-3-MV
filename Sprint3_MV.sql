# Mailin Villan SPRINT3 20/11/2024

#-------------------------------- NIVEL 1 ------------------------
# ----------EJERCICIO 1-------------------------------------------

USE transactions;

-- Creo la tabla credit_card
    CREATE TABLE IF NOT EXISTS credit_card (
        id VARCHAR(15) PRIMARY KEY,
        iban VARCHAR(50),
        pan VARCHAR(50),
        pin VARCHAR(4),
        cvv VARCHAR(4),
        expiring_date VARCHAR(20)
    );
    
ALTER TABLE transaction
ADD FOREIGN KEY (credit_card_id) REFERENCES credit_card(id);
    
 SELECT * FROM credit_card;
  
--    select * from credit_card
--    where id = 'CcU-9999';
    
--    INSERT INTO credit_card (id, iban, pin, cvv, expiring_date) VALUES ('CcU-9999', 'iban-9999', 'pin', 'cvv', '00/30/22');

# ----------EJERCICIO 2-------------------------------------------
# El departament de Recursos Humans ha identificat un error en el número de compte de l'usuari amb ID CcU-2938. La informació que ha de mostrar-se per a aquest registre és:
# R323456312213576817699999. Recorda mostrar que el canvi es va realitzar.

# muestra el id y el iban antes del cambio
SELECT id, iban
FROM credit_card
where id = 'CcU-2938'; 

# modificación del iban
update credit_card 
set iban = 'R323456312213576817699999' 
where id = 'CcU-2938'; 

# muestra el id y el iban despues del cambio
SELECT id, iban
FROM credit_card
where id = 'CcU-2938'; 

# ----------EJERCICIO 3-------------------------------------------

# En la taula "transaction" ingressa un nou usuari amb la següent informació:
INSERT INTO company (id, company_name, phone, email, country, website) 
VALUES ('b-9999', 'NA', '00 00 00 00', 'na@mail.com', 'NA', 'https://guardian.co.uk/settings');

select * from credit_card
where id = 'CcU-9999';
    
INSERT INTO credit_card (id, iban, pan, pin, cvv, expiring_date) VALUES ('CcU-9999', 'iban-9999', 'pan','pin', 'cvv', '00/30/22');

INSERT INTO transaction (id, credit_card_id, company_id, user_id, lat, longitude, amount, declined) 
VALUES ('108B1D1D-5B23-A76C-55EF-C568E49A99DD','CcU-9999','b-9999','9999','829.999','-117.999','111.11','0');

SELECT *
FROM transaction
WHERE id = '108B1D1D-5B23-A76C-55EF-C568E49A99DD';

# ----------EJERCICIO 4-------------------------------------------

# Des de recursos humans et sol·liciten eliminar la columna "pan" de la taula credit_*card. Recorda mostrar el canvi realitzat.


ALTER TABLE credit_card DROP pan;

SELECT *
FROM credit_card;


#-------------------------------- NIVEL 2 ------------------------

# ----------EJERCICIO 1-------------------------------------------

# Elimina de la taula transaction el registre amb ID 02C6201E-D90A-1859-B4EE-88D2986D3B02 de la base de dades.

DELETE FROM transaction WHERE id = '02C6201E-D90A-1859-B4EE-88D2986D3B02'; 

# ----------EJERCICIO 2-------------------------------------------

# Serà necessària que creïs una vista anomenada VistaMarketing que contingui la següent informació: Nom de la companyia. Telèfon de contacte. País de residència. 
# Mitjana de compra realitzat per cada companyia. Presenta la vista creada, ordenant les dades de major a menor mitjana de compra.

CREATE VIEW `vistamarketing` AS
SELECT company_name as nombre_compañia, phone as teléfono, country as país, ROUND(AVG(amount),2) as media_compra 
FROM transaction
JOIN company ON transaction.company_id = company.id
WHERE declined = '0'
GROUP BY company_id
ORDER BY 4 DESC;

SELECT * FROM transactions.vistamarketing;

# ----------EJERCICIO 3-------------------------------------------

# Filtra la vista VistaMarketing per a mostrar només les companyies que tenen el seu país de residència en "Germany"

SELECT * FROM transactions.vistamarketing
WHERE país = 'Germany';


#-------------------------------- NIVEL 3 ------------------------
# ----------EJERCICIO 1-------------------------------------------

SELECT *
FROM user; 

SELECT user_id 
FROM transaction 
WHERE user_id NOT IN (SELECT id FROM user); # busco en la tabla transaction el id que no está en la tabla user

SELECT *
FROM user
WHERE id = '9999'; # corroboro que id = 9999 no se encuentrs en user

# agrego el registro con id = 9999 en la tabla user
INSERT INTO user (id, name, surname, phone, email, birth_date, country, city, postal_code, address) VALUES ( "9999", "xx", "xx", "xx", "xx", "xx","xx", "xx", "xx", "xx");

# creo la relación con la dirección correcta 

ALTER TABLE transaction
ADD FOREIGN KEY (user_id) REFERENCES user(id);

# borro la relación existente incorrecta

ALTER TABLE user
DROP FOREIGN KEY user_ibfk_1;

# cambios de la tabla credit_card

ALTER TABLE credit_card
ADD fecha_actual DATE; # Añado el campo fecha_actual 

ALTER TABLE credit_card
MODIFY id VARCHAR(20) not null; # cambio del tipo de datos de id


# cambios de la tabla company

ALTER TABLE company
DROP COLUMN website; # Elimino el campo website

# cambios de la tabla user

RENAME TABLE user to data_user; # cambio de nombre 

ALTER TABLE data_user
CHANGE email personal_email VARCHAR(150); 


# ----------EJERCICIO 2-------------------------------------------

CREATE VIEW `informetecnico` AS
SELECT transaction.id as id_transacción, name as nombre_usuario, surname as apellido_usuario, iban, company_name as nombre_compañia
FROM transaction
JOIN data_user ON transaction.user_id = data_user.id
JOIN company ON transaction.company_id = company.id
JOIN credit_card ON transaction.credit_card_id = credit_card.id
ORDER BY transaction.id DESC;

SELECT * FROM transactions.informetecnico; 
