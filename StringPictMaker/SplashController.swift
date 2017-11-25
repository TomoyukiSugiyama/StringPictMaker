//
//  ViewController.swift
//  StringPictMaker
//
//  Created by 杉山智之 on 2017/11/15.
//  Copyright © 2017年 杉山智之. All rights reserved.
//

import UIKit

/// スプラッシュビューを表示
class SplashController: UIViewController {
    var logoImageView: UIImageView!
    /// Create splash view
    override func viewDidLoad() {
        super.viewDidLoad()
        // imageView作成
        self.logoImageView = UIImageView(frame: CGRect(x:0.0, y:0.0, width:204.0, height:77.0))
        // 画面中心に作成
        self.logoImageView.center = self.view.center
        // logo設定
        self.logoImageView.image = UIImage(named: "jv_logo")
        // viewに追加
        self.view.addSubview(self.logoImageView)
    }
    /// メモリワーニング
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /// アニメーションを表示
    ///
    /// - Parameter animated: <#animated description#>
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 少し縮小するアニメーション
        UIView.animate(withDuration: 0.3,
                       delay: 1.0,
                       options: UIViewAnimationOptions.curveEaseOut,
                       animations: { () in
                        self.logoImageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: { (Bool) in
        })
        // 拡大させて、消えるアニメーション
        UIView.animate(withDuration: 0.2,
                       delay: 1.3,
                       options: UIViewAnimationOptions.curveEaseOut,
                       animations: { () in
                        self.logoImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                        self.logoImageView.alpha = 0
        }, completion: { (Bool) in
            // imageListに画面遷移
            self.logoImageView.removeFromSuperview()
            let storyboard = self.storyboard!
            let nextView = storyboard.instantiateViewController(withIdentifier: "ImageList_id")
            self.present(nextView,animated:false,completion: nil)
        })
    }
    /// 画面の向きを固定
    override var shouldAutorotate: Bool {
        get {
            return false
        }
    }
    /// ホームボタンが下になるよう画面の向きを設定
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
        }
    }

}

