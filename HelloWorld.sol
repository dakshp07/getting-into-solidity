pragma solidity >=0.8.4;

contract HelloWorld{
    uint256 etherIown=0;
    function setValue(uint256 k) public 
    {
        etherIown=k;
    }
    function getValue() public view returns (uint256)
    {
        return etherIown;
    }
}