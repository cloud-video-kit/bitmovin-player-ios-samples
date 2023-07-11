//
//  ViewController.swift
//  DRMPlaybackUIKit
//
//  Created by Insys on 22/06/2023.
//

import UIKit
import BitmovinPlayer

class ViewController: UIViewController {
    var player: Player!

    deinit {
        player?.destroy()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .black
        
        // Define the required resources
        guard let fairplayStreamUrl = URL(string: "https://dtkya1w875897.cloudfront.net/da6dc30a-e52f-4af2-9751-000b89416a4e/assets/357577a1-3b61-43ae-9af5-82b9727e2f22/videokit-720p-dash-hls-drm/hls/index.m3u8"),
              let certificateUrl = URL(string: "https://insys-marketing.la.drm.cloud/certificate/fairplay?BrandGuid=da6dc30a-e52f-4af2-9751-000b89416a4e") else {
            print("Please specify the required resources marked with TODO in the ViewController.swift file.")
            return
        }
        
        // VideoKit TenantId 
        let brandGuid = "da6dc30a-e52f-4af2-9751-000b89416a4e"
        
        // DRM token
        let userToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE4OTM0NTYwMDAsImRybVRva2VuSW5mbyI6eyJleHAiOiIyMDMwLTAxLTAxVDAwOjAwOjAwKzAwOjAwIiwia2lkIjpbImM3OTYyNTYyLTE1MTctNDRjMi04OTM3LWExZjJjNmI4NDlmYyJdLCJwIjp7InBlcnMiOmZhbHNlfX19.Yp17bc9YEbicVxffOoFJ-OW3BMtD-5yRTrf0QcHPOns"
        
        // Create the player configuration
        let config = PlayerConfig()

        // Create the player based on the player configuration
        player = PlayerFactory.create(playerConfig: config)

        // Create the player view and associate it with the player instance
        let playerView = PlayerView(player: player, frame: .zero)

        // Listen to player events
        player.add(listener: self)

        playerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        playerView.frame = view.bounds

        view.addSubview(playerView)
        view.bringSubviewToFront(playerView)

        // Create the DRM (Digital Rights Management) configuration
        let fpsConfig = FairplayConfig(certificateURL: certificateUrl)

        // Example of how to prepare the message request data if custom modifications are needed
        fpsConfig.prepareMessage = { spcData, assetId in
            spcData
        }

        // Example of how to prepare the certificate data if custom modifications are needed
        fpsConfig.prepareCertificate = { (data: Data) -> Data in
            // Perform custom actions with the loaded certificate
            return data
        }

        /**
         * The following callbacks are available for making custom modifications:
         * - fpsConfig.prepareCertificate
         * - fpsConfig.prepareLicense
         * - fpsConfig.prepareContentId
         * - fpsConfig.prepareMessage
         *
         * Custom request headers can be set using:
         * - fpsConfig.certificateRequestHeaders
         * - fpsConfig.licenseRequestHeaders
         *
         * Refer to the header documentation for more details!
         */
        let sourceConfig = SourceConfig(url: fairplayStreamUrl, type: .hls)
        fpsConfig.licenseRequestHeaders = ["x-drm-brandGuid": brandGuid, "x-drm-usertoken": userToken]
        sourceConfig.drmConfig = fpsConfig

        player.load(sourceConfig: sourceConfig)
    }
}

extension ViewController: PlayerListener {
    func onEvent(_ event: Event, player: Player) {
        dump(event, name: "[Player Event]", maxDepth: 1)
    }
}
