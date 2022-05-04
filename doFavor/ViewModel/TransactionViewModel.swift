//
//  TransactionViewModel.swift
//  doFavor
//
//  Created by Phakkharachate on 7/4/2565 BE.
//

import Alamofire

struct TransactionViewModel {
    
    public func getFormData(completion: @escaping (Result<TSCTFormDataModel,ServiceError>) -> ()){
        
        let headers: HTTPHeaders = ["Authorization" : AppUtils.getUsrAuthToken()!,
                                    "Content-Type": "application/json"]
        
        let request = AF.request(Constants.BASE_URL+Constants.TSCT_FORM_DATA, method: .get, headers: headers)
        
        request.responseDecodable(of: ResponseTSCTFormDataModel.self) { (response) in
            switch response.result {
            case .success(_):
                guard let data = response.value else {return}
                
                if data.result == "OK" {
                    let formdata:TSCTFormDataModel = data.data
                    completion(.success(formdata))
                }
                else if data.result == "nOK" {
                    completion(.failure(ServiceError.BackEndError(errorMessage: data.message)))
                }
                else {
                    completion(.failure(ServiceError.Non200StatusCodeError(doFavorAPIError(message: data.result, status: "500"))))
                }
            case .failure(let error):
                
                if let afError = error.asAFError {
                    switch afError {
                    case .sessionTaskFailed(let sessionError):
                        if let urlError = sessionError as? URLError, urlError.code == .notConnectedToInternet {
                            completion(.failure(ServiceError.NoNetworkError))
                        }
                        else {
                            completion(.failure(ServiceError.UnParsableError))
                        }
                    default :
                        completion(.failure(ServiceError.UnParsableError))
                    }
                }
                completion(.failure(ServiceError.UnParsableError))
            }
        }
    }
    
    public func create(reqObj: RequestCreateTSCTModel,then completion: @escaping (Result<CreateTSCTDataModel,ServiceError>) -> ()){
        
        let headers: HTTPHeaders = ["Authorization" : AppUtils.getUsrAuthToken()!,
                                    "Content-Type": "application/json"]
        
        let request = AF.request(Constants.BASE_URL+Constants.TSCT_CREATE, method: .post, parameters: reqObj, encoder: JSONParameterEncoder.default, headers: headers)
        
        request.responseDecodable(of: ResponseCreateTSCTModel.self) { (response) in
            switch response.result {
            case .success(_):
                guard let data = response.value else {return}
                
                if data.result == "OK" {
                    let tsctdata:CreateTSCTDataModel = data.data
                    completion(.success(tsctdata))
                }
                else if data.result == "nOK" {
                    completion(.failure(ServiceError.BackEndError(errorMessage: data.message)))
                }
                else if data.result == "Not found" {
                    completion(.failure(ServiceError.BackEndError(errorMessage: data.result)))
                }
                else {
                    completion(.failure(ServiceError.Non200StatusCodeError(doFavorAPIError(message: data.result, status: "500"))))
                }
            case .failure(let error):
                if let afError = error.asAFError {
                    switch afError {
                    case .sessionTaskFailed(let sessionError):
                        if let urlError = sessionError as? URLError, urlError.code == .notConnectedToInternet {
                            completion(.failure(ServiceError.NoNetworkError))
                        }
                        else {
                            completion(.failure(ServiceError.UnParsableError))
                        }
                    default :
                        completion(.failure(ServiceError.UnParsableError))
                    }
                }
                completion(.failure(ServiceError.UnParsableError))
            }
        }
    }
    
    public func getTSCT(reqObj: RequestGetTSCTModel, type: String,then completion: @escaping (Result<TSCTDataModel,ServiceError>) -> ()){
        
        let headers: HTTPHeaders = ["Authorization" : AppUtils.getUsrAuthToken()!,
                                    "Content-Type": "application/json"]
        
        let request = AF.request(Constants.BASE_URL+type, method: .post, parameters: reqObj, encoder: JSONParameterEncoder.default, headers: headers)
        
        request.responseDecodable(of: ResponseGetTSCTDataModel.self) { (response) in
            switch response.result {
            case .success(_):
                guard let data = response.value else {return}
                
                if data.result == "OK" {
                    let tsctdata:TSCTDataModel = data.data
                    completion(.success(tsctdata))
                }
                else if data.result == "nOK" {
                    completion(.failure(ServiceError.BackEndError(errorMessage: data.message)))
                }
                else if data.result == "Not found" {
                    completion(.failure(ServiceError.BackEndError(errorMessage: data.result)))
                }
                else {
                    completion(.failure(ServiceError.Non200StatusCodeError(doFavorAPIError(message: data.result, status: "500"))))
                }
            case .failure(let error):
                if let afError = error.asAFError {
                    switch afError {
                    case .sessionTaskFailed(let sessionError):
                        if let urlError = sessionError as? URLError, urlError.code == .notConnectedToInternet {
                            completion(.failure(ServiceError.NoNetworkError))
                        }
                        else {
                            completion(.failure(ServiceError.UnParsableError))
                        }
                    default :
                        completion(.failure(ServiceError.UnParsableError))
                    }
                }
                completion(.failure(ServiceError.UnParsableError))
            }
        }
    }
    
