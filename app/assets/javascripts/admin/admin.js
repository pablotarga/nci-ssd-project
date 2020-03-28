
const onLoad = function (event) {
  const sidebar = document.getElementById('sidebar');
  const sidebarCollapse = document.getElementById('sidebarCollapse');

  if (sidebarCollapse) {
    sidebarCollapse.addEventListener('click', function () {
      sidebar.classList.toggle('active');
    });
  }
}

document.addEventListener('turbolinks:load', onLoad, false);

document.addEventListener('turbolinks:unload', function () {
  document.removeEventListener('turbolinks:load', onLoad, false);
})
