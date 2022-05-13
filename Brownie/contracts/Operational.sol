// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

contract Operational is VRFConsumerBase, Ownable {
    uint256 public fee;
    bytes32 public keyhash;

    struct Goods {
        address good_owner;
        uint256 id;
        string name;
        uint256 token_amount;
        string image_uri;
        string description;
        uint256 index_all_goods;
        uint256 index_seller_goods;
    }

    Goods[] public all_goods;

    mapping(address => Goods[]) public seller_to_goods;
    mapping(bytes32 => Goods) public requestId_to_good;
    mapping(uint256 => Goods) public id_to_good;

    constructor(
        address _vrfCoordinator,
        address _link,
        uint256 _fee,
        bytes32 _keyhash
    ) public VRFConsumerBase(_vrfCoordinator, _link) {
        fee = _fee;
        keyhash = _keyhash;
    }
    
    function addGoods(
        address _seller_address,
        string memory _name,
        uint256 _token_amount,
        string memory _image_uri,
        string memory _description
    ) public {
        Goods memory new_good = Goods(
            _seller_address,
            1,
            _name,
            _token_amount,
            _image_uri,
            _description,
            all_goods.length,
            seller_to_goods[_seller_address].length
        );

        bytes32 requestId = requestRandomness(keyhash, fee);
        requestId_to_good[requestId] = new_good;
    }

    function getAllGoods() public view returns (Goods[] memory) {
        return all_goods;
    }

    function getGoodBySeller(address _seller_address)
        public
        view
        returns (Goods[] memory)
    {
        return seller_to_goods[_seller_address];
    }

    function deleteGood(
        address _seller_address,
        uint256 index1,
        uint256 index2
    ) public onlyOwner {
        require(index1 < all_goods.length, "Index doesn't exists");
        require(
            index2 < seller_to_goods[_seller_address].length,
            "Index doesn't exists"
        );
        delete all_goods[index1];
        delete seller_to_goods[_seller_address][index2];
    }

    function fulfillRandomness(bytes32 _requestId, uint256 _randomness)
        internal
        override
    {
        Goods memory new_good = requestId_to_good[_requestId];
        new_good.id = _randomness;
        new_good.index_all_goods = all_goods.length;
        id_to_good[_randomness] = new_good;
        seller_to_goods[new_good.good_owner].push(new_good);
        all_goods.push(new_good);
    }
}
