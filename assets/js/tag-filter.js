document.addEventListener("DOMContentLoaded", function() {
  // Function to handle filtering based on hash
  function filterByHash() {
    const hash = window.location.hash.substring(1); // Remove the # symbol
    
    // Get all tag sections
    const tagSections = document.querySelectorAll('.tag-block');
    
    // If there's a hash in the URL
    if (hash) {
      // Flag to track if we found a matching section
      let foundMatch = false;
      
      // Check each section
      tagSections.forEach(function(section) {
        if (section.id === hash) {
          // Show the matching section
          section.style.display = 'block';
          foundMatch = true;
          
          // Add a "show all" button if it doesn't exist yet
          if (!document.getElementById('show-all-btn')) {
            const showAllBtn = document.createElement('button');
            showAllBtn.id = 'show-all-btn';
            showAllBtn.textContent = 'Show All Tags';
            showAllBtn.style.cssText = 'padding: 8px 16px; background: #5c00c7; color: white; border: none; border-radius: 4px; margin: 20px 0; cursor: pointer;';
            
            showAllBtn.addEventListener('click', function() {
              // Remove hash from URL without page reload
              history.pushState("", document.title, window.location.pathname + window.location.search);
              
              // Show all sections
              tagSections.forEach(section => section.style.display = 'block');
              
              // Remove the button
              this.remove();
            });
            
            // Insert before the first tag block
            const mainContent = document.querySelector('.main-content');
            mainContent.insertBefore(showAllBtn, document.querySelector('.tag-block'));
          }
        } else {
          // Hide non-matching sections
          section.style.display = 'none';
        }
      });
      
      // If no matching section was found, show all
      if (!foundMatch) {
        tagSections.forEach(section => section.style.display = 'block');
      }
    } else {
      // No hash, show all sections
      tagSections.forEach(section => section.style.display = 'block');
      
      // Remove "show all" button if it exists
      const showAllBtn = document.getElementById('show-all-btn');
      if (showAllBtn) {
        showAllBtn.remove();
      }
    }
  }
  
  // Run filter on page load
  filterByHash();
  
  // Listen for hash changes (when user clicks links or uses browser navigation)
  window.addEventListener('hashchange', filterByHash);
});
