//
//  CanadaTableViewCell.swift
//  Proof Of Concept
//
//  Created by Trupti Gavhane on 07/07/18.
//  Copyright © 2018 Telstra. All rights reserved.
//

import UIKit
import PureLayout

class CanadaTableViewCell: UITableViewCell {

    var imageViewItem: UIImageView!
    var labelTitle: UILabel = UILabel.newAutoLayout()
    var labelDescription: UILabel = UILabel.newAutoLayout()
    
    var didSetupConstraints = false
    let kLabelHorizontalInsets: CGFloat = 15.0
    let kLabelVerticalInsets: CGFloat = 10.0

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        imageViewItem = UIImageView()
        contentView.addSubview(imageViewItem)
        
        labelTitle = UILabel()
        labelTitle.textColor = UIColor.black
        labelTitle.font = UIFont.init(name: "Helvetica-bold", size: 15)
        labelTitle.numberOfLines = 1
        contentView.addSubview(labelTitle)
        
        labelDescription = UILabel()
        labelDescription.textColor = UIColor.black
        labelDescription.font = UIFont.init(name: "Helvetica-light", size: 15)
        labelDescription.numberOfLines = 0
        contentView.addSubview(labelDescription)
    }
    
    override func updateConstraints()
    {
        if !didSetupConstraints {
            NSLayoutConstraint.autoSetPriority(UILayoutPriority.required) {
                self.imageViewItem.autoSetContentCompressionResistancePriority(for: .vertical)
                self.labelTitle.autoSetContentCompressionResistancePriority(for: .vertical)
                self.labelDescription.autoSetContentCompressionResistancePriority(for: .vertical)
            }
            
            imageViewItem.autoPinEdge(toSuperviewEdge: .leading, withInset: kLabelHorizontalInsets)
            imageViewItem.autoAlignAxis(.horizontal, toSameAxisOf: contentView)
            imageViewItem.autoSetDimension(.height, toSize: CGFloat(Constants.thumbnailHeight))
            imageViewItem.autoSetDimension(.width, toSize: CGFloat(Constants.thumbnailWidth))
            
            labelTitle.autoPinEdge(toSuperviewEdge: .top, withInset: kLabelVerticalInsets)
            labelTitle.autoPinEdge(toSuperviewEdge: .trailing, withInset: kLabelHorizontalInsets)
            labelTitle.autoPinEdge(.leading, to: .trailing, of: imageViewItem, withOffset: 10)

            labelDescription.autoPinEdge(.top, to: .bottom, of: self.labelTitle, withOffset: 10.0, relation: .greaterThanOrEqual)
            labelDescription.autoPinEdge(.leading, to: .trailing, of: imageViewItem, withOffset: 10)
            labelDescription.autoPinEdge(toSuperviewEdge: .trailing, withInset: kLabelHorizontalInsets)
            labelDescription.autoPinEdge(toSuperviewEdge: .bottom, withInset: kLabelVerticalInsets)
            
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
