//
//  HiveEnterpriseHiveEnterpriseInitializer.swift
//  hive-celebrity-ios
//
//  Created by Soaurabh Kakkar on 10/01/2018.
//  Copyright © 2018 Hive. All rights reserved.
//

import UIKit

class HiveEnterpriseModuleInitializer: NSObject {

    let hiveEnterpriseViewController: HiveEnterpriseViewController
    
    override init() {
        self.hiveEnterpriseViewController = HiveEnterpriseViewController(nibName: "HiveEnterpriseViewController", bundle: nil)
        HiveEnterpriseModuleConfigurator().configureModuleForViewInput(viewInput: hiveEnterpriseViewController)
    }

}
