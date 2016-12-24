//
//  BoardCellView.swift
//  CirclesAndCrosses
//
//  Created by はるふ on 2016/12/24.
//  Copyright © 2016年 はるふ. All rights reserved.
//

import UIKit

class BoardCellView: UIView {
    var state: BoardCellState = .none {
        didSet {
            switch state {
            case .circle:
                self.backgroundColor = UIColor.green
            case .cross:
                self.backgroundColor = UIColor.red
            case .none:
                self.backgroundColor = UIColor.white
            }
        }
    }
}
