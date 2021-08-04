fillPercent = () => {
  let score_text = document.getElementById('avg-score').innerText;
  let score = parseFloat(score_text).toFixed(1);
  let decimal = score % 1;
  let percent = (decimal * 100)+"%";
  document.getElementById('stop1').setAttribute("offset", percent);
  document.getElementById('stop1').setAttribute("offset", percent);
}

document.addEventListener("turbolinks:load", () => {
  fillPercent();
})