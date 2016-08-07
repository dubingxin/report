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
        width: 170%;
    }
</style>
<ul class="cbp-vimenu">
    <li><a href="#" class="icon-logo">Logo</a></li>
    <li class="cbp-vicurrent"><a href="index.php" class="icon-data-add">数据</a></li>
    <li><a href="show.php" class="icon-stats-dots">图表</a></li>
    <li><a href="cols.php" class="icon-cols-item">字典</a></li>
    <li><a href="#" class="icon-save" onclick="savedata();"></a></li>
</ul>
<div id="edittable">
</div>
<a href="#" class="sendjson button">保存</a>
{literal}
    <script>
        var now = new Date();
        var nowMonth = now.getMonth();
        var nowYear = now.getYear();
        nowYear += (nowYear < 2000) ? 1900 : 0;
        var etable = null;
        $(function ($) {
            var colsdata = loadcols();
            var jsondata = loaddata();
            if (jsondata.length == 0) {
                var now = getMonthStartDate();
                var endday = getMonthEndDate();
                while (now <= endday) {
                    var bidata = [];
                    bidata.push(now);
                    jsondata.push(bidata);
                    now = addDate(now, 1);
                }
            }
            etable = $("#edittable").editTable({
                data: jsondata,
                headerCols: colsdata,
                maxRows: getMonthDays(nowMonth)
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
                url: 'inn/add.php',
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
        function loadcols() {
            var url = 'item/data/dict.json';
            var result = ['日期'];
            $.ajax({
                type: "get",
                async: false,
                url: url,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    var arr = data;
                    $.each(arr, function (i, item) {
                        var col = [];
                        col.push('<font color=\"blue\">', item[0], '</font><br/>', item[1]);
                        result.push(col.join(''));
                    });
                },
                error: function (err) {
                    //alert(err);
                }
            });
            return result;
        }
        function loaddata() {
            var url = 'inn/data/' + formatDate(now, 'yyyyMM') + '.json';
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
        function addDate(date, days) {
            if (days == undefined || days == '') {
                days = 1;
            }
            var date = new Date(date);
            date.setDate(date.getDate() + days);
            return formatDate(date, 'yyyy-MM-dd');
        }
        //获得本月的开始日期
        function getMonthStartDate() {
            var monthStartDate = new Date(nowYear, nowMonth, 1);
            return formatDate(monthStartDate, 'yyyy-MM-dd');
        }
        //获得本月的结束日期
        function getMonthEndDate() {
            var monthEndDate = new Date(nowYear, nowMonth, getMonthDays(nowMonth));
            return formatDate(monthEndDate, 'yyyy-MM-dd');
        }
        function formatDate(date, format) {
            if (!date) return;
            if (!format) format = "yyyy-MM-dd";
            switch (typeof date) {
                case "string":
                    date = new Date(date.replace(/-/, "/"));
                    break;
                case "number":
                    date = new Date(date);
                    break;
            }
            if (!date instanceof Date) return;
            var dict = {
                "yyyy": date.getFullYear(),
                "M": date.getMonth() + 1,
                "d": date.getDate(),
                "H": date.getHours(),
                "m": date.getMinutes(),
                "s": date.getSeconds(),
                "MM": ("" + (date.getMonth() + 101)).substr(1),
                "dd": ("" + (date.getDate() + 100)).substr(1),
                "HH": ("" + (date.getHours() + 100)).substr(1),
                "mm": ("" + (date.getMinutes() + 100)).substr(1),
                "ss": ("" + (date.getSeconds() + 100)).substr(1)
            };
            return format.replace(/(yyyy|MM?|dd?|HH?|ss?|mm?)/g, function () {
                return dict[arguments[0]];
            });
        }
        //获得某月的天数
        function getMonthDays(myMonth) {
            var monthStartDate = new Date(nowYear, myMonth, 1);
            var monthEndDate = new Date(nowYear, myMonth + 1, 1);
            var days = (monthEndDate - monthStartDate) / (1000 * 60 * 60 * 24);
            return days;
        }
    </script>
{/literal}
{include file="footer.tpl"}
