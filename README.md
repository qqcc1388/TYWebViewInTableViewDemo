
对于一些资讯类的app,比如网易新闻，今日头条这样的，他们的文章详情页大部分基本都是tableView中嵌套webView来实现的效果，其中顶部标题，关注按钮等这些可能是原生的，内容部分是webView,评论部分，相关推荐等是原生的，对于这样一样比较复杂的页面，今天这里提供一个类似的demo

<img src="https://images2018.cnblogs.com/blog/950551/201806/950551-20180608162437534-368859194.png" width="40%" height="40%"><img src="https://images2018.cnblogs.com/blog/950551/201806/950551-20180608161606399-1433122610.png" width="40%" height="40%">

demo中顶部图片 顶部标题，活动时间等相关信息都是原生的代码实现下面活动详情是由webView来实现，最底部评论模块一般都是原生来实现

实现这种效果的主要思路就是拿到数据后，去加载webView，等webView加载完毕后，拿到html的高度，去重新设置网页部分的高度

核心实现代码：
```
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
```
解析json数据
```
    //取出json文件
    NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"addata" ofType:@"json"]];
    
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
```

更多源码请参考demo: https://github.com/qqcc1388/TYWebViewInTableViewDemo

转载请标注来源：https://www.cnblogs.com/tinych/p/9156236.html
