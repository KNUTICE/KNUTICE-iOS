//
//  ReadingRoomWidgetProvider.swift
//  KNUTICEWidget
//
//  Created by 이정훈 on 4/2/26.
//

import Factory
import KNReadingRoom
import WidgetKit

struct ReadingRoomProvider: AppIntentTimelineProvider {
    private let fetchReadingRoomStatusUseCase = Container.shared.fetchReadingRoomStatusUseCase()
    
    // 위젯 갤러리에서 보여줄 미리보기 데이터
    func placeholder(in context: Context) -> ReadingRoomEntry {
        ReadingRoomEntry(date: Date(), roomStatuses: [])
    }

    // 위젯 추가 시 또는 특정 상황에서 일시적으로 보여줄 스냅샷
    func snapshot(for configuration: ReadingRoomWidgetIntent, in context: Context) async -> ReadingRoomEntry {
        ReadingRoomEntry(date: Date(), roomStatuses: [])
    }

    // 실제 위젯의 타임라인(데이터 업데이트 스케줄)을 생성
    func timeline(for configuration: ReadingRoomWidgetIntent, in context: Context) async -> Timeline<ReadingRoomEntry> {
        var entries: [ReadingRoomEntry] = []
        let currentDate = Date()
        let readingRoomStatuses = try? await fetchReadingRoomStatusUseCase.execute()
        let entry = ReadingRoomEntry(date: Date(), roomStatuses: readingRoomStatuses ?? [])
        entries.append(entry)
        
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 30, to: currentDate)!
        
        return Timeline(entries: entries, policy: .after(nextUpdate))
    }
}

struct ReadingRoomEntry: TimelineEntry {
    // 위젯이 렌더링될 시간
    let date: Date
    // 실제 표시할 데이터 리스트
    let roomStatuses: [ReadingRoomStatus]
}
