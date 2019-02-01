//
//  VariantProviding.swift
//  ABTestMaintenanceStrategy
//
//  Created by GINO WU on 2/1/19.
//  Copyright © 2019 sample. All rights reserved.
//

import Foundation

public protocol DynamicVariableProviding: class {
    static func load()

    var enableCloseAccountOption: Bool { get } // AB_TEST: Gino Wu | Reg squad | Exp 02/02/2019
    var iraVideoValuePropYoutubeId: String { get } // AB_TEST: Gino Wu | Growth squad | Exp 01/02/2030
    var custodianVideoValuePropYoutubeId: String { get }
    var investVideoValuePropYoutubeId: String { get }
    var securitiesLendingVariables: String { get } // AB_TEST: Gino Wu | Reg squad | Exp 10/10/2018
    var prefundVideoUrl: URL? { get }
    var postPurchaseValuePropType: String { get }
    var postPurchaseValuePropDeepLink: String { get }
    var foundersCardVideoUrl: URL? { get }
    var autoStashScheduleType: String { get }
}


