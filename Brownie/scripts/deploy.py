from brownie import TheyCoin, config, network
from scripts.helpfulScripts import getAccount
from web3 import Web3
import requests
from scripts.helpfulScripts import fundWithLink


def deploy_token():
    account = getAccount()
    initial_supply = Web3.toWei("10000", "ether")
    our_token = TheyCoin.deploy(initial_supply, {"from": account}, publish_source=config["networks"][network.show_active()]["verify"])
    print(our_token)


def transfer_to_user(user_address, amount):
    res = requests.get("https://min-api.cryptocompare.com/data/price?fsym=INR&tsyms=ETH").json()
    inr_to_eth = res["ETH"] * amount
    account = getAccount()
    our_token = TheyCoin[-1]
    tx_fund = fundWithLink(our_token, amount=Web3.toWei(0.01, "ether"))
    tx_fund.wait(1)
    tx = our_token.payUser(our_token, user_address, {"from": account, "value": Web3.toWei(inr_to_eth, "ether")})
    tx.wait(1)
    print("Transfer has been made!")
    print("Tokens will be sent soon!")


def add_goods(seller_address, id, name, token_amount, image_uri, description):
    account = getAccount()
    our_token = TheyCoin[-1]
    tx_add = our_token.addGoods(seller_address, id, name, token_amount, image_uri, description, {"from": account})
    tx_add.wait(1)
    print("Added the good!")


def get_all_goods():
    our_token = TheyCoin[-1]
    print("All goods are:\n")
    all_items = our_token.getAllGoods()
    for item in all_items:
        print(item)
        print("\n")

    # length = our_token.all_goods_length()
    # for i in range(0, length):
    #     print(our_token.all_goods(i))


def get_good_by_seller(seller_address):
    our_token = TheyCoin[-1]
    print(f"\nAll goods of seller {seller_address} are:\n")
    # length = our_token.seller_to_goods_length(seller_address)
    # for i in range(0, length):
    #     print(our_token.seller_to_goods(seller_address, i))

    all_items = our_token.getGoodBySeller("")
    for item in all_items:
        print(item)
        print("\n")


def main():
    # deploy_token()
    
    # transfer_to_user("", 500)

    # add_goods("", 3, "Test good3", 15, "https://ipfs.io/ipfs/?filename=0-PUG.json", "This is third test")

    get_all_goods()

    # get_good_by_seller("")

    # get_good_by_seller("")
