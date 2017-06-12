 ;BSTS.ns1.TContentAttributeSetDescriptor.1
 ;(C)InterSystems, generated for class BSTS.ns1.TContentAttributeSetDescriptor.  Do NOT edit. 10/22/2016 08:53:38AM
 ;;737A7464;BSTS.ns1.TContentAttributeSetDescriptor
 ;
%BindExport(dev,Seen,RegisterOref,AllowedDepth,AllowedCapacity) public {
   i $d(Seen(+$this)) q 1
   Set Seen(+$this)=$this
   s sc = 1
 s proporef=..propertyTypes
 s proporef=..versionAttributeSetDescriptor
   d:RegisterOref InitObjVar^%SYS.BINDSRV($this)
   i dev'="" s t=$io u dev i $zobjexport($this_"",3)+$zobjexport($this."%%OID",3)+$zobjexport($this,3)!1 u t
 If AllowedDepth>0 Set AllowedDepth = AllowedDepth - 1
 If AllowedCapacity>0 Set AllowedCapacity = AllowedCapacity - 1/2
 s proporef=..propertyTypes
       i proporef'="" d
  . s idx="" i proporef'="" f  s elemoref=proporef.GetNext(.idx) q:idx=""  s sc=1 i AllowedDepth'=0,AllowedCapacity'=0 s sc=elemoref.%BindExport(dev,.Seen,RegisterOref,AllowedDepth,AllowedCapacity) q:('sc)
  q:('sc) sc
       i proporef'="",dev'="" s t=$io u dev i $zobjexport(proporef_"",3)+$zobjexport(proporef."%%OID",3)+$zobjexport(proporef,3)!1 u t
       if proporef'="",dev'="" d
       . s t=$io u dev i $zobjexport(3_"",3)!1 u t
       . s t=$io u dev i $zobjexport(proporef.Count()_"",3)!1 u t
     . for i=1:1:proporef.Count()  s t=$io u dev i $zobjexport(proporef.GetAt(i)_"",3)!1 u t
 s proporef=..versionAttributeSetDescriptor
       i proporef'="" s sc=1 i AllowedDepth'=0,AllowedCapacity'=0 s sc=proporef.%BindExport(dev,.Seen,RegisterOref,AllowedDepth,AllowedCapacity) q:('sc) sc
   Quit sc }
%ConstructCloneInit(object,deep=0,cloned,location) public {
	Set i%propertyTypes="",r%propertyTypes=""
	Set i%"%%OID"=""
	If deep>0 {
		Set key="" For  Set value=..propertyTypes.GetNext(.key) Quit:key=""  Set r%propertyTypes(key)=$select(value="":"",1:value.%ConstructClone(1,.cloned)),i%propertyTypes(key)=""
		If $isobject(..versionAttributeSetDescriptor)=1 Set r%versionAttributeSetDescriptor=r%versionAttributeSetDescriptor.%ConstructClone(1,.cloned),i%versionAttributeSetDescriptor=""
	}
	Quit 1 }
%NormalizeObject() public {
	If '$system.CLS.GetModified() Quit 1
	If m%DEFAULTLIMIT Set:i%DEFAULTLIMIT'="" i%DEFAULTLIMIT=(..DEFAULTLIMITNormalize(i%DEFAULTLIMIT))
	If m%allPropertyTypes Set:i%allPropertyTypes'="" i%allPropertyTypes=(..allPropertyTypesNormalize(i%allPropertyTypes))
	If m%attributesLimit Set:i%attributesLimit'="" i%attributesLimit=(..attributesLimitNormalize(i%attributesLimit))
	If m%name Set:i%name'="" i%name=(..nameNormalize(i%name))
	If m%snapshotDate Set:i%snapshotDate'="" i%snapshotDate=(..snapshotDateNormalize(i%snapshotDate))
	If m%versions Set:i%versions'="" i%versions=(..versionsNormalize(i%versions))
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
		Set key=$order(r%propertyTypes(key),1,Poref) Quit:key=""
		If $isobject(Poref)=1 Set:'$data(%objTX(1,+Poref)) %objTX(6,$i(%objTX(6)))=Poref
	}
	Set Poref=r%versionAttributeSetDescriptor If Poref'="",'$data(%objTX(1,+Poref)) Set %objTX(6,$i(%objTX(6)))=Poref
