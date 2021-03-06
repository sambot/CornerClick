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

#import "ClickAction.h"
#import <Carbon/Carbon.h>

@implementation ClickAction

/*-(id)initWithType: (int) type andModifiers: (int) modifiers andString: (NSString *)theString forCorner: (int)corner andClicker:(Clicker *) clicker
{
    return [self initWithType:type andModifiers:  modifiers andString:theString  forCorner: corner withLabel:nil andClicker:clicker];
    
}
-(id)initWithType: (int) type andModifiers: (int) modifiers andString: (NSString *)theString forCorner: (int)corner withLabel: (NSString *)label andClicker:(Clicker *) clicker
{
	NSLog(@"!!!!!!!!ACCCCKKKK");
	return [self initWithType:type andModifiers:modifiers andTrigger:0
					andString:theString forCorner:corner withLabel:label
				   andClicker:clicker];
}*/

-(id)initWithType: (NSInteger) type andModifiers: (NSInteger) modifiers andTrigger: (NSInteger) trigger isDelayed: (BOOL) hoverTriggerDelayedvar 
        andString: (NSString *)theString
		forCorner: (NSInteger)corner withLabel: (NSString *)label andClicker:(Clicker *) clicker
{
    if(self=[super init]){
        myIcon=nil;
        trueLabel=nil;
        myLabel=nil;
        theCorner=corner;
        theType=type;
        theModifiers=modifiers;
        myClicker=clicker;
		theTrigger=trigger;
        self->hoverTriggerDelayed=hoverTriggerDelayedvar;
        if(theString != nil){
            //myString = [[NSString stringWithString:theString] retain];
            myString = [theString copy];
        }
        [self setIconAndLabelUserProvided:label];
    }
    return self;
}

-(void)setIconAndLabelUserProvided: (NSString *) label
{
    if(myLabel!=nil)
        [myLabel release];
    if(myIcon!=nil){
        DEBUG(@"releasing icon: %@ retain: %d",myIcon,[myIcon retainCount]);
        [myIcon release];
    }
    if(trueLabel!=nil)
        [trueLabel release];
    myLabel=nil;
    trueLabel=nil;
    myIcon=nil;
    if(label!=nil)
        trueLabel = [label copy];
    switch(theType){
        case ACT_FILE:
            if(myString!=nil){
                if(label != nil){
                    myLabel = [label copy];
                }
                else if([[myString lastPathComponent] hasSuffix:@".app"]){
                    myLabel = [[[myString lastPathComponent] stringByDeletingPathExtension] retain];
                }else{
                    myLabel =[[myString lastPathComponent] retain];
                }
                myIcon = [[[NSWorkspace sharedWorkspace] iconForFile: myString] retain];
            }else{
                myLabel=nil;
                myIcon=nil;
            }
            break;
        case ACT_HIDE:
            myLabel=[[NSString stringWithString: LOCALIZE([NSBundle mainBundle],@"Hide Current Application") ] retain];
			myIcon = nil;//[[NSImage imageNamed:@"HideAppIcon"] retain];
            break;
        case ACT_HIDO:
            myLabel=[[NSString stringWithString: LOCALIZE([NSBundle mainBundle],@"Hide Other Applications") ] retain];
			myIcon = nil;//[[NSImage imageNamed:@"HideOthersIcon"] retain];
            break;
        case ACT_URL:
            if(label !=nil){
                myLabel = [label copy];
            }else if(myString==nil){
                myLabel=nil;
            }else if([myString length]> 30){
                myLabel=[[NSString stringWithFormat:@"%@...",[myString substringToIndex:30]] retain];
            }else{
                myLabel=[[NSString stringWithString:myString] retain];
            }
            myIcon = [[NSImage imageNamed:@"BookmarkPreferences"] retain];
            break;
        case ACT_SCPT:
            if(label !=nil){
                myLabel = [label copy];
            }
            else if( myString !=nil){
                myLabel = [[[myString lastPathComponent] stringByDeletingPathExtension] retain];
            }
            else {
                myLabel=nil;
                myIcon=nil;
            }
            
            if( myString !=nil){
                myIcon = [[[NSWorkspace sharedWorkspace] iconForFile: myString] retain];
            }
            
            break;
        case ACT_EALL:
            myLabel=[[NSString stringWithFormat:@"%@ - %@",
                 LOCALIZE([NSBundle mainBundle],@"Expose") ,
                 LOCALIZE([NSBundle mainBundle],@"All Windows")] retain];
			myIcon = [[NSImage imageNamed:@"WindowVous"] retain];
            
            break;
        case ACT_EAPP:
            myLabel=[[NSString stringWithFormat:@"%@ - %@",
                LOCALIZE([NSBundle mainBundle],@"Expose") ,
                LOCALIZE([NSBundle mainBundle],@"Application Windows")] retain];
			myIcon = [[NSImage imageNamed:@"WindowVous"] retain];
            break;
        case ACT_EDES:
            myLabel=[[NSString stringWithFormat:@"%@ - %@",
                LOCALIZE([NSBundle mainBundle],@"Expose") ,
                LOCALIZE([NSBundle mainBundle],@"Desktop")] retain];
			myIcon = [[NSImage imageNamed:@"WindowVous"] retain];
            break;
        case ACT_DASH:
            myLabel=[[NSString stringWithString: LOCALIZE([NSBundle mainBundle],@"Dashboard")] retain];
			myIcon = [[NSImage imageNamed:@"WindowVous"] retain];
            break;
        case ACT_SCRE:
            myLabel=[[NSString stringWithString: LOCALIZE([NSBundle mainBundle],@"ScreenSaver")] retain];
            myIcon = [[[NSWorkspace sharedWorkspace] iconForFile: @"/System/Library/Frameworks/ScreenSaver.framework/Resources/ScreenSaverEngine.app"] retain];
            break;
        default:
            myLabel=[[NSString stringWithString:@"?!@#"] retain];

    }
    //DEBUG(@"setIcon return");
}

