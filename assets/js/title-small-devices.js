 document.addEventListener('DOMContentLoaded', function() {
      const titleElement = document.querySelector('h1');
      
      if (window.innerWidth <= 768) {  // Small device
        if (titleElement) {
          titleElement.innerHTML = "AI, LLM & <span class='no-break'>LLM-HypatiaX Blog</span>";
        }
      } else {  // Large device
        if (titleElement) {
          titleElement.innerHTML = "<span class='no-break'>AI, LLM & LLM-HypatiaX Blog</span>";
        }
      }
    });
