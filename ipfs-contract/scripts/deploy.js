const { ethers } = require("hardhat");
require("dotenv").config();

async function main() {
  const metadataURL = "ipfs://QmNruSSt4c5dZGMH4MvvpK6aV7mceHPUaSCuK6RCAMySbo/";
  const lW3Punkcontract = await ethers.getContractFactory("LW3Punks");
  const deployedLW3 = await lW3Punkcontract.deploy(metadataURL);
  await deployedLW3.deployed();

  console.log(`LW3 punks contract address ${deployedLW3.address}`);
}

main().then(() =>
  process.exit(0).catch((error) => {
    console.log(error);
    process.exit(1);
  })
);
