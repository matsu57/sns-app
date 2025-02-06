import axios from "axios";
import { csrfToken } from "rails-ujs";

axios.defaults.headers.common["X-CSRF-Token"] = csrfToken();

const likesCountDisplay = (likesCount, lastLikeUsername, likesCountElement) => {
  if (likesCount > 0) {
    let displayText = `${lastLikeUsername}`;

    if (likesCount > 1) {
      displayText += ` and ${likesCount - 1} other${likesCount > 2 ? "s" : ""} liked your post`;
    } else {
      displayText += " liked your post";
    }

    likesCountElement.textContent = displayText;
    likesCountElement.style.display = "block";
  } else {
    likesCountElement.style.display = "none";
  }
};

const heartListener = () => {
  document.addEventListener("click", function (event) {
    const parentElement = event.target.parentElement;
    // クリックされた要素の親クラスにinactive-heartが含まれているとき
    if (parentElement.classList.contains("inactive-heart")) {
      const articleElement = event.target.closest(".article");
      const likeArticleId = articleElement.getAttribute("data-article-id");
      const likesCountElement = articleElement.querySelector(".article_body_likeCount p");

      axios
        .post(`/api/articles/${likeArticleId}/like`)
        .then((response) => {
          if (response.data.status === "ok") {
            parentElement.classList.add("hidden");
            parentElement.nextElementSibling.classList.remove("hidden");
            const likesCount = response.data.likesCount;
            const lastLikeUsername = response.data.lastLikeUsername;
            likesCountDisplay(likesCount, lastLikeUsername, likesCountElement);
          }
        })
        .catch((e) => {
          window.alert("inactive-heart Error");
          console.log(e);
        });
    }

    // クリックされた要素の親クラスにactive-heartが含まれているとき
    else if (parentElement.classList.contains("active-heart")) {
      const articleElement = event.target.closest(".article");
      const likeArticleId = articleElement.getAttribute("data-article-id");
      const likesCountElement = articleElement.querySelector(".article_body_likeCount p");

      axios
        .delete(`/api/articles/${likeArticleId}/like`)
        .then((response) => {
          if (response.data.status === "ok") {
            parentElement.classList.add("hidden");
            parentElement.previousElementSibling.classList.remove("hidden");
            const likesCount = response.data.likesCount;
            const lastLikeUsername = response.data.lastLikeUsername;
            likesCountDisplay(likesCount, lastLikeUsername, likesCountElement);
          }
        })
        .catch((e) => {
          window.alert("active-heart Error");
          console.log(e);
        });
    }
  });
};

export { heartListener };