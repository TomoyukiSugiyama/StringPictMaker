//
//  MenuButtonActionController.swift
//  StringPictMaker
//
//  Created by 杉山智之 on 2017/11/21.
//  Copyright © 2017年 杉山智之. All rights reserved.
//

import Foundation
import UIKit
// CustomButton Class (Menu Button)
class MenuButtonActionController: UIButton {
    var isMoveing: Bool = false
    var position: CGPoint!
    /// began to touch menu butoon
    ///
    /// - Parameters:
    ///   - touches: touches
    ///   - event: event
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        position = self.frame.origin
    }
    /// touches moved
    ///
    /// - Parameters:
    ///   - touches: touches
    ///   - event: event
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        isMoveing = true
        
        let touchEvent = touches.first!
        
        // ドラッグ前の座標
        let preDx = touchEvent.previousLocation(in: superview).x
        let preDy = touchEvent.previousLocation(in: superview).y
        
        // ドラッグ後の座標
        let newDx = touchEvent.location(in: superview).x
        let newDy = touchEvent.location(in: superview).y
        
        // ドラッグしたx座標の移動距離
        let dx = newDx - preDx
        
        // ドラッグしたy座標の移動距離
        let dy = newDy - preDy
        
        // 画像のフレーム
        var viewFrame: CGRect = self.frame
        
        // 移動分を反映させる
        /// TODO フレームの外に出ないように設定
        viewFrame.origin.x += dx
        viewFrame.origin.y += dy
        self.frame = viewFrame
        
    }
    /// touches ended
    ///
    /// - Parameters:
    ///   - touches: touches
    ///   - event: event
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        isMoveing = false
        if position == self.frame.origin {
             self.sendActions(for: .touchUpOutside)
        }
    }
}
