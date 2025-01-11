import { imageDisplay } from "modules/image_display";

document.addEventListener("DOMContentLoaded", () => {
  const articles = document.querySelectorAll(".profileArticle");
    articles.forEach((article) => {
      // 画像の表示サイズの調整
      const imageContainer = article.querySelector(".article_body_image");
      imageDisplay(imageContainer);

    });
});