//
//  MajorCategory.swift
//  KNUTICECore
//
//  Created by 이정훈 on 9/9/25.
//

import Foundation

public enum MajorCategory: String, CategoryProtocol {
    
    // ---------- 융합기술대학 ----------
    case mechanicalEngineering = "MECHANICAL_ENGINEERING"
    case automotiveEngineering = "AUTOMOTIVE_ENGINEERING"
    case aeronauticalAndMechanicalDesignEngineering = "AERONAUTICAL_AND_MECHANICAL_DESIGN_ENGINEERING"
    case electricalEngineering = "ELECTRICAL_ENGINEERING"
    case electronicEngineering = "ELECTRONIC_ENGINEERING"
    case computerEngineering = "COMPUTER_ENGINEERING"
    case computerScience = "COMPUTER_SCIENCE"
    case aiRoboticsEngineering = "AI_ROBOTICS_ENGINEERING"
    case biomedicalEngineering = "BIOMEDICAL_ENGINEERING"
    case precisionMedicineMedicalDevice = "PRECISION_MEDICINE_MEDICAL_DEVICE"
    
    // ---------- 공과대학 ----------
    case civilEngineering = "CIVIL_ENGINEERING"
    case environmentalEngineering = "ENVIRONMENTAL_ENGINEERING"
    case urbanAndTransportationEngineering = "URBAN_AND_TRANSPORTATION_ENGINEERING"
    case chemicalAndBiologicalEngineering = "CHEMICAL_AND_BIOLOGICAL_ENGINEERING"
    case materialsScienceAndEngineering = "MATERIALS_SCIENCE_AND_ENGINEERING"
    case polymerScienceAndEngineering = "POLYMER_SCIENCE_AND_ENGINEERING"
    case industrialAndManagementEngineering = "INDUSTRIAL_AND_MANAGEMENT_ENGINEERING"
    case safetyEngineering = "SAFETY_ENGINEERING"
    case architecturalEngineering = "ARCHITECTURAL_ENGINEERING"
    case architecture = "ARCHITECTURE"
    case industrialDesign = "INDUSTRIAL_DESIGN"
    case communicationDesign = "COMMUNICATION_DESIGN"
    
    // ---------- 인문대학 ----------
    case englishLanguageAndLiterature = "ENGLISH_LANGUAGE_AND_LITERATURE"
    case chineseLanguage = "CHINESE_LANGUAGE"
    case koreanLanguageAndLiterature = "KOREAN_LANGUAGE_AND_LITERATURE"
    case music = "MUSIC"
    case sportsMedicine = "SPORTS_MEDICINE"
    case sportsIndustry = "SPORTS_INDUSTRY"
    
    // ---------- 사회과학대학 ----------
    case publicAdministration = "PUBLIC_ADMINISTRATION"
    case publicAdministrationAndInformationConvergence = "PUBLIC_ADMINISTRATION_AND_INFORMATION_CONVERGENCE"
    case businessAdministration = "BUSINESS_ADMINISTRATION"
    case convergenceManagement = "CONVERGENCE_MANAGEMENT"
    case internationalTradeAndBusiness = "INTERNATIONAL_TRADE_AND_BUSINESS"
    case socialWelfare = "SOCIAL_WELFARE"
    case airlineService = "AIRLINE_SERVICE"
    case aeronauticalScienceAndFlightOperation = "AERONAUTICAL_SCIENCE_AND_FLIGHT_OPERATION"
    case earlyChildhoodEducation = "EARLY_CHILDHOOD_EDUCATION"
    case mediaAndContents = "MEDIA_AND_CONTENTS"
    
    // ---------- 보건생명대학 ----------
    case nursing = "NURSING"
    case physicalTherapy = "PHYSICAL_THERAPY"
    case paramedicine = "PARAMEDICINE"
    case foodScienceAndTechnology = "FOOD_SCIENCE_AND_TECHNOLOGY"
    case foodAndNutrition = "FOOD_AND_NUTRITION"
    case biotechnology = "BIOTECHNOLOGY"
    case earlyChildhoodSpecialEducation = "EARLY_CHILDHOOD_SPECIAL_EDUCATION"
    
