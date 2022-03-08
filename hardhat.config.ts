import * as dotenv from "dotenv";
import { HardhatUserConfig, task } from "hardhat/config";
import "solidity-coverage"
import "hardhat-gas-reporter"
import "@typechain/hardhat"
import "@nomiclabs/hardhat-ethers"
import "@nomiclabs/hardhat-waffle"
import '@openzeppelin/hardhat-upgrades';
import "hardhat-contract-sizer"
import "@tenderly/hardhat-tenderly"

import hardhatNetworks from "./hardhat.networks";
import solidityConfiguration from "./hardhat.solidity.config";

dotenv.config();

task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
    const accounts = await hre.ethers.getSigners();
  
    for (const account of accounts) {
      console.log(account.address);
    }
});

const config: HardhatUserConfig = {
    solidity: solidityConfiguration,
    networks: hardhatNetworks,
    paths: {
      artifacts: "./artifacts",
      cache: "./cache",
      sources: "./contracts",
      tests: "./test",
    },
    typechain: {
      outDir: "types",
      target: "ethers-v5",
    },
    gasReporter: {
      enabled: process.env.REPORT_GAS !== undefined,
      currency: "USD",
      token: "ETH",
      gasPriceApi: process.env.GAS_PRICE_API,
      coinmarketcap: process.env.API_KEY
    }
  };
  
  export default config;