// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)


require("trix");
require("@rails/actiontext");

import $ from 'jquery'
import axios from "axios";
import { csrfToken } from "rails-ujs";

axios.defaults.headers.common["X-CSRF-Token"] = csrfToken();

const handleHeartDisplay = (hasLiked, activeHeart, inactiveHeart) => {
  if (hasLiked) {
    activeHeart.classList.remove("hidden");
    inactiveHeart.classList.add("hidden");
  } else {
    activeHeart.classList.add("hidden");
    inactiveHeart.classList.remove("hidden");
  }
};

document.addEventListener("DOMContentLoaded", () => {
  const articles = document.querySelectorAll(".article");

  articles.forEach((article) => {
    const articleId = article.dataset.articleId;
    const activeHeart = article.querySelector(".article_body_icon_heart.active-heart");
    const inactiveHeart = article.querySelector(".article_body_icon_heart.inactive-heart");

    // サーバーからいいね状態を取得
    axios
      .get(`/articles/${articleId}/like`)
      .then((response) => {
        const hasLiked = response.data.hasLiked;
        handleHeartDisplay(hasLiked, activeHeart, inactiveHeart);
      })
      .catch((error) => {
        console.error("Error fetching like status:", error);
      });
  });
});