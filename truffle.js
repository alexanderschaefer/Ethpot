module.exports = {
  build: {
    "index.html": "index.html",
    "app.js": [
      "javascripts/app.js"
    ],
    "app.css": [
      "stylesheets/app.css"
    ],
    "images/": "images/"
  },
  deploy: [
    "Ethpot"
  ],
  rpc: {
    host: "localhost",
    port: 8545,
    gas: 3141592,
    gasPrice: 100000000000 //(100 Shannon)
    //from: "0x...." // otherwise defaults to first account
  }
};
