//
//  GameManager.swift
//  CirclesAndCrosses
//
//  Created by はるふ on 2016/12/24.
//  Copyright © 2016年 はるふ. All rights reserved.
//

import Foundation

protocol GameManagerDelegate: class {
    func onChangeState(_ changes: [BoardCellStateChange])
    func onChangeTurn(newValue: BoardCellState)
    func onReset(states: [[BoardCellState]])
}

class GameManager {
    private(set) var turn = GameManager.initialTurn {
        didSet {
            delegate?.onChangeTurn(newValue: turn)
        }
    }
    private(set) var states = GameManager.initialState
    
    static let initialState: [[BoardCellState]] = [[.none, .none, .none], [.none, .none, .none], [.none, .none, .none]]
    static let initialTurn = BoardCellState.circle
    
    weak var delegate: GameManagerDelegate?
    
    private func nextTurn() {
        switch turn {
        case .circle:
            turn = .cross
        case .cross:
            turn = .circle
        default:
            fatalError("unexpected turn .none!")
        }
    }
    
    func reset() {
        states = GameManager.initialState
        turn = GameManager.initialTurn
        delegate?.onReset(states: states)
    }
    
    func isEmpty(at pos: BoardCellPosition) -> Bool {
        return getState(at: pos) == .none
    }
    
    func getState(at pos: BoardCellPosition) -> BoardCellState {
        return states[pos.y][pos.x]
    }
    
    func trySetState(_ value: BoardCellState, at pos: BoardCellPosition) {
        if isEmpty(at: pos) {
            states[pos.y][pos.x] = value
            nextTurn()
            delegate?.onChangeState([BoardCellStateChange(pos: pos, newValue: value)])
        }
    }
}