- (NSString *) labelSetting
{
    return [[trueLabel copy] autorelease];
}

- (void) setLabelSetting: (NSString *) label
{
    [self setIconAndLabelUserProvided:label];
}

-(NSInteger)type
{
    return theType;
}
-(NSInteger)modifiers
{
    return theModifiers;
}

-(NSInteger)corner
{
    return theCorner;
}
-(NSString *)string
{
    return [[myString copy] autorelease];
}
-(NSString *)label
{
    return [[myLabel copy] autorelease];
}
-(NSImage *)icon
{
    return [[myIcon copy] autorelease];
}
-(NSInteger) trigger
{
	return theTrigger;
}

-(void) setTrigger: (NSInteger) trigger
{
	theTrigger=trigger;
}

-(void) setString: (NSString *) string
{
    [myString release];
    myString=nil;
    if(string!=nil)
        myString=[string copy];
}
-(void) setLabel: (NSString *) label
{
    [myLabel release];
    myLabel=nil;
    if(label!=nil)
        myLabel=[label copy];
}
-(void) setIcon: (NSImage *) icon
{
    [icon retain];
    [myIcon release];
    myIcon=icon;
}
-(void) setCorner: (NSInteger) corner
{
    theCorner=corner;
}
-(void) setType: (NSInteger) type
{
    theType=type;
}
-(void) setModifiers: (NSInteger) modifiers
{
    theModifiers=modifiers;
}

- (void) dealloc
{
    [myString release];
    [myLabel release];
    [myIcon release];
    [trueLabel release];
    [myScript release];
    [scriptLastModified release];
    [super dealloc];
    
}
- (void)doAction:(NSEvent*)theEvent
{
    //NSLog(@"Do Action: %d %s",theType,[myString UTF8String]);
    switch(theType){
        case ACT_FILE:
            [[NSWorkspace sharedWorkspace] openFile:myString];
            break;
        case ACT_HIDE : 
            [self hideCurrentAction];
            break;
        case ACT_HIDO :
            [self hideOthersAction];
            break;
        case ACT_URL:
            [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:myString]];
            break;
        case ACT_SCPT:
            [self runAppleScriptAction];
            break;
        case ACT_EALL:
            [ClickAction exposeAllWindowsAction];
            break;
        case ACT_EAPP:
            [ClickAction exposeApplicationWindowsAction];
            break;
        case ACT_EDES:
            [ClickAction exposeDesktopAction];
            break;
        case ACT_DASH:
            [ClickAction dashboardAction];
            break;
        case ACT_SCRE:
            [ClickAction screensaverAction];
            break;
        default:
            break;
    }
}

