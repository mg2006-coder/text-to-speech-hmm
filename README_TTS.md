# Text-to-Speech Converter in MATLAB

A simple desktop app built in MATLAB that reads out any text you type. You can pick a voice, change the speed and volume, and save the speech as a WAV file.

I made this to learn how to build a GUI in MATLAB using a class, and how MATLAB can call .NET libraries.

## Features

- Type or paste text in a box and hear it spoken
- Choose between two voices (Microsoft David and Microsoft Zira)
- Speech rate slider
- Volume slider
- Save the spoken text as a `.wav` file
- Simple window with buttons and sliders, no extra toolbox needed

## How it works

The GUI is built with `uicontrol` elements inside a `classdef` class (`TextToSpeechConverter`). For the actual speech, it loads the .NET `System.Speech` assembly from Windows and uses its `SpeechSynthesizer`. The code reads the slider values, sets the rate and volume on the synthesizer, selects the voice, and then calls `Speak`. For saving, it sends the output to a wave file instead of the speakers.

So the speech engine is the one that comes with Windows. This project is the interface and control layer on top of it.

## Requirements

- Windows (it uses the Windows speech API, so it will not run on Mac or Linux)
- MATLAB with .NET support
- Voices "Microsoft David Desktop" and "Microsoft Zira Desktop" installed (they come with most Windows versions)

## How to run

1. Download `TextToSpeechConverter.m`
2. Open MATLAB and set the folder containing the file as the Current Folder
3. In the Command Window, run:

```matlab
app = TextToSpeechConverter;
```

4. Type some text, click **Speak Text**, or click **Save as Audio** to export a WAV file.

## Known limitations

- The pitch slider is there in the window, but it does not change the voice yet. The Windows speech API does not give direct pitch control, so this is still a placeholder.
- The voice list is fixed to two names. If those voices are not installed on your PC, the default voice is used.
- Windows only.

## Things I want to add

- Load the list of installed voices automatically instead of hardcoding it
- Working pitch control (maybe using SSML)
- Open a text file and read it aloud
- Pause and stop buttons

## Tools used

MATLAB, .NET System.Speech
