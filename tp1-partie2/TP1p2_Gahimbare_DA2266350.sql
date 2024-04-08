-- TP1 fichier réponse -- Modifiez le nom du fichier en suivant les instructions
-- Votre nom:  Lena Naomie Johanna Gahimbare       Votre DA: 2266350 
--ASSUREZ VOUS DE LA BONNE LISIBILITÉ DE VOS REQUÊTES  /5--

-- 1.   Rédigez la requête qui affiche la description pour les trois tables. Le nom des champs et leur type. /2
DESC OUTILS_EMPRUNT;
DESC OUTILS_OUTIL;
DESC OUTILS_USAGER;

-- 2.   Rédigez la requête qui affiche la liste de tous les usagers, sous le format prénom « espace » nom de famille (indice : concaténation). /2

SELECT PRENOM || ' ' || NOM_FAMILLE AS "Nom des usagers"
FROM OUTILS_USAGER;

-- 3.   Rédigez la requête qui affiche le nom des villes où habitent les usagers, en ordre alphabétique, le nom des villes va apparaître seulement une seule fois. /2

SELECT DISTINCT VILLE
FROM OUTILS_USAGER
ORDER BY VILLE;

-- 4.   Rédigez la requête qui affiche toutes les informations sur tous les outils en ordre alphabétique sur le nom de l’outil puis sur le code. /2

SELECT *
FROM OUTILS_OUTIL
ORDER BY NOM, CODE_OUTIL;

-- 5.   Rédigez la requête qui affiche le numéro des emprunts qui n’ont pas été retournés. /2

SELECT NUM_EMPRUNT AS "Numéro d'emprunt"
FROM OUTILS_EMPRUNT
WHERE DATE_RETOUR IS NULL;

-- 6.   Rédigez la requête qui affiche le numéro des emprunts faits avant 2014./3

SELECT NUM_EMPRUNT AS "Numéro des emprunts",
       DATE_EMPRUNT AS "Date d'emprunt"
FROM OUTILS_EMPRUNT
WHERE DATE_EMPRUNT < TO_DATE('2014-01-01', 'YYYY-MM-DD');






-- 7.   Rédigez la requête qui affiche le nom et le code des outils dont la couleur début par la lettre « j » (indice : utiliser UPPER() et LIKE) /3

SELECT NOM AS "Nom des outils",
       CODE_OUTIL AS "Code des outils"
FROM OUTILS_OUTIL
WHERE UPPER(CARACTERISTIQUES) LIKE 'J%';

-- 8.   Rédigez la requête qui affiche le nom et le code des outils fabriqués par Stanley. /2

SELECT NOM AS "Nom de l'outil",
       CODE_OUTIL AS "Code de l'outil"
FROM OUTILS_OUTIL
WHERE FABRICANT LIKE 'Stanley';

-- 9.   Rédigez la requête qui affiche le nom et le fabricant des outils fabriqués de 2006 à 2008 (ANNEE). /2

SELECT NOM AS "Nom de l'outil",
       FABRICANT AS "Marque de l'outil"
FROM OUTILS_OUTIL
WHERE ANNEE BETWEEN 2006 AND 2008;

-- 10.  Rédigez la requête qui affiche le code et le nom des outils qui ne sont pas de « 20 volts ». /3

SELECT CODE_OUTIL AS "Code de l'outil",
       NOM AS "Nom de l'outil"
FROM OUTILS_OUTIL
WHERE CARACTERISTIQUES
NOT IN(SELECT CARACTERISTIQUES FROM OUTILS_OUTIL
WHERE CARACTERISTIQUES LIKE '%20 volt%');

-- 11.  Rédigez la requête qui affiche le nombre d’outils qui n’ont pas été fabriqués par Makita. /2
SELECT COUNT(*)
FROM OUTILS_OUTIL
WHERE UPPER(FABRICANT) != 'MAKITA';


-- 12.  Rédigez la requête qui affiche les emprunts des clients de Vancouver et Regina. Il faut afficher le nom complet de l’usager, le numéro d’emprunt, la durée de l’emprunt et le prix de l’outil (indice : n’oubliez pas de traiter le NULL possible (dans les dates et le prix) et utilisez le IN). /5

