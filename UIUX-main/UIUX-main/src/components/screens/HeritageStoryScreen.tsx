import React, { useState, useEffect } from 'react';
import { ASSETS } from '../../data/mockData';
import { AppScreen } from '../../types';

interface HeritageStoryScreenProps {
  setScreen: (screen: AppScreen) => void;
}

export const HeritageStoryScreen: React.FC<HeritageStoryScreenProps> = ({ setScreen }) => {
  const [isPlaying, setIsPlaying] = useState(false);
  const [playbackSec, setPlaybackSec] = useState(0);

  useEffect(() => {
    let timer: NodeJS.Timeout;
    if (isPlaying) {
      timer = setInterval(() => {
        setPlaybackSec((prev) => (prev >= 120 ? 0 : prev + 1));
      }, 1000);
    }
    return () => clearInterval(timer);
  }, [isPlaying]);

  const toggleAudio = () => {
    setIsPlaying(!isPlaying);
  };

  const formatTime = (secs: number) => {
    const m = Math.floor(secs / 60);
    const s = secs % 60;
    return `${m}:${s < 10 ? '0' : ''}${s}`;
  };

  return (
    <div className="max-w-2xl mx-auto px-4 sm:px-6 pt-5 pb-32 space-y-6 animate-in fade-in duration-200">
      {/* Main Banner: Artisan at Work */}
      <section className="relative rounded-2xl overflow-hidden shadow-[0_2px_16px_rgba(58,48,42,0.08)] bg-[#fef1e7] border border-[#dbc1b5]/60">
        <div className="w-full h-80 relative">
          <img
            src={ASSETS.savitaWheel}
            alt="Savita's Terracotta Legacy"
            className="w-full h-full object-cover"
          />
          <div className="absolute inset-0 bg-gradient-to-t from-black/85 via-black/30 to-transparent flex flex-col justify-end p-6">
            <span className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-[#b65c21] text-white text-xs font-['IBM_Plex_Serif'] font-semibold w-max mb-2 shadow-sm">
              <span className="material-symbols-outlined text-sm" style={{ fontVariationSettings: "'FILL' 1" }}>
                verified
              </span>
              Verified Cultural Heritage
            </span>
            <h2 className="text-2xl sm:text-3xl font-['Quicksand'] font-bold text-white tracking-tight">
              Savita's Terracotta Legacy
            </h2>
            <p className="text-xs sm:text-sm font-['Vollkorn'] text-gray-200 mt-0.5">
              Kutch, Gujarat • Tradition of Sun-Baked Pottery
            </p>
          </div>
        </div>
      </section>

      {/* Audio Story Player Widget */}
      <section className="bg-[#fef1e7] rounded-2xl p-5 sm:p-6 border border-[#dbc1b5]/60 shadow-xs space-y-4">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3.5">
            <button
              onClick={toggleAudio}
              className={`w-12 h-12 rounded-full flex items-center justify-center text-white transition-all active:scale-95 shadow-sm ${
                isPlaying ? 'bg-[#b65c21] ring-4 ring-[#ffdbca]' : 'bg-[#964407] hover:bg-[#b65c21]'
              }`}
              aria-label={isPlaying ? 'Pause audio story' : 'Play audio story'}
            >
              <span className="material-symbols-outlined text-2xl">
                {isPlaying ? 'pause' : 'play_arrow'}
              </span>
            </button>
            <div>
              <h3 className="font-['Quicksand'] font-bold text-[#201b14] text-base">
                Listen to Savita's Story in Marathi
              </h3>
              <p className="text-xs text-[#554339] font-['IBM_Plex_Serif']">
                Audio narrated by the artisan • {isPlaying ? formatTime(playbackSec) : '2 mins'}
              </p>
            </div>
          </div>
          <span className="text-xs font-['IBM_Plex_Serif'] text-[#964407] font-bold bg-[#ffdbca] px-2.5 py-1 rounded-full">
            HD Audio
          </span>
        </div>

        {/* Waveform Simulation */}
        <div className="flex items-center gap-1.5 h-10 px-2 bg-white/70 rounded-xl border border-[#dbc1b5]/30">
          {[14, 28, 18, 32, 12, 24, 30, 16, 26, 20, 32, 14, 26, 18, 30].map((baseH, idx) => {
            const dynamicHeight = isPlaying ? Math.max(8, (baseH * ((idx % 4) + 1)) % 36) : baseH / 2;
            return (
              <div
                key={idx}
                className={`w-1.5 rounded-full transition-all duration-200 ${
                  isPlaying ? 'bg-[#964407]' : 'bg-[#964407]/40'
                }`}
                style={{
                  height: `${dynamicHeight}px`,
                  transitionDelay: `${idx * 20}ms`
                }}
              />
            );
          })}
        </div>
      </section>

      {/* The Artisan's Journey */}
      <section className="bg-[#fef1e7] rounded-2xl p-6 sm:p-8 border border-[#dbc1b5]/60 shadow-xs space-y-4">
        <div className="flex items-center gap-2 text-[#964407]">
          <span className="material-symbols-outlined" style={{ fontVariationSettings: "'FILL' 1" }}>
            auto_awesome
          </span>
          <h3 className="font-['Quicksand'] font-bold text-xl text-[#201b14]">
            The Artisan's Journey
          </h3>
        </div>
        <p className="text-[#554339] leading-relaxed font-['Vollkorn'] text-base">
          Deep within the sun-drenched plains of rural India, pottery is not merely craft—it is a sacred dialogue with the earth. For four generations, Savita’s family has harvested pristine river clay, kneading it with patience and reverence under the golden warmth of the midday sun.
        </p>
        <p className="text-[#554339] leading-relaxed font-['Vollkorn'] text-base">
          Every vessel is shaped by hand on ancient wooden wheels, left to dry naturally under open skies, and fired in traditional pit kilns fueled by cow dung and dry twigs. This time-honored technique imparts a distinct earthy fragrance and organic texture that modern machinery can never replicate.
        </p>
      </section>

      {/* Artisan Quote Card */}
      <section className="bg-[#f8ece1] rounded-2xl p-6 sm:p-8 border border-[#dbc1b5]/60 relative overflow-hidden">
        <div className="absolute -right-4 -bottom-4 text-[#964407]/10 pointer-events-none">
          <span className="material-symbols-outlined text-8xl">format_quote</span>
        </div>
        <blockquote className="relative z-10 space-y-3">
          <p className="font-['Quicksand'] italic text-base sm:text-lg text-[#201b14] font-semibold leading-relaxed">
            "When my hands touch the wet clay, I hear the whispers of my ancestors guiding every curve. This soil carries our history, our resilience, and our soul."
          </p>
          <footer className="text-sm font-['IBM_Plex_Serif'] text-[#964407] font-bold">
            — Savita Ben, Master Potter
          </footer>
        </blockquote>
      </section>

      {/* Publish to Global Marketplace Button */}
      <div className="pt-2">
        <button
          onClick={() => setScreen('pricing')}
          className="w-full py-4 px-6 bg-[#964407] hover:bg-[#b65c21] text-white rounded-xl font-['Quicksand'] font-bold text-base shadow-lg transition-all active:scale-98 flex items-center justify-center gap-2"
        >
          <span className="material-symbols-outlined text-lg" style={{ fontVariationSettings: "'FILL' 1" }}>
            public
          </span>
          <span>Publish to Global Marketplace</span>
        </button>
      </div>
    </div>
  );
};
