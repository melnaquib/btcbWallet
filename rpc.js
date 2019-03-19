.pragma library
.import "accs.js" as Accs
.import "AccBook.js" as AccBook

function versionUpdate(currentDate){
    var updateUrl = "https://bitcoin.black/api/BtcbWalletVersion";
    try {
        var xhr = new XMLHttpRequest();
        xhr.get("GET", updateUrl, false);
        xhr.send();
        var rsp = xhr.responseText;
        var res = JSON.parse(rsp);
        var shouldUpdate = new Date(res.date) > currentDate;
        return res;
    } catch (ex) {};
}

function _rpc(args, cb){
    var host = "localhost";
//    var port = "17076";
    var port = "15000";
//    var url = "http://" + host + ":" + port;
    var url = "http://" + "[::1]" + ":" + port;
    var method="POST"

    try {
        var xhr = new XMLHttpRequest();
        xhr.open(method, url, false);
        xhr.send(JSON.stringify(args));

        var rsp = xhr.responseText;
        var res = JSON.parse(rsp);
        return res;
    } catch (ex) {};
    return {error: true};
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

function setAccountRepresentative(wallet, account, repr) {
    var args = {
        action: "account_representative_set",
        wallet: wallet,
        account: account,
        representative: repr
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

function send(wallet, source, destination, amount) {
    var tempAmount = amount + "000".repeat(9);
    var args = {
        action: "send",
        wallet: wallet,
        source: source,
        destination: destination,
        amount: tempAmount
    }

    var res = _rpc(args);
    return res;
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
    return "1" === res.valid;
}

function rcvPendingBlock(wallet, account, block) {
    var args = {
        action: "receive",
        wallet:wallet,
        account:account,
        block:block
    }
    var res = _rpc(args);
    return res.block ;
}

function recvPendingAll(wallet) {
    var args = {
        action: "search_pending_all"
    }
    var res = _rpc(args);
    var wallet_pending = {
        action: "wallet_pending",
        wallet: wallet,
        count: 1,
        include_active: true
    }

    var resp = _rpc(wallet_pending);
    var block_recv = {
        action: "receive",
        wallet: wallet,
        account: "",
        block: ""
      }

    for(var account in resp["blocks"]) {
        for(var i in resp["blocks"][account]) {
            var hash = resp["blocks"][account][i];
            block_recv.account = account;
            block_recv.block = hash;
            _rpc(block_recv);
        }

    }

}

function randmon_seed() {
    var args = {
        action: "key_create"
    }
    var res = _rpc(args);
    var s = res.public;
    return s;
}
