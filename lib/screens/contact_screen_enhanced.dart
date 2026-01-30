import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../data/office_locations_data.dart';
import '../providers/app_config_provider.dart';
import '../shared/widgets/app_bar/custom_app_bar.dart';
import '../widgets/advanced_quote_request_form.dart';
import '../config/theme/colors.dart';
import '../shared/widgets/luxury/luxury_cta_section.dart';

class ContactScreenEnhanced extends StatelessWidget {
  const ContactScreenEnhanced({super.key});

  @override
  Widget build(BuildContext context) {
    final config = context.watch<AppConfigProvider>().config;
    final offices = OfficeLocationsData.getOfficesByRegion(config.region.code);
    final headOffice = OfficeLocationsData.getHeadOffice(config.region.code);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(24),
            child: _buildHeader(),
          ),

          const SizedBox(height: 60),

          // Quick Contact Cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _buildQuickContactSection(config),
          ),

          const SizedBox(height: 80),

          // Office Locations
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _buildOfficeLocationsSection(offices, config),
          ),

          const SizedBox(height: 80),

          // Get a Quote CTA (Final Footer)
          const LuxuryCTASection(
            buttonTypes: [CTAButtonType.quote, CTAButtonType.services],
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Text(
            'GET IN TOUCH',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryGold,  // Old Gold
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Contact Us',
            style: GoogleFonts.inter(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF212121),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(width: 60, height: 4,color: AppColors.primaryGold),  // Old Gold
          const SizedBox(height: 24),
          Text(
            'We\'re here to make your event extraordinary.\nReach out to us through any of our offices.',
            style: GoogleFonts.inter(
              fontSize: 16,
              color: const Color(0xFF616161),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickContactSection(config) {
    return Column(
      children: [
        Text(
          'Quick Contact',
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 32),
        LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = constraints.maxWidth > 900
                ? 4
                : (constraints.maxWidth > 600 ? 2 : 1);
            
            return Wrap(
              spacing: 24,
              runSpacing: 24,
              alignment: WrapAlignment.center,
              children: [
                _buildQuickContactCard(
                  icon: Icons.phone,
                  title: 'Call Us',
                  value: config.phoneNumber,
                  subtitle: 'Mon-Sat, 9 AM - 7 PM',
                  color: AppColors.primaryGold,  // Old Gold
                  onTap: () async {
                    final url = Uri.parse('tel:${config.phoneNumber}');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    }
                  },
                ),
                _buildQuickContactCard(
                  icon: FontAwesomeIcons.whatsapp,
                  title: 'WhatsApp',
                  value: 'Chat with us',
                  subtitle: 'Instant response',
                  color: const Color(0xFF25D366),
                  onTap: () async {
                    final url = Uri.parse(config.getWhatsAppLink());
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    }
                  },
                ),
                _buildQuickContactCard(
                  icon: Icons.email,
                  title: 'Email Us',
                  value: config.email,
                  subtitle: 'We reply within 24 hours',
                  color: AppColors.primaryGold,  // Old Gold
                  onTap: () async {
                    final url = Uri.parse('mailto:${config.email}');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    }
                  },
                ),
                _buildQuickContactCard(
                  icon: Icons.request_quote,
                  title: 'Get Quote',
                  value: 'Request a quote',
                  subtitle: 'Free, no obligation',
                  color: AppColors.primaryGold,  // Old Gold
                  onTap: (BuildContext ctx) {
                    showDialog(
                      context: ctx,
                      builder: (context) => Dialog(
                        backgroundColor: Colors.white,
                        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 900, maxHeight: 800),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: AdvancedQuoteRequestForm(
                              onSuccess: () {
                                 Navigator.pop(context);
                                 ScaffoldMessenger.of(context).showSnackBar(
                                   const SnackBar(
                                     content: Text('Quote request submitted successfully!'),
                                     backgroundColor: Color(0xFF059669),
                                   ),
                                 );
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildQuickContactCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
    required Function onTap,
  }) {
    return Builder(
      builder: (context) {
        return GestureDetector(
          onTap: () {
            if (onTap is Function(BuildContext)) {
              onTap(context);
            } else {
              onTap();
            }
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              width: 260,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withOpacity(0.2), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: color, size: 32),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    value,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF757575),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOfficeLocationsSection(List<OfficeLocation> offices, config) {
    return Column(
      children: [
        Text(
          'Our Offices in ${config.region.name}',
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Visit us at any of our locations or call to schedule an appointment',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: const Color(0xFF616161),
          ),
        ),
        const SizedBox(height: 40),
        Wrap(
          spacing: 24,
          runSpacing: 24,
          children: offices.map((office) => _buildOfficeCard(office)).toList(),
        ),
      ],
    );
  }

  Widget _buildOfficeCard(OfficeLocation office) {
    return Container(
      width: 380,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: office.isHeadOffice
            ? const Color(0xFFF5F5F5)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: office.isHeadOffice
              ? AppColors.primaryGold  // Old Gold for head office
              : const Color(0xFFE0E0E0),
          width: office.isHeadOffice ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryGold.withOpacity(0.1),  // Old Gold tint
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.location_city,
                  color: AppColors.primaryGold,  // Old Gold
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      office.cityName.toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryGold,  // Old Gold
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      office.officeName,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF212121),
                      ),
                    ),
                  ],
                ),
              ),
                if (office.isHeadOffice)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primaryGold, Color(0xFFAA9225)],  // Old Gold
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'HQ',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),

          // Address
          _buildOfficeInfoRow(Icons.location_on, office.fullAddress),
          const SizedBox(height: 16),

          // Phone
          _buildOfficeInfoRow(Icons.phone, office.phone, isClickable: true),
          const SizedBox(height: 16),

          // Email
          _buildOfficeInfoRow(Icons.email, office.email, isClickable: true),
          const SizedBox(height: 24),

          // Business Hours
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: office.isHeadOffice
                  ? Colors.white
                  : const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16, color: Color(0xFF616161)),
                    const SizedBox(width: 8),
                    Text(
                      'Business Hours',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF616161),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...office.businessHours.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entry.key,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: const Color(0xFF424242),
                          ),
                        ),
                        Text(
                          entry.value,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF212121),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // WhatsApp Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                final url = Uri.parse('https://wa.me/${office.whatsapp.replaceAll(RegExp(r'[^\d+]'), '')}');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
             style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF25D366),
                side: const BorderSide(color: Color(0xFF25D366), width: 2),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.chat, size: 18),
              label: Text(
                'WHATSAPP THIS OFFICE',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfficeInfoRow(IconData icon, String text, {bool isClickable = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: const Color(0xFF616161)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: isClickable ? AppColors.primaryGold : const Color(0xFF424242),
              fontWeight: isClickable ? FontWeight.w600 : FontWeight.normal,
              decoration: isClickable ? TextDecoration.underline : null,
            ),
          ),
        ),
      ],
    );
  }
}
