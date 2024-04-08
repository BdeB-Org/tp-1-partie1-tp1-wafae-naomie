-- TP1 fichier r�ponse -- Modifiez le nom du fichier en suivant les instructions
-- Votre nom:   wafae el-kita                     Votre DA: 6263586
--ASSUREZ VOUS DE LA BONNE LISIBILIT� DE VOS REQU�TES  /5--

-- 1.   R�digez la requ�te qui affiche la description pour les trois tables. Le nom des champs et leur type. /2
-- Table OUTILS_OUTIL
DESC OUTILS_OUTIL;

-- Table OUTILS_USAGER
DESC OUTILS_USAGER;


-- Table OUTILS_EMPRUNT
DESC OUTILS_EMPRUNT;

-- 2.   R�digez la requ�te qui affiche la liste de tous les usagers, sous le format pr�nom � espace � nom de famille (indice : concat�nation). /2

SELECT PRENOM || ' ' || NOM_FAMILLE AS "le nom complet"
FROM OUTILS_USAGER;

-- 3.   R�digez la requ�te qui affiche le nom des villes o� habitent les usagers, en ordre alphab�tique, le nom des villes va appara�tre seulement une seule fois. /2

SELECT DISTINCT VILLE AS "le nom des villes o� habitent les usagers"
FROM OUTILS_USAGER 
ORDER BY VILLE;

-- 4.   R�digez la requ�te qui affiche toutes les informations sur tous les outils en ordre alphab�tique sur le nom de l�outil puis sur le code. /2

SELECT * 
FROM OUTILS_OUTIL 
ORDER BY NOM, CODE_OUTIL;

-- 5.   R�digez la requ�te qui affiche le num�ro des emprunts qui n�ont pas �t� retourn�s. /2

SELECT NUM_EMPRUNT AS "le num�ro des emprunts"
FROM OUTILS_EMPRUNT
WHERE DATE_RETOUR IS NULL;

-- 6.   R�digez la requ�te qui affiche le num�ro des emprunts faits avant 2014./3

SELECT NUM_EMPRUNT AS "num�ro des emprunts"
FROM OUTILS_EMPRUNT 
WHERE DATE_EMPRUNT < TO_DATE('2014-01-01', 'YYYY-MM-DD');

-- 7.   R�digez la requ�te qui affiche le nom et le code des outils dont le NOM d�but par la lettre � B � (indice : utiliser UPPER() et LIKE) /3

SELECT NOM, CODE_OUTIL AS " le code des outils"
FROM OUTILS_OUTIL 
WHERE UPPER(NOM) LIKE 'B%';

-- 8.   R�digez la requ�te qui affiche le nom et le code des outils fabriqu�s par Stanley. /2

SELECT NOM, CODE_OUTIL AS " le code des outils"
FROM OUTILS_OUTIL 
WHERE FABRICANT = 'Stanley';

-- 9.   R�digez la requ�te qui affiche le nom et le fabricant des outils fabriqu�s de 2006 � 2008 (ANNEE). /2

SELECT NOM, FABRICANT AS "le fabricant des outils" 
FROM OUTILS_OUTIL 
WHERE ANNEE BETWEEN 2006 AND 2008;

-- 10.  R�digez la requ�te qui affiche le code et le nom des outils qui ne sont pas de � 20 volts �. /3

SELECT CODE_OUTIL AS " le code des outils", NOM AS "le nom des outils"
FROM OUTILS_OUTIL 
WHERE CARACTERISTIQUES NOT LIKE '%20 volt%';

-- 11.  R�digez la requ�te qui affiche le nombre d�outils qui n�ont pas �t� fabriqu�s par Makita. /2

SELECT COUNT(*) AS "Nombre d'outils" 
FROM OUTILS_OUTIL 
WHERE FABRICANT != 'Makita';

-- 12.  R�digez la requ�te qui affiche les emprunts des clients de Vancouver et Regina. Il faut afficher le nom complet de l�usager, le num�ro d�emprunt, la dur�e de l�emprunt et le prix de l�outil (indice : n�oubliez pas de traiter le NULL possible (dans les dates et le prix) et utilisez le IN). /5

SELECT u.PRENOM || ' ' || u.NOM_FAMILLE AS "Nom complet", e.NUM_EMPRUNT AS "le num�ro d�emprunt", 
       ROUND((NVL(DATE_RETOUR, SYSDATE) - DATE_EMPRUNT), 0) AS "la dur�e de l�emprunt", o.PRIX AS "le prix de l�outil"
FROM OUTILS_USAGER u
JOIN OUTILS_EMPRUNT e ON u.NUM_USAGER = e.NUM_USAGER
JOIN OUTILS_OUTIL o ON e.CODE_OUTIL = o.CODE_OUTIL
WHERE u.VILLE IN ('Vancouver', 'Regina');

-- 13.  R�digez la requ�te qui affiche le nom et le code des outils emprunt�s qui n�ont pas encore �t� retourn�s. /4

SELECT o.NOM AS "le nom des outils emprunt�s", o.CODE_OUTIL AS "le code des outils emprunt�s"
FROM OUTILS_OUTIL o
JOIN OUTILS_EMPRUNT e 
ON o.CODE_OUTIL = e.CODE_OUTIL
WHERE e.DATE_RETOUR IS NULL;

-- 14.  R�digez la requ�te qui affiche le nom et le courriel des usagers qui n�ont jamais fait d�emprunts. (indice : IN avec sous-requ�te) /3

