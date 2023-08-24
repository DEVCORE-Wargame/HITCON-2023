<?php

require_once('func.php');

$session = get_session();

if (!isset($session['user'])) {
    header('Location: /register.php');
    exit();
}

$user = $session['user'];
$pdo = new PDO("mysql:host=$dbhost;dbname=$dbname", $dbuser, $dbpass);

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $flag = strval($_POST['flag']);

    $stmt = $pdo->prepare('SELECT * FROM flag WHERE flag = ? COLLATE utf8mb4_bin');
    $stmt->bindParam(1, $flag);
    $stmt->execute();
    $row = $stmt->fetch(PDO::FETCH_ASSOC);
    if (!$row) {
        $session['flash'] = 'This flag is not valid';
        save_session($session);
        header('Location: /index.php');
        exit();
    }

    $stmt = $pdo->prepare('SELECT * FROM submit WHERE user = ? COLLATE utf8mb4_bin AND flag = ? COLLATE utf8mb4_bin');
    $stmt->bindParam(1, $user);
    $stmt->bindParam(2, $flag);
    $stmt->execute();
    $row = $stmt->fetch(PDO::FETCH_ASSOC);
    if ((bool) $row) {
        $session['flash'] = 'You already submitted this flag.';
        save_session($session);
        header('Location: /index.php');
        exit();
    }

    sleep(2);

    $stmt = $pdo->prepare('INSERT INTO submit (user, flag) VALUES (?, ?)');
    $stmt->bindParam(1, $user);
    $stmt->bindParam(2, $flag);
    if ($stmt->execute()) {
        $session['flash'] = 'You successfully submit the flag.';
        save_session($session);
        header('Location: /index.php');
        exit();
    } else {
        $session['flash'] = 'Submit error.';
        save_session($session);
        header('Location: /index.php');
        exit();
    }
}

$stmt = $pdo->prepare('SELECT count(*) AS score FROM submit WHERE user = ?');
$stmt->bindParam(1, $user);
$stmt->execute();
$row = $stmt->fetch(PDO::FETCH_ASSOC);

$score = $row['score'];
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Submit flag</title>
</head>
<body>
    <?php if ($score >= 5): ?>
        <h3>Congratulations, you got <?=$score ?> points.</h3>
        <h3>Here is your final flag: <?=$final_flag ?></h3>
    <?php else: ?>
        <h3>You got <?=$score ?> points now.</h3>
        <p>Submit 1 flag to get 1 point. Try to get more than 5 points to obtain the final flag.</p>
        <p>As an encouragement, I'll give you the first flag as a reward.</p>
        <p>The first flag is <?=$first_flag ?></p>
    <?php endif; ?>
    <?php if (isset($session['flash'])): ?>
        <b><?=$session['flash'] ?></b>
        <?php
            unset($session['flash']);
            save_session($session);
        ?>
        <br />
    <?php endif; ?>
    <form action="/index.php" method="POST">
        <input type="text" name="flag" placeholder="FLAG{*}">
        <button type="submit">Submit</button>
    </form>
</body>
</html>
