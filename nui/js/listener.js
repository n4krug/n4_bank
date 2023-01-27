$(function() {
    let accountTemplate = 
        '<div class="account info-element">' +
            '<div class="info-left info-part">' +
                '<i class="fa-solid fa-building-columns element-icon"></i>' +
                '<h5 class="element-number">#{{id}}</h5>' +
            '</div>' +
            '<div class="info-center info-part">' +
                '<h2 class="element-title">{{name}}</h2>' +
                '<div class="money-info">' +
                    '<i class="fa-solid fa-dollar"></i><h3 class="money-amount">{{money}}</h3>' +
                '</div>' +
            '</div>' +
            '<div class="info-right info-part">' +
                '<button class="new-transfer" id="account_{{id}}_transfer">Överföring</button>' +
                '<button class="manage-account" id="account_{{id}}_manage">Hantera</button>' +
                '<button class="account-transactions" id="account_{{id}}_transactions">Transaktioner</button>' +
            '</div>' +
        '</div>' 
    ;

    let uiType = 'bank'

    // öppna nuin
    function display(bool) {
        if (bool) {
            // $("#container").show();
            $("#container").removeClass("hidden");
        } else {
            // $("#container").hide();
            $("#container").addClass("hidden");
        }
    }

    function atmDisplay(bool) {
        if (bool) {
            // $("#container").show();
            $("#atm-container").removeClass("hidden");
        } else {
            // $("#container").hide();
            $("#atm-container").addClass("hidden");
        }
    }
    
    function loginDisplay(bool) {
        if (bool) {
            // $("#container").show();
            $("#login-container").removeClass("hidden");
        } else {
            // $("#container").hide();
            $("#login-container").addClass("hidden");
        }
    }
    
    function updateMoney(item) {
        let cashAmount = item.player.money
        let bankAmount = 0;
        for (let i = 0; i < item.player.accounts.length; i++) {
            if (item.player.accounts[i].name == 'bank') {
                bankAmount = item.player.accounts[i].money;
            }
        }
        
        $(".money-cash .money-amount").text(cashAmount)
        $(".money-bank .money-amount").text(bankAmount)
    }

    function updateAccounts(item) {
        $("#account-list").empty()
        
        $("#account-list").append(Mustache.render(
            '<button class="add-item" id="add-account">' +
                '<i class="fa-solid fa-plus"></i>' +
            '</button>'
        ))

        let accounts = item.player.accounts

        for (let i = 0; i < accounts.length; i++) {
            var view = {
                id: i,
                name: accounts[i].label,
                money: accounts[i].money
            };
            
            
            if (view.name != "Dirty Money" && view.name != "Cash") {
                let accountElement = $(Mustache.render(accountTemplate, view))[0];
                $("#account-list").append(accountElement);
            }
            
            if (view.name == "Bank") {
                $(`#account_${view.id}_manage`)[0].remove()
            }
        }

        addListeners()        

    }

    function addListeners() {
        $("#close-add-account-modal").replaceWith($("#close-add-account-modal").clone())
        $("#add-account").replaceWith($("#add-account").clone())
        $("#add-account-submit").replaceWith($("#add-account-submit").clone())
        $("#close-manage-account-modal").replaceWith($("#close-manage-account-modal").clone())
        $("#manage-account-submit").replaceWith($("#manage-account-submit").clone())
        $(".remove-account-btn").off()
        $("#new-account-title").off()

        document.getElementById("close-add-account-modal").addEventListener("click", function() {
            document.getElementById("add-account-modal").close();
            $.post('https://' + window.Script + '/update', JSON.stringify({}))
        })
        
        document.getElementById("add-account").addEventListener("click", function() {
            document.getElementById("add-account-modal").showModal();
        })
        
        document.getElementById("add-account-submit").addEventListener("click", function() {
            var label = document.getElementById("new-account-title").value
            $.post('https://' + window.Script + '/addAccount', JSON.stringify({
                label: label,
                name: label.toLowerCase().replace(/ /g, "_")
            }))
            // $.post('https://' + window.Script + '/update', JSON.stringify({}))
            document.getElementById("add-account-modal").close();
        })

        document.getElementById("close-manage-account-modal").addEventListener("click", function() {
            document.getElementById("manage-account-modal").close();
            $.post('https://' + window.Script + '/update', JSON.stringify({}))
        })

        document.getElementById("manage-account-submit").addEventListener("click", function() {
            document.getElementById("manage-account-modal").close();
            $.post('https://' + window.Script + '/update', JSON.stringify({}))
        })
        
        document.getElementById("close-account-transactions-modal").addEventListener("click", function() {
            document.getElementById("account-transactions-modal").close();
            $.post('https://' + window.Script + '/update', JSON.stringify({}))
        })
        
        document.getElementById("account-transactions-submit").addEventListener("click", function() {
            document.getElementById("account-transactions-modal").close();
            $.post('https://' + window.Script + '/update', JSON.stringify({}))
        })
        
        $(".remove-account-btn").on('click', function() {
            console.log($(".remove-account-btn").attr('id'))
            $.post('https://' + window.Script + '/removeAccount', JSON.stringify({
                account: $(".remove-account-btn").attr('id')
            }))
            document.getElementById("manage-account-modal").close();
            setTimeout(() => {$.post('https://' + window.Script + '/update', JSON.stringify({}))}, 100)
        })
    
        $("new-account-title").on("keyup", function(e) {
            if (e.key === "Enter") {
                var label = document.getElementById("new-account-title").value
                $.post('https://' + window.Script + '/addAccount', JSON.stringify({
                    label: label,
                    name: label.toLowerCase().replace(/ /g, "_")
                }))
                // $.post('https://' + window.Script + '/update', JSON.stringify({}))
                document.getElementById("add-account-modal").close();
            }
        })

        

    }

    function loadTransferBtns() {

        var transferModal = document.getElementById("transfer-modal")
        var transferBtns = document.getElementsByClassName("new-transfer");
        
        for (let btn of transferBtns) {
            btn.addEventListener("click", function() {
                transferModal.showModal();
                setTransferModal(window.item, btn.id)
                
            })
        }

        var manageModal = document.getElementById("manage-account-modal")
        var manageBtns = document.getElementsByClassName("manage-account");

        for (let btn of manageBtns) {
            btn.addEventListener("click", function() {
                manageModal.showModal();
                setManageModal(window.item, btn.id)
                
            })
        }
        
        var transactionsModal = document.getElementById("account-transactions-modal")
        var transactionsBtns = document.getElementsByClassName("account-transactions");

        for (let btn of transactionsBtns) {
            btn.addEventListener("click", function() {
                transactionsModal.showModal();
                setTransactionModal(window.item, btn.id)
                
            })
        }
    }

    function setTransactionModal(item, accountId) {
        var list = $("#transactions-list")
        list.empty()

        var id = accountId.split("_")[1]

        fetch('https://' + window.Script + '/getTransactions', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({
                account: item.player.accounts[id].name
            })
        }).then(resp => resp.json()).then(transactions => {
            transactions.forEach(transaction => {
                list.append(`
                <div class="transaction-element modal-list-element">
                    <p class="transaction-description">${transaction.description}</p>
                    <p class="transaction-amount">${transaction.amount} kr</p>
                </div>
                `)
            });
        })
    }

    function setManageModal(item, accountId) {
        var list = $("#owners-list")
        list.empty()

        var id = accountId.split("_")[1]

        $(".remove-account-btn").prop('id', item.player.accounts[id].name)

        // fetch('https://va_base/getAccountOwners', {
        //     method: 'POST',
        //     headers: {
        //         'Content-Type': 'application/json; charset=UTF-8',
        //     },
        //     body: JSON.stringify({
        //         account: item.player.accounts[id].name
        //     })
        // }).then(resp => resp.json()).then(resp => {
        //     let owners = JSON.parse(resp)

        //     for (let i = 0; i < owners.length; i++) {
        //         fetch('https://va_base/getPlayerData', {
        //             method: 'POST',
        //             headers: {
        //                 'Content-Type': 'application/json; charset=UTF-8',
        //             },
        //             body: JSON.stringify({
        //                 identifier: owners[i]
        //             })
        //         }).then(data => data.json()).then(data => {

        //             if (owners[i] == item.player.identifier) {

        //             }
                        
        //             var p = data.personnummer.toString()

        //             var personnummer = `${p[0]}${p[1]}${p[2]}${p[3]}-${p[4]}${p[5]}-${p[6]}${p[7]}-${p[8]}${p[9]}${p[10]}${p[11]}`

        //             // list.append(Mustache.render(template, {
        //             //     firstname: data.firstname,
        //             //     lastname: data.lastname,
        //             //     personnummer: personnummer,
        //             //     identifier: data.identifier,
        //             //     account: item.player.accounts[id].name
        //             // }))

        //             list.append(`
        //                 <div class="owner-wrapper modal-list-element">
        //                     <div class="info-wrapper">
        //                         <h2 class="modal-info-title">${data.firstname} ${data.lastname}</h2>
        //                         <h3 class="modal-info-subtitle">${personnummer}</h3>
        //                     </div>
        //                     <button class="remove-btn modal-btn" id="del${owners[i].toString()}">Ta bort</button>
        //                 </div>
        //             `)
                    
        //             $(`#del${owners[i].toString()}`).on("click", function() {
        //                 console.log("js")
        //                 fetch('https://' + window.Script + '/removeOwner', {
        //                     method: 'POST',
        //                     headers: {
        //                         'Content-Type': 'application/json; charset=UTF-8',
        //                     },
        //                     body: JSON.stringify({
        //                         identifier: owners[i],
        //                         account: item.player.accounts[id].name
        //                     })}).then(data => data.json()).then(data => {
        //                         setManageModal(item, accountId)
        //                         $.post('https://' + window.Script + '/update', JSON.stringify({}))
        //                     })
        //             })

        //             console.log(owners[i])

        //             if (owners[i].toString() == item.player.identifier) {
        //                 $(`#del${owners[i].toString()}`).remove()
                        
        //             }
        //         })
        //     }
        // });

        $("#add-player-account-submit").off()

        $("#add-player-account-submit").on('click', function() {
            $.post('https://' + window.Script + '/addOwner', JSON.stringify({
                account: item.player.accounts[id],
                pnummer: $('#add-player-account').val()
            }))
            setTimeout(() => {setManageModal(item, accountId)}, 100)
            $('#add-player-account').val("")
        })

        $('#add-player-account').off()

        $('#add-player-account').on('keyup', function(e) {
            if (e.key == 'Enter') {
                $.post('https://' + window.Script + '/addOwner', JSON.stringify({
                    account: item.player.accounts[id],
                    pnummer: $('#add-player-account').val()
                }))
                setTimeout(() => {setManageModal(item, accountId)}, 100)
                $('#add-player-account').val("")
            }
        })
        

        // $.post('https://va/getAccountOwners', JSON.stringify({
        //     account: item.player.accounts[id].name
        // }), function(respone) {
        //     console.log("response: " + JSON.stringify(respone))
        // })

    }

    function setTransferModal(item, accountId) {
        var dropdown = $("#select-account")
        dropdown.empty()
        dropdown.append(Mustache.render('<option value="" disabled selected>Till konto</option>'))

        var accounts = item.player.accounts;
        
        var id = accountId.split("_")[1]
        
        $(".transfer-submit")[0].id = accounts[id].name
        
        accounts.splice(id, 1);
        
        var optionTemplate = '<option value="{{name}}">{{label}}</option>'



        for (var i = 0; i < accounts.length; i++) {
            if (accounts[i].name != "money" && accounts[i].name != "black_money") {

                    var view = {
                    name: accounts[i].name,
                    label: accounts[i].label
                }
                dropdown.append(Mustache.render(optionTemplate, view))
            }
        }

    }

    document.getElementById("close-account-modal").addEventListener("click", function() {
        transferModal.close();
        $.post('https://' + window.Script + '/update', JSON.stringify({}))
    })


    display(false)
    loginDisplay(false)

    window.addEventListener('message', function(event) {
        const item = event.data;
        if (item.Script != null) {
            window.Script = item.Script
        }
        if (item.type === "ui") {
            if (item.status == true) {
                display(true, item.work)
                loginDisplay(false)
            } else {
                loginDisplay(false)
                display(false)
            }
        } else if (item.type === "atm-ui") {
            if (item.status == true) {
                atmDisplay(true, item.work)
                loginDisplay(false)
            } else {
                loginDisplay(false)
                atmDisplay(false)
            }
        } else if (item.type === 'BankIDLogin') {
            if (item.status == true) {
                loginDisplay(true, item.work)
            } else {
                loginDisplay(false)
            }
        }
        
        updateMoney(item)

        updateAccounts(item)

        loadTransferBtns()



        window.item = item

    })

    $(".transfer-submit").on("click", function() {
        document.getElementById("transfer-modal").close()

        let targetAcc = $("#select-account")[0].value
        let fromAcc = $(".transfer-submit")[0].id
        let amount = $("#transfer-amount")[0].value

        if (targetAcc != null && targetAcc != "") {
            $.post('https://' + window.Script + '/transfer', JSON.stringify({
                target: targetAcc,
                from: fromAcc,
                amount: amount,
            }));
        }

        $.post('https://' + window.Script + '/update', JSON.stringify({}))
    })

    $("#deposit-amount").on("keyup", function(e) {
        if (e.key === "Enter") {
            $.post('https://' + window.Script + '/deposit', JSON.stringify({
                amount: $('#deposit-amount').val()
            }));
            $('#deposit-amount').val("")
        }
    })
    
    $("#deposit-submit").on("click", function() {
        $.post('https://' + window.Script + '/deposit', JSON.stringify({
            amount: $('#deposit-amount').val()
        }));
        $('#deposit-amount').val("")
    })
    
    $("#atm-deposit-amount").on("keyup", function(e) {
        if (e.key === "Enter") {
            $.post('https://' + window.Script + '/atmDeposit', JSON.stringify({
                amount: $('#atm-deposit-amount').val()
            }));
            $('#atm-deposit-amount').val("")
        }
    })
    
    $("#atm-deposit-submit").on("click", function() {
        $.post('https://' + window.Script + '/atmDeposit', JSON.stringify({
            amount: $('#atm-deposit-amount').val()
        }));
        $('#atm-deposit-amount').val("")
    })
    
    $("#withdrawal-submit").on("click", function() {
        $.post('https://' + window.Script + '/withdraw', JSON.stringify({
            amount: $('#withdrawal-amount').val()
        }));
        $('#withdrawal-amount').val("")
    })
    
    $("#withdrawal-amount").on("keyup", function(e) {
        if (e.key === "Enter") {
            $.post('https://' + window.Script + '/withdraw', JSON.stringify({
                amount: $('#withdrawal-amount').val()
            }));
            $('#withdrawal-amount').val("")
        }
    })
    
    $("#atm-withdrawal-submit").on("click", function() {
        $.post('https://' + window.Script + '/atmWithdraw', JSON.stringify({
            amount: $('#atm-withdrawal-amount').val()
        }));
        $('#atm-withdrawal-amount').val("")
    })
    
    $("#atm-withdrawal-amount").on("keyup", function(e) {
        if (e.key === "Enter") {
            $.post('https://' + window.Script + '/atmWithdraw', JSON.stringify({
                amount: $('#atm-withdrawal-amount').val()
            }));
            $('#atm-withdrawal-amount').val("")
        }
    })

    // ESC Close
    $(document).keyup(function(e) {
        if (e.key === "Escape") {
            $.post('https://' + window.Script + '/exit', JSON.stringify({}));
        }
    });

    $("#exit-btn").on("click", function(e) {
        $.post('https://' + window.Script + '/exit', JSON.stringify({}));
    })
    
    $("#atm-exit-btn").on("click", function(e) {
        $.post('https://' + window.Script + '/exit', JSON.stringify({}));
    })
    
    $("#login-exit-btn").on("click", function(e) {
        $.post('https://' + window.Script + '/exit', JSON.stringify({}));
    })

    $("#add-account").on("click", function() {
        $.post('https://' + window.Script + '/add-account', JSON.stringify({}))
    })

    
})