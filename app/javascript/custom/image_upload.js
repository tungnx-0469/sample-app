document.addEventListener("turbo:load", async function () {
  let i18n = {}
  const loadI18n = async () => {
    try {
      const response = await fetch("/translations.json");
      if (!response.ok) throw new Error("Failed to fetch locales");
      i18n = await response.json();
    } catch (error) {
      console.error("Error loading locales:", error);
    }
  };

  await loadI18n(); 
  document.addEventListener("change", async function (event) {
    const locale = document.querySelector('body').getAttribute('data-locale');
    let image_upload = document.querySelector('#micropost_image'); 
    const size_in_megabytes = image_upload.files[0].size / 1024 / 1024; 
    if (size_in_megabytes > 5) { 
      alert(i18n[locale]?.errors?.file_size_exceeded); 
      image_upload.value = ""; 
    } 
  }); 
});
