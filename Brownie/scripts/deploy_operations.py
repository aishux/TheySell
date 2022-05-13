from brownie import Operational, config, network
from scripts.helpfulScripts import getAccount, fundWithLink
from web3 import Web3

def deploy_operations():
    account = getAccount()
    deploy_tx = Operational.deploy(
        config["networks"][network.show_active()]["vrf_coordinator"],
        config["networks"][network.show_active()]["link_token"],
        config["networks"][network.show_active()]["fee"],
        config["networks"][network.show_active()]["key_hash"],
        {"from":account}, 
        publish_source=config["networks"][network.show_active()]["verify"])
    print(deploy_tx)


def add_goods(seller_address, name, token_amount, image_uri, description):
    account = getAccount()
    operationals = Operational[-1]
    tx_fund = fundWithLink(operationals, amount=config["networks"][network.show_active()]["fee"])
    tx_fund.wait(1)
    tx_add = operationals.addGoods(seller_address, name, token_amount, image_uri, description, {"from": account})
    tx_add.wait(1)
    print("The good will be added and displayed soon!")


def get_all_goods():
    operationals = Operational[-1]
    print("All goods are:\n")
    all_items = operationals.getAllGoods()
    for item in all_items:
        if item[0] != '0x0000000000000000000000000000000000000000':
            print(item)
            print("\n")


def get_good_by_seller(seller_address):
    operationals = Operational[-1]
    print(f"\nAll goods of seller {seller_address} are:\n")

    all_items = operationals.getGoodBySeller(seller_address)
    for item in all_items:
        if item[0] != '0x0000000000000000000000000000000000000000':
            print(item)
            print("\n")


def get_specific_good(index):
    operationals = Operational[-1]
    item = operationals.all_goods(index)
    return item


def delete_good(seller_address, index1, index2):
    account = getAccount()
    operationals = Operational[-1]
    if get_specific_good(index1)[0] != "0x0000000000000000000000000000000000000000":
        tx_delete = operationals.deleteGood(seller_address, index1, index2, {"from": account})
        tx_delete.wait(1)
        print("Deleted the specified good!")
    else:
        print("Item is already deleted")


def main():

    # deploy_operations()

    # add_goods("", "Test good1", 10, "", "This is first test")

    # get_all_goods()

    # get_good_by_seller("")

    # delete_good("", 0, 0)

    # get_all_goods()

    # get_good_by_seller("")

    # get_good_by_seller("")