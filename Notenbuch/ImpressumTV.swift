//
//  ImpressumTV.swift
//  Notenbuch
//
//  Created by Tom Kumschier on 21.07.15.
//  Copyright © 2015 Tom Kumschier. All rights reserved.
//

import UIKit
import MessageUI


class ImpressumTV: UIViewController, MFMailComposeViewControllerDelegate {
    var bodyString = ""
    var appName = ""
    override func viewDidLoad() {
        appName = NSBundle.mainBundle().infoDictionary?["CFBundleName"] as? String ?? ""
        
        let systemName = "systemName:        \(UIDevice.currentDevice().systemName)"
        let systemVersion = "systemVersion:      \(UIDevice.currentDevice().systemVersion)"
        let model = "model:                     \(hardwareDescription() ?? UIDevice.currentDevice().model)"
        let versionNumber = "versionNumber:     \(NSBundle.applicationVersionNumber)"
        let buildNumber = "buildNumber:         \(NSBundle.applicationBuildNumber)"
        bodyString = "\n\n\n\n\nBitte nicht löschen - Please do not delete:\n############################### \n \(systemName) \n \(systemVersion) \n \(model) \n\n \(versionNumber) \n \(buildNumber) \n###############################"

    }
    @IBAction func mailButtonPressed(sender: UIButton) {
        let mailController = MFMailComposeViewController()
        mailController.mailComposeDelegate = self
        mailController.setToRecipients(["dev.angelicornis@icloud.com"])
        mailController.setSubject("[IOS] [\(appName)]")
        mailController.setMessageBody(bodyString, isHTML: false)
        presentViewController(mailController, animated: true, completion: nil)
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        if result == MFMailComposeResultSent {
            print("sent")
        } else if result == MFMailComposeResultSaved {
            print("saved")
            
        } else if result == MFMailComposeResultCancelled {
            print("cancelled")
        } else if result == MFMailComposeResultFailed {
            print("failed")
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
}
