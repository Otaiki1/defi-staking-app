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
    uint256 public constant REWARD_RATE = 100;
    uint256 public s_rewardPerTokenStored;
    uint256 public s_lastUpdateTime;

    modifier updateReward(address account){
        s_rewardPerTokenStored  = rewardPerToken();
        s_lastUpdateTime = block.timestamp;
    }

    constructor (address stakingToken) {
        s_stakingToken = IERC20(stakingToken);  
    }

    function rewardPerToken() public view returns(uint256){
        if(s_totalSupply == 0){
            return s_rewardPerTokenStored;
        }
        return s_rewardPerTokenStored +(((block.timestamp - s_lastUpdateTime) * REWARD_RATE * 1e18)/ s_totalSupply );
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

    function withdraw(uint256 _amount) external {
        s_balances[msg.sender] -= _amount;
        s_totalSupply -= _amount;

        bool success = s_stakingToken.transfer(msg.sender, _amount);
        if(!success){
            revert Staking__TransferFailed();
        }
    }

}