//
//  RGB.swift
//  RGB Demo App
//
//  Created by Jason van den Berg on 2020/07/11.
//  Copyright © 2020 LNP/BP Standards Association. All rights reserved.
//

import Foundation

enum RuntimeError: Error {
    case start
    case issue
    case transfer
}

class Runtime {
    private var runtime: CResult

    init(_ args: StartRgbArgs) throws {
        let network = UnsafeMutablePointer<Int8>(mutating: (args.network as NSString).utf8String)
        let stashEndpoint = UnsafeMutablePointer<Int8>(mutating: (args.stashEndpoint as NSString).utf8String)
        let contractEndpoints = UnsafeMutablePointer<Int8>(mutating: (args.contractEndpoints.description as NSString).utf8String)
        let datadir = UnsafeMutablePointer<Int8>(mutating: (args.datadir as NSString).utf8String)

        runtime = start_rgb(network, stashEndpoint, contractEndpoints, args.threaded, datadir)

        guard runtime.result.rawValue == 0 else {
            throw RuntimeError.start
        }
    }

    func issueAsset(_ args: IssueArgs) throws {
        let cs = (try args.toJson()).utf8String
        let buffer = UnsafeMutablePointer<Int8>(mutating: cs)

        try withUnsafePointer(to: &runtime.inner) {ptr in
            guard issue(ptr, buffer).result.rawValue == 0 else {
                throw RuntimeError.issue
            }
        }
    }

    func transferAsset(_ args: TransferArgs) throws {
        let inputs = UnsafeMutablePointer<Int8>(mutating: (args.inputs.description as NSString).utf8String)
        let allocate = UnsafeMutablePointer<Int8>(mutating: (args.allocate.description as NSString).utf8String)
        let invoice = UnsafeMutablePointer<Int8>(mutating: (args.invoice as NSString).utf8String)
        let prototype_psbt = UnsafeMutablePointer<Int8>(mutating: (args.prototype_psbt as NSString).utf8String)
        let consigment_file = UnsafeMutablePointer<Int8>(mutating: (args.consignment_file as NSString).utf8String)
        let transaction_file = UnsafeMutablePointer<Int8>(mutating: (args.transaction_file as NSString).utf8String)

        try withUnsafePointer(to: &runtime.inner) {ptr in
            guard transfer(ptr, inputs, allocate, invoice, prototype_psbt, consigment_file, transaction_file).result.rawValue == 0 else {
                throw RuntimeError.transfer
            }
        }
    }

    deinit {
        //TODO free runtime memory with ffi destroy function when available
    }
}
