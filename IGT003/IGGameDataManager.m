//
//  IGGameDataManager.m
//  IGT003
//
//  Created by 鹏 李 on 12-6-13.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//
#import "IGGameDataManager.h"

// 写入游戏数据
bool GamePlayingData_Write(GamePlayingData* data, const char* fileName)
{
	FILE* out_file = fopen(fileName, "w");
	
	char magicNum[5] = "iguor";
	
	fwrite(&magicNum[0], 4, 1, out_file);
	fwrite(data, sizeof(GamePlayingData), 1, out_file);

	fclose(out_file);
	return false;
}

// 读取游戏数据
bool GamePlayingData_Read(GamePlayingData* data,  const char* fileName)
{
	FILE* in_file = fopen(fileName, "r");
	
	char magicNum[5];
	fread(magicNum, 5, 1, in_file);
	if (strcmp(magicNum, "iguor"))
	{
		fclose(in_file);
		return false;
	}
	
	fread(data, sizeof(GamePlayingData), 1, in_file);
	fclose(in_file);
	return true;
}

// 游戏数据初始化
void GamePlayingData_Init(GamePlayingData* data)
{
	data->m_time = 60;
	data->m_scores = 0;
	for (int i = 0; i < kXDirCellNum; i++)
	{
		for (int j = 0; j < kYDirCellNum; j++)
		{
			data->m_fruitIdx[i][j] = -1;
		}
	}
    
    srand(time(nil));
    for (int i = 0; i < kFruitKinds; i++)
	{
        data->m_fruitOdr[i] = i;
	}
    
    for (int i=kFruitKinds; i>0; i--)
    {
        int temp;
        int randNum = rand();
        temp = data->m_fruitOdr[i-1];
        data->m_fruitOdr[i-1] = data->m_fruitOdr[randNum%kFruitKinds];
        data->m_fruitOdr[randNum%kFruitKinds] = temp;
        
    }
}

@implementation IGGameDataManager

@synthesize mainWindow = m_mainWindow;
@synthesize initTime = m_time;
@synthesize hasDataSaved = m_hasDataSaved;
@synthesize score = m_score;
@synthesize playerName = m_playerName;
@synthesize playerNameListNormal = m_playerNameListNormal;
@synthesize scoreListNormal = m_scoreListNormal;
@synthesize soundVolume = m_soundVolume;
@synthesize musicVolume = m_musicVolume;
@synthesize isSoundOn = m_isSoundOn;
@synthesize isMusicOn = m_isMusicOn;

// 读取游戏数据
- (GamePlayingData*) getPlayingData
{
	return &m_playingData;
}

