import $ from "jquery";
import axios from "axios";
import { csrfToken } from "rails-ujs";

axios.defaults.headers.common["X-CSRF-Token"] = csrfToken();

const appendNewComment = (comment) => {
  const commentHtml = $(`
    <div class='comment_content'>
      <div class='comment_avatar'>
        <img src="${comment.user.avatar_url || "/assets/default-avatar.png"}" alt="User Avatar">
      </div>
      <div class='comment_text'>
        <div class='comment_userName'>${comment.user.username}</div>
        <p>${comment.content}</p>
      </div>
    </div>
  `);

  $(".comment_body").prepend(commentHtml);
};

document.addEventListener("DOMContentLoaded", () => {
  const articleShow = $("#article-id");
  const dataset = articleShow.data();
  const articleId = dataset.articleId;

  $(".comment_btn").on("click", () => {
    const content = $("#comment_content").val();

    if (!content) {
      window.alert("コメントを入力してください");
    } else {
      axios
        .post(`/api/articles/${articleId}/comments`, {
          comment: { content: content },
        })
        .then((res) => {
          const comment = res.data;
          appendNewComment(comment); // 新しいコメントを追加
          $("#comment_content").val(""); // 入力欄をクリア
        })
        .catch((error) => {
          console.error("コメント投稿エラー:", error);
        });
    }
  });
});