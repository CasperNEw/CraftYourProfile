//
//  EmitterLayerAnimator.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 09.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class EmitterLayerAnimator {

    // MARK: - Properties
    private let bounds = UIScreen.main.bounds

    // MARK: - Public function
    public func createEmitterLayer(with emoji: [String]) -> CAEmitterLayer {

        let emitterLayer = CAEmitterLayer()

        emitterLayer.emitterPosition = CGPoint(x: bounds.width / 2, y: bounds.height + 40)
        emitterLayer.emitterSize = CGSize(width: bounds.width + 50, height: 20)
        emitterLayer.emitterShape = .line
        emitterLayer.timeOffset = 5
        emitterLayer.birthRate = 0.3
        emitterLayer.emitterCells = createEmitterCells(with: emoji)

        return emitterLayer
    }

    // MARK: - Module function
    private func createEmitterCells(with emoji: [String]) -> [CAEmitterCell] {

        var cells = [CAEmitterCell]()

        let verifyEmoji = emoji.filter {
            $0.unicodeScalars.first?.properties.isEmoji ?? false
        }

        for index in 0..<verifyEmoji.count*3 {

            let cell = CAEmitterCell()
            let random = .pi / 180 * Float.random(in: -20...20)

            cell.contents = verifyEmoji[index % verifyEmoji.count]
                .emojiToImage()?
                .rotate(radians: random)?
                .cgImage

            cell.scale = 0.4
            cell.scaleRange = 0.3
            cell.birthRate = Float.random(in: 0.2...0.6)
            cell.lifetime = 8.0
            cell.velocity = 0
            cell.yAcceleration = -bounds.height / 28
            cells.append(cell)
        }
        return cells
    }
}
