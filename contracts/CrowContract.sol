// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

interface IERC20 {
    // function totalSupply() external view returns (uint);
    // function balanceOf(address account) external view returns (uint);
    // function transfer(address recipient, uint amount) external returns (bool);
    // function allowance(address owner, address spender) external view returns (uint);
    // function approve(address spender, uint amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

contract CrowdFund  {
    event Launch(uint256 campaignId, uint256 goal, address creator, uint256 startAt, uint256 endAt);
    event Cancel(uint256 campaignId);
    event Pledge(uint256 campaignId, uint256 _amount, address pledger);
    event Claim(uint id);
    event Refund(uint id, address indexed caller, uint amount);

    struct Campaign {
        // Creator of campaign
        address creator;
        // Amount of tokens to raise
        uint goal;
        // Total amount pledged
        uint pledged;
        // Timestamp of start of campaign
        uint32 startAt;
        // Timestamp of end of campaign
        uint32 endAt;
        // True if goal was reached and creator has claimed the tokens.
        bool claimed;
    }

    mapping(uint256 => Campaign) public campaigns; //mapping for the created campaigns
    mapping(uint256 => mapping(address => uint256)) amountPledged; //mapping the pledged amounts for each campaign



    uint256 countCampaign = 0; //count for the campaigns
    IERC20 public immutable token;
    
   
    constructor(address _token) {
       token = IERC20(_token);
    }

    function launch(
        uint _goal,
        uint32 _startAt,
        uint32 _endAt
    ) external {
        require(_startAt >= block.timestamp, "The time is lower than the original time!"); //Test if the time is less than the original time
        require(_endAt >= _startAt, "End is < than Start!"); // Test if the end time is higher than the star time
        require(_endAt <= block.timestamp + 30 days, "Ends > than the maz duration!"); // In this require i test that is lower than today + 30 days (1 month)
        countCampaign +=1; //increment the countCampaign
        campaigns[countCampaign] = Campaign(msg.sender, _goal, 0, _startAt, _endAt, false); //Add the new campaign to campaigns

        emit Launch(countCampaign, _goal , msg.sender, _startAt, _endAt); //Emit the Launch event
    }

   function cancel(uint256 _campaignId) external{
        Campaign memory campaign = campaigns[_campaignId];
        require(msg.sender ==  campaign.creator, "Only the owner of the campaign can cancel!");
        require(block.timestamp < campaign.startAt, "The campaign doesn't started");
        delete campaigns[_campaignId];
        emit Cancel(_campaignId);
   }
    

    function pledge(uint256 _campaignId, uint256 _amountToPledge) external {
        Campaign memory campaign = campaigns[_campaignId];
        require(campaign.startAt >= block.timestamp, "The campaign doesn't start yet"); //require if the campaign started
        require(block.timestamp  < campaign.endAt, "The campaign is ended"); //require if the campaign doesn't end

        campaign.pledged += _amountToPledge; 
        amountPledged[_campaignId][msg.sender] += _amountToPledge; //Add the amount to the amountPledged Campaign

        emit Pledge(_campaignId, _amountToPledge, msg.sender); //Launch the Pledge event
    }    

    //function claim(uint _id) external {
        //completar
        
        
     //   }

   // function refund(uint _id) external {
        //completar
        
        
        
    //}
}
