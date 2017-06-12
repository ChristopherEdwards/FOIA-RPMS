 ;BSTS.ns1.TDataTypeFilter.1
 ;(C)InterSystems, generated for class BSTS.ns1.TDataTypeFilter.  Do NOT edit. 10/22/2016 08:53:36AM
 ;;7674395A;BSTS.ns1.TDataTypeFilter
 ;
%NormalizeObject() public {
	If '$system.CLS.GetModified() Quit 1
	If m%ALLCONTENT Set:i%ALLCONTENT'="" i%ALLCONTENT=(..ALLCONTENTNormalize(i%ALLCONTENT))
	If m%FILTERBYNAMEMATCHING Set:i%FILTERBYNAMEMATCHING'="" i%FILTERBYNAMEMATCHING=(..FILTERBYNAMEMATCHINGNormalize(i%FILTERBYNAMEMATCHING))
	If m%FILTERBYNAMESPACE Set:i%FILTERBYNAMESPACE'="" i%FILTERBYNAMESPACE=(..FILTERBYNAMESPACENormalize(i%FILTERBYNAMESPACE))
	If m%FILTERBYSUBSET Set:i%FILTERBYSUBSET'="" i%FILTERBYSUBSET=(..FILTERBYSUBSETNormalize(i%FILTERBYSUBSET))
	If m%contentId Set:i%contentId'="" i%contentId=(..contentIdNormalize(i%contentId))
	If m%filterBy Set:i%filterBy'="" i%filterBy=(..filterByNormalize(i%filterBy))
	If m%namePattern Set:i%namePattern'="" i%namePattern=(..namePatternNormalize(i%namePattern))
	If m%snapshotDate Set:i%snapshotDate'="" i%snapshotDate=(..snapshotDateNormalize(i%snapshotDate))
	Quit 1 }
%ValidateObject(force=0) public {
	Set sc=1
	If '$system.CLS.GetModified() Quit sc
	Set iv=..ALLCONTENT If iv="" Set rc=$$Error^%apiOBJ(5659,$classname()_"::"_"ALLCONTENT"_"("_$this_",ID="),sc=$select(+sc:rc,1:$$AppendStatus^%occSystem(sc,rc))
	If m%ALLCONTENT Set rc=(..ALLCONTENTIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"ALLCONTENT",iv)
	If m%FILTERBYNAMEMATCHING Set iv=..FILTERBYNAMEMATCHING If iv'="" Set rc=(..FILTERBYNAMEMATCHINGIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"FILTERBYNAMEMATCHING",iv)
	If m%FILTERBYNAMESPACE Set iv=..FILTERBYNAMESPACE If iv'="" Set rc=(..FILTERBYNAMESPACEIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"FILTERBYNAMESPACE",iv)
	If m%FILTERBYSUBSET Set iv=..FILTERBYSUBSET If iv'="" Set rc=(..FILTERBYSUBSETIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"FILTERBYSUBSET",iv)
	Set iv=..contentId If iv="" Set rc=$$Error^%apiOBJ(5659,$classname()_"::"_"contentId"_"("_$this_",ID="),sc=$select(+sc:rc,1:$$AppendStatus^%occSystem(sc,rc))
	If m%contentId Set rc=(..contentIdIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"contentId",iv)
	If m%filterBy Set iv=..filterBy If iv'="" Set rc=(..filterByIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"filterBy",iv)
	If m%namePattern Set iv=..namePattern If iv'="" Set rc=(..namePatternIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"namePattern",iv)
	Set iv=..snapshotDate If iv="" Set rc=$$Error^%apiOBJ(5659,$classname()_"::"_"snapshotDate"_"("_$this_",ID="),sc=$select(+sc:rc,1:$$AppendStatus^%occSystem(sc,rc))
	If m%snapshotDate Set rc=(..snapshotDateIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"snapshotDate",iv)
	Quit sc }
zXMLDTD(top,format,input,dtdlist)
 Quit ##class(%XML.Implementation).XMLDTD("BSTS.ns1.TDataTypeFilter",.top,.format,.input,.dtdlist)
