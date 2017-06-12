 ;BSTS.ns1.TOntylogConcept.1
 ;(C)InterSystems, generated for class BSTS.ns1.TOntylogConcept.  Do NOT edit. 10/22/2016 08:53:40AM
 ;;5754375A;BSTS.ns1.TOntylogConcept
 ;
%BindExport(dev,Seen,RegisterOref,AllowedDepth,AllowedCapacity) public {
   i $d(Seen(+$this)) q 1
   Set Seen(+$this)=$this
   s sc = 1
 s proporef=..associations
 s proporef=..definingConcepts
 s proporef=..definingRoles
 s proporef=..inverseAssociations
 s proporef=..inverseRoles
 s proporef=..kind
 s proporef=..properties
 s proporef=..roles
 s proporef=..subconcepts
 s proporef=..superconcepts
 s proporef=..synonyms
   d:RegisterOref InitObjVar^%SYS.BINDSRV($this)
   i dev'="" s t=$io u dev i $zobjexport($this_"",3)+$zobjexport($this."%%OID",3)+$zobjexport($this,3)!1 u t
 If AllowedDepth>0 Set AllowedDepth = AllowedDepth - 1
 If AllowedCapacity>0 Set AllowedCapacity = AllowedCapacity - 1/11
 s proporef=..associations
       i proporef'="" d
  . s idx="" i proporef'="" f  s elemoref=proporef.GetNext(.idx) q:idx=""  s sc=1 i AllowedDepth'=0,AllowedCapacity'=0 s sc=elemoref.%BindExport(dev,.Seen,RegisterOref,AllowedDepth,AllowedCapacity) q:('sc)
  q:('sc) sc
       i proporef'="",dev'="" s t=$io u dev i $zobjexport(proporef_"",3)+$zobjexport(proporef."%%OID",3)+$zobjexport(proporef,3)!1 u t
       if proporef'="",dev'="" d
       . s t=$io u dev i $zobjexport(3_"",3)!1 u t
       . s t=$io u dev i $zobjexport(proporef.Count()_"",3)!1 u t
     . for i=1:1:proporef.Count()  s t=$io u dev i $zobjexport(proporef.GetAt(i)_"",3)!1 u t
 s proporef=..definingConcepts
       i proporef'="" d
  . s idx="" i proporef'="" f  s elemoref=proporef.GetNext(.idx) q:idx=""  s sc=1 i AllowedDepth'=0,AllowedCapacity'=0 s sc=elemoref.%BindExport(dev,.Seen,RegisterOref,AllowedDepth,AllowedCapacity) q:('sc)
  q:('sc) sc
       i proporef'="",dev'="" s t=$io u dev i $zobjexport(proporef_"",3)+$zobjexport(proporef."%%OID",3)+$zobjexport(proporef,3)!1 u t
       if proporef'="",dev'="" d
       . s t=$io u dev i $zobjexport(3_"",3)!1 u t
       . s t=$io u dev i $zobjexport(proporef.Count()_"",3)!1 u t
     . for i=1:1:proporef.Count()  s t=$io u dev i $zobjexport(proporef.GetAt(i)_"",3)!1 u t
 s proporef=..definingRoles
       i proporef'="" d
  . s idx="" i proporef'="" f  s elemoref=proporef.GetNext(.idx) q:idx=""  s sc=1 i AllowedDepth'=0,AllowedCapacity'=0 s sc=elemoref.%BindExport(dev,.Seen,RegisterOref,AllowedDepth,AllowedCapacity) q:('sc)
  q:('sc) sc
       i proporef'="",dev'="" s t=$io u dev i $zobjexport(proporef_"",3)+$zobjexport(proporef."%%OID",3)+$zobjexport(proporef,3)!1 u t
       if proporef'="",dev'="" d
       . s t=$io u dev i $zobjexport(3_"",3)!1 u t
       . s t=$io u dev i $zobjexport(proporef.Count()_"",3)!1 u t
     . for i=1:1:proporef.Count()  s t=$io u dev i $zobjexport(proporef.GetAt(i)_"",3)!1 u t
 s proporef=..inverseAssociations
       i proporef'="" d
  . s idx="" i proporef'="" f  s elemoref=proporef.GetNext(.idx) q:idx=""  s sc=1 i AllowedDepth'=0,AllowedCapacity'=0 s sc=elemoref.%BindExport(dev,.Seen,RegisterOref,AllowedDepth,AllowedCapacity) q:('sc)
  q:('sc) sc
       i proporef'="",dev'="" s t=$io u dev i $zobjexport(proporef_"",3)+$zobjexport(proporef."%%OID",3)+$zobjexport(proporef,3)!1 u t
       if proporef'="",dev'="" d
       . s t=$io u dev i $zobjexport(3_"",3)!1 u t
       . s t=$io u dev i $zobjexport(proporef.Count()_"",3)!1 u t
     . for i=1:1:proporef.Count()  s t=$io u dev i $zobjexport(proporef.GetAt(i)_"",3)!1 u t
 s proporef=..inverseRoles
       i proporef'="" d
  . s idx="" i proporef'="" f  s elemoref=proporef.GetNext(.idx) q:idx=""  s sc=1 i AllowedDepth'=0,AllowedCapacity'=0 s sc=elemoref.%BindExport(dev,.Seen,RegisterOref,AllowedDepth,AllowedCapacity) q:('sc)
  q:('sc) sc
       i proporef'="",dev'="" s t=$io u dev i $zobjexport(proporef_"",3)+$zobjexport(proporef."%%OID",3)+$zobjexport(proporef,3)!1 u t
       if proporef'="",dev'="" d
       . s t=$io u dev i $zobjexport(3_"",3)!1 u t
       . s t=$io u dev i $zobjexport(proporef.Count()_"",3)!1 u t
     . for i=1:1:proporef.Count()  s t=$io u dev i $zobjexport(proporef.GetAt(i)_"",3)!1 u t
 s proporef=..kind
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
 s proporef=..roles
       i proporef'="" d
  . s idx="" i proporef'="" f  s elemoref=proporef.GetNext(.idx) q:idx=""  s sc=1 i AllowedDepth'=0,AllowedCapacity'=0 s sc=elemoref.%BindExport(dev,.Seen,RegisterOref,AllowedDepth,AllowedCapacity) q:('sc)
  q:('sc) sc
       i proporef'="",dev'="" s t=$io u dev i $zobjexport(proporef_"",3)+$zobjexport(proporef."%%OID",3)+$zobjexport(proporef,3)!1 u t
       if proporef'="",dev'="" d
       . s t=$io u dev i $zobjexport(3_"",3)!1 u t
       . s t=$io u dev i $zobjexport(proporef.Count()_"",3)!1 u t
     . for i=1:1:proporef.Count()  s t=$io u dev i $zobjexport(proporef.GetAt(i)_"",3)!1 u t
 s proporef=..subconcepts
       i proporef'="" d
  . s idx="" i proporef'="" f  s elemoref=proporef.GetNext(.idx) q:idx=""  s sc=1 i AllowedDepth'=0,AllowedCapacity'=0 s sc=elemoref.%BindExport(dev,.Seen,RegisterOref,AllowedDepth,AllowedCapacity) q:('sc)
  q:('sc) sc
       i proporef'="",dev'="" s t=$io u dev i $zobjexport(proporef_"",3)+$zobjexport(proporef."%%OID",3)+$zobjexport(proporef,3)!1 u t
       if proporef'="",dev'="" d
       . s t=$io u dev i $zobjexport(3_"",3)!1 u t
       . s t=$io u dev i $zobjexport(proporef.Count()_"",3)!1 u t
     . for i=1:1:proporef.Count()  s t=$io u dev i $zobjexport(proporef.GetAt(i)_"",3)!1 u t
 s proporef=..superconcepts
       i proporef'="" d
  . s idx="" i proporef'="" f  s elemoref=proporef.GetNext(.idx) q:idx=""  s sc=1 i AllowedDepth'=0,AllowedCapacity'=0 s sc=elemoref.%BindExport(dev,.Seen,RegisterOref,AllowedDepth,AllowedCapacity) q:('sc)
  q:('sc) sc
       i proporef'="",dev'="" s t=$io u dev i $zobjexport(proporef_"",3)+$zobjexport(proporef."%%OID",3)+$zobjexport(proporef,3)!1 u t
       if proporef'="",dev'="" d
       . s t=$io u dev i $zobjexport(3_"",3)!1 u t
       . s t=$io u dev i $zobjexport(proporef.Count()_"",3)!1 u t
     . for i=1:1:proporef.Count()  s t=$io u dev i $zobjexport(proporef.GetAt(i)_"",3)!1 u t
 s proporef=..synonyms
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
	Set m%associations=0,M%associations=0,m%definingConcepts=0,M%definingConcepts=0,m%definingRoles=0,M%definingRoles=0,m%inverseAssociations=0,M%inverseAssociations=0
	Set m%inverseRoles=0,M%inverseRoles=0,m%properties=0,M%properties=0,m%roles=0,M%roles=0,m%subconcepts=0,M%subconcepts=0,m%superconcepts=0,M%superconcepts=0
	Set m%synonyms=0,M%synonyms=0
	Quit 1 }
%ConstructCloneInit(object,deep=0,cloned,location) public {
	Set i%associations="",r%associations=""
	Set i%definingConcepts="",r%definingConcepts=""
	Set i%definingRoles="",r%definingRoles=""
	Set i%inverseAssociations="",r%inverseAssociations=""
	Set i%inverseRoles="",r%inverseRoles=""
	Set i%properties="",r%properties=""
	Set i%roles="",r%roles=""
	Set i%subconcepts="",r%subconcepts=""
	Set i%superconcepts="",r%superconcepts=""
	Set i%synonyms="",r%synonyms=""
	Set i%"%%OID"=""
	If deep>0 {
		Set key="" For  Set value=..associations.GetNext(.key) Quit:key=""  Set r%associations(key)=$select(value="":"",1:value.%ConstructClone(1,.cloned)),i%associations(key)=""
		Set key="" For  Set value=..definingConcepts.GetNext(.key) Quit:key=""  Set r%definingConcepts(key)=$select(value="":"",1:value.%ConstructClone(1,.cloned)),i%definingConcepts(key)=""
		Set key="" For  Set value=..definingRoles.GetNext(.key) Quit:key=""  Set r%definingRoles(key)=$select(value="":"",1:value.%ConstructClone(1,.cloned)),i%definingRoles(key)=""
		Set key="" For  Set value=..inverseAssociations.GetNext(.key) Quit:key=""  Set r%inverseAssociations(key)=$select(value="":"",1:value.%ConstructClone(1,.cloned)),i%inverseAssociations(key)=""
		Set key="" For  Set value=..inverseRoles.GetNext(.key) Quit:key=""  Set r%inverseRoles(key)=$select(value="":"",1:value.%ConstructClone(1,.cloned)),i%inverseRoles(key)=""
		If $isobject(..kind)=1 Set r%kind=r%kind.%ConstructClone(1,.cloned),i%kind=""
		Set key="" For  Set value=..properties.GetNext(.key) Quit:key=""  Set r%properties(key)=$select(value="":"",1:value.%ConstructClone(1,.cloned)),i%properties(key)=""
		Set key="" For  Set value=..roles.GetNext(.key) Quit:key=""  Set r%roles(key)=$select(value="":"",1:value.%ConstructClone(1,.cloned)),i%roles(key)=""
		Set key="" For  Set value=..subconcepts.GetNext(.key) Quit:key=""  Set r%subconcepts(key)=$select(value="":"",1:value.%ConstructClone(1,.cloned)),i%subconcepts(key)=""
		Set key="" For  Set value=..superconcepts.GetNext(.key) Quit:key=""  Set r%superconcepts(key)=$select(value="":"",1:value.%ConstructClone(1,.cloned)),i%superconcepts(key)=""
		Set key="" For  Set value=..synonyms.GetNext(.key) Quit:key=""  Set r%synonyms(key)=$select(value="":"",1:value.%ConstructClone(1,.cloned)),i%synonyms(key)=""
	}
	Quit 1 }
%Destruct() public {
	Try {
		If $isobject($get(r%associations))=1,$zobjcnt(r%associations)>1 Do r%associations.%Disconnect()
		If $isobject($get(r%definingConcepts))=1,$zobjcnt(r%definingConcepts)>1 Do r%definingConcepts.%Disconnect()
		If $isobject($get(r%definingRoles))=1,$zobjcnt(r%definingRoles)>1 Do r%definingRoles.%Disconnect()
		If $isobject($get(r%inverseAssociations))=1,$zobjcnt(r%inverseAssociations)>1 Do r%inverseAssociations.%Disconnect()
		If $isobject($get(r%inverseRoles))=1,$zobjcnt(r%inverseRoles)>1 Do r%inverseRoles.%Disconnect()
		If $isobject($get(r%properties))=1,$zobjcnt(r%properties)>1 Do r%properties.%Disconnect()
		If $isobject($get(r%roles))=1,$zobjcnt(r%roles)>1 Do r%roles.%Disconnect()
		If $isobject($get(r%subconcepts))=1,$zobjcnt(r%subconcepts)>1 Do r%subconcepts.%Disconnect()
		If $isobject($get(r%superconcepts))=1,$zobjcnt(r%superconcepts)>1 Do r%superconcepts.%Disconnect()
		If $isobject($get(r%synonyms))=1,$zobjcnt(r%synonyms)>1 Do r%synonyms.%Disconnect()
	} Catch { Set sc=$$Error^%apiOBJ(5002,$zerror) }
	Quit 1 }
