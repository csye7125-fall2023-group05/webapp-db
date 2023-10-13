SET search_path TO csye7125;

CREATE TABLE cars (
  id INT PRIMARY KEY,
  brand VARCHAR(255),
  model VARCHAR(255),
  year INT 
); 

CREATE TABLE car_price (
  car_id INT,
  price INT,
  FOREIGN KEY (car_id) REFERENCES cars(id)
); 



INSERT INTO cars (id,brand, model, year)
VALUES
  (1,'Volvo', 'p1800', 1968),
  (2,'BMW', 'M1', 1978),
  (3,'Toyota', 'Celica', 1975); 

  INSERT INTO car_price (car_id,price)
VALUES
  (1,20000),
  (2,50000),
  (3,70000); 