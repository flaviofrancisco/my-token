var KateToken = artifacts.require("./KateToken.sol");

module.exports = function (deployer) {
  deployer.deploy(KateToken, 'KateCoin', 'KTC', 1000000000);
};
