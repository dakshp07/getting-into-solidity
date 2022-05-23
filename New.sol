pragma solidity >=0.8.4;

contract Account{
    address public bank;
    address public owner;
    constructor(address _owner) payable{
        bank=msg.sender;
        owner=_owner;
    }
}

contract AccountFactory{
    Account[] public accounts;
    function createAccount(address _owner) external payable{
        Account account=new Account{value: 111}(_owner);
        accounts.push(account);
    }
}