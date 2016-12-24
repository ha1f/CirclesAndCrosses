//
//  GameState.swift
//  CirclesAndCrosses
//
//  Created by はるふ on 2016/12/24.
//  Copyright © 2016年 はるふ. All rights reserved.
//

import Foundation

enum GameState {
    case inGame
    case finished(win: BoardCellState)
}
