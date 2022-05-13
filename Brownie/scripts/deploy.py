from brownie import TheyCoin, accounts
from scripts.helpfulScripts import getAccount
from web3 import Web3


def deploy_token():
    account = getAccount()
    initial_supply = Web3.toWei("10000", "ether")
    our_token = TheyCoin.deploy(initial_supply, {"from": account}, publish_source=True)
    print(our_token)


def transfer_to_user(user_address):
    account = getAccount()
    our_token = TheyCoin[-1]
    tx = our_token.payUser(our_token, user_address, Web3.toWei("10", "ether"), {"from": account})
    tx.wait(1)
    print("Sent the tokens!")


def main():
    deploy_token()
    transfer_to_user("")