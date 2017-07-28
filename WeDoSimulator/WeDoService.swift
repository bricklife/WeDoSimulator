//
//  WeDoService.swift
//  WeDoSimulator
//
//  Created by Shinichiro Oba on 2017/07/27.
//  Copyright © 2017 bricklife.com. All rights reserved.
//

import Foundation
import CoreBluetooth

class WeDoService {
    
    static let services = [
        DeviceService.service,
        IOService.service,
        DeviceInformationService.service,
    ]
    
    static let characteristics: [Characteristic] = services.flatMap { $0.characteristics }
    
    static func characteristic(uuid: CBUUID) -> Characteristic? {
        let uuidString = uuid.uuidString
        return characteristics.first { $0.uuid == uuidString }
    }
}

class DeviceService {
    
    static let name = "LPF2 Smart Hub 2 I/O"
    
    static let service = Service(uuid: "00001523-1212-EFDE-1523-785FEABCD123", characteristics: [
        nameChar,
        buttonChar,
        portTypeChar,
        lowVoltageAlert,
        highCurrentAlert,
        lowSignalAlert,
        turnOffDevice,
        vccPortControl,
        batteryTypeIndicator,
        disconnectChar,
        ])
    
    static let nameChar =
        Characteristic(uuid: "00001524-1212-EFDE-1523-785FEABCD123",
                       properties: [.read, .write],
                       value: .string(name))
    
    static let buttonChar =
        Characteristic(uuid: "00001526-1212-EFDE-1523-785FEABCD123",
                       properties: [.read, .notify],
                       value: .uint8(0x00))
    
    static let portTypeChar =
        Characteristic(uuid: "00001527-1212-EFDE-1523-785FEABCD123",
                       properties: [.notify],
                       value: .null)
    
    static let lowVoltageAlert =
        Characteristic(uuid: "00001528-1212-EFDE-1523-785FEABCD123",
                       properties: [.read, .notify],
                       value: .uint8(0x00))
    
    static let highCurrentAlert =
        Characteristic(uuid: "00001529-1212-EFDE-1523-785FEABCD123",
                       properties: [.read, .notify],
                       value: .uint8(0x00))
    
    static let lowSignalAlert =
        Characteristic(uuid: "0000152A-1212-EFDE-1523-785FEABCD123",
                       properties: [.read, .notify],
                       value: .uint8(0x00))
    
    static let turnOffDevice =
        Characteristic(uuid: "0000152B-1212-EFDE-1523-785FEABCD123",
                       properties: [.write],
                       value: .null)
    
    static let vccPortControl =
        Characteristic(uuid: "0000152C-1212-EFDE-1523-785FEABCD123",
                       properties: [.read, .write],
                       value: .uint8(0x01))
    
    static let batteryTypeIndicator =
        Characteristic(uuid: "0000152D-1212-EFDE-1523-785FEABCD123",
                       properties: [.read],
                       value: .uint8(0x00))
    
    static let disconnectChar =
        Characteristic(uuid: "0000152E-1212-EFDE-1523-785FEABCD123",
                       properties: [.write],
                       value: .null)
}

class IOService {
    
    static let service = Service(uuid: "00004F0E-1212-EFDE-1523-785FEABCD123", characteristics: [
        sensorValue,
        valueFormat,
        inputCommand,
        outputCommand,
        ])

    static let sensorValue =
        Characteristic(uuid: "00001560-1212-EFDE-1523-785FEABCD123",
                       properties: [.read, .notify],
                       value: .data(Data(bytes: [])))

    static let valueFormat =
        Characteristic(uuid: "00001561-1212-EFDE-1523-785FEABCD123",
                       properties: [.notify],
                       value: .null)
    
    static let inputCommand =
        Characteristic(uuid: "00001563-1212-EFDE-1523-785FEABCD123",
                       properties: [.write, .writeWithoutResponse],
                       value: .null)
    
    static let outputCommand =
        Characteristic(uuid: "00001565-1212-EFDE-1523-785FEABCD123",
                       properties: [.write, .writeWithoutResponse],
                       value: .null)
}

class DeviceInformationService {
    
    static let firmwareRevision = "1.0.06.0000"
    static let softwareRevision = "2.0.00.0000"
    static let manufacturerName = "LEGO System A/S"
    
    static let service = Service(uuid: "180A", characteristics: [
        firmwareRevisionString,
        softwareRevisionString,
        manufacturerNameString,
        ])
    
    static let firmwareRevisionString =
        Characteristic(uuid: "2A26",
                       properties: [.read],
                       value: .string(firmwareRevision))
    
    static let softwareRevisionString =
        Characteristic(uuid: "2A28",
                       properties: [.read],
                       value: .string(softwareRevision))
    
    static let manufacturerNameString =
        Characteristic(uuid: "2A29",
                       properties: [.read],
                       value: .string(manufacturerName))
}
