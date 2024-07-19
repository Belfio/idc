// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {ERC20Votes} from "lib/openzeppelin-contracts/token/contracts/ERC20/extensions/ERC20Votes.sol";
import {ERC20Permit} from "lib/openzeppelin-contracts/token/contracts/ERC20/extensions/ERC20Permit.sol";
import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol";



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