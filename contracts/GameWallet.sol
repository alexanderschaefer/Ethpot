contract GameWallet {
    address private owner;
    address private gameContract;
    mapping (address => uint) private balances;

    modifier onlyNoValueSent() {
        if (msg.value > 0) throw;
        _
    }

    modifier onlyOwner() {
        if (msg.sender != owner) throw;
        _
    }

    modifier onlyNoFunds {
        if (this.balance > 0) throw;
        _
    }

    function GameWallet(address pgameContract) {
        owner = msg.sender;
        gameContract = pgameContract;
    }

    function deposit() returns (uint) {
        balances[msg.sender] += msg.value;

        return balances[msg.sender];
    }

    function withdraw(uint withdrawAmount) onlyNoValueSent returns (uint remainingBal) {
        if(balances[msg.sender] >= withdrawAmount) {
            balances[msg.sender] -= withdrawAmount;

            if (!msg.sender.send(withdrawAmount)) {
                throw;
            }
        }

        return balances[msg.sender];
    } 

    function getBalance() onlyNoValueSent returns (uint) {
        return balances[msg.sender];
    }

    function () {
        deposit();
    }

    function transferOwnership(address newOwner) onlyOwner onlyNoValueSent {
        owner = newOwner;
    }

    function changeGameContract(address newGameContract) onlyOwner onlyNoValueSent {
        gameContract = newGameContract;
    }

    function kill() onlyOwner onlyNoFunds { 
        selfdestruct(owner); 
    }
}
