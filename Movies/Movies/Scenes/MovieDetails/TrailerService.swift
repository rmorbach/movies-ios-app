//
//  TraillerService.swift
//  Movies
//
//  Created by Rodrigo Morbach on 16/11/18.
//  Copyright © 2018 Movile. All rights reserved.
//

import Foundation

enum ServiceError: String, Error {
    case urlNotFound = "Não encontrado"
    case unknown = "Desconhecido"
    case invalidUrl = "URL inválida"
    case parseError = "Erro de parse"
    case emptyResponse = "Resposta vazia"
}

class TrailerService {
    
    let apiBaseUrl = "https://itunes.apple.com/search?media=movie&entity=movie&term="
    
    let service: ServiceAPI
    
    init(service: ServiceAPI) {
        self.service = service
    }
    
    func trailerUrlFor(movie title: String, completion: @escaping (_ url: String?, _ error: ServiceError?) -> Void) {
        let urlString = apiBaseUrl + title
        let fragmentedUrlCharacterSet = CharacterSet.urlFragmentAllowed
        guard let fmtUrlS = urlString.addingPercentEncoding(withAllowedCharacters: fragmentedUrlCharacterSet) else {
            completion(nil, ServiceError.invalidUrl)
            return
        }
        
        guard let movieUrl = URL(string: fmtUrlS) else {
            completion(nil, ServiceError.invalidUrl)
            return
        }
        
        let method = HTTPMethod.post
        
        service.request(to: movieUrl, method: method, contentType: nil, payload: nil) { data, response, error in
            if error != nil {
                completion(nil, ServiceError.unknown)
                return
            }
            
            guard let resp = response else {
                completion(nil, ServiceError.unknown)
                return
            }
            
            if resp.statusCode == 200 {
                
                if data != nil {
                    
                    let decoder = JSONDecoder()
                    
                    do {
                        
                        let itunesResponse = try decoder.decode(ItunesApiResponse.self, from: data!)
                        if itunesResponse.resultCount == 0 {
                            completion(nil, ServiceError.emptyResponse)
                            return
                        }
                        
                        completion(itunesResponse.results.first!.previewUrl, nil)
                        
                    } catch {
                        completion(nil, ServiceError.parseError)
                        return
                    }
                } else {
                    completion(nil, ServiceError.emptyResponse)
                    return
                }
                
            } else if resp.statusCode == 404 {
                completion(nil, ServiceError.urlNotFound)
                return
            } else if resp.statusCode > 405 {
                completion(nil, ServiceError.unknown)
                return
            }
            
        }
        
    }
    
}
