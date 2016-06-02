// Factory "morphs" into a Pudding class.
// The reasoning is that calling load in each context
// is cumbersome.

(function() {

  var contract_data = {
    abi: [{"constant":false,"inputs":[],"name":"kill","outputs":[],"type":"function"},{"constant":false,"inputs":[],"name":"getOwner","outputs":[{"name":"","type":"address"}],"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"type":"function"},{"inputs":[],"type":"constructor"}],
    binary: "606060405260008054600160a060020a0319163317905560848060226000396000f36060604052361560315760e060020a600035046341c0e1b581146033578063893d20e814604e5780638da5cb5b146065575b005b603160005433600160a060020a039081169116146076576002565b600054600160a060020a03165b6060908152602090f35b605b600054600160a060020a031681565b600054600160a060020a0316ff",
    unlinked_binary: "606060405260008054600160a060020a0319163317905560848060226000396000f36060604052361560315760e060020a600035046341c0e1b581146033578063893d20e814604e5780638da5cb5b146065575b005b603160005433600160a060020a039081169116146076576002565b600054600160a060020a03165b6060908152602090f35b605b600054600160a060020a031681565b600054600160a060020a0316ff",
    address: "0xb8da227e5554c7effca244e0e0990128b8d568ea",
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
