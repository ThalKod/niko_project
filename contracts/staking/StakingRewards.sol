// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

/**
 * @notice basic implementation of the Staking Mechanism for Niko Token
 * @author Thal Marcelin
 */
contract StakingRewards {
    using SafeMath for uint256;

    IERC20 token;
    address[] internal stakeHolders;
    mapping(address => uint256) internal stakes;

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

        if(stakes[msg.sender] == 0) addStakeHolder(msg.sender);
        stakes[msg.sender] = stakes[msg.sender].add(_stake);
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
    function addStakeHolder(address _stakeHolder) public {
        (bool isStaking,) = isStakeHolder(_stakeHolder);
        if(!isStaking) stakeHolders.push(_stakeHolder);
    }

    /**
    * @notice to remove a stakeholder.
    * @param _stakeHolder the stakeholder to remove.
    */
    function removeStakeHolder(address _stakeHolder) public {
        (bool isStaking, uint256 i) = isStakeHolder(_stakeHolder);
        if(isStaking){
            stakeHolders[i] = stakeHolders[stakeHolders.length - 1];
            stakeHolders.pop();
        }
    }

}
