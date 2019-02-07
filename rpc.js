.pragma library
.import "accs.js" as Accs
.import "AccBook.js" as AccBook


function _rpc(args, cb){
    var host = "localhost";
    var port = "17076";
    var url = "http://" + host + ":" + port;
    var method="POST"

    var xhr = new XMLHttpRequest();
    xhr.open(method, url, false);
    xhr.send(JSON.stringify(args));

    var rsp = xhr.responseText;
    var res = JSON.parse(rsp);
    return res;
}

function walletAccounts(wallet) {
    console.log("DBG WALLET");
    console.log(wallet);

    var args = {
        action: "wallet_balances",
        wallet: wallet
    };
    var rsp = _rpc(args);
    var res = [];
    for(var a in rsp.balances) {
        var o = rsp.balances[a];
        o.account = a;
        o.name = AccBook.getNameFromAcc(a);
        res.push(o);
    }

    return res;
}

function account_history(account) {
    if (! account) return [];
    var args = {
        action: "account_history",
        count: "-1",
        account: account
    }

    var res = _rpc(args);

    res = res.history;
    for(var i in res) {
        res[i].binding = true;
        res[i].date = "date";
    }
    return res;
}


function createAccount(wallet) {
    var args = {
        action: "account_create",
        wallet: wallet
    }
    var res = _rpc(args);
    console.log(res.account)
    return res.account ;
}

function accountRepresentative(account) {
    var args = {
        action : "account_representative",
        account : account
    }
    var res = _rpc(args);
    console.log(res.representative)
    console.log(res.error)
    return res.representative;
}



function account_pending(account) {
    if (! account) return [];
    var args = {
        action: "accounts_pending",
        accounts: [account],
        source: "true"
    }

    var rsp = _rpc(args);
    rsp = rsp;

    res = res.history;
    for(var i in res) {
        res[i].binding = true;
        res[i].date = "date";
    }
    return res;
}

function createNextAccount(wallet) {
    var args = {
        action: "account_create",
        "wallet": wallet
    }

    var res = _rpc(args);
    return res.account;
}

function send(wallet, account, amount) {
    var args = {
        action: "send",
        "wallet": wallet,
        account: account,
        amount: amount,
    }

    var res = _rpc(args);
}

function wallets(proxy) {
    var r = proxy.nodeCmd("--wallet_list");
    r = r.split(/\r?\n/);
    var res = [];
    for(var i in r) {
        if(r[i].startsWith("Wallet ID: ")) {
            var a = r[i].substr(11);
            res.push(a);
        }
    }
    return res;

}

function newWallet(seed, passwd) {
    var args = {
        action: "wallet_create"
    }

    var res = _rpc(args);
    setSeed(res.wallet, seed);
    setPasswd(res.wallet, passwd);
    return res.wallet;
}

function setSeed(wallet, seed) {
    var args = {
        action: "wallet_change_seed",
        wallet: wallet,
        seed: seed,
        count :1
    }

    var res = _rpc(args);
    ;
}

function setPasswd(wallet, passwd) {
    var args = {
        action: "password_change",
        wallet: wallet,
        password: passwd
    }

    var res = _rpc(args);
    ;
}

function unlockWallet(wallet, passwd) {
    var args = {
        action: "password_enter",
        wallet: wallet,
        password: passwd
    }

    var res = _rpc(args);
    return "1" == res.valid;
}