SELECT NOM_FAMILLE AS "Nom de famille", COURRIEL 
FROM OUTILS_USAGER 
WHERE NUM_USAGER NOT IN (SELECT DISTINCT NUM_USAGER 
                         FROM OUTILS_EMPRUNT);
						 
-- 15.  R�digez la requ�te qui affiche le code et la valeur des outils qui n�ont pas �t� emprunt�s. (indice : utiliser une jointure externe � LEFT OUTER, aucun NULL dans les nombres) /4

SELECT o.CODE_OUTIL, o.PRIX 
FROM OUTILS_OUTIL o 
LEFT OUTER JOIN OUTILS_EMPRUNT e 
ON o.CODE_OUTIL = e.CODE_OUTIL 
WHERE e.NUM_EMPRUNT IS NULL;

-- 16.  R�digez la requ�te qui affiche la liste des outils (nom et prix) qui sont de marque Makita et dont le prix est sup�rieur � la moyenne des prix de tous les outils. Remplacer les valeurs absentes par la moyenne de tous les autres outils. /4

SELECT o.NOM, NVL(O.PRIX, (SELECT AVG(PRIX) 
                           FROM OUTILS_OUTIL)) AS "Prix"
FROM OUTILS_OUTIL o
WHERE o.FABRICANT = 'Makita' AND O.PRIX > (SELECT AVG(PRIX) 
                                           FROM OUTILS_OUTIL);
										   
-- 17.  R�digez la requ�te qui affiche le nom, le pr�nom et l�adresse des usagers et le nom et le code des outils qu�ils ont emprunt�s apr�s 2014. Tri�s par nom de famille. /4

SELECT u.NOM_FAMILLE, u.PRENOM, u.ADRESSE, o.NOM, o.CODE_OUTIL
FROM OUTILS_USAGER u
JOIN OUTILS_EMPRUNT e 
ON u.NUM_USAGER = e.NUM_USAGER
JOIN OUTILS_OUTIL o 
ON e.CODE_OUTIL = o.CODE_OUTIL
WHERE e.DATE_EMPRUNT > TO_DATE('2014-01-01', 'YYYY-MM-DD')
ORDER BY u.NOM_FAMILLE;

-- 18.  R�digez la requ�te qui affiche le nom et le prix des outils qui ont �t� emprunt�s plus qu�une fois. /4

SELECT o.NOM, o.PRIX AS "le prix des outils"
FROM OUTILS_OUTIL o 
JOIN OUTILS_EMPRUNT e 
ON o.CODE_OUTIL = e.CODE_OUTIL 
GROUP BY o.NOM, o.PRIX HAVING COUNT(*) > 1;

-- 19.  R�digez la requ�te qui affiche le nom, l�adresse et la ville de tous les usagers qui ont fait des emprunts en utilisant : /6

--  Une jointure
SELECT u.NOM_FAMILLE AS "le nom", u.ADRESSE AS "l�adresse", u.VILLE AS "la ville"
FROM OUTILS_USAGER u
JOIN OUTILS_EMPRUNT e
ON u.NUM_USAGER = e.NUM_USAGER;

--  IN
SELECT NOM_FAMILLE AS "le nom", ADRESSE AS "l�adresse", VILLE AS "la ville"
FROM OUTILS_USAGER
WHERE NUM_USAGER IN (SELECT NUM_USAGER 
                     FROM OUTILS_EMPRUNT);

--  EXISTS
SELECT NOM_FAMILLE AS "le nom", ADRESSE AS "l�adresse", VILLE AS "la ville"
FROM OUTILS_USAGER u
WHERE EXISTS (SELECT * 
              FROM OUTILS_EMPRUNT e 
			  WHERE u.NUM_USAGER = e.NUM_USAGER);

-- 20.  R�digez la requ�te qui affiche la moyenne du prix des outils par marque. /3

SELECT FABRICANT, AVG(PRIX) AS "la moyenne du prix"
FROM OUTILS_OUTIL
GROUP BY FABRICANT;

-- 21.  R�digez la requ�te qui affiche la somme des prix des outils emprunt�s par ville, en ordre d�croissant de valeur. /4

SELECT u.VILLE, SUM(o.PRIX) AS SOMME_PRIX
FROM OUTILS_EMPRUNT e
JOIN OUTILS_USAGER u ON e.NUM_USAGER = u.NUM_USAGER
JOIN OUTILS_OUTIL o ON e.CODE_OUTIL = o.CODE_OUTIL
GROUP BY u.VILLE
ORDER BY SOMME_PRIX DESC;

-- 22.  R�digez la requ�te pour ins�rer un nouvel outil en donnant une valeur pour chacun des attributs. /2

INSERT INTO OUTILS_OUTIL (CODE_OUTIL, NOM, FABRICANT, CARACTERISTIQUES, ANNEE, PRIX)
VALUES ('FF115', 'Perceuse', 'Sonny', '90 watt, verte, batterie', '2024', '700');

-- 23.  R�digez la requ�te pour ins�rer un nouvel outil en indiquant seulement son nom, son code et son ann�e. /2

INSERT INTO OUTILS_OUTIL (CODE_OUTIL, NOM, ANNEE)
VALUES ('F1112', 'Toupie', 2023);

-- 24.  R�digez la requ�te pour effacer les deux outils que vous venez d�ins�rer dans la table. /2

DELETE 
FROM OUTILS_OUTIL 
WHERE CODE_OUTIL IN ('FF115', 'F1112');

-- 25.  R�digez la requ�te pour modifier le nom de famille des usagers afin qu�ils soient tous en majuscules. /2

UPDATE OUTILS_USAGER 
SET NOM_FAMILLE = UPPER(NOM_FAMILLE);
