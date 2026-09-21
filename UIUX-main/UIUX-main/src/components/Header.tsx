import React, { useState } from 'react';
import { ASSETS } from '../data/mockData';
import { AppScreen } from '../types';

interface HeaderProps {
  currentScreen: AppScreen;
  setScreen: (screen: AppScreen) => void;
  title?: string;
  showBack?: boolean;
  onBack?: () => void;
  unreadNotifications?: number;
}

export const Header: React.FC<HeaderProps> = ({
  currentScreen,
  setScreen,
  showBack = false,
  onBack,
  unreadNotifications = 2
}) => {
  const [showNotifications, setShowNotifications] = useState(false);
  const [showScreenSwitcher, setShowScreenSwitcher] = useState(false);

  const screens: { id: AppScreen; label: string; icon: string }[] = [
    { id: 'home', label: '1. Artisan Home', icon: 'home' },
    { id: 'add-photo', label: '2. Add Craft (Photo)', icon: 'photo_camera' },
    { id: 'add-voice', label: '3. Voice Input', icon: 'mic' },
    { id: 'ai-catalog', label: '4. AI-Generated Catalog', icon: 'auto_awesome' },
    { id: 'multilingual', label: '5. Multilingual Catalog', icon: 'translate' },
    { id: 'heritage', label: '6. Heritage Story', icon: 'menu_book' },
    { id: 'pricing', label: '7. Smart Pricing & Earnings', icon: 'payments' },
    { id: 'digital-mela', label: '8. Digital Mela & Market', icon: 'festival' },
    { id: 'profile', label: 'Artisan Profile', icon: 'person' },
  ];

  return (
    <>
      <header className="sticky top-0 z-40 bg-[#fff8f4]/95 backdrop-blur-md border-b border-[#dbc1b5]/40 shadow-sm w-full px-4 sm:px-6 py-3.5 flex justify-between items-center transition-all">
        <div className="flex items-center space-x-3">
          {showBack ? (
            <button
              onClick={onBack || (() => setScreen('home'))}
              className="w-10 h-10 -ml-1 rounded-full flex items-center justify-center text-[#554339] hover:bg-[#f2e6dc] active:scale-95 transition-all"
              aria-label="Go back"
            >
              <span className="material-symbols-outlined text-2xl">arrow_back</span>
            </button>
          ) : (
            <div
              onClick={() => setScreen('profile')}
              className="relative w-10 h-10 rounded-full overflow-hidden border-2 border-[#b65c21] flex items-center justify-center bg-[#e9ded6] cursor-pointer shadow-sm active:scale-95 transition-transform"
              title="Artisan Profile: Savita Patil"
            >
              <img
                className="w-full h-full object-cover"
                src={ASSETS.artisanAvatar}
                alt="Artisan Savita Patil"
              />
            </div>
          )}

          <div>
            <div className="flex items-center gap-1.5 cursor-pointer" onClick={() => setScreen('home')}>
              <h1 className="text-xl sm:text-2xl font-['Quicksand'] font-extrabold text-[#964407] tracking-tight">
                ShilpMitra AI
              </h1>
            </div>
          </div>
        </div>

        <div className="flex items-center space-x-2">
          {/* Quick Screen Switcher Pill */}
          <button
            onClick={() => setShowScreenSwitcher(!showScreenSwitcher)}
            className="flex items-center space-x-1 px-2.5 py-1.5 rounded-full bg-[#f8ece1] hover:bg-[#f2e6dc] text-xs font-['IBM_Plex_Serif'] font-semibold text-[#964407] border border-[#dbc1b5]/60 transition-all active:scale-95"
            title="Switch between all 8 mock screens"
          >
            <span className="material-symbols-outlined text-sm">layers</span>
            <span className="hidden sm:inline">Screens</span>
            <span className="material-symbols-outlined text-sm">expand_more</span>
          </button>

          {/* Notifications button */}
          <button
            onClick={() => setShowNotifications(true)}
            className="relative w-10 h-10 rounded-full bg-[#f8ece1] flex items-center justify-center text-[#554339] hover:bg-[#f2e6dc] transition-all active:scale-95"
            aria-label="View notifications"
          >
            <span className="material-symbols-outlined text-2xl" style={{ fontVariationSettings: "'FILL' 1" }}>
              notifications
            </span>
            {unreadNotifications > 0 && (
              <span className="absolute top-2 right-2 w-2.5 h-2.5 bg-[#ba1a1a] rounded-full ring-2 ring-[#fff8f4] animate-pulse" />
            )}
          </button>
        </div>
      </header>

      {/* Screen switcher dropdown */}
      {showScreenSwitcher && (
        <div
          className="fixed inset-0 z-50 bg-black/30 backdrop-blur-xs"
          onClick={() => setShowScreenSwitcher(false)}
        >
          <div
            className="absolute top-16 right-4 sm:right-6 w-80 max-w-[calc(100vw-2rem)] bg-[#fff8f4] rounded-2xl shadow-xl border border-[#dbc1b5] p-3 space-y-1 animate-in fade-in slide-in-from-top-2 duration-150"
            onClick={(e) => e.stopPropagation()}
          >
            <div className="px-3 py-2 border-b border-[#dbc1b5]/40 flex items-center justify-between">
              <span className="text-xs font-['IBM_Plex_Serif'] uppercase tracking-wider text-[#964407] font-bold">
                Jump to Any Screen
              </span>
              <span className="text-[11px] text-[#554339]">8 Custom Views</span>
            </div>
            <div className="max-h-96 overflow-y-auto py-1 space-y-0.5">
              {screens.map((sc) => {
                const isActive = currentScreen === sc.id;
                return (
                  <button
                    key={sc.id}
                    onClick={() => {
                      setScreen(sc.id);
                      setShowScreenSwitcher(false);
                    }}
                    className={`w-full flex items-center space-x-3 px-3 py-2 rounded-xl text-left text-sm font-['Quicksand'] font-semibold transition-all ${
                      isActive
                        ? 'bg-[#964407] text-white shadow-sm'
                        : 'text-[#201b14] hover:bg-[#f8ece1]'
                    }`}
                  >
                    <span className="material-symbols-outlined text-lg">{sc.icon}</span>
                    <span className="truncate">{sc.label}</span>
                  </button>
                );
              })}
            </div>
          </div>
        </div>
      )}

      {/* Notifications Modal */}
      {showNotifications && (
        <div
          className="fixed inset-0 z-50 bg-black/40 backdrop-blur-xs flex items-center justify-center p-4"
          onClick={() => setShowNotifications(false)}
        >
          <div
            className="bg-[#fff8f4] max-w-md w-full rounded-2xl shadow-2xl border border-[#dbc1b5] p-6 space-y-4 animate-in fade-in zoom-in-95 duration-200"
            onClick={(e) => e.stopPropagation()}
          >
            <div className="flex items-center justify-between border-b border-[#dbc1b5]/40 pb-3">
              <div className="flex items-center gap-2 text-[#964407]">
                <span className="material-symbols-outlined">notifications_active</span>
                <h3 className="font-['Quicksand'] font-bold text-lg text-[#201b14]">Notifications</h3>
              </div>
              <button
                onClick={() => setShowNotifications(false)}
                className="w-8 h-8 rounded-full flex items-center justify-center text-[#554339] hover:bg-[#f8ece1]"
              >
                <span className="material-symbols-outlined text-xl">close</span>
              </button>
            </div>

            <div className="space-y-3 max-h-80 overflow-y-auto">
              <div className="p-3.5 rounded-xl bg-[#fef1e7] border border-[#dbc1b5]/60 flex items-start gap-3">
                <div className="w-8 h-8 rounded-full bg-[#ffdbca] text-[#773300] flex items-center justify-center shrink-0">
                  <span className="material-symbols-outlined text-base">storefront</span>
                </div>
                <div>
                  <h4 className="text-sm font-['Quicksand'] font-bold text-[#201b14]">
                    3 Buyers looking for your crafts!
                  </h4>
                  <p className="text-xs font-['Vollkorn'] text-[#554339] mt-0.5">
                    Maison Étoile Gallery (Paris) requested 10 Paithani sarees for exhibition.
                  </p>
                  <span className="text-[10px] text-[#964407] font-semibold mt-1 inline-block">10 mins ago</span>
                </div>
              </div>

              <div className="p-3.5 rounded-xl bg-[#f8ece1] border border-[#dbc1b5]/40 flex items-start gap-3">
                <div className="w-8 h-8 rounded-full bg-[#ffdad8] text-[#944242] flex items-center justify-center shrink-0">
                  <span className="material-symbols-outlined text-base">festival</span>
                </div>
                <div>
                  <h4 className="text-sm font-['Quicksand'] font-bold text-[#201b14]">
                    Digital Mela 2.0 is Live!
                  </h4>
                  <p className="text-xs font-['Vollkorn'] text-[#554339] mt-0.5">
                    Over 14,200 international collectors are browsing verified handlooms right now.
                  </p>
                  <span className="text-[10px] text-[#964407] font-semibold mt-1 inline-block">1 hour ago</span>
                </div>
              </div>

              <div className="p-3.5 rounded-xl bg-white border border-[#dbc1b5]/40 flex items-start gap-3">
                <div className="w-8 h-8 rounded-full bg-emerald-100 text-emerald-800 flex items-center justify-center shrink-0">
                  <span className="material-symbols-outlined text-base">verified</span>
                </div>
                <div>
                  <h4 className="text-sm font-['Quicksand'] font-bold text-[#201b14]">
                    GI Certification Renewal Verified
                  </h4>
                  <p className="text-xs font-['Vollkorn'] text-[#554339] mt-0.5">
                    Your Paithani Handloom certificate #244 has been renewed with zero commission guarantee.
                  </p>
                  <span className="text-[10px] text-gray-500 font-semibold mt-1 inline-block">Yesterday</span>
                </div>
              </div>
            </div>

            <button
              onClick={() => {
                setShowNotifications(false);
                setScreen('digital-mela');
              }}
              className="w-full py-3 bg-[#964407] hover:bg-[#b65c21] text-white font-['Quicksand'] font-bold text-sm rounded-xl shadow-sm transition-all"
            >
              Explore Buyer Leads & Mela
            </button>
          </div>
        </div>
      )}
    </>
  );
};
