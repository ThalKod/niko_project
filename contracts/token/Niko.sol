// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

/**
 * @notice implementation of the Niko token contract
 * @author Thal Marcelin
 */
contract Niko is ERC20, Ownable {
    using SafeMath for uint256;

    string internal constant NAME = "Niko";
    string internal constant SYMBOL = "NKO";

    address stakingRewards;
    uint256 burnRate = 5; // 0-100 %

    /**
     * @dev initializes a new Niko instance
     *
     * @param _initialSupply     initial supply of NKO
     */
    constructor(uint256 _initialSupply) ERC20(NAME, SYMBOL){
        _mint(msg.sender, _initialSupply);
    }

    /**
     * @dev mint new NKO token, only contract owner can mint
     *
     * @param _to          address for the new minted token
     * @param _amount      mount of NKO to mint
     */
    function mintToken(address _to, uint256 _amount) public onlyOwner {
        _mint(_to, _amount);
    }

    /**
     * @dev change staking rewards address
     *
     * @param _newAddress    new staking rewards address
     */
    function setStakingRewardsAddress(address _newAddress) public onlyOwner {
        stakingRewards = _newAddress;
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`, burn and take rewards
     *
     * @param _sender      sender of the token
     * @param _recipient   recipient of the token
     * @param _amount      token amount to send
     */
    function _transfer(address _sender, address _recipient, uint256 _amount) internal override {
        require(balanceOf(_sender) >= _amount);

        uint256 burnAmount = _deductionAmount(_amount, _recipient);
        uint256 amountMinusBurn = _amount.sub(burnAmount);

        if(burnAmount > 0){
            _handleTokenBurn(_sender, burnAmount);
        }

        super._transfer(_sender, _recipient, amountMinusBurn);
    }

    /**
     * @dev burn and mint new token as staking rewards
     *
     * @param _sender      send token
     * @param _amount      token amount to send
     */
    function _handleTokenBurn(address _sender, uint256 _amount) internal {
        _burn(_sender, _amount);
        _mint(stakingRewards, _amount.div(2));
    }

    /**
     * @dev determine the amount to burn and send to rewards contract
     *
     * @param _amount   total amount to calcuate with
     */
    function _deductionAmount(uint256 _amount, address _recipient) internal view returns (uint256) {
        uint256 deduction = 0;
        uint256 minSupply = 50000 * 10 ** (18);

        if(totalSupply() > minSupply && msg.sender != address(0) && msg.sender != stakingRewards && _recipient != stakingRewards){
            deduction = _amount.mul(burnRate).div(100);
        }

        return deduction;
    }

}
