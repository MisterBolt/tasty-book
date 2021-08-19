toggleColor = ((elementId, from = "bg-white", to = "bg-yellow-200", hover = "hover:bg-yellow-100") => {
  element = document.getElementById(elementId);
  element.classList.toggle(from);
  element.classList.toggle(hover);
  element.classList.toggle(to);  
})
