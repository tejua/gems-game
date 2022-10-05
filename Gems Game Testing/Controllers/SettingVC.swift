//
//  PopUpViewController.swift
//  Gems Game Testing
//
//  Created by vLinkD on 15/02/20.
//  Copyright © 2020 chanonly123. All rights reserved.
//
//

import AVFoundation
import UIKit

class SettingVC: UIViewController {
    @IBOutlet var viewsCollection: [UIView]!
    @IBOutlet var leadingContraints: [NSLayoutConstraint]!
    @IBOutlet weak var viewTopContrants: NSLayoutConstraint!
    @IBOutlet weak var bottomViewContrains: NSLayoutConstraint!
    
    @IBOutlet weak var btnVibrate: UIButton!
    @IBOutlet weak var btnSound: UIButton!
    @IBOutlet weak var btnColorBlind: UIButton!
    var removeFromView: (() -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        for index in 1..<leadingContraints.count - 1 {
            leadingContraints[index].constant = 500
        }
        viewTopContrants.constant = -200
        bottomViewContrains.constant = -200
        setButtonTitles()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.showViewsByAnimation()
        }
    }
    
    func setButtonTitles() {
        if let vibrate = UserDefaults.standard.string(forKey: "vibrate") {
            btnVibrate.setTitle(vibrate, for: .normal)
        }
        if let sound = UserDefaults.standard.string(forKey: "sound") {
            btnSound.setTitle(sound, for: .normal)
        }
        if let colorBlind = UserDefaults.standard.string(forKey: "colorBlind") {
            btnColorBlind.setTitle(colorBlind, for: .normal)
        }
    }
    
    func showViewsByAnimation() {
        viewsCollection.first!.alpha = 0.0
        UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.4, options: [], animations: {
            self.viewTopContrants.constant = 0
            self.viewsCollection.first!.alpha = 1.0
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        var delay = 0.5
        for index in 1..<leadingContraints.count - 1 {
            leadingContraints[index].constant = 500
            viewsCollection[index].alpha = 0.0
            UIView.animate(withDuration: 0.5, delay: delay, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.4, options: [], animations: {
                self.leadingContraints[index].constant = 0
                self.viewsCollection[index].alpha = 1.0
                self.view.layoutIfNeeded()
            }, completion: nil)
            delay += 0.1
        }
        
        viewsCollection.last!.alpha = 0.0
        UIView.animate(withDuration: 0.5, delay: 1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.4, options: [], animations: {
            self.bottomViewContrains.constant = 0
            self.viewsCollection.last!.alpha = 1.0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionChanges(_ sender: UIButton) {
        if sender.tag == 0 {
            if btnVibrate.titleLabel!.text! == "ON" {
                btnVibrate.setTitle("OFF", for: .normal)
            } else {
                Player.phoneVibrate("ON")
                btnVibrate.setTitle("ON", for: .normal)
            }
            // btnVibrate.titleLabel?.text = "OFF"
        } else if sender.tag == 1 {
            if btnSound.titleLabel!.text! == "ON" {
                btnSound.setTitle("OFF", for: .normal)
            } else {
                Player.playSound(named: "beep1", "ON")
                btnSound.setTitle("ON", for: .normal)
            }
            
        } else if sender.tag == 2 {
            if btnColorBlind.titleLabel!.text == "ON" {
                btnColorBlind.setTitle("OFF", for: .normal)
            } else {
                btnColorBlind.setTitle("ON", for: .normal)
            }
        }
    }
    
    @IBAction func saveChanges(_ sender: UIButton) {
        UserDefaults.standard.set(btnVibrate.titleLabel!.text, forKey: "vibrate")
        UserDefaults.standard.set(btnSound.titleLabel!.text, forKey: "sound")
        UserDefaults.standard.set(btnColorBlind.titleLabel!.text, forKey: "colorBlind")
        removeAnimate()
        removeFromView?()
    }
    
    @IBAction func backButton(_ sender: AnyObject) {
        removeAnimate()
        removeFromView?()
    }
    
    func showAnimate() {
        view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    func removeAnimate() {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseOut, animations: {
            for index in 1..<self.leadingContraints.count - 1 {
                self.leadingContraints[index].constant = 500
            }
            self.viewTopContrants.constant = -200
            self.bottomViewContrains.constant = -200
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }, completion: { (finished: Bool) in
            if finished {
                self.view.removeFromSuperview()
            }
        })
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
