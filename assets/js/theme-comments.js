<!-- HTML: Add a button to toggle dark/light mode -->
<button onclick="toggleTheme()">Toggle Dark/Light Mode</button>

<!-- Comment Section -->
<button onclick="toggleComments()">💬 Show/Hide Comments</button>
<section id="comments-section" style="display: none;">
  <h2>💬 Comments</h2>
  <div id="utterances-comments"></div>
</section>

<!-- JavaScript for Dark/Light Mode Toggle and Comment Section -->
<script>
  let commentsLoaded = false;
  let currentTheme = localStorage.getItem('theme') || 'light';  // Default to light mode

  // Function to toggle dark/light theme
  function toggleTheme() {
    const body = document.body;
    if (currentTheme === 'light') {
      body.classList.add('dark-mode');
      currentTheme = 'dark';
      localStorage.setItem('theme', 'dark');
    } else {
      body.classList.remove('dark-mode');
      currentTheme = 'light';
      localStorage.setItem('theme', 'light');
    }
    loadCommentsWithTheme();
  }

  // Function to load comments with the correct theme
  function loadCommentsWithTheme() {
    const theme = currentTheme === 'dark' ? 'github-dark' : 'github-light';
    const script = document.createElement('script');
    script.src = 'https://utteranc.es/client.js';
    script.repo = 'sednabcn/ai-llm-blog';
    script.issueTerm = 'pathname';
    script.theme = theme;  // Use dynamic theme
    script.crossOrigin = 'anonymous';
    script.async = true;
    document.getElementById('utterances-comments').innerHTML = '';  // Clear previous script
    document.getElementById('utterances-comments').appendChild(script);
  }

  // Function to toggle the visibility of the comment section
  function toggleComments() {
    const section = document.getElementById('comments-section');
    if (section.style.display === 'none') {
      section.style.display = 'block';
      if (!commentsLoaded) {
        loadCommentsWithTheme();  // Load comments with the current theme
        commentsLoaded = true;
      }
    } else {
      section.style.display = 'none';
    }
  }

  // Initially load comments with the correct theme on page load
  loadCommentsWithTheme();
</script>
