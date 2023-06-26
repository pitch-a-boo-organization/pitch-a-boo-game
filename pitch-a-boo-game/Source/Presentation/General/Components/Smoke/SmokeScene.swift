//
//  SmokeScene.swift
//  pitch-a-boo-game
//
//  Created by Cicero Nascimento on 25/06/23.
//

import SpriteKit

class SmokeScene: SKScene {

    var config: SmokeConfig

    init(size: CGSize, config: SmokeConfig) {
        self.config = config
        super.init(size: size)

        backgroundColor = UIColor(config.backgroundColor)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func didMove(to view: SKView) {
        launchSmoke()
    }

    var customBirthRate: CGFloat {
        switch config.intensity {
        case .low:
            return 10
        case .medium:
            return 40
        case .high:
            return 100
        }
    }

    func launchSmoke() {
        for contentElement in config.content {
            let node = SKEmitterNode()

            node.particleTexture = SKTexture(image: contentElement.image)

            // Particle General
            node.particleBirthRate = 10
            node.particleLifetime = CGFloat(100)

            // Define a posição inicial no ponto específico (por exemplo, x: 100, y: 200)
            let startPoint = CGPoint(x: -40, y: 20)
            node.position = startPoint

            // Define a faixa de posição para que as partículas se concentrem em torno do ponto inicial
            let positionRange = CGVector(dx: 20, dy: 120) // Ajuste o valor conforme necessário

            node.particlePositionRange = positionRange
            node.emissionAngle = 0
            node.emissionAngleRange =  .pi / 6

            node.particleAlpha = 0.4
            node.particleAlphaRange = 180.3
            node.particleAlphaSpeed = CGFloat(-0.28)

            node.yAcceleration = 0
            node.particleScale = contentElement.scale
            node.particleScaleRange = 0.3
            node.particleScaleSpeed = 0.5

            node.particleSpeed = 100
            node.particleSpeedRange = 40
            node.particleColor = contentElement.color ?? .black
            node.particleColorBlendFactor = 1

            node.particleRotation = 0
            node.particleRotationRange = .pi * 2
            node.particleRotationSpeed = .pi * 1.6

            node.particleBlendMode = .alpha
            node.fieldBitMask = 0

            addChild(node)
        }

    }
}
