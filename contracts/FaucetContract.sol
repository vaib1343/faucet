pragma solidity >=0.4.22 <0.9.0;

import "./Owned.sol";
import "./Logger.sol";

contract Faucet is Owned, Logger {
    //this is a special function
    //its called when you make a tx that doesnt specify function name to call
    //External function that can be called via contracts and other tx

    mapping(address => bool) public funders;
    mapping(uint => address) public lutFunders;
    uint256 public numOfFunders;

    modifier limitWithdraw(uint withdrawAmount) {
        require(withdrawAmount <= 1000000000000000000, "Cannot withdraw more than 1 eth");
        _;
    }

    receive() external payable {}

    function emitLog() public override pure returns(bytes32){
        return "Hello world";
    }


    function addFunds() external payable {
        address funder = msg.sender;
        if(!funders[funder]){
            uint index = numOfFunders++;
            funders[funder] = true;
            lutFunders[index] = funder;
        }
    }

    function withdraw(uint withdrawAmount) external limitWithdraw(withdrawAmount) onlyOwner {
        payable(msg.sender).transfer(withdrawAmount);
    }

    function getAllFunder() public view returns (address[] memory) {
        address[] memory _funders = new address[](numOfFunders);
        for (uint256 i = 0; i < numOfFunders; i++) {
            _funders[i] = lutFunders[i];
        }
        return _funders;
    }

    function getFunderAtIndex(uint8 index) external view returns (address) {
        return lutFunders[index];
    }

    //view - It indicates will not change eth state
    //pure - It indicates will not read and change eth state
    //no gas fee is required
}
