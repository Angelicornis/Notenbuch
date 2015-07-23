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
    
    @IBAction func mailButtonPressed(sender: UIButton) {
        let mailController = MFMailComposeViewController()
        mailController.mailComposeDelegate = self
        mailController.setToRecipients(["dev.angelicornis@icloud.com"])
        mailController.setSubject("[IOS][Notenbuch]")
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
