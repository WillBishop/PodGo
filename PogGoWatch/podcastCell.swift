//
//  podcastCell.swift
//  PogGoWatch Extension
//
//  Created by Will Bishop on 20/1/18.
//  Copyright © 2018 Will Bishop. All rights reserved.
//

import Foundation
import WatchKit
class podcastCell: NSObject{
	@IBOutlet var podcastTitle: WKInterfaceLabel!
	@IBOutlet var podcastArtist: WKInterfaceLabel!
	@IBOutlet var podcastDuration: WKInterfaceLabel!
	var asset: WKAudioFilePlayerItem!
	var ready: Bool!
	
}

