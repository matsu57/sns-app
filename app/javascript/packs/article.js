import axios from "axios";
import { csrfToken } from "rails-ujs";

axios.defaults.headers.common["X-CSRF-Token"] = csrfToken();

import { heartListener } from "modules/heart_listener";

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
  const signIn = document.getElementById("sign-in");
  const isSignIn = signIn.dataset.signinStatus === "true";

  // サインインしている場合のみ動作する
  if (isSignIn) {
    const articles = document.querySelectorAll(".article");

    articles.forEach((article) => {
      const articleId = article.dataset.articleId;
      const activeHeart = article.querySelector(".article_body_icon_heart.active-heart");
      const inactiveHeart = article.querySelector(".article_body_icon_heart.inactive-heart");

      // サーバーからいいね状態を取得
      axios
        .get(`/api/articles/${articleId}/like`)
        .then((response) => {
          const hasLiked = response.data.hasLiked;
          const lastLikeUsername = response.data.lastLikeUsername;
          handleHeartDisplay(hasLiked, activeHeart, inactiveHeart);
        })
        .catch((error) => {
          console.error("Error fetching like status:", error);
        });
    });

  }
  // オンタイムでのハートのつけ外し
  heartListener(isSignIn);
});
