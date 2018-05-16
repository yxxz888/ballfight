var startOffset = 0;

function IsAlnum(a)
{
	return/[a-zA-Z0-9']+/.test(a);
}

function IsChinese(a)
{
    if(/[^\u4e00-\u9fa5]/.test(a))
        return false;
    return true;
}

StartGrabWord();

function StartGrabWord()
{
	document.addEventListener("mousemove", OnMousemove, true);
}

function StopGrabWord()
{
	document.removeEventListener("mousemove", OnMousemove, true);
}

function OnMousemove(event)
{
	var evt = event || window.event;
	word = GetGrabWord(evt.clientX, evt.clientY);
	if (word != "")
	{
		chrome.extension.sendRequest({data:word + ":" + startOffset});
	}
	else
	{
		chrome.extension.sendRequest({data:""});
	}
}

//若当前节点没有内容则获取兄弟节点的第一个子节点的内容
function getSiblingNodeData(container){
	if(container && container.nextSibling && container.nextSibling.childNodes && container.nextSibling.childNodes[0]){
		if(typeof container.nextSibling.childNodes[0].data != "undefined" ){
			var resultword = container.nextSibling.childNodes[0].data;
			var temp = resultword.replace(/\s/, "").trim(); 
			if(IsChinese(temp) || IsAlnum(temp)){
				return resultword;
			}
		}
	}
	return "";
}

function GetGrabWord(clientX, clientY)
{
	var textRange = document.caretRangeFromPoint(clientX, clientY);   // 得到固定位置的文本
	do{
		if(!textRange){
		  break;
		}
		
		var start = textRange.startOffset, end = textRange.endOffset;
		startOffset = start;
		var cnt = 0;
		var space_cnt = 0;
		var chinese_cnt = 0;
		var wordRange = textRange.cloneRange(), text = "";
		if(textRange.startContainer.data){
			//向前遍历
			while(start > 0){
				wordRange.setStart(textRange.startContainer, --start);
				text = wordRange.toString().replace(/\s/, " ");
				text = text == " " ? getSiblingNodeData(textRange.startContainer).replace(/\s/, " ") : text;
				if(!IsAlnum(text.charAt(0))){
					if(IsChinese(text.charAt(0))) {
						chinese_cnt++;
					}
					if(text.charAt(0).trim().length == 0){
						space_cnt++
					}
					if(space_cnt == 0 && chinese_cnt == 0 || space_cnt == 3 || chinese_cnt == 5){
						wordRange.setStart(textRange.startContainer, start + 1);
						break;
					}
				}
				cnt++;
		  }
		}
		startOffset = startOffset - (start + 1);
		if(cnt == 0){
		  break;
		}
		cnt = 0;
		space_cnt = 0;
		chinese_cnt = 0;
		if(textRange.endContainer.data){
			//向后遍历
			while(end < textRange.endContainer.data.length){
				wordRange.setEnd(textRange.endContainer, ++end);
				text = wordRange.toString().replace(/\s/, " ");
				text = text == " " ? getSiblingNodeData(textRange.endContainer).replace(/\s/, " ") : text;
				if(!IsAlnum(text.charAt(text.length - 1))){
					if(IsChinese(text.charAt(text.length - 1))){
					chinese_cnt++;
					}
					if(text.charAt(text.length - 1).trim().length == 0){
						space_cnt++;
					}
					if(space_cnt == 0 && chinese_cnt == 0 || space_cnt == 3 || chinese_cnt == 5) {
						wordRange.setEnd(textRange.endContainer, end - 1);
						break;
					}
				}
			cnt++;
		  }
		}
		if(cnt == 0 && text.length > 3){
			break;
		}
		var result = wordRange.toString().replace(/\s/, " ");
		if(result.length >= 1){
			return result;
		}
  }while(0);
  return "";
}
