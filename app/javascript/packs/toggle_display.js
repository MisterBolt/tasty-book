toggle_display = ((elementId, intoClass = "fixed") => {
  document.getElementById(elementId).classList.toggle("hidden");
  document.getElementById(elementId).classList.toggle(intoClass);
})
