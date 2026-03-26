import UIKit
import Social

// MARK: - Share Extension Placeholder

class ShareViewController: SLComposeServiceViewController {
    override func isContentValid() -> Bool {
        true
    }

    override func didSelectPost() {
        // TODO: Quick Add로 Task 생성
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
}
