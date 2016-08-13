<?php
error_reporting(0);
date_default_timezone_set('Asia/Shanghai');
require 'libs/Smarty.class.php';

$smarty = new Smarty;

//$smarty->force_compile = true;
$smarty->debugging = false;
$smarty->caching = false;
//$smarty->cache_lifetime = 120;

$smarty->assign("title", "统计工具", true);
$smarty->assign("Name", "壹居", true);
$list_cats = get_dict(0);
$smarty->assign("list_cats", $list_cats, true);
$list_items = get_dict(1);
$smarty->assign("list_items", $list_items, true);

$smarty->display('inn_show.tpl');

function get_dict($index)
{
    $filename = dirname(__FILE__) . '/item/data/dict.json';
    $list = json_decode(get_file($filename));
    $result = array();
    foreach ($list as $item) {
        if (!in_array($item[$index], $result)) {
            array_push($result, $item[$index]);
        }
    }
    return $result;
}

function get_file($filename)
{
    $handle = fopen($filename, "r");//读取二进制文件时，需要将第二个参数设置成'rb'
    //通过filesize获得文件大小，将整个文件一下子读到一个字符串中
    $contents = fread($handle, filesize($filename));
    fclose($handle);
    return $contents;
}

?>