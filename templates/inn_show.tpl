{config_load file="test.conf" section="setup"}
{include file="header.tpl"}
<script src="https://as.alipayobjects.com/g/datavis/g2/1.2.6/index.js"></script>
<link rel="stylesheet" href="inn/css/menu.css">
<ul class="cbp-vimenu">
    <li><a href="#" class="icon-logo">Logo</a></li>
    <li><a href="index.php" class="icon-data-add">数据</a></li>
    <li class="cbp-vicurrent"><a href="show.php" class="icon-stats-dots">图表</a></li>
    <li><a href="cols.php" class="icon-cols-item">字典</a></li>
</ul>
<div style="margin: 15px 0px 0px 80px;">
    <div id="con">
        <div style="margin-left:50px;margin-top:15px;">
            分类:
            <select id="cat">
                {foreach from=$list_cats item=value}
                    <option value="{$value}">{$value}</option>
                {/foreach}
            </select>
            字典:
            <select id="item">
                {foreach from=$list_items item=value}
                    <option value="{$value}">{$value}</option>
                {/foreach}
            </select>
            <input type="button" value="查询" onclick="search();"/>
        </div>
    </div>
    <div id="c1"></div>
</div>
{literal}
    <script>
        $(function () {
            getdata($('#cat').val(), $('#item').val());
        });
        function initdata(cat, title, data) {
            var chart = new G2.Chart({
                id: 'c1',
                width: $('#con').width(),
                height: $(document).height() - $('#con').height() - 50
            });
            chart.source(data, {
                time: {
                    type: 'cat',
                    mask: 'dd',
                    alias: '日期',
                },
                value: {
                    alias: cat + title
                }
            });
            chart.legend('bottom');
            chart.line().position('time*value').color('name').shape('smooth').size(2);
            chart.point().position('time*value').color('name').shape('name', ['circle', 'rect', 'diamond']).size(4);
            chart.render();
        }
        function search() {
            $('#c1').empty();
            getdata($('#cat').val(), $('#item').val());
        }
        function getdata(c, i) {
            var condition = {
                cat: c,
                item: i
            };
            $.ajax({
                url: 'inn/get.php',
                type: 'POST',
                data: condition,
                success: function (result) {
                    if (result == "-1") {
                        alert('无相关数据');
                    }
                    else {
                        var data = JSON.parse(result);
                        initdata(c, i, data);
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    alert(XMLHttpRequest.status);
                    alert(XMLHttpRequest.readyState);
                    alert(textStatus);
                }
            });
        }
    </script>
{/literal}
{include file="footer.tpl"}
