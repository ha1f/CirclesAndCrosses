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
    
    func restartGame() {
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
    func onChangeGameState(newValue: GameState) {
        switch newValue {
        case .finished(let winner):
            let controller = UIAlertController(title: "ゲーム終了", message: "\(winner)の勝利", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "もう一度", style: .default, handler: {[weak self] _ in
                self?.restartGame()
            })
            controller.addAction(okAction)
            self.present(controller, animated: true, completion: nil)
        default:
            break
        }
    }
}
