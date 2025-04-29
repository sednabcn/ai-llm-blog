
document.addEventListener('DOMContentLoaded', function() {
  // Function to handle title formatting on various screen sizes
  function formatResponsiveTitle() {
    // Get the blog title element - using more generic selectors to find it
    const titleElement = document.querySelector('.blog-title, h1.page__title, .site-title');
    
    // Debug - check if we found the title element
    if (!titleElement) {
      console.log('Title element not found. Check your selectors.');
      return;
    }
    
    console.log('Found title element:', titleElement);
    
    // Get the original title text
    const originalTitle = titleElement.innerText || titleElement.textContent;
    console.log('Original title:', originalTitle);
    
    // Check screen width and apply appropriate formatting
    if (window.innerWidth <= 1024) { // This covers mobile phones, tablets, and small laptops
      // If the title contains "AI, LLM & LLM-HypatiaX Blog"
      if (originalTitle.includes('AI, LLM & LLM-HypatiaX Blog')) {
        console.log('Formatting title for small/medium device');
        
        // For very small screens (phones)
        if (window.innerWidth <= 480) {
          titleElement.innerHTML = 'AI, LLM &amp; <br>LLM-HypatiaX <br>Blog';
        }
        // For small tablets/large phones
        else if (window.innerWidth <= 767) {
          titleElement.innerHTML = 'AI, LLM &amp; <br>LLM-HypatiaX Blog';
        }
        // For tablets and small laptops
        else {
          titleElement.innerHTML = 'AI, LLM &amp; <br>LLM-HypatiaX Blog';
        }
      }
    } else {
      // On larger screens, restore the original title without line breaks
      if (originalTitle.includes('AI, LLM & ') && originalTitle.includes('LLM-HypatiaX Blog')) {
        console.log('Restoring original title format for large screen');
        titleElement.innerHTML = 'AI, LLM &amp; LLM-HypatiaX Blog';
      }
    }
    
    // Apply no-break classes to specific parts if needed
    const titleParts = titleElement.querySelectorAll('span');
    titleParts.forEach(part => {
      if (part.textContent.includes('LLM-HypatiaX')) {
        part.classList.add('no-break-hyphen');
      }
    });
  }

  // Run on page load
  formatResponsiveTitle();
  
  // Run when the window is resized
  window.addEventListener('resize', formatResponsiveTitle);
  
  // Add a small delay to ensure the DOM is fully loaded
  setTimeout(formatResponsiveTitle, 500);
  
  // Also run when orientation changes (important for tablets)
  window.addEventListener('orientationchange', formatResponsiveTitle);
});

