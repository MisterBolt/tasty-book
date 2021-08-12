

// const ingredients = [];

// function addIngredient(){
//     const submit = document.getElementById("add_ingredient");

//     const ingredient = document.getElementById("recipe_ingredients_recipe_ingredient"); 
//     const unit = document.getElementById("recipe_ingredients_recipe_unit");
//     const quantity = document.getElementById("recipe_ingredients_recipe_quantity");

//     submit.addEventListener('click', e=>{
//         e.preventDefault();
        
//         let seletedOption = document.querySelector(`option[value="${ingredient.value}"]`);
//         try{
//             var ingredient_id = seletedOption.getAttribute("data_ingredient_id")
//         }catch{
//             var ingredient_id = null
//         }

//         if(ingredient.value == "" || quantity.value == ""){
//             return
//         }

//         //Write values to main array
//         let ingredientSet = {
//             ingredient: parseInt(ingredient_id),
//             ingredientName: ingredient.value,
//             unit: parseInt(unit.value),
//             unitName: unit[unit.selectedIndex].text,
//             quantity: parseFloat(quantity.value)
//         }
//         ingredients.push(ingredientSet);

//         //Add DOM element for added ingredient
//         createIngredientItem(ingredientSet);

//         updateInputValueWithJSON();
//     })

// }

// function deleteIngredient(e){
//     e.preventDefault();
    
//     let submit = document.getElementById("add_ingredient");
//     let ingredientList = document.getElementById("ingredients");
//     let ingredient = document.getElementById("recipe_ingredients_recipe_ingredient");
//     let li = e.target.parentNode;

//     //Delete ingredient from ingredients list
//     ingredientList.removeChild(li);

//     if(ingredientList.childElementCount == 0){
//         let p = document.createElement("p");
//         p.innerText = "There are no ingredients";
//         ingredientList.appendChild(p);
//     }

//     //Update JSON 
//     let id = li.getAttribute("ingredient_id");
//     for(let i=0;i<ingredients.length;i++){
//         if(ingredients[i].ingredient == id){
//             ingredients.splice(i,1);
//         }
//     }

//     updateInputValueWithJSON();
// }

// function updateInputValueWithJSON(){
//     let hiddenInput = document.getElementById("recipe_ingredients");
//     let json = JSON.stringify(ingredients);
//     hiddenInput.value = json;
// }

// function createIngredientItem(ingredientObj){
//     let ingredientList = document.getElementById("ingredients");

//     let newItem = document.createElement("li");
//     newItem.setAttribute("class", "space-x-2 justify-center");
//     let unitStr = ingredientObj.unitName;
//     if(ingredientObj.quantity > 1){
//         unitStr = unitStr + "s";
//     }
//     //Ingredient name
//     let ingredientSpan = document.createElement("span")
//     ingredientSpan.innerText = ingredientObj.ingredientName;
//     newItem.appendChild(ingredientSpan);
//     //Qunatity + unit
//     let qunatitySpan = document.createElement("span");
//     qunatitySpan.innerText = ingredientObj.quantity + " " + unitStr;
//     newItem.appendChild(qunatitySpan);

//     newItem.setAttribute("ingredient_id", ingredientObj.ingredient);
//     //Delete button
//     let deleteButton = document.createElement('button');
//     deleteButton.innerText = "X";
//     deleteButton.setAttribute('class', "bg-red-500 hover:bg-red-400 text-white font-bold px-2 border-b-4 border-red-700 hover:border-red-500 rounded")
//     deleteButton.addEventListener("click", e=>{deleteIngredient(e)})
//     newItem.appendChild(deleteButton);

//     if(ingredientList.childElementCount == 1 && ingredientList.firstChild.nodeName == 'P'){
//         ingredientList.innerHTML = "";
//     }

//     ingredientList.appendChild(newItem);
// }

// function currentState(){ 
//     //Read current state and implement it
//     let ingredientList = document.getElementById("ingredients");
//     let state = JSON.parse(document.getElementById("recipe_ingredients").value);
//     if(state.length == 0){
//         let p = document.createElement("p");
//         p.innerText = "There are no ingredients";
//         ingredientList.appendChild(p);
//     }
    
//     state.forEach(ingr => {
//         createIngredientItem(ingr);
//         ingredients.push(ingr);
//     })
// }

// currentState();
// addIngredient();

document.querySelectorAll("a[data-form-prepend]").forEach(i => {
    i.addEventListener("click", e=>{
        e.preventDefault()
        let obj = document.createElement('fieldset')
        let newIndex = new Date().getTime()
        obj.innerHTML = i.getAttribute("data-form-prepend").replaceAll("FIELDSET_INDEX", newIndex);
        obj.querySelector(".delete-ingredient").addEventListener('click', e=>{
            e.preventDefault()
            e.target.parentNode.parentNode.style.display = 'none';
            e.target.parentNode.querySelector("input[name='_destroy']").value = '1';
        })
        let hidden_input = document.createElement("input");
        hidden_input.name = "_destroy"
        hidden_input.value = '0'
        hidden_input.hidden = true
        obj.appendChild(hidden_input);
        i.parentNode.insertBefore(obj, i);
    })
})
