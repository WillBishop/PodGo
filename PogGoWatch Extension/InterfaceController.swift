//
//  InterfaceController.swift
//  PogGoWatch Extension
//
//  Created by Will Bishop on 17/1/18.
//  Copyright © 2018 Will Bishop. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity
import Alamofire
import AVFoundation

class InterfaceController: WKInterfaceController, WCSessionDelegate {
	var player: WKAudioFilePlayer!
	var wcSession: WCSession?
	var downloadedFiles = UserDefaults.standard.object(forKey: "downloadedNames") as? [String] ?? [String]()
	var downloadNames = UserDefaults.standard.object(forKey: "downloadedFiles") as? [String: String] ?? [String: String]()
	var playing = false;
	@IBOutlet var podcastTable: WKInterfaceTable!
	
	override func awake(withContext context: Any?) {
        super.awake(withContext: context)
		wcSession = WCSession.default
		wcSession?.delegate = self
		wcSession?.activate()
		print(downloadNames)
		print(downloadedFiles)
		wcSession?.sendMessage(["applaunched": true], replyHandler: nil, errorHandler: { error in
			print(error.localizedDescription)
		})
		
//		let ur = "/Users/Will/Library/Developer/CoreSimulator/Devices/BA04FF83-676E-4B2A-B623-679742E7E4B3/data/Containers/Data/PluginKitPlugin/FD896473-FE24-4F9B-BCA4-D2FAB2017AF5/Documents/whc-528-bigskittlelies.mp3"
//		let file = URL(fileURLWithPath: ur)
//		let asset = WKAudioFileAsset(url: file)
//		let item = WKAudioFilePlayerItem(asset: asset)
//		self.player = WKAudioFilePlayer(playerItem: item)
//		self.player.play()
//
		
		podcastTable.setNumberOfRows(downloadNames.count, withRowType: "podcastCell")
		for (index, asset) in downloadNames.enumerated(){
			
			if let cell = podcastTable.rowController(at: index) as? podcastCell{
				let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/\(URL(string: asset.value)!.lastPathComponent)"
				let file = URL(fileURLWithPath: documents)
				let ass = WKAudioFileAsset(url: file)
				_ = WKAudioFilePlayerItem(asset: ass)
				
				cell.podcastArtist.setText(ass.albumTitle)
				cell.podcastTitle.setText(asset.key)
				cell.asset = WKAudioFilePlayerItem(asset: ass)
				cell.ready = true
				
			}
		}
		
		//self.downloadPod("https://audio.simplecast.com/c014fbf6.mp3")

	}
	override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {

		if let cell = podcastTable.rowController(at: rowIndex) as? podcastCell{
			if cell.ready{
				
				var asset = cell.asset
				WKInterfaceDevice.current().play(WKHapticType.click)
				if player != nil{
					player.replaceCurrentItem(with: asset)
					
				} else{
					player = WKAudioFilePlayer(playerItem: asset!)
				}
				self.pushController(withName: "podcastPlay", context: player)
				asset = nil
			} else{
				WKInterfaceDevice.current().play(WKHapticType.failure)
			}
		}
		
		
	}
	func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
		if let url = message["url"] as? String{
			if !downloadedFiles.contains(url){
				downloadPod(url)
				
			}
		}
	}
	
	@IBAction func g() {
		if player.status == .readyToPlay{
			self.player.play()
			print("let's a go")
			
		} else{
			print("nooooooooo: \(player.status)")
		}
		
	}
	
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
		print("Done")
		switch activationState {
		case .activated:
			print("activated")
			if (self.wcSession?.isReachable)!{
				self.wcSession?.sendMessage(["appLaunched": true], replyHandler: nil, errorHandler: { error in
					print(error.localizedDescription)
				})
			} else{
				print("Not reachable")
			}
		default:
			print("not actived")
		}
		print(error?.localizedDescription)
		
	}
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
		
        super.willActivate()
    }
	func downloadPod(_ mp3File: String = "https://archive.org/embed/test_wav/Untitled3.wav"){
		print(mp3File)
		let index = addPodcast()
		let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
		Alamofire.download(mp3File, to: destination)
			
			.response {df in
				let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
				let the = (paths as String) + "/" + (df.destinationURL?.lastPathComponent)!
				print(the)
				let file = URL(fileURLWithPath: the)
				let asset = WKAudioFileAsset(url: file)
				self.downloadNames[asset.title!] = the
				self.downloadedFiles.append(asset.title!)
				UserDefaults.standard.set(self.downloadNames, forKey: "downloadedFiles")
				UserDefaults.standard.set(self.downloadedFiles, forKey: "downloadedNames")
				let playerItem = WKAudioFilePlayerItem(asset: asset)
				guard let cell = self.podcastTable.rowController(at: index) as? podcastCell else{ return}
				WKInterfaceDevice.current().play(WKHapticType.success)
				cell.podcastTitle.setText(asset.title)
				cell.podcastArtist.setText(asset.albumTitle)
				cell.ready = true
				cell.asset = playerItem
				
			}
			.downloadProgress { progress in
				print(progress)
				if let cell = self.podcastTable.rowController(at: index) as? podcastCell{
					cell.podcastTitle.setText("Downloaded \(progress.fractionCompleted * 100)%")
					
				}
		}
		
	}
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
	func addPodcast(name: String = "Downloading...", artist: String = "") -> Int{
	
		podcastTable.setNumberOfRows(podcastTable.numberOfRows + 1, withRowType: "podcastCell")
		
		if let cell = podcastTable.rowController(at: podcastTable.numberOfRows - 1) as? podcastCell{ //-1 because they start at 0
			
			cell.podcastTitle.setText(name)
			cell.podcastArtist.setText(artist)
			
			return podcastTable.numberOfRows - 1
		} else{
			print("no")
		}
		return -1
		
	}
	func changePodcast(name: String, artist: String, index: Int){
		if let cell = podcastTable.rowController(at: index) as? podcastCell{ //-1 because they start at 0
			cell.podcastTitle.setText(name)
			cell.podcastArtist.setText(artist)
			
		}
	}
}
