pragma solidity 0.8.20; //Do not change the solidity version as it negatively impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {
    event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

    uint256 public constant tokensPerEth = 100;

    YourToken public yourToken;

    constructor(address tokenAddress) Ownable(msg.sender) {
        yourToken = YourToken(tokenAddress);
    }

    function buyTokens() external payable {
        uint256 tokenAmount = msg.value * tokensPerEth;
        yourToken.transfer(msg.sender, tokenAmount);
        emit BuyTokens(msg.sender, msg.value, tokenAmount);
    }

    function withdraw() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    function sellTokens(uint256 amount) external {
        yourToken.transferFrom(msg.sender, address(this), amount);
        uint256 ethAmount = amount / tokensPerEth;
        payable(msg.sender).transfer(ethAmount);
    }
}
