import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/internacionalization.dart';

class AppTranslation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUS,
        'ar_AE': ar,
        // Make sure the locale matches exactly with the format 'ar_AE'
      };
}

final Map<String, String> enUS = {
  'Welcome back': 'Welcome back',
  'Upcoming visit': 'Upcoming visit',
  'Get a New Appointment': 'Get a New Appointment',
  'Recommendation': 'Recommendation',
  'Home': 'Home',
  'Toggle Theme': 'Toggle Theme',
  'Chat': 'Chat',
  'profile': 'profile',
  'Book Now': 'Book Now',
  'Select Appointment Type': 'Select Appointment Type',
  'Type your message...':'Type your message...',
  'How soon do you need the appointment?':
      'How soon do you need the appointment?',
  'Regular appointment': 'Regular appointment',
  'Emergency appointment': 'Emergency appointment',
  'Book Appointment': 'Book Appointment',
  'We’re working on it! Check back soon.':
      'We’re working on it! Check back soon.',
  'Select your doctor': 'Select your doctor',
  'Select Date': 'Select Date',
  'Specialization not available': 'Specialization not available',

  'Select appointment Time': 'Select appointment Time',
  'Select the doctor to display available booking times':
      'Select the doctor to display available booking times',
  'Oops!': 'Oops!',
  'Please select a doctor and time': 'Please select a doctor and time',
  'ok': 'ok',
  'you already have an upcoming appointment':
      'you already have an upcoming appointment',
  'Awesome!': 'Awesome!',
  'Success': 'Success',
  'Select your emergency': 'Select your emergency',
  'Appointment booked successfully!': 'Appointment booked successfully!',
  'You’re all caught up!': 'You’re all caught up!',
  'No upcoming appointments.': 'No upcoming appointments.',
  'Search doctors...': 'Search doctors...',
  'how are you today!': 'how are you today!',
  'Appointments': 'Appointments',
  'Medical record': 'Medical record',
  'Medical Record': 'Medical Record',
  'My appointments': 'My appointments',
  'My Appointments': 'My Appointments',
  'payments': 'payments',
  'Payments': 'Payments',
  'You have no chats yet. Start a conversation by selecting a doctor.':
      'You have no chats yet. Start a conversation by selecting a doctor.',
  'Contact Us': 'Contact Us',
  'Medical history': 'Medical history',
  'Medical History': 'Medical History',
  'Last 7 days': 'Last 7 days',
  'Last 30 days': 'Last 30 days',
  'Last 90 days': 'Last 90 days',
  'Quarter of date': 'Quarter of date',
  'previous quarter': 'previous quarter',
  'Condition': 'Condition',
  'Treatment': 'Treatment',
  'Dentist': 'Dentist',
  'No available doctors to start a chat with at the moment.':
      'No available doctors to start a chat with at the moment.',
  'Notes:': 'Notes:',
  'download': 'download',
  'Date': 'Date',
  'Doctor': 'Doctor',
  'status': 'status',
  'upcoming': 'upcoming',
  'All Appointments':'All Appointments',
  'completed': 'completed',
  'canceled': 'canceled',
  'Appointment': 'Appointment',
  'Get in touch': 'Get in touch',
  'Contact support': 'Contact support',
  'Call us': 'Call us',
  'Email us': 'Email us',
  'Get legal information': 'Get legal information',
  'Contact Information': 'Contact Information',
  'Log out': 'Log out',
  'Settings': 'Settings',
  'Doctor Not Selected': 'Doctor Not Selected',
  'Please select a doctor before choosing a date.':
      'Please select a doctor before choosing a date.',
  'welcome': 'welcome',
  'welcome to out clinic! please choose your role to proceed':
      'welcome to out clinic! please choose your role to proceed',
  'Patient': 'Patient',
  'Lab': 'Lab',
  'Log in': 'Log in',
  'Enter your Email': 'Enter your Email',
  'Enter your password': 'Enter your password',
  'Continue': 'Continue',
  'Remember me': 'Remember me',
  'We will contact you shortly to confirm your appointment.':
      'We will contact you shortly to confirm your appointment.',
  'Forget password': 'Forget password',
  'please enter your emai and we will send you a link to reset your password':
      'please enter your emai and we will send you a link to reset your password',
  'Rest': 'Rest',
  'don\'t have an account?': 'don\'t have an account?',
  'Sign up': 'Sign up',
  'loading': 'loading',
  'Get Urgent Appointment': 'Get Urgent Appointment',
  'Please describe your emergency': 'Please describe your emergency',
  'logout': 'logout',
  'settings screen': 'settings screen',
  'Unavailable': 'Unavailable',
  'Fridays are not selectable.': 'Fridays are not selectable.',
  'Bills': 'Bills',
  'Error': 'Error',
  'Failed to book appointment': 'Failed to book appointment',
  'Urgent Appointment': 'Urgent Appointment',
  'Describe your emergency': 'Describe your emergency',
  'Toothache': 'Toothache',
  'Rinse your mouth with warm water.': 'Rinse your mouth with warm water.',
  'Use dental floss to remove any trapped food.':
      'Use dental floss to remove any trapped food.',
  'Apply a cold compress to your cheek if there is swelling.':
      'Apply a cold compress to your cheek if there is swelling.',
  'Take over-the-counter pain relief medication if needed.':
      'Take over-the-counter pain relief medication if needed.',
  'Knocked-Out Tooth': 'Knocked-Out Tooth',
  'Retrieve the tooth, holding it by the crown.':
      'Retrieve the tooth, holding it by the crown.',
  'Rinse it with water but do not scrub.':
      'Rinse it with water but do not scrub.',
  'If possible, reinsert it into the socket or place it in milk.':
      'If possible, reinsert it into the socket or place it in milk.',
  'Get to your dentist as soon as possible.':
      'Get to your dentist as soon as possible.',
  'Broken Tooth': 'Broken Tooth',
  'Rinse your mouth with warm water.': 'Rinse your mouth with warm water.',
  'Save any pieces of the tooth.': 'Save any pieces of the tooth.',
  'Apply a cold compress to reduce swelling.':
      'Apply a cold compress to reduce swelling.',
  'Avoid chewing on the affected side.': 'Avoid chewing on the affected side.',
  'Severe Gum Pain': 'Severe Gum Pain',
  'Rinse your mouth with warm salt water.':
      'Rinse your mouth with warm salt water.',
  'Use a cold compress on your face to reduce pain and swelling.':
      'Use a cold compress on your face to reduce pain and swelling.',
  'Avoid very hot or cold foods and drinks.':
      'Avoid very hot or cold foods and drinks.',
  'See your dentist to identify and treat the underlying cause.':
      'See your dentist to identify and treat the underlying cause.',
  'Chipped Tooth': 'Chipped Tooth',
  'Rinse your mouth with warm water.': 'Rinse your mouth with warm water.',
  'Save any broken pieces of the tooth.':
      'Save any broken pieces of the tooth.',
  'Apply a cold compress to reduce swelling.':
      'Apply a cold compress to reduce swelling.',
  'Visit your dentist as soon as possible for a proper repair.':
      'Visit your dentist as soon as possible for a proper repair.',
  'Lost Filling or Crown': 'Lost Filling or Crown',
  'Cover the exposed area with dental cement or sugar-free gum as a temporary measure.':
      'Cover the exposed area with dental cement or sugar-free gum as a temporary measure.',
  'Avoid chewing on that side of your mouth.':
      'Avoid chewing on that side of your mouth.',
  'Contact your dentist to schedule an appointment for a replacement.':
      'Contact your dentist to schedule an appointment for a replacement.',
  'Bleeding Gums': 'Bleeding Gums',
  'Rinse with warm salt water to reduce bleeding.':
      'Rinse with warm salt water to reduce bleeding.',
  'Apply gentle pressure with a clean gauze or cloth.':
      'Apply gentle pressure with a clean gauze or cloth.',
  'Avoid brushing or flossing the affected area until it stops bleeding.':
      'Avoid brushing or flossing the affected area until it stops bleeding.',
  'If bleeding persists, consult your dentist.':
      'If bleeding persists, consult your dentist.',
  'Jaw Injury': 'Jaw Injury',
  'Apply ice to reduce swelling and pain.':
      'Apply ice to reduce swelling and pain.',
  'Keep your jaw immobilized and avoid moving it.':
      'Keep your jaw immobilized and avoid moving it.',
  'If you experience severe pain or difficulty opening your mouth, seek immediate medical attention.':
      'If you experience severe pain or difficulty opening your mouth, seek immediate medical attention.',
  'Abscessed Tooth': 'Abscessed Tooth',
  'Rinse your mouth with warm salt water to help relieve pain.':
      'Rinse your mouth with warm salt water to help relieve pain.',
  'Apply a cold compress to reduce swelling.':
      'Apply a cold compress to reduce swelling.',
  'Seek prompt dental care to address the infection and relieve pain.':
      'Seek prompt dental care to address the infection and relieve pain.',
  'Appointment request sent successfully':
      'Appointment request sent successfully',
  'An unexpected error occurred': 'An unexpected error occurred',
  'Emergency Guidance': 'Emergency Guidance',
  'Visit Website': 'Visit Website',
  'Helpful guidance for addressing dental emergencies:':
      'Helpful guidance for addressing dental emergencies:',
  'You can contact us or visit our website for more assistance.':
      'You can contact us or visit our website for more assistance.',
  'Need More Help?': 'Need More Help?',
  'contact us': 'contact us',
  'It’s quiet today! No lab requests have come in yet.':
      'It’s quiet today! No lab requests have come in yet.',
  'Stay tuned!': 'Stay tuned!',
  'Today\'s Requests': 'Today\'s Requests',
  'Pending Lab Requests': 'Pending Lab Requests',
  'Pending': 'Pending',
  'request': 'request',
  ''''''
      ''''''
      ''''''
      ''''''
      ''''''
      ''''''
      ''
      'Request Details': 'Request Details',
  'Cost:': 'Cost:',
  'Image could not load.': 'Image could not load.',
  'No Image Available': 'No Image Available',
  'Doctor:': 'Doctor:',
  'Patient:': 'Patient:',
  'Medical Tech:': 'Medical Tech:',
  'Request Type:': 'Request Type:',
  'Type:': 'Type:',
  'Date:': 'Date:',
  'Color:': 'Color:',
  'Request Date:': 'Request Date:',
  'Delivery Date:': 'Delivery Date:',
  'Completed & Updated Requests': 'Completed & Updated Requests',
  'Completed': 'Completed',
  'No update requests found.': 'No update requests found.',
  'Please check back later.': 'Please check back later.',
  'OK': 'OK',
  'Update': 'Update',
  'Pick Image': 'Pick Image',
  'send Date': 'send Date',
  'Request Details': 'Request Details',
  'Error picking images: ': 'Error picking images: ',
  'Tap here to view the image':'Tap here to view the image',
  'Cost': 'Cost',
  'Delivery Date': 'Delivery Date',
  'Language': 'Language',
  'Canceled':'Canceled',
  'Theme': 'Theme',
  'Cancel':'Cancel',
  'Logout': 'Logout',
  'Account': 'Account',
  'Upcoming':'Upcoming',
"doctor_title": "Dr.",
  ''''''
      ''''''
      ''''''
      ''
      'Log in as Laboratory': 'Log in as Laboratory',
  'Enter your Lab Email': 'Enter your Lab Email',
  'Enter your Lab password': 'Enter your Lab password',
  'Continue as lab': 'Continue as lab',
  'There is an error': 'There is an error',
  'done': 'done',
  'Email and password cannot be empty': 'Email and password cannot be empty',
  'Error here': 'Error here',
  'loading...': 'loading...',
  'Welcome': 'Welcome',
  'welcome to our clinic! Please choose your role to proceed.':
      'welcome to our clinic! Please choose your role to proceed.',
  'Patient': 'Patient',
  'Lab': 'Lab',
  'No available times for the selected date.':
      'No available times for the selected date.',
  'Select Appointment Time': 'Select Appointment Time',
  'No appointments available':'No appointments available',
  'No reason provided':'No reason provided',
  'Cancel Appointment':'Cancel Appointment',
  'Are you sure you want to cancel this appointment?':
'Are you sure you want to cancel this appointment?',
  'Yes':'Yes',
  'No':'No',
  'Appointment reason :':'Appointment reason :',

};

