//
//  OnboardingOnboardingViewController.swift
//  hive-celebrity-ios
//
//  Created by Soaurabh Kakkar on 19/12/2017.
//  Copyright © 2017 Hive. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController, OnboardingViewInput {

    var output: OnboardingViewOutput!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var getStartedButton: UIButton!
    @IBOutlet weak var termsOfServiceLabel: UILabel!
    @IBOutlet weak var privacyPolicyLabel: UILabel!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        OnboardingModuleConfigurator().configureModuleForViewInput(viewInput: self)
        output.viewIsReady()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    // MARK: OnboardingViewInput
    func setupInitialState() {
    }
    
    // MARK: IBActions
    @IBAction func getStartedTapped(_ sender: Any) {
        self.output.getStartedTapped()
    }
    
    @IBAction func termsOfServiceTapped(_ sender: Any) {
        self.output.termsAndConditionsTapped()
    }
    
    @IBAction func privacyPolicyTapped(_ sender: Any) {
        self.output.privacyPolicyTapped()
    }
}

extension OnboardingViewController: OnboardingRouterOutput {
    func push(viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func present(viewController: UIViewController, completion: (()->Void)? = nil) {
        self.navigationController?.present(viewController, animated: true, completion: completion)
    }
}
