
document.addEventListener('DOMContentLoaded', function() {
  // Function to handle title formatting on small devices
  function formatTitleForSmallDevices() {
    // Get the blog title element
    const titleElement = document.querySelector('.blog-title, h1');
    
    // Check if we found the title element
    if (!titleElement) return;
    
    // Get the original title text
    const originalTitle = titleElement.innerText || titleElement.textContent;
    
    // Check if we're on a small device (max-width: 768px is common for mobile)
    if (window.innerWidth <= 768) {
      // If the title contains "AI, LLM & LLM-HypatiaX Blog"
      if (originalTitle.includes('AI, LLM & LLM-HypatiaX Blog')) {
        // Replace with split version using a line break
        titleElement.innerHTML = 'AI, LLM & <br>LLM-HypatiaX Blog';
      }
    } else {
      // On larger screens, restore the original title without line break
      if (originalTitle.includes('AI, LLM & ') && originalTitle.includes('LLM-HypatiaX Blog')) {
        titleElement.innerHTML = 'AI, LLM & LLM-HypatiaX Blog';
      }
    }
  }

  // Run on page load
  formatTitleForSmallDevices();
  
  // Also run when the window is resized
  window.addEventListener('resize', formatTitleForSmallDevices);
});

.no-break-hyphen {
  white-space: nowrap;
}
