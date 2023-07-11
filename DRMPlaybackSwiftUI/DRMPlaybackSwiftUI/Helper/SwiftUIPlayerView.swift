//
//  SwiftUIPlayerView.swift
//  DRMPlaybackSwiftUI
//
//  Created by Insys on 22/06/2023.
//

import BitmovinPlayer
import SwiftUI

struct SwiftUIPlayerView: UIViewRepresentable {
    let player: Player
    let playerViewConfig: PlayerViewConfig

    func makeUIView(context: Context) -> PlayerView {
        PlayerView(player: player, frame: .zero, playerViewConfig: playerViewConfig)
    }

    func updateUIView(_ uiView: BitmovinPlayer.PlayerView, context: Context) { }
}
