import Foundation
import PathKit
import Rainbow
import Progress

public struct localizationCommand :RegexStringsSearcher{
    
    let projectPath : Path
    let exceptPath : [Path]
    
    internal var ocPath : [Path] = []
    internal var swiftPath : [Path] = []
    
    var patterns: [String]
    var progress: ProgressBar
    
    
    public init(projPath:String,except:[String]){
        let path = Path(projPath).absolute()
        projectPath = path
        exceptPath = except.map{path + Path($0)}
        patterns = []
        progress = ProgressBar.init(count: 0)
    }

    
    func search(in content: String) {}
    
    
    public mutating func findTargetFiles(){
        
        let optonalPaths = try? projectPath.recursiveChildren()
        guard let paths = optonalPaths else {return}
        
        for itemPath in Progress(pathsFilter(paths: paths, except: exceptPath)){
            let swifts = itemPath.glob(FileType.swift.rawValue)
            for item in swifts {
                swiftPath.append(item)
            }
            let ocs = itemPath.glob(FileType.oc.rawValue)
            for item in ocs {
                ocPath.append(item)
            }
        }
        
        for item in Progress(swiftPath) {
            patterns = [TEST_REGEX]
            search(in: item)
        }
        
        // test
//        DataHandleManager.defaltManager.mapSwfit()
        
        for item in Progress(ocPath) {
            patterns = [OC_REGEX]
            search(in: item)
        }
        
        // test
//        DataHandleManager.defaltManager.mapOC()

    }
    
    
}


