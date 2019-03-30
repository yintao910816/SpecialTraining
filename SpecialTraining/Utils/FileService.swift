import UIKit
import RxSwift

class FileService: NSObject {
    static let share = FileService()
    let docuPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                       FileManager.SearchPathDomainMask.userDomainMask,
                                                       true).first!
    var videoFolderPath = ""
    var audioFolderPath = ""
    var requestFilePath = ""
    var dispose = DisposeBag()
    
    private override init() {
        super.init()
        videoFolderPath = docuPath + "/VideoCache/"
        audioFolderPath = docuPath + "/AudioCache/"
        requestFilePath = docuPath + "/RequestFielPath/"
        print("docuPath====\(docuPath)")
        // create folder
        do {
            if !FileManager.default.fileExists(atPath: videoFolderPath) {
                try FileManager.default.createDirectory(atPath: videoFolderPath, withIntermediateDirectories: true, attributes: nil)
            }
            if !FileManager.default.fileExists(atPath: audioFolderPath) {
                try FileManager.default.createDirectory(atPath: audioFolderPath, withIntermediateDirectories: true, attributes: nil)
            }
            if !FileManager.default.fileExists(atPath: requestFilePath) {
                try FileManager.default.createDirectory(atPath: requestFilePath, withIntermediateDirectories: true, attributes: nil)
            }
        } catch {
            print("create folder fail")
        }
    }
    
    /// 保存视频到沙盒
    ///
    /// - Parameter data: data
    /// - Returns: 返回沙盒路径
    private func saveVideo(data :Data ,fileKey :String) -> String {
        let path = videoFolderPath + "\(fileKey).mp4"
        do {
            let url = URL.init(fileURLWithPath: path)
            try data.write(to: url)
        } catch  {
            print("write to video fail path:===\(path)")
        }
        return path
    }
    /// 获取本地临时文件
    ///
    /// - Parameters:
    ///   - fileName: 临时文件名字
    ///   - folderName: 所在文件夹
    /// - Returns:
    private func loadLocationTempFile(fileName :String, folderName :String? = nil) -> Data? {
        var path = requestFilePath + fileName
        if let folder = folderName {
            path = requestFilePath + "/\(folder)/" + fileName
        }
        let data = try? Data.init(contentsOf: URL.init(fileURLWithPath: path))
        return data
    }
    
    private func loadLocationTempFile(localPath: String) -> Data? {
        let data = try? Data.init(contentsOf: URL.init(fileURLWithPath: localPath))
        return data
    }

    
    private func isExistVideo(fileKey :String) -> Bool {
        let path = videoFolderPath + "\(fileKey)"
        return FileManager.default.fileExists(atPath:path)
    }
    
    private func isExistAudio(fileKey :String) -> Bool {
        let path = audioFolderPath + "\(fileKey)"
        return FileManager.default.fileExists(atPath:path)
    }
    
}

extension FileService {
    /// 获取文件路径
    func localFilePath(fileName: String, folderName :String? = nil) ->String {
        if let folder = folderName {
            return (requestFilePath + "\(folder)/" + fileName)
        }else {
            return (requestFilePath + fileName)
        }
    }
    
    /// 写入临时文件
    ///
    /// - Parameter data: 写入的文件数据
    /// - Returns: 路径
    @discardableResult
    func writeToTempFile(data :Data, fileName :String = "tempfile", folderName :String? = nil) -> String {
        var path = requestFilePath + fileName
        if let folder = folderName {
            path = requestFilePath + "\(folder)/" + fileName
        }
        do {
            let url = URL.init(fileURLWithPath: path)
            try data.write(to: url, options: Data.WritingOptions.atomic)
        } catch  {
            print("save file to desk fail: \(error)")
        }
        return path
    }
    
    /// 删除临时文件
    ///
    /// - Parameter fielName: 文件名字
    func removeTempFile(fileName :String, folderName :String? = nil) {
        var path = requestFilePath + fileName
        if let folder = folderName {
            path = requestFilePath + "/\(folder)/" + fileName
        }
        
        do {
            try FileManager.default.removeItem(atPath: path)
        } catch {
            print("removeTempFile error==\(error)")
        }
    }
    
    /// 创建临时放发送图片的文件夹
    ///
    /// - Parameter folderName: 文件夹名字
    func createTempFolder(folderName :String) {
        let path = requestFilePath + folderName
        if !FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("createTempFolder error===\(error)")
            }
        }
    }
        
}
