// a simple vault where you just put your money for some period of time
pragma solidity >=0.8.4;

contract SimpleVault{
    address public owner;
    constructor(){
        owner=msg.sender;
    }
    struct vault{
        uint amt;
        uint256 timeLocked;
    }
    modifier onlyOwner(){
        require(msg.sender==owner, "not the owner");
        _;
    }
    uint counter=1;
    mapping(uint=>vault) public lockers;
    function deposit(uint256 _timestamp)public payable onlyOwner{
        lockers[counter].amt=msg.value;
        lockers[counter].timeLocked=_timestamp;
        counter++;
    }
    function withdraw(uint _lockernumber) public onlyOwner{
        require(block.timestamp>=lockers[_lockernumber].timeLocked, "cant withdraw");
        payable(owner).transfer(lockers[_lockernumber].amt);
    }
}