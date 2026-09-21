import React, { useState } from 'react';
import { ASSETS, MULTILINGUAL_PRODUCT } from '../../data/mockData';
import { AppScreen, Language } from '../../types';

interface MultilingualCatalogScreenProps {
  setScreen: (screen: AppScreen) => void;
}

export const MultilingualCatalogScreen: React.FC<MultilingualCatalogScreenProps> = ({
  setScreen
}) => {
  const [lang, setLang] = useState<Language>('en');

  const content = MULTILINGUAL_PRODUCT.translations[lang];

  return (
    <div className="max-w-2xl mx-auto px-4 sm:px-6 pt-5 pb-28 space-y-6 animate-in fade-in duration-200">
      {/* Screen Header & Language Tabs */}
      <div className="space-y-4">
        <div className="flex items-center justify-between">
          <h1 className="font-['Quicksand'] font-bold text-2xl sm:text-3xl text-[#201b14] tracking-tight">
            Multilingual Catalog
          </h1>
          <span className="text-xs font-['IBM_Plex_Serif'] uppercase tracking-widest text-[#554339] bg-[#f8ece1] px-3 py-1 rounded-full border border-[#dbc1b5]/60 font-semibold">
            AI Translated
          </span>
        </div>

        {/* Interactive Language Tabs */}
        <div className="flex gap-2 p-1.5 bg-[#f8ece1] rounded-2xl border border-[#dbc1b5]/50 shadow-inner">
          <button
            onClick={() => setLang('en')}
            className={`flex-1 py-2 px-4 rounded-xl font-['Quicksand'] font-semibold text-sm transition-all duration-200 ${
              lang === 'en'
                ? 'bg-[#964407] text-white shadow-sm'
                : 'text-[#554339] hover:text-[#201b14] hover:bg-white/50'
            }`}
          >
            English
          </button>
          <button
            onClick={() => setLang('hi')}
            className={`flex-1 py-2 px-4 rounded-xl font-['Quicksand'] font-semibold text-sm transition-all duration-200 ${
              lang === 'hi'
                ? 'bg-[#964407] text-white shadow-sm'
                : 'text-[#554339] hover:text-[#201b14] hover:bg-white/50'
            }`}
          >
            हिंदी
          </button>
          <button
            onClick={() => setLang('mr')}
            className={`flex-1 py-2 px-4 rounded-xl font-['Quicksand'] font-semibold text-sm transition-all duration-200 ${
              lang === 'mr'
                ? 'bg-[#964407] text-white shadow-sm'
                : 'text-[#554339] hover:text-[#201b14] hover:bg-white/50'
            }`}
          >
            मराठी
          </button>
        </div>
      </div>

      {/* Product Card (Sahara Style) */}
      <div className="bg-[#fef1e7] rounded-2xl p-5 sm:p-6 shadow-[0_2px_16px_rgba(58,48,42,0.06)] border border-[#dbc1b5]/60 space-y-6">
        {/* Product Image */}
        <div className="relative w-full h-72 sm:h-80 rounded-xl overflow-hidden shadow-sm border border-[#dbc1b5]/40">
          <img
            src={MULTILINGUAL_PRODUCT.imageUrl}
            alt={content.title}
            className="w-full h-full object-cover"
          />
          <div className="absolute top-3 right-3 bg-[#fff8f4]/95 backdrop-blur-xs px-3 py-1 rounded-full text-xs font-['IBM_Plex_Serif'] font-medium text-[#964407] shadow-sm border border-[#dbc1b5]/50 flex items-center gap-1">
            <span className="material-symbols-outlined text-xs" style={{ fontVariationSettings: "'FILL' 1" }}>
              verified
            </span>
            <span>Verified Craft</span>
          </div>
        </div>

        {/* Product Title */}
        <div>
          <h2 className="font-['Quicksand'] font-bold text-2xl sm:text-3xl text-[#201b14] mb-2 tracking-tight">
            {content.title}
          </h2>
          <p className="font-['Vollkorn'] text-base text-[#554339] leading-relaxed">
            {content.desc}
          </p>
        </div>

        {/* Keywords / Tags */}
        <div>
          <span className="block text-xs font-['IBM_Plex_Serif'] uppercase tracking-wider text-[#554339] font-bold mb-2">
            {content.keywordsLabel}
          </span>
          <div className="flex flex-wrap gap-2">
            {content.keywords.map((kw, idx) => (
              <span
                key={idx}
                className="bg-[#f8ece1] px-3 py-1 rounded-full text-xs font-['IBM_Plex_Serif'] text-[#201b14] border border-[#dbc1b5]/60 font-medium"
              >
                {kw}
              </span>
            ))}
          </div>
        </div>

        {/* Attributes Grid */}
        <div className="grid grid-cols-2 gap-3 pt-3 border-t border-[#dbc1b5]/40">
          <div className="bg-white p-3.5 rounded-xl border border-[#dbc1b5]/40">
            <span className="block text-xs font-['IBM_Plex_Serif'] text-[#554339] uppercase tracking-wider mb-0.5">
              {content.catLabel}
            </span>
            <span className="font-['Quicksand'] font-bold text-sm text-[#201b14]">
              {content.catVal}
            </span>
          </div>

          <div className="bg-white p-3.5 rounded-xl border border-[#dbc1b5]/40">
            <span className="block text-xs font-['IBM_Plex_Serif'] text-[#554339] uppercase tracking-wider mb-0.5">
              {content.matLabel}
            </span>
            <span className="font-['Quicksand'] font-bold text-sm text-[#201b14]">
              {content.matVal}
            </span>
          </div>

          <div className="bg-white p-3.5 rounded-xl border border-[#dbc1b5]/40">
            <span className="block text-xs font-['IBM_Plex_Serif'] text-[#554339] uppercase tracking-wider mb-0.5">
              {content.craftLabel}
            </span>
            <span className="font-['Quicksand'] font-bold text-sm text-[#201b14]">
              {content.craftVal}
            </span>
          </div>

          <div className="bg-white p-3.5 rounded-xl border border-[#dbc1b5]/40">
            <span className="block text-xs font-['IBM_Plex_Serif'] text-[#554339] uppercase tracking-wider mb-0.5">
              {content.origLabel}
            </span>
            <span className="font-['Quicksand'] font-bold text-sm text-[#201b14]">
              {content.origVal}
            </span>
          </div>
        </div>

        {/* Continue to Heritage Story button */}
        <div className="pt-2">
          <button
            onClick={() => setScreen('heritage')}
            className="w-full py-4 px-6 bg-[#964407] hover:bg-[#b65c21] text-white rounded-xl font-['Quicksand'] font-bold text-base shadow-md transition-all duration-200 flex items-center justify-center gap-2 group active:scale-98"
          >
            <span>{content.btnText}</span>
            <span className="material-symbols-outlined group-hover:translate-x-1 transition-transform">
              arrow_forward
            </span>
          </button>
        </div>
      </div>
    </div>
  );
};
