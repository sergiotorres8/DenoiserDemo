//
//  ContentView.swift
//  NoiseReductionDemo
//
//  Created by Sergio Torres on 4/28/25.
//

import SwiftUI
import AVKit

struct ContentView: View {
    @StateObject var engine = VBAudioEngine()
    
    var body: some View {
        VStack(spacing: 48) {
            MicToggleButton(isOn: $engine.isMicOn)
            airplayButton
        }
    }
    
    var airplayButton: some View {
        Button {
            airplayPressed()
        } label: {
            Image("airplay")
                .renderingMode(.template)
                .foregroundColor(.primary)
        }
    }
    
    func airplayPressed() {
        let routePickerView = AVRoutePickerView()
        let subviews = routePickerView.subviews
        for view in subviews {
            if let button = view as? UIButton {
                button.sendActions(for: .touchUpInside)
            }
        }
    }
}

#Preview {
    ContentView()
}
