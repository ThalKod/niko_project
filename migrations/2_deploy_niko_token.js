const Niko = artifacts.require("Niko");

module.exports = function(deployer){
  deployer.deploy(Niko, "1000000000000000000000000")
};
