# Internet Decentralized Company (IDC) Smart Contracts

## Simple summary
A standard interface for contracts that enable the creation of a Company in the blockchain. A set of smart contracts for creating and managing a decentralized company on the blockchain, with functionality for shareholder management and treasury operations.

## Abstract
The IDC smart contract system consists of three main contracts: IDCCore, ShareholderManager, and TreasuryManager. These contracts work together to provide a comprehensive solution for running a decentralized company on the blockchain. The system allows for shareholder management through tokenized shares, company fund management, and administrative controls.

## Motivation
Traditional company structures are often centralized, lack transparency, and can be inefficient. The IDC smart contract system aims to address these issues by:

1. Providing a decentralized and transparent way to manage company ownership and funds.
2. Enabling efficient and automated shareholder management through tokenization.
3. Allowing for quick and secure financial transactions.
4. Implementing a flexible administrative structure that can be adapted to various company needs.

## Usage

### Deployment
1. Deploy the IDCCore contract, providing the company name, jurisdiction, and URI for the ERC1155 tokens.
2. The IDCCore contract will automatically deploy ShareholderManager and TreasuryManager contracts.

### Interacting with the Contract
All interactions should be done through the IDCCore contract, which will delegate operations to the appropriate manager contract.

1. Shareholder Management:
   - Mint new shares to an address
   - Burn shares from an address
   - Check if an address is a shareholder

2. Treasury Management:
   - Send funds to the company (by sending ETH to the contract address)
   - Withdraw funds from the company
   - Send funds to another address
   - Check the company's balance

3. Administrative Functions:
   - Set or remove admin rights for an address

## API Description

### IDCCore

#### Constructor
- `constructor(string memory _name, string memory _jurisdiction, string memory _uri)`
  - Initializes the IDC with a name, jurisdiction, and URI for ERC1155 tokens

#### Admin Functions
- `setAdmin(address _address, bool _isAdmin)`
  - Sets or removes admin rights for an address

#### Shareholder Management
- `mintShares(address to, uint256 amount)`
  - Mints new shares to the specified address
- `burnShares(address from, uint256 amount)`
  - Burns shares from the specified address

#### Treasury Management
- `withdraw(uint256 amount)`
  - Withdraws the specified amount from the company's funds
- `sendFunds(address payable recipient, uint256 amount)`
  - Sends the specified amount to the recipient address

### ShareholderManager

- `mintShares(address to, uint256 amount)`
  - Mints new shares to the specified address
- `burnShares(address from, uint256 amount)`
  - Burns shares from the specified address
- `isShareHolder(address account)`
  - Checks if the specified address is a shareholder

### TreasuryManager

- `withdraw(uint256 amount)`
  - Withdraws the specified amount
- `sendFunds(address payable recipient, uint256 amount)`
  - Sends the specified amount to the recipient address
- `getBalance()`
  - Returns the current balance of the treasury

Note: The ShareholderManager and TreasuryManager contracts are owned and controlled by the IDCCore contract. Direct interaction with these contracts should be avoided in favor of using the IDCCore contract's interface.
## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
