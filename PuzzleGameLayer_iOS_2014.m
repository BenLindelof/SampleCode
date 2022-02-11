//
//  GameLayer.m
//  FruitBunch
//
//  Created by FruitBunch on 11/20/12.

//cocos2d v: v1.1.0-RC0

// CLEAN BUILD VERSION.________________________________________________________________
//1. Use temp placeholder anims of fading boxes for now so we can size on the fly.
//2. comment out intPostCollisionMode and replace row tracking.
//3. set up debug display in game.  track xy's for boxes.`
//4. add music and menus. hires placeholders animated. 
//5. setup positions only hires placeholders animated.
//6. test in ios6 ipod and ios8 ipad for alert styles.


// Import the interfaces
#import "GameLayer.h"
#import "CreditsLayer.h"
#import "SimpleAudioEngine.h"

#import "AlertPrompt.h"

//INTS: set screen dims, control locs, first block loc, board loc

extern float intScreenWidth;
extern float intScreenHeight;
extern float intScreenMidX;
extern float intScreenMidY;
extern int intGamePausedforOrient;
extern int intGamePausedbyPlayer;
extern int intInLandscape;

extern int intLeavingGameInLandscape;
extern float intWideMode;

extern float intFieldBGTop_Device;
extern float intFieldBGLeft_Device;
extern float intButtonsTop_Device;
extern float intButtonsLeft_Device;
extern float intMenuPauseTop_Device;
extern float intMenuPauseLeft_Device;
extern float intMenuSwitchTop_Device;
extern float intMenuSwitchLeft_Device;

extern float intFieldBGTop_DeviceLand;
extern float intFieldBGLeft_DeviceLand;
extern float intButtonsTop_DeviceLand;
extern float intButtonsLeft_DeviceLand;
extern float intMenuPauseTop_DeviceLand;
extern float intMenuPauseLeft_DeviceLand;
extern float intMenuSwitchTop_DeviceLand;
extern float intMenuSwitchLeft_DeviceLand;

extern float intFirstBoxLocX;
extern float intFirstBoxLocY;
extern float intFirstBoxLocLandX;
extern float intFirstBoxLocLandY;

extern int intBoxXposition;
extern int intBoxYposition;

extern int intDownHeldDown;
extern int intLeftHeldDown;
extern int intRightHeldDown;

extern int intIs4InchScreen;

extern int intSupposedToBeInPortorLand;


// globals:  //extend thru extern:
extern long int inttypeOfHD;    //none (low), 1 iphone (hd), 2 ipad (hd), 3 ipad ret (ultra hd)


extern int intSwitchStatus; //switch controls now or later.
extern long int intSlidingLeftRightMeter; // hit, puase the go..
extern long int intLeftorRightSide;  //defaults to left side, but load saved var.
extern long int intSizeofPieceWithoutAA;  // double for HD, Quad for UHD.


// piece movement and orient tracking:

float intActualFieldBGHeight = 0; //fieldbg.contentSize.height replacement

int intPieceScalar = 0;

int intGameHasStartedSentinel = 0;

int intCurrentPieceIsSet = 0;
int intNextPieceIsSet = 0;

int intCurrentPieceInt = 0; //for id'ing piece.

int intCurrentGridIsSet = 0;

int intCurrentPieceIsMoving = 0;

float intDropTimeLength = 20.5;     //20.5.... 40.5
float intDropTimeElapsed = 0;
float intDropTimeRemaining = 0;

NSDate *dateTimeStartedDrop;
NSDate *dateTimeCurrent;
NSTimeInterval dateTimeDropDuration;

int intInstantiatedWidth = 0;
int intInstantiatedChecked = 0;

float intTotalDistanceCalc = 0;
float intPieceTopPosition = 0;

float intBoxTopPosition = 0;
float intBoxBottomPosition = 0;
float intDistanceTraveled = 0;
float intDistanceToGo = 0;

float intRealDistanceTraveled = 0; //same for all devices.
float intRealDistanceToGo = 0; //same for all devices.

float intRealDerivedDistStartingPosition = 9999;
float intRealDerivedDistEndPosition = 0;
float intRealDerivedDistanceTraveled = 0; //same for all devices.
float intRealDerivedDistanceToGo = 0; //same for all devices.

float intRandomUno = 0;
float intRandomDos = 0;
float intRandomTres = 0;

int integerCurrentRowforPiece = 0;
float intCurrentRowforPiece = 0;
int intRowIDd = 0;
int intPrevRowID = 0;

float intPieceTopStartingPosition = 9999;
float intPieceTopStartingPosDist = 0;

int intCheckSavedCell = 0;
int intCheckUpcomCell = 0;
int intCheckIncomCell = 0;

int intCombineSavedandUpcoming = 0;

int intPrevColID = 0;
int intColIDd = 0;

int intRotOrLR = 0;
int intRotate_isClear = 0;
int intSlideLeft_isClear = 0;
int intSlideRight_isClear = 0;

int intPlayerCanMove = 0;
int intPostCollisionMode = 0;

int intPieceTypeSelected = 0;

int intOKtoGoLeft = 0;
int intOKtoGoRight = 0;

int intSavedPieceVal = 0;
int intFoundPieceVal = 0;

int intPiece1RotVerDrop = 0;
int intPiece2RotVerDrop = 0;
int intPiece3RotVerDrop = 0;
int intPiece4RotVerDrop = 0;
int intPiece5RotVerDrop = 0;
int intPiece6RotVerDrop = 0;
int intPiece7RotVerDrop = 0;
int intPiece8RotVerDrop = 0;
int intPiece9RotVerDrop = 0;

int intPiece1of9Drop = 0;
int intPiece2of9Drop = 0;
int intPiece3of9Drop = 0;
int intPiece4of9Drop = 0;
int intPiece5of9Drop = 0;
int intPiece6of9Drop = 0;
int intPiece7of9Drop = 0;
int intPiece8of9Drop = 0;
int intPiece9of9Drop = 0;
int intColtoCheck = 0;
int intRowtoCheck = 0;
int intCelltoCheck = 0;
int intDropScantoCheck = 0;

int intGravityNewRowHit = 0;

int intReturnSavedArrayValue = 0;

int intValueofSavedCell = 0;

int intFlashCounter = 0;

int intOriginalValuetoCheck = 0;

int intPiece1of9ReDrop = 0;
int intPiece2of9ReDrop = 0;
int intPiece3of9ReDrop = 0;
int intPiece4of9ReDrop = 0;
int intPiece5of9ReDrop = 0;
int intPiece6of9ReDrop = 0;
int intPiece7of9ReDrop = 0;
int intPiece8of9ReDrop = 0;
int intPiece9of9ReDrop = 0;

int intPiece1of9CheckForRowBuster = 0;
int intPiece2of9CheckForRowBuster = 0;
int intPiece3of9CheckForRowBuster = 0;

int intStoppedAlready = 0;

int intPieceTypeCounter = 0;

int intPieceTypeIdentified = 0;

int intPiece1TypeCounter = 0;
int intPiece2TypeCounter = 0;
int intPiece3TypeCounter = 0;
int intPiece4TypeCounter = 0;
int intPiece5TypeCounter = 0;
int intPiece6TypeCounter = 0;
int intPiece7TypeCounter = 0;
int intPiece8TypeCounter = 0;
int intPiece9TypeCounter = 0;
int intAdd10ToCurrent = 0;

int intToUseFromPopper = 0;

int intPopperScansCompleted = 0;

int intPopFX1 = 0;

int intPopDownBtn = 0;
int intPopDownBtnJustPopped = 0;


//NSTimeInterval duration = [end timeIntervalSinceDate:start];
//NSDate *dateTimeStartedDrop = [NSDate date];



//23x23 sprites with 1/2/4 pixel sides/t/b overlap.  21x21 for trace fill
//
//9 by 15:  23px iphone    46  hd,   92   ultra hd,
//0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0
//
//5 or 6 reds on bottom pre-filled OK. use 1 or more to pop em all.
//these squares are marked premades so they dont pop during pop  check


#define GROUND_SCALE 2
#define DRAW_WIDTH 6.5f
#define MINERS_COUNT 20
//#define SHOW_DRAWN_GROUND_STRIPES
//#define WIDTH 20

//ui
CCSprite *miner;
CCSprite *fieldbg;
CCSprite *fieldbgDisp;

//game:
CCSprite *tempBox;

CCSprite *Box1a;
CCSprite *Box2a;
CCSprite *Box3a;
CCSprite *Box4a;
CCSprite *Box5a;
CCSprite *Box6a;
CCSprite *Box7a;
CCSprite *Box8a;
CCSprite *Box9a;


//current and previous piece parts:
CCSprite *currentP1;
CCSprite *currentP2;
CCSprite *currentP3;
CCSprite *currentP4;
CCSprite *currentP5;
CCSprite *currentP6;
CCSprite *currentP7;
CCSprite *currentP8;
CCSprite *currentP9;

CCSprite *currentN1;
CCSprite *currentN2;
CCSprite *currentN3;
CCSprite *currentN4;
CCSprite *currentN5;
CCSprite *currentN6;
CCSprite *currentN7;
CCSprite *currentN8;
CCSprite *currentN9;



//STRINGS:

//CCAnimation *animFruitBoom;

CCSpriteFrameCache *frameCacheMain;
CCSpriteFrame *spriteFrameMain;

NSMutableArray *animationFramesMain = nil;   //=12

NSMutableArray *animationFramesBoom1 = nil;   //=5

NSMutableString *strCurrentBlankDefaultPiece = nil;
NSMutableString *strCurrentTestPiece = nil;
NSMutableString *strDeviceSpriteFilename = nil;

//i think we need string names for pieces.... by device.

//spritename:     note: strPieceType01 below is strutures array
NSMutableString *strPieceName001 = nil;
NSMutableString *strPieceName002 = nil;
NSMutableString *strPieceName003 = nil;
NSMutableString *strPieceName004 = nil;
NSMutableString *strPieceName005 = nil;
NSMutableString *strPieceName006 = nil;
NSMutableString *strPieceName007 = nil;
NSMutableString *strPieceName008 = nil;
NSMutableString *strPieceName009 = nil;
NSMutableString *strPieceName010 = nil;
NSMutableString *strPieceName011 = nil;
NSMutableString *strPieceName012 = nil;
//need the rest...
NSMutableString *strPieceName013 = nil;
NSMutableString *strPieceName014 = nil;
NSMutableString *strPieceName015 = nil;
NSMutableString *strPieceName016 = nil;
NSMutableString *strPieceName017 = nil;
NSMutableString *strPieceName018 = nil;
NSMutableString *strPieceName019 = nil;
NSMutableString *strPieceName020 = nil;
NSMutableString *strPieceName021 = nil;
NSMutableString *strPieceName022 = nil;
NSMutableString *strPieceName023 = nil;
NSMutableString *strPieceName024 = nil;
NSMutableString *strPieceName025 = nil;


NSMutableString *strRandomPieceName1 = nil;
NSMutableString *strRandomPieceName2 = nil;
NSMutableString *strRandomPieceName3 = nil;

NSMutableString *strTopButtonFileNormal = nil;
NSMutableString *strTopButtonFileSelect = nil;
NSMutableString *strTopButtonFileDisable = nil;
NSMutableString *strBottomButtonFileNormal = nil;
NSMutableString *strBottomButtonFileSelect = nil;
NSMutableString *strBottomButtonFileDisable = nil;
NSMutableString *strLeftButtonFileNormal = nil;
NSMutableString *strLeftButtonFileSelect = nil;
NSMutableString *strLeftButtonFileDisable = nil;
NSMutableString *strRightButtonFileNormal = nil;
NSMutableString *strRightButtonFileSelect = nil;
NSMutableString *strRightButtonFileDisable = nil;
NSMutableString *strSwitchFileNormal = nil;
NSMutableString *strSwitchFileSelect = nil;
NSMutableString *strSwitchFileDisable = nil;
NSMutableString *strPauseFileNormal = nil;
NSMutableString *strPauseFileSelect = nil;
NSMutableString *strPauseFileDisable = nil;




NSMutableString *strSavedGameData = nil;
NSMutableString *strSavedAudioData = nil;

NSMutableString *strIncomPiecesGrid = nil;
NSMutableString *strIncomPiecesPiece1 = nil;
NSMutableString *strIncomPiecesPiece2 = nil;
NSMutableString *strIncomPiecesPiece3 = nil;

// Prev board and piece tracker, but lots still used for motion tied to orient.
// see below for new column and piece trackers.

NSMutableString *strSavedBoardPieces = nil;    //current grid data
NSMutableString *strIncomBoardPieces = nil;    //incoming grid data
NSMutableString *strUpcomBoardPieces = nil;    //upcoming grid data

NSMutableString *strNewBoard = nil;
NSMutableArray *strREPLNewBoard = nil;
NSMutableArray *strREPLNewBoardRow = nil;

NSMutableString *strFinalBoardPieces = nil;

NSMutableString *strRotLRBoardPieces = nil;    //check fresh rot/lr for space...

NSMutableString *strIncomBoardPiecesTopBuffer = nil;
NSMutableString *strIncomBoardPiecesMidBuffer = nil;
NSMutableString *strIncomBoardPiecesBottomBuffer = nil;

NSMutableString *strREPLBoardPiecesTopBuffer = nil;
NSMutableString *strREPLBoardPiecesBottomBuffer = nil;

NSMutableString *strREPLBoardPiecesNewBuffer = nil;

NSMutableString *strSLIDEboardTopBuffer = nil;
NSMutableString *strSLIDEboardBottomBuffer = nil;
NSMutableString *strSLIDEboardPiecesNewBuffer = nil;

NSMutableString *strIncomBufferToSwitch = nil;

NSMutableString *strBuildBoardPieces = nil;    //build grid data oncoll

NSMutableString *strCurrentPieceMatchList = nil;
NSMutableArray *strRCVDBuild = nil;
NSMutableArray *strRCVDBuildRow = nil;

NSMutableString *strPopperConcatList = nil;



NSMutableArray *strActiveBoxiTags = nil;
NSMutableString *strActiveBoxiTagList = nil;

//redroptags:
NSMutableArray *strReDropBoxiTags = nil;
NSMutableString *strReDropBoxiTagList = nil;


NSMutableArray *strRCVDArray000 = nil;
NSMutableString *strInsertableBlank = nil;

NSMutableArray *strRCVDArraySaved = nil;
NSMutableArray *strRCVDArrayUpcom = nil;
NSMutableArray *strRCVDArrayIncom = nil;

NSMutableArray *strRCVDArraySavedRow = nil;
NSMutableArray *strRCVDArrayUpcomRow = nil;
NSMutableArray *strRCVDArrayIncomRow = nil;

NSMutableArray *strRCVDArrayRotator = nil;
NSMutableArray *strRCVDArrayRotatorRow1 = nil;
NSMutableArray *strRCVDArrayRotatorRow2 = nil;
NSMutableArray *strRCVDArrayRotatorRow3 = nil;

NSMutableString *strRotatedPiece = nil;

NSMutableArray *strRCVDUseRotate = nil;
NSMutableArray *strRCVDUseRotateRow1 = nil;
NSMutableArray *strRCVDUseRotateRow2 = nil;
NSMutableArray *strRCVDUseRotateRow3 = nil;

NSMutableArray *strRCVDPieceScan = nil;
NSMutableArray *strRCVDPieceScanRow1 = nil;
NSMutableArray *strRCVDPieceScanRow2 = nil;
NSMutableArray *strRCVDPieceScanRow3 = nil;

NSMutableArray *strRCVDDropScan = nil;
NSMutableArray *strRCVDDropScanRow1 = nil;
NSMutableArray *strRCVDDropScanRow2 = nil;
NSMutableArray *strRCVDDropScanRow3 = nil;


NSMutableString *strSavedBoardAttrib = nil;

NSMutableArray *strPopperCheckCols = nil;
NSMutableArray *strPopperCheckColCells = nil;


NSMutableString *strHighScoreName01 = nil;
NSMutableString *strHighScoreName02 = nil;
NSMutableString *strHighScoreName03 = nil;
NSMutableString *strHighScoreName04 = nil;
NSMutableString *strHighScoreName05 = nil;
NSMutableString *strHighScoreName06 = nil;
NSMutableString *strHighScoreName07 = nil;
NSMutableString *strHighScoreName08 = nil;
NSMutableString *strHighScoreName09 = nil;
NSMutableString *strHighScoreName10 = nil;

NSMutableString *strHighScore01 = nil;
NSMutableString *strHighScore02 = nil;
NSMutableString *strHighScore03 = nil;
NSMutableString *strHighScore04 = nil;
NSMutableString *strHighScore05 = nil;
NSMutableString *strHighScore06 = nil;
NSMutableString *strHighScore07 = nil;
NSMutableString *strHighScore08 = nil;
NSMutableString *strHighScore09 = nil;
NSMutableString *strHighScore10 = nil;

NSMutableString *strNameCols = nil;
NSMutableString *strPointsCols = nil;

NSMutableString *selectedFontToShow = nil;

NSMutableString *strNotifierTextToShow = nil;
NSMutableString *strLevelTextToShow = nil;

NSMutableString *strCreditsList = nil;

//currentplayer:
NSMutableString *strCurrentPlayerName = nil;




NSMutableString *strCurrentPlayPiece = nil;
NSMutableString *strNext01PlayPiece = nil;
NSMutableString *strNext02PlayPiece = nil;


NSMutableString *strPieceType01 = nil;
NSMutableString *strPieceType02 = nil;
NSMutableString *strPieceType03 = nil;
NSMutableString *strPieceType04 = nil;
NSMutableString *strPieceType05 = nil;
NSMutableString *strPieceType06 = nil;
NSMutableString *strPieceType07 = nil;
NSMutableString *strPieceType08 = nil;
NSMutableString *strPieceType09 = nil;

//intCurrentPieceInt
NSMutableString *strCurrentPieceStr = nil;




//new high score:  ALWAYS FINAL INT AND STR INIT: add nothing after this:
long int intHighScore01 = 0;
long int intHighScore02 = 0;
long int intHighScore03 = 0;
long int intHighScore04 = 0;
long int intHighScore05 = 0;
long int intHighScore06 = 0;
long int intHighScore07 = 0;
long int intHighScore08 = 0;
long int intHighScore09 = 0;
long int intHighScore10 = 0;

// ______________________________________________


@interface GameLayer(Private)

-(void)instantiateObjects;
-(void)positionObjects;
-(void)animateObjects;

// pause routine ??  also need show and hide high score list. 
// show and hide store.  show and hide profile edit screen for player. 
// show and hide op tions screen.

// pause button is where:
// control panel subs are where:

//-(void)pickBoxandSetColorNum;

//older to be removed:
-(void)resetGroundColors;
-(void)initGameScene;
-(void)appendNewGround;
-(void)refreshGameAssets;



@end

// GameLayer implementation
@implementation GameLayer

@synthesize emitter;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLayer *layer = [GameLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}


+ (void)initialize
{
    //initialize Mutable Strings then get out.
    
    //strCurrentBlankDefaultPiece = [[NSMutableString alloc] initWithString:@"piece_mstr_012.png"];
    strCurrentBlankDefaultPiece = [[NSMutableString alloc] initWithString:@"piece_mstr_003.png"];
    strCurrentTestPiece = [[NSMutableString alloc] initWithString:@"piece_mstr_005.png"];
    
    //player piece sprite names, not structure array:  set in game:
    strPieceName001 = [[NSMutableString alloc] initWithString:@"piece_mstr_001.png"];
    strPieceName002 = [[NSMutableString alloc] initWithString:@"piece_mstr_001.png"];
    strPieceName003 = [[NSMutableString alloc] initWithString:@"piece_mstr_001.png"];
    strPieceName004 = [[NSMutableString alloc] initWithString:@"piece_mstr_001.png"];
    strPieceName005 = [[NSMutableString alloc] initWithString:@"piece_mstr_001.png"];
    strPieceName006 = [[NSMutableString alloc] initWithString:@"piece_mstr_001.png"];
    strPieceName007 = [[NSMutableString alloc] initWithString:@"piece_mstr_001.png"];
    strPieceName008 = [[NSMutableString alloc] initWithString:@"piece_mstr_001.png"];
    strPieceName009 = [[NSMutableString alloc] initWithString:@"piece_mstr_001.png"];
    strPieceName010 = [[NSMutableString alloc] initWithString:@"piece_mstr_001.png"];
    strPieceName011 = [[NSMutableString alloc] initWithString:@"piece_mstr_001.png"];
    strPieceName012 = [[NSMutableString alloc] initWithString:@"piece_mstr_001.png"];
    strPieceName013 = [[NSMutableString alloc] initWithString:@"piece_mstr_001.png"];
    strPieceName014 = [[NSMutableString alloc] initWithString:@"piece_mstr_001.png"];
    strPieceName015 = [[NSMutableString alloc] initWithString:@"piece_mstr_001.png"];
    strPieceName016 = [[NSMutableString alloc] initWithString:@"piece_mstr_001.png"];
    strPieceName017 = [[NSMutableString alloc] initWithString:@"piece_mstr_001.png"];
    strPieceName018 = [[NSMutableString alloc] initWithString:@"piece_mstr_001.png"];
    strPieceName019 = [[NSMutableString alloc] initWithString:@"piece_mstr_001.png"];
    strPieceName020 = [[NSMutableString alloc] initWithString:@"piece_mstr_001.png"];
    strPieceName021 = [[NSMutableString alloc] initWithString:@"piece_mstr_001.png"];
    strPieceName022 = [[NSMutableString alloc] initWithString:@"piece_mstr_001.png"];
    strPieceName023 = [[NSMutableString alloc] initWithString:@"piece_mstr_001.png"];
    strPieceName024 = [[NSMutableString alloc] initWithString:@"piece_mstr_001.png"];
    strPieceName025 = [[NSMutableString alloc] initWithString:@"piece_mstr_001.png"];

    
    
    strRandomPieceName1 = [[NSMutableString alloc] initWithString:@"piece_mstr_001.png"];
    strRandomPieceName2 = [[NSMutableString alloc] initWithString:@"piece_mstr_001.png"];
    strRandomPieceName3 = [[NSMutableString alloc] initWithString:@"piece_mstr_001.png"];
    
    
	//NSMutableString *strDeviceSpriteFilename = nil;
	strDeviceSpriteFilename = [[NSMutableString alloc] initWithString:@"piece_normaltex.plist"];

    
    strTopButtonFileNormal = [[NSMutableString alloc] initWithString:@"top_button_88_38.png"];
    strTopButtonFileSelect = [[NSMutableString alloc] initWithString:@"top_button_88_38_selected.png"];
    strTopButtonFileDisable = [[NSMutableString alloc] initWithString:@"top_button_88_38_disabled.png"];
    strBottomButtonFileNormal = [[NSMutableString alloc] initWithString:@"bottom_button_88_38.png"];
    strBottomButtonFileSelect = [[NSMutableString alloc] initWithString:@"bottom_button_88_38_selected.png"];
    strBottomButtonFileDisable = [[NSMutableString alloc] initWithString:@"bottom_button_88_38_disabled.png"];
    strLeftButtonFileNormal = [[NSMutableString alloc] initWithString:@"left_button_90_60.png"];
    strLeftButtonFileSelect = [[NSMutableString alloc] initWithString:@"left_button_90_60_selected.png"];
    strLeftButtonFileDisable = [[NSMutableString alloc] initWithString:@"left_button_90_60_disabled.png"];
    strRightButtonFileNormal = [[NSMutableString alloc] initWithString:@"right_button_90_60.png"];
    strRightButtonFileSelect = [[NSMutableString alloc] initWithString:@"right_button_90_60_selected.png"];
    strRightButtonFileDisable = [[NSMutableString alloc] initWithString:@"right_button_90_60_disabled.png"];
    strSwitchFileNormal = [[NSMutableString alloc] initWithString:@"switchkb_61_29.png"];
    strSwitchFileSelect = [[NSMutableString alloc] initWithString:@"switchkb_61_29_selected.png"];
    strSwitchFileDisable = [[NSMutableString alloc] initWithString:@"switchkb_61_29_disabled.png"];
    strPauseFileNormal = [[NSMutableString alloc] initWithString:@"pausebtn_normal_57.png"];
    strPauseFileSelect = [[NSMutableString alloc] initWithString:@"pausebtn_enabled_57.png"];
    strPauseFileDisable = [[NSMutableString alloc] initWithString:@"pausebtn_disabled_57.png"];
    
    
    
    strIncomPiecesGrid = [[NSMutableString alloc] initWithString:@"O«X«O»O«X«O»O«X«O"];
    strIncomPiecesPiece1 = [[NSMutableString alloc] initWithString:@"O«X«O»"];
    strIncomPiecesPiece2 = [[NSMutableString alloc] initWithString:@"O«X«O»"];
    strIncomPiecesPiece3 = [[NSMutableString alloc] initWithString:@"O«X«O"];
    
	
	//set to noticably wrong default values:
	strSavedGameData = [[NSMutableString alloc] initWithString:@"Ben1«100»Ben1«99»Ben1«98»Ben1«97»Ben1«96»Ben1«95»Ben1«94»Ben1«82»Ben1«50»Ben1«10»"];
	strSavedAudioData = [[NSMutableString alloc] initWithString:@"1"];
	
//    strSavedBoardPieces = [[NSMutableString alloc] initWithString:@"0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»4»3»5»6»5»4«0»0»2»4»3»5»6»5»4«2»1»2»4»3»5»6»5»4«3»2»1»2»3»4»3»2»1"];
    
//    strSavedBoardPieces = [[NSMutableString alloc] initWithString:@"0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»3»6»0»0«0»0»0»0»0»3»6»0»0«0»0»0»0»0»1»6»0»0«0»0»0»0»0»1»2»0»0«0»0»0»4»1»5»2»0»0«0»0»0»4»3»1»2»0»0«0»0»0»4»3»1»2»0»0«0»0»1»2»1»1»1»0»0"];

    strSavedBoardPieces = [[NSMutableString alloc] initWithString:@"0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»3»6»0»0«0»0»0»0»0»3»6»0»0«0»0»0»0»0»1»6»0»0«0»0»0»0»0»1»2»0»0«0»0»0»4»1»5»2»0»0«0»0»0»4»3»1»2»0»0«0»0»0»4»3»1»2»0»0«0»0»1»2»7»7»7»0»0"];             //  test error on apples x 2

//    strSavedBoardPieces = [[NSMutableString alloc] initWithString:@"0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»3»6»0»0«0»0»0»0»0»3»6»0»0«0»0»0»0»0»1»6»0»0«0»0»0»0»0»1»2»0»0«0»0»0»4»1»5»2»0»0«0»0»0»4»3»5»2»0»0«0»0»0»4»3»1»2»0»0«0»0»6»2»7»7»7»0»0"];    // no error but falling piece sometimes fires on single
    
    strFinalBoardPieces = [[NSMutableString alloc] initWithString:@"1"];
    
    strIncomBoardPieces = [[NSMutableString alloc] initWithString:@"0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0"];
    strUpcomBoardPieces = [[NSMutableString alloc] initWithString:@"0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0"];    //upcoming grid data
    
    strRotLRBoardPieces = [[NSMutableString alloc] initWithString:@"0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0"];
    
    
    strBuildBoardPieces = [[NSMutableString alloc] initWithString:@"0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0"];
    
    strNewBoard = [[NSMutableString alloc] initWithString:@"0»0"];
    strREPLNewBoard = [[NSMutableArray alloc]init];
    strREPLNewBoardRow = [[NSMutableArray alloc]init];
    
    strCurrentPieceMatchList = [[NSMutableString alloc] initWithString:@"0«0«0«0«0«0«0«0«0"];
    strRCVDBuild = [[NSMutableArray alloc]init];
    strRCVDBuildRow = [[NSMutableArray alloc]init];
    
    strActiveBoxiTags = [[NSMutableArray alloc]init];
    strActiveBoxiTagList = [[NSMutableString alloc] initWithString:@"0»0"];
    
    strReDropBoxiTags = [[NSMutableArray alloc]init];
    strReDropBoxiTagList = [[NSMutableString alloc] initWithString:@"0»0"];
    
    strPopperConcatList = [[NSMutableString alloc] initWithString:@"0»0"];
    
    strPopperCheckCols = [[NSMutableArray alloc]init];
    strPopperCheckColCells = [[NSMutableArray alloc]init];
    
    strIncomBoardPiecesTopBuffer = [[NSMutableString alloc] initWithString:@"0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0"];
    
    strIncomBoardPiecesMidBuffer = [[NSMutableString alloc] initWithString:@"0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0"];
    
    strIncomBoardPiecesBottomBuffer = [[NSMutableString alloc] initWithString:@"0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0"];
    
    strREPLBoardPiecesNewBuffer = [[NSMutableString alloc] initWithString:@"0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0"];
    
    strREPLBoardPiecesTopBuffer = [[NSMutableString alloc] initWithString:@"0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0"];
    strREPLBoardPiecesBottomBuffer = [[NSMutableString alloc] initWithString:@"0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0"];
    
    strSLIDEboardTopBuffer = [[NSMutableString alloc] initWithString:@"0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0"];
    strSLIDEboardBottomBuffer = [[NSMutableString alloc] initWithString:@"0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0"];
    strSLIDEboardPiecesNewBuffer = [[NSMutableString alloc] initWithString:@"0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0"];
    
    
    
    strIncomBufferToSwitch = [[NSMutableString alloc] initWithString:@"0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0"];
    
    //remove all
    strRCVDArray000 = [[NSMutableArray alloc]init];
    strInsertableBlank = [[NSMutableString alloc] initWithString:@"0«0«0«0«0«0«0«0«0"];
    strRotatedPiece = [[NSMutableString alloc] initWithString:@"O«X«O»O«X«O»O«X«O"];
    
    
     strRCVDDropScan = [[NSMutableArray alloc]init];
     strRCVDDropScanRow1 = [[NSMutableArray alloc]init];
     strRCVDDropScanRow2 = [[NSMutableArray alloc]init];
     strRCVDDropScanRow3 = [[NSMutableArray alloc]init];
    
    strRCVDArraySaved = [[NSMutableArray alloc]init];
    strRCVDArrayUpcom = [[NSMutableArray alloc]init];
    strRCVDArrayIncom = [[NSMutableArray alloc]init];
    strRCVDArraySavedRow = [[NSMutableArray alloc]init];
    strRCVDArrayUpcomRow = [[NSMutableArray alloc]init];
    strRCVDArrayIncomRow = [[NSMutableArray alloc]init];
    
    strRCVDArrayRotator = [[NSMutableArray alloc]init];
    strRCVDArrayRotatorRow1 = [[NSMutableArray alloc]init];
    strRCVDArrayRotatorRow2 = [[NSMutableArray alloc]init];
    strRCVDArrayRotatorRow3 = [[NSMutableArray alloc]init];
    
    strRCVDUseRotate = [[NSMutableArray alloc]init];
    strRCVDUseRotateRow1 = [[NSMutableArray alloc]init];
    strRCVDUseRotateRow2 = [[NSMutableArray alloc]init];
    strRCVDUseRotateRow3 = [[NSMutableArray alloc]init];
    
    strRCVDPieceScan = [[NSMutableArray alloc]init];
    strRCVDPieceScanRow1 = [[NSMutableArray alloc]init];
    strRCVDPieceScanRow2 = [[NSMutableArray alloc]init];
    strRCVDPieceScanRow3 = [[NSMutableArray alloc]init];
    
    strSavedBoardAttrib = [[NSMutableString alloc] initWithString:@"0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0"];
    
	//strSavedSensitivity = [[NSMutableString alloc] initWithString:@"300"];
	
	
	strHighScoreName01 = [[NSMutableString alloc] initWithString:@"A"];
	strHighScoreName02 = [[NSMutableString alloc] initWithString:@"B"];
	strHighScoreName03 = [[NSMutableString alloc] initWithString:@"C"];
	strHighScoreName04 = [[NSMutableString alloc] initWithString:@"D"];
	strHighScoreName05 = [[NSMutableString alloc] initWithString:@"E"];
	strHighScoreName06 = [[NSMutableString alloc] initWithString:@"F"];
	strHighScoreName07 = [[NSMutableString alloc] initWithString:@"G"];
	strHighScoreName08 = [[NSMutableString alloc] initWithString:@"H"];
	strHighScoreName09 = [[NSMutableString alloc] initWithString:@"I"];
	strHighScoreName10 = [[NSMutableString alloc] initWithString:@"J"];
	
	strHighScore01 = [[NSMutableString alloc] initWithString:@"10"];
	strHighScore02 = [[NSMutableString alloc] initWithString:@"9"];
	strHighScore03 = [[NSMutableString alloc] initWithString:@"8"];
	strHighScore04 = [[NSMutableString alloc] initWithString:@"7"];
	strHighScore05 = [[NSMutableString alloc] initWithString:@"6"];
	strHighScore06 = [[NSMutableString alloc] initWithString:@"5"];
	strHighScore07 = [[NSMutableString alloc] initWithString:@"4"];
	strHighScore08 = [[NSMutableString alloc] initWithString:@"3"];
	strHighScore09 = [[NSMutableString alloc] initWithString:@"2"];
	strHighScore10 = [[NSMutableString alloc] initWithString:@"1"];
	
	strNameCols = [[NSMutableString alloc] initWithString:@"Name"];
	strPointsCols = [[NSMutableString alloc] initWithString:@"Score"];
	
    
    selectedFontToShow = [[NSMutableString alloc] initWithString:@"kaushaun.otf"];
	//selectedFontToShow = [[NSMutableString alloc] initWithString:@"gamefont_df.ttf"];
	
	strNotifierTextToShow = [[NSMutableString alloc] initWithString:@"Copyright © 2014. All Rights Reserved.\nPresented by Titanbase Productions. Version 1.0"];
	
	strLevelTextToShow = [[NSMutableString alloc] initWithString:@"Level XXX"];
	
    strCreditsList = [[NSMutableString alloc] initWithString:@"\nBen Lindelof\n  art direction & game design\nBen Lindelof\n  coding, graphics, game design\nBen Lindelof\n  QA, testing\nBen Lindelof\n  sound FX, QA, testing\nBen Lindelof\n  3D character artist\nBen Lindelof\n  composer\nBen Lindelof\n  voice acting\n "];
	
	strCurrentPlayerName = [[NSMutableString alloc] initWithString:@"Ben"];

	
//    NSMutableString *strCurrentPlayPiece = nil;
//    NSMutableString *strNext01PlayPiece = nil;
//    NSMutableString *strNext02PlayPiece = nil;
    
     strCurrentPlayPiece = [[NSMutableString alloc] initWithString:@"1«100»"];
     strNext01PlayPiece = [[NSMutableString alloc] initWithString:@"1«100»"];
     strNext02PlayPiece = [[NSMutableString alloc] initWithString:@"1«100»"];
    
    //store avaialble pieces
    strPieceType01 = [[NSMutableString alloc] initWithString:@"O«X«O»O«X«O»O«X«O"];
    strPieceType02 = [[NSMutableString alloc] initWithString:@"X«O«O»X«X«O»X«X«X"];
    strPieceType03 = [[NSMutableString alloc] initWithString:@"X«O«X»O«X«O»X«O«X"];
    strPieceType04 = [[NSMutableString alloc] initWithString:@"X«O«X»X«O«X»X«X«X"];
    strPieceType05 = [[NSMutableString alloc] initWithString:@"X«X«X»O«X«O»O«X«O"];
    strPieceType06 = [[NSMutableString alloc] initWithString:@"X«X«X»O«O«X»O«O«X"];
    strPieceType07 = [[NSMutableString alloc] initWithString:@"X«X«X»O«X«O»X«O«O"];
    strPieceType08 = [[NSMutableString alloc] initWithString:@"X«X«X»X«O«X»X«X«X"];
    strPieceType09 = [[NSMutableString alloc] initWithString:@"X«X«X»X«X«X»X«X«X"];
    
    strCurrentPieceStr = [[NSMutableString alloc] initWithString:@"99"];
    
    
    
}




