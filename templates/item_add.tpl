{config_load file="test.conf" section="setup"}
{include file="header.tpl"}
<script src="editTable/jquery.edittable.min.js" type="text/javascript"></script>
<link rel="stylesheet" href="editTable/jquery.edittable.css">
<link rel="stylesheet" href="inn/css/menu.css">
<style>
    .cbp-vimenu li:last-child a {
        background: #ff500b;
        color: #fff;
        position: fixed;
        bottom: 0px;
    }
    table.inputtable {
        width: 95%;
    }
</style>
<ul class="cbp-vimenu">
    <li><a href="#" class="icon-logo">Logo</a></li>
    <li><a href="index.php" class="icon-data-add">数据</a></li>
    <li><a href="show.php" class="icon-stats-dots">图表</a></li>
    <li class="cbp-vicurrent"><a href="cols.php" class="icon-cols-item">字典</a></li>
    <li><a href="javasscript:void(0);" class="icon-save" onclick="savedata();"></a></li>
</ul>
<div id="edittable">
</div>
<a href="#" class="sendjson button">保存</a>
{literal}
    <script>
        var etable = null;
        $(function ($) {
            var jsondata = [];
            jsondata = loaddata();
            if (jsondata.length == 0) {
                jsondata = [["Click on the plus symbols on the top and right to add cols or rows"]];
            }
            etable = $("#edittable").editTable({
                data: jsondata,
                headerCols: [
                    '类别',
                    '字典'
                ]
            });
            var $inp = $('input:text');
            $inp.bind('keydown', function (e) {
                var key = e.which;
                if (key == 13) {
                    e.preventDefault();
                    var nxtIdx = $inp.index(this) + 1;
                    $(":input:text:eq(" + nxtIdx + ")").focus();
                }
            });
        });
        function savedata() {
            $.ajax({
                url: 'item/add.php',
                type: 'POST',
                data: {data: etable.getJsonData()},
                complete: function (result) {
                    if (result.responseText == 1) {
                        alert('提交成功!');
                    }
                    else {
                        alert('提交失败!' + result.responseText);
                    }
                }
            });
        }
        function loaddata() {
            var url = 'item/data/dict.json';
            var result = [];
            $.ajax({
                type: "get",
                async: false,
                url: url,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    result = data;
                },
                error: function (err) {
                    //alert(err);
                }
            });
            return result;
        }
    </script>
{/literal}
{include file="footer.tpl"}
