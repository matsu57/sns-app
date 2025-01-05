import $ from "jquery";
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

const likesCountDisplay = (likesCount, lastLikeUsername, likesCountElement) => {
  if (likesCount > 0) {
    let displayText = `${lastLikeUsername}`;

    if (likesCount > 1) {
      displayText += ` and ${likesCount - 1} other${likesCount > 2 ? "s" : ""} liked your post`;
    } else {
      displayText += " liked your post";
    }

    likesCountElement.text(displayText).show();
  }
  else {
    likesCountElement.hide();
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
        const lastLikeUsername = response.data.lastLikeUsername;
        handleHeartDisplay(hasLiked, activeHeart, inactiveHeart);
      })
      .catch((error) => {
        console.error("Error fetching like status:", error);
      });
  });

  $(document).on("click", ".inactive-heart", function () {
    const articleElement = $(this).closest(".article");
    const likeArticleId = articleElement.attr("data-article-id");
    const likesCountElement = articleElement.find(".article_body_likeCount p");

    axios
      .post(`/articles/${likeArticleId}/like`)
      .then((response) => {
        if (response.data.status === "ok") {
          $(this).addClass("hidden");
          $(this).next().removeClass("hidden");
          const likesCount = response.data.likesCount;
          const lastLikeUsername = response.data.lastLikeUsername;
          likesCountDisplay(likesCount, lastLikeUsername, likesCountElement);
        }
      })
      .catch((e) => {
        window.alert("inactive-heart Error");
        console.log(e);
      });
  });

  $(document).on("click", ".active-heart", function () {
    const articleElement = $(this).closest(".article");
    const likeArticleId = articleElement.attr("data-article-id");
    const likesCountElement = articleElement.find(".article_body_likeCount p");

    axios
      .delete(`/articles/${likeArticleId}/like`)
      .then((response) => {
        if (response.data.status === "ok") {
          $(this).addClass("hidden");
          $(this).prev().removeClass("hidden");
          const likesCount = response.data.likesCount;
          const lastLikeUsername = response.data.lastLikeUsername;
          likesCountDisplay(likesCount, lastLikeUsername, likesCountElement);
        }
      })
      .catch((e) => {
        window.alert("active-heart Error");
        console.log(e);
      });
  });
});
