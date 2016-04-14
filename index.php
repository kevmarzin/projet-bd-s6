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
                echo "Erreur connexion BDD : " . $e->getMessage();
            }
            //$result=$pdo->query($query);
            
            /// SUPPRESSION DES TABLES ///
            /*try {
                $delete = "DELETE FROM ";

                $pdo->exec($delete . "Championnat;");
                $pdo->exec($delete . "Bookmaker;");
                $pdo->exec($delete . "Club;");
                $pdo->exec($delete . "Cote;");
                $pdo->exec($delete . "Saison;");
                $pdo->exec($delete . "Pays;");
                $pdo->exec($delete . "Rencontre;");
                
                echo "Tables vidées avec succès." . '<br>';
            }
            catch (PDOException $e) {
                echo "Erreur suppression des données : " . $e->getMessage() . '<br>';
            }*/
            
            /// REMPLISSAGE DES TABLES ///
            try {
                /// INSERT ///
                $statement_pays = "INSERT INTO Pays (Pays_Nom) VALUES (?)";
                $statement_champ = "INSERT INTO Championnat (Champ_Nom, Champ_Pays_Id) VALUES (?, ?);";
                $statement_club = "INSERT INTO Club (Club_Nom, Club_Champ_Id) VALUES (?, ?);";
                $statement_saison = "INSERT INTO Saison (Saison_Annee_Debut, Saison_Annee_Fin) VALUES (?, ?);";
                $statement_bookmaker = "INSERT INTO Bookmaker (Bookmaker_Nom) VALUES (?);";
                $statement_rencontre = "INSERT INTO Rencontre (Renc_Club_Id_Domicile, Renc_Club_Id_Exterieur, Renc_Saison_Id, "
                                                            . "Renc_Date, Renc_Buts_Exterieur, Renc_Buts_Domicile, Renc_Tirs_Exterieur, "
                                                            . "Renc_Tirs_Domicile, Renc_Tirs_Cadres_Exterieur, Renc_Tirs_Cadres_Domicile, "
                                                            . "Renc_Fautes_Exterieur, Renc_Fautes_Domicile, Renc_Corners_Exterieur, "
                                                            . "Renc_Corners_Domicile, Renc_Cartons_Jaune_Exterieur, Renc_Cartons_Jaune_Domicile, "
                                                            . "Renc_Cartons_Rouge_Exterieur, Renc_Cartons_Rouge_Domicile) "
                                                            . "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";
                
                
                $pays = array("England", "France", "Germany", "Italy", "Spain");
                $champ = array("Premier League", "Ligue 1", "Bundesliga", "Serie A", "Liga");
                $i = 0;
                foreach ($pays as $p) {
                    $query_ajout_pays = $pdo->prepare($statement_pays);
                    $query_ajout_pays->execute(array($p));
                    $id_pays = $pdo->lastInsertId();

                    $query_ajout_champ= $pdo->prepare($statement_champ);
                    $query_ajout_champ->execute(array($champ[$i], $id_pays));
                    $id_champ_pays = $pdo->lastInsertId();
                    $i++;
                    
                }
                
                $row = 2;
                if (($handle = fopen("src/England/0.csv", "r")) !== FALSE) {
                    while (($data = fgetcsv($handle, ",")) !== FALSE) {
                        $row++;
                        $home_team = $data[2];
                        $away_team = $data[3];
                        $query_england_club = $pdo->prepare($statement_club);
                        $query_england_club->execute($home_team, $england_champ_id);
                        $home_team_id = $pdo->lastInsertId();
                        $query_england_club->execute($away_team, $england_champ_id);
                        $away_team_id = $pdo->lastInsertId();
                        
                    }
                    fclose($handle);
                }
            }
            catch (PDOException $e) {
                echo $e->getMessage();
            }
            
            /// SELECT ///
            /*$res = $pdo->query();
            while ($donnees = $res->fetch()) {
                echo $donnees['NOM_CHAMP'];
            }*/
            
            $pdo=null;
        }
        ?>
        <form method="post" action="">
            <input type="submit" name="Envoyer" value="Exécuter le script" />
        </form>
    </body>
</html>