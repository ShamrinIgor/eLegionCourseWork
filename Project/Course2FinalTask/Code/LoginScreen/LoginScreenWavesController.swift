//
//  LoginScreenWavesController.swift
//  Course2FinalTask
//
//  Created by Игорь on 29.04.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
struct LoginScreenWavesController: View {
   
    let universalSize = UIScreen.main.bounds
    
    var body: some View {
        getSinWave().foregroundColor(Color.init(red: 0.3, green: 0.6, blue: 1).opacity(0.4))
    }
    
    func getSinWave(baseLine:CGFloat =  UIScreen.main.bounds.height/2) -> Path {
        Path { path in
            path.move(to: CGPoint(x: 0, y: universalSize.height/2))
            path.addCurve(to: CGPoint(x: universalSize.width, y: baseLine),
                          control1: CGPoint(x: universalSize.width * (0.25), y: 150 + baseLine),
                          control2: CGPoint(x: universalSize.width * (0.75), y: -150 + baseLine)
            )
            path.addLine(to: CGPoint(x: universalSize.width, y: universalSize.height))
            path.addLine(to:  CGPoint(x: 0, y: universalSize.height))
        }
    }
}

@available(iOS 13.0, *)
struct LoginScreenWavesController_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreenWavesController()
    }
}
