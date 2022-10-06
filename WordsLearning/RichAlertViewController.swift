//
//  RichAlertViewController.swift
//  WordsLearning
//
//  Created by Roman Kuzin on 03.08.2022.
//

import UIKit

final class RichAlertViewController: UIViewController {

	private let buttonsSettings: [ButtonSettins]
	private var buttons: [RespondingButton] = []
	private let titleString: String?
	private let subtitle: String?
	private let image: UIImage?

	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.sizeToFit()
		label.numberOfLines = 2
		label.text = titleString
		label.layer.cornerRadius = 20
		label.layer.borderColor = UIColor.white.cgColor
		label.font = UIFont(name: "Thonburi", size: 25)?.bold()
		label.textAlignment = .center
		return label
	}()

	private lazy var subtitleLabel: UILabel = {
		let label = UILabel()
		label.sizeToFit()
		label.text = subtitle
		label.numberOfLines = 0
		label.textAlignment = .center
		label.layer.cornerRadius = 20
		label.layer.borderColor = UIColor.white.cgColor
		label.font = UIFont(name: "Thonburi", size: 20)
		return label
	}()

	private var contentView: UIView = {
		let view = UIView()
		view.layer.borderWidth = 2
		view.layer.cornerRadius = 20
		view.backgroundColor = .white
		view.layer.borderColor = UIColor.black.cgColor
		return view
	}()

	private lazy var imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = image
		return imageView
	}()

	private enum Sizes {

		static let contentToSubcontentMultiplier: CGFloat = 0.8
		static let indentBetweenButtons: CGFloat = 15
		static let firstButtonToBottom: CGFloat = 15
		static let subtitleLabelHeight:CGFloat = 200
		static let titleLabelHeight:CGFloat = 70
		static let titleToSubtitle: CGFloat = 10
		static let buttonHeight: CGFloat = 40
		static let titleToTop: CGFloat = 100
		static let imageSize: CGFloat = 70
		static let imageToTop: CGFloat = 15
	}

	// MARK: Object lifecycle

	/// Инициализатор
	/// - Parameters:
	///  - image: изображение
	///  - title: текст заголовка
	///  - subtitle: текст подзаголовка
	///  - buttons: настройки кнопок
	init(image: UIImage?,
		 title: String?,
		 subtitle: String?,
		 buttons: [ButtonSettins]) {
		self.image = image
		self.titleString = title
		self.subtitle = subtitle
		self.buttonsSettings = buttons
		super.init(nibName: nil, bundle: nil)
		self.buttons = makeButtons(settings: buttonsSettings)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: View lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		seutpViews()
		setupConstraints()
	}

	override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
		lastButtonTappedByKeystroke()
	}

	// MARK: Private

	private func seutpViews() {
		view.overrideUserInterfaceStyle = .light
		view.backgroundColor = .white
		contentView.backgroundColor = .white
		view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
		view.addSubview(contentView)
		view.addSubview(titleLabel)
		view.addSubview(subtitleLabel)
		view.addSubview(imageView)
		buttons.forEach {
			view.addSubview($0)
		}

		if Platform.isSimulator {
			buttons.last?.becomeFirstResponder()
		}
	}

	private func makeButtons(settings: [ButtonSettins]) -> [RespondingButton] {
		var result: [RespondingButton] = []
		settings.forEach { settings in
			let button = RespondingButton()
			button.actionOnTap = settings.actionOnTap
			button.backgroundColor = .white
			button.layer.borderColor = UIColor.black.cgColor
			button.setTitle(settings.title, for: .normal)
			button.setTitleColor(.black, for: .normal)
			button.layer.borderWidth = 1
			button.layer.cornerRadius = 18
			button.addTarget(self, action: #selector(buttonDidTapped(_:)), for: .touchUpInside)
			result.append(button)
		}
		return result
	}
	
	private func setupConstraints() {
		view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

		NSLayoutConstraint.activate([
			contentView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
			contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
			contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
			contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),

			imageView.widthAnchor.constraint(equalToConstant: Sizes.imageSize),
			imageView.heightAnchor.constraint(equalToConstant: Sizes.imageSize),
			imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Sizes.imageToTop),


			titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Sizes.titleToTop),
			titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: Sizes.contentToSubcontentMultiplier),

			subtitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Sizes.titleToSubtitle),
			subtitleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: Sizes.contentToSubcontentMultiplier)
		])

		buttons.enumerated().forEach { index, button in
			let indentFromBottom =
				Sizes.firstButtonToBottom + ((Sizes.buttonHeight + Sizes.indentBetweenButtons) * CGFloat(index))
			NSLayoutConstraint.activate([
				button.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
				button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -indentFromBottom),
				button.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: Sizes.contentToSubcontentMultiplier),
				button.heightAnchor.constraint(equalToConstant: Sizes.buttonHeight)
			])
		}
	}

	@objc private func buttonDidTapped(_ button: RespondingButton) {
		if button.actionOnTap != nil {
			button.actionOnTap?()
		}
		dismiss(animated: false)
	}

	@objc private func lastButtonTappedByKeystroke() {
		buttons.last?.actionOnTap?()
		dismiss(animated: false)
	}
}

private struct Platform {

	static var isSimulator: Bool {
		return TARGET_OS_SIMULATOR != 0
	}
}
