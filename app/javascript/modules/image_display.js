const imageDisplay = (imageContainer) =>  {
  const images = imageContainer.querySelectorAll("img");
  const count = images.length;
  imageContainer.style.height = "225px";
  imageContainer.style.overflow = "hidden";

  if (count === 1) {
    imageContainer.style.gridTemplateColumns = "1fr";
  } else if (count === 2) {
    imageContainer.style.gridTemplateColumns = "1fr 1fr";
  } else if (count === 3) {
    imageContainer.style.gridTemplateColumns = "calc(50% - 3.5px) calc(50% - 3.5px)";
    imageContainer.style.gridTemplateRows = "calc(50% - 3.5px) calc(50% - 3.5px)";
    images[0].style.gridRow = "1 / span 2";
    images[1].style.gridRow = "1 / span 1";
    images[2].style.gridRow = "2 / span 1";
  } else if (count === 4) {
    imageContainer.style.gridTemplateColumns = "calc(50% - 3.5px) calc(50% - 3.5px)";
    imageContainer.style.gridTemplateRows = "calc(50% - 3.5px) calc(50% - 3.5px)";
  }
}

export { imageDisplay };