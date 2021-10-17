//
//  ContentView.swift
//  MyBirthday
//
//  Created by 横森暉 on 2021/10/17.
//

import SwiftUI

struct ContentView: View {
    //誕生日の日付
    @State private var birthDate = Date()
    //誕生日が保存されているかどうか
    @State private var isSaved = false
    var body: some View {
        NavigationView{
            VStack{
                NavigationLink(destination: SetBirthdateView(birthDate: $birthDate, isSaved: $isSaved)){
                    if !isSaved{
                        Text("誕生日を設定")
                    } else {
                        Text("誕生日: \(jp_date(birthDate))")
                    }
                }
                .navigationBarTitle("誕生日リマインダー")
                
                if isSaved {
                    if calcDaysLeft() == 0 {
                        Text("ハッピーバースデー")
                            .foregroundColor(.orange)
                        Text("年齢\(self.calcAge())歳")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                    } else {
                        Text("誕生日まであと\(calcDaysLeft())日")
                        Text("年齢\(self.calcAge())歳")
                            .font(.largeTitle)
                }
            }
        }
            .font(.title)
    }
        .onAppear{
            //誕生日を読み込む
            if let birthDate = UserDefaults.standard.object(forKey: "birthKey"){
                self.birthDate = birthDate as! Date
                self.isSaved = true
            }
        }
}
    //年齢を返すメソッド
    func calcAge() -> Int {
        let cal = Calendar(identifier: .gregorian)
        let now = Date()
        return cal.dateComponents([.year], from: birthDate, to: now).year!
    }
    //誕生日までの残り日数を戻す
    func calcDaysLeft() -> Int{
        let cal = Calendar(identifier: .gregorian)
        let now = Date()
        var comp = cal.dateComponents([.year, .month, .day], from: now)
        //今日の０時０分のDateオブジェクトをtodayに代入
        let today = cal.date(from: comp)!
        //nextBirthDateを今年の誕生日に設定
        let thisYear = cal.component(.year, from: now)
        comp = cal.dateComponents([.year, .month, .day], from: self.birthDate)
        comp.year = thisYear
        var nextBirthDate = cal.date(from: comp)!
        //誕生日が過ぎていたらnextBirthDateを来年の誕生日に設定
        if nextBirthDate < today {
            comp = cal.dateComponents([.year, .month, .day,], from: nextBirthDate)
            comp.year! += 1
            nextBirthDate = cal.date(from: comp)!
        }
        //誕生日までの日数を計算する
        return cal.dateComponents([.day], from: today, to: nextBirthDate).day!
    }
    //日本語の日付を取得
    func jp_date(_ date: Date) -> String {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ja_JP")
        df.dateStyle = .full
        return df.string(from: date)
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
