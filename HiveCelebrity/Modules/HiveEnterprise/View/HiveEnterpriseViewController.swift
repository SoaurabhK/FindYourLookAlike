//
//  HiveEnterpriseHiveEnterpriseViewController.swift
//  hive-celebrity-ios
//
//  Created by Soaurabh Kakkar on 10/01/2018.
//  Copyright © 2018 Hive. All rights reserved.
//

import UIKit
import SafariServices

class HiveEnterpriseViewController: UIViewController {

    var output: HiveEnterpriseViewOutput!
    
    @IBOutlet weak var moreInfoTextView: UITextView!
    @IBOutlet weak var nameTextField: FloatingLabelTextField!
    @IBOutlet weak var emailTextField: FloatingLabelTextField!
    @IBOutlet weak var companyTextField: FloatingLabelTextField!
    @IBOutlet weak var phoneTextField: FloatingLabelTextField!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var buttonViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var loaderImageView: UIImageView!
    @IBOutlet weak var loaderView: UIView!
    
    private lazy var rotateAnimation: CABasicAnimation = {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(.pi * 2.0)
        rotateAnimation.duration = 1.0
        rotateAnimation.repeatCount = Float.greatestFiniteMagnitude
        return rotateAnimation
    }()
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    func configureMoreInfoLabel() {
        let infoString = "For More Information visit: "
        let infoMutableAttributedString = NSMutableAttributedString(string: infoString,
                                                      attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14, weight: .regular), NSAttributedStringKey.foregroundColor: Color.primaryDark])
        let websiteString = "www.thehive.ai"
        let websiteAttributedString = NSAttributedString(string: websiteString,
                                                         attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16, weight: .medium), NSAttributedStringKey.foregroundColor: Color.primaryDark, NSAttributedStringKey.underlineStyle: 1, NSAttributedStringKey.underlineColor: Color.primaryDark])
        
        infoMutableAttributedString.append(websiteAttributedString)
        
        infoMutableAttributedString.beginEditing()
        if let url = URL(string: "https://www.thehive.ai") {
            let range = NSString(string: infoMutableAttributedString.string).range(of: websiteString)
            infoMutableAttributedString.addAttribute(.link, value: url, range: range)
        }
        infoMutableAttributedString.endEditing()
        self.moreInfoTextView.tintColor = Color.primaryDark
        self.moreInfoTextView.attributedText = infoMutableAttributedString
        
    }
    
    func configureTextFields() {
        self.nameTextField.textFieldType = .name
        self.emailTextField.textFieldType = .email
        self.companyTextField.textFieldType = .company
        self.phoneTextField.textFieldType = .phone
    }
    
    func configureKeyboardDismissGestureRecogniser() {
        let gestureRecogniser = UITapGestureRecognizer(target: self, action:#selector(HiveEnterpriseViewController.endEditing))
        gestureRecogniser.cancelsTouchesInView = false
        self.view.addGestureRecognizer(gestureRecogniser)
    }
    
    @objc func endEditing() {
        self.view.endEditing(true)
    }
    
    func configureKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(HiveEnterpriseViewController.keyboardDidChangeState(notification:)), name: Notification.Name.UIKeyboardDidChangeFrame, object: nil)
    }
    
    @objc func keyboardDidChangeState(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber  else { return }
        
        let animationCurveRaw = animationCurveRawNSN.uintValue
        let animationCurve = UIViewAnimationOptions(rawValue: animationCurveRaw)
        if endFrame.origin.y >= UIScreen.main.bounds.size.height {
            self.buttonViewBottomConstraint.constant = 0.0
        } else {
            self.buttonViewBottomConstraint.constant = endFrame.size.height
        }
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: animationCurve,
                       animations: { self.view.layoutIfNeeded() },
                       completion: nil)
    }
    
    func configureLoaderView() {
        self.loaderImageView.image = UIImage(named: "iconsLoadingSpinner")
        self.loaderImageView.layer.add(self.rotateAnimation, forKey: nil)
        self.loaderView.isHidden = true
    }
    
    func resetErrors() {
        self.nameTextField.toggleError(show: false)
        self.emailTextField.toggleError(show: false)
        self.companyTextField.toggleError(show: false)
        self.phoneTextField.toggleError(show: false)
    }
    
    func openWebPageWithURL(url: URL?) {
        guard let webPageURL = url else { return }
        
        let svc = SFSafariViewController(url: webPageURL, entersReaderIfAvailable: true)
        self.present(svc, animated: true, completion: nil)
    }
    
    //MARK: IBActions
    @IBAction func backTapped(_ sender: Any) {
        self.output.backTapped()
    }
    @IBAction func submitTapped(_ sender: Any) {
        self.output.sendFeedbackTapped()
    }
}