    public func getHistory(completion: @escaping (Result<historyModel,ServiceError>) -> ()){
        
        let headers: HTTPHeaders = ["Authorization" : AppUtils.getUsrAuthToken()!,
                                    "Content-Type": "application/json"]
        
        let request = AF.request(Constants.BASE_URL+Constants.TSCT_GET_HISTORY, method: .get, headers: headers)
        
        request.responseDecodable(of: ResponseTSCTHistoryDataModel.self) { (response) in
            switch response.result {
            case .success(_):
                guard let data = response.value else {return}
                
                if data.result == "OK" {
                    let formdata:historyModel = data.data
                    completion(.success(formdata))
                }
                else if data.result == "nOK" {
                    completion(.failure(ServiceError.BackEndError(errorMessage: data.message)))
                }
                else {
                    completion(.failure(ServiceError.Non200StatusCodeError(doFavorAPIError(message: data.result, status: "500"))))
                }
            case .failure(let error):
                
                if let afError = error.asAFError {
                    switch afError {
                    case .sessionTaskFailed(let sessionError):
                        if let urlError = sessionError as? URLError, urlError.code == .notConnectedToInternet {
                            completion(.failure(ServiceError.NoNetworkError))
                        }
                        else {
                            completion(.failure(ServiceError.UnParsableError))
                        }
                    default :
                        completion(.failure(ServiceError.UnParsableError))
                    }
                }
                completion(.failure(ServiceError.UnParsableError))
            }
        }
    }
    
    public func getAll(completion: @escaping (Result<getAllModel,ServiceError>) -> ()){
        
        let headers: HTTPHeaders = ["Authorization" : AppUtils.getUsrAuthToken()!,
                                    "Content-Type": "application/json"]
        
        let request = AF.request(Constants.BASE_URL+Constants.TSCT_GET_ALL, method: .get, headers: headers)
        
        request.responseDecodable(of: ResponseGetAllTSCTDataModel.self) { (response) in
            switch response.result {
            case .success(_):
                guard let data = response.value else {return}
                
                if data.result == "OK" {
                    let formdata:getAllModel = data.data
                    completion(.success(formdata))
                }
                else if data.result == "nOK" {
                    completion(.failure(ServiceError.BackEndError(errorMessage: data.message)))
                }
                else {
                    completion(.failure(ServiceError.Non200StatusCodeError(doFavorAPIError(message: data.result, status: "500"))))
                }
            case .failure(let error):
                
                if let afError = error.asAFError {
                    switch afError {
                    case .sessionTaskFailed(let sessionError):
                        if let urlError = sessionError as? URLError, urlError.code == .notConnectedToInternet {
                            completion(.failure(ServiceError.NoNetworkError))
                        }
                        else {
                            completion(.failure(ServiceError.UnParsableError))
                        }
                    default :
                        completion(.failure(ServiceError.UnParsableError))
                    }
                }
                completion(.failure(ServiceError.UnParsableError))
            }
        }
    }
    
    public func acceptTSCT(reqObj: RequestGetTSCTModel, then completion: @escaping (Result<TSCTDataModel,ServiceError>) -> ()){
        
        let headers: HTTPHeaders = ["Authorization" : AppUtils.getUsrAuthToken()!,
                                    "Content-Type": "application/json"]
        
        let request = AF.request(Constants.BASE_URL+Constants.TSCT_ACCEPT, method: .patch, parameters: reqObj, encoder: JSONParameterEncoder.default, headers: headers)
        
        request.responseDecodable(of: ResponseGetTSCTDataModel.self) { (response) in
            switch response.result {
            case .success(_):
                guard let data = response.value else {return}
                
                if data.result == "OK" {
                    let tsctdata:TSCTDataModel = data.data
                    completion(.success(tsctdata))
                }
                else if data.result == "nOK" {
                    completion(.failure(ServiceError.BackEndError(errorMessage: data.message)))
                }
                else if data.result == "Not found" {
                    completion(.failure(ServiceError.BackEndError(errorMessage: data.result)))
                }
                else {
                    completion(.failure(ServiceError.Non200StatusCodeError(doFavorAPIError(message: data.result, status: "500"))))
                }
            case .failure(let error):
                if let afError = error.asAFError {
                    switch afError {
                    case .sessionTaskFailed(let sessionError):
                        if let urlError = sessionError as? URLError, urlError.code == .notConnectedToInternet {
                            completion(.failure(ServiceError.NoNetworkError))
                        }
                        else {
                            completion(.failure(ServiceError.UnParsableError))
                        }
                    default :
                        completion(.failure(ServiceError.UnParsableError))
                    }
                }
                completion(.failure(ServiceError.UnParsableError))
            }
        }
    }
    
