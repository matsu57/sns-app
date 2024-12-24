import $ from "jquery";
import axios from "axios";
import { csrfToken } from "rails-ujs";

axios.defaults.headers.common["X-CSRF-Token"] = csrfToken();


// DOMが読み込まれた後の処理
document.addEventListener("DOMContentLoaded", () => {
  const account = $("#account-id");
  const dataset = account.data();
  const accountId = dataset.accountId;
  const followingId = dataset.currentId;

  axios
    .get(`/accounts/${accountId}/follows/${followingId}`)
    .then((response) => {
      const hasFollowed = response.data.hasFollowed;
      console.log(hasFollowed)
    })
    .catch((error) => {
      console.error("Error fetching follow status:", error);
    });
})