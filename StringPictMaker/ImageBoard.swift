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
        print("ImageBoard - delegateParamId:",delegateParamId)
        self.initView()
        self.view.addSubview(imageView!)
    }
    
    func initView(){
        for view in (imageView?.subviews)!
        {
            // remove image from superview when tag is -1
            // because this image is "noimage"
            if view.tag == -1{
                view.removeFromSuperview()
            }else{
                if view.isKind(of: NSClassFromString("UIImageView")!) {
                    print("ImageEditor - initView")
                }else if view.isKind(of: NSClassFromString("UISearchBarBackground")!) {
                    
                }
            }
        }
    }
}
