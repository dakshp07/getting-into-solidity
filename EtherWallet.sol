pragma solidity >=0.8.4;

contract EtherWallet{
    address payable public owner;
    constructor(){
        owner=payable(msg.sender);
    }
    receive() external payable{}
    function withdraw(uint amt) external{
        require(msg.sender==owner, "caller is not owner");
        owner.transfer(amt);
    }
    function getBalance() external view returns(uint){
        return address(this).balance;
    }
}