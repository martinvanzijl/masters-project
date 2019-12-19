<?php

$keypair1 = sodium_crypto_box_keypair();
$keypair1_public = sodium_crypto_box_publickey($keypair1);
$keypair1_secret = sodium_crypto_box_secretkey($keypair1);

$keypair2 = sodium_crypto_box_keypair();
$keypair2_public = sodium_crypto_box_publickey($keypair2);
$keypair2_secret = sodium_crypto_box_secretkey($keypair2);

//--------------------------------------------------
// Person 1, encrypting

$message = 'hello';

$nonce = random_bytes(SODIUM_CRYPTO_BOX_NONCEBYTES);

$encryption_key = sodium_crypto_box_keypair_from_secretkey_and_publickey($keypair1_secret, $keypair2_public);
$encrypted = sodium_crypto_box($message, $nonce, $encryption_key);

echo base64_encode($encrypted) . "\n";

//--------------------------------------------------
// Person 2, decrypting

$decryption_key = sodium_crypto_box_keypair_from_secretkey_and_publickey($keypair2_secret, $keypair1_public);
$decrypted = sodium_crypto_box_open($encrypted, $nonce, $decryption_key);

echo $decrypted . "\n";

?>
