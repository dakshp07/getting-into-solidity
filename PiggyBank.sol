pragma solidity >=0.8.4;

contract PiggyBank{
    address public owner=msg.sender;
    event Deposit(uint amt);
    event Withdraw(uint amt);
    receive() external payable{
        emit Deposit(msg.value);
    }
    function withdraw() external{
        require(owner==msg.sender, "not owner");
        emit Withdraw(address(this).balance);
        selfdestruct(payable(msg.sender));
    }
}