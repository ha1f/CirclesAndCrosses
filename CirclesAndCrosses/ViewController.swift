//
//  ViewController.swift
//  CirclesAndCrosses
//
//  Created by はるふ on 2016/12/24.
//  Copyright © 2016年 はるふ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var boardView: BoardView! {
        didSet {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.onTappedBoardView(sender:)))
            self.boardView.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    private var manager: GameManager! {
        didSet {
            manager.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager = GameManager()
        
        restartGame()
    }
    
    private func restartGame() {
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
