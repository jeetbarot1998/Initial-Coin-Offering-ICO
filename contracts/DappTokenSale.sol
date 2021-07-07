pragma solidity ^0.5.16;

import './DappToken.sol';

contract DappTokenSale{
    address payable admin;
    DappToken public tokenContract;
    uint256 public tokenPrice;
    uint256 public tokenSold;

    event Sell(
        address _buyer,
        uint256 _amount
    );

    constructor(DappToken _tokenContract, uint256 _tokenPrice) public{
        admin = msg.sender;
        tokenPrice = _tokenPrice;
        tokenContract = _tokenContract;
    }

    // using multiply using "ds-math" Library.
    // Internal means that it is only available insidde the contract and it cannot be called externally.
    //  Pure means that it doesnt write to blockchain or any other state variables. 
    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
    }

    // Payable means that a transaction will be done via this contract and some tokens will be passed to this function.
    function buyTokens(uint256 _numberOfTokens) public payable{
        // Making Sure if the sender has sent enough tokens as much as it has requested for.
        //  Ie. I am really sending 6rs to get 3(_numberofToken)*2(tokenprice) 
        require(msg.value == mul(_numberOfTokens, tokenPrice));

        //  Making sure if the contract has enough tokens.
        // So tranfer some tokens to the "Smart Contract" instead of an external account.
        require(tokenContract.balanceOf(address(this)) > _numberOfTokens);

        // Successful Tx.
        require(tokenContract.transfer(msg.sender, _numberOfTokens));

        // Keeping track of all the events
        tokenSold +=_numberOfTokens;

        // Emiting the event mentioning who bought and how much
        emit Sell(msg.sender , _numberOfTokens);
    }

    // Ending Token Sales.
    function endSale() public{
        // Requires the ending person to be "admin"
        require(msg.sender==admin);
        // Transfer Remaining Dapp Token to "admin"
        require(tokenContract.transfer(admin, tokenContract.balanceOf(address(this))));
        //  Self-Destruct the Contract.
        // Destroys the current contract and returns its funds to the given "Address"
        admin.transfer(address(this).balance);


    }

}