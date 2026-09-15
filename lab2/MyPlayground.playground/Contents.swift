import Cocoa

var greeting = "Hello, playground"


let arr = ["apple","banana","grape","pear"]
print(arr[2])
print(arr[arr.index(arr.startIndex, offsetBy: 2)])
var b = arr.startIndex
print(arr.formIndex(&b, offsetBy: 2, limitedBy: 1))


var dict = Dictionary<String ,Int>()


dict = ["Some" : 123 , "Another" : 234 , "Ha" : 345]

var h  = [1 : "1"]
print(dict[dict.index(dict.startIndex, offsetBy: 1)].value)
if let g = dict.first(where: {$0.value == 123})?.value {
    print (g)
}
print(dict.first(where: {$0.value == 123})?.value)


for (index , smth) in dict {
    print(index,smth , terminator: "gggg" )
}
print()
var s1 =  Set<Int>()
var s2 = Set<Int>()

s1 = [1,1,2,3,4]
s2 = [3,3,2]
print("\(s1) s1")
print("s2", s2)

print(s1.intersection(s2))
print(s1)
print(s1.filter({[1,2].contains($0)}))


    if let indexHas = dict.firstIndex(where:{ $0.key == "Ha"}) {
        var j = dict[indexHas].value
        dict.remove(at: indexHas)
        
        dict["NoHa"] = j
    }


var  arr1 = ["apple" , "banana"]

var arr2  = ["cherry", "date"]
arr1.append(contentsOf: arr2)

print(arr1)



var countries = ["Kaz" : 123 , "Pol" : 123 , "Turk" : 456]

countries["Lib" , default: 0] += 1

print(countries)

var ss = Set(["cat" , "dog" ])

var ss2 = Set(["mouse" , "dog" ])

print(ss.intersection(ss2))
print(ss)
ss.formIntersection(ss2)
print(ss)
print(ss2)
 ss = Set(["cat" , "dog" ])

 ss2 = Set(["mouse" , "dog" ])


print(ss2.count)
print(ss.subtracting(ss2))
print(ss)
ss.subtract(ss2)
print(ss)


var grades = ["Kaz" : ["Math" : 123 , "PE" : 243 ]]

var jj = grades[grades.index(grades.startIndex, offsetBy: 0)]
print(jj.value[jj.value.index(jj.value.startIndex, offsetBy: 1)].value)
