//
//  Case8ViewController.m
//  MasonryExample
//
//  Created by zorro on 15/12/5.
//  Copyright © 2015年 tutuge. All rights reserved.
//

#import "Case8ViewController.h"
#import "Case8Cell.h"
#import "Case8DataEntity.h"
#import "Common.h"

@interface Case8ViewController () <UITableViewDelegate, UITableViewDataSource, Case8CellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *data;
@end

@implementation Case8ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 80.0f;

    // 注册Cell
    [_tableView registerClass:[Case8Cell class] forCellReuseIdentifier:NSStringFromClass([Case8Cell class])];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self generateData];
    [_tableView reloadData];
}

#pragma mark - Case8CellDelegate

- (void)case8Cell:(Case8Cell *)cell switchExpandedStateWithIndexPath:(NSIndexPath *)index {
    // 改变数据
    Case8DataEntity *case8DataEntity = _data[(NSUInteger) index.row];
    case8DataEntity.expanded = !case8DataEntity.expanded; // 切换展开还是收回
    case8DataEntity.cellHeight = 0; // 重置高度缓存
    
    // 只会重新计算高度,不会reload cell,所以只是把原来的cell撑大了而已,还是同一个cell实例
//    [_tableView beginUpdates];
//    [_tableView endUpdates];

    // 先重新计算高度,然后reload,不是原来的cell实例
    [_tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static Case8Cell *templateCell;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        templateCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([Case8Cell class])];
    });

    // 获取对应的数据
    Case8DataEntity *dataEntity = _data[(NSUInteger) indexPath.row];

    // 判断高度是否已经计算过
    if (dataEntity.cellHeight <= 0) {
        // 填充数据
        [templateCell setEntity:dataEntity indexPath:[NSIndexPath indexPathForRow:-1 inSection:-1]];
        // 根据当前数据，计算Cell的高度，注意+1
        dataEntity.cellHeight = [templateCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 0.5f;
        NSLog(@"Calculate height: %ld", (long) indexPath.row);
    } else {
        NSLog(@"Get cache %ld", (long) indexPath.row);
    }

    return dataEntity.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Case8Cell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([Case8Cell class]) forIndexPath:indexPath];
    [cell setEntity:_data[(NSUInteger) indexPath.row] indexPath:indexPath];
    cell.delegate = self;
    return cell;
}

#pragma mark - Private methods

// 生成数据
- (void)generateData {
    NSMutableArray *tmpData = [NSMutableArray new];

    for (int i = 0; i < 20; i++) {
        Case8DataEntity *dataEntity = [Case8DataEntity new];
        dataEntity.content = [Common getText:@"case 8 content. " withRepeat:i * 2 + 10];
        [tmpData addObject:dataEntity];
    }

    _data = tmpData;
}

@end