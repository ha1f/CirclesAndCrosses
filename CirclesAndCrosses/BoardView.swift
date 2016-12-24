//
//  BoardView.swift
//  CirclesAndCrosses
//
//  Created by はるふ on 2016/12/24.
//  Copyright © 2016年 はるふ. All rights reserved.
//

import UIKit

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
