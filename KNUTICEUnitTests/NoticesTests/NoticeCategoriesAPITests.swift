//
//  NoticeCategoriesAPITests.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 9/9/25.
//

import Alamofire
import Factory
import Foundation
import KNUTICECore
import Testing

@Test
func fetchAllNoticeTypes() async throws {
    // Configurate Session
    let configuration = URLSessionConfiguration.ephemeral
    configuration.protocolClasses = [MockURLProtocol.self]
    
    let session = Session(configuration: configuration)
    
    Container.shared.remoteDataSource.register {
        RemoteDataSourceImpl(session: session)
    }
    
    let dataSource = Container.shared.remoteDataSource()
    
    guard let baseURL = Bundle.main.noticeURL else {
        throw NetworkError.invalidURL(
            message: "Failed to load noticeURL from Bundle.main. Make sure the URL is properly defined in ServiceInfo.plist or the Bundle extension."
        )
    }
    
    // Enpoints
    let endpoints: [(url: URL, category: NoticeCategory, mockType: MockURLProtocol.MockDataType)] = [
        (
            URL(string: baseURL + "?noticeName=\(NoticeCategory.generalNotice.rawValue)")!,
            .generalNotice,
            .fetchGeneralNoticesShouldSucceed
        ),
        (
            URL(string: baseURL + "?noticeName=\(NoticeCategory.academicNotice.rawValue)")!,
            .academicNotice,
            .fetchAcademicNoticesShouldSucceed
        ),
        (
            URL(string: baseURL + "?noticeName=\(NoticeCategory.scholarshipNotice.rawValue)")!,
            .scholarshipNotice,
            .fetchScholarshipNoticesShouldSucceed
        ),
        (
            URL(string: baseURL + "?noticeName=\(NoticeCategory.eventNotice.rawValue)")!,
            .eventNotice,
            .fetchEventNoticesShouldSucceed
        ),
        (
            URL(string: baseURL + "?noticeName=\(NoticeCategory.employmentNotice.rawValue)")!,
            .employmentNotice,
            .fetchEmploymentNoticesShouldSucceed
        )
    ]
    
    // Set up mock data
    for endpoint in endpoints {
        MockURLProtocol.setUpMockData(endpoint.mockType, for: endpoint.url)
    }
    
    var dtos = [NoticeReponseDTO]()
    
    try await withThrowingTaskGroup { group in
        for endpoint in endpoints {
            group.addTask {
                try await dataSource.request(
                    endpoint.url.absoluteString,
                    method: .get,
                    decoding: NoticeReponseDTO.self
                )
            }
        }
        
        for try await dto in group {
            dtos.append(dto)
        }
    }
    
    for dto in dtos {
        #expect(dto.body?.count == 20)
    }
}
