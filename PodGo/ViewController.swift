//
//  ViewController.swift
//  PodGo
//
//  Created by Will Bishop on 17/1/18.
//  Copyright © 2018 Will Bishop. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate {
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
		print("Successful")
		let url = UserDefaults.init(suiteName: "group.willbishop.sharedurls")?.object(forKey: "url") as? String

		if let ur = url{
			wcSession?.sendMessage(["url": ur], replyHandler: nil, errorHandler: nil)
			
		}
	}
	
	func sessionDidBecomeInactive(_ session: WCSession) {
		print("Became inactive")
	}
	
	func sessionDidDeactivate(_ session: WCSession) {
		print("Deactivated")
	}
	
	var wcSession: WCSession?
	func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
		print(message)
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func viewDidAppear(_ animated: Bool) {
	
	}
	@IBAction func s(_ sender: Any) {
		let url = UserDefaults.init(suiteName: "group.willbishop.sharedurls")?.object(forKey: "url") as? String
		print(url)
		wcSession = WCSession.default
		wcSession?.delegate = self
		wcSession?.activate()
		
	}
	

}

