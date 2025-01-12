document.addEventListener("DOMContentLoaded", () => {
  const submitButton = document.getElementById("submit_button");
  const contentTextarea = document.querySelector('textarea[name="article[content]"]');
  const imageUpload = document.getElementById("imageUpload");

  const validateForm = () => {
    const isContentValid = contentTextarea.value.trim() !== "";
    const isImageValid = imageUpload.files.length > 0;

    if (isContentValid && isImageValid) {
      submitButton.disabled = false;
      submitButton.classList.remove("color-gray");
    } else {
      submitButton.disabled = true;
      submitButton.classList.add("color-gray");
    }
  };

  validateForm(); //初期状態を設定

  contentTextarea.addEventListener("input", validateForm);
  imageUpload.addEventListener("change", validateForm);
});
