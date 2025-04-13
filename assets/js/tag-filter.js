document.addEventListener("DOMContentLoaded", function () {
  const hash = window.location.hash.substring(1);
  if (hash) {
    const allSections = document.querySelectorAll(".tag-block");
    let matched = false;

    allSections.forEach(section => {
      if (section.id === hash) {
        section.style.display = "block";
        matched = true;
      } else {
        section.style.display = "none";
      }
    });

    if (matched) {
      const tagIntro = document.querySelector(".tag-intro");
      if (tagIntro) tagIntro.style.display = "none";
    }
  }
});
