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
class LayerPickerViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    var imageView:UIView!
    func setImageView(view: UIView) {
        self.imageView = view
    }
    
    // コレクションビューを生成
    var tableView : UITableView!
//    var layerCell: UICollectionViewCell!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = CGRect(x:self.view.frame.width/2,y:0,width:self.view.frame.width/2,height:self.view.frame.height - 100)
        self.view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        // コレクションビューを生成
//        let layout = UITableViewFlowLayout()
        let frame = CGRect(x:10,y:10,width:self.view.frame.width - 20,height:self.view.frame.height - 20)
        print("LayerPickerViewController - viewDidLoad - frame:",frame)
        tableView = UITableView(frame:frame, style: .plain)
        tableView.register(LayerCell.self, forCellReuseIdentifier: "LayerCell_id")
        //tableView.register(LayerCell.self, forCellWithReuseIdentifier: "LayerCell_id")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        tableView.rowHeight = 200.0
        self.view.addSubview(tableView)
        print("LayerPickerViewController - viewDidLoad")
    }
    
    // セクション数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    // セクションの行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageView.subviews.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LayerCell_id", for: indexPath) as! LayerCell
        //cell.textLabel?.text = indexPath.row.description
        cell.layerLabel?.text = "Layer" + String(indexPath.row)
        cell.imageLabel?.image = imageView.subviews[indexPath.row].GetImage()
        print("indexPath:",indexPath.row,imageView.subviews[indexPath.row].GetImage())
        cell.editButton?.setTitle("EYE", for: .normal)
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
