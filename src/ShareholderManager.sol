// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract ShareholderManager is ERC1155, Ownable {
    uint256 public constant SHARE_TOKEN_ID = 0;
    mapping(address => bool) public isShareholder;

    constructor(string memory uri) ERC1155(uri) {}

    function mintShares(address to, uint256 amount) public onlyOwner {
        _mint(to, SHARE_TOKEN_ID, amount, "");
        isShareholder[to] = true;
    }

    function burnShares(address from, uint256 amount) public onlyOwner {
        _burn(from, SHARE_TOKEN_ID, amount);
        if (balanceOf(from, SHARE_TOKEN_ID) == 0) {
            isShareholder[from] = false;
        }
    }

    function isShareHolder(address account) public view returns (bool) {
        return isShareholder[account];
    }
}

contract TreasuryManager is Ownable {
    event FundsReceived(address indexed from, uint256 amount);
    event FundsWithdrawn(address indexed to, uint256 amount);
    event FundsSent(address indexed to, uint256 amount);

    receive() external payable {
        emit FundsReceived(msg.sender, msg.value);
    }

    fallback() external payable {
        emit FundsReceived(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) public onlyOwner {
        require(address(this).balance >= amount, "Insufficient balance");
        payable(msg.sender).transfer(amount);
        emit FundsWithdrawn(msg.sender, amount);
    }

    function sendFunds(
        address payable recipient,
        uint256 amount
    ) public onlyOwner {
        require(address(this).balance >= amount, "Insufficient balance");
        recipient.transfer(amount);
        emit FundsSent(recipient, amount);
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

contract IDCCore is Ownable {
    string public companyName;
    string public jurisdiction;

    ShareholderManager public shareholderManager;
    TreasuryManager public treasuryManager;

    mapping(address => bool) public isAdmin;

    constructor(
        string memory _name,
        string memory _jurisdiction,
        string memory _uri
    ) {
        companyName = _name;
        jurisdiction = _jurisdiction;
        isAdmin[msg.sender] = true;

        shareholderManager = new ShareholderManager(_uri);
        treasuryManager = new TreasuryManager();

        shareholderManager.transferOwnership(address(this));
        treasuryManager.transferOwnership(address(this));

        shareholderManager.mintShares(msg.sender, 100);
    }

    function setAdmin(address _address, bool _isAdmin) public onlyOwner {
        isAdmin[_address] = _isAdmin;
    }

    function mintShares(address to, uint256 amount) public onlyAdmin {
        shareholderManager.mintShares(to, amount);
    }

    function burnShares(address from, uint256 amount) public onlyAdmin {
        shareholderManager.burnShares(from, amount);
    }

    function withdraw(uint256 amount) public onlyAdmin {
        treasuryManager.withdraw(amount);
    }

    function sendFunds(
        address payable recipient,
        uint256 amount
    ) public onlyAdmin {
        treasuryManager.sendFunds(recipient, amount);
    }

    modifier onlyAdmin() {
        require(isAdmin[msg.sender], "Only admins can perform this action");
        _;
    }
}
