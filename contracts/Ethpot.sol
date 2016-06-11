contract Ethpot {
    struct Player {
        address addr;
        uint winning;
        uint timestamp;
    }
    struct TicketBatch {
        uint startNo;
        uint endNo;
        address addr;
    }
    struct Tickets {
        uint ticketCnt;
        uint timestamp;
    }

    address private owner;
    uint public ticketPrice = 0.01 ether;     
    uint8 public lotteryFee = 1;              // lottery fee in percent 1 == 1% 
    uint public roundDuration = 60 seconds;

    Player[10] public pastWinners;            // last 10 winners
    uint public pastWinnersCount = 0;
    uint public ticketCount = 0;
    mapping (address => Tickets) private tickets; 
    TicketBatch[] private ticketAddresses;
    uint private ticketAddresses_length = 0;  // keeping track of array length separately. saves gas because we do not need to delete the array upon new round
    uint private currentRoundTimestamp = 0;
    bool private lotteryEnabled = true;
    bytes32 private seed; 

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
        if (ticketCount> 0) throw; // TODO: better replace the throws with ifs? to be cheaper
        _
    }

    modifier checkSenderValue() {
        if (msg.value > 0) buyTickets("");
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
        // TODO: test with LARGE numbers, participants, tickets, etc
    //TODO: add events
    //TODO: add constant keyword to functions that do not change state
    //TODO: add comments to weird constructs used to save gas  
    // TODO: would be nice to know number of participants. can we figure that out in JS?

    /**
        Fallback function used in this contract as means to participate 
        in the lottery. An account sending ETH to the contract, without data,
        is interpreted as buying tickets.
        No string seed provided here if user chooses this way instead of calling 'buyTickets(string secret)'.
        However, by default seed is always complemented with current block time stamp
        To provide an own string secret, n account shall  call buyTickets directly 
    */
    function () {
        buyTickets("");
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

        var ts = msg.value / ticketPrice;
        updateTicketsMap(msg.sender, ts); // TODO: for game contract later might need to use tx.origin to get actual sender?! 
        pushTicketAddresses(ts, msg.sender); 
        ticketCount += ts;

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
        if (ticketCount > 0) {
            winner = binarySearchWinner(uint(sha3(seed, block.timestamp)) % ticketCount);
            uint pot = this.balance;
            if (winner == 0x0 || !winner.send(this.balance)) // TODO: maybe do not throw for winner not found so i can use event
                throw;

            pushPastWinners(winner, pot);
        }
        resetLottery();
        if (lotteryEnabled) newRound(secret);  

        return winner;
    }

    // TODO: this can be a smaller int?
    function getTickets() checkSenderValue returns(uint) {
        if (tickets[msg.sender].timestamp + roundDuration < now) return 0;
        return tickets[msg.sender].ticketCnt;
    }

    /**
        Returns the winning percentage. 
    */
    function getWinningPercentage() checkSenderValue returns(uint) {
        uint ts = tickets[msg.sender].ticketCnt;
        if (tickets[msg.sender].timestamp + roundDuration < now) ts = 0;
        return 100 * ts / ticketCount;
    }

    /**
        Returns the current jackpot size in wei
    */
    function getCurrentJackpot() checkSenderValue returns(uint) {
        return this.balance;
    }

    function getRoundTimeLeft() returns(uint) {
        int timeLeft = int((currentRoundTimestamp + roundDuration) - now);
        if (timeLeft < 0) timeLeft = 0;
        return uint(timeLeft);
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
    function setTicketPrice(uint newPrice) onlyOwner onlyNoParticipants { // TODO: mist says it uses all gas!?!?!?! cannot be
        ticketPrice = newPrice;
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

    function kill() onlyOwner onlyNoParticipants { 
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
        ticketCount = 0;
        delete seed;
        clearTicketAddresses(); 
    } 
    
    function pushPastWinners(address addr, uint winning) private {
        pastWinners[(++pastWinnersCount % 10) - 1] = Player({
            addr: addr,
            winning: winning,
            timestamp: now
        });
    }
    
    /**
        Deleting an array can cost alot of gas if the array is large. To save gas, we never actually delete the array,
        but keep track of its actual length in a separate counter
    */
    function pushTicketAddresses(uint pticketCnt, address paddr) {
        if (ticketAddresses_length == ticketAddresses.length) ticketAddresses.length++;
        ticketAddresses[ticketAddresses_length++] = TicketBatch({
            startNo: ticketCount,
            endNo: ticketCount + pticketCnt - 1,
            addr: paddr
        });
    }
    
    function clearTicketAddresses() {
        ticketAddresses_length = 0;
    }

    function updateTicketsMap(address addr, uint ts) private {
        if (tickets[addr].timestamp + roundDuration < now) tickets[addr].ticketCnt = 0;
        tickets[addr].timestamp = now;
        tickets[addr].ticketCnt += ts;
    }

    function updateSeed(string secret) private {
        seed = sha3(seed, secret, now);
    }

    function binarySearchWinner(uint tno) private returns(address) {
        address winner = 0x0;
        uint i = 0;
        uint lower = 0;
        uint upper = ticketAddresses_length ;
        while ((upper - lower) > 0) {   // TODO: test border cases
            i = (upper - lower) / 2 + lower;
            if (tno < ticketAddresses[i].startNo) {
                upper = i;
            } else if (tno > ticketAddresses[i].endNo) {
                lower = i + 1;
            } else {
                winner = ticketAddresses[i].addr;
                break;
            }
        }
        return winner;
    }
}
