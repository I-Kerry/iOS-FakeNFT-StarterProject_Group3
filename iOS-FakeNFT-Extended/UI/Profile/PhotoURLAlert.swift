import SwiftUI
import UIKit

struct PhotoURLAlert: UIViewControllerRepresentable {
    @Binding var isPresented: Bool

    let initialURL: String
    let onSave: (String) -> Void

    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }

    func updateUIViewController(
        _ uiViewController: UIViewController,
        context: Context
    ) {
        guard isPresented,
              uiViewController.presentedViewController == nil else {
            return
        }

        let alert = UIAlertController(
            title: "Ссылка на фото",
            message: nil,
            preferredStyle: .alert
        )

        alert.addTextField { textField in
            textField.text = initialURL
            textField.keyboardType = .URL
            textField.autocapitalizationType = .none
        }

        alert.addAction(
            UIAlertAction(
                title: "Отмена",
                style: .cancel
            ) { _ in
                isPresented = false
            }
        )

        alert.addAction(
            UIAlertAction(
                title: "Сохранить",
                style: .default
            ) { _ in
                let url = alert.textFields?.first?.text ?? ""
                isPresented = false
                onSave(url)
            }
        )

        uiViewController.present(alert, animated: true)
    }
}
