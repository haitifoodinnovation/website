// Haiti Food Innovation ET — site scripts
document.addEventListener('DOMContentLoaded', function () {
  var t = document.querySelector('.nav-toggle');
  var nav = document.querySelector('nav.mainnav');
  if (t && nav) {
    t.addEventListener('click', function () {
      nav.classList.toggle('open');
      t.setAttribute('aria-expanded', nav.classList.contains('open'));
    });
  }
  // Point form success redirects at this site's thank-you page
  document.querySelectorAll('form.hf').forEach(function (f) {
    var next = f.querySelector('input[name="_next"]');
    if (next) {
      var base = location.pathname.indexOf('/am/') !== -1 ? '/am/thanks.html' : '/thanks.html';
      var root = location.pathname.split('/').slice(0, location.pathname.indexOf('/am/') !== -1 ? -2 : -1).join('/');
      next.value = location.origin + root + base;
    }
  });
  var y = document.getElementById('year');
  if (y) y.textContent = new Date().getFullYear();
});
