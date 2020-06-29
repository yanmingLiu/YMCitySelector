//
//  YMCitySelector.m
//  Pods-YMCitySelector_Example
//
//  Created by mni on 2020/6/29.
//

#import "YMCitySelector.h"
#import <YYKit/NSObject+YYModel.h>

#define color_black [UIColor colorWithRed:72/255.0 green:72/255.0 blue:72/255.0 alpha:1.0]

#define color_green [UIColor colorWithRed:34/255.0 green:187/255.0 blue:98/255.0 alpha:1.0]

/*--------------------=======分类，利用yymodel解析数组========----------------------*/
@implementation NSObject (YM)

+ (NSArray *)ym_modelArrayWithJsons:(id)jsons {
    NSMutableArray *models = [NSMutableArray array];
    for (NSDictionary *json in jsons) {
        id model = [[self class] modelWithJSON:json];
        if (model) {
            [models addObject:model];
        }
    }
    return models;
}

/**
 获取文件所在name，默认情况下podName和bundlename相同，传一个即可s
 
 @param bundleName bundle名字，就是在resource_bundles里面的名字
 @param podName pod的名字
 @return bundle
 */
+ (NSBundle *)bundleWithBundleName:(NSString *)bundleName podName:(NSString *)podName {
    if (bundleName == nil && podName == nil) {
        @throw @"bundleName和podName不能同时为空";
    } else if (bundleName == nil ) {
        bundleName = podName;
    } else if (podName == nil) {
        podName = bundleName;
    }
    if ([bundleName containsString:@".bundle"]) {
        bundleName = [bundleName componentsSeparatedByString:@".bundle"].firstObject;
    }
    //没使用framwork的情况下
    NSURL *associateBundleURL = [[NSBundle mainBundle] URLForResource:bundleName withExtension:@"bundle"];
    //使用framework形式
    if (!associateBundleURL) {
        associateBundleURL = [[NSBundle mainBundle] URLForResource:@"Frameworks" withExtension:nil];
        associateBundleURL = [associateBundleURL URLByAppendingPathComponent:podName];
        associateBundleURL = [associateBundleURL URLByAppendingPathExtension:@"framework"];
        NSBundle *associateBunle = [NSBundle bundleWithURL:associateBundleURL];
        associateBundleURL = [associateBunle URLForResource:bundleName withExtension:@"bundle"];
    }
    NSAssert(associateBundleURL, @"取不到关联bundle");
    //生产环境直接返回空
    return associateBundleURL?[NSBundle bundleWithURL:associateBundleURL]:nil;
}

@end

/*--------------------=======数据模型========----------------------*/

@implementation AXCity

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"area" : [NSString class]};
}
@end

@implementation AXProvince

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"city" : [AXCity class]};
}

+ (NSArray<AXProvince *> * _Nullable )getRegions {
    @try {
        NSString *path = [[self bundleWithBundleName:@"YMCitySelector" podName:@"YMCitySelector"] pathForResource:@"regions" ofType:@"json"];
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        id json = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
        NSArray *arr = [AXProvince ym_modelArrayWithJsons:json];
        return arr;
    } @catch (NSException *exception) {
        NSLog(@"获取城市数据错误：%@", exception);
    } @finally {
        
    }
}

@end


/*--------------------========视图=======----------------------*/

@interface ButtonsView : UIView
@property (nonatomic, strong) UIButton *cacelBtn;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *label;
@end

@implementation ButtonsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"所在地区";
        label.font = [UIFont boldSystemFontOfSize:17];
        label.textColor = [UIColor colorWithRed:72/255.0 green:72/255.0 blue:72/255.0 alpha:1.0];
        [label sizeToFit];
        [self addSubview:label];
        self.label = label;
        
        UIButton *cancel = [[UIButton alloc] init];
        cancel.titleLabel.font = [UIFont systemFontOfSize:15];
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        [cancel setTitleColor:[UIColor colorWithRed:132/255.0 green:132/255.0 blue:132/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self addSubview:cancel];
        self.cacelBtn = cancel;
        
        UIButton *sure = [[UIButton alloc] init];
        sure.titleLabel.font = [UIFont systemFontOfSize:15];
        [sure setTitle:@"确定" forState:UIControlStateNormal];
        [sure setTitleColor:[UIColor colorWithRed:34/255.0 green:187/255.0 blue:98/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self addSubview:sure];
        self.sureBtn = sure;
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0];
        [self addSubview:line];
        self.line = line;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat btnWH = 63;
    CGFloat x = 10;
    CGFloat w = self.frame.size.width;
    
    self.label.center = CGPointMake(w/2, self.frame.size.height/2);
    self.cacelBtn.frame = CGRectMake(x, 0, btnWH, btnWH);
    self.sureBtn.frame = CGRectMake(w-10-btnWH, 0, btnWH, btnWH);
    self.line.frame = CGRectMake(0, btnWH, w, 1);
}

