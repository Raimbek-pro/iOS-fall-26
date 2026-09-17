// =============================================================
//  Station ALMA-7: Rescue Protocol
//  iOS Mobile Development · Module 3 · Lab Assignment
//
//  How to use:
//   • Xcode: File → New → Playground → Blank, replace everything
//     with this file's contents.
//   • Terminal: swift ALMA7_Starter.swift
//
//  Rules:
//   • Do NOT modify the STARTER CODE section.
//   • `!` (force unwrap) is forbidden: −0.5 points each.
//   • No map / filter / reduce / compactMap.
//   • Use the exact function names from the assignment PDF.
// =============================================================


// MARK: - =================== STARTER CODE ===================
// MARK: - Do not modify anything in this section

typealias Reading = (sensor: String, value: Int)

/// Splits a string at the first occurrence of the separator.
/// splitOnce("O2:87", by: ":") -> ("O2", "87")
/// splitOnce("hello", by: ":") -> nil
func splitOnce(_ line: String, by separator: Character) -> (String, String)? {
    guard let index = line.firstIndex(of: separator) else { return nil }
    let left = String(line[..<index])
    let right = String(line[line.index(after: index)...])
    return (left, right)
}

let rawLog = [
    "O2:87", "TEMP:-12", "O2:9x", "PRESS:101", "TEMP:abc", "O2:",
    "RAD:3", "O2:64", ":55", "TEMP:31", "PRESS:98", "O2:71",
    "RAD:-1", "TEMP:4", "PRESS:1o2", "O2:90"
]

class Tank {
    var level: Int
    init(level: Int) { self.level = level }
}

class Module {
    let name: String
    var oxygenTank: Tank?
    init(name: String, oxygenTank: Tank?) {
        self.name = name
        self.oxygenTank = oxygenTank
    }
}

class CrewMember {
    let name: String
    let role: String
    let priority: Int      // 1 = evacuated first
    var module: Module?    // nil = in open space
    init(name: String, role: String, priority: Int, module: Module?) {
        self.name = name
        self.role = role
        self.priority = priority
        self.module = module
    }
}

let lab  = Module(name: "Lab",  oxygenTank: Tank(level: 40))
let hab  = Module(name: "Hab",  oxygenTank: Tank(level: 12))
let dock = Module(name: "Dock", oxygenTank: nil)

let crew = [
    CrewMember(name: "Timur",   role: "Engineer",  priority: 3, module: lab),
    CrewMember(name: "Dana",    role: "Scientist", priority: 4, module: dock),
    CrewMember(name: "Aigerim", role: "Commander", priority: 1, module: hab),
    CrewMember(name: "Nurlan",  role: "Pilot",     priority: 2, module: nil)
]

var roster: [String: CrewMember] = [:]
for member in crew { roster[member.name] = member }

print("ALMA-7 systems online: \(rawLog.count) log lines, \(crew.count) crew members.")

// MARK: - ================= END OF STARTER CODE =================


// MARK: - =================== YOUR SOLUTION ===================
// Uncomment each signature when you start working on it.


// MARK: Level 1 · Decoding Telemetry

// 1.1
@discardableResult
 func parseReading(_ raw: String) -> Reading? {
     var name = ""
     var value = ""
     var been = false
     raw.forEach({ if ($0 != ":" && been == false ) {
         name.append($0)
     } else {
         been = true
         value.append($0)
     }
     })
     if !value.isEmpty{
         value.removeFirst()
     }
  
     guard let val = Int(value) , val > 0 || name == "TEMP" , !name.isEmpty else { return nil}
     print((sensor : name , value : val ))
     return (sensor : name , value : val )
 }
parseReading("O2:87") // (sensor: "O2"
parseReading("TEMP:-12") // (sensor: "TEMP"
parseReading("RAD:-1") // nil
parseReading(":55") // nil

// 1.2
 func parseLog(_ lines: [String]) -> (valid: [Reading], invalidCount: Int) {
     var valid  : [Reading] = []
     var invC = 0
     for i in lines {
         if let new = parseReading(i) {
             valid.append(new)
         } else {
             invC += 1
         }
     }
     return (valid : valid ,invalidCount :  invC)
     
 }
let logA = parseLog(rawLog)
let A = logA.invalidCount
print(A)


// MARK: Level 2 · Analysis

// 2.1
 func select(_ readings: [Reading], where isIncluded: (Reading) -> Bool) -> [Reading] {
     var newone : [Reading] = []
     readings.forEach({
         if  isIncluded($0) == true {
             newone.append($0)
         }
       
         
     })
     return newone
 }
 func values(of readings: [Reading]) -> [Int] {
     var arr : [Int] = []
     readings.forEach({
         arr.append($0.value)
     })
     return arr
 }

var sel02 = select(logA.valid, where: {
    $0.sensor == "O2"
})
var sel02vals = values(of: sel02)

print(sel02vals)


// 2.2
 func stats(of values: [Int]) -> (min: Int, max: Int, average: Double)? {
     var ourMin = Int.max
     var ourMax = -Int.max
     var sum = 0
     for i in values {
         if i < ourMin {
             ourMin = i
         }
         if i > ourMax {
             ourMax = i
         }
         sum += i
         
     }
//     var c = values.count
     if values.count == 0{
         return nil
     }
  
     
     return (min : ourMin , max : ourMax , average : Double(sum / values.count) )
     
    
 }
 func stats(_ values: Int...) -> (min: Int, max: Int, average: Double)? { stats(of: values) }

print(stats())
var statis = stats(of: sel02vals)
let B = Int(stats(of: sel02vals)!.average)





// 2.3 · The Closure Ladder (5 sorts, then compare results in code)

