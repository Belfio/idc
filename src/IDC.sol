// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol"; 
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/governance/Governor.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorSettings.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorCountingSimple.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotes.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotesQuorumFraction.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorTimelockControl.sol";
import "@openzeppelin/contracts/governance/TimelockController.sol";

contract VotingToken is ERC20, ERC20Votes, ERC20Permit, Ownable {
    constructor(
        string memory name,
        string memory symbol
    ) ERC20(name, symbol) ERC20Permit(name) {}

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) public onlyOwner {
        require(balanceOf(from) >= amount, "Insufficient balance for burning");
        _burn(from, amount);
    }

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override(ERC20, ERC20Votes) {
        super._afterTokenTransfer(from, to, amount);
    }

    function _mint(
        address to,
        uint256 amount
    ) internal override(ERC20, ERC20Votes) {
        super._mint(to, amount);
    }

    function _burn(
        address account,
        uint256 amount
    ) internal override(ERC20, ERC20Votes) {
        super._burn(account, amount);
    }
}

contract ShareToken is ERC1155, Ownable {
    uint256 public constant SHARE_TOKEN_ID = 0;
    uint256 public totalShares;

    constructor(string memory uri) ERC1155(uri) {}

    function mintShares(address to, uint256 amount) public onlyOwner {
        _mint(to, SHARE_TOKEN_ID, amount, "");
        totalShares += amount;
    }

    function burnShares(address from, uint256 amount) public onlyOwner {
        require(
            balanceOf(from, SHARE_TOKEN_ID) >= amount,
            "Insufficient shares"
        );
        _burn(from, SHARE_TOKEN_ID, amount);
        totalShares -= amount;
    }

    function transferShares(address from, address to, uint256 amount) public {
        require(
            from == msg.sender || isApprovedForAll(from, msg.sender),
            "Not authorized"
        );
        safeTransferFrom(from, to, SHARE_TOKEN_ID, amount, "");
    }

    function sharesOf(address account) public view returns (uint256) {
        return balanceOf(account, SHARE_TOKEN_ID);
    }
}

contract CompanyNameNFT is ERC721URIStorage, Ownable {
    uint256 private _tokenIdCounter;

    constructor() ERC721("CompanyNameNFT", "CNFT") {}

    function mintNFT(
        address to,
        string memory uri
    ) public onlyOwner returns (uint256) {
        _tokenIdCounter++;
        uint256 newItemId = _tokenIdCounter;
        _mint(to, newItemId);
        _setTokenURI(newItemId, uri);
        return newItemId;
    }

    function burnNFT(uint256 tokenId) public {
        require(ownerOf(tokenId) == msg.sender, "You do not own this token");
        _burn(tokenId);
    }
}

