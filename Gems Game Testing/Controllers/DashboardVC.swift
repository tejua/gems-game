//
//  DashboardVC.swift
//  Gems Game Testing
//
//  Created by vLinkD on 15/02/20.
//  Copyright © 2020 chanonly123. All rights reserved.
//

import Foundation
import UIKit

class DashboardVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    @IBOutlet weak var board: UIView!
    @IBOutlet weak var collectionVew: UICollectionView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var footerView: UIView!
    var isHideCells = false
    
    //set menu image with thile
    var imageArray = [ImageData(title: "Timed", image: #imageLiteral(resourceName: "time")), ImageData(title: "Moves", image: #imageLiteral(resourceName: "moves")), ImageData(title: "Endless", image: #imageLiteral(resourceName: "endles")), ImageData(title: "Challenges", image: #imageLiteral(resourceName: "challnege"))]
    var delay = 0.1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadViewAndData()
    }
    
    // MARK: load views when load the controller
    func reloadViewAndData() {
        collectionVew.reloadData()
        delay = 0.1
        isHideCells = false
        headerView.upperShowAnimation()
        footerView.downShowAnimation()
    }
    
    // MARK: Collection view data source and delegatesd
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCollectionViewCell", for: indexPath) as! MyCollectionViewCell
        //set image
        let imageData = imageArray[indexPath.row]
        cell.imageView.image = imageData.image
        //set title
        cell.title.text = imageData.title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2, height: collectionView.frame.width / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Player.playSound(named: "beep1")
        hideViews()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.sendToNavigationScreen()
        }
    }
    
    // MARK: Hide View when we goto to other controllers
    func hideViews() {
        headerView.upperHideAnimation()
        footerView.downHideAnimation()
        delay = 0.03
        isHideCells = true
        collectionVew.reloadData()
    }
    
    // MARK: Navigate to play game screen
    func sendToNavigationScreen() {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DotGameVC") as! DotGameVC
        popOverVC.removeFromView = {
            self.reloadViewAndData()
        }
        addChild(popOverVC)
        popOverVC.view.frame = view.frame
        view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if isHideCells {
            hideCell(cell)
        } else {
           showCell(cell)
        }
    }
    
    // MARK: Show Cell With Animation when collectionView Load
    func showCell(_ cell: UICollectionViewCell)  {
        cell.alpha = 0
        cell.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.5) {
            cell.alpha = 1
            cell.transform = .identity
        }
    }
    
   // MARK: Hide Cell when we goto to other controllers
    func hideCell(_ cell: UICollectionViewCell)  {
        cell.alpha = 1
        cell.transform = .identity
        UIView.animate(withDuration: 0.25) {
            cell.alpha = 0
            cell.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            // cell.transform = .identity
        }
    }
    
    // MARK: Navigate to play game screen
   @IBAction func sendToNavigationSettingScreen() {
        Player.playSound(named: "beep1")
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
        popOverVC.removeFromView = {
            self.reloadViewAndData()
        }
        addChild(popOverVC)
        popOverVC.view.frame = view.frame
        view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }
    
   
}

class MyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var title: UILabel!
}

struct ImageData {
    let title: String
    let image: UIImage
}
