var SomeTokenTimelockFactory = artifacts.require("SomeTokenTimelockFactory");
var SomeToken = artifacts.require("SomeToken");

module.exports = function(deployer) {
  deployer.deploy(SomeToken).then(function() {
    return deployer.deploy(SomeTokenTimelockFactory, SomeToken.address);
  });
};
