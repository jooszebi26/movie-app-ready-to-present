//
//  FetchPersonDetailRequest.swift
//  movie-app-live
//
//  Created by Szebasztian Joo on 2025. 06. 14..
//

struct  FetchCastMemberDetailRequest: Encodable{
    let accessToken: String = Config.bearerToken
    let personId: Int
    
    func asRequestParams() -> [String: Any] {
        return [:]
    }
}
