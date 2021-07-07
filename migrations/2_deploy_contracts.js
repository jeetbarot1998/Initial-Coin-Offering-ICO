var DappToken = artifacts.require("DappToken");
var DappTokenSale = artifacts.require("DappTokenSale");

module.exports = function (deployer) {
  deployer.deploy(DappToken, 1000000).then(function () {
    // Token price is 0.001 Ether
    var tokenPrice = 1000000000000000;
    return deployer.deploy(DappTokenSale, DappToken.address, tokenPrice);
  });
};
