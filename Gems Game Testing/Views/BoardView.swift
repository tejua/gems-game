//
//  BoardView.swift
//  Gems Game Testing
//
//  Created by vLinkD on 15/02/20.
//  Copyright © 2020 chanonly123. All rights reserved.
//
//

import AVFoundation
import Firebase
import FirebaseDatabase
import UIKit

class BoardView: UIView {
    var delegate: UpdateLables?
    var size: Int = 0
   // var dd: EventBus.sha
    var gemViews = [[GemView]]()
    
    var cellSize: CGFloat = 0
    var cellMid: CGFloat = 0
    
    // animation times
    let removeTime = 0.3
    let shiftTime = 0.3
    let insertTime = 0.5
    var makePerfectPair = false
    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var collision: UICollisionBehavior!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let gesture = TouchGesture(target: self, action: #selector(onTouch(_:)))
        addGestureRecognizer(gesture)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cellSize = bounds.width / CGFloat(size)
        cellMid = cellSize / 2
        // FirebaseHelper.initPlayGameTableListener(sinchId: "tejuchahar")
        // updateViewsFirstTime()
        EventBus.shared.onMain(noti: .getEntry) { [weak self] obj in
           guard let `self` = self else { return }
          // print("EventBus", obj)
           let arr = obj as! [Int]
           let gemView = self.gemViews[arr[0]][arr[1]]
           if arr.count > 2 {
                gemView.loc.color = arr[2]
              // gemView.backgroundColor = GemView.colors[arr[2]]
                self.selectedColor = GemView.colors[arr[2]]
            } else {
            self.selectedColor = gemView.backgroundColor ?? .red
            }
          //  DispatchQueue.main.sync {
                self.self.touchSelectedNodes.append(gemView)
                print(self.self.touchSelectedNodes.count)
           // }
        }

        EventBus.shared.onMain(noti: .removeEntry) { [weak self] _ in
            guard let `self` = self else { return }
             print("remove")
             DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.checkAndRemoveNodes()
               //  DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.touchSelectedNodes.removeAll()
               // }
               // self.otherSelectedNodes.removeAll()
            }
        }

    }
    
    func fillBoardRandomly() {
        subviews.forEach { $0.removeFromSuperview() }
        gemViews.removeAll()
        for i in 0..<size {
            gemViews.append([GemView]())
            for j in 0..<size {
                let gem = GemView()
                gem.loc = GemLoc(i, j, Int.random(in: 0..<GemView.colors.count))
                gemViews[i].append(gem)
            }
        }
    }
    
    func updateViewsFirstTime() {
        var delay = 0.3
        if size < 1 { return }
        print(#function)
        for i in 0..<size {
            for j in 0..<size {
                let gem = gemViews[i][j]
                let center = gem.center
                gem.center.y = -bounds.height
                gem.alpha = 0.0
                UIView.animate(withDuration: insertTime, delay: delay, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.4, options: [], animations: {
                    gem.center = center
                    gem.alpha = 1.0
                }, completion: nil)
                delay += 0.005
                addGem(gem: gem, loc: GemLoc(i, j, Int.random(in: 0..<GemView.colors.count)))
            }
        }
    }
    
    func updateViews() {
        if size < 1 { return }
        print(#function)
        for i in 0..<size {
            for j in 0..<size {
                let gem = gemViews[i][j]
                addGem(gem: gem, loc: GemLoc(i, j, Int.random(in: 0..<GemView.colors.count)))
            }
        }
    }
    
    func clearArr(locs: [GemLoc]) {
        print(locs.count)
        isUserInteractionEnabled = false
        var delay = 0.0
        for each in locs {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.clearLoc(each)
                FirebaseHelper.removeIndex(selectedNote: [[each.x, each.y]] )
            }
            delay += 0.1
        }

        // make pair 4,8,12 then remove all the node same color
        if let locsf = locs.first {
            if makePerfectPair {
                let delGem = gemViews[locsf.x][locsf.y]
                for i in 0..<size {
                    for j in 0..<size {
                        let gem = gemViews[i][j]
                        if delGem.backgroundColor == gem.backgroundColor {
                            clearLoc(gem.loc)
                        }
                    }
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.isUserInteractionEnabled = true
        }
    }
    
    private func clearLoc(_ loc: GemLoc) {
        // remove animate down
        delegate?.updateScore(1)
        let delGem = gemViews[loc.x][loc.y]
        UIView.animate(withDuration: removeTime, delay: 0.0, options: [.curveEaseIn], animations: {
            delGem.center.y += self.cellMid
            delGem.alpha = 0
        }, completion: { _ in
            delGem.removeFromSuperview()
        })
        
        // shift down
        var delay = 0.3
        var j = loc.y
        while j - 1 >= 0 {
            let upperGem = gemViews[loc.x][j - 1]
            let prevLoc = upperGem.loc
            // print(GemLoc(prevLoc.x, j))
            UIView.animate(withDuration: shiftTime, delay: delay, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: [], animations: {
                print("call move")
                self.addGem(gem: upperGem, loc: GemLoc(prevLoc.x, j, prevLoc.color))
            }, completion: nil)
            j -= 1
            delay += 0.02
        }
        
        // insert from top
        let new = GemView()
        print("call new Add")
        addGem(gem: new, loc: GemLoc(loc.x, 0, loc.color))
        let center = new.center
        new.center.y = -bounds.height
        new.alpha = 0.0

        UIView.animate(withDuration: insertTime, delay: delay, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            new.center = center
            new.alpha = 1.0
        }, completion: nil)
    }
    
    func addGem(gem: GemView, loc: GemLoc) {
        if gem.superview == nil {
            addSubview(gem)
        }
        
        gemViews[loc.x][loc.y] = gem
        print("Add", loc)
        gem.loc = loc
        gem.board = self
        gem.backgroundColor = GemView.colors[loc.color]
        gem.frame.size = CGSize(width: cellSize / 2, height: cellSize / 2)
        gem.center = CGPoint(x: CGFloat(loc.x) * cellSize + cellMid, y: CGFloat(loc.y) * cellSize + cellMid)
    }

    var arrSelectPosi = [[Int]]()
    
    var otherSelectedNodes: [GemView] = [] {
        didSet {
            lines.removeAll()
            setNeedsDisplay()
            if otherSelectedNodes.count < 2 { return }
            for i in 0..<otherSelectedNodes.count - 1 {
                let path = UIBezierPath()
                path.lineWidth = 8
                path.move(to: otherSelectedNodes[i].center)
                path.addLine(to: otherSelectedNodes[i + 1].center)
                lines.append(path)
            }
            
            if otherSelectedNodes.count == 1 || otherSelectedNodes.count == 2 {
                Player.playSound(named: "beep1")
            } else if otherSelectedNodes.count == 3 {
                Player.playSound(named: "beep3")
                
            } else {
                Player.playSound(named: "beep3")
            }
            setNeedsDisplay()
        }
    }
    
    var touchSelectedNodes: [GemView] = [] {
        didSet {
            lines.removeAll()
            setNeedsDisplay()
            if touchSelectedNodes.count < 2 { return }
            for i in 0..<touchSelectedNodes.count - 1 {
                let path = UIBezierPath()
                path.lineWidth = 8
                path.move(to: touchSelectedNodes[i].center)
                path.addLine(to: touchSelectedNodes[i + 1].center)
                lines.append(path)
            }
            
            if touchSelectedNodes.count == 1 || touchSelectedNodes.count == 2 {
                Player.playSound(named: "beep1")
            } else if touchSelectedNodes.count == 3 {
                Player.playSound(named: "beep3")
                
            } else {
                Player.playSound(named: "beep3")
            }
            setNeedsDisplay()
        }
    }
    
    var lines = [UIBezierPath]()
    
    var selectedColor = UIColor.white
    var selectedGemView: GemView?
    let lastLayer = CAShapeLayer()
    
    @objc func onTouch(_ ges: UIGestureRecognizer) {
        let point = ges.location(ofTouch: 0, in: self)
        let x = Int(point.x / cellSize)
        let y = Int(point.y / cellSize)
        // check if you are goning to out side the view
        if x < 0 || x >= size || y < 0 || y >= size {
            checkAndRemoveNodes()
            delegate?.resetProgressBar()
            lastLayer.removeFromSuperlayer()
            touchSelectedNodes.removeAll()
            return
        }
        let gemView = gemViews[x][y]
       // gemView.loc.color = Int.random(in: 0..<GemView.colors.count)
        print("Touch Node", gemView.loc)
        switch ges.state {
        // when we touch first view
        case .began:
            makePerfectPair = false
            Player.playSound(named: "beep1")
            delegate?.resetProgressBar()
            selectedColor = gemView.backgroundColor ?? .white
            touchSelectedNodes.removeAll()
            gemView.loc.color = Int.random(in: 0..<GemView.colors.count)
            touchSelectedNodes.append(gemView)
            selectedGemView = gemView
            arrSelectPosi.removeAll()
            //  arrSelectPosi.append()
            arrSelectPosi.append([gemView.loc.x, gemView.loc.y, gemView.loc.color])
            FirebaseHelper.AddNewSelectedNode(selectedNote: arrSelectPosi)
            gemView.addPulse(fillColor: gemView.backgroundColor ?? .white)
            delegate?.updateProgressBar(1, selectedColor)
        case .changed:
            // another view touch
            if !touchSelectedNodes.contains(gemView) && shouldSelect(gem: gemView) {
                gemView.loc.color = Int.random(in: 0..<GemView.colors.count)
                touchSelectedNodes.append(gemView)
                // print("New")
                gemView.addPulse(fillColor: gemView.backgroundColor ?? .white)
                delegate?.updateProgressBar(1, gemView.backgroundColor ?? .white)
                arrSelectPosi.append([gemView.loc.x, gemView.loc.y, gemView.loc.color])
                FirebaseHelper.AddNewSelectedNode(selectedNote: arrSelectPosi)
            } else if touchSelectedNodes.contains(gemView) && shouldSelect(gem: gemView) {
                // print("enter make pair", gemView.loc, touchSelectedNodes.last?.loc)
                if gemView == touchSelectedNodes[touchSelectedNodes.count - 2] {
                    // print("remove")
                    // touchSelectedNodes.removeLast()
                } else {
                    if makePerfectPair {
                        return
                    }
                    makePerfectPair = true
                    gemView.loc.color = Int.random(in: 0..<GemView.colors.count)
                    touchSelectedNodes.append(gemView)
                    arrSelectPosi.append([gemView.loc.x, gemView.loc.y, gemView.loc.color])
                    FirebaseHelper.AddNewSelectedNode(selectedNote: arrSelectPosi)
                    gemView.addPulse(fillColor: gemView.backgroundColor ?? .white)
                    delegate?.updateProgressBar(1, gemView.backgroundColor ?? .white)
                }
            } else if touchSelectedNodes.count > 0, let firstPoint = touchSelectedNodes.last?.center {
                // draw last line
                lastLayer.removeFromSuperlayer()
                let linePath = UIBezierPath()
                linePath.move(to: firstPoint)
                linePath.addLine(to: point)
                lastLayer.path = linePath.cgPath
                lastLayer.strokeColor = selectedColor.cgColor
                lastLayer.lineWidth = 8
                lastLayer.lineJoin = CAShapeLayerLineJoin.round
                layer.addSublayer(lastLayer)
            }
        default:
            print("default")
            if makePerfectPair {
                Player.phoneVibrate()
                Player.playSound(named: "beep4")
            }
            arrSelectPosi.removeAll()
            lastLayer.removeFromSuperlayer()
            FirebaseHelper.removeEntry()
            checkAndRemoveNodes()
            delegate?.resetProgressBar()
            selectedGemView = nil
            touchSelectedNodes.removeAll()
        }
    }
    
    override func draw(_ rect: CGRect) {
        if lines.isEmpty {
            UIColor.white.setFill()
            UIGraphicsGetCurrentContext()?.fill(bounds)
        } else {
            for each in lines {
                selectedColor.setStroke()
                each.stroke()
            }
        }
    }
    
    // check poind should select or not
    func shouldSelect(gem: GemView) -> Bool {
        guard let last = touchSelectedNodes.last else { return true }
        return gem.backgroundColor == last.backgroundColor && gem.loc.isNeigbour(loc: last.loc)
    }
    
    // check view is equal according to loc
    func isCheckViewEqual(_ gemFirst: GemView, _ gemLast: GemView) -> Bool {
        if gemFirst.loc.x == gemLast.loc.x && gemFirst.loc.y == gemLast.loc.y {
            return true
        }
        return false
    }
    
    func isCheckViewEqual1(_ gemFirst: GemView, _ gemLast: GemView) -> Bool {
        if gemFirst.loc.x == gemLast.loc.x && gemFirst.loc.y == gemLast.loc.y {
            return true
        }
        return false
    }
    
    // check locs is equal
    func isCheckLocEqual(_ gemFirst: GemLoc, _ gemLast: GemLoc) -> Bool {
        if gemFirst.x == gemLast.x && gemFirst.y == gemLast.y {
            return true
        }
        return false
    }
    
    // remove selected nodes
    func checkAndRemoveNodes() {
        if touchSelectedNodes.count > 1 {
            delegate?.updateMoves(1)
            clearArr(locs: touchSelectedNodes.map({ $0.loc }))
        }
    }
    
}

class FirebaseHelper {
    static let playGame = Database.database().reference().child("playGame")
    static let newEntry = Database.database().reference().child("NewEntry")
    static func AddNewSelectedNode(selectedNote: [[Int]]) {
        // let dict = ["x": selectedNote.x, "y": selectedNote.y]
        // let arr = [dict]
        
        //  let data = try! JSONSerialization.data(withJSONObject: selectedNote, options: [])
        //  let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        print("Add Node Firebase", selectedNote)
        FirebaseHelper.playGame.child(obsId).setValue(selectedNote)
        // FirebaseHelper.playGame.child("tejuchahar").setValue(arr) //updateChildValues(dict)
        // self.ref.child("users").child(user.uid).setValue(["username": username])
    }
    
    static func removeIndex(selectedNote: [[Int]]) {
      //  FirebaseHelper.newEntry.child(obsId).setValue(selectedNote)
    }
    
    static func removeEntry() {
        FirebaseHelper.playGame.child(obsId).removeValue()
    }
    
    static func initNewEntryTableListener(sinchId: String) {
        FirebaseHelper.newEntry.child(sinchId).removeAllObservers()
        // changeState(to: CallState.callRest, nil)
        // listen for childAdded in get_connect
        FirebaseHelper.newEntry.child(sinchId).observe(DataEventType.childAdded, with: { snap in
            if let postDict = snap.value as! [Int]? {
                print("getconnect_entry NEW Entry: ", postDict)
               // EventBus.shared.postToMain(.getEntry, object: postDict)
            }
        }) { _ in
            // showing after logout
            // MyAlert.showError(message: error.localizedDescription)
        }
    }
    
    static func initPlayGameTableListener(sinchId: String) {
        FirebaseHelper.playGame.child(sinchId).removeAllObservers()
        // changeState(to: CallState.callRest, nil)
        // listen for childAdded in get_connect
        FirebaseHelper.playGame.child(sinchId).observe(DataEventType.childAdded, with: { snap in
            if let postDict = snap.value as! [Int]? {
                print("getconnect_entry: ", postDict)
                EventBus.shared.postToMain(.getEntry, object: postDict)
            }
        }) { _ in
            // showing after logout
            // MyAlert.showError(message: error.localizedDescription)
        }
        // listen for childRemoved in get_connect
        FirebaseHelper.playGame.child(sinchId).observe(DataEventType.childRemoved, with: { snap in
            if let postDict = snap.value {
                print("cant convert from get_connect dict: ", postDict)
                 EventBus.shared.postToMain(.removeEntry)
            }
        }) { _ in
            // showing after logout
            // MyAlert.showError(message: error.localizedDescription)
        }
        // listen for ChildChange in get_connect
        FirebaseHelper.playGame.child(sinchId).observe(DataEventType.childChanged, with: { snap in
            if let postDict = snap.value {
                // if let obj = GetConnectData(JSON: postDict) {
                print("get connect childUpdated: ", postDict)
            }
        }) { _ in
            // showing after logout
            // MyAlert.showError(message: error.localizedDescription)
        }
    }

   // EventBus.shared()

    
}




class EventBus {
   
    typealias NotiHandler = ((Any?) -> Void)
     fileprivate var dict: [String: NotiHandler] = [:]
    static var shared = EventBus()
    static let object = [Int]()
    // for global
    func onMain(noti: SystemNotification, handler: @escaping NotiHandler) {
        let name = noti.rawValue
        unregister(noti)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didRecieve(notification:)), name: Notification.Name(name), object: nil)
        dict[name] = handler
    }
    
    
    // for global
    func postToMain(_ noti: SystemNotification, object: [Int]? = nil) {
        let name = noti.rawValue
        if object != nil {
            NotificationCenter.default.post(name: Notification.Name(name), object: nil, userInfo: [EventBus.object: object!])
        } else {
            NotificationCenter.default.post(name: Notification.Name(name), object: nil, userInfo: nil)
        }
    }

    
    // For calling only
    func unregister(_ noti: SystemNotification) {
        let name = noti.rawValue
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(name), object: nil)
        dict[name] = nil
    }
    
    // For calling only
    @objc func didRecieve(notification: NSNotification) {
        dict[notification.name.rawValue]?(notification.userInfo?[EventBus.object])
    }
}

enum SystemNotification: String {
    case getEntry
    case removeEntry
}
