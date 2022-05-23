pragma solidity >=0.8.4;

contract Event{
    event Message(address indexed _to, address indexed _from, string message);
    function sendMessage(address _to, string calldata message) external{
        emit Message(_to, msg.sender, message);
    }
}