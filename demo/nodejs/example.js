const ex = require('../../ffi/nodejs/build/Release/rgb_node')

const config = {
    network: "testnet",
    stash_endpoint: "lnpz:/tmp/rgb-node/testnet/stashd.rpc",
    contract_endpoints: {
        Fungible: "lnpz:/tmp/rgb-node/testnet/fungibled.rpc"
    },
    threaded: true,
    datadir: "/tmp/rgb-node/"
}

const issueData = {
    network: "testnet",
    ticker: "USDT",
    name: "USD Tether",
    issue_structure: "SingleIssue",
    allocations: [{ coins: 6660000, vout:0, txid: "5aa2d0a8098371ee12b4b59f43ffe6a2de637341258af65936a5baa01da49e9b" }],
    precision: 0,
    prune_seals: [],
}

const transferData = {
    inputs: ["5aa2d0a8098371ee12b4b59f43ffe6a2de637341258af65936a5baa01da49e9b:0"],
    allocate: [
        { coins: 6660000, vout: 0, txid: "5aa2d0a8098371ee12b4b59f43ffe6a2de637341258af65936a5baa01da49e9b" }
    ],
    invoice: "rgb20:utxob1rtvk9vxwhrj39vyd9f84thssr53k088pv59f078quhcc5g6pavzscynjnq?asset=rgb162s2e0duqfn5shwcjh3m47vg4uh5xjcsze09rjl9z0mxh3aea9jqvu2mz3&amount=6660000",
    prototype_psbt: "cHNidP8BAFICAAAAAZ38ZijCbFiZ/hvT3DOGZb/VXXraEPYiCXPfLTht7BJ2AQAAAAD/////AfA9zR0AAAAAFgAUezoAv9wU0neVwrdJAdCdpu8TNXkAAAAATwEENYfPAto/0AiAAAAAlwSLGtBEWx7IJ1UXcnyHtOTrwYogP/oPlMAVZr046QADUbdDiH7h1A3DKmBDck8tZFmztaTXPa7I+64EcvO8Q+IM2QxqT64AAIAAAACATwEENYfPAto/0AiAAAABuQRSQnE5zXjCz/JES+NTzVhgXj5RMoXlKLQH+uP2FzUD0wpel8itvFV9rCrZp+OcFyLrrGnmaLbyZnzB1nHIPKsM2QxqT64AAIABAACAAAEBKwBlzR0AAAAAIgAgLFSGEmxJeAeagU4TcV1l82RZ5NbMre0mbQUIZFuvpjIBBUdSIQKdoSzbWyNWkrkVNq/v5ckcOrlHPY5DtTODarRWKZyIcSEDNys0I07Xz5wf6l0F1EFVeSe+lUKxYusC4ass6AIkwAtSriIGAzcrNCNO18+cH+pdBdRBVXknvpVCsWLrAuGrLOgCJMALENkMak+uAACAAQAAgAAAAAAiBgKdoSzbWyNWkrkVNq/v5ckcOrlHPY5DtTODarRWKZyIcRDZDGpPrgAAgAAAAIAAAAAAACICA57/H1R6HV+S36K6evaslxpL0DukpzSwMVaiVritOh75EO3kXMUAAACAAAAAgAEAAIAA",
    consignment_file: "/tmp/rgb-node/output/consignment",
    transaction_file: "/tmp/rgb-node/output/transaction"
}

async function main() {
    await ex.start_rgb(config.network, config.stash_endpoint, JSON.stringify(config.contract_endpoints), config.threaded,
             config.datadir)
    .then(runtime => {
        console.log('Calling issue')
        ex.issue(runtime, JSON.stringify(issueData))
        return runtime
    })
    .then(runtime => {
        console.log('Calling transfer')
        return ex.transfer(runtime, JSON.stringify(transferData.inputs), JSON.stringify(transferData.allocate),
           transferData.invoice, transferData.prototype_psbt, transferData.consignment_file,
           transferData.transaction_file)
    })
}

main().catch( e => {
    console.error('ERR: ' + e)
    process.exit(1)
})
