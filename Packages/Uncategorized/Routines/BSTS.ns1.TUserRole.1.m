 ;BSTS.ns1.TUserRole.1
 ;(C)InterSystems, generated for class BSTS.ns1.TUserRole.  Do NOT edit. 10/22/2016 08:53:39AM
 ;;496E3355;BSTS.ns1.TUserRole
 ;
%BindExport(dev,Seen,RegisterOref,AllowedDepth,AllowedCapacity) public {
   i $d(Seen(+$this)) q 1
   Set Seen(+$this)=$this
   s sc = 1
 s proporef=..adminPermissions
 s proporef=..authorityPermissions
 s proporef=..namespacePermissions
 s proporef=..subsetPermissions
   d:RegisterOref InitObjVar^%SYS.BINDSRV($this)
   i dev'="" s t=$io u dev i $zobjexport($this_"",3)+$zobjexport($this."%%OID",3)+$zobjexport($this,3)!1 u t
 If AllowedDepth>0 Set AllowedDepth = AllowedDepth - 1
 If AllowedCapacity>0 Set AllowedCapacity = AllowedCapacity - 1/4
 s proporef=..adminPermissions
       i proporef'="",dev'="" s t=$io u dev i $zobjexport(proporef_"",3)+$zobjexport(proporef."%%OID",3)+$zobjexport(proporef,3)!1 u t
       if proporef'="",dev'="" d
       . s t=$io u dev i $zobjexport(1_"",3)!1 u t
       . s t=$io u dev i $zobjexport(proporef.Count()_"",3)!1 u t
     . for i=1:1:proporef.Count()  s t=$io u dev i $zobjexport(proporef.GetAt(i)_"",3)!1 u t
 s proporef=..authorityPermissions
       i proporef'="" d
  . s idx="" i proporef'="" f  s elemoref=proporef.GetNext(.idx) q:idx=""  s sc=1 i AllowedDepth'=0,AllowedCapacity'=0 s sc=elemoref.%BindExport(dev,.Seen,RegisterOref,AllowedDepth,AllowedCapacity) q:('sc)
  q:('sc) sc
       i proporef'="",dev'="" s t=$io u dev i $zobjexport(proporef_"",3)+$zobjexport(proporef."%%OID",3)+$zobjexport(proporef,3)!1 u t
       if proporef'="",dev'="" d
       . s t=$io u dev i $zobjexport(3_"",3)!1 u t
       . s t=$io u dev i $zobjexport(proporef.Count()_"",3)!1 u t
     . for i=1:1:proporef.Count()  s t=$io u dev i $zobjexport(proporef.GetAt(i)_"",3)!1 u t
 s proporef=..namespacePermissions
       i proporef'="" d
  . s idx="" i proporef'="" f  s elemoref=proporef.GetNext(.idx) q:idx=""  s sc=1 i AllowedDepth'=0,AllowedCapacity'=0 s sc=elemoref.%BindExport(dev,.Seen,RegisterOref,AllowedDepth,AllowedCapacity) q:('sc)
  q:('sc) sc
       i proporef'="",dev'="" s t=$io u dev i $zobjexport(proporef_"",3)+$zobjexport(proporef."%%OID",3)+$zobjexport(proporef,3)!1 u t
       if proporef'="",dev'="" d
       . s t=$io u dev i $zobjexport(3_"",3)!1 u t
       . s t=$io u dev i $zobjexport(proporef.Count()_"",3)!1 u t
     . for i=1:1:proporef.Count()  s t=$io u dev i $zobjexport(proporef.GetAt(i)_"",3)!1 u t
 s proporef=..subsetPermissions
       i proporef'="" d
  . s idx="" i proporef'="" f  s elemoref=proporef.GetNext(.idx) q:idx=""  s sc=1 i AllowedDepth'=0,AllowedCapacity'=0 s sc=elemoref.%BindExport(dev,.Seen,RegisterOref,AllowedDepth,AllowedCapacity) q:('sc)
  q:('sc) sc
       i proporef'="",dev'="" s t=$io u dev i $zobjexport(proporef_"",3)+$zobjexport(proporef."%%OID",3)+$zobjexport(proporef,3)!1 u t
       if proporef'="",dev'="" d
       . s t=$io u dev i $zobjexport(3_"",3)!1 u t
       . s t=$io u dev i $zobjexport(proporef.Count()_"",3)!1 u t
     . for i=1:1:proporef.Count()  s t=$io u dev i $zobjexport(proporef.GetAt(i)_"",3)!1 u t
   Quit sc }
%Construct(initvalue) public {
	Set m%adminPermissions=0,M%adminPermissions=0,m%authorityPermissions=0,M%authorityPermissions=0,m%namespacePermissions=0,M%namespacePermissions=0
	Set m%subsetPermissions=0,M%subsetPermissions=0
	Quit 1 }
%ConstructCloneInit(object,deep=0,cloned,location) public {
	Set i%adminPermissions="",r%adminPermissions=""
	Set i%authorityPermissions="",r%authorityPermissions=""
	Set i%namespacePermissions="",r%namespacePermissions=""
	Set i%subsetPermissions="",r%subsetPermissions=""
	Set i%"%%OID"=""
	If deep>0 {
		Set key="" For  Set value=..authorityPermissions.GetNext(.key) Quit:key=""  Set r%authorityPermissions(key)=$select(value="":"",1:value.%ConstructClone(1,.cloned)),i%authorityPermissions(key)=""
		Set key="" For  Set value=..namespacePermissions.GetNext(.key) Quit:key=""  Set r%namespacePermissions(key)=$select(value="":"",1:value.%ConstructClone(1,.cloned)),i%namespacePermissions(key)=""
		Set key="" For  Set value=..subsetPermissions.GetNext(.key) Quit:key=""  Set r%subsetPermissions(key)=$select(value="":"",1:value.%ConstructClone(1,.cloned)),i%subsetPermissions(key)=""
	}
	Quit 1 }
%Destruct() public {
	Try {
		If $isobject($get(r%adminPermissions))=1,$zobjcnt(r%adminPermissions)>1 Do r%adminPermissions.%Disconnect()
		If $isobject($get(r%authorityPermissions))=1,$zobjcnt(r%authorityPermissions)>1 Do r%authorityPermissions.%Disconnect()
		If $isobject($get(r%namespacePermissions))=1,$zobjcnt(r%namespacePermissions)>1 Do r%namespacePermissions.%Disconnect()
		If $isobject($get(r%subsetPermissions))=1,$zobjcnt(r%subsetPermissions)>1 Do r%subsetPermissions.%Disconnect()
	} Catch { Set sc=$$Error^%apiOBJ(5002,$zerror) }
	Quit 1 }
