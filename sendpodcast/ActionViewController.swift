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

class ActionViewController: UIViewController{

	
	var midDownload = false

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
		
		Alamofire.request(overcast.absoluteURL!)
			.responseString(completionHandler: { response in
				let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
				let matches = detector.matches(in: response.result.value!, options: [], range: NSRange(location: 0, length: (response.result.value?.utf16.count)!))
				for match in matches {
					let url = (response.result.value! as NSString).substring(with: match.range)
					if url.contains("mp3") && !self.midDownload{
						self.midDownload = true
						_ = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
						UserDefaults.init(suiteName: "group.willbishop.sharedurls")?.set(url, forKey: "url")
						self.indicator.text = "Now continue in iOS app"
					} else{
						
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
