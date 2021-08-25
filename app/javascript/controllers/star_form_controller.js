import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["starAll"];
  
  connect () {
    let starScore = this.starAllTarget;
    for (let i = 0; i < starScore.children.length; i++) {
      starScore.children[i].addEventListener('mouseenter', (e) => {
        this.fillStar(e.target);
        let prevSibling = e.target.previousElementSibling;
        while(prevSibling) {
          this.fillStar(prevSibling);
          prevSibling = prevSibling.previousElementSibling;
        }
      }); 
      starScore.children[i].addEventListener('mouseleave', (e) => {
        this.emptyStar(e.target);
        let prevSibling = e.target.previousElementSibling;
        while(prevSibling) {
          this.emptyStar(prevSibling);
          prevSibling = prevSibling.previousElementSibling;
        }
      });
      starScore.children[i].addEventListener('click', () => {
        let modal = document.getElementById('score-modal');
        modal.classList.remove('hidden');
        let starId = starScore.children[i].id;
        this.fillScoreForm(starId);
      });
    }
  }

  fillStar = (element) => {
    element.children[0].children[0].children[1].setAttribute('fill', "#c89c4c");
  }

  emptyStar = (element) => {
    element.children[0].children[0].children[1].setAttribute('fill', "#acb1b7");
  }

  fillScoreForm = (starId) => {
    let scoreFormField = document.getElementById('recipe_score[score]');
    let scoreDisplayed = document.getElementById('your-score');
    let scoreOptions = { "score-one": 1, "score-two": 2, "score-three": 3, "score-four": 4, "score-five": 5 };  
    scoreFormField.setAttribute("value", scoreOptions[starId]);
    scoreDisplayed.innerHTML = scoreOptions[starId];
  }
}
