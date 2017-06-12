 ;BEDDAPPL.EDMenu.1
 ;(C)InterSystems, generated for class BEDDAPPL.EDMenu.  Do NOT edit. 04/14/2017 08:47:49AM
 ;;42695964;BEDDAPPL.EDMenu
 ;
%CreateComposite() public {
 Set tSC = 1
 New %composite
 Set %composite = $this
 Set cmpst1 = $this
 Set hmn2 = ##class(%ZEN.Component.hmenu).%New()
 Do cmpst1.%AddChild(hmn2)
 Set mnItm3 = ##class(%ZEN.Component.menuItem).%New()
 Set mnItm3.id="m1"
 Set mnItm3.caption="Reports"
 Set mnItm3.help="To Be Added"
 Set mnItm3.link="BEDDRPTMNU.csp"
 Do hmn2.%AddChild(mnItm3)
 Set mnItm3 = ##class(%ZEN.Component.menuItem).%New()
 Set mnItm3.id="m2"
 Set mnItm3.caption="Rooms"
 Set mnItm3.help="Go to Application Home Page"
 Set mnItm3.link="BEDDAPPL.EDRoom.cls"
 Do hmn2.%AddChild(mnItm3)
 Set mnItm3 = ##class(%ZEN.Component.menuItem).%New()
 Set mnItm3.id="m3"
 Set mnItm3.caption="Warnings"
 Set mnItm3.help="View the warnings"
 Set mnItm3.link="BEDDAPPL.EDWarning.cls"
 Do hmn2.%AddChild(mnItm3)
 Set mnItm3 = ##class(%ZEN.Component.menuItem).%New()
 Set mnItm3.id="m4"
 Do hmn2.%AddChild(mnItm3)
 Set mnItm3 = ##class(%ZEN.Component.menuItem).%New()
 Set mnItm3.id="m5"
 Set mnItm3.caption="DashBoard"
 Set mnItm3.help="return to dashboard"
 Set mnItm3.link="BEDD.csp"
 Do hmn2.%AddChild(mnItm3)
 Set mnItm3 = ##class(%ZEN.Component.menuItem).%New()
 Set mnItm3.id="m6"
 Do hmn2.%AddChild(mnItm3)
 Set mnItm3 = ##class(%ZEN.Component.menuItem).%New()
 Set mnItm3.id="m7"
 Set mnItm3.caption="Record Lock"
 Set mnItm3.help="return to dashboard"
 Set mnItm3.link="BEDDLCKREL.csp"
 Do hmn2.%AddChild(mnItm3)
 Set mnItm3 = ##class(%ZEN.Component.menuItem).%New()
 Set mnItm3.id="m8"
 Do hmn2.%AddChild(mnItm3)
 Set mnItm3 = ##class(%ZEN.Component.menuItem).%New()
 Set mnItm3.id="m9"
 Set mnItm3.caption="Setup"
 Set mnItm3.help="To Be Added"
 Set mnItm3.link="BEDDAPPL.EDSystem.cls"
 Do hmn2.%AddChild(mnItm3)
 Set mnItm3 = ##class(%ZEN.Component.menuItem).%New()
 Set mnItm3.id="m10"
 Do hmn2.%AddChild(mnItm3)
 Set ..childrenCreated = 1
 Quit tSC }
