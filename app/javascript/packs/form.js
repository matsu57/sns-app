document.addEventListener("DOMContentLoaded", () => {
  const submitButton = document.getElementById("submitButton");
  const contentTextarea = document.querySelector('textarea[name="article[content]"]');
  const imageUpload = document.getElementById("imageUpload");
  const fileNameList = document.getElementById("fileNameList");
  const albumButton = document.getElementById("albumButton");
  const warningMessage = document.getElementById("warningMessage");

  // 入力のチェック
  const validateForm = () => {
    const isContentValid = contentTextarea.value.trim() !== "";
    const isImageValid = imageUpload.files.length > 0;

    if (isContentValid && isImageValid) {
      submitButton.classList.remove("color-gray");
    } else {
      submitButton.classList.add("color-gray");
    }
  };

  // fileNameListの更新
  const updateFileNameList = (files) => {
    // リストと警告をクリア
    fileNameList.innerHTML = "";
    warningMessage.textContent = "";

    if (files.length > 4) {
      warningMessage.textContent = "Please select no more than 4 images";
    } else {
      // file名の表示
      Array.from(files).forEach((file) => {
        const li = document.createElement("li");
        li.textContent = file.name;
        fileNameList.appendChild(li);
      });
    }
  };

  // 初期状態を設定
  validateForm();

  // textareaのチェック
  contentTextarea.addEventListener("input", validateForm);

  // 画像選択のチェック
  imageUpload.addEventListener("change", (event) => {
    updateFileNameList(event.target.files);
    validateForm();
  });

  //自作のボタンがクリックされたとき、初期フォームがクリックされたようにする
  albumButton.addEventListener("click", () => {
    imageUpload.click();
  });
});