%NormalizeObject() public {
	If '$system.CLS.GetModified() Quit 1
	If m%code Set:i%code'="" i%code=(..codeNormalize(i%code))
	If m%id Set:i%id'="" i%id=(..idNormalize(i%id))
	If m%name Set:i%name'="" i%name=(..nameNormalize(i%name))
	If m%namespaceId Set:i%namespaceId'="" i%namespaceId=(..namespaceIdNormalize(i%namespaceId))
	If m%numberOfSpecifiedInverseRoles Set:i%numberOfSpecifiedInverseRoles'="" i%numberOfSpecifiedInverseRoles=(..numberOfSpecifiedInverseRolesNormalize(i%numberOfSpecifiedInverseRoles))
	If m%numberOfSpecifiedRoles Set:i%numberOfSpecifiedRoles'="" i%numberOfSpecifiedRoles=(..numberOfSpecifiedRolesNormalize(i%numberOfSpecifiedRoles))
	If m%numberOfSpecifiedSubconcepts Set:i%numberOfSpecifiedSubconcepts'="" i%numberOfSpecifiedSubconcepts=(..numberOfSpecifiedSubconceptsNormalize(i%numberOfSpecifiedSubconcepts))
	If m%numberOfSpecifiedSuperconcepts Set:i%numberOfSpecifiedSuperconcepts'="" i%numberOfSpecifiedSuperconcepts=(..numberOfSpecifiedSuperconceptsNormalize(i%numberOfSpecifiedSuperconcepts))
	If m%primitive Set:i%primitive'="" i%primitive=(..primitiveNormalize(i%primitive))
	If m%revisionIn Set:i%revisionIn'="" i%revisionIn=(..revisionInNormalize(i%revisionIn))
	If m%revisionOut Set:i%revisionOut'="" i%revisionOut=(..revisionOutNormalize(i%revisionOut))
	If m%snapshotDate Set:i%snapshotDate'="" i%snapshotDate=(..snapshotDateNormalize(i%snapshotDate))
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
		Set key=$order(r%associations(key),1,Poref) Quit:key=""
		If $isobject(Poref)=1 Set:'$data(%objTX(1,+Poref)) %objTX(6,$i(%objTX(6)))=Poref
	}
	Set key=""
	For  {
		Set key=$order(r%definingConcepts(key),1,Poref) Quit:key=""
		If $isobject(Poref)=1 Set:'$data(%objTX(1,+Poref)) %objTX(6,$i(%objTX(6)))=Poref
	}
	Set key=""
	For  {
		Set key=$order(r%definingRoles(key),1,Poref) Quit:key=""
		If $isobject(Poref)=1 Set:'$data(%objTX(1,+Poref)) %objTX(6,$i(%objTX(6)))=Poref
	}
	Set key=""
	For  {
		Set key=$order(r%inverseAssociations(key),1,Poref) Quit:key=""
		If $isobject(Poref)=1 Set:'$data(%objTX(1,+Poref)) %objTX(6,$i(%objTX(6)))=Poref
	}
	Set key=""
	For  {
		Set key=$order(r%inverseRoles(key),1,Poref) Quit:key=""
		If $isobject(Poref)=1 Set:'$data(%objTX(1,+Poref)) %objTX(6,$i(%objTX(6)))=Poref
	}
	Set Poref=r%kind If Poref'="",'$data(%objTX(1,+Poref)) Set %objTX(6,$i(%objTX(6)))=Poref
	Set key=""
	For  {
		Set key=$order(r%properties(key),1,Poref) Quit:key=""
		If $isobject(Poref)=1 Set:'$data(%objTX(1,+Poref)) %objTX(6,$i(%objTX(6)))=Poref
	}
	Set key=""
	For  {
		Set key=$order(r%roles(key),1,Poref) Quit:key=""
		If $isobject(Poref)=1 Set:'$data(%objTX(1,+Poref)) %objTX(6,$i(%objTX(6)))=Poref
	}
	Set key=""
	For  {
		Set key=$order(r%subconcepts(key),1,Poref) Quit:key=""
		If $isobject(Poref)=1 Set:'$data(%objTX(1,+Poref)) %objTX(6,$i(%objTX(6)))=Poref
	}
	Set key=""
	For  {
		Set key=$order(r%superconcepts(key),1,Poref) Quit:key=""
		If $isobject(Poref)=1 Set:'$data(%objTX(1,+Poref)) %objTX(6,$i(%objTX(6)))=Poref
	}
	Set key=""
	For  {
		Set key=$order(r%synonyms(key),1,Poref) Quit:key=""
		If $isobject(Poref)=1 Set:'$data(%objTX(1,+Poref)) %objTX(6,$i(%objTX(6)))=Poref
	}
exit	Quit sc }
%ValidateObject(force=0) public {
	Set sc=1
	If '$system.CLS.GetModified() Quit sc
	Set iv=..code If iv="" Set rc=$$Error^%apiOBJ(5659,$classname()_"::"_"code"_"("_$this_",ID="),sc=$select(+sc:rc,1:$$AppendStatus^%occSystem(sc,rc))
	If m%code Set rc=(..codeIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"code",iv)
	Set iv=..id If iv="" Set rc=$$Error^%apiOBJ(5659,$classname()_"::"_"id"_"("_$this_",ID="),sc=$select(+sc:rc,1:$$AppendStatus^%occSystem(sc,rc))
	If m%id Set rc=(..idIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"id",iv)
	If m%name Set iv=..name If iv'="" Set rc=(..nameIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"name",iv)
	Set iv=..namespaceId If iv="" Set rc=$$Error^%apiOBJ(5659,$classname()_"::"_"namespaceId"_"("_$this_",ID="),sc=$select(+sc:rc,1:$$AppendStatus^%occSystem(sc,rc))
	If m%namespaceId Set rc=(..namespaceIdIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"namespaceId",iv)
	Set iv=..numberOfSpecifiedInverseRoles If iv="" Set rc=$$Error^%apiOBJ(5659,$classname()_"::"_"numberOfSpecifiedInverseRoles"_"("_$this_",ID="),sc=$select(+sc:rc,1:$$AppendStatus^%occSystem(sc,rc))
	If m%numberOfSpecifiedInverseRoles Set rc=(..numberOfSpecifiedInverseRolesIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"numberOfSpecifiedInverseRoles",iv)
	Set iv=..numberOfSpecifiedRoles If iv="" Set rc=$$Error^%apiOBJ(5659,$classname()_"::"_"numberOfSpecifiedRoles"_"("_$this_",ID="),sc=$select(+sc:rc,1:$$AppendStatus^%occSystem(sc,rc))
	If m%numberOfSpecifiedRoles Set rc=(..numberOfSpecifiedRolesIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"numberOfSpecifiedRoles",iv)
	Set iv=..numberOfSpecifiedSubconcepts If iv="" Set rc=$$Error^%apiOBJ(5659,$classname()_"::"_"numberOfSpecifiedSubconcepts"_"("_$this_",ID="),sc=$select(+sc:rc,1:$$AppendStatus^%occSystem(sc,rc))
	If m%numberOfSpecifiedSubconcepts Set rc=(..numberOfSpecifiedSubconceptsIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"numberOfSpecifiedSubconcepts",iv)
	Set iv=..numberOfSpecifiedSuperconcepts If iv="" Set rc=$$Error^%apiOBJ(5659,$classname()_"::"_"numberOfSpecifiedSuperconcepts"_"("_$this_",ID="),sc=$select(+sc:rc,1:$$AppendStatus^%occSystem(sc,rc))
	If m%numberOfSpecifiedSuperconcepts Set rc=(..numberOfSpecifiedSuperconceptsIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"numberOfSpecifiedSuperconcepts",iv)
	Set iv=..primitive If iv="" Set rc=$$Error^%apiOBJ(5659,$classname()_"::"_"primitive"_"("_$this_",ID="),sc=$select(+sc:rc,1:$$AppendStatus^%occSystem(sc,rc))
	If m%primitive Set rc=(..primitiveIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"primitive",iv)
	If m%revisionIn Set iv=..revisionIn If iv'="" Set rc=(..revisionInIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"revisionIn",iv)
	If m%revisionOut Set iv=..revisionOut If iv'="" Set rc=(..revisionOutIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"revisionOut",iv)
	If m%snapshotDate Set iv=..snapshotDate If iv'="" Set rc=(..snapshotDateIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"snapshotDate",iv)
	Set iv=..status If iv="" Set rc=$$Error^%apiOBJ(5659,$classname()_"::"_"status"_"("_$this_",ID="),sc=$select(+sc:rc,1:$$AppendStatus^%occSystem(sc,rc))
	If m%status Set rc=(..statusIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"status",iv)
	Quit sc }
zXMLDTD(top,format,input,dtdlist)
 Quit ##class(%XML.Implementation).XMLDTD("BSTS.ns1.TOntylogConcept",.top,.format,.input,.dtdlist)
