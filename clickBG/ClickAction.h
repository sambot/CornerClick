/*
 Copyright 2003-2010 Greg Schueler
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

/* ClickAction */

#import <Cocoa/Cocoa.h>
@class Clicker;

@interface ClickAction : NSObject <NSCopying>
{
    NSString* myString;
    NSInteger theType;
    NSInteger theCorner;
    NSInteger theModifiers;
	NSInteger theTrigger;
    BOOL hoverTriggerDelayed;
    NSImage *myIcon;
    NSString *myLabel;
    NSString *trueLabel;
    Clicker *myClicker;
    NSAppleScript *myScript;
    NSDate *scriptLastModified;
}

- (void)doAction:(NSEvent*)theEvent;
/*-(id)initWithType: (int) type andModifiers: (int) modifiers andString: (NSString *)theString forCorner: (int) corner andClicker:(Clicker *) clicker;
-(id)initWithType: (int) type andModifiers: (int) modifiers andString: (NSString *)theString forCorner: (int) corner withLabel:(NSString *) label andClicker:(Clicker *) clicker;
*/
-(id)initWithType: (NSInteger) type andModifiers: (NSInteger) modifiers andTrigger: (NSInteger) trigger  isDelayed: (BOOL) hoverTriggerDelayed  andString: (NSString *)theString
		forCorner: (NSInteger)corner withLabel: (NSString *)label andClicker:(Clicker *) clicker;
-(void)hideCurrentAction;
-(void)hideOthersAction;
-(NSInteger)type;
-(NSInteger)corner;
-(NSInteger)modifiers;
-(NSString *)string;
-(NSString *)label;
-(NSImage *)icon;
- (NSString *) labelSetting;
-(NSInteger)trigger;
- (void) setLabelSetting:(NSString *) label;
-(void) setString: (NSString *) string;
-(void) setLabel: (NSString *) label;
-(void) setIcon: (NSImage *) icon;
-(void) setCorner: (NSInteger) corner;
-(void) setType: (NSInteger) type;
-(void) setModifiers: (NSInteger) modifiers;
-(void) setTrigger: (NSInteger) trigger;
-(void) setHoverTriggerDelayed: (BOOL) delayed;
-(BOOL) hoverTriggerDelayed;
- (NSComparisonResult)triggerCompare:(ClickAction *)anAction;


-(void)setIconAndLabelUserProvided: (NSString *) label;
- (void) runAppleScriptAction;
- (BOOL) isValid;

//static
+ (void) logAppleScriptError:(NSDictionary *) err atStep:(NSString *)step;
+ (NSString *) stringNameForActionType: (NSInteger) type;
+ (NSString *) labelNameForActionType: (NSInteger) type;
+ (BOOL) validActionType: (NSInteger) type andString: (NSString *) action;

+ (void) exposeAllWindowsAction;
+ (void) exposeApplicationWindowsAction;
+ (void) exposeDesktopAction;
+ (void) dashboardAction;
+ (void) screensaverAction;

@end
