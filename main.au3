#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>
#include <WindowsConstants.au3>

;;;;; 全局变量

;; 是否为企点号
Global $isQidian = True

;; 脚本运行状态
Global $isRun = False


;;;;; 快捷键

;; F10 启动程序
HotKeySet("{F10}", "RunStart")

;; F9 停止按钮
HotKeySet("{F9}", "RunStop")


;;;;; UI控制

;; 主窗口
Local $hGUI = GUICreate("丰橙信息科技©消息自动发送器", 600, 300) 

;; 消息框
Local $idMyedit = GUICtrlCreateEdit ("", 20, 20, 560, 200, $ES_AUTOVSCROLL + $WS_VSCROLL)

;; 启动按钮
Local $startButton = GUICtrlCreateButton("启动(F10)", 20, 230, 80, 30)

;; 停止按钮
Local $stopButton = GUICtrlCreateButton("停止(F9)", 100, 230, 80, 30)

;; QQ
Local $qqRadio = GUICtrlCreateRadio("QQ", 200, 230, 40, 30)

;; 企点号，默认选中
Local $qidianRadio = GUICtrlCreateRadio("企点号", 250, 230, 50, 30)
GUICtrlSetState($qidianRadio, $GUI_CHECKED)

GUISetState(@SW_SHOW, $hGUI)

;; 活动控件
Local $iMsg = 0



While 1
    $iMsg = GUIGetMsg()
    Select 
		Case $iMsg = $idMyedit
			ClipPut(GUICtrlRead($idMyedit))
		Case $iMsg = $qqRadio And BitAND(GUICtrlRead($qqRadio), $GUI_CHECKED) = $GUI_CHECKED
			$isQidian = False
		Case $iMsg = $qidianRadio And BitAND(GUICtrlRead($qidianRadio), $GUI_CHECKED) = $GUI_CHECKED
			$isQidian = True
		Case $iMsg = $startButton
            RunStart()
		Case $iMsg = $stopButton
			RunStop()
        Case $iMsg = $GUI_EVENT_CLOSE
			Terminate()
            ExitLoop
    EndSelect
WEnd


;;;;; 函数

;; 

;; 根据类型运行程序
Func RunStart()
	
	$isRun = True

	$initPos = WinGetPos("[ACTIVE]")
	$initWidth = $initPos[2]
	$initHeigh = $initPos[3]
	
	While $isRun
	
		Sleep(200)
		$curPos = WinGetPos("[ACTIVE]")
		$curWidth = $curPos[2]
		$curHeight = $curPos[3]
		
		; 如果当前活动窗口和第一次运行程序的窗口大小不一致
		; 则认为已经跳出程序，直接停止程序（判断逻辑待优化）
		If $initWidth <> $curWidth And $initHeigh <> $curHeight Then
			RunStop()
			ExitLoop
		EndIf
		Sleep(200)
	
		Send("^v")
		Sleep(200)
		
		; PROD CODE
		; 发送消息
		Send("{ENTER}")
		Sleep(100)
		
		Send("!c")
		Sleep(100)
		
		; DEV CODE
		; 消息框有消息推出需要确认逻辑
		;Send("{ENTER}")
		;Sleep(100)
		
		Send("{TAB}")
		Sleep(100)
		Send("{TAB}")
		Sleep(100)
		
		; QQ号逻辑处理
		If $isQidian <> True Then 
			Send("{ENTER}")
			Sleep(100)
		EndIf
		
		Send("{DOWN}")
		Sleep(100)
		Send("{ENTER}")
		Sleep(100)
		
		; 如果往下移动一次获取到的标题还是 QQ
		; 则判断为分组节点，继续往下移一次（存在用户为 QQ 导致错误问题）
		If WinGetTitle("[ACTIVE]") = 'QQ' Then
			Send("{DOWN}")
			Send("{ENTER}")
		EndIf
		Sleep(100)
		
	WEnd
EndFunc

;; 暂停
Func RunStop()
	$isRun = False
EndFunc

;; 退出
Func Terminate()
	GUIDelete($hGUI)
	MsgBox(4096,"","退出成功，听课人数又涨了~。")
    Exit 0
EndFunc
