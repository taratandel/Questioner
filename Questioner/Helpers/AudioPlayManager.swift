//
//  AudioPlayManager.swift
//  Questioner
//
//  Created by negar on 97/Azar/30 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import Foundation
import AVFoundation
import Alamofire

enum AudioPlayerStatus: String {
    case start = "start Playin"
    case finished = "finished Playing"
    case failed = "failed Playing"
    case interrupted = "interrupted"
}

protocol PlayAudioDelegate: class {
    func audioPlayStatus(status: AudioPlayerStatus)
}

let AudioPlayInstance = AudioPlayManager.sharedInstance

class AudioPlayManager: NSObject {
    fileprivate var audioPlayer: AVAudioPlayer?

    weak var delegate: PlayAudioDelegate?


    class var sharedInstance: AudioPlayManager {
        struct Static {
            static let instance: AudioPlayManager = AudioPlayManager()
        }
        return Static.instance
    }
    func playSoundWithPath(_ fileData: Data) {
        do {
            self.audioPlayer = try AVAudioPlayer(data: fileData, fileTypeHint: AVFileType.m4a.rawValue)
            guard let player = self.audioPlayer else { return }

            player.delegate = self
            player.prepareToPlay()

            guard let delegate = self.delegate else {
                return
            }

            if player.play() {
                delegate.audioPlayStatus(status: .start)
            } else {
                delegate.audioPlayStatus(status: .failed)
            }
        } catch {
            self.destroyPlayer()
        }
    }

    func destroyPlayer() {
        self.stopPlayer()
    }

    func stopPlayer() {
        if self.audioPlayer == nil { return }

        self.audioPlayer!.delegate = nil
        self.audioPlayer!.stop()
        self.audioPlayer?.prepareToPlay()
        self.audioPlayer = nil
    }
}

extension AudioPlayManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        UIDevice.current.isProximityMonitoringEnabled = false

        if flag {
            self.delegate?.audioPlayStatus(status: .finished)
        } else {
            self.delegate?.audioPlayStatus(status: .failed)
        }
        self.stopPlayer()
    }

    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        self.stopPlayer()
        self.delegate?.audioPlayStatus(status: .failed)
    }

    func audioPlayerBeginInterruption(_ player: AVAudioPlayer) {
        self.stopPlayer()
        self.delegate?.audioPlayStatus(status: .failed)
    }

    func audioPlayerEndInterruption(_ player: AVAudioPlayer, withOptions flags: Int) {
        self.delegate?.audioPlayStatus(status: .interrupted)
    }
}
