document.onclick = (e) => {
  let dropdowns = document.getElementsByClassName("dropdown")
  for(let i = 0; i < dropdowns.length; i++){
    if(dropdowns[i].contains(e.target)) return;
  }
  let dropdownInput = document.querySelector('input[name="dropdown"]:checked');
  if(dropdownInput) dropdownInput.checked = false;
}

uncheckDropdown = ((id) => {
  let dropdownRecipe = document.getElementById(id);
  dropdownRecipe.checked = !dropdownRecipe.checked;
})