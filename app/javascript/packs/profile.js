import axios from "axios";
import { csrfToken } from "rails-ujs";

axios.defaults.headers.common["X-CSRF-Token"] = csrfToken();

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
});
