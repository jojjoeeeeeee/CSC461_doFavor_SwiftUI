//
//  SampleViewModel.swift
//  doFavor
//
//  Created by Phakkharachate on 16/3/2565 BE.
//

import Alamofire


struct UserViewModel {
    
    public func report(reqObj: RequestReportModel,then completion: @escaping (Result<ReportDataModel,ServiceError>) -> ()){
        
        let headers: HTTPHeaders = ["Authorization" : AppUtils.getUsrAuthToken()!,
                                    "Content-Type": "application/json"]
        
        let request = AF.request(Constants.BASE_URL+Constants.USER_REPORT, method: .post, parameters: reqObj, encoder: JSONParameterEncoder.default, headers: headers)
        
        request.responseDecodable(of: ResponseReportDataModel.self) { (response) in
            switch response.result {
            case .success(_):
                guard let data = response.value else {return}
                
                if data.result == "OK" {
                    let reportdata:ReportDataModel = data.data
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
