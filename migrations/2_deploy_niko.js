const Niko = artifacts.require("Niko");
const StakingRewards = artifacts.require("StakingRewards");

module.exports = async function(deployer){
  await deployer.deploy(Niko, "1000000000000000000000000");
  await deployer.deploy(StakingRewards, Niko.address);

  const nikoInstance = await Niko.deployed();
  await nikoInstance.setStakingRewardsAddress(StakingRewards.address);
};
