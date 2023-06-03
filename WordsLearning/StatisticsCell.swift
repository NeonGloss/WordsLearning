//
//  StatisticsCell.swift
//  WordsLearning
//
//  Created by Кузин Роман Эдуардович on 27.10.2022.
//

import UIKit

/// Протокол объекта обрабатывающего события от ячейки
protocol StaticsticsCellOutput: AnyObject {
    
    /// Нажата ячейка
    /// - Parameter word: слово в ячейке
    func cellTappedWithWord(_ word: Word)
    
    /// Ечейка выбрана для удаления
    /// - Parameters:
    ///   - word: словов в ячейке
    ///   - complition: замыкание принимаюшее флаг успеха удаления слова
    func cellTappedForDeletionWithWord(_ wordForDeletion: Word, complition: @escaping (Bool) -> ())
}

/// Ячейка экрана стистики
final class StatisticsCell: UITableViewCell, DRTableViewCellProtocol {
    
    // TODO: реюзабилити не работает
    var shouldReuse = false
    
    private weak var output: StaticsticsCellOutput?
    private var word: Word
    
    private let backRoundedCornersView = UIView()
    private let foreingWordLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Thonburi", size: 23)?.bold()
        return label
    }()
    private let nativeWordsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    private let fToNRemarkLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.italic()
        return label
    }()
    private let nToFRemarkLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.italic()
        return label
    }()
    private let fToNStudyPercentLabel = UILabel()
    private let nToFStudyPercentLabel = UILabel()
    private enum Sizes {
        static let horizontalIndent: CGFloat = 20.0
        static let verticalIndent: CGFloat = 15.0
    }
    
    /// Инициализатор
    /// - Parameters:
    ///   - word: слово
    ///   - output: объект обрабатывающий события
    init(word: Word, output: StaticsticsCellOutput) {
        self.word = word
        self.output = output
		super.init(style: .subtitle, reuseIdentifier: nil)
		setupUI()
		setupConstraints()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        word = Word(foreign: "", native: [""], transcription: "")
		super.init(style: style, reuseIdentifier: reuseIdentifier)
	}

	func didSelected() {
        output?.cellTappedWithWord(word)
    }

	func someCellWasSelected() {}

	func emptySpaceOnTableWasTapped() {}

	func selectedToBeEdited() {}

    func selectedToBeRemoved(complition: @escaping (Bool) -> ()) {
        output?.cellTappedForDeletionWithWord(word) { result in
            complition(result)
        }
    }

	// MARK: Private

	private func setupConstraints() {
        contentView.addSubview(backRoundedCornersView)
        contentView.addSubview(fToNRemarkLabel)
        contentView.addSubview(nToFRemarkLabel)
        contentView.addSubview(nativeWordsLabel)
        contentView.addSubview(foreingWordLabel)
		contentView.addSubview(fToNStudyPercentLabel)
        contentView.addSubview(nToFStudyPercentLabel)
		contentView.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        backRoundedCornersView.topToSuperview().constant = 5
        backRoundedCornersView.bottomToSuperview().constant = -5
        backRoundedCornersView.leadingToSuperview().constant = Sizes.horizontalIndent
        backRoundedCornersView.trailingToSuperview().constant = -Sizes.horizontalIndent

        foreingWordLabel.topToSuperview().constant = Sizes.verticalIndent
        foreingWordLabel.leadingToSuperview().constant = 30

        fToNRemarkLabel.centerX(to: foreingWordLabel)
        fToNRemarkLabel.leading(to: foreingWordLabel).constant = 10

        fToNStudyPercentLabel.centerY(to: foreingWordLabel)
        fToNStudyPercentLabel.trailingToSuperview().constant = -30

        nativeWordsLabel.topToBottom(of: foreingWordLabel).constant = 10
        nativeWordsLabel.leading(to: foreingWordLabel)
        nativeWordsLabel.width(to: contentView, multiplier: 0.75)

        nToFRemarkLabel.top(to: nativeWordsLabel).constant = 10
        nToFRemarkLabel.leading(to: nativeWordsLabel)
        nToFRemarkLabel.trailingToSuperview().constant = -50
        nToFRemarkLabel.bottomToSuperview().constant = -Sizes.verticalIndent

        nToFStudyPercentLabel.centerY(to: nativeWordsLabel)
        nToFStudyPercentLabel.trailing(to: fToNStudyPercentLabel)
        
        if nToFRemarkLabel.text != nil {
            nToFRemarkLabel.topToBottom(of: nativeWordsLabel).constant = 10
            nToFRemarkLabel.leading(to: nativeWordsLabel)
            nToFRemarkLabel.trailingToSuperview().constant = -50
            nToFRemarkLabel.bottomToSuperview().constant = -Sizes.verticalIndent
        } else {
            nativeWordsLabel.bottomToSuperview().constant = -Sizes.verticalIndent
        }
    }

	private func setupUI() {
		backgroundColor = .clear
        backRoundedCornersView.backgroundColor = .white
        backRoundedCornersView.layer.cornerRadius = 10

        foreingWordLabel.text = word.foreign
        nativeWordsLabel.text = makeNativeString(from: word.native)
        fToNStudyPercentLabel.text = String(format: "%.0f", word.foreingToNativeStatistic.studyPercent) + " %"
        nToFStudyPercentLabel.text = String(format: "%.0f", word.nativeToForeignStatistic.studyPercent) + " %"
        
        if let fToNRemarkText = word.fToNRemark, !fToNRemarkText.isEmpty {
			fToNRemarkLabel.text = "(" + fToNRemarkText + ")"
		} else {
			fToNRemarkLabel.text = nil
		}
        if let nToFRemarkText = word.nToFRemark, !nToFRemarkText.isEmpty {
            nToFRemarkLabel.text = "(" + nToFRemarkText + ")"
        } else {
			nToFRemarkLabel.text = nil
		}
	}
    
    // MAKR: Private
    
    private func makeNativeString(from words: [String]) -> String {
        words.joined(separator: ", ")
    }
}
