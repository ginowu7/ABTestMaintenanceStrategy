#!/usr/bin/xcrun --sdk macosx swift

/*
 Automated Maintenance Strategy:
 We can now add AB_TEST: marks next to the initialized AB test in the iOS codebase stating when the test was created, the engineer and squad responsible for the test, and how long the test should remain active for. This post build script will validate a time interval as to how long the tests should be active for. If the active test time expires, we can trigger a warning from XCode during compilation time. This should notify the iOS team an AB test needs maintenance. ie: AB_TEST: Gino Wu | Registration Squad | Expires 01/01/2019 - Post build script would trigger a warning on 01/01/2019 during compliation

 Parses the format `// AB_TEST: {name} | {squad} | {expiration_date in the format MM/dd/yyyy}` on same line as delcared property in a specified file. Used to notify errors when expiration date lapses the current date.

 Input: Filename of where format is initialized
 Output: Expired AB tests that requires attention.
 */

import Foundation

let fileManager = FileManager.default
let currentPath = fileManager.currentDirectoryPath
let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy"
    return dateFormatter
}()

let currentDate = Date()

/// List of files in currentPath - recursive
var pathFiles: [String] = {
    guard let enumerator = fileManager.enumerator(atPath: currentPath),
        let files = enumerator.allObjects as? [String] else {
        fatalError("Could not locate files in path directory: \(currentPath)")
    }
    return files
}()

/// Reads contents in path
///
/// - Parameter path: path of file
/// - Returns: content in file
func contents(atPath path: String) -> String {
    guard let data = fileManager.contents(atPath: path),
        let content = String(data: data, encoding: .utf8) else {
        fatalError("Could not read from path: \(path)")
    }
    return content
}

/// Returns a list of strings that match regex pattern from content
///
/// - Parameters:
///   - pattern: regex pattern
///   - content: content to match
/// - Returns: list of results
func regexFor(_ pattern: String, content: String) -> [String] {
    guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { fatalError("Regex not formatted correctly: \(pattern)") }
    let matches = regex.matches(in: content, options: [], range: NSRange(location: 0, length: content.utf16.count))
    return matches.map {
        guard let range = Range($0.range(at: 0), in: content) else { fatalError("Incorrect range match") }
        return String(content[range])
    }
}


/// Returns path of file
///
/// - Parameter file: name of file
/// - Returns: path of file
func findPath(_ file: String) -> String {
    guard let pathFile = pathFiles.first(where: {$0.localizedCaseInsensitiveContains(file) && NSString(string: $0).pathExtension == "swift" }) else {
        fatalError("Could not locate file: \(file)")
    }
    return pathFile
}


/// Validates AB tests that has expired - if the test has expired - trigger warning on XCode console
///
/// - Parameter file: name of file
func validateABTests(file: String) {
    let declaredVariantFile = findPath(file)
    let variantContents = contents(atPath: declaredVariantFile)
    let variantTests = regexFor("(.*//\\s*AB_TEST.*)", content: variantContents)

    variantTests.forEach {
        guard let expirationDateSerialized = regexFor("((0|1)\\d{1})/((0|1|2)\\d{1})/((19|20)\\d{2})", content: $0).first,
            let expirationDate = dateFormatter.date(from: expirationDateSerialized) else {
                fatalError("Incorrect expiration date format: MM/dd/yyyy")
        }
        if let expiredTest = regexFor(".+?(?=:)", content: $0).first, expirationDate < currentDate {
            print("warning: \(expiredTest) AB Test is expired - \n:\($0)")
        }
    }

}

guard CommandLine.arguments.indices.contains(1) else { fatalError("Missing filename argument") }
validateABTests(file: CommandLine.arguments[1])
