export type AppScreen =
  | 'home'
  | 'add-photo'
  | 'add-voice'
  | 'ai-catalog'
  | 'multilingual'
  | 'heritage'
  | 'pricing'
  | 'digital-mela'
  | 'profile';

export type NavTab = 'home' | 'products' | 'ai-assist' | 'profile';

export type Language = 'en' | 'hi' | 'mr';

export interface CraftProduct {
  id: string;
  title: string;
  category: string;
  material: string;
  craft: string;
  origin: string;
  price: number;
  imageUrl: string;
  status: 'Published' | 'Buyer Interested' | 'Draft';
  description: {
    en: string;
    hi: string;
    mr: string;
  };
  keywords: {
    en: string[];
    hi: string[];
    mr: string[];
  };
  attributes: {
    en: { category: string; material: string; craft: string; origin: string };
    hi: { category: string; material: string; craft: string; origin: string };
    mr: { category: string; material: string; craft: string; origin: string };
  };
}

export interface BuyerLead {
  id: string;
  buyerName: string;
  location: string;
  requestedCraft: string;
  budget: string;
  urgency: 'High' | 'Medium';
  avatar: string;
  note: string;
}
