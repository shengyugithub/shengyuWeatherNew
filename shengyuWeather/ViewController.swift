//
//  ViewController.swift
//  shengyuWeather
//
//  Created by 盛钰 on 16/5/5.
//  Copyright © 2016年 shengyu. All rights reserved.
//

import UIKit


class ViewController: UIViewController,UISearchBarDelegate {
    
    @IBOutlet var city: UILabel!
    @IBOutlet var weather: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var time: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var Temperature: UILabel!
    
    var resultData : NSData?
    
    
    override func viewDidLoad() {
      
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
     
      //  self.networkingRequest()
       self.searchBar.delegate = self
        //hello world!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func refreshButtonClicked(){
        //1
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        
        let url = urlWithSearchText(searchBar.text)
        
        //2
        dispatch_async(queue){
            self.networkingRequest(url!)
            if let dt = self.resultData{
                    let tempweatherdata =  self.getJsonData(dt)
                dispatch_async(dispatch_get_main_queue()){
                    self.updateLabels(tempweatherdata)
                    self.updateImage(tempweatherdata)
                }
            }
        }
    }
    
    func updateLabels(Data: weatherModel?){
        if let weatherData = Data{
            self.city.text = weatherData.name
            self.weather.text = weatherData.weather.description
            self.time.text = weatherData.date
            self.Temperature.text = "\(kelvinToCelsius(weatherData.main.temp))"
        }else{
            print("no label data!")
        }
    }
    
    func getJsonData(data: NSData)->weatherModel{
        let weatherData  = self.parseJSON(data)!
        
        print("hi,this is the new. City \(weatherData.name)'s weather is \(weatherData.weather.description),TIME: \(weatherData.date)")
//        self.city.text = weatherData.name
//        self.weather.text = weatherData.weather.description
//        self.time.text = weatherData.date
//       
        return weatherData
    }
    
    func urlWithSearchText(text : String?)-> NSURL?{
        if let SearchText = text{
            let url = NSURL(string : "http://api.openweathermap.org/data/2.5/weather?q=" + SearchText + "&appid=3d5b744314d045c612bda1540a4f503e")
            print(url)
            return url
        }
        return nil
    }
    
    func networkingRequest(url : NSURL){
        
        let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        var dataTask: NSURLSessionDataTask
        

     
/*       let url = NSURL(string:  "http://api.openweathermap.org/data/2.5/weather? q=Xian&appid=3d5b744314d045c612bda1540a4f503e")
 */
        dataTask = defaultSession.dataTaskWithURL(url){
            data, response, error in
            dispatch_async(dispatch_get_main_queue()){
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
            
            if let error = error {
                print(error.localizedDescription)
            }else if let httpResponse = response as? NSHTTPURLResponse{
                if httpResponse.statusCode == 200{
                    self.resultData = data

                }
            }
        }
        
        dataTask.resume()
        
        
    }


    func parseJSON(data :NSData)->weatherModel?{
        let weatherObject  : weatherModel
        var json :[String :AnyObject]
        do {
            json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as![String :AnyObject]
           weatherObject = parseDictionary(json)!
            return weatherObject
            }catch{
                print(error)
            }
            return nil
    }
    
    //时间戳 时间转换
    func changeUTCtoDate(UTCString:Int)->NSString{
        let sunStr = NSString(format: "%d", UTCString)
        let timer:NSTimeInterval = sunStr.doubleValue
        let data = NSDate(timeIntervalSince1970: timer)
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let str:NSString = formatter.stringFromDate(data)
        return str
      
    }
    //开尔文转换摄氏度
    func kelvinToCelsius(kelvin : Double)->Double{
        return kelvin - 273.15
    }
    
    
    private func parseDictionary(dictionary :[String :AnyObject])-> weatherModel?{
        let weatherResult = weatherModel()
        //
        guard let item = dictionary as? [String :AnyObject],
            let name = item["name"] as? String,
            let dt = item["dt"] as? Int,
            
           
            let weather = item["weather"] as? [AnyObject],
            let weatherInfo = weather[0] as? [String :AnyObject],
            let weatherDescription = weatherInfo["description"] as? String,
            let weatherIcon = weatherInfo["icon"] as? String,
            
            let main = item["main"] as? [String : AnyObject],
            let mainTemp = main["temp"] as? Double
//
            else{
                return nil
            }
        let date = changeUTCtoDate(dt)
     //   print("City \(name)'s weather is \(weatherDescription),dt:\(dt)TIME: \(date)")
        weatherResult.name = name
        weatherResult.weather.description = weatherDescription
        weatherResult.date = date as String
        weatherResult.image = weatherIcon
        weatherResult.main.temp = mainTemp
        
        //
        return weatherResult
    }
    
    
    func updateImage(Data: weatherModel?){
        if let weatherData = Data{
            self.imageView.image = UIImage.init(named: "\(weatherData.image)")
        }else{
            print("no data!")
        }
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if let text = searchBar.text{
            print("\(text)")
            urlWithSearchText(text)
            refreshButtonClicked()
        }
        
    }
    
}