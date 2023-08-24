<?php

require_once('config.php');

function base64_url_encode($input) {
    return strtr(base64_encode($input), '+/=', '._-');
}

function base64_url_decode($input) {
    return base64_decode(strtr($input, '._-', '+/='));
}

function get_session() {
    global $secret;
    $session = [];
    if (isset($_COOKIE['session']) && strlen($_COOKIE['session']) > 40) {
        $data = substr($_COOKIE['session'], 0, strlen($_COOKIE['session']) - 40);
        $sig = substr($_COOKIE['session'], strlen($data));
        $verify_sig = hash_hmac('sha1', $data, $secret);
        if ($sig === $verify_sig) {
            $session = json_decode(base64_url_decode($data), true);
            if (time() > $session['exp']) {
                $session = [];
            }
        }
    }
    return $session;
}

function save_session($session) {
    global $secret;
    $session['exp'] = time() + 3600;
    $data = base64_url_encode(json_encode($session));
    $sig = hash_hmac('sha1', $data, $secret);
    setcookie('session', $data.$sig);
}
