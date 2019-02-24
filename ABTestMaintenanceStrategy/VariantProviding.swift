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

    var isNewUserFlow: Bool { get }                             // AB_TEST: Gino Wu | Reg squad | Exp 02/02/2019
    var variantProductionVideoText: String { get }              // AB_TEST: Gino Wu | Growth squad | Exp 01/02/2030
    var variantUserVideoText: String { get }                    // AB_TEST: Gino Wu | Growth squad | Exp 01/02/2030
    var variantTermsAndConditions: String { get }               // AB_TEST: Gino Wu | Growth squad | Exp 01/02/2030
    var variantNavigationText: String { get }                   // AB_TEST: Gino Wu | Reg squad | Exp 10/10/2018
    var variantPlacholderVideoUrl: URL? { get }                 // AB_TEST: Gino Wu | Growth squad | Exp 01/02/2030
    var variantSuccessViewCopy: String { get }                  // AB_TEST: Gino Wu | Growth squad | Exp 01/02/2030
    var variantDeeplinkToTab: String { get }                    // AB_TEST: Gino Wu | Growth squad | Exp 01/02/2030
    var variantnavigationImageUrl: URL? { get }                 // AB_TEST: Gino Wu | Growth squad | Exp 01/02/2030
    var variantLoginTitleText: String { get }                   // AB_TEST: Gino Wu | Growth squad | Exp 01/02/2030
}


