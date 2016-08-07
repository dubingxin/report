<?php
$index = get_dict_index($_POST['cat'], $_POST['item']);
if ($index == -1) {
    echo $index;
} else {
    $t1 = date('Ym', strtotime('-1 month'));
    $t2 = date('Ym');
    $list1 = get_data($t1 . $_POST['item'], $t1, $index);
    $list2 = get_data($t2 . $_POST['item'], $t2, $index);
    $result = array_merge($list1, $list2);
    echo json_encode($result);
}
function get_dict_index($cat, $item)
{
    $filename = dirname(dirname(__FILE__)) . '/item/data/dict.json';
    $list = json_decode(get_file($filename));
    $i = 0;
    $result = -1;
    foreach ($list as $v) {
        if ($cat == $v[0] && $item == $v[1]) {
            $result = $i;
            return $result;
        }
        $i++;
    }
    return $result;
}

function get_data($series, $month, $index)
{
    $filename = (dirname(__FILE__)) . '/data/' . $month . '.json';
    $list = json_decode(get_file($filename));
    $result = array();
    foreach ($list as $v) {
        $item['name'] = $series;
        $item['time'] = date("d", strtotime($v[0]));
        $item['value'] = $v[$index + 1];
        array_push($result, $item);
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