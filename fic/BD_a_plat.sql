CREATE TABLE Rencontre_a_plat (
	Renc_Id INT NOT NULL AUTO_INCREMENT,
	Renc_Champ_Nom VARCHAR(20) NOT NULL,
	Pays_Nom VARCHAR(20) NOT NULL,
	Renc_Club_Nom_Domicile VARCHAR(20) NOT NULL,
	Renc_Club_Nom_Exterieur VARCHAR(20) NOT NULL,
	Renc_Saison_Annee_Debut YEAR,
	Renc_Saison_Annee_Fin YEAR,
	Renc_Date DATE,

	Renc_Buts_Exterieur INT UNSIGNED DEFAULT 0,
	Renc_Buts_Domicile INT UNSIGNED DEFAULT 0,
	Renc_Tirs_Exterieur INT UNSIGNED DEFAULT 0,
	Renc_Tirs_Domicile INT UNSIGNED DEFAULT 0,
	Renc_Tirs_Cadres_Exterieur INT UNSIGNED DEFAULT 0,
	Renc_Tirs_Cadres_Domicile INT UNSIGNED DEFAULT 0,
	Renc_Fautes_Exterieur INT UNSIGNED DEFAULT 0,
	Renc_Fautes_Domicile INT UNSIGNED DEFAULT 0,
	Renc_Corners_Exterieur INT UNSIGNED DEFAULT 0,
	Renc_Corners_Domicile INT UNSIGNED DEFAULT 0,
	Renc_Cartons_Jaune_Exterieur INT UNSIGNED DEFAULT 0,
	Renc_Cartons_Jaune_Domicile INT UNSIGNED DEFAULT 0,
	Renc_Cartons_Rouge_Exterieur INT UNSIGNED DEFAULT 0,
	Renc_Cartons_Rouge_Domicile INT UNSIGNED DEFAULT 0,
	
	Cote_Domicile_B365 FLOAT UNSIGNED,
	Cote_Nul_B365 FLOAT UNSIGNED,
	Cote_Exterieur_B365 FLOAT UNSIGNED,
	
	Cote_Domicile_BS FLOAT UNSIGNED,
	Cote_Nul_BS FLOAT UNSIGNED,
	Cote_Exterieur_BS FLOAT UNSIGNED,
	
	Cote_Domicile_BW FLOAT UNSIGNED,
	Cote_Nul_BW FLOAT UNSIGNED,
	Cote_Exterieur_BW FLOAT UNSIGNED,
	
	Cote_Domicile_GB FLOAT UNSIGNED,
	Cote_Nul_GB FLOAT UNSIGNED,
	Cote_Exterieur_GB FLOAT UNSIGNED,
	
	Cote_Domicile_IW FLOAT UNSIGNED,
	Cote_Nul_IW FLOAT UNSIGNED,
	Cote_Exterieur_IW FLOAT UNSIGNED,
	
	Cote_Domicile_LB FLOAT UNSIGNED,
	Cote_Nul_LB FLOAT UNSIGNED,
	Cote_Exterieur_LB FLOAT UNSIGNED,
	
	Cote_Domicile_PS FLOAT UNSIGNED,
	Cote_Nul_PS FLOAT UNSIGNED,
	Cote_Exterieur_PS FLOAT UNSIGNED,
	
	Cote_Domicile_SB FLOAT UNSIGNED,
	Cote_Nul_SB FLOAT UNSIGNED,
	Cote_Exterieur_SB FLOAT UNSIGNED,
	 	
	Cote_Domicile_SJ FLOAT UNSIGNED,
	Cote_Nul_SJ FLOAT UNSIGNED,
	Cote_Exterieur_SJ FLOAT UNSIGNED,
	
	Cote_Domicile_VC FLOAT UNSIGNED,
	Cote_Nul_VC FLOAT UNSIGNED,
	Cote_Exterieur_VC FLOAT UNSIGNED,
	 	
	Cote_Domicile_WH FLOAT UNSIGNED,
	Cote_Nul_WH FLOAT UNSIGNED,
	Cote_Exterieur_WH FLOAT UNSIGNED,	
		
 	PRIMARY KEY (Renc_Id),
);
