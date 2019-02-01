#!/usr/bin/xcrun --sdk macosx swift

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
        let files = enumerator.allObjects as? [String]
        else { fatalError("Could not locate files in path directory: \(currentPath)") }
    return files
}()

/// Reads contents in path
///
/// - Parameter path: path of file
/// - Returns: content in file
func contents(atPath path: String) -> String {
    guard let data = fileManager.contents(atPath: path),
        let content = String(data: data, encoding: .utf8)
        else { fatalError("Could not read from path: \(path)") }
    return content
}

/// Returns a list of strings that match regex pattern from content
///
/// - Parameters:
///   - pattern: regex pattern
///   - content: content to match
/// - Returns: list of results
func regexFor(_ pattern: String, content: String) -> [String] {
    guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { fatalError("Regex not formatted correctly: \(pattern)")}
    let matches = regex.matches(in: content, options: [], range: NSRange(location: 0, length: content.utf16.count))
    return matches.map {
        guard let range = Range($0.range(at: 0), in: content) else { fatalError("Incorrect range match") }
        return String(content[range])
    }
}


func findPath(name: String) -> String {
    guard let pathFile = pathFiles.first(where: {$0.localizedCaseInsensitiveContains(name) && NSString(string: $0).pathExtension == "swift" })
        else { fatalError("Could not locate file: \(name)") }
    return pathFile
}

func validateABTests(path: String) {
    let declaredVariantFile = findPath(name: path)
    let variantContents = contents(atPath: declaredVariantFile)
    let variantTests = regexFor("(.*//\\s*AB_TEST.*)", content: variantContents)

    variantTests.forEach {
        guard let expirationDateSerialized = regexFor("((0|1)\\d{1})/((0|1|2)\\d{1})/((19|20)\\d{2})", content: $0).first,
            let expirationDate = dateFormatter.date(from: expirationDateSerialized) else {
                fatalError("Incorrect expiration date format: MM/dd/yyyy")
        }
        if let expiredTest = regexFor(".+?(?=:)", content: $0).first, expirationDate < currentDate {
            print("\(expiredTest) AB Test is expired - \nWarning: \($0)")
        }
    }

}

validateABTests(path: "VariantProviding")

