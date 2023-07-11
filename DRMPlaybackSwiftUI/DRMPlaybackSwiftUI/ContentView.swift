//
//  ContentView.swift
//  DRMPlaybackSwiftUI
//
//  Created by Insys on 22/06/2023.
//

import BitmovinPlayer
import SwiftUI

struct ContentView: View {
    private let player: Player
    private let playerViewConfig: PlayerViewConfig
    
    private var sourceConfig: SourceConfig {
        // URL for the video to be played
        guard let videoUrl = URL(string: "https://dtkya1w875897.cloudfront.net/da6dc30a-e52f-4af2-9751-000b89416a4e/assets/357577a1-3b61-43ae-9af5-82b9727e2f22/videokit-720p-dash-hls-drm/hls/index.m3u8"),
              // URL for the FairPlay Streaming certificate
              let certificateUrl = URL(string: "https://insys-marketing.la.drm.cloud/certificate/fairplay?BrandGuid=da6dc30a-e52f-4af2-9751-000b89416a4e") else {
            fatalError("Please specify the needed resources.")
        }
        
        // VideoKit TenantId
        let brandGuid = "da6dc30a-e52f-4af2-9751-000b89416a4e"
        
        // DRM token
        let userToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE4OTM0NTYwMDAsImRybVRva2VuSW5mbyI6eyJleHAiOiIyMDMwLTAxLTAxVDAwOjAwOjAwKzAwOjAwIiwia2lkIjpbImM3OTYyNTYyLTE1MTctNDRjMi04OTM3LWExZjJjNmI4NDlmYyJdLCJwIjp7InBlcnMiOmZhbHNlfX19.Yp17bc9YEbicVxffOoFJ-OW3BMtD-5yRTrf0QcHPOns"
        
        let fpsConfig = FairplayConfig(certificateURL: certificateUrl)
        
        // Prepare message block for SPC (Server Playback Context) data
        fpsConfig.prepareMessage = { spcData, assetId in
            return spcData
        }
        
        // Example of how certificate data can be prepared if custom modifications are needed
        fpsConfig.prepareCertificate = { data in
            // Do something with the loaded certificate
            return data
        }
        
        // Set license request headers
        fpsConfig.licenseRequestHeaders = ["x-drm-brandGuid": brandGuid, "x-drm-usertoken": userToken]
        
        let result = SourceConfig(url: videoUrl, type: .hls)
        result.drmConfig = fpsConfig
        return result
    }
    
    init() {
        // Create player configuration
        let playerConfig = PlayerConfig()
        
        // Create player based on player config
        player = PlayerFactory.create(playerConfig: playerConfig)
        
        // Create player view configuration
        playerViewConfig = PlayerViewConfig()
    }
    
    var body: some View {
        VStack {
            ZStack {
                Color.black
                
                SwiftUIPlayerView(player: player, playerViewConfig: playerViewConfig)
            }
        }
        .onAppear {
            // Load the source configuration when the view appears
            player.load(sourceConfig: sourceConfig)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
