classdef TextToSpeechConverter < handle
    properties
        fig
        textBox
        speakButton
        rateSlider
        pitchSlider
        volumeSlider
        voiceDropdown
        saveButton
    end

    methods
        function obj = TextToSpeechConverter()
            % Main GUI window
            obj.fig = figure('Name', 'MATLAB Text-to-Speech Converter', ...
                'NumberTitle', 'off', ...
                'Position', [100, 100, 600, 400], ...
                'Resize', 'off', ...
                'MenuBar', 'none', ...
                'ToolBar', 'none');

            % UI Components
            obj.createUIComponents();
        end

        function createUIComponents(obj)
            uicontrol('Style', 'text', 'String', 'Enter Text:', ...
                'Position', [50, 350, 100, 20], 'HorizontalAlignment', 'left');

            obj.textBox = uicontrol('Style', 'edit', 'String', 'Type your text here', ...
                'Position', [50, 300, 500, 50], 'Max', 5, ...
                'HorizontalAlignment', 'left');

            obj.speakButton = uicontrol('Style', 'pushbutton', ...
                'String', 'Speak Text', ...
                'Position', [50, 250, 150, 30], ...
                'Callback', @(src, event) obj.speakText());

            obj.saveButton = uicontrol('Style', 'pushbutton', ...
                'String', 'Save as Audio', ...
                'Position', [220, 250, 150, 30], ...
                'Callback', @(src, event) obj.saveAudio());

            uicontrol('Style', 'text', 'String', 'Voice:', ...
                'Position', [50, 200, 100, 20], 'HorizontalAlignment', 'left');

            obj.voiceDropdown = uicontrol('Style', 'popupmenu', ...
                'String', {'Microsoft David Desktop', 'Microsoft Zira Desktop'}, ...
                'Position', [150, 200, 200, 25]);

            uicontrol('Style', 'text', 'String', 'Speech Rate:', ...
                'Position', [50, 150, 100, 20], 'HorizontalAlignment', 'left');

            obj.rateSlider = uicontrol('Style', 'slider', ...
                'Min', 0.5, 'Max', 2, 'Value', 1, ...
                'Position', [150, 150, 200, 20], ...
                'Callback', @(src, event) obj.updateRate());

            uicontrol('Style', 'text', 'String', 'Pitch:', ...
                'Position', [50, 100, 100, 20], 'HorizontalAlignment', 'left');

            obj.pitchSlider = uicontrol('Style', 'slider', ...
                'Min', 0.8, 'Max', 1.5, 'Value', 1, ...
                'Position', [150, 100, 200, 20], ...
                'Callback', @(src, event) obj.updatePitch());

            uicontrol('Style', 'text', 'String', 'Volume:', ...
                'Position', [50, 50, 100, 20], 'HorizontalAlignment', 'left');

            obj.volumeSlider = uicontrol('Style', 'slider', ...
                'Min', 0, 'Max', 1, 'Value', 0.8, ...
                'Position', [150, 50, 200, 20], ...
                'Callback', @(src, event) obj.updateVolume());
        end

        function speakText(obj)
            % Load .NET SpeechSynthesizer
            NET.addAssembly('System.Speech');
            import System.Speech.Synthesis.*

            % Get text from box
            textToSpeak = get(obj.textBox, 'String');
            if iscell(textToSpeak)
                textToSpeak = strjoin(textToSpeak, ' ');
            end

            synth = SpeechSynthesizer;
            obj.configureVoice(synth);

            synth.Speak(textToSpeak);
        end

        function configureVoice(obj, synth)
            rate = get(obj.rateSlider, 'Value');
            synth.Rate = int32((rate - 1) * 10);

            volume = get(obj.volumeSlider, 'Value');
            synth.Volume = int32(volume * 100);

            voices = synth.GetInstalledVoices();
            voiceNames = cell(voices.Count, 1);
            for i = 1:voices.Count
                voiceNames{i} = char(voices.Item(i-1).VoiceInfo.Name);
            end

            selectedVoiceIdx = get(obj.voiceDropdown, 'Value');
            if selectedVoiceIdx <= length(voiceNames)
                synth.SelectVoice(voiceNames{selectedVoiceIdx});
            end
        end

        function saveAudio(obj)
            % Load .NET SpeechSynthesizer
            NET.addAssembly('System.Speech');
            import System.Speech.Synthesis.*

            textToSpeak = get(obj.textBox, 'String');
            if iscell(textToSpeak)
                textToSpeak = strjoin(textToSpeak, ' ');
            end

            synth = SpeechSynthesizer;
            obj.configureVoice(synth);

            [filename, pathname] = uiputfile('*.wav', 'Save Speech as WAV');
            if isequal(filename, 0)
                return;
            end
            fullPath = fullfile(pathname, filename);
            synth.SetOutputToWaveFile(fullPath);
            synth.Speak(textToSpeak);
            msgbox(['Audio saved successfully to: ' fullPath], 'Success');
        end

        function updateRate(obj)
            rate = get(obj.rateSlider, 'Value');
            disp(['Speech rate set to: ' num2str(rate)]);
        end

        function updatePitch(obj)
            pitch = get(obj.pitchSlider, 'Value');
            disp(['Pitch (placeholder): ' num2str(pitch)]);
        end

        function updateVolume(obj)
            volume = get(obj.volumeSlider, 'Value');
            disp(['Volume set to: ' num2str(volume)]);
        end
    end
end