final Map<String, String> ar = {
  'Appointment reason :':'سبب الموعد :',
  'No':'لا',
  'Yes':'نعم',
'Are you sure you want to cancel this appointment?':
'هل أنت متأكد أنك تريد إلغاء هذا الموعد؟',
'Cancel Appointment':'الغاء الموعد',
  'Cancel':'الغاء',
  'No reason provided':' يوجد سبب موفر',
  'No appointments available':'لا توجد مواعيد متاحة',
  'Welcome back': 'أهلا بعودتك',
  'Failed to book appointment': 'فشل في حجز الموعد',
  'Upcoming visit': 'الزيارة القادمة',
  'Get a New Appointment': 'احصل على موعد جديد',
  'Recommendation': 'توصيات',
  'Home': 'الرئيسية',
  'Chat': 'الدردشة',
  'profile': 'الملف الشخصي',
  'Canceled':'ملغاة',
  'canceled':'ملغاة',
  'Appointment request sent successfully': 'تم إرسال طلب الموعد بنجاح',
  'Book Now': 'احجز الآن',
  'An unexpected error occurred': 'حدث خطأ غير متوقع',
  'Need More Help?': 'هل تحتاج إلى مزيد من المساعدة؟',
  'You can contact us or visit our website for more assistance.':
      'يمكنك الاتصال بنا أو زيارة موقعنا الإلكتروني للحصول على المزيد من المساعدة.',
  'Visit Website': 'زيارة الموقع',
  'Helpful guidance for addressing dental emergencies:':
      'إرشادات مفيدة للتعامل مع حالات الطوارئ المتعلقة بالأسنان:',
  'Upcoming':'القادمة',
  'All Appointments':'المواعيد',
  'Emergency Guidance': 'إرشادات الطوارئ',
  'Get legal information': 'احصل على المعلومات القانونية',
  'Select Appointment Type': 'اختر نوع الموعد',
  'How soon do you need the appointment?': 'ما مدى سرعة حاجتك إلى الموعد',
  'Regular appointment': 'موعد عادي',
  'Emergency appointment': 'موعد طارئ',
  'You have no chats yet. Start a conversation by selecting a doctor.':
      'ليس لديك محادثات بعد. ابدأ محادثة باختيار طبيب.',
  'Book Appointment': 'احجز موعد',
  'Urgent Appointment': 'موعد عاجل',
  'Success': 'تم',
  'No available doctors to start a chat with at the moment.':
      'لا يوجد أطباء متاحين لبدء الدردشة معهم في الوقت الحالي.',
  'Select your doctor': 'اختر طبيبك',
  'Select Date': 'اختر التاريخ',
  'Fridays are not selectable.': 'لا يمكن اختيار أيام الجمعة.',
  'Unavailable': 'غير متاح',
  'Please describe your emergency': "الرجاء وصف حالتك الطارئة",
  'Please select a doctor before choosing a date.':
      'الرجاء اختيار الطبيب قبل اختيار التاريخ.',
  'Doctor Not Selected': 'قم باختيار الطبيب',
  'Get Urgent Appointment': 'احصل على موعد عاجل',
  'Specialization not available': 'المختص غير متاح',
  'Select appointment Time': 'اختر وقت الموعد',
  'Select the doctor to display available booking times': 'اختر الطبيب لعرض أوقات الحجز المتاحة',
  'Tap here to view the image':'اضغط هنا لرؤية الصورة',
  'Oops!': 'عذرًا',
  'Error': 'خطأ',
  'All':'All',
  'Select your emergency': "اختر حالة الطوارئ الخاصة بك",
  'Describe your emergency': "وصف حالتك الطارئة",
  'Please select a doctor and time': 'يرجى اختيار طبيب ووقت',
  'ok': 'حسنًا',
  'We will contact you shortly to confirm your appointment.':
      'سوف نتواصل بك قريبا لتأكيد موعدك.',
  'Appointments': 'المواعيد',
  'you already have an upcoming appointment': 'لديك بالفعل موعد قادم',
  'Awesome!': 'رائع',
  'Appointment booked successfully!': 'تم حجز الموعد بنجاح',
  'You’re all caught up!': 'لقد أنجزت كل شيء!',
  'No upcoming appointments.': 'لا توجد مواعيد قادمة',
  'Search doctors...': 'ابحث عن الأطباء',
  'how are you today!': 'كيف حالك اليوم',
  'We’re working on it! Check back soon.':
      'نحن نعمل على ذلك! ارجع مرة أخرى قريبًا.',
  'Medical record': 'السجل الطبي',
  'Medical Record': 'السجل الطبي',
  'Toggle Theme': 'تبديل الثيم',
  'My appointments': 'مواعيدي',
  'My Appointments': 'مواعيدي',
  'payments': 'المدفوعات',
  'Payments': 'المدفوعات',
  'Contact Us': 'اتصل بنا',
  'contact us': 'اتصل بنا',
  'Medical history': 'التاريخ الطبي',
  'Medical History': 'التاريخ الطبي',
  'Bills': 'الفواتير',
  'Last 7 days': 'آخر 7 أيام',
  'Last 30 days': 'آخر 30 يومًا',
  'Last 90 days': 'آخر 90 يومًا',
  'Quarter of date': 'ربع السنة',
  'previous quarter': 'الربع السابق',
  'Condition': 'الحالة',
  'Treatment': 'العلاج',
  'Dentist': 'طبيب الأسنان',
  'Notes:': 'ملاحظات',
  'download': 'تنزيل',
  'Date': 'التاريخ',
  'Doctor': 'الطبيب',
  'Status': 'الحالة',
  'upcoming': 'القادمة',
  'completed': 'مكتمل',
  'canceled': 'ملغى',
  'Appointment': 'الموعد',
  'Get in touch': 'تواصل معنا',
  'Contact support': 'اتصل بالدعم',
  'Call us': 'اتصل بنا',
  'Email us': 'راسلنا عبر البريد الإلكتروني',
  'Contact Information': 'معلومات الاتصال',
  'Log out': 'تسجيل الخروج',
  'Settings': 'الإعدادات',
  'welcome': 'أهلاً وسهلاً',
  'welcome to out clinic! please choose your role to proceed':
      'مرحبًا بك في عيادتنا! يرجى اختيار دورك للمتابعة',
  'Patient': 'مريض',
  'All':'الكل',
  'Lab': 'مختبر',
  'Log in': 'تسجيل الدخول',
  'Enter your Email': 'أدخل بريدك الإلكتروني',
  'Enter your password': 'أدخل كلمة المرور الخاصة بك',
  'Type your message...':'الرسالة',
  'Continue': 'متابعة',
  'Remember me': 'تذكرني',
  'Forget password': 'نسيت كلمة المرور',
  'please enter your emai and we will send you a link to reset your password':
      'يرجى إدخال بريدك الإلكتروني وسنرسل لك رابطًا لإعادة تعيين كلمة المرور',
  'Rest': 'استعادة',
  'don\'t have an account?': 'لا تملك حسابًا؟',
  'Sign up': 'سجل',
  'loading': 'جارٍ التحميل',
  'logout': 'تسجيل خروج',
  'settings screen': 'صفحة الاعدادات',
  'Toothache': 'وجع الأسنان',
  'Rinse your mouth with warm water.': 'اغسل فمك بالماء الدافئ.',
  'Use dental floss to remove any trapped food.':
      'استخدم خيط الأسنان لإزالة أي طعام محبوس.',
  'Apply a cold compress to your cheek if there is swelling.':
      'ضع كمادة باردة على خدك إذا كان هناك تورم.',
  'Take over-the-counter pain relief medication if needed.':
      'تناول مسكنات الألم المتاحة دون وصفة طبية إذا لزم الأمر.',
  'Knocked-Out Tooth': 'سقوط السن',
  'Retrieve the tooth, holding it by the crown.':
      'استرجع السن وأمسكه من التاج.',
  'Rinse it with water but do not scrub.': 'اغسله بالماء لكن لا تفركه.',
  'If possible, reinsert it into the socket or place it in milk.':
      'إذا أمكن، أعد إدخاله في التجويف أو ضعه في الحليب.',
  'Get to your dentist as soon as possible.':
      'اذهب إلى طبيب الأسنان في أسرع وقت ممكن.',
  'Broken Tooth': 'كسر السن',
  'Rinse your mouth with warm water.': 'اغسل فمك بالماء الدافئ.',
  'Save any pieces of the tooth.': 'احتفظ بأي قطع من السن.',
  'Apply a cold compress to reduce swelling.': 'ضع كمادة باردة لتقليل التورم.',
  'Avoid chewing on the affected side.': 'تجنب المضغ على الجانب المتأثر.',
  'Severe Gum Pain': 'ألم شديد في اللثة',
  'Rinse your mouth with warm salt water.': 'اغسل فمك بالماء المالح الدافئ.',
  'Use a cold compress on your face to reduce pain and swelling.':
      'استخدم كمادة باردة على وجهك لتقليل الألم والتورم.',
  'Avoid very hot or cold foods and drinks.':
      'تجنب الأطعمة والمشروبات شديدة السخونة أو البرودة.',
  'See your dentist to identify and treat the underlying cause.':
      'راجع طبيب الأسنان لتحديد السبب وعلاجه.',
  'Chipped Tooth': 'تقطيع السن',
  'Rinse your mouth with warm water.': 'اغسل فمك بالماء الدافئ.',
  'Save any broken pieces of the tooth.': 'احتفظ بأي قطع مكسورة من السن.',
  'Apply a cold compress to reduce swelling.': 'ضع كمادة باردة لتقليل التورم.',
  'Visit your dentist as soon as possible for a proper repair.':
      'زر طبيب أسنانك في أسرع وقت ممكن للإصلاح المناسب.',
  'Lost Filling or Crown': 'فقدان الحشوة أو التاج',
  'Cover the exposed area with dental cement or sugar-free gum as a temporary measure.':
      'غط المنطقة المكشوفة بالإسمنت السني أو العلكة الخالية من السكر كإجراء مؤقت.',
  'Avoid chewing on that side of your mouth.':
      'تجنب المضغ على هذا الجانب من فمك.',
  'Contact your dentist to schedule an appointment for a replacement.':
      'اتصل بطبيب الأسنان لتحديد موعد للاستبدال.',
  'Bleeding Gums': 'نزيف اللثة',
  'Rinse with warm salt water to reduce bleeding.':
      'اغسل فمك بالماء المالح الدافئ لتقليل النزيف.',
  'Apply gentle pressure with a clean gauze or cloth.':
      'ضع ضغطًا خفيفًا باستخدام شاش نظيف أو قطعة قماش.',
  'Avoid brushing or flossing the affected area until it stops bleeding.':
      'تجنب تنظيف أو استخدام الخيط في المنطقة المتأثرة حتى يتوقف النزيف.',
  'If bleeding persists, consult your dentist.':
      'إذا استمر النزيف، استشر طبيب الأسنان.',
  'Jaw Injury': 'إصابة الفك',
  'Apply ice to reduce swelling and pain.': 'ضع ثلجًا لتقليل التورم والألم.',
  'Keep your jaw immobilized and avoid moving it.':
      'حافظ على فكك ثابتًا وتجنب تحريكه.',
  'If you experience severe pain or difficulty opening your mouth, seek immediate medical attention.':
      'إذا كنت تعاني من ألم شديد أو صعوبة في فتح فمك، فاطلب العناية الطبية فورًا.',
  'Abscessed Tooth': 'خراج الأسنان',
  'Rinse your mouth with warm salt water to help relieve pain.':
      'اغسل فمك بالماء المالح الدافئ لتخفيف الألم.',
  'Apply a cold compress to reduce swelling.': 'ضع كمادة باردة لتقليل التورم.',
  'Seek prompt dental care to address the infection and relieve pain.':
      'اطلب رعاية أسنان فورية لعلاج العدوى وتخفيف الألم.',
  'It’s quiet today! No lab requests have come in yet.':
      "اليوم هادئ! لم تصل أي طلبات للمختبر بعد.",
  'Stay tuned!': 'ابقى على اطلاع!',
  'Today\'s Requests': 'طلبات اليوم',
  'Pending Lab Requests': 'الطلبات المعلقة',
  'Pending': 'معلق',
  'request': 'الطلبات',
  ''''''
      ''''''
      ''''''
      ''
      'Request Details': 'تفاصيل الطلب',
  'Cost:': 'التكلفة:',
  'Cost': 'التكلفة',
  'Image could not load.': 'تعذر تحميل الصورة.',
  'No Image Available': 'لا توجد صورة متاحة',
  'Doctor:': 'الطبيب:',
  'Patient:': 'المريض:',
  'Medical Tech:': 'فني طبي:',
  'Request Type:': 'نوع الطلب:',
  'Type:': 'النوع:',
  'Date:': 'التاريخ:',
  'Color:': 'اللون:',
  "doctor_title": "د.",
  'Request Date:': 'تاريخ الطلب:',
  'Delivery Date:': 'تاريخ التسليم:',
  'Completed & Updated Requests': 'الطلبات المكتملة والمحدثة',
  'Completed': 'مكتمل',
  'No update requests found.': 'لم يتم العثور على طلبات محدثة.',
  'Please check back later.': 'يرجى العودة لاحقاً.',
  'OK': 'موافق',
  'Update': 'تحديث',
  'Pick Image': 'اختر صورة',
  'send Date': 'تاريخ الإرسال',
  'Error picking images: ': 'خطأ في اختيار الصور:',
  'Delivery Date': 'تاريخ التوصيل',
  'Language': 'اللغة',
  'Theme': 'الثيم',
  'Logout': 'تسجيل الخروج',
      'Account': 'الحساب',
  'Log in as Laboratory': 'تسجيل الدخول كمختبر',
  'Enter your Lab Email': 'أدخل بريدك الإلكتروني للمختبر',
  'Enter your Lab password': 'أدخل كلمة مرور المختبر',
  'Continue as lab': 'استمر كمختبر',
  'There is an error': 'هناك خطأ',
  'done': 'تم',
  'Email and password cannot be empty':
      'لا يمكن أن يكون البريد الإلكتروني وكلمة المرور فارغين',
  'Error here': 'خطأ هنا',
  'loading...': 'جارٍ التحميل...',
  'Welcome': 'أهلاً وسهلاً',
  'welcome to our clinic! Please choose your role to proceed.':
      'مرحبًا بكم في عيادتنا! يرجى اختيار دورك للمتابعة.',
  'Patient': 'مريض',
  'Lab': 'مختبر',
  'No available times for the selected date.':
      'لا توجد أوقات متاحة للتاريخ المحدد.',
  'Select Appointment Time': 'حدد وقت الموعد',
};
