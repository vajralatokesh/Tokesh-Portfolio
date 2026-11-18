/**
 * ╔══════════════════════════════════════════════════════════════╗
 * ║  THE ONLY FILE YOU NEED TO EDIT FOR TEXT CONTENT             ║
 * ║  (images live in /public – see README.md)                    ║
 * ╚══════════════════════════════════════════════════════════════╝
 */

/* ───────────── 1. BASIC INFO ───────────── */
export const SITE = {
  name: 'Vajrala Tokesh', // shown in navbar, footer, hero, about
  pageTitle: 'Vajrala Tokesh – Software Engineer | Full-Stack & AI/IoT', // browser tab title
  role: 'Software Engineer · Full-Stack & AI/IoT', // footer subtitle
  email: 'tokeshvajrala@gmail.com',
  // digits only, with country code, no + or spaces (e.g. 919876543210)
  phone: '917337233543',
  whatsappMessage: 'Hi Tokesh, I saw your portfolio and would like to connect regarding an opportunity.',
  available: true,
};

/* ───────────── 2. HERO (top of page) ───────────── */
export const HERO = {
  eyebrow: 'SOFTWARE ENGINEER • FULL-STACK & AI/IOT',
  headline: 'VAJRALA TOKESH', // big text, use CAPS
  roles: ['SOFTWARE ENGINEER', 'AI & IOT DEVELOPER'] as [string, string],
  tagline: 'Final year B.Tech (CSE – IoT) student with 8.99 CGPA. Top 10 Finalist at Deloitte Hacksplosion (out of 21,866 participants) and Technology Intern at Deloitte.',
  primaryButton: 'EXPLORE MY WORK',
  secondaryButton: 'Get In Touch',
  image: '/assets/hero-tokesh.jpg', // 1920x1080, subject on the RIGHT side
  imageAlt: 'Portrait of Vajrala Tokesh',
  imagePosition: '69% center', // CSS object-position fallback
};

/* ───────────── 3. LOADING SCREEN ───────────── */
export const LOADER = {
  statement: 'ENGINEERING FULL-STACK APPLICATIONS, MACHINE LEARNING AND IOT SYSTEMS',
  redWords: ['APPLICATIONS', 'IOT'], // words highlighted in red
};

/* ───────────── 4. ABOUT ───────────── */
export const ABOUT = {
  eyebrow: 'Final Year B.Tech (CSE – IoT) · CGPA 8.99 / 10',
  portrait: '/media/tokesh-blazer.jpeg', // 4:5 portrait photo
  portraitAlt: 'Portrait of Vajrala Tokesh',
  portraitCaption: 'Software Engineer · Deloitte Intern', // small red text under the name on the photo
  paragraphs: [
    "I am a final year B.Tech student in Computer Science & Engineering (IoT) at Jain Deemed-to-be University, Bengaluru, graduating in 2027 with a CGPA of 8.99/10. I specialize in building and deploying production-ready full-stack applications, machine learning workflows, and connected IoT systems using Python, Flask, SQL, and Docker.",
    "Selected as a Top 10 Finalist at Deloitte Hacksplosion 2026 among 21,866 participants nationwide and 2nd Runner-Up at NOVATHON Hackathon 2024, I earned a Deloitte Technology Internship in Strategy, Risk & Transactions (Regulatory & Financial Risk). Eager to contribute to Agile software engineering teams.",
  ],
  technologies: ['Python', 'Flask', 'SQL', 'Docker', 'TensorFlow.js', 'React'],
  focus: ['Full-Stack Software Engineering', 'Applied Machine Learning & AI', 'IoT & Embedded Systems'],
};

/* ───────────── 5. SOCIAL LINKS (footer) ───────────── */
export const SOCIALS = [
  { id: 'github', label: 'GitHub', href: 'https://github.com/vajralatokesh' },
  { id: 'linkedin', label: 'LinkedIn', href: 'https://linkedin.com/in/tokesh-vajrala' },
] as const;

