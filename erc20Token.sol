// SPDX-License-Identifier: GPL-3.0
 
pragma solidity >=0.5.0<0.9.0;

//EIP-20:ERC20 Token Standard


interface ERC20Interface{

    //These are the only 3 mandatory functions needed for an erc20 token
    function totalSupply()external view returns(uint);
    function balanceOf(address tokenOwner) external view returns(uint balance);
    function transfer(address to, uint amount) external returns(bool success);


    //these are the 3 additional function needed to make a fully ERC-20 compliable token
    function allowance(address tokenOwner,address spender) external view returns(uint remaining);
    function approve(address spender, uint tokens) external returns(bool success);
    function transferFrom(address from, address to, uint tokens) external returns (bool success);

    event Transfer(address indexed from,address indexed to, uint tokens);
    event Approval(address indexed tokenOwner,address indexed  spender, uint tokens);
}


   contract Surrealium is ERC20Interface{

       string public name= "Surrealium";
       string public symbol="SUR";
       uint public decimals = 0;
        //though this is a state variable it creates a getter function beacuse its public so we have to use "override"
       uint public override totalSupply;
       address public founder;
       mapping(address=>uint) public balances;
       //a mapping that mapps the addresses of token owner to the addresses of the accounts they allow to transfer tokens from their balance
       mapping(address=>mapping(address=>uint)) allowed;


       constructor(){

           totalSupply=1000000;
           founder=msg.sender;
           balances[founder]=totalSupply;
       }

       function balanceOf(address tokenOwner)   public view override returns(uint balance){
           return balances[tokenOwner];
       }


       function transfer(address to, uint amount) public override returns(bool success){
           //Fuction reverts on failure
           require(amount <= balances[msg.sender],"You dont have enough in your account");

           //debit the sender account
           balances[msg.sender]-=amount;
           //credit the receiver account,adding it to the mapping
           balances[to]+=amount;
           //emit an event
           emit Transfer(msg.sender,to,amount);
           return true;

       }

        //retruns the number of tokens the token owner has allowed the spender to transfer
       function allowance( address tokenOwner, address spender) view public override returns(uint){

            return allowed[tokenOwner][spender];
       }

       

        //allows the token owner to allow the  spender to spend a given amount
         function approve(address spender, uint tokens) public override returns(bool success){
             require(tokens<=balances[msg.sender]);

             allowed[msg.sender][spender]=tokens;

             //emit the Approval event
             emit Approval(msg.sender,spender,tokens);
             return true;

         }



        //allows a speder to withdraw from the sender account up until the allowance
        function transferFrom(address from, address to, uint tokens) public override returns (bool success){

            //make sure the tokens the spender wants to send are not more than the allowed amount
            require(allowed[from][msg.sender]>=tokens,"Tokens exceed the allowed limit");
            //check that the balance of the sender is  more than the amount the spender wants to transfer
            require(balances[from]>=tokens,"The approver does not have enough balance");

            //debit the sender account
           balances[from]-=tokens;

           //credit the receiver account,adding it to the mapping
           balances[to]+=tokens;

           //emit an event
           emit Transfer(from,to,tokens);

            //Update the mapping
            allowed[from][msg.sender]-=tokens;

            return true;


        }












    }
