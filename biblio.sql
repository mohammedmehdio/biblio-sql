/*Étape 1 : Création de la Base de Données

Créer une nouvelle base de données appelée Bibliotheque.*/

create database Bibliothèque;

/*Étape 2 : Création des Tables*/

/*Créer une table Auteurs*/

create table Auteurs (
AuteurID INT PRIMARY KEY IDENTITY,
Nom VARCHAR(100),
Prenom VARCHAR(100),
DateNaissance DATE
);

/*Créer une table Livres*/

create table Livres (
LivreID INT PRIMARY KEY IDENTITY,
Titre VARCHAR(200),
Genre VARCHAR(50),
AuteurID INT FOREIGN KEY references Auteurs(AuteurID)
);

/*Créer une table Membres*/

create table Membres (
MembreID INT PRIMARY KEY IDENTITY,
Nom VARCHAR(100),
Prenom VARCHAR(100),
DateInscription DATE
);

/*Créer une table Emprunts*/

create table Emprunts (
EmpruntID INT PRIMARY KEY IDENTITY,
MembreID INT FOREIGN KEY references Membres(MembreID),
LivreID INT FOREIGN KEY references  Livres(LivreID),
DateEmprunt DATE,
DateRetour DATE
);

/*Étape 3 : Insertion de Données*/

GO
INSERT INTO Auteurs (Nom, Prenom, DateNaissance) VALUES
('Hugo', 'Victor', '1802-02-26'),
('Dumas', 'Alexandre', '1802-07-24'),
('Zola', 'Émile', '1840-04-02');
GO

INSERT INTO Livres (Titre, Genre, AuteurID) VALUES
('Les Misérables', 'Roman', 1),
('Notre-Dame de Paris', 'Roman', 1),
('Le Comte de Monte-Cristo', 'Aventure', 2),
('Les Trois Mousquetaires', 'Aventure', 2),
('Germinal', 'Roman', 3);
GO

INSERT INTO Membres (Nom, Prenom, DateInscription) VALUES
('Dupont', 'Jean', '2024-01-15'),
('Martin', 'Sophie', '2024-02-20'),
('Bernard', 'Luc', '2024-03-05'),
('Petit', 'Marie', '2024-04-10'),
('Roux', 'Pierre', '2024-05-15'),
('Moreau', 'Lucie', '2024-06-20'),
('Simon', 'Paul', '2024-07-25');
GO

INSERT INTO Emprunts (MembreID, LivreID, DateEmprunt, DateRetour) VALUES
(1, 1, '2024-06-01', '2024-06-15'),
(2, 2, '2024-06-05', '2024-06-20'),
(3, 3, '2024-06-10', '2024-06-25'),
(4, 4, '2024-06-15', '2024-06-30'),
(5, 5, '2024-06-20', '2024-07-05'),
(6, 1, '2024-06-25', '2024-07-10'),
(7, 2, '2024-06-30', '2024-07-15'),
(1, 3, '2024-07-01', '2024-07-16'),
(2, 4, '2024-07-05', '2024-07-20'),
(3, 5, '2024-07-10', '2024-07-25');
GO

/*Étape 4 : Requêtes SQL*/

/*Sélectionner tous les livres et leurs auteurs.*/

select Livres.Titre , Auteurs.Nom,Auteurs.Prenom from Livres inner join Auteurs
on Livres.AuteurID=Auteurs.AuteurID;

/*Sélectionner tous les membres qui ont emprunté un livre.*/

select distinct nom , prenom from Membres inner join Emprunts
on Membres.MembreID=Emprunts.MembreID ;

/*Sélectionner tous les livres qui sont actuellement empruntés (DateRetour est NULL).*/

SELECT Titre, DateRetour
FROM Livres L
JOIN Emprunts E ON L.LivreID = E.LivreID
WHERE E.DateRetour IS NULL;

/*Mettre à jour la date de retour d'un emprunt.*/

update Emprunts set DateRetour='2024-05-25' where EmpruntID=10;

/*Supprimer un membre.*/

select * from Membres;
select * from Emprunts;
select * from Livres;

