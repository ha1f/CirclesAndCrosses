//
//  BoardCellState.swift
//  CirclesAndCrosses
//
//  Created by はるふ on 2016/12/24.
//  Copyright © 2016年 はるふ. All rights reserved.
//

import Foundation

enum BoardCellState: Int {
    case circle
    case cross
    case none
}

struct BoardCellPosition {
    var x: Int
    var y: Int
}

struct BoardCellStateChange {
    var pos: BoardCellPosition
    var newValue: BoardCellState
}