@end

/*--------------------=======城市选择器========----------------------*/

@interface YMCitySelector () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *contentVeiw;

@property (nonatomic, strong) UITableView *fistTableView;
@property (nonatomic, strong) UITableView *secondTableView;
@property (nonatomic, strong) UITableView *thirdTableView;
@property (nonatomic, strong) ButtonsView *btnView;

@property (nonatomic, strong) NSArray *regions;

@property (nonatomic, strong) NSIndexPath *firstIndex;
@property (nonatomic, strong) NSIndexPath *secondIndex;
@property (nonatomic, strong) NSIndexPath *thirdIndex;
@end

@implementation YMCitySelector

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self loadData];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [touches.anyObject locationInView:self.view];
    if (!CGRectContainsPoint(self.fistTableView.frame, point)
        || !CGRectContainsPoint(self.secondTableView.frame, point)
        || !CGRectContainsPoint(self.thirdTableView.frame, point)
        || !CGRectContainsPoint(self.btnView.frame, point)) {
        [self dismiss];
    }
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    
    [self.view addSubview:self.contentVeiw];
    [self.contentVeiw addSubview:self.btnView];
    [self.contentVeiw addSubview:self.fistTableView];
    [self.contentVeiw addSubview:self.secondTableView];
    [self.contentVeiw addSubview:self.thirdTableView];
    
    CGFloat bottom = 0;
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    if (@available(iOS 11.0, *)) {
        bottom = window.safeAreaInsets.bottom;
    }
    CGFloat h = self.view.frame.size.height * 0.8 ;
    CGFloat w = self.view.frame.size.width-30;
    CGFloat btnH = 64;
    CGFloat tableW = w / 3;
    CGFloat tableH =  h - btnH;
    self.contentVeiw.frame = CGRectMake(15, window.bounds.size.height - h - 64, w, h - bottom);
    self.btnView.frame = CGRectMake(0, 0, w, btnH);
    self.fistTableView.frame = CGRectMake(0, btnH, tableW, tableH);
    self.secondTableView.frame = CGRectMake(tableW, btnH, tableW, tableH);
    self.thirdTableView.frame = CGRectMake(tableW*2, btnH, tableW, tableH);
}

- (void)loadData {
    self.regions = [AXProvince getRegions];
    _firstIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    _secondIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    _thirdIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    [self reloadData];
}

- (void)reloadData {
    [self.fistTableView reloadData];
    [self.secondTableView reloadData];
    [self.thirdTableView reloadData];
    
    [self.fistTableView scrollToRowAtIndexPath:self.firstIndex atScrollPosition:(UITableViewScrollPositionMiddle) animated:YES];
    [self.secondTableView scrollToRowAtIndexPath:self.secondIndex atScrollPosition:(UITableViewScrollPositionMiddle) animated:YES];
    [self.thirdTableView scrollToRowAtIndexPath:self.thirdIndex atScrollPosition:(UITableViewScrollPositionMiddle) animated:YES];
}


#pragma mark - actions

