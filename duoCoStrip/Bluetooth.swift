//
//  Bluetooth.swift
//  Demo
//
//  Created by content on 2023/1/26.
//

import Cocoa
import CoreBluetooth

let led: Bluetooth = Bluetooth()

let serviceUUID = CBUUID(string: "FFF0")
let characteristicUUID = CBUUID(string: "FFF3")
let serviceName = "ELK-BLEDOM"

class Bluetooth: NSObject {
    private var centralManager: CBCentralManager?
    var characteristics: Array<CBCharacteristic?> = Array() //设备服务特征（连接成功）
    var peripherals: Array<CBPeripheral> = Array()  //设备
    
    private var connected: ((_ index: Int)->Void)?  //连接成功
    private var disconnected: ((_ index: Int)->Void)?   //已断开连接
    
    func initBLE() {
        let centralQueue = DispatchQueue(label: "content.BLEledControlQueue", attributes: [])
        centralManager = CBCentralManager(delegate: self, queue: centralQueue)
    }
    
    func startScan(connected: @escaping(_ index: Int)->Void, disconnected: @escaping(_ index: Int)->Void) {
        initBLE()
        sleep(2)
        centralManager?.scanForPeripherals(withServices: nil, options: nil)
        debugPrint("开始寻找设备！")
        
        self.connected = connected
        self.disconnected = disconnected
    }
    
    //停止设备搜索
    func stopScan() {
        centralManager?.stopScan()
    }
    
    //连接
    func connect(_ index: Int) {
        centralManager?.connect(self.peripherals[index], options: nil)
    }
    
    //断开连接
    func disconnect(_ index: Int) {
        centralManager?.cancelPeripheralConnection(self.peripherals[index])
    }
    
    func sendMsg(data: Data) {
        for characteristic in self.characteristics {
            if characteristic == nil {
                debugPrint("未连接！")
            } else {
                self.peripherals[0].writeValue(data, for: characteristic!, type: CBCharacteristicWriteType.withoutResponse)
            }
        }
    }
    
    func normalizeName(_ name: String?) -> String {
        if (name != nil) {
            return name!
        }
        return serviceName
    }

}

extension Bluetooth: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch (central.state) {
        case .poweredOff:
            debugPrint("蓝牙已关闭！")
            DispatchQueue.main.async {
                self.centralManager?.stopScan()
            }
            break
        case .unauthorized:
            debugPrint("应用未授权！")
            break
        case .unknown:
            debugPrint("蓝牙管理器状态未知！")
            break
        case .poweredOn:
            debugPrint("蓝牙已打开!")
            break
        case .resetting:
            debugPrint("与系统服务连接暂时丢失！")
            break
        case .unsupported:
            debugPrint("此设备不支持！")
            break
       default:
            break
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if(serviceName == peripheral.name)
        {
            if(!self.peripherals.contains(peripheral))
            {
                peripheral.delegate = self
                self.peripherals.append(peripheral)
                self.characteristics.append(nil)
                
                debugPrint("已发现\(normalizeName(peripheral.name))！")
                debugPrint("uuid：\(peripheral.identifier.uuidString)")
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        debugPrint("\(normalizeName(peripheral.name))已连接！")
        peripheral.delegate = self
        //查找蓝牙设备服务
        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        debugPrint("连接\(peripheral)失败！错误：\(String(describing: error))")
    }
    
    //已断开连接
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        debugPrint("\(normalizeName(peripheral.name))已断开连接！")
        self.characteristics[peripherals.firstIndex(of: peripheral)!] = nil
        self.disconnected!(peripherals.firstIndex(of: peripheral)!)
    }
}

extension Bluetooth: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        debugPrint("已发现\(normalizeName(peripheral.name))的服务！")
        for service in peripheral.services! {
            if (service.uuid == serviceUUID) {
                debugPrint("找到目标服务!")
                //发现服务特征
                peripheral.discoverCharacteristics([characteristicUUID], for: service)
            }
        }
    }
    
    //连接成功
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        debugPrint("已发现\(normalizeName(peripheral.name))的特征！")
        for characteristic in service.characteristics! {
            if (characteristic.uuid == characteristicUUID) {
                debugPrint("可以控制\(normalizeName(peripheral.name))了！")
                
                self.characteristics[peripherals.firstIndex(of: peripheral)!] = characteristic
                self.connected!(peripherals.firstIndex(of: peripheral)!)
            }
        }
    }
}
