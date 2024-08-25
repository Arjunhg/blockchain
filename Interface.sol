// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

interface BluePrint{

    // main functions
    function getTotalSupply() external view returns(uint256);
    function balanceOf(address account) external view returns(uint256);
    function transfer(address recipent, uint256 amount) external returns(bool);
    function transferFrom(address sender, address recipent, uint256 amount ) external returns(bool);
    function allowance(address owner, address spender) external view returns(uint256);
    function approve(address sender, uint256 amount) external returns (bool);

  
    event Transfer(address from, address to, uint256 value);
    event Approval(address owner, address spender, uint256 value);
}