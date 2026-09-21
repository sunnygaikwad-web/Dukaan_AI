import React, { useState, useEffect } from 'react';
import { AppScreen } from '../../types';

interface AddProductVoiceScreenProps {
  setScreen: (screen: AppScreen) => void;
  voiceTranscript: string;
  setVoiceTranscript: (text: string) => void;
}

export const AddProductVoiceScreen: React.FC<AddProductVoiceScreenProps> = ({
  setScreen,
  voiceTranscript,
  setVoiceTranscript
}) => {
  const [isRecording, setIsRecording] = useState(false);
  const [isPlayingAudio, setIsPlayingAudio] = useState(false);
  const [typedIndex, setTypedIndex] = useState(0);

  const sampleMarathi =
    'ही हाताने बनवलेली पैठणी साडी आहे. ती रेशमापासून बनवली आहे आणि त्यावर पारंपरिक मोराची डिझाइन आहे.';

  const sampleHindi =
    'यह हाथ से बुनी हुई पैठणी साड़ी है। इसे शुद्ध रेशम से बनाया गया है और इस पर पारंपरिक मोर की नक्काशी है।';

  const [selectedLanguage, setSelectedLanguage] = useState<'mr' | 'hi' | 'en'>('mr');

  // Interactive typewriter transcript simulation or speech recognition
  useEffect(() => {
    let interval: NodeJS.Timeout;
    if (isRecording) {
      const textToType = selectedLanguage === 'mr' ? sampleMarathi : sampleHindi;
      interval = setInterval(() => {
        setTypedIndex((prev) => {
          if (prev >= textToType.length) {
            clearInterval(interval);
            setIsRecording(false);
            return prev;
          }
          const next = prev + 3;
          setVoiceTranscript(textToType.substring(0, next));
          return next;
        });
      }, 90);
    }
    return () => clearInterval(interval);
  }, [isRecording, selectedLanguage]);

  const handleToggleRecord = () => {
    if (isRecording) {
      setIsRecording(false);
    } else {
      setVoiceTranscript('');
      setTypedIndex(0);
      setIsRecording(true);
    }
  };

  const handlePlaySample = () => {
    setIsPlayingAudio(true);
    // Simple synthesized speech or audio tone
    if ('speechSynthesis' in window) {
      window.speechSynthesis.cancel();
      const utter = new SpeechSynthesisUtterance(sampleMarathi);
      utter.lang = 'mr-IN';
      utter.rate = 0.9;
      utter.onend = () => setIsPlayingAudio(false);
      utter.onerror = () => setIsPlayingAudio(false);
      window.speechSynthesis.speak(utter);
    } else {
      setTimeout(() => setIsPlayingAudio(false), 2500);
    }
  };

  const currentTranscript =
    voiceTranscript || 'ही हाताने बनवलेली पैठणी साडी आहे. ती रेशमापासून बनवली आहे...';

  return (
    <div className="max-w-md mx-auto px-4 sm:px-6 pt-5 pb-28 space-y-6 animate-in fade-in duration-200">
      {/* Title */}
      <div className="text-center space-y-1">
        <h2 className="text-2xl sm:text-3xl font-['Quicksand'] font-bold text-[#201b14] tracking-tight">
          Tell us about your product.
        </h2>
        <p className="text-base font-['Vollkorn'] text-[#554339]">
          Speak in Marathi, Hindi or English.
        </p>
      </div>

      {/* Interactive Microphone Central Card */}
      <div className="bg-[#fef1e7] rounded-2xl p-6 sm:p-8 border border-[#dbc1b5]/60 shadow-sm flex flex-col items-center justify-center relative overflow-hidden">
        {/* Concentric waves */}
        <div className="relative flex items-center justify-center my-4">
          <div
            className={`absolute w-44 h-44 rounded-full border border-[#b65c21]/20 transition-all duration-700 ${
              isRecording ? 'scale-125 opacity-100 animate-ping' : 'scale-100 opacity-40'
            }`}
          />
          <div
            className={`absolute w-36 h-36 rounded-full border border-[#b65c21]/40 transition-all duration-500 ${
              isRecording ? 'scale-110 opacity-90' : 'scale-100 opacity-60'
            }`}
          />
          <div className="w-28 h-28 rounded-full bg-[#f8ece1] border border-[#dbc1b5] flex items-center justify-center shadow-inner">
            <button
              onClick={handleToggleRecord}
              className={`w-20 h-20 rounded-full flex items-center justify-center text-white transition-all shadow-md active:scale-95 ${
                isRecording ? 'bg-[#ba1a1a] animate-pulse ring-4 ring-[#ffdad6]' : 'bg-[#964407] hover:bg-[#b65c21]'
              }`}
              aria-label="Tap and speak"
            >
              <span className="material-symbols-outlined text-3xl">
                {isRecording ? 'graphic_eq' : 'mic'}
              </span>
            </button>
          </div>
        </div>

        <span className="text-sm font-['Quicksand'] font-bold text-[#964407] mt-1">
          {isRecording ? 'Listening now... Speak your craft story' : 'Tap and speak'}
        </span>

        {/* Dynamic Soundwave simulation */}
        <div className="flex items-center gap-1 mt-3 h-8">
          {[12, 24, 16, 28, 14, 26, 18, 32, 20, 15, 25, 10].map((h, i) => (
            <div
              key={i}
              className="w-1 bg-[#964407] rounded-full transition-all duration-150"
              style={{
                height: isRecording ? `${Math.max(6, (h * (i % 3 + 1)) % 30)}px` : `${Math.min(h, 14)}px`,
                opacity: isRecording ? 1 : 0.4
              }}
            />
          ))}
        </div>
      </div>

      {/* Example Voice Input Card */}
      <div className="bg-[#fef1e7] rounded-2xl p-5 border border-[#dbc1b5]/60 shadow-xs space-y-3">
        <div className="flex items-center justify-between">
          <span className="text-xs font-['IBM_Plex_Serif'] font-bold uppercase tracking-wider text-[#554339]">
            Example Voice Input
          </span>
          <button
            onClick={handlePlaySample}
            className="w-8 h-8 rounded-full flex items-center justify-center text-[#964407] hover:bg-[#f8ece1] transition-all"
            title="Listen to sample audio"
          >
            <span className="material-symbols-outlined text-lg">
              {isPlayingAudio ? 'volume_up' : 'volume_down'}
            </span>
          </button>
        </div>

        <p className="font-['Vollkorn'] italic text-base text-[#201b14] leading-relaxed">
          "{sampleMarathi}"
        </p>

        <div className="pt-2 border-t border-[#dbc1b5]/40 flex items-center justify-between text-xs font-['IBM_Plex_Serif'] text-[#554339]">
          <div className="flex items-center gap-1.5 text-[#964407]">
            <span className="material-symbols-outlined text-sm">graphic_eq</span>
            <span>Marathi • Paithani Silk Saree</span>
          </div>
          <div className="flex gap-1">
            <button
              onClick={() => setSelectedLanguage('mr')}
              className={`px-2 py-0.5 rounded text-[11px] font-bold ${
                selectedLanguage === 'mr' ? 'bg-[#964407] text-white' : 'bg-[#e9ded6] text-[#554339]'
              }`}
            >
              मराठी
            </button>
            <button
              onClick={() => setSelectedLanguage('hi')}
              className={`px-2 py-0.5 rounded text-[11px] font-bold ${
                selectedLanguage === 'hi' ? 'bg-[#964407] text-white' : 'bg-[#e9ded6] text-[#554339]'
              }`}
            >
              हिंदी
            </button>
          </div>
        </div>
      </div>

      {/* Live Transcript Card */}
      <div className="bg-white rounded-2xl p-5 border border-[#dbc1b5]/60 shadow-xs space-y-2">
        <div className="flex items-center justify-between">
          <span className="text-xs font-['IBM_Plex_Serif'] font-bold uppercase tracking-wider text-[#964407]">
            Live Transcript
          </span>
          <span className="w-2.5 h-2.5 rounded-full bg-[#ba1a1a] animate-pulse" />
        </div>
        <p className="font-['Vollkorn'] text-base text-[#201b14] leading-relaxed min-h-[48px]">
          {currentTranscript}
        </p>
      </div>

      {/* Action Buttons: Try Again & Looks Good */}
      <div className="grid grid-cols-2 gap-3 pt-2">
        <button
          onClick={() => {
            setVoiceTranscript('');
            setTypedIndex(0);
            setIsRecording(false);
          }}
          className="bg-white border border-[#dbc1b5] text-[#201b14] font-['Quicksand'] font-bold py-3.5 px-4 rounded-xl shadow-xs hover:bg-[#f8ece1] active:scale-95 transition-all text-center"
        >
          Try Again
        </button>
        <button
          onClick={() => setScreen('ai-catalog')}
          className="bg-[#964407] hover:bg-[#b65c21] text-white font-['Quicksand'] font-bold py-3.5 px-4 rounded-xl shadow-md active:scale-95 transition-all text-center"
        >
          Looks Good
        </button>
      </div>
    </div>
  );
};