// on "init" you need to initialize your instance
-(id) init {
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        
        NSLog(@".......");
        
        srandom(time(NULL));
        
        dateTimeStartedDrop = [NSDate date];
        dateTimeCurrent = [NSDate date];
        dateTimeDropDuration = [dateTimeCurrent timeIntervalSinceDate:dateTimeStartedDrop];
        
        //NSTimeInterval duration = [end timeIntervalSinceDate:start];
        //NSDate *dateTimeStartedDrop = [NSDate date];
        
        
        
        // ask director the the window size
		//CGSize size = [[CCDirector sharedDirector] winSizeInPixels];

        
        //Enable touches
        self.isTouchEnabled=YES;
        
        //none, iphone (hd), ipad (hd), ipad ret (ultra hd)

        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            if (CC_CONTENT_SCALE_FACTOR() > 1) {
                inttypeOfHD = 3;              // 1 + CC_CONTENT_SCALE_FACTOR();   //3+
            } else {
                inttypeOfHD = 2;
            }
        } else {
            if (CC_CONTENT_SCALE_FACTOR() > 1) {
                inttypeOfHD = 1;
            } else {
                inttypeOfHD = 0;
            }
        }
        
        NSLog(@"inttypeOfHD %li", inttypeOfHD);
        
        
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
            if([UIScreen mainScreen].bounds.size.height == 568.0){
                NSLog(@"4 inch display");
                intIs4InchScreen = 1;
            }
        }
        
        // int intActualFieldBGHeight = 0; //fieldbg.contentSize.height replacement
        
        if (inttypeOfHD == 0) {
            intSizeofPieceWithoutAA = 21;
            intActualFieldBGHeight = 315;
        } else if (inttypeOfHD == 1) {
            intSizeofPieceWithoutAA = 42;
            intActualFieldBGHeight = 630;
        } else if (inttypeOfHD == 2) {
            intSizeofPieceWithoutAA = 42;
            intActualFieldBGHeight = 630;
        } else {
            intSizeofPieceWithoutAA = 84;
            intActualFieldBGHeight = 1260;
        }
        
        
        //load data:
        //SHOW LOADING SCREEN HERE IF NEEDED.........
        

        if (intGamePausedbyPlayer == 0) {

            [self instantiateObjects];
            
        } else {
            //something elsE?
            [self instantiateObjects];
        }
        
        
        
        //        if (intGamePausedbyPlayer == 0) {
        //            [self initGameScene];
        //        } else {
        //            NSLog(@"doing nothing... game paused by player...");
        //            
        //            //display?   no, missing inits!
        //            //  so.... fix LANDSCAPE START IN INITGAMESCENE
        //            //[self refreshGameAssets];
        //            
        //            [self initGameScene];
        //        }
        
        
        
        
        
        lastDigTime=0;
        touchActiveLocationOK=NO;
        
        
        
        //[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"SpaceGame.caf" loop:YES];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"explosion_large.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"laser_ship.caf"];
        
        
        
//        [self schedule:@selector(tickerTimer:)];
//        
//        [self schedule:@selector(pieceTicker:) interval:0.7f];
        //[self schedule:@selector(addEnemy) interval:30.0f];
        
        
	}
	return self;
}
// on "dealloc" you need to release all your retained objects
- (void) dealloc {
//    [miners release];
//	[grounds release];
	[super dealloc];
}


//TODO: NEW INIT:
-(void)instantiateObjects {
    
    CGSize size = [[CCDirector sharedDirector] winSizeInPixels];
    
    intScreenWidth = size.width;
    intScreenMidX = size.width/2;
    
    intInstantiatedWidth = intScreenWidth;
    
    //set and watch:
    intWideMode = intScreenWidth;
    
    intScreenHeight = size.height;
    intScreenMidY = size.height/2;
    
    //this coul be wrong if starting in landscape on 7.1
    if (intScreenHeight < intScreenWidth) {
        intInLandscape = 1;
    } else {
        intInLandscape = 0;
    }


    //PIECE NAMES:
    
	//strCurrentBlankDefaultPiece                             11 and 12 are more blank than others
	if (inttypeOfHD == 0) {
        NSLog(@"Setting default..");
//		[strCurrentBlankDefaultPiece setString:@"piece_mstr_003.png"];
//        [strCurrentTestPiece setString:@"piece_mstr_005.png"];

	
        [strCurrentBlankDefaultPiece setString:@"piece_mstr_011.png"];
        [strCurrentTestPiece setString:@"piece_mstr_007.png"];
        
        [strPieceName001 setString:@"piece_mstr_001.png"];
        [strPieceName002 setString:@"piece_mstr_002.png"];
        [strPieceName003 setString:@"piece_mstr_003.png"];
        [strPieceName004 setString:@"piece_mstr_004.png"];
        [strPieceName005 setString:@"piece_mstr_005.png"];
        [strPieceName006 setString:@"piece_mstr_006.png"];
        [strPieceName007 setString:@"piece_mstr_007.png"];
        [strPieceName008 setString:@"piece_mstr_008.png"];
        [strPieceName009 setString:@"piece_mstr_009.png"];
        [strPieceName010 setString:@"piece_mstr_010.png"];
        [strPieceName011 setString:@"piece_mstr_011.png"];
        [strPieceName012 setString:@"piece_mstr_012.png"];
        
        [strPieceName013 setString:@"piece_mstr_013.png"];
        [strPieceName014 setString:@"piece_mstr_014.png"];
        [strPieceName015 setString:@"piece_mstr_015.png"];
        [strPieceName016 setString:@"piece_mstr_016.png"];
        [strPieceName017 setString:@"piece_mstr_017.png"];
        [strPieceName018 setString:@"piece_mstr_018.png"];
        [strPieceName019 setString:@"piece_mstr_019.png"];
        [strPieceName020 setString:@"piece_mstr_020.png"];
        [strPieceName021 setString:@"piece_mstr_021.png"];
        [strPieceName022 setString:@"piece_mstr_022.png"];
        [strPieceName023 setString:@"piece_mstr_023.png"];
        [strPieceName024 setString:@"piece_mstr_024.png"];
        [strPieceName025 setString:@"piece_mstr_025.png"];
        
        [strRandomPieceName1 setString:@"piece_mstr_001.png"];
        [strRandomPieceName2 setString:@"piece_mstr_001.png"];
        [strRandomPieceName3 setString:@"piece_mstr_001.png"];
        
    
    } else if (inttypeOfHD == 1) {
        //[strCurrentBlankDefaultPiece setString:@"piece_mstr_46_003.png"];
        //[strCurrentTestPiece setString:@"piece_mstr_46_005.png"];
        [strCurrentBlankDefaultPiece setString:@"piece_mstr_46_011.png"];
        [strCurrentTestPiece setString:@"piece_mstr_46_007.png"];
        
        [strPieceName001 setString:@"piece_mstr_46_001.png"];
        [strPieceName002 setString:@"piece_mstr_46_002.png"];
        [strPieceName003 setString:@"piece_mstr_46_003.png"];
        [strPieceName004 setString:@"piece_mstr_46_004.png"];
        [strPieceName005 setString:@"piece_mstr_46_005.png"];
        [strPieceName006 setString:@"piece_mstr_46_006.png"];
        [strPieceName007 setString:@"piece_mstr_46_007.png"];
        [strPieceName008 setString:@"piece_mstr_46_008.png"];
        [strPieceName009 setString:@"piece_mstr_46_009.png"];
        [strPieceName010 setString:@"piece_mstr_46_010.png"];
        [strPieceName011 setString:@"piece_mstr_46_011.png"];
        [strPieceName012 setString:@"piece_mstr_46_012.png"];
        
        [strPieceName013 setString:@"piece_mstr_46_013.png"];
        [strPieceName014 setString:@"piece_mstr_46_014.png"];
        [strPieceName015 setString:@"piece_mstr_46_015.png"];
        [strPieceName016 setString:@"piece_mstr_46_016.png"];
        [strPieceName017 setString:@"piece_mstr_46_017.png"];
        [strPieceName018 setString:@"piece_mstr_46_018.png"];
        [strPieceName019 setString:@"piece_mstr_46_019.png"];
        [strPieceName020 setString:@"piece_mstr_46_020.png"];
        [strPieceName021 setString:@"piece_mstr_46_021.png"];
        [strPieceName022 setString:@"piece_mstr_46_022.png"];
        [strPieceName023 setString:@"piece_mstr_46_023.png"];
        [strPieceName024 setString:@"piece_mstr_46_024.png"];
        [strPieceName025 setString:@"piece_mstr_46_025.png"];
        
        [strRandomPieceName1 setString:@"piece_mstr_46_001.png"];
        [strRandomPieceName2 setString:@"piece_mstr_46_001.png"];
        [strRandomPieceName3 setString:@"piece_mstr_46_001.png"];
    
    } else if (inttypeOfHD == 2) {
		//[strCurrentBlankDefaultPiece setString:@"piece_mstr_46_003.png"];
        //[strCurrentTestPiece setString:@"piece_mstr_46_005.png"];
        [strCurrentBlankDefaultPiece setString:@"piece_mstr_46_011.png"];
        [strCurrentTestPiece setString:@"piece_mstr_46_007.png"];
        
        [strPieceName001 setString:@"piece_mstr_46_001.png"];
        [strPieceName002 setString:@"piece_mstr_46_002.png"];
        [strPieceName003 setString:@"piece_mstr_46_003.png"];
        [strPieceName004 setString:@"piece_mstr_46_004.png"];
        [strPieceName005 setString:@"piece_mstr_46_005.png"];
        [strPieceName006 setString:@"piece_mstr_46_006.png"];
        [strPieceName007 setString:@"piece_mstr_46_007.png"];
        [strPieceName008 setString:@"piece_mstr_46_008.png"];
        [strPieceName009 setString:@"piece_mstr_46_009.png"];
        [strPieceName010 setString:@"piece_mstr_46_010.png"];
        [strPieceName011 setString:@"piece_mstr_46_011.png"];
        [strPieceName012 setString:@"piece_mstr_46_012.png"];
        
        [strPieceName013 setString:@"piece_mstr_46_013.png"];
        [strPieceName014 setString:@"piece_mstr_46_014.png"];
        [strPieceName015 setString:@"piece_mstr_46_015.png"];
        [strPieceName016 setString:@"piece_mstr_46_016.png"];
        [strPieceName017 setString:@"piece_mstr_46_017.png"];
        [strPieceName018 setString:@"piece_mstr_46_018.png"];
        [strPieceName019 setString:@"piece_mstr_46_019.png"];
        [strPieceName020 setString:@"piece_mstr_46_020.png"];
        [strPieceName021 setString:@"piece_mstr_46_021.png"];
        [strPieceName022 setString:@"piece_mstr_46_022.png"];
        [strPieceName023 setString:@"piece_mstr_46_023.png"];
        [strPieceName024 setString:@"piece_mstr_46_024.png"];
        [strPieceName025 setString:@"piece_mstr_46_025.png"];
        
        [strRandomPieceName1 setString:@"piece_mstr_46_001.png"];
        [strRandomPieceName2 setString:@"piece_mstr_46_001.png"];
        [strRandomPieceName3 setString:@"piece_mstr_46_001.png"];
        
    } else {
		//[strCurrentBlankDefaultPiece setString:@"piece_mstr_92_003.png"];
        //[strCurrentTestPiece setString:@"piece_mstr_92_005.png"];
        [strCurrentBlankDefaultPiece setString:@"piece_mstr_92_011.png"];
        [strCurrentTestPiece setString:@"piece_mstr_92_007.png"];
        
        [strPieceName001 setString:@"piece_mstr_92_001.png"];
        [strPieceName002 setString:@"piece_mstr_92_002.png"];
        [strPieceName003 setString:@"piece_mstr_92_003.png"];
        [strPieceName004 setString:@"piece_mstr_92_004.png"];
        [strPieceName005 setString:@"piece_mstr_92_005.png"];
        [strPieceName006 setString:@"piece_mstr_92_006.png"];
        [strPieceName007 setString:@"piece_mstr_92_007.png"];
        [strPieceName008 setString:@"piece_mstr_92_008.png"];
        [strPieceName009 setString:@"piece_mstr_92_009.png"];
        [strPieceName010 setString:@"piece_mstr_92_010.png"];
        [strPieceName011 setString:@"piece_mstr_92_011.png"];
        [strPieceName012 setString:@"piece_mstr_92_012.png"];
        
        [strPieceName013 setString:@"piece_mstr_92_013.png"];
        [strPieceName014 setString:@"piece_mstr_92_014.png"];
        [strPieceName015 setString:@"piece_mstr_92_015.png"];
        [strPieceName016 setString:@"piece_mstr_92_016.png"];
        [strPieceName017 setString:@"piece_mstr_92_017.png"];
        [strPieceName018 setString:@"piece_mstr_92_018.png"];
        [strPieceName019 setString:@"piece_mstr_92_019.png"];
        [strPieceName020 setString:@"piece_mstr_92_020.png"];
        [strPieceName021 setString:@"piece_mstr_92_021.png"];
        [strPieceName022 setString:@"piece_mstr_92_022.png"];
        [strPieceName023 setString:@"piece_mstr_92_023.png"];
        [strPieceName024 setString:@"piece_mstr_92_024.png"];
        [strPieceName025 setString:@"piece_mstr_92_025.png"];
        
        [strRandomPieceName1 setString:@"piece_mstr_92_001.png"];
        [strRandomPieceName2 setString:@"piece_mstr_92_001.png"];
        [strRandomPieceName3 setString:@"piece_mstr_92_001.png"];
        
    }

    // GET ALL DEVICE SETTINGS DONE BY HERE.
    
    
    
    //sample text:    CCLabelTTF *label = [CCLabelTTF labelWithString:@"FruitBunch!" fontName:@"Helvetica" fontSize:24];
//    CCLabelTTF *label = [CCLabelTTF labelWithString:@"FruitBunch!" fontName:@"KaushanScript-Regular" fontSize:24];
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"FruitBunch!" fontName:@"kaushaun.otf" fontSize:26];
    label.positionInPixels =  ccp( intScreenWidth/2 , (intScreenHeight)-33 );
    [self addChild: label z:400];
    
    
    
    
// pieces
    
//    ______ _
//    | ___ (_)
//    | |_/ /_  ___  ___ ___  ___
//    |  __/| |/ _ \/ __/ _ \/ __|
//    | |   | |  __/ (_|  __/\__ \
//    \_|   |_|\___|\___\___||___/
    

    
//    strCurrentPlayPiece = [[NSMutableString alloc] initWithString:@"1«100»"];
//    strNext01PlayPiece = [[NSMutableString alloc] initWithString:@"1«100»"];
//    strNext02PlayPiece = [[NSMutableString alloc] initWithString:@"1«100»"];
    
   //currentP1 loasding below in sprites.
    
    //NSArray *arrRCVD_Top10 = [strSavedGameData componentsSeparatedByString:@"»"];
    //NSArray *arrRCVD01 = [[arrRCVD_Top10 objectAtIndex:0] componentsSeparatedByString:@"«"];
    //NSArray *arrRCVD02 = [[arrRCVD_Top10 objectAtIndex:1] componentsSeparatedByString:@"«"];
    //NSArray *arrRCVD03 = [[arrRCVD_Top10 objectAtIndex:2] componentsSeparatedByString:@"«"];
    
    
    //strPieceType01 = [[NSMutableString alloc] initWithString:@"O«X«O»O«X«O»O«X«O"];
    //strPieceType02 = [[NSMutableString alloc] initWithString:@"X«O«O»O«X«O»O«O«X"];
    //strPieceType03 = [[NSMutableString alloc] initWithString:@"X«O«X»O«X«O»X«O«X"];
    //strPieceType04 = [[NSMutableString alloc] initWithString:@"X«O«X»X«O«X»X«X«X"];
    //strPieceType05 = [[NSMutableString alloc] initWithString:@"X«X«X»O«X«O»O«X«O"];
    //strPieceType06 = [[NSMutableString alloc] initWithString:@"X«X«X»O«O«X»O«O«X"];
    //strPieceType07 = [[NSMutableString alloc] initWithString:@"X«X«X»O«X«O»X«O«O"];
    //strPieceType08 = [[NSMutableString alloc] initWithString:@"X«X«X»X«O«X»X«X«X"];
    //strPieceType09 = [[NSMutableString alloc] initWithString:@"X«X«X»X«X«X»X«X«X"];
    
    //    NSArray *arrRCVD_Piece01 = [strPieceType01 componentsSeparatedByString:@"»"];
    //    NSArray *arrRCVD01 = [[arrRCVD_Piece01 objectAtIndex:0] componentsSeparatedByString:@"«"];
    //    NSArray *arrRCVD02 = [[arrRCVD_Piece01 objectAtIndex:1] componentsSeparatedByString:@"«"];
    //    NSArray *arrRCVD03 = [[arrRCVD_Piece01 objectAtIndex:2] componentsSeparatedByString:@"«"];
    
    
    
    
    
//     _____            _ _
//    /  ___|          (_) |
//    \ `--. _ __  _ __ _| |_ ___  ___
//     `--. \ '_ \| '__| | __/ _ \/ __|
//    /\__/ / |_) | |  | | ||  __/\__ \
//    \____/| .__/|_|  |_|\__\___||___/
//          | |
//          |_|

    


