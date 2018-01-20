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
		print("As successful as a chinese student")
	}
	
	func sessionDidBecomeInactive(_ session: WCSession) {
		print("slower than toby")
	}
	
	func sessionDidDeactivate(_ session: WCSession) {
		print("aw fuck can't believe you done this")
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
		print("her")
		
		let url = UserDefaults.init(suiteName: "group.willbishop.sharedurls")?.object(forKey: "url") as? String
		print(url)
		if let ur = url{
			print(ur)
			wcSession?.sendMessage(["url": ur], replyHandler: nil, errorHandler: nil)
			
		}
	}
	@IBAction func s(_ sender: Any) {
		let url = UserDefaults.init(suiteName: "group.willbishop.sharedurls")?.object(forKey: "url") as? String
		print(url)
		wcSession = WCSession.default
		wcSession?.delegate = self
		wcSession?.activate()
		if let ur = url{
			wcSession?.sendMessage(["url": ur], replyHandler: nil, errorHandler: nil)
			
		}
	}
	

}

