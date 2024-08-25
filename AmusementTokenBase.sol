// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "./TokenBase.sol";

contract AmusementTokenBase is TokenBase{

    address public immutable owner;
    bool public parkOpen;
    uint256 public constant TOKENS_PER_ETH = 100;

    modifier onlyOwner(){
        require(msg.sender == owner, "Only Amusemant land owner can call this function");
        _;
    }
    modifier whenParkOpen(){
        require(parkOpen, "Amusement land is closed");
        _;
    }

    constructor(string memory _name, string memory _symbol)
    TokenBase(_name, _symbol){

        owner = msg.sender;

    }
    function openPark() public onlyOwner{
        parkOpen = true;
    }
    function closePark() public onlyOwner{
        parkOpen = false;
    }
    function buyToken(uint256 amount) public payable whenParkOpen{

        require(msg.value * TOKENS_PER_ETH >= amount, "Amusement: Not enough ETH send");
        _mint(msg.sender, amount);
    }

    function useTokensForRide(uint256 amount) public whenParkOpen{
        _burn(msg.sender, amount);
    }

    function transfer(address recipent, uint256 amount) public virtual override whenParkOpen returns(bool){
        return super.transfer(recipent, amount);
    }
    function transferFrom(address sender, address recipent, uint256 amount) public virtual override whenParkOpen returns(bool){
        return super.transferFrom(sender, recipent, amount);
    }
}

