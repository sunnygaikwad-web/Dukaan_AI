import React, { useState } from 'react';
import { ASSETS, BUYER_LEADS, RECENT_PRODUCTS } from '../../data/mockData';
import { AppScreen } from '../../types';

interface HomeScreenProps {
  setScreen: (screen: AppScreen) => void;
}

export const HomeScreen: React.FC<HomeScreenProps> = ({ setScreen }) => {
  const [showBuyersModal, setShowBuyersModal] = useState(false);

  return (
    <div className="max-w-md mx-auto px-4 sm:px-6 pt-5 pb-28 space-y-6 animate-in fade-in duration-200">
      {/* Greeting Section */}
      <section className="space-y-1">
        <h2 className="text-2xl sm:text-3xl font-['Quicksand'] font-bold text-[#201b14] tracking-tight">
          Namaste, Savita 👋
        </h2>
        <p className="text-base font-['Vollkorn'] text-[#554339]">
          Let's grow your craft together.
        </p>
      </section>

      {/* Prominent Opportunity Banner */}
      <section className="bg-gradient-to-br from-[#b65c21] to-[#964407] rounded-2xl p-5 sm:p-6 text-white shadow-md relative overflow-hidden flex flex-col justify-between">
        <div className="absolute -right-6 -bottom-6 w-36 h-36 bg-white/10 rounded-full blur-xl pointer-events-none" />
        <div className="space-y-2 mb-4 relative z-10">
          <div className="inline-flex items-center space-x-1.5 bg-white/20 px-3 py-1 rounded-full text-xs font-['IBM_Plex_Serif'] font-semibold text-white backdrop-blur-xs">
            <span className="material-symbols-outlined text-sm" style={{ fontVariationSettings: "'FILL' 1" }}>
              trending_up
            </span>
            <span>High Demand</span>
          </div>
          <p className="text-xl font-['Quicksand'] font-bold text-white leading-snug">
            3 buyers are looking for products like yours
          </p>
        </div>
        <div className="relative z-10">
          <button
            onClick={() => setShowBuyersModal(true)}
            className="bg-[#fff8f4] text-[#964407] font-['IBM_Plex_Serif'] px-4 py-2.5 rounded-xl font-bold shadow hover:bg-white transition-all active:scale-95 flex items-center justify-center space-x-2 w-full sm:w-auto"
          >
            <span>View Buyers</span>
            <span className="material-symbols-outlined text-base">arrow_forward</span>
          </button>
        </div>
      </section>

      {/* Large Central Primary Action Card (+ Add New Product) */}
      <section
        onClick={() => setScreen('add-photo')}
        className="bg-[#fef1e7] rounded-2xl p-6 border border-[#dbc1b5]/70 shadow-sm text-center relative hover:shadow-md hover:border-[#b65c21] transition-all group cursor-pointer active:scale-98"
      >
        <div className="w-16 h-16 bg-[#b65c21] text-white rounded-2xl mx-auto flex items-center justify-center mb-3.5 shadow-md group-hover:scale-105 transition-transform duration-200">
          <div className="relative flex items-center justify-center">
            <span className="material-symbols-outlined text-3xl">photo_camera</span>
            <span
              className="material-symbols-outlined text-sm absolute -top-1 -right-2 text-[#ffdbca]"
              style={{ fontVariationSettings: "'FILL' 1" }}
            >
              auto_awesome
            </span>
          </div>
        </div>
        <h3 className="text-xl font-['Quicksand'] font-bold text-[#201b14] mb-1">
          + Add New Product
        </h3>
        <p className="text-sm font-['Vollkorn'] text-[#554339] max-w-xs mx-auto">
          Take a photo and let AI do the rest.
        </p>
      </section>

      {/* Quick Actions Grid */}
      <section>
        <h4 className="text-xs font-['IBM_Plex_Serif'] uppercase tracking-wider text-[#554339] font-bold mb-3">
          Quick Actions
        </h4>
        <div className="grid grid-cols-2 gap-3">
          {/* My Products */}
          <button
            onClick={() => setScreen('ai-catalog')}
            className="bg-[#fef1e7] p-4 rounded-xl border border-[#dbc1b5]/50 flex flex-col items-start hover:bg-[#f8ece1] hover:border-[#b65c21]/60 transition-all active:scale-95 text-left"
          >
            <div className="w-10 h-10 rounded-lg bg-[#e9ded6] text-[#645d57] flex items-center justify-center mb-3">
              <span className="material-symbols-outlined text-xl" style={{ fontVariationSettings: "'FILL' 1" }}>
                inventory_2
              </span>
            </div>
            <span className="text-sm font-['Quicksand'] font-bold text-[#201b14]">My Products</span>
            <span className="text-xs font-['IBM_Plex_Serif'] text-[#554339]">12 Active</span>
          </button>

          {/* Find Buyers */}
          <button
            onClick={() => setShowBuyersModal(true)}
            className="bg-[#fef1e7] p-4 rounded-xl border border-[#dbc1b5]/50 flex flex-col items-start hover:bg-[#f8ece1] hover:border-[#b65c21]/60 transition-all active:scale-95 text-left"
          >
            <div className="w-10 h-10 rounded-lg bg-[#ffdad8] text-[#944242] flex items-center justify-center mb-3">
              <span className="material-symbols-outlined text-xl" style={{ fontVariationSettings: "'FILL' 1" }}>
                storefront
              </span>
            </div>
            <span className="text-sm font-['Quicksand'] font-bold text-[#201b14]">Find Buyers</span>
            <span className="text-xs font-['IBM_Plex_Serif'] text-[#554339]">3 New Leads</span>
          </button>

          {/* My Earnings */}
          <button
            onClick={() => setScreen('pricing')}
            className="bg-[#fef1e7] p-4 rounded-xl border border-[#dbc1b5]/50 flex flex-col items-start hover:bg-[#f8ece1] hover:border-[#b65c21]/60 transition-all active:scale-95 text-left"
          >
            <div className="w-10 h-10 rounded-lg bg-[#ffdbca] text-[#773300] flex items-center justify-center mb-3">
              <span className="material-symbols-outlined text-xl" style={{ fontVariationSettings: "'FILL' 1" }}>
                payments
              </span>
            </div>
            <span className="text-sm font-['Quicksand'] font-bold text-[#201b14]">My Earnings</span>
            <span className="text-xs font-['IBM_Plex_Serif'] text-[#554339]">₹34,500 this mo</span>
          </button>

          {/* Digital Mela */}
          <button
            onClick={() => setScreen('digital-mela')}
            className="bg-[#fef1e7] p-4 rounded-xl border border-[#dbc1b5]/50 flex flex-col items-start hover:bg-[#f8ece1] hover:border-[#b65c21]/60 transition-all active:scale-95 text-left"
          >
            <div className="w-10 h-10 rounded-lg bg-[#e9ded6] text-[#964407] flex items-center justify-center mb-3">
              <span className="material-symbols-outlined text-xl" style={{ fontVariationSettings: "'FILL' 1" }}>
                festival
              </span>
            </div>
            <span className="text-sm font-['Quicksand'] font-bold text-[#201b14]">Digital Mela</span>
            <span className="text-xs font-['IBM_Plex_Serif'] text-[#554339]">Live Now</span>
          </button>
        </div>
      </section>

      {/* AI Tip Card */}
      <section className="bg-[#fef1e7] rounded-xl p-4 border-l-4 border-[#964407] shadow-xs relative space-y-1.5">
        <div className="flex items-center space-x-2 text-[#964407]">
          <span className="material-symbols-outlined text-sm" style={{ fontVariationSettings: "'FILL' 1" }}>
            auto_awesome
          </span>
          <span className="text-sm font-['Quicksand'] font-bold">AI Tip for Your Craft ✨</span>
        </div>
        <p className="text-sm font-['Vollkorn'] text-[#554339] leading-relaxed">
          Your handloom products are receiving more interest this week. High seasonal demand in Western Europe.
        </p>
      </section>

      {/* Recent Products List */}
      <section className="space-y-3 pb-4">
        <div className="flex justify-between items-center">
          <h4 className="text-lg font-['Quicksand'] font-bold text-[#201b14]">
            Recent Products
          </h4>
          <button
            onClick={() => setScreen('ai-catalog')}
            className="text-xs font-['IBM_Plex_Serif'] text-[#964407] font-semibold hover:underline"
          >
            View All
          </button>
        </div>
        <div className="space-y-3">
          {/* Product Item 1 */}
          <div
            onClick={() => setScreen('ai-catalog')}
            className="bg-[#fef1e7] p-3 rounded-xl border border-[#dbc1b5]/40 flex items-center space-x-3 shadow-xs hover:shadow-sm hover:border-[#b65c21] cursor-pointer transition-all"
          >
            <div className="w-16 h-16 rounded-lg bg-[#f8ece1] overflow-hidden shrink-0 border border-[#dbc1b5]/30">
              <img
                className="w-full h-full object-cover"
                src={RECENT_PRODUCTS[0].imageUrl}
                alt={RECENT_PRODUCTS[0].title}
              />
            </div>
            <div className="grow min-w-0">
              <h5 className="text-sm font-['Quicksand'] font-bold text-[#201b14] truncate">
                {RECENT_PRODUCTS[0].title}
              </h5>
              <p className="text-sm font-['IBM_Plex_Serif'] text-[#554339] font-medium">₹8,499</p>
            </div>
            <div>
              <span className="bg-[#e9ded6] text-[#201b14] text-xs px-2.5 py-1 rounded-full font-['IBM_Plex_Serif'] font-medium">
                Published
              </span>
            </div>
          </div>

          {/* Product Item 2 */}
          <div
            onClick={() => setScreen('multilingual')}
            className="bg-[#fef1e7] p-3 rounded-xl border border-[#dbc1b5]/40 flex items-center space-x-3 shadow-xs hover:shadow-sm hover:border-[#b65c21] cursor-pointer transition-all"
          >
            <div className="w-16 h-16 rounded-lg bg-[#f8ece1] overflow-hidden shrink-0 border border-[#dbc1b5]/30">
              <img
                className="w-full h-full object-cover"
                src={RECENT_PRODUCTS[1].imageUrl}
                alt={RECENT_PRODUCTS[1].title}
              />
            </div>
            <div className="grow min-w-0">
              <h5 className="text-sm font-['Quicksand'] font-bold text-[#201b14] truncate">
                {RECENT_PRODUCTS[1].title}
              </h5>
              <p className="text-sm font-['IBM_Plex_Serif'] text-[#554339] font-medium">₹2,400</p>
            </div>
            <div>
              <span className="bg-[#ffdad8] text-[#944242] text-xs px-2.5 py-1 rounded-full font-['IBM_Plex_Serif'] font-medium">
                Buyer Interested
              </span>
            </div>
          </div>
        </div>
      </section>

      {/* Buyer Leads Modal */}
      {showBuyersModal && (
        <div
          className="fixed inset-0 z-50 bg-black/40 backdrop-blur-xs flex items-center justify-center p-4"
          onClick={() => setShowBuyersModal(false)}
        >
          <div
            className="bg-[#fff8f4] max-w-lg w-full rounded-2xl shadow-2xl border border-[#dbc1b5] p-6 space-y-4 max-h-[90vh] overflow-y-auto animate-in fade-in zoom-in-95 duration-150"
            onClick={(e) => e.stopPropagation()}
          >
            <div className="flex items-center justify-between border-b border-[#dbc1b5]/50 pb-3">
              <div>
                <span className="text-xs font-['IBM_Plex_Serif'] uppercase tracking-wider text-[#964407] font-bold">
                  Verified Buyer Demand
                </span>
                <h3 className="font-['Quicksand'] font-bold text-xl text-[#201b14]">
                  3 Active Buyer Inquiries
                </h3>
              </div>
              <button
                onClick={() => setShowBuyersModal(false)}
                className="w-8 h-8 rounded-full flex items-center justify-center text-[#554339] hover:bg-[#f8ece1]"
              >
                <span className="material-symbols-outlined">close</span>
              </button>
            </div>

            <div className="space-y-3">
              {BUYER_LEADS.map((lead) => (
                <div key={lead.id} className="p-4 rounded-xl bg-[#fef1e7] border border-[#dbc1b5]/60 space-y-2">
                  <div className="flex items-center justify-between">
                    <div className="flex items-center space-x-3">
                      <img src={lead.avatar} alt={lead.buyerName} className="w-10 h-10 rounded-full object-cover" />
                      <div>
                        <h4 className="text-sm font-['Quicksand'] font-bold text-[#201b14]">{lead.buyerName}</h4>
                        <span className="text-xs font-['IBM_Plex_Serif'] text-[#554339]">{lead.location}</span>
                      </div>
                    </div>
                    <span className="text-xs font-['IBM_Plex_Serif'] px-2 py-0.5 rounded-full bg-[#ffdad8] text-[#944242] font-semibold">
                      {lead.urgency} Interest
                    </span>
                  </div>
                  <div className="text-xs font-['Vollkorn'] text-[#554339] bg-white/70 p-2.5 rounded-lg border border-[#dbc1b5]/30">
                    <span className="font-bold text-[#201b14]">Looking for:</span> {lead.requestedCraft}
                    <div className="mt-1 font-semibold text-[#964407]">Budget: {lead.budget}</div>
                    <p className="mt-1 italic text-[#645d57]">"{lead.note}"</p>
                  </div>
                  <div className="flex justify-end gap-2 pt-1">
                    <button
                      onClick={() => {
                        setShowBuyersModal(false);
                        setScreen('multilingual');
                      }}
                      className="px-3 py-1.5 rounded-lg text-xs font-['Quicksand'] font-bold bg-[#964407] text-white hover:bg-[#b65c21] transition-all"
                    >
                      Share Catalog
                    </button>
                  </div>
                </div>
              ))}
            </div>

            <button
              onClick={() => {
                setShowBuyersModal(false);
                setScreen('digital-mela');
              }}
              className="w-full py-3 bg-[#e9ded6] text-[#201b14] font-['Quicksand'] font-bold text-sm rounded-xl hover:bg-[#dbc1b5]/60 transition-all"
            >
              Go to Digital Mela Showcase
            </button>
          </div>
        </div>
      )}
    </div>
  );
};
