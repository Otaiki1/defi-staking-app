//SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

error Staking__TransferFailed();

contract Staking {
    IERC20 public s_stakingToken;

    //a mapping of users to how mmuch they have staked
    mapping(address => uint256) public s_balances;
    
    //a mapping of how much each address has already been paid
    mapping(address => uint256) public s_userRewardPerTokenPaid;

    //a mapping of how much rewards each address has
    mapping(address => uint256) public s_rewards;

    //total supply
    uint256 public s_totalSupply;
    uint256 public constant REWARD_RATE = 100;
    uint256 public s_rewardPerTokenStored;
    uint256 public s_lastUpdateTime;

    modifier updateReward(address account){
        s_rewardPerTokenStored  = rewardPerToken();
        s_lastUpdateTime = block.timestamp;
        s_rewards[account] = earned(account);
        s_userRewardPerTokenPaid[account] = s_rewardPerTokenStored;

        _;
    }

    constructor (address stakingToken) {
        s_stakingToken = IERC20(stakingToken);  
    }

    function earned(address _account) public view returns(uint256){
       uint256 currentBalance  = s_balances[_account];

       //how much they have been paid already
        uint256 amountPaid = s_userRewardPerTokenPaid[_account];
        uint256 currentRewardPerToken = rewardPerToken();
        uint256 pastRewards = s_rewards[_account];

        uint256 _earned = ((currentBalance * (currentRewardPerToken - amountPaid) / 1e18) +
        pastRewards);
        return _earned;
    }

    function rewardPerToken() public view returns(uint256){
        if(s_totalSupply == 0){
            return s_rewardPerTokenStored;
        }
        return s_rewardPerTokenStored +(((block.timestamp - s_lastUpdateTime) * REWARD_RATE * 1e18)/ s_totalSupply );   
    }

    function stake(uint256 _amount) updateReward(msg.sender) external {

        s_balances[msg.sender] += _amount;
        s_totalSupply += _amount;

        //transfers the token to the contract
        bool success = s_stakingToken.transferFrom(msg.sender, address(this), _amount);
        if(!success){
            revert Staking__TransferFailed();
        }
    }

    function withdraw(uint256 _amount) updateReward(msg.sender) external {
        s_balances[msg.sender] -= _amount;
        s_totalSupply -= _amount;

        bool success = s_stakingToken.transfer(msg.sender, _amount);
        if(!success){
            revert Staking__TransferFailed();
        }
    }

}