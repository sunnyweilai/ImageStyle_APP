//
//  MoodView.swift
//  ImageStyle
//
//  Created by Lai Wei on 2021-03-06.
//

import SwiftUI

struct MoodView: View {
   
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var model = ModelManager.shared
    @State var moodText = ""
    @State var textIsChanged = false
    @State var moodIsReady = false
    @State var pickedImage: Data
    @ObservedObject var mood = MoodManager.shared
    let format = DateFormatter.dateAndMonth
    var body: some View {
        GeometryReader{ geo in
            ScrollView{
                VStack{
                    Spacer().frame(height: 20)
                    Image(uiImage: UIImage(data: pickedImage) ?? UIImage()).resizable().frame(width: geo.size.height / 4 ,height: geo.size.height / 4 , alignment: .center).clipShape(RoundedRectangle(cornerRadius: 10))
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
                NavigationLink(destination: CalendarRootView(inputImage: pickedImage), isActive: $moodIsReady){ EmptyView() }
            }.navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .principal){
                    Button(action: {
                        mood.pubChangingDate = true
                    }) {
                        Text(format.string(from: mood.pubDate)).font(.titleFont)
                    }.foregroundColor(.white)
                    
                }
            }
            .navigationBarItems(trailing: textIsChanged ? (Button(action: {
                textIsChanged = false
                resignFirstResponder()
            }){
                Image(systemName: "checkmark")
            }) : (Button(action: {
                
                addItem()
                
            }){
                Image(systemName: "chevron.right")
            }))
        }.background(LinearGradient.primaryBackgroundColor)
        .sheet(isPresented: $mood.pubChangingDate, onDismiss: mood.didDatePickerDismissed){
            DatePickerView()
        }
        
    }
    
    
    func resignFirstResponder() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private func addItem() {
      
            let newItem = CoreDataSaving(context: viewContext)
            print(mood.pubDate)
            newItem.daydate = mood.pubDate
            newItem.daydescription = moodText
            newItem.dayimage = pickedImage
            
            
            do {
                try viewContext.save()
               
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        
        moodIsReady = true
    }
    
}


struct DatePickerView: View {
    @ObservedObject var mood = MoodManager.shared
    var body: some View {
        DatePicker("Choose My Day", selection: $mood.pubDate, in: ...Date())
            .datePickerStyle(GraphicalDatePickerStyle())
            .frame(height: 400)
    }
}

struct MoodView_Previews: PreviewProvider {
    
    static var previews: some View {
        MoodView(pickedImage: Data())
    }
}
