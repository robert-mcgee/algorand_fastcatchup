//
//  AppDelegate.swift
//  Algorand Node
//
//  Created by Robert McGee on 3/30/21.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    //popOver
    let popView = NSPopover()
    
    //menu button
    let icon_item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.icon_item.button?.image = NSImage(named: "Bunny")
        self.icon_item.button?.target = self
        self.icon_item.button?.action = #selector(togglePopOver)
//        if #available(macOS 11.0, *) {
//            self.icon_item.button?.image = NSImage(systemSymbolName: "hare.fill", accessibilityDescription: "Bunny")
//        } else {
//            // Fallback on earlier versions
//        }
        // Insert code here to initialize your application
        
        //Delay

    }
    //MARK: Toggle PopOver
    @objc public func togglePopOver(sender: Any?){
        if popView.isShown{
            popView.performClose(sender)
        } else{
            showView()
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        

        if flag {
            print (flag)
            return false
        } else {
            NSApplication.shared.windows.last!.makeKeyAndOrderFront(nil)
            NSApplication.shared.activate(ignoringOtherApps: true)
            print(flag)
            return true
        }
        
        
    }
    
    @objc func showView(){
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateController(withIdentifier: "ViewController") as? ViewController else { fatalError("Unable to find view controller")}
        guard let button = icon_item.button else { fatalError("Unable to find button.")}
        
        popView.contentViewController = vc
        popView.behavior = .applicationDefined
        popView.show(relativeTo: button.bounds, of: button, preferredEdge: .maxY)
        popView.animates = false
        
    }
//    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
//        return true
//    }


}

