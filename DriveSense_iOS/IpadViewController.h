//
//  IpadViewController.h
//  DriveSense_iOS
//
//  Created by Mickey Barboi on 2/27/14.
//  Copyright (c) 2014 Mickey Barboi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IpadViewController : UIViewController {
    
    __weak IBOutlet UIView *viewContainer;
    __weak IBOutlet UIView *containerLeft;
}
- (IBAction)record:(id)sender;
- (IBAction)trips:(id)sender;
- (IBAction)settings:(id)sender;

@end
