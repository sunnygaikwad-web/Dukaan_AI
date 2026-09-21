import React, { useState } from 'react';
import { Header } from './components/Header';
import { BottomNav } from './components/BottomNav';
import { HomeScreen } from './components/screens/HomeScreen';
import { AddProductPhotoScreen } from './components/screens/AddProductPhotoScreen';
import { AddProductVoiceScreen } from './components/screens/AddProductVoiceScreen';
import { AiCatalogScreen } from './components/screens/AiCatalogScreen';
import { MultilingualCatalogScreen } from './components/screens/MultilingualCatalogScreen';
import { HeritageStoryScreen } from './components/screens/HeritageStoryScreen';
import { SmartPricingScreen } from './components/screens/SmartPricingScreen';
import { DigitalMelaScreen } from './components/screens/DigitalMelaScreen';
import { ProfileScreen } from './components/screens/ProfileScreen';
import { AppScreen } from './types';
import { ASSETS } from './data/mockData';

export default function App() {
  const [currentScreen, setCurrentScreen] = useState<AppScreen>('home');
  const [selectedPhoto, setSelectedPhoto] = useState<string>(ASSETS.paithaniMannequin);
  const [voiceTranscript, setVoiceTranscript] = useState<string>(
    'ही हाताने बनवलेली पैठणी साडी आहे. ती रेशमापासून बनवली आहे आणि त्यावर पारंपरिक मोराची डिझाइन आहे.'
  );

  const handleBack = () => {
    switch (currentScreen) {
      case 'add-photo':
        setCurrentScreen('home');
        break;
      case 'add-voice':
        setCurrentScreen('add-photo');
        break;
      case 'ai-catalog':
        setCurrentScreen('add-voice');
        break;
      case 'multilingual':
        setCurrentScreen('ai-catalog');
        break;
      case 'heritage':
        setCurrentScreen('multilingual');
        break;
      case 'pricing':
        setCurrentScreen('heritage');
        break;
      case 'digital-mela':
        setCurrentScreen('pricing');
        break;
      case 'profile':
        setCurrentScreen('home');
        break;
      default:
        setCurrentScreen('home');
    }
  };

  const showBack = currentScreen !== 'home';

  return (
    <div className="min-h-screen bg-[#fff8f4] text-[#201b14] flex flex-col selection:bg-[#ffdbca] selection:text-[#773300]">
      {/* Top App Bar */}
      <Header
        currentScreen={currentScreen}
        setScreen={setCurrentScreen}
        showBack={showBack}
        onBack={handleBack}
      />

      {/* Main Content Area */}
      <main className="flex-1">
        {currentScreen === 'home' && <HomeScreen setScreen={setCurrentScreen} />}

        {currentScreen === 'add-photo' && (
          <AddProductPhotoScreen
            setScreen={setCurrentScreen}
            selectedPhoto={selectedPhoto}
            setSelectedPhoto={setSelectedPhoto}
          />
        )}

        {currentScreen === 'add-voice' && (
          <AddProductVoiceScreen
            setScreen={setCurrentScreen}
            voiceTranscript={voiceTranscript}
            setVoiceTranscript={setVoiceTranscript}
          />
        )}

        {currentScreen === 'ai-catalog' && (
          <AiCatalogScreen
            setScreen={setCurrentScreen}
            productImage={selectedPhoto}
          />
        )}

        {currentScreen === 'multilingual' && (
          <MultilingualCatalogScreen setScreen={setCurrentScreen} />
        )}

        {currentScreen === 'heritage' && (
          <HeritageStoryScreen setScreen={setCurrentScreen} />
        )}

        {currentScreen === 'pricing' && (
          <SmartPricingScreen setScreen={setCurrentScreen} />
        )}

        {currentScreen === 'digital-mela' && (
          <DigitalMelaScreen setScreen={setCurrentScreen} />
        )}

        {currentScreen === 'profile' && (
          <ProfileScreen setScreen={setCurrentScreen} />
        )}
      </main>

      {/* Bottom Navigation */}
      <BottomNav currentScreen={currentScreen} setScreen={setCurrentScreen} />
    </div>
  );
}