%DrawClassDefinition() public {
 Write !
 Write "self._zenClassIdx['EDMenu'] = 'BEDDAPPL_EDMenu';",!
 Write "self.BEDDAPPL_EDMenu = function(index,id) {",!
 Write $C(9),"if (index>=0) {BEDDAPPL_EDMenu__init(this,index,id);}",!
 Write "}",!
 Write !
 Write "self.BEDDAPPL_EDMenu__init = function(o,index,id) {",!
 Write $C(9),"('undefined' == typeof _ZEN_Component_composite__init) ?"
 Write "zenMaster._ZEN_Component_composite__init(o,index,id)"
 Write ":"
 Write "_ZEN_Component_composite__init(o,index,id);",!
 Write "}",!
 Set tSC=..%DrawJSSerialize()
 Quit:('tSC) tSC
 Set tSC=..%DrawJSGetSettings()
 Quit:('tSC) tSC
 Do JSSvrMethod(0,"","ReallyRefreshContents","","")
 Write "self.BEDDAPPL_EDMenu__Loader = function() {",!
 Set tCls = "BEDDAPPL_EDMenu"
 Write $C(9),"zenLoadClass('_ZEN_Component_composite');",!
 Write $C(9),tCls,".prototype = zenCreate('_ZEN_Component_composite',-1);",!
 Write $C(9),"var p = ",tCls,".prototype;",!
 Write $C(9),"if (null==p) {return;}",!
 Write $C(9),"p.constructor = ",tCls,";",!
 Write $C(9),"p.superClass = ('undefined' == typeof _ZEN_Component_composite) ? zenMaster._ZEN_Component_composite.prototype:_ZEN_Component_composite.prototype;",!
 Write $C(9),"p.__ZENcomponent = true;",!
 Write $C(9),"p._serverClass = '"_$ZCVT("BEDDAPPL.EDMenu","O","JS")_"';",!
 Write $C(9),"p._type = '"_"EDMenu"_"';",!
 Write $C(9),"p.serialize = ",tCls,"_serialize;",!
 Write $C(9),"p.getSettings = ",tCls,"_getSettings;",!
 Write $C(9),"p.ReallyRefreshContents = ",tCls,"_ReallyRefreshContents;",!
 Write "}",!
 Quit 1
JSClientMethod(method,args)
 Write !,"self.","BEDDAPPL_EDMenu","_",method," = function(",args,") {",!
 For line=1:1:$s($d(^oddCOM("BEDDAPPL.EDMenu","m",method,30))#2:^(30),$d(^oddCOM($g(^(2),"BEDDAPPL.EDMenu"),"m",method,30))#2:^(30),1:$s($d(^oddDEF($g(^oddCOM("BEDDAPPL.EDMenu","m",method,2),"BEDDAPPL.EDMenu"),"m",method,30))#2:^(30),1:$g(^%qCacheObjectKey(1,"m",30)))) {
  If +$G(%zenStripJS) {
   Set tLine = $ZSTRIP($s($d(^oddCOM("BEDDAPPL.EDMenu","m",method,30,line))#2:^(line),$d(^oddCOM($g(^oddCOM("BEDDAPPL.EDMenu","m",method,2),"BEDDAPPL.EDMenu"),"m",method,30,line))#2:^(line),1:$g(^oddDEF($g(^oddCOM("BEDDAPPL.EDMenu","m",method,2),"BEDDAPPL.EDMenu"),"m",method,30,line))),"<>W")
   If (tLine["&") {
    Set tLine = $Replace(tLine,"&nbsp;","&#160;")
    Set tLine = $Replace(tLine,"&raquo;","&#187;")
    Set tLine = $Replace(tLine,"&laquo;","&#171;")
   }
   Write:(($L(tLine)>0)&&($E(tLine,1,2)'="//")) tLine,!
  } Else {
   Write $s($d(^oddCOM("BEDDAPPL.EDMenu","m",method,30,line))#2:^(line),$d(^oddCOM($g(^oddCOM("BEDDAPPL.EDMenu","m",method,2),"BEDDAPPL.EDMenu"),"m",method,30,line))#2:^(line),1:$g(^oddDEF($g(^oddCOM("BEDDAPPL.EDMenu","m",method,2),"BEDDAPPL.EDMenu"),"m",method,30,line))),!
  }
 }
 Write "}",!
 Quit
JSSvrMethod(cm,retType,method,args,spec)
 Write !,"self.","BEDDAPPL_EDMenu","_",method," = function(",args,") {",!
 Write $C(9),$S(retType="":"",1:"return "),$S(cm:"zenClassMethod",1:"zenInstanceMethod"),"(this,'",method,"','",spec,"','",retType,"',arguments);",!
 Write "}",!
 Quit }
%DrawJSGetSettings() public {
 Write "function BEDDAPPL_EDMenu_getSettings(s)",!
 Write "{",!
 Write $C(9),"s['name'] = 'string';",!
 Write $C(9),"this.invokeSuper('getSettings',arguments);",!
 Write "}",!
 Quit 1 }
%DrawJSSerialize() public {
 Write "function BEDDAPPL_EDMenu_serialize(set,s)",!
 Write "{",!
 Write $C(9)
 Write "var o = this;"
 Write "s[0]='"_$ZCVT(..%GetClassCRC(),"O","JS")_"';"
 Write "s[1]=o.index;"
 Write "s[2]=o.id;"
 Write "s[3]=o.name;"
 Write "s[4]=set.addObject(o.parent,'parent');"
 Write "s[5]=set.addObject(o.composite,'composite');"
 Write "s[6]=o.align;"
 Write "s[7]=o.aux;"
 Write "s[8]=o.cellAlign;"
 Write "s[9]=o.cellSize;"
 Write "s[10]=o.cellStyle;"
 Write "s[11]=o.cellVAlign;"
 Write "s[12]=set.serializeList(o,o.children,true,'children');"
 Write "s[13]=(o.childrenCreated?1:0);"
 Write "s[14]=o.containerStyle;"
 Write "s[15]=(o.disabled?1:0);"
 Write "s[16]=(o.dragEnabled?1:0);"
 Write "s[17]=(o.dropEnabled?1:0);"
 Write "s[18]=(o.dynamic?1:0);"
 Write "s[19]=o.enclosingClass;"
 Write "s[20]=o.enclosingStyle;"
 Write "s[21]=o.error;"
 Write "s[22]=o.groupClass;"
 Write "s[23]=o.groupStyle;"
 Write "s[24]=o.height;"
 Write "s[25]=(o.hidden?1:0);"
 Write "s[26]=o.hint;"
 Write "s[27]=o.hintClass;"
 Write "s[28]=o.hintStyle;"
 Write "s[29]=o.label;"
 Write "s[30]=o.labelClass;"
 Write "s[31]=o.labelDisabledClass;"
 Write "s[32]=o.labelPosition;"
 Write "s[33]=o.labelStyle;"
 Write "s[34]=o.layout;"
 Write "s[35]=o.onafterdrag;"
 Write "s[36]=o.onbeforedrag;"
 Write "s[37]=o.onclick;"
 Write "s[38]=o.ondrag;"
 Write "s[39]=o.ondrop;"
 Write "s[40]=o.onhide;"
 Write "s[41]=o.onrefresh;"
 Write "s[42]=o.onshow;"
 Write "s[43]=o.onupdate;"
 Write "s[44]=o.overlayMode;"
 Write "s[45]=o.renderFlag;"
 Write "s[46]=(o.showLabel?1:0);"
 Write "s[47]=o.slice;"
 Write "s[48]=o.title;"
 Write "s[49]=o.tuple;"
 Write "s[50]=o.valign;"
 Write "s[51]=(o.visible?1:0);"
 Write "s[52]=o.width;"
 Write !,"}",!
 Quit 1 }
%DrawJSStrings(pVisited) public {
 Set tSC = 1
 If '$D(pVisited("BEDDAPPL.EDMenu")) {
  Set tSC = ##class(%ZEN.Component.composite)$this.%DrawJSStrings(.pVisited)
  Set pVisited("BEDDAPPL.EDMenu") = ""
 }
 Quit tSC }
%DrawObjectProperties() public {
 Write:(..align'="") "o.align = '",$ZCVT(..align,"O","JS"),"';",!
 Write:(..aux'="") "o.aux = '",$ZCVT(..aux,"O","JS"),"';",!
 Write:(..cellAlign'=$parameter(,"DEFAULTCELLALIGN")) "o.cellAlign = '",$ZCVT(..cellAlign,"O","JS"),"';",!
 Write:(..cellSize'=$parameter(,"DEFAULTCELLSIZE")) "o.cellSize = '",$ZCVT(..cellSize,"O","JS"),"';",!
 Write:(..cellStyle'=$parameter(,"DEFAULTCELLSTYLE")) "o.cellStyle = '",$ZCVT(..cellStyle,"O","JS"),"';",!
 Write:(..cellVAlign'=$parameter(,"DEFAULTCELLVALIGN")) "o.cellVAlign = '",$ZCVT(..cellVAlign,"O","JS"),"';",!
 For i=1:1:..children.Count() {
  If ##class(%ZEN.Component.component).%IsA("%ZEN.Component.object") {
   Set idx = +..children.GetAt(i).index
   Write:'idx "throw new Error('Collection element is not part of the page model.\nClass: BEDDAPPL.EDMenu\nProperty: children\nElement Type:%ZEN.Component.component\nKey: ",i,"');",!
   Write "o.children[",i-1,"] = _zenIndex[",idx,"];",!
  }
 }
 Write:(..childrenCreated'=0) "o.childrenCreated = ",$S(+..childrenCreated:"true",1:"false"),";",!
  If ##class(%ZEN.Component.group).%IsA("%ZEN.Component.object") {
  Write:$IsObject(..composite) "o.composite = _zenIndex[",(+..composite.index),"]",";",!
 }
 Write:(..containerStyle'="") "o.containerStyle = '",$ZCVT(..containerStyle,"O","JS"),"';",!
 Write:(..disabled'=0) "o.disabled = ",$S(+..disabled:"true",1:"false"),";",!
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
 Write:(..label'="") "o.label = '",$ZCVT(..label,"O","JS"),"';",!
 Write:(..labelClass'=$parameter(,"DEFAULTLABELCLASS")) "o.labelClass = '",$ZCVT(..labelClass,"O","JS"),"';",!
 Write:(..labelDisabledClass'=$parameter(,"DEFAULTLABELDISABLEDCLASS")) "o.labelDisabledClass = '",$ZCVT(..labelDisabledClass,"O","JS"),"';",!
 Write:(..labelPosition'=$parameter(,"DEFAULTLABELPOSITION")) "o.labelPosition = '",$ZCVT(..labelPosition,"O","JS"),"';",!
 Write:(..labelStyle'="") "o.labelStyle = '",$ZCVT(..labelStyle,"O","JS"),"';",!
 Write:(..layout'=$parameter(,"DEFAULTLAYOUT")) "o.layout = '",$ZCVT(..layout,"O","JS"),"';",!
 Write:(..name'="") "o.name = '",$ZCVT(..name,"O","JS"),"';",!
 Write:(..onafterdrag'="") "o.onafterdrag = '",$ZCVT(..onafterdrag,"O","JS"),"';",!
 Write:(..onbeforedrag'="") "o.onbeforedrag = '",$ZCVT(..onbeforedrag,"O","JS"),"';",!
 Write:(..onclick'="") "o.onclick = '",$ZCVT(..onclick,"O","JS"),"';",!
 Write:(..ondrag'="") "o.ondrag = '",$ZCVT(..ondrag,"O","JS"),"';",!
 Write:(..ondrop'="") "o.ondrop = '",$ZCVT(..ondrop,"O","JS"),"';",!
 Write:(..onhide'="") "o.onhide = '",$ZCVT(..onhide,"O","JS"),"';",!
 Write:(..onrefresh'="") "o.onrefresh = '",$ZCVT(..onrefresh,"O","JS"),"';",!
 Write:(..onshow'="") "o.onshow = '",$ZCVT(..onshow,"O","JS"),"';",!
 Write:(..onupdate'="") "o.onupdate = '",$ZCVT(..onupdate,"O","JS"),"';",!
 Write:(..overlayMode'=0) "o.overlayMode = ",$S($IsValidNum(..overlayMode):..overlayMode,1:"''"),";",!
  If ##class(%ZEN.Component.object).%IsA("%ZEN.Component.object") {
  Write:$IsObject(..parent) "o.parent = _zenIndex[",(+..parent.index),"]",";",!
 }
 Write:(..renderFlag'=0) "o.renderFlag = ",$S($IsValidNum(..renderFlag):..renderFlag,1:"''"),";",!
 Write:(..showLabel'=1) "o.showLabel = ",$S(+..showLabel:"true",1:"false"),";",!
 Write:(..slice'="") "o.slice = ",$S($IsValidNum(..slice):..slice,1:"''"),";",!
 Write:(..title'="") "o.title = '",$ZCVT(..title,"O","JS"),"';",!
 Write:(..tuple'="") "o.tuple = '",$ZCVT(..tuple,"O","JS"),"';",!
 Write:(..valign'="") "o.valign = '",$ZCVT(..valign,"O","JS"),"';",!
 Write:(..visible'=$parameter(,"DEFAULTVISIBLE")) "o.visible = ",$S(+..visible:"true",1:"false"),";",!
 Write:(..width'=$parameter(,"DEFAULTWIDTH")) "o.width = '",$ZCVT(..width,"O","JS"),"';",!
 Write:(..window'="") "o.window = '",$ZCVT(..window,"O","JS"),"';",!
 Do $System.CLS.SetSModified($this,0) }
%DrawSVGDef() public {
 Write "<!-- SVGDef: BEDDAPPL.EDMenu -->",!  }
%DrawStyleHTML(pLevel=2) public {
 Write "<!-- Style: BEDDAPPL.EDMenu -->",! 
 Write "",!
	Write "<style type=""text/css"">",!
	Write "/*Styles for components in this composite component*/",!
	Write "  .title {",!
	Write "          background: #C5D6D6;",!
	Write "          color: black;",!
	Write "          font-size: 1.5em;",!
	Write "          font-weight: bold;",!
	Write "          padding: 5px;",!
	Write "          border-bottom: 1px solid black;",!
	Write "          text-align: center;",!
	Write "    }",!
	Write "/* Default style overrides*/",!
	Write "/* Override default menu item style */",!
	Write "  a.menuItem {",!
	Write "         font-size: 0.9em;",!
	Write "         color: black;",!
	Write "   }",!
	Write "  a.menuItemDisabled {",!
	Write "        font-size: 0.9em;",!
	Write "        color: black;",!
	Write "  }",!
	Write "</style>",!
	Write " ",!  }
%DrawStyleSVG() public {
 Write "<!-- SVGStyle: BEDDAPPL.EDMenu -->",!  }
%GenerateCode(pCode,pLocalize,pURIList,pCollection,pLevel=1,pMode="page",pKey="",pParentVar="unknown") public {
 Set tVar = "EDMn"_pLevel
 If ((..%condition '= "")||(..%resource '= "")) {
  Set tCond = $S(..%condition="":"",1:"("_..%condition_")")
  Set tRsc = $S(..%resource="":"",1:"$system.Security.Check("""_..%resource_""",""USE"")")
  Set tAND = $S((tCond="")||(tRsc=""):"",1:"&&")
  Do pCode.WriteLine(" If ("_tRsc_tAND_tCond_") {")
 }
 If (pLevel>1) {
  Do pCode.WriteLine(" Set "_tVar_" = ##class(BEDDAPPL.EDMenu).%New()")
 } Else {
  If (pMode = "composite") {
    Do pCode.WriteLine(" Set "_tVar_" = ##this")
  } ElseIf (pMode = "pane") {
    Do pCode.WriteLine(" Set "_tVar_" = pGroup")
  } Else {
   Do pCode.WriteLine(" Set "_tVar_" = ..%New()")
   Do pCode.WriteLine(" Set %page = "_tVar_"")
   Do pCode.WriteLine(" Do %page.%ApplyURLParms()")
  }
 }
 Do:(..%import'="") pCode.WriteLine(" Set "_tVar_".%import="_..%QuoteValue(..%import))
 Do:(..id'="") pCode.WriteLine(" Set "_tVar_".id="_..%QuoteValue(..id))
 Do:(..name'="") pCode.WriteLine(" Set "_tVar_".name="_..%QuoteValue(..name))
 Do:(..%condition'=("")) pCode.WriteLine(" Set "_tVar_".%condition="_..%QuoteValue(..%condition))
 Do:(..%resource'=("")) pCode.WriteLine(" Set "_tVar_".%resource="_..%QuoteValue(..%resource))
 Do:(..align'=("")) pCode.WriteLine(" Set "_tVar_".align="_..%QuoteValue(..align))
 Do:(..aux'=("")) pCode.WriteLine(" Set "_tVar_".aux="_..%QuoteValue(..aux))
 Do:(..cellAlign'=($parameter(,"DEFAULTCELLALIGN"))) pCode.WriteLine(" Set "_tVar_".cellAlign="_..%QuoteValue(..cellAlign))
 Do:(..cellSize'=($parameter(,"DEFAULTCELLSIZE"))) pCode.WriteLine(" Set "_tVar_".cellSize="_..%QuoteValue(..cellSize))
 Do:(..cellStyle'=($parameter(,"DEFAULTCELLSTYLE"))) pCode.WriteLine(" Set "_tVar_".cellStyle="_..%QuoteValue(..cellStyle))
 Do:(..cellVAlign'=($parameter(,"DEFAULTCELLVALIGN"))) pCode.WriteLine(" Set "_tVar_".cellVAlign="_..%QuoteValue(..cellVAlign))
 Do:(..childrenCreated'=(0)) pCode.WriteLine(" Set "_tVar_".childrenCreated="_..%QuoteValue(..childrenCreated))
 Do:($IsObject(..composite)&&(..composite.%IsA("%ZEN.Component.object"))) ..composite.%GenerateCode(pCode,pLocalize,.pURIList,"composite",pLevel+1,pMode,$C(0),tVar)
 Do:(..containerStyle'=("")) pCode.WriteLine(" Set "_tVar_".containerStyle="_..%QuoteValue(..containerStyle))
 Do:(..disabled'=(0)) pCode.WriteLine(" Set "_tVar_".disabled="_..%QuoteValue(..disabled))
 Do:(..dragEnabled'=(0)) pCode.WriteLine(" Set "_tVar_".dragEnabled="_..%QuoteValue(..dragEnabled))
 Do:(..dropEnabled'=(0)) pCode.WriteLine(" Set "_tVar_".dropEnabled="_..%QuoteValue(..dropEnabled))
 Do:(..dynamic'=(0)) pCode.WriteLine(" Set "_tVar_".dynamic="_..%QuoteValue(..dynamic))
 Do:(..enclosingClass'=($parameter(,"DEFAULTENCLOSINGCLASS"))) pCode.WriteLine(" Set "_tVar_".enclosingClass="_..%QuoteValue(..enclosingClass))
 Do:(..enclosingStyle'=("")) pCode.WriteLine(" Set "_tVar_".enclosingStyle="_..%QuoteValue(..enclosingStyle))
 Do:(..error'=("")) pCode.WriteLine(" Set "_tVar_".error="_..%QuoteValue(..error))
 Do:(..groupClass'=($parameter(,"DEFAULTGROUPCLASS"))) pCode.WriteLine(" Set "_tVar_".groupClass="_..%QuoteValue(..groupClass))
 Do:(..groupStyle'=($parameter(,"DEFAULTGROUPSTYLE"))) pCode.WriteLine(" Set "_tVar_".groupStyle="_..%QuoteValue(..groupStyle))
 Do:(..height'=($parameter(,"DEFAULTHEIGHT"))) pCode.WriteLine(" Set "_tVar_".height="_..%QuoteValue(..height))
 Do:(..hidden'=($parameter(,"DEFAULTHIDDEN"))) pCode.WriteLine(" Set "_tVar_".hidden="_..%QuoteValue(..hidden))
 If (pLocalize) {
 Do:(..hint'=("")) pCode.WriteLine(" Set "_tVar_".hint="_..%QuoteValueL10N(..hint)_"")
 } Else {
 Do:(..hint'=("")) pCode.WriteLine(" Set "_tVar_".hint="_..%QuoteValue(..hint))
 }
 Do:(..hintClass'=($parameter(,"DEFAULTHINTCLASS"))) pCode.WriteLine(" Set "_tVar_".hintClass="_..%QuoteValue(..hintClass))
 Do:(..hintStyle'=("")) pCode.WriteLine(" Set "_tVar_".hintStyle="_..%QuoteValue(..hintStyle))
 If (pLocalize) {
 Do:(..label'=("")) pCode.WriteLine(" Set "_tVar_".label="_..%QuoteValueL10N(..label)_"")
 } Else {
 Do:(..label'=("")) pCode.WriteLine(" Set "_tVar_".label="_..%QuoteValue(..label))
 }
 Do:(..labelClass'=($parameter(,"DEFAULTLABELCLASS"))) pCode.WriteLine(" Set "_tVar_".labelClass="_..%QuoteValue(..labelClass))
 Do:(..labelDisabledClass'=($parameter(,"DEFAULTLABELDISABLEDCLASS"))) pCode.WriteLine(" Set "_tVar_".labelDisabledClass="_..%QuoteValue(..labelDisabledClass))
 Do:(..labelPosition'=($parameter(,"DEFAULTLABELPOSITION"))) pCode.WriteLine(" Set "_tVar_".labelPosition="_..%QuoteValue(..labelPosition))
 Do:(..labelStyle'=("")) pCode.WriteLine(" Set "_tVar_".labelStyle="_..%QuoteValue(..labelStyle))
 Do:(..layout'=($parameter(,"DEFAULTLAYOUT"))) pCode.WriteLine(" Set "_tVar_".layout="_..%QuoteValue(..layout))
 Do:(..onafterdrag'=("")) pCode.WriteLine(" Set "_tVar_".onafterdrag="_..%QuoteValue(..onafterdrag))
 Do:(..onbeforedrag'=("")) pCode.WriteLine(" Set "_tVar_".onbeforedrag="_..%QuoteValue(..onbeforedrag))
 Do:(..onclick'=("")) pCode.WriteLine(" Set "_tVar_".onclick="_..%QuoteValue(..onclick))
 Do:(..ondrag'=("")) pCode.WriteLine(" Set "_tVar_".ondrag="_..%QuoteValue(..ondrag))
 Do:(..ondrop'=("")) pCode.WriteLine(" Set "_tVar_".ondrop="_..%QuoteValue(..ondrop))
 Do:(..onhide'=("")) pCode.WriteLine(" Set "_tVar_".onhide="_..%QuoteValue(..onhide))
 Do:(..onrefresh'=("")) pCode.WriteLine(" Set "_tVar_".onrefresh="_..%QuoteValue(..onrefresh))
 Do:(..onshow'=("")) pCode.WriteLine(" Set "_tVar_".onshow="_..%QuoteValue(..onshow))
 Do:(..onupdate'=("")) pCode.WriteLine(" Set "_tVar_".onupdate="_..%QuoteValue(..onupdate))
 Do:(..overlayMode'=(0)) pCode.WriteLine(" Set "_tVar_".overlayMode="_..%QuoteValue(..overlayMode))
 Do:($IsObject(..parent)&&(..parent.%IsA("%ZEN.Component.object"))) ..parent.%GenerateCode(pCode,pLocalize,.pURIList,"parent",pLevel+1,pMode,$C(0),tVar)
 Do:(..renderFlag'=(0)) pCode.WriteLine(" Set "_tVar_".renderFlag="_..%QuoteValue(..renderFlag))
 Do:(..showLabel'=(1)) pCode.WriteLine(" Set "_tVar_".showLabel="_..%QuoteValue(..showLabel))
 Do:(..slice'=("")) pCode.WriteLine(" Set "_tVar_".slice="_..%QuoteValue(..slice))
 If (pLocalize) {
 Do:(..title'=("")) pCode.WriteLine(" Set "_tVar_".title="_..%QuoteValueL10N(..title)_"")
 } Else {
 Do:(..title'=("")) pCode.WriteLine(" Set "_tVar_".title="_..%QuoteValue(..title))
 }
 Do:(..tuple'=("")) pCode.WriteLine(" Set "_tVar_".tuple="_..%QuoteValue(..tuple))
 Do:(..valign'=("")) pCode.WriteLine(" Set "_tVar_".valign="_..%QuoteValue(..valign))
 Do:(..visible'=($parameter(,"DEFAULTVISIBLE"))) pCode.WriteLine(" Set "_tVar_".visible="_..%QuoteValue(..visible))
 Do:(..width'=($parameter(,"DEFAULTWIDTH"))) pCode.WriteLine(" Set "_tVar_".width="_..%QuoteValue(..width))
 Do:(..window'=("")) pCode.WriteLine(" Set "_tVar_".window="_..%QuoteValue(..window))
 If (pLevel>1) {
  If ((pCollection="children")) {
  Do pCode.WriteLine(" Do "_pParentVar_".%AddChild("_tVar_")")
  } Else {
   If (pKey="") {
    Do pCode.WriteLine(" Do "_pParentVar_"."_pCollection_".Insert("_tVar_")")
   }
   ElseIf (pKey=$C(0)) {
    Do pCode.WriteLine(" Set "_pParentVar_"."_pCollection_" = "_tVar)
    Do pCode.WriteLine(" Set "_tVar_".parent = "_pParentVar)
   }
   Else {
    Do pCode.WriteLine(" Do "_pParentVar_"."_pCollection_".SetAt("_tVar_","""_pKey_""")")
    Do pCode.WriteLine(" Set "_tVar_".parent = "_pParentVar)
   }
  Do pCode.WriteLine(" Do:$IsObject(%page) %page.%AddComponent("_tVar_")")
  }
 }
 For n=1:1:..children.Count() {
  Do ..children.GetAt(n).%GenerateCode(pCode,pLocalize,.pURIList,"children",pLevel+1,pMode,,tVar)
 }
 If ((..%condition '= "") || (..%resource '= "")) {
  Do pCode.WriteLine(" }")
 } }
%GetIncludeFiles(pMode="HTML") public {
 If $D(%zenClassList("BEDDAPPL.EDMenu")) Quit
 Set %zenClassList("BEDDAPPL.EDMenu") = ""
 Do ##class(%ZEN.Component.composite)$this.%GetIncludeFiles(pMode)
 Set:(pMode="HTML") %zenIncludeJS(2,1,"BEDDAPPL","BEDDAPPL.js") = $LB("js",5,"BEDDAPPL.EDMenu")
 Set:(pMode="HTML") %zenIncludeCSS(2,1,"BEDDAPPL","BEDDAPPL.cssx") = $LB("html",5) }
%GetIncludeInfo(pModules,pHasJS,pCSSType,pInline) public {
 Set pModules("BEDDAPPL","BEDDAPPL") = $LB(5,"")
 Set pHasJS = 1
 Set pCSSType = "HTML"
 Set pInline = 0 }
%GetPaneContents(pGroup,pPaneName,pPaneExists) public {
 Set pPaneExists = 0
 Goto Dispatch
Dispatch
Done
 Quit 1 }
%GetSuperClassList(pList) public {
 Quit "%ZEN.Component.object,%ZEN.Component.component,%ZEN.Component.abstractGroup,%ZEN.Component.group,%ZEN.Component.composite,BEDDAPPL.EDMenu" }
%GetXMLName(pNamespace,pName) public {
 Set pNamespace = ""
 Set pName = "EDMenu" }
%ObjectSynch() public {
 Set tSC = 1
 Set $ZT="Trap"
 Set osp =  "o.setProperty"
 Set s%"%%OID"=0
 Set s%%condition=0
 Set s%%import=0
 Set s%%includeFiles=0
 Set s%%page=0
 Set s%%partial=0
 Set s%%resource=0
 Quit:'$system.CLS.GetSModified($this) tSC
 Write:s%align osp,"('align','",$ZCVT(..align,"O","JS"),"');",!
 Write:s%aux osp,"('aux','",$ZCVT(..aux,"O","JS"),"');",!
 Write:s%cellAlign osp,"('cellAlign','",$ZCVT(..cellAlign,"O","JS"),"');",!
 Write:s%cellSize osp,"('cellSize','",$ZCVT(..cellSize,"O","JS"),"');",!
 Write:s%cellStyle osp,"('cellStyle','",$ZCVT(..cellStyle,"O","JS"),"');",!
 Write:s%cellVAlign osp,"('cellVAlign','",$ZCVT(..cellVAlign,"O","JS"),"');",!
 If (('..%partial)&&s%children) {
 Write "o.children.length = 0;",!
 For i=1:1:..children.Count() {
  If ##class(%ZEN.Component.component).%IsA("%ZEN.Component.object") {
   Set idx = +..children.GetAt(i).index
   Write:'idx "throw new Error('Collection element is not part of the page model.\nClass: BEDDAPPL.EDMenu\nProperty: children\nElement Type:%ZEN.Component.component\nKey: ",i,"');",!
   Write "o.children[",i-1,"] = _zenIndex[",idx,"];",!
  }
 }
 }
 Write:s%childrenCreated osp,"('childrenCreated',",$S(+..childrenCreated:"true",1:"false"),");",!
 If s%composite {
 If ##class(%ZEN.Component.group).%IsA("%ZEN.Component.object") {
  Write "o.composite = ",$S($IsObject(..composite):"_zenIndex["_(+..composite.index)_"]",1:"null"),";",!
 }
 }
 Write:s%containerStyle osp,"('containerStyle','",$ZCVT(..containerStyle,"O","JS"),"');",!
 Write:s%disabled osp,"('disabled',",$S(+..disabled:"true",1:"false"),");",!
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
 Write:s%label osp,"('label','",$ZCVT(..label,"O","JS"),"');",!
 Write:s%labelClass osp,"('labelClass','",$ZCVT(..labelClass,"O","JS"),"');",!
 Write:s%labelDisabledClass osp,"('labelDisabledClass','",$ZCVT(..labelDisabledClass,"O","JS"),"');",!
 Write:s%labelPosition osp,"('labelPosition','",$ZCVT(..labelPosition,"O","JS"),"');",!
 Write:s%labelStyle osp,"('labelStyle','",$ZCVT(..labelStyle,"O","JS"),"');",!
 Write:s%layout osp,"('layout','",$ZCVT(..layout,"O","JS"),"');",!
 Write:s%name osp,"('name','",$ZCVT(..name,"O","JS"),"');",!
 Write:s%onafterdrag osp,"('onafterdrag','",$ZCVT(..onafterdrag,"O","JS"),"');",!
 Write:s%onbeforedrag osp,"('onbeforedrag','",$ZCVT(..onbeforedrag,"O","JS"),"');",!
 Write:s%onclick osp,"('onclick','",$ZCVT(..onclick,"O","JS"),"');",!
 Write:s%ondrag osp,"('ondrag','",$ZCVT(..ondrag,"O","JS"),"');",!
 Write:s%ondrop osp,"('ondrop','",$ZCVT(..ondrop,"O","JS"),"');",!
 Write:s%onhide osp,"('onhide','",$ZCVT(..onhide,"O","JS"),"');",!
 Write:s%onrefresh osp,"('onrefresh','",$ZCVT(..onrefresh,"O","JS"),"');",!
 Write:s%onshow osp,"('onshow','",$ZCVT(..onshow,"O","JS"),"');",!
 Write:s%onupdate osp,"('onupdate','",$ZCVT(..onupdate,"O","JS"),"');",!
 Write:s%overlayMode "o.overlayMode = ",$S($IsValidNum(..overlayMode):..overlayMode,1:"''"),";",!
 If s%parent {
 If ##class(%ZEN.Component.object).%IsA("%ZEN.Component.object") {
  Write "o.parent = ",$S($IsObject(..parent):"_zenIndex["_(+..parent.index)_"]",1:"null"),";",!
 }
 }
 Write:s%renderFlag "o.renderFlag = ",$S($IsValidNum(..renderFlag):..renderFlag,1:"''"),";",!,"zenRenderContents(o);",!
 Write:s%showLabel osp,"('showLabel',",$S(+..showLabel:"true",1:"false"),");",!
 Write:s%slice osp,"('slice',",$S($IsValidNum(..slice):..slice,1:"''"),");",!
 Write:s%title osp,"('title','",$ZCVT(..title,"O","JS"),"');",!
 Write:s%tuple "o.tuple = '",$ZCVT(..tuple,"O","JS"),"';",!
 Write:s%valign osp,"('valign','",$ZCVT(..valign,"O","JS"),"');",!
 Write:s%visible "o.visible = ",$S(+..visible:"true",1:"false"),";",!
 Write:s%width osp,"('width','",$ZCVT(..width,"O","JS"),"');",!
 Do $System.CLS.SetSModified($this,0)
 Quit tSC
Trap
 Set $ZT=""
 Set tSC = $$Error^%apiOBJ(5002,"BEDDAPPL.EDMenu:ObjectSynch: "_$ZE)
 Quit tSC }
zXMLExportInternal()
 New tag,summary,attrsVal,savelocal,aval,k,tmpPrefix,prefixDepth,hasNoContent,hasElement,topAttrs,beginprefix,endprefix,savexsiAttrs,initialxsiAttrs,initlist,initialCR,inlineFlag,popAtEnd,saveTopPrefix,saveTypesPrefix,saveAttrsPrefix,saveUsePrefix
 Set $ztrap="XMLExportInternalTrap",popAtEnd=0
 If encoded Quit $$Error^%apiOBJ(6231,fmt)
 Set summary=summaryArg,initialxsiAttrs=xsiAttrs
 If group Quit $$Error^%apiOBJ(6386,"BEDDAPPL.EDMenu")
 If indentFlag Set initialCR=($extract(currentIndent,1,2)=$c(13,10))
 Set id=createId
 Set temp=""
 If id'="" {
   If $piece($get(idlist(+$this)),",",2)'="" Quit 1
   Set idlist(+$this)=id_",1"
 }
 If 'nocycle {
   If $data(oreflist($this)) Quit $$Error^%apiOBJ(6296,"BEDDAPPL.EDMenu")
   Set oreflist($this)=""
 }
 Set tag=$get(topArg)
 Set tmpi=(($get(typeAttr)'="")&&(typeAttr'="BEDDAPPL.EDMenu"))
 If $IsObject(namespaces) {
     Set popAtEnd=1,saveTopPrefix=topPrefix,saveTypesPrefix=typesPrefix,saveAttrsPrefix=attrsPrefix,saveUsePrefix=usePrefix
     Set sc=namespaces.PushNodeForExport("",$get(local,0),tmpi,"",,.topPrefix,.topAttrs,.typesPrefix,.attrsPrefix,.usePrefix)
     If 'sc Quit sc
   Set beginprefix=$select(namespaces.ElementQualified&&usePrefix:typesPrefix,1:"")
   If topAttrs'="" Set temp=temp_" "_topAttrs
   If tag="" Set tag="EDMenu"
   Set xsitype=namespaces.OutputTypeAttribute
 } Else {
   Set saveTopPrefix=topPrefix,saveTypesPrefix=typesPrefix,saveAttrsPrefix=attrsPrefix,saveUsePrefix=usePrefix
   Set typesPrefix=namespaces If (typesPrefix'=""),($extract(typesPrefix,*)'=":") Set typesPrefix=typesPrefix_":"
   Set namespaces=""
   Set (topPrefix,attrsPrefix,topAttrs,beginprefix)=""
   If tag="" Set tag=typesPrefix_"EDMenu"
   Set xsitype=0
 }
 Set local=+$get(local),savelocal=local
 Set endprefix="</"_beginprefix,beginprefix="<"_beginprefix
 If tmpi Set temp=temp_" "_xsiPrefix_"type="""_typesPrefix_"EDMenu"""_xsiAttrs,xsiAttrs=""
   If id'="" Set temp=" "_$select($get(soap12):soapPrefix_"id",1:"id")_"=""id"_id_""""_temp
 If indentFlag Set %xmlmsg=currentIndent if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg } Set currentIndent=$select(initialCR:"",1:$c(13,10))_currentIndent_indentChars
 If tag[":" Set topPrefix=$piece(tag,":"),tag=$piece(tag,":",2)  If topPrefix'="" Set topPrefix=topPrefix_":"
 Set %xmlmsg="<"_topPrefix_tag_temp if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set attrsVal=attrsArg,attrsArg="" Set %xmlmsg=attrsVal if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..%condition
 Set %xmlmsg=" "_attrsPrefix_"condition="""_$select(val=$c(0):"",1:$zcvt(val,"O","XML"))_"""" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..%resource
 Set %xmlmsg=" "_attrsPrefix_"resource="""_$select(val=$c(0):"",1:$zcvt(val,"O","XML"))_"""" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..%import
 Set %xmlmsg=" "_attrsPrefix_"import="""_$select(val=$c(0):"",1:$zcvt(val,"O","XML"))_"""" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..id
 Set %xmlmsg=" "_attrsPrefix_"id="""_$select(val=$c(0):"",1:$zcvt(val,"O","XML"))_"""" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..name
 Set %xmlmsg=" "_attrsPrefix_"name="""_$select(val=$c(0):"",1:$zcvt(val,"O","XML"))_"""" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..aux
 Set %xmlmsg=" "_attrsPrefix_"aux="""_$select(val=$c(0):"",1:$zcvt(val,"O","XML"))_"""" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..onupdate
 Set %xmlmsg=" "_attrsPrefix_"onupdate="""_$select(val=$c(0):"",1:$zcvt(val,"O","XML"))_"""" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..label
 Set %xmlmsg=" "_attrsPrefix_"label="""_$select(val=$c(0):"",1:$zcvt(val,"O","XML"))_"""" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..labelClass
 Set %xmlmsg=" "_attrsPrefix_"labelClass="""_$select(val=$c(0):"",1:$zcvt(val,"O","XML"))_"""" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..labelDisabledClass
 Set %xmlmsg=" "_attrsPrefix_"labelDisabledClass="""_$select(val=$c(0):"",1:$zcvt(val,"O","XML"))_"""" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..labelStyle
 Set %xmlmsg=" "_attrsPrefix_"labelStyle="""_$select(val=$c(0):"",1:$zcvt(val,"O","XML"))_"""" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..showLabel
 Set %xmlmsg=" "_attrsPrefix_"showLabel="""_$select(val=$c(0):"",1:$select(val:"true",1:"false"))_"""" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..hint
 Set %xmlmsg=" "_attrsPrefix_"hint="""_$select(val=$c(0):"",1:$zcvt(val,"O","XML"))_"""" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..hintClass
 Set %xmlmsg=" "_attrsPrefix_"hintClass="""_$select(val=$c(0):"",1:$zcvt(val,"O","XML"))_"""" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..hintStyle
 Set %xmlmsg=" "_attrsPrefix_"hintStyle="""_$select(val=$c(0):"",1:$zcvt(val,"O","XML"))_"""" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..title
 Set %xmlmsg=" "_attrsPrefix_"title="""_$select(val=$c(0):"",1:$zcvt(val,"O","XML"))_"""" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..hidden
 Set %xmlmsg=" "_attrsPrefix_"hidden="""_$select(val=$c(0):"",1:$select(val:"true",1:"false"))_"""" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..onshow
 Set %xmlmsg=" "_attrsPrefix_"onshow="""_$select(val=$c(0):"",1:$zcvt(val,"O","XML"))_"""" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..onhide
 Set %xmlmsg=" "_attrsPrefix_"onhide="""_$select(val=$c(0):"",1:$zcvt(val,"O","XML"))_"""" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..onrefresh
 Set %xmlmsg=" "_attrsPrefix_"onrefresh="""_$select(val=$c(0):"",1:$zcvt(val,"O","XML"))_"""" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..dragEnabled
 Set %xmlmsg=" "_attrsPrefix_"dragEnabled="""_$select(val=$c(0):"",1:$select(val:"true",1:"false"))_"""" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..dropEnabled
 Set %xmlmsg=" "_attrsPrefix_"dropEnabled="""_$select(val=$c(0):"",1:$select(val:"true",1:"false"))_"""" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..onbeforedrag
 Set %xmlmsg=" "_attrsPrefix_"onbeforedrag="""_$select(val=$c(0):"",1:$zcvt(val,"O","XML"))_"""" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..ondrag
 Set %xmlmsg=" "_attrsPrefix_"ondrag="""_$select(val=$c(0):"",1:$zcvt(val,"O","XML"))_"""" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..onafterdrag
 Set %xmlmsg=" "_attrsPrefix_"onafterdrag="""_$select(val=$c(0):"",1:$zcvt(val,"O","XML"))_"""" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..ondrop
 Set %xmlmsg=" "_attrsPrefix_"ondrop="""_$select(val=$c(0):"",1:$zcvt(val,"O","XML"))_"""" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..containerStyle
 Set %xmlmsg=" "_attrsPrefix_"containerStyle="""_$select(val=$c(0):"",1:$zcvt(val,"O","XML"))_"""" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..align
 Set %xmlmsg=" "_attrsPrefix_"align="""_$select(val=$c(0):"",1:$zcvt(val,"O","XML"))_"""" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..valign
 Set %xmlmsg=" "_attrsPrefix_"valign="""_$select(val=$c(0):"",1:$zcvt(val,"O","XML"))_"""" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..width
 Set %xmlmsg=" "_attrsPrefix_"width="""_$select(val=$c(0):"",1:$zcvt(val,"O","XML"))_"""" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..height
 Set %xmlmsg=" "_attrsPrefix_"height="""_$select(val=$c(0):"",1:$zcvt(val,"O","XML"))_"""" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..slice
 Set %xmlmsg=" "_attrsPrefix_"slice="""_$select(val=$c(0):"",1:$zcvt(val,"O","XML"))_"""" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..enclosingClass
 Set %xmlmsg=" "_attrsPrefix_"enclosingClass="""_$select(val=$c(0):"",1:$zcvt(val,"O","XML"))_"""" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..enclosingStyle
 Set %xmlmsg=" "_attrsPrefix_"enclosingStyle="""_$select(val=$c(0):"",1:$zcvt(val,"O","XML"))_"""" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..disabled
 Set %xmlmsg=" "_attrsPrefix_"disabled="""_$select(val=$c(0):"",1:$select(val:"true",1:"false"))_"""" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..layout
 Set %xmlmsg=" "_attrsPrefix_"layout="""_$select(val=$c(0):"",1:$zcvt(val,"O","XML"))_"""" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..cellAlign
 Set %xmlmsg=" "_attrsPrefix_"cellAlign="""_$select(val=$c(0):"",1:$zcvt(val,"O","XML"))_"""" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..cellVAlign
 Set %xmlmsg=" "_attrsPrefix_"cellVAlign="""_$select(val=$c(0):"",1:$zcvt(val,"O","XML"))_"""" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..cellSize
 Set %xmlmsg=" "_attrsPrefix_"cellSize="""_$select(val=$c(0):"",1:$zcvt(val,"O","XML"))_"""" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..labelPosition
 Set %xmlmsg=" "_attrsPrefix_"labelPosition="""_$select(val=$c(0):"",1:$zcvt(val,"O","XML"))_"""" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..groupStyle
 Set %xmlmsg=" "_attrsPrefix_"groupStyle="""_$select(val=$c(0):"",1:$zcvt(val,"O","XML"))_"""" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..cellStyle
 Set %xmlmsg=" "_attrsPrefix_"cellStyle="""_$select(val=$c(0):"",1:$zcvt(val,"O","XML"))_"""" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..groupClass
 Set %xmlmsg=" "_attrsPrefix_"groupClass="""_$select(val=$c(0):"",1:$zcvt(val,"O","XML"))_"""" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..onclick
 Set %xmlmsg=" "_attrsPrefix_"onclick="""_$select(val=$c(0):"",1:$zcvt(val,"O","XML"))_"""" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set %xmlmsg=">" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set prefixDepth=0
 Set prefixDepth=0
 Set prefixDepth=0
 Set prefixDepth=0
 Set prefixDepth=0
 Set prefixDepth=0
 Set prefixDepth=0
 Set prefixDepth=0
 Set prefixDepth=0
 Set prefixDepth=0
 Set prefixDepth=0
 Set prefixDepth=0
 Set prefixDepth=0
 Set prefixDepth=0
 Set prefixDepth=0
 Set prefixDepth=0
 Set prefixDepth=0
 Set prefixDepth=0
 Set prefixDepth=0
 Set prefixDepth=0
 Set prefixDepth=0
 Set prefixDepth=0
 Set prefixDepth=0
 Set prefixDepth=0
 Set prefixDepth=0
 Set prefixDepth=0
 Set prefixDepth=0
 Set prefixDepth=0
 Set prefixDepth=0
 Set prefixDepth=0
 Set prefixDepth=0
 Set prefixDepth=0
 Set prefixDepth=0
 Set prefixDepth=0
 Set prefixDepth=0
 Set aval=..children
 Set k="" Set:deepFlag val=aval.GetNext(.k) If k'="" {
   While k'="" {
     If $IsObject(val) {
         Set topArg="",summaryArg=1,group=0,createId="",typeAttr=$select(xsitype:"*",1:""),local=$select(prefixDepth>0:1,1:0),savexsiAttrs=xsiAttrs
         Set sc=val.XMLExportInternal() Goto:'sc XMLExportExit Set xsiAttrs=savexsiAttrs
     } Else {
       If $isobject(namespaces) { Set sc=namespaces.PushNodeForExport($parameter("%ZEN.Component.component","NAMESPACE"),''prefixDepth,0,"","",.tmpPrefix,.topAttrs,,,,0) Goto:'sc XMLExportExit Set prefixDepth=prefixDepth+1 Set tmpPrefix(prefixDepth)=tmpPrefix Set:(topAttrs'="") topAttrs=" "_topAttrs } Else { Set tmpPrefix=$extract(beginprefix,2,*),topAttrs=""}
       Set %xmlmsg=currentIndent_"<"_tmpPrefix_"component"_topAttrs_" "_xsiPrefix_"nil=""true"""_xsiAttrs_"/>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
       If $isobject(namespaces) Do namespaces.PopNode() Set prefixDepth=prefixDepth-1 Set tmpPrefix=$get(tmpPrefix(prefixDepth))
     }
     Set val=aval.GetNext(.k)
   }
 }
 Set prefixDepth=0
 Set prefixDepth=0
 Set prefixDepth=0
 Set prefixDepth=0
 Set prefixDepth=0
 Set prefixDepth=0
 Set prefixDepth=0
 Set prefixDepth=0
 Set prefixDepth=0
 Set prefixDepth=0
 If indentFlag Set currentIndent=$extract(currentIndent,1,*-$length(indentChars)) Set %xmlmsg=currentIndent if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set %xmlmsg="</"_topPrefix_tag_">" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg } If indentFlag,'initialCR if $data(%xmlBlock) { Set %xmlmsg="" Do xeWriteLine^%occXMLInternal } else { write ! } Set $extract(currentIndent,1,2)=""
 If '$IsObject(namespaces) || (popAtEnd=1) Set topPrefix=saveTopPrefix,typesPrefix=saveTypesPrefix,attrsPrefix=saveAttrsPrefix,usePrefix=saveUsePrefix
 If popAtEnd Do namespaces.PopNode()
   If 'nocycle Kill oreflist($this)
 Quit sc
XMLExportInternalTrap Set $ztrap=""
 If $data(val) , $IsObject(val) , ($piece($ze,">",1)="<METHOD DOES NOT EXIST") {
   Set sc=$$Error^%apiOBJ(6249,$classname(val))
 } Else {
   Set sc=$$Error^%apiOBJ(5002,$ze)
 }
XMLExportExit 
 If '$IsObject(namespaces) || (popAtEnd=1) Set topPrefix=saveTopPrefix,typesPrefix=saveTypesPrefix,attrsPrefix=saveAttrsPrefix,usePrefix=saveUsePrefix
 If popAtEnd Do namespaces.PopNode()
 Quit sc
zXMLGetSchemaImports(imports,classes)
 Quit ##class(%XML.Implementation).XMLGetSchemaImports("BEDDAPPL.EDMenu",.imports,.classes)
zXMLImportInternal()
 New child,node,data,ref,encodedArray,loopref,element,key,nsIndex
 Set $ztrap="XMLImportInternalTrap"
 If $case($piece(fmt,",",1),"":0,"literal":0,:1) Quit $$Error^%apiOBJ(6231,fmt)
 Set nsIndex=$select($get(namespace)="":"",1:$get(@(tree)@("ns",namespace)))
 Set (node,ref)=nodeArg
 If ($listget($get(@(tree)@(node,0)),1)'="e")||(tag'=@(tree)@(node)) Goto XMLImportMalformed
 If bareProjection Quit $$Error^%apiOBJ(6386,"BEDDAPPL.EDMenu")
 Set sc=..XMLImportAttributes() If 'sc Quit sc
 If +$listget($get(@(tree)@(node,0)),7,0) Quit 1
 Set sc=$$XMLImportElements()
XMLImportExit Quit sc
XMLImportElements() ;
 Set child=""
XMLLOOP For  { Set child=$order(@(tree)@(node,"c",child)) If (child="")||($listget($get(@(tree)@(child,0)),1)'="w") Quit }
 If child="" Quit sc
 Set tag=@(tree)@(child)
 Set ref=child
 If $listget($get(@(tree)@(ref,0)),1)'="e" Goto XMLImportMalformedNoTag
 Set class=$get(^oddCOM("%ZEN.Component.component",85,"n",tag))_$get(^oddXML("%ZEN.Component.component","n",tag)) If class="" Set class=0
 If class'=0 {
   Set tmp=$select($listget($get(@(tree)@(ref,0)),3)="":"",1:$get(@(tree)@("ns#",$list(@(tree)@(ref,0),3))))
   If ($listlength(class)>1),(tmp="") Goto XMLImportNS
   If tmp'="" {
     For tmpi=1:1:$listlength(class) {
       Set tmpns=$parameter($list(class,tmpi),"NAMESPACE")
       If tmp=tmpns Set class=$list(class,tmpi),tmpi=0 Quit
     }
     If tmpi { For tmpi=1:1:$listlength(class) {
       Set tmpns=$parameter($list(class,tmpi),"NAMESPACE")
       If tmpns="" Set class=$list(class,tmpi),tmpi=0 Quit
     } }
     If tmpi Goto XMLImportNS
   } Else { Set class=$list(class) }
   If $listget($get(@(tree)@(ref,0)),1)'="e" Goto XMLImportMalformedNoTag
     Set class=$get(^oddCOM("%ZEN.Component.component",85,"n",@(tree)@(ref)))_$get(^oddXML("%ZEN.Component.component","n",@(tree)@(ref))) If class="" Set class=0
   If class=0 Goto XMLImportBadTag
   Set tmp=$select($listget($get(@(tree)@(ref,0)),3)="":"",1:$get(@(tree)@("ns#",$list(@(tree)@(ref,0),3))))
   If ($listlength(class)>1),(tmp="") Goto XMLImportNS
   If tmp'="" {
     For tmpi=1:1:$listlength(class) {
       Set tmpns=$parameter($list(class,tmpi),"NAMESPACE")
       If tmp=tmpns Set class=$list(class,tmpi),tmpi=0 Quit
     }
     If tmpi { For tmpi=1:1:$listlength(class) {
       Set tmpns=$parameter($list(class,tmpi),"NAMESPACE")
       If tmpns="" Set class=$list(class,tmpi),tmpi=0 Quit
     } }
     If tmpi Goto XMLImportNS
   } Else { Set class=$list(class) }
   Set data=$classmethod(class,"XMLNew",handler,ref,$this)
   If $isobject(data) Set tag=@(tree)@(ref),nodeArg=ref,bareProjection=0,summaryArg=1,keynameattr="",sc=data.XMLImportInternal() If ('sc) Goto XMLImportExit
   If data'="" Do ..children.Insert(data)
   Goto XMLLOOP }
 Goto XMLImportBadTag
XMLImportBadTag Quit $$Error^%apiOBJ(6237,tag_$$XMLImportLocation(ref))
XMLImportBadType Quit $$Error^%apiOBJ(6277,class,@(tree)@(ref)_$$XMLImportLocation(ref))
XMLImportErr
 Set data=$order(@(tree)@(ref,"c",""))
 If (data'="") {
   If $listget($get(@(tree)@(data,0)),1)'="e" {
     Quit $$Error^%apiOBJ(6232,@(tree)@(ref)_$$XMLImportLocation(ref),$extract(@(tree)@(data),1,200))
   } Else {
     Quit $$Error^%apiOBJ(6253,@(tree)@(ref)_$$XMLImportLocation(ref),@(tree)@(data))
   }
 } Else {
   Quit $$Error^%apiOBJ(6252,@(tree)@(ref)_$$XMLImportLocation(ref))
 }
XMLImportIdErr Set sc=$$Error^%apiOBJ(6236,id,@(tree)@(ref)_$$XMLImportLocation(ref)) Quit sc
XMLImportMalformed Set sc=$$Error^%apiOBJ(6233,@(tree)@(ref)_$$XMLImportLocation(ref)) Quit sc
XMLImportMalformedNoTag Set node=$listget($get(@(tree)@(ref,0)),2),sc=$$Error^%apiOBJ(6254,@(tree)@(ref),@(tree)@(node)_$$XMLImportLocation(node)) Quit sc
XMLImportNS Set sc=$$Error^%apiOBJ(6235,@(tree)@(ref)_$$XMLImportLocation(ref)) Quit sc
XMLImportLocation(node) new msg,loc
 Set loc=$lb($listget($get(@(tree)@(node,0)),5),$listget($get(@(tree)@(node,0)),6))
 If loc="" Quit ""
 Set msg=$get(^%qCacheMsg("%ObjectErrors",$s(""'="":$zcvt("","L"),1:$get(^||%Language,"en")),"XMLImportLocation")," (%1,%2)")
 Quit $$FormatText^%occMessages(msg,$listget(loc,1),$listget(loc,2))
XMLImportInternalTrap Set $ztrap=""
 If $ZE["<CLASS DOES NOT EXIST>" Goto XMLImportBadTag
 Quit $$Error^%apiOBJ(5002,$ZE)
XMLImportId() ;
 If $data(@(tree)@(ref,"a","href")) {
   Set id=$get(@(tree)@(ref,"a","href"))
   If $extract(id)="#" {
     Set tmp=$get(@(tree)@("id",$extract(id,2,*))) If tmp="" Goto XMLImportIdErr
     Set ref=tmp
   }
 } ElseIf $data(@(tree)@(ref,"a","ref")) , ($select($get(@(tree)@(ref,"a","ref","u"))="":"",1:$get(@(tree)@("ns#",@(tree)@(ref,"a","ref","u"))))="http://www.w3.org/2003/05/soap-encoding") {
   Set id=$get(@(tree)@(ref,"a","ref"))
   Set tmp=$get(@(tree)@("id",id)) If tmp="" Goto XMLImportIdErr
   Set ref=tmp
 } ElseIf '$data(@(tree)@(ref,"a","id")) {
   Quit 0
 }
 Quit $data(idlist(ref))
zXMLNew(document,node,containerOref="")
	Quit (##class(BEDDAPPL.EDMenu).%New())
zXMLSchema(top="",format="",namespacePrefix="",input=0,refOnly=0,schema)
 Quit ##class(%XML.Implementation).XMLSchema("BEDDAPPL.EDMenu",top,format,namespacePrefix,input,refOnly,.schema)
