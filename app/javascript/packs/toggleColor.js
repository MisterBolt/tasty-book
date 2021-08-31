toggleColor = ((elementId, unclicked = "bg-gray-200", clicked = "bg-gray-300") => {
  element = document.getElementById(elementId);
  element.classList.toggle(unclicked);
  element.classList.toggle(clicked);
  element.classList.toggle("hover:"+unclicked);
  element.classList.toggle("hover:"+clicked);
})