//	if (inttypeOfHD == 0) {
//		[strDeviceSpriteFilename setString:@"piece_normaltex.plist"];
//	} else if (inttypeOfHD == 1) {
//		[strDeviceSpriteFilename setString:@"piece_hdtex.plist"];
//	} else if (inttypeOfHD == 2) {
//		[strDeviceSpriteFilename setString:@"piece_hdtex.plist"];
//	} else {
//		[strDeviceSpriteFilename setString:@"piece_uhdtex.plist"];
//	}
    
    if (inttypeOfHD == 0) {
		[strDeviceSpriteFilename setString:@"texture23.plist"];
	} else if (inttypeOfHD == 1) {
		[strDeviceSpriteFilename setString:@"texture46.plist"];
	} else if (inttypeOfHD == 2) {
		[strDeviceSpriteFilename setString:@"texture46.plist"];
	} else {
		[strDeviceSpriteFilename setString:@"texture92.plist"];
	}
    
        
    frameCacheMain = [CCSpriteFrameCache sharedSpriteFrameCache];
    //[frameCacheMain addSpriteFramesWithFile:@"piece_normaltex.plist"];
	[frameCacheMain addSpriteFramesWithFile:strDeviceSpriteFilename];
    
    
    //all images are already in the framecache, ready for animation arrays:
    //
    NSMutableArray *animationFramesMain = [NSMutableArray arrayWithCapacity:25];
    
    NSMutableArray *animationFramesBoom1 = [NSMutableArray arrayWithCapacity:4];
    
    //    spriteFrameMain = [frameCacheMain spriteFrameByName:@"piece_mstr_001.png"];
    //    [animationFramesMain addObject:spriteFrameMain];
    
	if (inttypeOfHD == 0) {
		//looping thru names instead of named sprites individually:
		for (int i = 1; i <= 25 ; ++i) {
			//NSLog(@"write: %@", [NSString stringWithFormat:@"piece_mstr_0%02d.png", i]);
			[animationFramesMain addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"piece_mstr_0%02d.png", i]]];
		}
        [animationFramesBoom1 addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"piece_mstr_0%02d.png", 13]]];
        [animationFramesBoom1 addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"piece_mstr_0%02d.png", 25]]];
        [animationFramesBoom1 addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"piece_mstr_0%02d.png", 13]]];
        [animationFramesBoom1 addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"piece_mstr_0%02d.png", 25]]];
        

	} else if (inttypeOfHD == 1) {

		for (int i = 1; i <= 25 ; ++i) {
			//NSLog(@"write: %@", [NSString stringWithFormat:@"piece_mstr_0%02d.png", i]);
			[animationFramesMain addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"piece_mstr_46_0%02d.png", i]]];
		}
        [animationFramesBoom1 addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"piece_mstr_46_0%02d.png", 13]]];
        [animationFramesBoom1 addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"piece_mstr_46_0%02d.png", 25]]];
        [animationFramesBoom1 addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"piece_mstr_46_0%02d.png", 13]]];
        [animationFramesBoom1 addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"piece_mstr_46_0%02d.png", 25]]];

	} else if (inttypeOfHD == 2) {

		for (int i = 1; i <= 25 ; ++i) {
			//NSLog(@"write: %@", [NSString stringWithFormat:@"piece_mstr_0%02d.png", i]);
			[animationFramesMain addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"piece_mstr_46_0%02d.png", i]]];
		}
        [animationFramesBoom1 addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"piece_mstr_46_0%02d.png", 13]]];
        [animationFramesBoom1 addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"piece_mstr_46_0%02d.png", 25]]];
        [animationFramesBoom1 addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"piece_mstr_46_0%02d.png", 13]]];
        [animationFramesBoom1 addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"piece_mstr_46_0%02d.png", 25]]];

	} else {

		for (int i = 1; i <= 25 ; ++i) {
			//NSLog(@"write: %@", [NSString stringWithFormat:@"piece_mstr_0%02d.png", i]);
			[animationFramesMain addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"piece_mstr_92_0%02d.png", i]]];
		}
        [animationFramesBoom1 addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"piece_mstr_92_0%02d.png", 13]]];
        [animationFramesBoom1 addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"piece_mstr_92_0%02d.png", 25]]];
        [animationFramesBoom1 addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"piece_mstr_92_0%02d.png", 13]]];
        [animationFramesBoom1 addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"piece_mstr_92_0%02d.png", 25]]];

	}
    
    
    //use for game grid:
    Box1a = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box1a.anchorPoint = ccp(0,0);
    [self addChild:Box1a z:101 tag:101];
    
    Box2a = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box2a.anchorPoint = ccp(0,0);
    [self addChild:Box2a z:102 tag:102];
    
    Box3a = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box3a.anchorPoint = ccp(0,0);
    [self addChild:Box3a z:103 tag:103];
    
    Box4a = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box4a.anchorPoint = ccp(0,0);
    [self addChild:Box4a z:104 tag:104];
    
    Box5a = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box5a.anchorPoint = ccp(0,0);
    [self addChild:Box5a z:105 tag:105];
    
    Box6a = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box6a.anchorPoint = ccp(0,0);
    [self addChild:Box6a z:106 tag:106];
    
    Box7a = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box7a.anchorPoint = ccp(0,0);
    [self addChild:Box7a z:107 tag:107];
    
    Box8a = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box8a.anchorPoint = ccp(0,0);
    [self addChild:Box8a z:108 tag:108];
    
    Box9a = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box9a.anchorPoint = ccp(0,0);
    [self addChild:Box9a z:109 tag:109];
    
    
    Box1b = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box1b.anchorPoint = ccp(0,0);
    [self addChild:Box1b z:111 tag:111];
    
    Box2b = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box2b.anchorPoint = ccp(0,0);
    [self addChild:Box2b z:112 tag:112];
    
    Box3b = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box3b.anchorPoint = ccp(0,0);
    [self addChild:Box3b z:113 tag:113];
    
    Box4b = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box4b.anchorPoint = ccp(0,0);
    [self addChild:Box4b z:114 tag:114];
    
    Box5b = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box5b.anchorPoint = ccp(0,0);
    [self addChild:Box5b z:115 tag:115];
    
    Box6b = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box6b.anchorPoint = ccp(0,0);
    [self addChild:Box6b z:116 tag:116];
    
    Box7b = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box7b.anchorPoint = ccp(0,0);
    [self addChild:Box7b z:117 tag:117];
    
    Box8b = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box8b.anchorPoint = ccp(0,0);
    [self addChild:Box8b z:118 tag:118];
    
    Box9b = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box9b.anchorPoint = ccp(0,0);
    [self addChild:Box9b z:119 tag:119];
    
    
    Box1c = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box1c.anchorPoint = ccp(0,0);
    [self addChild:Box1c z:101 tag:121];
    
    Box2c = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box2c.anchorPoint = ccp(0,0);
    [self addChild:Box2c z:102 tag:122];
    
    Box3c = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box3c.anchorPoint = ccp(0,0);
    [self addChild:Box3c z:103 tag:123];
    
    Box4c = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box4c.anchorPoint = ccp(0,0);
    [self addChild:Box4c z:104 tag:124];
    
    Box5c = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box5c.anchorPoint = ccp(0,0);
    [self addChild:Box5c z:105 tag:125];
    
    Box6c = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box6c.anchorPoint = ccp(0,0);
    [self addChild:Box6c z:106 tag:126];
    
    Box7c = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box7c.anchorPoint = ccp(0,0);
    [self addChild:Box7c z:107 tag:127];
    
    Box8c = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box8c.anchorPoint = ccp(0,0);
    [self addChild:Box8c z:108 tag:128];
    
    Box9c = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box9c.anchorPoint = ccp(0,0);
    [self addChild:Box9c z:109 tag:129];
    
    
    
    Box1d = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box1d.anchorPoint = ccp(0,0);
    [self addChild:Box1d z:111 tag:131];
    
    Box2d = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box2d.anchorPoint = ccp(0,0);
    [self addChild:Box2d z:112 tag:132];
    
    Box3d = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box3d.anchorPoint = ccp(0,0);
    [self addChild:Box3d z:113 tag:133];
    
    Box4d = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box4d.anchorPoint = ccp(0,0);
    [self addChild:Box4d z:114 tag:134];
    
    Box5d = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box5d.anchorPoint = ccp(0,0);
    [self addChild:Box5d z:115 tag:135];
    
    Box6d = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box6d.anchorPoint = ccp(0,0);
    [self addChild:Box6d z:116 tag:136];
    
    Box7d = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box7d.anchorPoint = ccp(0,0);
    [self addChild:Box7d z:117 tag:137];
    
    Box8d = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box8d.anchorPoint = ccp(0,0);
    [self addChild:Box8d z:118 tag:138];
    
    Box9d = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box9d.anchorPoint = ccp(0,0);
    [self addChild:Box9d z:119 tag:139];
    
    
    Box1e = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box1e.anchorPoint = ccp(0,0);
    [self addChild:Box1e z:101 tag:141];
    
    Box2e = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box2e.anchorPoint = ccp(0,0);
    [self addChild:Box2e z:102 tag:142];
    
    Box3e = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box3e.anchorPoint = ccp(0,0);
    [self addChild:Box3e z:103 tag:143];
    
    Box4e = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box4e.anchorPoint = ccp(0,0);
    [self addChild:Box4e z:104 tag:144];
    
    Box5e = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box5e.anchorPoint = ccp(0,0);
    [self addChild:Box5e z:105 tag:145];
    
    Box6e = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box6e.anchorPoint = ccp(0,0);
    [self addChild:Box6e z:106 tag:146];
    
    Box7e = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box7e.anchorPoint = ccp(0,0);
    [self addChild:Box7e z:107 tag:147];
    
    Box8e = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box8e.anchorPoint = ccp(0,0);
    [self addChild:Box8e z:108 tag:148];
    
    Box9e = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box9e.anchorPoint = ccp(0,0);
    [self addChild:Box9e z:109 tag:149];
    
    
    
    
    Box1f = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box1f.anchorPoint = ccp(0,0);
    [self addChild:Box1f z:111 tag:151];
    
    Box2f = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box2f.anchorPoint = ccp(0,0);
    [self addChild:Box2f z:112 tag:152];
    
    Box3f = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box3f.anchorPoint = ccp(0,0);
    [self addChild:Box3f z:113 tag:153];
    
    Box4f = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box4f.anchorPoint = ccp(0,0);
    [self addChild:Box4f z:114 tag:154];
    
    Box5f = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box5f.anchorPoint = ccp(0,0);
    [self addChild:Box5f z:115 tag:155];
    
    Box6f = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box6f.anchorPoint = ccp(0,0);
    [self addChild:Box6f z:116 tag:156];
    
    Box7f = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box7f.anchorPoint = ccp(0,0);
    [self addChild:Box7f z:117 tag:157];
    
    Box8f = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box8f.anchorPoint = ccp(0,0);
    [self addChild:Box8f z:118 tag:158];
    
    Box9f = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box9f.anchorPoint = ccp(0,0);
    [self addChild:Box9f z:119 tag:159];
    
    
    Box1g = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box1g.anchorPoint = ccp(0,0);
    [self addChild:Box1g z:101 tag:161];
    
    Box2g = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box2g.anchorPoint = ccp(0,0);
    [self addChild:Box2g z:102 tag:162];
    
    Box3g = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box3g.anchorPoint = ccp(0,0);
    [self addChild:Box3g z:103 tag:163];
    
    Box4g = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box4g.anchorPoint = ccp(0,0);
    [self addChild:Box4g z:104 tag:164];
    
    Box5g = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box5g.anchorPoint = ccp(0,0);
    [self addChild:Box5g z:105 tag:165];
    
    Box6g = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box6g.anchorPoint = ccp(0,0);
    [self addChild:Box6g z:106 tag:166];
    
    Box7g = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box7g.anchorPoint = ccp(0,0);
    [self addChild:Box7g z:107 tag:167];
    
    Box8g = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box8g.anchorPoint = ccp(0,0);
    [self addChild:Box8g z:108 tag:168];

    Box9g = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box9g.anchorPoint = ccp(0,0);
    [self addChild:Box9g z:109 tag:169];
    
    
    
    
    Box1h = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box1h.anchorPoint = ccp(0,0);
    [self addChild:Box1h z:111 tag:171];
    
    Box2h = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box2h.anchorPoint = ccp(0,0);
    [self addChild:Box2h z:112 tag:172];
    
    Box3h = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box3h.anchorPoint = ccp(0,0);
    [self addChild:Box3h z:113 tag:173];
    
    Box4h = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box4h.anchorPoint = ccp(0,0);
    [self addChild:Box4h z:114 tag:174];
    
    Box5h = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box5h.anchorPoint = ccp(0,0);
    [self addChild:Box5h z:115 tag:175];
    
    Box6h = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box6h.anchorPoint = ccp(0,0);
    [self addChild:Box6h z:116 tag:176];
    
    Box7h = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box7h.anchorPoint = ccp(0,0);
    [self addChild:Box7h z:117 tag:177];
    
    Box8h = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box8h.anchorPoint = ccp(0,0);
    [self addChild:Box8h z:118 tag:178];
    
    Box9h = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box9h.anchorPoint = ccp(0,0);
    [self addChild:Box9h z:119 tag:179];
    
    
    Box1i = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box1i.anchorPoint = ccp(0,0);
    [self addChild:Box1i z:101 tag:181];
    
    Box2i = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box2i.anchorPoint = ccp(0,0);
    [self addChild:Box2i z:102 tag:182];
    
    Box3i = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box3i.anchorPoint = ccp(0,0);
    [self addChild:Box3i z:103 tag:183];
    
    Box4i = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box4i.anchorPoint = ccp(0,0);
    [self addChild:Box4i z:104 tag:184];
    
    Box5i = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box5i.anchorPoint = ccp(0,0);
    [self addChild:Box5i z:105 tag:185];
    
    Box6i = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box6i.anchorPoint = ccp(0,0);
    [self addChild:Box6i z:106 tag:186];
    
    Box7i = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box7i.anchorPoint = ccp(0,0);
    [self addChild:Box7i z:107 tag:187];
    
    Box8i = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box8i.anchorPoint = ccp(0,0);
    [self addChild:Box8i z:108 tag:188];
    
    Box9i = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box9i.anchorPoint = ccp(0,0);
    [self addChild:Box9i z:109 tag:189];
    
    
    
    
    Box1j = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box1j.anchorPoint = ccp(0,0);
    [self addChild:Box1j z:111 tag:191];
    
    Box2j = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box2j.anchorPoint = ccp(0,0);
    [self addChild:Box2j z:112 tag:192];
    
    Box3j = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box3j.anchorPoint = ccp(0,0);
    [self addChild:Box3j z:113 tag:193];
    
    Box4j = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box4j.anchorPoint = ccp(0,0);
    [self addChild:Box4j z:114 tag:194];
    
    Box5j = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box5j.anchorPoint = ccp(0,0);
    [self addChild:Box5j z:115 tag:195];
    
    Box6j = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box6j.anchorPoint = ccp(0,0);
    [self addChild:Box6j z:116 tag:196];
    
    Box7j = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box7j.anchorPoint = ccp(0,0);
    [self addChild:Box7j z:117 tag:197];
    
    Box8j = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box8j.anchorPoint = ccp(0,0);
    [self addChild:Box8j z:118 tag:198];
    
    Box9j = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box9j.anchorPoint = ccp(0,0);
    [self addChild:Box9j z:119 tag:199];
    
    
    Box1k = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box1k.anchorPoint = ccp(0,0);
    [self addChild:Box1k z:101 tag:201];
    
    Box2k = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box2k.anchorPoint = ccp(0,0);
    [self addChild:Box2k z:102 tag:202];
    
    Box3k = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box3k.anchorPoint = ccp(0,0);
    [self addChild:Box3k z:103 tag:203];
    
    Box4k = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box4k.anchorPoint = ccp(0,0);
    [self addChild:Box4k z:104 tag:204];
    
    Box5k = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box5k.anchorPoint = ccp(0,0);
    [self addChild:Box5k z:105 tag:205];
    
    Box6k = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box6k.anchorPoint = ccp(0,0);
    [self addChild:Box6k z:106 tag:206];
    
    Box7k = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box7k.anchorPoint = ccp(0,0);
    [self addChild:Box7k z:107 tag:207];
    
    Box8k = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box8k.anchorPoint = ccp(0,0);
    [self addChild:Box8k z:108 tag:208];
    
    Box9k = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box9k.anchorPoint = ccp(0,0);
    [self addChild:Box9k z:109 tag:209];
    
    
    
    
    Box1l = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box1l.anchorPoint = ccp(0,0);
    [self addChild:Box1l z:111 tag:211];
    
    Box2l = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box2l.anchorPoint = ccp(0,0);
    [self addChild:Box2l z:112 tag:212];
    
    Box3l = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box3l.anchorPoint = ccp(0,0);
    [self addChild:Box3l z:113 tag:213];
    
    Box4l = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box4l.anchorPoint = ccp(0,0);
    [self addChild:Box4l z:114 tag:214];
    
    Box5l = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box5l.anchorPoint = ccp(0,0);
    [self addChild:Box5l z:115 tag:215];
    
    Box6l = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box6l.anchorPoint = ccp(0,0);
    [self addChild:Box6l z:116 tag:216];
    
    Box7l = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box7l.anchorPoint = ccp(0,0);
    [self addChild:Box7l z:117 tag:217];
    
    Box8l = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box8l.anchorPoint = ccp(0,0);
    [self addChild:Box8l z:118 tag:218];
    
    Box9l = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box9l.anchorPoint = ccp(0,0);
    [self addChild:Box9l z:119 tag:219];
    
    
    Box1m = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box1m.anchorPoint = ccp(0,0);
    [self addChild:Box1m z:101 tag:221];
    
    Box2m = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box2m.anchorPoint = ccp(0,0);
    [self addChild:Box2m z:102 tag:222];
    
    Box3m = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box3m.anchorPoint = ccp(0,0);
    [self addChild:Box3m z:103 tag:223];
    
    Box4m = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box4m.anchorPoint = ccp(0,0);
    [self addChild:Box4m z:104 tag:224];
    
    Box5m = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box5m.anchorPoint = ccp(0,0);
    [self addChild:Box5m z:105 tag:225];
    
    Box6m = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box6m.anchorPoint = ccp(0,0);
    [self addChild:Box6m z:106 tag:226];
    
    Box7m = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box7m.anchorPoint = ccp(0,0);
    [self addChild:Box7m z:107 tag:227];
    
    Box8m = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box8m.anchorPoint = ccp(0,0);
    [self addChild:Box8m z:108 tag:228];
    
    Box9m = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box9m.anchorPoint = ccp(0,0);
    [self addChild:Box9m z:109 tag:229];
    
    
    
    
    Box1n = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box1n.anchorPoint = ccp(0,0);
    [self addChild:Box1n z:111 tag:231];
    
    Box2n = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box2n.anchorPoint = ccp(0,0);
    [self addChild:Box2n z:112 tag:232];
    
    Box3n = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box3n.anchorPoint = ccp(0,0);
    [self addChild:Box3n z:113 tag:233];
    
    Box4n = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box4n.anchorPoint = ccp(0,0);
    [self addChild:Box4n z:114 tag:234];
    
    Box5n = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box5n.anchorPoint = ccp(0,0);
    [self addChild:Box5n z:115 tag:235];
    
    Box6n = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box6n.anchorPoint = ccp(0,0);
    [self addChild:Box6n z:116 tag:236];
    
    Box7n = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box7n.anchorPoint = ccp(0,0);
    [self addChild:Box7n z:117 tag:237];
    
    Box8n = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box8n.anchorPoint = ccp(0,0);
    [self addChild:Box8n z:118 tag:238];
    
    Box9n = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box9n.anchorPoint = ccp(0,0);
    [self addChild:Box9n z:119 tag:239];
    
    
    Box1o = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box1o.anchorPoint = ccp(0,0);
    [self addChild:Box1o z:101 tag:241];
    
    Box2o = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box2o.anchorPoint = ccp(0,0);
    [self addChild:Box2o z:102 tag:242];
    
    Box3o = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box3o.anchorPoint = ccp(0,0);
    [self addChild:Box3o z:103 tag:243];
    
    Box4o = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box4o.anchorPoint = ccp(0,0);
    [self addChild:Box4o z:104 tag:244];
    
    Box5o = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box5o.anchorPoint = ccp(0,0);
    [self addChild:Box5o z:105 tag:245];
    
    Box6o = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box6o.anchorPoint = ccp(0,0);
    [self addChild:Box6o z:106 tag:246];
    
    Box7o = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box7o.anchorPoint = ccp(0,0);
    [self addChild:Box7o z:107 tag:247];
    
    Box8o = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box8o.anchorPoint = ccp(0,0);
    [self addChild:Box8o z:108 tag:248];
    
    Box9o = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    Box9o.anchorPoint = ccp(0,0);
    [self addChild:Box9o z:109 tag:249];
    
    
    //Current Piece:  use strCurrentTestPiece for now
    //CCSprite *currentP1;
    //CCSprite *currentP2;
    //CCSprite *currentP3;
    //CCSprite *currentP4;
    //CCSprite *currentP5;
    //CCSprite *currentP6;
    //CCSprite *currentP7;
    //CCSprite *currentP8;
    //CCSprite *currentP9;
    
    currentP1 = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    currentP1.anchorPoint = ccp(0,0);
    [self addChild:currentP1 z:201 tag:301];
    
    currentP2 = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    currentP2.anchorPoint = ccp(0,0);
    [self addChild:currentP2 z:202 tag:302];
    
    currentP3 = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    currentP3.anchorPoint = ccp(0,0);
    [self addChild:currentP3 z:203 tag:303];
    
    currentP4 = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    currentP4.anchorPoint = ccp(0,0);
    [self addChild:currentP4 z:204 tag:304];
    
    currentP5 = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    currentP5.anchorPoint = ccp(0,0);
    [self addChild:currentP5 z:205 tag:305];
    
    currentP6 = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    currentP6.anchorPoint = ccp(0,0);
    [self addChild:currentP6 z:206 tag:306];
    
    currentP7 = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    currentP7.anchorPoint = ccp(0,0);
    [self addChild:currentP7 z:207 tag:307];
    
    currentP8 = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    currentP8.anchorPoint = ccp(0,0);
    [self addChild:currentP8 z:208 tag:308];
    
    currentP9 = [CCSprite spriteWithSpriteFrameName:strCurrentBlankDefaultPiece];
    currentP9.anchorPoint = ccp(0,0);
    [self addChild:currentP9 z:209 tag:309];
    
    
    //    currentP1 = [CCSprite spriteWithSpriteFrameName:strCurrentTestPiece];
    //    currentP1.anchorPoint = ccp(0,0);
    //    [self addChild:currentP1 z:201 tag:301];
    
    // CCSprite *currentN1;

    currentN1 = [CCSprite spriteWithSpriteFrameName:strPieceName003];
    currentN1.anchorPoint = ccp(0,0);
    [self addChild:currentN1 z:211 tag:311];
    
    currentN2 = [CCSprite spriteWithSpriteFrameName:strPieceName003];
    currentN2.anchorPoint = ccp(0,0);
    [self addChild:currentN2 z:212 tag:312];
    
    currentN3 = [CCSprite spriteWithSpriteFrameName:strPieceName003];
    currentN3.anchorPoint = ccp(0,0);
    [self addChild:currentN3 z:213 tag:313];

    currentN4 = [CCSprite spriteWithSpriteFrameName:strPieceName003];
    currentN4.anchorPoint = ccp(0,0);
    [self addChild:currentN4 z:214 tag:314];
    
    currentN5 = [CCSprite spriteWithSpriteFrameName:strPieceName003];
    currentN5.anchorPoint = ccp(0,0);
    [self addChild:currentN5 z:215 tag:315];
    
    currentN6 = [CCSprite spriteWithSpriteFrameName:strPieceName003];
    currentN6.anchorPoint = ccp(0,0);
    [self addChild:currentN6 z:216 tag:316];
    
    currentN7 = [CCSprite spriteWithSpriteFrameName:strPieceName003];
    currentN7.anchorPoint = ccp(0,0);
    [self addChild:currentN7 z:217 tag:317];
    
    currentN8 = [CCSprite spriteWithSpriteFrameName:strPieceName003];
    currentN8.anchorPoint = ccp(0,0);
    [self addChild:currentN8 z:218 tag:318];
    
    currentN9 = [CCSprite spriteWithSpriteFrameName:strPieceName003];
    currentN9.anchorPoint = ccp(0,0);
    [self addChild:currentN9 z:219 tag:319];
    
    
    
    
    
    
    
    
    
    NSLog(@"Size of Frame Cache %@", frameCacheMain.description);  //ize of Frame Cache <CCSpriteFrameCache = 0x81b5060 | num of sprite frames =  12>
    
    
    
    
    
    
    
    //***** ANIMATION CODE:
    // more code for sprite tests at navCallback5
    
    
    
    //    //game pieces:
    //    //Box1a
    //    Box1a = [CCSprite spriteWithFile:@"piece_mstr_001.png"];
    //    Box1a.tag = 101;
    //    [self addChild:Box1a z:101];
    //    Box1a.anchorPoint = ccp(0,0);
    //
    //    //Box2a
    //    Box2a = [CCSprite spriteWithFile:@"piece_mstr_002.png"];
    //    Box2a.tag = 102;
    //    [self addChild:Box2a z:102];
    //    Box2a.anchorPoint = ccp(0,0);
    
    
    
    
    //*****works ok for one sprite...
    //    Box3a = [CCSprite spriteWithFile:@"pieces001texture.png" rect:CGRectMake(0,0,23,23)];
    //	[self addChild:Box3a z:103];
    //
    //    Box3a.position = ccp( 200, 200);
    
    
    
    
    //*****WORKS GOOD FOR FLIPPING FRAMES:
    //do like abive but add frame and calc sizes.  then show frame on tap
    //    CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    //    [frameCache addSpriteFramesWithFile:@"pieces001texture.plist"];
    
    //strCurrentBlankDefaultPiece
    
    //Box3a = [CCSprite spriteWithSpriteFrameName:@"piece_mstr_008.png"];
    
    
    
    //*****this calls a new image from anim and display it:
    //    CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    //    //        CCSpriteFrame* frame = [frameCache spriteFrameByName:@"new_image.png"];
    //    CCSpriteFrame* frame = [frameCache spriteFrameByName:@"piece_mstr_009.png"];
    //    [Box3a setDisplayFrame:frame];
    
    
    //    CCSpriteFrameCache *frameCacheMain;
    //    CCSpriteFrame *spriteFrameMain;
    //    NSMutableArray *animationFramesMain = nil;   //=12
    
    
    
//    Box5a = [CCSprite spriteWithSpriteFrameName:@"piece_mstr_012.png"];
//    Box5a.position = CGPointMake(230, 230);
//    [self addChild:Box5a z:105 tag:105];
    
    
//    CCSpriteFrame *spriteFrame;
//    NSMutableArray *animationFrames = [NSMutableArray arrayWithCapacity:5];
//    
//    animationFrames = [NSMutableArray arrayWithCapacity:5];
//    
//    spriteFrame = [frameCache spriteFrameByName:@"piece_mstr_002.png"];
//    [animationFrames addObject:spriteFrame];
//    
//    spriteFrame = [frameCache spriteFrameByName:@"piece_mstr_003.png"];
//    [animationFrames addObject:spriteFrame];
//    
//    spriteFrame = [frameCache spriteFrameByName:@"piece_mstr_004.png"];
//    [animationFrames addObject:spriteFrame];
    
    
    
   // ** MASTER: ANIMATION METHOD:
//    Box1a
//    
//    
//    CCSprite *mega = [CCSprite spriteWithFile:@"piece_mstr_007.png"];
//    mega.position = ccp(10.0f, 50.0f);
//    [self addChild: mega z:104];
//    
//    //try: addFrame:(CCSpriteFrame*)frame    instead of animwithframes    CCAnimation methodes
//    
//    CCAnimation *animation = [CCAnimation animationWithFrames:animationFramesMain delay:0.05f];
//    CCAnimate *animate = [CCAnimate actionWithAnimation:animation];
//    CCRepeatForever *repeat = [CCRepeatForever actionWithAction:animate];
//    
//    CCAction *moveAction = [CCMoveBy actionWithDuration:2.0f position:CGPointMake(100.0f,0.0f)];
//    
//    [mega runAction:repeat];
//    [mega runAction:moveAction];
//    
    

    //*****end of sprite and anim tests
    
 
    
    //PIECES ALREADY LOADED
    
    
    
    //BG image:
    miner=[CCSprite spriteWithFile:@"bg1050_1050.png"];
    [self addChild:miner];
    
    
    
    //game board:
    //none, iphone (hd), ipad (hd), ipad ret (ultra hd)
    if (inttypeOfHD > 2) {
        fieldbg=[CCSprite spriteWithFile:@"backboard_924.png"];              //924 1260
        fieldbgDisp=[CCSprite spriteWithFile:@"backboard_1000_001.png"];	//1000 1356 
        
    } else if ((inttypeOfHD == 1) || (inttypeOfHD == 2)) {
        fieldbg=[CCSprite spriteWithFile:@"backboard_462.png"];
        fieldbgDisp=[CCSprite spriteWithFile:@"backboard_500_001.png"];
    
    } else {
        fieldbg=[CCSprite spriteWithFile:@"backboard_231_315.png"];
        fieldbgDisp=[CCSprite spriteWithFile:@"backboard_250_001.png"];
    
    }
    
	//background of playing field plus the DISPLAYED background... add border to see trans.
    [self addChild:fieldbg];
    [self addChild:fieldbgDisp];
    

    
    //SELECT REZ BUTTONS:
    if (inttypeOfHD == 0) {
		//no changes
        
	} else if ((inttypeOfHD == 1) || (inttypeOfHD == 2)) {
		//[strDeviceSpriteFilename setString:@"piece_hdtex.plist"];
        
        [strTopButtonFileNormal setString:@"top_button_176.png"];
        [strTopButtonFileSelect setString:@"top_button_176_selected.png"];
        [strTopButtonFileDisable setString:@"top_button_176_disabled.png"];
        [strBottomButtonFileNormal setString:@"bottom_button_176.png"];
        [strBottomButtonFileSelect setString:@"bottom_button_176_selected.png"];
        [strBottomButtonFileDisable setString:@"bottom_button_176_disabled.png"];
        [strLeftButtonFileNormal setString:@"left_button_180.png"];
        [strLeftButtonFileSelect setString:@"left_button_180_selected.png"];
        [strLeftButtonFileDisable setString:@"left_button_180_disabled.png"];
        [strRightButtonFileNormal setString:@"right_button_180.png"];
        [strRightButtonFileSelect setString:@"right_button_180_selected.png"];
        [strRightButtonFileDisable setString:@"right_button_180_disabled.png"];
        [strSwitchFileNormal setString:@"switchkb_122.png"];
        [strSwitchFileSelect setString:@"switchkb_122_selected.png"];
        [strSwitchFileDisable setString:@"switchkb_122_disabled.png"];
        [strPauseFileNormal setString:@"pausebtn_normal_115.png"];
        [strPauseFileSelect setString:@"pausebtn_enabled_115.png"];
        [strPauseFileDisable setString:@"pausebtn_disabled_115.png"];
        
        
	} else {
		//[strDeviceSpriteFilename setString:@"piece_uhdtex.plist"];
        
        [strTopButtonFileNormal setString:@"top_button_352.png"];
        [strTopButtonFileSelect setString:@"top_button_352_selected.png"];
        [strTopButtonFileDisable setString:@"top_button_352_disabled.png"];
        [strBottomButtonFileNormal setString:@"bottom_button_352.png"];
        [strBottomButtonFileSelect setString:@"bottom_button_352_selected.png"];
        [strBottomButtonFileDisable setString:@"bottom_button_352_disabled.png"];
        [strLeftButtonFileNormal setString:@"left_button_360.png"];
        [strLeftButtonFileSelect setString:@"left_button_360_selected.png"];
        [strLeftButtonFileDisable setString:@"left_button_360_disabled.png"];
        [strRightButtonFileNormal setString:@"right_button_360.png"];
        [strRightButtonFileSelect setString:@"right_button_360_selected.png"];
        [strRightButtonFileDisable setString:@"right_button_360_disabled.png"];
        [strSwitchFileNormal setString:@"switchkb_244.png"];
        [strSwitchFileSelect setString:@"switchkb_244_selected.png"];
        [strSwitchFileDisable setString:@"switchkb_244_disabled.png"];
        [strPauseFileNormal setString:@"pausebtn_normal_230.png"];
        [strPauseFileSelect setString:@"pausebtn_enabled_230.png"];
        [strPauseFileDisable setString:@"pausebtn_disabled_230.png"];
        
	}
    
    
    //controls and buttons
    [CCMenuItemFont setFontSize:30];
    [CCMenuItemFont setFontName: @"Courier New"];
    
    CCMenuItem *item1 = [CCMenuItemImage itemFromNormalImage:strTopButtonFileNormal selectedImage:strTopButtonFileSelect disabledImage:strTopButtonFileDisable target:self selector:@selector(navCallback1:)];
    item1.tag = 100;
    CCMenu *menu1 = [CCMenu menuWithItems: item1, nil];
    [menu1 alignItemsVertically];
    menu1.tag = 1;
    [self addChild: menu1 z:55];
    
    
    CCMenuItem *item2 = [CCMenuItemImage itemFromNormalImage:strBottomButtonFileNormal selectedImage:strBottomButtonFileSelect disabledImage:strBottomButtonFileDisable target:self selector:@selector(navCallback2:)];
    item2.tag = 99;
    CCMenu *menu2 = [CCMenu menuWithItems: item2, nil];
    [menu2 alignItemsVertically];
    menu2.tag = 2;
    [self addChild: menu2 z:55];
    
    
    CCMenuItem *item3 = [CCMenuItemImage itemFromNormalImage:strLeftButtonFileNormal selectedImage:strLeftButtonFileSelect disabledImage:strLeftButtonFileDisable target:self selector:@selector(navCallback3:)];
    item3.tag = 90;
    CCMenu *menu3 = [CCMenu menuWithItems: item3, nil];
    [menu3 alignItemsVertically];
    menu3.tag = 3;
    [self addChild: menu3 z:56];
    
    
    CCMenuItem *item4 = [CCMenuItemImage itemFromNormalImage:strRightButtonFileNormal selectedImage:strRightButtonFileSelect disabledImage:strRightButtonFileDisable target:self selector:@selector(navCallback4:)];
    item4.tag = 91;
    CCMenu *menu4 = [CCMenu menuWithItems: item4, nil];
    [menu4 alignItemsVertically];
    menu4.tag = 4;
    [self addChild: menu4 z:56];
    

    CCMenuItem *item5 = [CCMenuItemImage itemFromNormalImage:strSwitchFileNormal selectedImage:strSwitchFileSelect disabledImage:strSwitchFileDisable target:self selector:@selector(navCallback5:)];
    item5.tag = 50;
    CCMenu *menu5 = [CCMenu menuWithItems: item5, nil];
    [menu5 alignItemsVertically];
    menu5.tag = 5;
    [self addChild: menu5 z:96];
    

    CCMenuItem *item6 = [CCMenuItemImage itemFromNormalImage:strPauseFileNormal selectedImage:strPauseFileSelect disabledImage:strPauseFileDisable target:self selector:@selector(navCallback6:)];
    item6.tag = 60;
    CCMenu *menu6 = [CCMenu menuWithItems: item6, nil];
    //[menu6 alignItemsVertically];
    menu6.tag = 6;
    [self addChild: menu6 z:100];
    
    
    
    
    
    //test info button for PAUSE:     //Promo Micro Miners :D   mmenu screen show
    
    if (inttypeOfHD > 2) {
        CCSprite *microminersIcon=[CCSprite spriteWithFile:@"info256_256.png"];
        CCSprite *microminersIconSelected=[CCSprite spriteWithFile:@"info256_256.png"];
        microminersIconSelected.color=ccc3(100, 100, 100);
        CCMenuItem *microminersItem=[CCMenuItemSprite itemFromNormalSprite:microminersIcon selectedSprite:microminersIconSelected target:self selector:@selector(info)];
        microminersItem.positionInPixels=ccp(0,0);
        CCMenu *menu=[CCMenu menuWithItems:microminersItem, nil];
        [self addChild:menu];
        menu.anchorPoint=ccp(microminersIconSelected.contentSizeInPixels.width, -microminersIconSelected.contentSizeInPixels.height);
        menu.positionInPixels=ccp((intScreenWidth - (microminersIconSelected.contentSizeInPixels.width/2)),microminersIconSelected.contentSizeInPixels.height/2);
    } else if ((inttypeOfHD == 1) || (inttypeOfHD == 2)) {
        CCSprite *microminersIcon=[CCSprite spriteWithFile:@"info128_128.png"];
        CCSprite *microminersIconSelected=[CCSprite spriteWithFile:@"info128_128.png"];
        microminersIconSelected.color=ccc3(100, 100, 100);
        CCMenuItem *microminersItem=[CCMenuItemSprite itemFromNormalSprite:microminersIcon selectedSprite:microminersIconSelected target:self selector:@selector(info)];
        microminersItem.positionInPixels=ccp(0,0);
        CCMenu *menu=[CCMenu menuWithItems:microminersItem, nil];
        [self addChild:menu];
        menu.anchorPoint=ccp(microminersIconSelected.contentSizeInPixels.width, -microminersIconSelected.contentSizeInPixels.height);
        menu.positionInPixels=ccp((intScreenWidth - (microminersIconSelected.contentSizeInPixels.width/2)),microminersIconSelected.contentSizeInPixels.height/2);
    } else {
        CCSprite *microminersIcon=[CCSprite spriteWithFile:@"info.png"];
        CCSprite *microminersIconSelected=[CCSprite spriteWithFile:@"info.png"];
        microminersIconSelected.color=ccc3(100, 100, 100);
        CCMenuItem *microminersItem=[CCMenuItemSprite itemFromNormalSprite:microminersIcon selectedSprite:microminersIconSelected target:self selector:@selector(info)];
        microminersItem.positionInPixels=ccp(0,0);
        CCMenu *menu=[CCMenu menuWithItems:microminersItem, nil];
        [self addChild:menu];
        menu.anchorPoint=ccp(microminersIconSelected.contentSizeInPixels.width, -microminersIconSelected.contentSizeInPixels.height);
        menu.positionInPixels=ccp((intScreenWidth - (microminersIconSelected.contentSizeInPixels.width/2)),microminersIconSelected.contentSizeInPixels.height/2);
        //menu.positionInPixels=ccp((intScreenWidth - (microminersIconSelected.contentSizeInPixels.width/2)),0);
        
        
    }
    
    
	//***************************************************************************************************************
    //Once Instantiated, Position Objects for Device and Port/land:
    [self positionObjects];
    
    
    
    
}



