//
//  ViewController.swift
//  Algorand Node
//
//  Created by Robert McGee on 3/30/21.
//
// MainNet https://algorand-catchpoints.s3.us-east-2.amazonaws.com/channel/mainnet/latest.catchpoint
// TestNet https://algorand-catchpoints.s3.us-east-2.amazonaws.com/channel/testnet/latest.catchpoint

import Cocoa

class ViewController: NSViewController, NSWindowDelegate {

    @IBOutlet weak var progress: NSProgressIndicator!
    
    @IBOutlet weak var statOutput: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //getCatchPoints()
        // Do any additional setup after loading the view.
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func getCatchPoint() {
        DispatchQueue.global().async(qos:.background){
            let myAppleScript = """
                    set theScript to "curl https://algorand-catchpoints.s3.us-east-2.amazonaws.com/channel/mainnet/latest.catchpoint"
                    set thePoint to do shell script theScript
                    delay 2
                    return thePoint
            """
            var error: NSDictionary?
            if let scriptObject = NSAppleScript(source: myAppleScript) {
                if let outputString = scriptObject.executeAndReturnError(&error).stringValue {
                    print(outputString)
                    DispatchQueue.main.async {
                        self.updateNodeWithCatchpoint(catchPoint: outputString)
                    }
                } else if (error != nil) {
                    DispatchQueue.main.async {
                        let theError = error!.value(forKey: "NSAppleScriptErrorBriefMessage") as! String
                        self.statOutput.stringValue = theError
                    }
                }
            }
        }
    }
    
    func updateNodeWithCatchpoint(catchPoint: String){
        let theMSG = "Using Catchpoint: \(catchPoint)"
        DispatchQueue.global().async(qos:.background){
        let myAppleScript = """
                set theScript to "cd ~/public/node && ./goal node catchup \(catchPoint) -d data && echo 'Horray! Your Algorand Node is started and catching up. You can close this window.'"
                do shell script theScript
        """
            var error: NSDictionary?
            if let scriptObject = NSAppleScript(source: myAppleScript) {
                if let outputString = scriptObject.executeAndReturnError(&error).stringValue {
                    DispatchQueue.main.async {
                        
                        
                            self.statOutput.stringValue = outputString

                            
                        
                    }
                } else if (error != nil) {
                    DispatchQueue.main.async {
                        let theError = error!.value(forKey: "NSAppleScriptErrorBriefMessage") as! String
                        self.statOutput.stringValue = theError
                    }
                }
            }
        }
        print(theMSG)
    }
    

    @IBAction func installAlgorand(_ sender: Any) {
        self.statOutput.stringValue = "Installing..."
        self.progress.isHidden = false
        self.progress.startAnimation(nil)
        DispatchQueue.global().async(qos:.background){
            let myAppleScript = """
                         set theScript to "cd ~/Public && mkdir node && cd node && curl https://raw.githubusercontent.com/algorand/go-algorand-doc/master/downloads/installers/update.sh -O && chmod +x update.sh && ./update.sh -i -c stable -p ~/Public/node -d ~/Public/node/data -n && echo 'done'"
                         do shell script theScript
            """

            var error: NSDictionary?
            if let scriptObject = NSAppleScript(source: myAppleScript) {
                if let outputString = scriptObject.executeAndReturnError(&error).stringValue {
                    DispatchQueue.main.async {
                        
                        
                            self.statOutput.stringValue = outputString
                        self.progress.stopAnimation(nil)
                        self.progress.isHidden = true
                        self.startAlgorand()
                            
                        
                    }
                } else if (error != nil) {
                    DispatchQueue.main.async {
                        let theError = error!.value(forKey: "NSAppleScriptErrorBriefMessage") as! String
                        self.statOutput.stringValue = theError
                    }
                }
            }
        }
    }
    
    
    //Start Algorand Node
    func startAlgorand() {
        self.statOutput.stringValue = "Starting Node..."
        DispatchQueue.global().async(qos:.background){
            let myAppleScript = """
                    delay 2
                    set theScript to "cd ~/Public/node && ./goal node start -d data"
                    do shell script theScript
            """
            var error: NSDictionary?
            if let scriptObject = NSAppleScript(source: myAppleScript) {
                if let outputString = scriptObject.executeAndReturnError(&error).stringValue {
                    if (outputString.contains("successfully")){
                        
                        //Get the catchpoint
                        self.getCatchPoint()
                    }
                    
                } else if (error != nil) {
                    DispatchQueue.main.async {
                        let theError = error!.value(forKey: "NSAppleScriptErrorBriefMessage") as! String
                        self.statOutput.stringValue = theError
                    }
                }
            }
        }
    }
    
    
    
    
    
}
