﻿B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=9.85
@EndOfDesignText@
#Region Shared Files
#CustomBuildAction: folders ready, %WINDIR%\System32\Robocopy.exe,"..\..\Shared Files" "..\Files"
'Ctrl + click to sync files: ide://run?file=%WINDIR%\System32\Robocopy.exe&args=..\..\Shared+Files&args=..\Files&FilesSync=True
#End Region

'Ctrl + click to export as zip: ide://run?File=%B4X%\Zipper.jar&Args=Project.zip

Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	Private WebView1 As WebView
	Private cc As ContentChooser
	Private Provider As FileProvider
	Dim d As DoubleTaptoClose

	Private WebView1 As WebView
	Dim anim As Animation
	Private loading As ImageView
End Sub

Public Sub Initialize
'	B4XPages.GetManager.LogEvents = True
End Sub

'This event will be called once, before the page becomes visible.
Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.LoadLayout("index")
	Provider.Initialize
	Dim client As JavaObject
	client.InitializeNewInstance(Application.PackageName & ".b4xmainpage$MyChromeClient", Array(Me))
	WebView1.As(JavaObject).RunMethod("setWebChromeClient", Array(client))
	WebView1.LoadUrl("https://jahad-afza.iran.liara.run/")
	d.Initialize("برای خروج دوباره کلیک کنید!")
	WebView1.LoadUrl("https://jahad-afza.iran.liara.run/")
	WebView1.ZoomEnabled=False
	loading.Visible=True
	
	
	anim.InitializeTranslate("anim",2%x,1%y,3%x,4%y)
	anim.Duration=1000
	anim.RepeatMode = anim.REPEAT_REVERSE
	anim.RepeatCount=-1
	anim.Start(loading)
End Sub

Sub ShowFile_Chooser (FilePathCallback As Object, FileChooserParams As Object)
	cc.Initialize("CC")
	cc.Show("*/*", "Choose File")
	Wait For CC_Result (Success As Boolean, Dir As String, FileName As String)
	Dim jo As JavaObject = Me
	If Success Then
		Log(FileName)
		File.Copy(Dir, FileName, Provider.SharedFolder, "TempFile")
		jo.RunMethod("SendResult", Array(Provider.GetFileUri("TempFile"), FilePathCallback))
	Else
		jo.RunMethod("SendResult", Array(Null, FilePathCallback))
	End If
End Sub


#if Java
import android.webkit.*;
import android.webkit.WebChromeClient.*;
import android.net.*;
public void SendResult(Uri uri, ValueCallback<Uri[]> filePathCallback) {
	if (uri != null)
		filePathCallback.onReceiveValue(new Uri[] {uri});
	else
		filePathCallback.onReceiveValue(null);
		
}
public static class MyChromeClient extends WebChromeClient {
	private final B4AClass target;
	public MyChromeClient(B4AClass target) {
		this.target = target;
	}
@Override
 public boolean onShowFileChooser(WebView webView, ValueCallback<Uri[]> filePathCallback,
            FileChooserParams fileChooserParams) {
		target.getBA().raiseEventFromUI(this, "showfile_chooser", filePathCallback, fileChooserParams);
        return true;
    }
	}
#End If

Private Sub WebView1_PageFinished (Url As String)
	WebView1.Visible=True
	anim.Stop(loading)
	loading.Visible=False
End Sub

Private Sub WebView1_OverrideUrl (Url As String) As Boolean
	WebView1.Visible=False
	anim.Start(loading)
	loading.Visible=True
End Sub

Sub Activity_KeyPress (KeyCode As Int) As Boolean

	If KeyCode = KeyCodes.KEYCODE_BACK Then
		If WebView1.Url = "https://jahad-afza.iran.liara.run/" Then
			d.TapToClose
		Else
			WebView1.Back
		End If
		Return True
	End If

End Sub