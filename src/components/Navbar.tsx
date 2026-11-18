import React, { useState, useEffect } from 'react';
import { FileDown } from 'lucide-react';
import { SITE } from '../data/portfolioData';

export const Navbar: React.FC = () => {
  const [scrolled, setScrolled] = useState(false);

  useEffect(() => {
    const handleScroll = () => {
      setScrolled(window.scrollY > 50);
    };
    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  return (
    <nav className="fixed top-0 left-0 w-full z-50 px-3 md:px-6 pt-3">
      <div
        className={`glass max-w-7xl mx-auto rounded-2xl px-5 md:px-8 flex items-center justify-between transition-all duration-300 ${
          scrolled ? 'py-2.5 !bg-[#111113]/80' : 'py-3.5'
        }`}
      >
        <a
          href="/"
          className="text-white text-2xl font-black tracking-tight uppercase group flex items-center"
        >
          <span className="text-red-600 drop-shadow-[0_0_10px_rgba(220,38,38,0.8)]">
            {SITE.name.charAt(0)}
          </span>
          <span className="group-hover:text-red-500 transition-colors duration-300">
            {SITE.name.slice(1)}.
          </span>
        </a>

        <div className="hidden md:flex items-center gap-8">
          {['Projects', 'About', 'Skills', 'Contact'].map((item) => (
            <a
              key={item}
              href={`#${item.toLowerCase()}`}
              className="relative text-xs md:text-sm font-bold text-gray-400 uppercase tracking-[0.15em] transition-colors duration-300 hover:text-white group"
            >
              {item}
              <span className="absolute -bottom-2 left-0 w-0 h-[2px] bg-red-600 transition-all duration-300 ease-out group-hover:w-full shadow-[0_0_8px_rgba(220,38,38,0.8)]" />
            </a>
          ))}
        </div>

        {/* Action Buttons */}
        <div className="flex items-center gap-2 sm:gap-3">
          <a
            href="/Vajrala_Tokesh_Resume.pdf"
            download="Vajrala_Tokesh_Resume.pdf"
            target="_blank"
            rel="noopener noreferrer"
            className="glass-chip inline-flex items-center gap-1.5 px-3.5 py-1.5 sm:px-4 sm:py-2 rounded-full text-gray-200 hover:text-white text-xs font-bold uppercase tracking-wider transition-all duration-300 hover:scale-105 border border-white/10 hover:border-red-500/50 shadow-[0_0_12px_rgba(220,38,38,0.2)]"
          >
            <FileDown className="w-3.5 h-3.5 text-red-500" />
            <span>Resume</span>
          </a>
          <a
            href="#contact"
            className="glass-red hidden sm:inline-block px-5 py-2 rounded-full text-white text-xs font-bold uppercase tracking-wider"
          >
            Let's Talk
          </a>
        </div>
      </div>
    </nav>
  );
};
