import React, { useState } from 'react';
import { ASSETS } from '../../data/mockData';
import { AppScreen } from '../../types';

interface SmartPricingScreenProps {
  setScreen: (screen: AppScreen) => void;
}

type Currency = 'INR' | 'USD' | 'EUR';

export const SmartPricingScreen: React.FC<SmartPricingScreenProps> = ({ setScreen }) => {
  const [currency, setCurrency] = useState<Currency>('INR');
  const [margin, setMargin] = useState<number>(15);
  const [showSuccessModal, setShowSuccessModal] = useState<boolean>(false);

  const rates: Record<Currency, { symbol: string; rate: number; isPrefix: boolean }> = {
    INR: { symbol: '₹', rate: 1, isPrefix: true },
    USD: { symbol: '$', rate: 0.012, isPrefix: true },
    EUR: { symbol: '€', rate: 0.011, isPrefix: true },
  };

  const baseValues = {
    material: 1200,
    labor: 1850,
    heritage: 1800,
  };

  const multiplier = 1 + margin / 100;
  const currentMaterial = Math.round(baseValues.material * multiplier);
  const currentLabor = Math.round(baseValues.labor * multiplier);
  const currentHeritage = Math.round(baseValues.heritage * multiplier);
  const currentTotal = currentMaterial + currentLabor + currentHeritage;

  const formatMoney = (amount: number, curr: Currency = currency) => {
    const r = rates[curr];
    const converted = Math.round(amount * r.rate);
    if (curr === 'INR') {
      return `${r.symbol}${converted.toLocaleString('en-IN')}`;
    }
    return `${r.symbol}${converted.toLocaleString('en-US')}`;
  };

  return (
    <div className="max-w-4xl mx-auto px-4 sm:px-6 pt-5 pb-28 space-y-6 animate-in fade-in duration-200">
      {/* Hero Heading Section */}
      <section className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-6 bg-[#fef1e7] p-6 sm:p-8 rounded-2xl border border-[#dbc1b5]/60 shadow-[0_2px_16px_rgba(58,48,42,0.04)]">
        <div className="space-y-2">
          <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-[#ffdbca] text-[#773300] text-xs font-['IBM_Plex_Serif'] font-bold uppercase tracking-wider">
            <span className="material-symbols-outlined text-sm">auto_awesome</span>
            <span>AI Fair Pricing Engine</span>
          </div>
          <h1 className="text-2xl sm:text-4xl font-['Quicksand'] font-bold text-[#201b14] tracking-tight">
            Smart Pricing &amp; Earnings
          </h1>
          <p className="text-[#554339] max-w-xl text-sm sm:text-base font-['Vollkorn'] leading-relaxed">
            Optimized for maximum artisan livelihood with guaranteed zero platform commission, reflecting true heritage value.
          </p>
        </div>

        <div className="flex flex-col items-start sm:items-end bg-white p-4 sm:p-5 rounded-2xl border border-[#dbc1b5]/60 shadow-xs min-w-[200px] w-full sm:w-auto">
          <span className="text-xs font-['IBM_Plex_Serif'] text-[#554339] uppercase tracking-wider font-bold">
            Recommended Price
          </span>
          <div className="text-3xl font-['Quicksand'] font-bold text-[#964407] my-0.5">
            {formatMoney(currentTotal)}
          </div>
          <span className="text-xs text-[#554339] font-['IBM_Plex_Serif']">
            USD ${(currentTotal * rates.USD.rate).toFixed(2)} / EUR €{(currentTotal * rates.EUR.rate).toFixed(2)}
          </span>
        </div>
      </section>

      {/* Global Currency View bar */}
      <section className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 bg-[#f8ece1] p-4 rounded-2xl border border-[#dbc1b5]/50">
        <div className="flex items-center gap-2 text-sm font-['IBM_Plex_Serif'] text-[#554339] font-medium">
          <span className="material-symbols-outlined text-[#964407]">currency_exchange</span>
          <span>Global Currency View:</span>
        </div>
        <div className="flex gap-2">
          {(['INR', 'USD', 'EUR'] as Currency[]).map((c) => (
            <button
              key={c}
              onClick={() => setCurrency(c)}
              className={`px-4 py-1.5 rounded-xl text-xs sm:text-sm font-['Quicksand'] font-bold transition-all shadow-xs ${
                currency === c
                  ? 'bg-[#964407] text-white shadow-sm'
                  : 'bg-white hover:bg-[#ece0d6] text-[#201b14] border border-[#dbc1b5]'
              }`}
            >
              {c === 'INR' ? 'INR (₹)' : c === 'USD' ? 'USD ($)' : 'EUR (€)'}
            </button>
          ))}
        </div>
      </section>

      {/* Grid: Fair Price Breakdown & Margin Adjuster */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {/* Fair Price Breakdown */}
        <section className="bg-white p-6 sm:p-7 rounded-2xl border border-[#dbc1b5]/60 shadow-[0_2px_16px_rgba(58,48,42,0.04)] space-y-5">
          <div className="flex items-center justify-between border-b border-[#dbc1b5]/40 pb-3.5">
            <h2 className="text-lg font-['Quicksand'] font-bold text-[#201b14] flex items-center gap-2">
              <span className="material-symbols-outlined text-[#964407]">analytics</span>
              <span>Fair Price Breakdown</span>
            </h2>
            <span className="text-xs font-['IBM_Plex_Serif'] px-2.5 py-1 rounded-full bg-[#e9ded6] text-[#69615b] font-medium">
              Transparent AI Model
            </span>
          </div>

          <div className="space-y-3">
            {/* Item 1 */}
            <div className="flex items-center justify-between p-3 rounded-xl bg-[#fef1e7] border border-[#dbc1b5]/30">
              <div className="flex items-center gap-3">
                <div className="p-2 rounded-lg bg-[#ffdbca] text-[#773300]">
                  <span className="material-symbols-outlined text-xl">inventory_2</span>
                </div>
                <div>
                  <h4 className="font-['Quicksand'] font-bold text-sm text-[#201b14]">
                    Material Cost
                  </h4>
                  <p className="text-xs text-[#554339] font-['Vollkorn']">Raw sustainable clay &amp; natural glazes</p>
                </div>
              </div>
              <span className="font-['Quicksand'] font-bold text-sm text-[#201b14]">
                {formatMoney(currentMaterial)}
              </span>
            </div>

            {/* Item 2 */}
            <div className="flex items-center justify-between p-3 rounded-xl bg-[#fef1e7] border border-[#dbc1b5]/30">
              <div className="flex items-center gap-3">
                <div className="p-2 rounded-lg bg-[#ffdbca] text-[#773300]">
                  <span className="material-symbols-outlined text-xl">schedule</span>
                </div>
                <div>
                  <h4 className="font-['Quicksand'] font-bold text-sm text-[#201b14]">
                    Artisan Labor (8 Hours)
                  </h4>
                  <p className="text-xs text-[#554339] font-['Vollkorn']">Guaranteed fair living wage standard</p>
                </div>
              </div>
              <span className="font-['Quicksand'] font-bold text-sm text-[#201b14]">
                {formatMoney(currentLabor)}
              </span>
            </div>

            {/* Item 3 */}
            <div className="flex items-center justify-between p-3 rounded-xl bg-[#fef1e7] border border-[#dbc1b5]/30">
              <div className="flex items-center gap-3">
                <div className="p-2 rounded-lg bg-[#ffdbca] text-[#773300]">
                  <span className="material-symbols-outlined text-xl">verified</span>
                </div>
                <div>
                  <h4 className="font-['Quicksand'] font-bold text-sm text-[#201b14]">
                    Heritage Value Premium
                  </h4>
                  <p className="text-xs text-[#554339] font-['Vollkorn']">Generational GI-tagged craft technique</p>
                </div>
              </div>
              <span className="font-['Quicksand'] font-bold text-sm text-[#201b14]">
                {formatMoney(currentHeritage)}
              </span>
            </div>

            {/* Item 4 */}
            <div className="flex items-center justify-between p-3 rounded-xl bg-emerald-50 border border-emerald-200">
              <div className="flex items-center gap-3">
                <div className="p-2 rounded-lg bg-emerald-600 text-white">
                  <span className="material-symbols-outlined text-xl">card_giftcard</span>
                </div>
                <div>
                  <h4 className="font-['Quicksand'] font-bold text-sm text-emerald-900">
                    Platform Zero-Commission
                  </h4>
                  <p className="text-xs text-emerald-700 font-['Vollkorn']">100% earnings go directly to artisan</p>
                </div>
              </div>
              <span className="font-['Quicksand'] font-bold text-emerald-800">
                ₹0 Fee
              </span>
            </div>
          </div>

          <div className="pt-3 border-t border-[#dbc1b5]/40 flex items-center justify-between">
            <span className="font-['Quicksand'] font-bold text-[#201b14]">Total Fair Value</span>
            <span className="text-xl font-['Quicksand'] font-bold text-[#964407]">
              {formatMoney(currentTotal)}
            </span>
          </div>
        </section>

        {/* Profit Calculator Slider & Projections */}
        <section className="bg-white p-6 sm:p-7 rounded-2xl border border-[#dbc1b5]/60 shadow-[0_2px_16px_rgba(58,48,42,0.04)] space-y-6 flex flex-col justify-between">
          <div>
            <div className="flex items-center justify-between border-b border-[#dbc1b5]/40 pb-3.5 mb-5">
              <h2 className="text-lg font-['Quicksand'] font-bold text-[#201b14] flex items-center gap-2">
                <span className="material-symbols-outlined text-[#964407]">tune</span>
                <span>Profit &amp; Margin Adjuster</span>
              </h2>
              <span className="text-xs font-['IBM_Plex_Serif'] px-2.5 py-1 rounded-full bg-[#e9ded6] text-[#69615b] font-medium">
                Customizable
              </span>
            </div>

            <div className="space-y-6">
              <div>
                <div className="flex justify-between items-center mb-2">
                  <label className="text-sm font-['Quicksand'] font-bold text-[#201b14]" htmlFor="margin-slider">
                    Artisan Profit Margin
                  </label>
                  <span className="font-['Quicksand'] font-bold text-[#964407] bg-[#ffdbca] px-2.5 py-0.5 rounded text-sm">
                    {margin}%
                  </span>
                </div>
                <input
                  id="margin-slider"
                  type="range"
                  min="0"
                  max="40"
                  step="1"
                  value={margin}
                  onChange={(e) => setMargin(parseInt(e.target.value))}
                  className="w-full accent-[#964407] cursor-pointer bg-[#f8ece1] h-2.5 rounded-lg"
                />
                <div className="flex justify-between text-xs font-['IBM_Plex_Serif'] text-[#554339] mt-1.5">
                  <span>0% (At Cost)</span>
                  <span>20% (Recommended)</span>
                  <span>40% (Masterpiece)</span>
                </div>
              </div>

              {/* Monthly Earnings Simulator */}
              <div className="bg-[#f8ece1] p-4 rounded-xl space-y-2.5 border border-[#dbc1b5]/40">
                <h3 className="text-xs font-['IBM_Plex_Serif'] uppercase tracking-wider font-bold text-[#201b14]">
                  Estimated Monthly Earnings Simulator
                </h3>
                <div className="grid grid-cols-2 gap-3">
                  <div className="bg-white p-3 rounded-xl border border-[#dbc1b5]/40 shadow-xs">
                    <span className="text-xs text-[#554339] block font-['IBM_Plex_Serif']">15 Sales / Month</span>
                    <span className="text-base sm:text-lg font-['Quicksand'] font-bold text-[#964407]">
                      {formatMoney(currentTotal * 15)}
                    </span>
                  </div>
                  <div className="bg-white p-3 rounded-xl border border-[#dbc1b5]/40 shadow-xs">
                    <span className="text-xs text-[#554339] block font-['IBM_Plex_Serif']">30 Sales / Month</span>
                    <span className="text-base sm:text-lg font-['Quicksand'] font-bold text-[#964407]">
                      {formatMoney(currentTotal * 30)}
                    </span>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div className="pt-2">
            <div className="p-3 rounded-xl bg-[#fef1e7] flex items-start gap-2.5 border border-[#dbc1b5]/50">
              <span className="material-symbols-outlined text-[#964407] text-lg mt-0.5">info</span>
              <p className="text-xs text-[#554339] font-['Vollkorn'] leading-relaxed">
                Prices are calculated using regional economic data, material indices, and historical demand for GI-certified crafts from Rajasthan.
              </p>
            </div>
          </div>
        </section>
      </div>

      {/* Craft Preview Banner / Visual Context */}
      <section className="relative rounded-2xl overflow-hidden shadow-sm h-64 sm:h-72 flex items-end p-6 sm:p-8 border border-[#dbc1b5]/60">
        <img
          src={ASSETS.pricingBannerPot}
          alt="Terracotta Vase background"
          className="absolute inset-0 w-full h-full object-cover"
        />
        <div className="absolute inset-0 bg-gradient-to-t from-black/90 via-black/40 to-transparent" />
        <div className="relative z-10 text-white space-y-1.5">
          <span className="text-xs font-['IBM_Plex_Serif'] uppercase tracking-widest text-[#ffdbca] font-bold">
            Verified Masterpiece
          </span>
          <h3 className="text-2xl font-['Quicksand'] font-bold text-white">
            Blue Pottery &amp; Terracotta Handcrafted Vase
          </h3>
          <p className="text-xs sm:text-sm text-gray-200 font-['Vollkorn'] max-w-lg">
            Hand-thrown by Master Artisan Ramesh Kumar in Jaipur. GI Tag #492 verified authentic.
          </p>
        </div>
      </section>

      {/* Action CTA Section */}
      <section className="flex flex-col sm:flex-row items-center justify-between gap-4 bg-[#fef1e7] p-6 rounded-2xl border border-[#dbc1b5]/60">
        <div>
          <h4 className="font-['Quicksand'] font-bold text-[#201b14] text-lg">
            Ready to list your craft globally?
          </h4>
          <p className="text-xs sm:text-sm font-['Vollkorn'] text-[#554339]">
            Publish instantly to international art collectors with automated translation and secure escrow.
          </p>
        </div>
        <button
          onClick={() => setShowSuccessModal(true)}
          className="w-full sm:w-auto px-7 py-3.5 bg-[#964407] hover:bg-[#b65c21] text-white font-['Quicksand'] font-bold rounded-xl shadow-md transition-all active:scale-95 flex items-center justify-center gap-2 shrink-0"
        >
          <span className="material-symbols-outlined text-lg">publish</span>
          <span>Publish at Recommended Price</span>
        </button>
      </section>

      {/* Success Modal */}
      {showSuccessModal && (
        <div
          className="fixed inset-0 z-50 bg-black/50 backdrop-blur-xs flex items-center justify-center p-4 animate-in fade-in duration-200"
          onClick={() => setShowSuccessModal(false)}
        >
          <div
            className="bg-[#fff8f4] max-w-md w-full p-6 sm:p-8 rounded-2xl shadow-2xl border border-[#dbc1b5] text-center space-y-4"
            onClick={(e) => e.stopPropagation()}
          >
            <div className="w-16 h-16 bg-[#ffdbca] text-[#964407] rounded-full flex items-center justify-center mx-auto shadow-sm">
              <span className="material-symbols-outlined text-3xl">verified</span>
            </div>
            <h3 className="text-2xl font-['Quicksand'] font-bold text-[#201b14]">
              Successfully Published!
            </h3>
            <p className="text-sm font-['Vollkorn'] text-[#554339] leading-relaxed">
              Your craft is now live on ShilpMitra AI global marketplace at{' '}
              <strong className="text-[#964407]">{formatMoney(currentTotal)}</strong> with zero platform commission. Buyers from 42 countries can view your story.
            </p>
            <div className="pt-2 flex flex-col gap-2">
              <button
                onClick={() => {
                  setShowSuccessModal(false);
                  setScreen('digital-mela');
                }}
                className="w-full py-3.5 bg-[#964407] text-white font-['Quicksand'] font-bold rounded-xl hover:bg-[#b65c21] shadow-sm transition-all"
              >
                View in Digital Mela
              </button>
              <button
                onClick={() => setShowSuccessModal(false)}
                className="w-full py-2.5 bg-white border border-[#dbc1b5] text-[#554339] font-['Quicksand'] font-bold rounded-xl hover:bg-[#f8ece1] transition-all text-sm"
              >
                Done
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
