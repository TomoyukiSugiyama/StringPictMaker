//
//  ImageBoard.swift
//  StringPictMaker
//
//  Created by 杉山智之 on 2017/11/19.
//  Copyright © 2017年 杉山智之. All rights reserved.
//

import Foundation
import UIKit

class ImageBoard: UIViewController{
    //,SampleViewDelegate{
    var delegateParamId: Int = 0
    var imageView : UIView? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        print(delegateParamId)
        self.view.addSubview(imageView!)
    }
}
