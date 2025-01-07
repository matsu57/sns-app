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


function adjustImageLayout(imageContainer) {
  const images = imageContainer.querySelectorAll("img");
  const count = images.length;
  imageContainer.style.height = "225px";
  imageContainer.style.overflow = "hidden";

  if (count === 1) {
    imageContainer.style.gridTemplateColumns = "1fr";
  } else if (count === 2) {
    imageContainer.style.gridTemplateColumns = "1fr 1fr";
  } else if (count === 3) {
    imageContainer.style.gridTemplateColumns = "calc(50% - 3.5px) calc(50% - 3.5px)";
    imageContainer.style.gridTemplateRows = "calc(50% - 3.5px) calc(50% - 3.5px)";
    images[0].style.gridRow = "1 / span 2";
    images[1].style.gridRow = "1 / span 1";
    images[2].style.gridRow = "2 / span 1";
  } else if (count === 4) {
    imageContainer.style.gridTemplateColumns = "calc(50% - 3.5px) calc(50% - 3.5px)";
    imageContainer.style.gridTemplateRows = "calc(50% - 3.5px) calc(50% - 3.5px)";
  }
}

document.addEventListener("DOMContentLoaded", () => {
  const articles = document.querySelectorAll(".article");

  articles.forEach((article) => {
    const articleId = article.dataset.articleId;
    const activeHeart = article.querySelector(".article_body_icon_heart.active-heart");
    const inactiveHeart = article.querySelector(".article_body_icon_heart.inactive-heart");

    // 画像の表示サイズの調整
    const imageContainer = article.querySelector(".article_body_image");
    adjustImageLayout(imageContainer);

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
