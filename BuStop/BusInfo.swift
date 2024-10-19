//
//  BusesInfo.swift
//  BuStop
//
//

import Foundation
import CSV

// 정류장 선택 시 해당 정류장의 버스 정보 반환하는 클래스
class BusInfo{

    let busStopInfo : BusStopInfo
    
    init(busStopInfo: BusStopInfo){
        
        self.busStopInfo = busStopInfo
        
        for i in 0..<10 {
            print("\(i) : \(self.busStopInfo.name[i]) \(self.busStopInfo.busNum[i]) \(self.busStopInfo.busList[i])")
        }
    }
    
    func FindBusInfo(from busStops: [String], at idx:Int) -> [String]?{

        var selectedBusStop: String? = ""
        var row = 0
        //주변 정류장 배열과 idx로 선택한 정류장 찾기
        selectedBusStop = busStops[idx]
        
        // csv에서 선택한 정류장 이름으로 해당 row 찾기
        if let selectedIdx = busStopInfo.busIndex[selectedBusStop!]{
            row = selectedIdx
        }
        
        // 해당 row에서 정차하는 버스의 수, 버스종류 찾기
        print("버스의 수: \(busStopInfo.busNum[row])")
        print("버스의 종류: ")
        print(busStopInfo.busList[row])
         
        return busStopInfo.busList[row]
    }
}


