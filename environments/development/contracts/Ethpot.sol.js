// Factory "morphs" into a Pudding class.
// The reasoning is that calling load in each context
// is cumbersome.

(function() {

  var contract_data = {
    abi: [{"constant":false,"inputs":[{"name":"newPrice","type":"uint256"}],"name":"setTicketPrice","outputs":[],"type":"function"},{"constant":false,"inputs":[{"name":"roundDur","type":"uint24"}],"name":"setRoundDuration","outputs":[],"type":"function"},{"constant":false,"inputs":[],"name":"kill","outputs":[],"type":"function"},{"constant":false,"inputs":[],"name":"getTickets","outputs":[{"name":"","type":"uint256"}],"type":"function"},{"constant":false,"inputs":[],"name":"getParticipants","outputs":[{"name":"","type":"uint256"}],"type":"function"},{"constant":false,"inputs":[],"name":"getRoundDuration","outputs":[{"name":"","type":"uint256"}],"type":"function"},{"constant":false,"inputs":[],"name":"getTicketPrice","outputs":[{"name":"","type":"uint256"}],"type":"function"},{"constant":false,"inputs":[],"name":"getCurrentJackpot","outputs":[{"name":"","type":"uint256"}],"type":"function"},{"constant":false,"inputs":[],"name":"getTotalNumberOfTickets","outputs":[{"name":"","type":"uint256"}],"type":"function"},{"constant":false,"inputs":[],"name":"pauseLottery","outputs":[],"type":"function"},{"constant":false,"inputs":[{"name":"secret","type":"string"}],"name":"buyTickets","outputs":[],"type":"function"},{"constant":false,"inputs":[],"name":"getLotteryFee","outputs":[{"name":"","type":"uint8"}],"type":"function"},{"constant":false,"inputs":[{"name":"newFee","type":"uint8"}],"name":"setLotteryFee","outputs":[],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"pastWinners","outputs":[{"name":"addr","type":"address"},{"name":"winning","type":"uint256"}],"type":"function"},{"constant":false,"inputs":[{"name":"secret","type":"string"}],"name":"resumeLottery","outputs":[{"name":"","type":"uint256"}],"type":"function"},{"constant":false,"inputs":[{"name":"secret","type":"string"}],"name":"drawWinner","outputs":[{"name":"","type":"address"}],"type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"type":"function"},{"constant":false,"inputs":[],"name":"getWinningPercentage","outputs":[{"name":"","type":"uint256"}],"type":"function"},{"inputs":[{"name":"secret","type":"string"}],"type":"constructor"}],
    binary: "60606040819052662386f26fc1000060019081556002805460ff199081168317909155620151806003556000600755600880549091169091179055610dbf388190039081908339810160405280510160008054600160a060020a031916331790556100ae600580546000808355919091526100d6907f036b6384b5eca791c62761152d0c79bb0604c104a5fb6f4eb0703f3154bb3db0908101905b80821115610135576000815560010161009a565b6100c68160085460009060ff16151561018957610002565b5050610b918061020e6000396000f35b50600060095561013960005b60065481101561018657600060046000506000600660005084815481101561000257600202600080516020610d9f8339815191520154600160a060020a03169091525060205260408120556001016100e2565b5090565b6006805460008083559190915261018690600202600080516020610d9f833981519152908101905b80821115610135578054600160a060020a031916815560006001820155600201610161565b50565b600354600754429101111561019d57610002565b60065460009011156101ae57610002565b610202826009600050548160405180836000191681526020018280519060200190808383829060006004602084601f0104600f02600301f15090500192505050604051809103902060096000508190555050565b5050426007819055905600606060405236156100da5760e060020a600035046315981650811461012e5780633fc45f2b1461015057806341c0e1b5146101725780634ed02622146101915780635aa68ac0146101ab5780638473808f146101c557806387bb7ae0146101df5780639f57d16e146101f9578063a10f60de14610213578063ab73e1441461022d578063bfdf55f21461024c578063cf72f718146102aa578063e0cd7a20146102c4578063e499e79c146102e6578063eebd3ab514610359578063f0935d7b146103bb578063f2fde38b1461041f578063fbff1b8a14610441575b61045b61045d61045f425b6040805160208101909152600081526104cb6104d38360008160001415610a9757507f30000000000000000000000000000000000000000000000000000000000000005b6104ce565b61045b600435600054600160a060020a0390811633909116146107c057610002565b61045b600435600054600160a060020a0390811633909116146107d157610002565b61045b600054600160a060020a0390811633909116146107ec57610002565b610464600060003411156107fa576107fa61045f426100e5565b610464600060003411156108185761081861045f426100e5565b610464600060003411156108215761082161045f426100e5565b6104646000600034111561082a5761082a61045f426100e5565b610464600060003411156108335761083361045f426100e5565b610464600060003411156108445761084461045f426100e5565b61045b600054600160a060020a03908116339091161461084d57610002565b6040805160206004803580820135601f810184900484028501840190955284845261045b9491936024939092918401919081908401838280828437509496505050505050505b60035460075460009182914291011161057557610002565b610476600060003411156108595761085961045f426100e5565b61045b600435600054600160a060020a03908116339091161461086557610002565b61048c600435600a8054829081101561000257506000526002027fc65a7bb8d6351c1cf70c95a316cc6a92839c986682d98bc35f958f4883f9d2a88101547fc65a7bb8d6351c1cf70c95a316cc6a92839c986682d98bc35f958f4883f9d2a990910154600160a060020a03919091169082565b6040805160206004803580820135601f810184900484028501840190955284845261046494919360249390929184019190819084018382808284375094965050505050505060008054600160a060020a03908116339091161461089657610002565b6040805160206004803580820135601f81018490048402850184019095528484526104af949193602493909291840191908190840183828082843750949650505050505050600060006000426003600050546007600050540111156108bc57610002565b61045b600435600054600160a060020a039081163390911614610a5c57610002565b61046460006000341115610a7157610a7161045f426100e5565b005b565b610292565b60408051918252519081900360200190f35b6040805160ff9092168252519081900360200190f35b60408051600160a060020a03909316835260208301919091528051918290030190f35b60408051600160a060020a039092168252519081900360200190f35b90505b919050565b604080516020818101835260008083528351808301855281815293519293929091908059106104ff5750595b90808252806020026020018201604052509150600090505b6020811015610a555783816020811015610002571a60f860020a0282828151811015610002579060200101907effffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916908160001a905350600101610517565b60015434101561058457610002565b6105d9835b6009600050548160405180836000191681526020018280519060200190808383829060006004602084601f0104600f02600301f15090500192505050604051809103902060096000508190555050565b6001543406915060008211156106145760405133600160a060020a031690600090849082818181858883f19350505050151561061457610002565b33600160a060020a031660009081526004602052604081205414156106a9576006805460018101808355828183801582901161066957600202816002028360005260206000209182019101610669919061074b565b5050506000928352506020808320604080518082019091523380825292018490526002929092029091018054600160a060020a0319169091178155600101555b5060015433600160a060020a03811660009081526004602052604081208054349490940493840190556107749183915b828110156107b25760058054600181018083558281838015829011610abd57818360005260206000209182019101610abd9190610969565b600680546000808355919091526107bd906002027ff652222313e28459528d920b65115c16c04f3efc82aaedc97be59f3f377c0d3f908101905b80821115610770578054600160a060020a03191681556000600182015560020161074b565b5090565b60405160008054600254600160a060020a039190911692606460ff929092163402919091049082818181858883f1935050505015156107b257610002565b505050565b60018190555b50565b60065460009011156107b757610002565b60065460009011156107e257610002565b62ffffff16600355565b600054600160a060020a0316ff5b5033600160a060020a03166000908152600460205260409020545b90565b50600654610815565b50600354610815565b50600154610815565b5030600160a060020a031631610815565b50600554610815565b6008805460ff19169055565b5060025460ff16610815565b600654600090111561087657610002565b60078160ff16111561088757610002565b6002805460ff19168217905550565b6008805460ff191660011790556104cb825b60085460009060ff161515610ae457610002565b60003411156108d1576108d161045f426100e5565b600654600092508290111561092f5760095460058054909161097d426100e5565b50505060009283525060209182902060408051808201909152858152909201839052600202018054600160a060020a031916831781556001018190555b610a3f60058054600080835591909152610b1e907f036b6384b5eca791c62761152d0c79bb0604c104a5fb6f4eb0703f3154bb3db0908101905b808211156107705760008155600101610969565b60405180836000191681526020018280519060200190808383829060006004602084601f0104600f02600301f150905001925050506040518091039020600190040681548110156100025760405160009283526020832090910154600160a060020a03908116945030168031935084929190319082818181858883f193505050501515610a0957610002565b600a80546001810180835582818380158290116108f2576002028160020283600052602060002091820191016108f2919061074b565b60085460ff1615610a5557610a53846108a8565b505b5092915050565b60008054600160a060020a0319168217905550565b5060055433600160a060020a031660009081526004602052604090205460640204610815565b5b600082111561012957600a808304920660300160f860020a0261010090910417610a98565b5050506000928352506020909120018054600160a060020a031916831790556001016106d9565b6003546007544291011115610af857610002565b6006546000901115610b0957610002565b610b1282610589565b504260078190556104ce565b50600060095561071160005b6006548110156107bd576000600460005060006006600050848154811015610002575050507ff652222313e28459528d920b65115c16c04f3efc82aaedc97be59f3f377c0d3f600284020154600160a060020a031682526020526040812055600101610b2a56f652222313e28459528d920b65115c16c04f3efc82aaedc97be59f3f377c0d3f",
    unlinked_binary: "60606040819052662386f26fc1000060019081556002805460ff199081168317909155620151806003556000600755600880549091169091179055610dbf388190039081908339810160405280510160008054600160a060020a031916331790556100ae600580546000808355919091526100d6907f036b6384b5eca791c62761152d0c79bb0604c104a5fb6f4eb0703f3154bb3db0908101905b80821115610135576000815560010161009a565b6100c68160085460009060ff16151561018957610002565b5050610b918061020e6000396000f35b50600060095561013960005b60065481101561018657600060046000506000600660005084815481101561000257600202600080516020610d9f8339815191520154600160a060020a03169091525060205260408120556001016100e2565b5090565b6006805460008083559190915261018690600202600080516020610d9f833981519152908101905b80821115610135578054600160a060020a031916815560006001820155600201610161565b50565b600354600754429101111561019d57610002565b60065460009011156101ae57610002565b610202826009600050548160405180836000191681526020018280519060200190808383829060006004602084601f0104600f02600301f15090500192505050604051809103902060096000508190555050565b5050426007819055905600606060405236156100da5760e060020a600035046315981650811461012e5780633fc45f2b1461015057806341c0e1b5146101725780634ed02622146101915780635aa68ac0146101ab5780638473808f146101c557806387bb7ae0146101df5780639f57d16e146101f9578063a10f60de14610213578063ab73e1441461022d578063bfdf55f21461024c578063cf72f718146102aa578063e0cd7a20146102c4578063e499e79c146102e6578063eebd3ab514610359578063f0935d7b146103bb578063f2fde38b1461041f578063fbff1b8a14610441575b61045b61045d61045f425b6040805160208101909152600081526104cb6104d38360008160001415610a9757507f30000000000000000000000000000000000000000000000000000000000000005b6104ce565b61045b600435600054600160a060020a0390811633909116146107c057610002565b61045b600435600054600160a060020a0390811633909116146107d157610002565b61045b600054600160a060020a0390811633909116146107ec57610002565b610464600060003411156107fa576107fa61045f426100e5565b610464600060003411156108185761081861045f426100e5565b610464600060003411156108215761082161045f426100e5565b6104646000600034111561082a5761082a61045f426100e5565b610464600060003411156108335761083361045f426100e5565b610464600060003411156108445761084461045f426100e5565b61045b600054600160a060020a03908116339091161461084d57610002565b6040805160206004803580820135601f810184900484028501840190955284845261045b9491936024939092918401919081908401838280828437509496505050505050505b60035460075460009182914291011161057557610002565b610476600060003411156108595761085961045f426100e5565b61045b600435600054600160a060020a03908116339091161461086557610002565b61048c600435600a8054829081101561000257506000526002027fc65a7bb8d6351c1cf70c95a316cc6a92839c986682d98bc35f958f4883f9d2a88101547fc65a7bb8d6351c1cf70c95a316cc6a92839c986682d98bc35f958f4883f9d2a990910154600160a060020a03919091169082565b6040805160206004803580820135601f810184900484028501840190955284845261046494919360249390929184019190819084018382808284375094965050505050505060008054600160a060020a03908116339091161461089657610002565b6040805160206004803580820135601f81018490048402850184019095528484526104af949193602493909291840191908190840183828082843750949650505050505050600060006000426003600050546007600050540111156108bc57610002565b61045b600435600054600160a060020a039081163390911614610a5c57610002565b61046460006000341115610a7157610a7161045f426100e5565b005b565b610292565b60408051918252519081900360200190f35b6040805160ff9092168252519081900360200190f35b60408051600160a060020a03909316835260208301919091528051918290030190f35b60408051600160a060020a039092168252519081900360200190f35b90505b919050565b604080516020818101835260008083528351808301855281815293519293929091908059106104ff5750595b90808252806020026020018201604052509150600090505b6020811015610a555783816020811015610002571a60f860020a0282828151811015610002579060200101907effffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916908160001a905350600101610517565b60015434101561058457610002565b6105d9835b6009600050548160405180836000191681526020018280519060200190808383829060006004602084601f0104600f02600301f15090500192505050604051809103902060096000508190555050565b6001543406915060008211156106145760405133600160a060020a031690600090849082818181858883f19350505050151561061457610002565b33600160a060020a031660009081526004602052604081205414156106a9576006805460018101808355828183801582901161066957600202816002028360005260206000209182019101610669919061074b565b5050506000928352506020808320604080518082019091523380825292018490526002929092029091018054600160a060020a0319169091178155600101555b5060015433600160a060020a03811660009081526004602052604081208054349490940493840190556107749183915b828110156107b25760058054600181018083558281838015829011610abd57818360005260206000209182019101610abd9190610969565b600680546000808355919091526107bd906002027ff652222313e28459528d920b65115c16c04f3efc82aaedc97be59f3f377c0d3f908101905b80821115610770578054600160a060020a03191681556000600182015560020161074b565b5090565b60405160008054600254600160a060020a039190911692606460ff929092163402919091049082818181858883f1935050505015156107b257610002565b505050565b60018190555b50565b60065460009011156107b757610002565b60065460009011156107e257610002565b62ffffff16600355565b600054600160a060020a0316ff5b5033600160a060020a03166000908152600460205260409020545b90565b50600654610815565b50600354610815565b50600154610815565b5030600160a060020a031631610815565b50600554610815565b6008805460ff19169055565b5060025460ff16610815565b600654600090111561087657610002565b60078160ff16111561088757610002565b6002805460ff19168217905550565b6008805460ff191660011790556104cb825b60085460009060ff161515610ae457610002565b60003411156108d1576108d161045f426100e5565b600654600092508290111561092f5760095460058054909161097d426100e5565b50505060009283525060209182902060408051808201909152858152909201839052600202018054600160a060020a031916831781556001018190555b610a3f60058054600080835591909152610b1e907f036b6384b5eca791c62761152d0c79bb0604c104a5fb6f4eb0703f3154bb3db0908101905b808211156107705760008155600101610969565b60405180836000191681526020018280519060200190808383829060006004602084601f0104600f02600301f150905001925050506040518091039020600190040681548110156100025760405160009283526020832090910154600160a060020a03908116945030168031935084929190319082818181858883f193505050501515610a0957610002565b600a80546001810180835582818380158290116108f2576002028160020283600052602060002091820191016108f2919061074b565b60085460ff1615610a5557610a53846108a8565b505b5092915050565b60008054600160a060020a0319168217905550565b5060055433600160a060020a031660009081526004602052604090205460640204610815565b5b600082111561012957600a808304920660300160f860020a0261010090910417610a98565b5050506000928352506020909120018054600160a060020a031916831790556001016106d9565b6003546007544291011115610af857610002565b6006546000901115610b0957610002565b610b1282610589565b504260078190556104ce565b50600060095561071160005b6006548110156107bd576000600460005060006006600050848154811015610002575050507ff652222313e28459528d920b65115c16c04f3efc82aaedc97be59f3f377c0d3f600284020154600160a060020a031682526020526040812055600101610b2a56f652222313e28459528d920b65115c16c04f3efc82aaedc97be59f3f377c0d3f",
    address: "0x6c4d6c87d354a26e0ed05f1b6190d9545f6bb844",
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