zXMLExportInternal()
 New tag,summary,attrsVal,savelocal,aval,k,tmpPrefix,prefixDepth,hasNoContent,hasElement,topAttrs,beginprefix,endprefix,savexsiAttrs,initialxsiAttrs,initlist,initialCR,inlineFlag,popAtEnd,saveTopPrefix,saveTypesPrefix,saveAttrsPrefix,saveUsePrefix,initlist
 Set $ztrap="XMLExportInternalTrap",popAtEnd=0
 Set summary=summaryArg,initialxsiAttrs=xsiAttrs
 If group Quit $$Error^%apiOBJ(6386,"BSTS.ns1.TOntylogConcept")
 If indentFlag Set initialCR=($extract(currentIndent,1,2)=$c(13,10))
 Set id=createId
 Set temp=""
 If id'="" {
   If $piece($get(idlist(+$this)),",",2)'="" Quit 1
   Set idlist(+$this)=id_",1"
 }
 If encoded Set initlist=$lb($get(oreflist),inlineFlagArg),oreflist=1,inlineFlag=inlineFlagArg
 If 'nocycle,('encoded||inlineFlag) {
   If $data(oreflist($this)) Quit $$Error^%apiOBJ(6296,"BSTS.ns1.TOntylogConcept")
   Set oreflist($this)=""
 }
 Set tag=$get(topArg)
 Set tmpi=(($get(typeAttr)'="")&&(typeAttr'="BSTS.ns1.TOntylogConcept"))
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
   If tag="" Set tag="TOntylogConcept"
   Set xsitype=namespaces.OutputTypeAttribute
 } Else {
   Set saveTopPrefix=topPrefix,saveTypesPrefix=typesPrefix,saveAttrsPrefix=attrsPrefix,saveUsePrefix=usePrefix
   Set typesPrefix=namespaces If (typesPrefix'=""),($extract(typesPrefix,*)'=":") Set typesPrefix=typesPrefix_":"
   If 'encoded Set namespaces=""
   Set (topPrefix,attrsPrefix,topAttrs,beginprefix)=""
   If tag="" Set tag=typesPrefix_"TOntylogConcept"
   Set xsitype=0
 }
 Set local=+$get(local),savelocal=local
 Set endprefix="</"_beginprefix,beginprefix="<"_beginprefix
 If tmpi Set temp=temp_" "_xsiPrefix_"type="""_typesPrefix_"TOntylogConcept"""_xsiAttrs,xsiAttrs=""
   If id'="" Set temp=" "_$select($get(soap12):soapPrefix_"id",1:"id")_"=""id"_id_""""_temp
 If encoded Set temp=temp_xsiAttrs,xsiAttrs=""
 If indentFlag Set %xmlmsg=currentIndent if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg } Set currentIndent=$select(initialCR:"",1:$c(13,10))_currentIndent_indentChars
 If tag[":" Set topPrefix=$piece(tag,":"),tag=$piece(tag,":",2)  If topPrefix'="" Set topPrefix=topPrefix_":"
 Set %xmlmsg="<"_topPrefix_tag_temp if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set attrsVal=attrsArg,attrsArg="" Set %xmlmsg=attrsVal if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set %xmlmsg=">" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..namespaceId
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"namespaceId"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"int""",1:"")_">"_val_endprefix_"namespaceId>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..id
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"id"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"int""",1:"")_">"_val_endprefix_"id>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..name
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"name"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"string""",1:"")_">"_$select(val=$c(0):"",1:$select((val["<")||(val[">")||(val["&"):"<![CDATA["_$replace(val,"]]>","]]]]><![CDATA[>")_"]]>",1:val))_endprefix_"name>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..code
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"code"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"string""",1:"")_">"_$select(val=$c(0):"",1:$select((val["<")||(val[">")||(val["&"):"<![CDATA["_$replace(val,"]]>","]]]]><![CDATA[>")_"]]>",1:val))_endprefix_"code>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..revisionIn
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"revisionIn"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"dateTime""",1:"")_">"_$select(val="":"",1:$translate(val," ","T")_"Z")_endprefix_"revisionIn>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..revisionOut
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"revisionOut"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"dateTime""",1:"")_">"_$select(val="":"",1:$translate(val," ","T")_"Z")_endprefix_"revisionOut>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..status
 If val'="" {
   Set temp="",temp1=$parameter("BSTS.ns1.TItemStatus","NAMESPACE")
   Set temp1=$select((temp1'="http://apelon.com/dtsserver/types")&&$IsObject(namespaces):namespaces.GetNamespacePrefix(temp1,.temp),1:typesPrefix)
   Set %xmlmsg=currentIndent_beginprefix_"status"_$select(xsitype:" "_xsiPrefix_"type="""_temp1_"TItemStatus"""_temp,1:"")_">"_$select(val=$c(0):"",1:$select((val["<")||(val[">")||(val["&"):"<![CDATA["_$replace(val,"]]>","]]]]><![CDATA[>")_"]]>",1:val))_endprefix_"status>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..snapshotDate
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"snapshotDate"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"dateTime""",1:"")_">"_$select(val="":"",1:$translate(val," ","T")_"Z")_endprefix_"snapshotDate>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
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
 Set aval=..associations
 Set k="" Set:deepFlag val=aval.GetNext(.k) If k'="" {
   If encoded {
     If indentFlag Set %xmlmsg=currentIndent Set currentIndent=currentIndent_indentChars if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     Set temp="",temp1=$parameter("BSTS.ns1.TConceptAssociation","NAMESPACE")
     Set temp1=$select((temp1'="http://apelon.com/dtsserver/types")&&$IsObject(namespaces):namespaces.GetNamespacePrefix(temp1,.temp),1:typesPrefix)
     If soap12 { Set %xmlmsg=beginprefix_"associations"_$select(xsitype:"",1:" "_soapPrefix_"itemType="""_temp1_$select($parameter("BSTS.ns1.TConceptAssociation","XMLSUMMARY")'="":"s_TConceptAssociation",1:"TConceptAssociation")_"""")_" "_soapPrefix_"arraySize="""_aval.Count()_""""_""_temp_">" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     } Else { Set %xmlmsg=beginprefix_"associations "_$select(xsitype:xsiPrefix_"type="""_soapPrefix_"Array""",1:soapPrefix_"arrayType="""_temp1_$select($parameter("BSTS.ns1.TConceptAssociation","XMLSUMMARY")'="":"s_TConceptAssociation",1:"TConceptAssociation")_"["_aval.Count()_"]""")_""_temp_">" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg } }
   }
   While k'="" {
     If $IsObject(val) {
       Set id=""
       If encoded,'inlineFlag {
         Set temp=$select($parameter("BSTS.ns1.TConceptAssociation","XMLSUMMARY")'="":-1,1:1)
         Set id=+$get(idlist(temp*val))
         If 'soap12 , (id=0) Set id=$increment(idlist),oreflist(temp*id)=val,idlist(temp*val)=id
       }
       If +id'=0 {
         Set %xmlmsg=currentIndent_beginprefix_"associations "_$select(soap12:soapPrefix_"ref=""",1:"href=""#")_"id"_id_""" />" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
       } Else { if id=0 Set id=$increment(idlist)
         Set topArg="associations",summaryArg=1,group=0,createId=$get(id),typeAttr=$select(encoded||xsitype:"*",1:"BSTS.ns1.TConceptAssociation"),local=1,savexsiAttrs=xsiAttrs
         Set sc=val.XMLExportInternal() Goto:'sc XMLExportExit Set xsiAttrs=savexsiAttrs
       }
     } Else {
       Set %xmlmsg=currentIndent_beginprefix_"associations "_xsiPrefix_"nil=""true"""_xsiAttrs_"/>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     }
     Set val=aval.GetNext(.k)
   }
   If encoded {
     If indentFlag Set currentIndent=$extract(currentIndent,1,*-$length(indentChars)) Set %xmlmsg=currentIndent if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     Set %xmlmsg=endprefix_"associations>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
   }
 }
 Set aval=..inverseAssociations
 Set k="" Set:deepFlag val=aval.GetNext(.k) If k'="" {
   If encoded {
     If indentFlag Set %xmlmsg=currentIndent Set currentIndent=currentIndent_indentChars if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     Set temp="",temp1=$parameter("BSTS.ns1.TConceptAssociation","NAMESPACE")
     Set temp1=$select((temp1'="http://apelon.com/dtsserver/types")&&$IsObject(namespaces):namespaces.GetNamespacePrefix(temp1,.temp),1:typesPrefix)
     If soap12 { Set %xmlmsg=beginprefix_"inverseAssociations"_$select(xsitype:"",1:" "_soapPrefix_"itemType="""_temp1_$select($parameter("BSTS.ns1.TConceptAssociation","XMLSUMMARY")'="":"s_TConceptAssociation",1:"TConceptAssociation")_"""")_" "_soapPrefix_"arraySize="""_aval.Count()_""""_""_temp_">" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     } Else { Set %xmlmsg=beginprefix_"inverseAssociations "_$select(xsitype:xsiPrefix_"type="""_soapPrefix_"Array""",1:soapPrefix_"arrayType="""_temp1_$select($parameter("BSTS.ns1.TConceptAssociation","XMLSUMMARY")'="":"s_TConceptAssociation",1:"TConceptAssociation")_"["_aval.Count()_"]""")_""_temp_">" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg } }
   }
   While k'="" {
     If $IsObject(val) {
       Set id=""
       If encoded,'inlineFlag {
         Set temp=$select($parameter("BSTS.ns1.TConceptAssociation","XMLSUMMARY")'="":-1,1:1)
         Set id=+$get(idlist(temp*val))
         If 'soap12 , (id=0) Set id=$increment(idlist),oreflist(temp*id)=val,idlist(temp*val)=id
       }
       If +id'=0 {
         Set %xmlmsg=currentIndent_beginprefix_"inverseAssociations "_$select(soap12:soapPrefix_"ref=""",1:"href=""#")_"id"_id_""" />" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
       } Else { if id=0 Set id=$increment(idlist)
         Set topArg="inverseAssociations",summaryArg=1,group=0,createId=$get(id),typeAttr=$select(encoded||xsitype:"*",1:"BSTS.ns1.TConceptAssociation"),local=1,savexsiAttrs=xsiAttrs
         Set sc=val.XMLExportInternal() Goto:'sc XMLExportExit Set xsiAttrs=savexsiAttrs
       }
     } Else {
       Set %xmlmsg=currentIndent_beginprefix_"inverseAssociations "_xsiPrefix_"nil=""true"""_xsiAttrs_"/>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     }
     Set val=aval.GetNext(.k)
   }
   If encoded {
     If indentFlag Set currentIndent=$extract(currentIndent,1,*-$length(indentChars)) Set %xmlmsg=currentIndent if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     Set %xmlmsg=endprefix_"inverseAssociations>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
   }
 }
 Set aval=..synonyms
 Set k="" Set:deepFlag val=aval.GetNext(.k) If k'="" {
   If encoded {
     If indentFlag Set %xmlmsg=currentIndent Set currentIndent=currentIndent_indentChars if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     Set temp="",temp1=$parameter("BSTS.ns1.TSynonym","NAMESPACE")
     Set temp1=$select((temp1'="http://apelon.com/dtsserver/types")&&$IsObject(namespaces):namespaces.GetNamespacePrefix(temp1,.temp),1:typesPrefix)
     If soap12 { Set %xmlmsg=beginprefix_"synonyms"_$select(xsitype:"",1:" "_soapPrefix_"itemType="""_temp1_$select($parameter("BSTS.ns1.TSynonym","XMLSUMMARY")'="":"s_TSynonym",1:"TSynonym")_"""")_" "_soapPrefix_"arraySize="""_aval.Count()_""""_""_temp_">" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     } Else { Set %xmlmsg=beginprefix_"synonyms "_$select(xsitype:xsiPrefix_"type="""_soapPrefix_"Array""",1:soapPrefix_"arrayType="""_temp1_$select($parameter("BSTS.ns1.TSynonym","XMLSUMMARY")'="":"s_TSynonym",1:"TSynonym")_"["_aval.Count()_"]""")_""_temp_">" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg } }
   }
   While k'="" {
     If $IsObject(val) {
       Set id=""
       If encoded,'inlineFlag {
         Set temp=$select($parameter("BSTS.ns1.TSynonym","XMLSUMMARY")'="":-1,1:1)
         Set id=+$get(idlist(temp*val))
         If 'soap12 , (id=0) Set id=$increment(idlist),oreflist(temp*id)=val,idlist(temp*val)=id
       }
       If +id'=0 {
         Set %xmlmsg=currentIndent_beginprefix_"synonyms "_$select(soap12:soapPrefix_"ref=""",1:"href=""#")_"id"_id_""" />" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
       } Else { if id=0 Set id=$increment(idlist)
         Set topArg="synonyms",summaryArg=1,group=0,createId=$get(id),typeAttr=$select(encoded||xsitype:"*",1:"BSTS.ns1.TSynonym"),local=1,savexsiAttrs=xsiAttrs
         Set sc=val.XMLExportInternal() Goto:'sc XMLExportExit Set xsiAttrs=savexsiAttrs
       }
     } Else {
       Set %xmlmsg=currentIndent_beginprefix_"synonyms "_xsiPrefix_"nil=""true"""_xsiAttrs_"/>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     }
     Set val=aval.GetNext(.k)
   }
   If encoded {
     If indentFlag Set currentIndent=$extract(currentIndent,1,*-$length(indentChars)) Set %xmlmsg=currentIndent if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     Set %xmlmsg=endprefix_"synonyms>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
   }
 }
 Set val=..kind
 If $IsObject(val) , deepFlag {
   Set id=""
   If encoded,'inlineFlag {
     Set temp=$select($parameter("BSTS.ns1.TKind","XMLSUMMARY")'="":-1,1:1)
     Set id=+$get(idlist(temp*val))
     If 'soap12 , (id=0) Set id=$increment(idlist),oreflist(temp*id)=val,idlist(temp*val)=id
   }
   If +id'=0 {
     Set %xmlmsg=currentIndent_beginprefix_"kind "_$select(soap12:soapPrefix_"ref=""",1:"href=""#")_"id"_id_""" />" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
   } Else { if id=0 Set id=$increment(idlist)
     Set topArg="kind",summaryArg=1,group=0,createId=$get(id),typeAttr=$select(encoded||xsitype:"*",1:"BSTS.ns1.TKind"),local=1,savexsiAttrs=xsiAttrs
     Set sc=val.XMLExportInternal() Goto:'sc XMLExportExit Set xsiAttrs=savexsiAttrs
   }
 }
 Set val=..primitive
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"primitive"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"boolean""",1:"")_">"_$s(val:"true",1:"false")_endprefix_"primitive>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set aval=..subconcepts
 Set k="" Set:deepFlag val=aval.GetNext(.k) If k'="" {
   If encoded {
     If indentFlag Set %xmlmsg=currentIndent Set currentIndent=currentIndent_indentChars if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     Set temp="",temp1=$parameter("BSTS.ns1.TConceptNav","NAMESPACE")
     Set temp1=$select((temp1'="http://apelon.com/dtsserver/types")&&$IsObject(namespaces):namespaces.GetNamespacePrefix(temp1,.temp),1:typesPrefix)
     If soap12 { Set %xmlmsg=beginprefix_"subconcepts"_$select(xsitype:"",1:" "_soapPrefix_"itemType="""_temp1_$select($parameter("BSTS.ns1.TConceptNav","XMLSUMMARY")'="":"s_TConceptNav",1:"TConceptNav")_"""")_" "_soapPrefix_"arraySize="""_aval.Count()_""""_""_temp_">" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     } Else { Set %xmlmsg=beginprefix_"subconcepts "_$select(xsitype:xsiPrefix_"type="""_soapPrefix_"Array""",1:soapPrefix_"arrayType="""_temp1_$select($parameter("BSTS.ns1.TConceptNav","XMLSUMMARY")'="":"s_TConceptNav",1:"TConceptNav")_"["_aval.Count()_"]""")_""_temp_">" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg } }
   }
   While k'="" {
     If $IsObject(val) {
       Set id=""
       If encoded,'inlineFlag {
         Set temp=$select($parameter("BSTS.ns1.TConceptNav","XMLSUMMARY")'="":-1,1:1)
         Set id=+$get(idlist(temp*val))
         If 'soap12 , (id=0) Set id=$increment(idlist),oreflist(temp*id)=val,idlist(temp*val)=id
       }
       If +id'=0 {
         Set %xmlmsg=currentIndent_beginprefix_"subconcepts "_$select(soap12:soapPrefix_"ref=""",1:"href=""#")_"id"_id_""" />" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
       } Else { if id=0 Set id=$increment(idlist)
         Set topArg="subconcepts",summaryArg=1,group=0,createId=$get(id),typeAttr=$select(encoded||xsitype:"*",1:"BSTS.ns1.TConceptNav"),local=1,savexsiAttrs=xsiAttrs
         Set sc=val.XMLExportInternal() Goto:'sc XMLExportExit Set xsiAttrs=savexsiAttrs
       }
     } Else {
       Set %xmlmsg=currentIndent_beginprefix_"subconcepts "_xsiPrefix_"nil=""true"""_xsiAttrs_"/>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     }
     Set val=aval.GetNext(.k)
   }
   If encoded {
     If indentFlag Set currentIndent=$extract(currentIndent,1,*-$length(indentChars)) Set %xmlmsg=currentIndent if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     Set %xmlmsg=endprefix_"subconcepts>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
   }
 }
 Set aval=..superconcepts
 Set k="" Set:deepFlag val=aval.GetNext(.k) If k'="" {
   If encoded {
     If indentFlag Set %xmlmsg=currentIndent Set currentIndent=currentIndent_indentChars if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     Set temp="",temp1=$parameter("BSTS.ns1.TConceptNav","NAMESPACE")
     Set temp1=$select((temp1'="http://apelon.com/dtsserver/types")&&$IsObject(namespaces):namespaces.GetNamespacePrefix(temp1,.temp),1:typesPrefix)
     If soap12 { Set %xmlmsg=beginprefix_"superconcepts"_$select(xsitype:"",1:" "_soapPrefix_"itemType="""_temp1_$select($parameter("BSTS.ns1.TConceptNav","XMLSUMMARY")'="":"s_TConceptNav",1:"TConceptNav")_"""")_" "_soapPrefix_"arraySize="""_aval.Count()_""""_""_temp_">" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     } Else { Set %xmlmsg=beginprefix_"superconcepts "_$select(xsitype:xsiPrefix_"type="""_soapPrefix_"Array""",1:soapPrefix_"arrayType="""_temp1_$select($parameter("BSTS.ns1.TConceptNav","XMLSUMMARY")'="":"s_TConceptNav",1:"TConceptNav")_"["_aval.Count()_"]""")_""_temp_">" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg } }
   }
   While k'="" {
     If $IsObject(val) {
       Set id=""
       If encoded,'inlineFlag {
         Set temp=$select($parameter("BSTS.ns1.TConceptNav","XMLSUMMARY")'="":-1,1:1)
         Set id=+$get(idlist(temp*val))
         If 'soap12 , (id=0) Set id=$increment(idlist),oreflist(temp*id)=val,idlist(temp*val)=id
       }
       If +id'=0 {
         Set %xmlmsg=currentIndent_beginprefix_"superconcepts "_$select(soap12:soapPrefix_"ref=""",1:"href=""#")_"id"_id_""" />" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
       } Else { if id=0 Set id=$increment(idlist)
         Set topArg="superconcepts",summaryArg=1,group=0,createId=$get(id),typeAttr=$select(encoded||xsitype:"*",1:"BSTS.ns1.TConceptNav"),local=1,savexsiAttrs=xsiAttrs
         Set sc=val.XMLExportInternal() Goto:'sc XMLExportExit Set xsiAttrs=savexsiAttrs
       }
     } Else {
       Set %xmlmsg=currentIndent_beginprefix_"superconcepts "_xsiPrefix_"nil=""true"""_xsiAttrs_"/>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     }
     Set val=aval.GetNext(.k)
   }
   If encoded {
     If indentFlag Set currentIndent=$extract(currentIndent,1,*-$length(indentChars)) Set %xmlmsg=currentIndent if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     Set %xmlmsg=endprefix_"superconcepts>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
   }
 }
 Set aval=..roles
 Set k="" Set:deepFlag val=aval.GetNext(.k) If k'="" {
   If encoded {
     If indentFlag Set %xmlmsg=currentIndent Set currentIndent=currentIndent_indentChars if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     Set temp="",temp1=$parameter("BSTS.ns1.TRole","NAMESPACE")
     Set temp1=$select((temp1'="http://apelon.com/dtsserver/types")&&$IsObject(namespaces):namespaces.GetNamespacePrefix(temp1,.temp),1:typesPrefix)
     If soap12 { Set %xmlmsg=beginprefix_"roles"_$select(xsitype:"",1:" "_soapPrefix_"itemType="""_temp1_$select($parameter("BSTS.ns1.TRole","XMLSUMMARY")'="":"s_TRole",1:"TRole")_"""")_" "_soapPrefix_"arraySize="""_aval.Count()_""""_""_temp_">" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     } Else { Set %xmlmsg=beginprefix_"roles "_$select(xsitype:xsiPrefix_"type="""_soapPrefix_"Array""",1:soapPrefix_"arrayType="""_temp1_$select($parameter("BSTS.ns1.TRole","XMLSUMMARY")'="":"s_TRole",1:"TRole")_"["_aval.Count()_"]""")_""_temp_">" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg } }
   }
   While k'="" {
     If $IsObject(val) {
       Set id=""
       If encoded,'inlineFlag {
         Set temp=$select($parameter("BSTS.ns1.TRole","XMLSUMMARY")'="":-1,1:1)
         Set id=+$get(idlist(temp*val))
         If 'soap12 , (id=0) Set id=$increment(idlist),oreflist(temp*id)=val,idlist(temp*val)=id
       }
       If +id'=0 {
         Set %xmlmsg=currentIndent_beginprefix_"roles "_$select(soap12:soapPrefix_"ref=""",1:"href=""#")_"id"_id_""" />" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
       } Else { if id=0 Set id=$increment(idlist)
         Set topArg="roles",summaryArg=1,group=0,createId=$get(id),typeAttr=$select(encoded||xsitype:"*",1:"BSTS.ns1.TRole"),local=1,savexsiAttrs=xsiAttrs
         Set sc=val.XMLExportInternal() Goto:'sc XMLExportExit Set xsiAttrs=savexsiAttrs
       }
     } Else {
       Set %xmlmsg=currentIndent_beginprefix_"roles "_xsiPrefix_"nil=""true"""_xsiAttrs_"/>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     }
     Set val=aval.GetNext(.k)
   }
   If encoded {
     If indentFlag Set currentIndent=$extract(currentIndent,1,*-$length(indentChars)) Set %xmlmsg=currentIndent if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     Set %xmlmsg=endprefix_"roles>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
   }
 }
 Set aval=..inverseRoles
 Set k="" Set:deepFlag val=aval.GetNext(.k) If k'="" {
   If encoded {
     If indentFlag Set %xmlmsg=currentIndent Set currentIndent=currentIndent_indentChars if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     Set temp="",temp1=$parameter("BSTS.ns1.TRole","NAMESPACE")
     Set temp1=$select((temp1'="http://apelon.com/dtsserver/types")&&$IsObject(namespaces):namespaces.GetNamespacePrefix(temp1,.temp),1:typesPrefix)
     If soap12 { Set %xmlmsg=beginprefix_"inverseRoles"_$select(xsitype:"",1:" "_soapPrefix_"itemType="""_temp1_$select($parameter("BSTS.ns1.TRole","XMLSUMMARY")'="":"s_TRole",1:"TRole")_"""")_" "_soapPrefix_"arraySize="""_aval.Count()_""""_""_temp_">" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     } Else { Set %xmlmsg=beginprefix_"inverseRoles "_$select(xsitype:xsiPrefix_"type="""_soapPrefix_"Array""",1:soapPrefix_"arrayType="""_temp1_$select($parameter("BSTS.ns1.TRole","XMLSUMMARY")'="":"s_TRole",1:"TRole")_"["_aval.Count()_"]""")_""_temp_">" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg } }
   }
   While k'="" {
     If $IsObject(val) {
       Set id=""
       If encoded,'inlineFlag {
         Set temp=$select($parameter("BSTS.ns1.TRole","XMLSUMMARY")'="":-1,1:1)
         Set id=+$get(idlist(temp*val))
         If 'soap12 , (id=0) Set id=$increment(idlist),oreflist(temp*id)=val,idlist(temp*val)=id
       }
       If +id'=0 {
         Set %xmlmsg=currentIndent_beginprefix_"inverseRoles "_$select(soap12:soapPrefix_"ref=""",1:"href=""#")_"id"_id_""" />" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
       } Else { if id=0 Set id=$increment(idlist)
         Set topArg="inverseRoles",summaryArg=1,group=0,createId=$get(id),typeAttr=$select(encoded||xsitype:"*",1:"BSTS.ns1.TRole"),local=1,savexsiAttrs=xsiAttrs
         Set sc=val.XMLExportInternal() Goto:'sc XMLExportExit Set xsiAttrs=savexsiAttrs
       }
     } Else {
       Set %xmlmsg=currentIndent_beginprefix_"inverseRoles "_xsiPrefix_"nil=""true"""_xsiAttrs_"/>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     }
     Set val=aval.GetNext(.k)
   }
   If encoded {
     If indentFlag Set currentIndent=$extract(currentIndent,1,*-$length(indentChars)) Set %xmlmsg=currentIndent if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     Set %xmlmsg=endprefix_"inverseRoles>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
   }
 }
 Set aval=..definingConcepts
 Set k="" Set:deepFlag val=aval.GetNext(.k) If k'="" {
   If encoded {
     If indentFlag Set %xmlmsg=currentIndent Set currentIndent=currentIndent_indentChars if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     Set temp="",temp1=$parameter("BSTS.ns1.TConceptNav","NAMESPACE")
     Set temp1=$select((temp1'="http://apelon.com/dtsserver/types")&&$IsObject(namespaces):namespaces.GetNamespacePrefix(temp1,.temp),1:typesPrefix)
     If soap12 { Set %xmlmsg=beginprefix_"definingConcepts"_$select(xsitype:"",1:" "_soapPrefix_"itemType="""_temp1_$select($parameter("BSTS.ns1.TConceptNav","XMLSUMMARY")'="":"s_TConceptNav",1:"TConceptNav")_"""")_" "_soapPrefix_"arraySize="""_aval.Count()_""""_""_temp_">" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     } Else { Set %xmlmsg=beginprefix_"definingConcepts "_$select(xsitype:xsiPrefix_"type="""_soapPrefix_"Array""",1:soapPrefix_"arrayType="""_temp1_$select($parameter("BSTS.ns1.TConceptNav","XMLSUMMARY")'="":"s_TConceptNav",1:"TConceptNav")_"["_aval.Count()_"]""")_""_temp_">" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg } }
   }
   While k'="" {
     If $IsObject(val) {
       Set id=""
       If encoded,'inlineFlag {
         Set temp=$select($parameter("BSTS.ns1.TConceptNav","XMLSUMMARY")'="":-1,1:1)
         Set id=+$get(idlist(temp*val))
         If 'soap12 , (id=0) Set id=$increment(idlist),oreflist(temp*id)=val,idlist(temp*val)=id
       }
       If +id'=0 {
         Set %xmlmsg=currentIndent_beginprefix_"definingConcepts "_$select(soap12:soapPrefix_"ref=""",1:"href=""#")_"id"_id_""" />" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
       } Else { if id=0 Set id=$increment(idlist)
         Set topArg="definingConcepts",summaryArg=1,group=0,createId=$get(id),typeAttr=$select(encoded||xsitype:"*",1:"BSTS.ns1.TConceptNav"),local=1,savexsiAttrs=xsiAttrs
         Set sc=val.XMLExportInternal() Goto:'sc XMLExportExit Set xsiAttrs=savexsiAttrs
       }
     } Else {
       Set %xmlmsg=currentIndent_beginprefix_"definingConcepts "_xsiPrefix_"nil=""true"""_xsiAttrs_"/>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     }
     Set val=aval.GetNext(.k)
   }
   If encoded {
     If indentFlag Set currentIndent=$extract(currentIndent,1,*-$length(indentChars)) Set %xmlmsg=currentIndent if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     Set %xmlmsg=endprefix_"definingConcepts>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
   }
 }
 Set aval=..definingRoles
 Set k="" Set:deepFlag val=aval.GetNext(.k) If k'="" {
   If encoded {
     If indentFlag Set %xmlmsg=currentIndent Set currentIndent=currentIndent_indentChars if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     Set temp="",temp1=$parameter("BSTS.ns1.TRole","NAMESPACE")
     Set temp1=$select((temp1'="http://apelon.com/dtsserver/types")&&$IsObject(namespaces):namespaces.GetNamespacePrefix(temp1,.temp),1:typesPrefix)
     If soap12 { Set %xmlmsg=beginprefix_"definingRoles"_$select(xsitype:"",1:" "_soapPrefix_"itemType="""_temp1_$select($parameter("BSTS.ns1.TRole","XMLSUMMARY")'="":"s_TRole",1:"TRole")_"""")_" "_soapPrefix_"arraySize="""_aval.Count()_""""_""_temp_">" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     } Else { Set %xmlmsg=beginprefix_"definingRoles "_$select(xsitype:xsiPrefix_"type="""_soapPrefix_"Array""",1:soapPrefix_"arrayType="""_temp1_$select($parameter("BSTS.ns1.TRole","XMLSUMMARY")'="":"s_TRole",1:"TRole")_"["_aval.Count()_"]""")_""_temp_">" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg } }
   }
   While k'="" {
     If $IsObject(val) {
       Set id=""
       If encoded,'inlineFlag {
         Set temp=$select($parameter("BSTS.ns1.TRole","XMLSUMMARY")'="":-1,1:1)
         Set id=+$get(idlist(temp*val))
         If 'soap12 , (id=0) Set id=$increment(idlist),oreflist(temp*id)=val,idlist(temp*val)=id
       }
       If +id'=0 {
         Set %xmlmsg=currentIndent_beginprefix_"definingRoles "_$select(soap12:soapPrefix_"ref=""",1:"href=""#")_"id"_id_""" />" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
       } Else { if id=0 Set id=$increment(idlist)
         Set topArg="definingRoles",summaryArg=1,group=0,createId=$get(id),typeAttr=$select(encoded||xsitype:"*",1:"BSTS.ns1.TRole"),local=1,savexsiAttrs=xsiAttrs
         Set sc=val.XMLExportInternal() Goto:'sc XMLExportExit Set xsiAttrs=savexsiAttrs
       }
     } Else {
       Set %xmlmsg=currentIndent_beginprefix_"definingRoles "_xsiPrefix_"nil=""true"""_xsiAttrs_"/>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     }
     Set val=aval.GetNext(.k)
   }
   If encoded {
     If indentFlag Set currentIndent=$extract(currentIndent,1,*-$length(indentChars)) Set %xmlmsg=currentIndent if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     Set %xmlmsg=endprefix_"definingRoles>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
   }
 }
 Set val=..numberOfSpecifiedSubconcepts
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"numberOfSpecifiedSubconcepts"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"int""",1:"")_">"_val_endprefix_"numberOfSpecifiedSubconcepts>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..numberOfSpecifiedSuperconcepts
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"numberOfSpecifiedSuperconcepts"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"int""",1:"")_">"_val_endprefix_"numberOfSpecifiedSuperconcepts>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..numberOfSpecifiedInverseRoles
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"numberOfSpecifiedInverseRoles"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"int""",1:"")_">"_val_endprefix_"numberOfSpecifiedInverseRoles>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..numberOfSpecifiedRoles
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"numberOfSpecifiedRoles"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"int""",1:"")_">"_val_endprefix_"numberOfSpecifiedRoles>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
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
     If $classname(val)="BSTS.ns1.TOntylogConcept" {
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
 Quit ##class(%XML.Implementation).XMLGetSchemaImports("BSTS.ns1.TOntylogConcept",.imports,.classes)
zXMLImportInternal()
 New child,node,data,ref,encodedArray,loopref,element,key,nsIndex
 Set $ztrap="XMLImportInternalTrap"
 Set encoded=$case($piece(fmt,",",1),"":0,"literal":0,"encoded":1,"encoded12":1,:"")
 If encoded="" Quit $$Error^%apiOBJ(6231,fmt)
 Set nsIndex=$get(@(tree)@("ns","http://apelon.com/dtsserver/types"))
 Set (node,ref)=nodeArg
 If ($listget($get(@(tree)@(node,0)),1)'="e")||(tag'=@(tree)@(node)) Goto XMLImportMalformed
 If bareProjection Quit $$Error^%apiOBJ(6386,"BSTS.ns1.TOntylogConcept")
 If encoded {
   If $data(@(tree)@(node,"a","id")) Set idlist(node)=$this
 }
 If +$listget($get(@(tree)@(node,0)),7,0) Quit 1
 Set sc=$$XMLImportElements()
XMLImportExit Quit sc
XMLImportElements() ;
 Set child=""
 If $$XMLLOOP()'=0 Quit sc
 If tag="namespaceId" {
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
   Set ..namespaceId=data
   If $$XMLLOOP()'=0 Goto XMLImportExit }
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
 If tag="code" {
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
   Set ..code=data
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 If tag="revisionIn" {
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
             Set data=$zstrip(data,"<>W",$c(13,10)) If data'="" Set data=..revisionInXSDToLogical(data) Goto:data="" XMLImportErr Goto:('..revisionInIsValid(data)) XMLImportErr
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   Set ..revisionIn=data
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 If tag="revisionOut" {
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
             Set data=$zstrip(data,"<>W",$c(13,10)) If data'="" Set data=..revisionOutXSDToLogical(data) Goto:data="" XMLImportErr Goto:('..revisionOutIsValid(data)) XMLImportErr
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   Set ..revisionOut=data
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 If tag="status" {
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
             If data'="" Goto:('$s(data'[","&&(",A,I,D,"[(","_$select(data=$c(0):"",1:data)_",")):1,1:$$Error^%apiOBJ(7205,data,",A,I,D"))) XMLImportErr
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   Set ..status=data
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
 For  { Set encodedArray=encoded
 If tag="associations" {
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
           If (class="") || (class="TConceptAssociation") {
             Set class="BSTS.ns1.TConceptAssociation"
           } Else {
             If $length(class,":")=2 Set class=$piece(class,":",2)
             Set class=$get(^oddCOM("BSTS.ns1.TConceptAssociation",85,"s",class))_$get(^oddXML("BSTS.ns1.TConceptAssociation","s",class)) If class="" Set class=0
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
         If data'="" Do ..associations.Insert(data)
         }
         Set element=$order(@(tree)@(loopref,"c",element))
       }
       Quit:('sc)  Set ref=loopref
     } Else { Set encodedArray=0
         If $listget($get(@(tree)@(ref,0)),1)'="e" Goto XMLImportMalformedNoTag
         If 'encoded,(@(tree)@(ref)'="associations") Goto XMLImportBadTag
         If '$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
         If encoded,$$XMLImportId() {
           Set data=idlist(ref)
         } Else {
           If 'sc Goto XMLImportExit
           Set class=$select(($get(@(tree)@(ref,"a","type","u"))=1):$get(@(tree)@(ref,"a","type")),1:"")
           If (class="") || (class="TConceptAssociation") {
             Set class="BSTS.ns1.TConceptAssociation"
           } Else {
             If $length(class,":")=2 Set class=$piece(class,":",2)
             Set class=$get(^oddCOM("BSTS.ns1.TConceptAssociation",85,"s",class))_$get(^oddXML("BSTS.ns1.TConceptAssociation","s",class)) If class="" Set class=0
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
         If data'="" Do ..associations.Insert(data)
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 Else { Quit  }
 If encodedArray Quit
 }
 For  { Set encodedArray=encoded
 If tag="inverseAssociations" {
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
           If (class="") || (class="TConceptAssociation") {
             Set class="BSTS.ns1.TConceptAssociation"
           } Else {
             If $length(class,":")=2 Set class=$piece(class,":",2)
             Set class=$get(^oddCOM("BSTS.ns1.TConceptAssociation",85,"s",class))_$get(^oddXML("BSTS.ns1.TConceptAssociation","s",class)) If class="" Set class=0
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
         If data'="" Do ..inverseAssociations.Insert(data)
         }
         Set element=$order(@(tree)@(loopref,"c",element))
       }
       Quit:('sc)  Set ref=loopref
     } Else { Set encodedArray=0
         If $listget($get(@(tree)@(ref,0)),1)'="e" Goto XMLImportMalformedNoTag
         If 'encoded,(@(tree)@(ref)'="inverseAssociations") Goto XMLImportBadTag
         If '$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
         If encoded,$$XMLImportId() {
           Set data=idlist(ref)
         } Else {
           If 'sc Goto XMLImportExit
           Set class=$select(($get(@(tree)@(ref,"a","type","u"))=1):$get(@(tree)@(ref,"a","type")),1:"")
           If (class="") || (class="TConceptAssociation") {
             Set class="BSTS.ns1.TConceptAssociation"
           } Else {
             If $length(class,":")=2 Set class=$piece(class,":",2)
             Set class=$get(^oddCOM("BSTS.ns1.TConceptAssociation",85,"s",class))_$get(^oddXML("BSTS.ns1.TConceptAssociation","s",class)) If class="" Set class=0
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
         If data'="" Do ..inverseAssociations.Insert(data)
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 Else { Quit  }
 If encodedArray Quit
 }
 For  { Set encodedArray=encoded
 If tag="synonyms" {
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
           If (class="") || (class="TSynonym") {
             Set class="BSTS.ns1.TSynonym"
           } Else {
             If $length(class,":")=2 Set class=$piece(class,":",2)
             Set class=$get(^oddCOM("BSTS.ns1.TSynonym",85,"s",class))_$get(^oddXML("BSTS.ns1.TSynonym","s",class)) If class="" Set class=0
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
         If data'="" Do ..synonyms.Insert(data)
         }
         Set element=$order(@(tree)@(loopref,"c",element))
       }
       Quit:('sc)  Set ref=loopref
     } Else { Set encodedArray=0
         If $listget($get(@(tree)@(ref,0)),1)'="e" Goto XMLImportMalformedNoTag
         If 'encoded,(@(tree)@(ref)'="synonyms") Goto XMLImportBadTag
         If '$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
         If encoded,$$XMLImportId() {
           Set data=idlist(ref)
         } Else {
           If 'sc Goto XMLImportExit
           Set class=$select(($get(@(tree)@(ref,"a","type","u"))=1):$get(@(tree)@(ref,"a","type")),1:"")
           If (class="") || (class="TSynonym") {
             Set class="BSTS.ns1.TSynonym"
           } Else {
             If $length(class,":")=2 Set class=$piece(class,":",2)
             Set class=$get(^oddCOM("BSTS.ns1.TSynonym",85,"s",class))_$get(^oddXML("BSTS.ns1.TSynonym","s",class)) If class="" Set class=0
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
         If data'="" Do ..synonyms.Insert(data)
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 Else { Quit  }
 If encodedArray Quit
 }
 If tag="kind" {
   If '$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
   If encoded,$$XMLImportId() {
     Set data=idlist(ref)
   } Else { Goto:'sc XMLImportExit
     Set class=$select(($get(@(tree)@(ref,"a","type","u"))=1):$get(@(tree)@(ref,"a","type")),1:"")
     If (class="") || (class="TKind") {
       Set class="BSTS.ns1.TKind"
     } Else {
       If $length(class,":")=2 Set class=$piece(class,":",2)
       Set class=$get(^oddCOM("BSTS.ns1.TKind",85,"s",class))_$get(^oddXML("BSTS.ns1.TKind","s",class)) If class="" Set class=0
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
   If data'="" Set ..kind=data
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 If tag="primitive" {
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
   Set ..primitive=data
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 For  { Set encodedArray=encoded
 If tag="subconcepts" {
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
           If (class="") || (class="TConceptNav") {
             Set class="BSTS.ns1.TConceptNav"
           } Else {
             If $length(class,":")=2 Set class=$piece(class,":",2)
             Set class=$get(^oddCOM("BSTS.ns1.TConceptNav",85,"s",class))_$get(^oddXML("BSTS.ns1.TConceptNav","s",class)) If class="" Set class=0
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
         If data'="" Do ..subconcepts.Insert(data)
         }
         Set element=$order(@(tree)@(loopref,"c",element))
       }
       Quit:('sc)  Set ref=loopref
     } Else { Set encodedArray=0
         If $listget($get(@(tree)@(ref,0)),1)'="e" Goto XMLImportMalformedNoTag
         If 'encoded,(@(tree)@(ref)'="subconcepts") Goto XMLImportBadTag
         If '$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
         If encoded,$$XMLImportId() {
           Set data=idlist(ref)
         } Else {
           If 'sc Goto XMLImportExit
           Set class=$select(($get(@(tree)@(ref,"a","type","u"))=1):$get(@(tree)@(ref,"a","type")),1:"")
           If (class="") || (class="TConceptNav") {
             Set class="BSTS.ns1.TConceptNav"
           } Else {
             If $length(class,":")=2 Set class=$piece(class,":",2)
             Set class=$get(^oddCOM("BSTS.ns1.TConceptNav",85,"s",class))_$get(^oddXML("BSTS.ns1.TConceptNav","s",class)) If class="" Set class=0
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
         If data'="" Do ..subconcepts.Insert(data)
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 Else { Quit  }
 If encodedArray Quit
 }
 For  { Set encodedArray=encoded
 If tag="superconcepts" {
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
           If (class="") || (class="TConceptNav") {
             Set class="BSTS.ns1.TConceptNav"
           } Else {
             If $length(class,":")=2 Set class=$piece(class,":",2)
             Set class=$get(^oddCOM("BSTS.ns1.TConceptNav",85,"s",class))_$get(^oddXML("BSTS.ns1.TConceptNav","s",class)) If class="" Set class=0
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
         If data'="" Do ..superconcepts.Insert(data)
         }
         Set element=$order(@(tree)@(loopref,"c",element))
       }
       Quit:('sc)  Set ref=loopref
     } Else { Set encodedArray=0
         If $listget($get(@(tree)@(ref,0)),1)'="e" Goto XMLImportMalformedNoTag
         If 'encoded,(@(tree)@(ref)'="superconcepts") Goto XMLImportBadTag
         If '$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
         If encoded,$$XMLImportId() {
           Set data=idlist(ref)
         } Else {
           If 'sc Goto XMLImportExit
           Set class=$select(($get(@(tree)@(ref,"a","type","u"))=1):$get(@(tree)@(ref,"a","type")),1:"")
           If (class="") || (class="TConceptNav") {
             Set class="BSTS.ns1.TConceptNav"
           } Else {
             If $length(class,":")=2 Set class=$piece(class,":",2)
             Set class=$get(^oddCOM("BSTS.ns1.TConceptNav",85,"s",class))_$get(^oddXML("BSTS.ns1.TConceptNav","s",class)) If class="" Set class=0
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
         If data'="" Do ..superconcepts.Insert(data)
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 Else { Quit  }
 If encodedArray Quit
 }
 For  { Set encodedArray=encoded
 If tag="roles" {
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
           If (class="") || (class="TRole") {
             Set class="BSTS.ns1.TRole"
           } Else {
             If $length(class,":")=2 Set class=$piece(class,":",2)
             Set class=$get(^oddCOM("BSTS.ns1.TRole",85,"s",class))_$get(^oddXML("BSTS.ns1.TRole","s",class)) If class="" Set class=0
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
         If data'="" Do ..roles.Insert(data)
         }
         Set element=$order(@(tree)@(loopref,"c",element))
       }
       Quit:('sc)  Set ref=loopref
     } Else { Set encodedArray=0
         If $listget($get(@(tree)@(ref,0)),1)'="e" Goto XMLImportMalformedNoTag
         If 'encoded,(@(tree)@(ref)'="roles") Goto XMLImportBadTag
         If '$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
         If encoded,$$XMLImportId() {
           Set data=idlist(ref)
         } Else {
           If 'sc Goto XMLImportExit
           Set class=$select(($get(@(tree)@(ref,"a","type","u"))=1):$get(@(tree)@(ref,"a","type")),1:"")
           If (class="") || (class="TRole") {
             Set class="BSTS.ns1.TRole"
           } Else {
             If $length(class,":")=2 Set class=$piece(class,":",2)
             Set class=$get(^oddCOM("BSTS.ns1.TRole",85,"s",class))_$get(^oddXML("BSTS.ns1.TRole","s",class)) If class="" Set class=0
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
         If data'="" Do ..roles.Insert(data)
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 Else { Quit  }
 If encodedArray Quit
 }
 For  { Set encodedArray=encoded
 If tag="inverseRoles" {
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
           If (class="") || (class="TRole") {
             Set class="BSTS.ns1.TRole"
           } Else {
             If $length(class,":")=2 Set class=$piece(class,":",2)
             Set class=$get(^oddCOM("BSTS.ns1.TRole",85,"s",class))_$get(^oddXML("BSTS.ns1.TRole","s",class)) If class="" Set class=0
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
         If data'="" Do ..inverseRoles.Insert(data)
         }
         Set element=$order(@(tree)@(loopref,"c",element))
       }
       Quit:('sc)  Set ref=loopref
     } Else { Set encodedArray=0
         If $listget($get(@(tree)@(ref,0)),1)'="e" Goto XMLImportMalformedNoTag
         If 'encoded,(@(tree)@(ref)'="inverseRoles") Goto XMLImportBadTag
         If '$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
         If encoded,$$XMLImportId() {
           Set data=idlist(ref)
         } Else {
           If 'sc Goto XMLImportExit
           Set class=$select(($get(@(tree)@(ref,"a","type","u"))=1):$get(@(tree)@(ref,"a","type")),1:"")
           If (class="") || (class="TRole") {
             Set class="BSTS.ns1.TRole"
           } Else {
             If $length(class,":")=2 Set class=$piece(class,":",2)
             Set class=$get(^oddCOM("BSTS.ns1.TRole",85,"s",class))_$get(^oddXML("BSTS.ns1.TRole","s",class)) If class="" Set class=0
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
         If data'="" Do ..inverseRoles.Insert(data)
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 Else { Quit  }
 If encodedArray Quit
 }
 For  { Set encodedArray=encoded
 If tag="definingConcepts" {
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
           If (class="") || (class="TConceptNav") {
             Set class="BSTS.ns1.TConceptNav"
           } Else {
             If $length(class,":")=2 Set class=$piece(class,":",2)
             Set class=$get(^oddCOM("BSTS.ns1.TConceptNav",85,"s",class))_$get(^oddXML("BSTS.ns1.TConceptNav","s",class)) If class="" Set class=0
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
         If data'="" Do ..definingConcepts.Insert(data)
         }
         Set element=$order(@(tree)@(loopref,"c",element))
       }
       Quit:('sc)  Set ref=loopref
     } Else { Set encodedArray=0
         If $listget($get(@(tree)@(ref,0)),1)'="e" Goto XMLImportMalformedNoTag
         If 'encoded,(@(tree)@(ref)'="definingConcepts") Goto XMLImportBadTag
         If '$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
         If encoded,$$XMLImportId() {
           Set data=idlist(ref)
         } Else {
           If 'sc Goto XMLImportExit
           Set class=$select(($get(@(tree)@(ref,"a","type","u"))=1):$get(@(tree)@(ref,"a","type")),1:"")
           If (class="") || (class="TConceptNav") {
             Set class="BSTS.ns1.TConceptNav"
           } Else {
             If $length(class,":")=2 Set class=$piece(class,":",2)
             Set class=$get(^oddCOM("BSTS.ns1.TConceptNav",85,"s",class))_$get(^oddXML("BSTS.ns1.TConceptNav","s",class)) If class="" Set class=0
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
         If data'="" Do ..definingConcepts.Insert(data)
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 Else { Quit  }
 If encodedArray Quit
 }
 For  { Set encodedArray=encoded
 If tag="definingRoles" {
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
           If (class="") || (class="TRole") {
             Set class="BSTS.ns1.TRole"
           } Else {
             If $length(class,":")=2 Set class=$piece(class,":",2)
             Set class=$get(^oddCOM("BSTS.ns1.TRole",85,"s",class))_$get(^oddXML("BSTS.ns1.TRole","s",class)) If class="" Set class=0
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
         If data'="" Do ..definingRoles.Insert(data)
         }
         Set element=$order(@(tree)@(loopref,"c",element))
       }
       Quit:('sc)  Set ref=loopref
     } Else { Set encodedArray=0
         If $listget($get(@(tree)@(ref,0)),1)'="e" Goto XMLImportMalformedNoTag
         If 'encoded,(@(tree)@(ref)'="definingRoles") Goto XMLImportBadTag
         If '$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
         If encoded,$$XMLImportId() {
           Set data=idlist(ref)
         } Else {
           If 'sc Goto XMLImportExit
           Set class=$select(($get(@(tree)@(ref,"a","type","u"))=1):$get(@(tree)@(ref,"a","type")),1:"")
           If (class="") || (class="TRole") {
             Set class="BSTS.ns1.TRole"
           } Else {
             If $length(class,":")=2 Set class=$piece(class,":",2)
             Set class=$get(^oddCOM("BSTS.ns1.TRole",85,"s",class))_$get(^oddXML("BSTS.ns1.TRole","s",class)) If class="" Set class=0
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
         If data'="" Do ..definingRoles.Insert(data)
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 Else { Quit  }
 If encodedArray Quit
 }
 If tag="numberOfSpecifiedSubconcepts" {
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
   Set ..numberOfSpecifiedSubconcepts=data
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 If tag="numberOfSpecifiedSuperconcepts" {
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
   Set ..numberOfSpecifiedSuperconcepts=data
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 If tag="numberOfSpecifiedInverseRoles" {
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
   Set ..numberOfSpecifiedInverseRoles=data
   If $$XMLLOOP()'=0 Goto XMLImportExit }
 If tag="numberOfSpecifiedRoles" {
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
   Set ..numberOfSpecifiedRoles=data
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
 If ..namespaceId'="" Quit 0
 If ..id'="" Quit 0
 If ..name'="" Quit 0
 If ..code'="" Quit 0
 If ..revisionIn'="" Quit 0
 If ..revisionOut'="" Quit 0
 If ..status'="" Quit 0
 If ..snapshotDate'="" Quit 0
 If ..properties.Count()>0 Quit 0
 If ..associations.Count()>0 Quit 0
 If ..inverseAssociations.Count()>0 Quit 0
 If ..synonyms.Count()>0 Quit 0
 If $IsObject(..kind) Quit 0
 If ..primitive'="" Quit 0
 If ..subconcepts.Count()>0 Quit 0
 If ..superconcepts.Count()>0 Quit 0
 If ..roles.Count()>0 Quit 0
 If ..inverseRoles.Count()>0 Quit 0
 If ..definingConcepts.Count()>0 Quit 0
 If ..definingRoles.Count()>0 Quit 0
 If ..numberOfSpecifiedSubconcepts'="" Quit 0
 If ..numberOfSpecifiedSuperconcepts'="" Quit 0
 If ..numberOfSpecifiedInverseRoles'="" Quit 0
 If ..numberOfSpecifiedRoles'="" Quit 0
 Quit 1
zXMLNew(document,node,containerOref="")
	Quit (##class(BSTS.ns1.TOntylogConcept).%New())
zXMLSchema(top="",format="",namespacePrefix="",input=0,refOnly=0,schema)
 Quit ##class(%XML.Implementation).XMLSchema("BSTS.ns1.TOntylogConcept",top,format,namespacePrefix,input,refOnly,.schema)
zdefiningConceptsBuildValueArra(value,array) public {
	Quit ##class(%Collection.ListOfObj).BuildValueArray(value,.array)
}
zdefiningConceptsCollectionToDi(val="",delim) public { Set:'($data(delim)#2) delim=$char(13,10)
	set odbc="",tDelimLen=$l(delim)
	for i=1:1:$listlength(val) {
		set item=$Listget(val,i)
		if item'["""",item'[delim,$length($zstrip(item,"<>W"))=$length(item) set odbc=odbc_delim_item continue
		for j=$length(item,""""):-1:2 set $piece(item,"""",j)=""""_$piece(item,"""",j)
		set odbc=odbc_delim_""""_item_""""
	}
	quit $extract(odbc,tDelimLen+1,*) }
zdefiningConceptsCollectionToOd(val="") public {
	set odbc=""
	for i=1:1:$listlength(val) {
		set item=$listget(val,i)
		if item'["""",item'[",",$length($zstrip(item,"<>W"))=$length(item) set odbc=odbc_","_item continue
		for j=$length(item,""""):-1:2 set $piece(item,"""",j)=""""_$piece(item,"""",j)
		set odbc=odbc_","""_item_""""
	}
	quit $extract(odbc,2,*) }
zdefiningConceptsDisplayToColle(val="",delim) public { Set:'($data(delim)#2) delim=$char(13,10)
	set logical="",out="",tDelimLen=$l(delim)
hloop	if $extract(val,1,tDelimLen)=delim { goto hdel } if val="" { goto hexit } if $extract(val)="""" { goto hquote } goto hdefault
hdefault	set stuff=$piece(val,delim),out=out_stuff,val=$extract(val,$length(stuff)+1,*) goto hloop
hquote	set stuff=$find(val,"""",2) if stuff=0 set stuff=$length(val)+10
	set out=out_$select(stuff=3:"""",1:$extract(val,2,stuff-2)),val=$extract(val,stuff,*)
	if $extract(val)="""" { set out=out_"""" goto hquote } else { goto hdefault }
hdel	set logical=logical_$listbuild(out),out="",val=$extract(val,tDelimLen+1,*) goto hloop
hexit	set logical=logical_$listbuild(out)
	quit logical }
zdefiningConceptsGetObject(force=0) public {
	Quit $select(r%definingConcepts="":$select(i%definingConcepts="":"",1:$listbuild(i%definingConcepts_"")),(''..definingConcepts.%GetSwizzleObject(force,.oid)):oid,1:"") }
zdefiningConceptsGetObjectId(force=0) public {
	Quit $listget(..definingConceptsGetObject(force)) }
zdefiningConceptsGetSwizzled() public {
	Set oref=##class(%Collection.ListOfObj).%New() If oref="" Quit ""
	Set modstate=$system.CLS.GetModifiedBits() Set r%definingConcepts=oref Do $system.CLS.SetModifiedBits(modstate)
	Set oref.ElementType="BSTS.ns1.TConceptNav",oref.ElementClassType="",oref.Owner=+$this,oref.Storage=$this."definingConcepts%i"(),oref.OrefStorage=oref.Storage+1
	Do $system.CLS.SetModified(oref,0)
	Quit oref }
zdefiningConceptsOdbcToCollecti(val="") public {
	set logical="",out=""
hloop	if $extract(val)="," { goto hdel } if val="" { goto hexit } if $extract(val)="""" { goto hquote } goto hdefault
hdefault	set stuff=$piece(val,","),out=out_stuff,val=$extract(val,$length(stuff)+1,*) goto hloop
hquote	set stuff=$find(val,"""",2) if stuff=0 set stuff=$length(val)+10
	set out=out_$select(stuff=3:"""",1:$extract(val,2,stuff-2)),val=$extract(val,stuff,*)
	if $extract(val)="""" { set out=out_"""" goto hquote } else { goto hdefault }
hdel	set logical=logical_$listbuild(out),out="",val=$extract(val,2,*) goto hloop
hexit	set logical=logical_$listbuild(out)
	quit logical }
zdefiningConceptsSet(newvalue) public {
	If '$isobject(newvalue),newvalue'="" Quit $$Error^%apiOBJ(5807,newvalue)
	If r%definingConcepts=newvalue Quit 1
	If newvalue="" Kill i%definingConcepts,r%definingConcepts Set i%definingConcepts="",r%definingConcepts="" Quit 1
	Set oref=r%definingConcepts Kill i%definingConcepts,r%definingConcepts Set i%definingConcepts="",r%definingConcepts=oref
	Set key="" For i=1:1 Set value=newvalue.GetNext(.key) Quit:key=""  Set r%definingConcepts(i)=value,i%definingConcepts(i)=""
	Quit 1 }
zdefiningRolesBuildValueArray(value,array) public {
	Quit ##class(%Collection.ListOfObj).BuildValueArray(value,.array)
}
zdefiningRolesCollectionToDispl(val="",delim) public { Set:'($data(delim)#2) delim=$char(13,10)
	set odbc="",tDelimLen=$l(delim)
	for i=1:1:$listlength(val) {
		set item=$Listget(val,i)
		if item'["""",item'[delim,$length($zstrip(item,"<>W"))=$length(item) set odbc=odbc_delim_item continue
		for j=$length(item,""""):-1:2 set $piece(item,"""",j)=""""_$piece(item,"""",j)
		set odbc=odbc_delim_""""_item_""""
	}
	quit $extract(odbc,tDelimLen+1,*) }
zdefiningRolesCollectionToOdbc(val="") public {
	set odbc=""
	for i=1:1:$listlength(val) {
		set item=$listget(val,i)
		if item'["""",item'[",",$length($zstrip(item,"<>W"))=$length(item) set odbc=odbc_","_item continue
		for j=$length(item,""""):-1:2 set $piece(item,"""",j)=""""_$piece(item,"""",j)
		set odbc=odbc_","""_item_""""
	}
	quit $extract(odbc,2,*) }
zdefiningRolesDisplayToCollecti(val="",delim) public { Set:'($data(delim)#2) delim=$char(13,10)
	set logical="",out="",tDelimLen=$l(delim)
hloop	if $extract(val,1,tDelimLen)=delim { goto hdel } if val="" { goto hexit } if $extract(val)="""" { goto hquote } goto hdefault
hdefault	set stuff=$piece(val,delim),out=out_stuff,val=$extract(val,$length(stuff)+1,*) goto hloop
hquote	set stuff=$find(val,"""",2) if stuff=0 set stuff=$length(val)+10
	set out=out_$select(stuff=3:"""",1:$extract(val,2,stuff-2)),val=$extract(val,stuff,*)
	if $extract(val)="""" { set out=out_"""" goto hquote } else { goto hdefault }
hdel	set logical=logical_$listbuild(out),out="",val=$extract(val,tDelimLen+1,*) goto hloop
hexit	set logical=logical_$listbuild(out)
	quit logical }
zdefiningRolesGetObject(force=0) public {
	Quit $select(r%definingRoles="":$select(i%definingRoles="":"",1:$listbuild(i%definingRoles_"")),(''..definingRoles.%GetSwizzleObject(force,.oid)):oid,1:"") }
zdefiningRolesGetObjectId(force=0) public {
	Quit $listget(..definingRolesGetObject(force)) }
zdefiningRolesGetSwizzled() public {
	Set oref=##class(%Collection.ListOfObj).%New() If oref="" Quit ""
	Set modstate=$system.CLS.GetModifiedBits() Set r%definingRoles=oref Do $system.CLS.SetModifiedBits(modstate)
	Set oref.ElementType="BSTS.ns1.TRole",oref.ElementClassType="",oref.Owner=+$this,oref.Storage=$this."definingRoles%i"(),oref.OrefStorage=oref.Storage+1
	Do $system.CLS.SetModified(oref,0)
	Quit oref }
zdefiningRolesOdbcToCollection(val="") public {
	set logical="",out=""
hloop	if $extract(val)="," { goto hdel } if val="" { goto hexit } if $extract(val)="""" { goto hquote } goto hdefault
hdefault	set stuff=$piece(val,","),out=out_stuff,val=$extract(val,$length(stuff)+1,*) goto hloop
hquote	set stuff=$find(val,"""",2) if stuff=0 set stuff=$length(val)+10
	set out=out_$select(stuff=3:"""",1:$extract(val,2,stuff-2)),val=$extract(val,stuff,*)
	if $extract(val)="""" { set out=out_"""" goto hquote } else { goto hdefault }
hdel	set logical=logical_$listbuild(out),out="",val=$extract(val,2,*) goto hloop
hexit	set logical=logical_$listbuild(out)
	quit logical }
zdefiningRolesSet(newvalue) public {
	If '$isobject(newvalue),newvalue'="" Quit $$Error^%apiOBJ(5807,newvalue)
	If r%definingRoles=newvalue Quit 1
	If newvalue="" Kill i%definingRoles,r%definingRoles Set i%definingRoles="",r%definingRoles="" Quit 1
	Set oref=r%definingRoles Kill i%definingRoles,r%definingRoles Set i%definingRoles="",r%definingRoles=oref
	Set key="" For i=1:1 Set value=newvalue.GetNext(.key) Quit:key=""  Set r%definingRoles(i)=value,i%definingRoles(i)=""
	Quit 1 }
zinverseRolesBuildValueArray(value,array) public {
	Quit ##class(%Collection.ListOfObj).BuildValueArray(value,.array)
}
zinverseRolesCollectionToDispla(val="",delim) public { Set:'($data(delim)#2) delim=$char(13,10)
	set odbc="",tDelimLen=$l(delim)
	for i=1:1:$listlength(val) {
		set item=$Listget(val,i)
		if item'["""",item'[delim,$length($zstrip(item,"<>W"))=$length(item) set odbc=odbc_delim_item continue
		for j=$length(item,""""):-1:2 set $piece(item,"""",j)=""""_$piece(item,"""",j)
		set odbc=odbc_delim_""""_item_""""
	}
	quit $extract(odbc,tDelimLen+1,*) }
zinverseRolesCollectionToOdbc(val="") public {
	set odbc=""
	for i=1:1:$listlength(val) {
		set item=$listget(val,i)
		if item'["""",item'[",",$length($zstrip(item,"<>W"))=$length(item) set odbc=odbc_","_item continue
		for j=$length(item,""""):-1:2 set $piece(item,"""",j)=""""_$piece(item,"""",j)
		set odbc=odbc_","""_item_""""
	}
	quit $extract(odbc,2,*) }
zinverseRolesDisplayToCollectio(val="",delim) public { Set:'($data(delim)#2) delim=$char(13,10)
	set logical="",out="",tDelimLen=$l(delim)
hloop	if $extract(val,1,tDelimLen)=delim { goto hdel } if val="" { goto hexit } if $extract(val)="""" { goto hquote } goto hdefault
hdefault	set stuff=$piece(val,delim),out=out_stuff,val=$extract(val,$length(stuff)+1,*) goto hloop
hquote	set stuff=$find(val,"""",2) if stuff=0 set stuff=$length(val)+10
	set out=out_$select(stuff=3:"""",1:$extract(val,2,stuff-2)),val=$extract(val,stuff,*)
	if $extract(val)="""" { set out=out_"""" goto hquote } else { goto hdefault }
hdel	set logical=logical_$listbuild(out),out="",val=$extract(val,tDelimLen+1,*) goto hloop
hexit	set logical=logical_$listbuild(out)
	quit logical }
zinverseRolesGetObject(force=0) public {
	Quit $select(r%inverseRoles="":$select(i%inverseRoles="":"",1:$listbuild(i%inverseRoles_"")),(''..inverseRoles.%GetSwizzleObject(force,.oid)):oid,1:"") }
zinverseRolesGetObjectId(force=0) public {
	Quit $listget(..inverseRolesGetObject(force)) }
zinverseRolesGetSwizzled() public {
	Set oref=##class(%Collection.ListOfObj).%New() If oref="" Quit ""
	Set modstate=$system.CLS.GetModifiedBits() Set r%inverseRoles=oref Do $system.CLS.SetModifiedBits(modstate)
	Set oref.ElementType="BSTS.ns1.TRole",oref.ElementClassType="",oref.Owner=+$this,oref.Storage=$this."inverseRoles%i"(),oref.OrefStorage=oref.Storage+1
	Do $system.CLS.SetModified(oref,0)
	Quit oref }
zinverseRolesOdbcToCollection(val="") public {
	set logical="",out=""
hloop	if $extract(val)="," { goto hdel } if val="" { goto hexit } if $extract(val)="""" { goto hquote } goto hdefault
hdefault	set stuff=$piece(val,","),out=out_stuff,val=$extract(val,$length(stuff)+1,*) goto hloop
hquote	set stuff=$find(val,"""",2) if stuff=0 set stuff=$length(val)+10
	set out=out_$select(stuff=3:"""",1:$extract(val,2,stuff-2)),val=$extract(val,stuff,*)
	if $extract(val)="""" { set out=out_"""" goto hquote } else { goto hdefault }
hdel	set logical=logical_$listbuild(out),out="",val=$extract(val,2,*) goto hloop
hexit	set logical=logical_$listbuild(out)
	quit logical }
zinverseRolesSet(newvalue) public {
	If '$isobject(newvalue),newvalue'="" Quit $$Error^%apiOBJ(5807,newvalue)
	If r%inverseRoles=newvalue Quit 1
	If newvalue="" Kill i%inverseRoles,r%inverseRoles Set i%inverseRoles="",r%inverseRoles="" Quit 1
	Set oref=r%inverseRoles Kill i%inverseRoles,r%inverseRoles Set i%inverseRoles="",r%inverseRoles=oref
	Set key="" For i=1:1 Set value=newvalue.GetNext(.key) Quit:key=""  Set r%inverseRoles(i)=value,i%inverseRoles(i)=""
	Quit 1 }
zkindNewObject() public {
	Set newobject=##class(BSTS.ns1.TKind).%New() If newobject="" Quit ""
	Set ..kind=newobject
	Quit newobject }
znumberOfSpecifiedInverseRolesD(%val) public {
	Q $s(%val="":"",$zu(115,13)&&(%val=$c(0)):"",1:+$in(%val,"",%val)) }
znumberOfSpecifiedInverseRolesI(%val) public {
	Quit $select($zu(115,13)&&(%val=$c(0)):1,$isvalidnum(%val,0,-2147483648,2147483647):1,'$isvalidnum(%val):$$Error^%apiOBJ(7207,%val),%val<-2147483648:$$Error^%apiOBJ(7204,%val,-2147483648),1:$$Error^%apiOBJ(7203,%val,2147483647)) }
znumberOfSpecifiedInverseRolesN(%val) public {
	Quit $select($zu(115,13)&&(%val=$c(0)):"",1:%val\1) }
znumberOfSpecifiedInverseRolesX(%val) public {
	Q $s($tr(%val,"Ee(),.")'=%val:"",1:$number(%val,"I",-2147483648,2147483647)) }
znumberOfSpecifiedRolesDisplayT(%val) public {
	Q $s(%val="":"",$zu(115,13)&&(%val=$c(0)):"",1:+$in(%val,"",%val)) }
znumberOfSpecifiedRolesIsValid(%val) public {
	Quit $select($zu(115,13)&&(%val=$c(0)):1,$isvalidnum(%val,0,-2147483648,2147483647):1,'$isvalidnum(%val):$$Error^%apiOBJ(7207,%val),%val<-2147483648:$$Error^%apiOBJ(7204,%val,-2147483648),1:$$Error^%apiOBJ(7203,%val,2147483647)) }
znumberOfSpecifiedRolesNormaliz(%val) public {
	Quit $select($zu(115,13)&&(%val=$c(0)):"",1:%val\1) }
znumberOfSpecifiedRolesXSDToLog(%val) public {
	Q $s($tr(%val,"Ee(),.")'=%val:"",1:$number(%val,"I",-2147483648,2147483647)) }
znumberOfSpecifiedSubconceptsDi(%val) public {
	Q $s(%val="":"",$zu(115,13)&&(%val=$c(0)):"",1:+$in(%val,"",%val)) }
znumberOfSpecifiedSubconceptsIs(%val) public {
	Quit $select($zu(115,13)&&(%val=$c(0)):1,$isvalidnum(%val,0,-2147483648,2147483647):1,'$isvalidnum(%val):$$Error^%apiOBJ(7207,%val),%val<-2147483648:$$Error^%apiOBJ(7204,%val,-2147483648),1:$$Error^%apiOBJ(7203,%val,2147483647)) }
znumberOfSpecifiedSubconceptsNo(%val) public {
	Quit $select($zu(115,13)&&(%val=$c(0)):"",1:%val\1) }
znumberOfSpecifiedSubconceptsXS(%val) public {
	Q $s($tr(%val,"Ee(),.")'=%val:"",1:$number(%val,"I",-2147483648,2147483647)) }
znumberOfSpecifiedSuperconcepts(%val) public {
	Q $s(%val="":"",$zu(115,13)&&(%val=$c(0)):"",1:+$in(%val,"",%val)) }
znumberOfSpecifiedSuperconcept2(%val) public {
	Quit $select($zu(115,13)&&(%val=$c(0)):1,$isvalidnum(%val,0,-2147483648,2147483647):1,'$isvalidnum(%val):$$Error^%apiOBJ(7207,%val),%val<-2147483648:$$Error^%apiOBJ(7204,%val,-2147483648),1:$$Error^%apiOBJ(7203,%val,2147483647)) }
znumberOfSpecifiedSuperconcept4(%val) public {
	Quit $select($zu(115,13)&&(%val=$c(0)):"",1:%val\1) }
znumberOfSpecifiedSuperconcept5(%val) public {
	Q $s($tr(%val,"Ee(),.")'=%val:"",1:$number(%val,"I",-2147483648,2147483647)) }
zprimitiveDisplayToLogical(%val) public {
	Quit ''%val }
zprimitiveIsValid(%val="") public {
	Q $s($isvalidnum(%val,0,0,2)&&(+%val'=2):1,1:$$Error^%apiOBJ(7206,%val)) }
zprimitiveLogicalToXSD(%val) public {
	Q $s(%val:"true",1:"false") }
zprimitiveNormalize(%val) public {
	Quit %val\1 }
zprimitiveXSDToLogical(%val) public {
	Q $case(%val,"true":1,"false":0,1:1,0:0,:"") }
zrolesBuildValueArray(value,array) public {
	Quit ##class(%Collection.ListOfObj).BuildValueArray(value,.array)
}
zrolesCollectionToDisplay(val="",delim) public { Set:'($data(delim)#2) delim=$char(13,10)
	set odbc="",tDelimLen=$l(delim)
	for i=1:1:$listlength(val) {
		set item=$Listget(val,i)
		if item'["""",item'[delim,$length($zstrip(item,"<>W"))=$length(item) set odbc=odbc_delim_item continue
		for j=$length(item,""""):-1:2 set $piece(item,"""",j)=""""_$piece(item,"""",j)
		set odbc=odbc_delim_""""_item_""""
	}
	quit $extract(odbc,tDelimLen+1,*) }
zrolesCollectionToOdbc(val="") public {
	set odbc=""
	for i=1:1:$listlength(val) {
		set item=$listget(val,i)
		if item'["""",item'[",",$length($zstrip(item,"<>W"))=$length(item) set odbc=odbc_","_item continue
		for j=$length(item,""""):-1:2 set $piece(item,"""",j)=""""_$piece(item,"""",j)
		set odbc=odbc_","""_item_""""
	}
	quit $extract(odbc,2,*) }
zrolesDisplayToCollection(val="",delim) public { Set:'($data(delim)#2) delim=$char(13,10)
	set logical="",out="",tDelimLen=$l(delim)
hloop	if $extract(val,1,tDelimLen)=delim { goto hdel } if val="" { goto hexit } if $extract(val)="""" { goto hquote } goto hdefault
hdefault	set stuff=$piece(val,delim),out=out_stuff,val=$extract(val,$length(stuff)+1,*) goto hloop
hquote	set stuff=$find(val,"""",2) if stuff=0 set stuff=$length(val)+10
	set out=out_$select(stuff=3:"""",1:$extract(val,2,stuff-2)),val=$extract(val,stuff,*)
	if $extract(val)="""" { set out=out_"""" goto hquote } else { goto hdefault }
hdel	set logical=logical_$listbuild(out),out="",val=$extract(val,tDelimLen+1,*) goto hloop
hexit	set logical=logical_$listbuild(out)
	quit logical }
zrolesGetObject(force=0) public {
	Quit $select(r%roles="":$select(i%roles="":"",1:$listbuild(i%roles_"")),(''..roles.%GetSwizzleObject(force,.oid)):oid,1:"") }
zrolesGetObjectId(force=0) public {
	Quit $listget(..rolesGetObject(force)) }
zrolesGetSwizzled() public {
	Set oref=##class(%Collection.ListOfObj).%New() If oref="" Quit ""
	Set modstate=$system.CLS.GetModifiedBits() Set r%roles=oref Do $system.CLS.SetModifiedBits(modstate)
	Set oref.ElementType="BSTS.ns1.TRole",oref.ElementClassType="",oref.Owner=+$this,oref.Storage=$this."roles%i"(),oref.OrefStorage=oref.Storage+1
	Do $system.CLS.SetModified(oref,0)
	Quit oref }
zrolesOdbcToCollection(val="") public {
	set logical="",out=""
hloop	if $extract(val)="," { goto hdel } if val="" { goto hexit } if $extract(val)="""" { goto hquote } goto hdefault
hdefault	set stuff=$piece(val,","),out=out_stuff,val=$extract(val,$length(stuff)+1,*) goto hloop
hquote	set stuff=$find(val,"""",2) if stuff=0 set stuff=$length(val)+10
	set out=out_$select(stuff=3:"""",1:$extract(val,2,stuff-2)),val=$extract(val,stuff,*)
	if $extract(val)="""" { set out=out_"""" goto hquote } else { goto hdefault }
hdel	set logical=logical_$listbuild(out),out="",val=$extract(val,2,*) goto hloop
hexit	set logical=logical_$listbuild(out)
	quit logical }
zrolesSet(newvalue) public {
	If '$isobject(newvalue),newvalue'="" Quit $$Error^%apiOBJ(5807,newvalue)
	If r%roles=newvalue Quit 1
	If newvalue="" Kill i%roles,r%roles Set i%roles="",r%roles="" Quit 1
	Set oref=r%roles Kill i%roles,r%roles Set i%roles="",r%roles=oref
	Set key="" For i=1:1 Set value=newvalue.GetNext(.key) Quit:key=""  Set r%roles(i)=value,i%roles(i)=""
	Quit 1 }
zsubconceptsBuildValueArray(value,array) public {
	Quit ##class(%Collection.ListOfObj).BuildValueArray(value,.array)
}
zsubconceptsCollectionToDisplay(val="",delim) public { Set:'($data(delim)#2) delim=$char(13,10)
	set odbc="",tDelimLen=$l(delim)
	for i=1:1:$listlength(val) {
		set item=$Listget(val,i)
		if item'["""",item'[delim,$length($zstrip(item,"<>W"))=$length(item) set odbc=odbc_delim_item continue
		for j=$length(item,""""):-1:2 set $piece(item,"""",j)=""""_$piece(item,"""",j)
		set odbc=odbc_delim_""""_item_""""
	}
	quit $extract(odbc,tDelimLen+1,*) }
zsubconceptsCollectionToOdbc(val="") public {
	set odbc=""
	for i=1:1:$listlength(val) {
		set item=$listget(val,i)
		if item'["""",item'[",",$length($zstrip(item,"<>W"))=$length(item) set odbc=odbc_","_item continue
		for j=$length(item,""""):-1:2 set $piece(item,"""",j)=""""_$piece(item,"""",j)
		set odbc=odbc_","""_item_""""
	}
	quit $extract(odbc,2,*) }
zsubconceptsDisplayToCollection(val="",delim) public { Set:'($data(delim)#2) delim=$char(13,10)
	set logical="",out="",tDelimLen=$l(delim)
hloop	if $extract(val,1,tDelimLen)=delim { goto hdel } if val="" { goto hexit } if $extract(val)="""" { goto hquote } goto hdefault
hdefault	set stuff=$piece(val,delim),out=out_stuff,val=$extract(val,$length(stuff)+1,*) goto hloop
hquote	set stuff=$find(val,"""",2) if stuff=0 set stuff=$length(val)+10
	set out=out_$select(stuff=3:"""",1:$extract(val,2,stuff-2)),val=$extract(val,stuff,*)
	if $extract(val)="""" { set out=out_"""" goto hquote } else { goto hdefault }
hdel	set logical=logical_$listbuild(out),out="",val=$extract(val,tDelimLen+1,*) goto hloop
hexit	set logical=logical_$listbuild(out)
	quit logical }
zsubconceptsGetObject(force=0) public {
	Quit $select(r%subconcepts="":$select(i%subconcepts="":"",1:$listbuild(i%subconcepts_"")),(''..subconcepts.%GetSwizzleObject(force,.oid)):oid,1:"") }
zsubconceptsGetObjectId(force=0) public {
	Quit $listget(..subconceptsGetObject(force)) }
zsubconceptsGetSwizzled() public {
	Set oref=##class(%Collection.ListOfObj).%New() If oref="" Quit ""
	Set modstate=$system.CLS.GetModifiedBits() Set r%subconcepts=oref Do $system.CLS.SetModifiedBits(modstate)
	Set oref.ElementType="BSTS.ns1.TConceptNav",oref.ElementClassType="",oref.Owner=+$this,oref.Storage=$this."subconcepts%i"(),oref.OrefStorage=oref.Storage+1
	Do $system.CLS.SetModified(oref,0)
	Quit oref }
zsubconceptsOdbcToCollection(val="") public {
	set logical="",out=""
hloop	if $extract(val)="," { goto hdel } if val="" { goto hexit } if $extract(val)="""" { goto hquote } goto hdefault
hdefault	set stuff=$piece(val,","),out=out_stuff,val=$extract(val,$length(stuff)+1,*) goto hloop
hquote	set stuff=$find(val,"""",2) if stuff=0 set stuff=$length(val)+10
	set out=out_$select(stuff=3:"""",1:$extract(val,2,stuff-2)),val=$extract(val,stuff,*)
	if $extract(val)="""" { set out=out_"""" goto hquote } else { goto hdefault }
hdel	set logical=logical_$listbuild(out),out="",val=$extract(val,2,*) goto hloop
hexit	set logical=logical_$listbuild(out)
	quit logical }
zsubconceptsSet(newvalue) public {
	If '$isobject(newvalue),newvalue'="" Quit $$Error^%apiOBJ(5807,newvalue)
	If r%subconcepts=newvalue Quit 1
	If newvalue="" Kill i%subconcepts,r%subconcepts Set i%subconcepts="",r%subconcepts="" Quit 1
	Set oref=r%subconcepts Kill i%subconcepts,r%subconcepts Set i%subconcepts="",r%subconcepts=oref
	Set key="" For i=1:1 Set value=newvalue.GetNext(.key) Quit:key=""  Set r%subconcepts(i)=value,i%subconcepts(i)=""
	Quit 1 }
zsuperconceptsBuildValueArray(value,array) public {
	Quit ##class(%Collection.ListOfObj).BuildValueArray(value,.array)
}
zsuperconceptsCollectionToDispl(val="",delim) public { Set:'($data(delim)#2) delim=$char(13,10)
	set odbc="",tDelimLen=$l(delim)
	for i=1:1:$listlength(val) {
		set item=$Listget(val,i)
		if item'["""",item'[delim,$length($zstrip(item,"<>W"))=$length(item) set odbc=odbc_delim_item continue
		for j=$length(item,""""):-1:2 set $piece(item,"""",j)=""""_$piece(item,"""",j)
		set odbc=odbc_delim_""""_item_""""
	}
	quit $extract(odbc,tDelimLen+1,*) }
zsuperconceptsCollectionToOdbc(val="") public {
	set odbc=""
	for i=1:1:$listlength(val) {
		set item=$listget(val,i)
		if item'["""",item'[",",$length($zstrip(item,"<>W"))=$length(item) set odbc=odbc_","_item continue
		for j=$length(item,""""):-1:2 set $piece(item,"""",j)=""""_$piece(item,"""",j)
		set odbc=odbc_","""_item_""""
	}
	quit $extract(odbc,2,*) }
zsuperconceptsDisplayToCollecti(val="",delim) public { Set:'($data(delim)#2) delim=$char(13,10)
	set logical="",out="",tDelimLen=$l(delim)
hloop	if $extract(val,1,tDelimLen)=delim { goto hdel } if val="" { goto hexit } if $extract(val)="""" { goto hquote } goto hdefault
hdefault	set stuff=$piece(val,delim),out=out_stuff,val=$extract(val,$length(stuff)+1,*) goto hloop
hquote	set stuff=$find(val,"""",2) if stuff=0 set stuff=$length(val)+10
	set out=out_$select(stuff=3:"""",1:$extract(val,2,stuff-2)),val=$extract(val,stuff,*)
	if $extract(val)="""" { set out=out_"""" goto hquote } else { goto hdefault }
hdel	set logical=logical_$listbuild(out),out="",val=$extract(val,tDelimLen+1,*) goto hloop
hexit	set logical=logical_$listbuild(out)
	quit logical }
zsuperconceptsGetObject(force=0) public {
	Quit $select(r%superconcepts="":$select(i%superconcepts="":"",1:$listbuild(i%superconcepts_"")),(''..superconcepts.%GetSwizzleObject(force,.oid)):oid,1:"") }
zsuperconceptsGetObjectId(force=0) public {
	Quit $listget(..superconceptsGetObject(force)) }
zsuperconceptsGetSwizzled() public {
	Set oref=##class(%Collection.ListOfObj).%New() If oref="" Quit ""
	Set modstate=$system.CLS.GetModifiedBits() Set r%superconcepts=oref Do $system.CLS.SetModifiedBits(modstate)
	Set oref.ElementType="BSTS.ns1.TConceptNav",oref.ElementClassType="",oref.Owner=+$this,oref.Storage=$this."superconcepts%i"(),oref.OrefStorage=oref.Storage+1
	Do $system.CLS.SetModified(oref,0)
	Quit oref }
zsuperconceptsOdbcToCollection(val="") public {
	set logical="",out=""
hloop	if $extract(val)="," { goto hdel } if val="" { goto hexit } if $extract(val)="""" { goto hquote } goto hdefault
hdefault	set stuff=$piece(val,","),out=out_stuff,val=$extract(val,$length(stuff)+1,*) goto hloop
hquote	set stuff=$find(val,"""",2) if stuff=0 set stuff=$length(val)+10
	set out=out_$select(stuff=3:"""",1:$extract(val,2,stuff-2)),val=$extract(val,stuff,*)
	if $extract(val)="""" { set out=out_"""" goto hquote } else { goto hdefault }
hdel	set logical=logical_$listbuild(out),out="",val=$extract(val,2,*) goto hloop
hexit	set logical=logical_$listbuild(out)
	quit logical }
zsuperconceptsSet(newvalue) public {
	If '$isobject(newvalue),newvalue'="" Quit $$Error^%apiOBJ(5807,newvalue)
	If r%superconcepts=newvalue Quit 1
	If newvalue="" Kill i%superconcepts,r%superconcepts Set i%superconcepts="",r%superconcepts="" Quit 1
	Set oref=r%superconcepts Kill i%superconcepts,r%superconcepts Set i%superconcepts="",r%superconcepts=oref
	Set key="" For i=1:1 Set value=newvalue.GetNext(.key) Quit:key=""  Set r%superconcepts(i)=value,i%superconcepts(i)=""
	Quit 1 }
