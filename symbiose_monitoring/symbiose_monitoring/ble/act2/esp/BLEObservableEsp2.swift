//
//  BLEObservable.swift
//  SwiftUI_BLE
//
//  Created by Al on 26/10/2022.
//

import Foundation
import CoreBluetooth

class BLEObservableEsp2:ObservableObject{
    
    enum ConnectionState {
        case disconnected,connecting,discovering,ready
    }
    
    @Published var periphList:[Periph] = []
    @Published var connectedPeripheral:Periph? = nil
    @Published var connectionState:ConnectionState = .disconnected
    @Published var dataReceived:[DataReceived] = []
    
    @Published var rfid1: Bool = false
    @Published var rfid2: Bool = false
    @Published var rfid3: Bool = false
        
    @Published var esp2Status: String = ""
    
    init(){
        _ = BLEManagerEsp2.instance
    }
    
    func startScann(){
        BLEManagerEsp2.instance.scan { p,s in
            let periph = Periph(blePeriph: p,name: s)
            
            if periph.name == "esp_led_2"{
                self.connectTo(p: periph)
                self.stopScann()
            }
            
        }
    }
    
    func stopScann(){
        BLEManagerEsp2.instance.stopScan()
    }
    
    func connectTo(p:Periph){
        connectionState = .connecting
        BLEManagerEsp2.instance.connectPeripheral(p.blePeriph) { cbPeriph in
            self.connectionState = .discovering
            BLEManagerEsp2.instance.discoverPeripheral(cbPeriph) { cbPeriphh in
                self.connectionState = .ready
                self.connectedPeripheral = p
            }
        }
        BLEManagerEsp2.instance.didDisconnectPeripheral { cbPeriph in
            if self.connectedPeripheral?.blePeriph == cbPeriph{
                self.connectionState = .disconnected
                self.connectedPeripheral = nil
            }
        }
    }
    
    func disconnectFrom(p:Periph){
        
        BLEManagerEsp2.instance.disconnectPeripheral(p.blePeriph) { cbPeriph in
            if self.connectedPeripheral?.blePeriph == cbPeriph{
                self.connectionState = .disconnected
                self.connectedPeripheral = nil
            }
        }
        
    }
    
    func sendString(str:String){
        
        let dataFromString = str.data(using: .utf8)!
        
        BLEManagerEsp2.instance.sendData(data: dataFromString) { c in
            
        }
    }
    
    func sendData(){
        let d = [UInt8]([0x00,0x01,0x02])
        let data = Data(d)
        let dataFromString = String("Toto").data(using: .utf8)
        
        BLEManagerEsp2.instance.sendData(data: data) { c in
            
        }
    }
    
    func readData(){
        BLEManagerEsp2.instance.readData()
    }
    
    func listen(c:((String)->())){
        
        BLEManagerEsp2.instance.listenForMessages { data in
            
            if let d = data{
                if let str = String(data: d, encoding: .utf8) {
                    print(str)
                    switch str {
                    case "rfid1":
                        self.rfid1 = true
                    case "rfid2":
                        self.rfid2 = true
                    case "rfid3":
                        self.rfid3 = true
                    default:
                        print(str)
                    }
                    
                    if (self.rfid1 && self.rfid2 && self.rfid3) {
                        self.esp2Status = "endact2"
                        print("endact2")
                    }
                }
            }
            
        }
        
    }
    
}
