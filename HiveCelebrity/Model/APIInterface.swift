//
//  APIInterface.swift
//  HiveCelebrity
//
//  Created by Soaurabh Kakkar on 02/01/18.
//  Copyright © 2018 Soaurabh Kakkar. All rights reserved.
//

import Foundation

protocol JSONParsing {
    static func parseResults(json: Any) -> Self
}

struct Result <T: JSONParsing> {
    var data: T?
    var error: Error?
}

class APIInterface {
    var defaultSession: URLSession {
        // used as a computed property to be able to override
        return URLSession(configuration: .default)
    }

    func uploadImage<T>(imageData: Data,
                        urlRequest request: URLRequest,
                        params: [String: String],
                        completionBlock: @escaping ((Result<T>)->Void)) -> URLSessionDataTask? {
        var serviceRequest = request // make a local mutable Copy
        serviceRequest.httpMethod = "POST"
        let boundary = "Boundary-\(UUID().uuidString)"
        serviceRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        serviceRequest.httpBody = createBody(parameters: params,
                                             boundary: boundary,
                                             data: imageData,
                                             mimeType: "image/jpg",
                                             filename: "image.jpg",
                                             dataKeyName: "image")

         let dataTask = self.defaultSession.dataTask(with: serviceRequest,
                                                     completionHandler: {
                                                        [weak self] (data, urlResponse, error) in
                                                        if let response = urlResponse {
                                                            DLOG(response)
                                                        }
                                                        if let data = data {
                                                            do {
                                                                let json = try JSONSerialization.jsonObject(with: data, options: [])
                                                                DLOG("json returned is \(json)")
                                                                let data = T.parseResults(json: json)
                                                                let result: Result<T> = Result(data: data, error: nil)
                                                                completionBlock(result)
                                                            } catch {
                                                                let result: Result<T> = Result(data: nil, error: NSError.parsingError())
                                                                completionBlock(result)
                                                            }
                                                        } else {
                                                            self?.mapError(error: error, withCompletionBlock: completionBlock)
                                                        }
        })
        return dataTask
    }
    
    func sendFeedback<T>(data: Data,
                        urlRequest request: URLRequest,
                        params: [String: String],
                        completionBlock: @escaping ((Result<T>)->Void)) -> URLSessionDataTask? {
        var serviceRequest = request // make a local mutable Copy
        serviceRequest.httpMethod = "POST"
        serviceRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        serviceRequest.httpBody = data
        
        let dataTask = self.defaultSession.dataTask(with: serviceRequest,
                                                    completionHandler: {
                                                        [weak self] (data, urlResponse, error) in
                                                        guard  let response = urlResponse as? HTTPURLResponse else { return }
                                                        DLOG(response)
                                                        if response.statusCode == 200 {
                                                            let data = T.parseResults(json: [:])
                                                            let result: Result<T> = Result(data: data, error: nil)
                                                            completionBlock(result)
                                                        } else {
                                                            self?.mapError(error: error, withCompletionBlock: completionBlock)
                                                        }
        })
        return dataTask
    }

    func mapError<T>(error: Error?, withCompletionBlock completionBlock: ((Result<T>)->Void)) {
        // map the error from server
    }

    private func createBody(parameters: [String: String],
                    boundary: String,
                    data: Data,
                    mimeType: String,
                    filename: String,
                    dataKeyName: String) -> Data {
        let body = NSMutableData()

        let boundaryPrefix = "--\(boundary)\r\n"

        for (key, value) in parameters {
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }

        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"\(dataKeyName)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--".appending(boundary.appending("--")))

        return body as Data
    }
}
