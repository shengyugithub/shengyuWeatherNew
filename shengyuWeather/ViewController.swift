//
//  ViewController.swift
//  shengyuWeather
//
//  Created by 盛钰 on 16/5/5.
//  Copyright © 2016年 shengyu. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NSLog("good")
        getData()
        //hello world!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getData(){
        
        let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        var dataTask: NSURLSessionDataTask
        

     
        let url = NSURL(string:  "http://api.openweathermap.org/data/2.5/weather?q=London,uk&appid=3d5b744314d045c612bda1540a4f503e")
        dataTask = defaultSession.dataTaskWithURL(url!){
            data, response, error in
            dispatch_async(dispatch_get_main_queue()){
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
            
            if let error = error {
                print(error.localizedDescription)
            }else if let httpResponse = response as? NSHTTPURLResponse{
                if httpResponse.statusCode == 200{
                    self.parseJSON(data!)
                }
            }
        }
        
        dataTask.resume()
        
    }


    func parseJSON(data :NSData)->[String: AnyObject]?{
        
        var json :[String :AnyObject]
        do {
            json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as![String :AnyObject]
            parseDictionary(json)
            return json
            }catch{
                print(error)
            }
            return nil
    }
    
    
    private func parseDictionary(dictionary :[String :AnyObject])-> weatherModel{
        let weatherResult = weatherModel()
        //
        guard let item = dictionary as? [String :AnyObject],
            let name = item["name"] as? String
//            let weather = item["weather"] as? [String :AnyObject],
//            let description = weather["description"]
//        
            else{
                return weatherResult
            }
        print("City \(name)'s weather is \(description)")
        weatherResult.name = name
       
        //
        return weatherResult
    }
    
}