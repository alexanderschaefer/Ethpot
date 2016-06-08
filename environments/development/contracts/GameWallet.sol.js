// Factory "morphs" into a Pudding class.
// The reasoning is that calling load in each context
// is cumbersome.

(function() {

  var contract_data = {
    abi: [{"constant":false,"inputs":[],"name":"getBalance","outputs":[{"name":"","type":"uint256"}],"type":"function"},{"constant":false,"inputs":[{"name":"newGameContract","type":"address"}],"name":"changeGameContract","outputs":[],"type":"function"},{"constant":false,"inputs":[{"name":"withdrawAmount","type":"uint256"}],"name":"withdraw","outputs":[{"name":"remainingBal","type":"uint256"}],"type":"function"},{"constant":false,"inputs":[],"name":"kill","outputs":[],"type":"function"},{"constant":false,"inputs":[],"name":"deposit","outputs":[{"name":"","type":"uint256"}],"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"type":"function"},{"inputs":[{"name":"pgameContract","type":"address"}],"type":"constructor"}],
    binary: "606060405260405160208061028d83395060806040525160008054600160a060020a03199081163317909155600180549091168217905550610248806100456000396000f3606060405236156100565760e060020a600035046312065fe081146100615780631b37ae0c146100745780632e1a7d4d1461009757806341c0e1b5146100ad578063d0e30db0146100cd578063f2fde38b146100f5575b61011861011a6100d1565b61011d6000600034111561012f57610002565b610118600435600054600160a060020a0390811633919091161461014e57610002565b61011d6004356000600034111561017e57610002565b610118600054600160a060020a039081163391909116146101f257610002565b61011d5b600160a060020a033316600090815260026020526040902080543401908190555b90565b610118600435600054600160a060020a0390811633919091161461021857610002565b005b50565b60408051918252519081900360200190f35b50600160a060020a0333166000908152600260205260409020546100f2565b600034111561015c57610002565b6001805473ffffffffffffffffffffffffffffffffffffffff19168217905550565b600160a060020a0333166000908152600260205260409020548290106101d45760406000818120805485900390559051600160a060020a0333169190849082818181858883f1935050505015156101d457610002565b505033600160a060020a031660009081526002602052604090205490565b600030600160a060020a031631111561020a57610002565b600054600160a060020a0316ff5b600034111561022657610002565b6000805473ffffffffffffffffffffffffffffffffffffffff1916821790555056",
    unlinked_binary: "606060405260405160208061028d83395060806040525160008054600160a060020a03199081163317909155600180549091168217905550610248806100456000396000f3606060405236156100565760e060020a600035046312065fe081146100615780631b37ae0c146100745780632e1a7d4d1461009757806341c0e1b5146100ad578063d0e30db0146100cd578063f2fde38b146100f5575b61011861011a6100d1565b61011d6000600034111561012f57610002565b610118600435600054600160a060020a0390811633919091161461014e57610002565b61011d6004356000600034111561017e57610002565b610118600054600160a060020a039081163391909116146101f257610002565b61011d5b600160a060020a033316600090815260026020526040902080543401908190555b90565b610118600435600054600160a060020a0390811633919091161461021857610002565b005b50565b60408051918252519081900360200190f35b50600160a060020a0333166000908152600260205260409020546100f2565b600034111561015c57610002565b6001805473ffffffffffffffffffffffffffffffffffffffff19168217905550565b600160a060020a0333166000908152600260205260409020548290106101d45760406000818120805485900390559051600160a060020a0333169190849082818181858883f1935050505015156101d457610002565b505033600160a060020a031660009081526002602052604090205490565b600030600160a060020a031631111561020a57610002565b600054600160a060020a0316ff5b600034111561022657610002565b6000805473ffffffffffffffffffffffffffffffffffffffff1916821790555056",
    address: "",
    generated_with: "2.0.9",
    contract_name: "GameWallet"
  };

  function Contract() {
    if (Contract.Pudding == null) {
      throw new Error("GameWallet error: Please call load() first before creating new instance of this contract.");
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
      throw new Error("GameWallet error: Please call load() first before calling new().");
    }

    return Contract.Pudding.new.apply(Contract, arguments);
  };

  Contract.at = function() {
    if (Contract.Pudding == null) {
      throw new Error("GameWallet error: Please call load() first before calling at().");
    }

    return Contract.Pudding.at.apply(Contract, arguments);
  };

  Contract.deployed = function() {
    if (Contract.Pudding == null) {
      throw new Error("GameWallet error: Please call load() first before calling deployed().");
    }

    return Contract.Pudding.deployed.apply(Contract, arguments);
  };

  if (typeof module != "undefined" && typeof module.exports != "undefined") {
    module.exports = Contract;
  } else {
    // There will only be one version of Pudding in the browser,
    // and we can use that.
    window.GameWallet = Contract;
  }

})();
