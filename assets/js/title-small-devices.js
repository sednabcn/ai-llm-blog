 document.addEventListener('DOMContentLoaded', function() {
      const titleElement = document.querySelector('h1');
      
      if (window.innerWidth <= 768) {  // Small device
          if (titleElement) {
	      titleElement.innerHTML = `AI, LLM & <span class="no-break-hyphen">LLM-HypatiaX</span> Blog`;
        }
      } else {  // Large device
        if (titleElement) {
          titleElement.innerHTML = "<span class='no-break'>AI, LLM & LLM-HypatiaX Blog</span>";
        }
      }
    });
.no-break-hyphen {
  white-space: nowrap;
}