/* ───────────── 6. TECHNICAL SKILLS (6 cards) ───────────── */
export const SKILL_CARDS: { name: string; category: string; level: string }[] = [
  { name: 'Programming Languages', category: 'Python · Java · SQL (MySQL, T-SQL) · JavaScript · PHP', level: 'Advanced' },
  { name: 'Frameworks & ML', category: 'Flask · TensorFlow.js · Scikit-learn · NumPy · Pandas · Streamlit', level: 'Advanced' },
  { name: 'DevOps & Tooling', category: 'Docker · Git · GitHub · VS Code', level: 'Proficient' },
  { name: 'Data & Visualization', category: 'Power BI · Tableau · MS Excel', level: 'Proficient' },
  { name: 'IoT & Hardware Systems', category: 'Arduino Uno · GPS · GSM · Sensor Integration · Tinkercad', level: 'Proficient' },
  { name: 'AI & Data Science', category: 'Supervised Learning · Classification · Data Preprocessing · Neural Networks', level: 'Advanced' },
];

/* ───────────── 6b. TECH STACK STRIP (logos under the skills) ─────────────
 * Use names with a built-in logo: React, JavaScript, Python, FastAPI, PostgreSQL,
 * Supabase, SQLite, Three.js, GSAP. Any other name still shows as a lettered badge. */
export const TECH_STACK: string[] = ['Python', 'React', 'JavaScript', 'FastAPI', 'PostgreSQL', 'Docker', 'Three.js', 'GSAP'];

/* ───────────── 7. PROJECTS ─────────────
 * Thumbnails: put project-<n>-1.jpg, -2.jpg, -3.jpg in /public/assets/thumbnails/
 * (card cycles through 1-3). Set poster to the "-1.jpg" file.
 * Add liveUrl / repoUrl to show "View Live" / "View Code" buttons.
 * 6 or 9 projects fill the 3D grid best. */
export interface Project {
  id: string;
  title: string;
  category: string;
  categoryGroup?: 'ai' | 'web' | 'iot';
  award?: string;
  subtitle: string;
  videoUrl?: string;
  embedUrl?: string;
  driveUrl?: string;
  liveUrl?: string;
  repoUrl?: string;
  kind?: 'video' | 'software';
  poster?: string;
  description?: string;
  tags?: string[];
}

