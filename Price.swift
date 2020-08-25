//
//  Price.swift
//  PriceClass
//
//  Created by Hayden Bowden on 1/28/20.
//  Copyright © 2020 Hayden Bowden. All rights reserved.
//

import Foundation

class Price:Codable{
    
    private var priceString = String()
    private var priceBase = Double()
    private var magnitude = Int()
    private var magnitudeName = String()
    private var magnitudeAbr = String()
    
    init(_ price: Double){
        setPrice(amount: price)
    }
    init(_ base: Double, mag: Int){
        setPrice(base: base, mag: mag)
    }
    init(){
        magnitude = 0
        priceBase = 0
    }
    
    init(priceStringI: String, priceBaseI: Double, magnitudeI: Int, magnitudeNameI: String, magnitudeAbrI:String){
        self.priceString = priceStringI
        self.priceBase = priceBaseI
        self.magnitude = magnitudeI
        self.magnitudeName = magnitudeNameI
        self.magnitudeAbr = magnitudeAbrI
    }
    
    func getString() -> String{
        return priceString
    }
    func setMAX(){
        setPrice(base: 9, mag:100)
        priceString = "MAX"
    }
    private func getLength(_ price: Double) -> Int{
        var length = 0
        var temp = price
        while (temp>=1){
            length+=1
            temp/=10
        }
        return length
    }
    
    private func setMagName(){
        switch (magnitude/3) {
        case 0:
            magnitudeName = ""
            magnitudeAbr = ""
            break
        case 1:
            magnitudeName = "Thousand"
            magnitudeAbr = "K"
            break
        case 2:
            magnitudeName = "Million"
            magnitudeAbr = "M"
            break
        case 3:
            magnitudeName = "Billion"
            magnitudeAbr = "B"
            break
        case 4:
            magnitudeName = "Trillion"
            magnitudeAbr = "T"
            break
        case 5:
            magnitudeName = "Quadrillion"
            magnitudeAbr = "q"
            break
        case 6:
            magnitudeName = "Quintillion"
            magnitudeAbr = "Q"
            /* finish*/
        default:
            magnitudeName = ""
            magnitudeAbr = ""
        }
    }

    private func setString(){
        var temp = "$"
        
        let multiplier: Double = (Double)(magnitude%3)
        if magnitude>=4{
            temp.append("\(round(toRound: (priceBase * pow(10, multiplier)), toPlaces: 2-Int(multiplier)).removeZerosFromEnd())")
            temp.append(" \(magnitudeAbr)")
        }else if magnitude == 3{
            let tempNum = (round(toRound: Double(priceBase * pow(10, Double(magnitude))), toPlaces: 2))
            let formatted = String(format: "%.0f", tempNum)
            temp.append(formatted)
        }else{
            let tempNum = (round(toRound: (priceBase * pow(10, multiplier)), toPlaces: 2))
            let formatted = String(format: "%.2f", tempNum)
            temp.append(formatted)
        }
        priceString = temp
        //print(priceString)
    }
    
    
    private func round(toRound num:Double,toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (num * divisor).rounded() / divisor
        
    }
    
    func setPrice(amount: Double){
        magnitude = getLength(amount)-1
        priceBase = amount * pow(10, Double(magnitude) * -1.0)
        valueUpdated()
    }
    
    func setPrice(base: Double, mag: Int){
        magnitude = mag
        priceBase = base
        valueUpdated()
    }
    static func *=( lhs: inout Price, rhs: Price){
        lhs.magnitude = lhs.magnitude + rhs.magnitude
        lhs.priceBase = lhs.priceBase * rhs.priceBase
        while(lhs.priceBase >= 10){
            lhs.priceBase /= 10
            lhs.magnitude += 1
        }
        lhs.valueUpdated()
    }
    
    static func *=( lhs: inout Price, rhs: Double){
        let tempPrice = Price(rhs)
        lhs.magnitude = lhs.magnitude + tempPrice.magnitude
        lhs.priceBase = lhs.priceBase * tempPrice.priceBase
        while(lhs.priceBase >= 10){
            lhs.priceBase /= 10
            lhs.magnitude += 1
        }
        lhs.valueUpdated()
    }
    
    static func /=( lhs: inout Price, rhs: Price){
        lhs.magnitude = lhs.magnitude - rhs.magnitude
        lhs.priceBase = lhs.priceBase / rhs.priceBase
        while lhs.priceBase <= 0{
            lhs.priceBase *= 10
            lhs.magnitude -= 1
        }
        lhs.valueUpdated()
    }
    
    static func /=( lhs: inout Price, rhs: Double){
        let tempPrice = Price(rhs)
        lhs.magnitude = lhs.magnitude - tempPrice.magnitude
        lhs.priceBase = lhs.priceBase / tempPrice.priceBase
        while lhs.priceBase <= 0{
            lhs.priceBase *= 10
            lhs.magnitude -= 1
        }
        lhs.valueUpdated()
    }
    
