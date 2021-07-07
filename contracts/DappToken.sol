pragma solidity ^0.5.16;

contract DappToken{
    string public name = "BaBuBisleri";
    string public symbol = "GENESIS";
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    // allowance
    // Returns the amount which _spender is still allowed to withdraw from _owner.
    mapping(address => mapping(address => uint256)) public allowance;
    // mapping ("A" allowing => ("B" => to sped "X"))
    // mapping ("A" allowing => ("C" => to sped "Y")) and sso on...

    // Events in solidity is something that te contract is going to emit in the blockchian which users can subscribe to
    // you can only listen/ see the parameters mentioned as indexed to inside the "Event".
    // ===========================================OR===========================================================
    // An event is emitted, it stores the arguments passed in transaction logs. These logs are stored on
    //  blockchain and are accessible using address of the contract till the contract is present on the blockchain.
    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 _value      
    );

    event Approval(
        address indexed _owner,
         address indexed _spender, 
         uint256 _value
    );

    constructor(uint256 _initialSupply) public{
        totalSupply = _initialSupply;
        // totalSupply = 1000000;
        // allocate initial supply to one of the addresses initially.
        balanceOf[msg.sender]=_initialSupply;
    }

    //transfer function.
   
    function transfer(address _to, uint256 _value) public returns(bool success) {
        // return boolean and show an exception if not enough balance
        require(balanceOf[msg.sender] >= _value);
        // Transfer the balance
        balanceOf[msg.sender] = balanceOf[msg.sender] - _value;
        balanceOf[_to] = balanceOf[_to] + _value;
        // transfer of "0" is valid
        // Transfer event
        emit Transfer(msg.sender, _to, _value);
        
        return true;
    }   

    // Delegated trasnfer
    // For eg: User "A" can "ALLOW" User "B" to spend "C" amount of his/her behalf.
    // Usually a wallet rests on a differnet contract address in the network and thus the user needs to allow the contract(wallet)
    // To spend on itss behalf. 
    // Exchanges are another example of this. You can allow the exchange to do some echanges between tokens on your behalf.
    // Thus 3 types of function.
    // "APPROVE" denoting who is allowed by whom
    // "TRANSFERFROM": Once you have approved a certain amount to "B", Then "B can do the transaction on your behalf.
    // This "TRANSFERFROM" is similar to "transfer" but in "transfer" the user himself was intitiating the Tx, while in "trnasferfrom"
    // some other "allowed" user/address/wallet is doin Tx, on "A"s behalf.
    // "ALLOWANCE": alloted amount of approval to user "B" by "A".

    // Aprove
    // Allows _spender to withdraw from your account multiple times, up to the _value amount. 
    //If this function is called again it overwrites the current allowance with _value.
    // It must also trigger the approval event.
    function approve(address _spender, uint256 _value) public returns (bool success){
        // If You are account "A" then you would like to approve "_spender" to be able to spend "_value" on your behalf.
        // Allowance
        allowance[msg.sender][_spender]= _value;  
        // Trigger approval event
        emit Approval(msg.sender, _spender,_value);
        return true;
    }



    // TransferFrom :
    // Transfers _value amount of tokens from address _from to address _to, and MUST fire the Transfer event.
    // The transferFrom method is used for a withdraw workflow, allowing contracts to transfer tokens on your behalf. This
    // can be used for example to allow a contract to transfer tokens on your behalf and/or to charge fees in sub-currencies. 
    //The function SHOULD throw unless the _from account has deliberately authorized the sender of the message via some mechanism.
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
        // _from : "A"
        // The person calling this or the msg.sender for this function will be "B"
        // _to : "C"
        // _ value : value to tx from "A" to "C"
        
        // Require _from has enough tokens.
        // Require if the allowance is enough.
        require(balanceOf[_from] >= _value);
        require(_value <= allowance[_from][msg.sender]);

        // Update the balance 
        balanceOf[_from] = balanceOf[_from]  - _value;
        balanceOf[_to] += _value;  
        // Update the allowance
        allowance[_from][msg.sender] = allowance[_from][msg.sender] - _value;

        // Emit the Event
        emit Transfer(_from, _to, _value);

        return true;    
    } 
}