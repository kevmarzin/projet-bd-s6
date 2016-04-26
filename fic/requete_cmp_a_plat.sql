SET @Debut_Saison = 2014;
SET @Champ = 'Liga';
SET @Nb_Match_par_saison = (CASE 
								WHEN @Champ = 'Bundesliga' THEN 34
								ELSE 38
							END);

SELECT  Club,
		ROUND((Proba_V/(Proba_V+Proba_N+Proba_D))*@Nb_Match_par_saison) AS Prediction_V, V, CONCAT(ROUND(((((Proba_V/(Proba_V+Proba_N+Proba_D))*@Nb_Match_par_saison)-V)/V)*100,2),'%') AS ErreurV,
		ROUND((Proba_N/(Proba_V+Proba_N+Proba_D))*@Nb_Match_par_saison) AS Prediction_N, N, CONCAT(ROUND(((((Proba_N/(Proba_V+Proba_N+Proba_D))*@Nb_Match_par_saison)-N)/N)*100,2),'%') AS ErreurN,
		ROUND((Proba_D/(Proba_V+Proba_N+Proba_D))*@Nb_Match_par_saison) AS Prediction_D, D, CONCAT(ROUND(((((Proba_D/(Proba_V+Proba_N+Proba_D))*@Nb_Match_par_saison)-D)/D)*100,2),'%') AS ErreurN
		
FROM (SELECT Renc_Id, Club, COUNT(CASE WHEN Buts_Marques > Buts_Encaisses THEN 'VICTOIRE' END) AS V,
             COUNT(CASE WHEN Buts_Marques = Buts_Encaisses THEN 'NUL' END) AS N,
             COUNT(CASE WHEN Buts_Marques < Buts_Encaisses THEN 'DEFAITE' END) AS D
		FROM ((SELECT Renc_Id, `Rencontre_a_plat`.Renc_Club_Nom_Domicile AS Club, `Rencontre_a_plat`.Renc_Buts_Domicile AS Buts_Marques,
                                            `Rencontre_a_plat`.Renc_Buts_Exterieur AS Buts_Encaisses
					FROM `Rencontre_a_plat`
					WHERE `Rencontre_a_plat`.Renc_Champ_Nom = @Champ AND `Rencontre_a_plat`.Renc_Saison_Annee_Debut = @Debut_Saison)
				UNION
			   (SELECT Renc_Id, `Rencontre_a_plat`.Renc_Club_Nom_Exterieur AS Club, `Rencontre_a_plat`.Renc_Buts_Exterieur AS Buts_Marques, 
										`Rencontre_a_plat`.Renc_Buts_Domicile  AS Buts_Encaisses
					FROM `Rencontre_a_plat`
					WHERE `Rencontre_a_plat`.Renc_Champ_Nom = @Champ AND `Rencontre_a_plat`.Renc_Saison_Annee_Debut = @Debut_Saison)) AS Liste_Matchs
		GROUP BY Club) AS Ratios
