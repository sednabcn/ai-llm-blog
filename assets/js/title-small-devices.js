document.addEventListener('DOMContentLoaded', function() {
    const titleElement = document.querySelector('h1.blog-title');

    if (!titleElement) return;
      
    if (window.innerWidth <= 768) {  // Small device
          if (titleElement) {
	      titleElement.innerHTML = `
      <span class="title-part">AI, LLM &</span>
      <span class="no-break-hyphen">LLM-HypatiaX</span>
      <span class="title-part">Blog</span>
    `;
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
