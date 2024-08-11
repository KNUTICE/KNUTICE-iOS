//
//  DownloadWebViewController+Download.swift
//  KNUTICE
//
//  Created by 이정훈 on 8/11/24.
//

import WebKit

extension DownloadWebViewController: WKDownloadDelegate {
    func showShareSheet(urlString: String) {
        let fileURL = NSURL(fileURLWithPath: urlString)
        var fileToShare = [fileURL]
        
        let activityViewController = UIActivityViewController(activityItems : fileToShare, applicationActivities: [UIShareToFileAcivity(viewController: self)])
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.completionWithItemsHandler = { (activityType, completed, arrayReturnedItems, error) in
            self.dismiss(animated: true)
        }
        
        self.present(activityViewController, animated: true)
    }
    
    func download(_ download: WKDownload, decideDestinationUsing response: URLResponse, suggestedFilename: String, completionHandler: @escaping (URL?) -> Void) {
        let fileManager = FileManager.default
        let downloadsDirectory = try? fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let url = downloadsDirectory?.appendingPathComponent(suggestedFilename)
        
        completionHandler(url)
        
        showShareSheet(urlString: url?.absoluteString ?? "")
    }
    
    func downloadDidFinish(_ download: WKDownload) {
        print("finished")
    }
    
    private class UIShareToFileAcivity: UIActivity {
        let parent: UIViewController
        
        init(viewController: UIViewController) {
            self.parent = viewController
        }
        
        override var activityTitle: String? {
            return "파일에서 보기"
        }
        
        override var activityType: UIActivity.ActivityType? {
            return UIActivity.ActivityType("파일에서 보기")
        }
        
        override var activityImage: UIImage? {
            return UIImage(systemName: "folder")
        }
        
        override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
            return true
        }
        
        override func perform() {
            if let directory = URL(string: "shareddocuments" + getDownloadDirectory()) {
                UIApplication.shared.open(directory, completionHandler: { [weak self] _ in
                    self?.parent.dismiss(animated: true)
                })
            }
        }
        
        private func getDownloadDirectory() -> String {
            let fileManager = FileManager.default
            let downloadsDirectory = try? fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            
            guard let directoryString = downloadsDirectory?.absoluteString else {
                return ""
            }
            
            let firstIndex = directoryString.index(directoryString.startIndex, offsetBy: 4)
            let lastIndex = directoryString.index(before: directoryString.endIndex)
            
            return String(directoryString[firstIndex...lastIndex])
        }
        
        override class var activityCategory: UIActivity.Category {
            return .action
        }
    }
}