exit	Quit sc }
%ValidateObject(force=0) public {
	Set sc=1
	If '$system.CLS.GetModified() Quit sc
	Set iv=..DEFAULTLIMIT If iv="" Set rc=$$Error^%apiOBJ(5659,$classname()_"::"_"DEFAULTLIMIT"_"("_$this_",ID="),sc=$select(+sc:rc,1:$$AppendStatus^%occSystem(sc,rc))
	If m%DEFAULTLIMIT Set rc=(..DEFAULTLIMITIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"DEFAULTLIMIT",iv)
	Set iv=..allPropertyTypes If iv="" Set rc=$$Error^%apiOBJ(5659,$classname()_"::"_"allPropertyTypes"_"("_$this_",ID="),sc=$select(+sc:rc,1:$$AppendStatus^%occSystem(sc,rc))
	If m%allPropertyTypes Set rc=(..allPropertyTypesIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"allPropertyTypes",iv)
	Set iv=..attributesLimit If iv="" Set rc=$$Error^%apiOBJ(5659,$classname()_"::"_"attributesLimit"_"("_$this_",ID="),sc=$select(+sc:rc,1:$$AppendStatus^%occSystem(sc,rc))
	If m%attributesLimit Set rc=(..attributesLimitIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"attributesLimit",iv)
	If m%name Set iv=..name If iv'="" Set rc=(..nameIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"name",iv)
	If m%snapshotDate Set iv=..snapshotDate If iv'="" Set rc=(..snapshotDateIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"snapshotDate",iv)
	Set iv=..versions If iv="" Set rc=$$Error^%apiOBJ(5659,$classname()_"::"_"versions"_"("_$this_",ID="),sc=$select(+sc:rc,1:$$AppendStatus^%occSystem(sc,rc))
	If m%versions Set rc=(..versionsIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"versions",iv)
	Quit sc }
zXMLDTD(top,format,input,dtdlist)
 Quit ##class(%XML.Implementation).XMLDTD("BSTS.ns1.TContentAttributeSetDescriptor",.top,.format,.input,.dtdlist)
