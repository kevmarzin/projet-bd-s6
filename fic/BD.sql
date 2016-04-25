CREATE TABLE Pays (
	Pays_Id INT NOT NULL AUTO_INCREMENT,
	Pays_Nom VARCHAR(20) NOT NULL,
	
	PRIMARY KEY (Pays_Id)
);

CREATE TABLE Championnat (
	Champ_Id INT NOT NULL AUTO_INCREMENT,
	Champ_Nom VARCHAR(20) NOT NULL,
	Champ_Pays_Id INT NOT NULL,
	
	PRIMARY KEY (Champ_Id),
	FOREIGN KEY (Champ_Pays_Id) REFERENCES Pays(Pays_Id)
);

CREATE TABLE Saison (
	Saison_Id INT NOT NULL AUTO_INCREMENT,
	Saison_Annee_Debut YEAR,
	Saison_Annee_Fin YEAR,
	
	PRIMARY KEY (Saison_Id)
);

CREATE TABLE Club (
	Club_Id INT NOT NULL AUTO_INCREMENT,
	Club_Nom VARCHAR(20) NOT NULL UNIQUE,
	Club_Champ_Id INT NOT NULL,
	
	PRIMARY KEY (Club_Id),
	FOREIGN KEY (Club_Champ_Id) REFERENCES Championnat(Club_Champ_Id)
);

CREATE TABLE Rencontre (
	Renc_Id INT NOT NULL AUTO_INCREMENT,
	Renc_Club_Id_Domicile INT NOT NULL,
	Renc_Club_Id_Exterieur INT NOT NULL,
	Renc_Saison_Id INT NOT NULL,
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
	
	PRIMARY KEY (Renc_Id),
	FOREIGN KEY (Renc_Saison_Id) REFERENCES Saison(Saison_Id),
	FOREIGN KEY (Renc_Club_Id_Domicile) REFERENCES Club(Club_Id),
	FOREIGN KEY (Renc_Club_Id_Exterieur) REFERENCES Club(Club_Id)
);

CREATE TABLE Bookmaker (
	Bookmaker_Id INT NOT NULL AUTO_INCREMENT,
	Bookmaker_Nom VARCHAR(20) NOT NULL,
	
	PRIMARY KEY (Bookmaker_Id)
);

CREATE TABLE Cote (
	Cote_Renc_Id INT NOT NULL,
	Cote_Bookmaker_Id INT NOT NULL,
	
	Cote_Domicile FLOAT UNSIGNED,
	Cote_Nul FLOAT UNSIGNED,
	Cote_Exterieur FLOAT UNSIGNED,
	
	FOREIGN KEY (Cote_Renc_Id) REFERENCES Rencontre(Renc_Id),
	FOREIGN KEY (Cote_Bookmaker_Id) REFERENCES Rencontre(Bookmaker_Id),
	PRIMARY KEY (Cote_Renc_Id, Cote_Bookmaker_Id)
);
