const hre = require("hardhat");

async function main() {

  // We get the contract to deploy
  const Agrifunding = await hre.ethers.getContractFactory("Agrifunding");
  const agrifunding = await Agrifunding.deploy();

  await agrifunding.waitForDeployment();

  console.log("AgriFunding deployed to:", agrifunding.getAddress);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
