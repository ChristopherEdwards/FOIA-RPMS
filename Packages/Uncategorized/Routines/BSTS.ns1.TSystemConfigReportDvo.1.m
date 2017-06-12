 ;BSTS.ns1.TSystemConfigReportDvo.1
 ;(C)InterSystems, generated for class BSTS.ns1.TSystemConfigReportDvo.  Do NOT edit. 10/22/2016 08:53:37AM
 ;;7475344D;BSTS.ns1.TSystemConfigReportDvo
 ;
%NormalizeObject() public {
	If '$system.CLS.GetModified() Quit 1
	If m%databaseSystemContext Set:i%databaseSystemContext'="" i%databaseSystemContext=(..databaseSystemContextNormalize(i%databaseSystemContext))
	If m%displayString Set:i%displayString'="" i%displayString=(..displayStringNormalize(i%displayString))
	If m%freeMemory Set:i%freeMemory'="" i%freeMemory=(..freeMemoryNormalize(i%freeMemory))
	If m%javaClassPath Set:i%javaClassPath'="" i%javaClassPath=(..javaClassPathNormalize(i%javaClassPath))
	If m%javaImplementationVersion Set:i%javaImplementationVersion'="" i%javaImplementationVersion=(..javaImplementationVersionNormalize(i%javaImplementationVersion))
	If m%javaSystemVersion Set:i%javaSystemVersion'="" i%javaSystemVersion=(..javaSystemVersionNormalize(i%javaSystemVersion))
	If m%maxMemory Set:i%maxMemory'="" i%maxMemory=(..maxMemoryNormalize(i%maxMemory))
	If m%osArchitecture Set:i%osArchitecture'="" i%osArchitecture=(..osArchitectureNormalize(i%osArchitecture))
	If m%osName Set:i%osName'="" i%osName=(..osNameNormalize(i%osName))
	If m%osVersion Set:i%osVersion'="" i%osVersion=(..osVersionNormalize(i%osVersion))
	If m%processors Set:i%processors'="" i%processors=(..processorsNormalize(i%processors))
	If m%sessionContext Set:i%sessionContext'="" i%sessionContext=(..sessionContextNormalize(i%sessionContext))
	If m%totalMemory Set:i%totalMemory'="" i%totalMemory=(..totalMemoryNormalize(i%totalMemory))
	If m%usedMemory Set:i%usedMemory'="" i%usedMemory=(..usedMemoryNormalize(i%usedMemory))
	Quit 1 }
