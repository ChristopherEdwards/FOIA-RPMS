 ;BSTS.ns1.SESearchFilter.1
 ;(C)InterSystems, generated for class BSTS.ns1.SESearchFilter.  Do NOT edit. 10/22/2016 08:53:37AM
 ;;78666677;BSTS.ns1.SESearchFilter
 ;
%BindExport(dev,Seen,RegisterOref,AllowedDepth,AllowedCapacity) public {
   i $d(Seen(+$this)) q 1
   Set Seen(+$this)=$this
   s sc = 1
 s proporef=..attributeFilters
 s proporef=..conceptFilters
 s proporef=..concepts
 s proporef=..excludeFilter
 s proporef=..subsetFilters
   d:RegisterOref InitObjVar^%SYS.BINDSRV($this)
   i dev'="" s t=$io u dev i $zobjexport($this_"",3)+$zobjexport($this."%%OID",3)+$zobjexport($this,3)!1 u t
 If AllowedDepth>0 Set AllowedDepth = AllowedDepth - 1
 If AllowedCapacity>0 Set AllowedCapacity = AllowedCapacity - 1/5
 s proporef=..attributeFilters
       i proporef'="" d
  . s idx="" i proporef'="" f  s elemoref=proporef.GetNext(.idx) q:idx=""  s sc=1 i AllowedDepth'=0,AllowedCapacity'=0 s sc=elemoref.%BindExport(dev,.Seen,RegisterOref,AllowedDepth,AllowedCapacity) q:('sc)
  q:('sc) sc
       i proporef'="",dev'="" s t=$io u dev i $zobjexport(proporef_"",3)+$zobjexport(proporef."%%OID",3)+$zobjexport(proporef,3)!1 u t
       if proporef'="",dev'="" d
       . s t=$io u dev i $zobjexport(3_"",3)!1 u t
       . s t=$io u dev i $zobjexport(proporef.Count()_"",3)!1 u t
     . for i=1:1:proporef.Count()  s t=$io u dev i $zobjexport(proporef.GetAt(i)_"",3)!1 u t
 s proporef=..conceptFilters
       i proporef'="" d
  . s idx="" i proporef'="" f  s elemoref=proporef.GetNext(.idx) q:idx=""  s sc=1 i AllowedDepth'=0,AllowedCapacity'=0 s sc=elemoref.%BindExport(dev,.Seen,RegisterOref,AllowedDepth,AllowedCapacity) q:('sc)
  q:('sc) sc
       i proporef'="",dev'="" s t=$io u dev i $zobjexport(proporef_"",3)+$zobjexport(proporef."%%OID",3)+$zobjexport(proporef,3)!1 u t
       if proporef'="",dev'="" d
       . s t=$io u dev i $zobjexport(3_"",3)!1 u t
       . s t=$io u dev i $zobjexport(proporef.Count()_"",3)!1 u t
     . for i=1:1:proporef.Count()  s t=$io u dev i $zobjexport(proporef.GetAt(i)_"",3)!1 u t
 s proporef=..concepts
       i proporef'="" d
  . s idx="" i proporef'="" f  s elemoref=proporef.GetNext(.idx) q:idx=""  s sc=1 i AllowedDepth'=0,AllowedCapacity'=0 s sc=elemoref.%BindExport(dev,.Seen,RegisterOref,AllowedDepth,AllowedCapacity) q:('sc)
  q:('sc) sc
       i proporef'="",dev'="" s t=$io u dev i $zobjexport(proporef_"",3)+$zobjexport(proporef."%%OID",3)+$zobjexport(proporef,3)!1 u t
       if proporef'="",dev'="" d
       . s t=$io u dev i $zobjexport(3_"",3)!1 u t
       . s t=$io u dev i $zobjexport(proporef.Count()_"",3)!1 u t
     . for i=1:1:proporef.Count()  s t=$io u dev i $zobjexport(proporef.GetAt(i)_"",3)!1 u t
 s proporef=..excludeFilter
       i proporef'="" s sc=1 i AllowedDepth'=0,AllowedCapacity'=0 s sc=proporef.%BindExport(dev,.Seen,RegisterOref,AllowedDepth,AllowedCapacity) q:('sc) sc
 s proporef=..subsetFilters
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
	Set m%attributeFilters=0,M%attributeFilters=0,m%conceptFilters=0,M%conceptFilters=0,m%concepts=0,M%concepts=0,m%subsetFilters=0,M%subsetFilters=0
	Quit 1 }