// 取得用户信息
- (id) getUserData:(NSString*) key
{
	return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

// 写入用户信息
- (void) storeUserData:(id)data forKey:(NSString*)key
{
	[[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
}

// 音效音量初始化
- (CGFloat) realSoundVolume
{
	return m_isSoundOn ? (1.0 / 9.0) * m_soundVolume : 0;
}

// 背景音乐音量初始化
- (CGFloat) realMusicVolume
{
	return m_isMusicOn ? (1.0 / 9.0) * m_musicVolume : 0;
}

- (id) init
{
	[super init];
	
	m_mainWindow = nil;
	m_hasDataSaved = false;
	m_isMusicOn = true;
	m_isSoundOn = true;
	m_time = 60;
	m_musicVolume = 5;
	m_soundVolume = 5;
	m_score = 0;
	m_gameState = Game_MainMenu;
	m_playerName = [[NSString alloc] initWithString:@"lipeng"];
	m_playerNameListNormal = [[NSMutableArray alloc] initWithCapacity:21];
	m_scoreListNormal = [[NSMutableArray alloc] initWithCapacity:21];
	
    GamePlayingData_Init(&m_playingData);
	return self;
}


- (void) dealloc
{
	[m_playerName release];
	[super dealloc];
}

- (void) save
{
	id tmpId = [NSNumber numberWithInt:1];
	tmpId = [NSNumber numberWithBool:m_hasDataSaved];
	[self storeUserData:tmpId forKey:@"HasDataSaved"];
	
	tmpId = [NSNumber numberWithBool:m_isSoundOn];
	[self storeUserData:tmpId forKey:@"IsSoundOn"];
	
	tmpId = [NSNumber numberWithBool:m_isMusicOn];
	[self storeUserData:tmpId forKey:@"IsMusicOn"];
	
	[self storeUserData:m_playerName forKey:@"PlayerName"];
	tmpId = [NSNumber numberWithInt:m_time];
	[self storeUserData:tmpId forKey:@"InitTime"];
	
	tmpId = [NSNumber numberWithInt:m_soundVolume];
	[self storeUserData:tmpId forKey:@"SoundVolume"];
	
	tmpId = [NSNumber numberWithInt:m_musicVolume];
	[self storeUserData:tmpId forKey:@"MusicVolume"];
	
	[self storeUserData:m_playerNameListNormal forKey:@"PlayerNameListNormal"];
	[self storeUserData:m_scoreListNormal forKey:@"ScoreListNormal"];
    [self storeUserData:m_fruitOrder forKey:@"FruitOrder"];

	if (m_hasDataSaved)
	{
		tmpId = [NSString stringWithString:@"FriutBaoBao_DataSaved"];
		[self storeUserData:tmpId forKey:@"DataSavedFileName"];
		
		NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString* documentsDirectory = [paths objectAtIndex:0];
		NSString *filePath = [documentsDirectory stringByAppendingPathComponent:(NSString*)tmpId];
		GamePlayingData_Write(&m_playingData, [filePath UTF8String]);
	}
}


- (void) load
{
    id tmpId = [NSNumber numberWithInt:1];
	tmpId = [self getUserData:@"HasDataSaved"];
	if (tmpId)
	{
		m_hasDataSaved = [(NSNumber*)tmpId boolValue];
	}
	
	tmpId = [self getUserData:@"IsSoundOn"];
	if (tmpId)
	{
		m_isSoundOn = [(NSNumber*)tmpId boolValue];
	}
	
	tmpId = [self getUserData:@"IsMusicOn"];
	if (tmpId)
	{
		m_isMusicOn = [(NSNumber*)tmpId boolValue];
	}
	
	tmpId = [self getUserData:@"InitTime"];
	if (tmpId)
	{
		m_time = [(NSNumber*)tmpId intValue];
	}
	
	tmpId = [self getUserData:@"MusicVolume"];
	if (tmpId)
	{
		m_musicVolume = [(NSNumber*)tmpId intValue];
	}
	
	tmpId = [self getUserData:@"SoundVolume"];
	if (tmpId)
	{
		m_soundVolume = [(NSNumber*)tmpId intValue];
	}
	
	tmpId = [self getUserData:@"PlayerName"];
	if (tmpId)
	{
		self.playerName = [(NSString*)tmpId copy];
	}
	if ([self.playerName length] == 0)
	{
		self.playerName = @"Player";
	}
	
	tmpId = [self getUserData:@"PlayerNameListNormal"];
	if (tmpId)
	{
		[m_playerNameListNormal release];
		m_playerNameListNormal = [[NSMutableArray alloc] initWithArray:(NSArray*)tmpId];
	}
	
	tmpId = [self getUserData:@"ScoreListNormal"];
	if (tmpId)
	{
		[m_scoreListNormal release];
		m_scoreListNormal = [[NSMutableArray alloc] initWithArray:(NSArray*)tmpId];
	}
	
    tmpId = [self getUserData:@"FruitOrder"];
	if (tmpId)
	{
		[m_fruitOrder release];
		m_fruitOrder = [[NSMutableArray alloc] initWithArray:(NSArray*)tmpId];
	}
	
	if (m_hasDataSaved)
	{
		tmpId = [self getUserData:@"DataSavedFileName"];
		if (tmpId)
		{
			NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString* documentsDirectory = [paths objectAtIndex:0];
			NSString *filePath = [documentsDirectory stringByAppendingPathComponent:(NSString*)tmpId];
			GamePlayingData_Read(&m_playingData, [filePath UTF8String]);
		}
	}
}


- (void) insertScore:(int) score 
			  player:(NSString*)name 
		   scoreList:(NSMutableArray*)socreList 
			nameList:(NSMutableArray*)nameList
{
	int count = [socreList count];
	int insertIdx = 0;
	
	for ( ; insertIdx < count; insertIdx++)
	{
		NSNumber* curScore = [socreList objectAtIndex:insertIdx];
		if (score >= [curScore intValue])
		{
			break;
		}
	}
	
	NSNumber* num = [[NSNumber alloc] initWithInt:score];
	[socreList insertObject:num atIndex:insertIdx];
	[num release];
	
	NSString* text = [[NSString alloc] initWithString:name];
	[nameList insertObject:text atIndex:insertIdx];
	[text release];
	
	if ([socreList count] > 20)
	{
		[socreList removeLastObject];
		[nameList removeLastObject];
	}	
}


- (void) insertScore:(int) score player:(NSString*)name
{
    [self insertScore:score player:name scoreList:m_scoreListNormal nameList:m_playerNameListNormal];
}

@end
