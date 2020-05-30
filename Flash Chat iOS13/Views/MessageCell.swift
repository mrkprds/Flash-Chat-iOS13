//
//  MessageCell.swift
//  Flash Chat iOS13
//
//  Created by Mark Patrick Perdon on 5/27/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var messageText: UILabel!
    @IBOutlet weak var senderImage: UIImageView!
    @IBOutlet weak var receiverImage: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        messageBubble.layer.cornerRadius = messageBubble.frame.size.height / 3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
