import { load_js, load_css } from "/lib/v1/cameo-core/cameo-load.js";
async function load() {
  await load_js("https://bossanova.uk/jexcel/v4/jexcel.js");
  await load_js("https://bossanova.uk/jsuites/v3/jsuites.js");
  load_css("https://bossanova.uk/jexcel/v4/jexcel.css");
  load_css("https://bossanova.uk/jsuites/v3/jsuites.css");
}

class CameoTable extends HTMLElement {
  connectedCallback() {
    this.str_random_id = "id_" + Math.random().toString(36).substr(2, 9);
    this.innerHTML = `
      <div id="${this.str_random_id}"></div>
      <br/>
      <button id="button_send_to_server">傳送伺服器</button> 
      <button>⬇️</button> 
      <button>➡️</button> 
      <button>⬆️</button> 
      <button>⬅️</button> 
    `;
    this.render();
    document
      .getElementById("button_send_to_server")
      .addEventListener("click", this.action_button_send_to_server);
  }
  async render() {
    this.jexcel = jexcel(document.getElementById(this.str_random_id), {
      csv: this.getAttribute("src")
    });
  }
  async action_button_send_to_server() {
    // alert("按下按鈕，送資料到伺服器:");
    const json = JSON.stringify([1, 3, 5, 7, 9]);
    console.log(json);
    let fetch_return = await fetch(
      "https://rksvn.sse.codesandbox.io/?from_client=123",
      {
        method: "GET",
        headers: {
          "Content-Type": "application/json"
        },
        json
      }
    );
    console.log("fetch_return");
    console.log(fetch_return.text());
    // const res = await postForm(body);
    // const data = await res.json();
  }
}

async function main() {
  await load();
  customElements.define("cameo-table", CameoTable);
}
main();
