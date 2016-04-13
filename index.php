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
            
            /// SELECT ///
            $res = $pdo->query();
            while ($donnees = $res->fetch()) {
                echo $donnees['NOM_CHAMP'];
            } 
            
            /// INSERT ///
            $statement = 'INSERT INTO ...';
            $query = $pdo->prepare($statement);
            $query->execute(array('nom_champ_1' => $nom_champ_1, ''));
            
            $pdo=null;
        }
        ?>
        <form method="post" action="">
            <input type="submit" name="Envoyer" value="Exécuter le script" />
        </form>
    </body>
</html>