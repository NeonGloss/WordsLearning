//
//  TappableViewWithLabelAndImage.swift
//  WordsLearning
//
//  Created by Roman on 03/06/2023.
//

import UIKit

struct TappableViewWithLabelAndImageConfig {

	let text: String
	let image: UIImage
	let elementsHighlightedColor: UIColor
	let elementsStartColor: UIColor
	let elementsTappingColor: UIColor
	let startColor: UIColor
	let highlightedColor: UIColor
	let font: UIFont
}

/// Нажимаемое вью с изображением и текстом
final class TappableViewWithLabelAndImage: UIView {

	/// Действие при нажатии
	var acitonOnTap: (() -> Void)?

	/// Подсвечено ли вью
	var isHighlighted: Bool {
		didSet {
			updateViewColor()
		}
	}

	private let config: TappableViewWithLabelAndImageConfig
	private let imageView = UIImageView()
	private let label = UILabel()
	private let gestureView = UIButton()

	/// Инициализатор
	/// - Parameter config: конфигурация
	init(_ config: TappableViewWithLabelAndImageConfig) {
		self.config = config
		isHighlighted = false
		imageView.image = config.image
		label.text = config.text
		super.init(frame: .zero)
		setupView()
		setupConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private

	private func setupView() {
		imageView.contentMode = .scaleAspectFit
		label.textAlignment = .center
		label.font = config.font
		addSubview(imageView)
		addSubview(label)

		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
		tapGesture.delegate = self
		addGestureRecognizer(tapGesture)

		updateViewColor()
	}

	private func setupConstraints() {
		subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

		imageView.leadingToSuperview().constant = 10
		imageView.heightToSuperview(multiplier: 0.5)
		imageView.widthToHeight(of: imageView)
		imageView.centerYToSuperview()

		label.trailingToSuperview().constant = -10
		label.centerYToSuperview()
	}

	@objc private func viewTapped() {
		isHighlighted = !isHighlighted
		acitonOnTap?()
	}

	private func updateViewColor() {
		backgroundColor = isHighlighted ? config.highlightedColor : config.startColor
		let contentColor = isHighlighted ? config.elementsHighlightedColor : config.elementsStartColor
		imageView.image = imageView.image?.coloredAs(contentColor, contentColor)
		label.textColor = contentColor
	}

	private func colorContext(isTapping: Bool) {
		let origColor = isHighlighted ? config.elementsHighlightedColor : config.elementsStartColor
		let contentColor = isTapping ? config.elementsTappingColor : origColor
		imageView.image = imageView.image?.coloredAs(contentColor, contentColor)
		label.textColor = contentColor
	}

	private func configure(image: UIImage?, text: String) {
		imageView.image = image
		label.text = text
	}
}

extension TappableViewWithLabelAndImage: UIGestureRecognizerDelegate {

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		colorContext(isTapping: true)
		print("touchesBegan")
	}

	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesCancelled(touches, with: event)
		colorContext(isTapping: false)
		print("touchesCancelled")
	}

	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesEnded(touches, with: event)
		colorContext(isTapping: false)
		print("touchesEnded")
	}
}

