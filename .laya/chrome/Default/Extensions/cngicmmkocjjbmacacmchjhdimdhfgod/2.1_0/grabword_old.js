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
	word = GetGrabWord(event.clientX, event.clientY);
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
	var textRange = document.caretRangeFromPoint(clientX,clientY);
	if(!textRange)
		return "";

	var start = textRange.startOffset, end = textRange.endOffset;
	startOffset = start;
	var frontNum = 0, backNum = 0; // 前面和后面的字符个数
	var c1 = 0, c2 = 0;
	var word = "";
	var wordRange = textRange.cloneRange();
			
	if(!textRange.startContainer.textContent)
		return "";
		
	for(; start > 0;)
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
				wordRange.setStart(textRange.startContainer, ++start);
				break;
			}
		}
		frontNum++;
	}

	startOffset -= start;

	c1 = c2 = 0;
	for(; end < textRange.endContainer.textContent.length;)
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
	
	word = "";
	if(frontNum + backNum > 0)
	{
		word = wordRange.toString();
		if (startOffset > word.length - 1)
			startOffset = word.length - 1;
	}
	
	return word;
}