zXMLExportInternal()
 New tag,summary,attrsVal,savelocal,aval,k,tmpPrefix,prefixDepth,hasNoContent,hasElement,topAttrs,beginprefix,endprefix,savexsiAttrs,initialxsiAttrs,initlist,initialCR,inlineFlag,popAtEnd,saveTopPrefix,saveTypesPrefix,saveAttrsPrefix,saveUsePrefix,initlist
 Set $ztrap="XMLExportInternalTrap",popAtEnd=0
 Set summary=summaryArg,initialxsiAttrs=xsiAttrs
 If group Quit $$Error^%apiOBJ(6386,"BSTS.ns1.TDataTypeFilter")
 If indentFlag Set initialCR=($extract(currentIndent,1,2)=$c(13,10))
 Set id=createId
 Set temp=""
 If id'="" {
   If $piece($get(idlist(+$this)),",",2)'="" Quit 1
   Set idlist(+$this)=id_",1"
 }
 If encoded Set initlist=$lb($get(oreflist),inlineFlagArg),oreflist=1,inlineFlag=inlineFlagArg
 If 'nocycle,('encoded||inlineFlag) {
   If $data(oreflist($this)) Quit $$Error^%apiOBJ(6296,"BSTS.ns1.TDataTypeFilter")
   Set oreflist($this)=""
 }
 Set tag=$get(topArg)
 Set tmpi=(($get(typeAttr)'="")&&(typeAttr'="BSTS.ns1.TDataTypeFilter"))
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
   If tag="" Set tag="TDataTypeFilter"
   Set xsitype=namespaces.OutputTypeAttribute
 } Else {
   Set saveTopPrefix=topPrefix,saveTypesPrefix=typesPrefix,saveAttrsPrefix=attrsPrefix,saveUsePrefix=usePrefix
   Set typesPrefix=namespaces If (typesPrefix'=""),($extract(typesPrefix,*)'=":") Set typesPrefix=typesPrefix_":"
   If 'encoded Set namespaces=""
   Set (topPrefix,attrsPrefix,topAttrs,beginprefix)=""
   If tag="" Set tag=typesPrefix_"TDataTypeFilter"
   Set xsitype=0
 }
 Set local=+$get(local),savelocal=local
 Set endprefix="</"_beginprefix,beginprefix="<"_beginprefix
 If tmpi Set temp=temp_" "_xsiPrefix_"type="""_typesPrefix_"TDataTypeFilter"""_xsiAttrs,xsiAttrs=""
   If id'="" Set temp=" "_$select($get(soap12):soapPrefix_"id",1:"id")_"=""id"_id_""""_temp
 If encoded Set temp=temp_xsiAttrs,xsiAttrs=""
 If indentFlag Set %xmlmsg=currentIndent if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg } Set currentIndent=$select(initialCR:"",1:$c(13,10))_currentIndent_indentChars
 If tag[":" Set topPrefix=$piece(tag,":"),tag=$piece(tag,":",2)  If topPrefix'="" Set topPrefix=topPrefix_":"
 Set %xmlmsg="<"_topPrefix_tag_temp if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set attrsVal=attrsArg,attrsArg="" Set %xmlmsg=attrsVal if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 If 'encoded {
   Set val=..ALLCONTENT
   If val'="" {
     Set %xmlmsg=" "_attrsPrefix_"ALL_CONTENT="""_val_"""" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
   }
   Set val=..FILTERBYSUBSET
   If val'="" {
     Set %xmlmsg=" "_attrsPrefix_"FILTER_BY_SUBSET="""_$select(val=$c(0):"",1:$zcvt(val,"O","XML"))_"""" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
   }
   Set val=..FILTERBYNAMESPACE
   If val'="" {
     Set %xmlmsg=" "_attrsPrefix_"FILTER_BY_NAMESPACE="""_$select(val=$c(0):"",1:$zcvt(val,"O","XML"))_"""" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
   }
   Set val=..FILTERBYNAMEMATCHING
   If val'="" {
     Set %xmlmsg=" "_attrsPrefix_"FILTER_BY_NAME_MATCHING="""_$select(val=$c(0):"",1:$zcvt(val,"O","XML"))_"""" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
   }
 }
 Set %xmlmsg=">" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..filterBy
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"filterBy"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"string""",1:"")_">"_$select(val=$c(0):"",1:$select((val["<")||(val[">")||(val["&"):"<![CDATA["_$replace(val,"]]>","]]]]><![CDATA[>")_"]]>",1:val))_endprefix_"filterBy>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..namePattern
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"namePattern"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"string""",1:"")_">"_$select(val=$c(0):"",1:$select((val["<")||(val[">")||(val["&"):"<![CDATA["_$replace(val,"]]>","]]]]><![CDATA[>")_"]]>",1:val))_endprefix_"namePattern>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..contentId
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"contentId"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"int""",1:"")_">"_val_endprefix_"contentId>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..snapshotDate
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"snapshotDate"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"dateTime""",1:"")_">"_$select(val="":"",1:$translate(val," ","T")_"Z")_endprefix_"snapshotDate>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 If encoded {
   Set val=..ALLCONTENT
   If val'="" {
     Set %xmlmsg=currentIndent_beginprefix_"ALL_CONTENT"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"int""",1:"")_">"_val_endprefix_"ALL_CONTENT>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
   }
 }
 If encoded {
   Set val=..FILTERBYSUBSET
   If val'="" {
     Set %xmlmsg=currentIndent_beginprefix_"FILTER_BY_SUBSET"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"string""",1:"")_">"_$select(val=$c(0):"",1:$select((val["<")||(val[">")||(val["&"):"<![CDATA["_$replace(val,"]]>","]]]]><![CDATA[>")_"]]>",1:val))_endprefix_"FILTER_BY_SUBSET>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
   }
 }
 If encoded {
   Set val=..FILTERBYNAMESPACE
   If val'="" {
     Set %xmlmsg=currentIndent_beginprefix_"FILTER_BY_NAMESPACE"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"string""",1:"")_">"_$select(val=$c(0):"",1:$select((val["<")||(val[">")||(val["&"):"<![CDATA["_$replace(val,"]]>","]]]]><![CDATA[>")_"]]>",1:val))_endprefix_"FILTER_BY_NAMESPACE>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
   }
 }
 If encoded {
   Set val=..FILTERBYNAMEMATCHING
   If val'="" {
     Set %xmlmsg=currentIndent_beginprefix_"FILTER_BY_NAME_MATCHING"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"string""",1:"")_">"_$select(val=$c(0):"",1:$select((val["<")||(val[">")||(val["&"):"<![CDATA["_$replace(val,"]]>","]]]]><![CDATA[>")_"]]>",1:val))_endprefix_"FILTER_BY_NAME_MATCHING>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
   }
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
 Quit ##class(%XML.Implementation).XMLGetSchemaImports("BSTS.ns1.TDataTypeFilter",.imports,.classes)
zXMLImportAttributes()
 ;
 New data,ref
 If ($data(@(tree)@(node,"a","ALL_CONTENT"))) {
   Set ref="ALL_CONTENT",data=$get(@(tree)@(node,"a",ref))
   Set data=$zstrip(data,"<>W",$c(13,10)) If data'="" Set data=$s($tr(data,"Ee(),.")'=data:"",1:$number(data,"I",-2147483648,2147483647)) Goto:data="" XMLImportAttrErr Goto:('$select($zu(115,13)&&(data=$c(0)):1,$isvalidnum(data,0,-2147483648,2147483647):1,'$isvalidnum(data):$$Error^%apiOBJ(7207,data),data<-2147483648:$$Error^%apiOBJ(7204,data,-2147483648),1:$$Error^%apiOBJ(7203,data,2147483647))) XMLImportAttrErr
   Set ..ALLCONTENT=data
 }
 If ($data(@(tree)@(node,"a","FILTER_BY_SUBSET"))) {
   Set ref="FILTER_BY_SUBSET",data=$get(@(tree)@(node,"a",ref))
   If data="" Set data=$c(0)
   Set ..FILTERBYSUBSET=data
 }
 If ($data(@(tree)@(node,"a","FILTER_BY_NAMESPACE"))) {
   Set ref="FILTER_BY_NAMESPACE",data=$get(@(tree)@(node,"a",ref))
   If data="" Set data=$c(0)
   Set ..FILTERBYNAMESPACE=data
 }
 If ($data(@(tree)@(node,"a","FILTER_BY_NAME_MATCHING"))) {
   Set ref="FILTER_BY_NAME_MATCHING",data=$get(@(tree)@(node,"a",ref))
   If data="" Set data=$c(0)
   Set ..FILTERBYNAMEMATCHING=data
 }
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
 If bareProjection Quit $$Error^%apiOBJ(6386,"BSTS.ns1.TDataTypeFilter")
 If encoded {
   If $data(@(tree)@(node,"a","id")) Set idlist(node)=$this
 }
 If 'encoded Set sc=..XMLImportAttributes() If 'sc Quit sc
 If +$listget($get(@(tree)@(node,0)),7,0) Quit 1
 Set sc=$$XMLImportElements()
XMLImportExit Quit sc
XMLImportElements() ;
 Set child=""
 If $$XMLLOOP()'=0 Quit sc
 If tag="filterBy" {
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
   Set ..filterBy=data
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 If tag="namePattern" {
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
   Set ..namePattern=data
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 If tag="contentId" {
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
   Set ..contentId=data
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 If tag="snapshotDate" {
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
             Set data=$zstrip(data,"<>W",$c(13,10)) If data'="" Set data=..snapshotDateXSDToLogical(data) Goto:data="" XMLImportErr Goto:('..snapshotDateIsValid(data)) XMLImportErr
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   Set ..snapshotDate=data
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 If encoded,(tag="ALL_CONTENT") {
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
   Set ..ALLCONTENT=data
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 If encoded,(tag="FILTER_BY_SUBSET") {
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
   Set ..FILTERBYSUBSET=data
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 If encoded,(tag="FILTER_BY_NAMESPACE") {
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
   Set ..FILTERBYNAMESPACE=data
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 If encoded,(tag="FILTER_BY_NAME_MATCHING") {
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
   Set ..FILTERBYNAMEMATCHING=data
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
 If ..filterBy'="" Quit 0
 If ..namePattern'="" Quit 0
 If ..contentId'="" Quit 0
 If ..snapshotDate'="" Quit 0
 If ..ALLCONTENT'="" Quit 0
 If ..FILTERBYSUBSET'="" Quit 0
 If ..FILTERBYNAMESPACE'="" Quit 0
 If ..FILTERBYNAMEMATCHING'="" Quit 0
 Quit 1
zXMLNew(document,node,containerOref="")
	Quit (##class(BSTS.ns1.TDataTypeFilter).%New())
zXMLSchema(top="",format="",namespacePrefix="",input=0,refOnly=0,schema)
 Quit ##class(%XML.Implementation).XMLSchema("BSTS.ns1.TDataTypeFilter",top,format,namespacePrefix,input,refOnly,.schema)
zALLCONTENTDisplayToLogical(%val) public {
	Q $s(%val="":"",$zu(115,13)&&(%val=$c(0)):"",1:+$in(%val,"",%val)) }
zALLCONTENTIsValid(%val) public {
	Quit $select($zu(115,13)&&(%val=$c(0)):1,$isvalidnum(%val,0,-2147483648,2147483647):1,'$isvalidnum(%val):$$Error^%apiOBJ(7207,%val),%val<-2147483648:$$Error^%apiOBJ(7204,%val,-2147483648),1:$$Error^%apiOBJ(7203,%val,2147483647)) }
zALLCONTENTNormalize(%val) public {
	Quit $select($zu(115,13)&&(%val=$c(0)):"",1:%val\1) }
zALLCONTENTXSDToLogical(%val) public {
	Q $s($tr(%val,"Ee(),.")'=%val:"",1:$number(%val,"I",-2147483648,2147483647)) }
zcontentIdDisplayToLogical(%val) public {
	Q $s(%val="":"",$zu(115,13)&&(%val=$c(0)):"",1:+$in(%val,"",%val)) }
zcontentIdIsValid(%val) public {
	Quit $select($zu(115,13)&&(%val=$c(0)):1,$isvalidnum(%val,0,-2147483648,2147483647):1,'$isvalidnum(%val):$$Error^%apiOBJ(7207,%val),%val<-2147483648:$$Error^%apiOBJ(7204,%val,-2147483648),1:$$Error^%apiOBJ(7203,%val,2147483647)) }
zcontentIdNormalize(%val) public {
	Quit $select($zu(115,13)&&(%val=$c(0)):"",1:%val\1) }
zcontentIdXSDToLogical(%val) public {
	Q $s($tr(%val,"Ee(),.")'=%val:"",1:$number(%val,"I",-2147483648,2147483647)) }
zsnapshotDateIsValid(%val)
	Quit:$zu(115,13)&&(%val=$c(0)) 1 New val Set val=%val,%val=$select(%val=(%val\1):$zd(%val,3,,,,,,,"error")_" 00:00:00",%val?1.2N1":"2N1":"2N.1(1"."1.N):$zd($h,3)_" "_%val,$length(%val)=10:%val_" 00:00:00",1:%val) Quit:($length(%val)<19||($zdth(%val,3,,,,,,,,"")="")) $$Error^%apiOBJ(7208,val)
	Quit 1
zsnapshotDateLogicalToXSD(%val)
	Quit $select(%val="":"",1:$translate(%val," ","T")_"Z")
zsnapshotDateNormalize(%val)
	Quit $s(%val="":"",$zu(115,13)&&(%val=$c(0)):"",%val=(%val\1):$zd(%val,3,,,,,,,"error")_" 00:00:00",%val?1.2N1":"2N1":"2N.1(1"."1.N):$zd($h,3)_" "_%val,$l(%val)=10:%val_" 00:00:00",$zdth(%val,3,,,,,,,,"")="":"error",1:$zdt($zdth($p(%val,"."),3,,,,,,,,""),3)_$s(+$p(%val,".",2)=0:"",1:+("."_$p(%val,".",2))))
zsnapshotDateOdbcToLogical(%val)
 quit:%val="" "" if $zdth(%val,3,,,,,,,,"")'="" { s %val=$zdt($zdth(%val,3),3,,$l($p(%val,".",2))) } elseif $zdth(%val,-1,,,,,,,,"")'="" { s %val=$zdt($zdth(%val,-1),3,,$l($p(%val,".",2))) } quit $s(%val'[".":%val,1:$zstrip($zstrip(%val,">","0"),">","."))
	Quit
zsnapshotDateXSDToLogical(%val)
 New len,dt,d,f,s,t,z
 If $length($get(%val),"T")'=2 Quit ""
 Set dt=$translate(%val,"T"," ")
 Set len=$length(%val)
 If $extract(%val,len)="Z" {
   Set dt=$extract(dt,1,len-1)
 } ElseIf $case($extract(%val,len-5),"+":1,"-":1,:0) {
   If $extract(%val,len-2)'=":" Quit ""
   Set dt=$extract(dt,1,len-6)
   Set f=$piece(dt,".",2) If f'="" Set f="."_f,dt=$piece(dt,".")
   Set t=$zdatetimeh(dt,3,1,,,,,,,"") If t="" Quit ""
   Set d=$piece(t,",")
   Set s=$piece(t,",",2)
   Set z=($extract(%val,len-4,len-3)*60+$extract(%val,len-1,len))*60
   If $extract(%val,len-5)="-" {
     Set s=s+z
     If s>=(24*60*60) Set d=d+1,s=s-(24*60*60)
   } Else {
     Set s=s-z
     If s<0 Set d=d-1,s=s+(24*60*60)
   }
   Set dt=$zdatetime(d_","_s,3,1,0,,,,,,,"")
   Quit $select(dt="":"",1:dt_f)
 }
 If $zdatetimeh(dt,3,1,,,,,,,"")="" Quit ""
 Quit dt
