// Default to light mode, get saved theme from localStorage
let commentsLoaded = false;
let currentTheme = localStorage.getItem('theme') || 'light';  

// Initialize theme on page load
document.addEventListener('DOMContentLoaded', () => {
  setTheme(currentTheme);
  loadCommentsWithTheme();
});

// Function to toggle between dark and light theme
function toggleTheme() {
  currentTheme = currentTheme === 'light' ? 'dark' : 'light';
  setTheme(currentTheme);
  localStorage.setItem('theme', currentTheme);
  loadCommentsWithTheme(); // Load comments with the new theme
}

// Set the theme on the body
function setTheme(theme) {
  const body = document.body;
  body.classList.toggle('dark-mode', theme === 'dark');
}

// Function to load comments with the correct theme
function loadCommentsWithTheme() {
  const theme = currentTheme === 'dark' ? 'github-dark' : 'github-light';
  const commentsContainer = document.getElementById('utterances-comments');
  
  // Clear previous comments and add new script with updated theme
  commentsContainer.innerHTML = '';
  const script = document.createElement('script');
  script.src = 'https://utteranc.es/client.js';
  script.repo = 'sednabcn/ai-llm-blog';
  script.issueTerm = 'pathname';
  script.theme = theme;
  script.crossOrigin = 'anonymous';
  script.async = true;
  commentsContainer.appendChild(script);
}

// Function to toggle visibility of the comment section
function toggleComments() {
  const section = document.getElementById('comments-section');
  section.style.display = section.style.display === 'none' ? 'block' : 'none';

  // Load comments only when they are shown and not already loaded
  if (section.style.display === 'block' && !commentsLoaded) {
    loadCommentsWithTheme();
    commentsLoaded = true;
  }
}
