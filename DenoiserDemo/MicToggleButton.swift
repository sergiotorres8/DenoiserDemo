//
//  MicToggleButton.swift
//  MicrophoneLive
//
//  Created by Sergio Torres on 3/28/21.
//

import SwiftUI

struct MicToggleButton: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var isOn: Bool
    let condition: () -> Bool
    
    init(isOn: Binding<Bool>, condition: @escaping () -> Bool = { return true }) {
        _isOn = isOn
        self.condition = condition
    }
    
    var body: some View {
        Button {
            if condition() || isOn == true {
                isOn.toggle()
            }
        } label: {
            ZStack {
                Circle()
                    .frame(width: 80, height: 80)
                    .foregroundStyle(.secondary.opacity(0.1))
                    .overlay(
                        Circle()
                            .stroke(.tertiary, lineWidth: 0.5)
                    )
                Image(isOn ? "on" : "off")
                    .renderingMode(.template)
                    .foregroundColor(colorScheme == .light && isOn ? .blue : nil)
            }
        }.buttonStyle(.plain)
    }
}

#Preview {
    struct ContentView: View {
        @State var isOn = true
        
        var body: some View {
            MicToggleButton(isOn: $isOn)
                .padding(40)
        }
    }
    return ContentView()
}
