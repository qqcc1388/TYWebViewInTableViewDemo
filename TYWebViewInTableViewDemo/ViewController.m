//
//  ViewController.m
//  TYWebViewInTableViewDemo
//
//  Created by Tiny on 2018/6/8.
//  Copyright © 2018年 hxq. All rights reserved.
//  在TableView中嵌套WebView

#import "ViewController.h"
#import "TYActivityHeaderView.h"
#import "Masonry.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) TYActivityHeaderView *headerView;

@end

@implementation ViewController

-(TYActivityHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[TYActivityHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0)];
        __weak typeof(self) weakself = self;
        _headerView.headerBlock = ^(CGFloat height) {
            CGRect rect = weakself.headerView.frame;
            rect.size.height = height;
            weakself.headerView.frame = rect;
            weakself.tableView.tableHeaderView = weakself.headerView;
        };
    }
    return _headerView;
}

-(UITableView*)tableView{
    if(!_tableView){
        self.tableView = ({
            UITableView* tableView = [[UITableView alloc] init];
            tableView.tableHeaderView = self.headerView;
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.backgroundColor = [UIColor whiteColor];
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableView;
        });
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //有些场景 含有大量资讯的页面 还有大量图片，这时候如果全部用webView用户体验会比较差，所以出现这样的场景，比较好的做法是采用tableView中嵌套WebView的做法
    [self setupUI];
    
    [self loadData];
}

-(void)setupUI{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(0);
    }];
}

-(void)loadData{
    //取出json文件
    NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"addata" ofType:@"json"]];
    
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
    //赋值
    self.headerView.paramDict = jsonDict[@"datas"];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = @"测试数据";
    return cell;
}

@end