//        ______         _ _   _
//        | ___ \       (_) | (_)
//        | |_/ /__  ___ _| |_ _  ___  _ __
//        |  __/ _ \/ __| | __| |/ _ \| '_ \
//        | | | (_) \__ \ | |_| | (_) | | | |
//        \_|  \___/|___/_|\__|_|\___/|_| |_|


//TODO: NEW POSITION OBJECTS:
-(void)positionObjects {
    
    NSLog(@"runs on ORIENT SWITCH & STARTUP!! see below for intGameHasStartedSentinel if switch needed");

	//ADD MORE FOR TV, OTHER NEW DEVICE LAYOUTS:

    
    //TURN BACK ON WITH SCHEDULED ACTION:
    //for now just turn back on:
    if (intSwitchStatus == 1) {
        //..
        intSwitchStatus = 0;
    }
    
    intPlayerCanMove = 0;
    
    
    CGSize size = [[CCDirector sharedDirector] winSizeInPixels];
    CGSize sizer = [[CCDirector sharedDirector] winSize];
    
    intScreenWidth = size.width;
    intScreenMidX = size.width/2;
    
    intScreenHeight = size.height;
    intScreenMidY = size.height/2;
    
    NSLog(@"intScreenWidth: %f intScreenHeight: %f", intScreenWidth, intScreenHeight);
    NSLog(@"intScreenW2:  %f intScreenH2:  %f", sizer.width, sizer.height);
    NSLog(@"intWideMode %f", intWideMode);
    
    if (intScreenHeight < intScreenWidth) {
        intInLandscape = 1;
        intSupposedToBeInPortorLand = 1;
    } else {
        intInLandscape = 0;
        intSupposedToBeInPortorLand = 0;
    }
    

	//locs:                                      PLACEMENT 1
	if (inttypeOfHD == 0) {
		intFirstBoxLocX = 64;           
		intFirstBoxLocY = 438;
		intFirstBoxLocLandX = 240;
		intFirstBoxLocLandY = 296;
	} else if (inttypeOfHD == 1) {
        
        if (intIs4InchScreen == 0) {
            intFirstBoxLocX = 64 *2;            //  iphone hd - 3.5"
            intFirstBoxLocY = 438 *2;
            intFirstBoxLocLandX = 240 *2;
            intFirstBoxLocLandY = 296 *2;
            
        } else {
            intFirstBoxLocX = 64 *2;            //  iphone hd  - 4"
            intFirstBoxLocY = (438 *2) + 109;
            intFirstBoxLocLandX = (240 *2) + 125;
            intFirstBoxLocLandY = 296 *2;
            
        }
        
            
            
	} else if (inttypeOfHD == 2) {    
		intFirstBoxLocX = (64 *2) + 65;             // ipad sd
		intFirstBoxLocY = (438 *2) + 39;
		intFirstBoxLocLandX = (240 *2) +46;
		intFirstBoxLocLandY = (296 *2) +63;
        
        
	} else {
		intFirstBoxLocX = (64 *4) + 132;             // ipad hd
		intFirstBoxLocY = (438 *4) + 77;
		intFirstBoxLocLandX = (240 *4) +94;
		intFirstBoxLocLandY = (296 *4) +122;
	
    }

    
    // GET ALL DEVICE SETTINGS DONE BY HERE.
    
    
    
    //BG Image: scale it at some point, currently unscaled:
    miner.positionInPixels = ccp(intScreenWidth /2 , intScreenHeight /2);

	//probably needs scaling above if:
	//if (inttypeOfHD >= 2) {
	//}
    


    
    
    



    //RUN ONLY ONCE FOR ALL DEVICES:  SET DEFAULT BLANK THEN LOAD FROM GRID
    
    if (intInLandscape == 0) {

        //101-109
        //241-249
        
        
        //a line:
        for (int i = 101; i <= 109 ; ++i) {
            tempBox = (CCSprite*)[self getChildByTag:i];
            tempBox.positionInPixels = ccp(intFirstBoxLocX + (intSizeofPieceWithoutAA*(i-101)), intFirstBoxLocY);
        }
        
        //b line:
        for (int i = 111; i <= 119 ; ++i) {
            tempBox = (CCSprite*)[self getChildByTag:i];
            tempBox.positionInPixels = ccp(intFirstBoxLocX + (intSizeofPieceWithoutAA*(i-111)), intFirstBoxLocY - (intSizeofPieceWithoutAA*1));
        }
        
        //c line:
        for (int i = 121; i <= 129 ; ++i) {
            tempBox = (CCSprite*)[self getChildByTag:i];
            tempBox.positionInPixels = ccp(intFirstBoxLocX + (intSizeofPieceWithoutAA*(i-121)), intFirstBoxLocY - (intSizeofPieceWithoutAA*2));
        }
        
        for (int i = 131; i <= 139 ; ++i) {
            tempBox = (CCSprite*)[self getChildByTag:i];
            tempBox.positionInPixels = ccp(intFirstBoxLocX + (intSizeofPieceWithoutAA*(i-131)), intFirstBoxLocY - (intSizeofPieceWithoutAA*3));
        }
        
        for (int i = 141; i <= 149 ; ++i) {
            tempBox = (CCSprite*)[self getChildByTag:i];
            tempBox.positionInPixels = ccp(intFirstBoxLocX + (intSizeofPieceWithoutAA*(i-141)), intFirstBoxLocY - (intSizeofPieceWithoutAA*4));
        }
        
        for (int i = 151; i <= 159 ; ++i) {
            tempBox = (CCSprite*)[self getChildByTag:i];
            tempBox.positionInPixels = ccp(intFirstBoxLocX + (intSizeofPieceWithoutAA*(i-151)), intFirstBoxLocY - (intSizeofPieceWithoutAA*5));
        }
        
        for (int i = 161; i <= 169 ; ++i) {
            tempBox = (CCSprite*)[self getChildByTag:i];
            tempBox.positionInPixels = ccp(intFirstBoxLocX + (intSizeofPieceWithoutAA*(i-161)), intFirstBoxLocY - (intSizeofPieceWithoutAA*6));
        }
        
        for (int i = 171; i <= 179 ; ++i) {
            tempBox = (CCSprite*)[self getChildByTag:i];
            tempBox.positionInPixels = ccp(intFirstBoxLocX + (intSizeofPieceWithoutAA*(i-171)), intFirstBoxLocY - (intSizeofPieceWithoutAA*7));
        }
        
        for (int i = 181; i <= 189 ; ++i) {
            tempBox = (CCSprite*)[self getChildByTag:i];
            tempBox.positionInPixels = ccp(intFirstBoxLocX + (intSizeofPieceWithoutAA*(i-181)), intFirstBoxLocY - (intSizeofPieceWithoutAA*8));
        }
        
        for (int i = 191; i <= 199 ; ++i) {
            tempBox = (CCSprite*)[self getChildByTag:i];
            tempBox.positionInPixels = ccp(intFirstBoxLocX + (intSizeofPieceWithoutAA*(i-191)), intFirstBoxLocY - (intSizeofPieceWithoutAA*9));
        }
        
        for (int i = 201; i <= 209 ; ++i) {
            tempBox = (CCSprite*)[self getChildByTag:i];
            tempBox.positionInPixels = ccp(intFirstBoxLocX + (intSizeofPieceWithoutAA*(i-201)), intFirstBoxLocY - (intSizeofPieceWithoutAA*10));
        }
        
        for (int i = 211; i <= 219 ; ++i) {
            tempBox = (CCSprite*)[self getChildByTag:i];
            tempBox.positionInPixels = ccp(intFirstBoxLocX + (intSizeofPieceWithoutAA*(i-211)), intFirstBoxLocY - (intSizeofPieceWithoutAA*11));
        }
        
        for (int i = 221; i <= 229 ; ++i) {
            tempBox = (CCSprite*)[self getChildByTag:i];
            tempBox.positionInPixels = ccp(intFirstBoxLocX + (intSizeofPieceWithoutAA*(i-221)), intFirstBoxLocY - (intSizeofPieceWithoutAA*12));
        }
        
        for (int i = 231; i <= 239 ; ++i) {
            tempBox = (CCSprite*)[self getChildByTag:i];
            tempBox.positionInPixels = ccp(intFirstBoxLocX + (intSizeofPieceWithoutAA*(i-231)), intFirstBoxLocY - (intSizeofPieceWithoutAA*13));
        }
        
        for (int i = 241; i <= 249 ; ++i) {
            tempBox = (CCSprite*)[self getChildByTag:i];
            tempBox.positionInPixels = ccp(intFirstBoxLocX + (intSizeofPieceWithoutAA*(i-241)), intFirstBoxLocY - (intSizeofPieceWithoutAA*14));
        }
        
        
        
    } else {
        
        for (int i = 101; i <= 109 ; ++i) {
            tempBox = (CCSprite*)[self getChildByTag:i];
            tempBox.positionInPixels = ccp(intFirstBoxLocLandX + (intSizeofPieceWithoutAA*(i-101)), intFirstBoxLocLandY);
        }
        
        for (int i = 111; i <= 119 ; ++i) {
            tempBox = (CCSprite*)[self getChildByTag:i];
            tempBox.positionInPixels = ccp(intFirstBoxLocLandX + (intSizeofPieceWithoutAA*(i-111)), intFirstBoxLocLandY - (intSizeofPieceWithoutAA*1));
        }
        
        for (int i = 121; i <= 129 ; ++i) {
            tempBox = (CCSprite*)[self getChildByTag:i];
            tempBox.positionInPixels = ccp(intFirstBoxLocLandX + (intSizeofPieceWithoutAA*(i-121)), intFirstBoxLocLandY - (intSizeofPieceWithoutAA*2));
        }
        
        for (int i = 131; i <= 139 ; ++i) {
            tempBox = (CCSprite*)[self getChildByTag:i];
            tempBox.positionInPixels = ccp(intFirstBoxLocLandX + (intSizeofPieceWithoutAA*(i-131)), intFirstBoxLocLandY - (intSizeofPieceWithoutAA*3));
        }
        
        for (int i = 141; i <= 149 ; ++i) {
            tempBox = (CCSprite*)[self getChildByTag:i];
            tempBox.positionInPixels = ccp(intFirstBoxLocLandX + (intSizeofPieceWithoutAA*(i-141)), intFirstBoxLocLandY - (intSizeofPieceWithoutAA*4));
        }
        
        for (int i = 151; i <= 159 ; ++i) {
            tempBox = (CCSprite*)[self getChildByTag:i];
            tempBox.positionInPixels = ccp(intFirstBoxLocLandX + (intSizeofPieceWithoutAA*(i-151)), intFirstBoxLocLandY - (intSizeofPieceWithoutAA*5));
        }
        
        for (int i = 161; i <= 169 ; ++i) {
            tempBox = (CCSprite*)[self getChildByTag:i];
            tempBox.positionInPixels = ccp(intFirstBoxLocLandX + (intSizeofPieceWithoutAA*(i-161)), intFirstBoxLocLandY - (intSizeofPieceWithoutAA*6));
        }
        
        for (int i = 171; i <= 179 ; ++i) {
            tempBox = (CCSprite*)[self getChildByTag:i];
            tempBox.positionInPixels = ccp(intFirstBoxLocLandX + (intSizeofPieceWithoutAA*(i-171)), intFirstBoxLocLandY - (intSizeofPieceWithoutAA*7));
        }
        
        for (int i = 181; i <= 189 ; ++i) {
            tempBox = (CCSprite*)[self getChildByTag:i];
            tempBox.positionInPixels = ccp(intFirstBoxLocLandX + (intSizeofPieceWithoutAA*(i-181)), intFirstBoxLocLandY - (intSizeofPieceWithoutAA*8));
        }
        
        for (int i = 191; i <= 199 ; ++i) {
            tempBox = (CCSprite*)[self getChildByTag:i];
            tempBox.positionInPixels = ccp(intFirstBoxLocLandX + (intSizeofPieceWithoutAA*(i-191)), intFirstBoxLocLandY - (intSizeofPieceWithoutAA*9));
        }
        
        for (int i = 201; i <= 209 ; ++i) {
            tempBox = (CCSprite*)[self getChildByTag:i];
            tempBox.positionInPixels = ccp(intFirstBoxLocLandX + (intSizeofPieceWithoutAA*(i-201)), intFirstBoxLocLandY - (intSizeofPieceWithoutAA*10));
        }
        
        for (int i = 211; i <= 219 ; ++i) {
            tempBox = (CCSprite*)[self getChildByTag:i];
            tempBox.positionInPixels = ccp(intFirstBoxLocLandX + (intSizeofPieceWithoutAA*(i-211)), intFirstBoxLocLandY - (intSizeofPieceWithoutAA*11));
        }
        
        for (int i = 221; i <= 229 ; ++i) {
            tempBox = (CCSprite*)[self getChildByTag:i];
            tempBox.positionInPixels = ccp(intFirstBoxLocLandX + (intSizeofPieceWithoutAA*(i-221)), intFirstBoxLocLandY - (intSizeofPieceWithoutAA*12));
        }
        
        for (int i = 231; i <= 239 ; ++i) {
            tempBox = (CCSprite*)[self getChildByTag:i];
            tempBox.positionInPixels = ccp(intFirstBoxLocLandX + (intSizeofPieceWithoutAA*(i-231)), intFirstBoxLocLandY - (intSizeofPieceWithoutAA*13));
        }
        
        for (int i = 241; i <= 249 ; ++i) {
            tempBox = (CCSprite*)[self getChildByTag:i];
            tempBox.positionInPixels = ccp(intFirstBoxLocLandX + (intSizeofPieceWithoutAA*(i-241)), intFirstBoxLocLandY - (intSizeofPieceWithoutAA*14));
        }

        
        
    }
    

    
    //game board:                    PLACEMENT 2
    if (inttypeOfHD >= 3) {
        
            //TEST:
            intFieldBGTop_Device = intScreenHeight /2 + (intScreenHeight*0.13);
            intFieldBGLeft_Device = intScreenWidth/2;
            intButtonsTop_Device = intScreenMidY*0.51f;
            intButtonsLeft_Device = intScreenMidX;
            
            intFieldBGTop_DeviceLand = intScreenHeight /2;
            intFieldBGLeft_DeviceLand = (intScreenWidth/2) + (intScreenWidth /5);
            intButtonsTop_DeviceLand = (size.height/2) + (size.height/7);
            intButtonsLeft_DeviceLand = (intScreenWidth /2)  -  (intScreenWidth /3.5f);
            
            ////top middle:
            //intMenuSwitchLeft_Device = (intScreenWidth - (intScreenWidth*0.6f))
            //intMenuSwitchTop_Device = (intScreenHeight - (intScreenHeight*0.35f)
            // bottom left:
            intMenuSwitchLeft_DeviceLand = (intScreenWidth*0.08f);
            intMenuSwitchTop_DeviceLand = (intScreenHeight*0.05f);
        
    } else if (inttypeOfHD == 2) {
 
            //TESTED OK for first button: (CHECK OTHERS: otherButtons)
            intFieldBGTop_Device = intScreenHeight /2 + (intScreenHeight*0.13);
            intFieldBGLeft_Device = intScreenWidth/2;
        
            //HANDHELD portrait iPAD:
            intButtonsTop_Device = intScreenMidY*0.51f;
            intButtonsLeft_Device = intScreenMidX/2;
            
            intFieldBGTop_DeviceLand = intScreenHeight /2;
            intFieldBGLeft_DeviceLand = (intScreenWidth/2) + (intScreenWidth /5);
        
            //missing:
            //        intMenuSwitchLeft_Device = ff;
            //        intMenuSwitchTop_DeviceLand = ff;
        
            //HANDHELD landscape iPAD:  TESTED OK
            intButtonsTop_DeviceLand = ((size.height/2) + (size.height/7))/1.7;      //response OK
            intButtonsLeft_DeviceLand = (intScreenWidth /2)  -  (intScreenWidth /3.5f);
            
            ////top middle:
            //intMenuSwitchLeft_Device = (intScreenWidth - (intScreenWidth*0.6f))
            //intMenuSwitchTop_Device = (intScreenHeight - (intScreenHeight*0.35f)
        
        // top left:
            intMenuSwitchLeft_DeviceLand = (intScreenWidth*0.08f);
            //intMenuSwitchTop_DeviceLand = (intScreenHeight*0.05f);
            intMenuSwitchTop_DeviceLand = intScreenHeight - 50;         //ok
        
        
    } else if (inttypeOfHD == 1) {
    
            //TESTED OK: (3.5 and 4 inch)
            intFieldBGTop_Device = intScreenHeight /2 + (intScreenHeight*0.13);
            intFieldBGLeft_Device = intScreenWidth/2;
            intButtonsTop_Device = intScreenMidY*0.51f;
            intButtonsLeft_Device = intScreenMidX;
            
            intFieldBGTop_DeviceLand = intScreenHeight /2;
            intFieldBGLeft_DeviceLand = (intScreenWidth/2) + (intScreenWidth /5);
            intButtonsTop_DeviceLand = (size.height/2) + (size.height/7);
            intButtonsLeft_DeviceLand = (intScreenWidth /2)  -  (intScreenWidth /3.5f);
            
            ////top middle:
            //intMenuSwitchLeft_Device = (intScreenWidth - (intScreenWidth*0.6f))
            //intMenuSwitchTop_Device = (intScreenHeight - (intScreenHeight*0.35f)
            // bottom left:
            intMenuSwitchLeft_DeviceLand = (intScreenWidth*0.08f);
            intMenuSwitchTop_DeviceLand = (intScreenHeight*0.05f);
        
    } else {

            //TeSTED OK!
            intFieldBGTop_Device = intScreenHeight /2 + (intScreenHeight*0.13);
            intFieldBGLeft_Device = intScreenWidth/2;
            intButtonsTop_Device = intScreenMidY*0.51f;
            intButtonsLeft_Device = intScreenMidX;
        
            intFieldBGTop_DeviceLand = intScreenHeight /2;
            intFieldBGLeft_DeviceLand = (intScreenWidth/2) + (intScreenWidth /5);
            intButtonsTop_DeviceLand = (size.height/2) + (size.height/7);
            intButtonsLeft_DeviceLand = (intScreenWidth /2)  -  (intScreenWidth /3.5f);
            
            ////top middle:
            //intMenuSwitchLeft_Device = (intScreenWidth - (intScreenWidth*0.6f))
            //intMenuSwitchTop_Device = (intScreenHeight - (intScreenHeight*0.35f)
            // bottom left:
            intMenuSwitchLeft_DeviceLand = (intScreenWidth*0.08f);
            intMenuSwitchTop_DeviceLand = (intScreenHeight*0.05f);
            
    
    }
    
    
    //Select Objects:
    CCMenu *menu1 = (CCMenu*)[self getChildByTag:1];
    CCMenu *menu2 = (CCMenu*)[self getChildByTag:2];
    CCMenu *menu3 = (CCMenu*)[self getChildByTag:3];
    CCMenu *menu4 = (CCMenu*)[self getChildByTag:4];
    CCMenu *menu5 = (CCMenu*)[self getChildByTag:5];
    CCMenu *menu6 = (CCMenu*)[self getChildByTag:6];

    //ready to be disabled:
    //    CCMenuItem *item01 = (CCMenuItem *)[(CCMenu *)[self getChildByTag:1] getChildByTag:100];
    //    CCMenuItem *item02 = (CCMenuItem *)[(CCMenu *)[self getChildByTag:2] getChildByTag:99];
    //    CCMenuItem *item03 = (CCMenuItem *)[(CCMenu *)[self getChildByTag:3] getChildByTag:90];
    //    CCMenuItem *item04 = (CCMenuItem *)[(CCMenu *)[self getChildByTag:4] getChildByTag:91];
    //    CCMenuItem *item05 = (CCMenuItem *)[(CCMenu *)[self getChildByTag:5] getChildByTag:50];

    
    //** USE SIZE OF BUTTONS, NOT 101, 50, etc.
    
    
        if (inttypeOfHD >= 3) {
            
            if (intInLandscape == 0) {
                NSLog(@"SHOWING PORTRAIT - iPad High (UHD)");
                
                fieldbg.positionInPixels = ccp(intScreenWidth /2 , intFieldBGTop_Device);
                fieldbgDisp.positionInPixels = ccp(intScreenWidth /2 , intFieldBGTop_Device);
                
                menu1.positionInPixels = (ccp(intScreenMidX-345,intButtonsTop_Device+10));
                menu2.positionInPixels = (ccp(intScreenMidX-345,intButtonsTop_Device-382));
                menu3.positionInPixels = (ccp(240,intButtonsTop_Device-185));  //ok
                menu4.positionInPixels = (ccp(intScreenMidX-160,intButtonsTop_Device-185)); //ok
                //menu5.positionInPixels = (ccp(450, 200));
                menu5.positionInPixels = (ccp(685*2, 270*2));
                //menu5.positionInPixels = (ccp(intScreenMidX+(intScreenMidX*0.8f),intButtonsTop_Device));
                
                menu6.positionInPixels = ccp(intScreenWidth-115, intScreenHeight-115);
                
                
            } else {
                NSLog(@"SHOWING LANDSCAPE - iPad High (UHD)");
                
                fieldbg.positionInPixels = ccp(intFieldBGLeft_DeviceLand, intFieldBGTop_DeviceLand);
                fieldbgDisp.positionInPixels = ccp(intFieldBGLeft_DeviceLand, intFieldBGTop_DeviceLand);
                
                menu1.positionInPixels = (ccp(425,540));
                menu2.positionInPixels = (ccp(425,140));
                menu3.positionInPixels = (ccp(240,340));  //ok
                menu4.positionInPixels = (ccp(610,340)); //ok
                //menu5.positionInPixels = (ccp(intMenuSwitchLeft_DeviceLand, intMenuSwitchTop_DeviceLand));
                //menu5.positionInPixels = (ccp(intMenuSwitchLeft_Device, intMenuSwitchTop_Device));
                menu5.positionInPixels = (ccp(180, (685*2)+80));
                
                //half of size subtracted:
                menu6.positionInPixels = ccp(intScreenWidth-115, intScreenHeight-115);
                
            }

            
        } else if (inttypeOfHD == 2) {
            
            if (intInLandscape == 0) {
                NSLog(@"SHOWING PORTRAIT - iPad Low (HD)");
                
                fieldbg.positionInPixels = ccp(intScreenWidth /2 , intFieldBGTop_Device);
                fieldbgDisp.positionInPixels = ccp(intScreenWidth /2 , intFieldBGTop_Device);
                
                menu1.positionInPixels = (ccp(intScreenMidX-170,intButtonsTop_Device+10));  //test
                menu2.positionInPixels = (ccp(intScreenMidX-170,intButtonsTop_Device-192));
                menu3.positionInPixels = (ccp(intScreenMidX-260,intButtonsTop_Device-90));
                menu4.positionInPixels = (ccp(intScreenMidX-80,intButtonsTop_Device-90));
                //menu5.positionInPixels = (ccp(450, 200));
                menu5.positionInPixels = (ccp(685, 270));
                
                //half of size subtracted:
                menu6.positionInPixels = ccp(intScreenWidth-57, intScreenHeight-57);
                
            } else {
                NSLog(@"SHOWING LANDSCAPE - iPad Low (HD)");
                
                fieldbg.positionInPixels = ccp(intFieldBGLeft_DeviceLand, intFieldBGTop_DeviceLand);
                fieldbgDisp.positionInPixels = ccp(intFieldBGLeft_DeviceLand, intFieldBGTop_DeviceLand);
                
                menu1.positionInPixels = (ccp(intButtonsLeft_DeviceLand, intButtonsTop_DeviceLand));
                menu2.positionInPixels = (ccp(intButtonsLeft_DeviceLand, intButtonsTop_DeviceLand-202));
                menu3.positionInPixels = (ccp(intButtonsLeft_DeviceLand-90, intButtonsTop_DeviceLand-100));
                menu4.positionInPixels = (ccp(intButtonsLeft_DeviceLand+90, intButtonsTop_DeviceLand-100));
                menu5.positionInPixels = (ccp(intMenuSwitchLeft_DeviceLand, intMenuSwitchTop_DeviceLand));
                //menu5.positionInPixels = (ccp(intMenuSwitchLeft_Device, intMenuSwitchTop_Device));
                
                //half of size subtracted:
                menu6.positionInPixels = ccp(intScreenWidth-57, intScreenHeight-57);
            
            }
        
        } else if (inttypeOfHD == 1) {
            
            if (intIs4InchScreen == 1) {
                
                if (intInLandscape == 0) {
                    NSLog(@"SHOWING PORTRAIT - iPhone HD long");
                    
                    fieldbg.positionInPixels = ccp(intScreenWidth /2 , intFieldBGTop_Device);
                    fieldbgDisp.positionInPixels = ccp(intScreenWidth /2 , intFieldBGTop_Device);
                    
                    menu1.positionInPixels = (ccp(intScreenMidX,intButtonsTop_Device));
                    menu2.positionInPixels = (ccp(intScreenMidX,intButtonsTop_Device-202));
                    menu3.positionInPixels = (ccp(intScreenMidX-90,intButtonsTop_Device-100));
                    menu4.positionInPixels = (ccp(intScreenMidX+90,intButtonsTop_Device-100));
                    menu5.positionInPixels = (ccp(intScreenMidX+(intScreenMidX*0.8f),intButtonsTop_Device));
                    
                    //half of size subtracted:
                    menu6.positionInPixels = ccp(intScreenWidth-57, intScreenHeight-57);
                    
                } else {
                    NSLog(@"SHOWING LANDSCAPE - iPhone HD long");
                    
                    fieldbg.positionInPixels = ccp(intFieldBGLeft_DeviceLand, intFieldBGTop_DeviceLand);
                    fieldbgDisp.positionInPixels = ccp(intFieldBGLeft_DeviceLand, intFieldBGTop_DeviceLand);
                    
                    menu1.positionInPixels = (ccp(intButtonsLeft_DeviceLand, intButtonsTop_DeviceLand));
                    menu2.positionInPixels = (ccp(intButtonsLeft_DeviceLand, intButtonsTop_DeviceLand-202));
                    menu3.positionInPixels = (ccp(intButtonsLeft_DeviceLand-90, intButtonsTop_DeviceLand-100));
                    menu4.positionInPixels = (ccp(intButtonsLeft_DeviceLand+90, intButtonsTop_DeviceLand-100));
                    menu5.positionInPixels = (ccp(intMenuSwitchLeft_DeviceLand, intMenuSwitchTop_DeviceLand));
                    
                    //half of size subtracted:
                    menu6.positionInPixels = ccp(intScreenWidth-57, intScreenHeight-57);
                }
                
                
            } else {
                    
                    
                if (intInLandscape == 0) {
                    NSLog(@"SHOWING PORTRAIT - iPhone HD");
                    
                    fieldbg.positionInPixels = ccp(intScreenWidth /2 , intFieldBGTop_Device);
                    fieldbgDisp.positionInPixels = ccp(intScreenWidth /2 , intFieldBGTop_Device);
                    
                    menu1.positionInPixels = (ccp(intScreenMidX,intButtonsTop_Device));
                    menu2.positionInPixels = (ccp(intScreenMidX,intButtonsTop_Device-202));
                    menu3.positionInPixels = (ccp(intScreenMidX-90,intButtonsTop_Device-100));
                    menu4.positionInPixels = (ccp(intScreenMidX+90,intButtonsTop_Device-100));
                    menu5.positionInPixels = (ccp(intScreenMidX+(intScreenMidX*0.8f),intButtonsTop_Device));
                    //half of size subtracted:
                    menu6.positionInPixels = ccp(intScreenWidth-57, intScreenHeight-57);
                    
                } else {
                    NSLog(@"SHOWING LANDSCAPE - iPhone HD");
                    
                    fieldbg.positionInPixels = ccp(intFieldBGLeft_DeviceLand, intFieldBGTop_DeviceLand);
                    fieldbgDisp.positionInPixels = ccp(intFieldBGLeft_DeviceLand, intFieldBGTop_DeviceLand);
                    
                    menu1.positionInPixels = (ccp(intButtonsLeft_DeviceLand, intButtonsTop_DeviceLand));
                    menu2.positionInPixels = (ccp(intButtonsLeft_DeviceLand, intButtonsTop_DeviceLand-202));
                    menu3.positionInPixels = (ccp(intButtonsLeft_DeviceLand-90, intButtonsTop_DeviceLand-100));
                    menu4.positionInPixels = (ccp(intButtonsLeft_DeviceLand+90, intButtonsTop_DeviceLand-100));
                    menu5.positionInPixels = (ccp(intMenuSwitchLeft_DeviceLand, intMenuSwitchTop_DeviceLand));
                    
                    //half of size subtracted:
                    menu6.positionInPixels = ccp(intScreenWidth-57, intScreenHeight-57);
                }
            
            }
            
            
        } else {
            
            //position objects:
            if (intInLandscape == 0) {
                NSLog(@"SHOWING PORTRAIT - iPhone low");
                
                fieldbg.positionInPixels = ccp(intScreenWidth /2 , intFieldBGTop_Device);
                fieldbgDisp.positionInPixels = ccp(intScreenWidth /2 , intFieldBGTop_Device);
                
                menu1.positionInPixels = (ccp(intScreenMidX,intButtonsTop_Device));
                menu2.positionInPixels = (ccp(intScreenMidX,intButtonsTop_Device-101));
                menu3.positionInPixels = (ccp(intScreenMidX-45,intButtonsTop_Device-50));
                menu4.positionInPixels = (ccp(intScreenMidX+45,intButtonsTop_Device-50));
                menu5.positionInPixels = (ccp(intScreenMidX+(intScreenMidX*0.8f),intButtonsTop_Device));
                
                //half of size subtracted:
                menu6.positionInPixels = ccp(intScreenWidth-29, intScreenHeight-29);
                
            } else {
                NSLog(@"SHOWING LANDSCAPE - iPhone low");
                
                fieldbg.positionInPixels = ccp(intFieldBGLeft_DeviceLand, intFieldBGTop_DeviceLand);
                fieldbgDisp.positionInPixels = ccp(intFieldBGLeft_DeviceLand, intFieldBGTop_DeviceLand);
                
                menu1.positionInPixels = (ccp(intButtonsLeft_DeviceLand, intButtonsTop_DeviceLand));
                menu2.positionInPixels = (ccp(intButtonsLeft_DeviceLand, intButtonsTop_DeviceLand-101));
                menu3.positionInPixels = (ccp(intButtonsLeft_DeviceLand-45, intButtonsTop_DeviceLand-50));
                menu4.positionInPixels = (ccp(intButtonsLeft_DeviceLand+45, intButtonsTop_DeviceLand-50));
                menu5.positionInPixels = (ccp(intMenuSwitchLeft_DeviceLand, intMenuSwitchTop_DeviceLand));
                
                //half of size subtracted:
                menu6.positionInPixels = ccp(intScreenWidth-29, intScreenHeight-29);
            }
            
            
        }
    
    
    
    //turn back on if game was paused:
    if (intGamePausedbyPlayer == 0) {
        
        //....
        
    } else {
        intGamePausedbyPlayer = 0;
    }
    
//    //TURN BACK ON WITH SCHEDULED ACTION:
//    //for now just turn back on:
//    if (intSwitchStatus == 1) {
//        //..
//        intSwitchStatus = 0;
//    }
    
    
    //dont run this again if its not first time out:
    if (intGameHasStartedSentinel == 0) {
        
        intGameHasStartedSentinel = 1;
        
        [self addDemoPiecesLayersFromGrid];
 
        ////testing:
        [self addFirstPiece];
        
        ////start timers:
        [self schedule:@selector(tickerTimer:)];      //orientation checker
        //
        //[self schedule:@selector(secondTicker:) interval:0.75f];   //used for FX graphics.
        
		[self schedule:@selector(thirdTicker:) interval:0.75f];  //used for downbutton for dropping pieces faster than gravity.
        
		//
        ////        [self schedule:@selector(pieceTicker:) interval:0.7f];  //for piece movement. go X distance.
        //[self schedule:@selector(pieceTicker:)];  //for piece movement. go X distance.        
        
    } else if (intGameHasStartedSentinel == 1) {
        
        //might not a repos'der
         //[self positionFirstPiece];


		//ANYTHING ELSE NEED TO BE REPOSITIOINED IN MOTION?  EXPLOSIONS?  DO IT HERE

        
        //run repositionFirstPiece instead if in motion...
        [self repositionFirstPiece];
        
       
        
        
    } else {
        //....
        
    }
    
    
}

