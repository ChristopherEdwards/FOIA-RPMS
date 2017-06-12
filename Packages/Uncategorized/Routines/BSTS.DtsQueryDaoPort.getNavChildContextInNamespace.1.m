 ;BSTS.DtsQueryDaoPort.getNavChildContextInNamespace.1
 ;(C)InterSystems, generated for class BSTS.DtsQueryDaoPort.getNavChildContextInNamespace.  Do NOT edit. 10/22/2016 08:54:01AM
 ;;7232742F;BSTS.DtsQueryDaoPort.getNavChildContextInNamespace
 ;
%BindExport(dev,Seen,RegisterOref,AllowedDepth,AllowedCapacity) public {
   i $d(Seen(+$this)) q 1
   Set Seen(+$this)=$this
   s sc = 1
 s proporef=..%Result
 s proporef=..focusConcept
 s proporef=..focusConceptASD
 s proporef=..namespace
   d:RegisterOref InitObjVar^%SYS.BINDSRV($this)
   i dev'="" s t=$io u dev i $zobjexport($this_"",3)+$zobjexport($this."%%OID",3)+$zobjexport($this,3)!1 u t
 If AllowedDepth>0 Set AllowedDepth = AllowedDepth - 1
 If AllowedCapacity>0 Set AllowedCapacity = AllowedCapacity - 1/4
 s proporef=..%Result
       i proporef'="" s sc=1 i AllowedDepth'=0,AllowedCapacity'=0 s sc=proporef.%BindExport(dev,.Seen,RegisterOref,AllowedDepth,AllowedCapacity) q:('sc) sc
 s proporef=..focusConcept
       i proporef'="" s sc=1 i AllowedDepth'=0,AllowedCapacity'=0 s sc=proporef.%BindExport(dev,.Seen,RegisterOref,AllowedDepth,AllowedCapacity) q:('sc) sc
 s proporef=..focusConceptASD
       i proporef'="" s sc=1 i AllowedDepth'=0,AllowedCapacity'=0 s sc=proporef.%BindExport(dev,.Seen,RegisterOref,AllowedDepth,AllowedCapacity) q:('sc) sc
 s proporef=..namespace
       i proporef'="" s sc=1 i AllowedDepth'=0,AllowedCapacity'=0 s sc=proporef.%BindExport(dev,.Seen,RegisterOref,AllowedDepth,AllowedCapacity) q:('sc) sc
   Quit sc }
%Construct(operation) public {
	Quit ..%OnNew(.operation) }
%ConstructCloneInit(object,deep=0,cloned,location) public {
	Set i%"%%OID"=""
	If deep>0 {
		If $isobject(..%Result)=1 Set r%%Result=r%%Result.%ConstructClone(1,.cloned),i%%Result=""
		If $isobject(..focusConcept)=1 Set r%focusConcept=r%focusConcept.%ConstructClone(1,.cloned),i%focusConcept=""
		If $isobject(..focusConceptASD)=1 Set r%focusConceptASD=r%focusConceptASD.%ConstructClone(1,.cloned),i%focusConceptASD=""
		If $isobject(..namespace)=1 Set r%namespace=r%namespace.%ConstructClone(1,.cloned),i%namespace=""
	}
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
	Set Poref=r%%Result If Poref'="",'$data(%objTX(1,+Poref)) Set %objTX(6,$i(%objTX(6)))=Poref
	Set Poref=r%focusConcept If Poref'="",'$data(%objTX(1,+Poref)) Set %objTX(6,$i(%objTX(6)))=Poref
	Set Poref=r%focusConceptASD If Poref'="",'$data(%objTX(1,+Poref)) Set %objTX(6,$i(%objTX(6)))=Poref
	Set Poref=r%namespace If Poref'="",'$data(%objTX(1,+Poref)) Set %objTX(6,$i(%objTX(6)))=Poref
exit	Quit sc }
zInvoke(%Client,%Action,focusConcept,focusConceptASD,namespace) public {
 Set ..focusConcept=$get(focusConcept),..focusConceptASD=$get(focusConceptASD),..namespace=$get(namespace)
 Do %Client.InvokeClient($this,"getNavChildContextInNamespace",%Action)
 Quit ..%Result }
zNeedsAdjustment(ResultName) public {
 Set ResultName="getNavChildContextInNamespaceResult"
 Quit 1 }
zReset() public {
 Quit }
