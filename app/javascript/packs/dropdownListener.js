document.onclick = (e) => {
  dropdowns = document.getElementsByClassName("dropdown")
  for(let i = 0; i < dropdowns.length; i++){
    if(dropdowns[i].contains(e.target)) return;
  }
  document.querySelector('input[name="dropdown"]:checked').checked = false;
}