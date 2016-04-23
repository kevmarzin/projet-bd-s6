<html>
    <head>
        <meta charset="UTF-8">
        <title>Projet BD</title>
    </head>
    <body>
        <?php
        if(isset ($_POST)){
            if (!empty($_POST['alim_bd']) ) { // Si le formulaire est envoyé.
                if (!empty($_POST['pass']) && $_POST['pass'] == 'projetbd') {
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
                                        "SJ"   => array (NULL, NULL),
                                        "VC"   => array (NULL, NULL),
                                        "WH"   => array (NULL, NULL));
                    $clubs = array ();

                    try {
                        /// CONECTION A LA BASE ///
                        $pdo = new PDO("mysql:host=dbserver;dbname=adrbounader", "adrbounader", "girondin33");

                        /// ON VIDE LES TABLES ///
                        $delete = "TRUNCATE ";
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

                            // Ajout du championnat
                            $query_ajout_champ= $pdo->prepare($statement_champ);
                            $query_ajout_champ->execute(array($champ[$id_pays], $id_pays_sql));
                            $id_champ_sql = $pdo->lastInsertId();

                            $dossier = "src/" . $pays [$id_pays] . "/";
                            // Parcours des saisons
                            for ($id_saison = 0; $id_saison < 10; $id_saison++) {
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
                                                    case "SBH":
                                                    case "SJH":
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
                                        }
                                        else {
                                            // On insère le club à domicile s'il n'a pas déjà été ajouté et on récupère son ID
                                            if ( !array_key_exists($data[$id_column_home_team], $clubs)) {
                                                $query_club = $pdo->prepare($statement_club);
                                                $query_club->execute(array($data[$id_column_home_team], $id_champ_sql));
                                                $clubs[$data[$id_column_home_team]] = $pdo->lastInsertId();
                                            }
                                            //Idem pour le club à l'extérieur
                                            if (!array_key_exists($data[$id_column_away_team], $clubs)) {
                                                $query_club = $pdo->prepare($statement_club);
                                                $query_club->execute(array($data[$id_column_away_team], $id_champ_sql));
                                                $clubs[$data[$id_column_away_team]] = $pdo->lastInsertId();
                                            }

                                            // Requête d'ajout de la rencontre
                                            $query_ajout_rencontre = $pdo->prepare($statement_rencontre);
                                            $date_rencontre = DateTime::createFromFormat('d/m/y', $data[$id_column_date]);
                                            $query_ajout_rencontre->execute(array(  $clubs[$data[$id_column_home_team]],
                                                                                    $clubs[$data[$id_column_away_team]],
                                                                                    $saisons_id_sql[$id_saison], 
                                                                                    $id_column_date != NULL ? $date_rencontre->format('Y-m-d') : NULL,
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
                        echo "BD alimentée !<br/>";
                        $pdo=null;
                    }
                    catch (PDOException $e) {
                        echo "Erreur : " . $e->getMessage() . "<br/>";
                    }
                }
                else echo "mauvais mdp 1";
            }
            else if (!empty($_POST['alim_bd_plat'])){
                if (!empty($_POST['pass']) && $_POST['pass'] == 'projetbd'){
                    $statement_rencontre = "INSERT INTO `Rencontre_a_plat` (Renc_Champ_Nom, Renc_Pays_Nom, "
                                                                         . "Renc_Club_Nom_Domicile, Renc_Club_Nom_Exterieur, "
                                                                         . "Renc_Saison_Annee_Debut, Renc_Saison_Annee_Fin, "
                                                                         . "Renc_Date, Renc_Buts_Exterieur, Renc_Buts_Domicile, Renc_Tirs_Exterieur, "
                                                                         . "Renc_Tirs_Domicile, Renc_Tirs_Cadres_Exterieur, Renc_Tirs_Cadres_Domicile, "
                                                                         . "Renc_Fautes_Exterieur, Renc_Fautes_Domicile, Renc_Corners_Exterieur, "
                                                                         . "Renc_Corners_Domicile, Renc_Cartons_Jaune_Exterieur, Renc_Cartons_Jaune_Domicile, "
                                                                         . "Renc_Cartons_Rouge_Exterieur, Renc_Cartons_Rouge_Domicile, "
                                                                         . "Cote_Domicile_B365, Cote_Nul_B365, Cote_Exterieur_B365, "
                                                                         . "Cote_Domicile_BS, Cote_Nul_BS, Cote_Exterieur_BS, "
                                                                         . "Cote_Domicile_BW, Cote_Nul_BW, Cote_Exterieur_BW, "
                                                                         . "Cote_Domicile_GB, Cote_Nul_GB, Cote_Exterieur_GB, "
                                                                         . "Cote_Domicile_IW, Cote_Nul_IW, Cote_Exterieur_IW, "
                                                                         . "Cote_Domicile_LB, Cote_Nul_LB, Cote_Exterieur_LB, "
                                                                         . "Cote_Domicile_PS, Cote_Nul_PS, Cote_Exterieur_PS, "
                                                                         . "Cote_Domicile_SB, Cote_Nul_SB, Cote_Exterieur_SB, "
                                                                         . "Cote_Domicile_SJ, Cote_Nul_SJ, Cote_Exterieur_SJ, "
                                                                         . "Cote_Domicile_VC, Cote_Nul_VC, Cote_Exterieur_VC, "
                                                                         . "Cote_Domicile_WH, Cote_Nul_WH, Cote_Exterieur_WH) "
                                                                         . "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "
                                                                                 . "?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "
                                                                                 . "?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";
                    $pays = array("England", "France", "Germany", "Italy", "Spain");
                    $champ = array("Premier League", "Ligue 1", "Bundesliga", "Serie A", "Liga");
                    $bookmakers = array("B365" => NULL,
                                        "BS"   => NULL,
                                        "BW"   => NULL,
                                        "GB"   => NULL,
                                        "IW"   => NULL,
                                        "LB"   => NULL,
                                        "PS"   => NULL,
                                        "SO"   => NULL,
                                        "SJ"   => NULL,
                                        "VC"   => NULL,
                                        "WH"   => NULL);
                    try {
                        /// CONECTION A LA BASE ///
                        $pdo = new PDO("mysql:host=dbserver;dbname=adrbounader", "adrbounader", "girondin33");

                        /// ON VIDE LA TABLES ///
                        $pdo->exec("TRUNCATE `Rencontre_a_plat`;");
                        
                        $cpt = 0;
                        $saisons = array ();
                        for ($annee_debut = 2005; $annee_debut < 2015; $annee_debut++) {
                            $saisons[$cpt] = array ($annee_debut, $annee_debut + 1);
                        }

                        /// INSERTION RENCONTRE + COTE ///
                        for ($id_pays = 0; $id_pays < count ($pays); $id_pays++) {
                            $dossier = "src/" . $pays [$id_pays] . "/";
                            // Parcours des saisons
                            for ($id_saison = 0; $id_saison < 10; $id_saison++) {
                                if (($handle = fopen($dossier . $id_saison . ".csv", "r")) !== FALSE) {
                                    $id_column_date = $id_column_home_team = $id_column_away_team = $id_column_fthg = $id_column_ftag
                                                    = $id_column_hs = $id_column_as = $id_column_hst = $id_column_ast = $id_column_hc
                                                    = $id_column_ac = $id_column_hf = $id_column_af = $id_column_hy = $id_column_ay
                                                    = $id_column_hr = $id_column_ar = NULL;
                                    $row = 0;
                                    foreach ($bookmakers as $b => $id_bookmaker) {
                                        $id_bookmaker = NULL;
                                    }
                                    while (($data = fgetcsv($handle)) !== FALSE) {
                                        if ($row == 0){
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
                                                    case "SBH":
                                                    case "SJH":
                                                    case "VCH":
                                                    case "WHH":
                                                        $nom_bookmaker = substr($data[$column], 0, strlen ($data[$column])-1);
                                                        $bookmakers[$nom_bookmaker] = $column;
                                                        break;
                                                    default: break;
                                                }
                                            }
                                        }
                                        else {
                                            // Requête d'ajout de la rencontre
                                            $date_rencontre = DateTime::createFromFormat('d/m/y', $data[$id_column_date]);
                                            $query_ajout_rencontre = $pdo->prepare($statement_rencontre);
                                            $query_ajout_rencontre->execute(array(  $champ[$id_pays],
                                                                                    $pays[$id_pays],
                                                                                    $data[$id_column_home_team],
                                                                                    $data[$id_column_away_team],
                                                                                    $saisons[$id_saison][0],
                                                                                    $saisons[$id_saison][1],
                                                                                    $id_column_date != NULL ? $date_rencontre->format('Y-m-d') : NULL,
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
                                                                                    $id_column_hr   != NULL ? $data[$id_column_hr]   : NULL,
                                                                                    $boomakers["B365"] != NULL ? $data[$boomakers["B365"]] : NULL,
                                                                                    $boomakers["B365"] != NULL ? $data[$boomakers["B365"]+1] : NULL,
                                                                                    $boomakers["B365"] != NULL ? $data[$boomakers["B365"]+2] : NULL,
                                                                                    $boomakers["BS"]   != NULL ? $data[$boomakers["BS"]] : NULL,
                                                                                    $boomakers["BS"]   != NULL ? $data[$boomakers["BS"]+1] : NULL,
                                                                                    $boomakers["BS"]   != NULL ? $data[$boomakers["BS"]+2] : NULL,
                                                                                    $boomakers["BW"]   != NULL ? $data[$boomakers["BW"]] : NULL,
                                                                                    $boomakers["BW"]   != NULL ? $data[$boomakers["BW"]+1] : NULL,
                                                                                    $boomakers["BW"]   != NULL ? $data[$boomakers["BW"]+2] : NULL,
                                                                                    $boomakers["GB"]   != NULL ? $data[$boomakers["GB"]] : NULL,
                                                                                    $boomakers["GB"]   != NULL ? $data[$boomakers["GB"]+1] : NULL,
                                                                                    $boomakers["GB"]   != NULL ? $data[$boomakers["GB"]+2] : NULL,
                                                                                    $boomakers["IW"]   != NULL ? $data[$boomakers["IW"]] : NULL,
                                                                                    $boomakers["IW"]   != NULL ? $data[$boomakers["IW"]+1] : NULL,
                                                                                    $boomakers["IW"]   != NULL ? $data[$boomakers["IW"]+2] : NULL,
                                                                                    $boomakers["LB"]   != NULL ? $data[$boomakers["LB"]] : NULL,
                                                                                    $boomakers["LB"]   != NULL ? $data[$boomakers["LB"]+1] : NULL,
                                                                                    $boomakers["LB"]   != NULL ? $data[$boomakers["LB"]+2] : NULL,
                                                                                    $boomakers["PS"]   != NULL ? $data[$boomakers["PS"]] : NULL,
                                                                                    $boomakers["PS"]   != NULL ? $data[$boomakers["PS"]+1] : NULL,
                                                                                    $boomakers["PS"]   != NULL ? $data[$boomakers["PS"]+2] : NULL,
                                                                                    $boomakers["SO"]   != NULL ? $data[$boomakers["SO"]] : NULL,
                                                                                    $boomakers["SO"]   != NULL ? $data[$boomakers["SO"]+1] : NULL,
                                                                                    $boomakers["SO"]   != NULL ? $data[$boomakers["SO"]+2] : NULL,
                                                                                    $boomakers["SJ"]   != NULL ? $data[$boomakers["SJ"]] : NULL,
                                                                                    $boomakers["SJ"]   != NULL ? $data[$boomakers["SJ"]+1] : NULL,
                                                                                    $boomakers["SJ"]   != NULL ? $data[$boomakers["SJ"]+2] : NULL,
                                                                                    $boomakers["VC"]   != NULL ? $data[$boomakers["VC"]] : NULL,
                                                                                    $boomakers["VC"]   != NULL ? $data[$boomakers["VC"]+1] : NULL,
                                                                                    $boomakers["VC"]   != NULL ? $data[$boomakers["VC"]+2] : NULL,
                                                                                    $boomakers["WH"]   != NULL ? $data[$boomakers["WH"]] : NULL,
                                                                                    $boomakers["WH"]   != NULL ? $data[$boomakers["WH"]+1] : NULL,
                                                                                    $boomakers["WH"]   != NULL ? $data[$boomakers["WH"]+2] : NULL));
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
                else echo "mauvais mdp 2";
            }
        }
        ?>
        <h1> Bd </h1>
        <form method="post" action="">
            <input type="password" name="pass" maxlength="10">
            <input type="submit" name="alim_bd" value="Exécuter le script" />
        </form>
        <h1> Bd à plat </h1>
        <form method="post" action="">
            <input type="password" name="pass" maxlength="10">
            <input type="submit" name="alim_bd_plat" value="Exécuter le script" />
        </form>
    </body>
</html>