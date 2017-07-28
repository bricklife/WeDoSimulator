//
//  WeDoSimulator.swift
//  WeDoSimulator
//
//  Created by Shinichiro Oba on 2017/07/27.
//  Copyright © 2017 bricklife.com. All rights reserved.
//

import Foundation
import CoreBluetooth

class WeDoSimulator: NSObject {
    
    var peripheralManager: CBPeripheralManager!
    
    let services = WeDoService.services.map { $0.mutableService }
    
    override init() {
        super.init()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    func startAdvertising() {
        let advertisementData: [String : Any] = [
            CBAdvertisementDataLocalNameKey: DeviceService.name,
            CBAdvertisementDataServiceUUIDsKey: [CBUUID(string: DeviceService.service.uuid)],
            ]
        peripheralManager.startAdvertising(advertisementData)
    }
    
    func stopAdvertising() {
        peripheralManager.stopAdvertising()
    }
}

extension WeDoSimulator: CBPeripheralManagerDelegate {
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            for service in services {
                peripheralManager.add(service)
            }
        default:
            peripheralManager.removeAllServices()
        }
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        print("didStartAdvertising:", error ?? "success")
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        print("didAdd:", service, error ?? "")
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        print("didReceiveRead:", request.characteristic.uuid)
        
        if let characteristic = WeDoService.characteristic(uuid: request.characteristic.uuid) {
            request.value = characteristic.value.data
            peripheralManager.respond(to: request, withResult: .success)
        } else {
            peripheralManager.respond(to: request, withResult: .requestNotSupported)
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        print("didReceiveWrite:")
        for request in requests {
            print("\t", request.characteristic.uuid, hexDump(request.value!))
        }
        peripheralManager.respond(to: requests[0], withResult: .success)
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        print("didSubscribeTo:", characteristic.uuid)
        if characteristic.uuid.uuidString == DeviceService.portTypeChar.uuid {
            // notify - built-in RBG lgiht
            let data = Data(bytes: [0x00, 0x01, 0x32, 0x17, 0x01, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00])
            peripheralManager.updateValue(data, for: characteristic as! CBMutableCharacteristic, onSubscribedCentrals: nil)
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        print("didUnsubscribeFrom:", characteristic.uuid)
    }
}

fileprivate func hexDump(_ data: Data?) -> String {
    guard let data = data else { return "-" }
    let nsdata = data as NSData
    let len = nsdata.length
    var byteArray = [UInt8](repeating: 0x0, count: len)
    nsdata.getBytes(&byteArray, length:len)
    let byte = byteArray.map { String(format: "%02x", $0) }.joined(separator: " ")
    return "[\(byte)]"
}

