//
//  CalendarView.swift
//  ImageStyle
//
//  Created by Lai Wei on 2021-03-10.
//

import SwiftUI

struct CalendarRootView: View {
    @Environment(\.calendar) var calendar
    
    
    
    var inputImage: Image
    var inputDate: Date
    let dateFormat = DateFormatter.dateAndMonthAndYear
    
    private var year: DateInterval {
        calendar.dateInterval(of: .year, for: inputDate)!
    }
    var body: some View {
        let inputDateString = dateFormat.string(from: inputDate)
        
        return GeometryReader{ geo in
            
            CalendarView(inputDate: inputDate, interval: year) { date in
                Text("30")
                    .hidden()
                    .frame(width: (geo.size.width - 20)/7, height: (geo.size.width - 20)/7, alignment: .center)
                    .background(inputDateString  == dateFormat.string(from: date) ? inputImage.resizable().aspectRatio(contentMode: .fill) : nil).clipped()
                    
                    
                    .overlay(
                        Text(String(self.calendar.component(.day, from: date))).foregroundColor(inputDateString  == dateFormat.string(from: date) ? .white : .black)
                    )
                
                
            }.navigationBarHidden(true)
            .padding(.horizontal, 10)
        }.background(LinearGradient.primaryBackgroundColor)
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
                       
                                MonthView(month: month, content: self.content)
                                
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
    
    var body: some View {
       
        VStack {
            Spacer().frame(height:20)
            Text(monthFormat.string(from: month)).font(.titleFont)
            Spacer().frame(height:20)
            ForEach(weeks, id: \.self) { week in
                WeekView(week: week, content: self.content).background(Color.white.opacity(0.5))
                Spacer().frame(height:10)
            }
            Spacer()
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
