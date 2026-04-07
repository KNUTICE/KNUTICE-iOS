//
//  ReadingRoomWidgetEntryView.swift
//  KNUTICEWidget
//
//  Created by 이정훈 on 4/1/26.
//

import KNDesignSystem
import KNReadingRoom
import KNUtility
import WidgetKit
import SwiftUI

struct ReadingRoomEntryView: View {
    let entry: ReadingRoomProvider.Entry
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text("열람실 현황")
                    .bold()
                
                Spacer()
                
                Text("마지막 업데이트: \(entry.date.time)")
                    .font(.caption)
                
                Button(intent: RefreshWidgetIntent()) {
                    Image(systemName: "arrow.trianglehead.2.clockwise")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .bold()
                }
                .buttonStyle(.plain)
            }
            
            HStack {
                ForEach(entry.roomStatuses, id: \.id) { status in
                    RoomStatusCard(status: status)
                }
            }
        }
    }
}

fileprivate struct RoomStatusCard: View {
    let status: ReadingRoomStatus
    
    var color: Color {
        switch status.congestionLevel {
        case .smooth:
            return Color(red: 0x15 / 255.0, green: 0x7A / 255.0, blue: 0x43 / 255.0) // #157A43
        case .normal:
            return Color(red: 0xF5 / 255.0, green: 0x9E / 255.0, blue: 0x0B / 255.0) // #F59E0B
        case .crowded:
            return Color(red: 0xEF / 255.0, green: 0x44 / 255.0, blue: 0x44 / 255.0) // #EF4444
        }
    }
    
    var body: some View {
        VStack {
            Text(status.name.split(separator: " ").first ?? "")
                .bold()
                .font(.caption)
            
            ZStack {
                Circle()
                    .trim(from: 0, to: 0.75)
                    .stroke(
                        Color(UIColor.systemGray5),
                        style: StrokeStyle(lineWidth: 6, lineCap: .round)
                    )
                    .rotationEffect(.degrees(135))
                
                Circle()
                    .trim(from: 0.0, to: 0.75 * status.occupancyRate)
                    .stroke(
                        color,
                        style: StrokeStyle(lineWidth: 6, lineCap: .round)
                    )
                    .rotationEffect(.degrees(135))
                
                Text(status.congestionLevel.title)
                    .bold()
                    .font(.caption)
                    .foregroundStyle(color)
            }
            
            Text("\(status.availableSeats)석")
                .bold()
                .font(.caption2)
        }
        .frame(maxWidth: .infinity)
        .padding(5)
        .background(KNDesignSystemAsset.mainCellBackground.swiftUIColor)
        .cornerRadius(20)
    }
}

// MARK: - Widget Configuration
struct ReadingRoomWidget: Widget {
    private let kind: String = "ReadingRoomWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ReadingRoomProvider()) { entry in
            ReadingRoomEntryView(entry: entry)
                .containerBackground(for: .widget) {
                    KNDesignSystemAsset.primaryBackground.swiftUIColor
                }
        }
        .supportedFamilies([.systemMedium])
        .configurationDisplayName("열람실 현황")
        .description("실시간 좌석 현황을 확인합니다.")
    }
}

// MARK: - Preview
#Preview(as: .systemMedium) {
    ReadingRoomWidget()
} timeline: {
    ReadingRoomEntry(date: Date(), roomStatuses: [
        ReadingRoomStatus(
            id: UUID().uuidString,
            roomType: .room1,
            name: "제1집중",
            totalSeats: 100,
            availableSeats: 50,
            occupiedSeats: 50
        ),
        ReadingRoomStatus(
            id: UUID().uuidString,
            roomType: .room2,
            name: "제2집중",
            totalSeats: 100,
            availableSeats: 30,
            occupiedSeats: 70
        ),
        ReadingRoomStatus(
            id: UUID().uuidString,
            roomType: .room3,
            name: "제3협업",
            totalSeats: 100,
            availableSeats: 60,
            occupiedSeats: 40
        )
    ])
}
