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

$smarty->display('inn_add.tpl');

?>