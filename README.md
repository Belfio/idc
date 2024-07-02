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
- Deploy the IDCCore contract, providing the company name, jurisdiction, and URI for the ERC1155 tokens.
- The IDCCore contract will automatically deploy ShareholderManager and TreasuryManager contracts.

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

## Implementation notes
This implementation:

- Uses OpenZeppelin's Governor contract and several extensions for comprehensive DAO functionality.
- Implements a custom ShareToken contract that extends ERC1155 and ERC1155Votes for token-based voting.
- Keeps the TreasuryManager for handling funds.
- Integrates all these components in the IDCCore contract.

Key points:

- The ShareToken contract represents shares as ERC1155 tokens and supports voting.
- The Governor contract provides full DAO functionality including proposal creation, voting, and execution.
- The TreasuryManager handles fund management, controlled by governance decisions.
- Governance functions (like minting/burning shares, withdrawing/sending funds) are protected by the onlyGovernance modifier.

To deploy this:

- Deploy a TimelockController contract first.
- Deploy the IDCCore contract, passing the TimelockController address as a parameter.

This implementation provides a robust, flexible, and standardized DAO structure for your IDC. It allows for:

- Token-based voting
- Proposal creation and execution
- Timelock for executing decisions
- Quorum and voting thresholds

Remember, you'll need to set up the proper roles and permissions in the TimelockController to work correctly with this Governor setup.

## API Description
## VotingToken

ERC20 token representing voting power in the IDC.

### Functions

- `constructor(string memory name, string memory symbol)`
  - Initializes the voting token with a name and symbol.

- `mint(address to, uint256 amount) public onlyOwner`
  - Mints new voting tokens to the specified address.

- `burn(address from, uint256 amount) public onlyOwner`
  - Burns voting tokens from the specified address.

- `delegate(address delegatee) public virtual override`
  - Delegates voting power to another address.

- `delegates(address account) public view virtual override returns (address)`
  - Returns the address that `account` has delegated their voting power to.

- `getVotes(address account) public view virtual override returns (uint256)`
  - Returns the current voting power for `account`.

## ShareToken

ERC1155 token representing ownership shares in the IDC.

### Functions

- `constructor(string memory uri)`
  - Initializes the share token with a metadata URI.

- `mintShares(address to, uint256 amount) public onlyOwner`
  - Mints new shares
- ## IDCCore

Main contract for the Internet Decentralized Company (IDC), implementing OpenZeppelin's Governor functionality.

### Properties

- `companyName`: Name of the company (string)
- `jurisdiction`: Jurisdiction of the company (string)
- `votingToken`: Address of the VotingToken contract
- `shareToken`: Address of the ShareToken contract
- `treasuryManager`: Address of the TreasuryManager contract

### Constructor

- `constructor(string memory _name, string memory _jurisdiction, string memory _shareTokenUri, TimelockController _timelock)`
  - Initializes the IDC with a name, jurisdiction, share token URI, and timelock controller.

### Governance Functions

- `propose(address[] memory targets, uint256[] memory values, bytes[] memory calldatas, string memory description) public override(Governor, IGovernor) returns (uint256)`
  - Creates a new proposal.

- `execute(uint256 proposalId, address[] memory targets, uint256[] memory values, bytes[] memory calldatas, bytes32 descriptionHash) public payable override(Governor, IGovernor) returns (uint256)`
  - Executes a successful proposal.

- `cancel(uint256 proposalId, address[] memory targets, uint256[] memory values, bytes[] memory calldatas, bytes32 descriptionHash) public override(Governor, IGovernor) returns (uint256)`
  - Cancels a proposal.

- `castVote(uint256 proposalId, uint8 support) public override(Governor) returns (uint256)`
  - Casts a vote on a proposal.

### Token Management Functions

- `mintShares(address to, uint256 amount) public onlyGovernance`
  - Mints new shares to the specified address.

- `burnShares(address from, uint256 amount) public onlyGovernance`
  - Burns shares from the specified address.

- `mintVotingTokens(address to, uint256 amount) public onlyGovernance`
  - Mints new voting tokens to the specified address.

- `burnVotingTokens(address from, uint256 amount) public onlyGovernance`
  - Burns voting tokens from the specified address.

### Treasury Management Functions

- `withdrawFunds(uint256 amount) public onlyGovernance`
  - Withdraws funds from the treasury.

- `sendFunds(address payable recipient, uint256 amount) public onlyGovernance`
  - Sends funds to a specified recipient.

### View Functions

- `votingDelay() public view override(IGovernor, GovernorSettings) returns (uint256)`
  - Returns the delay between proposal creation and voting start.

- `votingPeriod() public view override(IGovernor, GovernorSettings) returns (uint256)`
  - Returns the voting period duration.

- `quorum(uint256 blockNumber) public view override(IGovernor, GovernorVotesQuorumFraction) returns (uint256)`
  - Returns the minimum number of votes required for a proposal to succeed.

- `state(uint256 proposalId) public view override(Governor, GovernorTimelockControl) returns (ProposalState)`
  - Returns the current state of a proposal.

- `proposalThreshold() public view override(Governor, GovernorSettings) returns (uint256)`
  - Returns the minimum number of votes required to create a proposal.

- `supportsInterface(bytes4 interfaceId) public view override(Governor, GovernorTimelockControl) returns (bool)`
  - Checks if the contract supports a given interface.

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
