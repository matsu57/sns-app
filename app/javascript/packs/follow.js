import $ from "jquery";
import axios from "axios";
import { csrfToken } from "rails-ujs";

axios.defaults.headers.common["X-CSRF-Token"] = csrfToken();

const handleFollowDisplay = (hasFollowed) => {
  if (hasFollowed) {
    $(".unfollow-button").removeClass("hidden");
    $(".follow-button").addClass("hidden");
  } else {
    $(".unfollow-button").addClass("hidden");
    $(".follow-button").removeClass("hidden");
  }
};

const handleFollowAction = (accountId, action) => {
  const url = `/api/account/${accountId}/${action === "follow" ? "follows" : "unfollows"}`;

  axios
    .post(url)
    .then((response) => {
      if (response.data.status === "ok") {
        handleFollowDisplay(action === "follow");
        $(".followers-count p").text(response.data.followersCount);
      }
    })
    .catch((e) => {
      window.alert(`${action} Error`);
      console.log(e);
    });
};


document.addEventListener("DOMContentLoaded", () => {
  const account = $("#account-id");
  const dataset = account.data();
  const accountId = dataset.accountId;
  const followingId = dataset.currentId;

  axios
    .get(`/api/account/${accountId}/follows/${followingId}`)
    .then((response) => {
      const hasFollowed = response.data.hasFollowed;
      handleFollowDisplay(hasFollowed);
    })
    .catch((error) => {
      console.error("Error fetching follow status:", error);
    });

  $(document).on("click", ".follow-button", () => handleFollowAction(accountId, "follow"));
  $(document).on("click", ".unfollow-button", () => handleFollowAction(accountId, "unfollow"));
})