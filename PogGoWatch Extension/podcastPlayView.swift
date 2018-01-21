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
	var downloadedFiles = UserDefaults.standard.object(forKey: "downloadedNames") as? [String] ?? [String]()
	var downloadNames = UserDefaults.standard.object(forKey: "downloadedFiles") as? [String: String] ?? [String: String]()
	@IBOutlet var playButton: WKInterfaceButton!
	var player: WKAudioFilePlayer?
	var playing = false
	
	override func awake(withContext context: Any?) {
		print("Awaking")
		if let play = context as? WKAudioFilePlayer{
			player = play
			print(player?.currentItem?.asset.title)
			
			podcastTitle.setText(player?.currentItem?.asset.title)
			podcastAlbum.setText(player?.currentItem?.asset.albumTitle)
		}
	}
	@IBAction func trashPodcast() {
		let confirmAction = WKAlertAction(title: "Confirm", style: .destructive, handler: {
			
			if let play = self.player, let item = play.currentItem, let title = item.asset.title{
				
				do {
					try FileManager.default.removeItem(at: item.asset.url)
					
				} catch let er{
					print(er.localizedDescription)
				}
				self.downloadedFiles = self.downloadedFiles.filter{$0 != title}
				self.downloadNames.removeValue(forKey: title)
				UserDefaults.standard.set(self.downloadNames, forKey: "downloadedFiles")
				UserDefaults.standard.set(self.downloadedFiles, forKey: "downloadedNames")
				
			}
			self.dismiss()
		})
		let cancelAction = WKAlertAction(title: "Cancel", style: .cancel, handler: {
			print("Cancelled")
		})
		let actions = [confirmAction, cancelAction]
		self.presentAlert(withTitle: "Delete Podcast", message: "Are you sure you want to delete:\n \(player!.currentItem!.asset.title!)\n \(player!.currentItem!.asset.albumTitle!)", preferredStyle: .alert, actions: actions)
	}
	@IBAction func togglePlay() {
		if !playing{
			player?.play()
			playButton.setTitle("Pause")
			playing = true
		} else{
			player?.pause()
			playButton.setTitle("Play")
			playing = false
		}
	}
}
