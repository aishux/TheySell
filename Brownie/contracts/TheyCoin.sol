// contracts/FarmToken.sol
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";

contract TheyCoin is ERC20, ChainlinkClient {
    address owner;
    using Chainlink for Chainlink.Request;

    uint256 public volume;

    address private oracle;
    bytes32 private jobId;
    uint256 private fee;

    address token_address;

    struct Goods {
        uint256 id;
        string name;
        uint256 token_amount;
        string image_uri;
        string description;
    }

    Goods[] public all_goods;

    mapping(bytes32 => address) public requestId_toSender;
    mapping(address => uint256) public address_to_ethgiven;
    mapping(address => Goods[]) public seller_to_goods;

    constructor(uint256 initialSupply) ERC20("TheyCoin", "TC") {
        _mint(msg.sender, initialSupply);
        _approve(msg.sender, address(this), initialSupply);
        owner = msg.sender;

        // For connecting external API
        setPublicChainlinkToken();
        oracle = 0x3A56aE4a2831C3d3514b5D7Af5578E45eBDb7a40;
        jobId = "3b7ca0d48c7a4b2da9268456665d11ae";
        fee = 0.01 * 10**18;
    }

    // Later remove this "_to_user" with msg.sender and also remove functional arg
    function payUser(address _token, address _to_user) public payable {
        token_address = _token;
        bytes32 requestId = requestVolumeData();
        requestId_toSender[requestId] = _to_user;
        address_to_ethgiven[_to_user] = msg.value;
    }

    function requestVolumeData() public returns (bytes32 requestId) {
        Chainlink.Request memory request = buildChainlinkRequest(
            jobId,
            address(this),
            this.fulfill.selector
        );

        // Set the URL to perform the GET request on
        request.add(
            "get",
            "https://min-api.cryptocompare.com/data/price?fsym=INR&tsyms=ETH"
        );

        request.add("path", "ETH");

        // Multiply the result by 1000000000000000000 to remove decimals
        int256 timesAmount = 10**18;
        request.addInt("times", timesAmount);

        // Sends the request
        return sendChainlinkRequestTo(oracle, request, fee);
    }

    /**
     * Receive the response in the form of uint256
     */
    function fulfill(bytes32 _requestId, uint256 _volume)
        public
        recordChainlinkFulfillment(_requestId)
    {
        volume = _volume;

        uint256 amount_in_eth = address_to_ethgiven[
            requestId_toSender[_requestId]
        ];

        require(amount_in_eth > 0, "Insufficient ETH");

        uint256 amount_of_tokens = ((amount_in_eth / _volume) * (10**18)) / 10;

        IERC20 paymentToken = IERC20(token_address);

        require(amount_of_tokens > 0, "Tokens too less!");

        require(
            paymentToken.transferFrom(
                owner,
                requestId_toSender[_requestId],
                amount_of_tokens
            ),
            "transfer Failed"
        );

        address_to_ethgiven[requestId_toSender[_requestId]] = 0;
    }

    function addGoods(
        address _seller_address,
        uint256 _id,
        string memory _name,
        uint256 _token_amount,
        string memory _image_uri,
        string memory _description
    ) public {
        Goods memory new_good = Goods(_id, _name, _token_amount, _image_uri, _description);
        seller_to_goods[_seller_address].push(new_good);
        all_goods.push(new_good);
    }

    function getAllGoods() public view returns(Goods[] memory){
        return all_goods;
    }

    function getGoodBySeller(address _seller_address) view public returns(Goods[] memory){
        return seller_to_goods[_seller_address];
    }
}
