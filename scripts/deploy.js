// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  const TokenFactory = await hre.ethers.getContractFactory("ERC20Basic");
  const TokenInstance = await TokenFactory.deploy();
  const CrowFunding = await hre.ethers.getContractFactory("CrowdFund");
  const CrowInstance = await CrowFunding.deploy(TokenInstance.address);

  await TokenInstance.deployed()
  await CrowInstance.deployed();

  console.log(
    `CrowFunding deployed to ${CrowInstance.address}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