    // ---------- 철도대학 ----------
    case railroadManagementAndLogistics = "RAILROAD_MANAGEMENT_AND_LOGISTICS"
    case dataScience = "DATA_SCIENCE"
    case artificialIntelligence = "ARTIFICIAL_INTELLIGENCE"
    case railroadOperationSystemsEngineering = "RAILROAD_OPERATION_SYSTEMS_ENGINEERING"
    case railwayVehicleSystemEngineering = "RAILWAY_VEHICLE_SYSTEM_ENGINEERING"
    case railroadInfrastructureEngineering = "RAILROAD_INFRASTRUCTURE_ENGINEERING"
    case railroadElectricalAndInformationEngineering = "RAILROAD_ELECTRICAL_AND_INFORMATION_ENGINEERING"
    
    // MARK: - Localized Description
    public var localizedDescription: String {
        switch self {
        // 융합기술대학
        case .mechanicalEngineering: return "기계공학과"
        case .automotiveEngineering: return "자동차공학과"
        case .aeronauticalAndMechanicalDesignEngineering: return "항공·기계설계학과"
        case .electricalEngineering: return "전기공학과"
        case .electronicEngineering: return "전자공학과"
        case .computerEngineering: return "컴퓨터공학과"
        case .computerScience: return "컴퓨터소프트웨어학과"
        case .aiRoboticsEngineering: return "AI로봇공학과"
        case .biomedicalEngineering: return "바이오메디컬융합학과"
        case .precisionMedicineMedicalDevice: return "정밀의료·의료기기학과"
            
        // 공과대학
        case .civilEngineering: return "사회기반공학전공"
        case .environmentalEngineering: return "환경공학전공"
        case .urbanAndTransportationEngineering: return "도시·교통공학전공"
        case .chemicalAndBiologicalEngineering: return "화공생물공학과"
        case .materialsScienceAndEngineering: return "반도체신소재공학과"
        case .polymerScienceAndEngineering: return "나노화학소재공학과"
        case .industrialAndManagementEngineering: return "산업경영공학과"
        case .safetyEngineering: return "안전공학과"
        case .architecturalEngineering: return "건축공학과"
        case .architecture: return "건축학과(5년제)"
        case .industrialDesign: return "산업디자인학과"
        case .communicationDesign: return "커뮤니케이션디자인학과"
            
        // 인문대학
        case .englishLanguageAndLiterature: return "영어영문학과"
        case .chineseLanguage: return "중국어학과"
        case .koreanLanguageAndLiterature: return "한국어문학과"
        case .music: return "음악학과"
        case .sportsMedicine: return "스포츠의학과"
        case .sportsIndustry: return "스포츠산업학과"
            
        // 사회과학대학
        case .publicAdministration: return "행정학과"
        case .publicAdministrationAndInformationConvergence: return "행정정보융합학과"
        case .businessAdministration: return "경영학과"
        case .convergenceManagement: return "융합경영학과"
        case .internationalTradeAndBusiness: return "국제무역학과"
        case .socialWelfare: return "사회복지학과"
        case .airlineService: return "항공서비스학과"
        case .aeronauticalScienceAndFlightOperation: return "항공운항학과"
        case .earlyChildhoodEducation: return "유아교육학과"
        case .mediaAndContents: return "미디어&콘텐츠학과"
            
        // 보건생명대학
        case .nursing: return "간호학과"
        case .physicalTherapy: return "물리치료학과"
        case .paramedicine: return "응급구조학과"
        case .foodScienceAndTechnology: return "식품공학전공"
        case .foodAndNutrition: return "식품영양학전공"
        case .biotechnology: return "생명공학전공"
        case .earlyChildhoodSpecialEducation: return "유아특수교육학과"
            
        // 철도대학
        case .railroadManagementAndLogistics: return "철도경영·물류학과"
        case .dataScience: return "데이터사이언스전공"
        case .artificialIntelligence: return "인공지능전공"
        case .railroadOperationSystemsEngineering: return "철도운전시스템공학과"
        case .railwayVehicleSystemEngineering: return "철도차량시스템공학과"
        case .railroadInfrastructureEngineering: return "철도인프라공학과"
        case .railroadElectricalAndInformationEngineering: return "철도전기정보공학과"
        }
    }
}
