//
//  AW_Project.m
//  Hacker School
//
//  Created by Alan Wang on 1/28/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AW_Project.h"

@implementation AW_Project


#pragma mark - Initializers

- (instancetype)initFromJsonObject:(NSDictionary *)projectInfo
{
    self = [super init];
    
    if (self) {
        _title = projectInfo[@"title"];
        _urlString = projectInfo[@"url"];
        _projectDescription = projectInfo[@"description"];
        
        
    }
    
    return self;
}

-(instancetype)init
{
    [NSException raise:@"Empty AW_Project not allowed" format:@"Use initFromJsonObject instead"];
    
    return nil;
}

#pragma mark -

// I use this method rather than perform the converstion in a getter because this will allow me to put up a temporary loading screen
// if projectDescriptionFormatted is nil while converting.
-(NSAttributedString *)formatProjectDescription
{
    // Convert raw projectDescription string (with HTML tags) to attributed string
    NSString *htmlProjectDescription = self.projectDescription;
    htmlProjectDescription = [htmlProjectDescription stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    htmlProjectDescription = [NSString stringWithFormat:@"<span style=\"font-family: HelveticaNeue; font-size: 17; color: black;\">%@</span>", htmlProjectDescription];
    
    // Supposedly this can only be done on the main thread. Something about Webkit requiring run cycles
    NSAttributedString *attributedProjectDescription = [[NSAttributedString alloc]initWithData:[htmlProjectDescription dataUsingEncoding:NSUnicodeStringEncoding]
                                                                                       options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                                            documentAttributes:nil
                                                                                         error:nil];
    self.projectDescriptionFormatted = attributedProjectDescription;

    NSLog(@"Project description formatted");
    return self.projectDescriptionFormatted;
}

@end