%ValidateObject(force=0) public {
	Set sc=1
	If '$system.CLS.GetModified() Quit sc
	Set iv=..databaseSystemContext If iv="" Set rc=$$Error^%apiOBJ(5659,$classname()_"::"_"databaseSystemContext"_"("_$this_",ID="),sc=$select(+sc:rc,1:$$AppendStatus^%occSystem(sc,rc))
	If m%databaseSystemContext Set rc=(..databaseSystemContextIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"databaseSystemContext",iv)
	Set iv=..displayString If iv="" Set rc=$$Error^%apiOBJ(5659,$classname()_"::"_"displayString"_"("_$this_",ID="),sc=$select(+sc:rc,1:$$AppendStatus^%occSystem(sc,rc))
	If m%displayString Set rc=(..displayStringIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"displayString",iv)
	Set iv=..freeMemory If iv="" Set rc=$$Error^%apiOBJ(5659,$classname()_"::"_"freeMemory"_"("_$this_",ID="),sc=$select(+sc:rc,1:$$AppendStatus^%occSystem(sc,rc))
	If m%freeMemory Set rc=(..freeMemoryIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"freeMemory",iv)
	Set iv=..javaClassPath If iv="" Set rc=$$Error^%apiOBJ(5659,$classname()_"::"_"javaClassPath"_"("_$this_",ID="),sc=$select(+sc:rc,1:$$AppendStatus^%occSystem(sc,rc))
	If m%javaClassPath Set rc=(..javaClassPathIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"javaClassPath",iv)
	Set iv=..javaImplementationVersion If iv="" Set rc=$$Error^%apiOBJ(5659,$classname()_"::"_"javaImplementationVersion"_"("_$this_",ID="),sc=$select(+sc:rc,1:$$AppendStatus^%occSystem(sc,rc))
	If m%javaImplementationVersion Set rc=(..javaImplementationVersionIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"javaImplementationVersion",iv)
	Set iv=..javaSystemVersion If iv="" Set rc=$$Error^%apiOBJ(5659,$classname()_"::"_"javaSystemVersion"_"("_$this_",ID="),sc=$select(+sc:rc,1:$$AppendStatus^%occSystem(sc,rc))
	If m%javaSystemVersion Set rc=(..javaSystemVersionIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"javaSystemVersion",iv)
	Set iv=..maxMemory If iv="" Set rc=$$Error^%apiOBJ(5659,$classname()_"::"_"maxMemory"_"("_$this_",ID="),sc=$select(+sc:rc,1:$$AppendStatus^%occSystem(sc,rc))
	If m%maxMemory Set rc=(..maxMemoryIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"maxMemory",iv)
	Set iv=..osArchitecture If iv="" Set rc=$$Error^%apiOBJ(5659,$classname()_"::"_"osArchitecture"_"("_$this_",ID="),sc=$select(+sc:rc,1:$$AppendStatus^%occSystem(sc,rc))
	If m%osArchitecture Set rc=(..osArchitectureIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"osArchitecture",iv)
	Set iv=..osName If iv="" Set rc=$$Error^%apiOBJ(5659,$classname()_"::"_"osName"_"("_$this_",ID="),sc=$select(+sc:rc,1:$$AppendStatus^%occSystem(sc,rc))
	If m%osName Set rc=(..osNameIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"osName",iv)
	Set iv=..osVersion If iv="" Set rc=$$Error^%apiOBJ(5659,$classname()_"::"_"osVersion"_"("_$this_",ID="),sc=$select(+sc:rc,1:$$AppendStatus^%occSystem(sc,rc))
	If m%osVersion Set rc=(..osVersionIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"osVersion",iv)
	Set iv=..processors If iv="" Set rc=$$Error^%apiOBJ(5659,$classname()_"::"_"processors"_"("_$this_",ID="),sc=$select(+sc:rc,1:$$AppendStatus^%occSystem(sc,rc))
	If m%processors Set rc=(..processorsIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"processors",iv)
	Set iv=..sessionContext If iv="" Set rc=$$Error^%apiOBJ(5659,$classname()_"::"_"sessionContext"_"("_$this_",ID="),sc=$select(+sc:rc,1:$$AppendStatus^%occSystem(sc,rc))
	If m%sessionContext Set rc=(..sessionContextIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"sessionContext",iv)
	Set iv=..totalMemory If iv="" Set rc=$$Error^%apiOBJ(5659,$classname()_"::"_"totalMemory"_"("_$this_",ID="),sc=$select(+sc:rc,1:$$AppendStatus^%occSystem(sc,rc))
	If m%totalMemory Set rc=(..totalMemoryIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"totalMemory",iv)
	Set iv=..usedMemory If iv="" Set rc=$$Error^%apiOBJ(5659,$classname()_"::"_"usedMemory"_"("_$this_",ID="),sc=$select(+sc:rc,1:$$AppendStatus^%occSystem(sc,rc))
	If m%usedMemory Set rc=(..usedMemoryIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"usedMemory",iv)
	Quit sc }
zXMLDTD(top,format,input,dtdlist)
 Quit ##class(%XML.Implementation).XMLDTD("BSTS.ns1.TSystemConfigReportDvo",.top,.format,.input,.dtdlist)
