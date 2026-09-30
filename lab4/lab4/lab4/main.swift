//
//  main.swift
//  lab4
//
//  Created by Райымбек Омаров on 30.09.2026.
//

import Foundation

print("Hello, World!")



// =============================================================
//  Station ALMA-7, Part II: The Teleporter Incident
//  iOS Mobile Development · Module 4 · Lab Assignment
//
//  How to use:
//   • Xcode: File → New → Playground → Blank, replace everything
//     with this file's contents.
//   • Terminal: swift ALMA7_Part2_Starter.swift
//
//  Rules:
//   • Do NOT modify the STARTER DATA section.
//   • `!` (force unwrap) is forbidden: −0.5 points each.
//   • No map / filter / reduce / compactMap.
//   • Default to struct. Use class only where the task says so.
// =============================================================


// MARK: - =================== STARTER DATA ===================
// MARK: - Do not modify anything in this section

/// Splits a line into fields.
/// fields("crate:101:120")            -> ["crate", "101", "120"]
/// fields("livestock:lab mice:12:2")  -> ["livestock", "lab mice", "12", "2"]
/// fields("junk")                     -> ["junk"]
func fields(_ line: String, separatedBy separator: Character = ":") -> [String] {
    var result: [String] = []
    var current = ""
    for character in line {
        if character == separator {
            result.append(current)
            current = ""
        } else {
            current.append(character)
        }
    }
    result.append(current)
    return result
}

/// Cargo manifest as recovered from the damaged recorder.
let rawManifest = [
    "crate:101:120",
    "container:KZ-ALM-7:340",
    "livestock:lab mice:12:2",
    "???-corrupted-line",
    "crate:102:75",
    "container:KZ-ALM-9:410",
    "livestock:ficus:3:5",
    "crate:103:260",
    "crate:104:abc",
    ""
]

/// Oxygen readings. One of these deck names is not a real deck.
let deckReadings: [(deck: String, oxygen: Int)] = [
    (deck: "bridge",     oxygen: 78),
    (deck: "lab",        oxygen: 64),
    (deck: "greenhouse", oxygen: 55),
    (deck: "cargo",      oxygen: 12),
    (deck: "medbay",     oxygen: 90),
    (deck: "engine",     oxygen: 41)
]

/// Crew records, straight from the personnel file.
let crewData: [(name: String, deck: String, oxygen: Int)] = [
    (name: "Timur",   deck: "engine", oxygen: 62),
    (name: "Dana",    deck: "lab",    oxygen: 48),
    (name: "Aigerim", deck: "bridge", oxygen: 91),
    (name: "Nurlan",  deck: "cargo",  oxygen: 17)
]

print("ALMA-7 recorder online: \(rawManifest.count) manifest lines, \(deckReadings.count) readings, \(crewData.count) crew records.")

// MARK: - ================= END OF STARTER DATA =================


// MARK: - =================== YOUR SOLUTION ===================
// Uncomment each declaration when you start working on it.


// MARK: Level 1 · The Deck Register

// 1.1
 enum Deck: String, CaseIterable {
     case bridge , lab , cargo , medbay, engine
     
     var evacuationPriority: Int {
         switch self {
         case .bridge :
             return 1
         case  .medbay :
             return 2
         case .lab :
             return 3
         case .engine :
             return 4
         case .cargo :
             return 5
         }
     }
 }

// 1.2
 enum AlarmLevel: Int {
      case green = 0
     case yellow
     case orange
     case red
     static func level(forTotalMass mass: Int) -> AlarmLevel {
         let prop = mass / 500
         return AlarmLevel(rawValue: min(prop,3)) ?? .red
         
       
     }
 }


print(AlarmLevel.level(forTotalMass: 0))// green
print(AlarmLevel.level(forTotalMass: 940))// yellow
print(AlarmLevel.level(forTotalMass: 4000)) // red

// MARK: Level 2 · The Manifest

// 2.1
 enum ManifestEntry {
     
     case crate(id: Int, massKg: Int)
     case container(code: String, massKg: Int)
     case livestock(species: String, count: Int, massPerUnitKg: Int)
     case unknown(raw: String)
 }

// 2.2
 func parseEntry(_ line: String) -> ManifestEntry {
     let h = line.split(separator: ":")
     if h.isEmpty {
         return ManifestEntry.unknown(raw: line)
     }
     switch h[0]{
     case "crate":
         if let jj  = Int(h[2]) {
             return ManifestEntry.crate(id: Int(h[1])!, massKg: jj)
         } else {
             fallthrough
         }
     case "container":
         if let jj = Int(h[2]) {
             return ManifestEntry.container(code: String(h[1]), massKg:  jj)
         } else {
             fallthrough
         }
     case "livestock" :
         if let hh = Int(h[2]) , let jj = Int(h[3]) {
             return ManifestEntry.livestock(species:  String(h[1]), count:  hh, massPerUnitKg:  jj)
         }else {
             fallthrough
         }
         
     default:
         return ManifestEntry.unknown(raw: line)
     }
 }

