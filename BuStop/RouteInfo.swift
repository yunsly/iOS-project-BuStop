//
//  RouteInfo.swift
//  BuStop
//

import Foundation
public class RouteInfo{
    func printRoute(_: [String]){
        let busStopObject: BusStopInfo = .init(filePath: "BusStopInfo.swift")
        print("busstop name: ", busStopObject.name)
    }
}
