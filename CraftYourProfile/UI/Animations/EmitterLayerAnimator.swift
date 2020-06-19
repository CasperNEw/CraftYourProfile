//
//  EmitterLayerAnimator.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 09.06.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class EmitterLayerAnimator {

    private let bounds = UIScreen.main.bounds

    func addAnimationOnView(_ view: UIView) {
        setupEmitterAnimation { [weak view] (emitter) in
            view?.layer.addSublayer(emitter)
        }
    }

    private func setupEmitterAnimation(completion: @escaping (CAEmitterLayer) -> Void) {

        let emitterLayer = CAEmitterLayer()
        let item = DispatchWorkItem {
            emitterLayer.emitterPosition = CGPoint(x: self.bounds.width / 2, y: self.bounds.height + 40)
            emitterLayer.emitterSize = CGSize(width: self.bounds.width + 50, height: 20)
            emitterLayer.emitterShape = .line
            emitterLayer.beginTime = CACurrentMediaTime()
            emitterLayer.timeOffset = 5
            emitterLayer.birthRate = 0.3

            let emoji = ["😍", "🥰", "😘", "😜", "💋", "❤️"]
            emitterLayer.emitterCells = self.makeEmitterCells(emoji: emoji)
        }

        item.notify(queue: DispatchQueue.main) {
            completion(emitterLayer)
        }

        DispatchQueue.global(qos: .userInteractive).async(execute: item)
    }

    private func makeEmitterCells(emoji: [String]) -> [CAEmitterCell] {

        var cells = [CAEmitterCell]()

        for index in 0..<emoji.count*3 {

            let cell = CAEmitterCell()
            let random = .pi / 180 * Float.random(in: -20...20)
            cell.contents = emoji[index % emoji.count].emojiToImage()?.rotate(radians: random)?.cgImage
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
