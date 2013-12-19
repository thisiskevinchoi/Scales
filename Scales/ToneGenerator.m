//
//  ToneGenerator.m
//  Scales
//
//  Created by Kevin Choi on 11/26/13.
//  Copyright (c) 2013 Kev. All rights reserved.
//

#import "ToneGenerator.h"

#define TG_STATE_IDLE 0
#define TG_STATE_FADE_IN 1
#define TG_STATE_FADE_OUT 2
#define TG_STATE_SUSTAINING 3

#define SINE 0
#define SQUARE 1
#define SAWTOOTH 2
#define TRIANGLE 3

@implementation ToneGenerator

- (id)init
{
    self = [super init];
    self.amplitude = 0.0;
    self.frequency = 440.0;
    self.sampleRate = 44100;
    self.phase = 0;
    self.fadePosition = 0;
    self.state = 0;
    self.fadeCurve = [NSMutableArray arrayWithArray:@[]];
    self.soundWave = 0;
    
    [self createToneUnit];
    
    // Stop changing parameters on the unit
    OSErr err = AudioUnitInitialize(_toneUnit);
    NSAssert1(err == noErr, @"Error initializing unit: %hd", err);
    
    // Start playback
    err = AudioOutputUnitStart(_toneUnit);
    NSAssert1(err == noErr, @"Error starting unit: %hd", err);

    return self;
}

// UNUSED
- (void)kill
{
    AudioOutputUnitStop(_toneUnit);
    AudioUnitUninitialize(_toneUnit);
    AudioComponentInstanceDispose(_toneUnit);
    _toneUnit = nil;
}

//- (void)createFadeOutArray
//{
//    self.fadeOutCurve = [NSMutableArray arrayWithArray:@[]];
//    double num = (_amplitude - _goalAmplitude) / 1000.0;
//    for (int i = 0; i < 1000; i++) {
//        [self.fadeOutCurve addObject:[NSNumber numberWithDouble:num*(999-i)]];
//    }
//}

- (void)createAmplitudeArray
{
    self.fadeCurve = [NSMutableArray arrayWithArray:@[]];
    double num = ABS(_goalAmplitude - _amplitude) / 1000.0;
    if (_goalAmplitude - _amplitude > 0)
    {
        for (int i = 0; i < 1000; i++) {
            [self.fadeCurve addObject:[NSNumber numberWithDouble:(num*i + _amplitude)]];
        }
    }
    else
    {
        for (int i = 999; i >= 0; i--) {
            [self.fadeCurve addObject:[NSNumber numberWithDouble:(num*i + _goalAmplitude)]];
        }
    }
}

OSStatus RenderTone(
                    void *inRefCon,
                    AudioUnitRenderActionFlags 	*ioActionFlags,
                    const AudioTimeStamp 		*inTimeStamp,
                    UInt32 						inBusNumber,
                    UInt32 						inNumberFrames,
                    AudioBufferList 			*ioData)

{
	// Get the tone parameters out of the view controller
    ToneGenerator *toneGenerator =
    (__bridge ToneGenerator *)inRefCon;
    
//    double amplitude = toneGenerator.amplitude;
//	double theta = toneGenerator.theta;
//	double theta_increment = 2.0 * M_PI * toneGenerator.frequency / toneGenerator.sampleRate;
    
	// This is a mono tone generator so we only need the first buffer
	const int channel = 0;
	Float32 *buffer = (Float32 *)ioData->mBuffers[channel].mData;
	
	// Generate the samples
	for (UInt32 frame = 0; frame < inNumberFrames; frame++)
	{
//		buffer[frame] = sin(theta) * amplitude;
//		
//		theta += theta_increment;
//		if (theta > 2.0 * M_PI)
//		{
//			theta -= 2.0 * M_PI;
//		}
        switch (toneGenerator->_state)
        {
            case TG_STATE_IDLE:
                toneGenerator->_amplitude = 0.f;
                break;
            case TG_STATE_FADE_IN:
                if (toneGenerator->_fadePosition < [toneGenerator->_fadeCurve count])
                {
                    toneGenerator->_amplitude = [toneGenerator->_fadeCurve[toneGenerator->_fadePosition] doubleValue];
                    ++toneGenerator->_fadePosition;
                }
                else
                {
                    toneGenerator->_fadePosition = 0;
                    toneGenerator->_state = TG_STATE_SUSTAINING;
                }
                break;
            case TG_STATE_FADE_OUT:
                if (toneGenerator->_fadePosition < [toneGenerator->_fadeCurve count])
                {
                    toneGenerator->_amplitude = [toneGenerator->_fadeCurve[toneGenerator->_fadePosition] doubleValue];
                    ++toneGenerator->_fadePosition;
                }
                else
                {
                    toneGenerator->_fadePosition = 0;
                    toneGenerator->_state = TG_STATE_IDLE;
                }
                break;
            case TG_STATE_SUSTAINING:
                toneGenerator->_amplitude += (toneGenerator->_goalAmplitude - toneGenerator->_amplitude) / 1000.0;
                break;
        }
        toneGenerator->_frequency += (toneGenerator->_goalFrequency - toneGenerator->_frequency) / 500.0;
        
        double phase_incr = 2.0 * M_PI * (toneGenerator->_frequency / toneGenerator->_sampleRate);
        
        if (toneGenerator->_soundWave == SINE)
        {
            //sine
            buffer[frame] = sinf(toneGenerator->_phase) * toneGenerator->_amplitude;
        }
        else if (toneGenerator->_soundWave == SQUARE)
        {
            //square
            if (toneGenerator->_phase < M_PI ) {
                buffer[frame] = toneGenerator->_amplitude;
            }
            else
            {
                buffer[frame] = 0;
            }        }
        else if (toneGenerator->_soundWave == SAWTOOTH)
        {
            //sawtooth
            buffer[frame] = (toneGenerator->_phase / (2.0 * M_PI)) * toneGenerator->_amplitude;
        }
        else
        {
            //triangle
            if (toneGenerator->_phase < M_PI ) {
                buffer[frame] = toneGenerator->_amplitude * (toneGenerator->_phase / (1.0 * M_PI));
            }
            else
            {
                buffer[frame] = toneGenerator->_amplitude * ((2.0 * M_PI - toneGenerator->_phase) / (1.0 * M_PI));
            }
        }
        toneGenerator->_phase += phase_incr;
        toneGenerator->_phase = ( toneGenerator->_phase > (2.0 * M_PI) ? toneGenerator->_phase - (2.0 * M_PI) : toneGenerator->_phase);
	}
//    NSLog(@"Amplitude is %f", toneGenerator->_amplitude);
//    NSLog(@"Frequency is %f", toneGenerator->_frequency);
//    NSLog(@"Phase is %f", toneGenerator->_phase);
	
	// Store the theta back in the view controller
//	toneGenerator.theta = theta;
    
	return noErr;
}