extension HiveEnterpriseViewController: HiveEnterpriseViewInput {
    // MARK: HiveEnterpriseViewInput
    func setupInitialState() {
        configureMoreInfoLabel()
        configureTextFields()
        configureKeyboardObserver()
        configureKeyboardDismissGestureRecogniser()
        configureLoaderView()
    }
    
    func toggleLoaderVisiblity(forState state: LoaderState) {
        self.loaderView.isHidden = state == .hidden
    }
    
    func feedbackResponseSuccess() {
        
    }
    
    func feedbackResponseFailure(error: Error?) {
        if let resposeError = error as NSError? {
            self.showAlert(error: resposeError)
        } else {
            self.showAlert(title: "Error", message: "There was some error in sending your feedback. Please try again!")
        }
    }
    
    func toggleTextFieldValidity(withState state: TextFieldValidityState) {
        if case TextFieldValidityState.invalid(let type) = state {
            switch type {
            case .email:
                self.emailTextField.toggleError(show: true)
            case .phone:
                self.phoneTextField.toggleError(show: true)
            case .name:
                self.nameTextField.toggleError(show: true)
            case .company:
                break
            }
        } else if case TextFieldValidityState.valid(let type) = state {
            switch type {
            case .email:
                self.emailTextField.toggleError(show: false)
            case .phone:
                self.phoneTextField.toggleError(show: false)
            case .name:
                self.nameTextField.toggleError(show: false)
            case .company:
                break
            }
        }
    }
}

extension HiveEnterpriseViewController: UITextFieldDelegate, UITextViewDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {        
        guard let floatingtextField = textField as? FloatingLabelTextField else { return false }
        
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let finalText = textFieldText.replacingCharacters(in: range, with: string)
        
        var shouldUpdate = true
        if let characterLimit = floatingtextField.textFieldType.characterLimit {
            shouldUpdate = finalText.count <= characterLimit
        }
        if shouldUpdate {
            if textField.isDescendant(of: self.nameTextField) {
                self.output.updateData(withString: finalText, textFieldType: .name)
            } else if textField.isDescendant(of: self.emailTextField) {
                self.output.updateData(withString: finalText, textFieldType: .email)
            } else if textField.isDescendant(of: self.companyTextField) {
                self.output.updateData(withString: finalText, textFieldType: .company)
            } else if textField.isDescendant(of: self.phoneTextField) {
                self.output.updateData(withString: finalText, textFieldType: .phone)
            }
        }
        return shouldUpdate
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //check for form validity
        
        let textFieldText: NSString = textView.text as NSString
        let finalText = textFieldText.replacingCharacters(in: range, with: text)
        
        let characterLimit = self.output.messageCharacterLimit
        let currentCharacterCount = textView.text?.count ?? 0
        let newLength = currentCharacterCount + text.count - range.length
        let shouldUpdate = newLength <= characterLimit
        
        if shouldUpdate {
            self.output.updateMessage(message: finalText)
        }
        return shouldUpdate
    }
    
    @available(iOS 10.0, *)
    func textView(_ textView: UITextView,
                  shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        print("url tapped \(URL.absoluteString)")
        openWebPageWithURL(url: URL)
        return false
    }
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        print("url tapped \(URL.absoluteString)")
        openWebPageWithURL(url: URL)
        return false
    }
}

extension HiveEnterpriseViewController: HiveEnterpriseRouterOutput {
    func popViewController(animated: Bool) {
        self.navigationController?.popViewController(animated: animated)
    }
}
