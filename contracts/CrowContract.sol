// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

interface IERC20 {
    //completar
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
    //event Cancel;
    //event Pledge;
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

    mapping(uint256 => Campaign) public campaigns;

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
       //completar

        //emit //completar
    

   // function cancel //completar
    

    //function pledge //completar
    

    //function claim(uint _id) external {
        //completar
        
        
     //   }

   // function refund(uint _id) external {
        //completar
        
        
        
    //}
}