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

const followersCountDisplay = (followersCount) => {
  const followersCountElement = $(".profile_body_basicInfo_followers p");
  let displayText;
  displayText = `${followersCount}`;
  followersCountElement.text(displayText);
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
      handleFollowDisplay(hasFollowed);
    })
    .catch((error) => {
      console.error("Error fetching follow status:", error);
    });

  $(document).on("click", ".follow", function () {
    axios
      .post(`/accounts/${accountId}/follows`)
      .then((response) => {
        if (response.data.status === "ok") {
          handleFollowDisplay(true)
          const followersCount = response.data.followersCount;
          followersCountDisplay(followersCount);
        }
      })
      .catch((e) => {
        window.alert("follow Error");
        console.log(e);
      });
  });
  $(document).on("click", ".unfollow", function () {
    axios
      .post(`/accounts/${accountId}/unfollows`)
      .then((response) => {
        if (response.data.status === "ok") {
          handleFollowDisplay(false);
          const followersCount = response.data.followersCount;
          followersCountDisplay(followersCount);
        }
      })
      .catch((e) => {
        window.alert("unfollow Error");
        console.log(e);
      });
  });
})