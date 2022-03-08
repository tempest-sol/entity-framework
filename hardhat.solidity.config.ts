import { MultiSolcUserConfig } from "hardhat/src/types/config";

const solidityConfiguration: MultiSolcUserConfig = {
  compilers: [
    {
      version: "0.8.4",
      settings: {
        metadata: {
          bytecodeHash: "none",
        },
        optimizer: {
          enabled: true,
          runs: 1000,
        },
      },
    },
    {
      version: "0.8.12",
      settings: {
        metadata: {
          bytecodeHash: "none",
        },
        optimizer: {
          enabled: true,
          runs: 1000,
        },
      },
    },
    { 
      version: "0.4.0",
      settings: {
        metadata: {
          bytecodeHash: "none",
        },
        optimizer: {
          enabled: true,
          runs: 1000,
        },
      },
    },
    {
      version: "0.7.5",
      settings: {
        metadata: {
          bytecodeHash: "none",
        },
        optimizer: {
          enabled: true,
          runs: 1000,
        },
      },
    }
  ],
  overrides: undefined
}

export default solidityConfiguration;
