//
//  UTKAppComm.swift
//  SocketDemo
//
//  Created by Lingfeng Liu on 2018/11/22.
//  Copyright © 2018 UTEAMTEC. All rights reserved.
//

import Foundation

class UTKAppComm:NSObject {
    
    static let globalInstance = UTKAppComm()
    
    var sktComm:UTKComm?
    
    private override init() {
        super.init()
        sktComm = UTKComm.init(ip: "127.0.0.1", port: 9002)
    }
    
    func connect() {
        sktComm?.connect()
    }
}
