//
//  AW_Project.h
//  Hacker School
//
//  Created by Alan Wang on 1/28/15.
//  Copyright (c) 2015 Alan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
    This class represents a Hacker School project. It has a name, url, and description.
 */
@interface AW_Project : NSObject <NSCoding>

@property (nonatomic, strong) NSString *title;                                  ///< Project name
@property (nonatomic, strong) NSString *urlString;                              ///< URL that project is linked to
@property (nonatomic, strong) NSString *projectDescription;                     ///< Description of project with raw HTML
@property (nonatomic, strong) NSAttributedString *projectDescriptionFormatted;  ///< Description of project formatted to NSAttributedString

/**
    @brief Returns an initialized project from a JSON object.
    @param projectInfo JSON object containing project information.
    @return Initialized project object with all properties set except for @b projectDescriptionFormatted.
*/
- (instancetype)initFromJsonObject:(NSDictionary *)projectInfo; //designated


/**
    Uses the main thread to convert the HTML tags in projectDescription into a formatted NSAttributedString. Sets the result to the
    projectDescriptionFormatted property. Because the implementation currently involves using WebKit, it must be run on the main thread.
 
    @brief Creates a formatted attributed string from HTML tags in projectDescription.
    @return Attributed string with formatted project description.
 */
- (NSAttributedString *)formatProjectDescription;

@end
