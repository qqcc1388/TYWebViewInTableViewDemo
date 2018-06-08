//
//  TYActivitySignView.m
//  TYWebViewInTableViewDemo
//
//  Created by Tiny on 2018/6/8.
//  Copyright © 2018年 hxq. All rights reserved.
//

#import "TYActivitySignView.h"
#import "Masonry.h"

@interface TYActivitySignView ()

@property (nonatomic, strong) UILabel *activityTimeLabel;
@property (nonatomic, strong) UILabel *activityPositionLabel;
@property (nonatomic, strong) UILabel *activityPriceLabel;
@property (nonatomic, strong) UILabel *activitySignTimeLabel;
@property (nonatomic, strong) UIButton *signButton;


@end
@implementation TYActivitySignView

-(UILabel *)activityTimeLabel{
    if (!_activityTimeLabel) {
        _activityTimeLabel = [UILabel new];
        _activityTimeLabel.font = [UIFont systemFontOfSize:14];
        _activityTimeLabel.textColor = [UIColor darkGrayColor];
        _activityTimeLabel.text = @"活动时间：5月22日09:00~5月24日17:30";
    }
    return _activityTimeLabel;
}

-(UILabel *)activityPositionLabel{
    if (!_activityPositionLabel) {
        _activityPositionLabel = [UILabel new];
        _activityPositionLabel.font = [UIFont systemFontOfSize:14];
        _activityPositionLabel.textColor = [UIColor darkGrayColor];
        _activityPositionLabel.text = @"地  点：深圳西乡敬老院";
    }
    return _activityPositionLabel;
}

-(UILabel *)activityPriceLabel{
    if (!_activityPriceLabel) {
        _activityPriceLabel = [UILabel new];
        _activityPriceLabel.font = [UIFont systemFontOfSize:14];
        _activityPriceLabel.textColor = [UIColor darkGrayColor];
        _activityPriceLabel.text = @"费  用：123积分";
    }
    return _activityPriceLabel;
}

-(UILabel *)activitySignTimeLabel{
    if (!_activitySignTimeLabel) {
        _activitySignTimeLabel = [UILabel new];
        _activitySignTimeLabel.font = [UIFont systemFontOfSize:14];
        _activitySignTimeLabel.textColor = [UIColor darkGrayColor];
        _activitySignTimeLabel.text = @"报名时间：5月20日09:00~20:00";
    }
    return _activitySignTimeLabel;
}

-(UIButton *)signButton{
    if (!_signButton) {
        _signButton = [UIButton new];
        _signButton.layer.cornerRadius = 5;
        _signButton.layer.masksToBounds = YES;
        [_signButton setBackgroundColor:[UIColor redColor]];
        [_signButton setTitle:@"立即报名" forState:UIControlStateNormal];
        _signButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_signButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _signButton;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}


-(void)setupUI{
    self.clipsToBounds = YES;
    
    [self addSubview:self.activityTimeLabel];
    [self addSubview:self.activityPositionLabel];
    [self addSubview:self.activityPriceLabel];
    [self addSubview:self.activitySignTimeLabel];
    [self addSubview:self.signButton];
    
    [self.activityTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(15);
        make.right.mas_offset(-5);
        make.top.mas_offset(10);
    }];
    
    [self.activityPositionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(15);
        make.top.mas_equalTo(self.activityTimeLabel.mas_bottom).mas_offset(5);
        make.right.mas_offset(-5);
    }];
    
    [self.activityPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(15);
        make.top.mas_equalTo(self.activityPositionLabel.mas_bottom).mas_offset(5);
        make.right.mas_offset(-5);
    }];
    
    [self.activitySignTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(15);
        make.top.mas_equalTo(self.activityPriceLabel.mas_bottom).mas_offset(5);
        make.right.mas_offset(-5);
    }];
    
    [self.signButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.left.mas_offset(51);
        make.right.mas_offset(-51);
        make.height.mas_equalTo(38);
        make.bottom.mas_offset(-10);
    }];
}

@end
