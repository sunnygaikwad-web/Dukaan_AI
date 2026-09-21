import { CraftProduct, BuyerLead } from '../types';

export const ASSETS = {
  artisanAvatar:
    'https://lh3.googleusercontent.com/aida-public/AB6AXuCd5RInpZTzNnI-2-UItYNsKWfBEG0yDguwMn_HyOFJiJuTPqBJFisAc0OoSzt4W5hQRyoeeehPUOMR_KK1zva9d_qAGx9FDSwtptsyygt8UgoRyMq3UBaBROUR3ijl7N8-v7XBZGYRY60s2tlBTYa4RDbyaiKxMAKKl49EyuG6-CdNVsIzm8JKW7tricoMbJto1qXnPgAVzcnPq8JZBYCnI2YW1tgpVMdJa9f1F-_SZnAl4WSBAEFY',
  artisanAvatarAlt:
    'https://lh3.googleusercontent.com/aida-public/AB6AXuBzBggyR_r_NCqMgi-nNvg75x-gqSFeTNcboTn3z8XiGkKvYf4H3mgLbMZzC023_V4oMYCzInuXpmQIdpBuUNHR_aKYvPbGQVHV75tvEXcnBfPYZxSrxeDRK53H8kByn9MPggsvIj3qisywOjTkeuLr7QJINL46G64pAuqSz68oPe38dKx8M0rJTUciroWHPPEcCM8F5Tu-w2re6Y6Yb08pynRrjFoxHve1auMV3Sbyo_VaRBZ2EM2_',
  paithaniFolded:
    'https://lh3.googleusercontent.com/aida-public/AB6AXuAnDuFgIBlKcOjRZwOQdmK1cfSVLdt6ymA5HFotZ4pkSDTHaTmtxetz1nGDUJCv35roeMeYSIWu177dXKIfw1My6ao3FaI_-9PGhYxlx_dtNDDHhdSHXu2xF50YZ72EX7l5VG-6SaA5snSt1uJ3EofRgC2xEWVUvEGZiSISWhIGuluGaeXWzxWkQVrqykLu9rwtt3nZYCmNTKHQxIaXrB1eU9fin4CrCeXW74v4GPjcnLuE16OGmD4t',
  bluePotteryVase:
    'https://lh3.googleusercontent.com/aida-public/AB6AXuCSP3WRfGpMGic1R4-JkDBjEgXwBnVcaQHgzByWTFkhrAKH-st0d_cEawSMmWCsjLxw5PrIsuMrq1MObNgcqr9wp1lVkHXt-Tb_07DjN_k_V5JDMOruGbtv6t_TWbtjVdPT2FArcLj7Pjil3KiLkL6Yox7awuQFAgfb6k4x25P0bJ2dQnRDN_HYtJFakkufU9lGJlbBojc6c01hX7159i0fgh5CnilKuCJlS8gIjcQdKaOLeztg9Wve',
  paithaniMannequin:
    'https://lh3.googleusercontent.com/aida-public/AB6AXuCXmRGvxAmCzp6WXrsxv9FMpDy_bxJxb4IYmzSCdz4leYKu_GSnnGcwRSlbcZOSBafjhYJtrEBb_c4NCGf0qgq66UWyfwAV85W-LA1PXJ2Goynojcjtl61JRLy8Dv898l3LOrfZ19jQzn5RoiYVAovzUuSLyUcOfcBmEJ21gbl3lZTlgx4D6heMOJqoFXssYHwNH4H2deqRXuDYVz5lpqhKXZ2ZRZ8h-NFd80PV-98VyeALc-k8KqN-',
  terracottaVase:
    'https://lh3.googleusercontent.com/aida-public/AB6AXuASymT9DUAu_3SZ1K2V5O3FV4TrzAMxGrOKmKobWmvPSAVhmwMiDTfEQw9spxf_6u0s-3YWFy8O6iapIuO8ZpZ2v-qlSncv4NBodDfeP1fQgu553GLyUwBC6LDdWvI4NiQUNr_Qzxfhc7vK3UzURU2lRa45TR50QYuvHsiBVxhcWCxplvxrZCg7LAzidBZCBHDTR2ahmQ6DLDLgNvrybli0gNtxYPLAe1dOusEQrCGiQadB78pQuKc-',
  savitaWheel:
    'https://lh3.googleusercontent.com/aida-public/AB6AXuAON7i8Bier1VVMQE1MKpF5pVjE2MU0bLwo8HpUgCjscPi61THXW2VX2MzBJZCH9A9s1RPeHuBIylBbIV9B-KXieSnXf9qiv0OrlehBtT4GVjmqa36m3gxPT-yljjNnmyYr42kSAXbTZr0ctE3g82b2htcFAvFEw-XIxV_HN3tIfVENG1zfAMGxBUfvsS9hLvtJEBwcRc2yjWP5PyqG4zCNhb9nZMwUbvVPR6Pmd__g2lDEU8q80VoX',
  pricingBannerPot:
    'https://lh3.googleusercontent.com/aida-public/AB6AXuBKINafNBUduAjDRq3w4vPX9mG4YFdYTh8xnKA7u48gdc7U81UCK2Wpt4Zc7rKieevI_XK5w_LIDoDfkXW1frL9wnsmnjPqb8G_TA3Py_o0pg4Qesb42BxVHDqYMADv11sarrjweHiJtS3nQfZCE1enGz4Ocxl3wNi6o75JxwLpDBCIUWhdcMg_ndabwHdwNkyZt5XI2tWe6S315AUYnS-RB7RuDy0VglNtgCX57cVbAgPQELwwb6BO',
  melaHeaderBg:
    'https://lh3.googleusercontent.com/aida-public/AB6AXuBxXyJCNMJK9zO5OQbjwLqiaIkWNHqLwpw-E5if9AllX3t9orLTv3ldvqp9WVzv7OxXsSA4-f15t9dGue7qsTLQFMEmr6Xawr6qLJ92fBjmo14kTOKHJUnrRZQx3wbc_fjk71d5qIa3OZQiDKxs73573xBSzzirv0zkBts0pI6DZ6YPDbDHXuqCrfCq7Sd1GOUlUDXVX4alWv-ICIisU_kpRLCeiKZjXBHn_KkYV8b-nUHsAXjAs9P5',
  dhokraHorse:
    'https://lh3.googleusercontent.com/aida-public/AB6AXuCAaMjlGdvx1S7JCjaY8NjrpoFf8qnOGQ66eVPQBcHLzJD1ZIJ8ziz_xF2Ncn4CnQecJGXxPetBjSIesYoUVtwZLPskiyG9e8meYB3slcZUDEcxIpgh_5z585tx5vT2jxKaCPxI_2L-SDHn4RGB2PNmf_yHdhn1fzvGpn6HENnzBt-4O53LEyGLCdjnWZYSSGFCKokvHt_gj-wfO1pUfQxu79TqKACMorNB5fTGAEYuh-eIrGM-Yr71',
  terracottaPitcher:
    'https://lh3.googleusercontent.com/aida-public/AB6AXuAlZWMRcpuHDyXyNLEn1ZNgtg_dbKg4UaTmm1bZj6Qaf5s4wMvHV9-125RyEkGriFoVA9FdihsNndi3oqGNAY5HJepbkNYgwM_OYMLg6j4kKaUId86cbzVTl7baxrK-t-sgP3vb3oDGLckXRWlm6aBs0ayBPK1XMdzdc9ZFsw0WPc3v9RsWtRAPeoKWu9SXTu4-SO7gtNwpqZjx5kXDKzL4h5eZ4MM5KsZD1wo3fioyi-5LZoHWc_4L',
  handloomSaree:
    'https://lh3.googleusercontent.com/aida-public/AB6AXuBlU75_mnuKOSw89xgjs9BnVSkcF2KHUH5lFTlHWygZzzPJ_hemqI_tD3zurPxWBLwbwYEbVAkDOAPCBrcJkvqauARnMwwv-JZOqkd2kIfqixf8r7oQcQIExADJ3y8aw-RZRDX_yEbKnau-pS1LIPT8uRmzDvBYPbC1fF27hdMVZ66IVY9tpntf6mWuzXWbXS97gu7bSuOTZQ0R-EV4y4p03IqNG5Oz72QLgamKkYR09ZV5n_PUdHTT',
  artisanWorkshopPortrait:
    'https://lh3.googleusercontent.com/aida-public/AB6AXuAjhaie8C2euGf99TKdzMVtIdoBCw4m98ew9zo9WMDbGX5qyUvO5ZnhlkJbV2ArwrfofpEUtMwvbJn_NfuD5BMC2b3nk5poIXgo0B5zwfmxFke-Uwq69KyrdJBnyJ0xhw9g1JoUwyViWLsC8pEQkZVwww65dWuxyiwDxqETbKyme-mofxJEe8yF37GwerX5ustVCIeJMo7nY0EfbYMaYh4T2Mz3xilCaVn63wg52t1VhNmoxsrP71w9',
};