- (void)createToneUnit
{
	// Configure the search parameters to find the default playback output unit
	// (called the kAudioUnitSubType_RemoteIO on iOS but
	// kAudioUnitSubType_DefaultOutput on Mac OS X)
	AudioComponentDescription defaultOutputDescription;
	defaultOutputDescription.componentType = kAudioUnitType_Output;
	defaultOutputDescription.componentSubType = kAudioUnitSubType_RemoteIO;
	defaultOutputDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
	defaultOutputDescription.componentFlags = 0;
	defaultOutputDescription.componentFlagsMask = 0;
	
	// Get the default playback output unit
	AudioComponent defaultOutput = AudioComponentFindNext(NULL, &defaultOutputDescription);
	NSAssert(defaultOutput, @"Can't find default output");
	
	// Create a new unit based on this that we'll use for output
	OSErr err = AudioComponentInstanceNew(defaultOutput, &_toneUnit);
	NSAssert1(_toneUnit, @"Error creating unit: %hd", err);
	
	// Set our tone rendering function on the unit
	AURenderCallbackStruct input;
	input.inputProc = RenderTone;
	input.inputProcRefCon = (__bridge void *)(self);
	err = AudioUnitSetProperty(_toneUnit,
                               kAudioUnitProperty_SetRenderCallback,
                               kAudioUnitScope_Input,
                               0,
                               &input,
                               sizeof(input));
	NSAssert1(err == noErr, @"Error setting callback: %hd", err);
	
	// Set the format to 32 bit, single channel, floating point, linear PCM
	const int four_bytes_per_float = 4;
	const int eight_bits_per_byte = 8;
	AudioStreamBasicDescription streamFormat = { 0 };
	streamFormat.mSampleRate = _sampleRate;
	streamFormat.mFormatID = kAudioFormatLinearPCM;
	streamFormat.mFormatFlags =
    kAudioFormatFlagsNativeFloatPacked | kAudioFormatFlagIsNonInterleaved;
	streamFormat.mBytesPerPacket = four_bytes_per_float;
	streamFormat.mFramesPerPacket = 1;
	streamFormat.mBytesPerFrame = four_bytes_per_float;
	streamFormat.mChannelsPerFrame = 1;
	streamFormat.mBitsPerChannel = four_bytes_per_float * eight_bits_per_byte;
	err = AudioUnitSetProperty (_toneUnit,
                                kAudioUnitProperty_StreamFormat,
                                kAudioUnitScope_Input,
                                0,
                                &streamFormat,
                                sizeof(AudioStreamBasicDescription));
	NSAssert1(err == noErr, @"Error setting stream format: %hd", err);
}

- (void)playToneWithFreq:(double)freq andAmplitude:(double)amp
{
    self.goalFrequency = freq;
    self.frequency = freq;
    self.goalAmplitude = amp;
    [self createAmplitudeArray];
    //self.fadePosition = 0;
    _state = TG_STATE_FADE_IN;
    
}

- (void)setFrequency:(double)freq andAmplitude:(double)amp
{
    self.goalFrequency = freq;
    self.goalAmplitude = amp;
}

- (void)stop
{
    self.goalAmplitude = 0;
    [self createAmplitudeArray];
    //self.fadePosition = 0;
    _state = TG_STATE_FADE_OUT;
}

@end
