document.addEventListener("DOMContentLoaded", () => {
const tagNameInput = document.querySelector("#input-tag");
if (tagNameInput){
    const inputElement = document.getElementById("input-tag");
    inputElement.addEventListener("input", () => {
      const keyword = document.getElementById("input-tag").value;
      const XHR = new XMLHttpRequest();
      XHR.open("GET", `/posts/search/?keyword=${keyword}`, true);
      XHR.responseType = "json";
      XHR.send();
      XHR.onload = () => {
        const searchResult = document.getElementById("search-result");
        searchResult.innerHTML = "";
        if (XHR.response) {
          // 検索結果
          const tagName = XHR.response.keyword;

          //読み取り専用になっているので操作しようとするとエラーが出てしまう
          tagName.readOnly = false;
          console.table(tagName)

          //すでに表示されているタグを取得
          const RemoveAddTagList = document.querySelectorAll('.add-tag');
          const RemoveAddTagListId = []
          RemoveAddTagList.forEach((tag) => {
            RemoveAddTagListId.push(tag.value);
          });

          console.table(RemoveAddTagListId)

        // ToDo：検索結果からすでに表示されているタグを削除
        // 連想配列tagNameのtag_nameと、配列RemoveAddTagListのvalueが一致していれば、連想配列から要素を消したい

          tagName = tagName.filter(value => {

            return ! RemoveAddTagListId.includes(value.tag_name);
            // console.table(value.tag_name)
            // if(value.tag_name != 80){
            //     return true;
            // }
        });


          tagName.forEach((tag) => {

            const childElement = document.createElement("div");
            childElement.setAttribute("class", "child");
            childElement.setAttribute("id", tag.id);
            childElement.innerHTML = tag.tag_name;
            searchResult.appendChild(childElement);
            const clickElement = document.getElementById(tag.id);
            // すでにaddに入っているidは消す

            clickElement.addEventListener("click", () => {

              const tag_html = document.createElement("input");
              tag_html.setAttribute("type", "text");
              tag_html.setAttribute("id", `input_${tag.id}`);
              tag_html.setAttribute("class", "add-tag");
              tag_html.setAttribute("name", "post_form_tag[]");
              tag_html.setAttribute("value", tag.id);
              const AddTagList = document.getElementById("add-tag-list");
              AddTagList.appendChild(tag_html);

              // console.log(tag)
              // console.log(tag_html)
              // console.log(document.getElementById(tag.id))
              // console.log(clickElement.textContent)

              document.getElementById(`input_${tag.id}`).value = clickElement.textContent;
              clickElement.remove();
            });
          });
        };
      }
    })
  };
});
