//
//  ExchangeManager.swift
//  MoneyExchange
//
//  Created by Eric on 2022/11/06.
//

import Foundation


protocol ExchangeManagerDelegate {
    func didUpdateCurrency()
    func didFailWithError(error: Error)
}

struct ExchangeManager {
    var delegate: ExchangeManagerDelegate?
    
    let baseURL = "https://www.koreaexim.go.kr/site/program/financial/exchangeJSON?data=AP01"
    let myAPIKey = "U7dr2LfO8WXzzSxdd1GDaEGpvUZcrqW9"

    let currencyArray = ["아랍에미리트 디르함", "호주 달러", "바레인 디나르", "브루나이 달러", "캐나다 달러", "스위스 프랑", "중국 위안화", "덴마크 크로네", "유럽 유로", "영국 파운드", "홍콩 달러", "인도네시아 루피아", "일본 엔", "한국 원", "쿠웨이트 디나르", "말레이시아 링기트", "노르웨이 크로네", "뉴질랜드 달러", "사우디 리얄", "스웨덴 크로나", "싱가포르 달러", "태국 바트", "미국 달러"]
    
    func getExchangeRate() {
        let urlString = "\(baseURL)&apikey=\(myAPIKey)"
        print(urlString)
    }
    
}


/*
 
 https://www.koreaexim.go.kr/site/program/financial/exchangeJSON?data=AP01&authkey=U7dr2LfO8WXzzSxdd1GDaEGpvUZcrqW9
 
 */
