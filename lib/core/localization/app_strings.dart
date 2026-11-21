class AppStrings {
  const AppStrings(this.isAmharic);

  final bool isAmharic;

  String get brand => 'Edu Ethiopia';
  String get home => isAmharic ? 'መነሻ' : 'Home';
  String get languageLabel => isAmharic ? 'English' : 'አማርኛ';
  String get languageTooltip => isAmharic ? 'Switch to English' : 'ወደ አማርኛ ቀይር';
  String get welcomeEyebrow =>
      isAmharic ? 'ለአዲስ ተማሪዎች እና ፕሪ-ኢንጂነሪንግ' : 'FRESHMAN + PRE-ENGINEERING';
  String get welcomeTitle => isAmharic
      ? 'የሚፈልጉትን ዲፓርትመንት ለማግኘት ይዘጋጁ።'
      : 'Prepare for the department you want.';
  String get welcomeSubtitle => isAmharic
      ? 'በእውነተኛ ማስታወሻዎች፣ በCOC ፈተናዎች እና በግልጽ የጥናት መንገድ።'
      : 'Real materials, COC exams, and a clear study path to help you move forward.';
  String get freshmanPrep =>
      isAmharic ? 'ፍሬሽማን + ፕሪ-ኢንጂነሪንግ' : 'Freshman + Pre-Eng.';
  String get cocExams => isAmharic ? 'የCOC ፈተናዎች' : 'COC exams';
  String get realMaterials => isAmharic ? 'እውነተኛ ማስታወሻዎች' : 'Real materials';
  String get notes => isAmharic ? 'ማስታወሻዎች' : 'Notes';
  String get quizzes => isAmharic ? 'ጥያቄዎች' : 'Quizzes';
  String get midExams => isAmharic ? 'ሚድ ፈተና' : 'Mid Exams';
  String get finalExams => isAmharic ? 'የመጨረሻ' : 'Finals';
  String get videos => isAmharic ? 'ቪዲዮዎች' : 'Videos';
  String get aiAssistant => isAmharic ? 'AI እገዛ' : 'AI Help';
  String get dashboardTitle => isAmharic ? 'የጥናት ማዕከል' : 'Study hub';
  String get dashboardSubtitle => isAmharic
      ? 'የትምህርት ሞጁሎችዎን እና ማስታወሻዎችዎን ይክፈቱ።'
      : 'Your modules, notes, videos, and exams in one place.';
  String get previewMode => isAmharic ? 'የሙከራ ሁኔታ' : 'Preview mode';
  String get previewNotice => isAmharic
      ? 'ይህ የመጀመሪያ የመድረክ ቅድመ እይታ ነው።'
      : 'This is an early platform preview. Content access comes with backend integration.';
  String get menu => isAmharic ? 'ምናሌ' : 'Menu';
  String get settings => isAmharic ? 'ቅንብሮች' : 'Settings';
  String get profile => isAmharic ? 'መገለጫ' : 'Profile';
  String get signOut => isAmharic ? 'ውጣ' : 'Sign out';
  String get modules => isAmharic ? 'ሞጁሎች' : 'Modules';
  String get exams => isAmharic ? 'ፈተናዎች' : 'Exams';
  String get notesDescription =>
      isAmharic ? 'ኮርስ ማስታወሻዎች እና ምዕራፎች' : 'Course notes and chapters';
  String get modulesDescription =>
      isAmharic ? 'ኮርሶች እና ትምህርቶች' : 'Courses and subjects';
  String get videosDescription =>
      isAmharic ? 'የትምህርት ቪዲዮዎች' : 'Lessons and study videos';
  String get examsDescription =>
      isAmharic ? 'ሚድ፣ ፍጻሜ እና COC' : 'Mid, Final, and COC';
  String get aiDescription =>
      isAmharic ? 'የትምህርት AI እገዛ' : 'Ask, understand, improve';
  String get settingsTitle => isAmharic ? 'የመተግበሪያ ቅንብሮች' : 'App settings';
  String get settingsNotice => isAmharic
      ? 'የመለያ እና የመተግበሪያ ቅንብሮች ከኋላ መሠረተ ልማት ጋር ይገናኛሉ።'
      : 'Account and app preferences will be connected to the backend.';
  String get modulePreview => isAmharic ? 'የሞጁል ቅድመ እይታ' : 'Module preview';
  String get aiTitle => isAmharic ? 'የትምህርት AI እገዛ' : 'Academic AI Help';
  String get aiNotice => isAmharic
      ? 'ጥያቄዎን ያስገቡ። የAI አገልግሎቱ ከኋላ መሠረተ ልማት ጋር ይገናኛል።'
      : 'Ask a study question. The AI service will connect through the backend.';
  String get askQuestion =>
      isAmharic ? 'ጥያቄዎን ይጻፉ...' : 'Ask a study question...';
  String get continueLabel => isAmharic ? 'መማር ይጀምሩ' : 'Start learning';
  String get authBackendNotice => isAmharic
      ? 'የመግቢያ አገልግሎቱ ከኋላ መሠረተ ልማት ጋር ይገናኛል።'
      : 'Authentication will connect to the secure backend in the next step.';
  String get loginTitle => isAmharic ? 'ወደ መለያዎ ይግቡ' : 'Welcome back';
  String get signupTitle =>
      isAmharic ? 'የተማሪ መለያ ይፍጠሩ' : 'Create your student account';
  String get loginSubtitle => isAmharic
      ? 'የትምህርት ማዕከልዎን ለመቀጠል ይግቡ።'
      : 'Pick up where you left off in your learning journey.';
  String get signupSubtitle => isAmharic
      ? 'ዩኒቨርሲቲዎን ያስመዝግቡ እና የትምህርት ቦታዎን ያዘጋጁ።'
      : 'Tell us where you study so your learning space starts in the right place.';
  String get loginTab => isAmharic ? 'ግባ' : 'Log in';
  String get signupTab => isAmharic ? 'መለያ ፍጠር' : 'Sign up';
  String get fullName => isAmharic ? 'ሙሉ ስም' : 'Full name';
  String get university => isAmharic ? 'ዩኒቨርሲቲ' : 'University';
  String get universityHint =>
      isAmharic ? 'ዩኒቨርሲቲዎን ይምረጡ' : 'Choose your university';
  String get email => isAmharic ? 'የኢሜይል አድራሻ' : 'Email address';
  String get password => isAmharic ? 'የይለፍ ቃል' : 'Password';
  String get forgotPassword => isAmharic ? 'የይለፍ ቃልዎን ረሱ?' : 'Forgot password?';
  String get loginAction => isAmharic ? 'ይግቡ' : 'Log in';
  String get signupAction => isAmharic ? 'መለያ ይፍጠሩ' : 'Create account';
  String get invalidName => isAmharic ? 'ሙሉ ስምዎን ያስገቡ' : 'Enter your full name';
  String get invalidUniversity =>
      isAmharic ? 'ዩኒቨርሲቲዎን ይምረጡ' : 'Choose your university';
  String get invalidEmail =>
      isAmharic ? 'ትክክለኛ ኢሜይል ያስገቡ' : 'Enter a valid email address';
  String get invalidPassword =>
      isAmharic ? 'ቢያንስ 8 ቁምፊዎችን ይጠቀሙ' : 'Use at least 8 characters';
  String get recoveryNotice => isAmharic
      ? 'የይለፍ ቃል መመለሻ በኋላ ይገናኛል።'
      : 'Password recovery will connect to the backend.';
}
