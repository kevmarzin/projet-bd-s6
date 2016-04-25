SET @Debut_Saison = 2014;
SET @Champ = 'Liga';
SET @Place = 0;
SELECT Club, ROUND((CV/(CV+CN+CD))*38) AS Prediction_V, ROUND((CN/(CV+CN+CD))*38) AS Prediction_N, ROUND((CD/(CV+CN+CD))*38) AS Prediction_D
FROM (
        SELECT `Liste_Cotes`.Club_Nom AS Club, 1/AVG(`Liste_Cotes`.Cote_Victoire) AS CV, 1/AVG(`Liste_Cotes`.Cote_Nul) AS CN, 1/AVG(`Liste_Cotes`.Cote_Defaite) AS CD
        FROM ((SELECT `Club`.Club_Nom, `Cote`.Cote_Domicile AS Cote_Victoire, `Cote`.Cote_Nul AS Cote_Nul,
                                            `Cote`.Cote_Exterieur AS Cote_Defaite
                FROM `Cote`
                INNER JOIN `Rencontre` ON `Rencontre`.Renc_Id = `Cote`.Cote_Renc_Id
                    INNER JOIN `Club` ON `Rencontre`.Renc_Club_Id_Domicile = `Club`.Club_Id
                        INNER JOIN `Championnat` ON `Championnat`.Champ_Id = `Club`.Club_Champ_Id AND `Championnat`.Champ_Nom = @Champ
                INNER JOIN `Saison` ON `Saison`.Saison_Id = `Rencontre`.Renc_Saison_Id AND `Saison`.Saison_Annee_Debut = @Debut_Saison)
                UNION
               (SELECT `Club`.Club_Nom, `Cote`.Cote_Exterieur AS Cote_Victoire, `Cote`.Cote_Nul AS Cote_Nul,
                                        `Cote`.Cote_Domicile AS Cote_Defaite
                    FROM `Cote`
                    INNER JOIN `Rencontre` ON `Rencontre`.Renc_Id = `Cote`.Cote_Renc_Id
                        INNER JOIN `Club` ON `Rencontre`.Renc_Club_Id_Exterieur = `Club`.Club_Id
                            INNER JOIN `Championnat` ON `Championnat`.Champ_Id = `Club`.Club_Champ_Id AND `Championnat`.Champ_Nom = @Champ
                    INNER JOIN `Saison` ON `Saison`.Saison_Id = `Rencontre`.Renc_Saison_Id AND `Saison`.Saison_Annee_Debut = @Debut_Saison))
    AS Liste_Cotes
GROUP BY Club_Nom) AS Moy_Cote;