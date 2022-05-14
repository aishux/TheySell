const web = new Web3("https://rinkeby.infura.io/v3/")
token_contract_details = JSON.parse(localStorage.getItem("token_contract"))
operations_contract_details = JSON.parse(localStorage.getItem("operations_contract"))
var token_contract = new web.eth.Contract(token_contract_details[0], token_contract_details[1])
var operations_contract = new web.eth.Contract(operations_contract_details[0], operations_contract_details[1])

getAllGoods()

async function getAllGoods() {
    var $main_div = $("#items_container")
    var $row_item = $('<div class="row"></div>')
    seller_address = $("#seller_address").text()
    all_goods = await operations_contract.methods.getGoodBySeller(seller_address).call()
    for (let index = 0; index < all_goods.length; index++) {
        $row_item.append(`
            <div class="column">
            <div class="card">
                <img src="${all_goods[index].image_uri}" alt="Mountains" style="width:100%; height:150px;border:solid">
                <h3>${all_goods[index].name}</h3>
                <p>${all_goods[index].description}</p>
                <a href="/products/${all_goods[index].is}"><button id="qv${all_goods[index].id}"class="btn btn-primary">QuickView</button></a>
            </div>
            </div>
        `)

        if (index > 0 && index % 3 == 0 && index != all_goods.length) {
            $main_div.append($row_item)
            $row_item = $('<div class="row"></div>')
        }

    }
    $main_div.append($row_item)
}