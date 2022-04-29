const hre = require('hardhat');

//CHANGE NAME CONTRACT DEPLOY
let contractName = 'StaycoolWorlds';

async function main(contractName) {
  const [deployer] = await ethers.getSigners();
  console.log(`Deploying address: ${deployer.address}`);
  console.log(
    `Address balance: ${(
      (await deployer.getBalance()) / 1000000000000000000
    ).toString()} ETH`,
  );

  const ContractFactory = await hre.ethers.getContractFactory(contractName);
  const contractFactory = await ContractFactory.deploy();
  await contractFactory.deployed();

  console.log('Contract address:', contractFactory.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main(contractName)
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
