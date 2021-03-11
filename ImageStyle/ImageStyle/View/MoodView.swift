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
    @State var textIsChanged = false
    @State var moodIsReady = false
    var pickedImage: Image
    let date = Date()
    let format = DateFormatter.dateAndMonth
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
                                .onChange(of: moodText, perform: {_ in
                                    textIsChanged = true
                                })
                                .font(.primaryFont)
                                .keyboardType(.asciiCapable)
                                .lineSpacing(5)
                                .opacity(0.5)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                
                               
                                
                            
                        }.frame(minHeight: 200)
                        HStack{
                            Text("Wanna say...").font(.hintFont).foregroundColor(Color.gray).opacity(moodText.count > 0 ? 0 : 100).padding(.leading,13)
                            Spacer()
                        }.frame(height: 40)
                    }
                }.padding([.horizontal, .bottom])
                NavigationLink(destination: CalendarRootView(inputImage: pickedImage, inputDate: date), isActive: $moodIsReady){ EmptyView() }
            }.navigationBarTitle(Text(format.string(from: date)),displayMode: .inline)
            .navigationBarItems(trailing: textIsChanged ? (Button(action: {
                textIsChanged = false
                resignFirstResponder()
            }){
                Image(systemName: "checkmark")
                }) : (Button(action: {
                    moodIsReady = true
                }){
                    Image(systemName: "chevron.right")
                }))
        }.background(LinearGradient.primaryBackgroundColor)
    }

    
    func resignFirstResponder() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct MoodView_Previews: PreviewProvider {
    static var previews: some View {
        MoodView(pickedImage: Image(""))
    }
}
