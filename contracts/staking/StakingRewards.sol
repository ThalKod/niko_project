// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

/**
 * @notice basic implementation of the Staking Mechanism for Niko Token
 * @author Thal Marcelin
 */
contract StakingRewards is Ownable {
    using SafeMath for uint256;

    IERC20 token;
    address[] internal stakeHolders;
    mapping(address => uint256) internal stakes;
    mapping(address => uint256) internal rewards;

    /**
     * @dev initializes a new Staking Rewards instance
     *
     * @param _tokenAddress     initial supply of NKO
     */
    constructor(address _tokenAddress){
        token = ERC20(_tokenAddress);
    }

    /**
    * @dev retrieve the stake for a stakeholder.
    *
    * @param stakeHolder The stakeholder to retrieve the stake for.
    * @return uint256 the amount of Niko staked.
    */
    function getStakes(address stakeHolder) public view returns(uint256) {
        return stakes[stakeHolder];
    }

    /**
    * @notice a method to get the total user stked token
    * @return uint256 the aggregated stakes from all stakeholders.
    */
    function getTotalStakes() public view returns(uint256) {
        uint256 totalStakes = 0;
        for(uint256 i; i < stakeHolders.length; i++){
            totalStakes = totalStakes.add(stakes[stakeHolders[i]]);
        }
        return totalStakes;
    }

    /**
    * @dev a method for a stakeholder to create a stake.
    * @param _stake The size of the stake to be created.
    */
    function createStake(uint256 _stake) public {
        require(token.transferFrom(msg.sender, address(this), _stake));

        if(stakes[msg.sender] == 0) _addStakeHolder(msg.sender);
        stakes[msg.sender] = stakes[msg.sender].add(_stake);
    }

    /**
    * @notice  method for a stakeholder to remove a stake.
    * @param _stake The size of the stake to be removed.
    */
    function removeStake(uint256 _stake) public {
        require(stakes[msg.sender] > 0);

        stakes[msg.sender] = stakes[msg.sender].sub(_stake);
        if(stakes[msg.sender] == 0) _removeStakeHolder(msg.sender);
        token.transfer(msg.sender, _stake);
    }

    /**
    * @notice function to check if an address is already a stakeholder
    *
    * @param _address    the address to verify.
    * @return bool, uint256 whether the address is a stakeholder,
    * and if yes its position in the stakeholders array.
    */
    function isStakeHolder(address _address) public view returns(bool, uint256) {
        for(uint256 i = 0; i < stakeHolders.length; i++){
            if(_address == stakeHolders[i]) return (true, i);
        }
        return (false, 0);
    }

    /**
    * @notice  to add a stakeholder.
    * @param _stakeHolder The stakeholder to add.
    */
    function _addStakeHolder(address _stakeHolder) internal {
        (bool isStaking,) = isStakeHolder(_stakeHolder);
        if(!isStaking) stakeHolders.push(_stakeHolder);
    }

    /**
    * @notice to remove a stakeholder.
    * @param _stakeHolder the stakeholder to remove.
    */
    function _removeStakeHolder(address _stakeHolder) internal {
        (bool isStaking, uint256 i) = isStakeHolder(_stakeHolder);
        if(isStaking){
            stakeHolders[i] = stakeHolders[stakeHolders.length - 1];
            stakeHolders.pop();
        }
    }

    /**
    * @notice A method to allow a staker to check his rewards.
    * @param _stakeHolder The stakeholder to check rewards for.
    */
    function getRewards(address _stakeHolder) public view returns(uint256) {
        return rewards[_stakeHolder];
    }

    /**
    * @notice A method to the sum the rewards from all stakeholders.
    * @return uint256 The aggregated rewards from all stakeholders.
    */
    function getTotalOwedRewards() public view returns(uint256) {
        uint256 _totalRewards = 0;
        for(uint256 i = 0; i < stakeHolders.length; i++){
            _totalRewards = _totalRewards.add(rewards[stakeHolders[i]]);
        }

        return _totalRewards;
    }

    /**
   * @notice A  method that calculates the rewards for each stakeholder.
   * @param _stakeHolder The stakeholder to calculate rewards for.
   */
    function calculateRewards(address _stakeHolder) internal view returns(uint256) {
        uint256 totalStakes = getTotalStakes();
        uint256 totalRewards = token.balanceOf(address(this)).sub(totalStakes);
        uint256 totalAvailableRewards = totalRewards.sub(getTotalOwedRewards());

        uint256 stakedAmount = stakes[_stakeHolder];
        uint256 holderStakedPercentage = stakedAmount.mul(100).div(totalStakes);

        return totalAvailableRewards.mul(holderStakedPercentage).div(100);
    }


    /**
   * @notice to distribute rewards to all stakeholders.
   */
    function distributeRewards() public onlyOwner {
        for(uint256 i; i < stakeHolders.length; i++){
            uint256 reward = calculateRewards(stakeHolders[i]);
            rewards[stakeHolders[i]] = rewards[stakeHolders[i]].add(reward);
        }
    }

    /**
    * @notice to allow a stakeholders to withdraw their rewards.
    */
    function claimRewards() public {
        uint256 reward = rewards[msg.sender];
        token.transfer(msg.sender, reward);
        rewards[msg.sender] = 0;
    }

}
