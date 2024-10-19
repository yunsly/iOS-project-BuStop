//
//  SetDest.swift
//  BuStop
//
//

import Foundation
import CSV

//버스 선택 시 해당 버스의 노선을 반환하는 클래스
class CheckDest{
    
    var stops: [String]?
    var numOfStops: [Int]?
    var passFirstRow = 0
    
    var busStop: String?        // 정류장
    var numOfBuses: [Int]?        // 경유하는 버스 개수
    var buses: [String]?        // 경유하는 버스 리스트
    
    // csv파일에서 가져올 값 정류소아이디[0],정류소명[1],버스번호[2],첫차시간[3],막차시간[4],운행회수[5],평균배차시간[6]
    var busNames:[String] = []          //버스 번호
    var busNamesNoDup:[String] = []
    var route:[String] = []        //노선
    var routeList:[String:[String]]? = ["":[""]]   //해당 정류장 버스 종류
    var sizeOfRoute = 0             //총 배열의 크기
    
    var busIndex = [String: Int]()  //key: 정류장 이름, value: 정류장에 해당하는 index. 위 배열에 사용
    
    //파일 경로 설정
    init(){
        //csv파일 읽기
        let fileManager = FileManager.default
        let documentPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        let filename = "busRoute.csv"
        let filepath = documentPath?.appendingPathComponent(filename)
        print(filepath)
        
        let stream = InputStream(url: filepath!)!
        let csv = try! CSVReader(stream: stream)
        
//        routeList.removeAll()     //버그 발생 방지
        
        //csv파일 정보  배열에 저장
        while let row = csv.next() {
            //첫행(열 설명하는 행) 통과
            if passFirstRow == 0{
                passFirstRow = 1
                continue
            }
            
            busNames.append(row[2])
            route.append(row[1])
            }
        
        busNamesNoDup=removeDuplicate(busNames)
        
        for i in 0..<busNamesNoDup.count{
            for j in 0..<busNames.count{
                if busNamesNoDup[i] == busNames[j]{
                    stops?.append(route[j])
                }
            }
            routeList?[busNamesNoDup[i]] = stops
            stops = []
        }
        
    }
 
    
    func FindDest(of num: String)->[String]?{
        
        let trimNum = num.trimmingCharacters(in: .whitespaces)
        print(self.routeList?[trimNum])
        return self.routeList?[trimNum]
    }
    func removeDuplicate (_ array: [String]) -> [String] {
        var removedArray = [String]()
        for i in array {
            if removedArray.contains(i) == false {
                removedArray.append(i)
            }
        }
        return removedArray
    }
}

extension Array where Element: Equatable {
    func doesNotContain(_ element: Element) -> Bool {
        return !contains(element)
    }
}
