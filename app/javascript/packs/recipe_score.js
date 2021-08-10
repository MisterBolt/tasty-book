fillPercent = () => {
  let score = gon.avgScore;
  let decimal = score % 1;
  let percent = (decimal * 100)+"%";
  document.getElementById('stop1').setAttribute("offset", percent);
  document.getElementById('stop2').setAttribute("offset", percent);
}

starHighlight = () => {
  let starScore = document.getElementById('score-all');
  for (let i = 0; i < starScore.children.length; i++) {
    starScore.children[i].addEventListener('mouseenter', (e) => {
      fillStar(e.target);
      let prevSibling = e.target.previousElementSibling;
      while(prevSibling) {
        fillStar(prevSibling);
        prevSibling = prevSibling.previousElementSibling;
      }
    }); 
    starScore.children[i].addEventListener('mouseleave', (e) => {
      emptyStar(e.target);
      let prevSibling = e.target.previousElementSibling;
      while(prevSibling) {
        emptyStar(prevSibling);
        prevSibling = prevSibling.previousElementSibling;
      }
    });
    starScore.children[i].addEventListener('click', () => {
      let modal = document.getElementById('score-modal');
      modal.classList.remove('hidden');
      let starId = starScore.children[i].id;
      console.log(starId);
      fillScoreForm(starId);
    });
  }
}

fillScoreForm = (starId) => {
  let scoreFormField = document.getElementById('recipe_score[score]');
  let scoreDisplayed = document.getElementById('your-score');
  switch (starId) {
    case 'score-one':
      scoreFormField.setAttribute("value", 1);
      scoreDisplayed.innerHTML = 1;
      break;
    case 'score-two':
      scoreFormField.setAttribute("value", 2);
      scoreDisplayed.innerHTML = 2;
      break;
    case 'score-three':
      scoreFormField.setAttribute("value", 3);
      scoreDisplayed.innerHTML = 3;
      break;
    case 'score-four':
      scoreFormField.setAttribute("value", 4);
      scoreDisplayed.innerHTML = 4;
      break;
    case 'score-five':
      scoreFormField.setAttribute("value", 5);
      scoreDisplayed.innerHTML = 5;
      break;
  }
}

closeModal = () => {
  let cancelButton = document.getElementById('close-modal');
  cancelButton.addEventListener('click', () => {
    let modal = document.getElementById('score-modal');
    modal.classList.add('hidden');
  });
}

fillStar = (element) => {
  element.children[0].children[1].setAttribute('fill', "#c89c4c");
}

emptyStar = (element) => {
  element.children[0].children[1].setAttribute('fill', "#acb1b7");
}

document.addEventListener("turbo:load", () => {
  fillPercent();
  starHighlight();
  closeModal();
})
