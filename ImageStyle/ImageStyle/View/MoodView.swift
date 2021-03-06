//
//  MoodView.swift
//  ImageStyle
//
//  Created by Lai Wei on 2021-03-06.
//

import SwiftUI

struct MoodView: View {
    @ObservedObject var model = ModelManager.shared
    @State var moodText = ""
    let date = Date()
    var body: some View {
        GeometryReader{ geo in
            
            ScrollView{
                VStack{
                    Image("PeachBlushStyleTemplate").resizable().frame(width: geo.size.height / 4 ,height: geo.size.height / 4 , alignment: .center).clipShape(RoundedRectangle(cornerRadius: 10))
                    Text("\(dateTransform(date: date))")
                    ZStack(alignment: .top){
                        HStack{
                            TextEditor(text: $moodText)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                                .keyboardType(.asciiCapable)
                                .lineSpacing(5)
                                
                            
                        }.frame(minHeight: 150)
                        HStack{
                            Text("Start from here...").foregroundColor(Color.gray).opacity(moodText.count > 0 ? 0 : 100)
                            Spacer()
                        }.frame(height: 40).padding([.leading,.top],5)
                    }
                }.padding([.horizontal, .bottom])
            }
        }
    }
    
    func dateTransform(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let dateString = formatter.string(from: date)
        return dateString
    }
}

struct MoodView_Previews: PreviewProvider {
    static var previews: some View {
        MoodView()
    }
}
