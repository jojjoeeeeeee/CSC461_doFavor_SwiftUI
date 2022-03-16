//
//  SampleViewModel.swift
//  doFavor
//
//  Created by Phakkharachate on 16/3/2565 BE.
//

import Alamofire

struct HomeViewModel {
    
    public func fetchData(completion: @escaping (Result<[SampleModel],Error>) -> ()){
        let request = AF.request(Constants.BASE_URL, method: .get)
        request.responseDecodable(of: SampleData.self) { (response) in
            switch response.result {
            case .success(_):
                guard let data = response.value else {return}
                let sampledata = data.keys
                completion(.success(sampledata))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
