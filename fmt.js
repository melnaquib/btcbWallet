.pragma library


var leading = 27;
var mdf = ["", "K", "M", "G", "T"];

function fmt2(num, unit, fraction) {
//    num = "340"  + "0" * 9 + "0" * leading;

    if (!fraction) fraction = "00";
    unit = "undefined" == typeof(unit) ? "R" : unit.toUpperCase();
    num = num.toString();
    var l = num.length;

    if(l > leading) {
        if("R" == unit)
            return fmt(num.substr(0, l - leading), "B", num.substr(l - leading, 2));
        else {
            fraction = num.substring(-leading, 2);
            num = num.substring(0, -leading);
            unit = "B";
            l = l - leading;
        }
    }

    var post = Math.min(Math.floor((l - 1) / 3), mdf.length - 1 );
    l -= post * 3;
    num = num.substr(0, l);
    post = mdf[post];

    return num + " " + post + unit;
}

function fmt3(num) {
    if(!num) return "0";
    num = num.toString();
    var l = num.length;
    var res = num[0] + "." + num.substr(1, 4) + "e" + (l - 1);
    return res;
}

function fmt(num) {
    var l = num.length;
    var res = num.substr(0, l -leading);
    return res + " BCB";
}

function fmtAcc(a) {
    var res = a.substr(0, 16) + "..." + a.substr(-8, 16);
    return res;

}
