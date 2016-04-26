SET @Debut_Saison = 2014;
SET @Champ = 'Liga';
SET @Nb_Match_par_saison = (CASE 
								WHEN @Champ = 'Bundesliga' THEN 34
								ELSE 38
							END);

SELECT      Club,
            ROUND((CV/(CV+CN+CD))*@Nb_Match_par_saison) AS Prediction_V, V, CONCAT(ROUND(((((CV/(CV+CN+CD))*@Nb_Match_par_saison)-V)/V)*100,2),'%') AS ErreurV,
            ROUND((CN/(CV+CN+CD))*@Nb_Match_par_saison) AS Prediction_N, N, CONCAT(ROUND(((((CN/(CV+CN+CD))*@Nb_Match_par_saison)-N)/N)*100,2),'%') AS ErreurN,
            ROUND((CD/(CV+CN+CD))*@Nb_Match_par_saison) AS Prediction_D, D, CONCAT(ROUND(((((CD/(CV+CN+CD))*@Nb_Match_par_saison)-D)/D)*100,2),'%') AS ErreurN
        FROM (
                SELECT Renc_Id, `Liste_Cotes`.Club_Nom AS Club, 1/AVG(`Liste_Cotes`.Cote_Victoire) AS CV, 1/AVG(`Liste_Cotes`.Cote_Nul) AS CN, 1/AVG(`Liste_Cotes`.Cote_Defaite) AS CD
                FROM ((SELECT Renc_Id, `Club`.Club_Nom, `Cote`.Cote_Domicile AS Cote_Victoire, `Cote`.Cote_Nul AS Cote_Nul,
                                                    `Cote`.Cote_Exterieur AS Cote_Defaite
                        FROM `Cote`
                        INNER JOIN `Rencontre` ON `Rencontre`.Renc_Id = `Cote`.Cote_Renc_Id
                            INNER JOIN `Club` ON `Rencontre`.Renc_Club_Id_Domicile = `Club`.Club_Id
                                INNER JOIN `Championnat` ON `Championnat`.Champ_Id = `Club`.Club_Champ_Id AND `Championnat`.Champ_Nom = @Champ
                        INNER JOIN `Saison` ON `Saison`.Saison_Id = `Rencontre`.Renc_Saison_Id AND `Saison`.Saison_Annee_Debut = @Debut_Saison)
                        UNION
                       (SELECT Renc_Id, `Club`.Club_Nom, `Cote`.Cote_Exterieur AS Cote_Victoire, `Cote`.Cote_Nul AS Cote_Nul,
                                                `Cote`.Cote_Domicile AS Cote_Defaite
                            FROM `Cote`
                            INNER JOIN `Rencontre` ON `Rencontre`.Renc_Id = `Cote`.Cote_Renc_Id
                                INNER JOIN `Club` ON `Rencontre`.Renc_Club_Id_Exterieur = `Club`.Club_Id
                                    INNER JOIN `Championnat` ON `Championnat`.Champ_Id = `Club`.Club_Champ_Id AND `Championnat`.Champ_Nom = @Champ
                            INNER JOIN `Saison` ON `Saison`.Saison_Id = `Rencontre`.Renc_Saison_Id AND `Saison`.Saison_Annee_Debut = @Debut_Saison))
            AS Liste_Cotes
        GROUP BY Club_Nom) AS Moy_Cote
        INNER JOIN (SELECT  Renc_Id, Club_Nom, COUNT(CASE WHEN Buts_Marques > Buts_Encaisses THEN 'VICTOIRE' END) AS V,
                    COUNT(CASE WHEN Buts_Marques = Buts_Encaisses THEN 'NUL' END) AS N,
                    COUNT(CASE WHEN Buts_Marques < Buts_Encaisses THEN 'DEFAITE' END) AS D
            FROM ((SELECT Renc_Id, `Club`.Club_Nom, `Rencontre`.Renc_Buts_Domicile AS Buts_Marques,
                                            `Rencontre`.Renc_Buts_Exterieur AS Buts_Encaisses
                                    FROM `Rencontre`
                                    INNER JOIN `Club` ON `Rencontre`.Renc_Club_Id_Domicile = `Club`.Club_Id
                                        INNER JOIN `Championnat` ON `Championnat`.Champ_Id = `Club`.Club_Champ_Id AND `Championnat`.Champ_Nom = @Champ
                                    INNER JOIN `Saison` ON `Saison`.Saison_Id = `Rencontre`.Renc_Saison_Id AND `Saison`.Saison_Annee_Debut = @Debut_Saison)
                                UNION
                               (SELECT Renc_Id, `Club`.Club_Nom, `Rencontre`.Renc_Buts_Exterieur AS Buts_Marques, 
                                                        `Rencontre`.Renc_Buts_Domicile  AS Buts_Encaisses
                                    FROM `Rencontre`
                                    INNER JOIN `Club` ON `Rencontre`.Renc_Club_Id_Exterieur = `Club`.Club_Id
                                        INNER JOIN `Championnat` ON `Championnat`.Champ_Id = `Club`.Club_Champ_Id AND `Championnat`.Champ_Nom = @Champ
                                    INNER JOIN `Saison` ON `Saison`.Saison_Id = `Rencontre`.Renc_Saison_Id AND `Saison`.Saison_Annee_Debut = @Debut_Saison)) AS Liste_Matchs
            GROUP BY Club_Nom) Resultat ON Resultat.Renc_Id = Moy_Cote.Renc_Id AND Resultat.Club_Nom = Moy_Cote.Club