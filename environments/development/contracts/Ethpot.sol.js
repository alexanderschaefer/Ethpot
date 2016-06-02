// Factory "morphs" into a Pudding class.
// The reasoning is that calling load in each context
// is cumbersome.

(function() {

  var contract_data = {
    abi: [{"constant":false,"inputs":[{"name":"newPrice","type":"uint256"}],"name":"setTicketPrice","outputs":[],"type":"function"},{"constant":false,"inputs":[],"name":"kill","outputs":[],"type":"function"},{"constant":false,"inputs":[],"name":"getParticipants","outputs":[{"name":"","type":"uint40"}],"type":"function"},{"constant":false,"inputs":[],"name":"getTicketPrice","outputs":[{"name":"","type":"uint256"}],"type":"function"},{"constant":false,"inputs":[],"name":"getOwner","outputs":[{"name":"","type":"address"}],"type":"function"},{"constant":false,"inputs":[],"name":"getCurrentJackpot","outputs":[{"name":"","type":"uint256"}],"type":"function"},{"constant":false,"inputs":[],"name":"drawWinner","outputs":[],"type":"function"},{"constant":false,"inputs":[],"name":"buyTickets","outputs":[],"type":"function"},{"constant":false,"inputs":[],"name":"getWinningChance","outputs":[{"name":"","type":"uint8"}],"type":"function"},{"inputs":[],"type":"constructor"}],
    binary: "6060604052662386f26fc1000060015560008054600160a060020a0319163317905561017d8061002f6000396000f3606060405236156100775760e060020a600035046315981650811461007d57806341c0e1b51461009e5780635aa68ac0146100bc57806387bb7ae0146100c6578063893d20e8146100d15780639f57d16e146100e5578063b2185bb1146100f8578063c8199826146100f8578063c84545ec14610100575b6101085b565b61010860043560005433600160a060020a0390811691161461016a57610002565b61010860005433600160a060020a0390811691161461016f57610002565b61010a5b60005b90565b6101246001546100c3565b610136600054600160a060020a03166100c3565b610124600160a060020a033016316100c3565b61010861007b565b6101536100c0565b005b6040805164ffffffffff9092168252519081900360200190f35b60408051918252519081900360200190f35b60408051600160a060020a03929092168252519081900360200190f35b6040805160ff929092168252519081900360200190f35b600155565b600054600160a060020a0316ff",
    unlinked_binary: "6060604052662386f26fc1000060015560008054600160a060020a0319163317905561017d8061002f6000396000f3606060405236156100775760e060020a600035046315981650811461007d57806341c0e1b51461009e5780635aa68ac0146100bc57806387bb7ae0146100c6578063893d20e8146100d15780639f57d16e146100e5578063b2185bb1146100f8578063c8199826146100f8578063c84545ec14610100575b6101085b565b61010860043560005433600160a060020a0390811691161461016a57610002565b61010860005433600160a060020a0390811691161461016f57610002565b61010a5b60005b90565b6101246001546100c3565b610136600054600160a060020a03166100c3565b610124600160a060020a033016316100c3565b61010861007b565b6101536100c0565b005b6040805164ffffffffff9092168252519081900360200190f35b60408051918252519081900360200190f35b60408051600160a060020a03929092168252519081900360200190f35b6040805160ff929092168252519081900360200190f35b600155565b600054600160a060020a0316ff",
    address: "0x5dcaf82a8e951393a87fdef61c31d52babd371d2",
    generated_with: "2.0.9",
    contract_name: "Ethpot"
  };

  function Contract() {
    if (Contract.Pudding == null) {
      throw new Error("Ethpot error: Please call load() first before creating new instance of this contract.");
    }

    Contract.Pudding.apply(this, arguments);
  };

  Contract.load = function(Pudding) {
    Contract.Pudding = Pudding;

    Pudding.whisk(contract_data, Contract);

    // Return itself for backwards compatibility.
    return Contract;
  }

  Contract.new = function() {
    if (Contract.Pudding == null) {
      throw new Error("Ethpot error: Please call load() first before calling new().");
    }

    return Contract.Pudding.new.apply(Contract, arguments);
  };

  Contract.at = function() {
    if (Contract.Pudding == null) {
      throw new Error("Ethpot error: Please call load() first before calling at().");
    }

    return Contract.Pudding.at.apply(Contract, arguments);
  };

  Contract.deployed = function() {
    if (Contract.Pudding == null) {
      throw new Error("Ethpot error: Please call load() first before calling deployed().");
    }

    return Contract.Pudding.deployed.apply(Contract, arguments);
  };

  if (typeof module != "undefined" && typeof module.exports != "undefined") {
    module.exports = Contract;
  } else {
    // There will only be one version of Pudding in the browser,
    // and we can use that.
    window.Ethpot = Contract;
  }

})();