-(void)repositionFirstPiece {
    
    NSLog(@"RE-Position Current Piece - 3x3.");
    
    //calc distance traveled...
    //intDistanceTraveled = intBoxTopPosition -
    
    
    //need landscape and portrait:  current piece:
    
    if (intInLandscape == 0) {
        NSLog(@"Portrait..............");
        
        for (int i = 301; i <= 303 ; ++i) {
            tempBox = (CCSprite*)[self getChildByTag:i];
            [tempBox stopAllActions];
            
            
            tempBox.positionInPixels = ccp(tempBox.positionInPixels.x - (intFirstBoxLocLandX + (intSizeofPieceWithoutAA*(i-301))-(intFirstBoxLocX + (intSizeofPieceWithoutAA*(i-301)))), tempBox.positionInPixels.y - (intFirstBoxLocLandY-intFirstBoxLocY));
            
            if (i == 301) {
                
                //from above:
                intPieceTopPosition = tempBox.position.y;
                NSLog(@"PIECE TOP pos: %f",intPieceTopPosition);
                intBoxTopPosition = fieldbg.position.y+(fieldbg.contentSize.height/2);
                NSLog(@"fieldbg BOX TOP pos: %f",intBoxTopPosition);
                intBoxBottomPosition = fieldbg.position.y-(fieldbg.contentSize.height/2);
                NSLog(@"fieldbg BOXBottom pos: %f",intBoxBottomPosition);
                //NSLog(@"intTotalDistanceCalc1: %f",  tempBox.position.y-(fieldbg.position.y-(fieldbg.contentSize.height/2)) );
                //intTotalDistanceCalc = tempBox.position.y-(fieldbg.position.y-(fieldbg.contentSize.height/2));
                intTotalDistanceCalc = intBoxTopPosition - intBoxBottomPosition;
                NSLog(@"intTotalDistanceCalc: %f",  intTotalDistanceCalc);
                
                
                //float intTotalDistanceCalc = 0;
                //float intBoxTopPosition = 0;
                //float intDistanceTraveled = 0;
                
                //float intDropTimeLength = 10.5;
                //float intDropTimeElapsed = 0;
                //  intDropTimeRemaining = 0;
                
                //calc distance traveled...    needs ratio:  need end position at bottom:
                //intDistanceTraveled = intBoxTopPosition - tempBox.position.x;
                
                //equals distance left to end:
                //intDistanceTraveled = tempBox.position.y - intBoxBottomPosition;
                
                //need to check dimensions on board, since board moving around is messing vals:
                
                
                //error: we have total distance: use that instead of BoxBottomPosition.
                
                intDistanceTraveled = intTotalDistanceCalc - ( tempBox.position.y - intBoxBottomPosition);
                NSLog(@"intDistanceTraveled: %f", intDistanceTraveled);
                
                //intDistanceToGo = tempBox.position.y - intBoxBottomPosition;
                intDistanceToGo = intTotalDistanceCalc - intDistanceTraveled;
                NSLog(@"intDistanceToGo: %f", intDistanceToGo);
                
                //caculate accurate time remaining with ratio for anim:
                //
                //                 travelled             distance/time to go:  tempBox.position.y - intBoxBottomPosition
                //      ttime     t distance
                //
                //                 time elapsed:         intDropTimeElapsed = (intDistanceTraveled * intDropTimeLength)/intTotalDistanceCalc
                //                 time remaining:       intDropTimeLength - intDropTimeElapsed;
                
                intDropTimeElapsed =  (intDistanceTraveled * intDropTimeLength)/intTotalDistanceCalc;
                NSLog(@"total and intDropTimeElapsed: %f   %f elapsed", intDropTimeLength, intDropTimeElapsed);
                intDropTimeRemaining = intDropTimeLength - intDropTimeElapsed;
                
            }
            
            

            
            
            
            //tempBox.positionInPixels = ccp(intFirstBoxLocX + (intSizeofPieceWithoutAA*(i-301)), intFirstBoxLocY);
            //i=0, i=size, i=size*2
        }
        
        for (int i = 304; i <= 306 ; ++i) {
            tempBox = (CCSprite*)[self getChildByTag:i];
            [tempBox stopAllActions];
            
             tempBox.positionInPixels = ccp(tempBox.positionInPixels.x - (intFirstBoxLocLandX + (intSizeofPieceWithoutAA*(i-304))-(intFirstBoxLocX + (intSizeofPieceWithoutAA*(i-304)))), tempBox.positionInPixels.y - ((intFirstBoxLocLandY)-intFirstBoxLocY));
            
            //tempBox.positionInPixels = ccp(intFirstBoxLocX + (intSizeofPieceWithoutAA*(i-304)), intFirstBoxLocY - intSizeofPieceWithoutAA);
        }
        
        for (int i = 307; i <= 309 ; ++i) {
            tempBox = (CCSprite*)[self getChildByTag:i];
            [tempBox stopAllActions];
            
             tempBox.positionInPixels = ccp(tempBox.positionInPixels.x - (intFirstBoxLocLandX + (intSizeofPieceWithoutAA*(i-307))-(intFirstBoxLocX + (intSizeofPieceWithoutAA*(i-307)))), tempBox.positionInPixels.y - ((intFirstBoxLocLandY)-intFirstBoxLocY));
            
            //tempBox.positionInPixels = ccp(intFirstBoxLocX + (intSizeofPieceWithoutAA*(i-307)), intFirstBoxLocY - (intSizeofPieceWithoutAA*2));
        }
        
    } else {
        
        NSLog(@"Landscape..............");
        
        for (int i = 301; i <= 303 ; ++i) {
            tempBox = (CCSprite*)[self getChildByTag:i];
            [tempBox stopAllActions];
            
            //WORKS GOOD:  do other 2 lines and portrait:
            tempBox.positionInPixels = ccp(tempBox.positionInPixels.x + (intFirstBoxLocLandX + (intSizeofPieceWithoutAA*(i-301))-(intFirstBoxLocX + (intSizeofPieceWithoutAA*(i-301)))), tempBox.positionInPixels.y + (intFirstBoxLocLandY-intFirstBoxLocY));
            
            if (i == 301) {
                
                    //from above:
                intPieceTopPosition = tempBox.position.y;
                NSLog(@"PIECE TOP pos: %f",intPieceTopPosition);
                intBoxTopPosition = fieldbg.position.y+(fieldbg.contentSize.height/2);
                NSLog(@"fieldbg BOX TOP pos: %f",intBoxTopPosition);
                intBoxBottomPosition = fieldbg.position.y-(fieldbg.contentSize.height/2);
                NSLog(@"fieldbg BOXBottom pos: %f",intBoxBottomPosition);
                //NSLog(@"intTotalDistanceCalc1: %f",  tempBox.position.y-(fieldbg.position.y-(fieldbg.contentSize.height/2)) );
                //intTotalDistanceCalc = tempBox.position.y-(fieldbg.position.y-(fieldbg.contentSize.height/2));
                intTotalDistanceCalc = intBoxTopPosition - intBoxBottomPosition;
                NSLog(@"intTotalDistanceCalc: %f",  intTotalDistanceCalc);
                
                
                //float intTotalDistanceCalc = 0;
                //float intBoxTopPosition = 0;
                //float intDistanceTraveled = 0;

                //float intDropTimeLength = 10.5;
                //float intDropTimeElapsed = 0;
                //  intDropTimeRemaining = 0;
                
                //calc distance traveled...    needs ratio:  need end position at bottom:
                //intDistanceTraveled = intBoxTopPosition - tempBox.position.x;
                
                //equals distance left to end:
                //intDistanceTraveled = tempBox.position.y - intBoxBottomPosition;
                
                intDistanceTraveled = intTotalDistanceCalc - ( tempBox.position.y - intBoxBottomPosition);
                NSLog(@"intDistanceTraveled: %f", intDistanceTraveled);
                
                //intDistanceToGo = tempBox.position.y - intBoxBottomPosition;
                intDistanceToGo = intTotalDistanceCalc - intDistanceTraveled;
                 NSLog(@"intDistanceToGo: %f", intDistanceToGo);
                
//                subtract 2 from Piece POS to get distance-to-go
//                piecePosition.y - bottomofBoxPOS = distance to go
//                (from total)    check that total doesn't change on switch…
                
                
                //caculate accurate time remaining with ratio for anim:
                //
                //                 travelled             distance/time to go:  tempBox.position.y - intBoxBottomPosition
                //      ttime     t distance
                //
                //                 time elapsed:         intDropTimeElapsed = (intDistanceTraveled * intDropTimeLength)/intTotalDistanceCalc
                //                 time remaining:       intDropTimeLength - intDropTimeElapsed;
                
                intDropTimeElapsed =  (intDistanceTraveled * intDropTimeLength)/intTotalDistanceCalc;
                NSLog(@"total and intDropTimeElapsed: %f   %f elapsed", intDropTimeLength, intDropTimeElapsed);
                intDropTimeRemaining = intDropTimeLength - intDropTimeElapsed;
                
            }

            
            //tempBox.positionInPixels = ccp(intFirstBoxLocLandX + (intSizeofPieceWithoutAA*(i-301)), intFirstBoxLocLandY);
        }
        for (int i = 304; i <= 306 ; ++i) {
            tempBox = (CCSprite*)[self getChildByTag:i];
            [tempBox stopAllActions];
            
            tempBox.positionInPixels = ccp(tempBox.positionInPixels.x + (intFirstBoxLocLandX + (intSizeofPieceWithoutAA*(i-304))-(intFirstBoxLocX + (intSizeofPieceWithoutAA*(i-304)))), tempBox.positionInPixels.y + ((intFirstBoxLocLandY)-intFirstBoxLocY));
            
            //tempBox.positionInPixels = ccp(intFirstBoxLocLandX + (intSizeofPieceWithoutAA*(i-304)), intFirstBoxLocLandY  - intSizeofPieceWithoutAA);
        }
        for (int i = 307; i <= 309 ; ++i) {
            tempBox = (CCSprite*)[self getChildByTag:i];
            [tempBox stopAllActions];
            
            tempBox.positionInPixels = ccp(tempBox.positionInPixels.x + (intFirstBoxLocLandX + (intSizeofPieceWithoutAA*(i-307))-(intFirstBoxLocX + (intSizeofPieceWithoutAA*(i-307)))), tempBox.positionInPixels.y + ((intFirstBoxLocLandY)-intFirstBoxLocY));
            
            //tempBox.positionInPixels = ccp(intFirstBoxLocLandX + (intSizeofPieceWithoutAA*(i-307)), intFirstBoxLocLandY - (intSizeofPieceWithoutAA*2));
            
            //tempBox.positionInPixels = ccp(intFirstBoxLocLandX + (intSizeofPieceWithoutAA*(i-307)), intFirstBoxLocLandY - (intSizeofPieceWithoutAA*2));
        }
        
    }
    
    
    //check if we're in collision mode:
    
    if (intPostCollisionMode >=1) {
        
        //do nothig yet...
        NSLog(@"Screenrotated in Drop Mode.... recalc n restart");
        
        //testing:
        [self reStartMoveCurrentPieceinDropMode];
        
        
        
    } else {
    
        //player drop continues:
        [self reStartMoveCurrentPiece];
    
    }
    
    //  reStartMoveCurrentPiece
    
    
    //restart piece falling:
    //    calc  new time using rato with distance traveled over total
    //    X gives new time for xtran cont.
    //        
    //        X               dist traveled calc
    //        _______________ = _____________________
    //        total time var     total distance calc
    //    
    
    
    
}



-(void)positionFirstPiece {
    
    NSLog(@"Position First Current Piece - 3x3 load.");
    
    
    //NSLog(@"");
    
    
    
    //need landscape and portrait:  current piece:
    
    if (intInLandscape == 0) {
        
        for (int i = 301; i <= 303 ; ++i) {
            tempBox = (CCSprite*)[self getChildByTag:i];
            [tempBox stopAllActions];
            tempBox.positionInPixels = ccp(intFirstBoxLocX + (intSizeofPieceWithoutAA*(i-301)), intFirstBoxLocY);
            //i=0, i=size, i=size*2
            
            if (i==301){
                intPieceTopPosition = tempBox.position.y;
                NSLog(@"PIECE TOP pos: %f",intPieceTopPosition);
                intBoxTopPosition = fieldbg.position.y+(fieldbg.contentSize.height/2);
                NSLog(@"fieldbg BOX TOP pos: %f",intBoxTopPosition);
                intBoxBottomPosition = fieldbg.position.y-(fieldbg.contentSize.height/2);
                NSLog(@"fieldbg BOXBottom pos: %f",intBoxBottomPosition);
                //NSLog(@"intTotalDistanceCalc1: %f",  tempBox.position.y-(fieldbg.position.y-(fieldbg.contentSize.height/2)) );
                //intTotalDistanceCalc = tempBox.position.y-(fieldbg.position.y-(fieldbg.contentSize.height/2));
               intTotalDistanceCalc = intBoxTopPosition - intBoxBottomPosition;
                NSLog(@"intTotalDistanceCalc: %f",  intTotalDistanceCalc);
                
                
                intDistanceTraveled = intTotalDistanceCalc - ( tempBox.position.y - intBoxBottomPosition);
                NSLog(@"intDistanceTraveled: %f", intDistanceTraveled);
                
                //intDistanceToGo = tempBox.position.y - intBoxBottomPosition;
                intDistanceToGo = intTotalDistanceCalc - intDistanceTraveled;
                NSLog(@"intDistanceToGo: %f", intDistanceToGo);
              
            }
            
            
        }
        
        for (int i = 304; i <= 306 ; ++i) {
            tempBox = (CCSprite*)[self getChildByTag:i];
            [tempBox stopAllActions];
            tempBox.positionInPixels = ccp(intFirstBoxLocX + (intSizeofPieceWithoutAA*(i-304)), intFirstBoxLocY - intSizeofPieceWithoutAA);
        }
        
        for (int i = 307; i <= 309 ; ++i) {
            tempBox = (CCSprite*)[self getChildByTag:i];
            [tempBox stopAllActions];
            tempBox.positionInPixels = ccp(intFirstBoxLocX + (intSizeofPieceWithoutAA*(i-307)), intFirstBoxLocY - (intSizeofPieceWithoutAA*2));
        }
        
    } else {
        
        for (int i = 301; i <= 303 ; ++i) {
            tempBox = (CCSprite*)[self getChildByTag:i];
            [tempBox stopAllActions];
            
            if (i==301){
                intPieceTopPosition = tempBox.position.y;
                NSLog(@"PIECE TOP pos: %f",intPieceTopPosition);
                intBoxTopPosition = fieldbg.position.y+(fieldbg.contentSize.height/2);
                NSLog(@"fieldbg BOX TOP pos: %f",intBoxTopPosition);
                intBoxBottomPosition = fieldbg.position.y-(fieldbg.contentSize.height/2);
                NSLog(@"fieldbg BOXBottom pos: %f",intBoxBottomPosition);
                //NSLog(@"intTotalDistanceCalc1: %f",  tempBox.position.y-(fieldbg.position.y-(fieldbg.contentSize.height/2)) );
                //intTotalDistanceCalc = tempBox.position.y-(fieldbg.position.y-(fieldbg.contentSize.height/2));
                intTotalDistanceCalc = intBoxTopPosition - intBoxBottomPosition;
                NSLog(@"intTotalDistanceCalc: %f",  intTotalDistanceCalc);
                
                
                intDistanceTraveled = intTotalDistanceCalc - ( tempBox.position.y - intBoxBottomPosition);
                NSLog(@"intDistanceTraveled: %f", intDistanceTraveled);
                
                //intDistanceToGo = tempBox.position.y - intBoxBottomPosition;
                intDistanceToGo = intTotalDistanceCalc - intDistanceTraveled;
                NSLog(@"intDistanceToGo: %f", intDistanceToGo);
            }
            
            tempBox.positionInPixels = ccp(intFirstBoxLocLandX + (intSizeofPieceWithoutAA*(i-301)), intFirstBoxLocLandY);
        }
        for (int i = 304; i <= 306 ; ++i) {
            tempBox = (CCSprite*)[self getChildByTag:i];
            [tempBox stopAllActions];
            tempBox.positionInPixels = ccp(intFirstBoxLocLandX + (intSizeofPieceWithoutAA*(i-304)), intFirstBoxLocLandY  - intSizeofPieceWithoutAA);
        }
        for (int i = 307; i <= 309 ; ++i) {
            tempBox = (CCSprite*)[self getChildByTag:i];
            [tempBox stopAllActions];
            tempBox.positionInPixels = ccp(intFirstBoxLocLandX + (intSizeofPieceWithoutAA*(i-307)), intFirstBoxLocLandY - (intSizeofPieceWithoutAA*2));
        }
        
    }
    
    
    intPlayerCanMove = 1;
    
    
}

-(void)threeRandomPieces {
    //"O«X«O»O«X«O»O«X«O" populator
    
    intRandomUno = CCRANDOM_0_1()*10;
    intRandomDos = CCRANDOM_0_1()*10;
    intRandomTres = CCRANDOM_0_1()*10;
    if (intRandomUno < 1) {
        [strRandomPieceName1 setString:strPieceName001];
        [strIncomPiecesPiece1 setString:@"1"];
    } else if (intRandomUno < 2) {
        [strRandomPieceName1 setString:strPieceName002];
        [strIncomPiecesPiece1 setString:@"2"];
    } else if (intRandomUno < 3) {
        [strRandomPieceName1 setString:strPieceName003];
        [strIncomPiecesPiece1 setString:@"3"];
    } else if (intRandomUno < 4) {
        [strRandomPieceName1 setString:strPieceName004];
        [strIncomPiecesPiece1 setString:@"4"];
    } else if (intRandomUno < 5) {
        [strRandomPieceName1 setString:strPieceName005];
        [strIncomPiecesPiece1 setString:@"5"];
    } else if (intRandomUno < 6) {
        [strRandomPieceName1 setString:strPieceName006];
        [strIncomPiecesPiece1 setString:@"6"];
    } else if (intRandomUno < 7) {
        [strRandomPieceName1 setString:strPieceName007];
        [strIncomPiecesPiece1 setString:@"7"];
    } else if (intRandomUno < 8) {
        [strRandomPieceName1 setString:strPieceName008];
        [strIncomPiecesPiece1 setString:@"8"];
    } else if (intRandomUno < 9) {
        [strRandomPieceName1 setString:strPieceName009];
        [strIncomPiecesPiece1 setString:@"9"];
    } else {
        [strRandomPieceName1 setString:strPieceName009];
        [strIncomPiecesPiece1 setString:@"9"];
    }
    
    if (intRandomDos < 1) {
        [strRandomPieceName2 setString:strPieceName001];
        [strIncomPiecesPiece2 setString:@"«1"];
    } else if (intRandomDos < 2) {
        [strRandomPieceName2 setString:strPieceName002];
        [strIncomPiecesPiece2 setString:@"«2"];
    } else if (intRandomDos < 3) {
        [strRandomPieceName2 setString:strPieceName003];
        [strIncomPiecesPiece2 setString:@"«3"];
    } else if (intRandomDos < 4) {
        [strRandomPieceName2 setString:strPieceName004];
        [strIncomPiecesPiece2 setString:@"«4"];
    } else if (intRandomDos < 5) {
        [strRandomPieceName2 setString:strPieceName005];
        [strIncomPiecesPiece2 setString:@"«5"];
    } else if (intRandomDos < 6) {
        [strRandomPieceName2 setString:strPieceName006];
        [strIncomPiecesPiece2 setString:@"«6"];
    } else if (intRandomDos < 7) {
        [strRandomPieceName2 setString:strPieceName007];
        [strIncomPiecesPiece2 setString:@"«7"];
    } else if (intRandomDos < 8) {
        [strRandomPieceName2 setString:strPieceName008];
        [strIncomPiecesPiece2 setString:@"«8"];
    } else if (intRandomDos < 9) {
        [strRandomPieceName2 setString:strPieceName009];
        [strIncomPiecesPiece2 setString:@"«9"];
    } else {
        [strRandomPieceName2 setString:strPieceName009];
        [strIncomPiecesPiece2 setString:@"«9"];
    }
    
    if (intRandomTres < 1) {
        [strRandomPieceName3 setString:strPieceName001];
        [strIncomPiecesPiece3 setString:@"«1"];
    } else if (intRandomTres < 2) {
        [strRandomPieceName3 setString:strPieceName002];
        [strIncomPiecesPiece3 setString:@"«2"];
    } else if (intRandomTres < 3) {
        [strRandomPieceName3 setString:strPieceName003];
        [strIncomPiecesPiece3 setString:@"«3"];
    } else if (intRandomTres < 4) {
        [strRandomPieceName3 setString:strPieceName004];
        [strIncomPiecesPiece3 setString:@"«4"];
    } else if (intRandomTres < 5) {
        [strRandomPieceName3 setString:strPieceName005];
        [strIncomPiecesPiece3 setString:@"«5"];
    } else if (intRandomTres < 6) {
        [strRandomPieceName3 setString:strPieceName006];
        [strIncomPiecesPiece3 setString:@"«6"];
    } else if (intRandomTres < 7) {
        [strRandomPieceName3 setString:strPieceName007];
        [strIncomPiecesPiece3 setString:@"«7"];
    } else if (intRandomTres < 8) {
        [strRandomPieceName3 setString:strPieceName008];
        [strIncomPiecesPiece3 setString:@"«8"];
    } else if (intRandomTres < 9) {
        [strRandomPieceName3 setString:strPieceName009];
        [strIncomPiecesPiece3 setString:@"«9"];
    } else {
        [strRandomPieceName3 setString:strPieceName009];
        [strIncomPiecesPiece3 setString:@"«9"];
    }
    
    
    //  **** TESTING OVERRIDE:
//    [strRandomPieceName1 setString:strPieceName004];
//    [strIncomPiecesPiece1 setString:@"4"];
//    [strRandomPieceName2 setString:strPieceName004];
//    [strIncomPiecesPiece2 setString:@"«4"];
//    [strRandomPieceName3 setString:strPieceName004];
//    [strIncomPiecesPiece3 setString:@"«4"];
    
    
    
}

