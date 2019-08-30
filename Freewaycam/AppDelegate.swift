//
//  AppDelegate.swift
//  Freewaycam
//
//  Created by scchn on 2019/8/28.
//  Copyright © 2019 scchn. All rights reserved.
//

import Cocoa

struct A: Hashable {
    var string: String
    var int: Int
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        TrafficInfoLoader().fetch(RoadLevel.self, type: .roadLevel) { result in
//            guard case .success(let roadLevels) = result else { return }
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

