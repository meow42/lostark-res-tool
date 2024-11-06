/* 定义全局参数 */
Version := "0.1"  ; 版本号
GUIWidth := 1600  ; 窗体宽度
GUIHeight := 1000  ; 窗体高度

; 状态
SelectedDir := A_ScriptDir  ; 存放选取的目录

; 编码字典
Codes := Map()
Chars :=    ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "_",  "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "_"]
Codes[0] := ["W", "3", "A", "H", "O", "V", "2", "9", "G", "N", "U", "1", "8", "F", "M", "T", "0P", "7", "E", "L", "S", "Z", "6", "D", "K", "R", "Y", "5", "C", "J", "Q", "X", "4", "B", "I", "P", "0L"]
Codes[1] := ["X", "4", "B", "I", "P", "W", "3", "A", "H", "O", "V", "2", "9", "G", "N", "U", "1Q", "8", "F", "M", "T", "0", "7", "E", "L", "S", "Z", "6", "D", "K", "R", "Y", "5", "C", "J", "Q", "1M"]
Codes[2] := ["Y", "5", "C", "J", "Q", "X", "4", "B", "I", "P", "W", "3", "A", "H", "O", "V", "2R", "9", "G", "N", "U", "1", "8", "F", "M", "T", "0", "7", "E", "L", "S", "Z", "6", "D", "K", "R", "2N"]
Codes[3] := ["Z", "6", "D", "K", "R", "Y", "5", "C", "J", "Q", "X", "4", "B", "I", "P", "W", "3S", "A", "H", "O", "V", "2", "9", "G", "N", "U", "1", "8", "F", "M", "T", "0", "7", "E", "L", "S", "3O"]
Codes[4] := ["0", "7", "E", "L", "S", "Z", "6", "D", "K", "R", "Y", "5", "C", "J", "Q", "X", "4T", "B", "I", "P", "W", "3", "A", "H", "O", "V", "2", "9", "G", "N", "U", "1", "8", "F", "M", "T", "4P"]
Codes[5] := ["1", "8", "F", "M", "T", "0", "7", "E", "L", "S", "Z", "6", "D", "K", "R", "Y", "5U", "C", "J", "Q", "X", "4", "B", "I", "P", "W", "3", "A", "H", "O", "V", "2", "9", "G", "N", "U", "5Q"]
Codes[6] := ["2", "9", "G", "N", "U", "1", "8", "F", "M", "T", "0", "7", "E", "L", "S", "Z", "6V", "D", "K", "R", "Y", "5", "C", "J", "Q", "X", "4", "B", "I", "P", "W", "3", "A", "H", "O", "V", "6R"]
Codes[7] := ["3", "A", "H", "O", "V", "2", "9", "G", "N", "U", "1", "8", "F", "M", "T", "0", "7W", "E", "L", "S", "Z", "6", "D", "K", "R", "Y", "5", "C", "J", "Q", "X", "4", "B", "I", "P", "W", "7S"]
Codes[8] := ["4", "B", "I", "P", "W", "3", "A", "H", "O", "V", "2", "9", "G", "N", "U", "1", "8X", "F", "M", "T", "0", "7", "E", "L", "S", "Z", "6", "D", "K", "R", "Y", "5", "C", "J", "Q", "X", "8T"]
Codes[9] := ["5", "C", "J", "Q", "X", "4", "B", "I", "P", "W", "3", "A", "H", "O", "V", "2", "9Y", "G", "N", "U", "1", "8", "F", "M", "T", "0", "7", "E", "L", "S", "Z", "6", "D", "K", "R", "Y", "9U"]
; 装填字符映射表  CodeMap[0]["W"] := "A"
CodeMap := Map()
for codeIndex in Codes {
  CodeMap[codeIndex] := Map()
  for idx, str in Codes[codeIndex] {
    CodeMap[codeIndex][str] := Chars[idx]
  }
}


/************ 窗体定义 开始 ************/
MyGui := Gui("+Resize", "LostArk文件名解码 - v" . Version)
MyGui.SetFont("s11")
InnerWidth := GUIWidth - MyGui.MarginX * 2  ; 窗体内部的可用宽度

; 目录选取区域 
MyGui.AddText("xm y18 w80 ", "游戏目录：")
DirTextEdit := MyGui.AddEdit("ReadOnly -tabstop r1 xs+80 ys-4 w" InnerWidth - 80 - 85, "")
DirSelectButton :=MyGui.AddButton("Default x+5 yp-1 h25 w80", "选择...")
DirSelectButton.OnEvent("Click", SelectDirEvent)
DirTextEdit.Value := SelectedDir  ; 显示当前选取目录