INNER JOIN  (SELECT Renc_Id, Nom_Club, 1/AVG(Cote_Victoire) AS Proba_V, 1/AVG(Cote_Nul) AS Proba_N, 1/AVG(Cote_Defaite) AS Proba_D
			FROM
				(SELECT Renc_Id, Nom_Club, Cote_Victoire, Cote_Nul, Cote_Defaite 
					FROM ((SELECT Renc_Id, Renc_Club_Nom_Domicile As Nom_Club, Cote_Domicile_B365 AS Cote_Victoire, Cote_Nul_B365 AS Cote_Nul, Cote_Exterieur_B365 AS Cote_Defaite FROM `Rencontre_a_plat` WHERE `Rencontre_a_plat`.Renc_Champ_Nom = @Champ AND `Rencontre_a_plat`.Renc_Saison_Annee_Debut = @Debut_Saison AND Cote_Domicile_B365 IS NOT NULL) 
						UNION
						(SELECT Renc_Id, Renc_Club_Nom_Domicile As Nom_Club, Cote_Domicile_BS AS Cote_Victoire, Cote_Nul_BS AS Cote_Nul, Cote_Exterieur_BS AS Cote_Defaite FROM `Rencontre_a_plat` WHERE `Rencontre_a_plat`.Renc_Champ_Nom = @Champ AND `Rencontre_a_plat`.Renc_Saison_Annee_Debut = @Debut_Saison AND Cote_Domicile_BS IS NOT NULL)
						UNION
						(SELECT Renc_Id, Renc_Club_Nom_Domicile As Nom_Club, Cote_Domicile_BW AS Cote_Victoire, Cote_Nul_BW AS Cote_Nul, Cote_Exterieur_BW AS Cote_Defaite FROM `Rencontre_a_plat` WHERE `Rencontre_a_plat`.Renc_Champ_Nom = @Champ AND `Rencontre_a_plat`.Renc_Saison_Annee_Debut = @Debut_Saison AND Cote_Domicile_BW IS NOT NULL) 
						UNION
						(SELECT Renc_Id, Renc_Club_Nom_Domicile As Nom_Club, Cote_Domicile_GB AS Cote_Victoire, Cote_Nul_GB AS Cote_Nul, Cote_Exterieur_GB AS Cote_Defaite FROM `Rencontre_a_plat` WHERE `Rencontre_a_plat`.Renc_Champ_Nom = @Champ AND `Rencontre_a_plat`.Renc_Saison_Annee_Debut = @Debut_Saison AND Cote_Domicile_GB IS NOT NULL)
						UNION
						(SELECT Renc_Id, Renc_Club_Nom_Domicile As Nom_Club, Cote_Domicile_IW AS Cote_Victoire, Cote_Nul_IW AS Cote_Nul, Cote_Exterieur_IW AS Cote_Defaite FROM `Rencontre_a_plat` WHERE `Rencontre_a_plat`.Renc_Champ_Nom = @Champ AND `Rencontre_a_plat`.Renc_Saison_Annee_Debut = @Debut_Saison AND Cote_Domicile_IW IS NOT NULL)
						UNION
						(SELECT Renc_Id, Renc_Club_Nom_Domicile As Nom_Club, Cote_Domicile_LB AS Cote_Victoire, Cote_Nul_LB AS Cote_Nul, Cote_Exterieur_LB AS Cote_Defaite FROM `Rencontre_a_plat` WHERE `Rencontre_a_plat`.Renc_Champ_Nom = @Champ AND `Rencontre_a_plat`.Renc_Saison_Annee_Debut = @Debut_Saison AND Cote_Domicile_LB IS NOT NULL)
						UNION
						(SELECT Renc_Id, Renc_Club_Nom_Domicile As Nom_Club, Cote_Domicile_PS AS Cote_Victoire, Cote_Nul_PS AS Cote_Nul, Cote_Exterieur_PS AS Cote_Defaite FROM `Rencontre_a_plat` WHERE `Rencontre_a_plat`.Renc_Champ_Nom = @Champ AND `Rencontre_a_plat`.Renc_Saison_Annee_Debut = @Debut_Saison AND Cote_Domicile_PS IS NOT NULL)
						UNION
						(SELECT Renc_Id, Renc_Club_Nom_Domicile As Nom_Club, Cote_Domicile_SB AS Cote_Victoire, Cote_Nul_SB AS Cote_Nul, Cote_Exterieur_SB AS Cote_Defaite FROM `Rencontre_a_plat` WHERE `Rencontre_a_plat`.Renc_Champ_Nom = @Champ AND `Rencontre_a_plat`.Renc_Saison_Annee_Debut = @Debut_Saison AND Cote_Domicile_SB IS NOT NULL)
						UNION
						(SELECT Renc_Id, Renc_Club_Nom_Domicile As Nom_Club, Cote_Domicile_SJ AS Cote_Victoire, Cote_Nul_SJ AS Cote_Nul, Cote_Exterieur_SJ AS Cote_Defaite FROM `Rencontre_a_plat` WHERE `Rencontre_a_plat`.Renc_Champ_Nom = @Champ AND `Rencontre_a_plat`.Renc_Saison_Annee_Debut = @Debut_Saison AND Cote_Domicile_SJ IS NOT NULL)
						UNION
						(SELECT Renc_Id, Renc_Club_Nom_Domicile As Nom_Club, Cote_Domicile_VC AS Cote_Victoire, Cote_Nul_VC AS Cote_Nul, Cote_Exterieur_VC AS Cote_Defaite FROM `Rencontre_a_plat` WHERE `Rencontre_a_plat`.Renc_Champ_Nom = @Champ AND `Rencontre_a_plat`.Renc_Saison_Annee_Debut = @Debut_Saison AND Cote_Domicile_VC IS NOT NULL) 
						UNION
						(SELECT Renc_Id, Renc_Club_Nom_Domicile As Nom_Club, Cote_Domicile_WH AS Cote_Victoire, Cote_Nul_WH AS Cote_Nul, Cote_Exterieur_WH AS Cote_Defaite FROM `Rencontre_a_plat` WHERE `Rencontre_a_plat`.Renc_Champ_Nom = @Champ AND `Rencontre_a_plat`.Renc_Saison_Annee_Debut = @Debut_Saison AND Cote_Domicile_WH IS NOT NULL)
					UNION 
						(SELECT Renc_Id, Renc_Club_Nom_Exterieur As Nom_Club, Cote_Exterieur_B365 AS Cote_Victoire, Cote_Nul_B365 AS Cote_Nul, Cote_Domicile_B365 AS Cote_Defaite FROM `Rencontre_a_plat` WHERE `Rencontre_a_plat`.Renc_Champ_Nom = @Champ AND `Rencontre_a_plat`.Renc_Saison_Annee_Debut = @Debut_Saison AND Cote_Exterieur_B365 IS NOT NULL)
						UNION
						(SELECT Renc_Id, Renc_Club_Nom_Exterieur As Nom_Club, Cote_Exterieur_BS AS Cote_Victoire, Cote_Nul_BS AS Cote_Nul, Cote_Domicile_BS AS Cote_Defaite FROM `Rencontre_a_plat` WHERE `Rencontre_a_plat`.Renc_Champ_Nom = @Champ AND `Rencontre_a_plat`.Renc_Saison_Annee_Debut = @Debut_Saison AND Cote_Domicile_BS IS NOT NULL)
						UNION
						(SELECT Renc_Id, Renc_Club_Nom_Exterieur As Nom_Club, Cote_Exterieur_BW AS Cote_Victoire, Cote_Nul_BW AS Cote_Nul, Cote_Domicile_BW AS Cote_Defaite FROM `Rencontre_a_plat` WHERE `Rencontre_a_plat`.Renc_Champ_Nom = @Champ AND `Rencontre_a_plat`.Renc_Saison_Annee_Debut = @Debut_Saison AND Cote_Domicile_BW IS NOT NULL)
						UNION
						(SELECT Renc_Id, Renc_Club_Nom_Exterieur As Nom_Club, Cote_Exterieur_GB AS Cote_Victoire, Cote_Nul_GB AS Cote_Nul, Cote_Domicile_GB AS Cote_Defaite FROM `Rencontre_a_plat` WHERE `Rencontre_a_plat`.Renc_Champ_Nom = @Champ AND `Rencontre_a_plat`.Renc_Saison_Annee_Debut = @Debut_Saison AND Cote_Domicile_GB IS NOT NULL)
						UNION
						(SELECT Renc_Id, Renc_Club_Nom_Exterieur As Nom_Club, Cote_Exterieur_IW AS Cote_Victoire, Cote_Nul_IW AS Cote_Nul, Cote_Domicile_IW AS Cote_Defaite FROM `Rencontre_a_plat` WHERE `Rencontre_a_plat`.Renc_Champ_Nom = @Champ AND `Rencontre_a_plat`.Renc_Saison_Annee_Debut = @Debut_Saison AND Cote_Domicile_IW IS NOT NULL)
						UNION
						(SELECT Renc_Id, Renc_Club_Nom_Exterieur As Nom_Club, Cote_Exterieur_LB AS Cote_Victoire, Cote_Nul_LB AS Cote_Nul, Cote_Domicile_LB AS Cote_Defaite FROM `Rencontre_a_plat` WHERE `Rencontre_a_plat`.Renc_Champ_Nom = @Champ AND `Rencontre_a_plat`.Renc_Saison_Annee_Debut = @Debut_Saison AND Cote_Domicile_LB IS NOT NULL)
						UNION
						(SELECT Renc_Id, Renc_Club_Nom_Exterieur As Nom_Club, Cote_Exterieur_PS AS Cote_Victoire, Cote_Nul_PS AS Cote_Nul, Cote_Domicile_PS AS Cote_Defaite FROM `Rencontre_a_plat` WHERE `Rencontre_a_plat`.Renc_Champ_Nom = @Champ AND `Rencontre_a_plat`.Renc_Saison_Annee_Debut = @Debut_Saison AND Cote_Domicile_PS IS NOT NULL)
						UNION
						(SELECT Renc_Id, Renc_Club_Nom_Exterieur As Nom_Club, Cote_Exterieur_SB AS Cote_Victoire, Cote_Nul_SB AS Cote_Nul, Cote_Domicile_SB AS Cote_Defaite FROM `Rencontre_a_plat` WHERE `Rencontre_a_plat`.Renc_Champ_Nom = @Champ AND `Rencontre_a_plat`.Renc_Saison_Annee_Debut = @Debut_Saison AND Cote_Domicile_SB IS NOT NULL)
						UNION
						(SELECT Renc_Id, Renc_Club_Nom_Exterieur As Nom_Club, Cote_Exterieur_SJ AS Cote_Victoire, Cote_Nul_SJ AS Cote_Nul, Cote_Domicile_SJ AS Cote_Defaite FROM `Rencontre_a_plat` WHERE `Rencontre_a_plat`.Renc_Champ_Nom = @Champ AND `Rencontre_a_plat`.Renc_Saison_Annee_Debut = @Debut_Saison AND Cote_Domicile_SJ IS NOT NULL)
						UNION
						(SELECT Renc_Id, Renc_Club_Nom_Exterieur As Nom_Club, Cote_Exterieur_VC AS Cote_Victoire, Cote_Nul_VC AS Cote_Nul, Cote_Domicile_VC AS Cote_Defaite FROM `Rencontre_a_plat` WHERE `Rencontre_a_plat`.Renc_Champ_Nom = @Champ AND `Rencontre_a_plat`.Renc_Saison_Annee_Debut = @Debut_Saison AND Cote_Domicile_VC IS NOT NULL)
						UNION
						(SELECT Renc_Id, Renc_Club_Nom_Exterieur As Nom_Club, Cote_Exterieur_WH AS Cote_Victoire, Cote_Nul_WH AS Cote_Nul, Cote_Domicile_WH AS Cote_Defaite FROM `Rencontre_a_plat` WHERE `Rencontre_a_plat`.Renc_Champ_Nom = @Champ AND `Rencontre_a_plat`.Renc_Saison_Annee_Debut = @Debut_Saison AND Cote_Domicile_WH IS NOT NULL)) AS Liste_Cotes) AS Moy_Cote
					GROUP BY Nom_Club) AS t ON Ratios.Renc_Id = t.Renc_Id AND Ratios.Club = t.Nom_Club
GROUP BY Club;