// MyLifeStory.swift
// Assignment: Your Life Story in Swift
//
// This program declares variables of different data types (String, Int,
// Bool, Double) to describe personal information and hobbies, then combines
// them into one final life story summary using string interpolation.

import Foundation

// MARK: - Step 1: Personal Information

var firstName: String = "Raiymbek"
var lastName: String = "Q"
var age: Int = 21
var birthYear: Int = 2004
var isStudent: Bool = true
var height: Double = 1.78          // height in meters
var hometown: String = "Almaty"    // extra detail
var nationality: String = "Kazakh" // extra detail
var favoriteEmoji: String = "🚀"   // extra detail using an emoji as a value

// Bonus Challenge: calculate age from birth year using a constant
let currentYear: Int = 2026
let calculatedAge: Int = currentYear - birthYear

// MARK: - Step 2: Hobbies and Interests

var hobby: String = "coding"
var numberOfHobbies: Int = 5
var favoriteNumber: Int = 7
var isHobbyCreative: Bool = true
var secondHobby: String = "photography"     // extra detail
var hoursPerWeekOnHobbies: Double = 10.5    // extra detail
let 🎯 = "Become a great software engineer" // emoji as a variable name (Bonus Task)

// MARK: - Bonus Task: Future Goals

var futureGoals: String = "In the future, I want to become a professional iOS developer 📱 and build apps that help people every day."

// MARK: - Step 3: Life Story Summary

let creativeDescription = isHobbyCreative ? "a creative hobby" : "not a creative hobby"
let studentStatus = isStudent ? "currently a student" : "not currently a student"

let lifeStory = """
My name is \(firstName) \(lastName). I am \(calculatedAge) years old, born in \(birthYear). \
I am \(studentStatus), and I stand \(height) meters tall. I'm from \(hometown) and I'm \(nationality). \
I enjoy \(hobby), which is \(creativeDescription). I also like \(secondHobby), and I spend about \(hoursPerWeekOnHobbies) hours a week on my hobbies. \
I have \(numberOfHobbies) hobbies in total, and my favorite number is \(favoriteNumber). \
My favorite emoji is \(favoriteEmoji), and my personal goal (\(🎯)) drives everything I do. \
\(futureGoals)
"""

// MARK: - Step 4: Print the Life Story

print(lifeStory)