export const BUYER_LEADS: BuyerLead[] = [
  {
    id: 'lead-1',
    buyerName: 'Maison Étoile Gallery',
    location: 'Paris, France',
    requestedCraft: 'Handwoven Paithani Silk Sarees & Dupattas',
    budget: '€4,200 (Bulk Order 10 pcs)',
    urgency: 'High',
    avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=150&q=80',
    note: 'Curating authentic Indian festive textiles for an autumn Parisian exhibition.'
  },
  {
    id: 'lead-2',
    buyerName: 'Ananya Boutique',
    location: 'Mumbai, India',
    requestedCraft: 'Terracotta Hand-Painted Planters & Vessels',
    budget: '₹45,000 (Set of 18)',
    urgency: 'High',
    avatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=150&q=80',
    note: 'Looking for verified master craftswomen for exclusive Diwali festive release.'
  },
  {
    id: 'lead-3',
    buyerName: 'Aura Lifestyle Studio',
    location: 'London, UK',
    requestedCraft: 'Natural Clay Tableware & Urns',
    budget: '£1,850',
    urgency: 'Medium',
    avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=150&q=80',
    note: 'Eco-conscious design house seeking direct relationship with rural potters.'
  }
];

export const RECENT_PRODUCTS: CraftProduct[] = [
  {
    id: 'prod-1',
    title: 'Handwoven Paithani Silk Saree',
    category: 'Textiles | Pure Silk',
    material: 'Mulberry Silk & Real Gold Zari',
    craft: 'Paithani Weaving',
    origin: 'Maharashtra, India',
    price: 8499,
    imageUrl: ASSETS.paithaniFolded,
    status: 'Published',
    description: {
      en: 'Exquisite handwoven Paithani silk saree crafted by master artisans in Maharashtra. Features traditional peacock motifs in rich zari work and vibrant silk threads, perfect for festive occasions and weddings.',
      hi: 'महाराष्ट्र के कुशल बुनकरों द्वारा तैयार की गई प्रामाणिक पैठणी रेशमी साड़ी। इसमें जटिल मोर और कमल के पारंपरिक जरी रूपांकन शामिल हैं।',
      mr: 'महाराष्ट्रातील निष्णात विणकरांनी विणलेली शुद्ध पैठणी रेशमी साडी. पारंपरिक मोराची नक्षी आणि अस्सल सोन्याची जरी काम.'
    },
    keywords: {
      en: ['Paithani', 'Handwoven', 'Pure Silk', 'Bridal Heritage'],
      hi: ['पैठणी', 'हथकरघा', 'शुद्ध रेशम', 'विवाह परिधान'],
      mr: ['पैठणी', 'हातमाग', 'रेशीम साडी', 'पारंपरिक कला']
    },
    attributes: {
      en: { category: 'Traditional Wear', material: 'Pure Silk', craft: 'Handloom', origin: 'Yeola, Maharashtra' },
      hi: { category: 'पारंपरिक वस्त्र', material: 'शुद्ध रेशम', craft: 'हथकरघा', origin: 'येवला, महाराष्ट्र' },
      mr: { category: 'पारंपारिक पोषाख', material: 'शुद्ध रेशीम', craft: 'हातमाग विणकाम', origin: 'येवला, महाराष्ट्र' }
    }
  },
  {
    id: 'prod-2',
    title: 'Blue Pottery Vase',
    category: 'Home Decor & Pottery',
    material: 'Quartz, Raw Clay & Cobalt Glaze',
    craft: 'Jaipur Blue Pottery',
    origin: 'Jaipur, Rajasthan',
    price: 2400,
    imageUrl: ASSETS.bluePotteryVase,
    status: 'Buyer Interested',
    description: {
      en: 'A handcrafted ceramic blue pottery vase adorned with intricate floral Persian motifs in cobalt blue and turquoise on a smooth white clay base, illuminated by gentle diffused studio lighting.',
      hi: 'हाथ से बना नीली मिट्टी का फूलदान जिस पर फ़ारसी पुष्प रूपांकन सुसज्जित हैं।',
      mr: 'पारंपारिक जयपुरी ब्लू पॉटरी फुलदाणी, हाताने रेखाटलेली सुरेख कलाकुसर.'
    },
    keywords: {
      en: ['Blue Pottery', 'Ceramic', 'Floral Art', 'GI Tagged'],
      hi: ['ब्लू पॉटरी', 'सिरेमिक', 'पुष्प कला', 'जीआई टैग'],
      mr: ['ब्लू पॉटरी', 'मातीकाम', 'नक्षीकाम', 'जीआय मानांकित']
    },
    attributes: {
      en: { category: 'Ceramics', material: 'Blue Glaze Clay', craft: 'Glazed Pottery', origin: 'Jaipur, Rajasthan' },
      hi: { category: 'सिरेमिक्स', material: 'नीली मिट्टी', craft: 'ग्लेज़्ड पॉटरी', origin: 'जयपुर, राजस्थान' },
      mr: { category: 'भांडी कला', material: 'चमकदार माती', craft: 'चमकदार पॉटरी', origin: 'जयपूर, राजस्थान' }
    }
  }
];

