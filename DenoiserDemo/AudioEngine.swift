//
//  VBAudioEngine.swift
//
//  Created by Sergio Torres on 5/16/15.
//
import SwiftUI
import AVFoundation
import AudioKit
import RNNoiseSwift

class VBAudioEngine: ObservableObject {
    
    static let shared = VBAudioEngine()

    @Published var isMicOn: Bool = false { didSet { didSetIsMicOn() }}
    var engine = AudioEngine()
    var mic: AudioEngine.InputNode?
    var mixer = Mixer()
    let denoiser = RNNoise()

    init() {
        requestMicrophonePermission()
        setAudioSessionPrefrences()
        mic = engine.input
        
        guard let mic = mic else { return }
        mixer.addInput(mic)
        engine.output = mixer
    }
    
    func didSetIsMicOn() {
        if isMicOn {
            try? engine.start()
            noiseReduction()
        } else {
            engine.stop()
            engine.output?.avAudioNode.removeTap(onBus: 0)
        }
    }
    
    func noiseReduction() {
        engine.output?.reset()
        let outputFormat = mixer.avAudioNode.outputFormat(forBus: 0)
        let output = mixer
        output.avAudioNode.installTap(onBus: 0, bufferSize: 1024, format: outputFormat, block: { [weak self] (buffer, when) in
            guard let self = self else { return }
            denoiser.process(buffer)
        })
        engine.avEngine.prepare()
        
        engine.output = mixer
    }
    
    func requestMicrophonePermission() {
        switch AVAudioApplication.shared.recordPermission {
        case .undetermined:
            AVAudioApplication.requestRecordPermission { granted in
                print("We have permission to use the mic.")
            }
        default:
            print("Unknown microphone permission status.")
        }
    }
    
    func setAudioSessionPrefrences() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default, options: [.allowBluetoothA2DP])
            try session.setActive(true)
        } catch {
            print("AVAudioSession setup error: \(error)")
        }
    }
}
