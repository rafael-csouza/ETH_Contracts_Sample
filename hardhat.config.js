require('@nomiclabs/hardhat-waffle');
require('dotenv').config();
require('@nomiclabs/hardhat-etherscan');
require('@nomiclabs/hardhat-ethers');
const dotenv = require('dotenv');
dotenv.config();

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task('accounts', 'Prints the list of accounts', async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(
      `Account: ${account.address}: ${
        (await account.getBalance()) / 1000000000000000000
      } ETH`,
    );
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: '0.8.9',
  // solidity: {
  //   version: '0.8.9',
  //   settings: {
  //     optimizer: {
  //       enabled: true,
  //       runs: 200,
  //     },
  //   },
  // },
  defaultNetwork: 'rinkeby',
  etherscan: {
    apiKey: process.env.ETHERSCAN_KEY,
  },
  networks: {
    rinkeby: {
      gasMultiplier: 2,
      url: process.env.ALCHEMY_RINKEBY_URL,
      accounts: [
        process.env.PRIVATE_KEY10,
        process.env.PRIVATE_KEY1,
        process.env.PRIVATE_KEY2,
        process.env.PRIVATE_KEY3,
        process.env.PRIVATE_KEY4,
      ],
    },
  },
};
