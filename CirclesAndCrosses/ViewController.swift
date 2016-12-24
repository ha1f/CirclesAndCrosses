//
//  ViewController.swift
//  CirclesAndCrosses
//
//  Created by はるふ on 2016/12/24.
//  Copyright © 2016年 はるふ. All rights reserved.
//

import UIKit

enum BoardCellState {
    case circle
    case cross
    case none
}

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

struct BoardCellPosition {
    var x: Int
    var y: Int
}

class BoardView: UIStackView {
    private var cellViews = [[BoardCellView]]()
    
    func setInitialStates(_ statess: [[BoardCellState]]) {
        self.cellViews.forEach { cellViews in
            cellViews.forEach { cellView in
                cellView.removeFromSuperview()
            }
        }
        self.cellViews = []
        self.axis = .vertical
        self.distribution = .fillEqually
        statess.forEach {states in
            let stackView = UIStackView()
            stackView.distribution = .fillEqually
            stackView.axis = .horizontal
            let cellViews = states.map { state -> BoardCellView in
                let cellView = BoardCellView()
                cellView.layer.borderWidth = 1
                cellView.layer.borderColor = UIColor.black.cgColor
                cellView.state = state
                stackView.addArrangedSubview(cellView)
                return cellView
            }
            stackView.layoutIfNeeded()
            self.cellViews.append(cellViews)
            self.addArrangedSubview(stackView)
        }
        self.layoutIfNeeded()
    }
    
    func put(_ value: BoardCellState, at pos: BoardCellPosition) {
        cellViews[pos.y][pos.x].state = value
    }
    
    func posFor(locationInView: CGPoint) -> BoardCellPosition {
        let x = Int(locationInView.x / (self.bounds.width / CGFloat(cellViews.first!.count)))
        let y = Int(locationInView.y / (self.bounds.height / CGFloat(cellViews.count)))
        return BoardCellPosition(x: x, y: y)
    }
}

class GameManager {
    private(set) var turn = BoardCellState.circle
    private(set) var states = GameManager.initialState
    
    static let initialState: [[BoardCellState]] = [[.none, .none, .none], [.none, .none, .none], [.none, .none, .none]]
    
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
        delegate?.onChangeTurn(newValue: turn)
    }
    
    func reset() {
        states = GameManager.initialState
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

struct BoardCellStateChange {
    var pos: BoardCellPosition
    var newValue: BoardCellState
}

protocol GameManagerDelegate: class {
    func onChangeState(_ changes: [BoardCellStateChange])
    func onChangeTurn(newValue: BoardCellState)
    func onReset(states: [[BoardCellState]])
}

// turn, statesがviewModelとして必要

class ViewController: UIViewController {
    
    @IBOutlet weak var boardView: BoardView!
    
    let manager = GameManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.onTappedBoardView(sender:)))
        self.boardView.addGestureRecognizer(tapGestureRecognizer)
        
        startGame()
    }
    
    private func startGame() {
        manager.reset()
    }
    
    func onTappedBoardView(sender: UITapGestureRecognizer) {
        let pos = boardView.posFor(locationInView: sender.location(in: boardView))
        manager.trySetState(manager.turn, at: pos)
    }

}

extension ViewController: GameManagerDelegate {
    func onReset(states: [[BoardCellState]]) {
        boardView.setInitialStates(states)
    }
    func onChangeState(_ changes: [BoardCellStateChange]) {
        changes.forEach { change in
            boardView.put(change.newValue, at: change.pos)
        }
    }
    func onChangeTurn(newValue: BoardCellState) {
        
    }
}
