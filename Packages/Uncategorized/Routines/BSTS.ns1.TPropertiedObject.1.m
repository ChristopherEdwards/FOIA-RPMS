 ;BSTS.ns1.TPropertiedObject.1
 ;(C)InterSystems, generated for class BSTS.ns1.TPropertiedObject.  Do NOT edit. 10/22/2016 08:53:38AM
 ;;7649504E;BSTS.ns1.TPropertiedObject
 ;
%BindExport(dev,Seen,RegisterOref,AllowedDepth,AllowedCapacity) public {
   i $d(Seen(+$this)) q 1
   Set Seen(+$this)=$this
   s sc = 1
 s proporef=..properties
   d:RegisterOref InitObjVar^%SYS.BINDSRV($this)
   i dev'="" s t=$io u dev i $zobjexport($this_"",3)+$zobjexport($this."%%OID",3)+$zobjexport($this,3)!1 u t
 If AllowedDepth>0 Set AllowedDepth = AllowedDepth - 1
 If AllowedCapacity>0 Set AllowedCapacity = AllowedCapacity - 1/1
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
%Construct(initvalue) public {
	Set m%properties=0,M%properties=0
	Quit 1 }
%ConstructCloneInit(object,deep=0,cloned,location) public {
	Set i%properties="",r%properties=""
	Set i%"%%OID"=""
	If deep>0 {
		Set key="" For  Set value=..properties.GetNext(.key) Quit:key=""  Set r%properties(key)=$select(value="":"",1:value.%ConstructClone(1,.cloned)),i%properties(key)=""
	}
	Quit 1 }
%Destruct() public {
	Try {
		If $isobject($get(r%properties))=1,$zobjcnt(r%properties)>1 Do r%properties.%Disconnect()
	} Catch { Set sc=$$Error^%apiOBJ(5002,$zerror) }
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
		Set key=$order(r%properties(key),1,Poref) Quit:key=""
		If $isobject(Poref)=1 Set:'$data(%objTX(1,+Poref)) %objTX(6,$i(%objTX(6)))=Poref
	}
exit	Quit sc }
zXMLDTD(top,format,input,dtdlist)
 Quit ##class(%XML.Implementation).XMLDTD("BSTS.ns1.TPropertiedObject",.top,.format,.input,.dtdlist)
zXMLGetSchemaImports(imports,classes)
 Quit ##class(%XML.Implementation).XMLGetSchemaImports("BSTS.ns1.TPropertiedObject",.imports,.classes)
zXMLIsObjectEmpty(ignoreNull)
 If ..namespaceId'="" Quit 0
 If ..id'="" Quit 0
 If ..name'="" Quit 0
 If ..code'="" Quit 0
 If ..revisionIn'="" Quit 0
 If ..revisionOut'="" Quit 0
 If ..properties.Count()>0 Quit 0
 Quit 1
zXMLNew(document,node,containerOref="")
	Quit (##class(BSTS.ns1.TPropertiedObject).%New())
zXMLSchema(top="",format="",namespacePrefix="",input=0,refOnly=0,schema)
 Quit ##class(%XML.Implementation).XMLSchema("BSTS.ns1.TPropertiedObject",top,format,namespacePrefix,input,refOnly,.schema)
zpropertiesBuildValueArray(value,array) public {
	Quit ##class(%Collection.ListOfObj).BuildValueArray(value,.array)
}
zpropertiesCollectionToDisplay(val="",delim) public { Set:'($data(delim)#2) delim=$char(13,10)
	set odbc="",tDelimLen=$l(delim)
	for i=1:1:$listlength(val) {
		set item=$Listget(val,i)
		if item'["""",item'[delim,$length($zstrip(item,"<>W"))=$length(item) set odbc=odbc_delim_item continue
		for j=$length(item,""""):-1:2 set $piece(item,"""",j)=""""_$piece(item,"""",j)
		set odbc=odbc_delim_""""_item_""""
	}
	quit $extract(odbc,tDelimLen+1,*) }
zpropertiesCollectionToOdbc(val="") public {
	set odbc=""
	for i=1:1:$listlength(val) {
		set item=$listget(val,i)
		if item'["""",item'[",",$length($zstrip(item,"<>W"))=$length(item) set odbc=odbc_","_item continue
		for j=$length(item,""""):-1:2 set $piece(item,"""",j)=""""_$piece(item,"""",j)
		set odbc=odbc_","""_item_""""
	}
	quit $extract(odbc,2,*) }
zpropertiesDisplayToCollection(val="",delim) public { Set:'($data(delim)#2) delim=$char(13,10)
	set logical="",out="",tDelimLen=$l(delim)
hloop	if $extract(val,1,tDelimLen)=delim { goto hdel } if val="" { goto hexit } if $extract(val)="""" { goto hquote } goto hdefault
hdefault	set stuff=$piece(val,delim),out=out_stuff,val=$extract(val,$length(stuff)+1,*) goto hloop
hquote	set stuff=$find(val,"""",2) if stuff=0 set stuff=$length(val)+10
	set out=out_$select(stuff=3:"""",1:$extract(val,2,stuff-2)),val=$extract(val,stuff,*)
	if $extract(val)="""" { set out=out_"""" goto hquote } else { goto hdefault }
hdel	set logical=logical_$listbuild(out),out="",val=$extract(val,tDelimLen+1,*) goto hloop
hexit	set logical=logical_$listbuild(out)
	quit logical }
zpropertiesGetObject(force=0) public {
	Quit $select(r%properties="":$select(i%properties="":"",1:$listbuild(i%properties_"")),(''..properties.%GetSwizzleObject(force,.oid)):oid,1:"") }
zpropertiesGetObjectId(force=0) public {
	Quit $listget(..propertiesGetObject(force)) }
zpropertiesGetSwizzled() public {
	Set oref=##class(%Collection.ListOfObj).%New() If oref="" Quit ""
	Set modstate=$system.CLS.GetModifiedBits() Set r%properties=oref Do $system.CLS.SetModifiedBits(modstate)
	Set oref.ElementType="BSTS.ns1.TProperty",oref.ElementClassType="",oref.Owner=+$this,oref.Storage=$this."properties%i"(),oref.OrefStorage=oref.Storage+1
	Do $system.CLS.SetModified(oref,0)
	Quit oref }
zpropertiesOdbcToCollection(val="") public {
	set logical="",out=""
hloop	if $extract(val)="," { goto hdel } if val="" { goto hexit } if $extract(val)="""" { goto hquote } goto hdefault
hdefault	set stuff=$piece(val,","),out=out_stuff,val=$extract(val,$length(stuff)+1,*) goto hloop
hquote	set stuff=$find(val,"""",2) if stuff=0 set stuff=$length(val)+10
	set out=out_$select(stuff=3:"""",1:$extract(val,2,stuff-2)),val=$extract(val,stuff,*)
	if $extract(val)="""" { set out=out_"""" goto hquote } else { goto hdefault }
hdel	set logical=logical_$listbuild(out),out="",val=$extract(val,2,*) goto hloop
hexit	set logical=logical_$listbuild(out)
	quit logical }
zpropertiesSet(newvalue) public {
	If '$isobject(newvalue),newvalue'="" Quit $$Error^%apiOBJ(5807,newvalue)
	If r%properties=newvalue Quit 1
	If newvalue="" Kill i%properties,r%properties Set i%properties="",r%properties="" Quit 1
	Set oref=r%properties Kill i%properties,r%properties Set i%properties="",r%properties=oref
	Set key="" For i=1:1 Set value=newvalue.GetNext(.key) Quit:key=""  Set r%properties(i)=value,i%properties(i)=""
	Quit 1 }