delete from Emprunts where EmpruntID=7;
delete from Membres where MembreID=7;

/*Étape 5 : Création de Vues*/
/*Créer une vue VueEmpruntsActuels qui affiche les emprunts en cours,
    avec les informations sur les livres et les membres.*/

create view VueEmpruntsActuels as
    select E.empruntID,M.membreID,M.nom,M.prenom,L.livreID,L.titre,L.genre,E.dateEmprunt,E.dateRetour
    from Emprunts E
    join Membres M on E.membreID=M.membreID
    join Livres L on E.livreID=L.livreID
    where E.dateRetour is null;

/*Étape 6 : Création de Procédures Stockées*/
/*Créer une procédure stockée AjouterMembre pour ajouter un nouveau membre. Les paramètres sont Nom, Prenom, et DateInscription.
*/

create procedure AjouterMembre
@Nom varchar(100),
@Prenom varchar(100),
@DateInscription date
    as
    begin
        insert into Membres (Nom,Prenom,DateInscription) values (@Nom,@Prenom,@DateInscription);
    end;


exec ajouterMembre @nom='Dupuis', @prenom='Jean', @DateInscription='2024-08-01';

/*Créer une procédure stockée AjouterEmprunt pour ajouter un nouvel emprunt.
    Les paramètres sont MembreID, LivreID, et DateEmprunt.*/

create procedure AjouterEmprunt
@MembreID int,
@LivreID int,
@DateEmprunt date
    as
    begin
        insert into Emprunts (MembreID, LivreID, DateEmprunt)
    VALUES (@MembreID, @LivreID, @DateEmprunt);
    end;

exec AjouterEmprunt @MembreID=8, @LivreID = 1, @DateEmprunt='2024-08-08';
    select * from Emprunts;
/*Créer une procédure stockée RetournerLivre pour mettre
  à jour la date de retour d'un emprunt. Les paramètres sont EmpruntID et DateRetour.
*/    create procedure RetournerLivre
@EmpruntID int,
@DateRetour date
    as
    begin
        update Emprunts set DateRetour=@DateRetour where EmpruntID=@EmpruntID;
    end;
        exec RetournerLivre @DateRetour='2024-08-20' , @EmpruntID=11;
        select * from Emprunts;

/*Étape 7 : Création de Triggers*/

/*Créer un trigger Trg_AfterInsert_Emprunts qui vérifie après l'insertion
  d'un nouvel emprunt si le livre est déjà emprunté (DateRetour est NULL), et lève une erreur si c'est le cas.
*/

CREATE TRIGGER Trg_AfterInsert_Emprunts
ON Emprunts
after INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Emprunts e
        INNER JOIN inserted i ON e.LivreID = i.LivreID
        WHERE e.DateRetour IS NULL
    )
    BEGIN
        RAISERROR ('Le livre est déjà emprunté.', 16, 1);
        ROLLBACK TRANSACTION;

    END
END;

insert into Emprunts (MembreID,LivreID,DateEmprunt) values (8,1,'2024-08-10');

/*Créer un trigger Trg_BeforeUpdate_Emprunts qui vérifie avant la mise à jour de la date de retour si la nouvelle date
    de retour est supérieure à la date d'emprunt, et lève une erreur si ce n'est pas le cas.*/

CREATE TRIGGER Trg_BeforeUpdate_Emprunts
ON Emprunts
instead of UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Emprunts e
        INNER JOIN inserted i ON e.EmpruntID = i.EmpruntID
        WHERE i.DateRetour < e.DateEmprunt
    )
    BEGIN
        RAISERROR ('La date de retour doit être supérieure à la date d''emprunt.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

update Emprunts set DateRetour='2024-08-05' where EmpruntID=11;

/*Étape 8 : Indexation*/

/*Créer un index sur la colonne Nom de la table Auteurs pour accélérer les recherches par nom.*/
CREATE INDEX idx_Nom_Auteurs ON Auteurs (Nom);

/*Créer un index sur la colonne Titre de la table Livres pour accélérer les recherches par titre.*/
    create index idx_Titre on Livres(Titre);

