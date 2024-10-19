//
//  BusesInfo.swift
//  BuStop
//
//  Created by 최명빈 on 2022/05/30.
//

import Foundation
import UIKit
// 정류장 선택 시 해당 정류장의 버스 정보 반환하는 클래
class BusInfo: UIViewController{
    var busStop: String? = "대명시장앞"    // 정류장
    var numOfBuses: Int?        // 경유하는 버스 개수
    var buses: [String]?        // 경유하는 버스 리스트

    // 선택한 정류장을 경유하는 버스 리턴 함수
    func FindBusInfo(busStop: String)->[String]{
        let iter = self.numOfBuses
        for i in 1..<iter!{
            print(self.buses![i])
        }
        return self.buses!
    }
}


