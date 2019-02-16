//
//  RequestManager.swift
//  Cartrack
//
//  Created by Aung Phyoe on 16/2/19.
//  Copyright © 2019 Aung Phyoe. All rights reserved.
//

import Foundation

class RequestManager: NSObject {
    
    class var shared: RequestManager {
        struct Singleton {
            static let instance = RequestManager()
        }
        return Singleton.instance
    }
    func download(urlString: String,
                  completion: @escaping (Bool, URL?, URLResponse?, NSError?) -> Void ) {
        if let url = URL(string: urlString) {
            let task = URLSession.shared.downloadTask(with: url) { localURL, urlResponse, error in
                if let localURL = localURL {
                    completion(true, localURL, urlResponse, error as NSError?)
                } else {
                    completion(false, localURL, urlResponse, error as NSError?)
                }
            }
            task.resume()
        } else {
            completion(false, nil, nil, NSError(domain: "error", code: 1, userInfo: [:]))
        }
    }
    func downloadURL(_ urlString: String, newDownload: Bool = true, completion: @escaping ((Data?, NSError?) -> Void), oldfileCompletion : @escaping ((Data?) -> Void)) {
        let oldfile: Data? = self.getFileFromDisk(urlString)
        oldfileCompletion(oldfile)
        if oldfile == nil || newDownload {
            self.download(urlString: urlString) { (success, templocalFile, _, error) in
                if success {
                    if let localFileURL = templocalFile {
                        let manager = FileManager.default
                        let name = self.removeHTTPFrom(urlString)
                        let filePath = self.getFilePath(name)
                        if manager.fileExists(atPath: filePath) {
                            do {
                                try manager.removeItem(atPath: filePath)
                            } catch let error {
                                print("error occurred, here are the details:\n \(error)")
                            }
                        }
                        if let destinationURL = self.getDocumentsURL()?.appendingPathComponent(name) {
                            //MARK: Move file
                            do {
                                try manager.moveItem(at: localFileURL, to: destinationURL)
                                completion(self.getFileFromDisk(urlString), nil)
                            } catch {
                                completion(nil, error as NSError)
                                print("Failed writing to URL: \(destinationURL), Error: " + error.localizedDescription)
                            }
                        }
                    }
                } else {
                    completion(nil, error)
                }
            }
        }
    }
    fileprivate func getFileFromDisk(_ fileName: String) -> Data? {
        // 1. Create a url for documents-directory/fileName
        let name = self.removeHTTPFrom(fileName)
        let fileManager = FileManager.default
        let filePath = self.getFilePath(name)
        //MARK: Remove if the file is exist
        if fileManager.fileExists(atPath: filePath) {
            if let url = getDocumentsURL()?.appendingPathComponent(name) {
                do {
                    return try Data(contentsOf: url)
                } catch {
                    return nil
                }
            }
        }
        return nil
    }
    fileprivate func removeHTTPFrom(_ fileName: String) -> String {
        var name = fileName
        if name.hasPrefix("https://") {
            name = name.replacingOccurrences(of: "https://", with: "")
        }
        if  name.hasPrefix("http://") {
            name = name.replacingOccurrences(of: "http://", with: "")
        }
        name = name.replacingOccurrences(of: "/", with: "_") //Avoid creating folder
        name = name.trimmingCharacters(in: .whitespaces)
        return name
    }
    fileprivate func getFilePath(_ name: String) -> String {
        let doumentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        return doumentDirectoryPath.appendingPathComponent(name)
    }
    fileprivate func getDocumentsURL() -> URL? {
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return url
        } else {
            print("Could not retrieve documents directory")
        }
        return nil
    }
}
