pragma solidity >=0.8.2 <0.9.0;


import "hardhat/console.sol";

//@ Anyone can contribute

//@  End project if targeted contribution amount reached

//@  Expire project if raised amount not fullfill between deadline
//    & return donated amount to all contributor .

//@  Owner need to request contributers for withdraw amount.

//@  Owner can withdraw amount if 50% contributors agree this is to enhance cmmunism


contract Project{
    enum State{
        Fundraising,
        Expired,
        Successful
    }
//@my struct
    struct withdrawRequest{
        string description;
        uint256 amount;
        uint256 noOfVotes;
        mapping(address => bool) voters;
        bool isCompleted;
        address payable reciptent;
    }
        //@variables
        address payable public creator;
        uint256 public minimumContribution;
        uint256 public deadline;
        uint256 public targetContribution; // required to reach at least this much amount
        uint public completeAt;
        uint256 public raisedAmount; // Total raised amount till this time
        uint256 public noOfContributers;
        string public projectTitle;
        string public projectDes;
        State public state = State.Fundraising; 

    mapping (address => uint) public contributiors;
    mapping (uint256 => WithdrawRequest) public withdrawRequests;

    uint256 public numOfWithdrawRequests = 0;

    //@ Modifiers
    modifier isCreator(){
        require(msg.sender == creator,'You dont have access to perform this operation !');
        _;
    }

    modifier validateExpiry(State _state){
        require(state == _state,'Invalid state');
        require(block.timestamp < deadline,'Deadline has passed !');
        _;
    }
    //@for funding received
    event FundingReceived(address contributor, uint amount, uint currentTotal);
    //@for contributors vote to withdraw request
    event AmountWithdrawSuccessful(
        uint256 requestId,
        string description,
        uint256 amount,
        uint256 noOfVotes,
        bool isCompleted,
        address reciptent
    );
    //@@@@@@@@ create a project
    ///@@ if not return null

       constructor(
       address _creator,
       uint256 _minimumContribution,
       uint256 _deadline,
       uint256 _targetContribution,
       string memory _projectTitle,
       string memory _projectDes
   ) {
       creator = payable(_creator);
       minimumContribution = _minimumContribution;
       deadline = _deadline;
       targetContribution = _targetContribution;
       projectTitle = _projectTitle;
       projectDes = _projectDes;
       raisedAmount = 0;
   }
}