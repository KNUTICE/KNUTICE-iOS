//
//  College.swift
//  KNUTICECore
//
//  Created by 이정훈 on 9/26/25.
//

import Foundation

public enum College: CaseIterable {
    case fusionTechnology
    case engineering
    case humanities
    case socialSciences
    case healthAndLife
    case railroad
    
    public var localizedDescription: String {
        switch self {
        case .fusionTechnology: return "융합기술대학"
        case .engineering: return "공과대학"
        case .humanities: return "인문대학"
        case .socialSciences: return "사회과학대학"
        case .healthAndLife: return "보건생명대학"
        case .railroad: return "철도대학"
        }
    }
    
    public var majors: [MajorCategory] {
        switch self {
        case .fusionTechnology:
            return [
                .mechanicalEngineering,
                .automotiveEngineering,
                .aeronauticalAndMechanicalDesignEngineering,
                .electricalEngineering,
                .electronicEngineering,
                .computerEngineering,
                .computerScience,
                .aiRoboticsEngineering,
                .biomedicalEngineering,
                .precisionMedicineMedicalDevice
            ]
        case .engineering:
            return [
                .civilEngineering,
                .environmentalEngineering,
                .urbanAndTransportationEngineering,
                .chemicalAndBiologicalEngineering,
                .materialsScienceAndEngineering,
                .polymerScienceAndEngineering,
                .industrialAndManagementEngineering,
                .safetyEngineering,
                .architecturalEngineering,
                .architecture,
                .industrialDesign,
                .communicationDesign
            ]
        case .humanities:
            return [
                .englishLanguageAndLiterature,
                .chineseLanguage,
                .koreanLanguageAndLiterature,
                .music,
                .sportsMedicine,
                .sportsIndustry
            ]
        case .socialSciences:
            return [
                .publicAdministration,
                .publicAdministrationAndInformationConvergence,
                .businessAdministration,
                .convergenceManagement,
                .internationalTradeAndBusiness,
                .socialWelfare,
                .airlineService,
                .aeronauticalScienceAndFlightOperation,
                .earlyChildhoodEducation,
                .mediaAndContents
            ]
        case .healthAndLife:
            return [
                .nursing,
                .physicalTherapy,
                .paramedicine,
                .foodScienceAndTechnology,
                .foodAndNutrition,
                .biotechnology,
                .earlyChildhoodSpecialEducation
            ]
        case .railroad:
            return [
                .railroadManagementAndLogistics,
                .dataScience,
                .artificialIntelligence,
                .railroadOperationSystemsEngineering,
                .railwayVehicleSystemEngineering,
                .railroadInfrastructureEngineering,
                .railroadElectricalAndInformationEngineering
            ]
        }
    }
}
