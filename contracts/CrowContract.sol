// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./IERC20.sol";


/*

the variables with the  " _ " are internal variables

*/


contract CrowdFund {

    //Events to be emmited while the functions or contract are running
    event Launch(uint256 campaignId, uint256 goal, address creator, uint256 startAt, uint256 endAt);
    event Cancel(uint256 campaignId);
    event Pledge(uint256 campaignId, uint256 _amount, address pledger);
    event Claim(uint id);
    event Refund(uint id, address indexed caller, uint amount);


    //Struct for campaign
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

        bool isCancel;
    }

    //Mappings for campaign and pledged amount
    mapping(uint256 => Campaign) public campaigns; //mapping for the created campaigns
    mapping(uint256 => mapping(address => uint256)) public amountPledged; //mapping the pledged amounts for each campaign

    uint256 countCampaign = 0; //count for the campaigns
    IERC20 public immutable paymentToken;
    
   //Initialize the paymentToken
    constructor(address _paymentToken) {
       paymentToken = IERC20(_paymentToken);
    }

    //Function that launch the campaign
    function launch(
        uint _goal,
        uint32 _startAt,
        uint32 _endAt
    ) external {
        require(_startAt >= block.timestamp, "The time is lower than the original time!"); //Test if the time is less than the original time
        require(_endAt >= _startAt, "End is < than Start!"); // Test if the end time is higher than the star time
        require(_endAt <= block.timestamp + 30 days, "Ends > than the max duration!"); // In this require i test that is lower than today + 30 days (1 month)
        countCampaign +=1; //increment the countCampaign
        campaigns[countCampaign] = Campaign(msg.sender, _goal, 0, _startAt, _endAt, false, false); //Add the new campaign to campaigns

        emit Launch(countCampaign, _goal , msg.sender, _startAt, _endAt); //Emit the Launch event
    }


    //Function that cancels the campaign
   function cancel(uint256 _campaignId) external{
        Campaign memory campaign = campaigns[_campaignId];
        require(msg.sender ==  campaign.creator, "Only the owner of the campaign can cancel!");
        require(block.timestamp < campaign.startAt, "The campaign doesn't started");
        delete campaigns[_campaignId];
        emit Cancel(_campaignId);
   }
    
    //Function that pledge an undeterminated amount to a campaign
    function pledge(uint256 _campaignId, uint256 _amountToPledge) external {
        Campaign memory campaign = campaigns[_campaignId];
        require(_amountToPledge >= 1 , "The minimun to pledge is 1");
        require(campaign.startAt >= block.timestamp, "The campaign doesn't start yet"); //require if the campaign started
        require(block.timestamp  < campaign.endAt, "The campaign is ended"); //require if the campaign doesn't end

        campaign.pledged += _amountToPledge; 
        amountPledged[_campaignId][msg.sender] += _amountToPledge; //Add the amount to the amountPledged Campaign

        paymentToken.transferFrom(msg.sender,address(this),_amountToPledge);

        emit Pledge(_campaignId, _amountToPledge, msg.sender); //Launch the Pledge event
    }    


    //Function that the owner of the campaign can claim the money
    function claim(uint256 _campaignId) external {
        Campaign memory campaign = campaigns[_campaignId];
        require(msg.sender == campaign.creator, "Only the owner of the campaign can call this function!");
        require(campaign.pledged >= campaign.goal, "Goal not reached");
        require(block.timestamp > campaign.endAt, "The campaign doesn't ended!");
        require(campaign.claimed == false, "The campaign is alredy claimded");

        campaign.claimed=true;
        paymentToken.transfer(msg.sender, campaign.pledged);


        emit Claim(_campaignId);
    }


    //Function that refund the money to the pledgers
    function refund(uint256 _campaignId) external {
        Campaign memory campaign = campaigns[_campaignId];
        if(campaign.isCancel != false){
            require(campaign.pledged < campaign.goal, "The goal of the campaign is reached!");
            require(block.timestamp > campaign.endAt, "The campaign doesn't ended!");
        }
        require(amountPledged[_campaignId][msg.sender] > 0, "You dont have any funds in this campaign!");
        uint256 balancePledged = amountPledged[_campaignId][msg.sender];
        amountPledged[_campaignId][msg.sender] = 0;
        paymentToken.transfer(msg.sender, balancePledged);

        emit Refund(_campaignId, msg.sender, balancePledged);
    }
}
