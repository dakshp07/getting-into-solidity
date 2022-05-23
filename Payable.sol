pragma solidity >=0.8.4;

contract Payable{
    address payable public send;
    constructor(){
        send=payable(msg.sender);
    }
    function deposit() external payable{}
    function getBalance() external view returns(uint){
        return address(this).balance;
    }
}