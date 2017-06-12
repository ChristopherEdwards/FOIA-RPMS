 ;BEDDAPPL.EDRoom.1
 ;(C)InterSystems, generated for class BEDDAPPL.EDRoom.  Do NOT edit. 10/29/2015 07:58:24AM
 ;;7A38582B;BEDDAPPL.EDRoom
 ;
%CreateApplication(pStatus) public {
 Set pStatus = 1
 Quit ##class(BEDDAPPL.EDManager).%New()
}
%CreatePage() public {
 Set:'$IsObject($G(%application)) %application = ..%CreateApplication(.tAppStatus)
 Set:'$IsObject($G(%application)) %application = ##class(%ZEN.application).%New()
 Set %application.%StatusCode = tAppStatus
 Set tPage = ""
 Set pg1 = ..%New()
 Set %page = pg1
 Do %page.%ApplyURLParms()
 Set pg1.nextIndex=1
 Set pg1.title="ED Manager Room Setup"
 Set EDMn2 = ##class(BEDDAPPL.EDMenu).%New()
 Set EDMn2.width="100%"
 Do pg1.%AddChild(EDMn2)
 Set hgrp2 = ##class(%ZEN.Component.hgroup).%New()
 Set hgrp2.width="100%"
 Do pg1.%AddChild(hgrp2)
 Set vgrp3 = ##class(%ZEN.Component.vgroup).%New()
 Set vgrp3.width="2%"
 Do hgrp2.%AddChild(vgrp3)
 Set vgrp3 = ##class(%ZEN.Component.vgroup).%New()
 Set vgrp3.width="75%"
 Do hgrp2.%AddChild(vgrp3)
 Set spcr4 = ##class(%ZEN.Component.spacer).%New()
 Set spcr4.width=2
 Do vgrp3.%AddChild(spcr4)
 Set tblNvgtrBr4 = ##class(%ZEN.Component.tableNavigatorBar).%New()
 Set tblNvgtrBr4.id="roomNav"
 Set tblNvgtrBr4.tablePaneId="roomTable"
 Do vgrp3.%AddChild(tblNvgtrBr4)
 Set spcr4 = ##class(%ZEN.Component.spacer).%New()
 Set spcr4.width=2
 Do vgrp3.%AddChild(spcr4)
 Set tblPn4 = ##class(%ZEN.Component.tablePane).%New()
 Set tblPn4.id="roomTable"
 Set tblPn4.caption="Room Setup"
 Set clmn5 = ##class(%ZEN.Auxiliary.column).%New()
 Set clmn5.colName="ID"
 Set clmn5.hidden=1
 Do tblPn4.columns.Insert(clmn5)
 Do:$IsObject(%page) %page.%AddComponent(clmn5)
 Set clmn5 = ##class(%ZEN.Auxiliary.column).%New()
 Set clmn5.colName="RoomNo"
 Set clmn5.filterType="text"
 Set clmn5.header="Room Name"
 Set clmn5.width="15%"
 Do tblPn4.columns.Insert(clmn5)
 Do:$IsObject(%page) %page.%AddComponent(clmn5)
 Set clmn5 = ##class(%ZEN.Auxiliary.column).%New()
 Set clmn5.colName="Status"
 Set clmn5.filterEnum="Active,No Longer Used,Temporarily Unavailable"
 Set clmn5.filterEnumDisplay="Active,No Longer Used,Temporarily Unavailable"
 Set clmn5.filterOp="="
 Set clmn5.filterType="enum"
 Set clmn5.header="Status"
 Set clmn5.width="15%"
 Do tblPn4.columns.Insert(clmn5)
 Do:$IsObject(%page) %page.%AddComponent(clmn5)
 Set clmn5 = ##class(%ZEN.Auxiliary.column).%New()
 Set clmn5.colName="Occupied"
 Set clmn5.filterEnum="Yes,No"
 Set clmn5.filterEnumDisplay="Yes,No"
 Set clmn5.filterType="enum"
 Set clmn5.header="Occupied"
 Set clmn5.width="15%"
 Do tblPn4.columns.Insert(clmn5)
 Do:$IsObject(%page) %page.%AddComponent(clmn5)
 Set tblPn4.extraColumnWidth="3%"
 Set tblPn4.onselectrow="zenPage.rowSelected(zenThis);"
 Set tblPn4.orderByClause="Status, RoomNo*1000"
 Set tblPn4.pageSize=15
 Set tblPn4.showRowNumbers=1
 Set tblPn4.showZebra=1
 Set tblPn4.tableName="BEDD.EDRooms"
 Set tblPn4.useSnapshot=1
 Set tblPn4.valueColumn="ID"
 Set tblPn4.width="750px"
 Do vgrp3.%AddChild(tblPn4)
 Set hgrp2 = ##class(%ZEN.Component.hgroup).%New()
 Do pg1.%AddChild(hgrp2)
 Set vgrp3 = ##class(%ZEN.Component.vgroup).%New()
 Set vgrp3.width="10%"
 Do hgrp2.%AddChild(vgrp3)
 Set spcr4 = ##class(%ZEN.Component.spacer).%New()
 Set spcr4.width=2
 Do vgrp3.%AddChild(spcr4)
 Set dtCntrllr4 = ##class(%ZEN.Auxiliary.dataController).%New()
 Set dtCntrllr4.id="roomData"
 Set dtBg5 = ##class(%ZEN.Auxiliary.dataBag).%New()
 Set dtCntrllr4.dataBag = dtBg5
 Set dtBg5.parent = dtCntrllr4
 Do:$IsObject(%page) %page.%AddComponent(dtBg5)
 Set dtCntrllr4.modelClass="BEDDAPPL.EDRoomModel"
 Do vgrp3.%AddChild(dtCntrllr4)
 Set spcr4 = ##class(%ZEN.Component.spacer).%New()
 Set spcr4.width="10%"
 Do vgrp3.%AddChild(spcr4)
 Set fldSt4 = ##class(%ZEN.Component.fieldSet).%New()
 Set fldSt4.id="roomFormGroup"
 Set fldSt4.legend="Edit Room Info"
 Do vgrp3.%AddChild(fldSt4)
 Set frm5 = ##class(%ZEN.Component.form).%New()
 Set frm5.id="roomForm"
 Set frm5.cellStyle="padding: 2px; padding-left: 5px; padding-right: 5px;"
 Set frm5.controllerId="roomData"
 Do fldSt4.%AddChild(frm5)
 Set hgrp6 = ##class(%ZEN.Component.hgroup).%New()
 Do frm5.%AddChild(hgrp6)
 Set txt7 = ##class(%ZEN.Component.text).%New()
 Set txt7.id="RoomNo"
 Set txt7.name="RoomNo"
 Set txt7.dataBinding="RoomNo"
 Set txt7.label="Room Name:"
 Set txt7.required=1
 Set txt7.size=10
 Do hgrp6.%AddChild(txt7)
 Set spcr7 = ##class(%ZEN.Component.spacer).%New()
 Set spcr7.width=8
 Do hgrp6.%AddChild(spcr7)
 Set rdSt7 = ##class(%ZEN.Component.radioSet).%New()
 Set rdSt7.id="Status"
 Set rdSt7.name="Status"
 Set rdSt7.dataBinding="Status"
 Set rdSt7.displayList="Active,No Longer Used,Temporarily Unavailable"
 Set rdSt7.label="Status:"
 Set rdSt7.valueList="Active,No Longer Used,Temporarily Unavailable"
 Do hgrp6.%AddChild(rdSt7)
 Set spcr7 = ##class(%ZEN.Component.spacer).%New()
 Set spcr7.width=15
 Do hgrp6.%AddChild(spcr7)
 Set rdSt7 = ##class(%ZEN.Component.radioSet).%New()
 Set rdSt7.id="Occupied"
 Set rdSt7.name="Occupied"
 Set rdSt7.dataBinding="Occupied"
 Set rdSt7.displayList="Yes,No"
 Set rdSt7.label="Occupied:"
 Set rdSt7.valueList="Yes,No"
 Do hgrp6.%AddChild(rdSt7)
 Set hgrp6 = ##class(%ZEN.Component.hgroup).%New()
 Do frm5.%AddChild(hgrp6)
 Set bttn7 = ##class(%ZEN.Component.button).%New()
 Set bttn7.caption="Save"
 Set bttn7.onclick="zenPage.saveRoom();"
 Do hgrp6.%AddChild(bttn7)
 Set spcr7 = ##class(%ZEN.Component.spacer).%New()
 Set spcr7.width=10
 Do hgrp6.%AddChild(spcr7)
 Set bttn7 = ##class(%ZEN.Component.button).%New()
 Set bttn7.caption="New"
 Set bttn7.onclick="zenPage.newEntry();"
 Do hgrp6.%AddChild(bttn7)
 Set spcr7 = ##class(%ZEN.Component.spacer).%New()
 Set spcr7.width=10
 Do hgrp6.%AddChild(spcr7)
 Set bttn7 = ##class(%ZEN.Component.button).%New()
 Set bttn7.caption="Delete"
 Set bttn7.onclick="zenPage.deleteItem();"
 Do hgrp6.%AddChild(bttn7)
 Set spcr7 = ##class(%ZEN.Component.spacer).%New()
 Set spcr7.width=10
 Do hgrp6.%AddChild(spcr7)
 Set bttn7 = ##class(%ZEN.Component.button).%New()
 Set bttn7.caption="Cancel"
 Set bttn7.onclick="zenPage.cancel();"
 Do hgrp6.%AddChild(bttn7)
 Do ..%GetDependentComponents(pg1)
 Quit pg1 }
