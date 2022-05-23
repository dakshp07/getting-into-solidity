pragma solidity >=0.8.4;

contract Owner {
    address public owner_add;
    constructor(){
        owner_add=msg.sender; // constructors works for first time deploy
    }
    modifier onlyOwner(){
        require(msg.sender==owner_add, "not owner");
        _;
    }
    function setOwner(address newOwner) external onlyOwner{
        require(newOwner!=address(0), "invalid address");
        owner_add=newOwner;
    }
    function onlyOwnerCanCall() external onlyOwner{
        // code
    }
    function anyoneCanCall() external{
        // code
    }
}