%NormalizeObject() public {
	If '$system.CLS.GetModified() Quit 1
	If m%adminPermissions Set key="" For  Set key=$order(i%adminPermissions(key),1,data) Quit:key=""  Set:data'="" i%adminPermissions(key)=..adminPermissionsNormalize(data)
	If m%description Set:i%description'="" i%description=(..descriptionNormalize(i%description))
	If m%name Set:i%name'="" i%name=(..nameNormalize(i%name))
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
	Set key=""
	For  {
		Set key=$order(r%authorityPermissions(key),1,Poref) Quit:key=""
		If $isobject(Poref)=1 Set:'$data(%objTX(1,+Poref)) %objTX(6,$i(%objTX(6)))=Poref
	}
	Set key=""
	For  {
		Set key=$order(r%namespacePermissions(key),1,Poref) Quit:key=""
		If $isobject(Poref)=1 Set:'$data(%objTX(1,+Poref)) %objTX(6,$i(%objTX(6)))=Poref
	}
	Set key=""
	For  {
		Set key=$order(r%subsetPermissions(key),1,Poref) Quit:key=""
		If $isobject(Poref)=1 Set:'$data(%objTX(1,+Poref)) %objTX(6,$i(%objTX(6)))=Poref
	}
exit	Quit sc }
%ValidateObject(force=0) public {
	Set sc=1
	If '$system.CLS.GetModified() Quit sc
	If m%adminPermissions Set key="",rc=1 For  Set key=$order(i%adminPermissions(key),1,val) Quit:key=""  If val'="" Set rc=..adminPermissionsIsValid(val) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"adminPermissions"_"("_key_")",val)
	Set iv=..description If iv="" Set rc=$$Error^%apiOBJ(5659,$classname()_"::"_"description"_"("_$this_",ID="),sc=$select(+sc:rc,1:$$AppendStatus^%occSystem(sc,rc))
	If m%description Set rc=(..descriptionIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"description",iv)
	Set iv=..name If iv="" Set rc=$$Error^%apiOBJ(5659,$classname()_"::"_"name"_"("_$this_",ID="),sc=$select(+sc:rc,1:$$AppendStatus^%occSystem(sc,rc))
	If m%name Set rc=(..nameIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"name",iv)
	Quit sc }
zXMLDTD(top,format,input,dtdlist)
 Quit ##class(%XML.Implementation).XMLDTD("BSTS.ns1.TUserRole",.top,.format,.input,.dtdlist)
zXMLExportInternal()
 New tag,summary,attrsVal,savelocal,aval,k,tmpPrefix,prefixDepth,hasNoContent,hasElement,topAttrs,beginprefix,endprefix,savexsiAttrs,initialxsiAttrs,initlist,initialCR,inlineFlag,popAtEnd,saveTopPrefix,saveTypesPrefix,saveAttrsPrefix,saveUsePrefix,initlist
 Set $ztrap="XMLExportInternalTrap",popAtEnd=0
 Set summary=summaryArg,initialxsiAttrs=xsiAttrs
 If group Quit $$Error^%apiOBJ(6386,"BSTS.ns1.TUserRole")
 If indentFlag Set initialCR=($extract(currentIndent,1,2)=$c(13,10))
 Set id=createId
 Set temp=""
 If id'="" {
   If $piece($get(idlist(+$this)),",",2)'="" Quit 1
   Set idlist(+$this)=id_",1"
 }
 If encoded Set initlist=$lb($get(oreflist),inlineFlagArg),oreflist=1,inlineFlag=inlineFlagArg
 If 'nocycle,('encoded||inlineFlag) {
   If $data(oreflist($this)) Quit $$Error^%apiOBJ(6296,"BSTS.ns1.TUserRole")
   Set oreflist($this)=""
 }
 Set tag=$get(topArg)
 Set tmpi=(($get(typeAttr)'="")&&(typeAttr'="BSTS.ns1.TUserRole"))
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
   If tag="" Set tag="TUserRole"
   Set xsitype=namespaces.OutputTypeAttribute
 } Else {
   Set saveTopPrefix=topPrefix,saveTypesPrefix=typesPrefix,saveAttrsPrefix=attrsPrefix,saveUsePrefix=usePrefix
   Set typesPrefix=namespaces If (typesPrefix'=""),($extract(typesPrefix,*)'=":") Set typesPrefix=typesPrefix_":"
   If 'encoded Set namespaces=""
   Set (topPrefix,attrsPrefix,topAttrs,beginprefix)=""
   If tag="" Set tag=typesPrefix_"TUserRole"
   Set xsitype=0
 }
 Set local=+$get(local),savelocal=local
 Set endprefix="</"_beginprefix,beginprefix="<"_beginprefix
 If tmpi Set temp=temp_" "_xsiPrefix_"type="""_typesPrefix_"TUserRole"""_xsiAttrs,xsiAttrs=""
   If id'="" Set temp=" "_$select($get(soap12):soapPrefix_"id",1:"id")_"=""id"_id_""""_temp
 If encoded Set temp=temp_xsiAttrs,xsiAttrs=""
 If indentFlag Set %xmlmsg=currentIndent if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg } Set currentIndent=$select(initialCR:"",1:$c(13,10))_currentIndent_indentChars
 If tag[":" Set topPrefix=$piece(tag,":"),tag=$piece(tag,":",2)  If topPrefix'="" Set topPrefix=topPrefix_":"
 Set %xmlmsg="<"_topPrefix_tag_temp if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set attrsVal=attrsArg,attrsArg="" Set %xmlmsg=attrsVal if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set %xmlmsg=">" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..name
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"name"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"string""",1:"")_">"_$select(val=$c(0):"",1:$select((val["<")||(val[">")||(val["&"):"<![CDATA["_$replace(val,"]]>","]]]]><![CDATA[>")_"]]>",1:val))_endprefix_"name>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..description
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"description"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"string""",1:"")_">"_$select(val=$c(0):"",1:$select((val["<")||(val[">")||(val["&"):"<![CDATA["_$replace(val,"]]>","]]]]><![CDATA[>")_"]]>",1:val))_endprefix_"description>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set aval=..adminPermissions
 Set k="" Set val=aval.GetNext(.k) If k'="" {
   If encoded {
     If indentFlag Set %xmlmsg=currentIndent Set currentIndent=currentIndent_indentChars if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     Set temp="",temp1=$parameter("BSTS.ns1.TAdminPermission","NAMESPACE")
     Set temp1=$select((temp1'="http://apelon.com/dtsserver/types")&&$IsObject(namespaces):namespaces.GetNamespacePrefix(temp1,.temp),1:typesPrefix)
     If soap12 { Set %xmlmsg=beginprefix_"adminPermissions"_$select(xsitype:"",1:" "_soapPrefix_"itemType="""_temp1_"TAdminPermission""")_" "_soapPrefix_"arraySize="""_aval.Count()_""""_""_temp_">" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     } Else { Set %xmlmsg=beginprefix_"adminPermissions "_$select(xsitype:xsiPrefix_"type="""_soapPrefix_"Array""",1:soapPrefix_"arrayType="""_temp1_"TAdminPermission["_aval.Count()_"]""")_""_temp_">" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg } }
   }
   While k'="" {
     If val'="" {
       Set temp="",temp1=$parameter("BSTS.ns1.TAdminPermission","NAMESPACE")
       Set temp1=$select((temp1'="http://apelon.com/dtsserver/types")&&$IsObject(namespaces):namespaces.GetNamespacePrefix(temp1,.temp),1:typesPrefix)
       Set %xmlmsg=currentIndent_beginprefix_"adminPermissions"_$select(xsitype:" "_xsiPrefix_"type="""_temp1_"TAdminPermission"""_temp,1:"")_">"_$select(val=$c(0):"",1:$select((val["<")||(val[">")||(val["&"):"<![CDATA["_$replace(val,"]]>","]]]]><![CDATA[>")_"]]>",1:val))_endprefix_"adminPermissions>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     } Else {
         Set %xmlmsg=currentIndent_beginprefix_"adminPermissions "_xsiPrefix_"nil=""true"""_xsiAttrs_"/>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     }
     Set val=aval.GetNext(.k)
   }
   If encoded {
     If indentFlag Set currentIndent=$extract(currentIndent,1,*-$length(indentChars)) Set %xmlmsg=currentIndent if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     Set %xmlmsg=endprefix_"adminPermissions>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
   }
 }
 Set aval=..namespacePermissions
 Set k="" Set:deepFlag val=aval.GetNext(.k) If k'="" {
   If encoded {
     If indentFlag Set %xmlmsg=currentIndent Set currentIndent=currentIndent_indentChars if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     Set temp="",temp1=$parameter("BSTS.ns1.TNamespacePermissionItem","NAMESPACE")
     Set temp1=$select((temp1'="http://apelon.com/dtsserver/types")&&$IsObject(namespaces):namespaces.GetNamespacePrefix(temp1,.temp),1:typesPrefix)
     If soap12 { Set %xmlmsg=beginprefix_"namespacePermissions"_$select(xsitype:"",1:" "_soapPrefix_"itemType="""_temp1_$select($parameter("BSTS.ns1.TNamespacePermissionItem","XMLSUMMARY")'="":"s_TNamespacePermissionItem",1:"TNamespacePermissionItem")_"""")_" "_soapPrefix_"arraySize="""_aval.Count()_""""_""_temp_">" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     } Else { Set %xmlmsg=beginprefix_"namespacePermissions "_$select(xsitype:xsiPrefix_"type="""_soapPrefix_"Array""",1:soapPrefix_"arrayType="""_temp1_$select($parameter("BSTS.ns1.TNamespacePermissionItem","XMLSUMMARY")'="":"s_TNamespacePermissionItem",1:"TNamespacePermissionItem")_"["_aval.Count()_"]""")_""_temp_">" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg } }
   }
   While k'="" {
     If $IsObject(val) {
       Set id=""
       If encoded,'inlineFlag {
         Set temp=$select($parameter("BSTS.ns1.TNamespacePermissionItem","XMLSUMMARY")'="":-1,1:1)
         Set id=+$get(idlist(temp*val))
         If 'soap12 , (id=0) Set id=$increment(idlist),oreflist(temp*id)=val,idlist(temp*val)=id
       }
       If +id'=0 {
         Set %xmlmsg=currentIndent_beginprefix_"namespacePermissions "_$select(soap12:soapPrefix_"ref=""",1:"href=""#")_"id"_id_""" />" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
       } Else { if id=0 Set id=$increment(idlist)
         Set topArg="namespacePermissions",summaryArg=1,group=0,createId=$get(id),typeAttr=$select(encoded||xsitype:"*",1:"BSTS.ns1.TNamespacePermissionItem"),local=1,savexsiAttrs=xsiAttrs
         Set sc=val.XMLExportInternal() Goto:'sc XMLExportExit Set xsiAttrs=savexsiAttrs
       }
     } Else {
       Set %xmlmsg=currentIndent_beginprefix_"namespacePermissions "_xsiPrefix_"nil=""true"""_xsiAttrs_"/>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     }
     Set val=aval.GetNext(.k)
   }
   If encoded {
     If indentFlag Set currentIndent=$extract(currentIndent,1,*-$length(indentChars)) Set %xmlmsg=currentIndent if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     Set %xmlmsg=endprefix_"namespacePermissions>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
   }
 }
 Set aval=..subsetPermissions
 Set k="" Set:deepFlag val=aval.GetNext(.k) If k'="" {
   If encoded {
     If indentFlag Set %xmlmsg=currentIndent Set currentIndent=currentIndent_indentChars if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     Set temp="",temp1=$parameter("BSTS.ns1.TSubsetPermissionItem","NAMESPACE")
     Set temp1=$select((temp1'="http://apelon.com/dtsserver/types")&&$IsObject(namespaces):namespaces.GetNamespacePrefix(temp1,.temp),1:typesPrefix)
     If soap12 { Set %xmlmsg=beginprefix_"subsetPermissions"_$select(xsitype:"",1:" "_soapPrefix_"itemType="""_temp1_$select($parameter("BSTS.ns1.TSubsetPermissionItem","XMLSUMMARY")'="":"s_TSubsetPermissionItem",1:"TSubsetPermissionItem")_"""")_" "_soapPrefix_"arraySize="""_aval.Count()_""""_""_temp_">" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     } Else { Set %xmlmsg=beginprefix_"subsetPermissions "_$select(xsitype:xsiPrefix_"type="""_soapPrefix_"Array""",1:soapPrefix_"arrayType="""_temp1_$select($parameter("BSTS.ns1.TSubsetPermissionItem","XMLSUMMARY")'="":"s_TSubsetPermissionItem",1:"TSubsetPermissionItem")_"["_aval.Count()_"]""")_""_temp_">" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg } }
   }
   While k'="" {
     If $IsObject(val) {
       Set id=""
       If encoded,'inlineFlag {
         Set temp=$select($parameter("BSTS.ns1.TSubsetPermissionItem","XMLSUMMARY")'="":-1,1:1)
         Set id=+$get(idlist(temp*val))
         If 'soap12 , (id=0) Set id=$increment(idlist),oreflist(temp*id)=val,idlist(temp*val)=id
       }
       If +id'=0 {
         Set %xmlmsg=currentIndent_beginprefix_"subsetPermissions "_$select(soap12:soapPrefix_"ref=""",1:"href=""#")_"id"_id_""" />" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
       } Else { if id=0 Set id=$increment(idlist)
         Set topArg="subsetPermissions",summaryArg=1,group=0,createId=$get(id),typeAttr=$select(encoded||xsitype:"*",1:"BSTS.ns1.TSubsetPermissionItem"),local=1,savexsiAttrs=xsiAttrs
         Set sc=val.XMLExportInternal() Goto:'sc XMLExportExit Set xsiAttrs=savexsiAttrs
       }
     } Else {
       Set %xmlmsg=currentIndent_beginprefix_"subsetPermissions "_xsiPrefix_"nil=""true"""_xsiAttrs_"/>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     }
     Set val=aval.GetNext(.k)
   }
   If encoded {
     If indentFlag Set currentIndent=$extract(currentIndent,1,*-$length(indentChars)) Set %xmlmsg=currentIndent if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     Set %xmlmsg=endprefix_"subsetPermissions>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
   }
 }
 Set aval=..authorityPermissions
 Set k="" Set:deepFlag val=aval.GetNext(.k) If k'="" {
   If encoded {
     If indentFlag Set %xmlmsg=currentIndent Set currentIndent=currentIndent_indentChars if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     Set temp="",temp1=$parameter("BSTS.ns1.TAuthorityPermissionItem","NAMESPACE")
     Set temp1=$select((temp1'="http://apelon.com/dtsserver/types")&&$IsObject(namespaces):namespaces.GetNamespacePrefix(temp1,.temp),1:typesPrefix)
     If soap12 { Set %xmlmsg=beginprefix_"authorityPermissions"_$select(xsitype:"",1:" "_soapPrefix_"itemType="""_temp1_$select($parameter("BSTS.ns1.TAuthorityPermissionItem","XMLSUMMARY")'="":"s_TAuthorityPermissionItem",1:"TAuthorityPermissionItem")_"""")_" "_soapPrefix_"arraySize="""_aval.Count()_""""_""_temp_">" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     } Else { Set %xmlmsg=beginprefix_"authorityPermissions "_$select(xsitype:xsiPrefix_"type="""_soapPrefix_"Array""",1:soapPrefix_"arrayType="""_temp1_$select($parameter("BSTS.ns1.TAuthorityPermissionItem","XMLSUMMARY")'="":"s_TAuthorityPermissionItem",1:"TAuthorityPermissionItem")_"["_aval.Count()_"]""")_""_temp_">" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg } }
   }
   While k'="" {
     If $IsObject(val) {
       Set id=""
       If encoded,'inlineFlag {
         Set temp=$select($parameter("BSTS.ns1.TAuthorityPermissionItem","XMLSUMMARY")'="":-1,1:1)
         Set id=+$get(idlist(temp*val))
         If 'soap12 , (id=0) Set id=$increment(idlist),oreflist(temp*id)=val,idlist(temp*val)=id
       }
       If +id'=0 {
         Set %xmlmsg=currentIndent_beginprefix_"authorityPermissions "_$select(soap12:soapPrefix_"ref=""",1:"href=""#")_"id"_id_""" />" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
       } Else { if id=0 Set id=$increment(idlist)
         Set topArg="authorityPermissions",summaryArg=1,group=0,createId=$get(id),typeAttr=$select(encoded||xsitype:"*",1:"BSTS.ns1.TAuthorityPermissionItem"),local=1,savexsiAttrs=xsiAttrs
         Set sc=val.XMLExportInternal() Goto:'sc XMLExportExit Set xsiAttrs=savexsiAttrs
       }
     } Else {
       Set %xmlmsg=currentIndent_beginprefix_"authorityPermissions "_xsiPrefix_"nil=""true"""_xsiAttrs_"/>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     }
     Set val=aval.GetNext(.k)
   }
   If encoded {
     If indentFlag Set currentIndent=$extract(currentIndent,1,*-$length(indentChars)) Set %xmlmsg=currentIndent if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     Set %xmlmsg=endprefix_"authorityPermissions>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
   }
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
     If $classname(val)="BSTS.ns1.TUserRole" {
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
 Quit ##class(%XML.Implementation).XMLGetSchemaImports("BSTS.ns1.TUserRole",.imports,.classes)
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
 If bareProjection Quit $$Error^%apiOBJ(6386,"BSTS.ns1.TUserRole")
 If encoded {
   If $data(@(tree)@(node,"a","id")) Set idlist(node)=$this
 }
 If +$listget($get(@(tree)@(node,0)),7,0) Quit 1
 Set sc=$$XMLImportElements()
XMLImportExit Quit sc
XMLImportElements() ;
 Set child=""
 If $$XMLLOOP()'=0 Quit sc
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
 For  { Set encodedArray=encoded
 If tag="adminPermissions" {
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
           If +$listget($get(@(tree)@(ref,0)),7,0) { Set data=""
           } Else {
                   Set data=$order(@(tree)@(ref,"c",""))
                   If $order(@(tree)@(ref,"c",data))'="" {
                     Set data="" If '##class(%XML.ImportHandler).SerializeNode(tree,ref,0,0,.data) Goto XMLImportErr
                   } ElseIf data'="" { Goto:$listget($get(@(tree)@(data,0)),1)="e" XMLImportErr Set data=@(tree)@(data) }
                   If data="" Set data=$c(0)
                   If data'="" Goto:('$s(data'[","&&(",NA,SA,AA,"[(","_$select(data=$c(0):"",1:data)_",")):1,1:$$Error^%apiOBJ(7205,data,",NA,SA,AA"))) XMLImportErr
           }
           If ($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
         }
         Do ..adminPermissions.Insert(data)
         }
         Set element=$order(@(tree)@(loopref,"c",element))
       }
       Quit:('sc)  Set ref=loopref
     } Else { Set encodedArray=0
         If $listget($get(@(tree)@(ref,0)),1)'="e" Goto XMLImportMalformedNoTag
         If 'encoded,(@(tree)@(ref)'="adminPermissions") Goto XMLImportBadTag
         If '$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
         If encoded,$$XMLImportId() {
           Set data=idlist(ref)
         } Else {
           If 'sc Goto XMLImportExit
           If +$listget($get(@(tree)@(ref,0)),7,0) { Set data=""
           } Else {
                   Set data=$order(@(tree)@(ref,"c",""))
                   If $order(@(tree)@(ref,"c",data))'="" {
                     Set data="" If '##class(%XML.ImportHandler).SerializeNode(tree,ref,0,0,.data) Goto XMLImportErr
                   } ElseIf data'="" { Goto:$listget($get(@(tree)@(data,0)),1)="e" XMLImportErr Set data=@(tree)@(data) }
                   If data="" Set data=$c(0)
                   If data'="" Goto:('$s(data'[","&&(",NA,SA,AA,"[(","_$select(data=$c(0):"",1:data)_",")):1,1:$$Error^%apiOBJ(7205,data,",NA,SA,AA"))) XMLImportErr
           }
           If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
         }
         Do ..adminPermissions.Insert(data)
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 Else { Quit  }
 If encodedArray Quit
 }
 For  { Set encodedArray=encoded
 If tag="namespacePermissions" {
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
           If (class="") || (class="TNamespacePermissionItem") {
             Set class="BSTS.ns1.TNamespacePermissionItem"
           } Else {
             If $length(class,":")=2 Set class=$piece(class,":",2)
             Set class=$get(^oddCOM("BSTS.ns1.TNamespacePermissionItem",85,"s",class))_$get(^oddXML("BSTS.ns1.TNamespacePermissionItem","s",class)) If class="" Set class=0
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
         If data'="" Do ..namespacePermissions.Insert(data)
         }
         Set element=$order(@(tree)@(loopref,"c",element))
       }
       Quit:('sc)  Set ref=loopref
     } Else { Set encodedArray=0
         If $listget($get(@(tree)@(ref,0)),1)'="e" Goto XMLImportMalformedNoTag
         If 'encoded,(@(tree)@(ref)'="namespacePermissions") Goto XMLImportBadTag
         If '$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
         If encoded,$$XMLImportId() {
           Set data=idlist(ref)
         } Else {
           If 'sc Goto XMLImportExit
           Set class=$select(($get(@(tree)@(ref,"a","type","u"))=1):$get(@(tree)@(ref,"a","type")),1:"")
           If (class="") || (class="TNamespacePermissionItem") {
             Set class="BSTS.ns1.TNamespacePermissionItem"
           } Else {
             If $length(class,":")=2 Set class=$piece(class,":",2)
             Set class=$get(^oddCOM("BSTS.ns1.TNamespacePermissionItem",85,"s",class))_$get(^oddXML("BSTS.ns1.TNamespacePermissionItem","s",class)) If class="" Set class=0
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
         If data'="" Do ..namespacePermissions.Insert(data)
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 Else { Quit  }
 If encodedArray Quit
 }
 For  { Set encodedArray=encoded
 If tag="subsetPermissions" {
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
           If (class="") || (class="TSubsetPermissionItem") {
             Set class="BSTS.ns1.TSubsetPermissionItem"
           } Else {
             If $length(class,":")=2 Set class=$piece(class,":",2)
             Set class=$get(^oddCOM("BSTS.ns1.TSubsetPermissionItem",85,"s",class))_$get(^oddXML("BSTS.ns1.TSubsetPermissionItem","s",class)) If class="" Set class=0
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
         If data'="" Do ..subsetPermissions.Insert(data)
         }
         Set element=$order(@(tree)@(loopref,"c",element))
       }
       Quit:('sc)  Set ref=loopref
     } Else { Set encodedArray=0
         If $listget($get(@(tree)@(ref,0)),1)'="e" Goto XMLImportMalformedNoTag
         If 'encoded,(@(tree)@(ref)'="subsetPermissions") Goto XMLImportBadTag
         If '$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
         If encoded,$$XMLImportId() {
           Set data=idlist(ref)
         } Else {
           If 'sc Goto XMLImportExit
           Set class=$select(($get(@(tree)@(ref,"a","type","u"))=1):$get(@(tree)@(ref,"a","type")),1:"")
           If (class="") || (class="TSubsetPermissionItem") {
             Set class="BSTS.ns1.TSubsetPermissionItem"
           } Else {
             If $length(class,":")=2 Set class=$piece(class,":",2)
             Set class=$get(^oddCOM("BSTS.ns1.TSubsetPermissionItem",85,"s",class))_$get(^oddXML("BSTS.ns1.TSubsetPermissionItem","s",class)) If class="" Set class=0
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
         If data'="" Do ..subsetPermissions.Insert(data)
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 Else { Quit  }
 If encodedArray Quit
 }
 For  { Set encodedArray=encoded
 If tag="authorityPermissions" {
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
           If (class="") || (class="TAuthorityPermissionItem") {
             Set class="BSTS.ns1.TAuthorityPermissionItem"
           } Else {
             If $length(class,":")=2 Set class=$piece(class,":",2)
             Set class=$get(^oddCOM("BSTS.ns1.TAuthorityPermissionItem",85,"s",class))_$get(^oddXML("BSTS.ns1.TAuthorityPermissionItem","s",class)) If class="" Set class=0
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
         If data'="" Do ..authorityPermissions.Insert(data)
         }
         Set element=$order(@(tree)@(loopref,"c",element))
       }
       Quit:('sc)  Set ref=loopref
     } Else { Set encodedArray=0
         If $listget($get(@(tree)@(ref,0)),1)'="e" Goto XMLImportMalformedNoTag
         If 'encoded,(@(tree)@(ref)'="authorityPermissions") Goto XMLImportBadTag
         If '$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
         If encoded,$$XMLImportId() {
           Set data=idlist(ref)
         } Else {
           If 'sc Goto XMLImportExit
           Set class=$select(($get(@(tree)@(ref,"a","type","u"))=1):$get(@(tree)@(ref,"a","type")),1:"")
           If (class="") || (class="TAuthorityPermissionItem") {
             Set class="BSTS.ns1.TAuthorityPermissionItem"
           } Else {
             If $length(class,":")=2 Set class=$piece(class,":",2)
             Set class=$get(^oddCOM("BSTS.ns1.TAuthorityPermissionItem",85,"s",class))_$get(^oddXML("BSTS.ns1.TAuthorityPermissionItem","s",class)) If class="" Set class=0
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
         If data'="" Do ..authorityPermissions.Insert(data)
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 Else { Quit  }
 If encodedArray Quit
 }
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
 If ..name'="" Quit 0
 If ..description'="" Quit 0
 If ..adminPermissions.Count()>0 Quit 0
 If ..namespacePermissions.Count()>0 Quit 0
 If ..subsetPermissions.Count()>0 Quit 0
 If ..authorityPermissions.Count()>0 Quit 0
 Quit 1
zXMLNew(document,node,containerOref="")
	Quit (##class(BSTS.ns1.TUserRole).%New())
zXMLSchema(top="",format="",namespacePrefix="",input=0,refOnly=0,schema)
 Quit ##class(%XML.Implementation).XMLSchema("BSTS.ns1.TUserRole",top,format,namespacePrefix,input,refOnly,.schema)
zadminPermissionsBuildValueArra(value,array) public {
	Quit ##class(%Collection.ListOfDT).BuildValueArray(value,.array)
}
zadminPermissionsCollectionToDi(val="",delim) public { Set:'($data(delim)#2) delim=$char(13,10)
	set odbc="",tDelimLen=$l(delim)
	for i=1:1:$listlength(val) {
		set item=##class(BSTS.ns1.TUserRole).adminPermissionsLogicalToDisplay($listget(val,i))
		if item'["""",item'[delim,$length($zstrip(item,"<>W"))=$length(item) set odbc=odbc_delim_item continue
		for j=$length(item,""""):-1:2 set $piece(item,"""",j)=""""_$piece(item,"""",j)
		set odbc=odbc_delim_""""_item_""""
	}
	quit $extract(odbc,tDelimLen+1,*) }
zadminPermissionsCollectionToOd(val="") public {
	set odbc=""
	for i=1:1:$listlength(val) {
		set item=##class(BSTS.ns1.TUserRole).adminPermissionsLogicalToOdbc($listget(val,i))
		if item'["""",item'[",",$length($zstrip(item,"<>W"))=$length(item) set odbc=odbc_","_item continue
		for j=$length(item,""""):-1:2 set $piece(item,"""",j)=""""_$piece(item,"""",j)
		set odbc=odbc_","""_item_""""
	}
	quit $extract(odbc,2,*) }
zadminPermissionsDisplayToColle(val="",delim) public { Set:'($data(delim)#2) delim=$char(13,10)
	set logical="",out="",tDelimLen=$l(delim)
hloop	if $extract(val,1,tDelimLen)=delim { goto hdel } if val="" { goto hexit } if $extract(val)="""" { goto hquote } goto hdefault
hdefault	set stuff=$piece(val,delim),out=out_stuff,val=$extract(val,$length(stuff)+1,*) goto hloop
hquote	set stuff=$find(val,"""",2) if stuff=0 set stuff=$length(val)+10
	set out=out_$select(stuff=3:"""",1:$extract(val,2,stuff-2)),val=$extract(val,stuff,*)
	if $extract(val)="""" { set out=out_"""" goto hquote } else { goto hdefault }
hdel	set logical=logical_$listbuild(out),out="",val=$extract(val,tDelimLen+1,*) goto hloop
hexit	set logical=logical_$listbuild(out)
	for stuff=1:1:$Listlength(logical) { set $List(logical,stuff) = ##class(BSTS.ns1.TUserRole).adminPermissionsDisplayToLogical($List(logical,stuff)) }
	quit logical }
zadminPermissionsGetObject(force=0) public {
	Quit $select(r%adminPermissions="":$select(i%adminPermissions="":"",1:$listbuild(i%adminPermissions_"")),(''..adminPermissions.%GetSwizzleObject(force,.oid)):oid,1:"") }
zadminPermissionsGetObjectId(force=0) public {
	Quit $listget(..adminPermissionsGetObject(force)) }
zadminPermissionsGetSwizzled() public {
	Set oref=##class(%Collection.ListOfDT).%New() If oref="" Quit ""
	Set modstate=$system.CLS.GetModifiedBits() Set r%adminPermissions=oref Do $system.CLS.SetModifiedBits(modstate)
	Set oref.ElementType="BSTS.ns1.TUserRole:adminPermissions",oref.ElementClassType="datatype",oref.Owner=+$this,oref.Storage=$this."adminPermissions%i"(),oref.OrefStorage=oref.Storage+1
	Do $system.CLS.SetModified(oref,0)
	Quit oref }
zadminPermissionsIsValid(%val) public {
	Q $s(%val'[","&&(",NA,SA,AA,"[(","_$select(%val=$c(0):"",1:%val)_",")):1,1:$$Error^%apiOBJ(7205,%val,",NA,SA,AA")) }
zadminPermissionsOdbcToCollecti(val="") public {
	set logical="",out=""
hloop	if $extract(val)="," { goto hdel } if val="" { goto hexit } if $extract(val)="""" { goto hquote } goto hdefault
hdefault	set stuff=$piece(val,","),out=out_stuff,val=$extract(val,$length(stuff)+1,*) goto hloop
hquote	set stuff=$find(val,"""",2) if stuff=0 set stuff=$length(val)+10
	set out=out_$select(stuff=3:"""",1:$extract(val,2,stuff-2)),val=$extract(val,stuff,*)
	if $extract(val)="""" { set out=out_"""" goto hquote } else { goto hdefault }
hdel	set logical=logical_$listbuild(out),out="",val=$extract(val,2,*) goto hloop
hexit	set logical=logical_$listbuild(out)
	quit logical }
zadminPermissionsSet(newvalue) public {
	If '$isobject(newvalue),newvalue'="" Quit $$Error^%apiOBJ(5807,newvalue)
	If r%adminPermissions=newvalue Quit 1
	If newvalue="" Kill i%adminPermissions,r%adminPermissions Set i%adminPermissions="",r%adminPermissions="" Quit 1
	Set oref=r%adminPermissions Kill i%adminPermissions,r%adminPermissions Set i%adminPermissions="",r%adminPermissions=oref
	Set key="" For i=1:1 Set value=newvalue.GetNext(.key) Quit:key=""  Set i%adminPermissions(i)=value
	Quit 1 }
zauthorityPermissionsBuildValue(value,array) public {
	Quit ##class(%Collection.ListOfObj).BuildValueArray(value,.array)
}
zauthorityPermissionsCollection(val="",delim) public { Set:'($data(delim)#2) delim=$char(13,10)
	set odbc="",tDelimLen=$l(delim)
	for i=1:1:$listlength(val) {
		set item=$Listget(val,i)
		if item'["""",item'[delim,$length($zstrip(item,"<>W"))=$length(item) set odbc=odbc_delim_item continue
		for j=$length(item,""""):-1:2 set $piece(item,"""",j)=""""_$piece(item,"""",j)
		set odbc=odbc_delim_""""_item_""""
	}
	quit $extract(odbc,tDelimLen+1,*) }
zauthorityPermissionsCollectio2(val="") public {
	set odbc=""
	for i=1:1:$listlength(val) {
		set item=$listget(val,i)
		if item'["""",item'[",",$length($zstrip(item,"<>W"))=$length(item) set odbc=odbc_","_item continue
		for j=$length(item,""""):-1:2 set $piece(item,"""",j)=""""_$piece(item,"""",j)
		set odbc=odbc_","""_item_""""
	}
	quit $extract(odbc,2,*) }
zauthorityPermissionsDisplayToC(val="",delim) public { Set:'($data(delim)#2) delim=$char(13,10)
	set logical="",out="",tDelimLen=$l(delim)
hloop	if $extract(val,1,tDelimLen)=delim { goto hdel } if val="" { goto hexit } if $extract(val)="""" { goto hquote } goto hdefault
hdefault	set stuff=$piece(val,delim),out=out_stuff,val=$extract(val,$length(stuff)+1,*) goto hloop
hquote	set stuff=$find(val,"""",2) if stuff=0 set stuff=$length(val)+10
	set out=out_$select(stuff=3:"""",1:$extract(val,2,stuff-2)),val=$extract(val,stuff,*)
	if $extract(val)="""" { set out=out_"""" goto hquote } else { goto hdefault }
hdel	set logical=logical_$listbuild(out),out="",val=$extract(val,tDelimLen+1,*) goto hloop
hexit	set logical=logical_$listbuild(out)
	quit logical }
zauthorityPermissionsGetObject(force=0) public {
	Quit $select(r%authorityPermissions="":$select(i%authorityPermissions="":"",1:$listbuild(i%authorityPermissions_"")),(''..authorityPermissions.%GetSwizzleObject(force,.oid)):oid,1:"") }
zauthorityPermissionsGetObjectI(force=0) public {
	Quit $listget(..authorityPermissionsGetObject(force)) }
zauthorityPermissionsGetSwizzle() public {
	Set oref=##class(%Collection.ListOfObj).%New() If oref="" Quit ""
	Set modstate=$system.CLS.GetModifiedBits() Set r%authorityPermissions=oref Do $system.CLS.SetModifiedBits(modstate)
	Set oref.ElementType="BSTS.ns1.TAuthorityPermissionItem",oref.ElementClassType="",oref.Owner=+$this,oref.Storage=$this."authorityPermissions%i"(),oref.OrefStorage=oref.Storage+1
	Do $system.CLS.SetModified(oref,0)
	Quit oref }
zauthorityPermissionsOdbcToColl(val="") public {
	set logical="",out=""
hloop	if $extract(val)="," { goto hdel } if val="" { goto hexit } if $extract(val)="""" { goto hquote } goto hdefault
hdefault	set stuff=$piece(val,","),out=out_stuff,val=$extract(val,$length(stuff)+1,*) goto hloop
hquote	set stuff=$find(val,"""",2) if stuff=0 set stuff=$length(val)+10
	set out=out_$select(stuff=3:"""",1:$extract(val,2,stuff-2)),val=$extract(val,stuff,*)
	if $extract(val)="""" { set out=out_"""" goto hquote } else { goto hdefault }
hdel	set logical=logical_$listbuild(out),out="",val=$extract(val,2,*) goto hloop
hexit	set logical=logical_$listbuild(out)
	quit logical }
zauthorityPermissionsSet(newvalue) public {
	If '$isobject(newvalue),newvalue'="" Quit $$Error^%apiOBJ(5807,newvalue)
	If r%authorityPermissions=newvalue Quit 1
	If newvalue="" Kill i%authorityPermissions,r%authorityPermissions Set i%authorityPermissions="",r%authorityPermissions="" Quit 1
	Set oref=r%authorityPermissions Kill i%authorityPermissions,r%authorityPermissions Set i%authorityPermissions="",r%authorityPermissions=oref
	Set key="" For i=1:1 Set value=newvalue.GetNext(.key) Quit:key=""  Set r%authorityPermissions(i)=value,i%authorityPermissions(i)=""
	Quit 1 }
znamespacePermissionsBuildValue(value,array) public {
	Quit ##class(%Collection.ListOfObj).BuildValueArray(value,.array)
}
znamespacePermissionsCollection(val="",delim) public { Set:'($data(delim)#2) delim=$char(13,10)
	set odbc="",tDelimLen=$l(delim)
	for i=1:1:$listlength(val) {
		set item=$Listget(val,i)
		if item'["""",item'[delim,$length($zstrip(item,"<>W"))=$length(item) set odbc=odbc_delim_item continue
		for j=$length(item,""""):-1:2 set $piece(item,"""",j)=""""_$piece(item,"""",j)
		set odbc=odbc_delim_""""_item_""""
	}
	quit $extract(odbc,tDelimLen+1,*) }
znamespacePermissionsCollectio2(val="") public {
	set odbc=""
	for i=1:1:$listlength(val) {
		set item=$listget(val,i)
		if item'["""",item'[",",$length($zstrip(item,"<>W"))=$length(item) set odbc=odbc_","_item continue
		for j=$length(item,""""):-1:2 set $piece(item,"""",j)=""""_$piece(item,"""",j)
		set odbc=odbc_","""_item_""""
	}
	quit $extract(odbc,2,*) }
znamespacePermissionsDisplayToC(val="",delim) public { Set:'($data(delim)#2) delim=$char(13,10)
	set logical="",out="",tDelimLen=$l(delim)
hloop	if $extract(val,1,tDelimLen)=delim { goto hdel } if val="" { goto hexit } if $extract(val)="""" { goto hquote } goto hdefault
hdefault	set stuff=$piece(val,delim),out=out_stuff,val=$extract(val,$length(stuff)+1,*) goto hloop
hquote	set stuff=$find(val,"""",2) if stuff=0 set stuff=$length(val)+10
	set out=out_$select(stuff=3:"""",1:$extract(val,2,stuff-2)),val=$extract(val,stuff,*)
	if $extract(val)="""" { set out=out_"""" goto hquote } else { goto hdefault }
hdel	set logical=logical_$listbuild(out),out="",val=$extract(val,tDelimLen+1,*) goto hloop
hexit	set logical=logical_$listbuild(out)
	quit logical }
znamespacePermissionsGetObject(force=0) public {
	Quit $select(r%namespacePermissions="":$select(i%namespacePermissions="":"",1:$listbuild(i%namespacePermissions_"")),(''..namespacePermissions.%GetSwizzleObject(force,.oid)):oid,1:"") }
znamespacePermissionsGetObjectI(force=0) public {
	Quit $listget(..namespacePermissionsGetObject(force)) }
znamespacePermissionsGetSwizzle() public {
	Set oref=##class(%Collection.ListOfObj).%New() If oref="" Quit ""
	Set modstate=$system.CLS.GetModifiedBits() Set r%namespacePermissions=oref Do $system.CLS.SetModifiedBits(modstate)
	Set oref.ElementType="BSTS.ns1.TNamespacePermissionItem",oref.ElementClassType="",oref.Owner=+$this,oref.Storage=$this."namespacePermissions%i"(),oref.OrefStorage=oref.Storage+1
	Do $system.CLS.SetModified(oref,0)
	Quit oref }
znamespacePermissionsOdbcToColl(val="") public {
	set logical="",out=""
hloop	if $extract(val)="," { goto hdel } if val="" { goto hexit } if $extract(val)="""" { goto hquote } goto hdefault
hdefault	set stuff=$piece(val,","),out=out_stuff,val=$extract(val,$length(stuff)+1,*) goto hloop
hquote	set stuff=$find(val,"""",2) if stuff=0 set stuff=$length(val)+10
	set out=out_$select(stuff=3:"""",1:$extract(val,2,stuff-2)),val=$extract(val,stuff,*)
	if $extract(val)="""" { set out=out_"""" goto hquote } else { goto hdefault }
hdel	set logical=logical_$listbuild(out),out="",val=$extract(val,2,*) goto hloop
hexit	set logical=logical_$listbuild(out)
	quit logical }
znamespacePermissionsSet(newvalue) public {
	If '$isobject(newvalue),newvalue'="" Quit $$Error^%apiOBJ(5807,newvalue)
	If r%namespacePermissions=newvalue Quit 1
	If newvalue="" Kill i%namespacePermissions,r%namespacePermissions Set i%namespacePermissions="",r%namespacePermissions="" Quit 1
	Set oref=r%namespacePermissions Kill i%namespacePermissions,r%namespacePermissions Set i%namespacePermissions="",r%namespacePermissions=oref
	Set key="" For i=1:1 Set value=newvalue.GetNext(.key) Quit:key=""  Set r%namespacePermissions(i)=value,i%namespacePermissions(i)=""
	Quit 1 }
zsubsetPermissionsBuildValueArr(value,array) public {
	Quit ##class(%Collection.ListOfObj).BuildValueArray(value,.array)
}
zsubsetPermissionsCollectionToD(val="",delim) public { Set:'($data(delim)#2) delim=$char(13,10)
	set odbc="",tDelimLen=$l(delim)
	for i=1:1:$listlength(val) {
		set item=$Listget(val,i)
		if item'["""",item'[delim,$length($zstrip(item,"<>W"))=$length(item) set odbc=odbc_delim_item continue
		for j=$length(item,""""):-1:2 set $piece(item,"""",j)=""""_$piece(item,"""",j)
		set odbc=odbc_delim_""""_item_""""
	}
	quit $extract(odbc,tDelimLen+1,*) }
zsubsetPermissionsCollectionToO(val="") public {
	set odbc=""
	for i=1:1:$listlength(val) {
		set item=$listget(val,i)
		if item'["""",item'[",",$length($zstrip(item,"<>W"))=$length(item) set odbc=odbc_","_item continue
		for j=$length(item,""""):-1:2 set $piece(item,"""",j)=""""_$piece(item,"""",j)
		set odbc=odbc_","""_item_""""
	}
	quit $extract(odbc,2,*) }
zsubsetPermissionsDisplayToColl(val="",delim) public { Set:'($data(delim)#2) delim=$char(13,10)
	set logical="",out="",tDelimLen=$l(delim)
hloop	if $extract(val,1,tDelimLen)=delim { goto hdel } if val="" { goto hexit } if $extract(val)="""" { goto hquote } goto hdefault
hdefault	set stuff=$piece(val,delim),out=out_stuff,val=$extract(val,$length(stuff)+1,*) goto hloop
hquote	set stuff=$find(val,"""",2) if stuff=0 set stuff=$length(val)+10
	set out=out_$select(stuff=3:"""",1:$extract(val,2,stuff-2)),val=$extract(val,stuff,*)
	if $extract(val)="""" { set out=out_"""" goto hquote } else { goto hdefault }
hdel	set logical=logical_$listbuild(out),out="",val=$extract(val,tDelimLen+1,*) goto hloop
hexit	set logical=logical_$listbuild(out)
	quit logical }
zsubsetPermissionsGetObject(force=0) public {
	Quit $select(r%subsetPermissions="":$select(i%subsetPermissions="":"",1:$listbuild(i%subsetPermissions_"")),(''..subsetPermissions.%GetSwizzleObject(force,.oid)):oid,1:"") }
zsubsetPermissionsGetObjectId(force=0) public {
	Quit $listget(..subsetPermissionsGetObject(force)) }
zsubsetPermissionsGetSwizzled() public {
	Set oref=##class(%Collection.ListOfObj).%New() If oref="" Quit ""
	Set modstate=$system.CLS.GetModifiedBits() Set r%subsetPermissions=oref Do $system.CLS.SetModifiedBits(modstate)
	Set oref.ElementType="BSTS.ns1.TSubsetPermissionItem",oref.ElementClassType="",oref.Owner=+$this,oref.Storage=$this."subsetPermissions%i"(),oref.OrefStorage=oref.Storage+1
	Do $system.CLS.SetModified(oref,0)
	Quit oref }
zsubsetPermissionsOdbcToCollect(val="") public {
	set logical="",out=""
hloop	if $extract(val)="," { goto hdel } if val="" { goto hexit } if $extract(val)="""" { goto hquote } goto hdefault
hdefault	set stuff=$piece(val,","),out=out_stuff,val=$extract(val,$length(stuff)+1,*) goto hloop
hquote	set stuff=$find(val,"""",2) if stuff=0 set stuff=$length(val)+10
	set out=out_$select(stuff=3:"""",1:$extract(val,2,stuff-2)),val=$extract(val,stuff,*)
	if $extract(val)="""" { set out=out_"""" goto hquote } else { goto hdefault }
hdel	set logical=logical_$listbuild(out),out="",val=$extract(val,2,*) goto hloop
hexit	set logical=logical_$listbuild(out)
	quit logical }
zsubsetPermissionsSet(newvalue) public {
	If '$isobject(newvalue),newvalue'="" Quit $$Error^%apiOBJ(5807,newvalue)
	If r%subsetPermissions=newvalue Quit 1
	If newvalue="" Kill i%subsetPermissions,r%subsetPermissions Set i%subsetPermissions="",r%subsetPermissions="" Quit 1
	Set oref=r%subsetPermissions Kill i%subsetPermissions,r%subsetPermissions Set i%subsetPermissions="",r%subsetPermissions=oref
	Set key="" For i=1:1 Set value=newvalue.GetNext(.key) Quit:key=""  Set r%subsetPermissions(i)=value,i%subsetPermissions(i)=""
	Quit 1 }
