import React, { useState } from 'react';
import { ASSETS } from '../../data/mockData';
import { AppScreen } from '../../types';

interface DigitalMelaScreenProps {
  setScreen: (screen: AppScreen) => void;
}

export const DigitalMelaScreen: React.FC<DigitalMelaScreenProps> = ({ setScreen }) => {
  const [activeCategory, setActiveCategory] = useState('All');
  const [currentBid, setCurrentBid] = useState(24500);
  const [showBidModal, setShowBidModal] = useState(false);
  const [showStreamModal, setShowStreamModal] = useState(false);
  const [showChatModal, setShowChatModal] = useState<string | null>(null);
  const [bidInput, setBidInput] = useState('25500');

  const categories = ['All', 'Pottery', 'Handloom', 'Terracotta', 'Woodwork', 'Metal Craft'];

  const handlePlaceBid = (e: React.FormEvent) => {
    e.preventDefault();
    const val = parseInt(bidInput);
    if (!isNaN(val) && val > currentBid) {
      setCurrentBid(val);
      setShowBidModal(false);
    }
  };

  return (
    <div className="max-w-md mx-auto px-4 pt-4 pb-28 space-y-6 animate-in fade-in duration-200">
      {/* Header Banner: Digital Mela 2.0 */}
      <section className="relative rounded-2xl overflow-hidden shadow-md bg-gradient-to-br from-[#b65c21] to-[#964407] text-white p-6">
        <div
          className="absolute inset-0 opacity-25 bg-cover bg-center mix-blend-overlay"
          style={{ backgroundImage: `url(${ASSETS.melaHeaderBg})` }}
        />
        <div className="relative z-10 space-y-4">
          <div className="inline-flex items-center space-x-2 bg-white/20 backdrop-blur-md px-3 py-1 rounded-full text-xs font-semibold text-white border border-white/20">
            <span className="w-2 h-2 rounded-full bg-red-400 animate-ping" />
            <span>LIVE GLOBAL SHOWCASE</span>
          </div>

          <div className="space-y-1">
            <h2 className="text-xl sm:text-2xl font-['Quicksand'] font-bold text-white tracking-tight leading-snug">
              Digital Mela 2.0 - Live Global Artisan Showcase
            </h2>
            <p className="text-xs sm:text-sm font-['Vollkorn'] text-[#f8ece1] opacity-90 leading-relaxed">
              Connecting heritage creators directly with international connoisseurs and bulk buyers.
            </p>
          </div>

          <div className="flex items-center justify-between pt-2">
            <div className="flex items-center space-x-1.5 text-xs font-['IBM_Plex_Serif'] bg-black/20 px-3 py-1.5 rounded-xl backdrop-blur-xs text-white">
              <span className="material-symbols-outlined text-sm">visibility</span>
              <span>14.2K Active Viewers</span>
            </div>
            <button
              onClick={() => setShowStreamModal(true)}
              className="bg-[#fff8f4] text-[#964407] hover:bg-white px-4 py-2 rounded-xl font-['Quicksand'] font-bold text-xs sm:text-sm shadow-sm transition-transform active:scale-95 flex items-center space-x-1.5"
            >
              <span className="material-symbols-outlined text-base">play_circle</span>
              <span>Join Live Stream</span>
            </button>
          </div>
        </div>
      </section>

      {/* Category Filter Chips */}
      <section className="overflow-x-auto no-scrollbar pb-1 -mx-4 px-4">
        <div className="flex space-x-2 min-w-max">
          {categories.map((cat) => (
            <button
              key={cat}
              onClick={() => setActiveCategory(cat)}
              className={`px-4 py-1.5 rounded-full text-xs font-['Quicksand'] font-semibold transition-all ${
                activeCategory === cat
                  ? 'bg-[#964407] text-white shadow-xs'
                  : 'bg-[#f8ece1] hover:bg-[#f2e6dc] text-[#554339] border border-[#dbc1b5]/60'
              }`}
            >
              {cat}
            </button>
          ))}
        </div>
      </section>

      {/* Featured Global Buyer Leads & Live Auctions */}
      <section className="space-y-3">
        <div className="flex justify-between items-center">
          <h3 className="font-['Quicksand'] font-bold text-lg text-[#201b14]">
            Live Auctions &amp; Buyer Leads
          </h3>
          <span className="text-xs text-[#964407] font-['IBM_Plex_Serif'] font-bold tracking-wide uppercase cursor-pointer hover:underline">
            View All
          </span>
        </div>

        <div className="bg-[#fef1e7] border border-[#dbc1b5]/60 rounded-2xl p-4 shadow-xs relative overflow-hidden">
          <div className="absolute top-0 right-0 bg-[#944242] text-white text-[10px] font-['IBM_Plex_Serif'] font-bold px-3 py-1 rounded-bl-xl tracking-wider">
            LIVE BIDDING
          </div>

          <div className="flex items-start space-x-3.5">
            <div className="w-16 h-16 rounded-xl bg-[#f2e6dc] overflow-hidden shrink-0 border border-[#dbc1b5]/40">
              <img
                src={ASSETS.dhokraHorse}
                alt="Bastar Dhokra Horse Figurine Set"
                className="w-full h-full object-cover"
              />
            </div>
            <div className="flex-1 space-y-1">
              <div className="flex items-center space-x-1.5">
                <span className="material-symbols-outlined text-sm text-[#964407]">gavel</span>
                <span className="text-xs font-['IBM_Plex_Serif'] font-semibold text-[#964407]">
                  Global Curator Lead - Paris, FR
                </span>
              </div>
              <h4 className="font-['Quicksand'] font-bold text-sm text-[#201b14]">
                Bastar Dhokra Horse Figurine Set
              </h4>
              <div className="flex justify-between items-end pt-1">
                <div>
                  <span className="text-[11px] font-['IBM_Plex_Serif'] text-[#554339] block">
                    Current Bid
                  </span>
                  <span className="font-['Quicksand'] font-bold text-sm text-[#201b14]">
                    ₹{currentBid.toLocaleString('en-IN')}{' '}
                    <span className="text-xs font-normal text-[#554339]">
                      (${Math.round(currentBid * 0.012)} USD)
                    </span>
                  </span>
                </div>
                <button
                  onClick={() => setShowBidModal(true)}
                  className="bg-[#b65c21] hover:bg-[#964407] text-white px-3.5 py-1.5 rounded-lg text-xs font-['Quicksand'] font-bold transition-all active:scale-95 shadow-xs"
                >
                  Place Bid
                </button>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Verified Artisan Masterpieces */}
      <section className="space-y-3">
        <div className="flex justify-between items-center">
          <h3 className="font-['Quicksand'] font-bold text-lg text-[#201b14]">
            Verified Artisan Masterpieces
          </h3>
          <span className="text-xs text-[#554339] font-['IBM_Plex_Serif']">
            Showing 2 of 128
          </span>
        </div>

        <div className="space-y-4">
          {/* Craft Card 1: Terracotta Cooling Pitcher */}
          <div className="bg-white border border-[#dbc1b5]/60 rounded-2xl overflow-hidden shadow-[0_2px_16px_rgba(58,48,42,0.04)] hover:shadow-md transition-all">
            <div className="relative h-48 bg-[#f8ece1]">
              <img
                src={ASSETS.terracottaPitcher}
                alt="Terracotta Cooling Pitcher & Goblets"
                className="w-full h-full object-cover"
              />
              <div className="absolute top-3 left-3 bg-white/90 backdrop-blur-xs text-[#964407] px-2.5 py-1 rounded-full text-[11px] font-['IBM_Plex_Serif'] font-bold flex items-center space-x-1 border border-[#964407]/20 shadow-xs">
                <span className="material-symbols-outlined text-xs" style={{ fontVariationSettings: "'FILL' 1" }}>
                  verified
                </span>
                <span>GI Tagged - Terracotta</span>
              </div>
              <div className="absolute bottom-3 left-3 bg-[#e9ded6]/90 backdrop-blur-xs text-[#201b14] px-2.5 py-1 rounded-lg text-[11px] font-['IBM_Plex_Serif'] font-medium flex items-center space-x-1">
                <span className="material-symbols-outlined text-xs text-[#964407]">trending_up</span>
                <span>4 International Buyers Interested</span>
              </div>
            </div>

            <div className="p-4 space-y-3">
              <div>
                <span className="text-xs text-[#554339] font-['IBM_Plex_Serif']">
                  By Ramesh Prajapati • Rajasthan
                </span>
                <h4 className="font-['Quicksand'] font-bold text-base text-[#201b14]">
                  Terracotta Cooling Pitcher &amp; Goblets
                </h4>
              </div>

              <div className="flex items-center justify-between pt-1 border-t border-[#dbc1b5]/30">
                <div>
                  <span className="text-[11px] font-['IBM_Plex_Serif'] text-[#554339] block">Direct Price</span>
                  <span className="font-['Quicksand'] font-bold text-base text-[#964407]">
                    ₹3,200 <span className="text-xs font-normal text-[#554339]">($38 USD)</span>
                  </span>
                </div>
                <div className="flex space-x-2">
                  <button
                    onClick={() => setShowChatModal('Ramesh Prajapati')}
                    className="border border-[#dbc1b5] hover:bg-[#f8ece1] text-[#201b14] px-3 py-1.5 rounded-lg text-xs font-['Quicksand'] font-bold transition-all flex items-center space-x-1"
                  >
                    <span className="material-symbols-outlined text-sm">chat</span>
                    <span>Chat</span>
                  </button>
                  <button
                    onClick={() => setShowChatModal('Ramesh Prajapati (Instant Connect)')}
                    className="bg-[#964407] hover:bg-[#b65c21] text-white px-3 py-1.5 rounded-lg text-xs font-['Quicksand'] font-bold shadow-xs transition-all flex items-center space-x-1"
                  >
                    <span className="material-symbols-outlined text-sm">bolt</span>
                    <span>Instant Connect</span>
                  </button>
                </div>
              </div>
            </div>
          </div>

          {/* Craft Card 2: Handloom Saree */}
          <div className="bg-white border border-[#dbc1b5]/60 rounded-2xl overflow-hidden shadow-[0_2px_16px_rgba(58,48,42,0.04)] hover:shadow-md transition-all">
            <div className="relative h-48 bg-[#f8ece1]">
              <img
                src={ASSETS.handloomSaree}
                alt="Kassav Pure Gold Zari Handloom Saree"
                className="w-full h-full object-cover"
              />
              <div className="absolute top-3 left-3 bg-white/90 backdrop-blur-xs text-[#964407] px-2.5 py-1 rounded-full text-[11px] font-['IBM_Plex_Serif'] font-bold flex items-center space-x-1 border border-[#964407]/20 shadow-xs">
                <span className="material-symbols-outlined text-xs" style={{ fontVariationSettings: "'FILL' 1" }}>
                  verified
                </span>
                <span>GI Tagged - Handloom Silk</span>
              </div>
              <div className="absolute bottom-3 left-3 bg-[#e9ded6]/90 backdrop-blur-xs text-[#201b14] px-2.5 py-1 rounded-lg text-[11px] font-['IBM_Plex_Serif'] font-medium flex items-center space-x-1">
                <span className="material-symbols-outlined text-xs text-[#964407]">trending_up</span>
                <span>7 International Buyers Interested</span>
              </div>
            </div>

            <div className="p-4 space-y-3">
              <div>
                <span className="text-xs text-[#554339] font-['IBM_Plex_Serif']">
                  By Anandi Devi • Varanasi
                </span>
                <h4 className="font-['Quicksand'] font-bold text-base text-[#201b14]">
                  Kassav Pure Gold Zari Handloom Saree
                </h4>
              </div>

              <div className="flex items-center justify-between pt-1 border-t border-[#dbc1b5]/30">
                <div>
                  <span className="text-[11px] font-['IBM_Plex_Serif'] text-[#554339] block">Direct Price</span>
                  <span className="font-['Quicksand'] font-bold text-base text-[#964407]">
                    ₹18,500 <span className="text-xs font-normal text-[#554339]">($225 USD)</span>
                  </span>
                </div>
                <div className="flex space-x-2">
                  <button
                    onClick={() => setShowChatModal('Anandi Devi')}
                    className="border border-[#dbc1b5] hover:bg-[#f8ece1] text-[#201b14] px-3 py-1.5 rounded-lg text-xs font-['Quicksand'] font-bold transition-all flex items-center space-x-1"
                  >
                    <span className="material-symbols-outlined text-sm">chat</span>
                    <span>Chat</span>
                  </button>
                  <button
                    onClick={() => setShowChatModal('Anandi Devi (Instant Connect)')}
                    className="bg-[#964407] hover:bg-[#b65c21] text-white px-3 py-1.5 rounded-lg text-xs font-['Quicksand'] font-bold shadow-xs transition-all flex items-center space-x-1"
                  >
                    <span className="material-symbols-outlined text-sm">bolt</span>
                    <span>Instant Connect</span>
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Place Bid Modal */}
      {showBidModal && (
        <div
          className="fixed inset-0 z-50 bg-black/40 backdrop-blur-xs flex items-center justify-center p-4"
          onClick={() => setShowBidModal(false)}
        >
          <div
            className="bg-[#fff8f4] max-w-md w-full rounded-2xl shadow-2xl border border-[#dbc1b5] p-6 space-y-4 animate-in fade-in zoom-in-95 duration-150"
            onClick={(e) => e.stopPropagation()}
          >
            <div className="flex items-center justify-between border-b border-[#dbc1b5]/40 pb-3">
              <h3 className="font-['Quicksand'] font-bold text-lg text-[#201b14]">
                Place Live Auction Bid
              </h3>
              <button
                onClick={() => setShowBidModal(false)}
                className="w-8 h-8 rounded-full flex items-center justify-center text-[#554339] hover:bg-[#f8ece1]"
              >
                <span className="material-symbols-outlined">close</span>
              </button>
            </div>

            <div className="space-y-3 font-['Quicksand']">
              <div className="p-3 bg-[#fef1e7] rounded-xl border border-[#dbc1b5]/40 text-xs">
                <span className="text-[#554339]">Current Highest Bid:</span>
                <span className="font-bold text-[#964407] ml-2 text-sm">₹{currentBid.toLocaleString('en-IN')}</span>
              </div>

              <div>
                <label className="text-xs font-bold text-[#554339] block mb-1">
                  Your New Bid (INR ₹)
                </label>
                <input
                  type="number"
                  value={bidInput}
                  min={currentBid + 500}
                  step="500"
                  onChange={(e) => setBidInput(e.target.value)}
                  className="w-full px-3 py-2 rounded-xl bg-white border border-[#dbc1b5] focus:outline-none focus:ring-2 focus:ring-[#964407] text-sm"
                />
              </div>

              <p className="text-[11px] font-['Vollkorn'] text-[#554339]">
                All bids are backed by ShilpMitra zero-commission smart contracts and verified escrow.
              </p>
            </div>

            <div className="flex gap-2 pt-2">
              <button
                onClick={() => setShowBidModal(false)}
                className="flex-1 py-2.5 bg-white border border-[#dbc1b5] rounded-xl text-sm font-['Quicksand'] font-bold text-[#554339]"
              >
                Cancel
              </button>
              <button
                onClick={handlePlaceBid}
                className="flex-1 py-2.5 bg-[#964407] text-white rounded-xl text-sm font-['Quicksand'] font-bold shadow-sm hover:bg-[#b65c21]"
              >
                Confirm Bid
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Live Stream Showcase Modal */}
      {showStreamModal && (
        <div
          className="fixed inset-0 z-50 bg-black/80 backdrop-blur-xs flex items-center justify-center p-4 animate-in fade-in duration-200"
          onClick={() => setShowStreamModal(false)}
        >
          <div
            className="bg-[#201b14] text-white max-w-lg w-full rounded-2xl shadow-2xl border border-[#dbc1b5]/30 overflow-hidden"
            onClick={(e) => e.stopPropagation()}
          >
            <div className="relative h-64 bg-black">
              <img
                src={ASSETS.savitaWheel}
                alt="Live artisan stream"
                className="w-full h-full object-cover"
              />
              <div className="absolute top-3 left-3 bg-red-600 px-2.5 py-1 rounded-full text-xs font-bold flex items-center gap-1.5 animate-pulse">
                <span className="w-2 h-2 rounded-full bg-white" />
                <span>LIVE • 14,218 Watching</span>
              </div>
              <button
                onClick={() => setShowStreamModal(false)}
                className="absolute top-3 right-3 w-8 h-8 rounded-full bg-black/60 flex items-center justify-center hover:bg-black"
              >
                <span className="material-symbols-outlined text-white">close</span>
              </button>
            </div>

            <div className="p-5 space-y-3 font-['Quicksand']">
              <h3 className="font-bold text-lg text-[#ffdbca]">
                Master Potter Savita Ben: Live Pitcher Throwing
              </h3>
              <p className="text-xs text-gray-300 font-['Vollkorn']">
                Demonstrating traditional 4th generation river clay shaping in Kutch, Gujarat.
              </p>

              <div className="h-28 overflow-y-auto space-y-1.5 bg-black/40 p-3 rounded-xl text-xs">
                <div><span className="text-[#ffb68e] font-bold">Claire (Paris):</span> Fascinating technique! What is the kiln temperature?</div>
                <div><span className="text-[#ffb68e] font-bold">Aarav (Bangalore):</span> The organic terracotta texture looks incredible.</div>
                <div><span className="text-[#ffb68e] font-bold">Siddharth (London):</span> Placed an inquiry for 20 vessels!</div>
              </div>

              <div className="flex gap-2 pt-2">
                <button
                  onClick={() => {
                    setShowStreamModal(false);
                    setScreen('pricing');
                  }}
                  className="flex-1 py-2.5 bg-[#b65c21] text-white rounded-xl text-xs font-bold hover:bg-[#964407]"
                >
                  View Product &amp; Pricing
                </button>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Chat / Instant Connect Modal */}
      {showChatModal && (
        <div
          className="fixed inset-0 z-50 bg-black/40 backdrop-blur-xs flex items-center justify-center p-4"
          onClick={() => setShowChatModal(null)}
        >
          <div
            className="bg-[#fff8f4] max-w-md w-full rounded-2xl shadow-2xl border border-[#dbc1b5] p-6 space-y-4 animate-in fade-in zoom-in-95 duration-150"
            onClick={(e) => e.stopPropagation()}
          >
            <div className="flex items-center justify-between border-b border-[#dbc1b5]/40 pb-3">
              <div>
                <span className="text-xs font-['IBM_Plex_Serif'] text-[#964407] font-bold uppercase tracking-wider">
                  Direct Artisan Messaging
                </span>
                <h3 className="font-['Quicksand'] font-bold text-lg text-[#201b14]">
                  Connecting with {showChatModal}
                </h3>
              </div>
              <button
                onClick={() => setShowChatModal(null)}
                className="w-8 h-8 rounded-full flex items-center justify-center text-[#554339] hover:bg-[#f8ece1]"
              >
                <span className="material-symbols-outlined">close</span>
              </button>
            </div>

            <div className="p-3 bg-[#fef1e7] rounded-xl text-xs font-['Vollkorn'] text-[#554339] space-y-1">
              <p>✨ Auto-translation enabled in Marathi, Hindi &amp; English.</p>
              <p>🔒 Protected by ShilpMitra zero-commission buyer-seller protocol.</p>
            </div>

            <div className="space-y-2">
              <textarea
                rows={3}
                placeholder="Hello, I am interested in ordering your handcrafted piece..."
                className="w-full p-3 bg-white border border-[#dbc1b5] rounded-xl text-xs sm:text-sm font-['Vollkorn'] focus:outline-none focus:ring-2 focus:ring-[#964407]"
              />
            </div>

            <button
              onClick={() => setShowChatModal(null)}
              className="w-full py-3 bg-[#964407] text-white font-['Quicksand'] font-bold text-sm rounded-xl hover:bg-[#b65c21] transition-all shadow-sm"
            >
              Send Message
            </button>
          </div>
        </div>
      )}
    </div>
  );
};
