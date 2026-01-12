import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import '../../data/models/user_model.dart';
import '../widgets/action_button_widget.dart';
import '../widgets/detail_info_widget.dart';
import '../widgets/info_title_widget.dart';

class UserDetailPage extends StatelessWidget {
  final User user;
  const UserDetailPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final Color primaryColor = Colors.blueAccent;

    return Scaffold(
      backgroundColor: Colors.white,
      // Using a CustomScrollView for the parallax effect
      body: CustomScrollView(
        slivers: [
          // --- Modern Dynamic Header ---
          SliverAppBar(
            expandedHeight: size.height * 0.28,
            pinned: true, // This keeps the bar visible at the top
            elevation: 0,
            stretch: true,
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: primaryColor,

            // --- This is the key part ---
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              centerTitle: true,
              // The title appears when collapsed
              title: Text(
                "${user.firstName} ${user.lastName}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1C1E),
                  fontSize: 28,
                ),
              ),
              // This setting ensures the title is hidden when fully expanded
              // and only shows up when scrolling
              expandedTitleScale: 1.0,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Background Gradient
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          primaryColor,
                          primaryColor.withOpacity(0.8),
                          Colors.white,
                        ],
                      ),
                    ),
                  ),
                  // Hero Image (Centered)
                  Center(
                    child: Hero(
                      tag: user.id,
                      child: Container(
                        height: 140,
                        width: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(user.avatar),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- User Information Section ---
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Verified Employee",
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Quick Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ActionButtonWidget(icon: Icons.email_outlined,  label: "Email", onPressed: () {
                          Clipboard.setData(ClipboardData(text: user.email));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Email copied to clipboard')),
                          );
                        }),
                        ActionButtonWidget(icon: Icons.phone_outlined, label: "Call", onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Call feature is not implemented yet')),
                          );
                        }),
                        ActionButtonWidget(icon: Icons.chat_bubble_outline_rounded, label: "Message", onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Message feature is not implemented yet')),
                          );
                        }),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Detail Information Cards
                    DetailInfoWidget(title: "Personal Information", info: [
                      InfoTitleWidget(
                          icon: Icons.person_outline_rounded,
                          label: "Full Name",
                          value:  "${user.firstName} ${user.lastName}"
                      ),
                      InfoTitleWidget(
                          icon: Icons.alternate_email_rounded,
                          label: "Email Address",
                          value: user.email
                      ),
                      InfoTitleWidget(
                          icon:Icons.badge_outlined,
                          label: "Employee ID",
                          value: "SKR-${user.id}042"
                      ),
                    ]),

                    DetailInfoWidget(title: "Company Details", info: [
                      InfoTitleWidget(
                          icon:Icons.business_center_outlined,
                          label:"Department",
                          value:"Field Operations"
                      ),
                      InfoTitleWidget(
                          icon: Icons.location_on_outlined,
                          label:"Office",
                          value:"Dhaka Headquarters"
                      ),
                    ]),

                    const SizedBox(height: 50), // Bottom padding
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}