-(void)addFirstPiece {
    //    NSMutableString *strCurrentPlayPiece = nil;
    //    NSMutableString *strNext01PlayPiece = nil;
    //    NSMutableString *strNext02PlayPiece = nil;
    
    //    currentP1 = [CCSprite spriteWithSpriteFrameName:strCurrentTestPiece];
    //    currentP1.anchorPoint = ccp(0,0);
    //    [self addChild:currentP1 z:201 tag:301];
    
    // CCSprite *currentN1;
    //
    //    currentN1 = [CCSprite spriteWithSpriteFrameName:strCurrentTestPiece];
    //    currentN1.anchorPoint = ccp(0,0);
    //    [self addChild:currentN1 z:211 tag:311];
    
    //    for (int i = 101; i <= 109 ; ++i) {
    //        tempBox = (CCSprite*)[self getChildByTag:i];
    //        tempBox.positionInPixels = ccp(intFirstBoxLocLandX + (intSizeofPieceWithoutAA*(i-101)), intFirstBoxLocLandY);
    //    }
    
    //strPieceName001
    
    
    
    
    
    srandom(time(NULL));
    

    [self positionFirstPiece];
    
    //sprite ready. load structure:      need a setRandomPiece funtion to call. sets nrw RndPieceString
    //                                    based on those set for device.
    //NSArray *arrRCVD_Top10 = [strSavedGameData componentsSeparatedByString:@"»"];
    //NSArray *arrRCVD01 = [[arrRCVD_Top10 objectAtIndex:0] componentsSeparatedByString:@"«"];
    //NSArray *arrRCVD02 = [[arrRCVD_Top10 objectAtIndex:1] componentsSeparatedByString:@"«"];
    //NSArray *arrRCVD03 = [[arrRCVD_Top10 objectAtIndex:2] componentsSeparatedByString:@"«"];

    
    
    
        
        
    //strPieceType01 = [[NSMutableString alloc] initWithString:@"O«X«O»O«X«O»O«X«O"];
    //strPieceType02 = [[NSMutableString alloc] initWithString:@"X«O«O»O«X«O»O«O«X"];
    //strPieceType03 = [[NSMutableString alloc] initWithString:@"X«O«X»O«X«O»X«O«X"];
    //strPieceType04 = [[NSMutableString alloc] initWithString:@"X«O«X»X«O«X»X«X«X"];
    //strPieceType05 = [[NSMutableString alloc] initWithString:@"X«X«X»O«X«O»O«X«O"];
    //strPieceType06 = [[NSMutableString alloc] initWithString:@"X«X«X»O«O«X»O«O«X"];
    //strPieceType07 = [[NSMutableString alloc] initWithString:@"X«X«X»O«X«O»X«O«O"];
    //strPieceType08 = [[NSMutableString alloc] initWithString:@"X«X«X»X«O«X»X«X«X"];
    //strPieceType09 = [[NSMutableString alloc] initWithString:@"X«X«X»X«X«X»X«X«X"];
    
    //    CCRANDOM_0_1
    //    returns a random float between 0 and 1
    
    //	fishRandomNumberof2 = 1 + rand()%14;   //cluckhit	re-randomize

    
    //    int intCurrentPieceIsSet = 0;
    //    int intNextPieceIsSet = 0;
    
    
    
    if (intCurrentPieceIsSet == 0) {
        
        //        NSLog(@"rand: %f", CCRANDOM_0_1());
        //        NSLog(@"rand: %f", CCRANDOM_0_1());
        //        2014-07-11 01:03:21.810 FruitBunch[8074:907] rand: 0.670559
        //        2014-07-11 01:03:21.811 FruitBunch[8074:907] rand: 0.990720
        
        
        if (CCRANDOM_0_1() < 0.1) {
            intPieceTypeSelected = 1;
            [strCurrentPlayPiece setString:strPieceType01];
        } else if (CCRANDOM_0_1() < 0.2) {
            intPieceTypeSelected = 2;
            [strCurrentPlayPiece setString:strPieceType02];
        } else if (CCRANDOM_0_1() < 0.3) {
            intPieceTypeSelected = 3;
            [strCurrentPlayPiece setString:strPieceType03];
        } else if (CCRANDOM_0_1() < 0.4) {
            intPieceTypeSelected = 4;
            [strCurrentPlayPiece setString:strPieceType04];
        } else if (CCRANDOM_0_1() < 0.5) {
            intPieceTypeSelected = 5;
            [strCurrentPlayPiece setString:strPieceType05];
        } else if (CCRANDOM_0_1() < 0.6) {
            intPieceTypeSelected = 6;
            [strCurrentPlayPiece setString:strPieceType06];
        } else if (CCRANDOM_0_1() < 0.7) {
            intPieceTypeSelected = 7;
            [strCurrentPlayPiece setString:strPieceType07];
        } else if (CCRANDOM_0_1() < 0.8) {
            intPieceTypeSelected = 8;
            [strCurrentPlayPiece setString:strPieceType08];
        } else if (CCRANDOM_0_1() < 0.9) {
            intPieceTypeSelected = 9;
            [strCurrentPlayPiece setString:strPieceType09];
        } else {
            //... piece options depend on level, so evenly random for now.
            intPieceTypeSelected = 9;
            [strCurrentPlayPiece setString:strPieceType09];
        }

        
        //overwrite for TESTING!   vert   //  **** TESTING OVERRIDE:
//        intPieceTypeSelected = 3;    // X
//        [strCurrentPlayPiece setString:strPieceType03];

//        intPieceTypeSelected = 1;    //   |
//        [strCurrentPlayPiece setString:strPieceType01];

//        intPieceTypeSelected = 5;    // T
//        [strCurrentPlayPiece setString:strPieceType05];

//        intPieceTypeSelected = 6;    // 7
//        [strCurrentPlayPiece setString:strPieceType06];

//        intPieceTypeSelected = 2;    // F
//        [strCurrentPlayPiece setString:strPieceType02];
        
//        intPieceTypeSelected = 4;    // U  C
//        [strCurrentPlayPiece setString:strPieceType04];
        
//        intPieceTypeSelected = 7;    // y
//        [strCurrentPlayPiece setString:strPieceType07];

//        intPieceTypeSelected = 8;    // O
//        [strCurrentPlayPiece setString:strPieceType08];
        
//        intPieceTypeSelected = 9;    // O
//        [strCurrentPlayPiece setString:strPieceType09];
        
        NSArray *arrRCVD_Piece01 = [strCurrentPlayPiece componentsSeparatedByString:@"»"];
        NSArray *arrRCVD01 = [[arrRCVD_Piece01 objectAtIndex:0] componentsSeparatedByString:@"«"];
        NSArray *arrRCVD02 = [[arrRCVD_Piece01 objectAtIndex:1] componentsSeparatedByString:@"«"];
        NSArray *arrRCVD03 = [[arrRCVD_Piece01 objectAtIndex:2] componentsSeparatedByString:@"«"];

        //update strIncomBoardPieces
        //do a random piece
        // [strRandomPieceName setString:@"piece_mstr_001.png"];
        //strPieceName001
        
        //intRandomUno
        // intTotalDistanceCalc for rows hit check calc  = 315
        
        
        //move to "set3randompiecenames sub:  and call for each row:
        //add a PieceNumberIntSelected so we can update the GRID with it!!
        
        
        [self threeRandomPieces];
        
        
        for (int i = 301; i <= 303 ; ++i) {
            
            if ([[arrRCVD01 objectAtIndex:(i-301)] rangeOfString:@"O"].location == NSNotFound) {
                NSLog(@"string does not contain bla. it s X");
                tempBox = (CCSprite*)[self getChildByTag:i];
                //currentP1
                //strPieceName001  is cherry, strPieceName002 is grape, etc
                
                if (i == 301) {
                    spriteFrameMain = [frameCacheMain spriteFrameByName:strRandomPieceName1];
                    [tempBox setDisplayFrame:spriteFrameMain];
                    
                    [strIncomPiecesGrid setString:strIncomPiecesPiece1];
                    
                } else if (i == 302) {
                    spriteFrameMain = [frameCacheMain spriteFrameByName:strRandomPieceName2];
                    [tempBox setDisplayFrame:spriteFrameMain];
                    
                    [strIncomPiecesGrid appendString:strIncomPiecesPiece2];
                    
                } else {
                    spriteFrameMain = [frameCacheMain spriteFrameByName:strRandomPieceName3];
                    [tempBox setDisplayFrame:spriteFrameMain];
                    
                    [strIncomPiecesGrid appendString:strIncomPiecesPiece3];
                    //»
                    [strIncomPiecesGrid appendString:@"»"];
                }
                
            } else {
                //add as zero to strIncomPiecesGrid «0»
                if (i == 301) {
                    [strIncomPiecesGrid setString:@"0"];
                } else if (i == 302) {
                    [strIncomPiecesGrid appendString:@"«0"];
                } else {
                    [strIncomPiecesGrid appendString:@"«0»"];
                }
                
            }
            
            
            
        }
        
        [self threeRandomPieces];
        
        for (int i = 304; i <= 306 ; ++i) {
            
            if ([[arrRCVD02 objectAtIndex:(i-304)] rangeOfString:@"O"].location == NSNotFound) {
                tempBox = (CCSprite*)[self getChildByTag:i];
                //spriteFrameMain = [frameCacheMain spriteFrameByName:strRandomPieceName1];
                //[tempBox setDisplayFrame:spriteFrameMain];
                
                
                if (i == 304) {
                    spriteFrameMain = [frameCacheMain spriteFrameByName:strRandomPieceName1];
                    [tempBox setDisplayFrame:spriteFrameMain];
                    
                    [strIncomPiecesGrid appendString:strIncomPiecesPiece1];
                    
                } else if (i == 305) {
                    spriteFrameMain = [frameCacheMain spriteFrameByName:strRandomPieceName2];
                    [tempBox setDisplayFrame:spriteFrameMain];
                    
                    [strIncomPiecesGrid appendString:strIncomPiecesPiece2];
                } else {
                    spriteFrameMain = [frameCacheMain spriteFrameByName:strRandomPieceName3];
                    [tempBox setDisplayFrame:spriteFrameMain];
                    
                    [strIncomPiecesGrid appendString:strIncomPiecesPiece3];
                    [strIncomPiecesGrid appendString:@"»"];
                }
                
                
            } else {
                if (i == 304) {
                    [strIncomPiecesGrid appendString:@"0"];
                } else if (i == 305) {
                    [strIncomPiecesGrid appendString:@"«0"];
                } else {
                    [strIncomPiecesGrid appendString:@"«0»"];
                }
            }
            
        }
        
        [self threeRandomPieces];
        
        for (int i = 307; i <= 309 ; ++i) {
            if ([[arrRCVD03 objectAtIndex:(i-307)] rangeOfString:@"O"].location == NSNotFound) {
                tempBox = (CCSprite*)[self getChildByTag:i];
                //spriteFrameMain = [frameCacheMain spriteFrameByName:strRandomPieceName1];
                //[tempBox setDisplayFrame:spriteFrameMain];
                
                
                if (i == 307) {
                    spriteFrameMain = [frameCacheMain spriteFrameByName:strRandomPieceName1];
                    [tempBox setDisplayFrame:spriteFrameMain];
                    [strIncomPiecesGrid appendString:strIncomPiecesPiece1];
                } else if (i == 308) {
                    spriteFrameMain = [frameCacheMain spriteFrameByName:strRandomPieceName2];
                    [tempBox setDisplayFrame:spriteFrameMain];
                    [strIncomPiecesGrid appendString:strIncomPiecesPiece2];
                } else {
                    spriteFrameMain = [frameCacheMain spriteFrameByName:strRandomPieceName3];
                    [tempBox setDisplayFrame:spriteFrameMain];
                    [strIncomPiecesGrid appendString:strIncomPiecesPiece3];
                }
                
            } else {
                
                if (i == 307) {
                    [strIncomPiecesGrid appendString:@"0"];
                } else if (i == 308) {
                    [strIncomPiecesGrid appendString:@"«0"];
                } else {
                    [strIncomPiecesGrid appendString:@"«0"];
                }
                
            }
            
            
        }

         [self threeRandomPieces];

        NSLog(@"displayed incoming piece is: %@", strIncomPiecesGrid);
        
        intPrevColID = 1;
        intColIDd = 1;  //0 is offscreen vertPiece when pushed over to left.
        intCurrentPieceIsSet = 1;

        [self updateIncomGridWithPiecesGrid];
    
    
    } else {
        //alrady set... do nothing..
        
        
    }
    
   
    
    //checking coords:........................................
    [self startMoveCurrentPiece];

    
}

-(void)updateIncomGridWithPiecesGrid {
    
    //RUNS ONLY ON ADDING 'FIRSTPIECE' AKA CURRENT
    //dont use afterwards
    
    
}

-(void)reStartMoveCurrentPiece {
    //select pieces and add action:
    //    float intDropTimeLength = 17.5;
    //    float intDropTimeElapsed = 0;
    
    

}

-(void)reStartMoveCurrentPieceinDropMode {
    //select pieces and add action:
    //    float intDropTimeLength = 17.5;
    //    float intDropTimeElapsed = 0;
    
    
    
    
}



-(void)startMoveCurrentPiece {
    //select pieces and add action:
    //    float intDropTimeLength = 17.5;
    //    float intDropTimeElapsed = 0;

    
    
}


-(void)addDemoPiecesLayersFromGrid {
    
    //strSavedBoardPieces
    //@"0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«2»1»2»4»3»5»6»5»4«3»2»1»2»3»4»3»2»1"];
    
    
    if (intCurrentGridIsSet == 0) {
    
    
        NSArray *arrRCVD_Grid01 = [strSavedBoardPieces componentsSeparatedByString:@"«"];
        
        //QUESTION: CYCLE THRU ARRAYS OR CYCLE THRU TAGS:
        //use select case: see notes
        
        for (int kk = 0; kk <= 14 ; ++kk) {
            //for each row, get each cell
            
            NSArray *arrRCVD_Row = [[arrRCVD_Grid01 objectAtIndex:kk] componentsSeparatedByString:@"«"];
            //[strCurrentPieceStr setString: [arrRCVD_Row objectAtIndex:0]];
            //NSLog(@"Data: %@", strCurrentPieceStr);
            
            NSArray *arrRCVD_Cell = [[arrRCVD_Row objectAtIndex:0] componentsSeparatedByString:@"»"];
            
            for (int kc = 0; kc <= 8 ; ++kc) {
                [strCurrentPieceStr setString: [arrRCVD_Cell objectAtIndex:kc]];
                //NSLog(@"DataC: %@", strCurrentPieceStr);
                
                intCurrentPieceInt = [strCurrentPieceStr intValue];
                
                //NSLog(@"Switch sprite: %d, %d = %d", kk, kc, intCurrentPieceInt);
                
                //intCurrentRow  intNewRow
                //strPieceName001 to strPieceName012  11 is blank, 12 is clear box
                
                switch (kk)
                {
                    case 0:
                        //NSLog (@"top row zero");
                        tempBox = (CCSprite*)[self getChildByTag:(101+kc)];
                        //tempBox.positionInPixels = ccp(intFirstBoxLocX + (intSizeofPieceWithoutAA*(i-101)), intFirstBoxLocY);
                        
                        break;
                    case 1:
                        //NSLog (@"one");
                        tempBox = (CCSprite*)[self getChildByTag:(111+kc)];
                        
                        break;
                    case 2:
                       //NSLog (@"two");
                        tempBox = (CCSprite*)[self getChildByTag:(121+kc)];
                        
                        break;
                    case 3:
                        //NSLog (@"three");
                        tempBox = (CCSprite*)[self getChildByTag:(131+kc)];
                        
                        break;
                    case 4:
                        //NSLog (@"four");
                        tempBox = (CCSprite*)[self getChildByTag:(141+kc)];
                        
                        break;
                    case 5:
                        //NSLog (@"five");
                        tempBox = (CCSprite*)[self getChildByTag:(151+kc)];
                        
                        break;
                    case 6:
                        //NSLog (@"6");
                        tempBox = (CCSprite*)[self getChildByTag:(161+kc)];
                        
                        break;
                    case 7:
                        //NSLog (@"7");
                        tempBox = (CCSprite*)[self getChildByTag:(171+kc)];
                        
                        break;
                    case 8:
                        //NSLog (@"8");
                        tempBox = (CCSprite*)[self getChildByTag:(181+kc)];
                        
                        break;
                    case 9:
                        //NSLog (@"9");
                        tempBox = (CCSprite*)[self getChildByTag:(191+kc)];
                        
                        break;
                    case 10:
                        //NSLog (@"10");
                        tempBox = (CCSprite*)[self getChildByTag:(201+kc)];
                        
                        break;
                    case 11:
                        //NSLog (@"11");
                        tempBox = (CCSprite*)[self getChildByTag:(211+kc)];
                        
                        break;
                    case 12:
                        //NSLog (@"12");
                        tempBox = (CCSprite*)[self getChildByTag:(221+kc)];
                        
                        break;
                    case 13:
                        //NSLog (@"13");
                        tempBox = (CCSprite*)[self getChildByTag:(231+kc)];
                        
                        break;
                    case 14:
                        //NSLog (@"14");
                        tempBox = (CCSprite*)[self getChildByTag:(241+kc)];
                        
                        break;
                    default:
                        NSLog (@"Integer out of range");
                        
                        break;
                //}
                
                //update with texture
                        
                }
                
                switch (intCurrentPieceInt)
                {
                    case 0:
                        //NSLog (@"use texture blank");
                        
                        spriteFrameMain = [frameCacheMain spriteFrameByName:strPieceName011];
                        [tempBox setDisplayFrame:spriteFrameMain];
                        break;
                    case 1:
                        spriteFrameMain = [frameCacheMain spriteFrameByName:strPieceName001];
                        [tempBox setDisplayFrame:spriteFrameMain];
                        break;
                    case 2:
                        spriteFrameMain = [frameCacheMain spriteFrameByName:strPieceName002];
                        [tempBox setDisplayFrame:spriteFrameMain];
                        break;
                    case 3:
                        spriteFrameMain = [frameCacheMain spriteFrameByName:strPieceName003];
                        [tempBox setDisplayFrame:spriteFrameMain];
                        break;
                    case 4:
                        spriteFrameMain = [frameCacheMain spriteFrameByName:strPieceName004];
                        [tempBox setDisplayFrame:spriteFrameMain];
                        break;
                    case 5:
                        spriteFrameMain = [frameCacheMain spriteFrameByName:strPieceName005];
                        [tempBox setDisplayFrame:spriteFrameMain];
                        break;
                    case 6:
                        spriteFrameMain = [frameCacheMain spriteFrameByName:strPieceName006];
                        [tempBox setDisplayFrame:spriteFrameMain];
                        break;
                    case 7:
                        spriteFrameMain = [frameCacheMain spriteFrameByName:strPieceName007];
                        [tempBox setDisplayFrame:spriteFrameMain];
                        break;
                    case 8:
                        spriteFrameMain = [frameCacheMain spriteFrameByName:strPieceName008];
                        [tempBox setDisplayFrame:spriteFrameMain];
                        break;
                    case 9:
                        spriteFrameMain = [frameCacheMain spriteFrameByName:strPieceName009];
                        [tempBox setDisplayFrame:spriteFrameMain];
                        break;
                    case 10:
                        spriteFrameMain = [frameCacheMain spriteFrameByName:strPieceName010];
                        [tempBox setDisplayFrame:spriteFrameMain];
                        break;
                    case 11:
                        spriteFrameMain = [frameCacheMain spriteFrameByName:strPieceName011];
                        [tempBox setDisplayFrame:spriteFrameMain];
                        break;
                    case 12:
                        spriteFrameMain = [frameCacheMain spriteFrameByName:strPieceName012];
                        [tempBox setDisplayFrame:spriteFrameMain];
                        break;
                    default:
                        NSLog (@"Integer out of range");
                        
                        break;
                        
                }
                
            }
            
        }
    
        intCurrentGridIsSet = 1;
        
    }
    
    // else set
    
}

-(void)addPopperPiecesLayersFromGrid {
    
    if (CC_CONTENT_SCALE_FACTOR() > 1) {
        intPieceScalar = 4;
    } else {
        intPieceScalar = 2;
    }
    
    
    //CYCLE THRU AND START IF > 13
    NSArray *arrRCVD_Grid01 = [strSavedBoardPieces componentsSeparatedByString:@"«"];
    
    //QUESTION: CYCLE THRU ARRAYS OR CYCLE THRU TAGS:
    //use select case: see notes
    
    for (int kk = 0; kk <= 14 ; ++kk) {
        //for each row, get each cell
        
        NSArray *arrRCVD_Row = [[arrRCVD_Grid01 objectAtIndex:kk] componentsSeparatedByString:@"«"];
        //[strCurrentPieceStr setString: [arrRCVD_Row objectAtIndex:0]];
        //NSLog(@"Data: %@", strCurrentPieceStr);
        
        NSArray *arrRCVD_Cell = [[arrRCVD_Row objectAtIndex:0] componentsSeparatedByString:@"»"];
        
        for (int kc = 0; kc <= 8 ; ++kc) {
            [strCurrentPieceStr setString: [arrRCVD_Cell objectAtIndex:kc]];
            //NSLog(@"DataC: %@", strCurrentPieceStr);
            
            intCurrentPieceInt = [strCurrentPieceStr intValue];
            
            //NSLog(@"Switch sprite: %d, %d = %d", kk, kc, intCurrentPieceInt);
            
            //intCurrentRow  intNewRow
            //strPieceName001 to strPieceName012  11 is blank, 12 is clear box
            
            switch (kk)
            {
                case 0:
                    //NSLog (@"top row zero");
                    tempBox = (CCSprite*)[self getChildByTag:(101+kc)];
                    //tempBox.positionInPixels = ccp(intFirstBoxLocX + (intSizeofPieceWithoutAA*(i-101)), intFirstBoxLocY);
                    
                    break;
                case 1:
                    //NSLog (@"one");
                    tempBox = (CCSprite*)[self getChildByTag:(111+kc)];
                    
                    break;
                case 2:
                    //NSLog (@"two");
                    tempBox = (CCSprite*)[self getChildByTag:(121+kc)];
                    
                    break;
                case 3:
                    //NSLog (@"three");
                    tempBox = (CCSprite*)[self getChildByTag:(131+kc)];
                    
                    break;
                case 4:
                    //NSLog (@"four");
                    tempBox = (CCSprite*)[self getChildByTag:(141+kc)];
                    
                    break;
                case 5:
                    //NSLog (@"five");
                    tempBox = (CCSprite*)[self getChildByTag:(151+kc)];
                    
                    break;
                case 6:
                    //NSLog (@"6");
                    tempBox = (CCSprite*)[self getChildByTag:(161+kc)];
                    
                    break;
                case 7:
                    //NSLog (@"7");
                    tempBox = (CCSprite*)[self getChildByTag:(171+kc)];
                    
                    break;
                case 8:
                    //NSLog (@"8");
                    tempBox = (CCSprite*)[self getChildByTag:(181+kc)];
                    
                    break;
                case 9:
                    //NSLog (@"9");
                    tempBox = (CCSprite*)[self getChildByTag:(191+kc)];
                    
                    break;
                case 10:
                    //NSLog (@"10");
                    tempBox = (CCSprite*)[self getChildByTag:(201+kc)];
                    
                    break;
                case 11:
                    //NSLog (@"11");
                    tempBox = (CCSprite*)[self getChildByTag:(211+kc)];
                    
                    break;
                case 12:
                    //NSLog (@"12");
                    tempBox = (CCSprite*)[self getChildByTag:(221+kc)];
                    
                    break;
                case 13:
                    //NSLog (@"13");
                    tempBox = (CCSprite*)[self getChildByTag:(231+kc)];
                    
                    break;
                case 14:
                    //NSLog (@"14");
                    tempBox = (CCSprite*)[self getChildByTag:(241+kc)];
                    
                    break;
                default:
                    NSLog (@"Integer out of range");
                    
                    break;
                    //}
                    
                    //update with texture
                    
            }
            
            
            
            
            
            switch (intCurrentPieceInt)
            {
                case 0:
                    //NSLog (@"use texture blank");
                    
                    spriteFrameMain = [frameCacheMain spriteFrameByName:strPieceName011];
                    [tempBox setDisplayFrame:spriteFrameMain];
                    break;
                case 1:
                    spriteFrameMain = [frameCacheMain spriteFrameByName:strPieceName001];
                    [tempBox setDisplayFrame:spriteFrameMain];
                    break;
                case 2:
                    spriteFrameMain = [frameCacheMain spriteFrameByName:strPieceName002];
                    [tempBox setDisplayFrame:spriteFrameMain];
                    break;
                case 3:
                    spriteFrameMain = [frameCacheMain spriteFrameByName:strPieceName003];
                    [tempBox setDisplayFrame:spriteFrameMain];
                    break;
                case 4:
                    spriteFrameMain = [frameCacheMain spriteFrameByName:strPieceName004];
                    [tempBox setDisplayFrame:spriteFrameMain];
                    break;
                case 5:
                    spriteFrameMain = [frameCacheMain spriteFrameByName:strPieceName005];
                    [tempBox setDisplayFrame:spriteFrameMain];
                    break;
                case 6:
                    spriteFrameMain = [frameCacheMain spriteFrameByName:strPieceName006];
                    [tempBox setDisplayFrame:spriteFrameMain];
                    break;
                case 7:
                    spriteFrameMain = [frameCacheMain spriteFrameByName:strPieceName007];
                    [tempBox setDisplayFrame:spriteFrameMain];
                    break;
                case 8:
                    spriteFrameMain = [frameCacheMain spriteFrameByName:strPieceName008];
                    [tempBox setDisplayFrame:spriteFrameMain];
                    break;
                case 9:
                    spriteFrameMain = [frameCacheMain spriteFrameByName:strPieceName009];
                    [tempBox setDisplayFrame:spriteFrameMain];
                    break;
                case 10:
                    spriteFrameMain = [frameCacheMain spriteFrameByName:strPieceName010];
                    [tempBox setDisplayFrame:spriteFrameMain];
                    break;
                    
                    //popper pieces:
                case 11:
                    spriteFrameMain = [frameCacheMain spriteFrameByName:strPieceName016];
                    [tempBox setDisplayFrame:spriteFrameMain];
                    
                    
                    [self showConfetti1: tempBox.position.x + (intSizeofPieceWithoutAA/intPieceScalar) yCoord:tempBox.position.y + (intSizeofPieceWithoutAA/intPieceScalar)
                                   royR:0.0f geeG:0.8f biV:0.0f];
                    [self showConfetti2: tempBox.position.x + (intSizeofPieceWithoutAA/intPieceScalar) yCoorD:tempBox.position.y + (intSizeofPieceWithoutAA/intPieceScalar)
                                   RoyR:1.0f GeeG:1.0f BiV:1.0f];

                    [self showPlus5: tempBox.position.x + (intSizeofPieceWithoutAA/intPieceScalar) yCoorD5:tempBox.position.y + (intSizeofPieceWithoutAA/intPieceScalar) RoyR5:0.0f GeeG5:0.9f BiV5:0.0f];

                    
                    break;
                case 12:
                    spriteFrameMain = [frameCacheMain spriteFrameByName:strPieceName017];
                    [tempBox setDisplayFrame:spriteFrameMain];
                    
                    [self showConfetti1: tempBox.position.x + (intSizeofPieceWithoutAA/intPieceScalar) yCoord:tempBox.position.y + (intSizeofPieceWithoutAA/intPieceScalar) royR:1.0f geeG:0.0f biV:0.0f];
                    [self showConfetti2: tempBox.position.x + (intSizeofPieceWithoutAA/intPieceScalar) yCoorD:tempBox.position.y + (intSizeofPieceWithoutAA/intPieceScalar) RoyR:0.8f GeeG:0.0f BiV:0.0f];
                    
                    [self showPlus10: tempBox.position.x + (intSizeofPieceWithoutAA/intPieceScalar) yCoorD10:tempBox.position.y + (intSizeofPieceWithoutAA/intPieceScalar) RoyR10:1.0f GeeG10:0.0f BiV10:0.0f];
                    
                    break;
                case 13:
                    spriteFrameMain = [frameCacheMain spriteFrameByName:strPieceName018];
                    [tempBox setDisplayFrame:spriteFrameMain];
                    
                    [self showConfetti1: tempBox.position.x + (intSizeofPieceWithoutAA/intPieceScalar) yCoord:tempBox.position.y + (intSizeofPieceWithoutAA/intPieceScalar) royR:1.0f geeG:1.0f biV:0.0f];
                    [self showConfetti2: tempBox.position.x + (intSizeofPieceWithoutAA/intPieceScalar) yCoorD:tempBox.position.y + (intSizeofPieceWithoutAA/intPieceScalar) RoyR:1.0f GeeG:0.75f BiV:0.0f];
                    
                    [self showPlus1: tempBox.position.x + (intSizeofPieceWithoutAA/intPieceScalar) yCoorD1:tempBox.position.y + (intSizeofPieceWithoutAA/intPieceScalar) RoyR1:1.0f GeeG1:1.0f BiV1:0.0f];
                    
                    
                    break;
                case 14:
                    spriteFrameMain = [frameCacheMain spriteFrameByName:strPieceName019];
                    [tempBox setDisplayFrame:spriteFrameMain];
                    
                    
                    [self showConfetti1: tempBox.position.x + (intSizeofPieceWithoutAA/intPieceScalar) yCoord:tempBox.position.y + (intSizeofPieceWithoutAA/intPieceScalar) royR:1.0f geeG:0.6f biV:0.0f];
                    [self showConfetti2: tempBox.position.x + (intSizeofPieceWithoutAA/intPieceScalar) yCoorD:tempBox.position.y + (intSizeofPieceWithoutAA/intPieceScalar) RoyR:1.0f GeeG:0.4f BiV:0.0f];
                    
                    [self showPlus1: tempBox.position.x + (intSizeofPieceWithoutAA/intPieceScalar) yCoorD1:tempBox.position.y + (intSizeofPieceWithoutAA/intPieceScalar) RoyR1:1.0f GeeG1:0.6f BiV1:0.0f];
                    
                    break;
                case 15:
                    spriteFrameMain = [frameCacheMain spriteFrameByName:strPieceName020];
                    [tempBox setDisplayFrame:spriteFrameMain];
                    
                    [self showConfetti1: tempBox.position.x + (intSizeofPieceWithoutAA/intPieceScalar) yCoord:tempBox.position.y + (intSizeofPieceWithoutAA/intPieceScalar) royR:1.0f geeG:0.0f biV:0.0f];
                    [self showConfetti2: tempBox.position.x + (intSizeofPieceWithoutAA/intPieceScalar) yCoorD:tempBox.position.y + (intSizeofPieceWithoutAA/intPieceScalar) RoyR:0.8f GeeG:0.0f BiV:0.0f];
                    
                    [self showPlus100: tempBox.position.x + (intSizeofPieceWithoutAA/intPieceScalar) yCoorD100:tempBox.position.y + (intSizeofPieceWithoutAA/intPieceScalar) RoyR100:1.0f GeeG100:0.0f BiV100:0.0f];
                    
                    break;
                case 16:
                    spriteFrameMain = [frameCacheMain spriteFrameByName:strPieceName021];
                    [tempBox setDisplayFrame:spriteFrameMain];
                    
                    [self showConfetti1: tempBox.position.x + (intSizeofPieceWithoutAA/intPieceScalar) yCoord:tempBox.position.y + (intSizeofPieceWithoutAA/intPieceScalar) royR:0.75f geeG:0.0f biV:0.75f];
                    [self showConfetti2: tempBox.position.x + (intSizeofPieceWithoutAA/intPieceScalar) yCoorD:tempBox.position.y + (intSizeofPieceWithoutAA/intPieceScalar) RoyR:0.9f GeeG:0.3f BiV:0.9f];
                    
                    [self showPlus1: tempBox.position.x + (intSizeofPieceWithoutAA/intPieceScalar) yCoorD1:tempBox.position.y + (intSizeofPieceWithoutAA/intPieceScalar) RoyR1:0.9f GeeG1:0.3f BiV1:0.9f];
                    
                    break;
                case 17:
                    spriteFrameMain = [frameCacheMain spriteFrameByName:strPieceName022];
                    [tempBox setDisplayFrame:spriteFrameMain];
                    
                    [self showConfetti1: tempBox.position.x + (intSizeofPieceWithoutAA/intPieceScalar) yCoord:tempBox.position.y + (intSizeofPieceWithoutAA/intPieceScalar) royR:0.0f geeG:0.0f biV:1.0f];
                    [self showConfetti2: tempBox.position.x + (intSizeofPieceWithoutAA/intPieceScalar) yCoorD:tempBox.position.y + (intSizeofPieceWithoutAA/intPieceScalar) RoyR:0.2f GeeG:0.2f BiV:1.0f];
                    
                    [self showPlus5: tempBox.position.x + (intSizeofPieceWithoutAA/intPieceScalar) yCoorD5:tempBox.position.y + (intSizeofPieceWithoutAA/intPieceScalar) RoyR5:0.2f GeeG5:0.2f BiV5:1.0f];
                    
                    break;
                case 18:
                    spriteFrameMain = [frameCacheMain spriteFrameByName:strPieceName023];
                    [tempBox setDisplayFrame:spriteFrameMain];
                    
                    [self showConfetti1: tempBox.position.x + (intSizeofPieceWithoutAA/intPieceScalar) yCoord:tempBox.position.y + (intSizeofPieceWithoutAA/intPieceScalar) royR:1.0f geeG:0.75f biV:0.0f];
                    [self showConfetti2: tempBox.position.x + (intSizeofPieceWithoutAA/intPieceScalar) yCoorD:tempBox.position.y + (intSizeofPieceWithoutAA/intPieceScalar) RoyR:1.0f GeeG:1.0f BiV:1.0f];
                    
                    [self showPlus10: tempBox.position.x + (intSizeofPieceWithoutAA/intPieceScalar) yCoorD10:tempBox.position.y + (intSizeofPieceWithoutAA/intPieceScalar) RoyR10:1.0f GeeG10:0.75f BiV10:0.0f];
                    
                    break;
                case 19:
                    spriteFrameMain = [frameCacheMain spriteFrameByName:strPieceName024];
                    [tempBox setDisplayFrame:spriteFrameMain];
                    
                    [self showConfetti1: tempBox.position.x + (intSizeofPieceWithoutAA/intPieceScalar) yCoord:tempBox.position.y + (intSizeofPieceWithoutAA/intPieceScalar) royR:1.0f geeG:0.75f biV:0.0f];
                    [self showConfetti2: tempBox.position.x + (intSizeofPieceWithoutAA/intPieceScalar) yCoorD:tempBox.position.y + (intSizeofPieceWithoutAA/intPieceScalar) RoyR:1.0f GeeG:1.0f BiV:1.0f];
                    
                    [self showPlus50: tempBox.position.x + (intSizeofPieceWithoutAA/intPieceScalar) yCoorD50:tempBox.position.y + (intSizeofPieceWithoutAA/intPieceScalar) RoyR50:1.0f GeeG50:0.75f BiV50:0.0f];
                    
                    break;
                case 20:
                    spriteFrameMain = [frameCacheMain spriteFrameByName:strPieceName025];
                    [tempBox setDisplayFrame:spriteFrameMain];
                    
                    [self showConfetti1: tempBox.position.x + (intSizeofPieceWithoutAA/intPieceScalar) yCoord:tempBox.position.y + (intSizeofPieceWithoutAA/intPieceScalar) royR:0.0f geeG:1.0f biV:0.0f];
                    [self showConfetti2: tempBox.position.x + (intSizeofPieceWithoutAA/intPieceScalar) yCoorD:tempBox.position.y + (intSizeofPieceWithoutAA/intPieceScalar) RoyR:0.6f GeeG:1.0f BiV:0.0f];
                    
                    [self showPlus5: tempBox.position.x + (intSizeofPieceWithoutAA/intPieceScalar) yCoorD5:tempBox.position.y + (intSizeofPieceWithoutAA/intPieceScalar) RoyR5:0.0f GeeG5:1.0f BiV5:0.0f];
                    
                    break;
                    
                    
                    
                    
                    
                    
                default:
                    NSLog (@"Integer out of range");
                    
                    break;
                    
            }
        }
    }
    

    
    
    
}