zXMLDTD(top,format,input,dtdlist)
 Quit ##class(%XML.Implementation).XMLDTD("BSTS.DtsQueryDaoPort.getNavChildContextInNamespace",.top,.format,.input,.dtdlist)
zXMLExportInternal()
 New tag,summary,attrsVal,savelocal,aval,k,tmpPrefix,prefixDepth,hasNoContent,hasElement,topAttrs,beginprefix,endprefix,savexsiAttrs,initialxsiAttrs,initlist,initialCR,inlineFlag,popAtEnd,saveTopPrefix,saveTypesPrefix,saveAttrsPrefix,saveUsePrefix
 Set $ztrap="XMLExportInternalTrap",popAtEnd=0
 If encoded Quit $$Error^%apiOBJ(6231,fmt)
 Set summary=summaryArg,initialxsiAttrs=xsiAttrs
 If group Quit $$Error^%apiOBJ(6386,"BSTS.DtsQueryDaoPort.getNavChildContextInNamespace")
 If indentFlag Set initialCR=($extract(currentIndent,1,2)=$c(13,10))
 Set id=createId
 Set temp=""
 If id'="" {
   If $piece($get(idlist(+$this)),",",2)'="" Quit 1
   Set idlist(+$this)=id_",1"
 }
 If 'nocycle {
   If $data(oreflist($this)) Quit $$Error^%apiOBJ(6296,"BSTS.DtsQueryDaoPort.getNavChildContextInNamespace")
   Set oreflist($this)=""
 }
 Set tag=$get(topArg)
 Set tmpi=(($get(typeAttr)'="")&&(typeAttr'="BSTS.DtsQueryDaoPort.getNavChildContextInNamespace"))
 If $IsObject(namespaces) {
   If namespaces.Stable,namespaces.CurrentNamespace="http://apelon.com/dtsserver/ws/dtsquery",'tmpi||(typesPrefix'="") {
     Set topAttrs=""
   } Else {
     Set popAtEnd=1,saveTopPrefix=topPrefix,saveTypesPrefix=typesPrefix,saveAttrsPrefix=attrsPrefix,saveUsePrefix=usePrefix
     Set sc=namespaces.PushNodeForExport("http://apelon.com/dtsserver/ws/dtsquery",$get(local,0),tmpi,"",,.topPrefix,.topAttrs,.typesPrefix,.attrsPrefix,.usePrefix)
     If 'sc Quit sc
   }
   Set beginprefix=$select(namespaces.ElementQualified&&usePrefix:typesPrefix,1:"")
   If topAttrs'="" Set temp=temp_" "_topAttrs
   If tag="" Set tag="getNavChildContextInNamespace"
   Set xsitype=namespaces.OutputTypeAttribute
 } Else {
   Set saveTopPrefix=topPrefix,saveTypesPrefix=typesPrefix,saveAttrsPrefix=attrsPrefix,saveUsePrefix=usePrefix
   Set typesPrefix=namespaces If (typesPrefix'=""),($extract(typesPrefix,*)'=":") Set typesPrefix=typesPrefix_":"
   Set namespaces=""
   Set (topPrefix,attrsPrefix,topAttrs,beginprefix)=""
   If tag="" Set tag=typesPrefix_"getNavChildContextInNamespace"
   Set xsitype=0
 }
 Set local=+$get(local),savelocal=local
 Set endprefix="</"_beginprefix,beginprefix="<"_beginprefix
 If tmpi Set temp=temp_" "_xsiPrefix_"type="""_typesPrefix_"getNavChildContextInNamespace"""_xsiAttrs,xsiAttrs=""
   If id'="" Set temp=" "_$select($get(soap12):soapPrefix_"id",1:"id")_"=""id"_id_""""_temp
 If indentFlag Set %xmlmsg=currentIndent if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg } Set currentIndent=$select(initialCR:"",1:$c(13,10))_currentIndent_indentChars
 If tag[":" Set topPrefix=$piece(tag,":"),tag=$piece(tag,":",2)  If topPrefix'="" Set topPrefix=topPrefix_":"
 Set %xmlmsg="<"_topPrefix_tag_temp if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set attrsVal=attrsArg,attrsArg="" Set %xmlmsg=attrsVal if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set %xmlmsg=">" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..focusConcept
 If $IsObject(val) , deepFlag {
     Set topArg="focusConcept",summaryArg=0,group=0,createId="",typeAttr=$select(xsitype:"*",1:"BSTS.ns1.TConcept"),local=1,savexsiAttrs=xsiAttrs
     Set sc=val.XMLExportInternal() Goto:'sc XMLExportExit Set xsiAttrs=savexsiAttrs
 }
 Set val=..focusConceptASD
 If $IsObject(val) , deepFlag {
     Set topArg="focusConceptASD",summaryArg=0,group=0,createId="",typeAttr=$select(xsitype:"*",1:"BSTS.ns1.TConceptAttributeSetDescriptor"),local=1,savexsiAttrs=xsiAttrs
     Set sc=val.XMLExportInternal() Goto:'sc XMLExportExit Set xsiAttrs=savexsiAttrs
 }
 Set val=..namespace
 If $IsObject(val) , deepFlag {
     Set topArg="namespace",summaryArg=0,group=0,createId="",typeAttr=$select(xsitype:"*",1:"BSTS.ns1.TNamespace"),local=1,savexsiAttrs=xsiAttrs
     Set sc=val.XMLExportInternal() Goto:'sc XMLExportExit Set xsiAttrs=savexsiAttrs
 }
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
 Quit ##class(%XML.Implementation).XMLGetSchemaImports("BSTS.DtsQueryDaoPort.getNavChildContextInNamespace",.imports,.classes)
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
 If $case($piece(fmt,",",1),"":0,"literal":0,:1) Quit $$Error^%apiOBJ(6231,fmt)
 Set nsIndex=$get(@(tree)@("ns","http://apelon.com/dtsserver/ws/dtsquery"))
 Set (node,ref)=nodeArg
 If ($listget($get(@(tree)@(node,0)),1)'="e")||(tag'=@(tree)@(node)) Goto XMLImportMalformed
 If bareProjection Quit $$Error^%apiOBJ(6386,"BSTS.DtsQueryDaoPort.getNavChildContextInNamespace")
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
 If tag="getNavChildContextInNamespaceResult" {
   If '$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
   Set class=$select(($get(@(tree)@(ref,"a","type","u"))=1):$get(@(tree)@(ref,"a","type")),1:"")
   If (class="") || (class="TNavChildContext") {
     Set class="BSTS.ns1.TNavChildContext"
   } Else {
     If $length(class,":")=2 Set class=$piece(class,":",2)
     Set class=$get(^oddCOM("BSTS.ns1.TNavChildContext",85,"t",class))_$get(^oddXML("BSTS.ns1.TNavChildContext","t",class)) If class="" Set class=0
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
   If $isobject(data) Set tag=@(tree)@(ref),nodeArg=ref,bareProjection=0,summaryArg=0,keynameattr="",sc=data.XMLImportInternal() If ('sc) Goto XMLImportExit
   If data'="" Set ..%Result=data
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
zXMLIsObjectEmpty(ignoreNull)
 If $IsObject(..%Result) Quit 0
 If $IsObject(..focusConcept) Quit 0
 If $IsObject(..focusConceptASD) Quit 0
 If $IsObject(..namespace) Quit 0
 Quit 1
zXMLNew(document,node,containerOref="")
	Quit (##class(BSTS.DtsQueryDaoPort.getNavChildContextInNamespace).%New())
zXMLSchema(top="",format="",namespacePrefix="",input=0,refOnly=0,schema)
 Quit ##class(%XML.Implementation).XMLSchema("BSTS.DtsQueryDaoPort.getNavChildContextInNamespace",top,format,namespacePrefix,input,refOnly,.schema)
%ResultNewObject() public {
	Set newobject=##class(BSTS.ns1.TNavChildContext).%New() If newobject="" Quit ""
	Set ..%Result=newobject
	Quit newobject }
zfocusConceptNewObject() public {
	Set newobject=##class(BSTS.ns1.TConcept).%New() If newobject="" Quit ""
	Set ..focusConcept=newobject
	Quit newobject }
zfocusConceptASDNewObject() public {
	Set newobject=##class(BSTS.ns1.TConceptAttributeSetDescriptor).%New() If newobject="" Quit ""
	Set ..focusConceptASD=newobject
	Quit newobject }
znamespaceNewObject() public {
	Set newobject=##class(BSTS.ns1.TNamespace).%New() If newobject="" Quit ""
	Set ..namespace=newobject
	Quit newobject }
