// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract WETH is ERC20 {
	event Deposit(address indexed dst, uint wad);
	event Withdrawal(address indexed src, uint wad);

	error BalanceOfSenderLessThanAmount();
	error FailedToSendEther();

	constructor() ERC20("WETH", "WETH") {}

	fallback() external payable {
		deposit();
	}

	receive() external payable {
		deposit();
	}

	function deposit() public payable {
		_mint(msg.sender, msg.value);
		emit Deposit(msg.sender, msg.value);
	}

	function withdraw(uint amount) public {
		if (balanceOf(msg.sender) < amount) {
			revert BalanceOfSenderLessThanAmount();
		}

		_burn(msg.sender, amount);

		(bool success, ) = payable(msg.sender).call{ value: amount }("");
		if (!success) {
			revert FailedToSendEther();
		}

		emit Withdrawal(msg.sender, amount);
	}
}