export const MULTILINGUAL_PRODUCT = {
  imageUrl: ASSETS.terracottaVase,
  translations: {
    en: {
      title: 'Terracotta Hand-Painted Vase',
      desc: 'An exquisite piece of traditional earthenware, meticulously shaped by skilled rural artisans. Featuring sun-baked pigments and natural glazing, this vase brings rustic elegance and authentic cultural heritage to contemporary living spaces.',
      keywordsLabel: 'AI Keywords',
      keywords: ['Terracotta', 'Handmade', 'Home Decor', 'Traditional Pottery'],
      catLabel: 'Category',
      catVal: 'Home Decor & Pottery',
      matLabel: 'Material',
      matVal: 'Natural Terracotta Clay',
      craftLabel: 'Craft',
      craftVal: 'Wheel-Thrown & Painted',
      origLabel: 'Origin',
      origVal: 'Rajasthan, India',
      btnText: 'Continue to Heritage Story'
    },
    hi: {
      title: 'टेराकोटा हाथ से रंगा हुआ फूलदान',
      desc: 'पारंपरिक मिट्टी के बर्तनों का एक उत्कृष्ट टुकड़ा, जिसे कुशल ग्रामीण कारीगरों द्वारा सावधानीपूर्वक आकार दिया गया है। धूप में पके पिगमेंट और प्राकृतिक ग्लेज़िंग की विशेषता वाला यह फूलदान समकालीन रहने वाले स्थानों में देहाती लालित्य और प्रामाणिक सांस्कृतिक विरासत लाता है।',
      keywordsLabel: 'एआई कीवर्ड',
      keywords: ['टेराकोटा', 'हस्तनिर्मित', 'होम डेकोर', 'पारंपरिक मिट्टी के बर्तन'],
      catLabel: 'श्रेणी',
      catVal: 'होम डेकोर और पॉटरी',
      matLabel: 'सामग्री',
      matVal: 'प्राकृतिक टेराकोटा क्ले',
      craftLabel: 'शिल्प',
      craftVal: 'चाक-निर्मित और चित्रित',
      origLabel: 'मूल',
      origVal: 'राजस्थान, भारत',
      btnText: 'विरासत की कहानी पर आगे बढ़ें'
    },
    mr: {
      title: 'टेराकोटा हाताने रंगवलेले फुलदाणी',
      desc: 'पारंपरिकी मातीची भांडी, ग्रामीण कारागिरांनी अत्यंत कौशल्याने घडवलेली. सूर्यप्रकाशात तापलेले रंग आणि नैसर्गिक चमक असलेली ही फुलदाणी तुमच्या घराला एक अस्सल सांस्कृतिक वारसा आणि आकर्षक रूप देते.',
      keywordsLabel: 'एआय कीवर्ड्स',
      keywords: ['टेराकोटा', 'हस्तनिर्मित', 'घर सजावट', 'पारंपारिक भांडी'],
      catLabel: 'वर्ग',
      catVal: 'घर सजावट आणि पॉटरी',
      matLabel: 'साहित्य',
      matVal: 'नैसर्गिक टेराकोटा माती',
      craftLabel: 'कलाकुसर',
      craftVal: 'चाकावर घडवलेले व रंगवलेले',
      origLabel: 'मूळ',
      origVal: 'राजस्थान, भारत',
      btnText: 'वारसा कथेसह पुढे जा'
    }
  }
};