SELECT CONCAT(usager.NOM_FAMILLE, ' ', usager.PRENOM) AS "Nom Complet",
       emprunt.NUM_EMPRUNT AS "Numéro d'emprunt",
    CASE 
        WHEN outil.PRIX IS NULL THEN 'Prix non disponible'
        ELSE TO_CHAR(outil.PRIX)
    END AS "Prix de l'outil",
    CASE 
        WHEN emprunt.DATE_RETOUR IS NULL THEN 'Emprunt indisponible'
        ELSE TO_CHAR(emprunt.DATE_RETOUR - emprunt.DATE_EMPRUNT)
    END AS "Durée de l'emprunt"
FROM OUTILS_EMPRUNT emprunt
JOIN OUTILS_USAGER usager ON emprunt.NUM_USAGER = usager.NUM_USAGER
JOIN OUTILS_OUTIL outil ON emprunt.CODE_OUTIL = outil.CODE_OUTIL
WHERE usager.VILLE IN ('Vancouver', 'Regina');

-- 13.  Rédigez la requête qui affiche le nom et le code des outils empruntés qui n’ont pas encore été retournés. /4

SELECT outil.NOM AS "Nom de l'outil",
       emprunt.CODE_OUTIL AS "Code de l'outil"
FROM OUTILS_EMPRUNT emprunt
JOIN OUTILS_OUTIL outil ON emprunt.CODE_OUTIL = outil.CODE_OUTIL
WHERE emprunt.DATE_RETOUR IS NULL;

-- 14.  Rédigez la requête qui affiche le nom et le courriel des usagers qui n’ont jamais fait d’emprunts. (indice : IN avec sous-requête) /3

SELECT NOM_FAMILLE AS "Nom de l'usager", 
       COURRIEL AS "Courriel de l'usager"
FROM OUTILS_USAGER
WHERE NUM_USAGER 
NOT IN (SELECT NUM_USAGER FROM OUTILS_EMPRUNT);





-- 15.  Rédigez la requête qui affiche le code et la valeur des outils qui n’ont pas été empruntés. (indice : utiliser une jointure externe – LEFT OUTER, aucun NULL dans les nombres) /4

SELECT outil.CODE_OUTIL AS "Code de l'outil",
     CASE 
        WHEN outil.PRIX IS NULL THEN 'Prix non disponible'
        ELSE TO_CHAR(outil.PRIX)
    END AS "Prix de l'outil"
FROM OUTILS_OUTIL outil
LEFT OUTER JOIN OUTILS_EMPRUNT emprunt ON outil.CODE_OUTIL = emprunt.CODE_OUTIL
WHERE emprunt.CODE_OUTIL IS NULL;

-- 16.  Rédigez la requête qui affiche la liste des outils (nom et prix) qui sont de marque Makita et dont le prix est supérieur à la moyenne des prix de tous les outils. Remplacer les valeurs absentes par la moyenne de tous les autres outils. /4

SELECT 
    NOM AS "Nom de l'outil",
    CASE 
        WHEN PRIX > AVG_PRICE THEN PRIX
        ELSE AVG_PRICE
    END AS "Prix de l'outil"
FROM 
    (  SELECT outil.NOM,
              COALESCE(outil.PRIX, AVG(outil2.PRIX)) AS PRIX,
              AVG(outil2.PRIX) AS AVG_PRICE
        FROM OUTILS_OUTIL outil
        JOIN OUTILS_OUTIL outil2 ON outil.FABRICANT = 'Makita'
        GROUP BY outil.NOM, outil.PRIX
    ) subquery;







-- 17.  Rédigez la requête qui affiche le nom, le prénom et l’adresse des usagers et le nom et le code des outils qu’ils ont empruntés après 2014. Triés par nom de famille. /4

SELECT 
    usager.NOM_FAMILLE AS "Nom des usagers",
    usager.PRENOM AS "Prenom des usagers",
    usager.ADRESSE AS "Adresse des usagers",
    outil.NOM AS "Nom des outils",
    emprunt.CODE_OUTIL AS "Code des outils"
