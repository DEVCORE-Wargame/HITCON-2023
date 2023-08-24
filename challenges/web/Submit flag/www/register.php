<?php

require_once('func.php');

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    if (isset($_POST['user']) && strlen($_POST['user']) <= 128) {
        $session = get_session();
        $session['user'] = strval($_POST['user']);
        $pdo = new PDO("mysql:host=$dbhost;dbname=$dbname", $dbuser, $dbpass);
        $stmt = $pdo->prepare('DELETE FROM submit WHERE user = ?');
        $stmt->bindParam(1, $session['user']);
        $stmt->execute();
        save_session($session);
        header('Location: /');
        exit();
    }
}

?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Enter you username</title>
</head>
<body>
    <form action="/register.php" method="POST">
        <input type="text" name="user" maxlength="128" placeholder="username">
        <button type="submit">Submit</button>
    </form>
</body>
</html>
