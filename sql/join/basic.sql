create table A (
                   ID INT PRIMARY KEY,
                   Name VARCHAR(50)
);

create table B (
                   ID INT PRIMARY KEY,
                   Age INT
);

insert into A (ID, Name) values (1, 'John'),(2, 'Jane'),(3, 'Tom');

insert into B (ID, Age) values (1, 25), (2, 30), (4, 35);

select A.ID, A.Name, B.Age from A inner join B on A.ID = B.ID;
select A.ID, A.Name, B.Age from A left join B on A.ID = B.ID;
select A.ID, A.Name, B.Age from A right join B on A.ID = B.ID;
select A.Id, A.Name, B.Age from A full join B on A.ID = B.ID;

select A.ID, A.Name, B.Name as BName, B.ID as BID from A inner join A as B on A.ID = B.ID;