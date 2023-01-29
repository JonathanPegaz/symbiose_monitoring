//
//  ContentView.swift
//  symbiose_monitoring
//
//  Created by Jonathan Pegaz on 21/01/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var BLEespAct2:BLEObservableEspAct2 = BLEObservableEspAct2()
    
    @StateObject var BLEesp2:BLEObservableEsp2 = BLEObservableEsp2()
    @State var bleEspLed2:String = "esp led 2 pas connecté"
    
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text(bleEspLed2)
        }
        .padding()
        .onChange(of: BLEesp2.connectedPeripheral) { newValue in
            if let p = newValue {
                bleEspLed2 = p.name
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
