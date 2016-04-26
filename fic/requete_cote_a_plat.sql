SET @Debut_Saison = 2014;
SET @Champ = 'Liga';
SET @Nb_Match_par_saison = (CASE 
								WHEN @Champ = 'Bundesliga' THEN 34
								ELSE 38
							END);
							
SELECT Nom_Club AS Club, Round(Pred_V*@Nb_Match_par_saison) AS Prediction_V, ROUND(Pred_N*@Nb_Match_par_saison) AS Prediction_N, ROUND(Pred_D*@Nb_Match_par_saison) AS Prediction_D
FROM (
SELECT Nom_Club, 1/AVG(Cote_Victoire) AS Pred_V, 1/AVG(Cote_Nul) AS Pred_N, 1/AVG(Cote_Defaite) AS Pred_D
FROM
	(SELECT Nom_Club, Cote_Victoire, Cote_Nul, Cote_Defaite 
		FROM ((SELECT Renc_Id, Renc_Club_Nom_Domicile As Nom_Club, Cote_Domicile_B365 AS Cote_Victoire, Cote_Nul_B365 AS Cote_Nul, Cote_Exterieur_B365 AS Cote_Defaite FROM `Rencontre_a_plat` WHERE `Rencontre_a_plat`.Renc_Champ_Nom = @Champ AND `Rencontre_a_plat`.Renc_Saison_Annee_Debut = @Debut_Saison) 
			UNION
			(SELECT Renc_Id, Renc_Club_Nom_Domicile As Nom_Club, Cote_Domicile_BS AS Cote_Victoire, Cote_Nul_BS AS Cote_Nul, Cote_Exterieur_BS AS Cote_Defaite FROM `Rencontre_a_plat` WHERE `Rencontre_a_plat`.Renc_Champ_Nom = @Champ AND `Rencontre_a_plat`.Renc_Saison_Annee_Debut = @Debut_Saison)
			UNION
			(SELECT Renc_Id, Renc_Club_Nom_Domicile As Nom_Club, Cote_Domicile_BW AS Cote_Victoire, Cote_Nul_BW AS Cote_Nul, Cote_Exterieur_BW AS Cote_Defaite FROM `Rencontre_a_plat` WHERE `Rencontre_a_plat`.Renc_Champ_Nom = @Champ AND `Rencontre_a_plat`.Renc_Saison_Annee_Debut = @Debut_Saison) 
			UNION
			(SELECT Renc_Id, Renc_Club_Nom_Domicile As Nom_Club, Cote_Domicile_GB AS Cote_Victoire, Cote_Nul_GB AS Cote_Nul, Cote_Exterieur_GB AS Cote_Defaite FROM `Rencontre_a_plat` WHERE `Rencontre_a_plat`.Renc_Champ_Nom = @Champ AND `Rencontre_a_plat`.Renc_Saison_Annee_Debut = @Debut_Saison)
			UNION
			(SELECT Renc_Id, Renc_Club_Nom_Domicile As Nom_Club, Cote_Domicile_IW AS Cote_Victoire, Cote_Nul_IW AS Cote_Nul, Cote_Exterieur_IW AS Cote_Defaite FROM `Rencontre_a_plat` WHERE `Rencontre_a_plat`.Renc_Champ_Nom = @Champ AND `Rencontre_a_plat`.Renc_Saison_Annee_Debut = @Debut_Saison)
			UNION
			(SELECT Renc_Id, Renc_Club_Nom_Domicile As Nom_Club, Cote_Domicile_LB AS Cote_Victoire, Cote_Nul_LB AS Cote_Nul, Cote_Exterieur_LB AS Cote_Defaite FROM `Rencontre_a_plat` WHERE `Rencontre_a_plat`.Renc_Champ_Nom = @Champ AND `Rencontre_a_plat`.Renc_Saison_Annee_Debut = @Debut_Saison)
			UNION
			(SELECT Renc_Id, Renc_Club_Nom_Domicile As Nom_Club, Cote_Domicile_PS AS Cote_Victoire, Cote_Nul_PS AS Cote_Nul, Cote_Exterieur_PS AS Cote_Defaite FROM `Rencontre_a_plat` WHERE `Rencontre_a_plat`.Renc_Champ_Nom = @Champ AND `Rencontre_a_plat`.Renc_Saison_Annee_Debut = @Debut_Saison)
			UNION
			(SELECT Renc_Id, Renc_Club_Nom_Domicile As Nom_Club, Cote_Domicile_SB AS Cote_Victoire, Cote_Nul_SB AS Cote_Nul, Cote_Exterieur_SB AS Cote_Defaite FROM `Rencontre_a_plat` WHERE `Rencontre_a_plat`.Renc_Champ_Nom = @Champ AND `Rencontre_a_plat`.Renc_Saison_Annee_Debut = @Debut_Saison)
			UNION
			(SELECT Renc_Id, Renc_Club_Nom_Domicile As Nom_Club, Cote_Domicile_SJ AS Cote_Victoire, Cote_Nul_SJ AS Cote_Nul, Cote_Exterieur_SJ AS Cote_Defaite FROM `Rencontre_a_plat` WHERE `Rencontre_a_plat`.Renc_Champ_Nom = @Champ AND `Rencontre_a_plat`.Renc_Saison_Annee_Debut = @Debut_Saison)
			UNION
			(SELECT Renc_Id, Renc_Club_Nom_Domicile As Nom_Club, Cote_Domicile_VC AS Cote_Victoire, Cote_Nul_VC AS Cote_Nul, Cote_Exterieur_VC AS Cote_Defaite FROM `Rencontre_a_plat` WHERE `Rencontre_a_plat`.Renc_Champ_Nom = @Champ AND `Rencontre_a_plat`.Renc_Saison_Annee_Debut = @Debut_Saison)
			UNION
			(SELECT Renc_Id, Renc_Club_Nom_Domicile As Nom_Club, Cote_Domicile_WH AS Cote_Victoire, Cote_Nul_WH AS Cote_Nul, Cote_Exterieur_WH AS Cote_Defaite FROM `Rencontre_a_plat` WHERE `Rencontre_a_plat`.Renc_Champ_Nom = @Champ AND `Rencontre_a_plat`.Renc_Saison_Annee_Debut = @Debut_Saison)
		UNION 
			(SELECT Renc_Id, Renc_Club_Nom_Exterieur As Nom_Club, Cote_Exterieur_B365 AS Cote_Victoire, Cote_Nul_B365 AS Cote_Nul, Cote_Domicile_B365 AS Cote_Defaite FROM `Rencontre_a_plat` WHERE `Rencontre_a_plat`.Renc_Champ_Nom = @Champ AND `Rencontre_a_plat`.Renc_Saison_Annee_Debut = @Debut_Saison)
			UNION
			(SELECT Renc_Id, Renc_Club_Nom_Exterieur As Nom_Club, Cote_Exterieur_BS AS Cote_Victoire, Cote_Nul_BS AS Cote_Nul, Cote_Domicile_BS AS Cote_Defaite FROM `Rencontre_a_plat` WHERE `Rencontre_a_plat`.Renc_Champ_Nom = @Champ AND `Rencontre_a_plat`.Renc_Saison_Annee_Debut = @Debut_Saison)
			UNION
			(SELECT Renc_Id, Renc_Club_Nom_Exterieur As Nom_Club, Cote_Exterieur_BW AS Cote_Victoire, Cote_Nul_BW AS Cote_Nul, Cote_Domicile_BW AS Cote_Defaite FROM `Rencontre_a_plat` WHERE `Rencontre_a_plat`.Renc_Champ_Nom = @Champ AND `Rencontre_a_plat`.Renc_Saison_Annee_Debut = @Debut_Saison)
			UNION
			(SELECT Renc_Id, Renc_Club_Nom_Exterieur As Nom_Club, Cote_Exterieur_GB AS Cote_Victoire, Cote_Nul_GB AS Cote_Nul, Cote_Domicile_GB AS Cote_Defaite FROM `Rencontre_a_plat` WHERE `Rencontre_a_plat`.Renc_Champ_Nom = @Champ AND `Rencontre_a_plat`.Renc_Saison_Annee_Debut = @Debut_Saison)
			UNION
			(SELECT Renc_Id, Renc_Club_Nom_Exterieur As Nom_Club, Cote_Exterieur_IW AS Cote_Victoire, Cote_Nul_IW AS Cote_Nul, Cote_Domicile_IW AS Cote_Defaite FROM `Rencontre_a_plat` WHERE `Rencontre_a_plat`.Renc_Champ_Nom = @Champ AND `Rencontre_a_plat`.Renc_Saison_Annee_Debut = @Debut_Saison)
			UNION
			(SELECT Renc_Id, Renc_Club_Nom_Exterieur As Nom_Club, Cote_Exterieur_LB AS Cote_Victoire, Cote_Nul_LB AS Cote_Nul, Cote_Domicile_LB AS Cote_Defaite FROM `Rencontre_a_plat` WHERE `Rencontre_a_plat`.Renc_Champ_Nom = @Champ AND `Rencontre_a_plat`.Renc_Saison_Annee_Debut = @Debut_Saison)
			UNION
			(SELECT Renc_Id, Renc_Club_Nom_Exterieur As Nom_Club, Cote_Exterieur_PS AS Cote_Victoire, Cote_Nul_PS AS Cote_Nul, Cote_Domicile_PS AS Cote_Defaite FROM `Rencontre_a_plat` WHERE `Rencontre_a_plat`.Renc_Champ_Nom = @Champ AND `Rencontre_a_plat`.Renc_Saison_Annee_Debut = @Debut_Saison)
			UNION
			(SELECT Renc_Id, Renc_Club_Nom_Exterieur As Nom_Club, Cote_Exterieur_SB AS Cote_Victoire, Cote_Nul_SB AS Cote_Nul, Cote_Domicile_SB AS Cote_Defaite FROM `Rencontre_a_plat` WHERE `Rencontre_a_plat`.Renc_Champ_Nom = @Champ AND `Rencontre_a_plat`.Renc_Saison_Annee_Debut = @Debut_Saison)
			UNION
			(SELECT Renc_Id, Renc_Club_Nom_Exterieur As Nom_Club, Cote_Exterieur_SJ AS Cote_Victoire, Cote_Nul_SJ AS Cote_Nul, Cote_Domicile_SJ AS Cote_Defaite FROM `Rencontre_a_plat` WHERE `Rencontre_a_plat`.Renc_Champ_Nom = @Champ AND `Rencontre_a_plat`.Renc_Saison_Annee_Debut = @Debut_Saison)
			UNION
			(SELECT Renc_Id, Renc_Club_Nom_Exterieur As Nom_Club, Cote_Exterieur_VC AS Cote_Victoire, Cote_Nul_VC AS Cote_Nul, Cote_Domicile_VC AS Cote_Defaite FROM `Rencontre_a_plat` WHERE `Rencontre_a_plat`.Renc_Champ_Nom = @Champ AND `Rencontre_a_plat`.Renc_Saison_Annee_Debut = @Debut_Saison)
			UNION
			(SELECT Renc_Id, Renc_Club_Nom_Exterieur As Nom_Club, Cote_Exterieur_WH AS Cote_Victoire, Cote_Nul_WH AS Cote_Nul, Cote_Domicile_WH AS Cote_Defaite FROM `Rencontre_a_plat` WHERE `Rencontre_a_plat`.Renc_Champ_Nom = @Champ AND `Rencontre_a_plat`.Renc_Saison_Annee_Debut = @Debut_Saison)) AS Liste_Cotes) AS Moy_Cote
		GROUP BY Nom_Club) AS t