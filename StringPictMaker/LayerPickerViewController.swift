//
//  LayerPickerViewController.swift
//  StringPictMaker
//
//  Created by 杉山智之 on 2017/12/10.
//  Copyright © 2017年 杉山智之. All rights reserved.
//

import Foundation
import UIKit

/// TODO:
/// ＊コレクションビュー、セルのレイアウト
/// ＊レイヤーオンオフの「目」
/// ＊レイヤー切り替え後、ImageViewに反映
class LayerPickerViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate{
    // スクロールビューを生成
    var scrollView: UIScrollView! = nil
    // コレクションビューを生成
    var collectionView : UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = CGRect(x:self.view.frame.width - 100,y:0,width:100,height:self.view.frame.height - 100)
        self.view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        // スクロールビューを設置
        /*scrollView = UIScrollView()
        scrollView.frame = CGRect(x:5,y:5,width:self.view.frame.width - 10,height:self.view.frame.height - 10)
        scrollView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        //scrollView.center = self.view.center
        self.view.addSubview(scrollView)
        */
        // コレクションビューを生成
        let layout = UICollectionViewFlowLayout()
        let frame = CGRect(x:10,y:10,width:self.view.frame.width - 20,height:self.view.frame.height - 20)
        collectionView = UICollectionView(frame:frame, collectionViewLayout: layout)
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell_id")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        //scrollView.addSubview(collectionView)
        self.view.addSubview(collectionView)
        print("LayerPickerViewController - viewDidLoad")
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("LayerPickerViewController - collectionView")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell_id", for: indexPath) as! ImageCell
        cell.textLabel?.text = indexPath.row.description
        cell.editButton?.setTitle("EDIT", for: .normal)
        return cell
    }

    /// コンテナをスーパービューに追加
    func displayContentController(content:UIViewController, container:UIView){
        print("ColorPickerViewController - displayContentController")
        addChildViewController(content)
        content.view.frame = container.bounds
        container.addSubview(content.view)
        content.didMove(toParentViewController: self)
    }
    /// コンテナをスーパービューから削除
    func hideContentController(content:UIViewController){
        print("ColorPickerViewController - hideContentController")
        content.willMove(toParentViewController: self)
        content.view.removeFromSuperview()
        content.removeFromParentViewController()
    }
}
