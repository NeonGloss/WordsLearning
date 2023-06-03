//
//  ExtraCapabilitiesView.swift
//  WordsLearning
//
//  Created by Roman on 30/05/2023.
//

import UIKit

/// Протокол обработчика событий от вью дополнительных возможностей на главном экране
protocol ExtraCapabilitiesViewOutput: AnyObject {

	/// Обработка нажатия кнопки выбора определенных слов для изученя
 	func selectWordsButtonTapped()

	/// Смена направления запрашиваемого перевода
	func contrverseTranslationSwitcherChanged()

	/// Нажата кнопка показа всех слов
	func showAllWordsButtonTapped()
}

/// Вью отображения дополнительных возможностей на главном экране
final class ExtraCapabilitiesView: UIView {

	weak var output: ExtraCapabilitiesViewOutput?

	private var showAllWordsButton = TappableViewWithLabelAndImage(TappableViewWithLabelAndImageConfig(
		text: "Show all words",
		image: SemanticImages.sliderHorizontal3,
		elementsHighlightedColor: Design.Colors.dsNuance0,
		elementsStartColor: .white,
		elementsTappingColor: .gray,
		startColor: .systemGray5,
		highlightedColor: .clear,
		font: Design.Fonts.smallest))

	private var selectWordsListButton = TappableViewWithLabelAndImage(TappableViewWithLabelAndImageConfig(
		text: "Select words list",
		image: SemanticImages.dotCircleAndHandPointUpLeftFill,
		elementsHighlightedColor: Design.Colors.dsNuance0,
		elementsStartColor: .white,
		elementsTappingColor: .gray,
		startColor: .systemGray5,
		highlightedColor: .clear,
		font: Design.Fonts.smallest))

	private var chaingeTranslationDirectionButton = TappableViewWithLabelAndImage(TappableViewWithLabelAndImageConfig(
		text: "Change translation direction",
		image: SemanticImages.arrowLeftArrowRight,
		elementsHighlightedColor: Design.Colors.dsNuance0,
		elementsStartColor: .white,
		elementsTappingColor: .gray,
		startColor: .systemGray5,
		highlightedColor: .clear,
		font: Design.Fonts.smallest))

	private enum Sizes {
		static let buttonHeight: CGFloat = 40
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
		setupConsgtraints()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	// MARK: - Private

	private func setupView() {
		backgroundColor = .clear
		showAllWordsButton.layer.cornerRadius = 10
		chaingeTranslationDirectionButton.layer.cornerRadius = 10
		showAllWordsButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
		chaingeTranslationDirectionButton.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]

		showAllWordsButton.acitonOnTap = { self.output?.showAllWordsButtonTapped() }
		selectWordsListButton.acitonOnTap = { self.output?.selectWordsButtonTapped() }
		chaingeTranslationDirectionButton.acitonOnTap = { self.output?.contrverseTranslationSwitcherChanged() }
	}

	private func setupConsgtraints() {
		addSubview(showAllWordsButton)
		addSubview(selectWordsListButton)
		addSubview(chaingeTranslationDirectionButton)
		subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

		showAllWordsButton.topToSuperview()
		showAllWordsButton.leadingToSuperview()
		showAllWordsButton.trailingToSuperview()
		showAllWordsButton.height(Sizes.buttonHeight)
		showAllWordsButton.width(Sizes.buttonHeight)

		selectWordsListButton.topToBottom(of: showAllWordsButton).constant = 2
		selectWordsListButton.leadingToSuperview()
		selectWordsListButton.trailingToSuperview()
		selectWordsListButton.width(Sizes.buttonHeight)
		selectWordsListButton.height(Sizes.buttonHeight)

		chaingeTranslationDirectionButton.topToBottom(of: selectWordsListButton).constant = 2
		chaingeTranslationDirectionButton.leadingToSuperview()
		chaingeTranslationDirectionButton.trailingToSuperview()
		chaingeTranslationDirectionButton.width(Sizes.buttonHeight)
		chaingeTranslationDirectionButton.height(Sizes.buttonHeight)
		chaingeTranslationDirectionButton.bottomToSuperview()
	}
}
