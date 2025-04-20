document.addEventListener("DOMContentLoaded", function () {
  document.querySelectorAll(".category-toggle").forEach((header) => {
    header.addEventListener("click", function () {
      const targetId = this.getAttribute("data-target");
      const target = document.getElementById(targetId);
      if (target.style.display === "none") {
        target.style.display = "block";
      } else {
        target.style.display = "none";
      }
    });
  });
});
