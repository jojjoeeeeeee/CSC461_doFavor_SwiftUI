//
//  SignUpViewModel.swift
//  doFavor
//
//  Created by Phakkharachate on 21/3/2565 BE.
//

import Alamofire

struct AuthViewModel {
    
    public func registerUser(reqObj: RequestRegisterUserModel,then completion: @escaping (Result<UserModel,ServiceError>) -> ()){
        let request = AF.request(Constants.BASE_URL+Constants.AUTH_REGISTER, method: .post, parameters: reqObj, encoder: JSONParameterEncoder.default)
        request.responseDecodable(of: ResponseUserModel.self) { (response) in
            switch response.result {
            case .success(_):
                guard let data = response.value else {return}
                
                if data.result == "OK" {
                    let userdata:UserModel = data.data
                    completion(.success(userdata))
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
    
    public func loginUser(reqObj: RequestLoginUserModel,then completion: @escaping (Result<UserModel,ServiceError>) -> ()){
        let request = AF.request(Constants.BASE_URL+Constants.AUTH_LOGIN, method: .post, parameters: reqObj, encoder: JSONParameterEncoder.default)
        request.responseDecodable(of: ResponseUserModel.self) { (response) in
            switch response.result {
            case .success(_):
                guard let data = response.value else {return}

                if data.result == "OK" {
                    let userdata:UserModel = data.data
                    if userdata.state == "verify" {
                        let token = response.response?.allHeaderFields["Authorization"] as? String
                        AppUtils.saveUsrAuthToken(token: token ?? "")
                        
                    }
                    completion(.success(userdata))
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
    
    public func verifyUser(reqObj: RequestOtpModel,then completion: @escaping (Result<UserModel
                                                                                  ,ServiceError>) -> ()){
        let request = AF.request(Constants.BASE_URL+Constants.AUTH_VERIFY, method: .post, parameters: reqObj, encoder: JSONParameterEncoder.default)
        request.responseDecodable(of: ResponseUserModel.self) { (response) in
            switch response.result {
            case .success(_):
                guard let data = response.value else {return}
                
                if data.result == "OK" {
                    let userdata:UserModel = data.data
                    let token = response.response?.allHeaderFields["Authorization"] as? String
                    AppUtils.saveUsrAuthToken(token: token ?? "")
                    completion(.success(userdata))
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
}
