//SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

error Staking__TransferFailed();

contract Staking {
    IERC20 public s_stakingToken;

    //a mapping of users to how mmuch they have staked
    mapping(address => uint256) public s_balances;

    //total supply
    uint256 public s_totalSupply;

    constructor (address stakingToken) {
        s_stakingToken = IERC20(stakingToken);  
    }

    function stake(uint256 _amount) external {

        s_balances[msg.sender] += _amount;
        s_totalSupply += _amount;

        //transfers the token to the contract
        bool success = s_stakingToken.transferFrom(msg.sender, address(this), _amount);
        if(!success){
            revert Staking__TransferFailed();
        }
    }

}