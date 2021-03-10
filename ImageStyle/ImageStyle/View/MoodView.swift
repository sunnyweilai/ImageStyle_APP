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
    var pickedImage: Image
    let date = Date()
    var body: some View {
        GeometryReader{ geo in
            
            ScrollView{
                VStack{
                    Spacer().frame(height: 20)
                    pickedImage.resizable().frame(width: geo.size.height / 4 ,height: geo.size.height / 4 , alignment: .center).clipShape(RoundedRectangle(cornerRadius: 10))
                    Spacer().frame(height: 20)
                    ZStack(alignment: .top){
                        HStack{
                            TextEditor(text: $moodText)
                                .keyboardType(.asciiCapable)
                                .lineSpacing(5)
                                .opacity(0.5)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                
                               
                                
                            
                        }.frame(minHeight: 150)
                        HStack{
                            Text("Start from here...").font(.hintFont).foregroundColor(Color.gray).opacity(moodText.count > 0 ? 0 : 100)
                            Spacer()
                        }.frame(height: 40).padding([.leading,.top],5)
                    }
                }.padding([.horizontal, .bottom])
            }.navigationBarTitle(Text("\(dateTransform(date: date))"),displayMode: .inline)
        }.background(LinearGradient.primaryBackgroundColor)
    }
    
    func dateTransform(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM,d"
        let dateString = formatter.string(from: date)
        return dateString
    }
}

struct MoodView_Previews: PreviewProvider {
    static var previews: some View {
        MoodView(pickedImage: Image(""))
    }
}
