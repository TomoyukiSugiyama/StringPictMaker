//
//  ImageBoard.swift
//  StringPictMaker
//
//  Created by 杉山智之 on 2017/11/19.
//  Copyright © 2017年 杉山智之. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class ImageBoard: UIViewController, CLLocationManagerDelegate{
    //,SampleViewDelegate{
    var delegateParamId: Int = 0
    var imageView : UIView? = nil
    var isUsed:Bool = false
    var myLocationManager:CLLocationManager!
    var addresstxt:String!
    var gpsTagArray = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ImageBoard - delegateParamId:",delegateParamId)
        myLocationManager = CLLocationManager()
        myLocationManager.delegate = self
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
                if (view.tag & 0x3FF) == DataManager.TagIDs.typeGPS.rawValue {
                    print("ImageEditor - initView - tagGPS - view.tag:",view.tag)
                    self.isUsed = true
                    self.gpsTagArray.append(view.tag)
                }else if view.tag == DataManager.TagIDs.typeDUMMY.rawValue {
                    
                }
            }
        }
        self.getGPS()
    }
    
    func getGPS(){
        if(self.isUsed == true){
            let status = CLLocationManager.authorizationStatus()
            if(status == CLAuthorizationStatus.notDetermined) {
                print("ImageBoard - getGPS - status",status)
                //self.myLocationManager.requestWhenInUseAuthorization()
            }else{
                print(status)
            }
            //取得精度の設定
            //myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
            myLocationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            // 取得頻度の設定
            //myLocationManager.distanceFilter = 100
            //myLocationManager.startUpdatingLocation()
            myLocationManager.requestLocation()
            //myLocationManager.stopUpdatingLocation()
            
        }
        
        //viewGPS.text = self.addresstxt
        //viewGPS.text = "test"
        //print("ImageBoard - getGPS - addresstxt:",self.addresstxt);

    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("ユーザーはこのアプリケーションに関してまだ選択を行っていません")
            self.myLocationManager.requestWhenInUseAuthorization()
            // 許可を求めるコードを記述する
            break
        case .denied:
            print("ローケーションサービスの設定が「無効」になっています (ユーザーによって、明示的に拒否されています）")
            // 「設定 > プライバシー > 位置情報サービス で、位置情報サービスの利用を許可して下さい」を表示する
            break
        case .restricted:
            print("このアプリケーションは位置情報サービスを使用できません(ユーザによって拒否されたわけではありません)")
            // 「このアプリは、位置情報を取得できないために、正常に動作できません」を表示する
            break
        case .authorizedAlways:
            print("常時、位置情報の取得が許可されています。")
            // 位置情報取得の開始処理
            break
        case .authorizedWhenInUse:
            print("起動時のみ、位置情報の取得が許可されています。")
            // 位置情報取得の開始処理
            break
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0]
        reverseGeocode(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
    }
    func locationManagerDidPauseLocationUpdates(manager: CLLocationManager!,didUpdateLocations locations: [CLLocation]) {
        print("locationManagerDidPauseLocationUpdates")
    }
    func locationManager(_ manager: CLLocationManager,didFailWithError error: Error){
        print("error")
    }
    func reverseGeocode(latitude:CLLocationDegrees, longitude:CLLocationDegrees) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    print(pm.country!)
                    print(pm.locality!)
                    print(pm.subLocality!)
                    print(pm.thoroughfare!)
                    print(pm.postalCode!)
                    if pm.subThoroughfare != nil {
                        print(pm.subThoroughfare!)
                    }
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    
                    self.addresstxt = pm.administrativeArea!
                    for tag in self.gpsTagArray{
                        let view:UILabel = self.imageView?.viewWithTag(tag) as! UILabel
                        view.text = pm.administrativeArea!
                        //view.text = pm.administrativeArea!
                    }
                    
                    //self.setLabel()
                    /*                    print(pm.country)
                     print(pm.postalCode)
                     print(pm.administrativeArea)
                     print(pm.subAdministrativeArea)
                     print(pm.subLocality)
                     print(pm.thoroughfare)
                     print(pm.subThoroughfare)
                     */
                    //print(addressString)
                }
        })
    }
}
