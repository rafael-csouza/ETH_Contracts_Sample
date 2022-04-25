const hre = require('hardhat');

let contractName = 'nft-tutorial';

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log(`Deploying contracts with the account: ${deployer.address}`);
  console.log(`Account balance: ${(await deployer.getBalance()).toString()}`);

  const ContractFactory = await hre.ethers.getContractFactory(contractName);
  const contractFactory = await ContractFactory.deploy();
  await contractFactory.deployed();

  console.log('Contract deployed to:', contractFactory.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