FROM OUTILS_USAGER usager
JOIN OUTILS_EMPRUNT emprunt ON usager.NUM_USAGER = emprunt.NUM_USAGER
JOIN OUTILS_OUTIL outil ON emprunt.CODE_OUTIL = outil.CODE_OUTIL
WHERE emprunt.DATE_EMPRUNT > '2014-01-01'
ORDER BY usager.NOM_FAMILLE;

-- 18.  Rédigez la requête qui affiche le nom et le prix des outils qui ont été empruntés plus qu’une fois. /4

SELECT outil.NOM AS "Nom de l'outil",
       outil.PRIX AS "Prix de l'outil"
FROM OUTILS_OUTIL outil
JOIN OUTILS_EMPRUNT emprunt ON outil.CODE_OUTIL = emprunt.CODE_OUTIL
GROUP BY outil.NOM, outil.PRIX
HAVING COUNT(*) > 1;


-- 19.  Rédigez la requête qui affiche le nom, l’adresse et la ville de tous les usagers qui ont fait des emprunts en utilisant : /6

--  Une jointure
SELECT DISTINCT usager.NOM_FAMILLE AS "Nom de famille",
                usager.ADRESSE AS "Adresse",
                usager.VILLE AS "Ville"
FROM OUTILS_USAGER usager
JOIN OUTILS_EMPRUNT emprunt ON usager.NUM_USAGER = emprunt.NUM_USAGER;







--  IN

SELECT NOM_FAMILLE AS "Nom de Famille",
       ADRESSE AS "Adresse",
       VILLE AS "Ville"
FROM OUTILS_USAGER
WHERE NUM_USAGER IN (SELECT DISTINCT NUM_USAGER FROM OUTILS_EMPRUNT);

--  EXISTS

SELECT NOM_FAMILLE AS "Nom de famille",
       ADRESSE AS "Adresse",
       VILLE AS "Ville"
FROM OUTILS_USAGER usager
WHERE 
    EXISTS (SELECT 1 FROM OUTILS_EMPRUNT emprunt 
    WHERE usager.NUM_USAGER = emprunt.NUM_USAGER);

-- 20.  Rédigez la requête qui affiche la moyenne du prix des outils par marque. /3

SELECT FABRICANT AS "Marque", 
       AVG(PRIX) AS "Moyenne du Prix"
FROM OUTILS_OUTIL
GROUP BY FABRICANT;

-- 21.  Rédigez la requête qui affiche la somme des prix des outils empruntés par ville, en ordre décroissant de valeur. /4

SELECT usager.VILLE,
       SUM(outil.PRIX) AS "Somme des prix"
FROM OUTILS_EMPRUNT emprunt
JOIN OUTILS_USAGER usager ON emprunt.NUM_USAGER = usager.NUM_USAGER
JOIN OUTILS_OUTIL outil ON emprunt.CODE_OUTIL = outil.CODE_OUTIL
GROUP BY usager.VILLE
ORDER BY SUM(outil.PRIX) DESC;








-- 22.  Rédigez la requête pour insérer un nouvel outil en donnant une valeur pour chacun des attributs. /2
INSERT INTO OUTILS_OUTIL (CODE_OUTIL, NOM, FABRICANT, CARACTERISTIQUES, ANNEE, PRIX)
VALUES ('LN456', 'Couteau', 'Dan', '1 metre, acier', '2023', '175');


-- 23.  Rédigez la requête pour insérer un nouvel outil en indiquant seulement son nom, son code et son année. /2
INSERT INTO OUTILS_OUTIL (CODE_OUTIL, NOM, ANNEE)
VALUES ('AD123', 'Arc', '2024');

-- 24.  Rédigez la requête pour effacer les deux outils que vous venez d’insérer dans la table. /2
DELETE FROM OUTILS_OUTIL
WHERE CODE_OUTIL IN ('LN456', 'AD123');

-- 25.  Rédigez la requête pour modifier le nom de famille des usagers afin qu’ils soient tous en majuscules. /2
UPDATE OUTILS_USAGER
SET NOM_FAMILLE = UPPER(NOM_FAMILLE);


