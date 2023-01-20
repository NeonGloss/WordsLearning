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
}

/// Ячейка экрана стистики
final class StatisticsCell: UITableViewCell, DRTableViewCellProtocol {
    
    // TODO: реюзабилити не работает
    var shouldReuse = false
    
    private weak var output: StaticsticsCellOutput?
    private var word: Word
    
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


	// MARK: Private

	private func setupConstraints() {
        contentView.addSubview(fToNRemarkLabel)
        contentView.addSubview(nToFRemarkLabel)
        contentView.addSubview(nativeWordsLabel)
        contentView.addSubview(foreingWordLabel)
		contentView.addSubview(fToNStudyPercentLabel)
        contentView.addSubview(nToFStudyPercentLabel)
		contentView.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

		NSLayoutConstraint.activate([
			foreingWordLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
			foreingWordLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            fToNRemarkLabel.centerYAnchor.constraint(equalTo: foreingWordLabel.centerYAnchor),
            fToNRemarkLabel.leadingAnchor.constraint(equalTo: foreingWordLabel.trailingAnchor, constant: 10),
            
            fToNStudyPercentLabel.centerYAnchor.constraint(equalTo: foreingWordLabel.centerYAnchor),
            fToNStudyPercentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            nativeWordsLabel.topAnchor.constraint(equalTo: foreingWordLabel.bottomAnchor, constant: 10),
            nativeWordsLabel.leadingAnchor.constraint(equalTo: foreingWordLabel.leadingAnchor),
            
            nToFRemarkLabel.topAnchor.constraint(equalTo: nativeWordsLabel.bottomAnchor, constant: 10),
            nToFRemarkLabel.leadingAnchor.constraint(equalTo: nativeWordsLabel.leadingAnchor),
            nToFRemarkLabel.trailingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: -50),
            nToFRemarkLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            nToFStudyPercentLabel.centerYAnchor.constraint(equalTo: nativeWordsLabel.centerYAnchor),
            nToFStudyPercentLabel.trailingAnchor.constraint(equalTo: fToNStudyPercentLabel.trailingAnchor),
		])
        
        if nToFRemarkLabel.text != nil {
            NSLayoutConstraint.activate([
                nToFRemarkLabel.topAnchor.constraint(equalTo: nativeWordsLabel.bottomAnchor, constant: 10),
                nToFRemarkLabel.leadingAnchor.constraint(equalTo: nativeWordsLabel.leadingAnchor),
                nToFRemarkLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
                nToFRemarkLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            ])
        } else {
            NSLayoutConstraint.activate([
                nativeWordsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            ])
        }
    }

	private func setupUI() {
		backgroundColor = .clear
        foreingWordLabel.text = word.foreign
        nativeWordsLabel.text = makeNativeString(from: word.native)
        fToNStudyPercentLabel.text = String(format: "%.0f", word.foreingToNativeStatistic.studyPercent) + " %"
        nToFStudyPercentLabel.text = String(format: "%.0f", word.nativeToForeignStatistic.studyPercent) + " %"
        
        if let fToNRemarkText = word.fToNRemark, !fToNRemarkText.isEmpty {
			fToNRemarkLabel.text = "(" + fToNRemarkText + ")"
		}
        if let nToFRemarkText = word.nToFRemark, !nToFRemarkText.isEmpty {
            nToFRemarkLabel.text = "(" + nToFRemarkText + ")"
        }
	}
    
    // MAKR: Private
    
    private func makeNativeString(from words: [String]) -> String {
        words.joined(separator: ", ")
    }
}
