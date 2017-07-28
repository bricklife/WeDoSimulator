//
//  GATT.swift
//  WeDoService
//
//  Created by Shinichiro Oba on 2017/07/27.
//  Copyright © 2017 bricklife.com. All rights reserved.
//

import Foundation
import CoreBluetooth

enum Value {
    
    case string(String)
    case uint8(UInt8)
    case data(Data)
    case null
}

extension Value {
    
    var string: String {
        switch self {
        case .string(let value):
            return value
        case .uint8(let value):
            return String(value)
        case .data(let value):
            return value.description
        case .null:
            return "<null>"
        }
    }
    
    var data: Data? {
        switch self {
        case .string(let value):
            return value.data(using: .utf8)
        case .uint8(let value):
            return Data(bytes: [value])
        case .data(let value):
            return value
        case .null:
            return nil
        }
    }
}

struct Characteristic {
    
    let uuid: String
    let properties: CBCharacteristicProperties
    let value: Value
}

extension Characteristic {
    
    var mutableCharacteristic: CBMutableCharacteristic {
        var permissions: CBAttributePermissions = []
        if properties.contains(.read) { permissions.insert(.readable) }
        if properties.contains(.write) { permissions.insert(.writeable) }
        if properties.contains(.writeWithoutResponse) { permissions.insert(.writeable) }
            
        return CBMutableCharacteristic(
            type: CBUUID(string: uuid),
            properties: properties,
            value: nil,
            permissions: permissions)
    }
}

struct Service {
    
    let uuid: String
    let characteristics: [Characteristic]
}

extension Service {
    
    var mutableService: CBMutableService {
        let service = CBMutableService(type: CBUUID(string: uuid), primary: true)
        service.characteristics = characteristics.map { $0.mutableCharacteristic }
        return service
    }
}