; 配置设定区域
MyGui.AddText("xm y+15 w75 ", "显示控制：")
CheckBoxCode := Map()  ; CODE选项控件组
loop 10 {
  CheckBoxCode[A_Index-1] := MyGui.AddCheckBox("Checked x+5", "CODE-" A_Index-1)
  CheckBoxCode[A_Index-1].OnEvent("Click", UpdateListView)
}
AllCodeButton := MyGui.AddButton("x+16 yp-3 h22 w50", "全选")
AllCodeButton.OnEvent("Click", ClickAllCodeButton)

; 文件窗体
ListView := MyGui.AddListView("Grid -ReadOnly r45 xm y+24 w" InnerWidth, ["文件名", "大小(KB)", "类型", "CODE-0", "CODE-1", "CODE-2", "CODE-3", "CODE-4", "CODE-5", "CODE-6", "CODE-7", "CODE-8", "CODE-9"])
ListView.OnEvent("DoubleClick", DoubleClickListItem)

; 显示窗体
MyGui.Show("w" . GUIWidth . " h" . GUIHeight)
InitListView() 
/************ 窗体定义 结束 ************/



/** 选择目录 */
SelectDirEvent(*) {
  global
  ; 优先锁定已选择目录，不存在则选取脚本所在目录
  dir := SelectedDir ? SelectedDir : A_ScriptDir
  ; 弹出选择框，不提供新建文件夹功能
  SelectedDir := DirSelect("*" dir, 6)
  DirTextEdit.Value := SelectedDir
  ; 更新目录
  InitListView()
}

/** 重置列表视图 */
InitListView(*) {
  global
  ListView.Delete()  ; 清空所有行
  ; 遍历当前目录下文件，并添加到列表中
  Loop Files, SelectedDir "\*.*"
    ListView.Add(, A_LoopFileName, A_LoopFileSizeKB, A_LoopFileExt, DecodeString(A_LoopFileName, 0), 
      DecodeString(A_LoopFileName, 1), DecodeString(A_LoopFileName, 2), DecodeString(A_LoopFileName, 3), 
      DecodeString(A_LoopFileName, 4), DecodeString(A_LoopFileName, 5), DecodeString(A_LoopFileName, 6), 
      DecodeString(A_LoopFileName, 7), DecodeString(A_LoopFileName, 8), DecodeString(A_LoopFileName, 9))
  ListView.ModifyCol(2, "Integer")  ; 为了进行排序, 指出列 2 是整数
  UpdateListView()
}

/** 更新列表视图状态 */
UpdateListView(*) {
  global
  ListView.ModifyCol(1, "AutoHdr")
  ListView.ModifyCol(2, "AutoHdr Right")
  ListView.ModifyCol(3, "AutoHdr Center")
  ; 根据CODE选项显示列表视图对应列
  for key in CheckBoxCode {
    colWidth := (CheckBoxCode[key].Value = 1) ? "AutoHdr" : 1
    ListView.ModifyCol(key+4, colWidth)
  }
}

/** 解码字符串 */
DecodeString(fileName, codeIndex := -1) {
  global
  ; 去除后缀名
  fileStr := RegExReplace(fileName, "\.\w*$")
  ; 检查codeIndex是否符合要求
  if(codeIndex < 0 or codeIndex >= Codes.Count) {
    return fileStr
  }
  ; 开始循环替换文件名中的字符
  resultStr := ""
  Loop StrLen(fileStr) {
    char := SubStr(fileStr, A_Index, 1)
    ; 判断是否为双字符码（此规则不完全确定）
    if(char = String(codeIndex)) {
      char := SubStr(fileStr, A_Index, 2)
      A_Index++
    }
    decodeChar := CodeMap[codeIndex].Has(char) ? CodeMap[codeIndex][char] : "-"
    resultStr .= decodeChar
  }
  return StrLower(resultStr)
}

/* 双击列表中的条目 */
DoubleClickListItem(listView, rowNumber) {
  ;MsgBox listView.GetText(rowNumber)  ; 从行的第一个字段中获取文本
  ;ToolTip("You double-clicked row number " RowNumber ". Text: '" listView.GetText(rowNumber) "'")
}

/** 点击全选按钮 */
ClickAllCodeButton(*) {
  global
  for key in CheckBoxCode {
    CheckBoxCode[key].Value := 1
  }
  UpdateListView()
}