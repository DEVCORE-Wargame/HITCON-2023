<?php

if (strpos(strtolower($_SERVER['HTTP_USER_AGENT']), 'sqlmap') !== false) {
    return;
}

if (!empty($_SERVER['HTTP_CLIENT_IP'])) {
    $ip = $_SERVER['HTTP_CLIENT_IP'];
} else if (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
    $ip = $_SERVER['HTTP_X_FORWARDED_FOR'];
} else {
    $ip = $_SERVER['REMOTE_ADDR'];
}
$country = @file_get_contents("https://api.hostip.info/country.php?ip=$ip");

if ($country == 'XX' || !$country) {
    $country = 'Unknown';
}

$db = mysqli_connect('mysql', 'dbuser', 'en8yzvQz4ywKK6gnSbK', 'ipdb');
mysqli_query($db, "INSERT INTO iplog (ip, country) VALUES ('$ip', '$country')");

$query = "SELECT country, COUNT(ip) as total FROM iplog GROUP BY country";

$result = mysqli_query($db, $query);

$table = array();
while ($row = mysqli_fetch_array($result, MYSQLI_ASSOC)) {
    $table[] = $row;
}

mysqli_close($db);

?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>What's my IP</title>
    <style>
        * {
            font-size: 1.5rem;
        }
    </style>
</head>
<body>
    <b>IP:&nbsp;</b><span><?=$ip ?></span>
    <br />
    <b>Country:&nbsp;</b><span><?=$country ?></span>
    <br />
    <br />
    <b>Statistic:&nbsp;</b>
    <table border='1'>
    <tr><th>Country</th><th>Total</th></tr>
    <?php
    foreach ($table as $row) {
        echo "<tr>";
        echo "<td>" . htmlentities($row['country']) . "</td>";
        echo "<td>" . htmlentities($row['total']) . "</td>";
        echo "</tr>";
    }
    ?>
    </table>
    <br />
</body>
</html>
