//
//  Protocol.swift
//  Gems Game Testing
//
//  Created by vLinkD on 15/02/20.
//  Copyright © 2020 chanonly123. All rights reserved.
//

import Foundation
import UIKit

protocol UpdateLables {
    func updateScore(_ conut: Int)
    func updateMoves(_ conut: Int)
    func updateProgressBar(_ conut: Int,_ bgColor: UIColor)
    func resetProgressBar()
}

