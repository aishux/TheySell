// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Operational is Ownable{

    constructor(){}

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

    function addGoods(
        address _seller_address,
        uint256 _id,
        string memory _name,
        uint256 _token_amount,
        string memory _image_uri,
        string memory _description
    ) public {
        Goods memory new_good = Goods(
            _seller_address,
            _id,
            _name,
            _token_amount,
            _image_uri,
            _description,
            all_goods.length,
            seller_to_goods[_seller_address].length
        );

        seller_to_goods[_seller_address].push(new_good);
        all_goods.push(new_good);
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
}