//
//  Level001Loading.m
//  BluePuff
//
//  Created by TitanBase on 10/6/10.
//  Copyright 2010 Benjamin Lindelof. All rights reserved.
//

// GO TO LINE 890 FOR INIT TO START
// GO TO LINE 1190 FOR SCHEDULERS

// Import the interfaces
#import "Level001.h"
#include <stdlib.h>
#import "SimpleAudioEngine.h"
#import "Level001EndMenu.h"
#import "Level001GameOverEndMenu.h"
#import "MainMenu.h"
#import "Level001Loading.h"

//Sprites not listed in Header file:
CCSprite *backgroundImageLevel001;

//progressbar sprites:
CCSprite *blueprogbar;
CCSprite *greenhealthbar;
CCSprite *yellowhealthbar;
CCSprite *redhealthbar;
CCSprite *healthbgbar;
CCSprite *progressbgbar;
CCSprite *gameOverBar;

//Globals:
extern long int SurvivalMapNumber;
extern long int playerScore;
extern long int intCurrentLevel;
extern long int currentPlayerScore;
extern long int globalHighScore;
extern float globalPlayerHealth;
extern float healthBarScale;
extern int onePerLevelUsed;
extern long int intInsideCreditsHowTo;
extern int gameHasStarted;
extern int intLastLevelSwitch;
extern int intCurrentBGNum;
extern int intMusicOff;

extern int intMinesEverHit;

//locals:
//long int localPlayerScore = 0;
long int alreadyPlayedTheSound = 0;
long int iterator = 0;
long int kickSoundIterator = 0;
long int tigerfishRemoved = 0;
long int rotationAmount = 0;
long int r = 0;
long int oneLifeRx = 0;
long int oneLifeRy = 0;
long int oneFlipRy = 0;
long int fishBreathingOut = 0;
long int multiTigerFishCounter = 0;
float currentNumberofFish = 0;
float maxNumberofFish = 75;     //MAX   //TEST:

long int zLevelSprites = 1050;  // start and reset

long int scoreXvalue = 500;  //_labelar.position = ccp(500, 690)
long int scoreYvalue = 690; 

long int currentTargetX = 0;
long int currentTargetY = 0;

//just use counters instead of arrays:
long int multiRedFishCounter = 0;

//double progressBarOffset = 0;
//double progressBarScale = 0;
//float progressBarOffset = 0;
float progressBarScale = 0;

//double healthBarScale = 100;

long int exitGameAlready = 0;
long int showGameOverAlready = 0;

//fish tracker:  //works with _targets, _projectiles, _mobs
//fish are targets, players are projectiles, mines are mobs
// trackers:
NSMutableString *str = nil;
NSMutableString *strMines = nil;

//	NSMutableArray *_mobs;

//random numbers
long int fishRandomNumber = 1; 
//long int fishRandomNumber = 1 + rand()%10;

long int fishRandomNumberof3 = 1;
long int fishRandomNumberof4 = 1;
//long int onePerLevelUsed = 0;
extern int onePerLevelUsed;

//fishCoordRandomNumber = 1 + rand()%10;   //goes up 1-10
long int fishCoordRandomNumber = 1;

long int fishCoordRotator = 1;

long int miscCounter = 0;

long int intHasShownFirstFish = 0;
long int intHasShownFirstMine = 0;

// Level001 implementation___________________________________________________________________
// __________________________________________________________________________________________
@implementation Level001
@synthesize bluefugu = _bluefugu;
@synthesize moveAction = _moveAction;
@synthesize walkAction = _walkAction;

//goZoom
@synthesize goZoom = _goZoom;
@synthesize manimAction = _manimAction;
@synthesize wanimAction = _wanimAction;

//goBoom
@synthesize goBoom = _goBoom;
@synthesize mBanimAction = _mBanimAction;
@synthesize wBanimAction = _wBanimAction;

//goPoints125
@synthesize goPoints125 = _goPoints125;
@synthesize mP125animAction = _mP125animAction;
@synthesize wP125animAction = _wP125animAction;



// score label
@synthesize label = _label;					//score label
//@synthesize label_part2 = _label_part2;		//score label

//@synthesize bottomlabel = _bottomlabel;		//middle label
//@synthesize bottomlabel2 = _bottomlabel2;	//top label

//@synthesize label_BoomDisplay = _label_BoomDisplay;
//@synthesize label_FishScoreDisplay = _label_FishScoreDisplay;
@synthesize label_ShowLevelNumber = _label_ShowLevelNumber;

@synthesize labelar = _labelar;   // score display  sprites

//label_ShowLevelNumber -> label_ShowHealthTag
@synthesize label_ShowHealthTag = _label_ShowHealthTag;   // score display  sprites

//___________________________________________________________________________________________


+ (void)initialize
{
	//initialize the level:
	
	//aMutableString = [[NSMutableString alloc] initWithString:@"Test"];
	//[str release];
	//[strMines release];
	str = [[NSMutableString alloc] initWithString:@"NEWMUTABLE|"];
	//NSMutableString *strMines = nil;
	strMines = [[NSMutableString alloc] initWithString:@"NEWMUTABLE|"];

	//needs to be [strMines release];
	// realloced? release first too
	
	
	
	//localPlayerScore = playerScore;
	
}
//___________________________________________________________________________________________


+(id) sceneLevel001
{
	// 'scene' is an autorelease object.
	CCScene *sceneLevel001 = [CCScene node];
	
	// 'layer' is an autorelease object.
	Level001 *layerLevel001 = [Level001 node];
	
	// add layer as a child to scene
	[sceneLevel001 addChild: layerLevel001];
	
	// return the scene
	return sceneLevel001;
}
//___________________________________________________________________________________________



// removes unused Targets:
-(void)spriteMoveFinished:(id)sender {
	CCSprite *sprite = (CCSprite *)sender;
	[self removeChild:sprite cleanup:YES];
}
//____________________________________________________________________________