    static func +=( lhs: inout Price, rhs: Price){
        while rhs.magnitude < lhs.magnitude{
            rhs.magnitude += 1
            rhs.priceBase /= 10
        }
        while rhs.magnitude > lhs.magnitude{
            rhs.magnitude -= 1
            rhs.priceBase *= 10
        }
        lhs.priceBase += rhs.priceBase
        while lhs.priceBase >= 10{
            lhs.priceBase /= 10
            lhs.magnitude += 1
        }
        while rhs.priceBase < 1 {
            rhs.priceBase *= 10
            rhs.magnitude -= 1
        }
        while rhs.priceBase >= 10 {
            rhs.priceBase /= 10
            rhs.magnitude += 1
        }
        lhs.valueUpdated()
    }
    
    static func +=( lhs: inout Price, rhs: Double){
        let temp = Price(rhs)
        while temp.magnitude < lhs.magnitude{
            temp.magnitude += 1
            temp.priceBase /= 10
        }
        while temp.magnitude > lhs.magnitude{
            temp.magnitude -= 1
            temp.priceBase *= 10
        }
        lhs.priceBase += temp.priceBase
        while lhs.priceBase >= 10{
            lhs.priceBase /= 10
            lhs.magnitude += 1
        }
        while temp.priceBase < 1 {
            temp.priceBase *= 10
            temp.magnitude -= 1
        }
        while temp.priceBase >= 10 {
            temp.priceBase /= 10
            temp.magnitude += 1
        }
        lhs.valueUpdated()
    }
    
    static func -=( lhs: inout Price, rhs: Price){
        while rhs.magnitude < lhs.magnitude{
            rhs.magnitude += 1
            rhs.priceBase /= 10
        }
        while rhs.magnitude > lhs.magnitude{
            rhs.magnitude -= 1
            rhs.priceBase *= 10
        }
        lhs.priceBase -= rhs.priceBase
        while lhs.priceBase < 1{
            lhs.priceBase *= 10
            lhs.magnitude -= 1
            if lhs.magnitude < 0{
                lhs.magnitude = 0
                lhs.priceBase = 0
                break
            }
        }
        while rhs.priceBase < 1 {
            rhs.priceBase *= 10
            rhs.magnitude -= 1
        }
        while rhs.priceBase >= 10 {
            rhs.priceBase /= 10
            rhs.magnitude += 1
        }
        lhs.valueUpdated()
    }
    
    static func -=( lhs: inout Price, rhs: Double){
        let temp = Price(rhs)
        while temp.magnitude < lhs.magnitude{
            temp.magnitude += 1
            temp.priceBase /= 10
        }
        while temp.magnitude > lhs.magnitude{
            temp.magnitude -= 1
            temp.priceBase *= 10
        }
        lhs.priceBase -= temp.priceBase
        while lhs.priceBase >= 10{
            lhs.priceBase *= 10
            lhs.magnitude -= 1
            if lhs.magnitude < 0{
                lhs.magnitude = 0
                lhs.priceBase = 0
                break
            }
        }
        while temp.priceBase < 1 {
            temp.priceBase *= 10
            temp.magnitude -= 1
        }
        while temp.priceBase >= 10 {
            temp.priceBase /= 10
            temp.magnitude += 1
        }
        lhs.valueUpdated()
    }
    
    static func ==( lhs: Price, rhs: Price) -> Bool{
        if lhs.magnitude != rhs.magnitude{
            return false
        }else if lhs.prepForCompare() != rhs.prepForCompare(){
            return false
        }
        return true
    }
    
    static func >=( lhs: Price, rhs: Price) -> Bool{
        if lhs.magnitude < rhs.magnitude{
            return false
        }else if (lhs.magnitude == rhs.magnitude){
            if lhs.priceBase < rhs.priceBase{
                return false
            }
        }
        return true
    }
    
    static func >( lhs: Price, rhs: Price) -> Bool{
        if lhs.magnitude < rhs.magnitude{
            return false
        }else if lhs.magnitude == rhs.magnitude{
            if lhs.priceBase <= rhs.priceBase{
                return false
            }
        }
        return true
    }
    
    static func <=( lhs: Price, rhs: Price) -> Bool{
        if lhs.magnitude > rhs.magnitude{
            return false
        }else if (lhs.magnitude == rhs.magnitude){
            if lhs.priceBase > rhs.priceBase{
                return false
            }
        }
        return true
    }

    static func <( lhs: Price, rhs: Price) -> Bool{
        if lhs.magnitude > rhs.magnitude{
            return false
        }else if (lhs.magnitude == rhs.magnitude){
            if lhs.priceBase >= rhs.priceBase{
                return false
            }
        }
        return true
    }
    
    
    
    private func prepForCompare() -> Double{
        var toRound  = self.priceBase
        toRound *= 10000000
        return toRound.rounded()
    }
    
    private func valueUpdated(){
        self.setMagName()
        self.setString()
    }
    
    func debugPrint(){
       // print("Base", priceBase, "\tMagnitude", magnitude, "\tMag name", magnitudeName, "\tAbr", magnitudeAbr, "\tString:", priceString)
        //print("String:", priceString, "\t\tnum:", priceBase * pow(Double(10), Double(magnitude)))
        print("Base:", priceBase, "Mag:", magnitude)
    }
}

extension Double {
    func removeZerosFromEnd() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 16 //maximum digits in Double after dot (maximum precision)
        return String(formatter.string(from: number) ?? "")
    }
}
