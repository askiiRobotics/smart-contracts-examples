// module.exports = {
//   networks: {
//     development: {
//       protocol: 'http',
//       host: 'localhost',
//       port: 8545,
//       gas: 5000000,
//       gasPrice: 5e9,
//       networkId: '*',
//     },
//   },
// };

const { projectId, mnemonic } = require('./secrets.json');
const HDWalletProvider = require('@truffle/hdwallet-provider');

module.exports = {
  networks: {
    ropstenjs: {
      provider: () =>
        new HDWalletProvider(mnemonic, "https://ropsten.infura.io/v3/"+projectId),
      network_id: '3',
    },
    dummy: {
      provider: () =>
        new HDWalletProvider(mnemonic,'http://localhost'),
      network_id: '3',
    },
    mainnet: {
      provider: () =>
        new HDWalletProvider(mnemonic, "https://mainnet.infura.io/v3/"+projectId),
      network_id: '1',
    },
  },
};