-(void)addTarget {
	
	//Adds tiger FIsh Instance copy
	//instead of playTigerFish, use addTarget   for TigerFish
	
	CCSprite *target = [CCSprite spriteWithFile:@"tigerfish_small_trim.png" 
										   rect:CGRectMake(0, 0, 88, 27)]; 
	
	target.tag = 1;
	[_targets addObject:target];
	
	
	
	//standard/custom fish code:
	currentNumberofFish++;
	
	int minY = target.contentSize.width/2;
	
	//new randoms:
	fishCoordRandomNumber = 1 + rand()%702;   //goes up 1-10
	fishCoordRandomNumber = fishCoordRandomNumber + 50;  // keep off the very bottom
	
	target.position = ccp(1200 + minY, fishCoordRandomNumber);
	
	target.scaleX = -target.scaleX;
	[self addChild:target];
	
	//example:  release the init
	//CCSprite *s = [[CCSprite alloc] initWithFile:@"somefile.png"];
//	[node addChild:s];
//	[s release];
	
	//[target release];
	
	
	fishCoordRotator = 2 + rand()%4;   //goes up 2-4   //speed of fish, 2 is fastest 2sec
	
	//fishCoordRandomNumber = 1 + rand()%550;   //goes up 1-10
	id actionMove = [CCMoveTo actionWithDuration:fishCoordRotator      //or fishCoordRotator
										position:ccp(-250, fishCoordRandomNumber)];  // bluefugu+fish
	
	id actionMoveDone = [CCCallFuncN actionWithTarget:self 
											 selector:@selector(spriteMoveFinished:)];
	[target runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
	
	//NSLog(@"Target Ran: fishCoordRotator = %d, fishCoordRandomNumber = %d", fishCoordRotator, fishCoordRandomNumber);
	//NSLog(@"str = %@", str);
	
	//target = nil;
}
//____________________________________________________________addTarget ends


-(void)addTargetRedFish {
	
	
	//Adds red FIsh Instance copy
	
	CCSprite *target = [CCSprite spriteWithFile:@"redfish_small_trim.png" 
										   rect:CGRectMake(0, 0, 103, 50)]; 
	//________________________
	target.tag = 2;
	[_targets addObject:target];
	
	
	//standard/custom fish code:
	currentNumberofFish++;

	int minY = target.contentSize.height/2;

	//new randoms:
	fishCoordRandomNumber = 1 + rand()%702;   //goes up 1-10
	fishCoordRandomNumber = fishCoordRandomNumber + 50;  // keep off the very bottom
	
	target.position = ccp(1200 + minY, fishCoordRandomNumber);
	
	target.scaleX = -target.scaleX;
	[self addChild:target];

	fishCoordRotator = 2 + rand()%4;   //goes up 2-4   //speed of fish, 2 is fastest 2sec
	
	//fishCoordRandomNumber = 1 + rand()%550;   //goes up 1-10
	id actionMove = [CCMoveTo actionWithDuration:fishCoordRotator      //or fishCoordRotator
										position:ccp(-250, fishCoordRandomNumber)];  // bluefugu+fish
	
	id actionMoveDone = [CCCallFuncN actionWithTarget:self 
											 selector:@selector(spriteMoveFinished:)];
	[target runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
	
	//NSLog(@"Target Ran: fishCoordRotator = %d, fishCoordRandomNumber = %d", fishCoordRotator, fishCoordRandomNumber);
	//NSLog(@"str = %@", str);
	//target = nil;
	
}
//_____________________________________________________________addTargetRedFish  (1st fish) ends



-(void)addTargetBAWFish {
		
//	CCSprite *target = [CCSprite spriteWithFile:@"blackandwhitefish_small_trimt.png" 
//										   rect:CGRectMake(0, 0, 110, 70)]; 
//// file above is not loading...
	
	CCSprite *target = [CCSprite spriteWithFile:@"blackandwhitefish_small_trim_72dpi.png" rect:CGRectMake(0, 0, 110, 70)]; 	
	
	
//	CCSprite *target = [CCSprite spriteWithFile:@"redfish_small_trim.png" 
//										   rect:CGRectMake(0, 0, 103, 50)]; 
		
	target.tag = 3;
	[_targets addObject:target];
	
	
	
	//standard/custom fish code:
	currentNumberofFish++;
	
	int minY = target.contentSize.height/2;
	
	//new randoms:
	fishCoordRandomNumber = 1 + rand()%702;   //goes up 1-10
	fishCoordRandomNumber = fishCoordRandomNumber + 50;  // keep off the very bottom
	
	target.position = ccp(1200 + minY, fishCoordRandomNumber);
	
	target.scaleX = -target.scaleX;
	[self addChild:target];
	
	fishCoordRotator = 2 + rand()%4;   //goes up 2-4   //speed of fish, 2 is fastest 2sec
	
	//fishCoordRandomNumber = 1 + rand()%550;   //goes up 1-10
	id actionMove = [CCMoveTo actionWithDuration:fishCoordRotator      //or fishCoordRotator
										position:ccp(-250, fishCoordRandomNumber)];  // bluefugu+fish
	
	id actionMoveDone = [CCCallFuncN actionWithTarget:self 
											 selector:@selector(spriteMoveFinished:)];
	[target runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
	
	//NSLog(@"Target Ran: fishCoordRotator = %d, fishCoordRandomNumber = %d", fishCoordRotator, fishCoordRandomNumber);
	//NSLog(@"str = %@", str);
	
	//target = nil;
}
//_____________________________________________________________addTargetBAWFish ends 2


-(void)addTargetBWYFish {
	
	
	CCSprite *target = [CCSprite spriteWithFile:@"blckwhiteyellowfish_small_trim_72dpi.png" 
										   rect:CGRectMake(0, 0, 113, 98)]; 
	
	target.tag = 4;
	[_targets addObject:target];
	
	
	//standard/custom fish code:
	currentNumberofFish++;
	
	int minY = target.contentSize.height/2;
	
	//new randoms:
	fishCoordRandomNumber = 1 + rand()%702;   //goes up 1-10
	fishCoordRandomNumber = fishCoordRandomNumber + 50;  // keep off the very bottom
	
	target.position = ccp(1200 + minY, fishCoordRandomNumber);
	
	target.scaleX = -target.scaleX;
	[self addChild:target];
	
	fishCoordRotator = 2 + rand()%4;   //goes up 2-4   //speed of fish, 2 is fastest 2sec
	
	//fishCoordRandomNumber = 1 + rand()%550;   //goes up 1-10
	id actionMove = [CCMoveTo actionWithDuration:fishCoordRotator      //or fishCoordRotator
										position:ccp(-250, fishCoordRandomNumber)];  // bluefugu+fish
	
	id actionMoveDone = [CCCallFuncN actionWithTarget:self 
											 selector:@selector(spriteMoveFinished:)];
	[target runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
	
	//NSLog(@"Target Ran: fishCoordRotator = %d, fishCoordRandomNumber = %d", fishCoordRotator, fishCoordRandomNumber);
	//NSLog(@"str = %@", str);
	
	//target = nil;
}
//_____________________________________________________________addTargetBWYFish ends 3


-(void)addTargetBYFish {
	
	
	CCSprite *target = [CCSprite spriteWithFile:@"blueyellowfish_small_trim.png" 
										   rect:CGRectMake(0, 0, 117, 67)]; 
	
	target.tag = 5;
	[_targets addObject:target];
	
	
	
	//standard/custom fish code:
	currentNumberofFish++;
	
	int minY = target.contentSize.height/2;
	
	//new randoms:
	fishCoordRandomNumber = 1 + rand()%702;   //goes up 1-10
	fishCoordRandomNumber = fishCoordRandomNumber + 50;  // keep off the very bottom
	
	target.position = ccp(1200 + minY, fishCoordRandomNumber);
	
	target.scaleX = -target.scaleX;
	[self addChild:target];
	
	fishCoordRotator = 2 + rand()%4;   //goes up 2-4   //speed of fish, 2 is fastest 2sec
	
	//fishCoordRandomNumber = 1 + rand()%550;   //goes up 1-10
	id actionMove = [CCMoveTo actionWithDuration:fishCoordRotator      //or fishCoordRotator
										position:ccp(-250, fishCoordRandomNumber)];  // bluefugu+fish
	
	id actionMoveDone = [CCCallFuncN actionWithTarget:self 
											 selector:@selector(spriteMoveFinished:)];
	[target runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
	
	//NSLog(@"Target Ran: fishCoordRotator = %d, fishCoordRandomNumber = %d", fishCoordRotator, fishCoordRandomNumber);
	//NSLog(@"str = %@", str);	
	
	//target = nil;
}
//_____________________________________________________________addTargetBYFish ends 4


-(void)addTargetSilverFish {
	
	CCSprite *target = [CCSprite spriteWithFile:@"silver1_small_trim.png" 
										   rect:CGRectMake(0, 0, 101, 57)]; 
	
	target.tag = 6;
	[_targets addObject:target];
	
	
	
	//standard/custom fish code:
	currentNumberofFish++;
	
	int minY = target.contentSize.height/2;
	
	//new randoms:
	fishCoordRandomNumber = 1 + rand()%702;   //goes up 1-10
	fishCoordRandomNumber = fishCoordRandomNumber + 50;  // keep off the very bottom
	
	target.position = ccp(1200 + minY, fishCoordRandomNumber);
	
	target.scaleX = -target.scaleX;
	[self addChild:target];
	
	fishCoordRotator = 2 + rand()%4;   //goes up 2-4   //speed of fish, 2 is fastest 2sec
	
	//fishCoordRandomNumber = 1 + rand()%550;   //goes up 1-10
	id actionMove = [CCMoveTo actionWithDuration:fishCoordRotator      //or fishCoordRotator
										position:ccp(-250, fishCoordRandomNumber)];  // bluefugu+fish
	
	id actionMoveDone = [CCCallFuncN actionWithTarget:self 
											 selector:@selector(spriteMoveFinished:)];
	[target runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
	
	//NSLog(@"Target Ran: fishCoordRotator = %d, fishCoordRandomNumber = %d", fishCoordRotator, fishCoordRandomNumber);
	//NSLog(@"str = %@", str);	
	
	//target = nil;
}
//_____________________________________________________________addTargetSilverFish ends 5


-(void)addTargetYellowFish {
		
	CCSprite *target = [CCSprite spriteWithFile:@"yellowfish_small_trim.png" 
										   rect:CGRectMake(0, 0, 136, 66)]; 
	
	target.tag = 7;
	[_targets addObject:target];
	
	
	
	//standard/custom fish code:
	currentNumberofFish++;
	
	int minY = target.contentSize.height/2;
	
	//new randoms:
	fishCoordRandomNumber = 1 + rand()%702;   //goes up 1-10
	fishCoordRandomNumber = fishCoordRandomNumber + 50;  // keep off the very bottom
	
	target.position = ccp(1200 + minY, fishCoordRandomNumber);
	
	target.scaleX = -target.scaleX;
	[self addChild:target];
	
	fishCoordRotator = 2 + rand()%4;   //goes up 2-4   //speed of fish, 2 is fastest 2sec
	
	//fishCoordRandomNumber = 1 + rand()%550;   //goes up 1-10
	id actionMove = [CCMoveTo actionWithDuration:fishCoordRotator      //or fishCoordRotator
										position:ccp(-250, fishCoordRandomNumber)];  // bluefugu+fish
	
	id actionMoveDone = [CCCallFuncN actionWithTarget:self 
											 selector:@selector(spriteMoveFinished:)];
	[target runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
	
	//NSLog(@"Target Ran: fishCoordRotator = %d, fishCoordRandomNumber = %d", fishCoordRotator, fishCoordRandomNumber);
	//NSLog(@"str = %@", str);	
	
	//target = nil;
}
//_____________________________________________________________addTargetYellowFish ends 6


-(void)addTargetYellowOrangeFish {
		
	CCSprite *target = [CCSprite spriteWithFile:@"yelloworange_small_trim.png" 
										   rect:CGRectMake(0, 0, 116, 90)]; 
	
	target.tag = 8;
	[_targets addObject:target];
	
	
	
	//standard/custom fish code:
	currentNumberofFish++;
	
	int minY = target.contentSize.height/2;
	
	//new randoms:
	fishCoordRandomNumber = 1 + rand()%702;   //goes up 1-10
	fishCoordRandomNumber = fishCoordRandomNumber + 50;  // keep off the very bottom
	
	target.position = ccp(1200 + minY, fishCoordRandomNumber);
	
	target.scaleX = -target.scaleX;
	[self addChild:target];
	
	fishCoordRotator = 2 + rand()%4;   //goes up 2-4   //speed of fish, 2 is fastest 2sec
	
	//fishCoordRandomNumber = 1 + rand()%550;   //goes up 1-10
	id actionMove = [CCMoveTo actionWithDuration:fishCoordRotator      //or fishCoordRotator
										position:ccp(-250, fishCoordRandomNumber)];  // bluefugu+fish
	
	id actionMoveDone = [CCCallFuncN actionWithTarget:self 
											 selector:@selector(spriteMoveFinished:)];
	[target runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
	
	//NSLog(@"Target Ran: fishCoordRotator = %d, fishCoordRandomNumber = %d", fishCoordRotator, fishCoordRandomNumber);
	//NSLog(@"str = %@", str);	
	//target = nil;
	
}
//_____________________________________________________________addTargetYellowOrangeFish ends 7


-(void)addTargetYellowTwoFish {
	
	
	CCSprite *target = [CCSprite spriteWithFile:@"yellowtwo_small_trim.png" 
										   rect:CGRectMake(0, 0, 100, 77)]; 
	
	target.tag = 9;
	[_targets addObject:target];
	
	
	//standard/custom fish code:
	currentNumberofFish++;
	
	int minY = target.contentSize.height/2;
	
	//new randoms:
	fishCoordRandomNumber = 1 + rand()%702;   //goes up 1-10
	fishCoordRandomNumber = fishCoordRandomNumber + 50;  // keep off the very bottom
	
	target.position = ccp(1200 + minY, fishCoordRandomNumber);
	
	target.scaleX = -target.scaleX;
	[self addChild:target];
	
	fishCoordRotator = 2 + rand()%4;   //goes up 2-4   //speed of fish, 2 is fastest 2sec
	
	//fishCoordRandomNumber = 1 + rand()%550;   //goes up 1-10
	id actionMove = [CCMoveTo actionWithDuration:fishCoordRotator      //or fishCoordRotator
										position:ccp(-250, fishCoordRandomNumber)];  // bluefugu+fish
	
	id actionMoveDone = [CCCallFuncN actionWithTarget:self 
											 selector:@selector(spriteMoveFinished:)];
	[target runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
	
	//NSLog(@"Target Ran: fishCoordRotator = %d, fishCoordRandomNumber = %d", fishCoordRotator, fishCoordRandomNumber);
	//NSLog(@"str = %@", str);
	//target = nil;
}
//_____________________________________________________________addTargetYellowTwoFish ends 8_actually *9 since addTarget is tiger.	



-(void)addTargetPurpleFish {
	
	CCSprite *target = [CCSprite spriteWithFile:@"purple_small_trim.png" 
										   rect:CGRectMake(0, 0, 179, 65)]; 
		
	target.tag = 10;
	[_targets addObject:target];
	
	
	//standard/custom fish code:
	currentNumberofFish++;
	
	int minY = target.contentSize.height/2;
	
	//new randoms:
	fishCoordRandomNumber = 1 + rand()%702;   //goes up 1-10
	fishCoordRandomNumber = fishCoordRandomNumber + 50;  // keep off the very bottom
	
	target.position = ccp(1200 + minY, fishCoordRandomNumber);
	
	target.scaleX = -target.scaleX;
	[self addChild:target];
	
	fishCoordRotator = 2 + rand()%4;   //goes up 2-4   //speed of fish, 2 is fastest 2sec
	
	//fishCoordRandomNumber = 1 + rand()%550;   //goes up 1-10
	id actionMove = [CCMoveTo actionWithDuration:fishCoordRotator      //or fishCoordRotator
										position:ccp(-250, fishCoordRandomNumber)];  // bluefugu+fish
	
	id actionMoveDone = [CCCallFuncN actionWithTarget:self 
											 selector:@selector(spriteMoveFinished:)];
	[target runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
	
	//NSLog(@"Target Ran: fishCoordRotator = %d, fishCoordRandomNumber = %d", fishCoordRotator, fishCoordRandomNumber);
	//NSLog(@"str = %@", str);	
	//target = nil;
}
//_____________________________________________________________addTargetPurpleFish ends 10	




-(void)addNonTargetPlant1 {
	
	
	//currentNumberofFish++;
	
	//Adds red FIsh Instance copy
	//instead of playTigerFish, use addTarget   for TigerFish
	
	CCSprite *target = [CCSprite spriteWithFile:@"bluepurpcoral_medtrim.png" 
										   rect:CGRectMake(0, 0, 257, 291)]; 
	
	// Determine where to spawn the target along the Y axis
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	//int minY = target.contentSize.height/2;
	//int maxY = winSize.height - target.contentSize.height/2;
	//int rangeY = maxY - minY;
	//int actualY = (arc4random() % rangeY) + minY;
	
	int actualY = target.contentSize.height/2 - 50;
	
	//target.tag = 11;
	//[_targets addObject:target];
	
	
	// Create the target slightly off-screen along the right edge,
	// and along a random position along the Y axis as calculated above
	target.position = ccp(winSize.width + (target.contentSize.width/2) + 40, actualY);
	target.scaleX = -target.scaleX;
	[self addChild:target];
	
	// Determine speed of the target
	int minDuration = 4.0;
	int maxDuration = 7.0;
	int rangeDuration = maxDuration - minDuration;
	int actualDuration = (arc4random() % rangeDuration) + minDuration;
	
	// Create the actions
	id actionMove = [CCMoveTo actionWithDuration:actualDuration 
										position:ccp(-target.contentSize.width/2, actualY)];
	id actionMoveDone = [CCCallFuncN actionWithTarget:self 
											 selector:@selector(spriteMoveFinished:)];
	[target runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
	
	//target = nil;
}
//_____________________________________________________________addNonTargetPlant1	



-(void)addNonTargetPlant2 {
	
	
	//currentNumberofFish++;
	
	//Adds red FIsh Instance copy
	//instead of playTigerFish, use addTarget   for TigerFish
	
	CCSprite *target = [CCSprite spriteWithFile:@"grass_medtrim.png" 
										   rect:CGRectMake(0, 0, 431, 250)]; 
	
	// Determine where to spawn the target along the Y axis
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	//int minY = target.contentSize.height/2;
	//int maxY = winSize.height - target.contentSize.height/2;
	//int rangeY = maxY - minY;
	//int actualY = (arc4random() % rangeY) + minY;
	
	int actualY = target.contentSize.height/2 - 100;
	
	//target.tag = 11;
	//[_targets addObject:target];
	
	
	// Create the target slightly off-screen along the right edge,
	// and along a random position along the Y axis as calculated above
	target.position = ccp(winSize.width + (target.contentSize.width/2), actualY);
	target.scaleX = -target.scaleX;
	[self addChild:target];
	
	// Determine speed of the target
	int minDuration = 4.0;
	int maxDuration = 7.0;
	int rangeDuration = maxDuration - minDuration;
	int actualDuration = (arc4random() % rangeDuration) + minDuration;
	
	// Create the actions
	id actionMove = [CCMoveTo actionWithDuration:actualDuration 
										position:ccp(-target.contentSize.width/2, actualY)];
	id actionMoveDone = [CCCallFuncN actionWithTarget:self 
											 selector:@selector(spriteMoveFinished:)];
	[target runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
	
	//target = nil;
}
//_____________________________________________________________addNonTargetPlant2	


-(void)addNonTargetPlant3 {
	
	//TEMPORARILY REPLACED WITH REEDS:
	
	//currentNumberofFish++;
	
	//Adds red FIsh Instance copy
	//instead of playTigerFish, use addTarget   for TigerFish
	//
	
	//CCSprite *target = [CCSprite spriteWithFile:@"thinplant_medtrim_186_319.png" 
	//									   rect:CGRectMake(0, 0, 186, 319)]; 
	
	CCSprite *target = [CCSprite spriteWithFile:@"reeds.png" 
										   rect:CGRectMake(0, 0, 548, 898)]; 
	
	// Determine where to spawn the target along the Y axis
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	//int minY = target.contentSize.height/2;
	//int maxY = winSize.height - target.contentSize.height/2;
	//int rangeY = maxY - minY;
	//int actualY = (arc4random() % rangeY) + minY;
	
	//int actualY = target.contentSize.height/2 - 100;   //medtrim version
	int actualY = target.contentSize.height/2 - 10;		//reeds version
	
	//target.tag = 11;
	//[_targets addObject:target];
	
	
	// Create the target slightly off-screen along the right edge,
	// and along a random position along the Y axis as calculated above
	target.position = ccp(winSize.width + (target.contentSize.width/2), actualY);
	target.scaleX = -target.scaleX;
	[self addChild:target];
	
	// Determine speed of the target
	int minDuration = 4.0;
	int maxDuration = 7.0;
	int rangeDuration = maxDuration - minDuration;
	int actualDuration = (arc4random() % rangeDuration) + minDuration;
	
	// Create the actions
	id actionMove = [CCMoveTo actionWithDuration:actualDuration 
										position:ccp(-target.contentSize.width/2, actualY)];
	id actionMoveDone = [CCCallFuncN actionWithTarget:self 
											 selector:@selector(spriteMoveFinished:)];
	[target runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
	
	//target = nil;
}
//_____________________________________________________________addNonTargetPlant3	

-(void)addNonTargetPlant4 {
	
	
	//currentNumberofFish++;
	
	//Adds red FIsh Instance copy
	//instead of playTigerFish, use addTarget   for TigerFish
	
	CCSprite *target = [CCSprite spriteWithFile:@"wideleaf_medtrim_67_297.png" 
										   rect:CGRectMake(0, 0, 67, 297)]; 
	
	// Determine where to spawn the target along the Y axis
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	//int minY = target.contentSize.height/2;
	//int maxY = winSize.height - target.contentSize.height/2;
	//int rangeY = maxY - minY;
	//int actualY = (arc4random() % rangeY) + minY;
	
	int actualY = target.contentSize.height/2 - 100;
	
	//target.tag = 11;
	//[_targets addObject:target];
	
	
	// Create the target slightly off-screen along the right edge,
	// and along a random position along the Y axis as calculated above
	target.position = ccp(winSize.width + (target.contentSize.width/2), actualY);
	target.scaleX = -target.scaleX;
	[self addChild:target];
	
	// Determine speed of the target
	int minDuration = 4.0;
	int maxDuration = 7.0;
	int rangeDuration = maxDuration - minDuration;
	int actualDuration = (arc4random() % rangeDuration) + minDuration;
	
	// Create the actions
	id actionMove = [CCMoveTo actionWithDuration:actualDuration 
										position:ccp(-target.contentSize.width/2, actualY)];
	id actionMoveDone = [CCCallFuncN actionWithTarget:self 
											 selector:@selector(spriteMoveFinished:)];
	[target runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
	
	//target = nil;
}
//_____________________________________________________________addNonTargetPlant4	

-(void)addNonTargetBubbles {
	
	
	//currentNumberofFish++;
	
	//Adds red FIsh Instance copy
	//instead of playTigerFish, use addTarget   for TigerFish
	
	CCSprite *target = [CCSprite spriteWithFile:@"bubbleorig_64_40.png" 
										   rect:CGRectMake(0, 0, 64, 40)]; 
	
	// Determine where to spawn the target along the Y axis
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	int minY = target.contentSize.height/2;
	int maxY = winSize.height - target.contentSize.height/2;
	int rangeY = maxY - minY;
	int actualY = (arc4random() % rangeY) + minY;
	
	//int actualY = target.contentSize.height/2 - 100;
	
	//target.tag = 11;
	//[_targets addObject:target];
	
	
	// Create the target slightly off-screen along the right edge,
	// and along a random position along the Y axis as calculated above
	target.position = ccp(winSize.width + (target.contentSize.width/2), actualY);
	target.scaleX = -target.scaleX;
	[self addChild:target];
	
	// Determine speed of the target
	int minDuration = 1.0;
	int maxDuration = 4.0;
	int rangeDuration = maxDuration - minDuration;
	int actualDuration = (arc4random() % rangeDuration) + minDuration;
	
	// Create the actions
	id actionMove = [CCMoveTo actionWithDuration:actualDuration 
										position:ccp(-target.contentSize.width/2, actualY)];
	id actionMoveDone = [CCCallFuncN actionWithTarget:self 
											 selector:@selector(spriteMoveFinished:)];
	[target runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
	
	//target = nil;
}
//_____________________________________________________________addNonTargetBubbles	


//ENEMIES / MOBS:
///metallic_mines903_dodged_100_99.png

-(void)addTargetmines903 {
	
	
	currentNumberofFish++;
	
	//Adds red FIsh Instance copy
	//instead of playTigerFish, use addTarget   for TigerFish
	
	CCSprite *mob = [CCSprite spriteWithFile:@"metallic_mines903_dodged_100_99.png" 
										   rect:CGRectMake(0, 0, 100, 99)]; 
	
	// Determine where to spawn the target along the Y axis
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	int minY = mob.contentSize.height/2;
	int maxY = winSize.height - mob.contentSize.height/2;
	int rangeY = maxY - minY;
	int actualY = (arc4random() % rangeY) + minY;
	
	//TEST:
	//actualY = 200;
	//NSLog(@"actualY: %i", actualY); 
	
	//NSLog(@"minY: %i", minY); 
	//NSLog(@"maxY: %i", maxY); 
	//NSLog(@"rangeY: %i", rangeY); 
	
	
	// mobs array:
	mob.tag = 11;
	[_mobs addObject:mob];
	
	
	//CLEAN OUT THE CCSRPIT AOVE FOR MEMORY LEAK:;
	//[mob release];
	//this worked belos:
	//too soon:
	//mob = nil;
	
	
	// Create the target slightly off-screen along the right edge,
	// and along a random position along the Y axis as calculated above
	//mob.position = ccp(winSize.width + (mob.contentSize.width/2), actualY);
	mob.position = ccp(1200 + minY, actualY);
	//mob.scaleX = -mob.scaleX;   //do not flip sprite.
	[self addChild:mob];
	
	// Determine speed of the target
	int minDuration = 2.0;
	int maxDuration = 4.0;
	int rangeDuration = maxDuration - minDuration;
	int actualDuration = (arc4random() % rangeDuration) + minDuration;
	
	// Create the actions
//	id actionMove = [CCMoveTo actionWithDuration:actualDuration 
//										position:ccp(-mob.contentSize.width/2, actualY)];
	id actionMove = [CCMoveTo actionWithDuration:actualDuration 
										position:ccp(-250, actualY)];
	id actionMoveDone = [CCCallFuncN actionWithTarget:self 
											 selector:@selector(spriteMoveFinished:)];
	[mob runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];

	//mob = nil;

}
//_____________________________________________________________ addTargetmines903 ends 10	


-(void)addTargetmines904 {
	
	
	currentNumberofFish++;
	
	//Adds red FIsh Instance copy
	//instead of playTigerFish, use addTarget   for TigerFish
	
	CCSprite *mob = [CCSprite spriteWithFile:@"metallic_mines903_dodged_150_148.png" 
										rect:CGRectMake(0, 0, 150, 148)]; 
	
	// Determine where to spawn the target along the Y axis
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	int minY = mob.contentSize.height/2;
	int maxY = winSize.height - mob.contentSize.height/2;
	int rangeY = maxY - minY;
	int actualY = (arc4random() % rangeY) + minY;
	
	//TEST:
	//actualY = 200;
	//NSLog(@"actualY: %i", actualY); 
	
	//NSLog(@"minY: %i", minY); 
	//NSLog(@"maxY: %i", maxY); 
	//NSLog(@"rangeY: %i", rangeY); 
	
	
	// mobs array:
	mob.tag = 11;
	[_mobs addObject:mob];
	
	
	//CLEAN OUT THE CCSRPIT AOVE FOR MEMORY LEAK:;
	//[mob release];
	//this worked belos:
	//too soon:
	//mob = nil;
	
	
	// Create the target slightly off-screen along the right edge,
	// and along a random position along the Y axis as calculated above
	//mob.position = ccp(winSize.width + (mob.contentSize.width/2), actualY);
	mob.position = ccp(1200 + minY, actualY);
	//mob.scaleX = -mob.scaleX;   //do not flip sprite.
	[self addChild:mob];
	
	// Determine speed of the target
	int minDuration = 3.0;
	int maxDuration = 6.0;
	int rangeDuration = maxDuration - minDuration;
	int actualDuration = (arc4random() % rangeDuration) + minDuration;
	
	// Create the actions
	//	id actionMove = [CCMoveTo actionWithDuration:actualDuration 
	//										position:ccp(-mob.contentSize.width/2, actualY)];
	id actionMove = [CCMoveTo actionWithDuration:actualDuration 
										position:ccp(-350, actualY)];
	id actionMoveDone = [CCCallFuncN actionWithTarget:self 
											 selector:@selector(spriteMoveFinished:)];
	[mob runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
	
	//mob = nil;
	
}
//_____________________________________________________________ addTargetmines904 ends 10	

-(void)addTargetmines905 {
	
	
	currentNumberofFish++;
	
	//Adds red FIsh Instance copy
	//instead of playTigerFish, use addTarget   for TigerFish
	
	CCSprite *mob = [CCSprite spriteWithFile:@"metallic_mines903_dodged_200_197.png" 
										rect:CGRectMake(0, 0, 200, 197)]; 
	
	// Determine where to spawn the target along the Y axis
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	int minY = mob.contentSize.height/2;
	int maxY = winSize.height - mob.contentSize.height/2;
	int rangeY = maxY - minY;
	int actualY = (arc4random() % rangeY) + minY;
	
	//TEST:
	//actualY = 200;
	//NSLog(@"actualY: %i", actualY); 
	
	//NSLog(@"minY: %i", minY); 
	//NSLog(@"maxY: %i", maxY); 
	//NSLog(@"rangeY: %i", rangeY); 
	
	
	// mobs array:
	mob.tag = 11;
	[_mobs addObject:mob];
	
	
	//CLEAN OUT THE CCSRPIT AOVE FOR MEMORY LEAK:;
	//[mob release];
	//this worked belos:
	//too soon:
	//mob = nil;
	
	
	// Create the target slightly off-screen along the right edge,
	// and along a random position along the Y axis as calculated above
	//mob.position = ccp(winSize.width + (mob.contentSize.width/2), actualY);
	mob.position = ccp(1200 + minY, actualY);
	//mob.scaleX = -mob.scaleX;   //do not flip sprite.
	[self addChild:mob];
	
	// Determine speed of the target  //CANT BE SAME NUMBERS OR CRASHES
	int minDuration = 7.0;
	int maxDuration = 8.0;
	int rangeDuration = maxDuration - minDuration;
	int actualDuration = (arc4random() % rangeDuration) + minDuration;
	//int actualDuration = (arc4random() % rangeDuration) + minDuration;
	
	// Create the actions
	//	id actionMove = [CCMoveTo actionWithDuration:actualDuration 
	//										position:ccp(-mob.contentSize.width/2, actualY)];
	id actionMove = [CCMoveTo actionWithDuration:actualDuration 
										position:ccp(-400, actualY)];
	id actionMoveDone = [CCCallFuncN actionWithTarget:self 
											 selector:@selector(spriteMoveFinished:)];
	[mob runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
	
	//mob = nil;
	
}
//_____________________________________________________________ addTargetmines905 ends 10	

// new plants:
-(void)addNonTargetPlant5 {
	
	CCSprite *target = [CCSprite spriteWithFile:@"greeskinny_medtrim.png" 
										   rect:CGRectMake(0, 0, 76, 252)]; 
	
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	int actualY = target.contentSize.height/2 - 10;
	
	// position target:
	target.position = ccp(winSize.width + (target.contentSize.width/2), actualY);
	target.scaleX = -target.scaleX;
	[self addChild:target];
	
	// Determine speed of the target
	int minDuration = 4.0;
	int maxDuration = 7.0;
	int rangeDuration = maxDuration - minDuration;
	int actualDuration = (arc4random() % rangeDuration) + minDuration;
	
	// Create the actions
	id actionMove = [CCMoveTo actionWithDuration:actualDuration 
										position:ccp(-target.contentSize.width/2, actualY)];
	id actionMoveDone = [CCCallFuncN actionWithTarget:self 
											 selector:@selector(spriteMoveFinished:)];
	[target runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
	
}
//_______________________________________________________________________________________	

// new plants:
-(void)addNonTargetPlant6 {
	
	CCSprite *target = [CCSprite spriteWithFile:@"thinplant_medtrim_186_319.png" 
										   rect:CGRectMake(0, 0, 186, 319)]; 
	
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	int actualY = target.contentSize.height/2 - 22;
	
	// position target:
	target.position = ccp(winSize.width + (target.contentSize.width/2), actualY);
	target.scaleX = -target.scaleX;
	[self addChild:target];
	
	// Determine speed of the target
	int minDuration = 4.0;
	int maxDuration = 7.0;
	int rangeDuration = maxDuration - minDuration;
	int actualDuration = (arc4random() % rangeDuration) + minDuration;
	
	// Create the actions
	id actionMove = [CCMoveTo actionWithDuration:actualDuration 
										position:ccp(-target.contentSize.width/2, actualY)];
	id actionMoveDone = [CCCallFuncN actionWithTarget:self 
											 selector:@selector(spriteMoveFinished:)];
	[target runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
	
}
//_______________________________________________________________________________________	

// new plants:
-(void)addNonTargetPlant7 {
	
	CCSprite *target = [CCSprite spriteWithFile:@"castle2_medtrim.png" 
										   rect:CGRectMake(0, 0, 193, 246)]; 
	
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	int actualY = target.contentSize.height/2 - 35;
	
	// position target:
	target.position = ccp(winSize.width + (target.contentSize.width/2), actualY);
	target.scaleX = -target.scaleX;
	[self addChild:target];
	
	// Determine speed of the target
	int minDuration = 4.0;
	int maxDuration = 7.0;
	int rangeDuration = maxDuration - minDuration;
	int actualDuration = (arc4random() % rangeDuration) + minDuration;
	
	// Create the actions
	id actionMove = [CCMoveTo actionWithDuration:actualDuration 
										position:ccp(-target.contentSize.width/2, actualY)];
	id actionMoveDone = [CCCallFuncN actionWithTarget:self 
											 selector:@selector(spriteMoveFinished:)];
	[target runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
	
}
//_______________________________________________________________________________________	

// new plants:
-(void)addNonTargetPlant8 {
	
	CCSprite *target = [CCSprite spriteWithFile:@"castle1_medtrim.png" 
										   rect:CGRectMake(0, 0, 169, 295)]; 
	
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	int actualY = target.contentSize.height/2 - 35;
	
	// position target:
	target.position = ccp(winSize.width + (target.contentSize.width/2), actualY);
	target.scaleX = -target.scaleX;
	[self addChild:target];
	
	// Determine speed of the target
	int minDuration = 4.0;
	int maxDuration = 7.0;
	int rangeDuration = maxDuration - minDuration;
	int actualDuration = (arc4random() % rangeDuration) + minDuration;
	
	// Create the actions
	id actionMove = [CCMoveTo actionWithDuration:actualDuration 
										position:ccp(-target.contentSize.width/2, actualY)];
	id actionMoveDone = [CCCallFuncN actionWithTarget:self 
											 selector:@selector(spriteMoveFinished:)];
	[target runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
	
}
//_______________________________________________________________________________________	

// new plants:
-(void)addNonTargetPlant9 {
	
	CCSprite *target = [CCSprite spriteWithFile:@"rock1new_medtrim.png" 
										   rect:CGRectMake(0, 0, 292, 251)]; 
	
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	int actualY = target.contentSize.height/2 - 130;
	
	// position target:
	target.position = ccp(winSize.width + (target.contentSize.width/2), actualY);
	target.scaleX = -target.scaleX;
	[self addChild:target];
	
	// Determine speed of the target
	int minDuration = 4.0;
	int maxDuration = 7.0;
	int rangeDuration = maxDuration - minDuration;
	int actualDuration = (arc4random() % rangeDuration) + minDuration;
	
	// Create the actions
	id actionMove = [CCMoveTo actionWithDuration:actualDuration 
										position:ccp(-target.contentSize.width/2, actualY)];
	id actionMoveDone = [CCCallFuncN actionWithTarget:self 
											 selector:@selector(spriteMoveFinished:)];
	[target runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
	
}
//_______________________________________________________________________________________	

// new plants:
-(void)addNonTargetPlant10 {
	
	CCSprite *target = [CCSprite spriteWithFile:@"beigecoral_medtrim.png" 
										   rect:CGRectMake(0, 0, 229, 282)]; 
	
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	int actualY = target.contentSize.height/2 - 10;
	
	// position target:
	target.position = ccp(winSize.width + (target.contentSize.width/2), actualY);
	target.scaleX = -target.scaleX;
	[self addChild:target];
	
	// Determine speed of the target
	int minDuration = 4.0;
	int maxDuration = 7.0;
	int rangeDuration = maxDuration - minDuration;
	int actualDuration = (arc4random() % rangeDuration) + minDuration;
	
	// Create the actions
	id actionMove = [CCMoveTo actionWithDuration:actualDuration 
										position:ccp(-target.contentSize.width/2, actualY)];
	id actionMoveDone = [CCCallFuncN actionWithTarget:self 
											 selector:@selector(spriteMoveFinished:)];
	[target runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
	
}
//_______________________________________________________________________________________	

// new plants:
-(void)addNonTargetPlant11 {
	
	CCSprite *target = [CCSprite spriteWithFile:@"rock5new_medtrim.png" 
										   rect:CGRectMake(0, 0, 252, 168)]; 
	
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	int actualY = target.contentSize.height/2 - 36;
	
	// position target:
	target.position = ccp(winSize.width + (target.contentSize.width/2), actualY);
	target.scaleX = -target.scaleX;
	[self addChild:target];
	
	// Determine speed of the target
	int minDuration = 4.0;
	int maxDuration = 7.0;
	int rangeDuration = maxDuration - minDuration;
	int actualDuration = (arc4random() % rangeDuration) + minDuration;
	
	// Create the actions
	id actionMove = [CCMoveTo actionWithDuration:actualDuration 
										position:ccp(-target.contentSize.width/2, actualY)];
	id actionMoveDone = [CCCallFuncN actionWithTarget:self 
											 selector:@selector(spriteMoveFinished:)];
	[target runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
	
}
//_______________________________________________________________________________________	

// new plants:
-(void)addNonTargetPlant12 {
	
	CCSprite *target = [CCSprite spriteWithFile:@"reflection_fade_trimmed_final.png" 
										   rect:CGRectMake(0, 0, 1200, 549)]; 
	
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	//int actualY = target.contentSize.height/2 - winSize.height;
	int actualY = winSize.height - target.contentSize.height;
	
	// position target:
	//target.position = ccp(winSize.width + (target.contentSize.width/2), actualY);
	//target.position = ccp(0, actualY);
	
	//top of screen before slidedown:
	target.position = ccp(winSize.width/2, (winSize.height)+(target.contentSize.height/2));
	//target.position = ccp(winSize.width/2, winSize.height);   // top?
	
	// correct position to start scrolling:
	//target.position = ccp(winSize.width/2, (winSize.height/2)+(target.contentSize.height/2));
	target.scaleX = -target.scaleX;
	target.scaleX = 1.6;
	target.scaleY = 1.6;
	[self addChild:target z:2900];
	
	// Determine speed of the target
	int minDuration = 205.0;
	int maxDuration = 220.0;
	int rangeDuration = maxDuration - minDuration;
	int actualDuration = (arc4random() % rangeDuration) + minDuration;
	
	int minDurationV = 1.0;
	int maxDurationV = 2.0;
	int rangeDurationV = maxDurationV - minDurationV;
	int actualDurationV = (arc4random() % rangeDurationV) + minDurationV;
	
	// Create the actions
	id actionMoveIntoView = [CCMoveTo actionWithDuration:actualDurationV 
										position:ccp(winSize.width/2, (winSize.height/2)+(target.contentSize.height/2))];
	
	id actionMove = [CCMoveTo actionWithDuration:actualDuration 
										position:ccp(-target.contentSize.width/2, actualY)];
	
	//original:
	//	id actionMove = [CCMoveTo actionWithDuration:actualDuration 
	//										position:ccp(-target.contentSize.width/2, actualY)];
		
	
	id actionMoveDone = [CCCallFuncN actionWithTarget:self 
											 selector:@selector(spriteMoveFinished:)];
	[target runAction:[CCSequence actions:actionMoveIntoView, actionMove, actionMoveDone, nil]];
	
}
//_______________________________________________________________________________________	

// new plants:
-(void)addNonTargetPlant13 {
	
	CCSprite *target = [CCSprite spriteWithFile:@"bigcoral_medtrim.png" 
										   rect:CGRectMake(0, 0, 499, 267)]; 
	
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	int actualY = target.contentSize.height/2 - 37;
	
	// position target:
	target.position = ccp(winSize.width + (target.contentSize.width/2), actualY);
	target.scaleX = -target.scaleX;
	[self addChild:target];
	
	// Determine speed of the target
	int minDuration = 4.0;
	int maxDuration = 7.0;
	int rangeDuration = maxDuration - minDuration;
	int actualDuration = (arc4random() % rangeDuration) + minDuration;
	
	// Create the actions
	id actionMove = [CCMoveTo actionWithDuration:actualDuration 
										position:ccp(-target.contentSize.width/2, actualY)];
	id actionMoveDone = [CCCallFuncN actionWithTarget:self 
											 selector:@selector(spriteMoveFinished:)];
	[target runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
	
}
//_______________________________________________________________________________________	

// new plants:
-(void)addNonTargetPlant14 {
	
	CCSprite *target = [CCSprite spriteWithFile:@"brightcoral.png" 
										   rect:CGRectMake(0, 0, 760, 544)]; 
	
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	int actualY = target.contentSize.height/2 - 315;
	
	// position target:
	target.position = ccp(winSize.width + (target.contentSize.width/2), actualY);
	//target.scaleX = -target.scaleX;
	target.scaleX = .50;
	target.scaleY = .50;
	[self addChild:target];
	
	// Determine speed of the target
	int minDuration = 4.0;
	int maxDuration = 7.0;
	int rangeDuration = maxDuration - minDuration;
	int actualDuration = (arc4random() % rangeDuration) + minDuration;
	
	// Create the actions
	id actionMove = [CCMoveTo actionWithDuration:actualDuration 
										position:ccp(-target.contentSize.width/2, actualY)];
	id actionMoveDone = [CCCallFuncN actionWithTarget:self 
											 selector:@selector(spriteMoveFinished:)];
	[target runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
	
}
//_______________________________________________________________________________________	





/*
//
//
//
//               .__         .___ _______  .______________
//  _____ _____  |__| ____   |   |\      \ |   \__    ___/
// /     \\__  \ |  |/    \  |   |/   |   \|   | |    |   
//|  Y Y  \/ __ \|  |   |  \ |   /    |    \   | |    |   
//|__|_|  (____  /__|___|  / |___\____|__  /___| |____|   
//      \/     \/        \/              \/               
//  MAIN
//
//
*/



-(id) init {
    if((self = [super init])) {

		//prep arrays:
		
		_targets = [[NSMutableArray alloc] init];
		_projectiles = [[NSMutableArray alloc] init];
		_mobs = [[NSMutableArray alloc] init];
		
		//NSMutableArray *_mobs;
		
		// Reset everything here for next level:
		
		//reset fish counters:
		//[str release];
		//[strMines release];
		//		strMines = nil;
		//		str = nil;
		
		[str setString:@"NEWMUTABLE|"];
		[strMines setString:@"NEWMUTABLE|"];
		
		// start next level:
			
		intCurrentLevel = intCurrentLevel + 1;
		
		NSLog(@"Level %i Starting!", intCurrentLevel);
		
		//set SurvivalMapNumber to 1 if intCurrentLevel is = 1
		
		if (intCurrentLevel == 1) {
			SurvivalMapNumber = 0;
		}
		
		//is modulus?
		if (intCurrentLevel % 2 == (0)) {
			
			SurvivalMapNumber = SurvivalMapNumber + 1;
			if (SurvivalMapNumber == 4) {
				SurvivalMapNumber = 1;
			}
		}

		
		//TEST:  JUmpto:
		//		if (intCurrentLevel == 2) {
		//			//jump to 98 after
		//			intCurrentLevel = 4;
		//		}
		//		
		//		if (intCurrentLevel == 12) {
		//			//jump to 98 after
		//			intCurrentLevel = 19;
		//		}
		//		
		//		if (intCurrentLevel == 22) {
		//			//jump to 98 after
		//			intCurrentLevel = 29;
		//		}
		//		
		//		if (intCurrentLevel == 32) {
		//			//jump to 98 after
		//			intCurrentLevel = 39;
		//		}
		
		//if (intCurrentLevel % 5 == (0)) {
		//			NSLog(@"Modulus 5!");
		//			
		//		}
		
		zLevelSprites = 1050;
		
		//LIVE: turn this off or on if you want to start levels with same health:
		
//		healthBarScale = 6;
		globalPlayerHealth = 100;
		
		
		
		
		//this is preloaded on main menu if its the first time.
		//audio:
		//[[SimpleAudioEngine sharedEngine] preloadEffect:@"boomonly.caf"];
		
		//test play:
		//[[SimpleAudioEngine sharedEngine] playEffect:@"boomonly.caf"];

		
		// check level for correct background:
		//		seaweed_1024_768.png
		//		rockformations_1024_768.png
		//		riverbottom_1024_768.png
		//		shining_1024_768.png
		
		//0 1 7 3 9 0
		//backgroundImageLoading = [CCSprite spriteWithFile: @"tracedfinal_fade_rockformations_1024_768.png"]; 
		//backgroundImageLoading = [CCSprite spriteWithFile: @"7_final_stop.jpg"];
		
		
		//newSwitch
		if (intCurrentBGNum == 0){
			if (intCurrentLevel == 1) {
				maxNumberofFish = 75;
			}
			backgroundImageLevel001 = [CCSprite spriteWithFile: @"00tracedfinal_withfade2.png"];
		} else if (intCurrentBGNum == 1) {
			backgroundImageLevel001 = [CCSprite spriteWithFile: @"01riverbottom_tracedone.png"];
		} else if (intCurrentBGNum == 2) {
			backgroundImageLevel001 = [CCSprite spriteWithFile: @"02reef_tracedone.png"];
		} else if (intCurrentBGNum == 3) {
			backgroundImageLevel001 = [CCSprite spriteWithFile: @"03seaweed_tracedone.png"];
		} else if (intCurrentBGNum == 4) {
			backgroundImageLevel001 = [CCSprite spriteWithFile: @"04reefhawk_tracedone2.png"];
		} else if (intCurrentBGNum == 5) {
			backgroundImageLevel001 = [CCSprite spriteWithFile: @"05garbagearea_tracedone.png"];
		} else if (intCurrentBGNum == 6) {
			backgroundImageLevel001 = [CCSprite spriteWithFile: @"06sandy_tracedone.png"];
		} else if (intCurrentBGNum == 7) {
			backgroundImageLevel001 = [CCSprite spriteWithFile: @"07rockformations_tracedone.png"];
		} else if (intCurrentBGNum == 8) {
			backgroundImageLevel001 = [CCSprite spriteWithFile: @"08ninth_tracedone.png"];
		} else if (intCurrentBGNum == 9) {
			backgroundImageLevel001 = [CCSprite spriteWithFile: @"09shining_1024_768.png"];
		} else {
			backgroundImageLevel001 = [CCSprite spriteWithFile: @"00tracedfinal_withfade2.png"];
		}
		
		//		// check switch for next time:
		//		if ((intCurrentLevel - intLastLevelSwitch) >= 3) {
		//			intLastLevelSwitch = intCurrentLevel;
		//			//switch level!
		//			intCurrentBGNum = intCurrentBGNum + 1;
		//			if (intCurrentBGNum == 10) {
		//				intCurrentBGNum = 0;
		//			}
		//		}
		// end of newSwitch
		
		
		
		//		//FINAL ORDER OF BACKGROUNDS:
		//		if ((intCurrentLevel >= 1) && (intCurrentLevel <= 19)) {
		//			//reset:
		//			// check if #1 for maxfish reset:
		//			if (intCurrentLevel == 1) {
		//				maxNumberofFish = 75;
		//			}
		//			//backgroundImageLevel001 = [CCSprite spriteWithFile: @"tracedfinal_withfade2.png"];
		//			backgroundImageLevel001 = [CCSprite spriteWithFile: @"00tracedfinal_withfade2.png"];
		//		} else if ((intCurrentLevel >= 20) && (intCurrentLevel <= 39)) {
		//			//backgroundImageLevel001 = [CCSprite spriteWithFile: @"riverbottom_1024_768.png"];
		//			backgroundImageLevel001 = [CCSprite spriteWithFile: @"01riverbottom_tracedone.png"];
		//		} else if ((intCurrentLevel >= 40) && (intCurrentLevel <= 59)) {
		//			//backgroundImageLevel001 = [CCSprite spriteWithFile: @"rockformations_1024_768.png"];
		//			backgroundImageLevel001 = [CCSprite spriteWithFile: @"07rockformations_tracedone.png"];
		//		} else if ((intCurrentLevel >= 60) && (intCurrentLevel <= 79)) {
		//			//backgroundImageLevel001 = [CCSprite spriteWithFile: @"seaweed_1024_768.png"];
		//			backgroundImageLevel001 = [CCSprite spriteWithFile: @"03seaweed_tracedone.png"];
		//		} else if ((intCurrentLevel >= 80) && (intCurrentLevel <= 99)) {
		//			//backgroundImageLevel001 = [CCSprite spriteWithFile: @"shining_1024_768.png"];
		//			backgroundImageLevel001 = [CCSprite spriteWithFile: @"09shining_1024_768.png"];
		//		} else {
		//			//backgroundImageLevel001 = [CCSprite spriteWithFile: @"tracedfinal_withfade2.png"];
		//			backgroundImageLevel001 = [CCSprite spriteWithFile: @"00tracedfinal_withfade2.png"];
		//		}
		
		
		//BACKGROUND SHOWN:____________________________________________________________________
		//backgroundImageLevel001 = [CCSprite spriteWithFile: @"tracedfinal_withfade2.png"];
		
		//CGSize size = [[CCDirector sharedDirector] winSize];
		//CGSize size = CGSizeMake(1024, 768);		
		
		CGSize sizeLevel001 = [[CCDirector sharedDirector] winSize];
		backgroundImageLevel001.position = ccp( sizeLevel001.width /2 , sizeLevel001.height/2 ); 
				
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		{
			// The device is an iPad running iPhone 3.2 or later.
		}
		else
		{
			//spread out image to fit the phone scale:
			backgroundImageLevel001.scaleX = 1.124;
		}
				
        [self addChild:backgroundImageLevel001];
		
				
		//		//NUMBER SPRITES: FOR SCORE, ETC:
		//		//add number test:
		//		CCLabelAtlas *labelar = [CCLabelAtlas labelAtlasWithString:@"45245" charMapFile:@"numbers_sprite_49_61.png" itemWidth:49 itemHeight:61 startCharMap:'0'];
		//		[self addChild:labelar];

		
		
		// HERO FISH SHOWN:_____________________________________________________________________________
        // This loads an image of the same name (but ending in png), and goes through the
        // plist to add definitions of each frame to the cache.
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"fishtexture.plist"];        

        // Create a sprite sheet with bluefugu images
        CCSpriteSheet *spriteSheet = [CCSpriteSheet spriteSheetWithFile:@"fishtexture.png"];
        [self addChild:spriteSheet z:1003];

        // Load up the frames of our animation
        NSMutableArray *walkAnimFrames = [NSMutableArray array];
        for(int i = 1; i <= 8; ++i) {
            [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"bluefugu_med_%d.png", i]]];
        }
        CCAnimation *walkAnim = [CCAnimation animationWithName:@"walk" delay:0.1f frames:walkAnimFrames];

        // Create a sprite for bluefugu
        //CGSize winSize = [CCDirector sharedDirector].winSize;
        self.bluefugu = [CCSprite spriteWithSpriteFrameName:@"bluefugu_med_1.png"];        
        /*_bluefugu.position = ccp(winSize.width/2, winSize.height/2);*/
		//bluePuff.position = ccp( 200, 300 );
		_bluefugu.position = ccp( 200, 300 );
        self.walkAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkAnim restoreOriginalFrame:NO]];
   
        [spriteSheet addChild:_bluefugu z:998];  // z:998 ignored
        
		
		
		// setup display text SCORE TEXT_________________________________________________________
		//self.label = [CCLabel labelWithString:@"SCORE:" fontName:@"SF Comic Script" fontSize:64];
		self.label = [CCLabel labelWithString:@"SCORE:" fontName:@"SF Comic Script" fontSize:58];
		_label.color = ccc3(255,255,255);
		//_label.position = ccp(size.width/2, size.height/2);  //centered
		//_label.position = ccp(size.width/2, 750);  //centered
		//no jumping?
		//_label.position = ccp(400, 725);  //centered

		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		{
			// The device is an iPad running iPhone 3.2 or later.
			_label.position = ccp(400, 725);  //centered
		}
		else
		{
			//spread out image to fit the phone scale:
			_label.position = ccp(448, 725);
		}

		[self addChild:_label z:999];
		
		

		//////show values  currentNumberofFish     
		//NSString *intConvShowCurrentFish = [NSString stringWithFormat:@" Current Fish Total: %i",currentNumberofFish];
		//[_bottomlabel setString:intConvShowCurrentFish];


		//label_ShowLevelNumber
		//LIVE:
		NSString *intShowCurrentLevel = [NSString stringWithFormat:@"Level %i ",intCurrentLevel];
		//TEST:
		//NSString *intShowCurrentLevel = [NSString stringWithFormat:@"Level 99 "];
		self.label_ShowLevelNumber = [CCLabel labelWithString:intShowCurrentLevel fontName:@"SF Comic Script" fontSize:42];
		_label_ShowLevelNumber.color = ccc3(255,255,255);
		//_label.position = ccp(size.width/2, size.height/2);  //centered
		//_label.position = ccp(size.width/2, 750);  //centered
		//no jumping?
		//_label_ShowLevelNumber.position = ccp(70, 725);  //centered
		//_label_ShowLevelNumber.position = ccp(95, 30);  
		_label_ShowLevelNumber.position = ccp(95, 98);  
		[self addChild:_label_ShowLevelNumber z:997];

		intShowCurrentLevel = nil;


		//health tag: label_ShowHealthTag
		//label_ShowLevelNumber
		//NSString *intShowHealthTag = [NSString stringWithFormat:@"Level %i ",intCurrentLevel];
		self.label_ShowHealthTag = [CCLabel labelWithString:@"Health " fontName:@"SF Comic Script" fontSize:38];
		_label_ShowHealthTag.color = ccc3(255,255,255);
		//_label.position = ccp(size.width/2, size.height/2);  //centered
		//_label.position = ccp(size.width/2, 750);  //centered
		//no jumping?
		//_label_ShowLevelNumber.position = ccp(70, 725);  //centered
		_label_ShowHealthTag.position = ccp(70, 739);  
		[self addChild:_label_ShowHealthTag z:997];

		//intShowCurrentLevel = nil;



		
		//		// setup display text SCORE TEXT_________________________________________________________
		//		//self.label_part2 = [CCLabel labelWithString:@"00000 " fontName:@"SF Comic Script" fontSize:64];
		//		self.label_part2 = [CCLabel labelWithString:@"_" fontName:@"SF Comic Script" fontSize:64];
		//		_label_part2.color = ccc3(255,255,255);
		//		//_label.position = ccp(size.width/2, size.height/2);  //centered
		//		//_label.position = ccp(size.width/2, 750);  //centered
		//		//no jumping?
		//		_label_part2.position = ccp(610, 730);  //centered
		//		[self addChild:_label_part2];
		
		
		// THESE ARE OK, COMMENTING OUT FOR NOW FOR MEMORY LEAK TEST
		
		/*
		// setup display text2
		self.bottomlabel = [CCLabel labelWithString:@"showBG Y Values" fontName:@"Arial" fontSize:24];
		_bottomlabel.color = ccc3(255,255,255);
		//_label.position = ccp(size.width/2, size.height/2);  //centered
		_bottomlabel.position = ccp(sizeLevel001.width/2, 40);  //centered
		[self addChild:_bottomlabel z:996];
		
		
		// setup display text3
		self.bottomlabel2 = [CCLabel labelWithString:@"showBG Y Values" fontName:@"Arial" fontSize:24];
		_bottomlabel2.color = ccc3(255,255,255);
		//_label.position = ccp(size.width/2, size.height/2);  //centered
		_bottomlabel2.position = ccp(sizeLevel001.width/2, 70);  //centered
		[self addChild:_bottomlabel2  z:995];
		*/

		
		
		//SET RANDOM NUMBER ON READOUTS:
		//[_bottomlabel2 setString:@"Game Over!"];
	
		srand([[NSDate date] timeIntervalSince1970]);
		/*fishRandomNumber = 1 + rand()%10;*/
		//change to 10 for the new fish count:  1-10
		fishRandomNumber = 1 + rand()%10;
		//start tracking?
		//fishRandomNumberList = fishRandomNumber;
		
		//		//setup  fishRandomNumber  test random number of fish one
		//		NSString *intConversionfishRandomNumberString = [NSString stringWithFormat:@"First Random Fish #: %i",fishRandomNumber];
		//		[_bottomlabel2 setString:intConversionfishRandomNumberString];

		
		
		
		//SCORE DISPLAY:
		//add number test:
		//CCLabelAtlas *labelar = [CCLabelAtlas labelAtlasWithString:@"00000" charMapFile:@"numbers_sprite_49_61.png" itemWidth:49 itemHeight:61 startCharMap:'0'];
		self.labelar = [CCLabelAtlas labelAtlasWithString:@"000000" charMapFile:@"whitewithbluenumbers_45_61_final.png" itemWidth:45 itemHeight:61 startCharMap:'0'];
		//_labelar.position = ccp(390, 70);   // width of 5 numbers, divided by 2. subtract from half of width 512-124=390
		//_labelar.position = ccp(500, 690);   // width of 5 numbers, divided by 2. subtract from half of width 512-124=390
		//495, 698

		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		{
			// The device is an iPad running iPhone 3.2 or later.
			_labelar.position = ccp(500, 690);  
		}
		else
		{
			//spread out image to fit the phone scale:
			_labelar.position = ccp(548, 690);
		}

		//_labelar.position = ccp(495, 698);
		[self addChild:_labelar  z:994];
		
		
		
		//preload anims:
		
		//start of GoBoom
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"goBoom.plist"];        
		
		// Create a sprite sheet with the Happy goZoom images
		CCSpriteSheet *spriteSheet38 = [CCSpriteSheet spriteSheetWithFile:@"goBoom.png"];
		
		
		
		[self addChild:spriteSheet38  z:zLevelSprites];
		
		// Load up the frames of our animation
		NSMutableArray *walkAnimFrames38 = [NSMutableArray array];
		for(int i = 1; i <= 15; ++i) {
			[walkAnimFrames38 addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"EXPL%02d.png", i]]];
		}
		CCAnimation *walkAnim38 = [CCAnimation animationWithName:@"walk" delay:0.1f frames:walkAnimFrames38];
		
		// Create a sprite for our goZoom
		//CGSize winSize3 = [CCDirector sharedDirector].winSize;
		self.goBoom = [CCSprite spriteWithSpriteFrameName:@"EXPL01.png"];     //ZOOMGO1.png  epexted   
		_goBoom.position = ccp(-300, -300);
		//self.wBanimAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkAnim3 restoreOriginalFrame:NO]];
		self.wBanimAction = [CCAnimate actionWithAnimation:walkAnim38 restoreOriginalFrame:NO];
		
		zLevelSprites = zLevelSprites + 1;	
		
		[spriteSheet38 addChild:_goBoom z:zLevelSprites];
		
		[_goBoom runAction:_wBanimAction];   
		
		//id actionMoveDone = [CCCallFuncN actionWithTarget:self 
		//														 selector:@selector(spriteMoveFinished:)];
		
		//this cant be run if it doesnt exist:
		//[_goBoom release];
		
		//[spriteSheet3 runAction:[CCSequence actions:actionMoveDone, nil]];
		//this cant be run if it doesnt exist:
		//spriteSheet3 = nil;
		// end of goBoom
		
		//moved above to preload anim:  moved back and to init...
		//start of goPoints125
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"goPoints125.plist"];        
		
		// Create a sprite sheet with the Happy goZoom images
		CCSpriteSheet *spriteSheet47 = [CCSpriteSheet spriteSheetWithFile:@"goPoints125.png"];
		
		[self addChild:spriteSheet47  z:zLevelSprites];
		
		
		
		// Load up the frames of our animation
		NSMutableArray *walkAnimFrames47 = [NSMutableArray array];
		for(int i = 1; i <= 21; ++i) {
			[walkAnimFrames47 addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"POIN%02d.png", i]]];
		}
		CCAnimation *walkAnim47 = [CCAnimation animationWithName:@"walk" delay:0.1f frames:walkAnimFrames47];
		
		// Create a sprite for our goPoints125
		//CGSize winSize3 = [CCDirector sharedDirector].winSize;
		self.goPoints125 = [CCSprite spriteWithSpriteFrameName:@"POIN01.png"];     //ZOOMGO1.png  epexted   
		_goPoints125.position = ccp(-300, -300);
		//self.wBanimAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkAnim3 restoreOriginalFrame:NO]];
		self.wBanimAction = [CCAnimate actionWithAnimation:walkAnim47 restoreOriginalFrame:NO];
		
		//increase z order for next explosion or points:
		zLevelSprites = zLevelSprites + 1;
		
		[spriteSheet47 addChild:_goPoints125 z:zLevelSprites];
		
		[_goPoints125 runAction:_wBanimAction];   
		// end of goPoints125
		
		zLevelSprites = zLevelSprites + 1;
		
		//this cant be run if it doesnt exist:
		//[_goPoints125 release];
		
		//this cant be run if it doesnt exist:
		//spriteSheet4 = nil;
		

		//NEW FISH AND ITEM PRELOADS:

		CCSprite *targetPL001 = [CCSprite spriteWithFile:@"tigerfish_small_trim.png" rect:CGRectMake(0, 0, 88, 27)]; 
		targetPL001.position = ccp(0, -800);
		[self addChild:targetPL001];

		//target.position = ccp( 1100, -800); 	

		CCSprite *targetPL002 = [CCSprite spriteWithFile:@"redfish_small_trim.png" 
		rect:CGRectMake(0, 0, 103, 50)]; 
		targetPL002.position = ccp(0, -800);
		[self addChild:targetPL002];

		CCSprite *targetPL003 = [CCSprite spriteWithFile:@"blackandwhitefish_small_trim_72dpi.png" 
		rect:CGRectMake(0, 0, 110, 70)]; 	
		targetPL003.position = ccp(0, -800);
		[self addChild:targetPL003];

		CCSprite *targetPL004 = [CCSprite spriteWithFile:@"blckwhiteyellowfish_small_trim_72dpi.png" 
		rect:CGRectMake(0, 0, 113, 98)]; 
		targetPL004.position = ccp(0, -800);
		[self addChild:targetPL004];

		CCSprite *targetPL005 = [CCSprite spriteWithFile:@"blueyellowfish_small_trim.png" 
		rect:CGRectMake(0, 0, 117, 67)]; 
		targetPL005.position = ccp(0, -800);
		[self addChild:targetPL005];

		CCSprite *targetPL006 = [CCSprite spriteWithFile:@"silver1_small_trim.png" 
		rect:CGRectMake(0, 0, 101, 57)]; 
		targetPL006.position = ccp(0, -800);
		[self addChild:targetPL006];

		CCSprite *targetPL007 = [CCSprite spriteWithFile:@"yellowfish_small_trim.png" 
		rect:CGRectMake(0, 0, 136, 66)];
		targetPL007.position = ccp(0, -800);
		[self addChild:targetPL007];

		CCSprite *targetPL008 = [CCSprite spriteWithFile:@"yelloworange_small_trim.png" 
		rect:CGRectMake(0, 0, 116, 90)]; 
		targetPL008.position = ccp(0, -800);
		[self addChild:targetPL008];

		CCSprite *targetPL009 = [CCSprite spriteWithFile:@"yellowtwo_small_trim.png" 
		rect:CGRectMake(0, 0, 100, 77)]; 
		targetPL009.position = ccp(0, -800);
		[self addChild:targetPL009];

		CCSprite *targetPL010 = [CCSprite spriteWithFile:@"purple_small_trim.png" 
		rect:CGRectMake(0, 0, 179, 65)]; 
		targetPL010.position = ccp(0, -800);
		[self addChild:targetPL010];

		CCSprite *targetPL011 = [CCSprite spriteWithFile:@"bluepurpcoral_medtrim.png" 
		rect:CGRectMake(0, 0, 257, 291)]; 
		targetPL011.position = ccp(0, -800);
		[self addChild:targetPL011];

		CCSprite *targetPL012 = [CCSprite spriteWithFile:@"grass_medtrim.png" 
		rect:CGRectMake(0, 0, 431, 250)]; 
		targetPL012.position = ccp(0, -800);
		[self addChild:targetPL012];

		CCSprite *targetPL013 = [CCSprite spriteWithFile:@"reeds.png" 
		rect:CGRectMake(0, 0, 548, 898)]; 
		targetPL013.position = ccp(0, -900);
		[self addChild:targetPL013];

		CCSprite *targetPL014 = [CCSprite spriteWithFile:@"wideleaf_medtrim_67_297.png" 
		rect:CGRectMake(0, 0, 67, 297)]; 
		targetPL014.position = ccp(0, -800);
		[self addChild:targetPL014];

		CCSprite *targetPL015 = [CCSprite spriteWithFile:@"bubbleorig_64_40.png" 
		rect:CGRectMake(0, 0, 64, 40)]; 
		targetPL015.position = ccp(0, -800);
		[self addChild:targetPL015];

		CCSprite *targetPL016 = [CCSprite spriteWithFile:@"metallic_mines903_dodged_100_99.png" 
		rect:CGRectMake(0, 0, 100, 99)]; 
		targetPL016.position = ccp(0, -800);
		[self addChild:targetPL016];

		CCSprite *targetPL017 = [CCSprite spriteWithFile:@"metallic_mines903_dodged_150_148.png" 
									rect:CGRectMake(0, 0, 150, 148)]; 
		targetPL017.position = ccp(0, -800);
		[self addChild:targetPL017];

		CCSprite *targetPL018 = [CCSprite spriteWithFile:@"metallic_mines903_dodged_200_197.png" 
									rect:CGRectMake(0, 0, 200, 197)];
		targetPL018.position = ccp(0, -800);
		[self addChild:targetPL018];

		CCSprite *targetPL019 = [CCSprite spriteWithFile:@"greeskinny_medtrim.png" 
		rect:CGRectMake(0, 0, 76, 252)]; 
		targetPL019.position = ccp(0, -800);
		[self addChild:targetPL019];

		CCSprite *targetPL020 = [CCSprite spriteWithFile:@"thinplant_medtrim_186_319.png" 
		rect:CGRectMake(0, 0, 186, 319)]; 
		targetPL020.position = ccp(0, -800);
		[self addChild:targetPL020];

		CCSprite *targetPL021 = [CCSprite spriteWithFile:@"castle2_medtrim.png" 
		rect:CGRectMake(0, 0, 193, 246)]; 
		targetPL021.position = ccp(0, -800);
		[self addChild:targetPL021];

		CCSprite *targetPL022 = [CCSprite spriteWithFile:@"castle1_medtrim.png" 
		rect:CGRectMake(0, 0, 169, 295)]; 
		targetPL022.position = ccp(0, -800);
		[self addChild:targetPL022];

		CCSprite *targetPL023 = [CCSprite spriteWithFile:@"rock1new_medtrim.png" 
		rect:CGRectMake(0, 0, 292, 251)]; 
		targetPL023.position = ccp(0, -800);
		[self addChild:targetPL023];

		CCSprite *targetPL024 = [CCSprite spriteWithFile:@"beigecoral_medtrim.png" 
		rect:CGRectMake(0, 0, 229, 282)]; 
		targetPL024.position = ccp(0, -800);
		[self addChild:targetPL024];

		CCSprite *targetPL025 = [CCSprite spriteWithFile:@"rock5new_medtrim.png" 
		rect:CGRectMake(0, 0, 252, 168)]; 
		targetPL025.position = ccp(0, -800);
		[self addChild:targetPL025];

		//CCSprite *targetPL026 = [CCSprite spriteWithFile:@"reflection_fade_trimmed_final.png" rect:CGRectMake(0, 0, 1200, 549)]; 

		CCSprite *targetPL027 = [CCSprite spriteWithFile:@"bigcoral_medtrim.png" 
		rect:CGRectMake(0, 0, 499, 267)]; 
		targetPL027.position = ccp(0, -800);
		[self addChild:targetPL027];

		CCSprite *targetPL028 = [CCSprite spriteWithFile:@"brightcoral.png" 
		rect:CGRectMake(0, 0, 760, 544)]; 
		targetPL028.position = ccp(0, -800);
		[self addChild:targetPL028];


		
		//end of PRELOADS
		
		
		
		
		
		//progressbar sprites:

		
		
		healthbgbar = [CCSprite spriteWithFile: @"health_bgbar_50x21.png"];
		//healthbgbar.position = ccp( size.width /2 , 30 ); 
		healthbgbar.position = ccp( 10 , 700 );
		healthbgbar.scaleX = 6;
		
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		{
			// The device is an iPad running iPhone 3.2 or later.
			healthbgbar.scaleX = 5;
		}
		
		[self addChild:healthbgbar z:994];
		[healthbgbar setAnchorPoint:ccp(0,0)];
		
		//healthbgbar = nil;
		
		// positioX 190-590
		// scaleX 0-16
		greenhealthbar = [CCSprite spriteWithFile: @"healthbar_green_50x21.png"];
		//blueprogbar.position = ccp( 590 , 70 ); 
		//blueprogbar.scaleX = 2;
		greenhealthbar.position = ccp( 10, 700 ); 
		
		//healthBarScale = (globalPlayerHealth * 6)/100;
		
		//greenhealthbar.scaleX = healthBarScale;
		greenhealthbar.scaleX = 6;
		
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		{
			// The device is an iPad running iPhone 3.2 or later.
			greenhealthbar.scaleX = 5;
		}
		
		[self addChild:greenhealthbar z:995];
		
		[greenhealthbar setAnchorPoint:ccp(0,0)];
		
		// size of the bar is scaleX 6 for 100, 3 for 50, etc.
		//  
		//  x     globalPlayerHealth   (0-100)
		// ___	= ___         
		// 
		//  6     100
		
		//greenhealthbar = nil;
		
		
		yellowhealthbar = [CCSprite spriteWithFile: @"healthbar_yellow_50x21.png"];
		yellowhealthbar.position = ccp( 10, 700 ); 
		yellowhealthbar.scaleX = 0;
		
		[self addChild:yellowhealthbar z:995];
		
		[yellowhealthbar setAnchorPoint:ccp(0,0)];
		
		
		redhealthbar = [CCSprite spriteWithFile: @"healthbar_red_50x21.png"];
		redhealthbar.position = ccp( 10, 700 ); 
		redhealthbar.scaleX = 0;
		
		[self addChild:redhealthbar z:995];
		
		[redhealthbar setAnchorPoint:ccp(0,0)];
		
		
		
		progressBarScale = (currentNumberofFish * 16)/maxNumberofFish;
		
		//NSLog(@"progressBarScale: %f",progressBarScale);  // runs once, always zero.
		
		//calculating progressbar scale offset:
		//  x     currentNumberofFish
		// ___  = ___
		//
		// 400    maxNumberofFish
		//
		//  x is the position adjustment for the bar from 590-190  (100-0)
		
		// size of the bar is scaleX 16 for 100, 8 for 50, etc.
		//  
		//  x     globalPlayerHealth   (0-100)
		// ___	= ___         
		// 
		// 16     100
		
		
		progressbgbar = [CCSprite spriteWithFile: @"progressbar_bgbar_50x21.png"];
		//progressbgbar.position = ccp( size.width /2 , 30 ); 
		progressbgbar.position = ccp( 570 , 96 );
		progressbgbar.scaleX = 15;
		[self addChild:progressbgbar z:994];
		
		// positioX 190-590
		// scaleX 0-16
		blueprogbar = [CCSprite spriteWithFile: @"bluebar_50x21.png"];
		//blueprogbar.position = ccp( 590 , 70 ); 
		//blueprogbar.scaleX = 2;
		blueprogbar.position = ccp( 190, 86 ); 
		blueprogbar.scaleX = 0;
		
		[self addChild:blueprogbar z:995];
		
		[blueprogbar setAnchorPoint:ccp(0,0)];
		
		
		
		
		
		
		
		//release sprite sheet?
		
		
		//start of GoZoom
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"zoomgo.plist"];        
		
        // Create a sprite sheet with the Happy goZoom images
        CCSpriteSheet *spriteSheet2 = [CCSpriteSheet spriteSheetWithFile:@"zoomgo.png"];
        [self addChild:spriteSheet2  z:1000];
		
		//spriteSheet2 = nil;
		
        // Load up the frames of our animation
        NSMutableArray *walkAnimFrames2 = [NSMutableArray array];
        for(int i = 1; i <= 12; ++i) {
            [walkAnimFrames2 addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"ZOOMGO%d.png", i]]];
        }
        CCAnimation *walkAnim2 = [CCAnimation animationWithName:@"walk" delay:0.1f frames:walkAnimFrames2];
		
        // Create a sprite for our goZoom
        CGSize winSize = [CCDirector sharedDirector].winSize;
        self.goZoom = [CCSprite spriteWithSpriteFrameName:@"ZOOMGO1.png"];     //ZOOMGO1.png  epexted   
        _goZoom.position = ccp(winSize.width/2, winSize.height/2);
        //self.wanimAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkAnim restoreOriginalFrame:NO]];
		self.wanimAction = [CCAnimate actionWithAnimation:walkAnim2 restoreOriginalFrame:NO];
		
        [spriteSheet2 addChild:_goZoom z:1001];
        
		[_goZoom runAction:_wanimAction];   
		// end of goZoom
		
		//spriteSheet2 = nil;
		
		
		if (intMusicOff == 0) {
			/*[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"drumsonly_gameplay_22mono.caf"];*/
			
			
//			[[SimpleAudioEngine sharedEngine] preloadEffect:@"boomonly_22mono.caf"];
//			//		//[[SimpleAudioEngine sharedEngine] preloadEffect:@"fishbop_rev_-1db_22mono.caf"];
//			[[SimpleAudioEngine sharedEngine] preloadEffect:@"fishbop_22mono.caf"];
//			[[SimpleAudioEngine sharedEngine] preloadEffect:@"raviment_gameover_22mono.caf"];
//			[[SimpleAudioEngine sharedEngine] preloadEffect:@"dancegroove4_22mono.caf"];
//			//drumsonly_gameplay_22mono.caf
//			//[[SimpleAudioEngine sharedEngine] preloadEffect:@"drumsonly_gameplay_22mono.caf"];
//			
//			NSLog(@"Sounds are attempting to preload...");
//			[[SimpleAudioEngine sharedEngine] playEffect:@"boomonly_22mono.caf" pitch:1.0f pan:0.0f gain:0.0f];
//			[[SimpleAudioEngine sharedEngine] playEffect:@"fishbop_22mono.caf" pitch:1.0f pan:0.0f gain:0.0f];
		}
		
		//sounds always play, otherwise use above:
		//[[SimpleAudioEngine sharedEngine] preloadEffect:@"boomonly_22mono.caf"];
		////		//[[SimpleAudioEngine sharedEngine] preloadEffect:@"fishbop_rev_-1db_22mono.caf"];
		//[[SimpleAudioEngine sharedEngine] preloadEffect:@"fishbop_22mono.caf"];
		//[[SimpleAudioEngine sharedEngine] preloadEffect:@"raviment_gameover_22mono.caf"];
		//[[SimpleAudioEngine sharedEngine] preloadEffect:@"dancegroove4_22mono.caf"];
		//drumsonly_gameplay_22mono.caf
		//[[SimpleAudioEngine sharedEngine] preloadEffect:@"drumsonly_gameplay_22mono.caf"];
		
		NSLog(@"Sounds are attempting to preload...");
		//[[SimpleAudioEngine sharedEngine] playEffect:@"boomonly_22mono.caf" pitch:1.0f pan:0.0f gain:0.0f];
		//[[SimpleAudioEngine sharedEngine] playEffect:@"fishbop_22mono.caf" pitch:1.0f pan:0.0f gain:0.0f];
		
		
		
		
		//[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"drumsonly_gameplay_22mono.caf"];			
		
		intMinesEverHit = 0;
		
		

		
		//this doesnt even work. which means none of this will. (move code to where it is effective)
		//		[[SimpleAudioEngine sharedEngine] playEffect:@"boomonly_22mono.caf"];
		//		[[SimpleAudioEngine sharedEngine] playEffect:@"fishbop_22mono.caf"];
		
		//[self backgroundMusicManager];
		
		//moved to end:
		//SCHEDULERS_______________________________________
		//spawn enemy fish
		//coontinuously spawn new ones:
		[self schedule:@selector(gameLogic:) interval:1.0];
		
		//coontinuously spawn 5 new ones:
		[self schedule:@selector(gameLogic2:) interval:1.1];
		
		// schedule a repeating callback on every frame - for fish
        [self schedule:@selector(nextFrameUpdateNow:)];
		
		// schedule a repeating callback on every frame - for mines
        [self schedule:@selector(nextFrameUpdateNowMines:)];
		
		//[self unschedule:@selector(gameLogic:)];
		//[self unschedule:@selector(gameLogic2:)];
		//[self unschedule:@selector(nextFrameUpdateNow:)];
		//[self unschedule:@selector(nextFrameUpdateNowMines:)];
		
		//INIT:
		//RESET LEVEL COUNTERS:
		//try resetting local vars here for next level:
		//this is overwriting the value, not resetting it...
		//SurvivalMapNumber = 1;
		//IF IT DOESN'T WORK (it's probably not listed here (SurvivalLevelNumber etc)
		alreadyPlayedTheSound = 0;
		iterator = 0;
		kickSoundIterator = 0;
		tigerfishRemoved = 0;
		rotationAmount = 0;
		r = 0;
		oneLifeRx = 0;
		oneLifeRy = 0;
		oneFlipRy = 0;
		fishBreathingOut = 0;
		multiTigerFishCounter = 0;
		currentNumberofFish = 0;
		zLevelSprites = 1050;  // start and reset
		currentTargetX = 0;
		currentTargetY = 0;
		//just use counters instead of arrays:
		multiRedFishCounter = 0;
		progressBarScale = 0;
		exitGameAlready = 0;
		showGameOverAlready = 0;
		//fishCoordRandomNumber = 1 + rand()%10;   //goes up 1-10
		fishCoordRandomNumber = 1;
		fishCoordRotator = 1;
		miscCounter = 0;
		
		NSLog(@"Level001 done loading.");
		NSLog(@"intCurrent: %i", intCurrentLevel);
		//NSLog(@"SurvivalMapNumber: %i", SurvivalMapNumber);
		NSLog(@"SurvivalMapNumber: %i", SurvivalMapNumber);
		
		NSLog(@"Mines it: %i", intMinesEverHit);
		
		//NSLog(@"SurvivalMapNumber: %f", SurvivalMapNumber);
		//NSLog(@"SurvivalMapNumber: %@", SurvivalMapNumber);
		
		//moved down here: cant preload while playing music!
		//[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"drumsonly_gameplay_22mono.caf"];
		//the above resets everything because its considered music, not thesfx:
		//[[SimpleAudioEngine sharedEngine] playEffect:@"drumsonly_gameplay_22mono.caf"];

		
        self.isTouchEnabled = YES;
                            
    }
    return self;
}
//_____________________________________________________________________________end of -(id) init ____






-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}
//___________________________________________________________________________________________________

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	
	
	CGPoint touchLocation = [touch locationInView: [touch view]];		
    touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];
    
    //float bluefuguVelocity = 480.0/3.0;
	//constant velocity.  how about faster for longer moves...
	
    CGPoint moveDifference = ccpSub(touchLocation, _bluefugu.position);
    //float distanceToMove = ccpLength(moveDifference);
    //float moveDuration = distanceToMove / bluefuguVelocity;
    
    if (moveDifference.x < 0) {
		// _bluefugu.flipX = YES;
		//no flipping
    } else {
        _bluefugu.flipX = NO;
    }    
    
    [_bluefugu stopAction:_moveAction];
    
    if (!_moving) {
        [_bluefugu runAction:_walkAction];
    }
    
	// take 1 second:
	//int actualDuration = 1;
	float actualDuration = 0.5;	
	
	
	self.moveAction = [CCSequence actions:                          
                       [CCMoveTo actionWithDuration:actualDuration position:touchLocation],
                       [CCCallFunc actionWithTarget:self selector:@selector(bluefuguMoveEnded)],
                       nil
                       ];
    
    
    [_bluefugu runAction:_moveAction];   
    _moving = TRUE;
	
	
	
	return YES;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {    
    CGPoint touchLocation = [touch locationInView: [touch view]];		
    touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];
    
    //float bluefuguVelocity = 480.0/3.0;
	//constant velocity.  how about faster for longer moves...

    CGPoint moveDifference = ccpSub(touchLocation, _bluefugu.position);
    //float distanceToMove = ccpLength(moveDifference);
    //float moveDuration = distanceToMove / bluefuguVelocity;
    
    if (moveDifference.x < 0) {
       // _bluefugu.flipX = YES;
		//no flipping
    } else {
        _bluefugu.flipX = NO;
    }    
    
    [_bluefugu stopAction:_moveAction];
    
    if (!_moving) {
        [_bluefugu runAction:_walkAction];
    }
    
	// take 1 second:
	//int actualDuration = 1;
	float actualDuration = 0.5;	
	

	 self.moveAction = [CCSequence actions:                          
                       [CCMoveTo actionWithDuration:actualDuration position:touchLocation],
                       [CCCallFunc actionWithTarget:self selector:@selector(bluefuguMoveEnded)],
                       nil
                       ];
    
    
    [_bluefugu runAction:_moveAction];   
    _moving = TRUE;

	//return YES;


}
//_________________________________________________________________________________end of touchended

-(void)bluefuguMoveEnded {
	
	// keep swimming
	//[_bluefugu stopAction:_walkAction];
    //_moving = FALSE;
}
//___________________________________________________________________________________________________



//DEALLOC



// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// small dealloc is BELOW
	// this is never called when the game is running:
	
	self.bluefugu = nil;
    self.walkAction = nil;
	self.moveAction = nil;
	
	self.goZoom = nil;
    self.wanimAction = nil;
	self.manimAction = nil;
	
	self.goBoom = nil;
    self.wBanimAction = nil;
	self.mBanimAction = nil;
	
	self.goPoints125 = nil;
    self.wP125animAction = nil;
	self.mP125animAction = nil;	
	
	//add schedulers
	[self unschedule:@selector(gameLogic:)];
	[self unschedule:@selector(gameLogic2:)];
	[self unschedule:@selector(nextFrameUpdateNow:)];
	[self unschedule:@selector(nextFrameUpdateNowMines:)];
	[self unschedule:@selector(gameOverSlowdown:)];
	[self unschedule:@selector(gameOverSlowdownSound:)];

	
	self.isTouchEnabled = NO;
	
	//add touch dispatch stuff:
	[self unschedule:@selector(ccTouchBegan:withEvent:)];
	[self unschedule:@selector(ccTouchEnded:withEvent:)];
	
	self.label = nil;					//score label
	//self.label_part2 = nil;		//score label
	
	//self.bottomlabel = nil;		//middle label
	//self.bottomlabel2 = nil;	//top label
	
	//self.label_BoomDisplay = nil;
	//self.label_FishScoreDisplay = nil;
	self.label_ShowLevelNumber = nil;
	
	self.labelar = nil;
	
	//_label_ShowHealthTag?
	//ie:
	self.label_ShowHealthTag = nil;
	//[_label_ShowHealthTag release];
	//_label_ShowHealthTag = nil;

	
	[[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
	
	//[[CCTextureCache sharedTextureCache] removeAllTextures];	
	//[[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
	
	[super dealloc];
}
//___________________________________________________________________________________________________


//small dealloc?
- (void) small_dealloc
{
	
	// this is never called when the game is running:
	
	//possible 1:
	//[_goPoints125 release];
	
	//need to remove targets:
	
	
	self.bluefugu = nil;
    self.walkAction = nil;
	self.moveAction = nil;
	
	self.goZoom = nil;
    self.wanimAction = nil;
	self.manimAction = nil;
	
	self.goBoom = nil;
    self.wBanimAction = nil;
	self.mBanimAction = nil;
	
	self.goPoints125 = nil;
    self.wP125animAction = nil;
	self.mP125animAction = nil;	
	
	//add schedulers
	[self unschedule:@selector(gameLogic:)];
	[self unschedule:@selector(gameLogic2:)];
	[self unschedule:@selector(nextFrameUpdateNow:)];
	[self unschedule:@selector(nextFrameUpdateNowMines:)];
	[self unschedule:@selector(gameOverSlowdown:)];
	[self unschedule:@selector(gameOverSlowdownSound:)];
	
	
	self.isTouchEnabled = NO;
	
	//add touch dispatch stuff:
	[self unschedule:@selector(ccTouchBegan:withEvent:)];
	[self unschedule:@selector(ccTouchEnded:withEvent:)];
	
	self.label = nil;					//score label
	//self.label_part2 = nil;		//score label
	
	//self.bottomlabel = nil;		//middle label
	//self.bottomlabel2 = nil;	//top label
	
	//self.label_BoomDisplay = nil;
	//self.label_FishScoreDisplay = nil;
	self.label_ShowLevelNumber = nil;
	
	self.labelar = nil;
	self.label_ShowHealthTag = nil;
	
	//_label_ShowHealthTag?
	//ie:
	//self.label_ShowHealthTag = nil;
	//[_label_ShowHealthTag release];
	//_label_ShowHealthTag = nil;
	
	
	[_targets release];
	[_mobs release];
	[_projectiles release];
	
	
	
	
	//[[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
	[[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
	[[CCTextureCache sharedTextureCache] removeAllTextures];	
	
	//[[CCTextureCache sharedTextureCache] removeAllTextures];	
	//[[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
	
	//[super dealloc];
}
//___________________________________________________________________________________________________

/*
//
//
//  _________      .__               .___    .__                       
// /   _____/ ____ |  |__   ____   __| _/_ __|  |   ___________  ______
// \_____  \_/ ___\|  |  \_/ __ \ / __ |  |  \  | _/ __ \_  __ \/  ___/
// /        \  \___|   Y  \  ___// /_/ |  |  /  |_\  ___/|  | \/\___ \ 
///_______  /\___  >___|  /\___  >____ |____/|____/\___  >__|  /____  >
//        \/     \/     \/     \/     \/               \/           \/ 
//
//
//
//
*/

// SPECIFY SCHEDULERS:
// GAME LOGIC: PART 1 of 2:  Mainly FISH, no MINES, no death checks
-(void)gameLogic:(ccTime)dt {
	// CURRENTLY SET TO ONCE A SECOND
	
	// need some practice rounds with a few fish and no mines. goal is to hit every fish. bonus if you do!



	//////show values  currentNumberofFish     
	//NSString *intConvShowCurrentFish = [NSString stringWithFormat:@" Current Fish Total: %i",currentNumberofFish];
	//[_bottomlabel setString:intConvShowCurrentFish];
		
	//[self addNonTargetPlant1];
	//	[self addNonTargetBubbles];
	
	//srand([[NSDate date] timeIntervalSince1970]);
	/*fishRandomNumber = 1 + rand()%10;*/
	//change to 10 for the new fish count:  1-10
	fishRandomNumber = 1 + rand()%10;
	fishRandomNumberof3 = 1 + rand()%3;

	
	
	//NEW METHOD STARTS:
	//first check modulus status,
	//if (intCurrentLevel % 10 == (0)) {
	if (intCurrentLevel % 2 == (0)) {
		//NSLog(@"Modulus 10! SurvivalMapNumber %i", SurvivalMapNumber);
		// this is a survival map.  which one? SurvivalMapNumber = 1 -3
		if (SurvivalMapNumber == 1) {
			// do first map with small only:
			//SurvivalMapNumber = SurvivalMapNumber + 1;
			// moved to EndMenu/Level.
			//backgroundImageLevel001 = [CCSprite spriteWithFile: @"riverbottom_1024_768.png"];
			[self addNonTargetBubbles];
			
		} else if (SurvivalMapNumber == 2) {
			// do 2nd
			//SurvivalMapNumber = SurvivalMapNumber + 1;
			//backgroundImageLevel001 = [CCSprite spriteWithFile: @"rockformations_1024_768.png"]; 
			[self addNonTargetBubbles];
			
			
		} else if (SurvivalMapNumber == 3) {
			// do 3rd:
			//backgroundImageLevel001 = [CCSprite spriteWithFile: @"seaweed_1024_768.png"];
			[self addNonTargetBubbles];
			
		} else {
			//undetected map number
			//NSLog(@"undetected survival map number");
			// do the default #1
			//SurvivalMapNumber = 1;
			[self addNonTargetBubbles];
			
		}
		
		// ok now advance:  //cant advance on everyframe. move moduls test to the top...
		//		SurvivalMapNumber = SurvivalMapNumber + 1;
		//		if (SurvivalMapNumber == 4) {
		//			SurvivalMapNumber = 1;
		//		}
		
	} else if ((intCurrentLevel % 2 != (0)) && (SurvivalMapNumber == 2)) {
		
		//if mod (2) = 0  and SURVNumber = 3 

		// BONUS level! no mines!
		//backgroundImageLevel001 = [CCSprite spriteWithFile: @"shining_1024_768.png"];
		
		intMinesEverHit = 1;
	
		[self addNonTargetBubbles];
		
		
		if (fishRandomNumber == 1) {
			[self addTarget];
			[self addTargetRedFish];
		} else if (fishRandomNumber == 2) {
			[self addTargetRedFish];
			[self addTargetBAWFish];
			[self addTargetPurpleFish];
		} else if (fishRandomNumber == 3) {
			[self addTargetBAWFish];
			[self addTargetBWYFish];
			[self addTargetSilverFish];
		} else if (fishRandomNumber == 4) {
			[self addTargetBWYFish];
			[self addTargetBYFish];
		} else if (fishRandomNumber == 5) {
			[self addTargetBYFish];
			[self addTargetSilverFish];
		} else if (fishRandomNumber == 6) {
			[self addTargetSilverFish];
			[self addTargetYellowFish];
			[self addTargetPurpleFish];
		} else if (fishRandomNumber == 7) {
			[self addTargetYellowFish];
			[self addTargetYellowOrangeFish];
			[self addTargetSilverFish];
		} else if (fishRandomNumber == 8) {
			[self addTargetYellowOrangeFish];
			[self addTargetYellowTwoFish];
			[self addTargetBWYFish];
		} else if (fishRandomNumber == 9) {
			[self addTargetYellowTwoFish];
			[self addTargetYellowTwoFish];
			[self addTargetBAWFish];
		} else if (fishRandomNumber == 10) {
			[self addTargetPurpleFish];
		} else {
			[self addTarget];
			[self addTargetPurpleFish];
		}
		
		
		
	} else {
		//standard level
		
		//backgroundImageLevel001 = [CCSprite spriteWithFile: @"tracedfinal_withfade2.png"];

		//[self addNonTargetPlant3];	   //plant. move to range check code.
		[self addNonTargetBubbles];
		
		if (fishRandomNumber == 1) {
			[self addTarget];
		} else if (fishRandomNumber == 2) {
			[self addTargetRedFish];
		} else if (fishRandomNumber == 3) {
			[self addTargetBAWFish];
		} else if (fishRandomNumber == 4) {
			[self addTargetBWYFish];
			[self addTargetmines903];
		} else if (fishRandomNumber == 5) {
			[self addTargetBYFish];
		} else if (fishRandomNumber == 6) {
			[self addTargetSilverFish];
		} else if (fishRandomNumber == 7) {
			[self addTargetYellowFish];
			[self addTargetmines903];
		} else if (fishRandomNumber == 8) {
			[self addTargetYellowOrangeFish];
		} else if (fishRandomNumber == 9) {
			[self addTargetYellowTwoFish];
		} else if (fishRandomNumber == 10) {
			[self addTargetmines903];
			[self addTargetPurpleFish];
		} else {
			[self addTarget];
		}
		
		
		
		
	}    //check if modulus.. ended.
	
	
	//	//then check content status,
	//	if ((intCurrentLevel >= 1) && (intCurrentLevel <= 19)) {
	//		// all other content is in gamelogic2.
	//		[self addNonTargetPlant3];	   //plant. move to range check code.
	//	}
	//	if (intCurrentLevel >= 100) {
	//		// all other content is in gamelogic2.
	//		[self addNonTargetPlant3];	   //plant. move to range check code.
	//	}
	
	
	//new:  ((intCurrentBGNum == 0) || (intCurrentBGNum == 5))
	if ((intCurrentBGNum == 0) || (intCurrentBGNum == 5)) {
		[self addNonTargetPlant3];
	}
	
	//NEW METHOD ENDS:
	
	
	//// end of zone.
	
	
	
	// TEST INDIVIDUALS:
	//[self addNonTargetPlant3];	//ok
	//[self addTargetmines903];	//ok
	
	//[self addTarget];				//ok
	//[self addTargetRedFish];     //ok
	//[self addTargetBAWFish];     //ok
	//[self addTargetBWYFish];     //ok
	//[self addTargetBYFish];      //ok
	//[self addTargetSilverFish];     //ok
	//[self addTargetYellowFish];     //ok
	//[self addTargetYellowOrangeFish];     //ok
	//[self addTargetYellowTwoFish];     //ok
	//[self addTargetPurpleFish];     //ok
	
	//[self addNonTargetBubbles];
	

}
// GAME LOGIC2:   PART 2 of 2   ADD MINES
-(void)gameLogic2:(ccTime)dt {
	// CURRENTLY SET TO ONCE A SECOND
	
		
	fishRandomNumber = 1 + rand()%10;
	fishRandomNumberof3 = 1 + rand()%3;
	fishRandomNumberof4 = 1 + rand()%4;
	
	////show values  currentNumberofFish     
	//NSString *intConvShowFR = [NSString stringWithFormat:@" Fish Random %i",fishRandomNumber];
	//[_bottomlabel2 setString:intConvShowFR];
	
	
	//[self addTargetRedFish];
	//[self addTargetmines903];
	//[self addNonTargetPlant3];
	
	//NEW:  Check if Survival first:  CONTENT is included, needs to be moved down into ranges.
	//if (intCurrentLevel % 10 == (0)) {
	if (intCurrentLevel % 2 == (0)) {	
		//NSLog(@"Modulus 10! SurvivalMapNumber %i", SurvivalMapNumber);
		// this is a survival map.  which one? SurvivalMapNumber = 1 -3
		if (SurvivalMapNumber == 1) {
			// do first map with small only:
			//SurvivalMapNumber = SurvivalMapNumber + 1;
			// moved to EndMenu/Level.
			//backgroundImageLevel001 = [CCSprite spriteWithFile: @"riverbottom_1024_768.png"];
			//[self addNonTargetBubbles];
			
			//special level modifier:
			maxNumberofFish = 30;
			
			//if (fishRandomNumberof3 != 1) {
				[self addTargetmines903];
			//}
			
			
		} else if (SurvivalMapNumber == 2) {
			// do 2nd
			//SurvivalMapNumber = SurvivalMapNumber + 1;
			//backgroundImageLevel001 = [CCSprite spriteWithFile: @"rockformations_1024_768.png"]; 
			//[self addNonTargetBubbles];
			
			//if (fishRandomNumberof3 != 3) {
				[self addTargetmines903];
			//}
			
			//special level modifier:
			maxNumberofFish = 28;
			
			miscCounter = miscCounter + 1;
			
			if (miscCounter == 3) {
				[self addTargetmines904];
				miscCounter = 0;
			} 
			
			
		
		} else if (SurvivalMapNumber == 3) {
			// do 3rd:
			//backgroundImageLevel001 = [CCSprite spriteWithFile: @"seaweed_1024_768.png"];
			//[self addNonTargetBubbles];
			
			//TESTING HERE:
			if (onePerLevelUsed == 0) {
				[self addNonTargetPlant12];
				onePerLevelUsed = 1;
			}
			
			// new way:
			if (fishRandomNumberof3 != 2) {
				[self addTargetmines905];
			}
			
			//[self addTargetmines905];
			
			//special level modifier:
			maxNumberofFish = 25;
			
		} else {
			//undetected map number
			//NSLog(@"undetected survival map number");
			// do the default #1
			//SurvivalMapNumber = 1;
			
			//[self addNonTargetBubbles];
			
			//special level modifier:
			maxNumberofFish = 24;
			
			if (fishRandomNumberof3 != 1) {
				[self addTargetmines903];
			}
			
		}
	} else if ((intCurrentLevel % 2 != (0)) && (SurvivalMapNumber == 2)) {
		// BONUS level! no mines!
		//backgroundImageLevel001 = [CCSprite spriteWithFile: @"shining_1024_768.png"];
		//[self addNonTargetBubbles];
		
		//special level modifier:
		maxNumberofFish = 99;
		
		if (fishRandomNumber == 10) {
			[self addTarget];
		} else if (fishRandomNumber == 9) {
			[self addTargetRedFish];
			//[self addTargetmines903];
		} else if (fishRandomNumber == 8) {
			[self addTargetBAWFish];
		} else if (fishRandomNumber == 7) {
			[self addTargetBWYFish];
			//[self addTargetmines903];
		} else if (fishRandomNumber == 6) {
			[self addTargetBYFish];
			[self addTargetBWYFish];
		} else if (fishRandomNumber == 5) {
			[self addTargetSilverFish];
			//[self addTargetmines903];
		} else if (fishRandomNumber == 4) {
			[self addTargetYellowFish];
			[self addTargetBWYFish];
		} else if (fishRandomNumber == 3) {
			//[self addTargetmines903];
			[self addTargetYellowOrangeFish];
			[self addTargetBWYFish];
		} else if (fishRandomNumber == 2) {
			[self addTargetYellowTwoFish];
		} else if (fishRandomNumber == 1) {
			//[self addTargetmines903];
			[self addTargetPurpleFish];
		} else {
			[self addTarget];
		}

		
		
	} else {
		//standard level
		
		//backgroundImageLevel001 = [CCSprite spriteWithFile: @"tracedfinal_withfade2.png"];
		//[self addNonTargetPlant3];	
		//[self addNonTargetBubbles];
		
		//NO ADDITIONAL PLANTS.  REEDS only
		
		if (fishRandomNumber == 1) {
			[self addTarget];
			[self addTargetmines903];
		} else if (fishRandomNumber == 2) {
			//[self addTargetRedFish];
			[self addTargetmines903];
		} else if (fishRandomNumber == 3) {
			[self addTargetBAWFish];
			[self addTargetmines903];
		} else if (fishRandomNumber == 4) {
			//[self addTargetBWYFish];
			[self addTargetmines903];
		} else if (fishRandomNumber == 5) {
			[self addTargetBYFish];
			[self addTargetmines903];
		} else if (fishRandomNumber == 6) {
			//[self addTargetSilverFish];
			[self addTargetmines903];
		} else if (fishRandomNumber == 7) {
			[self addTargetYellowFish];
			[self addTargetmines903];
		} else if (fishRandomNumber == 8) {
			[self addTargetmines903];
			//[self addTargetYellowOrangeFish];
		} else if (fishRandomNumber == 9) {
			[self addTargetYellowTwoFish];
			[self addTargetmines903];
		} else if (fishRandomNumber == 10) {
			[self addTargetmines903];
			[self addTargetPurpleFish];
		} else {
			[self addTarget];
			[self addTargetmines903];
		}
		

		
	}    //check if modulus.. ended.
	
	//end of NEW.
	
	//START OF NEW PLANTS:
	if ((intCurrentBGNum == 0) || (intCurrentBGNum == 5)) {
		[self addNonTargetBubbles];
		
		//test:
		//[self addNonTargetPlant14];
		
	} else if ((intCurrentBGNum == 1) || (intCurrentBGNum == 6)) {
		[self addNonTargetBubbles];
		
		//move to ranges. neverneeded for Survival check:
		// THIS IS RANGE 2, riverbottom:
		if (fishRandomNumberof4 == 1) {
			[self addNonTargetPlant4];	
		} else if (fishRandomNumberof4 == 2) {
			[self addNonTargetPlant5];	
		} else if (fishRandomNumberof4 == 3) {
			[self addNonTargetPlant3];	
		} else {
			[self addNonTargetPlant9];
		}
		//move to ranges ends.
		
	} else if ((intCurrentBGNum == 2) || (intCurrentBGNum == 7)) {
		[self addNonTargetBubbles];
		
		//move to ranges. neverneeded for Survival check:
		// THIS IS RANGE 3, Rock FORMATIONS
		if (fishRandomNumber == 1) {
			[self addNonTargetPlant7];	
		} else if (fishRandomNumber == 2) {
			[self addNonTargetPlant8];	
		} else if ((fishRandomNumber == 3) || (fishRandomNumber == 6)) {
			[self addNonTargetPlant9];	
		} else if ((fishRandomNumber == 4) || (fishRandomNumber == 7)){
			[self addNonTargetPlant6];
		} else {
			// do nothing
		}
		//end of move to ranges
		
	} else if ((intCurrentBGNum == 3) || (intCurrentBGNum == 8)) {
		[self addNonTargetBubbles];
		
		//move to ranges:
		// THIS IS RANGE 4, SEAWEED AREA
		if (fishRandomNumber == 1) {
			[self addNonTargetPlant10];	
		} else if (fishRandomNumber == 2) {
			[self addNonTargetPlant1];	
		} else if ((fishRandomNumber == 3) || (fishRandomNumber == 6)) {
			[self addNonTargetPlant11];	
		} else if ((fishRandomNumber == 4) || (fishRandomNumber == 7)) {
			[self addNonTargetPlant2];	
		} else {
			//[self addNonTargetPlant2];
		}
		
	} else if ((intCurrentBGNum == 4) || (intCurrentBGNum == 9)) {
		[self addNonTargetBubbles];
		
		//move to ranges:
		// THIS IS FOR FINAL RANGE 5, SHINING
		if (fishRandomNumber == 1) {
			[self addNonTargetPlant13];	
		} else if (fishRandomNumber == 2) {
			[self addNonTargetPlant14];	
		} else if (fishRandomNumber == 3) {
			[self addNonTargetPlant10];	
		} else if ((fishRandomNumber == 4) || (fishRandomNumber == 7)) {
			[self addNonTargetPlant1];
		} else {
			//[self addNonTargetPlant1];
		}
		
	} else  {
		[self addNonTargetBubbles];
		[self addNonTargetPlant3];
	}
	
	//END OF NEW PLANTS.
	
	
	

	//PREVIOUS METHOD REMOVED>  its now above as-is:
	//// new zone: level based requests:
	//FINAL ORDER (Update Ranges):

	//this is 6th.  champagne level
	//		if (onePerLevelUsed == 0) {
	//			[self addNonTargetPlant12];
	//			onePerLevelUsed = 1;
	//		}
	//		
	//		//6th level adds mostly bubbles:
	//		
	//		//backgroundImageLevel001 = [CCSprite spriteWithFile: @"tracedfinal_withfade2.png"];	
	//		[self addNonTargetBubbles];
	//		[self addNonTargetBubbles];
	//		[self addNonTargetBubbles];
	//		[self addNonTargetBubbles];
	//		[self addNonTargetBubbles];

	
	//// end of zone.
	

	//// end of schedulers.
	
}

/*
//
//
//   _____  .___ _______  ___________ _________
//  /     \ |   |\      \ \_   _____//   _____/
// /  \ /  \|   |/   |   \ |    __)_ \_____  \ 
///    Y    \   /    |    \|        \/        \
//\____|__  /___\____|__  /_______  /_______  /
//        \/            \/        \/        \/ 
//
//
*/ 


// ANIMATE COLLISION SCHEDULER:
- (void) nextFrameUpdateNowMines:(ccTime)dt {
	// CURRENTLY SET TO ONCE PER FRAME DISPLAYED
	
	//	healthBarScale
	//	globalPlayerHealth


	// need a new value to check against:  trying currentNumberofFish
	//if (globalPlayerHealth == 100) {
	if (currentNumberofFish == 0) {	
		showGameOverAlready = 0;
	}
	
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		// The device is an iPad running iPhone 3.2 or later.
		//greenhealthbar.scaleX = 5;
		healthBarScale = (globalPlayerHealth * 5)/100;
	} else {
		// 6
		healthBarScale = (globalPlayerHealth * 6)/100;

	}

	
	//TEST: LIVE: HACK  infinite health
	//globalPlayerHealth = 100;
	
	
	/*
	NSString *intConvShowCurrentFishRR = [NSString stringWithFormat:@" healthBarScale: %f",healthBarScale];
	[_bottomlabel2 setString:intConvShowCurrentFishRR];
	NSString *intConvShowCurrentFishZR = [NSString stringWithFormat:@" globalPlayerHealth: %f %f %f",globalPlayerHealth, globalPlayerHealth * 6, (globalPlayerHealth * 6)/100];
	[_bottomlabel setString:intConvShowCurrentFishZR];
	*/
	
	if (globalPlayerHealth >= 67) {
		//green
		greenhealthbar.scaleX = healthBarScale;
		redhealthbar.scaleX = 0;
		yellowhealthbar.scaleX = 0;
	} else {
		if (globalPlayerHealth >= 34) {
			//yellow
			yellowhealthbar.scaleX = healthBarScale;
			greenhealthbar.scaleX = 0;
			redhealthbar.scaleX = 0;
		} else {
			// red
			redhealthbar.scaleX = healthBarScale;
			yellowhealthbar.scaleX = 0;
			greenhealthbar.scaleX = 0;
		}

	}

	
	/*
	NSString *intConvShowCurrentFishRR = [NSString stringWithFormat:@" healthBarScale: %f",healthBarScale];
	[_bottomlabel2 setString:intConvShowCurrentFishRR];
	NSString *intConvShowCurrentFishZR = [NSString stringWithFormat:@" globalPlayerHealth: %f %f %f",globalPlayerHealth, globalPlayerHealth * 6, (globalPlayerHealth * 6)/100];
	[_bottomlabel setString:intConvShowCurrentFishZR];
	*/
	
	
	//greenhealthbar.scaleX = healthBarScale;
	// THE ABOVE LINE IS NOT GETTING RUN....
	
//	if ((healthBarScale <= 0) && (showGameOverAlready == 0)) {
//		//[[SimpleAudioEngine sharedEngine] playEffect:@"raviment_gameover_22mono.caf"];
//	}
	
	//THIS IS POPPING AT THE END OF EVERY NORMAL LEVEL FOR SOME REASON...
	//check that the level hasnt ended first....
	
	if (currentNumberofFish >= maxNumberofFish) {
		
		//the level is over... do nothing
		//this isnt working, just reset it.
		
	} else {
		//do this
		
		if ((healthBarScale <= 0) || (globalPlayerHealth <= 0)) {
			globalPlayerHealth = 0;
			//player is dead
			//schedule replaceScene GameOverMenu to take place in 3 seconds
			//schedule buttons to show after a short delay:
			
			//this always pops at the end of every level.
			//NSLog(@"you're dead. showGameOverAlready = %i", showGameOverAlready);
			
			
			
			if (showGameOverAlready == 0) {
				//[[SimpleAudioEngine sharedEngine] playEffect:@"dancegroove4_22mono.caf"];
				showGameOverAlready = 1;
				CGSize winSizeGO = [CCDirector sharedDirector].winSize;
				//self.bluefugu = [CCSprite spriteWithSpriteFrameName:@"bluefugu_med_1.png"];        
				/*_bluefugu.position = ccp(winSize.width/2, winSize.height/2);*/
				
				gameOverBar = [CCSprite spriteWithFile: @"gameOver.png"];
				gameOverBar.position = ccp( winSizeGO.width/2, winSizeGO.height/2 ); 
				gameOverBar.scaleX = 1;
				
				[self addChild:gameOverBar z:2000];			
				
				[self schedule:@selector(gameOverSlowdown:) interval:3.0];
				[self schedule:@selector(gameOverSlowdownSound:) interval:0.5];
				
				if ((globalPlayerHealth <= 0) && (alreadyPlayedTheSound == 0)) {
					alreadyPlayedTheSound = 1;
			
					if (intMusicOff == 0) {
						[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
						//[[SimpleAudioEngine sharedEngine] playEffect:@"raviment_gameover_22mono.caf"];

					}
					//[[SimpleAudioEngine sharedEngine] playEffect:@"raviment_gameover_22mono.caf"];
					
				}
				
				//				if (globalPlayerHealth <= 0) {
				//					[[SimpleAudioEngine sharedEngine] playEffect:@"raviment_gameover_22mono.caf"];
				//				}
				//fires everytime...
				//[[SimpleAudioEngine sharedEngine] playEffect:@"raviment_gameover_22mono.caf"];
				
				
				
			}
			
			//[self schedule:@selector(gameOverSlowdown:) interval:2.0];
			
			//play the GAME OVER TEXT now:
			//globalPlayerHealth = 0;
			//healthBarScale = 100;
			
			//show that you got the high score if you did on the next screen....
			
		} else {
			if (globalPlayerHealth >= 100) {
				globalPlayerHealth = 100;
			}
			
			// player is not dead yet!
			//update health bar?
			
		}
		
	}
	
	
	
	
	
	//		// size of the bar is scaleX 6 for 100, 3 for 50, etc.
	//  
	//  x     globalPlayerHealth   (0-100)
	// ___	= ___         
	// 
	//  6     100
	
	
	
	if (intHasShownFirstMine == 0) {
			
		
		//start of GoBoom
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"goBoom.plist"];        
		
		// Create a sprite sheet with the Happy goZoom images
		CCSpriteSheet *spriteSheet3 = [CCSpriteSheet spriteSheetWithFile:@"goBoom.png"];
		
		
		
		[self addChild:spriteSheet3  z:zLevelSprites];
		
		// Load up the frames of our animation
		NSMutableArray *walkAnimFrames3 = [NSMutableArray array];
		for(int i = 1; i <= 15; ++i) {
			[walkAnimFrames3 addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"EXPL%02d.png", i]]];
		}
		CCAnimation *walkAnim3 = [CCAnimation animationWithName:@"walk" delay:0.1f frames:walkAnimFrames3];
		
		// Create a sprite for our goZoom
		//CGSize winSize3 = [CCDirector sharedDirector].winSize;
		self.goBoom = [CCSprite spriteWithSpriteFrameName:@"EXPL01.png"];     //ZOOMGO1.png  epexted   
		_goBoom.position = ccp(-100, -100);
		//self.wBanimAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkAnim3 restoreOriginalFrame:NO]];
		self.wBanimAction = [CCAnimate actionWithAnimation:walkAnim3 restoreOriginalFrame:NO];
		
		zLevelSprites = zLevelSprites + 1;	
		
		[spriteSheet3 addChild:_goBoom z:zLevelSprites];
		
		[_goBoom runAction:_wBanimAction];   
		
		intHasShownFirstMine = 1;
	}
	
	
	
	
	
	
	
	
	/*
	//moved here:
	////show values  currentNumberofFish     
	NSString *intConvShowCurrentFish = [NSString stringWithFormat:@" Current Fish Total: %i",currentNumberofFish];
	[_bottomlabel setString:intConvShowCurrentFish];
	*/
	
		
	//CHECK FOR COLLISION:
	CGRect projectileRect2 = CGRectMake(
									   _bluefugu.position.x - (_bluefugu.contentSize.width/2), 
									   _bluefugu.position.y - (_bluefugu.contentSize.height/2), 
									   _bluefugu.contentSize.width - 5, 
									   _bluefugu.contentSize.height - 5);

	//we need a counter to track target/fish objects:
	int arrayCurrentMineCounter = 0;
	
	NSInteger count2 = 0;
	
	int switchMineWasHitMode = 0;
	
	//NSLog(@"each frame check: strMines: %@", strMines);
	//result: each frame check: strMines: NEWMUTABLE|2|5|8|11|12|20|21|22|
	
	//mines version:
	//NEW ARRAYS TO CHECK:
	//		_mobs = [[NSMutableArray alloc] init];
	//NSMutableArray *_mobs;
	//NSMutableString *strMines = nil;	
	// above the object in _mobs is called target....
	
	
	//loop thru fish and check for hit. deal with kicks.
	for (CCSprite *mob in _mobs) {
		
		
		//NSString *intMineCoords = [NSString stringWithFormat:@"%i",target.position.x];
		//		[_bottomlabel2 setString:intMineCoords];

		arrayCurrentMineCounter++;		
		
		//PREP THE NAME OF THE MINE TO SAVE FOR LATER:
		NSString *intConversionStringM1 = [NSString stringWithFormat:@"%i",arrayCurrentMineCounter];
		//NSString *intConversionString2 = [NSString stringWithFormat:@"btm_fishcounter1: %i",arrayCurrentFishCounter];
		 
		//[_label setString:intConversionString];   //playerScore
		//[_bottomlabel setString:intConversionString2];
		
		CGRect thisTargetRect2 = CGRectMake(
										   mob.position.x - (mob.contentSize.width/2), 
										   mob.position.y - (mob.contentSize.height/2), 
										   mob.contentSize.width - 25, 
										   mob.contentSize.height - 25);
		
		currentTargetX = mob.position.x;
		currentTargetY = mob.position.y;
		
		//reset for each mine:
		count2 = 0;
		switchMineWasHitMode = 0;
		
		//NSArray *arr = [str componentsSeparatedByString:@"|"];
		//NSMutableString *strMines = nil;
		NSArray *arrMines = [strMines componentsSeparatedByString:@"|"];
		
		//check mines for kick(hit) mode:   //move to mines array check...
		for(int q=0;q<[arrMines count];q++)
		{
						
			if([[arrMines objectAtIndex:q] isEqualToString:intConversionStringM1])
			{
				count2++;
			}
			//NSLog(@"each object check: strMines: %@ intConversionStringM1: %@ count2: %d", strMines, intConversionStringM1, count2);

		}
		if (count2 == 0) {
			// fish is not already there	do not concat to string yet first check beolow
			//NSString *newList = [myString stringByAppendingString:intConversionString];
			//fish is not already kicked, now check if fish was kicked beolow
			//NSLog(@"Mine hit for first time.");
		} else {
			// fish is in the list and bopped already:
			//switchFishIsInKickMode = 1;
			switchMineWasHitMode = 1;
			mob.position = ccp(-200, -200);  //centered
			//NSLog(@"Mine already hit.");
		}
		
		intConversionStringM1 = nil;
		//end of has bopped
		// this is the number of the current mine #: intConversionStringM1
		
		
		if ((CGRectIntersectsRect(projectileRect2, thisTargetRect2)) || (switchMineWasHitMode == 1))  // AND is not firing.
		//if ((CGRectIntersectsRect(projectileRect2, thisTargetRect2)) && (switchMineWasHitMode == 1))  // AND is not firing.
		//if (CGRectIntersectsRect(projectileRect2, thisTargetRect2)) 
		{	
			
			if ((CGRectIntersectsRect(projectileRect2, thisTargetRect2)) && (switchMineWasHitMode == 0)) {

				//NSLog(@"Mine Hit! count2=%d, arrayCurrentMineCounter=%d, strMines=%@, intConversionStringM1=%@, switchMineWasHitMode=%d", count2, arrayCurrentMineCounter, strMines, intConversionStringM1, switchMineWasHitMode);
				//NSLog(@"str = %@", str);
					
				intMinesEverHit = 1;
				
				//remove mine:
				mob.position = ccp(-200, -200);  //centered
				
				//if (intMusicOff == 0) {
				[[SimpleAudioEngine sharedEngine] playEffect:@"boomonly_22mono.caf"];
			
				//}
				
				// end of game...

				// mine blew up...
				//
				//			self.label_BoomDisplay = [CCLabel labelWithString:@"BOOM!" fontName:@"SF Comic Script" fontSize:50];
				//			//self.label_scoreLevelEndedTop = [CCLabel labelWithString:intConvShowScores fontName:@"SF Comic Script" fontSize:90];
				//			//self.label_scoreLevelEnded = [CCLabel labelWithString:@"SCORE:" fontName:@"SF Comic Script" fontSize:58];
				//			_label_BoomDisplay.color = ccc3(255,255,255);
				//			//_label.position = ccp(size.width/2, size.height/2);  //centered
				//			//_label.position = ccp(size.width/2, 750);  //centered
				//			//no jumping?
				//			//target.position.x
				//			//_label_BoomDisplay.position = ccp(target.position.x, target.position.y);  //centered
				//			//_label_BoomDisplay.position = ccp(300, 300);  //centered   currentTargetX
				//			_label_BoomDisplay.position = ccp(currentTargetX, currentTargetY);  //centered   currentTargetX
				//			
				//			
				//			//_label_scoreLevelEndedTop.position = ccp(size.width/2, 394);  //centered
				//			[self addChild:_label_BoomDisplay];
				
				// use this above in init to try to fix the lag when loading for first time:
				
				
				
//////fire this when the sound was to preload (preload graphic instead) must fire after any clearing:				
				//start of GoBoom
				[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"goBoom.plist"];        
				
				// Create a sprite sheet with the Happy goZoom images
				CCSpriteSheet *spriteSheet3 = [CCSpriteSheet spriteSheetWithFile:@"goBoom.png"];
				
					
					
				[self addChild:spriteSheet3  z:zLevelSprites];
				
				// Load up the frames of our animation
				NSMutableArray *walkAnimFrames3 = [NSMutableArray array];
				for(int i = 1; i <= 15; ++i) {
					[walkAnimFrames3 addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"EXPL%02d.png", i]]];
				}
				CCAnimation *walkAnim3 = [CCAnimation animationWithName:@"walk" delay:0.1f frames:walkAnimFrames3];
				
				// Create a sprite for our goZoom
				//CGSize winSize3 = [CCDirector sharedDirector].winSize;
				self.goBoom = [CCSprite spriteWithSpriteFrameName:@"EXPL01.png"];     //ZOOMGO1.png  epexted   
				_goBoom.position = ccp(currentTargetX, currentTargetY);
				//self.wBanimAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkAnim3 restoreOriginalFrame:NO]];
				self.wBanimAction = [CCAnimate actionWithAnimation:walkAnim3 restoreOriginalFrame:NO];
				
					zLevelSprites = zLevelSprites + 1;	
					
				[spriteSheet3 addChild:_goBoom z:zLevelSprites];
				
				[_goBoom runAction:_wBanimAction];   
				
				
				//id actionMoveDone = [CCCallFuncN actionWithTarget:self 
				//														 selector:@selector(spriteMoveFinished:)];
				
				//this cant be run if it doesnt exist:
				//[_goBoom release];
				
				//[spriteSheet3 runAction:[CCSequence actions:actionMoveDone, nil]];
				//this cant be run if it doesnt exist:
				//spriteSheet3 = nil;
				// end of goBoom
				
					
				
				
				zLevelSprites = zLevelSprites + 1;
	
				//add this mine # to the mobs array:
				
				NSString *intConversionStringM2 = [NSString stringWithFormat:@"%i",arrayCurrentMineCounter];
				//[_bottomlabel setString:intConversionString2];
		
				
				//ok we are now properly tracking which mine is bopped already... check the array, if its in there, its alreadyKicked:
				
				// only add it if its not there yet...
				if (switchMineWasHitMode == 0) {
					
					[strMines appendString:intConversionStringM2];
					[strMines appendString:@"|"];
					
					//NSMutableString *strMines = nil;
					
				}
				
				//CANT BE RELEASED EARLY. FIND WHEN TO RELEASE:
				//[intConversionStringM2 release];
				intConversionStringM2 = nil;
				
				//these is running to fast:
				//[spriteSheet3 runAction:[CCSequence actions:actionMoveDone, nil]];
				
				
				//NSLog(@"strMines.[%@]",strMines);	
				
				//[_bottomlabel2 setString:@"Game Over!"];
				//[target stopAllActions];
				
				//GAME IS OVER?
				// clear all strings
				
				// clear all arrays
				
				//[self unloadThisLevel];
				
				
				//MINE went off, apply damage and maybe schedule end of game:
				globalPlayerHealth = globalPlayerHealth - 20;
				
				//				if (globalPlayerHealth <= 0) {
				//					//player is dead
				//					//schedule replaceScene GameOverMenu to take place in 3 seconds
				//					//schedule buttons to show after a short delay:
				//					[self schedule:@selector(gameOverSlowdown:) interval:2.0];
				//					
				//					//play the GAME OVER TEXT now:
				//					globalPlayerHealth = 0;
				//					
				//					//show that you got the high score if you did on the next screen....
				//					
				//				} else {
				//					// player is not dead yet!
				//					//update health bar?
				//					
				//				}

				
				
				
			
			}    // if hit check 2
		}      // if hit check 1
	}         // for each object
		
	
	arrayCurrentMineCounter = 0;
	//reset
	
}
//________________________________________________________________End of Animated Collision scheduler nextFrameUpdateNowMines

/*
//
//
//								___________.___  _________ ___ ___  
//								\_   _____/|   |/   _____//   |   \ 
//								 |    __)  |   |\_____  \/    ~    \
//								 |     \   |   |/        \    Y    /
//								 \___  /   |___/_______  /\___|_  / 
//									 \/                \/       \/  
//
//
*/

// ANIMATE COLLISION SCHEDULER:  FISH VERSION
- (void) nextFrameUpdateNow:(ccTime)dt {
	// CURRENTLY SET TO ONCE PER FRAME DISPLAYED

	CGSize sizeScreenFish = [[CCDirector sharedDirector] winSize];
	
	progressBarScale = (currentNumberofFish * 16)/maxNumberofFish;
	
	//NSLog(@"progressBarScale: %f",progressBarScale);  // runs once, always zero.
	

	blueprogbar.scaleX = progressBarScale;
	


	//advance Score display:
	if (playerScore < currentPlayerScore)
	{
		// 1 is too slow counting:
		//playerScore = playerScore + 1;
		playerScore = playerScore + 5;
	}
	
	//reduce the size of the Score after it has been bounced:
	if (_labelar.scale > 1) {
		_labelar.scale = _labelar.scale - .02;
		
		scoreYvalue = scoreYvalue + 1;
		scoreXvalue = scoreXvalue + .5;
				
	}
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		// The device is an iPad running iPhone 3.2 or later.
		_labelar.position = ccp(500, 690);
		
	}
	else
	{
		//spread out image to fit the phone scale:
		_labelar.position = ccp(548, 690);
		
	}
	
	
  	//testing
	//NSString *intConversionString22 = [NSString stringWithFormat:@"X: %d",scoreYvalue];
	//NSString *intConversionString23 = [NSString stringWithFormat:@"Y: %d",scoreXvalue];
	//[_bottomlabel setString:intConversionString22];
	//[_bottomlabel2 setString:intConversionString23];
	
	
	
	NSString *intConvSpritePlayerScore = [NSString stringWithFormat:@"%06d",playerScore];
	//@"%05d "   
	[_labelar setString:intConvSpritePlayerScore];
	// SCORE IS NOW DISPLAYED.

	intConvSpritePlayerScore = nil;
		
	// moved to this check to every frame...
	if (currentNumberofFish >= maxNumberofFish) {
				
		
		
		// moved here due to complaints:		
		//one of these is causing problems on Next Level:  resetting the value after the level is over:
		//[[SimpleAudioEngine sharedEngine] playEffect:@"dancegroove4_22mono.caf"];
		
		currentNumberofFish = 0;
		maxNumberofFish = 75;
		//carry over any external ints to track if we got any bonuses!

		// MEMORY LEAK? do we need to release anything here??
		
		if ((healthBarScale == 0) || (globalPlayerHealth = 0)) {
			// cant go to next scene, you're dead.
			//noresponse:
			//[[SimpleAudioEngine sharedEngine] playEffect:@"raviment_gameover_22mono.caf"];
			
		} else {
			//
			if (intMusicOff == 0) {
				
				[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
				//[[SimpleAudioEngine sharedEngine] playEffect:@"dancegroove4_22mono.caf"];
			}
			[[SimpleAudioEngine sharedEngine] playEffect:@"dancegroove4_22mono.caf"];
			
			intHasShownFirstFish = 0;
			intHasShownFirstMine = 0;
			
			[[CCDirector sharedDirector] replaceScene: [Level001EndMenu sceneEndLevelMenu]];
			
			
			
			[self small_dealloc];
			
			
		}
		
		
	} else {
		
		// only check if you arent dead yet: globalPlayerHealth
		if (healthBarScale <= 0) {

			// do nothing
			
		} else {
			//  do normal process:
			
			
			
			
			
			if ((intHasShownFirstFish == 0) && (intHasShownFirstMine == 1)) {
			
				//moved above to preload anim:  moved back and to init...
				//start of goPoints125
				[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"goPoints125.plist"];        
				
				// Create a sprite sheet with the Happy goZoom images
				CCSpriteSheet *spriteSheet4 = [CCSpriteSheet spriteSheetWithFile:@"goPoints125.png"];
				
				[self addChild:spriteSheet4  z:zLevelSprites];
				
				
				
				// Load up the frames of our animation
				NSMutableArray *walkAnimFrames4 = [NSMutableArray array];
				for(int i = 1; i <= 21; ++i) {
					[walkAnimFrames4 addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"POIN%02d.png", i]]];
				}
				CCAnimation *walkAnim4 = [CCAnimation animationWithName:@"walk" delay:0.1f frames:walkAnimFrames4];
				
				// Create a sprite for our goPoints125
				//CGSize winSize3 = [CCDirector sharedDirector].winSize;
				self.goPoints125 = [CCSprite spriteWithSpriteFrameName:@"POIN01.png"];     //ZOOMGO1.png  epexted   
				_goPoints125.position = ccp(-100, -100);
				//self.wBanimAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkAnim3 restoreOriginalFrame:NO]];
				self.wBanimAction = [CCAnimate actionWithAnimation:walkAnim4 restoreOriginalFrame:NO];
				
				//increase z order for next explosion or points:
				zLevelSprites = zLevelSprites + 1;
				
				[spriteSheet4 addChild:_goPoints125 z:zLevelSprites];
				
				[_goPoints125 runAction:_wBanimAction];   
				// end of goPoints125

				intHasShownFirstFish = 1;
				//intHasShownFirstMine = 0;
			}
			
			
			
			
			
			
			
			
			//CHECK FOR COLLISION:
			CGRect projectileRect = CGRectMake(
											   _bluefugu.position.x - (_bluefugu.contentSize.width/2), 
											   _bluefugu.position.y - (_bluefugu.contentSize.height/2), 
											   _bluefugu.contentSize.width - 5, 
											   _bluefugu.contentSize.height - 5);
			
			
			
			//we need a counter to track target/fish objects:
			//int arrayKickedFishCounter = 0;
			int arrayCurrentFishCounter = 0;
			
			int underMaxFishCalc = 0;
			int underMaxFishCalc2 = 0;
			
			//NSString *str = @"Kicked|Fish|List|";  // moved to top
			//NSArray *arr = [str componentsSeparatedByString:@"|"]; // moved to below
			NSInteger count = 0;
			
			int switchFishIsInKickMode = 0;
			int switchFishIsOffScreenNow = 0;
			
			//TRACK FISH STARTS: 
			// concatenate value, value, then see if value exists (which means it was already kicked)
			
			//loop thru fish and check for hit. deal with kicks.
			for (CCSprite *target in _targets) {
				
				//FOR ALL FISH:  count each one off
				arrayCurrentFishCounter++;		
				
				//str on label 3
				//[_bottomlabel2 setString:str];
				
				//set number to a string:
				NSString *intConversionString = [NSString stringWithFormat:@"%i",arrayCurrentFishCounter];
				//NSString *intConversionString2 = [NSString stringWithFormat:@"btm_fishcounter1: %i",arrayCurrentFishCounter];
				
				//[_label setString:intConversionString];   //playerScore
				//[_bottomlabel setString:intConversionString2];
				
				CGRect thisTargetRect = CGRectMake(
												   target.position.x - (target.contentSize.width/2), 
												   target.position.y - (target.contentSize.height/2), 
												   target.contentSize.width, 
												   target.contentSize.height);
				
				
				//reset for each fish:
				count = 0;
				switchFishIsInKickMode = 0;
				switchFishIsOffScreenNow = 0;
				
				NSArray *arr = [str componentsSeparatedByString:@"|"];
				
				//check fish for kick mode:
				for(int i=0;i<[arr count];i++)
				{
					if([[arr objectAtIndex:i] isEqualToString:intConversionString])
						count++;
				}
				if (count == 0) {
					// fish is not already there	do not concat to string yet first check beolow
					//NSString *newList = [myString stringByAppendingString:intConversionString];
					//fish is not already kicked, now check if fish was kicked beolow
					
				} else {
					// fish is in the list and bopped already:
					switchFishIsInKickMode = 1;
					
				}
				
				//this is catching them ok, now to remove them..
				if (switchFishIsInKickMode == 1 && ((target.position.y >= (sizeScreenFish.height + 60)) || (target.position.y <= -60))) {
				//if (switchFishIsInKickMode == 1 && ((target.position.y >= 1000) || (target.position.y <= -20))) {
					//target.position.x - (target.contentSize.width/2)
					if (switchFishIsOffScreenNow == 1) {
						// do nothing, fish is already moved off
					} else {
						// do it:
						switchFishIsOffScreenNow = 1;
						[target stopAllActions];
						target.position = ccp( 1100, -61);  // offscreen
						target.rotation = 0;
					}

					
//					switchFishIsOffScreenNow = 1;
//					[target stopAllActions];
//					target.position = ccp( 1100, -61);  // offscreen
//					target.rotation = 0;
					//NSLog(@"fish is offscreen");
					
					
				}
				
				
				
				
				if (switchFishIsOffScreenNow == 1) {
						// do nothing, fish is already moved off
				} else {

					intConversionString = nil;
					
					//end of has bopped
					
					// 2 gates needed to check kick mode:
					// first:  is fish colliding right now or in kick mode?
					
					if ((CGRectIntersectsRect(projectileRect, thisTargetRect)) || (switchFishIsInKickMode == 1)) {
						
						// second: pre-kicked fish are already dealt with. is this fish colliding and NotKicked?
						
						//if so, it's a scored point!
						if ((CGRectIntersectsRect(projectileRect, thisTargetRect)) && (switchFishIsInKickMode == 0)) {
							
							// SCORE **********************************************************
							//playerScore = playerScore + 125;
							//currentPlayerScore

							//if (intMusicOff == 0) {
								
							[[SimpleAudioEngine sharedEngine] playEffect:@"fishbop_22mono.caf"];
							//}
								
							//[[SimpleAudioEngine sharedEngine] playEffect:@"dancegroove4_22mono.caf"];
							//gameoversound.caf
							//[[SimpleAudioEngine sharedEngine] playEffect:@"gameoversound.caf"];
							
							currentPlayerScore = currentPlayerScore + 125;
							
							//bounce the numbers:
							_labelar.scale = 1.25;
							//_labelar.position = ccp(500, 690);
							
							if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
							{
								// The device is an iPad running iPhone 3.2 or later.
								_labelar.position = ccp(500, 690);
								
							}
							else
							{
								//spread out image to fit the phone scale:
								_labelar.position = ccp(548, 690);
								
							}
							
							
							scoreYvalue = 500;
							scoreXvalue = 690;
							
							//show score over hit fish:
							
							currentTargetX = target.position.x;
							currentTargetY = target.position.y;
							
							if (globalPlayerHealth <= 2) {
								//cant add anymore health, you're dead already
								
							} else {
								//
								if (globalPlayerHealth >= 100) {
									globalPlayerHealth = 100;
									
								} else {
									//added health disabled:
									globalPlayerHealth = globalPlayerHealth + 2;
									if (globalPlayerHealth >= 100) {
										globalPlayerHealth = 100;
									}							
								}
								
							}
							
							
							//					//show score over hit fish:
							//					self.label_FishScoreDisplay = [CCLabel labelWithString:@"125" fontName:@"SF Comic Script" fontSize:60];
							//					//self.label_scoreLevelEndedTop = [CCLabel labelWithString:intConvShowScores fontName:@"SF Comic Script" fontSize:90];
							//					//self.label_scoreLevelEnded = [CCLabel labelWithString:@"SCORE:" fontName:@"SF Comic Script" fontSize:58];
							//					_label_FishScoreDisplay.color = ccc3(255,255,255);
							//					//_label.position = ccp(size.width/2, size.height/2);  //centered
							//					//_label.position = ccp(size.width/2, 750);  //centered
							//					//no jumping?
							//					//target.position.x
							//					//_label_BoomDisplay.position = ccp(target.position.x, target.position.y);  //centered
							//					//_label_BoomDisplay.position = ccp(300, 300);  //centered   currentTargetX
							//					_label_FishScoreDisplay.position = ccp(currentTargetX, currentTargetY);  //centered   currentTargetX
							//					
							//					
							//					//_label_scoreLevelEndedTop.position = ccp(size.width/2, 394);  //centered
							//					[self addChild:_label_FishScoreDisplay];
							
			
///// move to preload:							
							
							//moved above to preload anim:  moved back and to init...
							//start of goPoints125
							[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"goPoints125.plist"];        
							
							// Create a sprite sheet with the Happy goZoom images
							CCSpriteSheet *spriteSheet4 = [CCSpriteSheet spriteSheetWithFile:@"goPoints125.png"];
							
							[self addChild:spriteSheet4  z:zLevelSprites];
							
							
							
							// Load up the frames of our animation
							NSMutableArray *walkAnimFrames4 = [NSMutableArray array];
							for(int i = 1; i <= 21; ++i) {
								[walkAnimFrames4 addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"POIN%02d.png", i]]];
							}
							CCAnimation *walkAnim4 = [CCAnimation animationWithName:@"walk" delay:0.1f frames:walkAnimFrames4];
							
							// Create a sprite for our goPoints125
							//CGSize winSize3 = [CCDirector sharedDirector].winSize;
							self.goPoints125 = [CCSprite spriteWithSpriteFrameName:@"POIN01.png"];     //ZOOMGO1.png  epexted   
							_goPoints125.position = ccp(currentTargetX, currentTargetY);
							//self.wBanimAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkAnim3 restoreOriginalFrame:NO]];
							self.wBanimAction = [CCAnimate actionWithAnimation:walkAnim4 restoreOriginalFrame:NO];
							
							//increase z order for next explosion or points:
							zLevelSprites = zLevelSprites + 1;
							
							[spriteSheet4 addChild:_goPoints125 z:zLevelSprites];
							
							[_goPoints125 runAction:_wBanimAction];   
							// end of goPoints125
							
							zLevelSprites = zLevelSprites + 1;
							
							//this cant be run if it doesnt exist:
							//[_goPoints125 release];
							
							//this cant be run if it doesnt exist:
							//spriteSheet4 = nil;
							
							
							
							//NSString *intScoreString = [NSString stringWithFormat:@"Score: %i",localPlayerScore];
							//NSString *intScoreString = [NSString stringWithFormat:@"%i",playerScore];
							//NSString *intScoreString = [NSString stringWithFormat:@"%05d ",playerScore];
							
							//[_label setString:@"Score "];   //score label
							
							//DISABLED WHEN USING SPRITE NUMBERS:
							//[_label_part2 setString:intScoreString];   //score numbers
							
						}
						
						// get fish ID:
						NSString *intConversionString2 = [NSString stringWithFormat:@"%i",arrayCurrentFishCounter];
						//[_bottomlabel setString:intConversionString2];
						
						//[_projectiles addObject:[NSString numberWithInt:intConversionString2]];
						[_projectiles addObject:intConversionString2];
						
						
						
						//ok we are now properly tracking which fish is bopped already... check the array, if its in there, its alreadyKicked:
						
						// only add it if its not there yet...
						if (switchFishIsInKickMode == 0) {
							
							[str appendString:intConversionString2];
							[str appendString:@"|"];
							
							//NSMutableString *strMines = nil;
							
						}
						
						
						[target stopAllActions];
						
						
						//do not do if done with:
						if (switchFishIsOffScreenNow == 1) {
							// do nothing
						} else {
							//do this
							// start fishing spinning animation:
							
							double myDoubleL1 = [intConversionString2 doubleValue];
							int myIntL1 = (int)(myDoubleL1 + (myDoubleL1>0 ? 0.5 : -0.5));
							
							intConversionString2 = nil;
							
							rotationAmount++;
							//get random  int r = arc4random() % 74;
							//int r2 = arc4random() % 2;
							int r2 = 1;
							
							//fixing randoms... arraycurrentfishcounter is getting to high.
							//underMaxFishCalc = arrayCurrentFishCounter;
							//underMaxFishCalc2 = arrayCurrentFishCounter;
							underMaxFishCalc = myIntL1;
							underMaxFishCalc2 = myIntL1;
							
							
							while (underMaxFishCalc >= 40) {
								underMaxFishCalc = underMaxFishCalc/2;
							}
							
							while (underMaxFishCalc2 >= 30) {
								underMaxFishCalc2 = underMaxFishCalc2/2;
							}
							
							
							
							//rotationAmount = rotationAmount + r2;
							rotationAmount = rotationAmount + underMaxFishCalc2/10;
							
							if (rotationAmount >= 360) {
								rotationAmount = 0;
							}
							target.rotation = rotationAmount;
							
							//target.rotation = 30;
							
							
							
							if ((underMaxFishCalc % 2) == 0) {
								r2 = 2;	
							} else {
								r2 = 1;
							}
							
							
							
							if (r2 == 1) {
								//target.position = ccp( target.position.x + oneLifeRx, target.position.y - oneLifeRy);
								//target.position = ccp( target.position.x + 3, target.position.y - 3);
								//target.position = ccp( target.position.x + arrayCurrentFishCounter, target.position.y - arrayCurrentFishCounter);
								target.position = ccp( target.position.x + underMaxFishCalc2, target.position.y - underMaxFishCalc);
								
							} else {
								//target.position = ccp( target.position.x + oneLifeRx, target.position.y + oneLifeRy);
								target.position = ccp( target.position.x + underMaxFishCalc2, target.position.y + underMaxFishCalc);
								
							}
							
						}

						
						
						
						
					}




				}
				
				
				
				
			}
			
			// end of target Check for fish. 
			
			arrayCurrentFishCounter = 0;
			
			
		}
		
		
	}
	
}
//________________________________________________________________End of Animated Collision scheduler nextFrameUpdateNow


// GAME LOGIC:
-(void)gameOverSlowdown:(ccTime)dt {
	// CURRENTLY SET TO 2 SECOND
	
	if (globalPlayerHealth <= 0) {
		//alreadyPlayedTheSound = 1
		if (alreadyPlayedTheSound == 1) {
			// still needs this:
			//[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
			//[[SimpleAudioEngine sharedEngine] playEffect:@"raviment_gameover_22mono.caf"];
			// do nothing 
		} else {
			//
			//[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
			//[[SimpleAudioEngine sharedEngine] playEffect:@"raviment_gameover_22mono.caf"];
		}
	}
	
	//	extern float globalPlayerHealth;
	//	extern float healthBarScale;
	//NSLog(@"end of level slowdown started: gloHealth: %f healthbar: %f", globalPlayerHealth, healthBarScale);
	
	
	//TEST: LIVE:  resets health for new level:
	//healthBarScale = 6;
	globalPlayerHealth = 100;
	
	//exitGameAlready = 1;
	progressBarScale = 0;
	currentNumberofFish = 0;
	
	showGameOverAlready = 0;
	
	
	[[CCDirector sharedDirector] replaceScene: [Level001GameOverEndMenu sceneGameOver]];
		
	[self small_dealloc];
	
	
	
	
}

// GAME LOGIC:
-(void)gameOverSlowdownSound:(ccTime)dt {
	// CURRENTLY SET TO 2 SECOND
	
	//if ((globalPlayerHealth <= 0) && (alreadyPlayedTheSound == 0)) {
//		alreadyPlayedTheSound = 1;
//		[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
//		[[SimpleAudioEngine sharedEngine] playEffect:@"raviment_gameover_22mono.caf"];
//	}
	
}

//unload game level data except for score and go to end level screen:

-(void)unloadThisLevel {
	

	// max fish or you died:
	
	
}

//end of unload game level



@end
