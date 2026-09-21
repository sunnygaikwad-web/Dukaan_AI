import React, { useRef, useState } from 'react';
import { ASSETS } from '../../data/mockData';
import { AppScreen } from '../../types';

interface AddProductPhotoScreenProps {
  setScreen: (screen: AppScreen) => void;
  setSelectedPhoto: (url: string) => void;
  selectedPhoto: string;
}

export const AddProductPhotoScreen: React.FC<AddProductPhotoScreenProps> = ({
  setScreen,
  setSelectedPhoto,
  selectedPhoto
}) => {
  const fileInputRef = useRef<HTMLInputElement>(null);
  const [isCameraActive, setIsCameraActive] = useState(false);
  const [photoPreview, setPhotoPreview] = useState<string>(selectedPhoto || ASSETS.paithaniMannequin);

  const samplePhotos = [
    { title: 'Paithani Saree', url: ASSETS.paithaniMannequin },
    { title: 'Terracotta Vase', url: ASSETS.terracottaVase },
    { title: 'Blue Pottery', url: ASSETS.bluePotteryVase },
    { title: 'Dhokra Artifact', url: ASSETS.dhokraHorse }
  ];

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files && e.target.files[0]) {
      const file = e.target.files[0];
      const url = URL.createObjectURL(file);
      setPhotoPreview(url);
      setSelectedPhoto(url);
      setTimeout(() => {
        setScreen('add-voice');
      }, 400);
    }
  };

  const handleSelectSample = (url: string) => {
    setPhotoPreview(url);
    setSelectedPhoto(url);
    setTimeout(() => {
      setScreen('add-voice');
    }, 300);
  };

  const handleTakePhotoSim = () => {
    setIsCameraActive(true);
    setTimeout(() => {
      setIsCameraActive(false);
      setSelectedPhoto(ASSETS.paithaniMannequin);
      setScreen('add-voice');
    }, 1200);
  };

  return (
    <div className="max-w-md mx-auto px-4 sm:px-6 pt-5 pb-28 space-y-6 animate-in fade-in duration-200">
      {/* Hidden file input */}
      <input
        ref={fileInputRef}
        type="file"
        accept="image/*"
        className="hidden"
        onChange={handleFileChange}
      />

      {/* Screen Title */}
      <div className="space-y-1">
        <h2 className="text-3xl font-['Quicksand'] font-bold text-[#201b14] tracking-tight">
          Let's add your craft.
        </h2>
        <p className="text-base font-['Vollkorn'] text-[#554339]">
          Just take a photo. We'll help with the rest.
        </p>
      </div>

      {/* Action Cards Container */}
      <div className="space-y-4">
        {/* Take Photo Card */}
        <div
          onClick={handleTakePhotoSim}
          className="bg-[#fef1e7] rounded-2xl p-5 sm:p-6 border border-[#dbc1b5]/60 shadow-xs hover:shadow-md hover:border-[#b65c21] transition-all cursor-pointer flex items-center justify-between group active:scale-98"
        >
          <div className="flex items-center space-x-4">
            <div className="w-14 h-14 rounded-2xl bg-[#b65c21] text-white flex items-center justify-center shrink-0 shadow-sm group-hover:scale-105 transition-transform">
              <span className="material-symbols-outlined text-2xl">photo_camera</span>
            </div>
            <div>
              <h3 className="text-lg font-['Quicksand'] font-bold text-[#201b14]">
                Take Photo
              </h3>
              <p className="text-xs sm:text-sm font-['Vollkorn'] text-[#554339] max-w-[210px] leading-snug">
                Use your camera to capture your craft in natural light.
              </p>
            </div>
          </div>
          <span className="material-symbols-outlined text-xl text-[#964407] group-hover:translate-x-1 transition-transform">
            arrow_forward
          </span>
        </div>

        {/* Choose From Gallery Card */}
        <div
          onClick={() => fileInputRef.current?.click()}
          className="bg-[#fef1e7] rounded-2xl p-5 sm:p-6 border border-[#dbc1b5]/60 shadow-xs hover:shadow-md hover:border-[#b65c21] transition-all cursor-pointer flex items-center justify-between group active:scale-98"
        >
          <div className="flex items-center space-x-4">
            <div className="w-14 h-14 rounded-2xl bg-[#e9ded6] text-[#645d57] flex items-center justify-center shrink-0 group-hover:scale-105 transition-transform">
              <span className="material-symbols-outlined text-2xl">image</span>
            </div>
            <div>
              <h3 className="text-lg font-['Quicksand'] font-bold text-[#201b14]">
                Choose From Gallery
              </h3>
              <p className="text-xs sm:text-sm font-['Vollkorn'] text-[#554339] max-w-[210px] leading-snug">
                Select an existing photo from your device.
              </p>
            </div>
          </div>
          <span className="material-symbols-outlined text-xl text-[#964407] group-hover:translate-x-1 transition-transform">
            arrow_forward
          </span>
        </div>
      </div>

      {/* Quick Artisan Craft Photo Presets */}
      <div className="bg-[#f8ece1] p-4 rounded-2xl border border-[#dbc1b5]/50 space-y-2.5">
        <div className="flex items-center justify-between">
          <span className="text-xs font-['IBM_Plex_Serif'] font-bold uppercase tracking-wider text-[#964407]">
            Or Select a Demo Craft Photo
          </span>
          <span className="text-[11px] text-[#554339]">Instant AI Scan</span>
        </div>
        <div className="grid grid-cols-4 gap-2">
          {samplePhotos.map((sample, idx) => (
            <button
              key={idx}
              onClick={() => handleSelectSample(sample.url)}
              className="group relative rounded-xl overflow-hidden aspect-square border border-[#dbc1b5] hover:border-[#b65c21] hover:shadow-sm transition-all focus:ring-2 focus:ring-[#964407]"
            >
              <img src={sample.url} alt={sample.title} className="w-full h-full object-cover group-hover:scale-105 transition-transform" />
              <div className="absolute inset-0 bg-gradient-to-t from-black/70 via-transparent to-transparent flex items-end p-1">
                <span className="text-[10px] font-['Quicksand'] text-white truncate w-full font-medium">
                  {sample.title}
                </span>
              </div>
            </button>
          ))}
        </div>
      </div>

      {/* Tips for a great photo */}
      <section className="bg-[#f8ece1] rounded-2xl p-5 border border-[#dbc1b5]/50 space-y-3">
        <div className="flex items-center space-x-2 text-[#964407]">
          <span className="material-symbols-outlined text-lg">lightbulb</span>
          <h4 className="text-sm font-['Quicksand'] font-bold text-[#201b14]">
            Tips for a great photo
          </h4>
        </div>
        <ul className="space-y-2 text-sm font-['Vollkorn'] text-[#554339]">
          <li className="flex items-center space-x-2.5">
            <span className="text-[#964407] font-bold text-sm">✓</span>
            <span>Use natural light</span>
          </li>
          <li className="flex items-center space-x-2.5">
            <span className="text-[#964407] font-bold text-sm">✓</span>
            <span>Keep the product visible</span>
          </li>
          <li className="flex items-center space-x-2.5">
            <span className="text-[#964407] font-bold text-sm">✓</span>
            <span>Avoid clutter</span>
          </li>
        </ul>
      </section>

      {/* Camera Simulator Overlay */}
      {isCameraActive && (
        <div className="fixed inset-0 z-50 bg-black/90 flex flex-col items-center justify-between p-6 text-white animate-in fade-in duration-200">
          <div className="text-center pt-8">
            <span className="text-sm font-['Quicksand'] uppercase tracking-widest text-[#ffdbca]">
              ShilpMitra AI Camera
            </span>
            <p className="text-xs text-gray-300 mt-1">Focusing on handwoven silk motifs...</p>
          </div>

          <div className="relative w-64 h-64 border-2 border-dashed border-[#ffdbca] rounded-2xl flex items-center justify-center overflow-hidden">
            <img src={ASSETS.paithaniMannequin} alt="Target craft" className="w-full h-full object-cover animate-pulse" />
            <div className="absolute inset-0 bg-white/10 backdrop-blur-xs flex items-center justify-center">
              <div className="w-16 h-16 rounded-full border-4 border-white border-t-transparent animate-spin" />
            </div>
          </div>

          <div className="pb-12 text-center">
            <span className="text-sm font-['IBM_Plex_Serif'] text-white">
              Capturing high-resolution color & texture...
            </span>
          </div>
        </div>
      )}
    </div>
  );
};
