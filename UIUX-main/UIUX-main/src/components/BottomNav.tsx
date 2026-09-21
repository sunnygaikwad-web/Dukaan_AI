import React from 'react';
import { AppScreen, NavTab } from '../types';

interface BottomNavProps {
  currentScreen: AppScreen;
  setScreen: (screen: AppScreen) => void;
}

export const BottomNav: React.FC<BottomNavProps> = ({ currentScreen, setScreen }) => {
  // Determine which nav tab is currently active
  const getActiveTab = (): NavTab => {
    if (currentScreen === 'home') return 'home';
    if (
      currentScreen === 'add-photo' ||
      currentScreen === 'add-voice' ||
      currentScreen === 'ai-catalog' ||
      currentScreen === 'multilingual'
    ) {
      return 'products';
    }
    if (currentScreen === 'heritage' || currentScreen === 'pricing' || currentScreen === 'digital-mela') {
      return 'ai-assist';
    }
    if (currentScreen === 'profile') return 'profile';
    return 'home';
  };

  const activeTab = getActiveTab();

  const handleNavClick = (tab: NavTab) => {
    switch (tab) {
      case 'home':
        setScreen('home');
        break;
      case 'products':
        // If already in product flow, keep or go to catalog
        if (currentScreen === 'multilingual') {
          setScreen('multilingual');
        } else {
          setScreen('ai-catalog');
        }
        break;
      case 'ai-assist':
        setScreen('heritage');
        break;
      case 'profile':
        setScreen('profile');
        break;
    }
  };

  return (
    <nav className="fixed bottom-0 left-0 w-full z-50 flex justify-around items-center px-3 py-2 bg-[#fff8f4] border-t border-[#dbc1b5]/60 shadow-[0_-4px_20px_rgba(58,48,42,0.05)]">
      {/* Home */}
      <button
        onClick={() => handleNavClick('home')}
        className={`flex flex-col items-center justify-center px-4 py-1.5 rounded-2xl transition-all duration-200 active:scale-95 ${
          activeTab === 'home'
            ? 'bg-[#e9ded6] text-[#201b14] font-bold shadow-xs'
            : 'text-[#554339] hover:bg-[#f8ece1]'
        }`}
      >
        <span
          className="material-symbols-outlined text-2xl"
          style={{ fontVariationSettings: activeTab === 'home' ? "'FILL' 1" : "'FILL' 0" }}
        >
          home
        </span>
        <span className="text-xs font-['IBM_Plex_Serif'] mt-0.5">Home</span>
      </button>

      {/* Products */}
      <button
        onClick={() => handleNavClick('products')}
        className={`flex flex-col items-center justify-center px-4 py-1.5 rounded-2xl transition-all duration-200 active:scale-95 ${
          activeTab === 'products'
            ? 'bg-[#e9ded6] text-[#201b14] font-bold shadow-xs'
            : 'text-[#554339] hover:bg-[#f8ece1]'
        }`}
      >
        <span
          className="material-symbols-outlined text-2xl"
          style={{ fontVariationSettings: activeTab === 'products' ? "'FILL' 1" : "'FILL' 0" }}
        >
          inventory_2
        </span>
        <span className="text-xs font-['IBM_Plex_Serif'] mt-0.5">Products</span>
      </button>

      {/* AI Assist */}
      <button
        onClick={() => handleNavClick('ai-assist')}
        className={`flex flex-col items-center justify-center px-4 py-1.5 rounded-2xl transition-all duration-200 active:scale-95 ${
          activeTab === 'ai-assist'
            ? 'bg-[#e9ded6] text-[#201b14] font-bold shadow-xs'
            : 'text-[#554339] hover:bg-[#f8ece1]'
        }`}
      >
        <span
          className="material-symbols-outlined text-2xl"
          style={{ fontVariationSettings: activeTab === 'ai-assist' ? "'FILL' 1" : "'FILL' 0" }}
        >
          auto_awesome
        </span>
        <span className="text-xs font-['IBM_Plex_Serif'] mt-0.5">AI Assist</span>
      </button>

      {/* Profile */}
      <button
        onClick={() => handleNavClick('profile')}
        className={`flex flex-col items-center justify-center px-4 py-1.5 rounded-2xl transition-all duration-200 active:scale-95 ${
          activeTab === 'profile'
            ? 'bg-[#e9ded6] text-[#201b14] font-bold shadow-xs'
            : 'text-[#554339] hover:bg-[#f8ece1]'
        }`}
      >
        <span
          className="material-symbols-outlined text-2xl"
          style={{ fontVariationSettings: activeTab === 'profile' ? "'FILL' 1" : "'FILL' 0" }}
        >
          person
        </span>
        <span className="text-xs font-['IBM_Plex_Serif'] mt-0.5">Profile</span>
      </button>
    </nav>
  );
};
