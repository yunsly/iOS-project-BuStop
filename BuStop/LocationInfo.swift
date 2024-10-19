//
//  LocationInfo.swift
//  BuStop
//
//

import SwiftUI
import CoreLocation

//현재 위치정보 받아오기 클래스
class LocationInfo: UIViewController, CLLocationManagerDelegate {

    //LocationManager 선언
    var locationManager:CLLocationManager!
    
    //위도와 경도
    var latitude: Double?   //위도
    var longitude: Double?  //경도
  
    //latitude와 longitude의 위치정보 업데이트 함수
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //locationManager 인스턴스 생성 및 델리게이트 생성
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        //포그라운드 상태에서 위치 추적 권한 요청
        locationManager.requestWhenInUseAuthorization()
        
        //배터리에 맞게 권장되는 최적의 정확도
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        //위치업데이트
        locationManager.startUpdatingLocation()
        
        //위도 경도 가져오기
        let coor = locationManager.location?.coordinate
        latitude = coor?.latitude
        longitude = coor?.longitude
        
    }

}


extension LocationInfo{
    //위치정보간의 거리 구하기 함수
    func distance(latitude: Double, longitude: Double) -> CLLocationDistance{
        let from = CLLocation(latitude: latitude, longitude: longitude)
        if self.latitude != nil && self.longitude != nil{
            let to = CLLocation(latitude: self.latitude!, longitude: self.longitude!)
            //거리 return(meters)
            return from.distance(from: to)
        }else{
            return 0
        }
    }
}
