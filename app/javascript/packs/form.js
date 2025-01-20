document.addEventListener("DOMContentLoaded", () => {
  const submitButton = document.getElementById("submitButton");
  const contentTextarea = document.querySelector('textarea[name="article[content]"]');
  const imageUpload = document.getElementById("imageUpload");
  const fileNameList = document.getElementById("fileNameList");
  const albumButton = document.getElementById("albumButton");
  const warningMessage = document.getElementById("warningMessage");

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
  imageUpload.addEventListener("change", (event) => {
    const files = event.target.files;

    //リストと警告をクリア
    fileNameList.innerHTML = "";
    warningMessage.textContent = "";

    if (files.length > 4) {
      warningMessage.textContent = "Please select no more than 4 images";
    }
    else {
      // file名の表示
      for (let i = 0; i < files.length; i++) {
        const li = document.createElement("li");
        li.textContent = files[i].name;
        fileNameList.appendChild(li);
      }
    }

    validateForm();
  });

  albumButton.addEventListener("click", () => {
    imageUpload.click();
  });
});
