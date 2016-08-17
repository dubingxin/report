{config_load file="test.conf" section="setup"}
{include file="header.tpl"}
<script src="inn/js/common.js" type="text/javascript"></script>
<script type="text/javascript" src="inn/js/handsontable.full.js"></script>
<link rel="stylesheet" type="text/css" href="inn/css/handsontable.full.css">
<script src="datedropper/datedropper.js" type="text/javascript"></script>
<link rel="stylesheet" href="datedropper/datedropper.css"/>
<link rel="stylesheet" href="inn/css/menu.css">
<style>
    i {
        margin-top: 3em;;
    }

    .cbp-vimenu li:last-child a {
        background: #ff500b;
        color: #fff;
        position: fixed;
        bottom: 0px;
    }

    h1 {
        margin-top: 1rem;
        margin-bottom: 1rem;
        font-weight: 400;
        font-size: 1.5em;
    }
</style>
<ul class="cbp-vimenu">
    <li><a href="#" class="icon-logo">Logo</a></li>
    <li class="cbp-vicurrent"><a href="index.php" class="icon-data-add">数据</a></li>
    <li><a href="show.php" class="icon-stats-dots">图表</a></li>
    <li><a href="cols.php" class="icon-cols-item">字典</a></li>
    <li><a href="#" class="icon-save" onclick="savedata();">保存</a></li>
</ul>
<div style="margin-left: 80px;">
    <h1><input type="text" id="date" style="width:95px;border:none;"/></h1>
    <div id="etable"></div>
</div>
{literal}
    <script>
        $('#date').dateDropper({lang: 'zh', animation: 'dropdown', format: 'Y-m-d'});
    </script>
    <script>
        var initnow = null;
        var jsondata = null;
        $(function () {
            var date = getstorage("date");
            if (date) {
                $('#date').val(formatDate(date, 'yyyy-MM-dd'));
                init(date);
            }
            else {
                $('#date').val(formatDate(new Date(), 'yyyy-MM-dd'));
            }
        });
        function init(qdate) {
            var endday = null;
            var now = null;
            if (qdate != null) {
                try {
                    now = getCurrentMonthFirstDay(qdate);
                    endday = getCurrentMonthLastDay(qdate);
                }
                catch (err) {
                    alert(arr);
                    return;
                }
            }
            else {
                now = getCurrentMonthFirstDay();
                endday = getCurrentMonthLastDay();
            }
            initnow = now;

            var colsdata = loadcols();
            jsondata = loaddata(now);
            if (jsondata.length == 0) {
                while (now <= endday) {
                    var emptyata = [];
                    emptyata.push(now);
                    jsondata.push(emptyata);
                    for (var i = 0; i < colsdata.length - 1; i++) {
                        emptyata.push('');
                    }
                    now = addDate(now, 1);
                }
            }
            inittable('etable', colsdata, jsondata);
        }
        //呈现
        function inittable(ele_id, colsdata, tabledata) {
            $('#' + ele_id).empty();
            var container = document.getElementById(ele_id);
            var hot = new Handsontable(container, {
                data: tabledata,
                minSpareCols: 1,
                minSpareRows: 1,
                rowHeaders: false,
                colHeaders: true,
                fixedColumnsLeft: 1,
                contextMenu: false,
                colHeaders: function (col) {
                    var txt = null;
                    if (col == 0) {
                        txt = colsdata[col].cols;
                    } else {
                        txt = "<font color=\"blue\">" + colsdata[col].site + "</font><br/>" + colsdata[col].cols;
                    }
                    return txt;
                },
                afterChange: function () {
                },
                cells: function (row, col, prop) {
                    var cellProperties = {};
                    if (col === 0) {
                        cellProperties.readOnly = true;
                    }
                    return cellProperties;
                }
            });
        }
        function savedata() {
            $.ajax({
                url: 'inn/add.php',
                type: 'POST',
                data: {
                    month: formatDate(new Date(initnow), 'yyyyMM'),
                    data: jsondata
                },
                success: function (result) {
                    if (result == 1) {
                        alert('提交成功!');
                    }
                    else {
                        alert('提交失败!' + result.responseText);
                    }
                },
                error: function (err) {
                    alert(err);
                }
            });
        }
        function loadcols() {
            var url = 'item/data/dict.json';
            var result = [];
            var dh = new Object();
            dh.cols = '日期';
            result.push(dh);
            $.ajax({
                type: "get",
                async: false,
                url: url,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    var arr = data;
                    $.each(arr, function (i, item) {
                        var h = new Object();
                        h.site = item[0];
                        h.cols = item[1];
                        result.push(h);
                    });
                },
                error: function (err) {
                    alert(err);
                }
            });
            return result;
        }
        function loaddata(now) {
            var url = 'inn/data/' + formatDate(new Date(now), 'yyyyMM') + '.json';
            var result = [];
            $.ajax({
                type: "get",
                async: false,
                cache: false,
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
        function getCurrentMonthFirstDay(day) {
            var n = null;
            if (day) {
                n = new Date(day);
            }
            else {
                n = new Date();
            }
            return formatDate(n, 'yyyy-MM-01');
        }
        function getCurrentMonthLastDay(day) {
            var current = null;
            if (day) {
                current = new Date(day);
            }
            else {
                current = new Date();
            }
            var nextMonth = current.getMonth() + 1;
            var nextMonthFirstDay = new Date(current.getFullYear(), nextMonth, 1);
            var oneDay = 1000 * 60 * 60 * 24;
            return formatDate(new Date(nextMonthFirstDay - oneDay), 'yyyy-MM-dd');
        }
        function DayNumOfMonth(day) {
            var num = 0;
            var now = null;
            if (day) {
                now = new Date(day);
            } else {
                now = new Date();
            }
            var d = new Date(now.getYear(), now.getMonth(), 32);
            num = 32 - d.getDate();
            return num;
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
    </script>
{/literal}
{include file="footer.tpl"}