%ConstructCloneInit(object,deep=0,cloned,location) public {
	Set i%attributeFilters="",r%attributeFilters=""
	Set i%conceptFilters="",r%conceptFilters=""
	Set i%concepts="",r%concepts=""
	Set i%subsetFilters="",r%subsetFilters=""
	Set i%"%%OID"=""
	If deep>0 {
		Set key="" For  Set value=..attributeFilters.GetNext(.key) Quit:key=""  Set r%attributeFilters(key)=$select(value="":"",1:value.%ConstructClone(1,.cloned)),i%attributeFilters(key)=""
		Set key="" For  Set value=..conceptFilters.GetNext(.key) Quit:key=""  Set r%conceptFilters(key)=$select(value="":"",1:value.%ConstructClone(1,.cloned)),i%conceptFilters(key)=""
		Set key="" For  Set value=..concepts.GetNext(.key) Quit:key=""  Set r%concepts(key)=$select(value="":"",1:value.%ConstructClone(1,.cloned)),i%concepts(key)=""
		If $isobject(..excludeFilter)=1 Set r%excludeFilter=r%excludeFilter.%ConstructClone(1,.cloned),i%excludeFilter=""
		Set key="" For  Set value=..subsetFilters.GetNext(.key) Quit:key=""  Set r%subsetFilters(key)=$select(value="":"",1:value.%ConstructClone(1,.cloned)),i%subsetFilters(key)=""
	}
	Quit 1 }
%Destruct() public {
	Try {
		If $isobject($get(r%attributeFilters))=1,$zobjcnt(r%attributeFilters)>1 Do r%attributeFilters.%Disconnect()
		If $isobject($get(r%conceptFilters))=1,$zobjcnt(r%conceptFilters)>1 Do r%conceptFilters.%Disconnect()
		If $isobject($get(r%concepts))=1,$zobjcnt(r%concepts)>1 Do r%concepts.%Disconnect()
		If $isobject($get(r%subsetFilters))=1,$zobjcnt(r%subsetFilters)>1 Do r%subsetFilters.%Disconnect()
	} Catch { Set sc=$$Error^%apiOBJ(5002,$zerror) }
	Quit 1 }
%NormalizeObject() public {
	If '$system.CLS.GetModified() Quit 1
	If m%namespaceId Set:i%namespaceId'="" i%namespaceId=(..namespaceIdNormalize(i%namespaceId))
	If m%namespaceName Set:i%namespaceName'="" i%namespaceName=(..namespaceNameNormalize(i%namespaceName))
	If m%status Set:i%status'="" i%status=(..statusNormalize(i%status))
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
		Set key=$order(r%attributeFilters(key),1,Poref) Quit:key=""
		If $isobject(Poref)=1 Set:'$data(%objTX(1,+Poref)) %objTX(6,$i(%objTX(6)))=Poref
	}
	Set key=""
	For  {
		Set key=$order(r%conceptFilters(key),1,Poref) Quit:key=""
		If $isobject(Poref)=1 Set:'$data(%objTX(1,+Poref)) %objTX(6,$i(%objTX(6)))=Poref
	}
	Set key=""
	For  {
		Set key=$order(r%concepts(key),1,Poref) Quit:key=""
		If $isobject(Poref)=1 Set:'$data(%objTX(1,+Poref)) %objTX(6,$i(%objTX(6)))=Poref
	}
	Set Poref=r%excludeFilter If Poref'="",'$data(%objTX(1,+Poref)) Set %objTX(6,$i(%objTX(6)))=Poref
	Set key=""
	For  {
		Set key=$order(r%subsetFilters(key),1,Poref) Quit:key=""
		If $isobject(Poref)=1 Set:'$data(%objTX(1,+Poref)) %objTX(6,$i(%objTX(6)))=Poref
	}
exit	Quit sc }
%ValidateObject(force=0) public {
	Set sc=1
	If '$system.CLS.GetModified() Quit sc
	Set iv=..namespaceId If iv="" Set rc=$$Error^%apiOBJ(5659,$classname()_"::"_"namespaceId"_"("_$this_",ID="),sc=$select(+sc:rc,1:$$AppendStatus^%occSystem(sc,rc))
	If m%namespaceId Set rc=(..namespaceIdIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"namespaceId",iv)
	If m%namespaceName Set iv=..namespaceName If iv'="" Set rc=(..namespaceNameIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"namespaceName",iv)
	If m%status Set iv=..status If iv'="" Set rc=(..statusIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"status",iv)
	Quit sc }
