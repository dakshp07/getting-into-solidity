pragma solidity >=0.8.4;

contract Counter{
    uint public cnt;
    function inc() external
    {
        cnt+=1;
    }
    function dec() external
    {
        cnt-=1;
    }
}