+ (void) exposeAllWindowsAction
{
    [CornerClickSupport generateKeystrokeForKeyCode:
        [CornerClickSupport keyCodeForExposeAction:0] 
                                      withModifiers: 
        [CornerClickSupport modifiersForExposeAction:0]];
}
+ (void) exposeApplicationWindowsAction
{
    
    [CornerClickSupport generateKeystrokeForKeyCode:
        [CornerClickSupport keyCodeForExposeAction:1] 
                                      withModifiers: 
        [CornerClickSupport modifiersForExposeAction:1]];}
+ (void) exposeDesktopAction
{
    
    [CornerClickSupport generateKeystrokeForKeyCode:
        [CornerClickSupport keyCodeForExposeAction:2] 
                                      withModifiers: 
        [CornerClickSupport modifiersForExposeAction:2]];}

+ (void) dashboardAction
{
    
    [CornerClickSupport generateKeystrokeForKeyCode:
        [CornerClickSupport keyCodeForExposeAction:3] 
                                      withModifiers: 
        [CornerClickSupport modifiersForExposeAction:3]];
    
}

+ (void) screensaverAction
{
    [[NSWorkspace sharedWorkspace] openFile:@"/System/Library/Frameworks/ScreenSaver.framework/Resources/ScreenSaverEngine.app"];
}

- (void) toggleAppAction
{
    
    ProcessSerialNumber psn;
    FSRef file;
    //    ProcessSerialNumber paramPsn;
    OSErr err;
	//NSLog(@"myClicker class: %@",[myClicker class]);
	//psn = [myClicker lastActivePSN];
	psn.highLongOfPSN = 0;
	psn.lowLongOfPSN = 0;
	err = GetFrontProcess(&psn);
    if(err==0){
	}else{
		NSLog(@"error after get front process");
        return;
	}
    
    err = GetProcessBundleLocation(&psn,&file);
    if(err!=0){
		NSLog(@"error after get Process bundle location");
        return;
	}
    
 //   err = FSGetCatalogInfo(&psn,null,null,
    
    err=ShowHideProcess(&psn, (Boolean)NO);
    if(err==0){
	}else{
		NSLog(@"error after get front process");
	}
	//[myClicker getNextPSN];
    
}

+ (void) logAppleScriptError:(NSDictionary *) err atStep:(NSString *)step
{
    NSLog(@"Error %@ AppleScript: Message: %@, Error Number: %@, AppName: %@, BriefMessage: %@, Range:%@",step,
          [err objectForKey:@"NSAppleScriptErrorMessage"],
          [err objectForKey:@"NSAppleScriptErrorNumber"],
          [err objectForKey:@"NSAppleScriptErrorAppName"],
          [err objectForKey:@"NSAppleScriptErrorBriefMessage"],
          NSStringFromRange([[err objectForKey:@"NSAppleScriptErrorRange"] rangeValue])
          );
          
    /*

     NSAppleScriptErrorMessage
     An NSString that supplies a detailed description of the error condition.

     NSAppleScriptErrorNumber
     An NSNumber that specifies the error number.

     NSAppleScriptErrorAppName
     An NSString that specifies the name of the application that generated the error.

     NSAppleScriptErrorBriefMessage
     An NSString that provides a brief description of the error.

     NSAppleScriptErrorRange
     */
    
}

- (void) runAppleScriptAction
{
    NSDictionary *err;
    NSAppleEventDescriptor *evt;
    NSDate *modified;
    if(myScript==nil){
	    scriptLastModified = [[[NSFileManager defaultManager] attributesOfItemAtPath:myString error:nil] fileModificationDate];
        if(scriptLastModified==nil){
            NSLog(@"AppleScript Action: No such file:%@",myString);
            return;
        }
        [scriptLastModified retain];
        //NSLog(@"first modification:  %@",scriptLastModified);
        myScript = [[NSAppleScript alloc] initWithContentsOfURL:[NSURL fileURLWithPath:myString] error:&err];
    }else{
		modified = [[[NSFileManager defaultManager] attributesOfItemAtPath:myString error:nil] fileModificationDate];
		//NSLog(@"check modification:  %@",modified);
        if(![modified isEqualToDate: scriptLastModified]){
            //NSLog(@"modification later");
            [scriptLastModified release];
            scriptLastModified = [modified retain];
            //script has been modified
            [myScript release];
            myScript = [[NSAppleScript alloc] initWithContentsOfURL:[NSURL fileURLWithPath:myString] error:&err];
            
        }
    }

    if(myScript==nil){
        [ClickAction logAppleScriptError:err atStep:@"Loading"];
        return;
    }
    if(![myScript isCompiled]){
        if(![myScript compileAndReturnError:&err]){
            [ClickAction logAppleScriptError:err atStep:@"Compiling"];
            return;
        }
    }
    evt = [myScript executeAndReturnError:&err];
    if(evt==nil){
        [ClickAction logAppleScriptError:err atStep:@"Executing"];
        return;
    }
    else{
        DEBUG(@"Applescript executed.");
    }
}