- (void)fillDefaultWithProvince:(NSString *)province city:(NSString *)city area:(NSString *)area {
    if (province.length) {
        for (int i = 0; i < self.regions.count; i++) {
            AXProvince *p = self.regions[i];
            if ([p.name isEqualToString:province]) {
                self.firstIndex = [NSIndexPath indexPathForRow:i inSection:0];
                break;
            }
        }
    }
    if (city.length) {
        AXProvince *p = self.regions[self.firstIndex.row];
        for (int i = 0; i < p.city.count; i++) {
            AXCity *c = p.city[i];
            if ([c.name isEqualToString:city]) {
                self.secondIndex = [NSIndexPath indexPathForRow:i inSection:0];
                break;
            }
        }
    }
    if (area.length) {
        AXProvince *p = self.regions[self.firstIndex.row];
        AXCity *c = p.city[self.secondIndex.row];
        for (int i = 0; i < c.area.count; i++) {
            NSString *a = c.area[i];
            if ([a isEqualToString:a]) {
                self.thirdIndex = [NSIndexPath indexPathForRow:i inSection:0];
                break;
            }
        }
    }
    [self reloadData];
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window.rootViewController presentViewController:self animated:YES completion:^{
        
    }];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sure {
    AXProvince *province = self.regions[self.firstIndex.row];
    AXCity *city = province.city[self.secondIndex.row];
    NSString *area = city.area[self.thirdIndex.row];
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.callback) {
            self.callback(province.name, city.name, area);
        }
    }];
}

#pragma table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.fistTableView) {
        return self.regions.count;
    }
    else if (tableView == self.secondTableView) {
        AXProvince *province = self.regions[self.firstIndex.row];
        return province.city.count;
    }
    else if (tableView == self.thirdTableView) {
        AXProvince *province = self.regions[self.firstIndex.row];
        AXCity *city = province.city[self.secondIndex.row];
        return city.area.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = color_black;
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
    }
    if (tableView == self.fistTableView) {
        AXProvince *province = self.regions[indexPath.row];
        cell.textLabel.text = province.name;
        cell.textLabel.textColor = self.firstIndex == indexPath ? color_green : color_black;
    }
    else if (tableView == self.secondTableView) {
        AXProvince *province = self.regions[self.firstIndex.row];
        AXCity *city = province.city[indexPath.row];
        cell.textLabel.text = city.name;
        cell.textLabel.textColor = self.secondIndex == indexPath ? color_green : color_black;
    }
    else if (tableView == self.thirdTableView) {
        AXProvince *province = self.regions[self.firstIndex.row];
        AXCity *city = province.city[self.secondIndex.row];
        NSString *area = city.area[indexPath.row];
        cell.textLabel.text = area;
        cell.textLabel.textColor = self.thirdIndex == indexPath ? color_green : color_black;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.fistTableView) {
        self.firstIndex = indexPath;
        self.secondIndex = [NSIndexPath indexPathForRow:0 inSection:0];
        self.thirdIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    else if (tableView == self.secondTableView) {
        self.secondIndex = indexPath;
        self.thirdIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    else if (tableView == self.thirdTableView) {
        self.thirdIndex = indexPath;
    }
    [self reloadData];
}

#pragma makr - lazy

- (UIView *)contentVeiw {
    if (!_contentVeiw) {
        _contentVeiw = [[UIView alloc] init];
        _contentVeiw.backgroundColor = [UIColor whiteColor];
        _contentVeiw.clipsToBounds = YES;
        _contentVeiw.layer.cornerRadius = 4;
    }
    return _contentVeiw;
}

- (ButtonsView *)btnView {
    if (!_btnView) {
        _btnView = [[ButtonsView alloc] initWithFrame:CGRectMake(0, 0, self.contentVeiw.bounds.size.width, 64)];
        _btnView.backgroundColor = [UIColor whiteColor];
        [_btnView.cacelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [_btnView.sureBtn addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnView;
}

- (UITableView *)fistTableView {
    if (!_fistTableView) {
        _fistTableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _fistTableView.delegate = self;
        _fistTableView.dataSource = self;
        _fistTableView.estimatedRowHeight = 64;
        _fistTableView.backgroundColor = [UIColor whiteColor];
        _fistTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _fistTableView;
}

- (UITableView *)secondTableView {
    if (!_secondTableView) {
        _secondTableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _secondTableView.delegate = self;
        _secondTableView.dataSource = self;
        _secondTableView.estimatedRowHeight = 64;
        _secondTableView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
        _secondTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _secondTableView;
}

- (UITableView *)thirdTableView {
    if (!_thirdTableView) {
        _thirdTableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _thirdTableView.delegate = self;
        _thirdTableView.dataSource = self;
        _thirdTableView.estimatedRowHeight = 64;
        _thirdTableView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
        _thirdTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _thirdTableView;
}

@end



