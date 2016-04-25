SET @Debut_Saison = 2014;
SET @Champ = 'Liga';
SET @Place = 0;

SELECT  @Place := @Place + 1 AS '',
        `Liste_Matchs`.Club_Nom AS Club,
        SUM(CASE 
                WHEN Buts_Marques > Buts_Encaisses THEN 3
                WHEN Buts_Marques = Buts_Encaisses THEN 1
                ELSE 0
            END) AS Pts,
        COUNT(CASE WHEN Buts_Marques > Buts_Encaisses THEN 'VICTOIRE' END) AS V,
        COUNT(CASE WHEN Buts_Marques = Buts_Encaisses THEN 'NUL' END) AS N,
        COUNT(CASE WHEN Buts_Marques < Buts_Encaisses THEN 'DEFAITE' END) AS D,
        SUM(Buts_Marques) AS BP,
        SUM(Buts_Encaisses) AS BC,
        (CASE 
            WHEN SUM(Buts_Marques) > SUM(Buts_Encaisses) THEN CONCAT('+', SUM(Buts_Marques) - SUM(Buts_Encaisses))
            WHEN SUM(Buts_Marques) = SUM(Buts_Encaisses) THEN 0
            ELSE SUM(Buts_Marques) - SUM(Buts_Encaisses)
        END) AS DB,
        ROUND(AVG(Nb_Tirs)) AS 'T/M',
        CONCAT(ROUND((AVG(Nb_Tirs_Cadres)/AVG(Nb_Tirs))*100), '%') AS 'TC/M',
        ROUND(AVG(Nb_Fautes)) AS 'F/M',
        ROUND(AVG(Nb_Corners)) AS 'C/M',
        ROUND(SUM(Nb_Jaunes)) AS 'J',
        ROUND(SUM(Nb_Rouges)) AS 'R'
FROM ((SELECT `Club`.Club_Nom, `Rencontre`.Renc_Buts_Domicile AS Buts_Marques,
                                            `Rencontre`.Renc_Buts_Exterieur AS Buts_Encaisses,
                                            `Rencontre`.Renc_Tirs_Domicile AS Nb_Tirs,
                                            `Rencontre`.Renc_Tirs_Cadres_Domicile AS Nb_Tirs_Cadres,
                                            `Rencontre`.Renc_Fautes_Domicile AS Nb_Fautes,
                                            `Rencontre`.Renc_Corners_Domicile AS Nb_Corners,
                                            `Rencontre`.Renc_Cartons_Jaune_Domicile AS Nb_Jaunes, 
                                            `Rencontre`.Renc_Cartons_Rouge_Domicile Nb_Rouges
                        FROM `Rencontre`
                        INNER JOIN `Club` ON `Rencontre`.Renc_Club_Id_Domicile = `Club`.Club_Id
                            INNER JOIN `Championnat` ON `Championnat`.Champ_Id = `Club`.Club_Champ_Id AND `Championnat`.Champ_Nom = @Champ
                        INNER JOIN `Saison` ON `Saison`.Saison_Id = `Rencontre`.Renc_Saison_Id AND `Saison`.Saison_Annee_Debut = @Debut_Saison)
                    UNION
                   (SELECT `Club`.Club_Nom, `Rencontre`.Renc_Buts_Exterieur AS Buts_Marques, 
                                            `Rencontre`.Renc_Buts_Domicile  AS Buts_Encaisses,
                                            `Rencontre`.Renc_Tirs_Exterieur AS Nb_Tirs,
                                            `Rencontre`.Renc_Tirs_Cadres_Exterieur AS Nb_Tirs_Cadres,
                                            `Rencontre`.Renc_Fautes_Exterieur AS Nb_Fautes,
                                            `Rencontre`.Renc_Corners_Exterieur AS Nb_Corners,
                                            `Rencontre`.Renc_Cartons_Jaune_Exterieur AS Nb_Jaunes, 
                                            `Rencontre`.Renc_Cartons_Rouge_Exterieur AS Nb_Rouges
                        FROM `Rencontre`
                        INNER JOIN `Club` ON `Rencontre`.Renc_Club_Id_Exterieur = `Club`.Club_Id
                            INNER JOIN `Championnat` ON `Championnat`.Champ_Id = `Club`.Club_Champ_Id AND `Championnat`.Champ_Nom = @Champ
                        INNER JOIN `Saison` ON `Saison`.Saison_Id = `Rencontre`.Renc_Saison_Id AND `Saison`.Saison_Annee_Debut = @Debut_Saison)) AS Liste_Matchs
GROUP BY Club_Nom
ORDER BY Pts DESC;