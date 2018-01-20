//
//  HiveEnterpriseHiveEnterpriseRouter.swift
//  hive-celebrity-ios
//
//  Created by Soaurabh Kakkar on 10/01/2018.
//  Copyright © 2018 Hive. All rights reserved.
//

class HiveEnterpriseRouter: HiveEnterpriseRouterInput {
    weak var output: HiveEnterpriseRouterOutput!
    
    func takeToPreviousScreen() {
        self.output.popViewController(animated: true)
    }
}