zXMLExportInternal()
 New tag,summary,attrsVal,savelocal,aval,k,tmpPrefix,prefixDepth,hasNoContent,hasElement,topAttrs,beginprefix,endprefix,savexsiAttrs,initialxsiAttrs,initlist,initialCR,inlineFlag,popAtEnd,saveTopPrefix,saveTypesPrefix,saveAttrsPrefix,saveUsePrefix,initlist
 Set $ztrap="XMLExportInternalTrap",popAtEnd=0
 Set summary=summaryArg,initialxsiAttrs=xsiAttrs
 If group Quit $$Error^%apiOBJ(6386,"BSTS.ns1.TContentAttributeSetDescriptor")
 If indentFlag Set initialCR=($extract(currentIndent,1,2)=$c(13,10))
 Set id=createId
 Set temp=""
 If id'="" {
   If $piece($get(idlist(+$this)),",",2)'="" Quit 1
   Set idlist(+$this)=id_",1"
 }
 If encoded Set initlist=$lb($get(oreflist),inlineFlagArg),oreflist=1,inlineFlag=inlineFlagArg
 If 'nocycle,('encoded||inlineFlag) {
   If $data(oreflist($this)) Quit $$Error^%apiOBJ(6296,"BSTS.ns1.TContentAttributeSetDescriptor")
   Set oreflist($this)=""
 }
 Set tag=$get(topArg)
 Set tmpi=(($get(typeAttr)'="")&&(typeAttr'="BSTS.ns1.TContentAttributeSetDescriptor"))
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
   If tag="" Set tag="TContentAttributeSetDescriptor"
   Set xsitype=namespaces.OutputTypeAttribute
 } Else {
   Set saveTopPrefix=topPrefix,saveTypesPrefix=typesPrefix,saveAttrsPrefix=attrsPrefix,saveUsePrefix=usePrefix
   Set typesPrefix=namespaces If (typesPrefix'=""),($extract(typesPrefix,*)'=":") Set typesPrefix=typesPrefix_":"
   If 'encoded Set namespaces=""
   Set (topPrefix,attrsPrefix,topAttrs,beginprefix)=""
   If tag="" Set tag=typesPrefix_"TContentAttributeSetDescriptor"
   Set xsitype=0
 }
 Set local=+$get(local),savelocal=local
 Set endprefix="</"_beginprefix,beginprefix="<"_beginprefix
 If tmpi Set temp=temp_" "_xsiPrefix_"type="""_typesPrefix_"TContentAttributeSetDescriptor"""_xsiAttrs,xsiAttrs=""
   If id'="" Set temp=" "_$select($get(soap12):soapPrefix_"id",1:"id")_"=""id"_id_""""_temp
 If encoded Set temp=temp_xsiAttrs,xsiAttrs=""
 If indentFlag Set %xmlmsg=currentIndent if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg } Set currentIndent=$select(initialCR:"",1:$c(13,10))_currentIndent_indentChars
 If tag[":" Set topPrefix=$piece(tag,":"),tag=$piece(tag,":",2)  If topPrefix'="" Set topPrefix=topPrefix_":"
 Set %xmlmsg="<"_topPrefix_tag_temp if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set attrsVal=attrsArg,attrsArg="" Set %xmlmsg=attrsVal if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 If 'encoded {
   Set val=..DEFAULTLIMIT
   If val'="" {
     Set %xmlmsg=" "_attrsPrefix_"DEFAULT_LIMIT="""_val_"""" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
   }
 }
 Set %xmlmsg=">" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..name
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"name"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"string""",1:"")_">"_$select(val=$c(0):"",1:$select((val["<")||(val[">")||(val["&"):"<![CDATA["_$replace(val,"]]>","]]]]><![CDATA[>")_"]]>",1:val))_endprefix_"name>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..snapshotDate
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"snapshotDate"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"dateTime""",1:"")_">"_$select(val="":"",1:$translate(val," ","T")_"Z")_endprefix_"snapshotDate>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..attributesLimit
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"attributesLimit"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"int""",1:"")_">"_val_endprefix_"attributesLimit>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..allPropertyTypes
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"allPropertyTypes"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"boolean""",1:"")_">"_$s(val:"true",1:"false")_endprefix_"allPropertyTypes>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set aval=..propertyTypes
 Set k="" Set:deepFlag val=aval.GetNext(.k) If k'="" {
   If encoded {
     If indentFlag Set %xmlmsg=currentIndent Set currentIndent=currentIndent_indentChars if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     Set temp="",temp1=$parameter("BSTS.ns1.TPropertyType","NAMESPACE")
     Set temp1=$select((temp1'="http://apelon.com/dtsserver/types")&&$IsObject(namespaces):namespaces.GetNamespacePrefix(temp1,.temp),1:typesPrefix)
     If soap12 { Set %xmlmsg=beginprefix_"propertyTypes"_$select(xsitype:"",1:" "_soapPrefix_"itemType="""_temp1_$select($parameter("BSTS.ns1.TPropertyType","XMLSUMMARY")'="":"s_TPropertyType",1:"TPropertyType")_"""")_" "_soapPrefix_"arraySize="""_aval.Count()_""""_""_temp_">" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     } Else { Set %xmlmsg=beginprefix_"propertyTypes "_$select(xsitype:xsiPrefix_"type="""_soapPrefix_"Array""",1:soapPrefix_"arrayType="""_temp1_$select($parameter("BSTS.ns1.TPropertyType","XMLSUMMARY")'="":"s_TPropertyType",1:"TPropertyType")_"["_aval.Count()_"]""")_""_temp_">" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg } }
   }
   While k'="" {
     If $IsObject(val) {
       Set id=""
       If encoded,'inlineFlag {
         Set temp=$select($parameter("BSTS.ns1.TPropertyType","XMLSUMMARY")'="":-1,1:1)
         Set id=+$get(idlist(temp*val))
         If 'soap12 , (id=0) Set id=$increment(idlist),oreflist(temp*id)=val,idlist(temp*val)=id
       }
       If +id'=0 {
         Set %xmlmsg=currentIndent_beginprefix_"propertyTypes "_$select(soap12:soapPrefix_"ref=""",1:"href=""#")_"id"_id_""" />" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
       } Else { if id=0 Set id=$increment(idlist)
         Set topArg="propertyTypes",summaryArg=1,group=0,createId=$get(id),typeAttr=$select(encoded||xsitype:"*",1:"BSTS.ns1.TPropertyType"),local=1,savexsiAttrs=xsiAttrs
         Set sc=val.XMLExportInternal() Goto:'sc XMLExportExit Set xsiAttrs=savexsiAttrs
       }
     } Else {
       Set %xmlmsg=currentIndent_beginprefix_"propertyTypes "_xsiPrefix_"nil=""true"""_xsiAttrs_"/>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     }
     Set val=aval.GetNext(.k)
   }
   If encoded {
     If indentFlag Set currentIndent=$extract(currentIndent,1,*-$length(indentChars)) Set %xmlmsg=currentIndent if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     Set %xmlmsg=endprefix_"propertyTypes>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
   }
 }
 If encoded {
   Set val=..DEFAULTLIMIT
   If val'="" {
     Set %xmlmsg=currentIndent_beginprefix_"DEFAULT_LIMIT"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"int""",1:"")_">"_val_endprefix_"DEFAULT_LIMIT>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
   }
 }
 Set val=..versions
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"versions"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"boolean""",1:"")_">"_$s(val:"true",1:"false")_endprefix_"versions>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..versionAttributeSetDescriptor
 If $IsObject(val) , deepFlag {
   Set id=""
   If encoded,'inlineFlag {
     Set temp=$select($parameter("BSTS.ns1.TAttributeSetDescriptor","XMLSUMMARY")'="":-1,1:1)
     Set id=+$get(idlist(temp*val))
     If 'soap12 , (id=0) Set id=$increment(idlist),oreflist(temp*id)=val,idlist(temp*val)=id
   }
   If +id'=0 {
     Set %xmlmsg=currentIndent_beginprefix_"versionAttributeSetDescriptor "_$select(soap12:soapPrefix_"ref=""",1:"href=""#")_"id"_id_""" />" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
   } Else { if id=0 Set id=$increment(idlist)
     Set topArg="versionAttributeSetDescriptor",summaryArg=1,group=0,createId=$get(id),typeAttr=$select(encoded||xsitype:"*",1:"BSTS.ns1.TAttributeSetDescriptor"),local=1,savexsiAttrs=xsiAttrs
     Set sc=val.XMLExportInternal() Goto:'sc XMLExportExit Set xsiAttrs=savexsiAttrs
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
     If $classname(val)="BSTS.ns1.TContentAttributeSetDescriptor" {
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
 Quit ##class(%XML.Implementation).XMLGetSchemaImports("BSTS.ns1.TContentAttributeSetDescriptor",.imports,.classes)
zXMLImportInternal()
 New child,node,data,ref,encodedArray,loopref,element,key,nsIndex
 Set $ztrap="XMLImportInternalTrap"
 Set encoded=$case($piece(fmt,",",1),"":0,"literal":0,"encoded":1,"encoded12":1,:"")
 If encoded="" Quit $$Error^%apiOBJ(6231,fmt)
 Set nsIndex=$get(@(tree)@("ns","http://apelon.com/dtsserver/types"))
 Set (node,ref)=nodeArg
 If ($listget($get(@(tree)@(node,0)),1)'="e")||(tag'=@(tree)@(node)) Goto XMLImportMalformed
 If bareProjection Quit $$Error^%apiOBJ(6386,"BSTS.ns1.TContentAttributeSetDescriptor")
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
 If tag="attributesLimit" {
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
   Set ..attributesLimit=data
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 If tag="allPropertyTypes" {
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
   Set ..allPropertyTypes=data
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 For  { Set encodedArray=encoded
 If tag="propertyTypes" {
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
           If (class="") || (class="TPropertyType") {
             Set class="BSTS.ns1.TPropertyType"
           } Else {
             If $length(class,":")=2 Set class=$piece(class,":",2)
             Set class=$get(^oddCOM("BSTS.ns1.TPropertyType",85,"s",class))_$get(^oddXML("BSTS.ns1.TPropertyType","s",class)) If class="" Set class=0
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
         If data'="" Do ..propertyTypes.Insert(data)
         }
         Set element=$order(@(tree)@(loopref,"c",element))
       }
       Quit:('sc)  Set ref=loopref
     } Else { Set encodedArray=0
         If $listget($get(@(tree)@(ref,0)),1)'="e" Goto XMLImportMalformedNoTag
         If 'encoded,(@(tree)@(ref)'="propertyTypes") Goto XMLImportBadTag
         If '$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
         If encoded,$$XMLImportId() {
           Set data=idlist(ref)
         } Else {
           If 'sc Goto XMLImportExit
           Set class=$select(($get(@(tree)@(ref,"a","type","u"))=1):$get(@(tree)@(ref,"a","type")),1:"")
           If (class="") || (class="TPropertyType") {
             Set class="BSTS.ns1.TPropertyType"
           } Else {
             If $length(class,":")=2 Set class=$piece(class,":",2)
             Set class=$get(^oddCOM("BSTS.ns1.TPropertyType",85,"s",class))_$get(^oddXML("BSTS.ns1.TPropertyType","s",class)) If class="" Set class=0
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
         If data'="" Do ..propertyTypes.Insert(data)
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 Else { Quit  }
 If encodedArray Quit
 }
 If encoded,(tag="DEFAULT_LIMIT") {
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
   Set ..DEFAULTLIMIT=data
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 If tag="versions" {
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
   Set ..versions=data
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 If tag="versionAttributeSetDescriptor" {
   If '$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
   If encoded,$$XMLImportId() {
     Set data=idlist(ref)
   } Else { Goto:'sc XMLImportExit
     Set class=$select(($get(@(tree)@(ref,"a","type","u"))=1):$get(@(tree)@(ref,"a","type")),1:"")
     If (class="") || (class="TAttributeSetDescriptor") {
       Set class="BSTS.ns1.TAttributeSetDescriptor"
     } Else {
       If $length(class,":")=2 Set class=$piece(class,":",2)
       Set class=$get(^oddCOM("BSTS.ns1.TAttributeSetDescriptor",85,"s",class))_$get(^oddXML("BSTS.ns1.TAttributeSetDescriptor","s",class)) If class="" Set class=0
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
   If data'="" Set ..versionAttributeSetDescriptor=data
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
 If ..name'="" Quit 0
 If ..snapshotDate'="" Quit 0
 If ..attributesLimit'="" Quit 0
 If ..allPropertyTypes'="" Quit 0
 If ..propertyTypes.Count()>0 Quit 0
 If ..DEFAULTLIMIT'="" Quit 0
 If ..versions'="" Quit 0
 If $IsObject(..versionAttributeSetDescriptor) Quit 0
 Quit 1
zXMLNew(document,node,containerOref="")
	Quit (##class(BSTS.ns1.TContentAttributeSetDescriptor).%New())
zXMLSchema(top="",format="",namespacePrefix="",input=0,refOnly=0,schema)
 Quit ##class(%XML.Implementation).XMLSchema("BSTS.ns1.TContentAttributeSetDescriptor",top,format,namespacePrefix,input,refOnly,.schema)
zversionAttributeSetDescriptorN() public {
	Set newobject=##class(BSTS.ns1.TAttributeSetDescriptor).%New() If newobject="" Quit ""
	Set ..versionAttributeSetDescriptor=newobject
	Quit newobject }
zversionsDisplayToLogical(%val) public {
	Quit ''%val }
zversionsIsValid(%val="") public {
	Q $s($isvalidnum(%val,0,0,2)&&(+%val'=2):1,1:$$Error^%apiOBJ(7206,%val)) }
zversionsLogicalToXSD(%val) public {
	Q $s(%val:"true",1:"false") }
zversionsNormalize(%val) public {
	Quit %val\1 }
zversionsXSDToLogical(%val) public {
	Q $case(%val,"true":1,"false":0,1:1,0:0,:"") }
