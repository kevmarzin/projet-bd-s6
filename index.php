<html>
    <head>
        <meta charset="UTF-8">
        <title>Projet BD</title>
    </head>
    <body>
        <?php
        if(!empty($_POST['Envoyer'])) { // Si le formulaire est envoyé.
            // Préparation des requêtes
            $statement_pays = "INSERT INTO `Pays` (Pays_Nom) VALUES (?)";
            $statement_champ = "INSERT INTO `Championnat` (Champ_Nom, Champ_Pays_Id) VALUES (?, ?);";
            $statement_club = "INSERT INTO `Club` (Club_Nom, Club_Champ_Id) VALUES (?, ?);";
            $statement_saison = "INSERT INTO `Saison` (Saison_Annee_Debut, Saison_Annee_Fin) VALUES (?, ?);";
            $statement_bookmaker = "INSERT INTO `Bookmaker` (Bookmaker_Nom) VALUES (?);";
            $statement_rencontre = "INSERT INTO `Rencontre` (Renc_Club_Id_Domicile, Renc_Club_Id_Exterieur, Renc_Saison_Id, "
                                                        . "Renc_Date, Renc_Buts_Exterieur, Renc_Buts_Domicile, Renc_Tirs_Exterieur, "
                                                        . "Renc_Tirs_Domicile, Renc_Tirs_Cadres_Exterieur, Renc_Tirs_Cadres_Domicile, "
                                                        . "Renc_Fautes_Exterieur, Renc_Fautes_Domicile, Renc_Corners_Exterieur, "
                                                        . "Renc_Corners_Domicile, Renc_Cartons_Jaune_Exterieur, Renc_Cartons_Jaune_Domicile, "
                                                        . "Renc_Cartons_Rouge_Exterieur, Renc_Cartons_Rouge_Domicile) "
                                                        . "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";
            $statement_cote = "INSERT INTO `Cote` (Cote_Renc_Id, Cote_Bookmaker_Id, Cote_Domicile, Cote_Nul, Cote_Exterieur) "
                                . "VALUES (?, ?, ?, ?, ?);";
            $statement_select_id_club = "SELECT Club_Id FROM Club WHERE Club_Nom = ";


            $pays = array("England", "France", "Germany", "Italy", "Spain");
            $champ = array("Premier League", "Ligue 1", "Bundesliga", "Serie A", "Liga");
            $bookmakers = array("B365" => array (NULL, NULL), 
                                "BS"   => array (NULL, NULL),
                                "BW"   => array (NULL, NULL),
                                "GB"   => array (NULL, NULL),
                                "IW"   => array (NULL, NULL),
                                "LB"   => array (NULL, NULL),
                                "PS"   => array (NULL, NULL),
                                "SO"   => array (NULL, NULL),
                                "SB"   => array (NULL, NULL),
                                "SJ"   => array (NULL, NULL),
                                "SY"   => array (NULL, NULL),
                                "VC"   => array (NULL, NULL),
                                "WH"   => array (NULL, NULL));
            $clubs = array ();
            
            try {
                /// CONECTION A LA BASE ///
                $pdo = new PDO("mysql:host=dbserver;dbname=adrbounader", "adrbounader", "girondin33");
                
                /// ON VIDE LES TABLES ///
                $delete = "DELETE FROM ";
                $pdo->exec($delete . "`Championnat`;");
                $pdo->exec($delete . "`Bookmaker`;");
                $pdo->exec($delete . "`Club`;");
                $pdo->exec($delete . "`Cote`;");
                $pdo->exec($delete . "`Saison`;");
                $pdo->exec($delete . "`Pays`;");
                $pdo->exec($delete . "`Rencontre`;");

                echo "Tables vidées avec succès." . '<br>';
                
                /// ON INSERE LES SAISONS ///
                $saisons_id_sql = array();
                $query_ajout_saison = $pdo->prepare($statement_saison);
                for ($saison = 2005; $saison < 2015; $saison++) {
                    $query_ajout_saison->execute(array($saison, $saison + 1));
                    array_push($saisons_id_sql, $pdo->lastInsertId());
                }
                
                /// INSERTION RENCONTRE + COTE ///
                for ($id_pays = 0; $id_pays < count ($pays); $id_pays++) {
                    // Ajout du pays
                    $query_ajout_pays = $pdo->prepare($statement_pays);
                    $query_ajout_pays->execute(array($pays [$id_pays]));
                    $id_pays_sql = $pdo->lastInsertId();
                    echo $pays [$id_pays] ." / ";

                    // Ajout du championnat
                    $query_ajout_champ= $pdo->prepare($statement_champ);
                    $query_ajout_champ->execute(array($champ[$id_pays], $id_pays_sql));
                    $id_champ_sql = $pdo->lastInsertId();
                    echo $champ[$id_pays] . " ajoutés<br/>";
                    
                    $dossier = "src/" . $pays [$id_pays] . "/";
                    // Parcours des saisons
                    for ($id_saison = 0; $id_saison < 10; $id_saison++) {
                        echo $dossier . $id_saison . ".csv<br/>";
                        if (($handle = fopen($dossier . $id_saison . ".csv", "r")) !== FALSE) {
                            $id_column_date = $id_column_home_team = $id_column_away_team = $id_column_fthg = $id_column_ftag
                                            = $id_column_hs = $id_column_as = $id_column_hst = $id_column_ast = $id_column_hc
                                            = $id_column_ac = $id_column_hf = $id_column_af = $id_column_hy = $id_column_ay
                                            = $id_column_hr = $id_column_ar = NULL;
                            $row = 0;
                            foreach ($bookmakers as $b => $ids_bookmaker) {
                                $ids_bookmaker[0] = NULL;
                            }
                            while (($data = fgetcsv($handle)) !== FALSE) {
                                if ($row == 0){
                                    echo "nb colonnes : " . count ($data)."<br/>";
                                    for ($column = 0; $column < count ($data); $column++){
                                        switch ($data[$column]){
                                            case "Date": $id_column_date = $column; break;
                                            case "HomeTeam": $id_column_home_team = $column; break;
                                            case "AwayTeam": $id_column_away_team = $column; break;
                                            case "FTHG": $id_column_fthg = $column; break;
                                            case "FTAG": $id_column_ftag = $column; break;
                                            case "HS": $id_column_hs = $column; break;
                                            case "AS": $id_column_as = $column; break;
                                            case "HST": $id_column_hst = $column; break;
                                            case "AST": $id_column_ast = $column; break;
                                            case "HC": $id_column_hc = $column; break;
                                            case "AC": $id_column_ac = $column; break;
                                            case "HF": $id_column_hf = $column; break;
                                            case "AF": $id_column_af = $column; break;
                                            case "HY": $id_column_hy = $column; break;
                                            case "AY": $id_column_ay = $column; break;
                                            case "HR": $id_column_hr = $column; break;
                                            case "AR": $id_column_ar = $column; break;
                                            case "B365H":
                                            case "BSH":
                                            case "BWH":
                                            case "GBH":
                                            case "IWH":
                                            case "LBH":
                                            case "PSH":
                                            case "SOH":
                                            case "SBH":
                                            case "SJH":
                                            case "SYH":
                                            case "VCH":
                                            case "WHH":
                                                $nom_bookmaker = substr($data[$column], 0, strlen ($data[$column])-1);
                                                $bookmakers[$nom_bookmaker][0] = $column;
                                                if ($bookmakers[$nom_bookmaker][1] == NULL){
                                                    $query_ajout_bookmaker = $pdo->prepare($statement_bookmaker);
                                                    $query_ajout_bookmaker->execute(array($nom_bookmaker));
                                                    $bookmakers[$nom_bookmaker][1] = $pdo->lastInsertId();
                                                }
                                                break;
                                            default: break;
                                        }
                                    }
                                    echo "<br/>premiere ligne passée<br/>";
                                }
                                else {
                                    // On insère le club à domicile s'il n'a pas déjà été transféré et on récupère son ID
                                    if ( !array_key_exists($data[$id_column_home_team], $club)) {
                                        $query_club = $pdo->prepare($statement_club);
                                        $query_club->execute(array($data[$id_column_home_team], $id_champ_sql));
                                        $clubs[$data[$id_column_home_team]] = $pdo->lastInsertId();
                                    }
                                    //Idem pour le club à l'extérieur
                                    if (!array_key_exists($data[$id_column_away_team], $club)) {
                                        $query_club = $pdo->prepare($statement_club);
                                        $query_club->execute(array($data[$id_column_away_team], $id_champ_sql));
                                        $clubs[$data[$id_column_away_team]] = $pdo->lastInsertId();
                                    }
                                    
                                    $query_ajout_rencontre = $pdo->prepare($statement_rencontre);
                                    $query_ajout_rencontre->execute(array(  $clubs[$data[$id_column_home_team]],
                                                                            $clubs[$data[$id_column_away_team]],
                                                                            $saisons_id_sql[$id_saison], 
                                                                            $id_column_date != NULL ? $data[$id_column_date] : NULL,
                                                                            $id_column_ftag != NULL ? $data[$id_column_ftag] : NULL,
                                                                            $id_column_fthg != NULL ? $data[$id_column_fthg] : NULL,
                                                                            $id_column_as   != NULL ? $data[$id_column_as]   : NULL,
                                                                            $id_column_hs   != NULL ? $data[$id_column_hs]   : NULL,
                                                                            $id_column_ast  != NULL ? $data[$id_column_ast]  : NULL,
                                                                            $id_column_hst  != NULL ? $data[$id_column_hst]  : NULL,
                                                                            $id_column_af   != NULL ? $data[$id_column_af]   : NULL,
                                                                            $id_column_hf   != NULL ? $data[$id_column_hf]   : NULL,
                                                                            $id_column_ac   != NULL ? $data[$id_column_ac]   : NULL,
                                                                            $id_column_hc   != NULL ? $data[$id_column_hc]   : NULL,
                                                                            $id_column_ay   != NULL ? $data[$id_column_ay]   : NULL,
                                                                            $id_column_hy   != NULL ? $data[$id_column_hy]   : NULL,
                                                                            $id_column_ar   != NULL ? $data[$id_column_ar]   : NULL,
                                                                            $id_column_hr   != NULL ? $data[$id_column_hr]   : NULL));
                                    $id_rencontre = $pdo->lastInsertId();
                                    $query_ajout_cote = $pdo->prepare($statement_cote);
                                    foreach ($bookmakers as $b => $ids_bookmaker) {
                                        if ($ids_bookmaker[0] != NULL){
                                            $cote_dom = $data[$ids_bookmaker[0]];
                                            $cote_nul = $data[$ids_bookmaker[0] + 1];
                                            $cote_ext = $data[$ids_bookmaker[0] + 2];
                                            $query_ajout_cote->execute(array($id_rencontre, $ids_bookmaker[1], $cote_dom, $cote_nul, $cote_ext));
                                        }
                                    }
                                }
                                $row++;
                            }
                            echo "Saison " . $id_saison . " : " . $row . " lignes ajoutees<br/>";
                            fclose($handle);
                        }
                    }
                }
                $pdo=null;
            }
            catch (PDOException $e) {
                echo "Erreur : " . $e->getMessage() . "<br/>";
            }
        } 
        else {
        ?>
            <form method="post" action="">
                <input type="submit" name="Envoyer" value="Exécuter le script" />
            </form>
        <?php } ?>
    </body>
</html>