export const PORTFOLIO_PROJECTS: Project[] = [
  {
    id: 'aarogya-ai',
    kind: 'software',
    title: 'AAROGYA AI',
    subtitle: 'Early Disease Risk Prediction System • NOVATHON 2nd Runner-Up',
    category: 'AI & Healthcare',
    categoryGroup: 'ai',
    award: '🥈 2nd Runner-Up • NOVATHON 2024 (INR 10k)',
    poster: '/assets/thumbnails/project-1-1.jpg',
    description: 'Engineered an AI-powered healthcare web app predicting diseases from user symptoms using Scikit-learn classification models; integrated TensorFlow.js for real-time in-browser lung X-ray analysis. Containerized and deployed full-stack solution via Flask & Docker; secured 2nd Runner-Up at NOVATHON Hackathon 1.0 with a cash prize of INR 10,000.',
    tags: ['Python', 'Flask', 'TensorFlow.js', 'Scikit-learn', 'Docker'],
    liveUrl: 'https://aarogya-ai-09ha.onrender.com/',
    repoUrl: 'https://github.com/vajralatokesh',
  },
  {
    id: 'deloitte-ticket-triage',
    kind: 'software',
    title: 'Deloitte Autonomous Ticket Triage',
    subtitle: 'Top 10 Finalist (21,866 Participants) • Deloitte Internship Secured',
    category: 'Multi-Agent AI & GenAI',
    categoryGroup: 'ai',
    award: '🏆 Top 10 Finalist • 21.8k Competitors',
    poster: '/assets/thumbnails/project-2-1.jpg',
    description: 'Multi-Agent AI ticket triage system built using GenW.AI to autonomously parse, categorize, and route enterprise service desk requests. Selected among the Top 10 out of 21,866 participants nationwide at Deloitte Hacksplosion 2026, earning a Deloitte technology internship opportunity.',
    tags: ['Multi-Agent AI', 'GenW.AI', 'Python', 'LLMs', 'Deloitte'],
    repoUrl: 'https://github.com/vajralatokesh',
  },
  {
    id: 'ott-explorer',
    kind: 'software',
    title: 'OTT Explorer',
    subtitle: 'Movie & Anime Streaming Web Application',
    category: 'Full-Stack Web App',
    categoryGroup: 'web',
    poster: '/assets/thumbnails/project-3-1.jpg',
    description: 'Built a full-stack OTT platform with secure user authentication, personalized watchlists, and real-time content fetching via TMDB & Jikan REST APIs; optimized SQL queries for high reliability.',
    tags: ['Python', 'Flask', 'REST APIs', 'MySQL', 'HTML/CSS/JS'],
    liveUrl: 'https://ott-explo-3.onrender.com',
    repoUrl: 'https://github.com/vajralatokesh',
  },
  {
    id: 'smart-accident-detection',
    kind: 'software',
    title: 'Smart Vehicle Alert System',
    subtitle: 'IoT Accident Detection & Emergency Alert System',
    category: 'IoT & Embedded Systems',
    categoryGroup: 'iot',
    poster: '/assets/thumbnails/project-4-1.jpg',
    description: 'Developed an IoT accident-detection system that auto-transmits real-time GPS coordinates to emergency contacts on vehicular collision using accelerometer/vibration sensors and GSM-based SMS alerts on Arduino Uno.',
    tags: ['Arduino Uno', 'GPS', 'GSM', 'IoT', 'Sensors'],
    repoUrl: 'https://github.com/vajralatokesh',
  },
  {
    id: 'deloitte-risk-analytics',
    kind: 'software',
    title: 'Regulatory & Financial Risk Solutions',
    subtitle: 'Deloitte Strategy, Risk & Transactions (SR&T)',
    category: 'Enterprise & FinTech',
    categoryGroup: 'web',
    poster: '/assets/thumbnails/project-5-1.jpg',
    description: 'Technology-driven scalable solutions developed with Deloitte Regulatory & Financial Risk team, translating complex enterprise compliance and financial risk requirements into robust analytical data pipelines.',
    tags: ['Python', 'SQL', 'Risk Analytics', 'Power BI', 'Deloitte'],
    repoUrl: 'https://github.com/vajralatokesh',
  },
  {
    id: 'iot-sensor-integration',
    kind: 'software',
    title: 'IoT Sensor Integration & Hardware Lab',
    subtitle: 'Embedded Telemetry & Hardware Prototyping Suite',
    category: 'IoT & Hardware Systems',
    categoryGroup: 'iot',
    poster: '/assets/thumbnails/project-6-1.jpg',
    description: 'Embedded telemetry prototyping suite incorporating GPS, GSM, and multi-sensor acquisition on Arduino Uno and Tinkercad, executing low-latency sensor data acquisition and peripheral communications.',
    tags: ['Arduino Uno', 'Sensor Integration', 'Tinkercad', 'IoT', 'C++'],
    repoUrl: 'https://github.com/vajralatokesh',
  },
];

/* ───────────── 8. HEADLINE NUMBERS (under hero) ───────────── */
export const CLIENT_STATS = [
  { id: 'stat-1', value: 8.99, suffix: '/10', label: 'B.Tech CGPA · Jain University' },
  { id: 'stat-2', value: 21, suffix: 'k+', label: 'Deloitte Hacksplosion Pool (Top 10 Finalist)' },
  { id: 'stat-3', value: 10, suffix: '+', label: 'Projects Built & Deployed' },
] as const;

/* Derived – do not edit */
export const WHATSAPP_URL = `https://wa.me/${SITE.phone}?text=${encodeURIComponent(SITE.whatsappMessage)}`;
