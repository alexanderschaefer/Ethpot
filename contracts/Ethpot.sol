contract Ethpot {
    address private owner;
    uint private ticketPrice = 0.01 ether;
    mapping (address => uint) private balances;

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

    }

    /**
        Determines the number of tickets that can be bought with 
        the ETH that was sent to the contract. Refunds any remaining
        ETH to the sender. 
    */
    function buyTickets() {

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

    /**
        Returns the winning percentage. 1 == 100%
    */
    function getWinningChance() returns(ufixed0x8) {

    }

    /**
        Returns the number of accounts 
    */ 
    function getParticipants() returns(uint40) {
        
    }

    /**
        Returns the current jackpot size in wei
    */
    function getCurrentJackpot() returns(uint) {

    }

    /* 
        Set new ticket price in wei
    **/
    function setTicketPrice(uint newPrice) onlyOwner {
        ticketPrice = newPrice;
    }

    /* Function to recover the funds on the contract */
    function kill() onlyOwner { 
        selfdestruct(owner); 
    }
}