    public func successTSCT(reqObj: RequestGetTSCTModel, then completion: @escaping (Result<TSCTDataModel,ServiceError>) -> ()){
        
        let headers: HTTPHeaders = ["Authorization" : AppUtils.getUsrAuthToken()!,
                                    "Content-Type": "application/json"]
        
        let request = AF.request(Constants.BASE_URL+Constants.TSCT_SUCCESS, method: .patch, parameters: reqObj, encoder: JSONParameterEncoder.default, headers: headers)
        
        request.responseDecodable(of: ResponseGetTSCTDataModel.self) { (response) in
            switch response.result {
            case .success(_):
                guard let data = response.value else {return}
                
                if data.result == "OK" {
                    let tsctdata:TSCTDataModel = data.data
                    completion(.success(tsctdata))
                }
                else if data.result == "nOK" {
                    completion(.failure(ServiceError.BackEndError(errorMessage: data.message)))
                }
                else if data.result == "Not found" {
                    completion(.failure(ServiceError.BackEndError(errorMessage: data.result)))
                }
                else {
                    completion(.failure(ServiceError.Non200StatusCodeError(doFavorAPIError(message: data.result, status: "500"))))
                }
            case .failure(let error):
                if let afError = error.asAFError {
                    switch afError {
                    case .sessionTaskFailed(let sessionError):
                        if let urlError = sessionError as? URLError, urlError.code == .notConnectedToInternet {
                            completion(.failure(ServiceError.NoNetworkError))
                        }
                        else {
                            completion(.failure(ServiceError.UnParsableError))
                        }
                    default :
                        completion(.failure(ServiceError.UnParsableError))
                    }
                }
                completion(.failure(ServiceError.UnParsableError))
            }
        }
    }
    
    public func cancelTSCT(reqObj: RequestGetTSCTModel, type: String,then completion: @escaping (Result<TSCTDataModel,ServiceError>) -> ()){
        
        let headers: HTTPHeaders = ["Authorization" : AppUtils.getUsrAuthToken()!,
                                    "Content-Type": "application/json"]
        
        let request = AF.request(Constants.BASE_URL+type, method: .patch, parameters: reqObj, encoder: JSONParameterEncoder.default, headers: headers)
        
        request.responseDecodable(of: ResponseGetTSCTDataModel.self) { (response) in
            switch response.result {
            case .success(_):
                guard let data = response.value else {return}
                
                if data.result == "OK" {
                    let tsctdata:TSCTDataModel = data.data
                    completion(.success(tsctdata))
                }
                else if data.result == "nOK" {
                    completion(.failure(ServiceError.BackEndError(errorMessage: data.message)))
                }
                else if data.result == "Not found" {
                    completion(.failure(ServiceError.BackEndError(errorMessage: data.result)))
                }
                else {
                    completion(.failure(ServiceError.Non200StatusCodeError(doFavorAPIError(message: data.result, status: "500"))))
                }
            case .failure(let error):
                if let afError = error.asAFError {
                    switch afError {
                    case .sessionTaskFailed(let sessionError):
                        if let urlError = sessionError as? URLError, urlError.code == .notConnectedToInternet {
                            completion(.failure(ServiceError.NoNetworkError))
                        }
                        else {
                            completion(.failure(ServiceError.UnParsableError))
                        }
                    default :
                        completion(.failure(ServiceError.UnParsableError))
                    }
                }
                completion(.failure(ServiceError.UnParsableError))
            }
        }
    }
    
    public func reportTSCT(reqObj: RequestReportTSCTModel,then completion: @escaping (Result<ReportTSCTDataModel,ServiceError>) -> ()){
        
        let headers: HTTPHeaders = ["Authorization" : AppUtils.getUsrAuthToken()!,
                                    "Content-Type": "application/json"]
        
        let request = AF.request(Constants.BASE_URL+Constants.TSCT_REPORT, method: .post, parameters: reqObj, encoder: JSONParameterEncoder.default, headers: headers)
        
        request.responseDecodable(of: ResponseReportTSCTDataModel.self) { (response) in
            switch response.result {
            case .success(_):
                guard let data = response.value else {return}
                
                if data.result == "OK" {
                    let reportdata:ReportTSCTDataModel = data.data
                    completion(.success(reportdata))
                }
                else if data.result == "nOK" {
                    completion(.failure(ServiceError.BackEndError(errorMessage: data.message)))
                }
                else if data.result == "Not found" {
                    completion(.failure(ServiceError.BackEndError(errorMessage: data.result)))
                }
                else {
                    completion(.failure(ServiceError.Non200StatusCodeError(doFavorAPIError(message: data.result, status: "500"))))
                }
            case .failure(let error):
                if let afError = error.asAFError {
                    switch afError {
                    case .sessionTaskFailed(let sessionError):
                        if let urlError = sessionError as? URLError, urlError.code == .notConnectedToInternet {
                            completion(.failure(ServiceError.NoNetworkError))
                        }
                        else {
                            completion(.failure(ServiceError.UnParsableError))
                        }
                    default :
                        completion(.failure(ServiceError.UnParsableError))
                    }
                }
                completion(.failure(ServiceError.UnParsableError))
            }
        }
    }
    
}
