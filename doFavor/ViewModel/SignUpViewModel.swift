//
//  SignUpViewModel.swift
//  doFavor
//
//  Created by Phakkharachate on 21/3/2565 BE.
//

import Alamofire

struct SignUpViewModel {
    
    public func registerUser(reqObj: RequestUserModel,then completion: @escaping (Result<UserModel
                                                                                  ,ServiceError>) -> ()){
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
                completion(.failure(ServiceError.UnParsableError))
            }
        }
    }
}