//1. Full:
sel02vals.sort(by: {  (lhs: Int , rhs : Int) -> Bool in
    return lhs < rhs
})
//2. Infer types:
sel02vals.sort(by: { lhs, rhs in
    return lhs < rhs
})
//3. Implicit return:
sel02vals.sort(by: { lhs, rhs in
    lhs < rhs
})
//4. Shorthand arguments:
sel02vals.sort(by: {
    $0 < $1
})

//5. Trailing closure:
sel02vals.sort {
    $0 < $1
}

// MARK: Level 3 · Temperature Stabilization

// 3.1
 func heatUp(_ t: Int) -> Int {
     t + 5
 }
 func coolDown(_ t: Int) -> Int { t - 3 }
 func hold(_ t: Int) -> Int { t }
 func chooseProtocol(for temp: Int) -> (Int) -> Int {
     switch temp {
     case ...18 :
         return heatUp(_:)
     case 24... :
         return coolDown(_:)
     default :
         return hold(_:)
     }
 }



// 3.2
 func runUntilStable(from start: Int, maxSteps: Int = 10) -> (finalTemp: Int, steps: Int, isStable: Bool) {
     var g = start
     var n = 0
     var steps = 0
     var isStab = false
     while true{
         n = g
        
        var a = chooseProtocol(for: g)
        print(a)
       
         
        g =  a(g)
        if n == g {
             isStab = true
             break
         }
         steps += 1
         if  steps == maxSteps {
             break
         }
        
         
     }
    
     return (finalTemp : g , steps : steps  , isStable : isStab  )
 }

print(runUntilStable(from: 31))
print(runUntilStable(from: -100, maxSteps: 5))
print("A", A)
var  C = 0
if let res = statis?.min {
    C =   runUntilStable(from: res ).steps
}




// MARK: Level 4 · The Crew

// 4.1
 func oxygenLevel(of member: CrewMember) -> Int? {
     member.module?.oxygenTank?.level
 }



// 4.2
 func status(of member: CrewMember) -> String {
     if let mod = member.module {
         if let lev = oxygenLevel(of: member) {
             return "\(member.name): \(lev) \(lev >= 20 ? "OK" : "CRITICAL")"
         } else {
             return  "\(member.name): no data (Dock)"
         }
    
     } else {
         return  "\(member.name): no data (open space)"
     }
     
 }

// 4.3
 @discardableResult
 func transferOxygen(from source: inout Int, to target: inout Int, amount: Int) -> Int {
  //  lab.oxygenTank?.level
     guard amount >= 0 else {
         return 0
     }
     if source >= amount {
         source -= amount
         target += amount
         if target > 100 {
             var ol = target
             target = 100
             return (amount - (ol - 100 ))
         }
         return amount
     }
     
     return 0
 }
print( hab.oxygenTank?.level)
if let source = lab.oxygenTank,

   let target = hab.oxygenTank {

    transferOxygen(from: &source.level, to: &target.level, amount: 30)

}
var D = 0
if let Dres = hab.oxygenTank?.level {
    D = Dres
}
print(D)
// 4.4
 func evacuationOrder(_ names: String..., roster: [String: CrewMember]) -> [String] {

     var newnames =  roster.filter { el in
         names.contains(el.key)
     }
         

     var out = newnames.sorted(by: {
         $0.value.priority <  $1.value.priority
     })
     var output = out.map({$0.key})
     print(output)
     return [""]
 }

print(evacuationOrder("Dana" , "Ghost" , "Aigerim" , "Timur", roster: roster))


// MARK: Level 5 · The Saboteur's Logbook
// The saboteur's code is below, commented out (it needs your
// oxygenLevel(of:) to compile). Comment on every problem, then
// write fixed versions and a test that proves the logic bug is gone.


//func reportOxygen(for member: CrewMember) -> String {
//    let tank = member.module!.oxygenTank!
//    return "\(member.name): \(tank.level)%"
//}
//
//func firstCritical(in crew: [CrewMember]) -> String {
//    var result: String?
//    for member in crew {
//        if oxygenLevel(of: member)! < 20 {
//            result = member.name
//        }
//    }
//    return result!
//}


func reportOxygen(for member: CrewMember) -> String {
    let tank = member.module?.oxygenTank
    return "\(member.name): \(tank?.level)%"
}

func firstCritical(in crew: [CrewMember]) -> String {
    var result: String?
    for member in crew {
        if let lev = oxygenLevel(of: member)  {
            if lev < 20 {
                result = member.name
            }
        }
    }
    return result ?? "None"
}


// MARK: Finale · Launch Code

 let launchCode = "\(A)-\(B)-\(C)-\(D)"
 print("LAUNCH CODE: \(launchCode)")


// MARK: Bonus

 func makeAlarm(threshold: Int) -> (Int) -> Bool {
     var count  = 0

     var alarm  :  (Int) -> Bool  = { t in
         
         if t < threshold {
             count += 1
             print("Alarm #\(count) -> true")
             return true
         }else {
             print(false)
             return(false)
         }
     }
     return alarm

 }
let alarm = makeAlarm(threshold: 20)
alarm(12)
alarm(40)
alarm(5)


// MARK: - ================= DEFENSE QUESTIONS =================
/*
 1. guard let vs if let beyond syntax:

 2. Why can't you pass [Int] to stats(_ values: Int...)?

 3. Why doesn't transferOxygen(from: &x, to: &x, amount: 5) compile?

 4. Why doesn't oxygenLevel(of: dana) ?? "no data" compile?

 5. Full type of chooseProtocol and how to read it:

 Bonus. Where does the alarm counter live after makeAlarm returns?

*/

