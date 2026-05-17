const panels = Array.from(document.querySelectorAll(".panel"));
const buttons = Array.from(document.querySelectorAll("[data-target]"));

function showPanel(id) {
  panels.forEach((panel) => {
    panel.classList.toggle("active", panel.id === id);
  });

  if (location.hash !== `#${id}`) {
    history.replaceState(null, "", `#${id}`);
  }
}

buttons.forEach((button) => {
  button.addEventListener("click", () => showPanel(button.dataset.target));
});

const initial = location.hash.slice(1);
showPanel(panels.some((panel) => panel.id === initial) ? initial : "about");
