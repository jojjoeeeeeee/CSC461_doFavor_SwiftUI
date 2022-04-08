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
    
}
