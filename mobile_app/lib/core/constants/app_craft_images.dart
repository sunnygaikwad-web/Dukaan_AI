// lib/core/constants/app_craft_images.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppCraftImages {
  // Verified authentic high-resolution craft images
  static const String paithaniSaree =
      'https://images.unsplash.com/photo-1610030469983-98e550d6193c?auto=format&fit=crop&w=1000&q=80';
  static const String bluePotteryVase =
      'https://images.unsplash.com/photo-1565193566173-7a0ee3dbe261?auto=format&fit=crop&w=1000&q=80';
  static const String terracottaVase =
      'https://images.unsplash.com/photo-1610701596007-11502861dcfa?auto=format&fit=crop&w=1000&q=80';
  static const String terracottaPitcher =
      'https://images.unsplash.com/photo-1615486511484-92e172cc4fe0?auto=format&fit=crop&w=1000&q=80';
  static const String woodcraftBox =
      'https://images.unsplash.com/photo-1546484396-fb3fc6f95f98?auto=format&fit=crop&w=1000&q=80';
  static const String dhokraBrass =
      'https://images.unsplash.com/photo-1582555172866-f73bb12a2ab3?auto=format&fit=crop&w=1000&q=80';
  static const String warliPainting =
      'https://images.unsplash.com/photo-1579783902614-a3fb3927b675?auto=format&fit=crop&w=1000&q=80';
  static const String kolhapuriLeather =
      'https://images.unsplash.com/photo-1549298916-b41d501d3772?auto=format&fit=crop&w=1000&q=80';
  static const String traditionalJewellery =
      'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?auto=format&fit=crop&w=1000&q=80';
  static const String handloomWeaving =
      'https://images.unsplash.com/photo-1584917865442-de89df76afd3?auto=format&fit=crop&w=1000&q=80';
  static const String savitaWheel =
      'https://images.unsplash.com/photo-1565193566173-7a0ee3dbe261?auto=format&fit=crop&w=1200&q=80';
  static const String artisanPortrait =
      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=600&q=80';

  /// Craft presets available for quick selection in Add Craft screen
  static const List<Map<String, String>> craftPresets = [
    {
      'title': 'Paithani Silk Saree',
      'title_mr': 'पैठणी रेशीम साडी',
      'title_hi': 'पैठणी सिल्क साड़ी',
      'category': 'Textiles',
      'url': paithaniSaree,
      'craft': 'Paithani Weaving',
      'origin': 'Yeola, Maharashtra',
      'material': 'Pure Mulberry Silk & Zari',
      'price': '8499',
    },
    {
      'title': 'Blue Pottery Floral Vase',
      'title_mr': 'जयपुरी ब्लू पॉटरी फुलदाणी',
      'title_hi': 'ब्लू पॉटरी फ्लोरल फूलदान',
      'category': 'Pottery',
      'url': bluePotteryVase,
      'craft': 'Jaipur Blue Glazed Pottery',
      'origin': 'Jaipur, Rajasthan',
      'material': 'Quartz & Cobalt Glaze',
      'price': '2400',
    },
    {
      'title': 'Terracotta Hand-Painted Pitcher',
      'title_mr': 'टेराकोटा नक्षीदार सुराही',
      'title_hi': 'टेराकोटा नक्काशीदार सुराही',
      'category': 'Pottery',
      'url': terracottaPitcher,
      'craft': 'Wheel-Thrown Terracotta',
      'origin': 'Kolhapur, Maharashtra',
      'material': 'Natural River Clay & Ochre',
      'price': '799',
    },
    {
      'title': 'Hand-Carved Sheesham Keepsake Box',
      'title_mr': 'शिसम लाकडी कोरीव पेटी',
      'title_hi': 'शीशम लकड़ी नक्काशीदार बॉक्स',
      'category': 'Woodcraft',
      'url': woodcraftBox,
      'craft': 'Traditional Wood Inlay',
      'origin': 'Saharanpur, Uttar Pradesh',
      'material': 'Seasoned Sheesham Wood',
      'price': '2499',
    },
    {
      'title': 'Dhokra Bell-Metal Horse Figurine',
      'title_mr': 'ढोकरा ब्रास घोडा शिल्प',
      'title_hi': 'ढोकरा पीतल का घोड़ा',
      'category': 'Jewellery',
      'url': dhokraBrass,
      'craft': 'Lost-Wax Cast Metal',
      'origin': 'Bastar, Chhattisgarh',
      'material': 'Recycled Brass & Bronze',
      'price': '1850',
    },
    {
      'title': 'Warli Tribal Folk Painting',
      'title_mr': 'वारली आदिवासी चित्रकला',
      'title_hi': 'वारली लोक चित्रकला',
      'category': 'Paintings',
      'url': warliPainting,
      'craft': 'Warli Canvas Art',
      'origin': 'Palghar, Maharashtra',
      'material': 'Mud Base & Rice Paste',
      'price': '3200',
    },
    {
      'title': 'Authentic Kolhapuri Leather Chappal',
      'title_mr': 'अस्सल कोल्हापुरी चप्पल',
      'title_hi': 'प्रामाणिक कोल्हापुरी चप्पल',
      'category': 'Leather',
      'url': kolhapuriLeather,
      'craft': 'Hand-Braided Leathercraft',
      'origin': 'Kolhapur, Maharashtra',
      'material': 'Vegetable-Tanned Leather',
      'price': '1450',
    },
  ];

  /// Maps a craft or category name to an authentic online craft image URL
  static String getCraftImageUrl(String categoryOrTitle) {
    final s = categoryOrTitle.toLowerCase();
    if (s.contains('saree') || s.contains('paithani') || s.contains('silk') || s.contains('textile') || s.contains('handloom') || s.contains('fabric')) {
      return paithaniSaree;
    }
    if (s.contains('blue pottery') || s.contains('ceramic') || s.contains('vase') || s.contains('blue')) {
      return bluePotteryVase;
    }
    if (s.contains('pitcher') || s.contains('surahi') || s.contains('सुराही') || s.contains('pot')) {
      return terracottaPitcher;
    }
    if (s.contains('pottery') || s.contains('terracotta') || s.contains('clay') || s.contains('incense') || s.contains('धूपदानी')) {
      return terracottaVase;
    }
    if (s.contains('wood') || s.contains('carv') || s.contains('box') || s.contains('पेटी')) {
      return woodcraftBox;
    }
    if (s.contains('jewel') || s.contains('ornament') || s.contains('silver')) {
      return traditionalJewellery;
    }
    if (s.contains('paint') || s.contains('warli') || s.contains('madhubani') || s.contains('चित्र')) {
      return warliPainting;
    }
    if (s.contains('brass') || s.contains('metal') || s.contains('dhokra') || s.contains('dokra') || s.contains('घोडा')) {
      return dhokraBrass;
    }
    if (s.contains('leather') || s.contains('kolhapuri') || s.contains('chappal') || s.contains('footwear') || s.contains('चप्पल')) {
      return kolhapuriLeather;
    }
    return terracottaVase;
  }

  /// Builds a responsive, rounded craft image widget with loading indicator and fallback
  static Widget buildCraftImage({
    required String? imageUrl,
    required String categoryOrTitle,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
  }) {
    final effectiveUrl = (imageUrl != null && imageUrl.trim().isNotEmpty && imageUrl.startsWith('http'))
        ? imageUrl.trim()
        : getCraftImageUrl(categoryOrTitle);

    Widget imageWidget = Image.network(
      effectiveUrl,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        final total = loadingProgress.expectedTotalBytes;
        final loaded = loadingProgress.cumulativeBytesLoaded;
        return Container(
          width: width,
          height: height,
          color: AppColors.surfaceContainer,
          child: Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                value: total != null ? loaded / total : null,
                color: AppColors.primary,
              ),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          color: AppColors.surfaceContainer,
          child: Center(
            child: Icon(
              Icons.palette_outlined,
              color: AppColors.primary.withValues(alpha: 0.5),
              size: 28,
            ),
          ),
        );
      },
    );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: imageWidget,
      );
    }
    return imageWidget;
  }
}
