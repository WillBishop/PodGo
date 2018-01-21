//
//  podcastPlayView.swift
//  PodGo
//
//  Created by Will Bishop on 20/1/18.
//  Copyright © 2018 Will Bishop. All rights reserved.
//

import UIKit
import WatchKit

class podcastPlayView: WKInterfaceController {
	@IBOutlet var podcastTitle: WKInterfaceLabel!
	@IBOutlet var podcastAlbum: WKInterfaceLabel!
	
	@IBOutlet var playButton: WKInterfaceButton!
	var player: WKAudioFilePlayer?
	var playing = false
	
	override func awake(withContext context: Any?) {
		if let play = context as? WKAudioFilePlayer{
			player = play
			podcastTitle.setText(player?.currentItem?.asset.title)
			podcastAlbum.setText(player?.currentItem?.asset.albumTitle)
		}
	}
	@IBAction func togglePlay() {
		if !playing{
			player?.play()
			playButton.setTitle("Playing")
			playing = true
		} else{
			player?.pause()
			playButton.setTitle("Paused")
			playing = false
		}
	}
}
