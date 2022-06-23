pragma solidity ^0.8.0;

interface IERC20 {

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);


    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


contract SampleToken is IERC20 {
    using SafeMath for uint256;

    string public constant name = "SampleToken";
    string public constant symbol = "SMT";
    uint8 public constant decimals = 18;

    mapping(address => uint256) balances;
    mapping(address => mapping (address => uint256)) allowed;

    uint256 totalSupply_;

    constructor(uint256 total) public {
        totalSupply_ = total;
        balances[msg.sender] = totalSupply_;
    }

    function totalSupply() public override view returns (uint256) {
        return totalSupply_;
    }

    function balanceOf(address tokenOwner) public override view returns (uint256) {
        return balances[tokenOwner];
    }

    function transfer(address receiver, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender].sub(numTokens);
        balances[receiver] = balances[receiver].add(numTokens);
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function approve(address delegate, uint256 numTokens) public override returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(address owner, address delegate) public override view returns (uint) {
        return allowed[owner][delegate];
    }

    function transferFrom(address owner, address buyer, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);

        balances[owner] = balances[owner].sub(numTokens);
        allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
        balances[buyer] = balances[buyer].add(numTokens);
        emit Transfer(owner, buyer, numTokens);
        return true;
    }
}

library SafeMath {
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
      assert(b <= a);
      return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
      uint256 c = a + b;
      assert(c >= a);
      return c;
    }
}

We need to define two mapping objects. This is the Solidity notion for an associative or key/value array:
 mapping(address => uint256) balances;
 mapping(address => mapping (address => uint256)) allowed;
The expression mapping(address => uint256) defines an associative array whose keys are of type address. a number used to denote account addresses, and whose values are of type uint256. Balances mapping, will hold the token balance of each owner account.

The second mapping object, allowed, will include all of the accounts approved to withdraw from a given account together with the withdrawal sum allowed for each.

After that we set the total amount of tokens at constructor (which is a special function automatically called by Ethereum right after the contract is deployed) and assign all of them to the “contract owner” i.e. the account that deployed the smart contract:
uint256 totalSupply_;
constructor(uint256 total) public {
  totalSupply_ = total;
  balances[msg.sender] = totalSupply_;
}
Get Total Token Supply
This function will return the number of all tokens allocated by this contract regardless of owner.
function totalSupply() public view returns (uint256) {
  return totalSupply_;
}
Get Token Balance of Owner
balanceOf will return the current token balance of an account, identified by its owner’s address.
function balanceOf(address tokenOwner) public view returns (uint256) {
   return balances[tokenOwner];
}
Transfer Tokens to Another Account
The transfer function is used to move numTokens amount of tokens from the owner’s balance to that of another user, or receiver. The transferring owner is msg.sender i.e. the one executing the function.
function transfer(address receiver, uint256 numTokens) public returns (bool) {
    require(numTokens <= balances[msg.sender]);
    balances[msg.sender] = balances[msg.sender].sub(numTokens);
    balances[receiver] = balances[receiver].add(numTokens);
    emit Transfer(msg.sender, receiver, numTokens);
    return true;
}
Approve user to Withdraw Tokens
This function is most often used in a token marketplace scenario. What approve does is to allow an owner i.e. msg.sender to approve a delegate account to withdraw tokens from his account and to transfer them to other accounts.
function approve(address delegate, uint256 numTokens) public returns (bool) {
   allowed[msg.sender][delegate] = numTokens;
   emit Approval(msg.sender, delegate, numTokens);
   return true;
}
At the end of its execution, this function fires an Approval event.

Get Number of Tokens Approved for Withdrawal
This function returns the current approved number of tokens by an owner to a specific delegate, as set in the approve function.
function allowance(address owner, address delegate) public view returns (uint) {
   return allowed[owner][delegate];
}
Transfer Tokens by Delegate
The transferFrom function is the peer of the approve function. It allows a delegate approved for withdrawal to transfer owner funds to a third-party account.
function transferFrom(address owner, address buyer,
                     uint numTokens) public returns (bool) {
  require(numTokens <= balances[owner]);
  require(numTokens <= allowed[owner][msg.sender]);

  balances[owner] = balances[owner] — numTokens;
  allowed[owner][msg.sender] =
        allowed[from][msg.sender] — numTokens;
  balances[buyer] = balances[buyer] + numTokens;
  Transfer(owner, buyer, numTokens);
  return true;
}
SafeMath
We also used SafeMath Library for uint256 data type. SafeMath is a Solidity library aimed at dealing with one way hackers have been known to break contracts: integer overflow attack. In such an attack, the hacker forces the contract to use incorrect numeric values by passing parameters that will take the relevant integers past their maximal values.

Contract Deployment
Now Let's deploy our ERC20 Token to Ethereum Network. To Deploy Contract to Ethereum Network you will need to install the MetaMask plugin on your browser and a Ropsten (Ethereum test network) account with at least some Ropsten Ether in it.