%DrawClassDefinition() public {
 Write !
 Write "self._zenClassIdx['EDRoom'] = 'BEDDAPPL_EDRoom';",!
 Write "self.BEDDAPPL_EDRoom = function(index,id) {",!
 Write $C(9),"if (index>=0) {BEDDAPPL_EDRoom__init(this,index,id);}",!
 Write "}",!
 Write !
 Write "self.BEDDAPPL_EDRoom__init = function(o,index,id) {",!
 Write $C(9),"('undefined' == typeof _ZEN_Component_page__init) ?"
 Write "zenMaster._ZEN_Component_page__init(o,index,id)"
 Write ":"
 Write "_ZEN_Component_page__init(o,index,id);",!
 Write $C(9),"o.useSoftModals = ",$S(+(..%OnUseSoftModals()):"true",1:"false"),";",!
 Write "}",!
 Set tSC=..%DrawJSSerialize()
 Quit:('tSC) tSC
 Set tSC=..%DrawJSGetSettings()
 Quit:('tSC) tSC
 Do JSClientMethod("cancel","")
 Do JSClientMethod("deleteItem","")
 Do JSClientMethod("newEntry","")
 Do JSClientMethod("rowSelected","")
 Do JSClientMethod("saveRoom","")
 Do JSClientMethod("showroomForm","id")
 Do JSSvrMethod(0,"","CurrentDate","","")
 Do JSSvrMethod(1,"BOOLEAN","LoadZenComponent","pNamespace,pName,pClassName,pCSSLevel","L,L,L,L")
 Do JSSvrMethod(1,"","MonitorBackgroundTask","pTaskID","L")
 Do JSSvrMethod(0,"","ReallyRefreshContents","","")
 Write "self.BEDDAPPL_EDRoom__Loader = function() {",!
 Set tCls = "BEDDAPPL_EDRoom"
 Write $C(9),"zenLoadClass('_ZEN_Component_page');",!
 Write $C(9),tCls,".prototype = zenCreate('_ZEN_Component_page',-1);",!
 Write $C(9),"var p = ",tCls,".prototype;",!
 Write $C(9),"if (null==p) {return;}",!
 Write $C(9),"p.constructor = ",tCls,";",!
 Write $C(9),"p.superClass = ('undefined' == typeof _ZEN_Component_page) ? zenMaster._ZEN_Component_page.prototype:_ZEN_Component_page.prototype;",!
 Write $C(9),"p.__ZENcomponent = true;",!
 Write $C(9),"p._serverClass = '"_$ZCVT("BEDDAPPL.EDRoom","O","JS")_"';",!
 Write $C(9),"p._type = '"_"EDRoom"_"';",!
 Write $C(9),"p.serialize = ",tCls,"_serialize;",!
 Write $C(9),"p.getSettings = ",tCls,"_getSettings;",!
 Write $C(9),"p.CurrentDate = ",tCls,"_CurrentDate;",!
 Write $C(9),"p.LoadZenComponent = ",tCls,"_LoadZenComponent;",!
 Write $C(9),"p.MonitorBackgroundTask = ",tCls,"_MonitorBackgroundTask;",!
 Write $C(9),"p.ReallyRefreshContents = ",tCls,"_ReallyRefreshContents;",!
 Write $C(9),"p.cancel = ",tCls,"_cancel;",!
 Write $C(9),"p.deleteItem = ",tCls,"_deleteItem;",!
 Write $C(9),"p.newEntry = ",tCls,"_newEntry;",!
 Write $C(9),"p.rowSelected = ",tCls,"_rowSelected;",!
 Write $C(9),"p.saveRoom = ",tCls,"_saveRoom;",!
 Write $C(9),"p.showroomForm = ",tCls,"_showroomForm;",!
 Write "}",!
 Quit 1
JSClientMethod(method,args)
 Write !,"self.","BEDDAPPL_EDRoom","_",method," = function(",args,") {",!
 For line=1:1:$s($d(^oddCOM("BEDDAPPL.EDRoom","m",method,30))#2:^(30),$d(^oddCOM($g(^(2),"BEDDAPPL.EDRoom"),"m",method,30))#2:^(30),1:$s($d(^oddDEF($g(^oddCOM("BEDDAPPL.EDRoom","m",method,2),"BEDDAPPL.EDRoom"),"m",method,30))#2:^(30),1:$g(^%qCacheObjectKey(1,"m",30)))) {
  If +$G(%zenStripJS) {
   Set tLine = $ZSTRIP($s($d(^oddCOM("BEDDAPPL.EDRoom","m",method,30,line))#2:^(line),$d(^oddCOM($g(^oddCOM("BEDDAPPL.EDRoom","m",method,2),"BEDDAPPL.EDRoom"),"m",method,30,line))#2:^(line),1:$g(^oddDEF($g(^oddCOM("BEDDAPPL.EDRoom","m",method,2),"BEDDAPPL.EDRoom"),"m",method,30,line))),"<>W")
   If (tLine["&") {
    Set tLine = $Replace(tLine,"&nbsp;","&#160;")
    Set tLine = $Replace(tLine,"&raquo;","&#187;")
    Set tLine = $Replace(tLine,"&laquo;","&#171;")
   }
   Write:(($L(tLine)>0)&&($E(tLine,1,2)'="//")) tLine,!
  } Else {
   Write $s($d(^oddCOM("BEDDAPPL.EDRoom","m",method,30,line))#2:^(line),$d(^oddCOM($g(^oddCOM("BEDDAPPL.EDRoom","m",method,2),"BEDDAPPL.EDRoom"),"m",method,30,line))#2:^(line),1:$g(^oddDEF($g(^oddCOM("BEDDAPPL.EDRoom","m",method,2),"BEDDAPPL.EDRoom"),"m",method,30,line))),!
  }
 }
 Write "}",!
 Quit
JSSvrMethod(cm,retType,method,args,spec)
 Write !,"self.","BEDDAPPL_EDRoom","_",method," = function(",args,") {",!
 Write $C(9),$S(retType="":"",1:"return "),$S(cm:"zenClassMethod",1:"zenInstanceMethod"),"(this,'",method,"','",spec,"','",retType,"',arguments);",!
 Write "}",!
 Quit }
%DrawJSGetSettings() public {
 Write "function BEDDAPPL_EDRoom_getSettings(s)",!
 Write "{",!
 Write $C(9),"s['name'] = 'string';",!
 Write $C(9),"this.invokeSuper('getSettings',arguments);",!
 Write "}",!
 Quit 1 }
%DrawJSSerialize() public {
 Write "function BEDDAPPL_EDRoom_serialize(set,s)",!
 Write "{",!
 Write $C(9)
 Write "var o = this;"
 Write "s[0]='"_$ZCVT(..%GetClassCRC(),"O","JS")_"';"
 Write "s[1]=o.index;"
 Write "s[2]=o.id;"
 Write "s[3]=o.name;"
 Write "s[4]=set.addObject(o.parent,'parent');"
 Write "s[5]=set.addObject(o.composite,'composite');"
 Write "s[6]=o.SVGClassList;"
 Write "s[7]=o.UserSVGPackageList;"
 Write "s[8]=o.align;"
 Write "s[9]=o.aux;"
 Write "s[10]=o.backgroundTimerInterval;"
 Write "s[11]=o.cellAlign;"
 Write "s[12]=o.cellSize;"
 Write "s[13]=o.cellStyle;"
 Write "s[14]=o.cellVAlign;"
 Write "s[15]=set.serializeList(o,o.children,true,'children');"
 Write "s[16]=o.containerStyle;"
 Write "s[17]=o.cssLevel;"
 Write "s[18]=(o.designMode?1:0);"
 Write "s[19]=(o.disabled?1:0);"
 Write "s[20]=(o.dragAndDrop?1:0);"
 Write "s[21]=(o.dragEnabled?1:0);"
 Write "s[22]=(o.dropEnabled?1:0);"
 Write "s[23]=(o.dynamic?1:0);"
 Write "s[24]=o.enclosingClass;"
 Write "s[25]=o.enclosingStyle;"
 Write "s[26]=o.error;"
 Write "s[27]=o.groupClass;"
 Write "s[28]=o.groupStyle;"
 Write "s[29]=o.height;"
 Write "s[30]=(o.hidden?1:0);"
 Write "s[31]=o.hint;"
 Write "s[32]=o.hintClass;"
 Write "s[33]=o.hintStyle;"
 Write "s[34]=(o.inlineSVG?1:0);"
 Write "s[35]=(o.isPopup?1:0);"
 Write "s[36]=(o.isSoftModal?1:0);"
 Write "s[37]=o.label;"
 Write "s[38]=o.labelClass;"
 Write "s[39]=o.labelDisabledClass;"
 Write "s[40]=o.labelPosition;"
 Write "s[41]=o.labelStyle;"
 Write "s[42]=o.lastModalIndex;"
 Write "s[43]=o.layout;"
 Write "s[44]=o.nextIndex;"
 Write "s[45]=o.onafterdrag;"
 Write "s[46]=o.onbeforedrag;"
 Write "s[47]=o.onclick;"
 Write "s[48]=o.ondrag;"
 Write "s[49]=o.ondrop;"
 Write "s[50]=o.onhide;"
 Write "s[51]=o.onoverlay;"
 Write "s[52]=o.onrefresh;"
 Write "s[53]=o.onshow;"
 Write "s[54]=o.onupdate;"
 Write "s[55]=o.overlayMode;"
 Write "s[56]=o.popupParent;"
 Write "s[57]=o.renderFlag;"
 Write "s[58]=(o.showLabel?1:0);"
 Write "s[59]=o.slice;"
 Write "s[60]=o.title;"
 Write "s[61]=o.tuple;"
 Write "s[62]=(o.useSVG?1:0);"
 Write "s[63]=(o.useSoftModals?1:0);"
 Write "s[64]=o.valign;"
 Write "s[65]=(o.visible?1:0);"
 Write "s[66]=o.width;"
 Write "s[67]=(o.zenPersistentPopup?1:0);"
 Write !,"}",!
 Quit 1 }
%DrawJSStrings(pVisited) public {
 Set tSC = 1
 If '$D(pVisited("BEDDAPPL.EDRoom")) {
  Set tSC = ##class(%ZEN.Component.page)$this.%DrawJSStrings(.pVisited)
  Set pVisited("BEDDAPPL.EDRoom") = ""
 }
 Quit tSC }
%DrawObjectProperties() public {
 Write:(..SVGClassList'="") "o.SVGClassList = '",$ZCVT(..SVGClassList,"O","JS"),"';",!
 Write:(..UserSVGPackageList'="") "o.UserSVGPackageList = '",$ZCVT(..UserSVGPackageList,"O","JS"),"';",!
 Write:(..align'="") "o.align = '",$ZCVT(..align,"O","JS"),"';",!
 Write:(..aux'="") "o.aux = '",$ZCVT(..aux,"O","JS"),"';",!
 Write:(..backgroundTimerInterval'=1000) "o.backgroundTimerInterval = ",$S($IsValidNum(..backgroundTimerInterval):..backgroundTimerInterval,1:"''"),";",!
 Write:(..cellAlign'=$parameter(,"DEFAULTCELLALIGN")) "o.cellAlign = '",$ZCVT(..cellAlign,"O","JS"),"';",!
 Write:(..cellSize'=$parameter(,"DEFAULTCELLSIZE")) "o.cellSize = '",$ZCVT(..cellSize,"O","JS"),"';",!
 Write:(..cellStyle'=$parameter(,"DEFAULTCELLSTYLE")) "o.cellStyle = '",$ZCVT(..cellStyle,"O","JS"),"';",!
 Write:(..cellVAlign'=$parameter(,"DEFAULTCELLVALIGN")) "o.cellVAlign = '",$ZCVT(..cellVAlign,"O","JS"),"';",!
 For i=1:1:..children.Count() {
  If ##class(%ZEN.Component.component).%IsA("%ZEN.Component.object") {
   Set idx = +..children.GetAt(i).index
   Write:'idx "throw new Error('Collection element is not part of the page model.\nClass: BEDDAPPL.EDRoom\nProperty: children\nElement Type:%ZEN.Component.component\nKey: ",i,"');",!
   Write "o.children[",i-1,"] = _zenIndex[",idx,"];",!
  }
 }
  If ##class(%ZEN.Component.group).%IsA("%ZEN.Component.object") {
  Write:$IsObject(..composite) "o.composite = _zenIndex[",(+..composite.index),"]",";",!
 }
 Write:(..containerStyle'="") "o.containerStyle = '",$ZCVT(..containerStyle,"O","JS"),"';",!
 Write:(..cssLevel'=2) "o.cssLevel = ",$S($IsValidNum(..cssLevel):..cssLevel,1:"''"),";",!
 Write:(..designMode'=0) "o.designMode = ",$S(+..designMode:"true",1:"false"),";",!
 Write:(..disabled'=0) "o.disabled = ",$S(+..disabled:"true",1:"false"),";",!
 Write:(..dragAndDrop'=0) "o.dragAndDrop = ",$S(+..dragAndDrop:"true",1:"false"),";",!
 Write:(..dragEnabled'=0) "o.dragEnabled = ",$S(+..dragEnabled:"true",1:"false"),";",!
 Write:(..dropEnabled'=0) "o.dropEnabled = ",$S(+..dropEnabled:"true",1:"false"),";",!
 Write:(..dynamic'=0) "o.dynamic = ",$S(+..dynamic:"true",1:"false"),";",!
 Write:(..enclosingClass'=$parameter(,"DEFAULTENCLOSINGCLASS")) "o.enclosingClass = '",$ZCVT(..enclosingClass,"O","JS"),"';",!
 Write:(..enclosingStyle'="") "o.enclosingStyle = '",$ZCVT(..enclosingStyle,"O","JS"),"';",!
 Write:(..error'="") "o.error = '",$ZCVT(..error,"O","JS"),"';",!
 Write:(..groupClass'=$parameter(,"DEFAULTGROUPCLASS")) "o.groupClass = '",$ZCVT(..groupClass,"O","JS"),"';",!
 Write:(..groupStyle'=$parameter(,"DEFAULTGROUPSTYLE")) "o.groupStyle = '",$ZCVT(..groupStyle,"O","JS"),"';",!
 Write:(..height'=$parameter(,"DEFAULTHEIGHT")) "o.height = '",$ZCVT(..height,"O","JS"),"';",!
 Write:(..hidden'=$parameter(,"DEFAULTHIDDEN")) "o.hidden = ",$S(+..hidden:"true",1:"false"),";",!
 Write:(..hint'="") "o.hint = '",$ZCVT(..hint,"O","JS"),"';",!
 Write:(..hintClass'=$parameter(,"DEFAULTHINTCLASS")) "o.hintClass = '",$ZCVT(..hintClass,"O","JS"),"';",!
 Write:(..hintStyle'="") "o.hintStyle = '",$ZCVT(..hintStyle,"O","JS"),"';",!
 Write:(..id'="") "o.id = '",$ZCVT(..id,"O","JS"),"';",!
 Write:(..inlineSVG'=$parameter(,"INLINESVG")) "o.inlineSVG = ",$S(+..inlineSVG:"true",1:"false"),";",!
 Write:(..isPopup'="") "o.isPopup = ",$S(+..isPopup:"true",1:"false"),";",!
 Write:(..isSoftModal'="") "o.isSoftModal = ",$S(+..isSoftModal:"true",1:"false"),";",!
 Write:(..label'="") "o.label = '",$ZCVT(..label,"O","JS"),"';",!
 Write:(..labelClass'=$parameter(,"DEFAULTLABELCLASS")) "o.labelClass = '",$ZCVT(..labelClass,"O","JS"),"';",!
 Write:(..labelDisabledClass'=$parameter(,"DEFAULTLABELDISABLEDCLASS")) "o.labelDisabledClass = '",$ZCVT(..labelDisabledClass,"O","JS"),"';",!
 Write:(..labelPosition'=$parameter(,"DEFAULTLABELPOSITION")) "o.labelPosition = '",$ZCVT(..labelPosition,"O","JS"),"';",!
 Write:(..labelStyle'="") "o.labelStyle = '",$ZCVT(..labelStyle,"O","JS"),"';",!
 Write:(..lastModalIndex'=0) "o.lastModalIndex = ",$S($IsValidNum(..lastModalIndex):..lastModalIndex,1:"''"),";",!
 Write:(..layout'=$parameter(,"DEFAULTLAYOUT")) "o.layout = '",$ZCVT(..layout,"O","JS"),"';",!
 Write:(..name'="") "o.name = '",$ZCVT(..name,"O","JS"),"';",!
 Write:(..nextIndex'=0) "o.nextIndex = ",$S($IsValidNum(..nextIndex):..nextIndex,1:"''"),";",!
 Write:(..onafterdrag'="") "o.onafterdrag = '",$ZCVT(..onafterdrag,"O","JS"),"';",!
 Write:(..onbeforedrag'="") "o.onbeforedrag = '",$ZCVT(..onbeforedrag,"O","JS"),"';",!
 Write:(..onclick'="") "o.onclick = '",$ZCVT(..onclick,"O","JS"),"';",!
 Write:(..ondrag'="") "o.ondrag = '",$ZCVT(..ondrag,"O","JS"),"';",!
 Write:(..ondrop'="") "o.ondrop = '",$ZCVT(..ondrop,"O","JS"),"';",!
 Write:(..onhide'="") "o.onhide = '",$ZCVT(..onhide,"O","JS"),"';",!
 Write:(..onoverlay'="") "o.onoverlay = '",$ZCVT(..onoverlay,"O","JS"),"';",!
 Write:(..onrefresh'="") "o.onrefresh = '",$ZCVT(..onrefresh,"O","JS"),"';",!
 Write:(..onshow'="") "o.onshow = '",$ZCVT(..onshow,"O","JS"),"';",!
 Write:(..onupdate'="") "o.onupdate = '",$ZCVT(..onupdate,"O","JS"),"';",!
 Write:(..overlayMode'=0) "o.overlayMode = ",$S($IsValidNum(..overlayMode):..overlayMode,1:"''"),";",!
  If ##class(%ZEN.Component.object).%IsA("%ZEN.Component.object") {
  Write:$IsObject(..parent) "o.parent = _zenIndex[",(+..parent.index),"]",";",!
 }
 Write:(..popupParent'="") "o.popupParent = ",$S($IsValidNum(..popupParent):..popupParent,1:"''"),";",!
 Write:(..renderFlag'=0) "o.renderFlag = ",$S($IsValidNum(..renderFlag):..renderFlag,1:"''"),";",!
 Write:(..showLabel'=1) "o.showLabel = ",$S(+..showLabel:"true",1:"false"),";",!
 Write:(..slice'="") "o.slice = ",$S($IsValidNum(..slice):..slice,1:"''"),";",!
 Write:(..title'=$parameter(,"PAGETITLE")) "o.title = '",$ZCVT(..title,"O","JS"),"';",!
 Write:(..tuple'="") "o.tuple = '",$ZCVT(..tuple,"O","JS"),"';",!
 Write:(..useSVG'=0) "o.useSVG = ",$S(+..useSVG:"true",1:"false"),";",!
 Write:(..useSoftModals'=..%OnUseSoftModals()) "o.useSoftModals = ",$S(+..useSoftModals:"true",1:"false"),";",!
 Write:(..valign'="") "o.valign = '",$ZCVT(..valign,"O","JS"),"';",!
 Write:(..visible'=$parameter(,"DEFAULTVISIBLE")) "o.visible = ",$S(+..visible:"true",1:"false"),";",!
 Write:(..width'=$parameter(,"DEFAULTWIDTH")) "o.width = '",$ZCVT(..width,"O","JS"),"';",!
 Write:(..window'="") "o.window = '",$ZCVT(..window,"O","JS"),"';",!
 Write:(..zenPersistentPopup'=0) "o.zenPersistentPopup = ",$S(+..zenPersistentPopup:"true",1:"false"),";",!
 Do $System.CLS.SetSModified($this,0) }
%DrawSVGDef() public {
 Write "<!-- SVGDef: BEDDAPPL.EDRoom -->",!  }
%DrawStyleHTML(pLevel=2) public {
 Write "<!-- Style: BEDDAPPL.EDRoom -->",! 
 Write "",!
	Write "<style type=""text/css"">",!
	Write "</style>",!
	Write " ",!  }
%DrawStyleSVG() public {
 Write "<!-- SVGStyle: BEDDAPPL.EDRoom -->",!  }
%GetDependentComponents(pPage) public {
   Set pPage.%ComponentClasses(6,"BEDDAPPL.EDRoom") = 1
 If ##class(%ZEN.Component.object).%IsA("%ZEN.Component.object") {
  Do AddToList(pPage,##class(%ZEN.Component.object).%GetSuperClassList())
 }
 If ##class(%ZEN.Component.page).%IsA("%ZEN.Component.object") {
  Do AddToList(pPage,##class(%ZEN.Component.page).%GetSuperClassList())
 }
 If ##class(%ZEN.Component.component).%IsA("%ZEN.Component.object") {
  Do AddToList(pPage,##class(%ZEN.Component.component).%GetSuperClassList())
 }
 If ##class(%ZEN.Component.group).%IsA("%ZEN.Component.object") {
  Do AddToList(pPage,##class(%ZEN.Component.group).%GetSuperClassList())
 }
 Quit 1
AddToList(pPage,tList)
 For n=1:1:$L(tList,",") {
  Set tSuper = $P(tList,",",n)
   Set pPage.%ComponentClasses(n,tSuper) = 0
 }
 Quit }
%GetIncludeFiles(pMode="HTML") public {
 If $D(%zenClassList("BEDDAPPL.EDRoom")) Quit
 Set %zenClassList("BEDDAPPL.EDRoom") = ""
 Do ##class(%ZEN.Component.page)$this.%GetIncludeFiles(pMode)
}
%GetIncludeInfo(pModules,pHasJS,pCSSType,pInline) public {
 Set pModules("BEDDAPPL","BEDDAPPL") = $LB(6,"")
 Set pHasJS = 0
 Set pCSSType = "HTML"
 Set pInline = 1 }
%GetPaneContents(pGroup,pPaneName,pPaneExists) public {
 Set pPaneExists = 0
 Goto Dispatch
Dispatch
Done
 Quit 1 }
%GetSuperClassList(pList) public {
 Quit "%ZEN.Component.object,%ZEN.Component.component,%ZEN.Component.abstractGroup,%ZEN.Component.group,%ZEN.Component.abstractPage,%ZEN.Component.page,BEDDAPPL.EDRoom" }
%GetXMLName(pNamespace,pName) public {
 Set pNamespace = "http://www.intersystems.com/zen"
 Set pName = "EDRoom" }
%ObjectSynch() public {
 Set tSC = 1
 Set $ZT="Trap"
 Set osp =  "o.setProperty"
 Set s%"%%OID"=0
 Set s%%ComponentClasses=0
 Set s%%ComponentIds=0
 Set s%%ComponentNames=0
 Set s%%Components=0
 Set s%%CompositeList=0
 Set s%%DeletedIds=0
 Set s%%NotifyList=0
 Set s%%RenderList=0
 Set s%%UserPackageList=0
 Set s%%condition=0
 Set s%%import=0
 Set s%%includeFiles=0
 Set s%%page=0
 Set s%%partial=0
 Set s%%resource=0
 Set s%%xmlOutputMode=0
 Quit:'$system.CLS.GetSModified($this) tSC
 Write:s%SVGClassList osp,"('SVGClassList','",$ZCVT(..SVGClassList,"O","JS"),"');",!
 Write:s%UserSVGPackageList osp,"('UserSVGPackageList','",$ZCVT(..UserSVGPackageList,"O","JS"),"');",!
 Write:s%align osp,"('align','",$ZCVT(..align,"O","JS"),"');",!
 Write:s%aux osp,"('aux','",$ZCVT(..aux,"O","JS"),"');",!
 Write:s%backgroundTimerInterval osp,"('backgroundTimerInterval',",$S($IsValidNum(..backgroundTimerInterval):..backgroundTimerInterval,1:"''"),");",!
 Write:s%cellAlign osp,"('cellAlign','",$ZCVT(..cellAlign,"O","JS"),"');",!
 Write:s%cellSize osp,"('cellSize','",$ZCVT(..cellSize,"O","JS"),"');",!
 Write:s%cellStyle osp,"('cellStyle','",$ZCVT(..cellStyle,"O","JS"),"');",!
 Write:s%cellVAlign osp,"('cellVAlign','",$ZCVT(..cellVAlign,"O","JS"),"');",!
 If (('..%partial)&&s%children) {
 Write "o.children.length = 0;",!
 For i=1:1:..children.Count() {
  If ##class(%ZEN.Component.component).%IsA("%ZEN.Component.object") {
   Set idx = +..children.GetAt(i).index
   Write:'idx "throw new Error('Collection element is not part of the page model.\nClass: BEDDAPPL.EDRoom\nProperty: children\nElement Type:%ZEN.Component.component\nKey: ",i,"');",!
   Write "o.children[",i-1,"] = _zenIndex[",idx,"];",!
  }
 }
 }
 If s%composite {
 If ##class(%ZEN.Component.group).%IsA("%ZEN.Component.object") {
  Write "o.composite = ",$S($IsObject(..composite):"_zenIndex["_(+..composite.index)_"]",1:"null"),";",!
 }
 }
 Write:s%containerStyle osp,"('containerStyle','",$ZCVT(..containerStyle,"O","JS"),"');",!
 Write:s%cssLevel "o.cssLevel = ",$S($IsValidNum(..cssLevel):..cssLevel,1:"''"),";",!
 Write:s%designMode "o.designMode = ",$S(+..designMode:"true",1:"false"),";",!
 Write:s%disabled osp,"('disabled',",$S(+..disabled:"true",1:"false"),");",!
 Write:s%dragAndDrop osp,"('dragAndDrop',",$S(+..dragAndDrop:"true",1:"false"),");",!
 Write:s%dragEnabled osp,"('dragEnabled',",$S(+..dragEnabled:"true",1:"false"),");",!
 Write:s%dropEnabled osp,"('dropEnabled',",$S(+..dropEnabled:"true",1:"false"),");",!
 Write:s%dynamic "o.dynamic = ",$S(+..dynamic:"true",1:"false"),";",!
 Write:s%enclosingClass osp,"('enclosingClass','",$ZCVT(..enclosingClass,"O","JS"),"');",!
 Write:s%enclosingStyle osp,"('enclosingStyle','",$ZCVT(..enclosingStyle,"O","JS"),"');",!
 Write:s%error "o.error = '",$ZCVT(..error,"O","JS"),"';",!
 Write:s%groupClass osp,"('groupClass','",$ZCVT(..groupClass,"O","JS"),"');",!
 Write:s%groupStyle osp,"('groupStyle','",$ZCVT(..groupStyle,"O","JS"),"');",!
 Write:s%height osp,"('height','",$ZCVT(..height,"O","JS"),"');",!
 Write:s%hidden osp,"('hidden',",$S(+..hidden:"true",1:"false"),");",!
 Write:s%hint osp,"('hint','",$ZCVT(..hint,"O","JS"),"');",!
 Write:s%hintClass osp,"('hintClass','",$ZCVT(..hintClass,"O","JS"),"');",!
 Write:s%hintStyle osp,"('hintStyle','",$ZCVT(..hintStyle,"O","JS"),"');",!
 Write:s%id osp,"('id','",$ZCVT(..id,"O","JS"),"');",!
 Write:s%inlineSVG osp,"('inlineSVG',",$S(+..inlineSVG:"true",1:"false"),");",!
 Write:s%isPopup osp,"('isPopup',",$S(+..isPopup:"true",1:"false"),");",!
 Write:s%isSoftModal osp,"('isSoftModal',",$S(+..isSoftModal:"true",1:"false"),");",!
 Write:s%label osp,"('label','",$ZCVT(..label,"O","JS"),"');",!
 Write:s%labelClass osp,"('labelClass','",$ZCVT(..labelClass,"O","JS"),"');",!
 Write:s%labelDisabledClass osp,"('labelDisabledClass','",$ZCVT(..labelDisabledClass,"O","JS"),"');",!
 Write:s%labelPosition osp,"('labelPosition','",$ZCVT(..labelPosition,"O","JS"),"');",!
 Write:s%labelStyle osp,"('labelStyle','",$ZCVT(..labelStyle,"O","JS"),"');",!
 Write:s%lastModalIndex osp,"('lastModalIndex',",$S($IsValidNum(..lastModalIndex):..lastModalIndex,1:"''"),");",!
 Write:s%layout osp,"('layout','",$ZCVT(..layout,"O","JS"),"');",!
 Write:s%name osp,"('name','",$ZCVT(..name,"O","JS"),"');",!
 Write:s%nextIndex osp,"('nextIndex',",$S($IsValidNum(..nextIndex):..nextIndex,1:"''"),");",!
 Write:s%onafterdrag osp,"('onafterdrag','",$ZCVT(..onafterdrag,"O","JS"),"');",!
 Write:s%onbeforedrag osp,"('onbeforedrag','",$ZCVT(..onbeforedrag,"O","JS"),"');",!
 Write:s%onclick osp,"('onclick','",$ZCVT(..onclick,"O","JS"),"');",!
 Write:s%ondrag osp,"('ondrag','",$ZCVT(..ondrag,"O","JS"),"');",!
 Write:s%ondrop osp,"('ondrop','",$ZCVT(..ondrop,"O","JS"),"');",!
 Write:s%onhide osp,"('onhide','",$ZCVT(..onhide,"O","JS"),"');",!
 Write:s%onoverlay osp,"('onoverlay','",$ZCVT(..onoverlay,"O","JS"),"');",!
 Write:s%onrefresh osp,"('onrefresh','",$ZCVT(..onrefresh,"O","JS"),"');",!
 Write:s%onshow osp,"('onshow','",$ZCVT(..onshow,"O","JS"),"');",!
 Write:s%onupdate osp,"('onupdate','",$ZCVT(..onupdate,"O","JS"),"');",!
 Write:s%overlayMode "o.overlayMode = ",$S($IsValidNum(..overlayMode):..overlayMode,1:"''"),";",!
 If s%parent {
 If ##class(%ZEN.Component.object).%IsA("%ZEN.Component.object") {
  Write "o.parent = ",$S($IsObject(..parent):"_zenIndex["_(+..parent.index)_"]",1:"null"),";",!
 }
 }
 Write:s%popupParent osp,"('popupParent',",$S($IsValidNum(..popupParent):..popupParent,1:"''"),");",!
 Write:s%renderFlag "o.renderFlag = ",$S($IsValidNum(..renderFlag):..renderFlag,1:"''"),";",!,"zenRenderContents(o);",!
 Write:s%showLabel osp,"('showLabel',",$S(+..showLabel:"true",1:"false"),");",!
 Write:s%slice osp,"('slice',",$S($IsValidNum(..slice):..slice,1:"''"),");",!
 Write:s%title osp,"('title','",$ZCVT(..title,"O","JS"),"');",!
 Write:s%tuple "o.tuple = '",$ZCVT(..tuple,"O","JS"),"';",!
 Write:s%useSVG osp,"('useSVG',",$S(+..useSVG:"true",1:"false"),");",!
 Write:s%useSoftModals osp,"('useSoftModals',",$S(+..useSoftModals:"true",1:"false"),");",!
 Write:s%valign osp,"('valign','",$ZCVT(..valign,"O","JS"),"');",!
 Write:s%visible "o.visible = ",$S(+..visible:"true",1:"false"),";",!
 Write:s%width osp,"('width','",$ZCVT(..width,"O","JS"),"');",!
 Write:s%zenPersistentPopup osp,"('zenPersistentPopup',",$S(+..zenPersistentPopup:"true",1:"false"),");",!
 Do $System.CLS.SetSModified($this,0)
 Quit tSC
Trap
 Set $ZT=""
 Set tSC = $$Error^%apiOBJ(5002,"BEDDAPPL.EDRoom:ObjectSynch: "_$ZE)
 Quit tSC }
zCurrentDate() public {
        Quit $$XNOW^BEDDUTIL("5D") }
zPage(skipheader=1) public {
	New %CSPsc Set %CSPsc=1
	Set dopage=(%request.Method'="HEAD")
	If %response.Language="" Do %response.MatchLanguage()
	If 'skipheader Do $zutil(96,18,2,"UTF8")
	Try {
		If ..OnPreHTTP()=0 Set dopage=0
		If 'skipheader Set %CSPsc=%response.WriteHTTPHeader(.dopage) Set:('%CSPsc) dopage=0
		If $get(dopage) Set %CSPsc=..OnPage()
	} Catch exception {
		If $ZError'["<ZTHRO"||($get(%CSPsc)="")||(+%CSPsc) Set %CSPsc=exception.AsStatus()
	}
	Do ..OnPostHTTP()
	Quit %CSPsc }
zXMLNew(document,node,containerOref="")
	Quit (##class(BEDDAPPL.EDRoom).%New())
