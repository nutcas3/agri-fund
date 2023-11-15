import { ethers } from "hardhat";

async function main() {

  // We get the contract to deploy
  const Agrifunding = await ethers.getContractFactory("Agrifunding");
  const agrifunding = await Agrifunding.deploy();

  await agrifunding.deployed();

  console.log("Agrifunding contracts deployed to:", agrifunding.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });


