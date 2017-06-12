 ;BSTS.ns1.TSubset.1
 ;(C)InterSystems, generated for class BSTS.ns1.TSubset.  Do NOT edit. 10/22/2016 08:53:40AM
 ;;6F483278;BSTS.ns1.TSubset
 ;
%BindExport(dev,Seen,RegisterOref,AllowedDepth,AllowedCapacity) public {
   i $d(Seen(+$this)) q 1
   Set Seen(+$this)=$this
   s sc = 1
 s proporef=..authority
 s proporef=..contentVersion
 s proporef=..contentVersions
 s proporef=..expression
 s proporef=..properties
   d:RegisterOref InitObjVar^%SYS.BINDSRV($this)
   i dev'="" s t=$io u dev i $zobjexport($this_"",3)+$zobjexport($this."%%OID",3)+$zobjexport($this,3)!1 u t
 If AllowedDepth>0 Set AllowedDepth = AllowedDepth - 1
 If AllowedCapacity>0 Set AllowedCapacity = AllowedCapacity - 1/5
 s proporef=..authority
       i proporef'="" s sc=1 i AllowedDepth'=0,AllowedCapacity'=0 s sc=proporef.%BindExport(dev,.Seen,RegisterOref,AllowedDepth,AllowedCapacity) q:('sc) sc
 s proporef=..contentVersion
       i proporef'="" s sc=1 i AllowedDepth'=0,AllowedCapacity'=0 s sc=proporef.%BindExport(dev,.Seen,RegisterOref,AllowedDepth,AllowedCapacity) q:('sc) sc
 s proporef=..contentVersions
       i proporef'="" d
  . s idx="" i proporef'="" f  s elemoref=proporef.GetNext(.idx) q:idx=""  s sc=1 i AllowedDepth'=0,AllowedCapacity'=0 s sc=elemoref.%BindExport(dev,.Seen,RegisterOref,AllowedDepth,AllowedCapacity) q:('sc)
  q:('sc) sc
       i proporef'="",dev'="" s t=$io u dev i $zobjexport(proporef_"",3)+$zobjexport(proporef."%%OID",3)+$zobjexport(proporef,3)!1 u t
       if proporef'="",dev'="" d
       . s t=$io u dev i $zobjexport(3_"",3)!1 u t
       . s t=$io u dev i $zobjexport(proporef.Count()_"",3)!1 u t
     . for i=1:1:proporef.Count()  s t=$io u dev i $zobjexport(proporef.GetAt(i)_"",3)!1 u t
 s proporef=..expression
       i proporef'="" s sc=1 i AllowedDepth'=0,AllowedCapacity'=0 s sc=proporef.%BindExport(dev,.Seen,RegisterOref,AllowedDepth,AllowedCapacity) q:('sc) sc
 s proporef=..properties
       i proporef'="" d
  . s idx="" i proporef'="" f  s elemoref=proporef.GetNext(.idx) q:idx=""  s sc=1 i AllowedDepth'=0,AllowedCapacity'=0 s sc=elemoref.%BindExport(dev,.Seen,RegisterOref,AllowedDepth,AllowedCapacity) q:('sc)
  q:('sc) sc
       i proporef'="",dev'="" s t=$io u dev i $zobjexport(proporef_"",3)+$zobjexport(proporef."%%OID",3)+$zobjexport(proporef,3)!1 u t
       if proporef'="",dev'="" d
       . s t=$io u dev i $zobjexport(3_"",3)!1 u t
       . s t=$io u dev i $zobjexport(proporef.Count()_"",3)!1 u t
     . for i=1:1:proporef.Count()  s t=$io u dev i $zobjexport(proporef.GetAt(i)_"",3)!1 u t
   Quit sc }
%ConstructCloneInit(object,deep=0,cloned,location) public {
	Set i%contentVersions="",r%contentVersions=""
	Set i%properties="",r%properties=""
	Set i%"%%OID"=""
	If deep>0 {
		If $isobject(..authority)=1 Set r%authority=r%authority.%ConstructClone(1,.cloned),i%authority=""
		If $isobject(..contentVersion)=1 Set r%contentVersion=r%contentVersion.%ConstructClone(1,.cloned),i%contentVersion=""
		Set key="" For  Set value=..contentVersions.GetNext(.key) Quit:key=""  Set r%contentVersions(key)=$select(value="":"",1:value.%ConstructClone(1,.cloned)),i%contentVersions(key)=""
		If $isobject(..expression)=1 Set r%expression=r%expression.%ConstructClone(1,.cloned),i%expression=""
		Set key="" For  Set value=..properties.GetNext(.key) Quit:key=""  Set r%properties(key)=$select(value="":"",1:value.%ConstructClone(1,.cloned)),i%properties(key)=""
	}
	Quit 1 }
%NormalizeObject() public {
	If '$system.CLS.GetModified() Quit 1
	If m%buildTime Set:i%buildTime'="" i%buildTime=(..buildTimeNormalize(i%buildTime))
	If m%conceptCount Set:i%conceptCount'="" i%conceptCount=(..conceptCountNormalize(i%conceptCount))
	If m%createdBy Set:i%createdBy'="" i%createdBy=(..createdByNormalize(i%createdBy))
	If m%createdTime Set:i%createdTime'="" i%createdTime=(..createdTimeNormalize(i%createdTime))
	If m%description Set:i%description'="" i%description=(..descriptionNormalize(i%description))
	If m%id Set:i%id'="" i%id=(..idNormalize(i%id))
	If m%modifiedBy Set:i%modifiedBy'="" i%modifiedBy=(..modifiedByNormalize(i%modifiedBy))
	If m%modifiedTime Set:i%modifiedTime'="" i%modifiedTime=(..modifiedTimeNormalize(i%modifiedTime))
	If m%name Set:i%name'="" i%name=(..nameNormalize(i%name))
	If m%writable Set:i%writable'="" i%writable=(..writableNormalize(i%writable))
	Quit 1 }
%SerializeObject(serial,partial=0) public {
	Set $Ztrap = "%SerializeObjectERR"
	Set sc=..%ValidateObject() If ('sc) { Ztrap "SO" }
	Set sc=..%NormalizeObject() If ('sc) { Ztrap "SO" }
	Quit sc
%SerializeObjectERR	Set $ZTrap="" If $extract($zerror,1,5)'="<ZSO>" Set sc=$$Error^%apiOBJ(5002,$ZE)
	Quit sc }
%AddToSaveSet(depth=3,refresh=0) public {
	If $data(%objTX(1,+$this)) && ('refresh) Quit 1
	Set sc=1,intOref=+$this
	If refresh Set intPoref="" For  Set intPoref=$order(%objTX(1,intOref,2,intPoref)) Quit:intPoref=""  Kill %objTX(1,intPoref,3,intOref),%objTX(1,intOref,2,intPoref)
	Set %objTX(1,intOref)=$this,%objTX(1,intOref,1)=-1
	Set Poref=r%authority If Poref'="",'$data(%objTX(1,+Poref)) Set %objTX(6,$i(%objTX(6)))=Poref
	Set Poref=r%contentVersion If Poref'="",'$data(%objTX(1,+Poref)) Set %objTX(6,$i(%objTX(6)))=Poref
	Set key=""
	For  {
		Set key=$order(r%contentVersions(key),1,Poref) Quit:key=""
		If $isobject(Poref)=1 Set:'$data(%objTX(1,+Poref)) %objTX(6,$i(%objTX(6)))=Poref
	}
	Set Poref=r%expression If Poref'="",'$data(%objTX(1,+Poref)) Set %objTX(6,$i(%objTX(6)))=Poref
	Set key=""
	For  {
		Set key=$order(r%properties(key),1,Poref) Quit:key=""
		If $isobject(Poref)=1 Set:'$data(%objTX(1,+Poref)) %objTX(6,$i(%objTX(6)))=Poref
	}
exit	Quit sc }
%ValidateObject(force=0) public {
	Set sc=1
	If '$system.CLS.GetModified() Quit sc
	If m%buildTime Set iv=..buildTime If iv'="" Set rc=(..buildTimeIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"buildTime",iv)
	Set iv=..conceptCount If iv="" Set rc=$$Error^%apiOBJ(5659,$classname()_"::"_"conceptCount"_"("_$this_",ID="),sc=$select(+sc:rc,1:$$AppendStatus^%occSystem(sc,rc))
	If m%conceptCount Set rc=(..conceptCountIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"conceptCount",iv)
	If m%createdBy Set iv=..createdBy If iv'="" Set rc=(..createdByIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"createdBy",iv)
	If m%createdTime Set iv=..createdTime If iv'="" Set rc=(..createdTimeIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"createdTime",iv)
	If m%description Set iv=..description If iv'="" Set rc=(..descriptionIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"description",iv)
	Set iv=..id If iv="" Set rc=$$Error^%apiOBJ(5659,$classname()_"::"_"id"_"("_$this_",ID="),sc=$select(+sc:rc,1:$$AppendStatus^%occSystem(sc,rc))
	If m%id Set rc=(..idIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"id",iv)
	If m%modifiedBy Set iv=..modifiedBy If iv'="" Set rc=(..modifiedByIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"modifiedBy",iv)
	If m%modifiedTime Set iv=..modifiedTime If iv'="" Set rc=(..modifiedTimeIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"modifiedTime",iv)
	Set iv=..name If iv="" Set rc=$$Error^%apiOBJ(5659,$classname()_"::"_"name"_"("_$this_",ID="),sc=$select(+sc:rc,1:$$AppendStatus^%occSystem(sc,rc))
	If m%name Set rc=(..nameIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"name",iv)
	Set iv=..writable If iv="" Set rc=$$Error^%apiOBJ(5659,$classname()_"::"_"writable"_"("_$this_",ID="),sc=$select(+sc:rc,1:$$AppendStatus^%occSystem(sc,rc))
	If m%writable Set rc=(..writableIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"writable",iv)
	Quit sc }
zXMLDTD(top,format,input,dtdlist)
 Quit ##class(%XML.Implementation).XMLDTD("BSTS.ns1.TSubset",.top,.format,.input,.dtdlist)
zXMLExportInternal()
 New tag,summary,attrsVal,savelocal,aval,k,tmpPrefix,prefixDepth,hasNoContent,hasElement,topAttrs,beginprefix,endprefix,savexsiAttrs,initialxsiAttrs,initlist,initialCR,inlineFlag,popAtEnd,saveTopPrefix,saveTypesPrefix,saveAttrsPrefix,saveUsePrefix,initlist
 Set $ztrap="XMLExportInternalTrap",popAtEnd=0
 Set summary=summaryArg,initialxsiAttrs=xsiAttrs
 If group Quit $$Error^%apiOBJ(6386,"BSTS.ns1.TSubset")
 If indentFlag Set initialCR=($extract(currentIndent,1,2)=$c(13,10))
 Set id=createId
 Set temp=""
 If id'="" {
   If $piece($get(idlist(+$this)),",",2)'="" Quit 1
   Set idlist(+$this)=id_",1"
 }
 If encoded Set initlist=$lb($get(oreflist),inlineFlagArg),oreflist=1,inlineFlag=inlineFlagArg
 If 'nocycle,('encoded||inlineFlag) {
   If $data(oreflist($this)) Quit $$Error^%apiOBJ(6296,"BSTS.ns1.TSubset")
   Set oreflist($this)=""
 }
 Set tag=$get(topArg)
 Set tmpi=(($get(typeAttr)'="")&&(typeAttr'="BSTS.ns1.TSubset"))
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
   If tag="" Set tag="TSubset"
   Set xsitype=namespaces.OutputTypeAttribute
 } Else {
   Set saveTopPrefix=topPrefix,saveTypesPrefix=typesPrefix,saveAttrsPrefix=attrsPrefix,saveUsePrefix=usePrefix
   Set typesPrefix=namespaces If (typesPrefix'=""),($extract(typesPrefix,*)'=":") Set typesPrefix=typesPrefix_":"
   If 'encoded Set namespaces=""
   Set (topPrefix,attrsPrefix,topAttrs,beginprefix)=""
   If tag="" Set tag=typesPrefix_"TSubset"
   Set xsitype=0
 }
 Set local=+$get(local),savelocal=local
 Set endprefix="</"_beginprefix,beginprefix="<"_beginprefix
 If tmpi Set temp=temp_" "_xsiPrefix_"type="""_typesPrefix_"TSubset"""_xsiAttrs,xsiAttrs=""
   If id'="" Set temp=" "_$select($get(soap12):soapPrefix_"id",1:"id")_"=""id"_id_""""_temp
 If encoded Set temp=temp_xsiAttrs,xsiAttrs=""
 If indentFlag Set %xmlmsg=currentIndent if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg } Set currentIndent=$select(initialCR:"",1:$c(13,10))_currentIndent_indentChars
 If tag[":" Set topPrefix=$piece(tag,":"),tag=$piece(tag,":",2)  If topPrefix'="" Set topPrefix=topPrefix_":"
 Set %xmlmsg="<"_topPrefix_tag_temp if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set attrsVal=attrsArg,attrsArg="" Set %xmlmsg=attrsVal if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set %xmlmsg=">" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..id
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"id"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"int""",1:"")_">"_val_endprefix_"id>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set aval=..properties
 Set k="" Set:deepFlag val=aval.GetNext(.k) If k'="" {
   If encoded {
     If indentFlag Set %xmlmsg=currentIndent Set currentIndent=currentIndent_indentChars if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     Set temp="",temp1=$parameter("BSTS.ns1.TProperty","NAMESPACE")
     Set temp1=$select((temp1'="http://apelon.com/dtsserver/types")&&$IsObject(namespaces):namespaces.GetNamespacePrefix(temp1,.temp),1:typesPrefix)
     If soap12 { Set %xmlmsg=beginprefix_"properties"_$select(xsitype:"",1:" "_soapPrefix_"itemType="""_temp1_$select($parameter("BSTS.ns1.TProperty","XMLSUMMARY")'="":"s_TProperty",1:"TProperty")_"""")_" "_soapPrefix_"arraySize="""_aval.Count()_""""_""_temp_">" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     } Else { Set %xmlmsg=beginprefix_"properties "_$select(xsitype:xsiPrefix_"type="""_soapPrefix_"Array""",1:soapPrefix_"arrayType="""_temp1_$select($parameter("BSTS.ns1.TProperty","XMLSUMMARY")'="":"s_TProperty",1:"TProperty")_"["_aval.Count()_"]""")_""_temp_">" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg } }
   }
   While k'="" {
     If $IsObject(val) {
       Set id=""
       If encoded,'inlineFlag {
         Set temp=$select($parameter("BSTS.ns1.TProperty","XMLSUMMARY")'="":-1,1:1)
         Set id=+$get(idlist(temp*val))
         If 'soap12 , (id=0) Set id=$increment(idlist),oreflist(temp*id)=val,idlist(temp*val)=id
       }
       If +id'=0 {
         Set %xmlmsg=currentIndent_beginprefix_"properties "_$select(soap12:soapPrefix_"ref=""",1:"href=""#")_"id"_id_""" />" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
       } Else { if id=0 Set id=$increment(idlist)
         Set topArg="properties",summaryArg=1,group=0,createId=$get(id),typeAttr=$select(encoded||xsitype:"*",1:"BSTS.ns1.TProperty"),local=1,savexsiAttrs=xsiAttrs
         Set sc=val.XMLExportInternal() Goto:'sc XMLExportExit Set xsiAttrs=savexsiAttrs
       }
     } Else {
       Set %xmlmsg=currentIndent_beginprefix_"properties "_xsiPrefix_"nil=""true"""_xsiAttrs_"/>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     }
     Set val=aval.GetNext(.k)
   }
   If encoded {
     If indentFlag Set currentIndent=$extract(currentIndent,1,*-$length(indentChars)) Set %xmlmsg=currentIndent if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     Set %xmlmsg=endprefix_"properties>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
   }
 }
 Set val=..name
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"name"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"string""",1:"")_">"_$select(val=$c(0):"",1:$select((val["<")||(val[">")||(val["&"):"<![CDATA["_$replace(val,"]]>","]]]]><![CDATA[>")_"]]>",1:val))_endprefix_"name>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..authority
 If $IsObject(val) , deepFlag {
   Set id=""
   If encoded,'inlineFlag {
     Set temp=$select($parameter("BSTS.ns1.TAuthority","XMLSUMMARY")'="":-1,1:1)
     Set id=+$get(idlist(temp*val))
     If 'soap12 , (id=0) Set id=$increment(idlist),oreflist(temp*id)=val,idlist(temp*val)=id
   }
   If +id'=0 {
     Set %xmlmsg=currentIndent_beginprefix_"authority "_$select(soap12:soapPrefix_"ref=""",1:"href=""#")_"id"_id_""" />" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
   } Else { if id=0 Set id=$increment(idlist)
     Set topArg="authority",summaryArg=1,group=0,createId=$get(id),typeAttr=$select(encoded||xsitype:"*",1:"BSTS.ns1.TAuthority"),local=1,savexsiAttrs=xsiAttrs
     Set sc=val.XMLExportInternal() Goto:'sc XMLExportExit Set xsiAttrs=savexsiAttrs
   }
 }
 Set val=..writable
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"writable"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"boolean""",1:"")_">"_$s(val:"true",1:"false")_endprefix_"writable>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..contentVersion
 If $IsObject(val) , deepFlag {
   Set id=""
   If encoded,'inlineFlag {
     Set temp=$select($parameter("BSTS.ns1.TContentVersion","XMLSUMMARY")'="":-1,1:1)
     Set id=+$get(idlist(temp*val))
     If 'soap12 , (id=0) Set id=$increment(idlist),oreflist(temp*id)=val,idlist(temp*val)=id
   }
   If +id'=0 {
     Set %xmlmsg=currentIndent_beginprefix_"contentVersion "_$select(soap12:soapPrefix_"ref=""",1:"href=""#")_"id"_id_""" />" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
   } Else { if id=0 Set id=$increment(idlist)
     Set topArg="contentVersion",summaryArg=1,group=0,createId=$get(id),typeAttr=$select(encoded||xsitype:"*",1:"BSTS.ns1.TContentVersion"),local=1,savexsiAttrs=xsiAttrs
     Set sc=val.XMLExportInternal() Goto:'sc XMLExportExit Set xsiAttrs=savexsiAttrs
   }
 }
 Set aval=..contentVersions
 Set k="" Set:deepFlag val=aval.GetNext(.k) If k'="" {
   If encoded {
     If indentFlag Set %xmlmsg=currentIndent Set currentIndent=currentIndent_indentChars if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     Set temp="",temp1=$parameter("BSTS.ns1.TContentVersion","NAMESPACE")
     Set temp1=$select((temp1'="http://apelon.com/dtsserver/types")&&$IsObject(namespaces):namespaces.GetNamespacePrefix(temp1,.temp),1:typesPrefix)
     If soap12 { Set %xmlmsg=beginprefix_"contentVersions"_$select(xsitype:"",1:" "_soapPrefix_"itemType="""_temp1_$select($parameter("BSTS.ns1.TContentVersion","XMLSUMMARY")'="":"s_TContentVersion",1:"TContentVersion")_"""")_" "_soapPrefix_"arraySize="""_aval.Count()_""""_""_temp_">" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     } Else { Set %xmlmsg=beginprefix_"contentVersions "_$select(xsitype:xsiPrefix_"type="""_soapPrefix_"Array""",1:soapPrefix_"arrayType="""_temp1_$select($parameter("BSTS.ns1.TContentVersion","XMLSUMMARY")'="":"s_TContentVersion",1:"TContentVersion")_"["_aval.Count()_"]""")_""_temp_">" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg } }
   }
   While k'="" {
     If $IsObject(val) {
       Set id=""
       If encoded,'inlineFlag {
         Set temp=$select($parameter("BSTS.ns1.TContentVersion","XMLSUMMARY")'="":-1,1:1)
         Set id=+$get(idlist(temp*val))
         If 'soap12 , (id=0) Set id=$increment(idlist),oreflist(temp*id)=val,idlist(temp*val)=id
       }
       If +id'=0 {
         Set %xmlmsg=currentIndent_beginprefix_"contentVersions "_$select(soap12:soapPrefix_"ref=""",1:"href=""#")_"id"_id_""" />" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
       } Else { if id=0 Set id=$increment(idlist)
         Set topArg="contentVersions",summaryArg=1,group=0,createId=$get(id),typeAttr=$select(encoded||xsitype:"*",1:"BSTS.ns1.TContentVersion"),local=1,savexsiAttrs=xsiAttrs
         Set sc=val.XMLExportInternal() Goto:'sc XMLExportExit Set xsiAttrs=savexsiAttrs
       }
     } Else {
       Set %xmlmsg=currentIndent_beginprefix_"contentVersions "_xsiPrefix_"nil=""true"""_xsiAttrs_"/>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     }
     Set val=aval.GetNext(.k)
   }
   If encoded {
     If indentFlag Set currentIndent=$extract(currentIndent,1,*-$length(indentChars)) Set %xmlmsg=currentIndent if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     Set %xmlmsg=endprefix_"contentVersions>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
   }
 }
 Set val=..description
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"description"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"string""",1:"")_">"_$select(val=$c(0):"",1:$select((val["<")||(val[">")||(val["&"):"<![CDATA["_$replace(val,"]]>","]]]]><![CDATA[>")_"]]>",1:val))_endprefix_"description>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..expression
 If $IsObject(val) , deepFlag {
   Set id=""
   If encoded,'inlineFlag {
     Set temp=$select($parameter("BSTS.ns1.TSubsetExpression","XMLSUMMARY")'="":-1,1:1)
     Set id=+$get(idlist(temp*val))
     If 'soap12 , (id=0) Set id=$increment(idlist),oreflist(temp*id)=val,idlist(temp*val)=id
   }
   If +id'=0 {
     Set %xmlmsg=currentIndent_beginprefix_"expression "_$select(soap12:soapPrefix_"ref=""",1:"href=""#")_"id"_id_""" />" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
   } Else { if id=0 Set id=$increment(idlist)
     Set topArg="expression",summaryArg=1,group=0,createId=$get(id),typeAttr=$select(encoded||xsitype:"*",1:"BSTS.ns1.TSubsetExpression"),local=1,savexsiAttrs=xsiAttrs
     Set sc=val.XMLExportInternal() Goto:'sc XMLExportExit Set xsiAttrs=savexsiAttrs
   }
 }
 Set val=..conceptCount
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"conceptCount"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"int""",1:"")_">"_val_endprefix_"conceptCount>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..buildTime
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"buildTime"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"dateTime""",1:"")_">"_$select(val="":"",1:$translate(val," ","T")_"Z")_endprefix_"buildTime>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..createdBy
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"createdBy"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"string""",1:"")_">"_$select(val=$c(0):"",1:$select((val["<")||(val[">")||(val["&"):"<![CDATA["_$replace(val,"]]>","]]]]><![CDATA[>")_"]]>",1:val))_endprefix_"createdBy>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..createdTime
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"createdTime"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"dateTime""",1:"")_">"_$select(val="":"",1:$translate(val," ","T")_"Z")_endprefix_"createdTime>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..modifiedBy
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"modifiedBy"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"string""",1:"")_">"_$select(val=$c(0):"",1:$select((val["<")||(val[">")||(val["&"):"<![CDATA["_$replace(val,"]]>","]]]]><![CDATA[>")_"]]>",1:val))_endprefix_"modifiedBy>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..modifiedTime
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"modifiedTime"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"dateTime""",1:"")_">"_$select(val="":"",1:$translate(val," ","T")_"Z")_endprefix_"modifiedTime>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 If indentFlag Set currentIndent=$extract(currentIndent,1,*-$length(indentChars)) Set %xmlmsg=currentIndent if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set %xmlmsg="</"_topPrefix_tag_">" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg } If indentFlag,'initialCR if $data(%xmlBlock) { Set %xmlmsg="" Do xeWriteLine^%occXMLInternal } else { write ! } Set $extract(currentIndent,1,2)=""
 If '$IsObject(namespaces) || (popAtEnd=1) Set topPrefix=saveTopPrefix,typesPrefix=saveTypesPrefix,attrsPrefix=saveAttrsPrefix,usePrefix=saveUsePrefix
 If popAtEnd Do namespaces.PopNode()
 If encoded Set oreflist=$list(initlist),inlineFlag=$list(initlist,2)
 If 'encoded||inlineFlag {
   If 'nocycle Kill oreflist($this)
 } ElseIf $get(oreflist)'=1 {
   Set oreflist=1
   Set id=$order(oreflist(""))
   While id'="" {
     Set val=oreflist(id)
     Kill oreflist(id)
     Set group=0,createId=$zabs(id),typeAttr="*",local=savelocal,xsiAttrs=initialxsiAttrs
     If $classname(val)="BSTS.ns1.TSubset" {
       Set attrsArg=attrsVal
       Set topArg=tag,summaryArg=0
       Set sc=val.XMLExportInternal()
     } Else {
       Set topArg="",summaryArg=(id<0)
       Set sc=val.XMLExportInternal()
     }
     If 'sc Quit
     Set id=$order(oreflist(""))
   }
   Kill oreflist
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
 Quit ##class(%XML.Implementation).XMLGetSchemaImports("BSTS.ns1.TSubset",.imports,.classes)
zXMLImportInternal()
 New child,node,data,ref,encodedArray,loopref,element,key,nsIndex
 Set $ztrap="XMLImportInternalTrap"
 Set encoded=$case($piece(fmt,",",1),"":0,"literal":0,"encoded":1,"encoded12":1,:"")
 If encoded="" Quit $$Error^%apiOBJ(6231,fmt)
 Set nsIndex=$get(@(tree)@("ns","http://apelon.com/dtsserver/types"))
 Set (node,ref)=nodeArg
 If ($listget($get(@(tree)@(node,0)),1)'="e")||(tag'=@(tree)@(node)) Goto XMLImportMalformed
 If bareProjection Quit $$Error^%apiOBJ(6386,"BSTS.ns1.TSubset")
 If encoded {
   If $data(@(tree)@(node,"a","id")) Set idlist(node)=$this
 }
 If +$listget($get(@(tree)@(node,0)),7,0) Quit 1
 Set sc=$$XMLImportElements()
XMLImportExit Quit sc
XMLImportElements() ;
 Set child=""
 If $$XMLLOOP()'=0 Quit sc
 If tag="id" {
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
   Set ..id=data
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 For  { Set encodedArray=encoded
 If tag="properties" {
   If '$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
   If encoded,$$XMLImportId() {
     Set data=idlist(ref)
   } Else {
     If 'sc Goto XMLImportExit
     If encoded,(($data(@(tree)@(ref,"a","arrayType")))||(($get(@(tree)@(ref,"a","type","u"))=1)&&($piece($get(@(tree)@(ref,"a","type")),":",2)="Array"))||($select($get(@(tree)@(ref,"a","itemType","u"))="":"",1:$get(@(tree)@("ns#",@(tree)@(ref,"a","itemType","u"))))="http://www.w3.org/2003/05/soap-encoding")||($select($get(@(tree)@(ref,"a","nodeType","u"))="":"",1:$get(@(tree)@("ns#",@(tree)@(ref,"a","nodeType","u"))))="http://www.w3.org/2003/05/soap-encoding")||($select($get(@(tree)@(ref,"a","arraySize","u"))="":"",1:$get(@(tree)@("ns#",@(tree)@(ref,"a","arraySize","u"))))="http://www.w3.org/2003/05/soap-encoding")) {
       Set loopref=ref
       Set element=$order(@(tree)@(loopref,"c",""))
       While element'="" {
         If $listget($get(@(tree)@(element,0)),1)'="w" {
           Set ref=element
         If $listget($get(@(tree)@(ref,0)),1)'="e" Goto XMLImportMalformedNoTag
         If '$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
         If $$XMLImportId() {
           Set data=idlist(ref)
         } Else {
           If 'sc Goto XMLImportExit
           Set class=$select(($get(@(tree)@(ref,"a","type","u"))=1):$get(@(tree)@(ref,"a","type")),1:"")
           If (class="") || (class="TProperty") {
             Set class="BSTS.ns1.TProperty"
           } Else {
             If $length(class,":")=2 Set class=$piece(class,":",2)
             Set class=$get(^oddCOM("BSTS.ns1.TProperty",85,"s",class))_$get(^oddXML("BSTS.ns1.TProperty","s",class)) If class="" Set class=0
             Set tmp=$select($get(@(tree)@(ref,"a","type","v"))="":"",1:$get(@(tree)@("ns#",@(tree)@(ref,"a","type","v"))))
             If (class=0)||(($listlength(class)>1)&&(tmp="")) Set class=$get(@(tree)@(ref,"a","type")) Goto XMLImportBadType
             If $listlength(class)>1 {
               For tmpi=1:1:$listlength(class) {
                 If tmp=$parameter($list(class,tmpi),"NAMESPACE") Set class=$list(class,tmpi),tmpi=0 Quit
               }
               If tmpi Set class=$get(@(tree)@(ref,"a","type")) Goto XMLImportBadType
             } Else { Set class=$list(class) }
           }
           Set data=$classmethod(class,"XMLNew",handler,ref,$this)
           If $isobject(data) Set tag=@(tree)@(ref),nodeArg=ref,bareProjection=0,summaryArg=1,keynameattr="",sc=data.XMLImportInternal() If ('sc) Goto XMLImportExit
           If ($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
         }
         If data'="" Do ..properties.Insert(data)
         }
         Set element=$order(@(tree)@(loopref,"c",element))
       }
       Quit:('sc)  Set ref=loopref
     } Else { Set encodedArray=0
         If $listget($get(@(tree)@(ref,0)),1)'="e" Goto XMLImportMalformedNoTag
         If 'encoded,(@(tree)@(ref)'="properties") Goto XMLImportBadTag
         If '$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
         If encoded,$$XMLImportId() {
           Set data=idlist(ref)
         } Else {
           If 'sc Goto XMLImportExit
           Set class=$select(($get(@(tree)@(ref,"a","type","u"))=1):$get(@(tree)@(ref,"a","type")),1:"")
           If (class="") || (class="TProperty") {
             Set class="BSTS.ns1.TProperty"
           } Else {
             If $length(class,":")=2 Set class=$piece(class,":",2)
             Set class=$get(^oddCOM("BSTS.ns1.TProperty",85,"s",class))_$get(^oddXML("BSTS.ns1.TProperty","s",class)) If class="" Set class=0
             Set tmp=$select($get(@(tree)@(ref,"a","type","v"))="":"",1:$get(@(tree)@("ns#",@(tree)@(ref,"a","type","v"))))
             If (class=0)||(($listlength(class)>1)&&(tmp="")) Set class=$get(@(tree)@(ref,"a","type")) Goto XMLImportBadType
             If $listlength(class)>1 {
               For tmpi=1:1:$listlength(class) {
                 If tmp=$parameter($list(class,tmpi),"NAMESPACE") Set class=$list(class,tmpi),tmpi=0 Quit
               }
               If tmpi Set class=$get(@(tree)@(ref,"a","type")) Goto XMLImportBadType
             } Else { Set class=$list(class) }
           }
           Set data=$classmethod(class,"XMLNew",handler,ref,$this)
           If $isobject(data) Set tag=@(tree)@(ref),nodeArg=ref,bareProjection=0,summaryArg=1,keynameattr="",sc=data.XMLImportInternal() If ('sc) Goto XMLImportExit
           If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
         }
         If data'="" Do ..properties.Insert(data)
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 Else { Quit  }
 If encodedArray Quit
 }
 If tag="name" {
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
   Set ..name=data
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 If tag="authority" {
   If '$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
   If encoded,$$XMLImportId() {
     Set data=idlist(ref)
   } Else { Goto:'sc XMLImportExit
     Set class=$select(($get(@(tree)@(ref,"a","type","u"))=1):$get(@(tree)@(ref,"a","type")),1:"")
     If (class="") || (class="TAuthority") {
       Set class="BSTS.ns1.TAuthority"
     } Else {
       If $length(class,":")=2 Set class=$piece(class,":",2)
       Set class=$get(^oddCOM("BSTS.ns1.TAuthority",85,"s",class))_$get(^oddXML("BSTS.ns1.TAuthority","s",class)) If class="" Set class=0
       Set tmp=$select($get(@(tree)@(ref,"a","type","v"))="":"",1:$get(@(tree)@("ns#",@(tree)@(ref,"a","type","v"))))
       If (class=0)||(($listlength(class)>1)&&(tmp="")) Set class=$get(@(tree)@(ref,"a","type")) Goto XMLImportBadType
       If $listlength(class)>1 {
         For tmpi=1:1:$listlength(class) {
           If tmp=$parameter($list(class,tmpi),"NAMESPACE") Set class=$list(class,tmpi),tmpi=0 Quit
         }
         If tmpi Set class=$get(@(tree)@(ref,"a","type")) Goto XMLImportBadType
       } Else { Set class=$list(class) }
     }
     Set data=$classmethod(class,"XMLNew",handler,ref,$this)
     If $isobject(data) Set tag=@(tree)@(ref),nodeArg=ref,bareProjection=0,summaryArg=1,keynameattr="",sc=data.XMLImportInternal() If ('sc) Goto XMLImportExit
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   If data'="" Set ..authority=data
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 If tag="writable" {
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
             Set data=$zstrip(data,"<>W",$c(13,10)) If data'="" Set data=$case(data,"true":1,"false":0,1:1,0:0,:"") Goto:data="" XMLImportErr Goto:('$s($isvalidnum(data,0,0,2)&&(+data'=2):1,1:$$Error^%apiOBJ(7206,data))) XMLImportErr
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   Set ..writable=data
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 If tag="contentVersion" {
   If '$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
   If encoded,$$XMLImportId() {
     Set data=idlist(ref)
   } Else { Goto:'sc XMLImportExit
     Set class=$select(($get(@(tree)@(ref,"a","type","u"))=1):$get(@(tree)@(ref,"a","type")),1:"")
     If (class="") || (class="TContentVersion") {
       Set class="BSTS.ns1.TContentVersion"
     } Else {
       If $length(class,":")=2 Set class=$piece(class,":",2)
       Set class=$get(^oddCOM("BSTS.ns1.TContentVersion",85,"s",class))_$get(^oddXML("BSTS.ns1.TContentVersion","s",class)) If class="" Set class=0
       Set tmp=$select($get(@(tree)@(ref,"a","type","v"))="":"",1:$get(@(tree)@("ns#",@(tree)@(ref,"a","type","v"))))
       If (class=0)||(($listlength(class)>1)&&(tmp="")) Set class=$get(@(tree)@(ref,"a","type")) Goto XMLImportBadType
       If $listlength(class)>1 {
         For tmpi=1:1:$listlength(class) {
           If tmp=$parameter($list(class,tmpi),"NAMESPACE") Set class=$list(class,tmpi),tmpi=0 Quit
         }
         If tmpi Set class=$get(@(tree)@(ref,"a","type")) Goto XMLImportBadType
       } Else { Set class=$list(class) }
     }
     Set data=$classmethod(class,"XMLNew",handler,ref,$this)
     If $isobject(data) Set tag=@(tree)@(ref),nodeArg=ref,bareProjection=0,summaryArg=1,keynameattr="",sc=data.XMLImportInternal() If ('sc) Goto XMLImportExit
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   If data'="" Set ..contentVersion=data
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 For  { Set encodedArray=encoded
 If tag="contentVersions" {
   If '$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
   If encoded,$$XMLImportId() {
     Set data=idlist(ref)
   } Else {
     If 'sc Goto XMLImportExit
     If encoded,(($data(@(tree)@(ref,"a","arrayType")))||(($get(@(tree)@(ref,"a","type","u"))=1)&&($piece($get(@(tree)@(ref,"a","type")),":",2)="Array"))||($select($get(@(tree)@(ref,"a","itemType","u"))="":"",1:$get(@(tree)@("ns#",@(tree)@(ref,"a","itemType","u"))))="http://www.w3.org/2003/05/soap-encoding")||($select($get(@(tree)@(ref,"a","nodeType","u"))="":"",1:$get(@(tree)@("ns#",@(tree)@(ref,"a","nodeType","u"))))="http://www.w3.org/2003/05/soap-encoding")||($select($get(@(tree)@(ref,"a","arraySize","u"))="":"",1:$get(@(tree)@("ns#",@(tree)@(ref,"a","arraySize","u"))))="http://www.w3.org/2003/05/soap-encoding")) {
       Set loopref=ref
       Set element=$order(@(tree)@(loopref,"c",""))
       While element'="" {
         If $listget($get(@(tree)@(element,0)),1)'="w" {
           Set ref=element
         If $listget($get(@(tree)@(ref,0)),1)'="e" Goto XMLImportMalformedNoTag
         If '$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
         If $$XMLImportId() {
           Set data=idlist(ref)
         } Else {
           If 'sc Goto XMLImportExit
           Set class=$select(($get(@(tree)@(ref,"a","type","u"))=1):$get(@(tree)@(ref,"a","type")),1:"")
           If (class="") || (class="TContentVersion") {
             Set class="BSTS.ns1.TContentVersion"
           } Else {
             If $length(class,":")=2 Set class=$piece(class,":",2)
             Set class=$get(^oddCOM("BSTS.ns1.TContentVersion",85,"s",class))_$get(^oddXML("BSTS.ns1.TContentVersion","s",class)) If class="" Set class=0
             Set tmp=$select($get(@(tree)@(ref,"a","type","v"))="":"",1:$get(@(tree)@("ns#",@(tree)@(ref,"a","type","v"))))
             If (class=0)||(($listlength(class)>1)&&(tmp="")) Set class=$get(@(tree)@(ref,"a","type")) Goto XMLImportBadType
             If $listlength(class)>1 {
               For tmpi=1:1:$listlength(class) {
                 If tmp=$parameter($list(class,tmpi),"NAMESPACE") Set class=$list(class,tmpi),tmpi=0 Quit
               }
               If tmpi Set class=$get(@(tree)@(ref,"a","type")) Goto XMLImportBadType
             } Else { Set class=$list(class) }
           }
           Set data=$classmethod(class,"XMLNew",handler,ref,$this)
           If $isobject(data) Set tag=@(tree)@(ref),nodeArg=ref,bareProjection=0,summaryArg=1,keynameattr="",sc=data.XMLImportInternal() If ('sc) Goto XMLImportExit
           If ($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
         }
         If data'="" Do ..contentVersions.Insert(data)
         }
         Set element=$order(@(tree)@(loopref,"c",element))
       }
       Quit:('sc)  Set ref=loopref
     } Else { Set encodedArray=0
         If $listget($get(@(tree)@(ref,0)),1)'="e" Goto XMLImportMalformedNoTag
         If 'encoded,(@(tree)@(ref)'="contentVersions") Goto XMLImportBadTag
         If '$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
         If encoded,$$XMLImportId() {
           Set data=idlist(ref)
         } Else {
           If 'sc Goto XMLImportExit
           Set class=$select(($get(@(tree)@(ref,"a","type","u"))=1):$get(@(tree)@(ref,"a","type")),1:"")
           If (class="") || (class="TContentVersion") {
             Set class="BSTS.ns1.TContentVersion"
           } Else {
             If $length(class,":")=2 Set class=$piece(class,":",2)
             Set class=$get(^oddCOM("BSTS.ns1.TContentVersion",85,"s",class))_$get(^oddXML("BSTS.ns1.TContentVersion","s",class)) If class="" Set class=0
             Set tmp=$select($get(@(tree)@(ref,"a","type","v"))="":"",1:$get(@(tree)@("ns#",@(tree)@(ref,"a","type","v"))))
             If (class=0)||(($listlength(class)>1)&&(tmp="")) Set class=$get(@(tree)@(ref,"a","type")) Goto XMLImportBadType
             If $listlength(class)>1 {
               For tmpi=1:1:$listlength(class) {
                 If tmp=$parameter($list(class,tmpi),"NAMESPACE") Set class=$list(class,tmpi),tmpi=0 Quit
               }
               If tmpi Set class=$get(@(tree)@(ref,"a","type")) Goto XMLImportBadType
             } Else { Set class=$list(class) }
           }
           Set data=$classmethod(class,"XMLNew",handler,ref,$this)
           If $isobject(data) Set tag=@(tree)@(ref),nodeArg=ref,bareProjection=0,summaryArg=1,keynameattr="",sc=data.XMLImportInternal() If ('sc) Goto XMLImportExit
           If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
         }
         If data'="" Do ..contentVersions.Insert(data)
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 Else { Quit  }
 If encodedArray Quit
 }
 If tag="description" {
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
   Set ..description=data
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 If tag="expression" {
   If '$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
   If encoded,$$XMLImportId() {
     Set data=idlist(ref)
   } Else { Goto:'sc XMLImportExit
     Set class=$select(($get(@(tree)@(ref,"a","type","u"))=1):$get(@(tree)@(ref,"a","type")),1:"")
     If (class="") || (class="TSubsetExpression") {
       Set class="BSTS.ns1.TSubsetExpression"
     } Else {
       If $length(class,":")=2 Set class=$piece(class,":",2)
       Set class=$get(^oddCOM("BSTS.ns1.TSubsetExpression",85,"s",class))_$get(^oddXML("BSTS.ns1.TSubsetExpression","s",class)) If class="" Set class=0
       Set tmp=$select($get(@(tree)@(ref,"a","type","v"))="":"",1:$get(@(tree)@("ns#",@(tree)@(ref,"a","type","v"))))
       If (class=0)||(($listlength(class)>1)&&(tmp="")) Set class=$get(@(tree)@(ref,"a","type")) Goto XMLImportBadType
       If $listlength(class)>1 {
         For tmpi=1:1:$listlength(class) {
           If tmp=$parameter($list(class,tmpi),"NAMESPACE") Set class=$list(class,tmpi),tmpi=0 Quit
         }
         If tmpi Set class=$get(@(tree)@(ref,"a","type")) Goto XMLImportBadType
       } Else { Set class=$list(class) }
     }
     Set data=$classmethod(class,"XMLNew",handler,ref,$this)
     If $isobject(data) Set tag=@(tree)@(ref),nodeArg=ref,bareProjection=0,summaryArg=1,keynameattr="",sc=data.XMLImportInternal() If ('sc) Goto XMLImportExit
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   If data'="" Set ..expression=data
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 If tag="conceptCount" {
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
   Set ..conceptCount=data
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 If tag="buildTime" {
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
             Set data=$zstrip(data,"<>W",$c(13,10)) If data'="" Set data=..buildTimeXSDToLogical(data) Goto:data="" XMLImportErr Goto:('..buildTimeIsValid(data)) XMLImportErr
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   Set ..buildTime=data
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 If tag="createdBy" {
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
   Set ..createdBy=data
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 If tag="createdTime" {
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
             Set data=$zstrip(data,"<>W",$c(13,10)) If data'="" Set data=..createdTimeXSDToLogical(data) Goto:data="" XMLImportErr Goto:('..createdTimeIsValid(data)) XMLImportErr
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   Set ..createdTime=data
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 If tag="modifiedBy" {
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
   Set ..modifiedBy=data
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 If tag="modifiedTime" {
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
             Set data=$zstrip(data,"<>W",$c(13,10)) If data'="" Set data=..modifiedTimeXSDToLogical(data) Goto:data="" XMLImportErr Goto:('..modifiedTimeIsValid(data)) XMLImportErr
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   Set ..modifiedTime=data
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
 If ..id'="" Quit 0
 If ..properties.Count()>0 Quit 0
 If ..name'="" Quit 0
 If $IsObject(..authority) Quit 0
 If ..writable'="" Quit 0
 If $IsObject(..contentVersion) Quit 0
 If ..contentVersions.Count()>0 Quit 0
 If ..description'="" Quit 0
 If $IsObject(..expression) Quit 0
 If ..conceptCount'="" Quit 0
 If ..buildTime'="" Quit 0
 If ..createdBy'="" Quit 0
 If ..createdTime'="" Quit 0
 If ..modifiedBy'="" Quit 0
 If ..modifiedTime'="" Quit 0
 Quit 1
zXMLNew(document,node,containerOref="")
	Quit (##class(BSTS.ns1.TSubset).%New())
zXMLSchema(top="",format="",namespacePrefix="",input=0,refOnly=0,schema)
 Quit ##class(%XML.Implementation).XMLSchema("BSTS.ns1.TSubset",top,format,namespacePrefix,input,refOnly,.schema)
zbuildTimeIsValid(%val)
	Quit:$zu(115,13)&&(%val=$c(0)) 1 New val Set val=%val,%val=$select(%val=(%val\1):$zd(%val,3,,,,,,,"error")_" 00:00:00",%val?1.2N1":"2N1":"2N.1(1"."1.N):$zd($h,3)_" "_%val,$length(%val)=10:%val_" 00:00:00",1:%val) Quit:($length(%val)<19||($zdth(%val,3,,,,,,,,"")="")) $$Error^%apiOBJ(7208,val)
	Quit 1
zbuildTimeLogicalToXSD(%val)
	Quit $select(%val="":"",1:$translate(%val," ","T")_"Z")
zbuildTimeNormalize(%val)
	Quit $s(%val="":"",$zu(115,13)&&(%val=$c(0)):"",%val=(%val\1):$zd(%val,3,,,,,,,"error")_" 00:00:00",%val?1.2N1":"2N1":"2N.1(1"."1.N):$zd($h,3)_" "_%val,$l(%val)=10:%val_" 00:00:00",$zdth(%val,3,,,,,,,,"")="":"error",1:$zdt($zdth($p(%val,"."),3,,,,,,,,""),3)_$s(+$p(%val,".",2)=0:"",1:+("."_$p(%val,".",2))))
zbuildTimeOdbcToLogical(%val)
 quit:%val="" "" if $zdth(%val,3,,,,,,,,"")'="" { s %val=$zdt($zdth(%val,3),3,,$l($p(%val,".",2))) } elseif $zdth(%val,-1,,,,,,,,"")'="" { s %val=$zdt($zdth(%val,-1),3,,$l($p(%val,".",2))) } quit $s(%val'[".":%val,1:$zstrip($zstrip(%val,">","0"),">","."))
	Quit
zbuildTimeXSDToLogical(%val)
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
zconceptCountDisplayToLogical(%val) public {
	Q $s(%val="":"",$zu(115,13)&&(%val=$c(0)):"",1:+$in(%val,"",%val)) }
zconceptCountIsValid(%val) public {
	Quit $select($zu(115,13)&&(%val=$c(0)):1,$isvalidnum(%val,0,-2147483648,2147483647):1,'$isvalidnum(%val):$$Error^%apiOBJ(7207,%val),%val<-2147483648:$$Error^%apiOBJ(7204,%val,-2147483648),1:$$Error^%apiOBJ(7203,%val,2147483647)) }
zconceptCountNormalize(%val) public {
	Quit $select($zu(115,13)&&(%val=$c(0)):"",1:%val\1) }
zconceptCountXSDToLogical(%val) public {
	Q $s($tr(%val,"Ee(),.")'=%val:"",1:$number(%val,"I",-2147483648,2147483647)) }
zcreatedTimeIsValid(%val)
	Quit:$zu(115,13)&&(%val=$c(0)) 1 New val Set val=%val,%val=$select(%val=(%val\1):$zd(%val,3,,,,,,,"error")_" 00:00:00",%val?1.2N1":"2N1":"2N.1(1"."1.N):$zd($h,3)_" "_%val,$length(%val)=10:%val_" 00:00:00",1:%val) Quit:($length(%val)<19||($zdth(%val,3,,,,,,,,"")="")) $$Error^%apiOBJ(7208,val)
	Quit 1
zcreatedTimeLogicalToXSD(%val)
	Quit $select(%val="":"",1:$translate(%val," ","T")_"Z")
zcreatedTimeNormalize(%val)
	Quit $s(%val="":"",$zu(115,13)&&(%val=$c(0)):"",%val=(%val\1):$zd(%val,3,,,,,,,"error")_" 00:00:00",%val?1.2N1":"2N1":"2N.1(1"."1.N):$zd($h,3)_" "_%val,$l(%val)=10:%val_" 00:00:00",$zdth(%val,3,,,,,,,,"")="":"error",1:$zdt($zdth($p(%val,"."),3,,,,,,,,""),3)_$s(+$p(%val,".",2)=0:"",1:+("."_$p(%val,".",2))))
zcreatedTimeOdbcToLogical(%val)
 quit:%val="" "" if $zdth(%val,3,,,,,,,,"")'="" { s %val=$zdt($zdth(%val,3),3,,$l($p(%val,".",2))) } elseif $zdth(%val,-1,,,,,,,,"")'="" { s %val=$zdt($zdth(%val,-1),3,,$l($p(%val,".",2))) } quit $s(%val'[".":%val,1:$zstrip($zstrip(%val,">","0"),">","."))
	Quit
zcreatedTimeXSDToLogical(%val)
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
zexpressionNewObject() public {
	Set newobject=##class(BSTS.ns1.TSubsetExpression).%New() If newobject="" Quit ""
	Set ..expression=newobject
	Quit newobject }
zmodifiedTimeIsValid(%val)
	Quit:$zu(115,13)&&(%val=$c(0)) 1 New val Set val=%val,%val=$select(%val=(%val\1):$zd(%val,3,,,,,,,"error")_" 00:00:00",%val?1.2N1":"2N1":"2N.1(1"."1.N):$zd($h,3)_" "_%val,$length(%val)=10:%val_" 00:00:00",1:%val) Quit:($length(%val)<19||($zdth(%val,3,,,,,,,,"")="")) $$Error^%apiOBJ(7208,val)
	Quit 1
zmodifiedTimeLogicalToXSD(%val)
	Quit $select(%val="":"",1:$translate(%val," ","T")_"Z")
zmodifiedTimeNormalize(%val)
	Quit $s(%val="":"",$zu(115,13)&&(%val=$c(0)):"",%val=(%val\1):$zd(%val,3,,,,,,,"error")_" 00:00:00",%val?1.2N1":"2N1":"2N.1(1"."1.N):$zd($h,3)_" "_%val,$l(%val)=10:%val_" 00:00:00",$zdth(%val,3,,,,,,,,"")="":"error",1:$zdt($zdth($p(%val,"."),3,,,,,,,,""),3)_$s(+$p(%val,".",2)=0:"",1:+("."_$p(%val,".",2))))
zmodifiedTimeOdbcToLogical(%val)
 quit:%val="" "" if $zdth(%val,3,,,,,,,,"")'="" { s %val=$zdt($zdth(%val,3),3,,$l($p(%val,".",2))) } elseif $zdth(%val,-1,,,,,,,,"")'="" { s %val=$zdt($zdth(%val,-1),3,,$l($p(%val,".",2))) } quit $s(%val'[".":%val,1:$zstrip($zstrip(%val,">","0"),">","."))
	Quit
zmodifiedTimeXSDToLogical(%val)
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