contract TreasuryManager {
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function withdraw(uint256 amount) public onlyOwner {
        require(address(this).balance >= amount, "Insufficient balance");
        payable(owner).transfer(amount);
    }

    function sendFunds(
        address payable recipient,
        uint256 amount
    ) public onlyOwner {
        require(address(this).balance >= amount, "Insufficient balance");
        recipient.transfer(amount);
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    receive() external payable {}
}

// contract IDCCore is
//     Governor,
//     GovernorSettings,
//     GovernorCountingSimple,
//     GovernorVotes,
//     GovernorVotesQuorumFraction,
//     GovernorTimelockControl
// {
//     string public jurisdiction;

//     VotingToken public immutable votingToken;
//     ShareToken public immutable shareToken;
//     TreasuryManager public immutable treasuryManager;
//     CompanyNameNFT public immutable companyNameNFT;

//     uint256 private constant INITIAL_SHARES = 100;
//     uint256 private constant VOTES_PER_SHARE = 1e18; // 1 token with 18 decimals per share

//     constructor(
//         string memory _companyNameURI,
//         string memory _jurisdiction,
//         string memory _shareTokenUri, //this should be connected to the company name (what happens if you change the comapny name??)
//         string memory _votingTokenUri, //this should be connnected to the company name (what happens if you change the company name??)
//         TimelockController _timelock
//     )
//         Governor("IDCGovernor")
//         GovernorSettings(1 /* 1 block */, 50400 /* 1 week */, 0)
//         GovernorVotes(new VotingToken("IDC Voting Token", "IDCVT"))
//         GovernorVotesQuorumFraction(10) // 10% quorum
//         GovernorTimelockControl(_timelock)
//     {
//         jurisdiction = _jurisdiction;
//         votingToken = new VotingToken("IDC Voting Token", _votingTokenUri); //The name should be connected to the company name and the symbol name
//         shareToken = new ShareToken(_shareTokenUri);
//         treasuryManager = new TreasuryManager();
//         companyNameNFT = new CompanyNameNFT();

//         // Mint initial company name NFT to the deployer
//         companyNameNFT.mintNFT(msg.sender, _companyNameURI);

//         // Initialize GovernorVotes with the correct votingToken
//         __GovernorVotes_init(IVotes(address(votingToken)));

//         // Mint initial shares and voting tokens to the deployer
//         shareToken.mintShares(msg.sender, INITIAL_SHARES);
//         votingToken.mint(msg.sender, INITIAL_SHARES * VOTES_PER_SHARE);
//     }

//     function mintShares(address to, uint256 amount) public onlyGovernance {
//         shareToken.mintShares(to, amount);
//         votingToken.mint(to, amount * VOTES_PER_SHARE);
//     }

//     function burnShares(address from, uint256 amount) public onlyGovernance {
//         shareToken.burnShares(from, amount);
//         votingToken.burn(from, amount * VOTES_PER_SHARE);
//     }

//     function withdrawFunds(uint256 amount) public onlyGovernance {
//         treasuryManager.withdraw(amount);
//     }

//     function sendFunds(
//         address payable recipient,
//         uint256 amount
//     ) public onlyGovernance {
//         treasuryManager.sendFunds(recipient, amount);
//     }

//     function getTreasuryBalance() public view returns (uint256) {
//         return treasuryManager.getBalance();
//     }

//     function updateJurisdiction(
//         string memory newJurisdiction
//     ) public onlyGovernance {
//         jurisdiction = newJurisdiction;
//     }

//     function transferTokenOwnership(address newOwner) public onlyGovernance {
//         votingToken.transferOwnership(newOwner);
//         shareToken.transferOwnership(newOwner);
//     }

//     // The following functions are overrides required by Solidity

//     function votingDelay()
//         public
//         view
//         override(IGovernor, GovernorSettings)
//         returns (uint256)
//     {
//         return super.votingDelay();
//     }

//     function votingPeriod()
//         public
//         view
//         override(IGovernor, GovernorSettings)
//         returns (uint256)
//     {
//         return super.votingPeriod();
//     }

//     function quorum(
//         uint256 blockNumber
//     )
//         public
//         view
//         override(IGovernor, GovernorVotesQuorumFraction)
//         returns (uint256)
//     {
//         return super.quorum(blockNumber);
//     }

//     function state(
//         uint256 proposalId
//     )
//         public
//         view
//         override(Governor, GovernorTimelockControl)
//         returns (ProposalState)
//     {
//         return super.state(proposalId);
//     }

//     function propose(
//         address[] memory targets,
//         uint256[] memory values,
//         bytes[] memory calldatas,
//         string memory description
//     ) public override(Governor, IGovernor) returns (uint256) {
//         return super.propose(targets, values, calldatas, description);
//     }

//     function proposalThreshold()
//         public
//         view
//         override(Governor, GovernorSettings)
//         returns (uint256)
//     {
//         return super.proposalThreshold();
//     }

//     function _execute(
//         uint256 proposalId,
//         address[] memory targets,
//         uint256[] memory values,
//         bytes[] memory calldatas,
//         bytes32 descriptionHash
//     ) internal override(Governor, GovernorTimelockControl) {
//         super._execute(proposalId, targets, values, calldatas, descriptionHash);
//     }

//     function _cancel(
//         address[] memory targets,
//         uint256[] memory values,
//         bytes[] memory calldatas,
//         bytes32 descriptionHash
//     ) internal override(Governor, GovernorTimelockControl) returns (uint256) {
//         return super._cancel(targets, values, calldatas, descriptionHash);
//     }

//     function _executor()
//         internal
//         view
//         override(Governor, GovernorTimelockControl)
//         returns (address)
//     {
//         return super._executor();
//     }

//     function supportsInterface(
//         bytes4 interfaceId
//     ) public view override(Governor, GovernorTimelockControl) returns (bool) {
//         return super.supportsInterface(interfaceId);
//     }
// }
