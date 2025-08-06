//
//  IntentHandler.swift
//  OpenStatusReportIntent
//
//  Created by Navas Farhan on 5/8/25.
//

import Intents

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        guard intent is OpenStatusReportIntent else {
            fatalError("Unhandled Intent error: \(intent)")
        }
        
        return OpenStatusReportHandler()
    }
}

class OpenStatusReportHandler: NSObject, OpenStatusReportIntentHandling {
    func handle(intent: OpenStatusReportIntent, completion: @escaping (OpenStatusReportIntentResponse) -> Void) {
        let activity = NSUserActivity(activityType: "com.example.monday.openStatusReport")
        activity.title = "Open Status Report"
        
        if let url = URL(string: "monday://tasks") {
            activity.webpageURL = url
        }
        
        let response = OpenStatusReportIntentResponse(
            code: .success, userActivity: activity
        )
        
        completion(response)
    }
}
