//
//  ContentView.swift
//  BuStop
/

import SwiftUI

//MARK: - Start & Finding busStop
struct ContentView: View {
    @State var numOfStop: String = ""
    @State var isNavigationBarHidden: Bool = true
    @State var isLoading: Bool = true
    @ObservedObject var busStop : BusStopInfo
    @State var busStopList: [String]?
    @State var checkDest: CheckDest
    
    var body: some View {
        
//       ZStack {
////            // Start Screen
//            if isLoading {
//                launchScreenView
//                    .transition(.opacity)
//            }
//        }
//        .onAppear {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
//                withAnimation { isLoading.toggle() }
//            })
//        }
        
        NavigationView {
            ZStack{
                ZStack {
                    Color(red: 213/255, green: 223/255, blue: 240/255).ignoresSafeArea()
                    ZStack {
                        VStack {
                            ZStack {
                                Text("현재 위치의 주변 정류장입니다. \n 탑승하실 곳을 선택하세요.")
                                    .font(.title3)
                                    .multilineTextAlignment(.center)
                                    .padding(.leading, 50.0)
                                    .padding(.top, 20.0)
                                Spacer()
                                HStack {
                                    Image("CurrentStop")
                                        .resizable()
                                        .frame(width: 80, height: 80)
                                    Spacer()
                                }
                                .padding(.top, 10.0)
                                .padding(.leading, 10.0)

                            }
                            Spacer()
                        }

                        ZStack {
                            RoundedRectangle(cornerRadius: 35.0)
                                .padding(.top, 100.0)
                                .padding(.horizontal, 20.0)
                                .foregroundColor(.white)
                            ZStack {
                                ScrollView(.vertical, showsIndicators: false, content: {
                                    VStack (alignment: .leading){
                                        ForEach(busStopList!, id:\.self, content: { item in
                                            NavigationLink(destination: SelectBusView(busStop: busStop, busStopName: item, checkDest: checkDest))  {
                                                BusStopListItemView(busStopName: item)
                                            }
                                        })
                                    }
                                })
                                .frame(width: 300, height: 550, alignment: .leading)
                                .padding(.top, 90.0)
                                .padding(.horizontal, 20.0)
                            }
                        }
                    }
                }
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarHidden(isLoading)
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {busStopList = busStop.FindBusStop(200)}) {
                            Image(systemName: "arrow.counterclockwise")
                        }
                        .padding(.trailing, 15)
                    }
                }
                if isLoading {
                    ZStack (alignment: .center) {
                        Color(.white).edgesIgnoringSafeArea(.all)
                        Image("LaunchIcon")
                    }
                    .frame(height: UIScreen.main.bounds.height)
                    .transition(.move(edge: .top))
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    isLoading = false
                })
            }
        }
    }

}

//MARK: - Select Bus
struct SelectBusView: View {
    //@Binding var isNavigationBarHidden: Bool
    var busStop: BusStopInfo
    var busStopName: String
    var checkDest: CheckDest
    
