import { sb, configured, esc } from "./app.js";
const box = document.getElementById("public-reviews");
if (box) {
  if (!configured) { const s = box.closest("section"); if (s) s.style.display = "none"; }
  else load();
}
async function load(){
  const { data } = await sb.from("reviews")
    .select("name,city,product,rating,review,created_at")
    .eq("approved", true).order("created_at", { ascending: false }).limit(12);
  if (!data || !data.length) { box.innerHTML = `<p class="small">${esc(box.dataset.empty || "")}</p>`; return; }
  box.innerHTML = '<div class="grid cols-3">' + data.map(r => `
    <div class="card"><div class="body">
      <div style="color:var(--gold);font-size:1.1rem;letter-spacing:.1em">${"★".repeat(r.rating)}${"☆".repeat(5 - r.rating)}</div>
      <h3 style="font-size:1rem">${esc(r.product)}</h3>
      <p>"${esc(r.review)}"</p>
      <div class="meta">${esc(r.name)}${r.city ? " · " + esc(r.city) : ""}</div>
    </div></div>`).join("") + "</div>";
}
