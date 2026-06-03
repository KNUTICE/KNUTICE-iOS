//
//  ReadingRoomWidgetProvider.swift
//  KNUTICEWidget
//
//  Created by 이정훈 on 4/2/26.
//

import Factory
import KNDomain
import WidgetKit

struct ReadingRoomProvider: TimelineProvider {
    private let fetchReadingRoomStatusUseCase = Container.shared.fetchReadingRoomStatusUseCase()
    
    // 젯이 데이터를 불러오기 전에 잠깐 보여주는 임시 데이터
    func placeholder(in context: Context) -> ReadingRoomEntry {
        ReadingRoomEntry(date: Date(), isSkeleton: true, roomStatuses: ReadingRoomStatus.placeholders)
    }
    
    // 위젯 갤러리에서 보여줄 스냅샷
    func getSnapshot(in context: Context, completion: @escaping @Sendable (ReadingRoomEntry) -> Void) {
        Task {
            let currentDate = Date()
            let readingRoomStatuses = try? await fetchReadingRoomStatusUseCase.execute()
            completion(ReadingRoomEntry(date: currentDate, isSkeleton: false, roomStatuses: readingRoomStatuses ?? []))
        }
    }
    
    // 실제 위젯의 타임라인(데이터 업데이트 스케줄)을 생성
    func getTimeline(in context: Context, completion: @escaping @Sendable (Timeline<ReadingRoomEntry>) -> Void) {
        Task {
            var entries: [ReadingRoomEntry] = []
            let currentDate = Date()
            let readingRoomStatuses = try? await fetchReadingRoomStatusUseCase.execute()
            let entry = ReadingRoomEntry(date: Date(), isSkeleton: false, roomStatuses: readingRoomStatuses ?? [])
            entries.append(entry)
            
            let nextUpdate = Calendar.current.date(byAdding: .minute, value: 30, to: currentDate)!
            
            completion(Timeline(entries: entries, policy: .after(nextUpdate)))
        }
    }
}

struct ReadingRoomEntry: TimelineEntry {
    // 위젯이 렌더링될 시간
    let date: Date
    // 스켈레톤 표시 여부
    let isSkeleton: Bool
    // 실제 표시할 데이터 리스트
    let roomStatuses: [ReadingRoomStatus]
}

extension ReadingRoomStatus {
    static var placeholders: [ReadingRoomStatus] {
        return [
            ReadingRoomStatus(
                id: "placeholder_1",
                roomType: .room1,
                name: "제1집중",
                totalSeats: 300,
                availableSeats: 300,
                occupiedSeats: 0
            ),
            ReadingRoomStatus(
                id: "placeholder_2",
                roomType: .room2,
                name: "제2집중",
                totalSeats: 126,
                availableSeats: 126,
                occupiedSeats: 0
            ),
            ReadingRoomStatus(
                id: "placeholder_3",
                roomType: .room3,
                name: "제3협업",
                totalSeats: 108,
                availableSeats: 108,
                occupiedSeats: 0
            )
        ]
    }
}
