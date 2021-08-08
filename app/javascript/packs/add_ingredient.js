function addIngredient(){
    const submit = document.getElementById("add_ingredient");
  const ingredientList = document.getElementById("ingredients");

    const ingredient = document.getElementById("recipe_ingredients_recipe_ingredient_id");  
    const unit = document.getElementById("recipe_ingredients_recipe_unit");
    const quantity = document.getElementById("recipe_ingredients_recipe_quantity");
    const ingredients = []
    submit.addEventListener('click', e=>{
        e.preventDefault();
        
        if(ingredient.value == ""){
            return
        }
        
        if(quantity.value == ""){
            quantity.value = 1;
        }

        //Write values to hidden input with JSON
        let ingredientSet = {
            ingredient: ingredient.value,
            unit: unit.value,
            quantity: quantity.value
        }
        ingredients.push(ingredientSet);
        let json = JSON.stringify(ingredients);

        //Add DOM element for added ingredient
        let newItem = document.createElement("li");
        let unitStr = unit.options[unit.selectedIndex].text;
        if(quantity.value > 1){
            unitStr = unitStr + "s";
        }
        let span = document.createElement("span");
        span.innerText = ingredient.options[ingredient.selectedIndex].text
        newItem.appendChild(span);
        newItem.innerHTML += " " + quantity.value + " " + unitStr;
        let deleteButton = document.createElement('button');
        deleteButton.innerText = "X";
        deleteButton.addEventListener("click", e=>{deleteIngredient(e)})
        newItem.appendChild(deleteButton);
        ingredientList.appendChild(newItem);

        //Delete ingredient from ingredient
        let childCount = ingredient.childElementCount;
        ingredient.childNodes.forEach(item=>{
            if(ingredients.some(i => i.ingredient === item.value)){
                item.style.display = "none";
                childCount--;
            }
        })
        if(childCount == 0){
            ingredient.value = "";
            ingredient.disabled = true;
        }

    })
}

function deleteIngredient(e){
    e.preventDefault();
    
    const ingredientList = document.getElementById("ingredients");
    const ingredient = document.getElementById("recipe_ingredients_recipe_ingredient_id");
    const li = e.target.parentNode;

    ingredientList.removeChild(li);

    ingredient.childNodes.forEach(i=>{
        if(i.innerText == li.getElementsByTagName('span')[0].innerText){
            i.style.display = 'block';
            if(ingredient.disabled == true){
                ingredient.disabled = false
                ingredient.selectedIndex = 0
            }
        }
    })
}

window.onload = addIngredient;