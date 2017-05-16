//
//  AddSensorViewController.m
//  KBTU_SCADA
//
//  Created by Altynbek Orumbayev on 30/04/2017.
//  Copyright © 2017 A_Orumbayev. All rights reserved.
//

#import "AOAddSensorViewController.h"
#import "AOSensor.h"

@interface AddSensorViewController () <UIImagePickerControllerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *sensorTextField;
@property (strong, nonatomic) IBOutlet UIImageView *sensorImageView;
@property (strong, nonatomic) IBOutlet UIButton *attachDataset;
@property (strong, nonatomic) IBOutlet UILabel *datasetLabel;

@end

@implementation AddSensorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sensorTextField.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (IBAction)addSensorBtnPressed:(id)sender {

    if (self.sensorTextField.text.length > 0 && self.sensorImageView.image) {
    AOSensor *newSensor = [[AOSensor alloc] initWithTitle:self.sensorTextField.text andDataset:@""];
        newSensor.sensorImage = self.sensorImageView.image;
        [self.delegate didCreateSensor:newSensor];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    else {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please, make sure you have entered correct values" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [ac addAction:ok];
        [self presentViewController:ac animated:YES completion:nil];
    }
    
}

#pragma mark - Image Picker Delegate and Helpers

- (IBAction)setImagePressed:(UIButton *)sender {
    
    if ([sender.titleLabel.text isEqualToString:@"Set Image"]) {
        sender.alpha = 0.0f;
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //You can retrieve the actual UIImage
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    self.sensorImageView.alpha = 0.0f;
    self.sensorImageView.image = image;
    [UIView animateWithDuration:0.25 animations:^{
        self.sensorImageView.alpha = 1.0f;
    }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
