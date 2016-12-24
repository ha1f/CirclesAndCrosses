//
//  BoardCellView.swift
//  CirclesAndCrosses
//
//  Created by はるふ on 2016/12/24.
//  Copyright © 2016年 はるふ. All rights reserved.
//

import UIKit

class BoardCellView: UIImageView {
    lazy var circleImage: UIImage = {
        let imageSize = CGSize(width: 200, height: 200)
        let margin: CGFloat = 25
        let circleSize = CGSize(width: imageSize.width - margin * 2, height: imageSize.height - margin * 2)
        UIGraphicsBeginImageContext(imageSize)
        if let context = UIGraphicsGetCurrentContext() {
            context.setStrokeColor(UIColor.red.cgColor)
            context.setLineWidth(8)
            context.strokeEllipse(in: CGRect(origin: CGPoint(x: margin, y: margin), size: circleSize))
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsPopContext()
        return image!
    }()
    
    lazy var crossImage: UIImage = {
        let imageSize = CGSize(width: 200, height: 200)
        let margin: CGFloat = 25
        let circleSize = CGSize(width: imageSize.width - margin * 2, height: imageSize.height - margin * 2)
        UIGraphicsBeginImageContext(imageSize)
        if let context = UIGraphicsGetCurrentContext() {
            context.setStrokeColor(UIColor.blue.cgColor)
            context.setLineWidth(8)
            context.move(to: CGPoint(x: margin, y: margin))
            context.addLine(to: CGPoint(x: imageSize.width - margin, y: imageSize.height - margin))
            context.move(to: CGPoint(x: imageSize.width - margin, y: margin))
            context.addLine(to: CGPoint(x: margin, y: imageSize.height - margin))
            context.strokePath()
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsPopContext()
        return image!
    }()
    
    var state: BoardCellState = .none {
        didSet {
            switch state {
            case .circle:
                self.image = circleImage
            case .cross:
                self.image = crossImage
            case .none:
                self.image = nil
            }
        }
    }
}
