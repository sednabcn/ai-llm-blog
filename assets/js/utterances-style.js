// Add this script after your Utterances script
document.addEventListener('DOMContentLoaded', function() {
  // Function to apply styles to Utterances iframe once it loads
  function styleUtterances() {
    const utterancesFrame = document.querySelector('.utterances-frame');
    
    // If the frame exists and is loaded
    if (utterancesFrame && utterancesFrame.contentDocument) {
      // Create a style element
      const style = document.createElement('style');
      
      // Add your custom CSS
      style.textContent = `
        /* Base styles */
        body {
          font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif;
          background-color: #ffffff;
        }
        
        /* Comment styling */
        .timeline-comment {
          border: 1px solid #e1e4e8;
          border-radius: 6px;
        }
        
        .comment-header {
          background-color: #f6f8fa;
          padding: 8px 16px;
        }
        
        .comment-body {
          padding: 16px;
        }
        
        /* Button styling */
        .btn-primary {
          background-color: #8bc34a;
          border-color: #8bc34a;
        }
        
        .btn-primary:hover {
          background-color: #7cb342;
          border-color: #7cb342;
        }
        
        /* Add more custom styles as needed */
      `;
      
      // Add the style to the iframe document
      utterancesFrame.contentDocument.head.appendChild(style);
    }
  }
  
  // Check for the iframe - it might load after this script runs
  let checkInterval = setInterval(function() {
    const utterancesFrame = document.querySelector('.utterances-frame');
    if (utterancesFrame) {
      clearInterval(checkInterval);
      
      // Wait for the iframe content to load
      utterancesFrame.addEventListener('load', styleUtterances);
      
      // Also try immediately in case it's already loaded
      styleUtterances();
    }
  }, 300);
  
  // Stop checking after 10 seconds to avoid infinite checking
  setTimeout(function() {
    clearInterval(checkInterval);
  }, 10000);
});
