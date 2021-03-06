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

//
//  BubbleAction.m
//  CornerClick
//
//  Created by Greg Schueler on Fri Apr 30 2004.
//  Copyright (c) 2004 __MyCompanyName__. All rights reserved.
//

#import "BubbleAction.h"

static NSImage *triImage;
@interface BubbleAction (InternalMethods)
- (void)drawAction:(NSString*)label withIcon:(NSImage*)icon atPoint:(NSPoint)inside;
@end

@implementation BubbleAction

- (id) initWithSpacing:(CGFloat) space

{
    return [self initWithSpacing:space
								   andActions:nil];
}
- (id) initWithSpacing:(CGFloat) space
					 andActions:(NSArray *) theActions
{
    if(self=[super init]){
		spacingSize=space;
		
		if(theActions != nil){
			actions = [[NSArray alloc] initWithArray:theActions];
			[self calcPreferredSize];
		}
	}
	return self;
}

- (void) dealloc
{
	[actions release];
    [super dealloc];
}


- (NSString *)modifiersLabel
{
    ClickAction *act = [actions objectAtIndex:0];
    return [CornerClickSupport labelForModifiers:[act modifiers]
                                      andTrigger:[act trigger]
                                     localBundle:[NSBundle bundleForClass:[self class]]];
}

- (void) setActions:(NSArray *)theActions
{
	NSArray *arr = [[NSArray alloc] initWithArray: theActions];
	[actions release];
	actions=arr;
}
- (NSArray *)actions
{
	return [[actions retain] autorelease];
}

- (void) setSpacingSize: (CGFloat) size
{
	spacingSize=size;
	[self calcPreferredSize];
}
- (NSSize) preferredSize
{
	return preferredSize;
}
- (void) calcPreferredSize
{
	NSInteger i;
	CGFloat x,y;
	CGFloat mwidth,mheight;
	NSSize temp;
	NSSize textSize=NSMakeSize(0,0);
	mwidth=0;
	mheight=0;
	CGFloat iconSize = [[CornerClickSettings sharedSettings] iconSize];
	if(actions != nil){
			
		for(i=0;i<[actions count];i++){
			x=0;
			y=0;
			ClickAction* act = (ClickAction*)[actions objectAtIndex:i];
			if([act label]!=nil){
				temp = [[act label] sizeWithAttributes:[BubbleView normalTextAttrs]];
				x = temp.width; // /2;
                y = temp.height; ///2;
			}
			if([act icon]!=nil){
				
				x+=iconSize + 4;
				if(y<iconSize)
					y=iconSize;
			}
			if(i>0){
				y+=spacingSize;
				x+=16;
			}
			if(x>mwidth){
				mwidth=x;
			}
			mheight+=y;
				
		}
	}
	textSize.width=ceil(mwidth);
	textSize.height=ceil(mheight);
	preferredSize= textSize;
}

- (void) drawInRect: (NSRect) rect
{
	CGFloat tF;
	NSInteger i,ox;
	CGFloat curHeight=rect.size.height;
	CGFloat iconSize = [[CornerClickSettings sharedSettings] iconSize];
	for(i=0;i<[actions count];i++){
		ClickAction *act = (ClickAction *)[actions objectAtIndex:i];
		tF=0;
		ox=0;
		if([act label]!=nil){
			NSSize temp = [[act label] sizeWithAttributes:[BubbleView normalTextAttrs]];
			tF = temp.height; ///2;
			
		}
		if([act icon] !=nil && tF<iconSize){
			tF=iconSize;
		}
		curHeight = curHeight-tF;
		if(i>0){
			curHeight-=spacingSize;
			ox=16;
            NSInteger wide=10;
            NSInteger high=10;
            //draw a triangle or something
            [[BubbleAction triangleImage] compositeToPoint:NSMakePoint(rect.origin.x+ox/2-wide/2, rect.origin.y+curHeight+tF/2-high/2) 
                                                 operation: NSCompositeSourceOver];
		}
		NSPoint inside = NSMakePoint(floor(rect.origin.x+ox), floor(curHeight + rect.origin.y)); 
		[self drawAction:[act label] withIcon:[act icon] atPoint:inside];
		
		
	}
	
}

+ (void) initialize
{
    NSInteger wide=10;
    NSInteger high=10;
    
    if(triImage == nil){
        triImage = [[NSImage alloc] initWithSize:NSMakeSize(wide,high)];
        [triImage lockFocus];
        NSRect rect = { {0, 0}, { wide, high } } ;
        NSBezierPath *nbp = [[[NSBezierPath alloc] init] autorelease];
        [nbp moveToPoint:NSMakePoint(rect.origin.x, rect.origin.y)];
        [nbp lineToPoint:NSMakePoint(rect.origin.x+wide, rect.origin.y+high/2)];
        [nbp lineToPoint:NSMakePoint(rect.origin.x, rect.origin.y+high)];
        [nbp closePath];
        [BubbleView addShadow:nbp depth:1.5];
        [triImage unlockFocus];
    }
}
+ (NSImage *) triangleImage
{
    return [[triImage retain] autorelease];
}


- (void)drawAction:(NSString*)label withIcon:(NSImage*)icon atPoint:(NSPoint)inside
{
    NSSize tSize;
	CGFloat iconSize = [[CornerClickSettings sharedSettings] iconSize];
	
	CGFloat xoff=0;
	CGFloat yoff=0;
    CGFloat iyoff=0;
	
	if(label == nil){
		tSize=NSMakeSize(0,0);
	}else{
		tSize=[label sizeWithAttributes: [BubbleView normalTextAttrs]];
	}
	//draw an icon if it's set
	if(icon!=nil){
        if(iconSize > tSize.height){
            yoff+=(iconSize - tSize.height)/2;
        }else{
            iyoff+=(tSize.height - iconSize)/2;
        }
		xoff+=iconSize + 4;

		[icon drawInRect:NSMakeRect(inside.x, inside.y + iyoff, iconSize, iconSize) 
				fromRect:NSMakeRect(0,0,[icon size].width, [icon size].height)
			   operation:NSCompositeSourceOver
				fraction:1.0];
	}
	
	if(label!=nil){
        [[NSGraphicsContext currentContext] saveGraphicsState];
		[[NSGraphicsContext currentContext] setShouldAntialias: YES];

		[label drawAtPoint:NSMakePoint(inside.x+xoff, inside.y+yoff) withAttributes: [BubbleView normalTextAttrs] ];
		[[NSGraphicsContext currentContext] restoreGraphicsState];
        
	}
	
	
}

- (NSComparisonResult)triggerCompare:(BubbleAction *)anAction
{
    ClickAction *selfAct = (ClickAction *)[[self actions] objectAtIndex:0];
    ClickAction *anAct = (ClickAction *)[[anAction actions] objectAtIndex:0];
    return [selfAct triggerCompare:anAct];
}


@end
