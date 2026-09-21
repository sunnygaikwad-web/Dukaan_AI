import React, { useState } from 'react';
import { ASSETS } from '../../data/mockData';
import { AppScreen } from '../../types';

interface AiCatalogScreenProps {
  setScreen: (screen: AppScreen) => void;
  productImage?: string;
}

export const AiCatalogScreen: React.FC<AiCatalogScreenProps> = ({
  setScreen,
  productImage = ASSETS.paithaniMannequin
}) => {
  const [isRegenerating, setIsRegenerating] = useState(false);
  const [showEditModal, setShowEditModal] = useState(false);

  const [title, setTitle] = useState('Handwoven Paithani Silk Saree');
  const [craft, setCraft] = useState('Paithani');
  const [price, setPrice] = useState('24,500');
  const [description, setDescription] = useState(
    'Exquisite handwoven Paithani silk saree crafted by master artisans in Maharashtra. Features traditional peacock motifs in rich zari work and vibrant silk threads, perfect for festive occasions and weddings.'
  );

  const handleRegenerate = () => {
    setIsRegenerating(true);
    setTimeout(() => {
      setDescription(
        'Museum-grade authentic Paithani handloom masterpiece in royal saffron and terracotta tones. Woven with pure mulberry silk and hand-interlocked zari pallu depicting timeless Kalanjali motifs.'
      );
      setIsRegenerating(false);
    }, 900);
  };

  return (
    <div className="max-w-xl mx-auto px-4 sm:px-6 pt-5 pb-28 space-y-6 animate-in fade-in duration-200">
      {/* Header Section */}
      <div className="space-y-1">
        <h1 className="font-['Quicksand'] font-bold text-2xl sm:text-3xl text-[#201b14] tracking-tight">
          Your AI-Generated Catalog ✨
        </h1>
        <p className="text-[#554339] font-['Vollkorn'] text-base">
          ShilpMitra has turned your photo and voice into a professional listing.
        </p>
      </div>

      {/* Product Card Container */}
      <div className="bg-[#fef1e7] rounded-2xl p-5 sm:p-6 shadow-[0_2px_16px_rgba(58,48,42,0.06)] border border-[#dbc1b5]/60 space-y-6">
        {/* Product Image Preview */}
        <div className="relative w-full h-80 rounded-xl overflow-hidden shadow-sm bg-[#ece0d6] border border-[#dbc1b5]/40">
          <img
            src={productImage || ASSETS.paithaniMannequin}
            alt={title}
            className={`w-full h-full object-cover transition-opacity duration-300 ${
              isRegenerating ? 'opacity-40 animate-pulse' : 'opacity-100'
            }`}
          />
          <div className="absolute top-4 left-4 bg-[#964407] text-white px-3 py-1.5 rounded-full text-xs font-['Quicksand'] font-bold flex items-center gap-1.5 shadow-md">
            <span className="material-symbols-outlined text-sm" style={{ fontVariationSettings: "'FILL' 1" }}>
              auto_awesome
            </span>
            <span>AI Generated</span>
          </div>
        </div>

        {/* Product Details Content */}
        <div className="space-y-4">
          <div>
            <div className="flex items-center justify-between mb-1.5">
              <span className="text-xs font-['IBM_Plex_Serif'] uppercase tracking-wider text-[#964407] font-bold">
                Textiles | Pure Silk
              </span>
              <span className="text-xs font-['IBM_Plex_Serif'] text-[#554339] bg-[#f8ece1] px-2.5 py-1 rounded-full border border-[#dbc1b5]/40">
                Origin: Maharashtra
              </span>
            </div>
            <h2 className="font-['Quicksand'] font-bold text-2xl text-[#201b14]">
              {title}
            </h2>
          </div>

          {/* AI-Generated Description */}
          <div className="bg-white p-4 rounded-xl border border-[#dbc1b5]/40 relative overflow-hidden">
            {isRegenerating && (
              <div className="absolute inset-0 bg-[#fff8f4]/80 backdrop-blur-xs flex items-center justify-center gap-2 text-[#964407] font-['Quicksand'] font-bold text-sm">
                <span className="material-symbols-outlined animate-spin">refresh</span>
                Crafting enhanced cultural description...
              </div>
            )}
            <div className="flex items-center gap-2 mb-2 text-[#964407]">
              <span className="material-symbols-outlined text-sm">psychology</span>
              <span className="font-['Quicksand'] font-bold text-xs uppercase tracking-wider">
                AI-Generated Description
              </span>
            </div>
            <p className="text-[#554339] text-sm leading-relaxed italic font-['Vollkorn']">
              "{description}"
            </p>
          </div>

          {/* Attributes Grid */}
          <div className="grid grid-cols-2 gap-3 pt-1">
            <div className="bg-white p-3.5 rounded-xl border border-[#dbc1b5]/40">
              <span className="text-xs font-['IBM_Plex_Serif'] text-[#554339] block mb-0.5">
                Craft
              </span>
              <span className="font-['Quicksand'] font-bold text-sm text-[#201b14]">
                {craft}
              </span>
            </div>
            <div className="bg-white p-3.5 rounded-xl border border-[#dbc1b5]/40">
              <span className="text-xs font-['IBM_Plex_Serif'] text-[#554339] block mb-0.5">
                Estimated Value
              </span>
              <span className="font-['Quicksand'] font-bold text-base text-[#964407]">
                ₹{price}
              </span>
            </div>
          </div>
        </div>

        {/* Action Buttons */}
        <div className="pt-2 space-y-3">
          <button
            onClick={() => setScreen('multilingual')}
            className="w-full bg-[#964407] hover:bg-[#b65c21] text-white font-['Quicksand'] font-bold py-3.5 px-6 rounded-xl shadow-md transition-all duration-200 active:scale-98 flex items-center justify-center gap-2"
          >
            <span>Continue</span>
            <span className="material-symbols-outlined text-lg">arrow_forward</span>
          </button>

          <div className="grid grid-cols-2 gap-3">
            <button
              onClick={() => setShowEditModal(true)}
              className="bg-[#fff8f4] border border-[#dbc1b5] hover:bg-[#f8ece1] text-[#201b14] font-['Quicksand'] font-semibold py-3 px-4 rounded-xl transition-all active:scale-98 flex items-center justify-center gap-2"
            >
              <span className="material-symbols-outlined text-sm">edit</span>
              <span>Edit Details</span>
            </button>
            <button
              onClick={handleRegenerate}
              disabled={isRegenerating}
              className="bg-[#fff8f4] border border-[#dbc1b5] hover:bg-[#f8ece1] text-[#201b14] font-['Quicksand'] font-semibold py-3 px-4 rounded-xl transition-all active:scale-98 flex items-center justify-center gap-2"
            >
              <span className={`material-symbols-outlined text-sm ${isRegenerating ? 'animate-spin' : ''}`}>
                refresh
              </span>
              <span>Regenerate</span>
            </button>
          </div>
        </div>
      </div>

      {/* Edit Details Modal */}
      {showEditModal && (
        <div
          className="fixed inset-0 z-50 bg-black/40 backdrop-blur-xs flex items-center justify-center p-4"
          onClick={() => setShowEditModal(false)}
        >
          <div
            className="bg-[#fff8f4] max-w-md w-full rounded-2xl shadow-2xl border border-[#dbc1b5] p-6 space-y-4 animate-in fade-in zoom-in-95 duration-150"
            onClick={(e) => e.stopPropagation()}
          >
            <div className="flex items-center justify-between border-b border-[#dbc1b5]/40 pb-3">
              <h3 className="font-['Quicksand'] font-bold text-lg text-[#201b14]">
                Edit Listing Details
              </h3>
              <button
                onClick={() => setShowEditModal(false)}
                className="w-8 h-8 rounded-full flex items-center justify-center text-[#554339] hover:bg-[#f8ece1]"
              >
                <span className="material-symbols-outlined">close</span>
              </button>
            </div>

            <div className="space-y-3 font-['Quicksand']">
              <div>
                <label className="text-xs font-bold text-[#554339] block mb-1">
                  Product Title
                </label>
                <input
                  type="text"
                  value={title}
                  onChange={(e) => setTitle(e.target.value)}
                  className="w-full px-3 py-2 rounded-lg bg-white border border-[#dbc1b5] focus:outline-none focus:ring-2 focus:ring-[#964407] text-sm"
                />
              </div>

              <div>
                <label className="text-xs font-bold text-[#554339] block mb-1">
                  Craft Style
                </label>
                <input
                  type="text"
                  value={craft}
                  onChange={(e) => setCraft(e.target.value)}
                  className="w-full px-3 py-2 rounded-lg bg-white border border-[#dbc1b5] focus:outline-none focus:ring-2 focus:ring-[#964407] text-sm"
                />
              </div>

              <div>
                <label className="text-xs font-bold text-[#554339] block mb-1">
                  Estimated Price (₹)
                </label>
                <input
                  type="text"
                  value={price}
                  onChange={(e) => setPrice(e.target.value)}
                  className="w-full px-3 py-2 rounded-lg bg-white border border-[#dbc1b5] focus:outline-none focus:ring-2 focus:ring-[#964407] text-sm"
                />
              </div>

              <div>
                <label className="text-xs font-bold text-[#554339] block mb-1">
                  Description
                </label>
                <textarea
                  rows={3}
                  value={description}
                  onChange={(e) => setDescription(e.target.value)}
                  className="w-full px-3 py-2 rounded-lg bg-white border border-[#dbc1b5] focus:outline-none focus:ring-2 focus:ring-[#964407] text-sm font-['Vollkorn']"
                />
              </div>
            </div>

            <div className="flex gap-2 pt-2">
              <button
                onClick={() => setShowEditModal(false)}
                className="flex-1 py-2.5 bg-white border border-[#dbc1b5] rounded-lg text-sm font-['Quicksand'] font-bold text-[#554339]"
              >
                Cancel
              </button>
              <button
                onClick={() => setShowEditModal(false)}
                className="flex-1 py-2.5 bg-[#964407] text-white rounded-lg text-sm font-['Quicksand'] font-bold shadow-sm hover:bg-[#b65c21]"
              >
                Save Changes
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
