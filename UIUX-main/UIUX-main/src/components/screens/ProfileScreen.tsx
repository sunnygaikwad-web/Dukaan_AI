import React from 'react';
import { ASSETS } from '../../data/mockData';
import { AppScreen } from '../../types';

interface ProfileScreenProps {
  setScreen: (screen: AppScreen) => void;
}

export const ProfileScreen: React.FC<ProfileScreenProps> = ({ setScreen }) => {
  return (
    <div className="max-w-md mx-auto px-4 sm:px-6 pt-5 pb-28 space-y-6 animate-in fade-in duration-200">
      {/* Profile Card */}
      <section className="bg-[#fef1e7] rounded-2xl p-6 border border-[#dbc1b5]/60 shadow-xs text-center space-y-3 relative overflow-hidden">
        <div className="w-24 h-24 rounded-full overflow-hidden border-4 border-[#b65c21] mx-auto shadow-md">
          <img
            src={ASSETS.artisanAvatar}
            alt="Savita Patil"
            className="w-full h-full object-cover"
          />
        </div>
        <div>
          <div className="flex items-center justify-center gap-1 text-[#964407]">
            <span className="material-symbols-outlined text-base" style={{ fontVariationSettings: "'FILL' 1" }}>
              verified
            </span>
            <span className="text-xs font-['IBM_Plex_Serif'] font-bold uppercase tracking-wider">
              GI Certified Master Artisan
            </span>
          </div>
          <h2 className="text-2xl font-['Quicksand'] font-bold text-[#201b14]">
            Savita Patil
          </h2>
          <p className="text-sm font-['Vollkorn'] text-[#554339]">
            Paithani Handloom Weaver &amp; Terracotta Potter • 28 Years Experience
          </p>
        </div>

        <div className="grid grid-cols-3 gap-2 pt-2 border-t border-[#dbc1b5]/40 text-center">
          <div className="bg-white p-2 rounded-xl border border-[#dbc1b5]/30">
            <span className="text-lg font-['Quicksand'] font-bold text-[#964407] block">12</span>
            <span className="text-[11px] font-['IBM_Plex_Serif'] text-[#554339]">Active Crafts</span>
          </div>
          <div className="bg-white p-2 rounded-xl border border-[#dbc1b5]/30">
            <span className="text-lg font-['Quicksand'] font-bold text-[#964407] block">₹34.5K</span>
            <span className="text-[11px] font-['IBM_Plex_Serif'] text-[#554339]">This Month</span>
          </div>
          <div className="bg-white p-2 rounded-xl border border-[#dbc1b5]/30">
            <span className="text-lg font-['Quicksand'] font-bold text-[#964407] block">42</span>
            <span className="text-[11px] font-['IBM_Plex_Serif'] text-[#554339]">Global Orders</span>
          </div>
        </div>
      </section>

      {/* Cultural Heritage & Certifications */}
      <section className="bg-[#f8ece1] rounded-2xl p-5 border border-[#dbc1b5]/50 space-y-3">
        <h3 className="text-xs font-['IBM_Plex_Serif'] uppercase tracking-wider font-bold text-[#964407]">
          Verified GI Heritage Tags
        </h3>
        <div className="space-y-2 text-xs font-['Quicksand']">
          <div className="p-3 bg-white rounded-xl border border-[#dbc1b5]/40 flex items-center justify-between">
            <div className="flex items-center gap-2.5">
              <span className="material-symbols-outlined text-[#964407]">workspace_premium</span>
              <div>
                <strong className="block text-[#201b14]">Yeola Paithani Silk Weaving</strong>
                <span className="text-[#554339] text-[11px]">GI Tag Certificate #GI-MH-244</span>
              </div>
            </div>
            <span className="bg-emerald-100 text-emerald-800 text-[10px] px-2 py-0.5 rounded-full font-bold">
              Active
            </span>
          </div>

          <div className="p-3 bg-white rounded-xl border border-[#dbc1b5]/40 flex items-center justify-between">
            <div className="flex items-center gap-2.5">
              <span className="material-symbols-outlined text-[#964407]">workspace_premium</span>
              <div>
                <strong className="block text-[#201b14]">Kutch Terracotta Potter's Guild</strong>
                <span className="text-[#554339] text-[11px]">Rural Handicrafts Council #492</span>
              </div>
            </div>
            <span className="bg-emerald-100 text-emerald-800 text-[10px] px-2 py-0.5 rounded-full font-bold">
              Active
            </span>
          </div>
        </div>
      </section>

      {/* Direct Banking & Payouts */}
      <section className="bg-white rounded-2xl p-5 border border-[#dbc1b5]/60 shadow-xs space-y-3">
        <div className="flex items-center justify-between">
          <h3 className="text-xs font-['IBM_Plex_Serif'] uppercase tracking-wider font-bold text-[#201b14]">
            Direct Artisan Payout (0% Commission)
          </h3>
          <span className="text-xs text-emerald-700 font-bold bg-emerald-50 px-2 py-0.5 rounded-full">
            Direct Bank Transfer
          </span>
        </div>
        <div className="p-3 bg-[#fef1e7] rounded-xl border border-[#dbc1b5]/40 flex items-center justify-between text-xs">
          <div>
            <span className="font-bold text-[#201b14] block">Bank of Maharashtra</span>
            <span className="text-[#554339]">A/C: *******8492 • IFSC: MAHB0000123</span>
          </div>
          <button
            onClick={() => setScreen('pricing')}
            className="text-xs font-bold text-[#964407] hover:underline"
          >
            View Earnings
          </button>
        </div>
      </section>

      {/* Quick Navigation to Screens */}
      <section className="space-y-2">
        <h4 className="text-xs font-['IBM_Plex_Serif'] uppercase tracking-wider font-bold text-[#554339]">
          App Sections
        </h4>
        <div className="grid grid-cols-2 gap-2">
          <button
            onClick={() => setScreen('multilingual')}
            className="p-3 bg-[#f8ece1] rounded-xl text-left border border-[#dbc1b5]/50 hover:bg-[#f2e6dc] transition-all"
          >
            <span className="text-xs font-['Quicksand'] font-bold text-[#201b14] block">Multilingual Catalog</span>
            <span className="text-[11px] text-[#554339]">En / Hi / Mr</span>
          </button>
          <button
            onClick={() => setScreen('heritage')}
            className="p-3 bg-[#f8ece1] rounded-xl text-left border border-[#dbc1b5]/50 hover:bg-[#f2e6dc] transition-all"
          >
            <span className="text-xs font-['Quicksand'] font-bold text-[#201b14] block">Heritage Story</span>
            <span className="text-[11px] text-[#554339]">Audio in Marathi</span>
          </button>
          <button
            onClick={() => setScreen('pricing')}
            className="p-3 bg-[#f8ece1] rounded-xl text-left border border-[#dbc1b5]/50 hover:bg-[#f2e6dc] transition-all"
          >
            <span className="text-xs font-['Quicksand'] font-bold text-[#201b14] block">Smart Pricing Engine</span>
            <span className="text-[11px] text-[#554339]">Fair Wage Model</span>
          </button>
          <button
            onClick={() => setScreen('digital-mela')}
            className="p-3 bg-[#f8ece1] rounded-xl text-left border border-[#dbc1b5]/50 hover:bg-[#f2e6dc] transition-all"
          >
            <span className="text-xs font-['Quicksand'] font-bold text-[#201b14] block">Digital Mela 2.0</span>
            <span className="text-[11px] text-[#554339]">Live Showcase</span>
          </button>
        </div>
      </section>
    </div>
  );
};
