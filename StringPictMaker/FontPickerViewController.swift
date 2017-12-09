//
//  FontPickerViewController.swift
//  StringPictMaker
//
//  Created by 杉山智之 on 2017/12/05.
//  Copyright © 2017年 杉山智之. All rights reserved.
//

import Foundation
import UIKit

class FontPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    //UIPickerViewの変数の宣言
    private var picker: UIPickerView!
    //表示するデータの配列
    private let data: NSArray = ["White","Yellow","Blue","Green","Red","Orange","Purple","Pink","Cyan"]
    override func viewDidLoad() {
        // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        //self.view.frame = CGRect(x:0,y:self.view.frame.height - 100 - 4,width:self.view.frame.width,height:100.0)
        //UIPickerViewのインスタンスを生成
        picker = UIPickerView()
        //位置とサイズを設定
        picker.frame = CGRect(x: 0, y: self.view.frame.height - 100 - 40, width: self.view.frame.width, height: 100.0)
        picker.backgroundColor = UIColor.lightGray
        //delegateの設定
        picker.delegate = self
        //dataSourceの設定
        picker.dataSource = self
        self.view.addSubview(picker)
        print("FontPickerViewController")
    }

    //PickerViewの個数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //表示する行数。配列の個数を返している
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    //表示する値
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row] as? String
    }
}
