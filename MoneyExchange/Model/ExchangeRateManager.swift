//
//  ExchangeManager.swift
//  MoneyExchange
//
//  Created by Eric on 2022/11/06.
//

import Foundation


protocol ExchangeManagerDelegate {
    func didUpdateCurrency(price1: String, price2: String)
    func didFailWithError(error: Error)
}

struct ExchangeRateManager {
    var delegate: ExchangeManagerDelegate?
    
    let baseURL = "https://www.koreaexim.go.kr/site/program/financial/exchangeJSON?data=AP01"
    let myAPIKey = "U7dr2LfO8WXzzSxdd1GDaEGpvUZcrqW9"

    let currencyArray = ["아랍에미리트 (디르함)", "호주 (달러)", "바레인 (디나르)", "브루나이 (달러)", "캐나다 (달러)", "스위스 (프랑)", "중국 (위안화)", "덴마크 (크로네)", "유럽 (유로)", "영국 (파운드)", "홍콩 (달러)", "인도네시아 (루피아)", "일본 (엔)", "한국 (원)", "쿠웨이트 (디나르)", "말레이시아 (링기트)", "노르웨이 (크로네)", "뉴질랜드 (달러)", "사우디 (리얄)", "스웨덴 (크로나)", "싱가포르 (달러)", "태국 (바트)", "미국 (달러)"]
    
    func getExchangeRate(dateForAPI: String) {
        let urlString = "\(baseURL)&searchdate=\(dateForAPI)&authkey=\(myAPIKey)"
        performRequest(with: urlString)
    }

    func performRequest(with urlString: String) {
        // 1. Create a URL
        if let url = URL(string: urlString) {
            // 2. Create a URLSession
            let session = URLSession(configuration: .default)
            
            // 3. Give the session a task (completion handler 사용)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                // data 내용 체크
                //let dataAsString = String(data: data!, encoding: .utf8)
                //print(dataAsString!)
                
                // 데이터 가져오기 -> JSON 데이터를 parse하기 -> 변수에 값 업데이트하기
                // 각 스텝이 성공하면 다음 스텝으로 넘어가는 식으로 코딩
                if let safeData = data {
                    // closure 내부에서는 self를 생략하지 말아야 함
                    if let currentPrice1 = self.parseJSON(safeData) {
                        // delegate 송신 (to: WeatherViewController.swift)
                        let currentPrice1String = String(format: "%.2f", currentPrice1)
                        self.delegate?.didUpdateCurrency(price1: currentPrice1String, price2: currentPrice1String)
                    }
                }
            }
             
            // 4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> String? {
        let decoder = JSONDecoder()

        do {
            let decodedData = try decoder.decode(ERData.self, from: data)
            let currentPrice = decodedData[22].ttb
            print(currentPrice)
            return currentPrice
        } catch {
            print("ERROR: decoding")
            return nil
        }
    }
    
}


/*

https://www.koreaexim.go.kr/site/program/financial/exchangeJSON?data=AP01&searchdate=20221107&apikey=U7dr2LfO8WXzzSxdd1GDaEGpvUZcrqW9
 
 */
