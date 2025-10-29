//
//  MacEventsTests.swift
//  MacEventsTests
//
//  Created by Iren Sanchez on 3/14/25.
//

import Testing
import Foundation
@testable import MacEvents

struct MacEventsTests {

    @Test func testAdd(){
        #expect(add(2, 3)==5)
    }
    
    // This test verifies the correct date formatting by the formatDate method within the Event struct
    @Test func testEventFormatDate(){
        //Verify that ev's date format is" EEEE, MMMM dd, yyyy"
        let ev = Event(id: "7", title: "Play", location: "Campus Center", date: "Wednesday, March 03, 2025", description: "", link: "");
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy"
        let parsedDate = dateFormatter.date(from: ev.date)
        #expect(ev.formatDate()==parsedDate)
        
        //Verify that secondEv's date format is not "MMMM dd, yyyy"
        let secondEv = Event(id: "7", title: "Play", location: "Campus Center", date: "Friday, March 05, 2025", description: "ll", link: "");
        let wrongDateFormatter = DateFormatter()
        wrongDateFormatter.dateFormat = "MMMM dd, yyyy"
        let secondParsedDate = wrongDateFormatter.date(from: secondEv.date)
        #expect(ev.formatDate() != secondParsedDate)
    }
    
    

}
