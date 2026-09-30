
import SwiftUI
import UIKit

struct PhotoActionSheet: UIViewControllerRepresentable {
    @Binding var isPresented: Bool

    let onChangePhoto: () -> Void
    let onDeletePhoto: () -> Void

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
            title: "Фото профиля",
            message: nil,
            preferredStyle: .actionSheet
        )

        alert.addAction(
            UIAlertAction(
                title: "Изменить фото",
                style: .default
            ) { _ in
                isPresented = false
                onChangePhoto()
            }
        )

        alert.addAction(
            UIAlertAction(
                title: "Удалить фото",
                style: .destructive
            ) { _ in
                isPresented = false
                onDeletePhoto()
            }
        )

        alert.addAction(
            UIAlertAction(
                title: "Отмена",
                style: .cancel
            ) { _ in
                isPresented = false
            }
        )

        uiViewController.present(alert, animated: true)
    }
}

