//
//  SetBirthdateView.swift
//  MyBirthday
//
//  Created by 横森暉 on 2021/10/18.
//

import SwiftUI

struct SetBirthdateView: View {
    @State private var pickerDate = Date()
    @Binding var birthDate: Date
    @Binding var isSaved: Bool
    var body: some View {
        VStack{
            //誕生日を設定
            DatePicker(selection: $pickerDate, displayedComponents: [.date], label: {Text("誕生日")})
                .environment(\.locale, Locale(identifier: "ja_jp"))
                .padding()
                .onAppear{
                    self.pickerDate = self.birthDate
                }
            Button(action: {
                self.save()}
            ) {
                Text("保存")
                    .font(.title)
                    .background(Capsule()
                                    .foregroundColor(.yellow)
                                    .frame(width: 120, height:35))
            }
        }
    }
    func save(){
        birthDate = pickerDate
        UserDefaults.standard.set(birthDate, forKey: "birthKey")
        isSaved = true
    }
}

struct SetBirthdateView_Previews: PreviewProvider {
    static var previews: some View {
        SetBirthdateView(birthDate: .constant(Date()), isSaved: .constant(true))
    }
}
