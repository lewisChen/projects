//
//  SoundDef.h
//  RightToWin
//
//  Created by mybox_1027@sina.com on 14-4-22.
//  Copyright (c) 2014年 Apportable. All rights reserved.
//

#ifndef RightToWin_SoundDef_h
#define RightToWin_SoundDef_h

#define kEffectTouched (@"itemTouched.mp3")
#define kEffectLevelUp (@"levelUp.mp3")
#define kEffectExplosion (@"explosion.wav")
#define kEffectError (@"systemError.wav")

#define kEffectPianoDo (@"1.mp3")
#define kEffectPianoRe (@"2.mp3")
#define kEffectPianoMi (@"3.mp3")
#define kEffectPianoFa (@"4.mp3")
#define kEffectPianoSo (@"5.mp3")
#define kEffectPianoLa (@"6.mp3")
#define kEffectPianoQi (@"7.mp3")
#define kEffectPianoDi (@"8.mp3")


typedef enum : NSUInteger {
    eRandomSound1,
    eRandomSound2,
    eRandomSound3,
    eRandomSound4,
    eRandomSound5,
    eRandomSound6,
    eRandomSound7,
    eRandomSound8,
    
    eRandomSoundMax
} eRandomSound;


#endif
