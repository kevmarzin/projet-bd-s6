SET @Debut_Saison = 2014;
SET @Champ = 'Liga';
SET @Place = 0;

SELECT  @Place := @Place + 1 AS '',
        `Liste_Matchs`.Club,
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
FROM ((SELECT `Rencontre_a_plat`.Renc_Club_Nom_Domicile AS Club, `Rencontre_a_plat`.Renc_Buts_Domicile AS Buts_Marques,
                                            `Rencontre_a_plat`.Renc_Buts_Exterieur AS Buts_Encaisses,
                                            `Rencontre_a_plat`.Renc_Tirs_Domicile AS Nb_Tirs,
                                            `Rencontre_a_plat`.Renc_Tirs_Cadres_Domicile AS Nb_Tirs_Cadres,
                                            `Rencontre_a_plat`.Renc_Fautes_Domicile AS Nb_Fautes,
                                            `Rencontre_a_plat`.Renc_Corners_Domicile AS Nb_Corners,
                                            `Rencontre_a_plat`.Renc_Cartons_Jaune_Domicile AS Nb_Jaunes, 
                                            `Rencontre_a_plat`.Renc_Cartons_Rouge_Domicile AS Nb_Rouges
                        FROM `Rencontre_a_plat`
                        WHERE `Rencontre_a_plat`.Renc_Champ_Nom = @Champ AND `Rencontre_a_plat`.Renc_Saison_Annee_Debut = @Debut_Saison)
                    UNION
                   (SELECT `Rencontre_a_plat`.Renc_Club_Nom_Exterieur AS Club, `Rencontre_a_plat`.Renc_Buts_Exterieur AS Buts_Marques, 
                                            `Rencontre_a_plat`.Renc_Buts_Domicile  AS Buts_Encaisses,
                                            `Rencontre_a_plat`.Renc_Tirs_Exterieur AS Nb_Tirs,
                                            `Rencontre_a_plat`.Renc_Tirs_Cadres_Exterieur AS Nb_Tirs_Cadres,
                                            `Rencontre_a_plat`.Renc_Fautes_Exterieur AS Nb_Fautes,
                                            `Rencontre_a_plat`.Renc_Corners_Exterieur AS Nb_Corners,
                                            `Rencontre_a_plat`.Renc_Cartons_Jaune_Exterieur AS Nb_Jaunes, 
                                            `Rencontre_a_plat`.Renc_Cartons_Rouge_Exterieur AS Nb_Rouges
                        FROM `Rencontre_a_plat`
                        WHERE `Rencontre_a_plat`.Renc_Champ_Nom = @Champ AND `Rencontre_a_plat`.Renc_Saison_Annee_Debut = @Debut_Saison)) AS Liste_Matchs
GROUP BY Club
ORDER BY Pts DESC;