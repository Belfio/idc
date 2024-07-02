pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC1155NFT is ERC1155, Ownable {
    // ID values for the NFT and TOKEN tokens.
    uint256 public constant NFT_ID = 1;
    uint256 public constant TOKEN_ID = 2;

    // Mapping to track whether an address has already minted an NFT token
    mapping(address => bool) private _nftMinted;

    constructor()
        ERC1155("https://gateway.pinata.cloud/ipfs/<YOUR_CID>/{id}.json")
    {
        _mint(msg.sender, TOKEN_ID, 100, "");
        _mint(msg.sender, NFT_ID, 1, "");
    }

    function mintNFT(address account, bytes memory data) public onlyOwner {
        // Check if the account has already minted an NFT
        require(!_nftMinted[account], "NFT already minted");

        // Mark the account as having minted an NFT
        _nftMinted[account] = true;

        // Mint the NFT token to the specified account with ID 1 and quantity 1
        _mint(account, NFT_ID, 1, data);
    }

    function mintToken(
        address account,
        uint256 amount,
        bytes memory data
    ) public onlyOwner {
        // Mint the TOKEN token to the specified account with ID 2 and the specified quantity
        _mint(account, TOKEN_ID, amount, data);
    }
}
