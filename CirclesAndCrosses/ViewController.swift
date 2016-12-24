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

class BoardView: UIStackView {
    private var cellViews = [[BoardCellView]]()
    
    func setInitialStates(_ statess: [[BoardCellState]]) {
        self.cellViews = []
        statess.forEach {states in
            let stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            stackView.distribution = .fillEqually
            let cellViews = states.map { state -> BoardCellView in
                let cellView = BoardCellView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
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
        print(cellViews)
    }
    
    func put(_ value: BoardCellState, x: Int, y: Int) {
        cellViews[y][x].state = value
    }
    
    func posFor(locationInView: CGPoint) -> (Int, Int) {
        let x = Int(locationInView.x / (self.bounds.width / CGFloat(cellViews.first!.count)))
        let y = Int(locationInView.y / (self.bounds.height / CGFloat(cellViews.count)))
        return (x, y)
    }
    
}



// turn, statesがviewModelとして必要

class ViewController: UIViewController {
    
    @IBOutlet weak var boardView: BoardView!
    
    static let initialState: [[BoardCellState]] = [[.none, .circle, .none], [.none, .none, .none], [.none, .cross, .none]]
    
    private var turn = BoardCellState.circle
    private var states = [[BoardCellState]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialiStates()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.onTappedBoardView(sender:)))
        self.boardView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func setInitialiStates() {
        self.states = ViewController.initialState
        boardView.setInitialStates(self.states)
    }
    
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
    
    private func isEmptyAt(x: Int, y: Int) -> Bool {
        return getState(x: x, y: y) == .none
    }
    
    private func getState(x: Int, y: Int) -> BoardCellState {
        return states[y][x]
    }
    
    private func setState(_ value: BoardCellState, x: Int, y: Int) {
        states[y][x] = value
        boardView.put(turn, x: x, y: y)
    }
    
    func onTappedBoardView(sender: UITapGestureRecognizer) {
        let (x, y) = boardView.posFor(locationInView: sender.location(in: boardView))
        if isEmptyAt(x: x, y: y) {
            setState(turn, x: x, y: y)
            nextTurn()
        }
    }

}
