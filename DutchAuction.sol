// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;

interface IERC721{
    function transferFrom(address _from, address _to, uint _nftId) external;
}

contract DutchAuction{
    uint private constant DURATION=7 days;
    IERC721 public immutable nft;
    uint immutable nftId;
    address payable public immutable seller;
    uint public immutable startingAmount;
    uint public immutable startingAt;
    uint public immutable expiresAt;
    uint public immutable discountRate;

    constructor(uint _startingAmount, uint _discountRate, address _nft, uint _nftId){
        seller=payable(msg.sender);
        startingAmount = _startingAmount;
        startingAt=block.timestamp;
        expiresAt=block.timestamp+DURATION;
        require(_startingAmount>=_discountRate*DURATION, "starting price < discount");
        discountRate = _discountRate;
        nft=IERC721(_nft);
        nftId=_nftId;
    }
    function getPrice() public view returns(uint){
        uint timeElapsed=block.timestamp-startingAt;
        uint dis=discountRate*timeElapsed;
        return startingAmount-dis;
    }
    function buy() external payable{
        require(block.timestamp<=expiresAt, "auction expired");
        uint price=getPrice();
        require(msg.value>=price, "ETH<price");
        nft.transferFrom(seller, msg.sender, nftId);
        uint refund=msg.value-price;
        if(refund>0)
        {
            payable(msg.sender).transfer(refund);
        }
        selfdestruct(seller); // closes auction by deleting contract and also sends remaining ETH on contract to seller's account
    }
}