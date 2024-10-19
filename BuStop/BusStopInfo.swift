//
//  BusStopInfo.swift
//  BuStop
//

//

//버스정류장 정보 불러온 후 현재위치 n미터 이내 정류장이름을 String배열로 불러옮. 그리고 console에 출력

//let busstop = BusStopInfo(filePath: "/Users/geun/Desktop/input.csv")
//
//let listOfBusStop: [String] = busstop.FindBusStop(n)
//for i in 0..<listOfBusStop.count{
//    print(listOfBusStop[i])
//}


import Foundation
import CSV
import CoreLocation
//CSV.swift패키지 필요, https://github.com/yaslab/CSV.swift.git

//대구 시내 정류장정보를 가지고 있음
public class BusStopInfo: ObservableObject{
//    정류소아이디[0],모바일아이디[1],정류소명[2],영문명[3],시도[4],구군[5],동[6],경도[7],위도[8],경유노선수[9],경유노선[10]
    var name:[String] = []          //정류장 이름
    var longitude:[String] = []     //정류장 경도
    var latitude:[String] = []      //정류장 위도
    var busNum:[String] = []        //해당 정류장 정차버스 수
    var busList:[[String]] = [[]]   //해당 정류장 버스 종류
    var sizeOfArray = 0             //총 배열의 크기
    let currentLocation: LocationInfo = LocationInfo()
    
    @Published var isReset = true
    
    var busIndex = [String: Int]()  //key: 정류장 이름, value: 정류장에 해당하는 index. 위 배열에 사용
    
    //파일 경로 설정
    init(filePath: String){
        //csv파일 읽기
    
        let fileManager = FileManager.default
        let documentPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        let filename = "input.csv"
        let filepath = documentPath?.appendingPathComponent(filename)
        print(filepath)
        
        let stream = InputStream(url: filepath!)!
        let csv = try! CSVReader(stream: stream)
        
        
        busList.removeAll()     //버그 발생 방지!
        //csv파일 정보  배열에 저장
        while let row = csv.next() {
            var bus: [String] = []
            
            name.append(row[2])
            longitude.append(row[7])
            latitude.append(row[8])
            busNum.append(row[9])
            
            for j in 10..<row.count{
                bus.append(row[j])
            }
            
            busList.append(bus)
            busIndex[row[2]] = sizeOfArray
            sizeOfArray += 1
        }
        
        for i in 0..<10 {
            print("\(i) : \(name[i]) \(busNum[i]) \(self.busList[i])")
        }
        
        currentLocation.viewDidLoad()
    }
    
    //inMeter내의 주변 버스정류장 찾기 함수
    func FindBusStop(_ inMeter: CLLocationDistance) -> [String]?{
        var bsLongtitue: Double
        var bsLatitude: Double
        var distance: CLLocationDistance
        var listOfBusStop: [String] = []
        
        self.currentLocation.viewDidLoad()
        if currentLocation.latitude == nil || currentLocation.longitude == nil{
            return nil
        }
        
        for i in 1..<self.sizeOfArray{
            bsLongtitue = Double(self.longitude[i])!
            bsLatitude = Double(self.latitude[i])!
            distance = self.currentLocation.distance(latitude: bsLatitude, longitude: bsLongtitue)
            if distance <= inMeter{
                listOfBusStop.append(self.name[i])
            }
        }
        
        if isReset == true {
            isReset = false
        }
        else {
            isReset = true
        }
        print(isReset)
        
        return listOfBusStop
    }
    
    func FindBusInfo(from busStops: [String], at idx:Int) -> [String]?{

        var selectedBusStop: String? = ""
        var row = 0
        //주변 정류장 배열과 idx로 선택한 정류장 찾기
        selectedBusStop = busStops[idx]
        
        // csv에서 선택한 정류장 이름으로 해당 row 찾기
        if let selectedIdx = busIndex[selectedBusStop!]{
            row = selectedIdx
        }
        
        // 해당 row에서 정차하는 버스의 수, 버스종류 찾기
        print("버스의 수: \(busNum[row])")
        print("버스의 종류: ")
        print(busList[row])
         
        return busList[row]
    }
    
    func returnBusNum(of selectedBusStop: String) -> [String]{

        var row = 0
        var changeToString = [String]()
 
        // csv에서 선택한 정류장 이름으로 해당 row 찾기
        if let selectedIdx = busIndex[selectedBusStop]{
            row = selectedIdx
        }
        
        // 해당 row에서 정차하는 버스의 수, 버스종류 찾기
        print("버스의 수: \(busNum[row])")
        print("버스의 종류: ")
        print(busList[row])
        print(busList[row][0].split(separator: ","))
        
        for num in busList[row][0].split(separator: ",") {
            changeToString.append(String(num))
        }
        
        return changeToString
    }
    
    func resetLocation(_ inMeter: CLLocationDistance) {
        var bsLongtitue: Double
        var bsLatitude: Double
        var distance: CLLocationDistance
        var listOfBusStop: [String] = []
        
        self.currentLocation.viewDidLoad()
        if currentLocation.latitude == nil || currentLocation.longitude == nil{
            //return nil
        }
        
        for i in 1..<self.sizeOfArray{
            bsLongtitue = Double(self.longitude[i])!
            bsLatitude = Double(self.latitude[i])!
            distance = self.currentLocation.distance(latitude: bsLatitude, longitude: bsLongtitue)
            if distance <= inMeter{
                listOfBusStop.append(self.name[i])
            }
        }
        
        // isReset != isReset
        print("reset")
    }
}


