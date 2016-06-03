contract Ethpot {
    address private owner;
    uint private ticketPrice = 0.01 ether;
    // lottery fee in percent 1 == 1% 
    uint8 private lotteryFee = 1;

    mapping (address => uint) private tickets;
    uint40 private participants;
    uint private totalTickets;
    // past winners array
    string private seed; //TODO: should this string be limited in length to prevent attacks that spent all gas with huge strings?

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
        is interpreted as buying tickets.
        An account may also call buyTickets directly in order to provide its own
        seed
    **/
    function () {
        buyTickets(string(byte32ToBytes(uintToBytes(block.timestamp))));
    }

    /**
        Determines the number of tickets that can be bought with 
        the ETH that was sent to the contract. Refunds any remaining
        ETH to the sender. 
    */
    function buyTickets(string pseed) {  // TODO: call buy tickets from any function to allow sending funds via any function call
        if (msg.value < ticketPrice) throw;

        seed = strConcat(seed, pseed);

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
    function drawWinner() returns(uint) { // TODO: time condition
        seed = strConcat(seed, string(byte32ToBytes(uintToBytes(block.timestamp))));

        return uint(sha3(seed)) % totalTickets;
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

    function getRandomNumber(string seed) private returns(bytes32) {
        //return sha3(seed);
        return uintToBytes(block.timestamp);
    }

    function strConcat(string a, string b) private returns (string) {
        bytes memory b_a = bytes(a);
        bytes memory b_b = bytes(b);
        string memory ab = new string(b_a.length + b_b.length);
        bytes memory b_ab = bytes(ab);
        uint k = 0;

        for (uint i = 0; i < b_a.length; i++) b_ab[k++] = b_a[i];
        for (i = 0; i < b_b.length; i++) b_ab[k++] = b_b[i];

        return string(b_ab);
    }

    function byte32ToBytes(bytes32 b) private returns (bytes) {
        bytes memory bm = new bytes(b.length);
        for (uint i = 0; i < b.length; i++) bm[i] = b[i];
        return bm;
    }

    function uintToBytes(uint v) constant private returns (bytes32 ret) {
        if (v == 0) {
            ret = '0';
        }
        else {
            while (v > 0) {
                ret = bytes32(uint(ret) / (2 ** 8));
                ret |= bytes32(((v % 10) + 48) * 2 ** (8 * 31));
                v /= 10;
            }
        }
        return ret;
    }

    /* Function to recover the funds on the contract */
    function kill() onlyOwner { 
        selfdestruct(owner); 
    }
}
