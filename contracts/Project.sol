pragma solidity >=0.8.2 <0.9.0;

import "hardhat/console.sol";

//@ Anyone can contribute

//@  End project if targeted contribution amount reached

//@  Expire project if raised amount not fullfill between deadline
//    & return donated amount to all contributor .

//@  Owner need to request contributers for withdraw amount.

//@  Owner can withdraw amount if 50% contributors agree this is to enhance cmmunism

contract Project {
    enum State {
        Fundraising,
        Expired,
        Successful
    }
    //@my struct
    struct withdrawRequest {
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

    mapping(address => uint) public contributiors;
    mapping(uint256 => WithdrawRequest) public withdrawRequests;

    uint256 public numOfWithdrawRequests = 0;

    //@ Modifiers
    modifier isCreator() {
        require(
            msg.sender == creator,
            "You dont have access to perform this operation !"
        );
        _;
    }

    modifier validateExpiry(State _state) {
        require(state == _state, "Invalid state");
        require(block.timestamp < deadline, "Deadline has passed !");
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

    //@todo anyone can contibute
    //@todo return null if

    function contribute(
        address _contributor
    ) public payable validateExpiry(State.Fundraising) {
        require(
            msg.value >= minimumContribution,
            "Contribution amount is too low !"
        );
        if (contributiors[_contributor] == 0) {
            noOfContributers++;
        }
        contributiors[_contributor] += msg.value;
        raisedAmount += msg.value;
        emit FundingReceived(_contributor, msg.value, raisedAmount);
        checkFundingCompleteOrExpire();
    }

    //@todo: this is to complete or expire funding
    //@todo: return null if

    function checkFundingCompleteOrExpire() internal {
        if (raisedAmount >= targetContribution) {
            state = State.Successful;
        } else if (block.timestamp > deadline) {
            state = State.Expired;
        }
        completeAt = block.timestamp;
    }

    //@todo: return current balance
    //@todo: return uint
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    //@todo: request refund if fundings have expired
    //@todo: return boolean
    function requestRefund()
        public
        validateExpiry(State.Expired)
        returns (bool)
    {
        require(
            contributiors[msg.sender] > 0,
            "You dont have any contributed amount !"
        );
        address payable user = payable(msg.sender);
        user.transfer(contributiors[msg.sender]);
        contributiors[msg.sender] = 0;
        return true;
    }

    //@todo: request contributor for the withdrawn amoun
    //@todo: return null
    function createWithdrawRequest(
        string memory _description,
        uint256 _amount,
        address payable _reciptent
    ) public isCreator validateExpiry(State.Successful) {
        WithdrawRequest storage newRequest = withdrawRequests[
            numOfWithdrawRequests
        ];
        numOfWithdrawRequests++;

        newRequest.description = _description;
        newRequest.amount = _amount;
        newRequest.noOfVotes = 0;
        newRequest.isCompleted = false;
        newRequest.reciptent = _reciptent;

        emit WithdrawRequestCreated(
            numOfWithdrawRequests,
            _description,
            _amount,
            0,
            false,
            _reciptent
        );
    }

    //@todo: request contributor to vote for withdraw requests
    //@todo: return null

    function voteWithdrawRequest(uint256 _requestId) public {
        require(contributiors[msg.sender] > 0, "Only contributor can vote !");
        WithdrawRequest storage requestDetails = withdrawRequests[_requestId];
        require(
            requestDetails.voters[msg.sender] == false,
            "You already voted !"
        );
        requestDetails.voters[msg.sender] = true;
        requestDetails.noOfVotes += 1;
        emit WithdrawVote(msg.sender, requestDetails.noOfVotes);
    }

    //@todo: Owners can withdraw the amount that is rerquested
    //@todo: return null
    function withdrawRequestedAmount(
        uint256 _requestId
    ) public isCreator validateExpiry(State.Successful) {
        WithdrawRequest storage requestDetails = withdrawRequests[_requestId];
        require(
            requestDetails.isCompleted == false,
            "Request already completed"
        );
        require(
            requestDetails.noOfVotes >= noOfContributers / 2,
            "At least 50% contributor need to vote for this request"
        );
        requestDetails.reciptent.transfer(requestDetails.amount);
        requestDetails.isCompleted = true;

        emit AmountWithdrawSuccessful(
            _requestId,
            requestDetails.description,
            requestDetails.amount,
            requestDetails.noOfVotes,
            true,
            requestDetails.reciptent
        );
    }

    //@todo: Get contract details
    //@todo: return all the project details

    function getProjectDetails()
        public
        view
        returns (
            address payable projectStarter,
            uint256 minContribution,
            uint256 projectDeadline,
            uint256 goalAmount,
            uint completedTime,
            uint256 currentAmount,
            string memory title,
            string memory desc,
            State currentState,
            uint256 balance
        )
    {
        projectStarter = creator;
        minContribution = minimumContribution;
        projectDeadline = deadline;
        goalAmount = targetContribution;
        completedTime = completeAt;
        currentAmount = raisedAmount;
        title = projectTitle;
        desc = projectDes;
        currentState = state;
        balance = address(this).balance;
    }
}
