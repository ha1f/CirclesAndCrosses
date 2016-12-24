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
    func onChangeGameState(newValue: GameState)
}

class GameManager {
    private(set) var turn = GameManager.initialTurn {
        didSet {
            delegate?.onChangeTurn(newValue: turn)
        }
    }
    private(set) var states = GameManager.initialState {
        didSet {
            checkGameState()
        }
    }
    private var gameState = GameState.inGame {
        didSet {
            delegate?.onChangeGameState(newValue: gameState)
        }
    }
    
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
    
    func checkGameState() {
        for states in states {
            if let v = states.reduce(states.first, { $0 == $1 ? $0 : nil }), v != .none {
                // 横にすべて等しい
                self.gameState = .finished(win: v)
                return
            }
        }
        for i in 0..<states.first!.count {
            let states = self.states.map({ states in states[i] })
            if let v = states.reduce(states.first, { $0 == $1 ? $0 : nil }), v != .none {
                // 縦にすべて等しい
                self.gameState = .finished(win: v)
                return
            }
        }
        let count = states.count
        if count == states.first!.count {
            // 斜め判定可能
            // 右斜
            let states1 = (0..<count).map({ i in
                return self.states[i][i]
            })
            if let v = states1.reduce(states1.first, { $0 == $1 ? $0 : nil }), v != .none {
                self.gameState = .finished(win: v)
                return
            }
            // 左斜め
            let states2 = (0..<count).map({ i -> BoardCellState in
                return self.states[i][count - i - 1]
            })
            if let v = states2.reduce(states2.first, { $0 == $1 ? $0 : nil }), v != .none {
                self.gameState = .finished(win: v)
                return
            }
        }
        
        // 引き分け判定
        for states in states {
            for state in states {
                if state == .none {
                    return
                }
            }
        }
        self.gameState = .finished(win: nil)
    }
    
    func reset() {
        gameState = GameState.inGame
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
        switch gameState {
        case .inGame:
            if isEmpty(at: pos) {
                states[pos.y][pos.x] = value
                nextTurn()
                delegate?.onChangeState([BoardCellStateChange(pos: pos, newValue: value)])
            }
        default:
            break
        }
    }
}
