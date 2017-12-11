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
    // コレクションビューを生成
    var collectionView : UICollectionView!
//    var layerCell: UICollectionViewCell!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = CGRect(x:self.view.frame.width - 100,y:0,width:100,height:self.view.frame.height - 100)
        self.view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        // コレクションビューを生成
        let layout = UICollectionViewFlowLayout()
        let frame = CGRect(x:10,y:10,width:self.view.frame.width - 20,height:self.view.frame.height - 20)
        collectionView = UICollectionView(frame:frame, collectionViewLayout: layout)
        collectionView.register(LayerCell.self, forCellWithReuseIdentifier: "LayerCell_id")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        self.view.addSubview(collectionView)
        print("LayerPickerViewController - viewDidLoad")
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LayerCell_id", for: indexPath) as! LayerCell
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
