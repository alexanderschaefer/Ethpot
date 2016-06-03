contract Ethpot {
    struct Winner {
        address winner;
        uint jackpot;
    }

    address private owner;
    uint private ticketPrice = 0.01 ether;
    // lottery fee in percent 1 == 1% 
    uint8 private lotteryFee = 1;

    mapping (address => uint) private tickets;
    address[] private ticketAddresses;
    uint40 private participants;
    Winner[] public pastWinners; 
    // TODO: past winners array
    bytes32 private seed; 

    modifier onlyOwner() {
        if (msg.sender != owner) throw;
        _
    }

    modifier checkSenderValue() {
        if (msg.value > 0) buyTickets(uintToString(block.timestamp));
        _
    }

    function Ethpot() {
        owner = msg.sender;
    }

    //TODO: provide good server seed upon starting lottery. start lottery function

    /**
        Fallback function used in this contract as means to participate 
        in the lottery. An account sending ETH to the contract, without data,
        is interpreted as buying tickets.
        Seeds with current block time stamp
        An account may also call buyTickets directly in order to provide its own
        secret
    */
    function () {
        buyTickets(uintToString(block.timestamp));
    }

    /**
        Determines the number of tickets that can be bought with 
        the ETH that was sent to the contract. Refunds any remaining
        ETH to the sender. 
    */
    function buyTickets(string secret) {  
        if (msg.value < ticketPrice) throw;

        updateSeed(secret);

        var refund = msg.value % ticketPrice;
        if (refund > 0) {
            if (!msg.sender.send(refund))
                throw;
        }

        if (tickets[msg.sender] == 0) participants++;
        var ts = msg.value / ticketPrice;
        tickets[msg.sender] += ts;
        pushTickets(ts, msg.sender);

        if (!owner.send(msg.value * lotteryFee / 100))
            throw;
    }

    /**
        Draws the winner(s) and transfers the jackpot to the winner(s).
        Only draws the winner if the time condition for the jackpot is met. E.g.
        only one drawing per day
    
    */
    function drawWinner() checkSenderValue returns(address) { // TODO: time condition and reset of lottery
        if (this.balance == 0) throw;
        address winner = ticketAddresses[uint(sha3(seed, uintToString(block.timestamp))) % ticketAddresses.length];
        uint pot = this.balance;
        if (!winner.send(this.balance))
                throw;

        pastWinners.push(Winner({
            winner: address,
            jackpot: pot
        }))
        return winner;
    }

    // TODO: owner function to reset lottery

    /**
        Returns the current ticket price in wei
    */
    function getTicketPrice() checkSenderValue returns(uint) {
        return ticketPrice;
    }

    // TODO: this can be a smaller int?
    function getTickets() checkSenderValue returns(uint) {
        return tickets[msg.sender];
    }

    /**
        Returns the winning percentage. 1 == 100%
    */
    function getWinningPercentage() checkSenderValue returns(uint) {
        return 100 * tickets[msg.sender] / ticketAddresses.length;
    }

    /**
        Returns the number of accounts 
    */ 
    function getParticipants() checkSenderValue returns(uint40) {
        return participants;
    }

    /**
        Returns the current jackpot size in wei
    */
    function getCurrentJackpot() checkSenderValue returns(uint) {
        return this.balance;
    }

    function getTotalNumberOfTickets() returns(uint) {
        return ticketAddresses.length;
    }

    /**
        Set new ticket price in wei
    */
    function setTicketPrice(uint newPrice) checkSenderValue onlyOwner {
        ticketPrice = newPrice;
    }

    /**
        Returns lottery fee in percent. 1 == 1%
    */
    function getLotteryFee() checkSenderValue returns(uint8) {
        return lotteryFee;
    }

    /**
        Sets the lottery fee. Maximum possible fee 7%
    */
    function setLotteryFee(uint8 newFee) checkSenderValue onlyOwner { // TODO: fee must only be set for next drawing not current one
        if (newFee > 7) throw;
        lotteryFee = newFee;
    }

    // TODO: halt lottery

    function transferOwnership(address newOwner) onlyOwner {
        owner = newOwner;
    }

    function kill() onlyOwner { 
        selfdestruct(owner); 
    }

    function pushTickets(uint pticketCnt, address padr) private {
        for (uint i = 0; i < pticketCnt; i++) {
            ticketAddresses.push(padr);
        }
    }

    function updateSeed(string secret) private {
        seed = sha3(seed, secret);
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

    function uintToString(uint v) constant private returns (string) {
        return string(byte32ToBytes(uintToBytes(v)));
    }

}
