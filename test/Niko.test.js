const { expect } = require("chai");
const { expectRevert } = require('@openzeppelin/test-helpers');

const Niko = artifacts.require("Niko");
let niko;

const tokenName = "Niko";
const tokenSymbol = "NKO";
const tokenSupply = "1000000000000000000000000";

contract('Niko',  ([owner, stakingAddress, other]) => {
  beforeEach(async () => {
    niko = await Niko.new("1000000000000000000000000");
    niko.setStakingRewardsAddress(stakingAddress);
  });

  it("Should create an ERC20 with the right basic variable", async () => {
    expect((await niko.name()).toString()).to.equal(tokenName);
    expect((await niko.symbol()).toString()).to.equal(tokenSymbol);
    expect((await niko.totalSupply()).toString()).to.equal(tokenSupply);
  });

  it("Should mint new token correctly", async () => {
    await niko.mintToken(owner, "1000000000000000000000000");
    expect((await niko.totalSupply()).toString()).to.equal("2000000000000000000000000");
  });

  it("should prevent non owner from minting new token", async () => {
    await expectRevert(
        niko.mintToken(owner, "100000000000000000000000000", {from: other}),
        'Ownable: caller is not the owner'
    );
  });

  it("Should transfer and burn token correctly", async () => {
    await niko.transfer(other,"250000000000000000000");
    expect((await niko.balanceOf(other)).toString()).to.equal("237500000000000000000");
    expect((await niko.balanceOf(stakingAddress)).toString()).to.equal("6250000000000000000");
    expect((await niko.totalSupply()).toString()).to.equal("999993750000000000000000");
  });

});
