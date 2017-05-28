//
//  DAOTests.swift
//  Yourself
//
//  Created by Tri Dao on 5/28/17.
//  Copyright © 2017 Yourself. All rights reserved.
//

import XCTest
@testable import Yourself

class DAOTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDAOJars() {
        // Delete all
        XCTAssertTrue(DAOJars.BUILDER.DeleteAll())
        
        // Add
        XCTAssertTrue(DAOJars.BUILDER.Add(jars: DTOJars(type: JARS_TYPE.EDU, money: 1)))
        XCTAssertTrue(DAOJars.BUILDER.Add(jars: DTOJars(type: JARS_TYPE.FFA, money: 2)))
        XCTAssertTrue(DAOJars.BUILDER.Add(jars: DTOJars(type: JARS_TYPE.GIVE, money: 3)))
        XCTAssertTrue(DAOJars.BUILDER.Add(jars: DTOJars(type: JARS_TYPE.LTSS, money: 4)))
        XCTAssertTrue(DAOJars.BUILDER.Add(jars: DTOJars(type: JARS_TYPE.NEC, money: 5)))
        XCTAssertTrue(DAOJars.BUILDER.Add(jars: DTOJars(type: JARS_TYPE.PLAY, money: 10)))
        // Add again
        XCTAssertFalse(DAOJars.BUILDER.Add(jars: DTOJars(type: JARS_TYPE.EDU, money: 1)))
        XCTAssertFalse(DAOJars.BUILDER.Add(jars: DTOJars(type: JARS_TYPE.FFA, money: 2)))
        XCTAssertFalse(DAOJars.BUILDER.Add(jars: DTOJars(type: JARS_TYPE.GIVE, money: 3)))
        XCTAssertFalse(DAOJars.BUILDER.Add(jars: DTOJars(type: JARS_TYPE.LTSS, money: 4)))
        XCTAssertFalse(DAOJars.BUILDER.Add(jars: DTOJars(type: JARS_TYPE.NEC, money: 5)))
        XCTAssertFalse(DAOJars.BUILDER.Add(jars: DTOJars(type: JARS_TYPE.PLAY, money: 10)))
        // Get
        XCTAssertEqual(DAOJars.BUILDER.GetJARS(with: JARS_TYPE.EDU)!.money, 1)
        XCTAssertEqual(DAOJars.BUILDER.GetJARS(with: JARS_TYPE.FFA)!.money, 2)
        XCTAssertEqual(DAOJars.BUILDER.GetJARS(with: JARS_TYPE.GIVE)!.money, 3)
        XCTAssertEqual(DAOJars.BUILDER.GetJARS(with: JARS_TYPE.LTSS)!.money, 4)
        XCTAssertEqual(DAOJars.BUILDER.GetJARS(with: JARS_TYPE.NEC)!.money, 5)
        XCTAssertEqual(DAOJars.BUILDER.GetJARS(with: JARS_TYPE.PLAY)!.money, 10)
        // Update money
        XCTAssertTrue(DAOJars.BUILDER.UpdateMoney(type: JARS_TYPE.EDU, money: 10))
        XCTAssertTrue(DAOJars.BUILDER.UpdateMoney(type: JARS_TYPE.FFA, money: 20))
        XCTAssertTrue(DAOJars.BUILDER.UpdateMoney(type: JARS_TYPE.GIVE, money: 30))
        XCTAssertTrue(DAOJars.BUILDER.UpdateMoney(type: JARS_TYPE.LTSS, money: 40))
        XCTAssertTrue(DAOJars.BUILDER.UpdateMoney(type: JARS_TYPE.NEC, money: 50))
        XCTAssertTrue(DAOJars.BUILDER.UpdateMoney(type: JARS_TYPE.PLAY, money: 100))
        // Update percent
        XCTAssertTrue(DAOJars.BUILDER.UpdatePercent(type: JARS_TYPE.EDU, percent: 0.1))
        XCTAssertTrue(DAOJars.BUILDER.UpdatePercent(type: JARS_TYPE.FFA, percent: 0.2))
        XCTAssertTrue(DAOJars.BUILDER.UpdatePercent(type: JARS_TYPE.GIVE, percent: 0.55))
        XCTAssertTrue(DAOJars.BUILDER.UpdatePercent(type: JARS_TYPE.LTSS, percent: 0.3))
        XCTAssertTrue(DAOJars.BUILDER.UpdatePercent(type: JARS_TYPE.NEC, percent: 0.4))
        XCTAssertTrue(DAOJars.BUILDER.UpdatePercent(type: JARS_TYPE.PLAY, percent: 0.5))
        // Get money after updating
        XCTAssertEqual(DAOJars.BUILDER.GetJARS(with: JARS_TYPE.EDU)!.money, 10)
        XCTAssertEqual(DAOJars.BUILDER.GetJARS(with: JARS_TYPE.FFA)!.money, 20)
        XCTAssertEqual(DAOJars.BUILDER.GetJARS(with: JARS_TYPE.GIVE)!.money, 30)
        XCTAssertEqual(DAOJars.BUILDER.GetJARS(with: JARS_TYPE.LTSS)!.money, 40)
        XCTAssertEqual(DAOJars.BUILDER.GetJARS(with: JARS_TYPE.NEC)!.money, 50)
        XCTAssertEqual(DAOJars.BUILDER.GetJARS(with: JARS_TYPE.PLAY)!.money, 100)
        // Get percent after updating
        XCTAssertEqual(Int(DAOJars.BUILDER.GetJARS(with: JARS_TYPE.EDU)!.percent * 100), 10)
        XCTAssertEqual(Int(DAOJars.BUILDER.GetJARS(with: JARS_TYPE.FFA)!.percent * 100), 20)
        XCTAssertEqual(Int(DAOJars.BUILDER.GetJARS(with: JARS_TYPE.GIVE)!.percent * 100), 55)
        XCTAssertEqual(Int(DAOJars.BUILDER.GetJARS(with: JARS_TYPE.LTSS)!.percent * 100), 30)
        XCTAssertEqual(Int(DAOJars.BUILDER.GetJARS(with: JARS_TYPE.NEC)!.percent * 100), 40)
        XCTAssertEqual(Int(DAOJars.BUILDER.GetJARS(with: JARS_TYPE.PLAY)!.percent * 100), 50)
        // Get all
        let allInfo = DAOJars.BUILDER.GetAll()
        XCTAssertEqual(allInfo.count, 6)
        for info in allInfo {
            // Get money
            XCTAssertEqual(DAOJars.BUILDER.GetJARS(with: info.type)!.money, info.money)
            // Get percent
            XCTAssertEqual(Int(DAOJars.BUILDER.GetJARS(with: info.type)!.percent * 100), Int(info.percent * 100))
        }
        
