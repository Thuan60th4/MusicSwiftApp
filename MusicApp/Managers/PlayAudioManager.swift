//
//  PlayAudioManager.swift
//  MusicApp
//
//  Created by Pham Minh Thuan on 04/01/2024.
//

import Foundation
import AVFoundation
import UIKit

class PlayAudioManager {
    static let shared = PlayAudioManager()
    
    weak var playerViewController: PlayerViewController?
    var index = 0
    var player: AVPlayer?
    var tracks: [AudioTrack] = []

    
    func playAudioTrack(from viewController: UIViewController, tracks: [AudioTrack]){
        self.index = 0
        self.tracks = tracks
        let playerView = PlayerViewController()
        playerView.configure(currentTrack: tracks.first)
        playerView.modalPresentationStyle = .overFullScreen
        viewController.present(playerView, animated: true)
        if let url = URL(string: tracks.first?.preview_url ?? ""){
            self.player = AVPlayer(url: url)
            self.player?.play()
        }
        playerViewController = playerView
    }
    
    private func loadCurrentSong(){
        playerViewController?.configure(currentTrack: tracks[index])
        if let url = URL(string: tracks[index].preview_url ?? ""){
            self.player = AVPlayer(url: url)
            self.player?.play()
        }
    }
}


extension PlayAudioManager: PlayControlViewDelegate{
    func volumeChangingSlider(didChangeVolumeValue: Float) {
        player?.volume = didChangeVolumeValue
    }
    
    func playControlViewDidTapBackBtn() {
        index -= 1
        self.player?.pause()
        if index < 0 {
            index = 0
        }
        loadCurrentSong()
    }
    
    func playControlViewDidTapNextBtn() {
        index += 1
        self.player?.pause()
        if index >= tracks.count {
            index = 0
        }
        loadCurrentSong()
    }
    
    func playControlViewDidTapPlayPauseBtn(isPlaying: Bool) {
        if let player = player{
            if player.timeControlStatus == .playing || isPlaying {
                player.pause()
            }
            else{
                player.play()
            }
        }
    }
}
