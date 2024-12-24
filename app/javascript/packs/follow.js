import $ from "jquery";
import axios from "axios";
import { csrfToken } from "rails-ujs";

axios.defaults.headers.common["X-CSRF-Token"] = csrfToken();

const handleFollowDisplay = (hasFollowed) => {
  if (hasFollowed) {
    $(".unfollow").removeClass("hidden");
    $(".follow").addClass("hidden");
  } else {
    $(".unfollow").addClass("hidden");
    $(".follow").removeClass("hidden");
  }
};

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
      console.log(hasFollowed);
      handleFollowDisplay(hasFollowed);
      console.log(response.data.followersCount);
    })
    .catch((error) => {
      console.error("Error fetching follow status:", error);
    });

  $(document).on("click", ".follow", function () {
    const followersCountElement = $(".profile_body_basicInfo_followers p");
    axios
      .post(`/accounts/${accountId}/follows`)
      .then((response) => {
        if (response.data.status === "ok") {
          handleFollowDisplay(true)
          const followersCount = response.data.followersCount;

          let displayText;
          displayText = `${followersCount}`;
          followersCountElement.text(displayText);
        }
      })
      .catch((e) => {
        window.alert("follow Error");
        console.log(e);
      });
  });
  $(document).on("click", ".unfollow", function () {
    const followersCountElement = $(".profile_body_basicInfo_followers p");
    axios
      .post(`/accounts/${accountId}/unfollows`)
      .then((response) => {
        if (response.data.status === "ok") {
          handleFollowDisplay(false);
          const followersCount = response.data.followersCount;

          let displayText;
          displayText = `${followersCount}`;
          followersCountElement.text(displayText);
        }
      })
      .catch((e) => {
        window.alert("unfollow Error");
        console.log(e);
      });
  });
})