
document.getElementById('subscribeForm').addEventListener('submit', function(e) {
      e.preventDefault();
      const name = document.getElementById('name').value;
      const email = document.getElementById('email').value;
      
      // In a real implementation, you would send this data to your server
      alert(`Thank you, ${name}! Your subscription with email ${email} has been received. You'll hear from us soon.`);
      
      // Reset form
      this.reset();
});
 