// 2.3
 func mass(of entry: ManifestEntry) -> Int {
     switch entry {
     case .container(code: _, massKg: let ret) :
         return ret
     case .crate(id: _, massKg: let ret) :
         return ret
     case .livestock(species: _, count: let count, massPerUnitKg: let perunit):
         return count * perunit
     case .unknown(raw: _) :
         return 0
     }
 }
var A = 0
var numberOfUnknown = 0
let ans = rawManifest.map({parseEntry($0)}).map({mass(of: $0)}).forEach({if $0 == 0 {numberOfUnknown += 1  };A += $0})

print( "A" , A)
print("Number of uknown " , numberOfUnknown)


// MARK: Level 3 · Crew Snapshots

// 3.1
struct CrewSnapshot {
let name: String
var deck: Deck
var oxygen: Int
    
    
    mutating func breathe(
        amount: Int)  {
            oxygen -= amount
            oxygen = max(0 , oxygen)
        }
    mutating func move(to deck: Deck) {
        self.deck = deck
    }
    mutating func reviveInMedbay() {
        self = CrewSnapshot(name: "patient", deck: .medbay , oxygen: 100)
    }
    
    mutating func checkInOut(new : inout CrewSnapshot){
        self = new
    }
    static func rookie(named name: String) -> CrewSnapshot  {
        return CrewSnapshot(name: name, deck: .bridge, oxygen: 100)
    }
}


// 3.2
//enum CrewError :Error  {
//    case warning( warning : String)
//
//}
var crewRoster: [CrewSnapshot] = []
crewData.forEach{
    if let deckCheck = Deck(rawValue: $0.deck) {
        crewRoster.append(CrewSnapshot(name: $0.name, deck: deckCheck , oxygen: $0.oxygen))
        
    } else {
       // throw CrewError.warning(warning: $0.deck)
        print("warning")
    }
    }

print(crewRoster)

// 3.3 · Value-semantics demonstration (copy / plain parameter / inout)
//1
var orig = CrewSnapshot(name: "check", deck: .bridge, oxygen: 100)
print(orig)
var modif = orig
print("before")
print("orig" , orig)
print("modif" , modif)
modif.breathe(amount: 10)
print("after")
print("orig" , orig)
print("modif" , modif)
print()
print("before")
//2
modif.move(to: .cargo)
print("orig" , orig)
print("after")
print("orig" , orig)
print("modif" , modif)

var newone = CrewSnapshot.rookie(named: "newone")
print(newone)

print("lets check inout")
print(modif)
print(newone)
modif.checkInOut(new: &newone)
print(modif)
print(newone)
newone.breathe(amount:  5)
print("changes apply to orig")
print(modif)
print(newone)



// MARK: Level 4 · The Teleport Pod

// 4.1
final class TeleportPod {
let id: String
var chargeLevel: Int
var occupant: CrewSnapshot?
    init(id: String, chargeLevel: Int, occupant: CrewSnapshot? = nil) {
        self.id = id
        self.chargeLevel = chargeLevel
        self.occupant = occupant
    }
    
    deinit {
        print("deinit" , id)
    }
    
    func load(
        crew: CrewSnapshot) -> Bool {
            if self.occupant !=  nil  || chargeLevel < 20 { return false}
            self.occupant = crew
            return true
            
        }
    func fire() -> CrewSnapshot?{
       let occupantRet  = occupant
        occupant = nil
        chargeLevel -= 20
        return occupant
    } // fails if the pod is occupied or charge < 20
    // no occupant -> nil, and no charge is spent
}
let telepod = TeleportPod(id: "P-1"
                          , chargeLevel: 100)
// 4.3 · Reference-semantics demonstration
var h = telepod
print(telepod.load(crew: crewRoster.first(where: {$0.name == "Timur"})!))
print(telepod.fire())

print(h.load(crew: crewRoster.first(where: {$0.name == "Dana"})!))
print(telepod.fire())

print(telepod.load(crew: crewRoster.first(where: {$0.name == "Nurlan"})!))
print(telepod.fire())


// 4.2 · Charge ledger: load+fire three times, then fire an empty pod
let C = telepod.chargeLevel
print(C)




// MARK: Level 5 · Station Systems

