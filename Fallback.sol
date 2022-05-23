pragma solidity >=0.8.4;

contract Fallback{
    event log(string fucn, address sender, uint val, bytes data);
    fallback() external payable{
        emit log("fallback", msg.sender, msg.value, msg.data);
    } 
    receive() external payable{
        emit log("recieve", msg.sender, msg.value, "");
    }
}