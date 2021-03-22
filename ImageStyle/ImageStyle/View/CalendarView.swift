//
//  CalendarView.swift
//  ImageStyle
//
//  Created by Lai Wei on 2021-03-10.
//

import SwiftUI

struct CalendarRootView: View {
    @Environment(\.calendar) var calendar
    
    @ObservedObject var image  = ImageManager.shared
    @ObservedObject var mood = MoodManager.shared
    @ObservedObject var model = ModelManager.shared
    var inputImage: Image
    let dateFormat = DateFormatter.dateAndMonthAndYear
    @State var isWithImage = false
    @State var isTapped = false
    private var year: DateInterval {
        calendar.dateInterval(of: .year, for: mood.pubDate)!
    }
    
    var body: some View {
        let inputDateString = dateFormat.string(from: mood.pubDate)
        
        return GeometryReader{ geo in
            
            CalendarView(inputDate: mood.pubDate, interval: year) { date in
                Button(action: {
                    isTapped = true
                    mood.pubDate = date
                    if inputDateString  == dateFormat.string(from: date) {
                        isWithImage = true
                    }else {
                        isWithImage = false
                        image.pubContentImage = nil
                    }
                })
                    {
                    Text(String(self.calendar.component(.day, from: date))).foregroundColor(inputDateString  == dateFormat.string(from: date) ? .white : .black)
                }
                    .frame(width: (geo.size.width - 20)/7, height: (geo.size.width - 20)/7, alignment: .center)
                    .background(inputDateString  == dateFormat.string(from: date) ? inputImage.resizable().aspectRatio(contentMode: .fill) : nil).clipped()

                if isWithImage {
                    NavigationLink(destination: MoodView(pickedImage: inputImage) , isActive: $isTapped){EmptyView()}
                } else {
                    NavigationLink(destination:ImageTransferStyleView(), isActive: $isTapped){EmptyView()}
                }
                
            }.navigationBarHidden(true)
            
            
        }.padding(.horizontal, 10)
        .background(LinearGradient.primaryBackgroundColor)
    }
}

struct CalendarView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar
    
    let inputDate: Date
    let interval: DateInterval
    let content: (Date) -> DateView
    
    init(
        inputDate: Date,
        interval: DateInterval,
        @ViewBuilder content: @escaping (Date) -> DateView
        
    ) {
        self.interval = interval
        self.content = content
        self.inputDate = inputDate
    }
    
    private var months: [Date] {
        calendar.generateDates(
            inside: interval,
            matching: DateComponents(day: 1, hour: 0, minute: 0, second: 0)
        )
    }
    
    
    var body: some View {
        let inputMonth = calendar.dateComponents([.month], from: inputDate).month
        
        ScrollView(.vertical, showsIndicators: false) {
            ScrollViewReader { value in
                VStack {
                    ForEach(months, id: \.self) { month in
                        
                        MonthView(month: month, content: self.content).frame(height: UIScreen.main.bounds.size.height)
                        
                    }
                    
                }.onAppear{
                    for month in months where calendar.dateComponents([.month], from: month).month == inputMonth {
                        value.scrollTo(month, anchor: .top)
                    }
                }
            }
        }
    }
}

struct MonthView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar
    @ObservedObject var mood = MoodManager.shared
    @ObservedObject var image  = ImageManager.shared
    let month: Date
    let content: (Date) -> DateView
    let monthFormat = DateFormatter.month
    init(
        month: Date,
        @ViewBuilder content: @escaping (Date) -> DateView
    ) {
        self.month = month
        self.content = content
    }
    
    private var weeks: [Date] {
        guard
            let monthInterval = calendar.dateInterval(of: .month, for: month)
        else { return [] }
        return calendar.generateDates(
            inside: monthInterval,
            matching: DateComponents(hour: 0, minute: 0, second: 0, weekday: 1)
        )
    }
    @ObservedObject var imageManager  = ImageManager.shared
    @State var hidingshareButton = false
    
    var body: some View {
        
        VStack {
            Spacer().frame(height:20)
            ZStack{
                Spacer()
                Text(monthFormat.string(from: month)).font(.titleFont)
                HStack{
                    Spacer()
                    Button(action: {
                       
                        DispatchQueue.main.async {
                            // hide the share button first
                            imageManager.hidingShareButton = true
                            
                            // do the screenshot of the page
                            let snapImage = body.snapshot()
                            imageManager.snapImage = snapImage
                            
                            
                        }
                        
//                        shareAction()
                    }){
                        Image(systemName: "square.and.arrow.up")
                    }.padding(.trailing, 10).foregroundColor(imageManager.hidingShareButton ? .clear : .black)
                    
                }}
            Spacer().frame(height:20)
            ForEach(weeks, id: \.self) { week in
                WeekView(week: week, content: self.content).background(Color.white.opacity(0.5))
                Spacer().frame(height:10)
            }
            Spacer()
        } .sheet(isPresented: $imageManager.pubSnapImageReady, onDismiss: imageManager.didDismiss){
            ShareImageView(sharedImage: imageManager.snapImage)
        }
        
       
        
        
    }
   
    
    func shareAction() {
        /// THIS SHOULD BE THE APP LINK IN STORE
        let url = URL(string: "http://apple.com")
        let av = UIActivityViewController(activityItems: [url!], applicationActivities: nil)
        
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
}

struct ShareImageView: View {
    var sharedImage: UIImage?
    var body: some View{
        VStack{
            if sharedImage != nil {
                Image(uiImage: sharedImage!).resizable().aspectRatio(contentMode: .fit)
                   .padding()
            
            Button(action: {
            let imageSaver = ImageSaver()
                imageSaver.writeToPhotoAlbum(image: sharedImage!)
            }){
                Text("Save").font(.primaryFont)
            }.frame(width: 150, height: 50).foregroundColor(.black)
            }else {
                Text("Sorry, the view is not ready yet. Please try again later.")
            }
        }
    }
}

struct WeekView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar
    
    let week: Date
    let content: (Date) -> DateView
    
    init(
        week: Date,
        @ViewBuilder content: @escaping (Date) -> DateView
    ) {
        self.week = week
        self.content = content
    }
    
    private var days: [Date] {
        guard
            let weekInterval = calendar.dateInterval(of: .weekOfYear, for: week)
        else { return [] }
        return calendar.generateDates(
            inside: weekInterval,
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        )
    }
    
    var body: some View {
        
        HStack (spacing:0){
            ForEach(days, id: \.self) { date in
                HStack(spacing:0) {
                    if self.calendar.isDate(self.week, equalTo: date, toGranularity: .month) {
                        self.content(date).font(.secondaryFont)
                    } else {
                        self.content(date).hidden()
                    }
                }
            }
        }
        
    }
}

//struct CalendarView_Previews: PreviewProvider {
//    static var previews: some View {
//        CalendarView<DateView()>()
//    }
//}