zXMLDTD(top,format,input,dtdlist)
 Quit ##class(%XML.Implementation).XMLDTD("BSTS.ns1.SESearchFilter",.top,.format,.input,.dtdlist)
zXMLGetSchemaImports(imports,classes)
 Quit ##class(%XML.Implementation).XMLGetSchemaImports("BSTS.ns1.SESearchFilter",.imports,.classes)
zXMLIsObjectEmpty(ignoreNull)
 If ..namespaceId'="" Quit 0
 If ..namespaceName'="" Quit 0
 If ..concepts.Count()>0 Quit 0
 If ..conceptFilters.Count()>0 Quit 0
 If ..attributeFilters.Count()>0 Quit 0
 If ..subsetFilters.Count()>0 Quit 0
 If $IsObject(..excludeFilter) Quit 0
 If ..status'="" Quit 0
 Quit 1
zXMLNew(document,node,containerOref="")
	Quit (##class(BSTS.ns1.SESearchFilter).%New())
zXMLSchema(top="",format="",namespacePrefix="",input=0,refOnly=0,schema)
 Quit ##class(%XML.Implementation).XMLSchema("BSTS.ns1.SESearchFilter",top,format,namespacePrefix,input,refOnly,.schema)
zattributeFiltersBuildValueArra(value,array) public {
	Quit ##class(%Collection.ListOfObj).BuildValueArray(value,.array)
}
zattributeFiltersCollectionToDi(val="",delim) public { Set:'($data(delim)#2) delim=$char(13,10)
	set odbc="",tDelimLen=$l(delim)
	for i=1:1:$listlength(val) {
		set item=$Listget(val,i)
		if item'["""",item'[delim,$length($zstrip(item,"<>W"))=$length(item) set odbc=odbc_delim_item continue
		for j=$length(item,""""):-1:2 set $piece(item,"""",j)=""""_$piece(item,"""",j)
		set odbc=odbc_delim_""""_item_""""
	}
	quit $extract(odbc,tDelimLen+1,*) }
zattributeFiltersCollectionToOd(val="") public {
	set odbc=""
	for i=1:1:$listlength(val) {
		set item=$listget(val,i)
		if item'["""",item'[",",$length($zstrip(item,"<>W"))=$length(item) set odbc=odbc_","_item continue
		for j=$length(item,""""):-1:2 set $piece(item,"""",j)=""""_$piece(item,"""",j)
		set odbc=odbc_","""_item_""""
	}
	quit $extract(odbc,2,*) }
zattributeFiltersDisplayToColle(val="",delim) public { Set:'($data(delim)#2) delim=$char(13,10)
	set logical="",out="",tDelimLen=$l(delim)
hloop	if $extract(val,1,tDelimLen)=delim { goto hdel } if val="" { goto hexit } if $extract(val)="""" { goto hquote } goto hdefault
hdefault	set stuff=$piece(val,delim),out=out_stuff,val=$extract(val,$length(stuff)+1,*) goto hloop
hquote	set stuff=$find(val,"""",2) if stuff=0 set stuff=$length(val)+10
	set out=out_$select(stuff=3:"""",1:$extract(val,2,stuff-2)),val=$extract(val,stuff,*)
	if $extract(val)="""" { set out=out_"""" goto hquote } else { goto hdefault }
hdel	set logical=logical_$listbuild(out),out="",val=$extract(val,tDelimLen+1,*) goto hloop
hexit	set logical=logical_$listbuild(out)
	quit logical }
zattributeFiltersGetObject(force=0) public {
	Quit $select(r%attributeFilters="":$select(i%attributeFilters="":"",1:$listbuild(i%attributeFilters_"")),(''..attributeFilters.%GetSwizzleObject(force,.oid)):oid,1:"") }
zattributeFiltersGetObjectId(force=0) public {
	Quit $listget(..attributeFiltersGetObject(force)) }
zattributeFiltersGetSwizzled() public {
	Set oref=##class(%Collection.ListOfObj).%New() If oref="" Quit ""
	Set modstate=$system.CLS.GetModifiedBits() Set r%attributeFilters=oref Do $system.CLS.SetModifiedBits(modstate)
	Set oref.ElementType="BSTS.ns1.SEAttributeFilter",oref.ElementClassType="",oref.Owner=+$this,oref.Storage=$this."attributeFilters%i"(),oref.OrefStorage=oref.Storage+1
	Do $system.CLS.SetModified(oref,0)
	Quit oref }
zattributeFiltersOdbcToCollecti(val="") public {
	set logical="",out=""
hloop	if $extract(val)="," { goto hdel } if val="" { goto hexit } if $extract(val)="""" { goto hquote } goto hdefault
hdefault	set stuff=$piece(val,","),out=out_stuff,val=$extract(val,$length(stuff)+1,*) goto hloop
hquote	set stuff=$find(val,"""",2) if stuff=0 set stuff=$length(val)+10
	set out=out_$select(stuff=3:"""",1:$extract(val,2,stuff-2)),val=$extract(val,stuff,*)
	if $extract(val)="""" { set out=out_"""" goto hquote } else { goto hdefault }
hdel	set logical=logical_$listbuild(out),out="",val=$extract(val,2,*) goto hloop
hexit	set logical=logical_$listbuild(out)
	quit logical }
zattributeFiltersSet(newvalue) public {
	If '$isobject(newvalue),newvalue'="" Quit $$Error^%apiOBJ(5807,newvalue)
	If r%attributeFilters=newvalue Quit 1
	If newvalue="" Kill i%attributeFilters,r%attributeFilters Set i%attributeFilters="",r%attributeFilters="" Quit 1
	Set oref=r%attributeFilters Kill i%attributeFilters,r%attributeFilters Set i%attributeFilters="",r%attributeFilters=oref
	Set key="" For i=1:1 Set value=newvalue.GetNext(.key) Quit:key=""  Set r%attributeFilters(i)=value,i%attributeFilters(i)=""
	Quit 1 }
zconceptFiltersBuildValueArray(value,array) public {
	Quit ##class(%Collection.ListOfObj).BuildValueArray(value,.array)
}
zconceptFiltersCollectionToDisp(val="",delim) public { Set:'($data(delim)#2) delim=$char(13,10)
	set odbc="",tDelimLen=$l(delim)
	for i=1:1:$listlength(val) {
		set item=$Listget(val,i)
		if item'["""",item'[delim,$length($zstrip(item,"<>W"))=$length(item) set odbc=odbc_delim_item continue
		for j=$length(item,""""):-1:2 set $piece(item,"""",j)=""""_$piece(item,"""",j)
		set odbc=odbc_delim_""""_item_""""
	}
	quit $extract(odbc,tDelimLen+1,*) }
zconceptFiltersCollectionToOdbc(val="") public {
	set odbc=""
	for i=1:1:$listlength(val) {
		set item=$listget(val,i)
		if item'["""",item'[",",$length($zstrip(item,"<>W"))=$length(item) set odbc=odbc_","_item continue
		for j=$length(item,""""):-1:2 set $piece(item,"""",j)=""""_$piece(item,"""",j)
		set odbc=odbc_","""_item_""""
	}
	quit $extract(odbc,2,*) }
zconceptFiltersDisplayToCollect(val="",delim) public { Set:'($data(delim)#2) delim=$char(13,10)
	set logical="",out="",tDelimLen=$l(delim)
hloop	if $extract(val,1,tDelimLen)=delim { goto hdel } if val="" { goto hexit } if $extract(val)="""" { goto hquote } goto hdefault
hdefault	set stuff=$piece(val,delim),out=out_stuff,val=$extract(val,$length(stuff)+1,*) goto hloop
hquote	set stuff=$find(val,"""",2) if stuff=0 set stuff=$length(val)+10
	set out=out_$select(stuff=3:"""",1:$extract(val,2,stuff-2)),val=$extract(val,stuff,*)
	if $extract(val)="""" { set out=out_"""" goto hquote } else { goto hdefault }
hdel	set logical=logical_$listbuild(out),out="",val=$extract(val,tDelimLen+1,*) goto hloop
hexit	set logical=logical_$listbuild(out)
	quit logical }
zconceptFiltersGetObject(force=0) public {
	Quit $select(r%conceptFilters="":$select(i%conceptFilters="":"",1:$listbuild(i%conceptFilters_"")),(''..conceptFilters.%GetSwizzleObject(force,.oid)):oid,1:"") }
zconceptFiltersGetObjectId(force=0) public {
	Quit $listget(..conceptFiltersGetObject(force)) }
zconceptFiltersGetSwizzled() public {
	Set oref=##class(%Collection.ListOfObj).%New() If oref="" Quit ""
	Set modstate=$system.CLS.GetModifiedBits() Set r%conceptFilters=oref Do $system.CLS.SetModifiedBits(modstate)
	Set oref.ElementType="BSTS.ns1.SEConceptFilter",oref.ElementClassType="",oref.Owner=+$this,oref.Storage=$this."conceptFilters%i"(),oref.OrefStorage=oref.Storage+1
	Do $system.CLS.SetModified(oref,0)
	Quit oref }
zconceptFiltersOdbcToCollection(val="") public {
	set logical="",out=""
hloop	if $extract(val)="," { goto hdel } if val="" { goto hexit } if $extract(val)="""" { goto hquote } goto hdefault
hdefault	set stuff=$piece(val,","),out=out_stuff,val=$extract(val,$length(stuff)+1,*) goto hloop
hquote	set stuff=$find(val,"""",2) if stuff=0 set stuff=$length(val)+10
	set out=out_$select(stuff=3:"""",1:$extract(val,2,stuff-2)),val=$extract(val,stuff,*)
	if $extract(val)="""" { set out=out_"""" goto hquote } else { goto hdefault }
hdel	set logical=logical_$listbuild(out),out="",val=$extract(val,2,*) goto hloop
hexit	set logical=logical_$listbuild(out)
	quit logical }
zconceptFiltersSet(newvalue) public {
	If '$isobject(newvalue),newvalue'="" Quit $$Error^%apiOBJ(5807,newvalue)
	If r%conceptFilters=newvalue Quit 1
	If newvalue="" Kill i%conceptFilters,r%conceptFilters Set i%conceptFilters="",r%conceptFilters="" Quit 1
	Set oref=r%conceptFilters Kill i%conceptFilters,r%conceptFilters Set i%conceptFilters="",r%conceptFilters=oref
	Set key="" For i=1:1 Set value=newvalue.GetNext(.key) Quit:key=""  Set r%conceptFilters(i)=value,i%conceptFilters(i)=""
	Quit 1 }
zconceptsBuildValueArray(value,array) public {
	Quit ##class(%Collection.ListOfObj).BuildValueArray(value,.array)
}
zconceptsCollectionToDisplay(val="",delim) public { Set:'($data(delim)#2) delim=$char(13,10)
	set odbc="",tDelimLen=$l(delim)
	for i=1:1:$listlength(val) {
		set item=$Listget(val,i)
		if item'["""",item'[delim,$length($zstrip(item,"<>W"))=$length(item) set odbc=odbc_delim_item continue
		for j=$length(item,""""):-1:2 set $piece(item,"""",j)=""""_$piece(item,"""",j)
		set odbc=odbc_delim_""""_item_""""
	}
	quit $extract(odbc,tDelimLen+1,*) }
zconceptsCollectionToOdbc(val="") public {
	set odbc=""
	for i=1:1:$listlength(val) {
		set item=$listget(val,i)
		if item'["""",item'[",",$length($zstrip(item,"<>W"))=$length(item) set odbc=odbc_","_item continue
		for j=$length(item,""""):-1:2 set $piece(item,"""",j)=""""_$piece(item,"""",j)
		set odbc=odbc_","""_item_""""
	}
	quit $extract(odbc,2,*) }
zconceptsDisplayToCollection(val="",delim) public { Set:'($data(delim)#2) delim=$char(13,10)
	set logical="",out="",tDelimLen=$l(delim)
hloop	if $extract(val,1,tDelimLen)=delim { goto hdel } if val="" { goto hexit } if $extract(val)="""" { goto hquote } goto hdefault
hdefault	set stuff=$piece(val,delim),out=out_stuff,val=$extract(val,$length(stuff)+1,*) goto hloop
hquote	set stuff=$find(val,"""",2) if stuff=0 set stuff=$length(val)+10
	set out=out_$select(stuff=3:"""",1:$extract(val,2,stuff-2)),val=$extract(val,stuff,*)
	if $extract(val)="""" { set out=out_"""" goto hquote } else { goto hdefault }
hdel	set logical=logical_$listbuild(out),out="",val=$extract(val,tDelimLen+1,*) goto hloop
hexit	set logical=logical_$listbuild(out)
	quit logical }
zconceptsGetObject(force=0) public {
	Quit $select(r%concepts="":$select(i%concepts="":"",1:$listbuild(i%concepts_"")),(''..concepts.%GetSwizzleObject(force,.oid)):oid,1:"") }
zconceptsGetObjectId(force=0) public {
	Quit $listget(..conceptsGetObject(force)) }
zconceptsGetSwizzled() public {
	Set oref=##class(%Collection.ListOfObj).%New() If oref="" Quit ""
	Set modstate=$system.CLS.GetModifiedBits() Set r%concepts=oref Do $system.CLS.SetModifiedBits(modstate)
	Set oref.ElementType="BSTS.ns1.SEConcept",oref.ElementClassType="",oref.Owner=+$this,oref.Storage=$this."concepts%i"(),oref.OrefStorage=oref.Storage+1
	Do $system.CLS.SetModified(oref,0)
	Quit oref }
zconceptsOdbcToCollection(val="") public {
	set logical="",out=""
hloop	if $extract(val)="," { goto hdel } if val="" { goto hexit } if $extract(val)="""" { goto hquote } goto hdefault
hdefault	set stuff=$piece(val,","),out=out_stuff,val=$extract(val,$length(stuff)+1,*) goto hloop
hquote	set stuff=$find(val,"""",2) if stuff=0 set stuff=$length(val)+10
	set out=out_$select(stuff=3:"""",1:$extract(val,2,stuff-2)),val=$extract(val,stuff,*)
	if $extract(val)="""" { set out=out_"""" goto hquote } else { goto hdefault }
hdel	set logical=logical_$listbuild(out),out="",val=$extract(val,2,*) goto hloop
hexit	set logical=logical_$listbuild(out)
	quit logical }
zconceptsSet(newvalue) public {
	If '$isobject(newvalue),newvalue'="" Quit $$Error^%apiOBJ(5807,newvalue)
	If r%concepts=newvalue Quit 1
	If newvalue="" Kill i%concepts,r%concepts Set i%concepts="",r%concepts="" Quit 1
	Set oref=r%concepts Kill i%concepts,r%concepts Set i%concepts="",r%concepts=oref
	Set key="" For i=1:1 Set value=newvalue.GetNext(.key) Quit:key=""  Set r%concepts(i)=value,i%concepts(i)=""
	Quit 1 }
zexcludeFilterNewObject() public {
	Set newobject=##class(BSTS.ns1.SEExcludeFilter).%New() If newobject="" Quit ""
	Set ..excludeFilter=newobject
	Quit newobject }
znamespaceIdDisplayToLogical(%val) public {
	Q $s(%val="":"",$zu(115,13)&&(%val=$c(0)):"",1:+$in(%val,"",%val)) }
znamespaceIdIsValid(%val) public {
	Quit $select($zu(115,13)&&(%val=$c(0)):1,$isvalidnum(%val,0,-2147483648,2147483647):1,'$isvalidnum(%val):$$Error^%apiOBJ(7207,%val),%val<-2147483648:$$Error^%apiOBJ(7204,%val,-2147483648),1:$$Error^%apiOBJ(7203,%val,2147483647)) }
znamespaceIdNormalize(%val) public {
	Quit $select($zu(115,13)&&(%val=$c(0)):"",1:%val\1) }
znamespaceIdXSDToLogical(%val) public {
	Q $s($tr(%val,"Ee(),.")'=%val:"",1:$number(%val,"I",-2147483648,2147483647)) }
zstatusIsValid(%val) public {
	Q $s(%val'[","&&(",A,I,D,"[(","_$select(%val=$c(0):"",1:%val)_",")):1,1:$$Error^%apiOBJ(7205,%val,",A,I,D")) }
zsubsetFiltersBuildValueArray(value,array) public {
	Quit ##class(%Collection.ListOfObj).BuildValueArray(value,.array)
}
zsubsetFiltersCollectionToDispl(val="",delim) public { Set:'($data(delim)#2) delim=$char(13,10)
	set odbc="",tDelimLen=$l(delim)
	for i=1:1:$listlength(val) {
		set item=$Listget(val,i)
		if item'["""",item'[delim,$length($zstrip(item,"<>W"))=$length(item) set odbc=odbc_delim_item continue
		for j=$length(item,""""):-1:2 set $piece(item,"""",j)=""""_$piece(item,"""",j)
		set odbc=odbc_delim_""""_item_""""
	}
	quit $extract(odbc,tDelimLen+1,*) }
zsubsetFiltersCollectionToOdbc(val="") public {
	set odbc=""
	for i=1:1:$listlength(val) {
		set item=$listget(val,i)
		if item'["""",item'[",",$length($zstrip(item,"<>W"))=$length(item) set odbc=odbc_","_item continue
		for j=$length(item,""""):-1:2 set $piece(item,"""",j)=""""_$piece(item,"""",j)
		set odbc=odbc_","""_item_""""
	}
	quit $extract(odbc,2,*) }
zsubsetFiltersDisplayToCollecti(val="",delim) public { Set:'($data(delim)#2) delim=$char(13,10)
	set logical="",out="",tDelimLen=$l(delim)
hloop	if $extract(val,1,tDelimLen)=delim { goto hdel } if val="" { goto hexit } if $extract(val)="""" { goto hquote } goto hdefault
hdefault	set stuff=$piece(val,delim),out=out_stuff,val=$extract(val,$length(stuff)+1,*) goto hloop
hquote	set stuff=$find(val,"""",2) if stuff=0 set stuff=$length(val)+10
	set out=out_$select(stuff=3:"""",1:$extract(val,2,stuff-2)),val=$extract(val,stuff,*)
	if $extract(val)="""" { set out=out_"""" goto hquote } else { goto hdefault }
hdel	set logical=logical_$listbuild(out),out="",val=$extract(val,tDelimLen+1,*) goto hloop
hexit	set logical=logical_$listbuild(out)
	quit logical }
zsubsetFiltersGetObject(force=0) public {
	Quit $select(r%subsetFilters="":$select(i%subsetFilters="":"",1:$listbuild(i%subsetFilters_"")),(''..subsetFilters.%GetSwizzleObject(force,.oid)):oid,1:"") }
zsubsetFiltersGetObjectId(force=0) public {
	Quit $listget(..subsetFiltersGetObject(force)) }
zsubsetFiltersGetSwizzled() public {
	Set oref=##class(%Collection.ListOfObj).%New() If oref="" Quit ""
	Set modstate=$system.CLS.GetModifiedBits() Set r%subsetFilters=oref Do $system.CLS.SetModifiedBits(modstate)
	Set oref.ElementType="BSTS.ns1.SESubsetFilter",oref.ElementClassType="",oref.Owner=+$this,oref.Storage=$this."subsetFilters%i"(),oref.OrefStorage=oref.Storage+1
	Do $system.CLS.SetModified(oref,0)
	Quit oref }
zsubsetFiltersOdbcToCollection(val="") public {
	set logical="",out=""
hloop	if $extract(val)="," { goto hdel } if val="" { goto hexit } if $extract(val)="""" { goto hquote } goto hdefault
hdefault	set stuff=$piece(val,","),out=out_stuff,val=$extract(val,$length(stuff)+1,*) goto hloop
hquote	set stuff=$find(val,"""",2) if stuff=0 set stuff=$length(val)+10
	set out=out_$select(stuff=3:"""",1:$extract(val,2,stuff-2)),val=$extract(val,stuff,*)
	if $extract(val)="""" { set out=out_"""" goto hquote } else { goto hdefault }
hdel	set logical=logical_$listbuild(out),out="",val=$extract(val,2,*) goto hloop
hexit	set logical=logical_$listbuild(out)
	quit logical }
zsubsetFiltersSet(newvalue) public {
	If '$isobject(newvalue),newvalue'="" Quit $$Error^%apiOBJ(5807,newvalue)
	If r%subsetFilters=newvalue Quit 1
	If newvalue="" Kill i%subsetFilters,r%subsetFilters Set i%subsetFilters="",r%subsetFilters="" Quit 1
	Set oref=r%subsetFilters Kill i%subsetFilters,r%subsetFilters Set i%subsetFilters="",r%subsetFilters=oref
	Set key="" For i=1:1 Set value=newvalue.GetNext(.key) Quit:key=""  Set r%subsetFilters(i)=value,i%subsetFilters(i)=""
	Quit 1 }