//TODO: NEW ANIMATE INTO POSITION:
-(void)animateObjects {
    
}


//TODO: pieceTick
-(void)pieceTicker:(ccTime)dt2 {

    //0 is player control mode.  1 is gravity mode. 2 is collision.
    
   //deleted all of intPostCollisionMode  code (check game state of all pieces!!) and replace here.
    

    
    
//all devices, approx
//    2014-07-12 12:12:19.379 FruitBunch[1570:907] intPieceTopStartingPosDist notRotSafe: 0.000000
//    2014-07-12 12:12:19.380 FruitBunch[1570:907] intDistanceTraveled: 33.109894    <- (33+281=315)
//    2014-07-12 12:12:19.381 FruitBunch[1570:907] intDistanceToGo: 281.890106
//    2014-07-12 12:12:39.704 FruitBunch[1570:907] intPieceTopStartingPosDist notRotSafe: 281.890106
//    2014-07-12 12:12:39.705 FruitBunch[1570:907] intDistanceTraveled: 315.000000    <-       (315)
//    2014-07-12 12:12:39.705 FruitBunch[1570:907] intDistanceToGo: 0.000000
    
    
    if (intDownHeldDown == 1) {
        
        if (intPlayerCanMove == 1) {
            
            //set counter to 0, move down one, then do it again when counter hits 2, 4, 6, etc.
            //intPopDownBtn = 0;
            
            if (intPopDownBtn == 0) {
                
                if (intPopDownBtnJustPopped == 1) {
                    //do nothing
                } else {
                    NSLog(@"Move down 1 (if possible)! 0*****************************************************************");
                    NSLog(@"*********************************************************************************************");
                    intPopDownBtn = 1;
                    intPopDownBtnJustPopped = 1;
                    
                    //stop and move down 5 ?... hmmm
                    //finish current row...  drop to next...
                    // first see if we're already on a block....
                    // stop blocks and check...
                    
                    
                    
                }
                

            }
            //NSLog(@"holding down...");
            //drop piece on ticker, when stopping, restartPiece
            
            //POP DOWN ONCE THEN EVERY .75 SEC...
            
        }
    }
}

-(void)checkSavedvsUpcomGridCollision {
    
    //    NSLog(@"strSavedBoardPieces %@", strSavedBoardPieces);    //current grid data
    //    NSLog(@"strIncomBoardPieces %@", strIncomBoardPieces);    //incoming grid data
    //    NSLog(@"strUpcomBoardPieces %@", strUpcomBoardPieces);    //upcoming grid data
    
    
}


-(void) runBottomDropper {
    //drop piece into bottom. easy.
    
    NSLog(@"run BottomDropper for piece parts______________________");

    
}


-(void) checkForBoomers {
    NSLog(@"check for sets!   drop pieces sub ready!");
    
    
    
    
}

-(void) dropBottomDroppers {
    
    
    
}


-(void) reStartReDrop {
    
    //coming from pieceTicker ReDrop.                    old: dropAllOpenBoxes ______[self reStartGravityDrop];_____________
 
}


-(void) reStartGravityDrop {

    //coming from dropAllOpenBoxes ___________________
    
    //each piece needs stuff
  
    
}

-(void)dropAllOpenBoxes {
    
    NSLog(@"dropping boxes...  track collisions mode! intPostCollisionMode needs row tracker (1 already is...) [%i]", intPostCollisionMode);
    
    
}


-(void)dropIncomingGrid1RowforUpcomingGrid {
    
    //updates upcomBoard with IncomBoard data (next row is calcd)
    
}


-(void)secondTicker:(ccTime)dt {
    

}

-(void)thirdTicker:(ccTime)dt {
    //intPopDownBtn
    
    //if button held down, add 1 to pop...
    if (intDownHeldDown == 1) {
        
        if (intPlayerCanMove == 1) {
            intPopDownBtn = intPopDownBtn + 1;
            //            NSLog(@"Move down 1 (if possible)! ************************");
            if (intPopDownBtn >= 4) {
                //NSLog(@"Move down 1 (if possible)! 1************************");
                intPopDownBtn = 0;
                intPopDownBtnJustPopped = 1;
            }
            
        }
    }
    
}



-(void)tickerTimer:(ccTime)dt {
    
	//								  //orientation checker, run positionObjects if needed.

   CGSize size = [[CCDirector sharedDirector] winSizeInPixels];
    
    //check if Screen Dimensions have changed for XLATE
    if (size.width != intScreenWidth) {
        //refresh positions:
        intSwitchStatus = 1;
        NSLog(@"SWITCH DETECTED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
        
        //should update intWideMode since we're auto-detected??
        intWideMode = size.width;
        //NSLog(@"intWideMode: %f", intWideMode);
        
    }
    
    if ( intInstantiatedWidth != intScreenWidth) {
        if(intInstantiatedChecked == 0) {
            NSLog(@"Starting in LAND. DETECTED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
            intSwitchStatus = 1;
            intInstantiatedChecked = 1;
        } else {
            intInstantiatedChecked = 1;
        }
    } else {
        intInstantiatedChecked = 1;
    }
    
    if (intSwitchStatus == 1) {
        if (size.width == intScreenWidth) {
            //[self refreshGameAssets];
            // new position for final:
            [self positionObjects];
        }
    }
    
    //need to control:
    //NSLog(@"secondTicker: %i", intPopFX1);
    
}





- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch=[touches anyObject];
    currentColor=ccc4(0,0,0,0); //Transparent >> Draw holes (dig)
	CGPoint touchLocation = [touch locationInView:nil];
	touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];

    
    [[SimpleAudioEngine sharedEngine] playEffect:@"laser_ship.caf"];    
    
	activeLocation=touchLocation;
    touchActiveLocationOK=YES;
}
- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch;
	NSArray *allTouches = [[event allTouches] allObjects];

// ff
    
}


-(void)fingerAction:(CGPoint)p0 :(CGPoint)p1 {

    //ff
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
 //ff
}
- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[self ccTouchesEnded:touches withEvent:event];
}

-(void) rotateCurrentPiece {
    
    //rotate piece 90, and update et al:
    NSLog(@"rotating... first check on rotated block: doe it fit in same space like T?");
    
    NSLog(@"current strIncomPiecesGrid: %@", strIncomPiecesGrid);
    
    //check if overlap (cant rotate)
    // else rotate
    
    //update all boards!
    //1:, convert 3x3 to flat:
    //2 then transpose. Use:
    //  4th, 1st, 2nd, 7th, 5th, 3rd, 8th, 9th, 6th.
    //pop strRCVDArrayRotator
    
    [strRCVDArrayRotator removeAllObjects];
    [strRCVDArrayRotator setArray:[strIncomPiecesGrid componentsSeparatedByString:@"»"]];
    
    [strRCVDArrayRotatorRow1 removeAllObjects];
    [strRCVDArrayRotatorRow1 setArray:[[strRCVDArrayRotator objectAtIndex:0] componentsSeparatedByString:@"«"]];
    [strRCVDArrayRotatorRow2 removeAllObjects];
    [strRCVDArrayRotatorRow2 setArray:[[strRCVDArrayRotator objectAtIndex:1] componentsSeparatedByString:@"«"]];
    [strRCVDArrayRotatorRow3 removeAllObjects];
    [strRCVDArrayRotatorRow3 setArray:[[strRCVDArrayRotator objectAtIndex:2] componentsSeparatedByString:@"«"]];
    
    //new array string:     4th, 1st, 2nd, 7th, 5th, 3rd, 8th, 9th, 6th.
    // strRotatedPiece
    [strRotatedPiece setString:[strRCVDArrayRotatorRow2 objectAtIndex:0]];      //4th
    [strRotatedPiece appendString:@"«"];
    [strRotatedPiece appendString:[strRCVDArrayRotatorRow1 objectAtIndex:0]];   //1st
    [strRotatedPiece appendString:@"«"];
    [strRotatedPiece appendString:[strRCVDArrayRotatorRow1 objectAtIndex:1]];   //2nd
    [strRotatedPiece appendString:@"»"];
    [strRotatedPiece appendString:[strRCVDArrayRotatorRow3 objectAtIndex:0]];   //7th
    [strRotatedPiece appendString:@"«"];
    [strRotatedPiece appendString:[strRCVDArrayRotatorRow2 objectAtIndex:1]];   //5th
    [strRotatedPiece appendString:@"«"];
    [strRotatedPiece appendString:[strRCVDArrayRotatorRow1 objectAtIndex:2]];   //3rd
    [strRotatedPiece appendString:@"»"];
    [strRotatedPiece appendString:[strRCVDArrayRotatorRow3 objectAtIndex:1]];   //8th
    [strRotatedPiece appendString:@"«"];
    [strRotatedPiece appendString:[strRCVDArrayRotatorRow3 objectAtIndex:2]];   //9th
    [strRotatedPiece appendString:@"«"];
    [strRotatedPiece appendString:[strRCVDArrayRotatorRow2 objectAtIndex:2]];   //6th
    
    if ((intPieceTypeSelected == 3) || (intPieceTypeSelected == 8) || (intPieceTypeSelected == 9)) {
        //45 degrees is done.
        
    } else {
        //need 90:
        
        [strRCVDArrayRotator removeAllObjects];
        [strRCVDArrayRotator setArray:[strRotatedPiece componentsSeparatedByString:@"»"]];
        
        [strRCVDArrayRotatorRow1 removeAllObjects];
        [strRCVDArrayRotatorRow1 setArray:[[strRCVDArrayRotator objectAtIndex:0] componentsSeparatedByString:@"«"]];
        [strRCVDArrayRotatorRow2 removeAllObjects];
        [strRCVDArrayRotatorRow2 setArray:[[strRCVDArrayRotator objectAtIndex:1] componentsSeparatedByString:@"«"]];
        [strRCVDArrayRotatorRow3 removeAllObjects];
        [strRCVDArrayRotatorRow3 setArray:[[strRCVDArrayRotator objectAtIndex:2] componentsSeparatedByString:@"«"]];
        
        //new array string:     4th, 1st, 2nd, 7th, 5th, 3rd, 8th, 9th, 6th.
        // strRotatedPiece
        [strRotatedPiece setString:[strRCVDArrayRotatorRow2 objectAtIndex:0]];      //4th
        [strRotatedPiece appendString:@"«"];
        [strRotatedPiece appendString:[strRCVDArrayRotatorRow1 objectAtIndex:0]];   //1st
        [strRotatedPiece appendString:@"«"];
        [strRotatedPiece appendString:[strRCVDArrayRotatorRow1 objectAtIndex:1]];   //2nd
        [strRotatedPiece appendString:@"»"];
        [strRotatedPiece appendString:[strRCVDArrayRotatorRow3 objectAtIndex:0]];   //7th
        [strRotatedPiece appendString:@"«"];
        [strRotatedPiece appendString:[strRCVDArrayRotatorRow2 objectAtIndex:1]];   //5th
        [strRotatedPiece appendString:@"«"];
        [strRotatedPiece appendString:[strRCVDArrayRotatorRow1 objectAtIndex:2]];   //3rd
        [strRotatedPiece appendString:@"»"];
        [strRotatedPiece appendString:[strRCVDArrayRotatorRow3 objectAtIndex:1]];   //8th
        [strRotatedPiece appendString:@"«"];
        [strRotatedPiece appendString:[strRCVDArrayRotatorRow3 objectAtIndex:2]];   //9th
        [strRotatedPiece appendString:@"«"];
        [strRotatedPiece appendString:[strRCVDArrayRotatorRow2 objectAtIndex:2]];   //6th

        
    }
    
    
    NSLog(@"current strRotatedPiece: %@", strRotatedPiece);
    
    //chek if rotated piece fits! otherwise dont do it.
    //load strSavedBoardPieces + strRotatedPiece
    
    //run:
    //[self updateIncomGridWithPiecesGrid];   //no this is only first first aligned piece!
    
    [self checkUpcomGridvsSavedforRotatedorMovedPiece:1];  // type 1:rotate check
    
    if ((intRotate_isClear == 0) || (intColIDd == 0) || (intColIDd == 8)) {
        
        NSLog(@"Unable to rotate! no space avail.");
        //do not rotate... no space.
    } else {
    
        NSLog(@"Able to rotate!");
        //cycle thru like buildBoard coll. then do i/j comparison to check for overlap.
        //                                              upcomboard ok against savedboard? update incomboard.
        //[self updateUpcomGridtoCheckforOKonMove];     //use similar code for Left/Right...
        
        
        
        //then FINALLY set to pieces grid.   Then update sprites grid 301-309
        //THEN UPDATE SAVED!
        [strIncomPiecesGrid setString:strRotatedPiece];
        //update sprites:
        
        [strRCVDUseRotate removeAllObjects];
        [strRCVDUseRotate setArray:[strRotatedPiece componentsSeparatedByString:@"»"]];
        [strRCVDUseRotateRow1 removeAllObjects];
        [strRCVDUseRotateRow1 setArray:[[strRCVDUseRotate objectAtIndex:0] componentsSeparatedByString:@"«"]];
        [strRCVDUseRotateRow2 removeAllObjects];
        [strRCVDUseRotateRow2 setArray:[[strRCVDUseRotate objectAtIndex:1] componentsSeparatedByString:@"«"]];
        [strRCVDUseRotateRow3 removeAllObjects];
        [strRCVDUseRotateRow3 setArray:[[strRCVDUseRotate objectAtIndex:2] componentsSeparatedByString:@"«"]];
        
        //[self pickBoxandSetColorNum:1 :2];
        
        [self pickBoxandSetColorNum:301 isetColorz:[[strRCVDUseRotateRow1 objectAtIndex:0] intValue]];
        [self pickBoxandSetColorNum:302 isetColorz:[[strRCVDUseRotateRow1 objectAtIndex:1] intValue]];
        [self pickBoxandSetColorNum:303 isetColorz:[[strRCVDUseRotateRow1 objectAtIndex:2] intValue]];
        [self pickBoxandSetColorNum:304 isetColorz:[[strRCVDUseRotateRow2 objectAtIndex:0] intValue]];
        [self pickBoxandSetColorNum:305 isetColorz:[[strRCVDUseRotateRow2 objectAtIndex:1] intValue]];
        [self pickBoxandSetColorNum:306 isetColorz:[[strRCVDUseRotateRow2 objectAtIndex:2] intValue]];
        [self pickBoxandSetColorNum:307 isetColorz:[[strRCVDUseRotateRow3 objectAtIndex:0] intValue]];
        [self pickBoxandSetColorNum:308 isetColorz:[[strRCVDUseRotateRow3 objectAtIndex:1] intValue]];
        [self pickBoxandSetColorNum:309 isetColorz:[[strRCVDUseRotateRow3 objectAtIndex:2] intValue]];
        
        //[self pickBoxandSetColorNum:6 isetColorz:9];
        
        //until tracking, collision based on orig piecelayot
        
        //UPDATED SAVED STR ARRAYS FOR ROTATEDOK PIECES:
        //NOTE: Pieceticker is running, so keep it current, (not above advance check?)
        

        
        //[strIncomBoardPieces setString:strUpcomBoardPieces]; , [self dropIncomingGrid1RowforUpcomingGrid];, [self checkSavedvsUpcomGridCollision];
        
        //ROT matches Upcoming Status, and Incom is one behind.
        NSLog(@"strSavedBoardPieces                     %@", strSavedBoardPieces);    //current grid data
        NSLog(@"strIncomBoardPieces                     %@", strIncomBoardPieces);    //incoming grid data
        NSLog(@"strREPLBoardPiecesNewBuffer             %@", strREPLBoardPiecesNewBuffer);
        NSLog(@">");
        NSLog(@"strUpcomBoardPieces                     %@", strUpcomBoardPieces);    //upcoming grid data
        NSLog(@"strBuildBoardPieces                     %@", strBuildBoardPieces);
        NSLog(@"new rot'd to check strUpcomBoardPieces: %@", strRotLRBoardPieces);
        NSLog(@"updating...");
        
        [strUpcomBoardPieces setString:strRotLRBoardPieces];
        [strIncomBoardPieces setString:strREPLBoardPiecesNewBuffer];
        
        //also updated pieces grid:
        //  [strIncomPiecesGrid setString:strRotatedPiece];  alread ydone
        
        //just update UpcomBoard with the new board:!!
        ////ROT matches Upcoming Status, and Incom is one behind.
        
        
        //if incomboard is referenced,... need it too.
        

        
        intRotate_isClear = 0;
        
    }
    
}


//  -(void) checkGridPositionforPieceValue: (NSInteger) iSetRow iSetColz: (NSInteger) iSetCol;   intValueofSavedCell

//-(void) pickBoxandSetColorNum: (NSInteger) iboxtag isetColorz:(NSInteger) icolornum;

 -(void) checkGridPositionforPieceValue: (NSInteger) iSetRow iSetColz: (NSInteger) iSetCol;
{

    
    
    
}

-(void) checkUpcomGridvsSavedforRotatedorMovedPiece: (NSInteger) iRotateLorR;
{
    
    // check strRotatedPiece  as the new strIncomPiecesGrid :

    
}

//  -(void) checkGridPositionforPieceValue: (NSInteger) iSetRow iSetColz: (NSInteger) iSetCol;

-(void) pickBoxandSetColorNum: (NSInteger) iboxtag isetColorz:(NSInteger) icolornum;
{
	//NSLog(@"func tag %i  color %i", iboxtag, icolornum);
    
    tempBox = (CCSprite*)[self getChildByTag:iboxtag];
    
    switch (icolornum)
    {
        case 0:
            //NSLog (@"use texture blank");
            
            spriteFrameMain = [frameCacheMain spriteFrameByName:strPieceName011];
            [tempBox setDisplayFrame:spriteFrameMain];
            break;
        case 1:
            spriteFrameMain = [frameCacheMain spriteFrameByName:strPieceName001];
            [tempBox setDisplayFrame:spriteFrameMain];
            break;
        case 2:
            spriteFrameMain = [frameCacheMain spriteFrameByName:strPieceName002];
            [tempBox setDisplayFrame:spriteFrameMain];
            break;
        case 3:
            spriteFrameMain = [frameCacheMain spriteFrameByName:strPieceName003];
            [tempBox setDisplayFrame:spriteFrameMain];
            break;
        case 4:
            spriteFrameMain = [frameCacheMain spriteFrameByName:strPieceName004];
            [tempBox setDisplayFrame:spriteFrameMain];
            break;
        case 5:
            spriteFrameMain = [frameCacheMain spriteFrameByName:strPieceName005];
            [tempBox setDisplayFrame:spriteFrameMain];
            break;
        case 6:
            spriteFrameMain = [frameCacheMain spriteFrameByName:strPieceName006];
            [tempBox setDisplayFrame:spriteFrameMain];
            break;
        case 7:
            spriteFrameMain = [frameCacheMain spriteFrameByName:strPieceName007];
            [tempBox setDisplayFrame:spriteFrameMain];
            break;
        case 8:
            spriteFrameMain = [frameCacheMain spriteFrameByName:strPieceName008];
            [tempBox setDisplayFrame:spriteFrameMain];
            break;
        case 9:
            spriteFrameMain = [frameCacheMain spriteFrameByName:strPieceName009];
            [tempBox setDisplayFrame:spriteFrameMain];
            break;
        case 10:
            spriteFrameMain = [frameCacheMain spriteFrameByName:strPieceName010];
            [tempBox setDisplayFrame:spriteFrameMain];
            break;
        case 11:
            spriteFrameMain = [frameCacheMain spriteFrameByName:strPieceName011];
            [tempBox setDisplayFrame:spriteFrameMain];
            break;
        case 12:
            spriteFrameMain = [frameCacheMain spriteFrameByName:strPieceName012];
            [tempBox setDisplayFrame:spriteFrameMain];
            break;
        default:
            NSLog (@"Integer out of range");
            
            break;
            
    }
    
    
    
}

-(void) navCallback1: (id) sender
{
	//[(CCLayerMultiplex*)parent_ switchTo:1];
    NSLog(@"btn Up Pressed.");
    
    NSLog(@"ff: %i", intGamePausedforOrient);
    if (intGamePausedforOrient >= 1) {
        NSLog(@"Game is paused...no recogn");
        
    } else {
        if (intPlayerCanMove == 0) {
            NSLog(@"piece auto... no recogn");
        } else {
             NSLog(@"Up pressed.!  *ROTATE PIECE*");
            [self rotateCurrentPiece];
        }
        
       
    }
    
}

-(void) navCallback2: (id) sender
{
	//[(CCLayerMultiplex*)parent_ switchTo:1];
    NSLog(@"btn Down Pressed.");
    
    NSLog(@"ff: %i", intGamePausedforOrient);
    if (intGamePausedforOrient >= 1) {
        NSLog(@"Game is paused...no recogn");
        
    } else {
        NSLog(@"Down pressed Completed.  intDownHeldDown = 0");
        intDownHeldDown = 0;
        intPopDownBtn = 0;
        intPopDownBtnJustPopped = 0;
    }
    
}

-(void) navCallback3: (id) sender
{
	//[(CCLayerMultiplex*)parent_ switchTo:1];
    NSLog(@"btn Left Pressed.");
    
    NSLog(@"ff: %i", intGamePausedforOrient);
    if (intGamePausedforOrient >= 1) {
        NSLog(@"Game is paused...no recogn");
        
    } else {
        
        if (intPlayerCanMove == 0) {
            NSLog(@"piece auto... no recogn");
        } else {
        
        
            NSLog(@"Left pressed.");
            // check if piece can move intColIDd  goes to 0 for centerline piece
          
        }
        
    }
    
}


-(void) navCallback4: (id) sender
{
	//[(CCLayerMultiplex*)parent_ switchTo:1];
    NSLog(@"btn Right Pressed.");
    
    NSLog(@"ff: %i", intGamePausedforOrient);
    if (intGamePausedforOrient >= 1) {
        NSLog(@"Game is paused...no recogn");
        
    } else {
        
        if (intPlayerCanMove == 0) {
            NSLog(@"piece auto... no recogn");
        } else {
            
            NSLog(@"Right pressed.");
            
            // check if piece can move intColIDd  goes to 0 for centerline piece
            
        }
    
    }
    
}

