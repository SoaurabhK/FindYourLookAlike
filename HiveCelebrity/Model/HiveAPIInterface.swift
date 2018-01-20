//
//  HiveAPIInterface.swift
//  HiveCelebrity
//
//  Created by Soaurabh Kakkar on 02/01/18.
//  Copyright © 2018 Soaurabh Kakkar. All rights reserved.
//

import Foundation

class HiveAPIInterface: APIInterface {
    lazy var hiveURLRequest: URLRequest? = {
        let url = String(format: APIConstants.baseURLString)
        guard let serviceUrl = URL(string: url) else { return nil}
        var request = URLRequest(url: serviceUrl)
        request.timeoutInterval = APIConstants.timeOutInterval
        let authorization = "Token " + APIConstants.authorizationToken
        request.setValue(authorization, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        return request
    }()
    
    lazy var feedbackURLRequest: URLRequest? = {
        let url = String(format: FeedbackAPIConstants.baseURLString)
        guard let serviceUrl = URL(string: url) else { return nil}
        var request = URLRequest(url: serviceUrl)
        request.timeoutInterval = APIConstants.timeOutInterval
        request.httpMethod = "POST"
        return request
    }()

    static let sharedInterface = HiveAPIInterface()
    var dataTask: URLSessionDataTask?

    func fetchCelebrityDetails<T>(imageData: Data, completion: @escaping ((Result<T>)->Void)) {
        guard let request = self.hiveURLRequest else {
            let result: Result<T> = Result(data: nil, error: NSError.urlRequestGenerationError())
            completion(result)
            return
        }
        self.dataTask?.cancel()
        if let task = self.uploadImage(imageData: imageData, urlRequest: request, params: [:], completionBlock: completion) {
            self.dataTask = task
            self.dataTask?.resume() // data task cane be forwarded if needed to be cancelled
        } else {
            let result: Result<T> = Result(data: nil, error: NSError.urlRequestGenerationError())
            completion(result)
        }
    }
    
    func sendFeedback<T>(data: Data?, completion: @escaping ((Result<T>)->Void)) {
        guard let request = self.feedbackURLRequest, let formData = data else {
            let result: Result<T> = Result(data: nil, error: NSError.urlRequestGenerationError())
            completion(result)
            return
        }
        self.dataTask?.cancel()
        if let task = self.sendFeedback(data: formData, urlRequest: request, params: [:], completionBlock: completion) {
            self.dataTask = task
            self.dataTask?.resume() // data task cane be forwarded if needed to be cancelled
        } else {
            let result: Result<T> = Result(data: nil, error: NSError.urlRequestGenerationError())
            completion(result)
        }
    }

    override func mapError<T>(error: Error?, withCompletionBlock completionBlock: ((Result<T>)->Void)) {
        guard let error = error else {
            let result: Result<T> = Result(data: nil, error: NSError.urlRequestGenerationError())
            completionBlock(result)
            return
        }
        DLOG("error returned is \(error)")
        var mappedError: NSError? = nil
        if (error as NSError).code == -1009 {
            // internet not present
            mappedError = NSError.noNetworkAvailable()
        }
        let result: Result<T> = Result(data: nil, error: mappedError)
        completionBlock(result)
    }
    
}
