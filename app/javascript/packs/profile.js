import { imageDisplay } from "modules/image_display";

document.addEventListener("DOMContentLoaded", () => {
  // avatar画像の変更
  const avatarPreview = document.getElementById("avatar-preview");
  const avatarInput = document.getElementById("avatar-input");

  if (avatarPreview) {
    avatarPreview.addEventListener("click", () => {
      avatarInput.click();
    });

    // 画像が選択されたら自動的にアップロード
    avatarInput.addEventListener("change", () => {
      if (avatarInput.files && avatarInput.files[0]) {
        const form = avatarInput.closest("form");
        form.submit();
      }
    });
  }

  //userのarticle画像一覧の表示
  const articles = document.querySelectorAll(".profileArticle");
  articles.forEach((article) => {
    // 画像の表示サイズの調整
    const imageContainer = article.querySelector(".article_body_image");
    imageDisplay(imageContainer);
  });
});