        // Delete
        XCTAssertTrue(DAOJars.BUILDER.Delete(type: JARS_TYPE.NEC))
        XCTAssertNil(DAOJars.BUILDER.GetJARS(with: JARS_TYPE.NEC))
        
        // Delete all
        XCTAssertTrue(DAOJars.BUILDER.DeleteAll())
    }
    
    func testDAOIntent() {
        // Delete all
        XCTAssertTrue(DAOIntent.BUILDER.DeleteAll())
        
        // Add
        XCTAssertTrue(DAOIntent.BUILDER.Add(intent: DTOIntent(timestamp: 1412573, type: JARS_TYPE.EDU, content: "ABCXYZ", money: 125000)))
        XCTAssertTrue(DAOIntent.BUILDER.Add(intent: DTOIntent(timestamp: 1412591, type: JARS_TYPE.GIVE, content: "DEFGHJK", money: 225000)))
        // Add again
        XCTAssertFalse(DAOIntent.BUILDER.Add(intent: DTOIntent(timestamp: 1412573, type: JARS_TYPE.EDU, content: "ABCXYZ", money: 125000)))
        // Get
        var intent = DAOIntent.BUILDER.GetIntent(with: 1412573)!
        XCTAssertEqual(intent.type, JARS_TYPE.EDU)
        XCTAssertEqual(intent.content, "ABCXYZ")
        XCTAssertEqual(intent.money, 125000)
        intent = DAOIntent.BUILDER.GetIntent(with: 1412591)!
        XCTAssertEqual(intent.type, JARS_TYPE.GIVE)
        XCTAssertEqual(intent.content, "DEFGHJK")
        XCTAssertEqual(intent.money, 225000)
        // Update
        intent.money = 550000
        XCTAssertTrue(DAOIntent.BUILDER.Update(intent: intent))
        intent = DAOIntent.BUILDER.GetIntent(with: 1412591)!
        XCTAssertEqual(intent.type, JARS_TYPE.GIVE)
        XCTAssertEqual(intent.content, "DEFGHJK")
        XCTAssertEqual(intent.money, 550000)
        // Get all
        let allInfo = DAOIntent.BUILDER.GetAll()
        XCTAssertEqual(allInfo.count, 2)
        for info in allInfo {
            XCTAssertEqual(DAOIntent.BUILDER.GetIntent(with: info.timestamp)!.type, info.type)
            XCTAssertEqual(DAOIntent.BUILDER.GetIntent(with: info.timestamp)!.content, info.content)
            XCTAssertEqual(DAOIntent.BUILDER.GetIntent(with: info.timestamp)!.money, info.money)
        }
        
        // Delete
        XCTAssertTrue(DAOIntent.BUILDER.Delete(timestamp: 1412573))
        XCTAssertNil(DAOIntent.BUILDER.GetIntent(with: 1412573))
        
        // Delete all
        XCTAssertTrue(DAOIntent.BUILDER.DeleteAll())
    }
    
    func testDAOAlternatives() {
        // Delete all
        XCTAssertTrue(DAOAlternatives.BUILDER.DeleteAll())
        
        // Add
        XCTAssertTrue(DAOAlternatives.BUILDER.Add(alts: DTOAlternatives(timestamp: 1412573, owner: JARS_TYPE.GIVE, alts: JARS_TYPE.FFA, money: 125680)))
        XCTAssertTrue(DAOAlternatives.BUILDER.Add(alts: DTOAlternatives(timestamp: 123456, owner: JARS_TYPE.FFA, alts: JARS_TYPE.EDU, money: 1250000)))
        // Add again
        XCTAssertFalse(DAOAlternatives.BUILDER.Add(alts: DTOAlternatives(timestamp: 1412573, owner: JARS_TYPE.GIVE, alts: JARS_TYPE.FFA, money: 125680)))
        // Get
        var alts = DAOAlternatives.BUILDER.GetAlternative(with: 1412573)!
        XCTAssertEqual(alts.owner, JARS_TYPE.GIVE)
        XCTAssertEqual(alts.alts, JARS_TYPE.FFA)
        XCTAssertEqual(alts.money, 125680)
        // Update
        alts = DAOAlternatives.BUILDER.GetAlternative(with: 123456)!
        alts.money = 250000
        _ = DAOAlternatives.BUILDER.Update(alts: alts)
        alts = DAOAlternatives.BUILDER.GetAlternative(with: 123456)!
        XCTAssertEqual(alts.owner, JARS_TYPE.FFA)
        XCTAssertEqual(alts.alts, JARS_TYPE.EDU)
        XCTAssertEqual(alts.money, 250000)
        // Get all
        let allInfo = DAOAlternatives.BUILDER.GetAll()
        XCTAssertEqual(allInfo.count, 2)
        for info in allInfo {
            XCTAssertEqual(DAOAlternatives.BUILDER.GetAlternative(with: info.timestamp)!.owner, info.owner)
            XCTAssertEqual(DAOAlternatives.BUILDER.GetAlternative(with: info.timestamp)!.alts, info.alts)
            XCTAssertEqual(DAOAlternatives.BUILDER.GetAlternative(with: info.timestamp)!.money, info.money)
        }
        // Delete
        XCTAssertTrue(DAOAlternatives.BUILDER.Delete(timestamp: 123456))
        XCTAssertNil(DAOAlternatives.BUILDER.GetAlternative(with: 123456))
        
        // Delete all
        XCTAssertTrue(DAOAlternatives.BUILDER.DeleteAll())
    }
    
    func testDAOTime() {
        // Delete all
        XCTAssertTrue(DAOTime.BUILDER.DeleteAll())
        
        // Add
        XCTAssertTrue(DAOTime.BUILDER.Add(time: DTOTime(id: 1412573, content: "ABCXYZ", startTime: 123456, appointment: 7891011, finishTime: 12131415, state: TAG_STATE.DONE, tag: TAG.FOOD)))
        XCTAssertTrue(DAOTime.BUILDER.Add(time: DTOTime(id: 1412591, content: "DEFGHJ", startTime: 012, appointment: 234, finishTime: 5678, state: TAG_STATE.NOT_YET, tag: TAG.OTHERS)))
        // Add again
        XCTAssertFalse(DAOTime.BUILDER.Add(time: DTOTime(id: 1412573, content: "ABCXYZ", startTime: 123456, appointment: 7891011, finishTime: 12131415, state: TAG_STATE.DONE, tag: TAG.FOOD)))
        // Get
        let time = DAOTime.BUILDER.GetTime(with: 1412573)!
        XCTAssertEqual(time.startTime, 123456)
        XCTAssertEqual(time.appointment, 7891011)
        XCTAssertEqual(time.finishTime, 12131415)
        XCTAssertEqual(time.state, TAG_STATE.DONE)
        XCTAssertEqual(time.tag, TAG.FOOD)
        // Update
        time.state = TAG_STATE.DOING
        _ = DAOTime.BUILDER.Update(time: time)
        XCTAssertEqual(time.startTime, 123456)
        XCTAssertEqual(time.appointment, 7891011)
        XCTAssertEqual(time.finishTime, 12131415)
        XCTAssertEqual(time.state, TAG_STATE.DOING)
        XCTAssertEqual(time.tag, TAG.FOOD)
        // Get all
        let allInfo = DAOTime.BUILDER.GetAll()
        XCTAssertEqual(allInfo.count, 2)
        for info in allInfo {
            XCTAssertEqual(DAOTime.BUILDER.GetTime(with: info.id)!.startTime, info.startTime)
            XCTAssertEqual(DAOTime.BUILDER.GetTime(with: info.id)!.appointment, info.appointment)
            XCTAssertEqual(DAOTime.BUILDER.GetTime(with: info.id)!.finishTime, info.finishTime)
            XCTAssertEqual(DAOTime.BUILDER.GetTime(with: info.id)!.state, info.state)
            XCTAssertEqual(DAOTime.BUILDER.GetTime(with: info.id)!.tag, info.tag)
        }
        
        // Delete all
        XCTAssertTrue(DAOTime.BUILDER.DeleteAll())
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