Then, we will hop over to the second tab to the bottom called Compiler and click Compile.
Compile Contract
After compiled successfully Then, we will hop over to the third tab to the bottom called DEPLOY & RUN TRANSACTIONS. Then change the environment to Injected Web3. Make sure to select the appropriate contract from options.
Deploy Contract
And then enter total supply in highlighted box which you want for this token and click on deploy. A MetaMask popup will appear asking us to confirm the transaction. After approve your contract will be deployed which you can see in bottom section Deployed Contracts.
Deoployed

That’s it! your token contract is now deployed on Ethereum’s Ropsten testnet!

Congratulations on successfully creating your very own token/coin on the Ethereum network! Read more about the ERC-20 standard here.

Discussion (7)
Subscribe
pic
Add to the discussion

suhakim profile image
sadiul hakim
•
Feb 27

Can you create post about how to create a ERC721 token?


2
 likes
Reply

abdulmaajid profile image
Abdul Maajid
•
Feb 27

Already created Check it out.
dev.to/abdulmaajid/how-to-create-a...


1
 like
Reply

roni_sommerfeld profile image
RoNi Sommerfeld
•
Oct 30 '21

Hello, is it possible to use an ERC20 token inside a function of an ERC721 token?
To better explain what I want to do is as follows.
Before minting an ERC721 token (Item of my game) I want to check if the player has my token (ERC20) in his wallet, if he has he could mint it...
Is it possible to do that? Thanks.


3
 likes
Reply

abdulmaajid profile image
Abdul Maajid
•
Nov 3 '21

Hey

If you want to access/use ERC20 Token in any contract Just create an interface of ERC20 Token. And pass your erc20 contract address in this interface then you can access.
e.g. IERC20 token = IERC20(address)


1
 like
Reply

alx90s profile image
Alexander Härdrich
•
Jan 22 • Edited on Jan 22

Hey man, when I created a new ERC20 token with a total token supply of 1000. Then I add 1000 more tokens via the _mint function to any address. Now I reach the limit of 1000 coins and we have a new amount of 2000. Is that possible ? Or is the _totalSuply just the initial amount and not the maximum ?


2
 likes
Reply

abdulmaajid profile image
Abdul Maajid
•
Jan 24

Yes but you have to add function mint. which will mint new tokens for specific users.


2
 likes
Reply

milo123459 profile image
Milo
•
Jun 14

Can you make a post about making a token on the Vite network? Better yet: With solidity++ (github.com/vitelabs/soliditypp)


1
 like
Reply
Code of Conduct • Report abuse
Read next
thesmartnik profile image
How to test solidity smart contracts with ruby with RSpec and Etherium.rb
TheSmartnik - Mar 30

dominguezdaniel profile image
Introduction to web3.js
@dominguezdaniel - Mar 30

mikhailkaran profile image
What is Web1, Web2, and Web3?
Mikhail Karan - Mar 10

dipankarmedhi profile image
Build a Shared Wallet in Solidity
Dipankar Medhi - Mar 30


Abdul Maajid
Follow
Blockchain Developer @ BlocTech | ❤️ Web3 | Blockchain & Crypto enthusiast
LOCATION
Pakistan
WORK
Blockchain Developer at BlocTech Solutions
JOINED
Dec 9, 2019
More from Abdul Maajid
Best Free Resources to Learn Web3/Blockchain Development
#javascript #web3 #blockchain #webdev
How to Create an NFT(ERC-721) using OpenZeppelin
#blockchain #smartcontract #solidity #nft
Top Programming Languages To Create Smart Contracts
#blockchain #smartcontracts #programming #web3
pragma solidity ^0.8.0;

interface IERC20 {

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);


    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


contract SampleToken is IERC20 {
    using SafeMath for uint256;

    string public constant name = "SampleToken";
    string public constant symbol = "SMT";
    uint8 public constant decimals = 18;

    mapping(address => uint256) balances;
    mapping(address => mapping (address => uint256)) allowed;

    uint256 totalSupply_;

    constructor(uint256 total) public {
        totalSupply_ = total;
        balances[msg.sender] = totalSupply_;
    }

    function totalSupply() public override view returns (uint256) {
        return totalSupply_;
    }

    function balanceOf(address tokenOwner) public override view returns (uint256) {
        return balances[tokenOwner];
    }

    function transfer(address receiver, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender].sub(numTokens);
        balances[receiver] = balances[receiver].add(numTokens);
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function approve(address delegate, uint256 numTokens) public override returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(address owner, address delegate) public override view returns (uint) {
        return allowed[owner][delegate];
    }

    function transferFrom(address owner, address buyer, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);

        balances[owner] = balances[owner].sub(numTokens);
        allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
        balances[buyer] = balances[buyer].add(numTokens);
        emit Transfer(owner, buyer, numTokens);
        return true;
    }
}

library SafeMath {
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
      assert(b <= a);
      return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
      uint256 c = a + b;
      assert(c >= a);
      return c;
    }
}

DEV Community — A constructive and inclusive social network for software developers. With you every step of your journey.

Built on Forem — the open source software that powers DEV and other inclusive communities.

Made with love and Ruby on Rails. DEV Community © 2016 - 2022.
