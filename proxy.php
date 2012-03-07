<?php
// PHP Proxy
//for higher security just put the url you want here or build
//your url with GET or POST parameters. Not the best idea to
//pass the entire url

//make sure we're using http
$url = 'https://';
if (isset($_GET['sd']) && $_GET['sd'] != '')
{
    $url .= $_GET['sd'].'.';
}
//ensure only twitter domains are used
$url .= 'twitter.com/';

if (isset($_GET['path']) && $_GET['path'] != '')
{
    $url .= $_GET['path'];
}

$postFields = array();
foreach ($_GET as $name => $value) {
    if ($name != 'sd' and $name != 'path') {
        $postFields[$name] = $value;
    }
}

// Use curl to post to your blog.
$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $url);
//curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);

// Insert your user name and password for Twitter
curl_setopt($ch, CURLOPT_USERPWD,$user.':'.$pass);
curl_setopt($ch, CURLOPT_POSTFIELDS, $postFields);

$data = curl_exec($ch);

if (curl_errno($ch)) {
 print curl_error($ch);
} else {
 curl_close($ch);
}

// $data contains the result of the post...
echo $data;
?>
