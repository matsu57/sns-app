import $ from "jquery";
import axios from "axios";
import { csrfToken } from "rails-ujs";

axios.defaults.headers.common["X-CSRF-Token"] = csrfToken();


document.addEventListener("DOMContentLoaded", () => {
  const articleId = window.location.pathname.split("/")[2];

  // コメントの取得と表示
  axios.get(`/articles/${articleId}/comments`)
    .then((response) => {
      const comments = response.data;
      comments.forEach((comment) => {
        appendNewComment(comment);
      });
    })
    .catch((error) => {
      console.error("Error fetching comments:", error);
    });
})