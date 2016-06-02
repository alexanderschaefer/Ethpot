contract Ethpot {
    address private owner;
    uint private ticketPrice = 0.01 ether;
    // lottery fee in percent 1 == 1% 
    uint8 private lotteryFee = 1;

    mapping (address => uint) private tickets;
    uint40 private participants;
    uint private totalTickets;

    modifier onlyOwner() {
        if (msg.sender != owner) throw;
        _
    }

    function Ethpot() {
        owner = msg.sender;
    }

    /*
        Fallback function used in this contract as means to participate 
        in the lottery. An account sending ETH to the contract, without data,
        is interpreted as buying tickets
    **/
    function () {
        buyTickets();
    }

    /**
        Determines the number of tickets that can be bought with 
        the ETH that was sent to the contract. Refunds any remaining
        ETH to the sender. 
    */
    function buyTickets() {  // TODO: call buy tickets from any function to allow sending funds via any function call
        if (msg.value < ticketPrice) throw;

        var refund = msg.value % ticketPrice;
        if (refund > 0) {
            msg.sender.send(refund);
        }

        if (tickets[msg.sender] == 0) participants++;
        var ts = msg.value / ticketPrice;
        tickets[msg.sender] += ts;
        totalTickets += ts;

        owner.send(msg.value * lotteryFee / 100);
    }

    /**
        Draws the winner(s) and transfers the jackpot to the winner(s).
        Only draws the winner if the time condition for the jackpot is met. E.g.
        only one drawing per day
    */
    function drawWinner() {

    }

    function getOwner() returns(address) {
        return owner;
    }

    /**
        Returns the current ticket price in wei
    */
    function getTicketPrice() returns(uint) {
        return ticketPrice;
    }

    // TODO: this can be a smaller int?
    function getTickets() returns(uint) {
        return tickets[msg.sender];
    }

    /**
        Returns the winning percentage. 1 == 100%
    */
    function getWinningPercentage() returns(uint) {
        return 100 * tickets[msg.sender] / totalTickets;
    }

    /**
        Returns the number of accounts 
    */ 
    function getParticipants() returns(uint40) {
        return participants;
    }

    /**
        Returns the current jackpot size in wei
    */
    function getCurrentJackpot() returns(uint) {
        return this.balance;
    }

    /* 
        Set new ticket price in wei
    **/
    function setTicketPrice(uint newPrice) onlyOwner {
        ticketPrice = newPrice;
    }

    /*
        Returns lottery fee in percent. 1 == 1%
    **/
    function getLotteryFee() returns(uint8) {
        return lotteryFee;
    }

    /*
        Sets the lottery fee. Maximum possible fee 7%
    **/
    function setLotteryFee(uint8 newFee) onlyOwner { // TODO: fee must only be set for next drawing not current one
        if (newFee > 7) throw;
        lotteryFee = newFee;
    }

    /* Function to recover the funds on the contract */
    function kill() onlyOwner { 
        selfdestruct(owner); 
    }
}
