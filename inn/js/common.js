function GetQueryString(name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
    var r = window.location.search.substr(1).match(reg);
    if (r != null)return unescape(r[2]);
    return null;
}
function setstorage(objName, objValue) {
    var storage = window.localStorage;
    if (window.localStorage) {
        localStorage.setItem(objName, objValue);
    } else {
    }
}
function getstorage(objName) {
    var storage = window.localStorage;
    var result = '';
    if (window.localStorage) {
        for (var i = 0; i < storage.length; i++) {
            if (storage.key(i) == objName)
                result = storage.getItem(storage.key(i));
        }
    } else {
    }
    return result;
}
function clearstorage(key) {
    if (window.localStorage) {
        if (key)
            window.localStorage.removeItem(key);
        else
            window.localStorage.clear();
    }
}