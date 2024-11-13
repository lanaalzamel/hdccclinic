import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      Theme
          .of(context)
          .colorScheme
          .onBackground
          .withOpacity(0.5),
      appBar: AppBar(
        backgroundColor:
        Theme
            .of(context)
            .colorScheme
            .onBackground
            .withOpacity(0.5),
        leading: IconButton(
          icon:
          Icon(Icons.arrow_back, color: Theme
              .of(context)
              .iconTheme
              .color),
          onPressed: () {
            Get.back();
          },
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Get in touch'.tr,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme
                    .of(context)
                    .textTheme
                    .bodyText1
                    ?.color,
              ),
            ),
            const SizedBox(height: 20),
             ContactOption(text: 'Contact support'.tr),
            InkWell(
              onTap: () {
                _launchPhone('+963995952235');
              },
              child:  ContactOption(text: 'Call us'.tr),
            ),
            InkWell(
                onTap: () async {
                  String? encodeQueryParameters(Map<String, String> params) {
                    return params.entries
                        .map((MapEntry<String, String> e) =>
                    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(
                        e.value)}')
                        .join('&');
                  }
                  final Uri emailUri = Uri(
                  scheme: 'mailto',
                  path: 'HDCC_clinic@gmail.com',
                  query: encodeQueryParameters(<String, String>{
                  'subject': 'استفسار حول خيارات العلاج السني',
                  'body': 'أنا أفكر في بعض العلاجات السنية وأود الحصول على مزيد من المعلومات.',
                  }),
                  );
                  if (await canLaunchUrl(emailUri)) {
                  launchUrl(emailUri);
                  } else {
                  throw Exception('could not launch $emailUri'.tr);
                  }
                },
                child:  ContactOption(text: 'Email us'.tr)),
            // InkWell(
            //   onTap: () {
            //     Get.to(() => LegalInformationPage());
            //   },
            //   child: ContactOption(text: 'Get legal information'.tr),
            // ),

            const SizedBox(
              height: 20,
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0), // Rounded corners
              ),
              elevation: 4.0, // Background color of the card
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  // Match Card's rounded corners
                  image: DecorationImage(
                    image: AssetImage('assets/images/background.jpg'),
                    // Path to your background image
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.5), // Overlay color with opacity
                      BlendMode.srcATop, // Blending mode
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Contact Information'.tr,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Theme
                              .of(context)
                              .textTheme
                              .bodyText1
                              ?.color,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.phone,
                            color: Theme
                                .of(context)
                                .textTheme
                                .bodyText1
                                ?.color,
                          ),
                          const SizedBox(width: 8.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '+8801779717686',
                                style: TextStyle(
                                    color: Theme
                                        .of(context)
                                        .textTheme
                                        .bodyText1
                                        ?.color,
                                    fontSize: 16.0),
                              ),
                              Text(
                                '+988678363866',
                                style: TextStyle(
                                    color: Theme
                                        .of(context)
                                        .textTheme
                                        .bodyText1
                                        ?.color,
                                    fontSize: 16.0),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.email,
                            color: Theme
                                .of(context)
                                .textTheme
                                .bodyText1
                                ?.color,
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            'Support@uprangly.com',
                            style: TextStyle(
                                color: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.color,
                                fontSize: 16.0),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.location_on,
                            color: Theme
                                .of(context)
                                .textTheme
                                .bodyText1
                                ?.color,
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            'Damascus,Syria',
                            style: TextStyle(
                                color: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.color,
                                fontSize: 16.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContactOption extends StatelessWidget {
  final String text;

  const ContactOption({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          color: Theme
              .of(context)
              .primaryColor,
        ),
      ),
    );
  }
}

void _launchPhone(String phoneNumber) async {
  final url = 'tel:$phoneNumber';
  if (await canLaunchUrl(Uri.parse('tel:$phoneNumber'))) {
    await launchUrl(Uri.parse('tel:$phoneNumber'));
  } else {
    throw 'Could not launch $url';
  }
}


class LegalInformationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
          onPressed: () {
            Get.back();
          },
        ),
        elevation: 0,
        title: Text('Legal Information'.tr),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              _buildExpandableSection(
                context,
                title: 'Terms of Service',
                content: _termsOfServiceContent,
              ),
              const SizedBox(height: 20),
              _buildExpandableSection(
                context,
                title: 'Privacy Policy',
                content: _privacyPolicyContent,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandableSection(BuildContext context, {required String title, required String content}) {
    return ExpansionTile(
      title: Text(
        title.tr,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Text(
            content.tr,
            style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodyText1?.color),
          ),
        ),
      ],
    );
  }
}

// Terms of Service text content
const String _termsOfServiceContent = '''
By using this app, you agree to the following terms:

1. **Acceptance of Terms**: By accessing and using this app, you agree to comply with these Terms of Service.
2. **Use Restrictions**: Users agree not to misuse the app, such as by engaging in unauthorized access, modifying the app’s source code, or redistributing the content.
3. **Intellectual Property**: All content, designs, and intellectual property are owned by us and may not be used without permission.
4. **Limitation of Liability**: We are not responsible for any damages or losses caused by the use of the app.
5. **Termination**: We reserve the right to terminate any user account that violates these terms.
6. **Modifications**: We may modify the app and the Terms of Service at any time.
7. **Governing Law**: These terms are governed by the laws of [your country].

''';

// Privacy Policy text content
const String _privacyPolicyContent = '''
We value your privacy. This policy outlines how we collect, use, and protect your data:

1. **Data Collection**: We collect personal information like name, email, and phone number when users register or contact us.
2. **Data Use**: The information collected is used to improve your experience with the app, such as personalized content and user support.
3. **Third-Party Sharing**: We do not share personal data with third parties unless required by law or for essential app functionality.
4. **User Rights**: Users have the right to access, modify, or delete their personal data by contacting us.
5. **Cookies**: We may use cookies and similar technologies to enhance user experience.
6. **Security**: We take reasonable precautions to protect your data from unauthorized access.
7. **Changes**: This policy may be updated occasionally, and users will be notified of any significant changes.

If you have any questions regarding our Terms or Privacy Policy, please contact us at Support@uprangly.com.

''';