// 5.1
 final class Station {
     let callSign: String
     var hullIntegrity: Int = 100 {
         willSet {
             print("Hull changing from \(hullIntegrity) to \(newValue)")
         }
         didSet {
             if hullIntegrity > 100 { hullIntegrity = 100 }
             if hullIntegrity < 0   { hullIntegrity = 0 }
         }
     }
     lazy var fullDiagnostics: String = {
         print("Running full scan...")
         return "\(callSign): hull \(hullIntegrity)%, O2 total \(totalOxygen), avg \(averageOxygen)"
     }()
     var totalOxygen: Int {
         oxygenByDeck.values.reduce(0, +)
     }
     var averageOxygen: Int {
         get {
             oxygenByDeck.isEmpty ? 0 : totalOxygen / oxygenByDeck.count
         }
         set {
             for deck in oxygenByDeck.keys {
                 oxygenByDeck[deck] = newValue
             }
         }
     }
     
     init(callSign: String, hullIntegrity: Int,oxygenByDeck : [Deck :Int]) {
         self.callSign = callSign
         self.hullIntegrity = hullIntegrity
         self.oxygenByDeck = deckReadings.reduce(into: [:]) { result, reading in
                 result[Deck(rawValue: reading.deck) ?? .bridge] = reading.oxygen
             }
     }
     var oxygenByDeck: [Deck: Int] = [:]
     
    static func checkObj( h :  Station , j : Station) -> Bool {
         return(h===j)
     }
  
  }

let B = Station(callSign: "123", hullIntegrity: 123, oxygenByDeck: [.bridge : 23, .cargo : 2])

// 5.2 · The clamp trap: 130, then -40, then 55

B.hullIntegrity = 130
print(B.hullIntegrity)


// MARK: Level 6 · Incident Reports
// Three of these compile and are wrong. One does not compile.
// For each: expectation, actual behaviour, the language rule, the fix.


// Report 1
var roster = crewRoster
for  member in roster.indices {
    roster[member].oxygen -= 10
}
//roster.forEach({$0.oxygen - 10})
print(roster[0].oxygen)   // author expected the crew to have lost oxygen

// Report 2
let podA = TeleportPod(id: "A", chargeLevel: 100)
let podB = TeleportPod(id: "A", chargeLevel: 100)
podB.chargeLevel = 0
print(podA.chargeLevel)   // author expected 100

// Report 3
struct Logbook {
    var entries: [String] = []
    mutating func add(_ entry: String) {
        entries.append(entry)
    }
}

// Report 4
var snapshot = CrewSnapshot.rookie(named: "Dana")
snapshot.oxygen = 40

var pod = TeleportPod(id: "B", chargeLevel: 50)
pod.chargeLevel = 10



// MARK: Level 7 · Sealing the Black Box

// The leaky original:
//
 class FlightRecorder {
     var entries: [String] = []
     var isSealed = false
 }
//
// Your sealed version below. One comment per access keyword.

 final class FlightRecorder2 {
     var entries: [String] = [] {
         didSet {
             if !entries.contains(oldValue) || isSealed == true {
                entries = oldValue
             }
         }
         
     }
     private(set) var isSealed = false {
         didSet {
             if oldValue == true {
                 isSealed = oldValue
             }
         }
     }
 }

// A free function elsewhere in the file that uses your fileprivate helper:
// func auditTranscript(of recorder: FlightRecorder) -> String { }


// MARK: Finale · Integrity Code

let D = AlarmLevel.level(forTotalMass: A)
 let integrityCode = "\(A)-\(B)-\(C)-\(D)"
 print("INTEGRITY CODE: \(integrityCode)")


// MARK: Bonus

// deinit in TeleportPod, a do-block lifetime experiment, and === identity

do {
    let g = TeleportPod(id: "1", chargeLevel: 2)
    let b = g
}

let s1 = Station(callSign: "1", hullIntegrity: 2, oxygenByDeck: [Deck.bridge: 2])
let s11 = s1
let s2 = Station(callSign: "1", hullIntegrity: 2, oxygenByDeck: [Deck.bridge: 2])
print(Station.checkObj(h: s1, j: s2))
print(Station.checkObj(h: s11, j: s1))
// MARK: - ================= DEFENSE QUESTIONS =================
/*
 1. Why did CrewSnapshot get an initializer for free and TeleportPod did not?

 2. What does `mutating` do to self, and why do classes never need it?

 3. In Report 4 both values are `let`. What exactly does `let` freeze for a
    struct, and what does it freeze for a class?

 4. Why must a lazy property be var? When does lazy change behaviour, not
    just performance?

 5. private vs fileprivate: where in your FlightRecorder would private be
    too strict?

 Bonus. On which line does deinit fire, and why can't === be used on
 CrewSnapshot?

*/
