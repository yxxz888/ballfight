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

var IsAlpha = function(str) {
  return/[a-zA-Z']+/.test(str)
};

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
	//console.log("x:" + evt.clientX);
	//console.log("y:" + evt.clientY);
	if (word != "")
	{
		chrome.extension.sendRequest({data:word + ":" + startOffset});
	}
	else
	{
		chrome.extension.sendRequest({data:""});
	}
}

function GetGrabWord(clientX, clientY)
{
	do{
		var textRange = document.caretRangeFromPoint(clientX, clientY);
		//var range = document.createRange();
		//console.log("textRange:"+textRange);
		
		if(!textRange){
			return "";
		}
		
		var start = textRange.startOffset, end = textRange.endOffset; 
		startOffset = start;
		
		var frontNum = 0, backNum = 0; // 前面和后面的字符个数
		var c1 = 0, c2 = 0;
		var word = "";
		var wordRange = textRange.cloneRange();
				
		//console.log("gubtext:" + textRange.startContainer.textContent);
		if(textRange.startContainer.data){
			while(start > 0){
				{// 向前添加字符
					wordRange.setStart(textRange.startContainer, --start);
					word = wordRange.toString();
					if(!IsAlnum(word.charAt(0)))
					{
						if (IsChinese(word.charAt(0)))
							c1++;
						if (word.charAt(0) == " ")
							c2++;
							
						if((c1==0&&c2==0) || (c2==3) || (c1==5))
						{
							wordRange.setStart(textRange.startContainer, start + 1);
							break;
						}
					}
					frontNum++;
				}
			}
		}
		//如果前面没有词则跳出
		if(0 == frontNum){
			break;
		}
		startOffset -= (start + 1);

		c1 = c2 = 0;
		if(textRange.endContainer.data){
		//for(; end < textRange.endContainer.textContent.length && textRange.endContainer.childNodes.length > end;)
			while(end < textRange.endContainer.data.length)
			{// 向后添加字符
				wordRange.setEnd(textRange.endContainer, ++end);
				word = wordRange.toString();
				if(!IsAlnum(word.charAt(word.length - 1)))
				{
					if (IsChinese(word.charAt(word.length - 1)))
						c1++;
					if (word.charAt(word.length - 1) == " ")
						c2++;
					
					if((c1==0&&c2==0) || (c2==3) || (c1==5))
					{
						wordRange.setEnd(textRange.endContainer, end - 1);
						break;
					}
				}
				backNum++;
			}
		}
		word = "";
		//如果后面没有词则推出
		if(0 == backNum){
			break;
		}
		var result = wordRange.toString();
		if(result.length > 0){
			word = result;
		}
	}while(0);
	return word;
}
