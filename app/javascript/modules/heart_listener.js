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

const heartListener = (isSignIn) => {
  document.addEventListener("click", function (event) {
    const targetElement = event.target;
    const parentElement = targetElement.parentElement;

    // いいね/いいね解除処理を共通化
    const handleLike = (action, successCallback) => {
      const articleElement = targetElement.closest(".article");
      const likeArticleId = articleElement.getAttribute("data-article-id");
      const likesCountElement = articleElement.querySelector(".article_body_likeCount p");

      if (isSignIn) {
        axios[action](`/api/articles/${likeArticleId}/like`)
          .then((response) => {
            if (response.data.status === "ok") {
              successCallback(response.data);
              const likesCount = response.data.likesCount;
              const lastLikeUsername = response.data.lastLikeUsername;
              likesCountDisplay(likesCount, lastLikeUsername, likesCountElement);
            }
          })
          .catch((error) => {
            window.alert(e);
          });
      } else {
        window.alert("いいねするにはサインインが必要です");
      }
    };

    // クリックされた要素の親クラスにinactive-heartが含まれているとき（いいね）
    if (parentElement.classList.contains("inactive-heart")) {
      handleLike("post", (data) => {
        parentElement.classList.add("hidden");
        parentElement.nextElementSibling.classList.remove("hidden");
      });
    }

    // クリックされた要素の親クラスにactive-heartが含まれているとき（いいね解除）
    else if (parentElement.classList.contains("active-heart")) {
      handleLike("delete", (data) => {
        parentElement.classList.add("hidden");
        parentElement.previousElementSibling.classList.remove("hidden");
      });
    }
  });
};


export { heartListener };