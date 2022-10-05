//
//  ViewController.swift
//  Gems Game Testing
//
//  Created by vLinkD on 15/02/20.
//  Copyright © 2020 chanonly123. All rights reserved.
//

import UIKit

class DotGameVC: UIViewController, UpdateLables {
    @IBOutlet weak var board: BoardView!
    @IBOutlet weak var optionView: UIView!
    @IBOutlet weak var progessView: UIView!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var lblMoves: UILabel!
    @IBOutlet weak var optionViewContraints: NSLayoutConstraint!

    @IBOutlet weak var boardHeight: NSLayoutConstraint!
    @IBOutlet weak var progrssWidthContraits: NSLayoutConstraint!
    @IBOutlet weak var boardViewContraints: NSLayoutConstraint!
    var moves = 20
    var removeFromView: (() -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        // initial setting
    
        lblMoves.text = "\(moves)"
        board.delegate = self
        board.size = 6
        board.fillBoardRandomly()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.board.updateViewsFirstTime()
        }
        FirebaseHelper.initPlayGameTableListener(sinchId: obsId1)
       // FirebaseHelper.initNewEntryTableListener(sinchId: obsId1)
        optionViewContraints.constant = view.frame.width + 100
        view.setNeedsLayout()
        view.layoutIfNeeded()
        progrssWidthContraits.constant = 0
    }

    // MARK: Reset Game
    @IBAction func tapReset() {
        lblMoves.text = "\(moves)"
        lblScore.text = "0"
        board.fillBoardRandomly()
        board.updateViewsFirstTime()
        tapToShowBoardView()
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
     //  boardHeight.constant = board.frame.width
    }
    // MARK: Exit from game
    @IBAction func tapExit() {
        view.removeFromSuperview()
        removeFromView?()
    }

    // MARK: show option View and hide game view
    @IBAction func tapToShowOptions() {
        UIView.animate(withDuration: 0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.4, options: [], animations: {
            self.boardViewContraints.constant = -self.view.frame.width
            self.view.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.4, options: [], animations: {
            self.optionViewContraints.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    // MARK: hide option View and show game view
    @IBAction func tapToShowBoardView() {
        UIView.animate(withDuration: 0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.4, options: [], animations: {
            self.optionViewContraints.constant = self.view.frame.width
            self.view.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.4, options: [], animations: {
            self.boardViewContraints.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    // MARK: update Score
    func updateScore(_ conut: Int) {
        var preConut = Int(lblScore.text ?? "0") ?? 0
        preConut += conut
        lblScore.text = "\(preConut)"
        
        //reset progess bar
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.progrssWidthContraits.constant = 0
        }
        
    }

    // MARK: update moves
    func updateMoves(_ conut: Int) {
        var preConut = Int(lblMoves.text ?? "0") ?? 0
        preConut -= conut
        lblMoves.text = "\(preConut)"
        if preConut == 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.showCompliteView()
            }
        }
    }
    
    // MARK: update progess bar
    func updateProgressBar(_ conut: Int, _ bgColor: UIColor) {
        progrssWidthContraits.constant += CGFloat(20 * conut)
        progessView.backgroundColor = bgColor
    }
    // MARK: reset progess bar
    func resetProgressBar() {
        progrssWidthContraits.constant = 0
    }

    // MARK: show the view when game is complite
    func showCompliteView() {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpID") as! PopUpViewController
        addChild(popOverVC)
        popOverVC.view.frame = view.frame
        view.addSubview(popOverVC.view)
        popOverVC.backAction = {
            self.tapReset()
        }

        popOverVC.lblScore.text = "Score: " + "\(lblScore.text ?? "0")"
        popOverVC.didMove(toParent: self)
    }
}
