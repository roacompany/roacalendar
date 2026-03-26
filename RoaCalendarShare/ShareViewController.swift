import UIKit
import Social

// MARK: - Share Extension Placeholder

class ShareViewController: SLComposeServiceViewController {
    override func isContentValid() -> Bool {
        true
    }

    override func didSelectPost() {
        // Quick Add로 Task 생성 (v2에서 구현)
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
}
