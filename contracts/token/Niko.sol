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

    address _stakingRewards;
    uint256 _burnRate = 5; // 0-100 %

    /**
     * @dev initializes a new Niko instance
     *
     * @param initialSupply     initial supply of NKO
     */
    constructor(uint256 initialSupply) ERC20(NAME, SYMBOL){
        _mint(msg.sender, initialSupply);
    }

    /**
     * @dev mint new NKO token, only contract owner can mint
     *
     * @param to          address for the new minted token
     * @param amount      mount of NKO to mint
     */
    function mintToken(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    /**
     * @dev change staking rewards address
     *
     * @param newAddress    new staking rewards address
     */
    function setStakingRewardsAddress(address newAddress) public onlyOwner {
        _stakingRewards = newAddress;
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`, burn and take rewards
     *
     * @param sender      sender of the token
     * @param recipient   recipient of the token
     * @param amount      token amount to send
     */
    function _transfer(address sender, address recipient, uint256 amount) internal override {
        require(balanceOf(sender) >= amount);

        uint256 burnAmount = _deductionAmount(amount);
        uint256 amountMinusBurn = amount.sub(burnAmount);

        if(burnAmount > 0){
            _handleTokenBurn(sender, burnAmount);
        }

        super._transfer(sender, recipient, amountMinusBurn);
    }

    /**
     * @dev burn and mint new token as staking rewards
     *
     * @param sender      send token
     * @param amount      token amount to send
     */
    function _handleTokenBurn(address sender, uint256 amount) internal {
        _burn(sender, amount);
        _mint(_stakingRewards, amount.div(2));
    }

    /**
     * @dev determine the amount to burn and send to rewards contract
     *
     * @param amount   total amount to calcuate with
     */
    function _deductionAmount(uint256 amount) internal view returns (uint256) {
        uint256 deduction = 0;
        uint256 minSupply = 50000 * 10 ** (18);

        if(totalSupply() > minSupply && msg.sender != address(0)){
            deduction = amount.mul(_burnRate).div(100);
        }

        return deduction;
    }

}
