//
//  ContentView.swift
//  HowLong
//
//  Created by 陳昱豪 on 2019/12/30.
//  Copyright © 2019 Chen_Yu_Hao. All rights reserved.
//

import SwiftUI
struct Countdown:Identifiable,Codable{
    var id=UUID()
    var dietime:Date
}
class diedata: ObservableObject {
    @Published var dietime = [Countdown]()
{
    didSet{
        let encoder=JSONEncoder()
        if let data=try?encoder.encode(dietime){
            UserDefaults.standard.set(data, forKey: "dietime")
        }
        print("\(dietime[0].dietime)")
    }
    }
    init(){
        if let data = UserDefaults.standard.data(forKey: "dietime"){
            let decorder = JSONDecoder()
            if let decodedData = try? decorder.decode([Countdown].self, from: data){
                dietime = decodedData
            }
        }
    }
    
}
struct ContentView: View {
    @ObservedObject private var die=diedata()
    let nowDate=Date()
    @State private var lifetime=DateComponents()
    @State private var stop=true

    var timer:Timer{
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true){_ in
            self.lifetime.second! -= 1
            if self.lifetime.second! == -1
            {
                self.lifetime.second!=59
                self.lifetime.minute! -= 1
            }
            if self.lifetime.minute! == -1
            {
                self.lifetime.minute!=59
                self.lifetime.hour! -= 1
            }
            if self.lifetime.hour! == -1
            {
                self.lifetime.hour!=23
                self.lifetime.day! -= 1
            }
        }
    }
        func countDownString(nowDate: DateComponents) -> String {
        return String(format: "%02d:%02d:%02d",
                      nowDate.hour ?? 00,
                      nowDate.minute ?? 00,
                      nowDate.second ?? 00)
    }

    var body: some View {
        ZStack {
            Color.black
            if stop{
            VStack{
                HStack(alignment: .bottom,spacing: 0){
                    if lifetime.year != nil{
                        if lifetime.year! == 0{
                            Text("00").font(Font.system(size: 100)).bold().foregroundColor(.red).fixedSize()
                        }
                        else{
                            if lifetime.year!<10{Text("0").font(Font.system(size: 100)).bold().foregroundColor(.white).fixedSize()
                                                       }
                                                      
                            Text("\(lifetime.year!)").font(Font.system(size: 100)).bold().foregroundColor(.white).fixedSize()

                        }
                    }
                    Text("YRS").foregroundColor(.white).fixedSize()
                }
                HStack(alignment: .bottom,spacing: 0){
                    if lifetime.day != nil{
                        if lifetime.day! == 0 && lifetime.year! == 0{
                            Text("00").font(Font.system(size: 100)).bold().foregroundColor(.red).fixedSize()
                        }
                        else{
                            if lifetime.day!<10{Text("0").font(Font.system(size: 100)).bold().foregroundColor(.white).fixedSize()
                                                       }
                                                      
                            Text("\(lifetime.day!)").font(Font.system(size: 100)).bold().foregroundColor(.white).fixedSize()

                        }                }
                    Text("DAY").foregroundColor(.white).fixedSize()
                }
                HStack(alignment: .bottom,spacing: 0){
                    if lifetime.hour != nil{
                        if lifetime.day! == 0 && lifetime.year! == 0 && lifetime.hour==0{
                                               Text("00").font(Font.system(size: 100)).bold().foregroundColor(.red).fixedSize()
                                           }
                                           else{
                            if lifetime.hour!<10{Text("0").font(Font.system(size: 100)).bold().foregroundColor(.white).fixedSize()
                            }
                            Text("\(lifetime.hour!)").font(Font.system(size: 100)).bold().foregroundColor(.white).fixedSize()
                                

                                           }                 }
                    Text("HRS").foregroundColor(.white).fixedSize()
                }
                HStack(alignment: .bottom,spacing: 0){
                    if lifetime.minute != nil{
                        if lifetime.day! == 0 && lifetime.year! == 0 && lifetime.hour==0 && lifetime.minute==0{
                            Text("00").font(Font.system(size: 100)).bold().foregroundColor(.red).fixedSize()
                        }
                        else{
                           if lifetime.minute!<10{Text("0").font(Font.system(size: 100)).foregroundColor(.white).bold().fixedSize()
                            }
                            Text("\(lifetime.minute!)").font(Font.system(size: 100)).foregroundColor(.white).bold().fixedSize()

                        }                    }
                    Text("MIN").foregroundColor(.white).fixedSize()
                }
                HStack(alignment: .bottom,spacing: 0){
                    if lifetime.second != nil{
                        if lifetime.day! == 0 && lifetime.year! == 0 && lifetime.hour==0 && lifetime.second==0 && lifetime.minute==0{
                            Text("00").font(Font.system(size: 100)).bold().foregroundColor(.red).fixedSize().onAppear{
                                self.stop=false

                            }
                        }
                        else{
                            if lifetime.second!<10{Text("0").font(Font.system(size: 100)).bold().foregroundColor(.white).fixedSize()
                                                       }
                                                      Text("\(lifetime.second!)").font(Font.system(size: 100)).bold().foregroundColor(.white).fixedSize()

                        }
                    }
                    Text("SEC").foregroundColor(.white).fixedSize()
                }
            }.onAppear(perform: {
                if self.die.dietime.count==0
                {
                    let date2=Date() + Double.random(in: 0..<1892160000)
                    self.die.dietime.append(.init(dietime: date2))
                    
                }
                self.lifetime=Calendar.current.dateComponents([.year,.day,.hour,.minute,.second], from: Date()
                    , to: self.die.dietime[0].dietime)
                _ = self.timer
                if self.die.dietime[0].dietime<Date(){
                    self.stop=false
                }
        })
        }
            else{
                Text("YOU DIE").font(Font.system(size: 100)).foregroundColor(.red)
            }
        }.edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
