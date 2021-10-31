//
//  ScareMeParty.swift
//  ScareMeParty
//
//  Created by National Team on 31.10.2021.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(), configuration: ConfigurationIntent(), hours: "4 hours")
  }
  
  func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
    let entry = SimpleEntry(date: Date(), configuration: configuration, hours: "4 hours")
    completion(entry)
  }
  
  func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    var entries: [SimpleEntry] = []
    
    let date: Date?
    // Generate a timeline consisting of five entries an hour apart, starting from the current date.
    if let dateStr = UserDefaults(suiteName: "group.scareme")?.string(forKey: "partyDate") {
      let formatter = DateFormatter()
      formatter.dateFormat = "dd MMMM yyyy - HH:mm"
      date = formatter.date(from: dateStr)
    } else {
      date = nil
    }
    
    let currentDate = Date()
    
    var diff: TimeInterval?
    
    if let date = date {
      diff = -date.distance(to: currentDate)
    } else {
      diff = nil
    }
    
    if let diff = diff, diff > 0 {
      let hours = Int(diff / (60 * 60))
      for hourOffset in 0 ..< hours {
        let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
        let entry = SimpleEntry(date: entryDate, configuration: configuration, hours: "\(hours - hourOffset) hours")
        entries.append(entry)
      }
    } else {
      for hourOffset in 0 ..< 2 {
        let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
        let entry = SimpleEntry(date: entryDate, configuration: configuration, hours: nil)
        entries.append(entry)
      }
    }
    
   
    
    let timeline = Timeline(entries: entries, policy: .atEnd)
    completion(timeline)
  }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
  let configuration: ConfigurationIntent
  let hours: String?
}

struct ScareMePartyEntryView : View {
  var entry: Provider.Entry
  
  var body: some View {
    ZStack(alignment: .top) {
      HStack {
        Spacer()
        VStack {
          Spacer()
        }
      }
      if entry.hours == nil {
        VStack(spacing: 4) {
          Image("pump").aspectRatio(1, contentMode: .fit).frame(width: 100, height: 100).padding(.top, 16)
          Text("No Party No Gain").foregroundColor(.white).opacity(0.7).font(Font(CTFont("BalooPaaji2-Bold" as CFString, size: 12)))
          
        }
      } else {
        Image("pump-party").aspectRatio(1, contentMode: .fit).frame(width: 107, height: 107)
        VStack(alignment: .leading, spacing: 0) {
          Spacer()
          HStack {
          Text("Before the Party").foregroundColor(.white).opacity(0.7).font(Font(CTFont("BalooPaaji2-Bold" as CFString, size: 12)))
            Spacer()
          }
          HStack {
            Text(entry.hours ?? "").foregroundColor(.white).font(Font(CTFont("BalooPaaji2-Bold" as CFString, size: 24)))
            Spacer()
          }.padding(.bottom, 10)
          
        }.padding(.horizontal, 16)
      }
    }.background(LinearGradient(colors: [Color(UIColor(red: 0.075, green: 0.035, blue: 0.071, alpha: 1)), Color(UIColor(red: 0.243, green: 0.11, blue: 0.2, alpha: 1))], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 0, y: 1)))
  }
}

@main
struct ScareMeParty: Widget {
  let kind: String = "ScareMeParty"
  
  var body: some WidgetConfiguration {
    IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
      ScareMePartyEntryView(entry: entry)
    }
    .configurationDisplayName("ScareMe")
    .description("Before the party")
    .supportedFamilies([.systemSmall])
  }
}

struct ScareMeParty_Previews: PreviewProvider {
  static var previews: some View {
    ScareMePartyEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), hours: "4 hours"))
      .previewContext(WidgetPreviewContext(family: .systemSmall))
  }
}
