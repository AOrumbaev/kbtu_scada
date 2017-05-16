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

@interface SensorViewController () <UITableViewDelegate, UITableViewDataSource, AddSensorViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SensorViewController

#pragma mark - UIView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableViewDelegate & Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    SensorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sensorCell"];
    
    Sensor *currentSensor = [Storage sharedInstance].sensorsArray[indexPath.row];
    
    cell.imageView.image = currentSensor.sensorImage;
    cell.titleLabel.text = currentSensor.title;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [Storage sharedInstance].sensorsArray.count;
}

- (IBAction)addBtnPressed:(UIBarButtonItem *)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddSensorViewController * vc = (AddSensorViewController *)[sb instantiateViewControllerWithIdentifier:@"SensorVC"];
    vc.delegate = self;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - AddSensorViewController

- (void)didCreateSensor:(Sensor *)sensor {
    if (sensor) {
        [[Storage sharedInstance].sensorsArray addObject:sensor];
        [self.tableView reloadData];
    }
}

@end
