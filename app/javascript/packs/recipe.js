let loadRecipeTabContent = () => {
  let recipe_nav = document.getElementById('recipe-nav');
  for (let i = 0; i < recipe_nav.children.length; i++) { 
    recipe_nav.children[i].addEventListener('click', (e) => {
      Array.from(e.target.parentNode.children).filter(el => el !== e).forEach((sibling) => sibling.classList.remove('selected'));
      e.target.classList.add('selected');
      displayContent(e.target.id);
    });
  }
}
 
let displayContent = (button_id) => {
  let ingredients = document.getElementById('ingredients-content');
  let method = document.getElementById('method-content');
  let comments = document.getElementById('comments-content');

  switch (button_id) {
    case 'ingredients-button':
      ingredients.classList.remove('hidden');
      Array.from(ingredients.parentNode.children).filter(el => el !== ingredients).forEach((sibling) => sibling.classList.add('hidden'));
      break;
    case 'method-button':
      method.classList.remove('hidden');
      Array.from(method.parentNode.children).filter(el => el !== method).forEach((sibling) => sibling.classList.add('hidden'));
      break;
    case 'comments-button':
      comments.classList.remove('hidden');
      Array.from(comments.parentNode.children).filter(el => el !== comments).forEach((sibling) => sibling.classList.add('hidden'));
      break;
  }
}

document.addEventListener("turbolinks:load", () => {
  loadRecipeTabContent();
})