//navCallback5
-(void) navCallback5: (id) sender
{
	//[(CCLayerMultiplex*)parent_ switchTo:1];
    NSLog(@"btn Switch Panes Pressed.  Do Sprite Test.");
    
    NSLog(@"ff: %i", intGamePausedforOrient);
    if (intGamePausedforOrient >= 1) {
        NSLog(@"Game is paused...no recogn");
        
    } else {
        NSLog(@"Switch Panes pressed.");
        
        //no response...
        //Box1a = [CCSprite spriteWithFile:@"piece_mstr_002.png"];
        //Box2a = [CCSprite spriteWithFile:@"piece_mstr_001.png"];
        
        //test 2:
        //[Box2a setDisplayFrame:frameName];
        
        NSLog(@"displayedFrame: %@", Box3a.displayedFrame);
        
        //[Box3a setDisplayFrame:@"piece_mstr_002.png"];
        
        //[Box3a setDisplayFrame:2];
        
        //WORKS GOOD FOR FLIP:
//        CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
//        //        CCSpriteFrame* frame = [frameCache spriteFrameByName:@"new_image.png"];
//        CCSpriteFrame* frame = [frameCache spriteFrameByName:@"piece_mstr_009.png"];
        

		//USING NON)BLANK DEFAULT FOR SWITCH FOR NOW FOR TESTING DEVICE COMPLIANCE:	strCurrentBlankDefaultPiece
		//spriteFrameMain = [frameCacheMain spriteFrameByName:@"piece_mstr_009.png"];
        
        spriteFrameMain = [frameCacheMain spriteFrameByName:strCurrentTestPiece];
        [Box3a setDisplayFrame:spriteFrameMain];
        
        NSLog(@"displayedFrameafter: %@", Box3a.displayedFrame);
        
        
        //    CCSpriteFrameCache *frameCacheMain;
        //    CCSpriteFrame *spriteFrameMain;
        //    NSMutableArray *animationFramesMain = nil;   //=12
        
        //spriteFrameMain = [frameCacheMain spriteFrameByName:@"piece_mstr_003.png"];
        spriteFrameMain = [frameCacheMain spriteFrameByName:strPieceName008];
		[Box1a setDisplayFrame:spriteFrameMain];
        
        //get and set according to grid!



//        CCAnimation *animation = [CCAnimation animationWithFrames:animationFramesBoom1 delay:0.05f];
//        CCAnimate *animate = [CCAnimate actionWithAnimation:animation];
//        CCRepeatForever *repeat = [CCRepeatForever actionWithAction:animate];
        
        //strPieceName008
        
        CCAnimation *animation = [CCAnimation animationWithFrames:animationFramesMain delay:0.05f];
        CCAnimate *animate = [CCAnimate actionWithAnimation:animation];
        CCRepeatForever *repeat = [CCRepeatForever actionWithAction:animate];
        
        //CCAction *moveAction = [CCMoveBy actionWithDuration:2.0f position:CGPointMake(500.0f,0.0f)];
        [Box5a runAction:repeat];
        
        //[self checkGridPositionforPieceValue: (intRowIDd+1) iSetColz:intColIDd];
        
        
        
//        [self showPlus10: Box1a.position.x + (intSizeofPieceWithoutAA/4) yCoord10:Box1a.position.y + (intSizeofPieceWithoutAA/4) royR10:1.0f geeG10:0.7f biV10:0.0f];

        
       //[self showConfetti1: Box1a.position.x + (intSizeofPieceWithoutAA/4) yCoord:Box1a.position.y + (intSizeofPieceWithoutAA/4)
         //              royR:1.0f geeG:0.7f biV:0.0f];
        
        
        
        ///__________________
        
        if (CC_CONTENT_SCALE_FACTOR() > 1) {
            //emitter.position = ccp(Box1a.position.x + (intSizeofPieceWithoutAA/4), Box1a.position.y + (intSizeofPieceWithoutAA/4));
        
            [self showConfetti1: Box1a.position.x + (intSizeofPieceWithoutAA/4) yCoord:Box1a.position.y + (intSizeofPieceWithoutAA/4)
                           royR:1.0f geeG:0.7f biV:0.0f];
            [self showConfetti2: Box1a.position.x + (intSizeofPieceWithoutAA/4) yCoorD:Box1a.position.y + (intSizeofPieceWithoutAA/4)
                           RoyR:1.0f GeeG:1.0f BiV:1.0f];
//            [self showPlus10: Box1a.position.x + (intSizeofPieceWithoutAA/4) yCoorD10:Box1a.position.y + (intSizeofPieceWithoutAA/4) RoyR10:1.0f GeeG10:0.7f BiV10:0.0f];
            //[self showPlus1: Box1a.position.x + (intSizeofPieceWithoutAA/4) yCoorD1:Box1a.position.y + (intSizeofPieceWithoutAA/4) RoyR1:1.0f GeeG1:0.7f BiV1:0.0f];
            
            [self showPlus100: Box1a.position.x + (intSizeofPieceWithoutAA/4) yCoorD100:Box1a.position.y + (intSizeofPieceWithoutAA/4) RoyR100:1.0f GeeG100:0.7f BiV100:0.0f];
            
        } else {
            //emitter.position = ccp(Box1a.position.x + (intSizeofPieceWithoutAA/2), Box1a.position.y + (intSizeofPieceWithoutAA/2));
        
            [self showConfetti1: Box1a.position.x + (intSizeofPieceWithoutAA/2) yCoord:Box1a.position.y + (intSizeofPieceWithoutAA/2)
                           royR:1.0f geeG:0.7f biV:0.0f];
            [self showConfetti2: Box1a.position.x + (intSizeofPieceWithoutAA/2) yCoorD:Box1a.position.y + (intSizeofPieceWithoutAA/2)
                           RoyR:1.0f GeeG:1.0f BiV:1.0f];
            //[self showPlus10: Box1a.position.x + (intSizeofPieceWithoutAA/2) yCoorD10:Box1a.position.y + (intSizeofPieceWithoutAA/2) RoyR10:1.0f GeeG10:0.7f BiV10:0.0f];
            //[self showPlus1: Box1a.position.x + (intSizeofPieceWithoutAA/2) yCoorD1:Box1a.position.y + (intSizeofPieceWithoutAA/2) RoyR1:1.0f GeeG1:0.7f BiV1:0.0f];
            //[self showPlus5: Box1a.position.x + (intSizeofPieceWithoutAA/2) yCoorD5:Box1a.position.y + (intSizeofPieceWithoutAA/2) RoyR5:1.0f GeeG5:0.7f BiV5:0.0f];
            //[self showPlus50: Box1a.position.x + (intSizeofPieceWithoutAA/2) yCoorD50:Box1a.position.y + (intSizeofPieceWithoutAA/2) RoyR50:1.0f GeeG50:0.7f BiV50:0.0f];
            [self showPlus100: Box1a.position.x + (intSizeofPieceWithoutAA/2) yCoorD100:Box1a.position.y + (intSizeofPieceWithoutAA/2) RoyR100:1.0f GeeG100:0.7f BiV100:0.0f];
            
            
            
            
        }
        

    }
    
}

-(void) navCallback6: (id) sender
{
	//[(CCLayerMultiplex*)parent_ switchTo:1];
    NSLog(@"btn Pause Pressed.");
    
    
    UIAlertView* dialogZ1 = [[UIAlertView alloc] init];
	[dialogZ1 setDelegate:self];
	[dialogZ1 setTitle:@"PAUSED"];
	[dialogZ1 setMessage:@"Ready when you are!"];
	[dialogZ1 addButtonWithTitle:@"GO!"];
	//[dialog addButtonWithTitle:@"Exit Game"];
	//[dialogZ addButtonWithTitle:@"No"];
	[dialogZ1 show];
	[dialogZ1 release];
	
	
	//disabled for now:  piece tranking/animation issue/do Manually for now
	//[[CCDirector sharedDirector] pause];
    
    
    
//    NSLog(@"ff: %i", intGamePausedforOrient);
//    if (intGamePausedforOrient >= 1) {
//        NSLog(@"Game is paused...no recogn");
//        
//    } else {
//        NSLog(@"Right pressed.");
//    }
    
}






-(void)info {
    
    intGamePausedbyPlayer = 1;
    
    [[CCDirector sharedDirector] replaceScene:[CreditsLayer scene]];
}





-(void)pressUpButton {
   //not used... yet

}




//TODO: Dialog Button Section
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	//new one to add:
	//"Let me at 'em!"
	
    CGSize size = [[CCDirector sharedDirector] winSizeInPixels];
	
    //	if (intSoundSetting == 0) {
    //		[[SimpleAudioEngine sharedEngine] playEffect:@"Turret_Servo_1.caf" pitch:1.0f pan:0.0f gain:1.0f];
    //	}
	
	NSString *buttonTitleZ = [alertView buttonTitleAtIndex: buttonIndex];
	
	if ([buttonTitleZ isEqualToString: @"Yes"])
	{
		exit(0);
		
	}
	
	//[[CCDirector sharedDirector] resume];
	if ([buttonTitleZ isEqualToString: @"GO!"])
	{
        
        //reset game for now:
        [strSavedBoardPieces setString:@"0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»0»0»0»0«0»0»0»0»0»3»6»0»0«0»0»0»0»0»3»6»0»0«0»0»0»0»0»3»6»0»0«0»0»0»0»0»3»6»0»0«0»0»0»4»3»5»6»0»0«0»0»0»4»3»5»6»0»0«0»0»0»4»3»1»6»0»0«0»0»1»2»1»1»1»0»0"];
        
        //need
//        for (int i = 301; i <= 309 ; ++i) {
//            tempBox = (CCSprite*)[self getChildByTag:i];
//            spriteFrameMain = [frameCacheMain spriteFrameByName:strPieceName001];
//            [tempBox setDisplayFrame:spriteFrameMain];
//        }
        
        intPopDownBtn = 0;
        intPopDownBtnJustPopped = 0;
        
        intPlayerCanMove = 1;
        
        intCurrentGridIsSet = 0;
        intCurrentPieceIsSet = 0;
        
        intPostCollisionMode = 0;
        
        intDropTimeLength = 20.5;
        
        intPrevRowID = 0;
        intPrevColID = 0;
        intRowIDd = 0;
        intColIDd = 0;
        
        intPieceTopStartingPosition = 9999;
        
        intCurrentRowforPiece = 1;
        
        intPieceTypeSelected = 0;
        
        intPieceTypeCounter = 0;
        
        intPiece1TypeCounter = 0;
        intPiece2TypeCounter = 0;
        intPiece3TypeCounter = 0;
        intPiece4TypeCounter = 0;
        intPiece5TypeCounter = 0;
        intPiece6TypeCounter = 0;
        intPiece7TypeCounter = 0;
        intPiece8TypeCounter = 0;
        intPiece9TypeCounter = 0;
        intAdd10ToCurrent = 0;
        
        intPopperScansCompleted = 0;
        
        intPiece1of9Drop = 0;
        intPiece2of9Drop = 0;
        intPiece3of9Drop = 0;
        intPiece4of9Drop = 0;
        intPiece5of9Drop = 0;
        intPiece6of9Drop = 0;
        intPiece7of9Drop = 0;
        intPiece8of9Drop = 0;
        intPiece9of9Drop = 0;
        
        intPiece1of9ReDrop = 0;
        intPiece2of9ReDrop = 0;
        intPiece3of9ReDrop = 0;
        intPiece4of9ReDrop = 0;
        intPiece5of9ReDrop = 0;
        intPiece6of9ReDrop = 0;
        intPiece7of9ReDrop = 0;
        intPiece8of9ReDrop = 0;
        intPiece9of9ReDrop = 0;
        
        intGravityNewRowHit = 0;
        
        intPiece1of9CheckForRowBuster = 0;
        intPiece2of9CheckForRowBuster = 0;
        intPiece3of9CheckForRowBuster = 0;
        
        
        
        [self addDemoPiecesLayersFromGrid];
        
        [self addFirstPiece];
        
        
        
        

        
        
        
        
        
        //unpause the game
        
        
        //[[CCDirector sharedDirector] resume];
        
        
        
//        //check if Screen Dimensions have changed for XLATE
//        //if (size.width != intScreenWidth) {
//            //refresh positions:
//            intSwitchStatus = 1;
//        //}
//        
//        if (intSwitchStatus == 1) {
//            //if (size.width == intScreenWidth) {
//                //[self refreshGameAssets];
//                // new position for final:
//                [self positionObjects];
//                [self repositionFirstPiece];
//            //}
//        }
//        
        
        
		
		//[[CCDirector sharedDirector] resume];
		
		
	} else if ([buttonTitleZ isEqualToString: @"No"]) {
        
		//	if ([buttonTitleZ isEqualToString: @"No"])
		//	{
        //exit(0);
        //do nothing...
		[[CCDirector sharedDirector] resume];
		
		
	} else if ([buttonTitleZ isEqualToString: @"Let me at 'em!"]) {
		
		//they are pleased with the news!
		
		//	if ([buttonTitleZ isEqualToString: @"No"])
		//	{
		//exit(0);
		//do nothing...
		//[[CCDirector sharedDirector] resume];
		
		
	} else {
		////   high score stuff:
        //
        //    
        //    //LoadingBox.opacity = 0;
        //
		
		
	}
    
	
}


-(void) showConfetti1: (float) xCoord yCoord: (float) yCoordz royR: (float) royRz geeG: (float) geeGz biV: (float) biVz;
{
    
    //NSLog(@"showConfetti1: %f,%f   %f/%f/%f", xCoord, yCoordz, royRz, geeGz, biVz);
    
    emitter = [[CCParticleExplosion alloc] initWithTotalParticles:12];
    
    [emitter autorelease];
    emitter.autoRemoveOnFinish = YES;
    
    emitter.position = ccp(xCoord,yCoordz);
    
    emitter.duration = 1.25f;
    
    //changes where the trails goes to:  (this is down, -200, -200, up to left, etc)
    emitter.gravity = ccp(0,0);
    

    
    ccColor4F startColor = {royRz, geeGz, biVz, 1.0f};
    
    emitter.startColor = startColor;
    
    ccColor4F startColorVar = {0.0f, 0.0f, 0.0f, 0.0f};
    
    emitter.startColorVar = startColorVar;
    //
    
    ccColor4F endColor = {royRz, geeGz, biVz, 0.0f};
    
    emitter.endColor = endColor;
    
    ccColor4F endColorVar = {0.0f, 0.0f, 0.0f, 0.0f};
    
    emitter.endColorVar = endColorVar;
    
    emitter.speed = 24;
    emitter.speedVar = 7;
    
    //
    //    emitter.angle = -180;
    //    emitter.angleVar = 0;
    //
    //    emitter.posVar = ccp(100, 100);
    //    emitter.angleVar = 0;
    
    emitter.life = 1.25f;
    emitter.lifeVar = 1.0f;
    
    if (inttypeOfHD == 0) {
        emitter.scale = 0.75;
    } else if (inttypeOfHD == 1) {
        emitter.scale = 0.75;
    } else if (inttypeOfHD == 2) {
        emitter.scale = 1.5;
    } else {
        emitter.scale = 1.5;
    }
    
    //emitter.texture = [[CCTextureCache sharedTextureCache] addImage:@"starImage.png"];
    //emitter.texture = [[CCTextureCache sharedTextureCache] addImage:@"stratoBall_16.png"];
    //emitter.texture = [[CCTextureCache sharedTextureCache] addImage:@"vaportrail.png"];
    emitter.texture = [[CCTextureCache sharedTextureCache] addImage:@"star_shape1.png"];

    //emitter.texture = [CCSprite spriteWithFile:@"star_shape1.png"];
    
    // [CCSprite spriteWithFile:@"image.png"];
    //int intDurationSetter = 0.1f;
    
    [self addChild:emitter z:500];
    

    
}

-(void) showConfetti2: (float) xCoorD yCoorD: (float) yCoorDz RoyR: (float) RoyRz GeeG: (float) GeeGz BiV: (float) BiVz;
{
    //NSLog(@"showConfetti2: %f,%f   %f/%f/%f", xCoorD, yCoorDz, RoyRz, GeeGz, BiVz);
    
    emitter = [[CCParticleExplosion alloc] initWithTotalParticles:12];
    
    [emitter autorelease];
    emitter.autoRemoveOnFinish = YES;
    
//    if (CC_CONTENT_SCALE_FACTOR() > 1) {
//        emitter.position = ccp(Box1a.position.x + (intSizeofPieceWithoutAA/4), Box1a.position.y + (intSizeofPieceWithoutAA/4));
//    } else {
//        emitter.position = ccp(Box1a.position.x + (intSizeofPieceWithoutAA/2), Box1a.position.y + (intSizeofPieceWithoutAA/2));
//    }
    
    emitter.position = ccp(xCoorD,yCoorDz);
    
    emitter.duration = 1.25f;
    
    //changes where the trails goes to:  (this is down, -200, -200, up to left, etc)
    emitter.gravity = ccp(0,0);
    
    
    ccColor4F startColor = {RoyRz, GeeGz, BiVz, 1.0f};
    
    emitter.startColor = startColor;
    
    ccColor4F startColorVar = {0.0f, 0.0f, 0.0f, 0.0f};
    
    emitter.startColorVar = startColorVar;
    //
    
    ccColor4F endColor = {RoyRz, GeeGz, BiVz, 0.0f};
    
    emitter.endColor = endColor;
    
    ccColor4F endColorVar = {0.0f, 0.0f, 0.0f, 0.0f};
    
    emitter.endColorVar = endColorVar;
    
    emitter.speed = 25;
    emitter.speedVar = 7;
    
    emitter.life = 1.25f;
    emitter.lifeVar = 1.0f;
    
    if (inttypeOfHD == 0) {
        emitter.scale = 0.75;
    } else if (inttypeOfHD == 1) {
        emitter.scale = 0.75;
    } else if (inttypeOfHD == 2) {
        emitter.scale = 1.5;
    } else {
        emitter.scale = 1.5;
    }
    
    
    emitter.texture = [[CCTextureCache sharedTextureCache] addImage:@"star_shape2.png"];
    
    //int intDurationSetter = 0.1f;
    
    [self addChild:emitter z:499];
    
}


-(void) showPlus1: (float) xCoorD1 yCoorD1: (float) yCoorDz1 RoyR1: (float) RoyRz1 GeeG1: (float) GeeGz1 BiV1: (float) BiVz1;
{
    emitter = [[CCParticleSun alloc] initWithTotalParticles:1];
    
    [emitter autorelease];
    emitter.autoRemoveOnFinish = YES;

    emitter.position = ccp(xCoorD1,yCoorDz1);
    emitter.duration = 1.5f;
    
    //changes where the trails goes to:  (this is down, -200, -200, up to left, etc)
    emitter.gravity = ccp(0,0);
    
    ccColor4F startColor = {RoyRz1, GeeGz1, BiVz1, 1.0f};
    emitter.startColor = startColor;
    ccColor4F startColorVar = {0.0f, 0.0f, 0.0f, 0.0f};
    emitter.startColorVar = startColorVar;
    
    ccColor4F endColor = {RoyRz1, GeeGz1, BiVz1, 0.0f};
    emitter.endColor = endColor;
    ccColor4F endColorVar = {0.0f, 0.0f, 0.0f, 0.0f};
    emitter.endColorVar = endColorVar;
    
    emitter.speed = 3;
    emitter.speedVar = 1;
    
    emitter.life = 1.5f;
    emitter.lifeVar = 0.0f;
    emitter.angleVar = 0.0f;
    emitter.blendAdditive = NO;
    
    if (inttypeOfHD == 0) {
        emitter.scale = 1.0;
    } else if (inttypeOfHD == 1) {
        emitter.scale = 1.0;
    } else if (inttypeOfHD == 2) {
        emitter.scale = 2.0;
    } else {
        emitter.scale = 2.0;
    }
    
    emitter.texture = [[CCTextureCache sharedTextureCache] addImage:@"plus1.png"];
    
    [self addChild:emitter z:501];
    
}

-(void) showPlus5: (float) xCoorD5 yCoorD5: (float) yCoorDz5 RoyR5: (float) RoyRz5 GeeG5: (float) GeeGz5 BiV5: (float) BiVz5;
{
    emitter = [[CCParticleSun alloc] initWithTotalParticles:1];
    
    [emitter autorelease];
    emitter.autoRemoveOnFinish = YES;
    
    emitter.position = ccp(xCoorD5,yCoorDz5);
    emitter.duration = 1.5f;
    
    //changes where the trails goes to:  (this is down, -200, -200, up to left, etc)
    emitter.gravity = ccp(0,0);
    
    ccColor4F startColor = {RoyRz5, GeeGz5, BiVz5, 1.0f};
    emitter.startColor = startColor;
    ccColor4F startColorVar = {0.0f, 0.0f, 0.0f, 0.0f};
    emitter.startColorVar = startColorVar;
    
    ccColor4F endColor = {RoyRz5, GeeGz5, BiVz5, 0.0f};
    emitter.endColor = endColor;
    ccColor4F endColorVar = {0.0f, 0.0f, 0.0f, 0.0f};
    emitter.endColorVar = endColorVar;
    
    emitter.speed = 3;
    emitter.speedVar = 1;
    
    emitter.life = 1.5f;
    emitter.lifeVar = 0.0f;
    emitter.angleVar = 0.0f;
    emitter.blendAdditive = NO;
    
    if (inttypeOfHD == 0) {
        emitter.scale = 1.0;
    } else if (inttypeOfHD == 1) {
        emitter.scale = 1.0;
    } else if (inttypeOfHD == 2) {
        emitter.scale = 2.0;
    } else {
        emitter.scale = 2.0;
    }
    
    emitter.texture = [[CCTextureCache sharedTextureCache] addImage:@"plus5.png"];
    
    [self addChild:emitter z:501];
    
}


-(void) showPlus10: (float) xCoorD10 yCoorD10: (float) yCoorDz10 RoyR10: (float) RoyRz10 GeeG10: (float) GeeGz10 BiV10: (float) BiVz10;
{
    //NSLog(@"showConfetti2: %f,%f   %f/%f/%f", xCoorD, yCoorDz, RoyRz, GeeGz, BiVz);
    
    emitter = [[CCParticleSun alloc] initWithTotalParticles:1];
    
    [emitter autorelease];
    emitter.autoRemoveOnFinish = YES;
    
    //    if (CC_CONTENT_SCALE_FACTOR() > 1) {
    //        emitter.position = ccp(Box1a.position.x + (intSizeofPieceWithoutAA/4), Box1a.position.y + (intSizeofPieceWithoutAA/4));
    //    } else {
    //        emitter.position = ccp(Box1a.position.x + (intSizeofPieceWithoutAA/2), Box1a.position.y + (intSizeofPieceWithoutAA/2));
    //    }
    
    emitter.position = ccp(xCoorD10,yCoorDz10);
    
    emitter.duration = 1.5f;
    
    //changes where the trails goes to:  (this is down, -200, -200, up to left, etc)
    emitter.gravity = ccp(0,0);
    
    
    ccColor4F startColor = {RoyRz10, GeeGz10, BiVz10, 1.0f};
    
    emitter.startColor = startColor;
    
    ccColor4F startColorVar = {0.0f, 0.0f, 0.0f, 0.0f};
    
    emitter.startColorVar = startColorVar;
    //
    
    ccColor4F endColor = {RoyRz10, GeeGz10, BiVz10, 0.0f};
    
    emitter.endColor = endColor;
    
    ccColor4F endColorVar = {0.0f, 0.0f, 0.0f, 0.0f};
    
    emitter.endColorVar = endColorVar;
    
    emitter.speed = 3;
    emitter.speedVar = 1;
    
    emitter.life = 2.0f;
    emitter.lifeVar = 0.0f;
    
    emitter.angleVar = 0.0f;
    
    emitter.blendAdditive = NO;
    
    
    if (inttypeOfHD == 0) {
        emitter.scale = 1.0;
    } else if (inttypeOfHD == 1) {
        emitter.scale = 1.0;
    } else if (inttypeOfHD == 2) {
        emitter.scale = 2.0;
    } else {
        emitter.scale = 2.0;
    }
    
    
    emitter.texture = [[CCTextureCache sharedTextureCache] addImage:@"plus10.png"];
    
    //int intDurationSetter = 0.1f;
    
    [self addChild:emitter z:501];
    
}

-(void) showPlus50: (float) xCoorD50 yCoorD50: (float) yCoorDz50 RoyR50: (float) RoyRz50 GeeG50: (float) GeeGz50 BiV50: (float) BiVz50;
{
    emitter = [[CCParticleSun alloc] initWithTotalParticles:1];
    
    [emitter autorelease];
    emitter.autoRemoveOnFinish = YES;
    
    emitter.position = ccp(xCoorD50,yCoorDz50);
    emitter.duration = 1.5f;
    
    //changes where the trails goes to:  (this is down, -200, -200, up to left, etc)
    emitter.gravity = ccp(0,0);
    
    ccColor4F startColor = {RoyRz50, GeeGz50, BiVz50, 1.0f};
    emitter.startColor = startColor;
    ccColor4F startColorVar = {0.0f, 0.0f, 0.0f, 0.0f};
    emitter.startColorVar = startColorVar;
    
    ccColor4F endColor = {RoyRz50, GeeGz50, BiVz50, 0.0f};
    emitter.endColor = endColor;
    ccColor4F endColorVar = {0.0f, 0.0f, 0.0f, 0.0f};
    emitter.endColorVar = endColorVar;
    
    emitter.speed = 3;
    emitter.speedVar = 1;
    
    emitter.life = 1.5f;
    emitter.lifeVar = 0.0f;
    emitter.angleVar = 0.0f;
    emitter.blendAdditive = NO;
    
    if (inttypeOfHD == 0) {
        emitter.scale = 1.0;
    } else if (inttypeOfHD == 1) {
        emitter.scale = 1.0;
    } else if (inttypeOfHD == 2) {
        emitter.scale = 2.0;
    } else {
        emitter.scale = 2.0;
    }
    
    emitter.texture = [[CCTextureCache sharedTextureCache] addImage:@"plus50.png"];
    
    [self addChild:emitter z:501];
    
}

-(void) showPlus100: (float) xCoorD100 yCoorD100: (float) yCoorDz100 RoyR100: (float) RoyRz100 GeeG100: (float) GeeGz100 BiV100: (float) BiVz100;
{
    //NSLog(@"showConfetti2: %f,%f   %f/%f/%f", xCoorD, yCoorDz, RoyRz, GeeGz, BiVz);
    
    emitter = [[CCParticleSun alloc] initWithTotalParticles:1];
    
    [emitter autorelease];
    emitter.autoRemoveOnFinish = YES;
    
    //    if (CC_CONTENT_SCALE_FACTOR() > 1) {
    //        emitter.position = ccp(Box1a.position.x + (intSizeofPieceWithoutAA/4), Box1a.position.y + (intSizeofPieceWithoutAA/4));
    //    } else {
    //        emitter.position = ccp(Box1a.position.x + (intSizeofPieceWithoutAA/2), Box1a.position.y + (intSizeofPieceWithoutAA/2));
    //    }
    
    emitter.position = ccp(xCoorD100,yCoorDz100);
    
    emitter.duration = 1.5f;
    
    //changes where the trails goes to:  (this is down, -200, -200, up to left, etc)
    emitter.gravity = ccp(0,0);
    
    
    ccColor4F startColor = {RoyRz100, GeeGz100, BiVz100, 1.0f};
    
    emitter.startColor = startColor;
    
    ccColor4F startColorVar = {0.0f, 0.0f, 0.0f, 0.0f};
    
    emitter.startColorVar = startColorVar;
    //
    
    ccColor4F endColor = {RoyRz100, GeeGz100, BiVz100, 0.0f};
    
    emitter.endColor = endColor;
    
    ccColor4F endColorVar = {0.0f, 0.0f, 0.0f, 0.0f};
    
    emitter.endColorVar = endColorVar;
    
    emitter.speed = 3;
    emitter.speedVar = 1;
    
    emitter.life = 2.0f;
    emitter.lifeVar = 0.0f;
    
    emitter.angleVar = 0.0f;
    
    emitter.blendAdditive = NO;
    
    
    if (inttypeOfHD == 0) {
        emitter.scale = 1.2;
    } else if (inttypeOfHD == 1) {
        emitter.scale = 1.2;
    } else if (inttypeOfHD == 2) {
        emitter.scale = 2.4;
    } else {
        emitter.scale = 2.4;
    }
    
    
    emitter.texture = [[CCTextureCache sharedTextureCache] addImage:@"plus100.png"];
    
    //int intDurationSetter = 0.1f;
    
    [self addChild:emitter z:501];
    
}


-(void) resetGroundColors {
    //ff
}

-(void) initGameScene {
    
    //use animation  for switch keyboard button
    
    NSLog(@"''' OLD INIT DONT USE''''");
    
}


-(void)appendNewGround {
    //ff
}


-(void)refreshGameAssets {
    
    // use animation below for switch keyboard button!
    
    NSLog(@"refreshing Screen!");
    NSLog(@"PAUSE game...");
    
    intGamePausedforOrient = intGamePausedforOrient + 1;  //multiple concurrent attempts tracked
    
    //intSwitchStatus is should we kick off Movement of Things? No, we are here to do that now:
    intSwitchStatus = 0;
    
    
}




-(void)continueGameAfterXFR {
    
    NSLog(@"Request to resume game...");
    NSLog(@"A pause was completed...");
    intGamePausedforOrient = intGamePausedforOrient - 1;
    
}


@end
