//
//  ActionViewController.swift
//  sendpodcast
//
//  Created by Will Bishop on 17/1/18.
//  Copyright © 2018 Will Bishop. All rights reserved.
//

import UIKit
import MobileCoreServices
import Alamofire
import AVFoundation
import WatchConnectivity


class ActionViewController: UIViewController, WCSessionDelegate {

	var but = UIButton()
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
		print("As successful as a chinese student")
	}
	
	func sessionDidBecomeInactive(_ session: WCSession) {
		print("slower than toby")
	}
	
	func sessionDidDeactivate(_ session: WCSession) {
		print("aw fuck can't believe you done this")
	}
	var midDownload = false
	var wcSession: WCSession?


	@IBOutlet weak var indicator: UILabel!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Get the item[s] we're handling from the extension context.
        
        // For example, look for an image and place it into an image view.
        // Replace this with something appropriate for the type[s] your extension supports.
        for item in self.extensionContext!.inputItems as! [NSExtensionItem] {
            for provider in item.attachments! as! [NSItemProvider] {
				provider.loadItem(forTypeIdentifier: "public.url", options: nil, completionHandler: { result, error in
					if let podcastLink = result as? NSURL{
						self.getMP3Link(overcast: podcastLink)
						
					}
				})
            }
			
		}
	
		
	}


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	func getMP3Link(overcast: NSURL){
		self.indicator.text = "Extracting Download Link"
		Alamofire.request(overcast.absoluteURL!)
			.responseString(completionHandler: { response in
				let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
				let matches = detector.matches(in: response.result.value!, options: [], range: NSRange(location: 0, length: (response.result.value?.utf16.count)!))
				for match in matches {
					let url = (response.result.value! as NSString).substring(with: match.range)
					print(url.contains("mp3"))
					if url.contains("mp3") && !self.midDownload{
						self.midDownload = true
						_ = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
						UserDefaults.init(suiteName: "group.willbishop.sharedurls")?.set(url, forKey: "url")
						self.indicator.text = "Now continue in iOS app"
						break
					} else{
						self.indicator.text = "This podcast is not yet supported"
					}
				}
			})
		
		
	}
	var player: AVAudioPlayer?
	
	func playSound(_ fileName: String) {
		let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString

		guard URL(string: (paths as String) + "/\(fileName)") != nil else {print("not ther"); return }
		
		
	}
	
    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }

}
