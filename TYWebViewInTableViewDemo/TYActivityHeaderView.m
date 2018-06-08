//
//  TYActivityHeaderView.m
//  TYWebViewInTableViewDemo
//
//  Created by Tiny on 2018/6/8.
//  Copyright © 2018年 hxq. All rights reserved.
//

#import "TYActivityHeaderView.h"
#import <WebKit/WebKit.h>
#import "TYActivitySignView.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@interface TYActivityHeaderView ()<WKUIDelegate,WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) TYActivitySignView *signView;  //报名视图

@end

@implementation TYActivityHeaderView


-(WKWebView *)webView{
    if (!_webView) {
        self.webView = [[WKWebView alloc] init];
        self.webView.navigationDelegate = self;
        self.webView.UIDelegate = self;
        self.webView.scrollView.scrollEnabled = NO;
    }
    return _webView;
}

-(UIImageView *)imgView{
    if(!_imgView){
        _imgView = [UIImageView new];
    }
    return _imgView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

-(TYActivitySignView *)signView{
    if (!_signView) {
        _signView = [TYActivitySignView new];
    }
    return _signView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    [self addSubview:self.imgView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.signView];
    [self addSubview:self.webView];
    
    CGFloat SCREEN_WIDTH = [UIScreen mainScreen].bounds.size.width;
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.left.right.mas_offset(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(SCREEN_WIDTH*0.51);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imgView.mas_bottom).mas_offset(5);
        make.left.mas_offset(15);
        make.right.mas_offset(-10);
    }];
    
    [self.signView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(0);
        make.height.mas_equalTo(160);
    }];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.signView.mas_bottom).mas_offset(0);
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(1);
        make.left.mas_offset(15);
        make.right.mas_offset(-15);
    }];
}

-(void)setParamDict:(NSDictionary *)paramDict{
    _paramDict = paramDict;
    
    [self loadHtmtString:paramDict[@"content"]];

    self.titleLabel.text = paramDict[@"title"];
    
    NSString *url = [NSString stringWithFormat:@"https:%@",paramDict[@"img"]];
     __weak typeof(self) wSelf =self;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image!=nil&&error== nil) {
            wSelf.imgView.contentMode = UIViewContentModeScaleAspectFill;
        }else
        {
            wSelf.imgView.contentMode = UIViewContentModeCenter;
        }
    }];
}

#pragma mark - WKNavigationDelegate,WKUIDelegate
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    [self.webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
        //这里是重点 webView加载完成后需要把webView的高度返回 所有要在这里计算tableView header的总高度
        [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(([result doubleValue]+10));
        }];
        if (self.headerBlock) {
            //这里计算高度，根据实际内容来 每个高度都需要加上的
            CGFloat viewHeight = 0.0f;
            CGFloat SCREEN_WIDTH = [UIScreen mainScreen].bounds.size.width;
            viewHeight = [result doubleValue] + 10 + SCREEN_WIDTH *0.51 + 5 + [self getHeightWithTitle:self.paramDict[@"title"] font:self.titleLabel.font maxWidth:SCREEN_WIDTH -15 - 10] + 160;
            self.headerBlock(viewHeight);
        }
    }];
}

-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    if (error) {
        if (self.headerBlock) {
            self.headerBlock(-1);
        }
    }
}

#pragma mark - Private
-(void)loadHtmtString:(NSString *)content{
    NSString *htmlcontent = [NSString stringWithFormat:
                             @"<html>"
                             "<head>"
                             "<meta charset='utf-8' name='viewport' content='width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no'/>"
                             "<style type=\"text/css\">"
                             "img {"
                             "max-width:100%%;"
                             //                             "width:auto;"
                             //                             "height:auto;"
                             "-webkit-tap-highlight-color:rgba(0,0,0,0);"
                             "}"
                             "</style>"
                             "<script type=\"text/javascript\">"
                             "</script>"
                             "</head>"
                             "<body>"
                             "<div>"
                             "<div id=\"webview_content_wrapper\">%@</div>"
                             "</div>"
                             "</body>"
                             "</html>"
                             ,content];
    [self.webView loadHTMLString:htmlcontent baseURL:nil];
}

-(CGFloat)getHeightWithTitle:(NSString *)title font:(UIFont *)font maxWidth:(CGFloat)maxWidth{
    CGRect tmpRect = [title boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil];
    return tmpRect.size.height+1;
}


@end
