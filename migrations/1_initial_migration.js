const SwitchMainNet = artifacts.require("SwitchMainNet.sol");

module.exports = function(deployer) {
  deployer.deploy(SwitchMainNet,'0x92e831bbbb22424e0f22eebb8beb126366fa07ce');
};
