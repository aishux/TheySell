from brownie import network, accounts, config
from web3 import Web3

FORKED_LOCAL_ENVIRONMENTS = ["mainnet-fork", "mainnet-fork-dev"]
LOCAL_BLOCKCHAINS = ["development", "ganache-local"]


def getAccount(index=None, id=None):
    if index:
        return accounts[0]

    if id:
        return accounts.load(id)

    if network.show_active() in LOCAL_BLOCKCHAINS or network.show_active() in FORKED_LOCAL_ENVIRONMENTS:
        return accounts[0]

    return accounts.add(config["wallets"]["from_key"])
