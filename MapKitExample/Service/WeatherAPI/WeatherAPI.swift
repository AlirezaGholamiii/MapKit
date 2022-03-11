//
//  WeatherAPI.swift
//  MapKitExample
//
//  Created by Alireza Gholami on 2022-03-11.
//

import Foundation


class WeatherAPI {
    
    
    static func weatherNow(city : String,
                           successHandler: @escaping (_ httpStatusCode : Int, _ response : [String: Any]) -> Void,
                           failHandler : @escaping (_ httpStatusCode : Int, _ errorMessage: String)-> Void)
    {
        
        //deaclearing all the elements to fetch the API
        let baseURL = "https://weatherapi-com.p.rapidapi.com/"
        let endPoint = "current.json"
        let method = "GET"
        let header = ["x-rapidapi-host":"weatherapi-com.p.rapidapi.com", "x-rapidapi-key":"0f6e7fd7a0msh6dd932cb1a7ba2ap18a0a5jsnbd3170395213"]
        
        let payload : [String:String] = [:]
        
        API.call(baseURL: baseURL, endPoint: "\(endPoint)?q=\(city)", method: method, header: header, payload: payload, successHandler: successHandler , failHandler: failHandler)
        

    }
}


//codeable to serialize
struct WeatherAPICurrent : Codable {
    
    var temp_c : Double
    var condition : Condition
    var feelslike_c : Double
    
    
    //define the second instruct to go inside the condition
    struct Condition : Codable {
        
        var text : String
        var icon : String
    }
    
    
    struct func decode(json : [String:Any]) -> WeatherAPICurrent? {
        
        let decoder = JSONDecoder()
        
        do{
            let data = try JSONSerialization.data(withJSONObject: json, options: prettyPrinted)
            let object = try decoder.decode(WeatherAPICurrent.self, from: data)
            
            return object
        }catch
        {
            
        }
        return nil
        
    }}
