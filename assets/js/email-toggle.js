

  function handleEmailClick() {
    try {
      // Attempt to open email client
      window.location.href = "mailto:info@modelphysmat.com";
      
      // Optional: If fallback needed after a delay (if email client fails to launch)
      setTimeout(() => {
        const confirmUseForm = confirm("If your email app didn't open, would you like to use our form instead?");
        if (confirmUseForm) {
          document.getElementById('fallbackForm').style.display = 'block';
        }
      }, 1000);
    } catch (err) {
      // If mail client fails (e.g., in browser without mailto support)
      alert("Your email app couldn't open. Use the form below.");
      document.getElementById('fallbackForm').style.display = 'block';
    }
  }

