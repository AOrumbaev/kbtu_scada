//
//  SensorViewController.m
//  KBTU_SCADA
//
//  Created by Altynbek Orumbayev on 30/04/2017.
//  Copyright © 2017 A_Orumbayev. All rights reserved.
//

#import "AOSensorViewController.h"
#import "AOAddSensorViewController.h"
#import "AOSensor.h"
#import "AOSensorCell.h"
#import "AOStorage.h"
#import "TBWebViewController.h"

@interface AOSensorViewController () <UITableViewDelegate, UITableViewDataSource, AddSensorViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AOSensorViewController

#pragma mark - UIView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"adad" image:[UIImage imageNamed:@"share-7"] tag:1];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableViewDelegate & Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AOSensorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AOSensorCell"];
    
    AOSensor *currentSensor = [AOStorage sharedInstance].sensorsArray[indexPath.row];
    
    cell.imageView.image = currentSensor.sensorImage;
    cell.titleLabel.text = currentSensor.title;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [AOStorage sharedInstance].sensorsArray.count;
}

- (IBAction)addBtnPressed:(UIBarButtonItem *)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddSensorViewController * vc = (AddSensorViewController *)[sb instantiateViewControllerWithIdentifier:@"SensorVC"];
    vc.delegate = self;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AOSensor *curSensor = [AOStorage sharedInstance].sensorsArray[indexPath.row];
    
    if (curSensor.datasetLink) {
        TBWebViewController *vc = [[TBWebViewController alloc] init];
        [vc loadUrl:curSensor.datasetLink];
        [self.navigationController pushViewController:vc animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - AddSensorViewController

- (void)didCreateSensor:(Sensor *)sensor {
    if (sensor) {
        [[AOStorage sharedInstance].sensorsArray addObject:sensor];
        [self.tableView reloadData];
    }
}

@end
