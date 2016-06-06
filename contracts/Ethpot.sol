contract Ethpot {
    struct Player {
        address addr;
        uint winning;
    }

    address private owner;
    uint private ticketPrice = 0.01 ether;
    uint8 private lotteryFee = 1;           // lottery fee in percent 1 == 1% 
    uint private roundDuration = 1 days;

    mapping (address => uint) private tickets;
    address[] private ticketAddresses;
    Player[] private participants;
    uint private currentRoundTimestamp = 0;
    bool private lotteryEnabled = true;
    bytes32 private seed; 
    Player[] public pastWinners; 

    modifier onlyOwner() {
        if (msg.sender != owner) throw;
        _
    }

    modifier onlyLotteryEnabled() {
        if (!lotteryEnabled) throw; 
        _
    }

    modifier onlyRoundActive() {
        if (currentRoundTimestamp + roundDuration <= now) throw;
        _
    }

    modifier onlyRoundNotActive() {
        if (currentRoundTimestamp + roundDuration > now) throw;
        _
    }

    modifier onlyNoParticipants() { 
        if (participants.length > 0) throw;
        _
    }

    modifier checkSenderValue() {
        if (msg.value > 0) buyTickets(uintToString(block.timestamp));
        _
    }

    /**
        Takes random string to initialize seed
    */
    function Ethpot(string secret) {
        owner = msg.sender;
        resetLottery();
        newRound(secret); 
    }

    //TODO: provide good server seed upon starting lottery. start lottery function
    //TODO: write unit tests truffle

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
        Takes random string secret for seed
    */
    function buyTickets(string secret) onlyRoundActive {  
        if (msg.value < ticketPrice) throw;

        updateSeed(secret);

        var refund = msg.value % ticketPrice;
        if (refund > 0) {
            if (!msg.sender.send(refund))
                throw;
        }

        if (tickets[msg.sender] == 0) {
            participants.push(Player({
                addr: msg.sender,
                winning: 0
            }));
        } 
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
        Takes random string secret to initialize a new seed. 
    
    */
    function drawWinner(string secret) onlyRoundNotActive checkSenderValue returns(address) { 
        address winner = 0x0;
        if (participants.length > 0) {
            winner = ticketAddresses[uint(sha3(seed, uintToString(block.timestamp))) % ticketAddresses.length];
            uint pot = this.balance;
            if (!winner.send(this.balance))
                    throw;

            pastWinners.push(Player({
                addr: winner,
                winning: pot
            }));
        }
        resetLottery();
        if (lotteryEnabled) newRound(secret);  

        return winner;
    }

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
        Returns the winning percentage. 
    */
    function getWinningPercentage() checkSenderValue returns(uint) {
        return 100 * tickets[msg.sender] / ticketAddresses.length;
    }

    /**
        Returns the number of accounts 
    */ 
    function getParticipants() checkSenderValue returns(uint) {
        return participants.length;
    }

    /**
        Returns the current jackpot size in wei
    */
    function getCurrentJackpot() checkSenderValue returns(uint) {
        return this.balance;
    }

    function getTotalNumberOfTickets() checkSenderValue returns(uint) {
        return ticketAddresses.length;
    }

    /**
        Set length of a round until next drawing in seconds
    */
    function setRoundDuration(uint24 roundDur) onlyOwner onlyNoParticipants {
        roundDuration = roundDur * 1 seconds;
    }

    /**
        Set new ticket price in wei
    */
    function setTicketPrice(uint newPrice) onlyOwner onlyNoParticipants {
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
    function setLotteryFee(uint8 newFee) onlyOwner onlyNoParticipants { 
        if (newFee > 7) throw;
        lotteryFee = newFee;
    }

    /**
        Starting with the next round, the lottery and any participation will be paused
    */
    function pauseLottery() onlyOwner {
        lotteryEnabled = false;
    }

    /**
        Resumes the lottery with an new round. This method only when there are not participants and the jackpot is empty. 
        If the old round is still running, it has to be waited until the winner is drawn.
    */
    function resumeLottery(string secret) onlyOwner returns(uint) {
        lotteryEnabled = true;
        return newRound(secret);
    }

    function transferOwnership(address newOwner) onlyOwner {
        owner = newOwner;
    }

    function kill() onlyOwner { 
        selfdestruct(owner); 
    }

    /**
        Starts a new lottery round
    */
    function newRound(string secret) onlyLotteryEnabled onlyRoundNotActive onlyNoParticipants private returns(uint) {
        updateSeed(secret);
        currentRoundTimestamp = now;
        return currentRoundTimestamp;
    }

    function resetLottery() private {
        delete ticketAddresses; 
        delete seed;
        clearTicketsMapping();
        delete participants;
    }

    function pushTickets(uint pticketCnt, address padr) private {
        for (uint i = 0; i < pticketCnt; i++) {
            ticketAddresses.push(padr);
        }
    }

    function updateSeed(string secret) private {
        seed = sha3(seed, secret);
    }

    function clearTicketsMapping() private {
        for (uint i = 0; i < participants.length; i++) {
            tickets[participants[i].addr] = 0;
        }
    }

    function bytes32ToBytes(bytes32 b) private returns (bytes) {
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
        return string(bytes32ToBytes(uintToBytes(v)));
    }
}