zXMLExportInternal()
 New tag,summary,attrsVal,savelocal,aval,k,tmpPrefix,prefixDepth,hasNoContent,hasElement,topAttrs,beginprefix,endprefix,savexsiAttrs,initialxsiAttrs,initlist,initialCR,inlineFlag,popAtEnd,saveTopPrefix,saveTypesPrefix,saveAttrsPrefix,saveUsePrefix,initlist
 Set $ztrap="XMLExportInternalTrap",popAtEnd=0
 Set summary=summaryArg,initialxsiAttrs=xsiAttrs
 If group Quit $$Error^%apiOBJ(6386,"BSTS.ns1.TSystemConfigReportDvo")
 If indentFlag Set initialCR=($extract(currentIndent,1,2)=$c(13,10))
 Set id=createId
 Set temp=""
 If id'="" {
   If $piece($get(idlist(+$this)),",",2)'="" Quit 1
   Set idlist(+$this)=id_",1"
 }
 If encoded Set initlist=$lb($get(oreflist),inlineFlagArg),oreflist=1,inlineFlag=inlineFlagArg
 If 'nocycle,('encoded||inlineFlag) {
   If $data(oreflist($this)) Quit $$Error^%apiOBJ(6296,"BSTS.ns1.TSystemConfigReportDvo")
   Set oreflist($this)=""
 }
 Set tag=$get(topArg)
 Set tmpi=(($get(typeAttr)'="")&&(typeAttr'="BSTS.ns1.TSystemConfigReportDvo"))
 If $IsObject(namespaces) {
   If namespaces.Stable,namespaces.CurrentNamespace="http://apelon.com/dtsserver/types",'tmpi||(typesPrefix'="") {
     Set topAttrs=""
   } Else {
     Set popAtEnd=1,saveTopPrefix=topPrefix,saveTypesPrefix=typesPrefix,saveAttrsPrefix=attrsPrefix,saveUsePrefix=usePrefix
     Set sc=namespaces.PushNodeForExport("http://apelon.com/dtsserver/types",$get(local,0),(encoded||tmpi),1,,.topPrefix,.topAttrs,.typesPrefix,.attrsPrefix,.usePrefix)
     If 'sc Quit sc
   }
   Set beginprefix=$select(usePrefix:typesPrefix,1:"")
   If topAttrs'="" Set temp=temp_" "_topAttrs
   If tag="" Set tag="TSystemConfigReportDvo"
   Set xsitype=namespaces.OutputTypeAttribute
 } Else {
   Set saveTopPrefix=topPrefix,saveTypesPrefix=typesPrefix,saveAttrsPrefix=attrsPrefix,saveUsePrefix=usePrefix
   Set typesPrefix=namespaces If (typesPrefix'=""),($extract(typesPrefix,*)'=":") Set typesPrefix=typesPrefix_":"
   If 'encoded Set namespaces=""
   Set (topPrefix,attrsPrefix,topAttrs,beginprefix)=""
   If tag="" Set tag=typesPrefix_"TSystemConfigReportDvo"
   Set xsitype=0
 }
 Set local=+$get(local),savelocal=local
 Set endprefix="</"_beginprefix,beginprefix="<"_beginprefix
 If tmpi Set temp=temp_" "_xsiPrefix_"type="""_typesPrefix_"TSystemConfigReportDvo"""_xsiAttrs,xsiAttrs=""
   If id'="" Set temp=" "_$select($get(soap12):soapPrefix_"id",1:"id")_"=""id"_id_""""_temp
 If encoded Set temp=temp_xsiAttrs,xsiAttrs=""
 If indentFlag Set %xmlmsg=currentIndent if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg } Set currentIndent=$select(initialCR:"",1:$c(13,10))_currentIndent_indentChars
 If tag[":" Set topPrefix=$piece(tag,":"),tag=$piece(tag,":",2)  If topPrefix'="" Set topPrefix=topPrefix_":"
 Set %xmlmsg="<"_topPrefix_tag_temp if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set attrsVal=attrsArg,attrsArg="" Set %xmlmsg=attrsVal if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set %xmlmsg=">" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..usedMemory
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"usedMemory"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"long""",1:"")_">"_val_endprefix_"usedMemory>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..freeMemory
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"freeMemory"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"long""",1:"")_">"_val_endprefix_"freeMemory>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..totalMemory
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"totalMemory"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"long""",1:"")_">"_val_endprefix_"totalMemory>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..maxMemory
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"maxMemory"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"long""",1:"")_">"_val_endprefix_"maxMemory>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..processors
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"processors"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"int""",1:"")_">"_val_endprefix_"processors>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..javaImplementationVersion
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"javaImplementationVersion"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"string""",1:"")_">"_$select(val=$c(0):"",1:$select((val["<")||(val[">")||(val["&"):"<![CDATA["_$replace(val,"]]>","]]]]><![CDATA[>")_"]]>",1:val))_endprefix_"javaImplementationVersion>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..javaSystemVersion
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"javaSystemVersion"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"string""",1:"")_">"_$select(val=$c(0):"",1:$select((val["<")||(val[">")||(val["&"):"<![CDATA["_$replace(val,"]]>","]]]]><![CDATA[>")_"]]>",1:val))_endprefix_"javaSystemVersion>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..osName
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"osName"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"string""",1:"")_">"_$select(val=$c(0):"",1:$select((val["<")||(val[">")||(val["&"):"<![CDATA["_$replace(val,"]]>","]]]]><![CDATA[>")_"]]>",1:val))_endprefix_"osName>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..osVersion
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"osVersion"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"string""",1:"")_">"_$select(val=$c(0):"",1:$select((val["<")||(val[">")||(val["&"):"<![CDATA["_$replace(val,"]]>","]]]]><![CDATA[>")_"]]>",1:val))_endprefix_"osVersion>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..osArchitecture
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"osArchitecture"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"string""",1:"")_">"_$select(val=$c(0):"",1:$select((val["<")||(val[">")||(val["&"):"<![CDATA["_$replace(val,"]]>","]]]]><![CDATA[>")_"]]>",1:val))_endprefix_"osArchitecture>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..javaClassPath
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"javaClassPath"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"string""",1:"")_">"_$select(val=$c(0):"",1:$select((val["<")||(val[">")||(val["&"):"<![CDATA["_$replace(val,"]]>","]]]]><![CDATA[>")_"]]>",1:val))_endprefix_"javaClassPath>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..sessionContext
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"sessionContext"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"string""",1:"")_">"_$select(val=$c(0):"",1:$select((val["<")||(val[">")||(val["&"):"<![CDATA["_$replace(val,"]]>","]]]]><![CDATA[>")_"]]>",1:val))_endprefix_"sessionContext>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..databaseSystemContext
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"databaseSystemContext"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"string""",1:"")_">"_$select(val=$c(0):"",1:$select((val["<")||(val[">")||(val["&"):"<![CDATA["_$replace(val,"]]>","]]]]><![CDATA[>")_"]]>",1:val))_endprefix_"databaseSystemContext>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..displayString
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"displayString"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"string""",1:"")_">"_$select(val=$c(0):"",1:$select((val["<")||(val[">")||(val["&"):"<![CDATA["_$replace(val,"]]>","]]]]><![CDATA[>")_"]]>",1:val))_endprefix_"displayString>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 If indentFlag Set currentIndent=$extract(currentIndent,1,*-$length(indentChars)) Set %xmlmsg=currentIndent if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set %xmlmsg="</"_topPrefix_tag_">" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg } If indentFlag,'initialCR if $data(%xmlBlock) { Set %xmlmsg="" Do xeWriteLine^%occXMLInternal } else { write ! } Set $extract(currentIndent,1,2)=""
 If '$IsObject(namespaces) || (popAtEnd=1) Set topPrefix=saveTopPrefix,typesPrefix=saveTypesPrefix,attrsPrefix=saveAttrsPrefix,usePrefix=saveUsePrefix
 If popAtEnd Do namespaces.PopNode()
 If encoded Set oreflist=$list(initlist),inlineFlag=$list(initlist,2)
 If 'encoded||inlineFlag {
   If 'nocycle Kill oreflist($this)
 }
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
 Quit ##class(%XML.Implementation).XMLGetSchemaImports("BSTS.ns1.TSystemConfigReportDvo",.imports,.classes)
zXMLImportAttributes()
 ;
 Quit 1
XMLImportAttrErr Quit $$Error^%apiOBJ(6260,ref,$get(@(tree)@(node,"a",ref)),@(tree)@(node)_$$XMLImportAttrLocation(node))
XMLImportAttrLocation(node) new msg,loc
 Set loc=$lb($listget($get(@(tree)@(node,0)),5),$listget($get(@(tree)@(node,0)),6))
 If loc="" Quit ""
 Set msg=$get(^%qCacheMsg("%ObjectErrors",$s(""'="":$zcvt("","L"),1:$get(^||%Language,"en")),"XMLImportLocation")," (%1,%2)")
 Quit $$FormatText^%occMessages(msg,$listget(loc,1),$listget(loc,2))
zXMLImportInternal()
 New child,node,data,ref,encodedArray,loopref,element,key,nsIndex
 Set $ztrap="XMLImportInternalTrap"
 Set encoded=$case($piece(fmt,",",1),"":0,"literal":0,"encoded":1,"encoded12":1,:"")
 If encoded="" Quit $$Error^%apiOBJ(6231,fmt)
 Set nsIndex=$get(@(tree)@("ns","http://apelon.com/dtsserver/types"))
 Set (node,ref)=nodeArg
 If ($listget($get(@(tree)@(node,0)),1)'="e")||(tag'=@(tree)@(node)) Goto XMLImportMalformed
 If bareProjection Quit $$Error^%apiOBJ(6386,"BSTS.ns1.TSystemConfigReportDvo")
 If encoded {
   If $data(@(tree)@(node,"a","id")) Set idlist(node)=$this
 }
 If +$listget($get(@(tree)@(node,0)),7,0) Quit 1
 Set sc=$$XMLImportElements()
XMLImportExit Quit sc
XMLImportElements() ;
 Set child=""
 If $$XMLLOOP()'=0 Quit sc
 If tag="usedMemory" {
   If '$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
   If encoded,$$XMLImportId() {
     Set data=idlist(ref)
   } Else { Goto:'sc XMLImportExit
     If +$listget($get(@(tree)@(ref,0)),7,0) { Set data=""
     } Else {
             Set data=$order(@(tree)@(ref,"c",""))
             If $order(@(tree)@(ref,"c",data))'="" {
               Set data="" Goto XMLImportErr
             } ElseIf data'="" { Goto:$listget($get(@(tree)@(data,0)),1)="e" XMLImportErr Set data=@(tree)@(data) }
             Set data=$zstrip(data,"<>W",$c(13,10)) If data'="" Set data=$s($tr(data,"Ee(),.")'=data:"",1:$number(data,"I")) Goto:data="" XMLImportErr Goto:('$select($zu(115,13)&&(data=$c(0)):1,$isvalidnum(data,0,,):1,1:$$Error^%apiOBJ(7207,data))) XMLImportErr
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   Set ..usedMemory=data
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 If tag="freeMemory" {
   If '$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
   If encoded,$$XMLImportId() {
     Set data=idlist(ref)
   } Else { Goto:'sc XMLImportExit
     If +$listget($get(@(tree)@(ref,0)),7,0) { Set data=""
     } Else {
             Set data=$order(@(tree)@(ref,"c",""))
             If $order(@(tree)@(ref,"c",data))'="" {
               Set data="" Goto XMLImportErr
             } ElseIf data'="" { Goto:$listget($get(@(tree)@(data,0)),1)="e" XMLImportErr Set data=@(tree)@(data) }
             Set data=$zstrip(data,"<>W",$c(13,10)) If data'="" Set data=$s($tr(data,"Ee(),.")'=data:"",1:$number(data,"I")) Goto:data="" XMLImportErr Goto:('$select($zu(115,13)&&(data=$c(0)):1,$isvalidnum(data,0,,):1,1:$$Error^%apiOBJ(7207,data))) XMLImportErr
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   Set ..freeMemory=data
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 If tag="totalMemory" {
   If '$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
   If encoded,$$XMLImportId() {
     Set data=idlist(ref)
   } Else { Goto:'sc XMLImportExit
     If +$listget($get(@(tree)@(ref,0)),7,0) { Set data=""
     } Else {
             Set data=$order(@(tree)@(ref,"c",""))
             If $order(@(tree)@(ref,"c",data))'="" {
               Set data="" Goto XMLImportErr
             } ElseIf data'="" { Goto:$listget($get(@(tree)@(data,0)),1)="e" XMLImportErr Set data=@(tree)@(data) }
             Set data=$zstrip(data,"<>W",$c(13,10)) If data'="" Set data=$s($tr(data,"Ee(),.")'=data:"",1:$number(data,"I")) Goto:data="" XMLImportErr Goto:('$select($zu(115,13)&&(data=$c(0)):1,$isvalidnum(data,0,,):1,1:$$Error^%apiOBJ(7207,data))) XMLImportErr
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   Set ..totalMemory=data
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 If tag="maxMemory" {
   If '$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
   If encoded,$$XMLImportId() {
     Set data=idlist(ref)
   } Else { Goto:'sc XMLImportExit
     If +$listget($get(@(tree)@(ref,0)),7,0) { Set data=""
     } Else {
             Set data=$order(@(tree)@(ref,"c",""))
             If $order(@(tree)@(ref,"c",data))'="" {
               Set data="" Goto XMLImportErr
             } ElseIf data'="" { Goto:$listget($get(@(tree)@(data,0)),1)="e" XMLImportErr Set data=@(tree)@(data) }
             Set data=$zstrip(data,"<>W",$c(13,10)) If data'="" Set data=$s($tr(data,"Ee(),.")'=data:"",1:$number(data,"I")) Goto:data="" XMLImportErr Goto:('$select($zu(115,13)&&(data=$c(0)):1,$isvalidnum(data,0,,):1,1:$$Error^%apiOBJ(7207,data))) XMLImportErr
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   Set ..maxMemory=data
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 If tag="processors" {
   If '$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
   If encoded,$$XMLImportId() {
     Set data=idlist(ref)
   } Else { Goto:'sc XMLImportExit
     If +$listget($get(@(tree)@(ref,0)),7,0) { Set data=""
     } Else {
             Set data=$order(@(tree)@(ref,"c",""))
             If $order(@(tree)@(ref,"c",data))'="" {
               Set data="" Goto XMLImportErr
             } ElseIf data'="" { Goto:$listget($get(@(tree)@(data,0)),1)="e" XMLImportErr Set data=@(tree)@(data) }
             Set data=$zstrip(data,"<>W",$c(13,10)) If data'="" Set data=$s($tr(data,"Ee(),.")'=data:"",1:$number(data,"I",-2147483648,2147483647)) Goto:data="" XMLImportErr Goto:('$select($zu(115,13)&&(data=$c(0)):1,$isvalidnum(data,0,-2147483648,2147483647):1,'$isvalidnum(data):$$Error^%apiOBJ(7207,data),data<-2147483648:$$Error^%apiOBJ(7204,data,-2147483648),1:$$Error^%apiOBJ(7203,data,2147483647))) XMLImportErr
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   Set ..processors=data
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 If tag="javaImplementationVersion" {
   If '$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
   If encoded,$$XMLImportId() {
     Set data=idlist(ref)
   } Else { Goto:'sc XMLImportExit
     If +$listget($get(@(tree)@(ref,0)),7,0) { Set data=""
     } Else {
             Set data=$order(@(tree)@(ref,"c",""))
             If $order(@(tree)@(ref,"c",data))'="" {
               Set data="" If '##class(%XML.ImportHandler).SerializeNode(tree,ref,0,0,.data) Goto XMLImportErr
             } ElseIf data'="" { Goto:$listget($get(@(tree)@(data,0)),1)="e" XMLImportErr Set data=@(tree)@(data) }
             If data="" Set data=$c(0)
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   Set ..javaImplementationVersion=data
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 If tag="javaSystemVersion" {
   If '$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
   If encoded,$$XMLImportId() {
     Set data=idlist(ref)
   } Else { Goto:'sc XMLImportExit
     If +$listget($get(@(tree)@(ref,0)),7,0) { Set data=""
     } Else {
             Set data=$order(@(tree)@(ref,"c",""))
             If $order(@(tree)@(ref,"c",data))'="" {
               Set data="" If '##class(%XML.ImportHandler).SerializeNode(tree,ref,0,0,.data) Goto XMLImportErr
             } ElseIf data'="" { Goto:$listget($get(@(tree)@(data,0)),1)="e" XMLImportErr Set data=@(tree)@(data) }
             If data="" Set data=$c(0)
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   Set ..javaSystemVersion=data
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 If tag="osName" {
   If '$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
   If encoded,$$XMLImportId() {
     Set data=idlist(ref)
   } Else { Goto:'sc XMLImportExit
     If +$listget($get(@(tree)@(ref,0)),7,0) { Set data=""
     } Else {
             Set data=$order(@(tree)@(ref,"c",""))
             If $order(@(tree)@(ref,"c",data))'="" {
               Set data="" If '##class(%XML.ImportHandler).SerializeNode(tree,ref,0,0,.data) Goto XMLImportErr
             } ElseIf data'="" { Goto:$listget($get(@(tree)@(data,0)),1)="e" XMLImportErr Set data=@(tree)@(data) }
             If data="" Set data=$c(0)
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   Set ..osName=data
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 If tag="osVersion" {
   If '$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
   If encoded,$$XMLImportId() {
     Set data=idlist(ref)
   } Else { Goto:'sc XMLImportExit
     If +$listget($get(@(tree)@(ref,0)),7,0) { Set data=""
     } Else {
             Set data=$order(@(tree)@(ref,"c",""))
             If $order(@(tree)@(ref,"c",data))'="" {
               Set data="" If '##class(%XML.ImportHandler).SerializeNode(tree,ref,0,0,.data) Goto XMLImportErr
             } ElseIf data'="" { Goto:$listget($get(@(tree)@(data,0)),1)="e" XMLImportErr Set data=@(tree)@(data) }
             If data="" Set data=$c(0)
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   Set ..osVersion=data
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 If tag="osArchitecture" {
   If '$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
   If encoded,$$XMLImportId() {
     Set data=idlist(ref)
   } Else { Goto:'sc XMLImportExit
     If +$listget($get(@(tree)@(ref,0)),7,0) { Set data=""
     } Else {
             Set data=$order(@(tree)@(ref,"c",""))
             If $order(@(tree)@(ref,"c",data))'="" {
               Set data="" If '##class(%XML.ImportHandler).SerializeNode(tree,ref,0,0,.data) Goto XMLImportErr
             } ElseIf data'="" { Goto:$listget($get(@(tree)@(data,0)),1)="e" XMLImportErr Set data=@(tree)@(data) }
             If data="" Set data=$c(0)
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   Set ..osArchitecture=data
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 If tag="javaClassPath" {
   If '$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
   If encoded,$$XMLImportId() {
     Set data=idlist(ref)
   } Else { Goto:'sc XMLImportExit
     If +$listget($get(@(tree)@(ref,0)),7,0) { Set data=""
     } Else {
             Set data=$order(@(tree)@(ref,"c",""))
             If $order(@(tree)@(ref,"c",data))'="" {
               Set data="" If '##class(%XML.ImportHandler).SerializeNode(tree,ref,0,0,.data) Goto XMLImportErr
             } ElseIf data'="" { Goto:$listget($get(@(tree)@(data,0)),1)="e" XMLImportErr Set data=@(tree)@(data) }
             If data="" Set data=$c(0)
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   Set ..javaClassPath=data
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 If tag="sessionContext" {
   If '$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
   If encoded,$$XMLImportId() {
     Set data=idlist(ref)
   } Else { Goto:'sc XMLImportExit
     If +$listget($get(@(tree)@(ref,0)),7,0) { Set data=""
     } Else {
             Set data=$order(@(tree)@(ref,"c",""))
             If $order(@(tree)@(ref,"c",data))'="" {
               Set data="" If '##class(%XML.ImportHandler).SerializeNode(tree,ref,0,0,.data) Goto XMLImportErr
             } ElseIf data'="" { Goto:$listget($get(@(tree)@(data,0)),1)="e" XMLImportErr Set data=@(tree)@(data) }
             If data="" Set data=$c(0)
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   Set ..sessionContext=data
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 If tag="databaseSystemContext" {
   If '$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
   If encoded,$$XMLImportId() {
     Set data=idlist(ref)
   } Else { Goto:'sc XMLImportExit
     If +$listget($get(@(tree)@(ref,0)),7,0) { Set data=""
     } Else {
             Set data=$order(@(tree)@(ref,"c",""))
             If $order(@(tree)@(ref,"c",data))'="" {
               Set data="" If '##class(%XML.ImportHandler).SerializeNode(tree,ref,0,0,.data) Goto XMLImportErr
             } ElseIf data'="" { Goto:$listget($get(@(tree)@(data,0)),1)="e" XMLImportErr Set data=@(tree)@(data) }
             If data="" Set data=$c(0)
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   Set ..databaseSystemContext=data
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 If tag="displayString" {
   If '$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
   If encoded,$$XMLImportId() {
     Set data=idlist(ref)
   } Else { Goto:'sc XMLImportExit
     If +$listget($get(@(tree)@(ref,0)),7,0) { Set data=""
     } Else {
             Set data=$order(@(tree)@(ref,"c",""))
             If $order(@(tree)@(ref,"c",data))'="" {
               Set data="" If '##class(%XML.ImportHandler).SerializeNode(tree,ref,0,0,.data) Goto XMLImportErr
             } ElseIf data'="" { Goto:$listget($get(@(tree)@(data,0)),1)="e" XMLImportErr Set data=@(tree)@(data) }
             If data="" Set data=$c(0)
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   Set ..displayString=data
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 Goto XMLImportBadTag
XMLLOOP() For  { Set child=$order(@(tree)@(node,"c",child)) If (child="")||($listget($get(@(tree)@(child,0)),1)'="w") Quit }
 If child="" Quit sc
 Set tag=@(tree)@(child)
 Set ref=child
 If $listget($get(@(tree)@(ref,0)),1)'="e" Goto XMLImportMalformedNoTag
 Quit 0
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
zXMLIsObjectEmpty(ignoreNull)
 If ..usedMemory'="" Quit 0
 If ..freeMemory'="" Quit 0
 If ..totalMemory'="" Quit 0
 If ..maxMemory'="" Quit 0
 If ..processors'="" Quit 0
 If ..javaImplementationVersion'="" Quit 0
 If ..javaSystemVersion'="" Quit 0
 If ..osName'="" Quit 0
 If ..osVersion'="" Quit 0
 If ..osArchitecture'="" Quit 0
 If ..javaClassPath'="" Quit 0
 If ..sessionContext'="" Quit 0
 If ..databaseSystemContext'="" Quit 0
 If ..displayString'="" Quit 0
 Quit 1
zXMLNew(document,node,containerOref="")
	Quit (##class(BSTS.ns1.TSystemConfigReportDvo).%New())
zXMLSchema(top="",format="",namespacePrefix="",input=0,refOnly=0,schema)
 Quit ##class(%XML.Implementation).XMLSchema("BSTS.ns1.TSystemConfigReportDvo",top,format,namespacePrefix,input,refOnly,.schema)
zfreeMemoryDisplayToLogical(%val) public {
	Q $s(%val="":"",$zu(115,13)&&(%val=$c(0)):"",1:+$in(%val,"",%val)) }
zfreeMemoryIsValid(%val) public {
	Quit $select($zu(115,13)&&(%val=$c(0)):1,$isvalidnum(%val,0,,):1,1:$$Error^%apiOBJ(7207,%val)) }
zfreeMemoryNormalize(%val) public {
	Quit $select($zu(115,13)&&(%val=$c(0)):"",1:%val\1) }
zfreeMemoryXSDToLogical(%val) public {
	Q $s($tr(%val,"Ee(),.")'=%val:"",1:$number(%val,"I")) }
zmaxMemoryDisplayToLogical(%val) public {
	Q $s(%val="":"",$zu(115,13)&&(%val=$c(0)):"",1:+$in(%val,"",%val)) }
zmaxMemoryIsValid(%val) public {
	Quit $select($zu(115,13)&&(%val=$c(0)):1,$isvalidnum(%val,0,,):1,1:$$Error^%apiOBJ(7207,%val)) }
zmaxMemoryNormalize(%val) public {
	Quit $select($zu(115,13)&&(%val=$c(0)):"",1:%val\1) }
zmaxMemoryXSDToLogical(%val) public {
	Q $s($tr(%val,"Ee(),.")'=%val:"",1:$number(%val,"I")) }
zprocessorsDisplayToLogical(%val) public {
	Q $s(%val="":"",$zu(115,13)&&(%val=$c(0)):"",1:+$in(%val,"",%val)) }
zprocessorsIsValid(%val) public {
	Quit $select($zu(115,13)&&(%val=$c(0)):1,$isvalidnum(%val,0,-2147483648,2147483647):1,'$isvalidnum(%val):$$Error^%apiOBJ(7207,%val),%val<-2147483648:$$Error^%apiOBJ(7204,%val,-2147483648),1:$$Error^%apiOBJ(7203,%val,2147483647)) }
zprocessorsNormalize(%val) public {
	Quit $select($zu(115,13)&&(%val=$c(0)):"",1:%val\1) }
zprocessorsXSDToLogical(%val) public {
	Q $s($tr(%val,"Ee(),.")'=%val:"",1:$number(%val,"I",-2147483648,2147483647)) }
ztotalMemoryDisplayToLogical(%val) public {
	Q $s(%val="":"",$zu(115,13)&&(%val=$c(0)):"",1:+$in(%val,"",%val)) }
ztotalMemoryIsValid(%val) public {
	Quit $select($zu(115,13)&&(%val=$c(0)):1,$isvalidnum(%val,0,,):1,1:$$Error^%apiOBJ(7207,%val)) }
ztotalMemoryNormalize(%val) public {
	Quit $select($zu(115,13)&&(%val=$c(0)):"",1:%val\1) }
ztotalMemoryXSDToLogical(%val) public {
	Q $s($tr(%val,"Ee(),.")'=%val:"",1:$number(%val,"I")) }
zusedMemoryDisplayToLogical(%val) public {
	Q $s(%val="":"",$zu(115,13)&&(%val=$c(0)):"",1:+$in(%val,"",%val)) }
zusedMemoryIsValid(%val) public {
	Quit $select($zu(115,13)&&(%val=$c(0)):1,$isvalidnum(%val,0,,):1,1:$$Error^%apiOBJ(7207,%val)) }
zusedMemoryNormalize(%val) public {
	Quit $select($zu(115,13)&&(%val=$c(0)):"",1:%val\1) }
zusedMemoryXSDToLogical(%val) public {
	Q $s($tr(%val,"Ee(),.")'=%val:"",1:$number(%val,"I")) }