    var body: some View {
        
        ZStack {
            Color(red: 213/255, green: 223/255, blue: 240/255).ignoresSafeArea()
            ZStack {
                VStack {
                    ZStack {
                        Text("선택하신 정류장은\n\(busStopName) 입니다.\n탑승할 버스를 선택하세요.")
                            .font(.title2)
                            .multilineTextAlignment(.center)
                            //.padding(.top, 35.0)
                        Spacer()
                    }
                    Spacer()
                }

                ZStack {
                    RoundedRectangle(cornerRadius: 35.0)
                        .padding(.top, 100.0)
                        .padding(.horizontal, 20.0)
                        .foregroundColor(.white)
                    Image("ComingBus")
                        .resizable()
                        .frame(width: 250, height: 250)
                        .padding(.bottom, 210.0)
                    ZStack {
                        ScrollView(.vertical, showsIndicators: false, content: {
                            LazyVGrid(columns:[GridItem(.adaptive(minimum: 100))]) {
                                ForEach(busStop.returnBusNum(of: busStopName), id:\.self, content: { item in
                                    NavigationLink(destination: GoalView(checkDest: checkDest,busNum: item, busStopInfo: busStop)) {
                                        BusListItemView(busName: item)
                                            .aspectRatio(3/2, contentMode: .fit)
                                    }
                                })
                            }
                        })
                        .frame(width: 300, height: 310, alignment: .leading)
                        .padding(.top, 350.0)
                        .padding(.horizontal, 40.0)

                    }
                }
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        //.navigationBarHidden(true)
    }
}


//MARK: - Select Goal
struct GoalView: View {
    //@Binding var isNavigationBarHidden: Bool
    @ObservedObject private var notiManager = NotificationManager()
    var checkDest : CheckDest
    var busNum : String
    var busStopInfo : BusStopInfo
    var body: some View {
        ZStack {
            Color(red: 213/255, green: 223/255, blue: 240/255).ignoresSafeArea()
            ZStack {
                VStack {
                    Text("선택하신 버스는\n\(busNum) 입니다. \n 목적지를 선택하세요.")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        //.padding(.top, 18.0)
                    Spacer()
                }

                ZStack {
                    RoundedRectangle(cornerRadius: 35.0)
                        .padding(.top, 100.0)
                        .padding(.horizontal, 20.0)
                        .foregroundColor(.white)
                    HStack {
                        ScrollView(.vertical, showsIndicators: false, content: {
                            VStack (alignment: .leading) {
                                ForEach(checkDest.FindDest(of: busNum)!, id:\.self, content: { item in
                                    NavigationLink(destination: GoingView()) {
                                        BusGoalItemView(busGoalName: item)
                                    }
                                    .simultaneousGesture(TapGesture().onEnded{
                                        notiManager.requestNotificationAuthorization()
                                        notiManager.sendNotification(busStopInfo: busStopInfo, place: item)
                                    })
                                })
                            }
                        })
                        .frame(width: 300, height: 530, alignment: .leading)
                        .padding(.top, 100.0)
                    }
                }
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        //.navigationBarHidden(true)
    }
}

struct GoingView: View {
    var body: some View {
        ZStack {
            Color(red: 213/255, green: 223/255, blue: 240/255).ignoresSafeArea()
            ZStack {
                VStack {
                    Text("버스로 이동 중")
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .padding(.top, 50.0)
                    Spacer()
                }
                
                VStack {
                    ZStack {
                        Circle()
                            .foregroundColor(.white)
                            .frame(width: 300, height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        Image("arriveBus")
                    }
                    Text("목적지 전 정류장에 도착하면\n알려드릴게요!\n앱을 종료하지 마세요.")
                        .multilineTextAlignment(.center)
                        .frame(alignment: .center)
                        .font(.title2)
                        .padding(.top, 30.0)
                }
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        //.navigationBarHidden(true)
    }
}

//MARK: - ETC

extension ContentView {
    var launchScreenView: some View {
        ZStack (alignment: .center) {
            Color(.white).edgesIgnoringSafeArea(.all)

            Image("LaunchIcon")
        }
    }
}

struct openingView: View {
    var body: some View {
        ZStack (alignment: .center) {
            Color(.white).edgesIgnoringSafeArea(.all)
            Image("LaunchIcon")
        }
    }
}

struct BusStopListItemView: View {
    var busStopName: String
    var selected: Bool = false
    
    var body: some View {
        HStack {
            Image("BusStop")
                .resizable()
                .frame(width: 50, height: 50)
            Text(busStopName)
                .font(.system(size: 30))
        }
    }
}

struct BusListItemView: View {
    var busName: String
    let shape = RoundedRectangle(cornerRadius: 20)
    var body: some View {
        ZStack {
            shape.fill().foregroundColor(.white)
            shape.strokeBorder(lineWidth: 3).foregroundColor(Color(red: 213/255, green: 223/255, blue: 240/255))
            Text(busName)
                .font(.title)
        }
    }
}


struct BusGoalItemView: View {
    var busGoalName: String
    var shape = Rectangle()
    var body: some View {
        HStack {
            shape
                .foregroundColor(Color(red: 213/255, green: 223/255, blue: 240/255))
                .frame(width:20, height: 50)
            Text(busGoalName)
                .font(.system(size: 30))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
//            var busStop = BusStopInfo(filePath: "/Users/hwistarrrrr/Desktop/11.txt")
//            var busStopList: [String]? = busStop.FindBusStop(200)
//            var checkDest = CheckDest()
//            ContentView(busStop: busStop, busStopList: busStopList, checkDest: checkDest)
            openingView()
        }
    }
}