- (void) hideCurrentAction
{
    ProcessSerialNumber psn;
//    ProcessSerialNumber paramPsn;
    OSErr err;
	//NSLog(@"myClicker class: %@",[myClicker class]);
	//psn = [myClicker lastActivePSN];
	psn.highLongOfPSN = 0;
	psn.lowLongOfPSN = 0;
	err = GetFrontProcess(&psn);
    if(err==0){
	}else{
		NSLog(@"error after get front process");
	}

    err=ShowHideProcess(&psn, (Boolean)NO);
    if(err==0){
	}else{
		NSLog(@"error after get front process");
	}
	//[myClicker getNextPSN];
}

- (void) hideOthersAction
{
    OSErr err;
    ProcessSerialNumber psn;
    ProcessSerialNumber paramPsn;
    BOOL sameanswer;
    
    err =GetFrontProcess(&psn);
    paramPsn.highLongOfPSN=0;
    paramPsn.lowLongOfPSN=0;
    err =GetNextProcess(&paramPsn);
    while(err==0 ){
        SameProcess(&paramPsn,&psn,(Boolean *)&sameanswer);
        if(sameanswer){
            
        }else{
            ShowHideProcess(&paramPsn,(Boolean)NO);
        }
        err = GetNextProcess(&paramPsn);
    }
}

- (BOOL) isValid
{
    return [ClickAction validActionType: theType andString:myString];
}

//=========================================================== 
//  hoverTriggerDelayed 
//=========================================================== 
- (BOOL)hoverTriggerDelayed
{
    return hoverTriggerDelayed;
}
- (void)setHoverTriggerDelayed:(BOOL)flag
{
    hoverTriggerDelayed = flag;
}



- (NSComparisonResult)triggerCompare:(ClickAction *)anAction
{
    NSInteger t = [anAction trigger];
    return (t == [self trigger] ? NSOrderedSame :
            ( t > [self trigger] ? NSOrderedAscending :
              NSOrderedDescending ));
}

+ (NSString *) stringNameForActionType: (NSInteger) type
{
    switch(type){
        case 4:
        case 0: return @"chosenFilePath";
        case 3: return @"chosenURL";

        default: return nil;
    }
}

+ (NSString *) labelNameForActionType: (NSInteger) type
{
    switch(type){
        case ACT_FILE: return @"fileLabel";
        case 3: return @"urlDesc";
        case 4: return @"scriptDesc";
        default: return nil;
    }
}

+ (BOOL) validActionType: (NSInteger) type andString: (NSString *) action
{
    switch(type){
        case ACT_FILE:
            if(action !=nil)
                return YES;
            break;
        case ACT_HIDE: return YES;
        case ACT_HIDO: return YES;
        case ACT_URL:
            if(action !=nil && [action length]>0)
                return YES;
            break;
        case ACT_SCPT:
            if(action !=nil)
                return YES;
        case ACT_EALL:
        case ACT_EAPP:
        case ACT_EDES:
        case ACT_DASH:
        case ACT_SCRE:
                return YES;
        default:
            return NO;
    }
    return NO;
}

- (id) copyWithZone: (NSZone *) zone
{
    ClickAction *a = [[ClickAction allocWithZone:zone] initWithType: theType 
													   andModifiers:  theModifiers
														 andTrigger: theTrigger
                                                          isDelayed: hoverTriggerDelayed
														  andString:[myString copy] 
														  forCorner: theCorner
														  withLabel: [trueLabel copy]
														 andClicker:myClicker];
    return a;
}

@end
