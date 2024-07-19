// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

// Add two blank lines here

contract Counter {
	uint256 public number;

	constructor(uint256 _number) {
		number = _number;
	}

	function setNumber(uint256 newNumber) public {
		number = newNumber;
	}

	function increment() public {
		number++;
	}
}