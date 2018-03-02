//
//  WPAboutUsTableViewHeaderView.m
//  Wallpaper
//
//  Created by kyson on 02/03/2018.
//  Copyright © 2018 zhujinhui. All rights reserved.
//

#import "WPAboutUsTableViewHeaderView.h"

@interface WPAboutUsTableViewHeaderView()

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@end

@implementation WPAboutUsTableViewHeaderView


+(id)loadFromXib{
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil].lastObject;
}


-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(65, 65));
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(16.f);
    }];
    self.logoImageView.layer.cornerRadius = 65.f / 2 ;
    self.logoImageView.clipsToBounds = YES;
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.f);
        make.right.equalTo(self).offset(-15.f);
        make.top.equalTo(self.logoImageView.mas_bottom).offset(10.f);
    }];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.tipsLabel.attributedText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.tipsLabel.attributedText length])];
    self.tipsLabel.attributedText = attributedString;
}

+(CGFloat)headerHeight{
    return 200;
}


@end
