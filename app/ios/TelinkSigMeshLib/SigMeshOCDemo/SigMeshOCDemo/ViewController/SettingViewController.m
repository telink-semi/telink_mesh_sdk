/********************************************************************************************************
 * @file     SettingViewController.m 
 *
 * @brief    for TLSR chips
 *
 * @author   Telink, 梁家誌
 * @date     2018/7/31
 *
 * @par     Copyright (c) [2021], Telink Semiconductor (Shanghai) Co., Ltd. ("TELINK")
 *
 *          Licensed under the Apache License, Version 2.0 (the "License");
 *          you may not use this file except in compliance with the License.
 *          You may obtain a copy of the License at
 *
 *              http://www.apache.org/licenses/LICENSE-2.0
 *
 *          Unless required by applicable law or agreed to in writing, software
 *          distributed under the License is distributed on an "AS IS" BASIS,
 *          WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *          See the License for the specific language governing permissions and
 *          limitations under the License.
 *******************************************************************************************************/

#import "SettingViewController.h"
#import "SettingItemCell.h"
#import "MeshOTAVC.h"
#import "ResponseTestVC.h"

@interface SettingViewController()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <NSString *>*source;
@property (nonatomic, strong) NSMutableArray <NSString *>*iconSource;
@property (nonatomic, strong) NSMutableArray <NSString *>*vcIdentifiers;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@end

@implementation SettingViewController

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettingItemCell *cell = (SettingItemCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifiers_SettingItemCellID forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.nameLabel.text = self.source[indexPath.row];
    cell.iconImageView.image = [UIImage imageNamed:self.iconSource[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *titleString = self.source[indexPath.row];
    NSString *sb = @"Setting";
    UIViewController *vc = nil;
    if ([titleString isEqualToString:@"Log"] || [titleString isEqualToString:@"Choose Add Devices"]) {
        sb = @"Main";
    }
    
    if ([titleString isEqualToString:@"Mesh OTA"]) {
        vc = [[MeshOTAVC alloc] init];
    } else if ([titleString isEqualToString:@"Test"]) {
//        vc = [[ResponseTestVC alloc] init];
//        ((ResponseTestVC *)vc).isResponseTest = YES;
        [self clickTest];
        return;
    } else {
        vc = [UIStoryboard initVC:self.vcIdentifiers[indexPath.row] storybroad:sb];
    }
    if ([titleString isEqualToString:@"Choose Add Devices"]) {
        [SigDataSource.share setAllDevicesOutline];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.source.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 51.0;
}

- (void)clickTest {
    __weak typeof(self) weakSelf = self;
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Select Test Actions" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertT1 = [UIAlertAction actionWithTitle:@"Response Test" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ResponseTestVC *vc = [[ResponseTestVC alloc] init];
        vc.isResponseTest = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [actionSheet addAction:alertT1];
    UIAlertAction *alertT2 = [UIAlertAction actionWithTitle:@"Interval Test" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ResponseTestVC *vc = [[ResponseTestVC alloc] init];
        vc.isResponseTest = NO;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [actionSheet addAction:alertT2];
    UIAlertAction *alertF = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Cancel");
    }];
    [actionSheet addAction:alertF];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)normalSetting{
    [super normalSetting];
    self.title = @"Setting";
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.source = [NSMutableArray array];
    self.iconSource = [NSMutableArray array];
    self.vcIdentifiers = [NSMutableArray array];
    if (kShowScenes) {
        [self.source addObject:@"Scenes"];
        [self.iconSource addObject:@"scene"];
        [self.vcIdentifiers addObject:ViewControllerIdentifiers_SceneListViewControllerID];
    }
    if (kshowShare) {
        [self.source addObject:@"Share"];
        [self.iconSource addObject:@"ic_model"];
        [self.vcIdentifiers addObject:ViewControllerIdentifiers_ShareViewControllerID];
    }
    #ifdef kExist
    if (kExistMeshOTA) {
        [self.source addObject:@"Mesh OTA"];
        [self.iconSource addObject:@"ic_mesh_ota"];
        [self.vcIdentifiers addObject:@"no found"];
    }
    #endif
    if (kshowLog) {
        [self.source addObject:@"Log"];
        [self.iconSource addObject:@"ic_model"];
        [self.vcIdentifiers addObject:ViewControllerIdentifiers_LogViewControllerID];
    }
    if (kshowMeshInfo) {
        [self.source addObject:@"Mesh Info"];
        [self.iconSource addObject:@"ic_model"];
        [self.vcIdentifiers addObject:ViewControllerIdentifiers_MeshInfoViewControllerID];
    }
    if (kshowMeshSettings) {
        [self.source addObject:@"Settings"];
        [self.iconSource addObject:@"ic_model"];
        [self.vcIdentifiers addObject:ViewControllerIdentifiers_SettingsVCID];
    }
    if (kshowChooseAdd) {
        [self.source addObject:@"Choose Add Devices"];
        [self.iconSource addObject:@"ic_model"];
        [self.vcIdentifiers addObject:ViewControllerIdentifiers_ChooseAndAddDeviceViewControllerID];
    }
#ifdef kExist
    if (kshowTest) {
        [self.source addObject:@"Test"];
        [self.iconSource addObject:@"ic_model"];
        [self.vcIdentifiers addObject:ViewControllerIdentifiers_TestVCID];
    }
#endif

    NSString *app_Version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
#ifdef DEBUG
    NSString *appBundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    self.versionLabel.text = [NSString stringWithFormat:@"V%@ Bulid:%@",app_Version,appBundleVersion];
#else
    self.versionLabel.text = [NSString stringWithFormat:@"V%@",app_Version];
#endif

}

@end
