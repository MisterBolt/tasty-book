fillPercent = () => {
  let score = gon.avgScore;
  let decimal = score % 1;
  let percent = (decimal * 100)+"%";
  document.getElementById('stop1').setAttribute("offset", percent);
  document.getElementById('stop2').setAttribute("offset", percent);
}

starHighlight = () => {
  let star_score = document.getElementById('score-all');
  for (let i = 0; i < star_score.children.length; i++) {
    star_score.children[i].addEventListener('mouseenter', (e) => {
      fillStar(e.target);
      let prevSibling = e.target.previousElementSibling;
      while(prevSibling) {
        fillStar(prevSibling);
        prevSibling = prevSibling.previousElementSibling;
      }
    }); 
    star_score.children[i].addEventListener('mouseleave', (e) => {
      emptyStar(e.target);
      let prevSibling = e.target.previousElementSibling;
      while(prevSibling) {
        emptyStar(prevSibling);
        prevSibling = prevSibling.previousElementSibling;
      }
    });
    star_score.children[i].addEventListener('click', () => {
      let modal = document.getElementById('score-modal');
      modal.classList.remove('hidden');
      let star_id = star_score.children[i].id;
      console.log(star_id);
      fillScoreForm(star_id);
    });
  }
}

fillScoreForm = (star_id) => {
  let score_form_field = document.getElementById('recipe_score[score]');
  let score_displayed = document.getElementById('your-score');
  switch (star_id) {
    case 'score-one':
      score_form_field.setAttribute("value", 1);
      score_displayed.innerHTML = 1;
      break;
    case 'score-two':
      score_form_field.setAttribute("value", 2);
      score_displayed.innerHTML = 2;
      break;
    case 'score-three':
      score_form_field.setAttribute("value", 3);
      score_displayed.innerHTML = 3;
      break;
    case 'score-four':
      score_form_field.setAttribute("value", 4);
      score_displayed.innerHTML = 4;
      break;
    case 'score-five':
      score_form_field.setAttribute("value", 5);
      score_displayed.innerHTML = 5;
      break;
  }
}

closeModal = () => {
  let cancel_button = document.getElementById('close-modal');
  cancel_button.addEventListener('click', () => {
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
