//: Playground - noun: a place where people can play

import UIKit

class User {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

class Search {
    
    static func userName(keyword: String, users: [User], completion: (Bool) -> () ) {
        var found = false
        
        for user in users {
            if user.name == keyword {
                found = true
            }
        }
        
        return completion(found)
    }
}

var players = [User]()

var player1 = User(name: "Wirawan")
var player2 = User(name: "Ken")

players.append(player1)
players.append(player2)

Search.userName("Wirawan", users: players) { (found: Bool) -> () in
    if found {
        println("in the list")
    } else {
        println("not in the list")
    }
}

