<html>
    <head>
        <meta charset="UTF-8">
        <title>Projet BD</title>
    </head>
    <body>
        <?php
        if(!empty($_POST['Envoyer'])) // Si le formulaire est envoyé.          
        {  
            try {
                $pdo = new PDO("mysql:host=dbserver;dbname=adrbounader", "adrbounader", "girondin33");
            }
            catch (Exception $e) {
                die("Erreur : " . $e->getMessage());
            }
            //$result=$pdo->query($query);
            
            /// SUPPRESSION DES TABLES ///
            $sql_drop = "DROP TABLE Championnat, Bookmaker, Club, Cote, Pays, Rencontre, Saison;";
            
            $query = $pdo->prepare($sql_drop);
            $query->execute();
            
            /// CREATION DES TABLES ET DES CONTRAINTES ///
            try {
                $table_pays = "CREATE TABLE Pays ("
                               . "Pays_Id INT NOT NULL AUTO_INCREMENT,"
                               . "Pays_Nom VARCHAR(20) NOT NULL,"
                               . "PRIMARY KEY (Pays_Id)"
                               . ");";
                $pdo->exec($table_pays);

                $table_champ = "CREATE TABLE Championnat ("
                               . "Champ_Id INT NOT NULL AUTO_INCREMENT,"
                               . "Champ_Nom VARCHAR(20) NOT NULL,"
                               . "Champ_Pays_Id INT NOT NULL,"
                               . "PRIMARY KEY (Champ_Id),"
                               . "FOREIGN KEY (Champ_Pays_Id) REFERENCES Pays(Pays_Id));";
                $pdo->exec($table_champ);

                $table_saison = "CREATE TABLE Saison ("
                                . "Saison_Id INT NOT NULL AUTO_INCREMENT,"
                                . "Saison_Annee_Debut YEAR,"
                                . "Saison_Annee_Fin YEAR,"
                                . "PRIMARY KEY (Saison_Id));";
                $pdo->exec($table_saison);

                $table_club = "CREATE TABLE Club ("
                            . "Club_Id INT NOT NULL AUTO_INCREMENT,"
                            . "Club_Nom VARCHAR(20) NOT NULL,"
                            . "Club_Champ_Id INT NOT NULL,"
                            . "PRIMARY KEY (Club_Id),"
                            . "FOREIGN KEY (Club_Champ_Id) REFERENCES Championnat(Club_Champ_Id));";
                $pdo->exec($table_club);

                $table_rencontre = "CREATE TABLE Rencontre ("
                            . "Renc_Id INT NOT NULL AUTO_INCREMENT,"
                            . "Renc_Club_Id_Domicile INT NOT NULL,"
                            . "Renc_Club_Id_Exterieur INT NOT NULL,"
                            . "Renc_Saison_Id INT NOT NULL,"
                            . "Renc_Date DATE,"
                            . "Renc_Buts_Exterieur INT UNSIGNED DEFAULT 0,"
                            . "Renc_Buts_Domicile INT UNSIGNED DEFAULT 0,"
                            . "Renc_Tirs_Exterieur INT UNSIGNED DEFAULT 0,"
                            . "Renc_Tirs_Domicile INT UNSIGNED DEFAULT 0,"
                            . "Renc_Tirs_Cadres_Exterieur INT UNSIGNED DEFAULT 0,"
                            . "Renc_Tirs_Cadres_Domicile INT UNSIGNED DEFAULT 0,"
                            . "Renc_Fautes_Exterieur INT UNSIGNED DEFAULT 0,"
                            . "Renc_Fautes_Domicile INT UNSIGNED DEFAULT 0,"
                            . "Renc_Corners_Exterieur INT UNSIGNED DEFAULT 0,"
                            . "Renc_Corners_Domicile INT UNSIGNED DEFAULT 0,"
                            . "Renc_Cartons_Jaune_Exterieur INT UNSIGNED DEFAULT 0,"
                            . "Renc_Cartons_Jaune_Domicile INT UNSIGNED DEFAULT 0,"
                            . "Renc_Cartons_Rouge_Exterieur INT UNSIGNED DEFAULT 0,"
                            . "Renc_Cartons_Rouge_Domicile INT UNSIGNED DEFAULT 0,"
                            . "PRIMARY KEY (Renc_Id),"
                            . "FOREIGN KEY (Renc_Saison_Id) REFERENCES Saison(Saison_Id),"
                            . "FOREIGN KEY (Renc_Club_Id_Domicile) REFERENCES Club(Club_Id),"
                            . "FOREIGN KEY (Renc_Club_Id_Exterieur) REFERENCES Club(Club_Id));";
                $pdo->exec($table_rencontre);

                $table_bookmaker = "CREATE TABLE Bookmaker ("
                            . "Bookmaker_Id INT NOT NULL AUTO_INCREMENT,"
                            . "Bookmaker_Nom VARCHAR(20) NOT NULL,"
                            . "PRIMARY KEY (Bookmaker_Id));";
                $pdo->exec($table_bookmaker);

                $table_cote = "CREATE TABLE Cote ("
                            . "Cote_Renc_Id INT NOT NULL,"
                            . "Cote_Bookmaker_Id INT NOT NULL,"
                            . "Cote_Domicile FLOAT UNSIGNED,"
                            . "Cote_Nul FLOAT UNSIGNED,"
                            . "Cote_Exterieur FLOAT UNSIGNED,"
                            . "FOREIGN KEY (Cote_Renc_Id) REFERENCES Rencontre(Renc_Id),"
                            . "FOREIGN KEY (Cote_Bookmaker_Id) REFERENCES Rencontre(Bookmaker_Id),"
                            . "PRIMARY KEY (Cote_Renc_Id, Cote_Bookmaker_Id));";
                $pdo->exec($table_cote);
                
                echo 'Tables créées avec succès.';
            }
            catch (PDOException $e) {
                echo $e->getMessage();
            }
            
            /// SELECT ///
            /*$res = $pdo->query();
            while ($donnees = $res->fetch()) {
                echo $donnees['NOM_CHAMP'];
            } */
            
            /// INSERT ///
            /*$statement = 'INSERT INTO ...';
            $query = $pdo->prepare($statement);
            $query->execute(array('nom_champ_1' => $nom_champ_1, ''));*/
            
            $pdo=null;
        }
        ?>
        <form method="post" action="">
            <input type="submit" name="Envoyer" value="Exécuter le script" />
        </form>
    </body>
</html>