//
//  AW_Project.m
//  Hacker School
//
//  Created by Alan Wang on 1/28/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AW_Project.h"

// --- Constants ---
NSString * const TITLE_KEY = @"title";
NSString * const URL_STRING_KEY = @"urlString";
NSString * const PROJECT_DECRIPTION_KEY = @"projectDescription";
NSString * const PROJECT_DESCRIPTION_FORMATTED_KEY = @"projectDescriptionFormatted";

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

#pragma mark - NSCoding

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:TITLE_KEY];
    [aCoder encodeObject:self.urlString forKey:URL_STRING_KEY];
    [aCoder encodeObject:self.projectDescription forKey:PROJECT_DECRIPTION_KEY];
    [aCoder encodeObject:self.projectDescriptionFormatted forKey:PROJECT_DESCRIPTION_FORMATTED_KEY];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        self.title = [aDecoder decodeObjectForKey:TITLE_KEY];
        self.urlString = [aDecoder decodeObjectForKey:URL_STRING_KEY];
        self.projectDescription = [aDecoder decodeObjectForKey:PROJECT_DECRIPTION_KEY];
        self.projectDescriptionFormatted = [aDecoder decodeObjectForKey:PROJECT_DESCRIPTION_FORMATTED_KEY];
    }
    
    return self;
}


#pragma mark -

// I use this method rather than perform the conversion in a getter because this will allow me to put up a temporary loading screen
// if projectDescriptionFormatted is nil while converting.
-(NSAttributedString *)formatProjectDescription
{
    // Early exit if no description
    if ([self.projectDescription isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
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
