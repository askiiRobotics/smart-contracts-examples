var HDWalletProvider = require("truffle-hdwallet-provider");
const path = require('path')

const MNEMONIC = '';
const infuraKey = "";
const ropstenKey = "";
const deployer = "";

module.exports = {
  contracts_directory: path.resolve(__dirname, "contracts"),
  networks: {
    ganache: {
      host: "localhost",
      port: 7545,
      network_id: "*" // Match any network id
    },
    ropsten: {
      provider: function() {
        return new HDWalletProvider(MNEMONIC, "https://ropsten.infura.io/v3/"+ropstenKey)
      },
      network_id: 3,
      gas: 4000000,      //make sure this gas allocation isn't over 4M, which is the max
      skipDryRun: true
    },
    // Useful for private networks
    mainnet: {
      provider: () => new HDWalletProvider(MNEMONIC, `https://mainnet.infura.io/v3/`+infuraKey),
      network_id: 1,   // This network is yours, in the cloud.
      gas: 6700000,           // Gas sent with each transaction (default: ~6700000)
      gasPrice: 42000000000,  // 20 gwei (in wei) (default: 100 gwei)
      from: deployer,        // Account to send txs from (default: accounts[0])
      confirmations: 12,    // # of confs to wait between deployments. (default: 0)
      production: true    // Treats this network as if it was a public net. (default: false)
    },
  },
  plugins: [
    'truffle-plugin-verify'
  ],
  api_keys: {
    etherscan: ''
  },
  // Configure your compilers
  compilers: {
    solc: {
      version: "0.7.5+commit.eb77ed08.Emscripten.clang", // Fetch exact version from solc-bin (default: truffle's version)
    }
  },
};
