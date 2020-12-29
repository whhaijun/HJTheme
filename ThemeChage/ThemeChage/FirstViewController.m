//
//  FirstViewController.m
//  ThemeChage
//
//  Created by HJ on 2020/12/29.
//  Copyright © 2020 HJ. All rights reserved.
//

#import "FirstViewController.h"
#import "HJThemeManager.h"

@interface FirstViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray<NSArray<NSDictionary<NSString *,NSString *> *>*> *dataSource;
@end

@implementation FirstViewController

- (NSArray<NSArray<NSDictionary<NSString *,NSString *> *>*> *)dataSource {
    return @[
        @[
            @{@"Dark": @"CMSTabBarController"},
            @{@"Light": @"CMSHomePageViewController"},
            @{@"首页-自行构造数据测试": @"CMSHomePageViewController"},
        ],
        @[
            @{@"首页样式数据配置测试": @"CMSHomePageByConfigVC"},
            @{@"TableView组件数copy首页": @"hj_TB_HomeViewController"},
            @{@"UIView+CMSBackGroud": @"CMSBackGroudViewController"},
            @{@"UIImageView+CMSResource": @"CMSTESTImageViewController"},
            @{@"滚动视图": @"CMSCollectionViewController"},
            @{@"CMSPopoverMenu": @"PopoverMenu"},
            @{@"CMSTitleImageView": @"CMSNewsTestViewController"},
            @{@"交易首页": @"CMSTradePageController"},
            @{@"首页组件展示测试": @"HomePageDemonstrationComponentsVC"},
            @{@"首页CMSRecommendTargetInfoView": @"CMSRecommendTargetInfoTestVC"},
            @{@"首页音频播放测试Swift": @"CMSAudioViewController"},
            @{@"首页音频播放测试OC": @"CMSAuidoPlayController"},
            @{@"跑马灯效果": @"CMSLinearControlViewController"},
            @{@"首页组件CMSLinearButtonsView": @"CMSLinearButtonsTestVC"},
            @{@"GridButton与AdaptWidthButton瀑布流列表": @"CMSGridButtonCollectionVC"},
            @{@"CMSFoldTableView": @"CMSFoldMarketViewController"},
            @{@"数据解析绑定器-CMSDataBinderVC": @"CMSDataBinderViewController"},
            @{@"CMSNumberTextFieldDemo": @"CMSNumberTextFieldDemo"},
            @{@"交易展示": @"CMSAutoTradeViewController"},
            @{@"高级设置-CMSAdvancedSetup":@"CMSAdvancedSetupTest"},
            @{@"智能下单": @"CMSSmartOrderViewController"},
            @{@"CMSHomeRecommend": @"CMSHomeRecommendViewController"},
            @{@"自选股票管理页面": @"CMSSelfSelectStockManagementViewController"},
            @{@"自选股票CMSSelfSelectStockView": @"CMSSelfSelectStockViewController"},
            
        ]
    ];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"theme test 2";
    [self.view addSubview:self.tableView];
    self.tableView.hj_themeBackgroundColor = backgroundColorKey;
    [self addRightChangeThemeButton];
}

- (void)addRightChangeThemeButton {
    UIBarButtonItem *but = [[UIBarButtonItem alloc] initWithTitle:@"更换皮肤" style:UIBarButtonItemStylePlain target:self action:@selector(changeThemeMethod)];
    self.navigationItem.rightBarButtonItem = but;
}

- (void)changeThemeMethod {
    UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:@"更换皮肤" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *accountAction1 = [UIAlertAction actionWithTitle:@"Light" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[HJThemeManager sharedInstance] switchThemeWithName:@"Light"];
    }];
    [actionSheetController addAction:accountAction1];
    
    UIAlertAction *accountAction2 = [UIAlertAction actionWithTitle:@"Dark" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[HJThemeManager sharedInstance] switchThemeWithName:@"Dark"];
    }];
    [actionSheetController addAction:accountAction2];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:nil];
    [actionSheetController addAction:cancelAction];
    
    [self presentViewController:actionSheetController animated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource[section].count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *array = @[@"UI效果", @"组件效果演示"];
    if (array.count > section) {
        return array[section];;
    }
    return @"功能展示";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
       if (cell == nil){
           cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
           
           UIImageView *testView = [UIImageView new];
           testView.tag = 100;
           testView.frame = CGRectMake(0, 7, 30, 30);
           [cell.contentView addSubview:testView];
           
           UILabel *label = [UILabel new];
           label.tag = 110;
           label.frame = CGRectMake(40, 7, self.view.frame.size.width - 40, 30);
           [cell.contentView addSubview:label];
       }
    UILabel *label = [cell.contentView viewWithTag:110];
    label.text = self.dataSource[indexPath.section][indexPath.row].allKeys.firstObject;
    label.hj_themeTextColor = mainTextColorKey;
    cell.hj_themeBackgroundColor = backgroundColorKey;
    UIImageView *testView = [cell.contentView viewWithTag:100];
    testView.hj_themeImage = iconImageKey;
    cell.selectionStyle = 0;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [[HJThemeManager sharedInstance] switchThemeWithName:@"Dark"];
        }
        else if (indexPath.row == 1) {
            [[HJThemeManager sharedInstance] switchThemeWithName:@"Light"];
        }
    }
}

# pragma mark - 懒加载
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        _tableView.delegate  = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end

