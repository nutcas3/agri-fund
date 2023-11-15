require("@nomiclabs/hardhat-waffle");
require("dotenv").config({ path: ".env" });
require("hardhat-deploy");
require("@nomiclabs/hardhat-ethers");

module.exports = {
  solidity: "0.8.2",
  defaultNetwork: "telos_testnet",
  namedAccounts: {
    deployer: 0,
  },
  networks: {
    telos_testnet: {
      url: "https://testnet.telos.net/evm",
      accounts: [process.env.TELOS_TESTNET_PRIVATE_KEY],
      chainId: 41,
    },
  },
};