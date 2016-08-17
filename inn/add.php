<?php
/**
 * Created by PhpStorm.
 * User: 41356
 * Date: 2016-8-6
 * Time: 14:58
 */
$filename = $_POST['month'] . '.json';
$myfile = fopen(dirname(__FILE__) . '/data/' . $filename, "w") or die("Unable to open file!");
$txt = json_encode($_POST['data']);
fwrite($myfile, $txt);
fclose($myfile);
echo 1;
?>