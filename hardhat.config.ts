import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox-viem";
import { version } from "hardhat";
//import "hardhat-gas-reporter";
import 'dotenv/config';


const config: HardhatUserConfig = {
  solidity: {
    compilers: [
      {
        version: "0.8.20",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
    ],
  },
  networks: {
    hardhat: {
      forking: {
        url: "https://arbitrum-sepolia.infura.io/v3/" + process.env.INFURA_API_KEY,
      }
    }
  }/* ,
  gasReporter: {
    enabled: true,
  } */
};

export default config;
