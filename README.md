<!-- PROJECT LOGO -->
<br />
<p align="center">
  <h3 align="center">Niko</h3>

  <p align="center">
    A Deflationary token with staking rewards
    <br />
  </p>
</p>

<!-- ABOUT THE PROJECT -->
## About The Project
Niko is a simple deflationary ERC20 token with a staking rewards, made just for fun :).
There's a 5% tax on each transactions, 50% of the tax is to burn NKO permanently and the other 50% is used for staking rewards. 

With the staking rewards, holders can lockup their NKO token to earns more NKO, the rewards are from the transactions tax. 

### Built With

Niko is built with
* [Ethereum - Blockchain](https://ethereum.foundation/)
* [Solidity - Solidity Programming Language](https://soliditylang.org/)
* [Truffle Suite - Tools for Smart Contracts](https://www.trufflesuite.com/)

### Prerequisites

* Truffle Suite
  ```sh
  npm install truffle -g
  ```

<!-- GETTING STARTED -->
## Getting Started

This is an example of how you may setup/deploy the smart contracts locally. 

### Installation

1. Clone the repo
   ```sh
   git clone https://github.com/ThalKod/niko_project.git
   ```
2. Install NPM packages
   ```sh
   cd niko_project
   yarn install
   ```
3. Deploy with local testnet
   ```sh
   yarn deploy-test
   ```
4. Deploy on Ropsten testnet
    create a simple env.json with :
    ```JS
    {
      "mnemonic": "....",
      "Alchemy_API_KEY": "...."
    }
    ```
then deploy with:

   ```sh
   yarn deploy-ropsten
   ```
   
   
   <!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE` for more information.
   
