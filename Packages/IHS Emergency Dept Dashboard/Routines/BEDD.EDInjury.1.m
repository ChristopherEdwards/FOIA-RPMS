 ;BEDD.EDInjury.1
 ;(C)InterSystems, generated for class BEDD.EDInjury.  Do NOT edit. 10/29/2015 07:58:19AM
 ;;5A65364C;BEDD.EDInjury
 ;
%BindExport(dev,Seen,RegisterOref,AllowedDepth,AllowedCapacity) public {
   i $d(Seen(+$this)) q 1
   Set Seen(+$this)=$this
   s sc = 1
 s proporef=..AtFaultOther
 s proporef=..BusOffc
 s proporef=..InjuryDetails
   d:RegisterOref InitObjVar^%SYS.BINDSRV($this)
   i dev'="" s t=$io u dev i $zobjexport($this_"",3)+$zobjexport($this."%%OID",3)+$zobjexport($this,3)!1 u t
 If AllowedDepth>0 Set AllowedDepth = AllowedDepth - 1
 If AllowedCapacity>0 Set AllowedCapacity = AllowedCapacity - 1/3
 s proporef=..AtFaultOther
 s proporef=..BusOffc
 s proporef=..InjuryDetails
   Quit sc }
%ConstructCloneInit(object,deep=0,cloned,location) public {
	If i%AtFaultOther'=""||($isobject(r%AtFaultOther)=1) Set r%AtFaultOther=..AtFaultOther.%ConstructClone(deep,.cloned),i%AtFaultOther=""
	If i%BusOffc'=""||($isobject(r%BusOffc)=1) Set r%BusOffc=..BusOffc.%ConstructClone(deep,.cloned),i%BusOffc=""
	If i%InjuryDetails'=""||($isobject(r%InjuryDetails)=1) Set r%InjuryDetails=..InjuryDetails.%ConstructClone(deep,.cloned),i%InjuryDetails=""
	Set i%"%%OID"=""
	Quit 1 }
%Delete(oid="",concurrency=-1) public {
	Quit:oid="" 1
	If concurrency = -1 Set concurrency=$zu(115,10)
	If (concurrency > 4) || (concurrency < 0) || (concurrency '= (concurrency\1)) Quit $$Error^%apiOBJ(5828)
	Set class=$listget(oid,2)
	If class="" { Set class=$classname(),oid=$select(oid="":"",1:$listbuild($listget(oid),$classname())_$select($listget(oid,3)'="":$listbuild($list(oid,3)),1:"")) } Else { Set class=$s(class="":"",class[".":class,$e(class)'="%":"User."_class,1:"%Library."_$e(class,2,*)) If $classname()'=class { Quit $classmethod(class,"%Delete",oid,concurrency) } }
	If +$g(%objtxSTATUS)=0 { Set traninit=1 k %objtxSTATUS,%objtxLIST,%objtxOIDASSIGNED,%objtxOIDUNASSIGNED,%objtxMODIFIED k:'$TLevel %0CacheLock,%objtxTID,%objtxID i '$zu(115,9) { s %objtxSTATUS=1 } else { TStart  i ($s($TLEVEL:##class(%SYS.Journal.Transaction).GetVirtualLocation(),1:""))'=$g(%objtxTID,0) { l +^OBJ.JournalT("NEW") s %objtxID=$i(^OBJ.JournalT) l +^OBJ.JournalT(%objtxID) l -^OBJ.JournalT(%objtxID) s %objtxTID=($s($TLEVEL:##class(%SYS.Journal.Transaction).GetVirtualLocation(),1:"")),^OBJ.JournalT(%objtxID)=$lb("",%objtxTID) l -^OBJ.JournalT("NEW")#"I" } s %objtxSTATUS=2 } } Else { Set traninit=0 }
	Set oref=..%Open(oid) If oref="" Set sc=$$Error^%apiOBJ(5810,$classname(),$listget(oid)) Goto %DeleteEnd
	Set stream=oref.AtFaultOtherGetObject() If stream'="" Set sc=##class(%Library.GlobalCharacterStream).%Delete(stream,concurrency) If ('sc) Goto %DeleteEnd
	Set stream=oref.BusOffcGetObject() If stream'="" Set sc=##class(%Library.GlobalCharacterStream).%Delete(stream,concurrency) If ('sc) Goto %DeleteEnd
	Set stream=oref.InjuryDetailsGetObject() If stream'="" Set sc=##class(%Library.GlobalCharacterStream).%Delete(stream,concurrency) If ('sc) Goto %DeleteEnd
	Set oref=""
	Set sc = 1
%DeleteEnd	If traninit { If (''sc) { i $g(%objtxSTATUS)=1 { k %objtxSTATUS } else { If $Tlevel { TCommit  } k %objtxSTATUS,%objtxLIST,%objtxOIDASSIGNED,%objtxOIDUNASSIGNED,%objtxMODIFIED k:'$TLevel %0CacheLock,%objtxTID,%objtxID } } Else { i $g(%objtxSTATUS)=2 { k %0CacheLock s sc=$select(+sc:$$%TRollBack^%occTransaction(),1:$$AppendStatus^%occSystem(sc,$$%TRollBack^%occTransaction())) k %objtxTID,%objtxID } else { k %objtxSTATUS } } }
	Quit sc }
%GetSerial(force=0)
	i i%AtFaultAddress="",i%AtFaultInsAdd="",i%AtFaultInsPolicy="",i%AtFaultInsurance="",i%AtFaultName="",i%AtFaultOther="",i%BusOffc="",i%BusOffcCmp="",i%BusOffcStat="",i%EmplAddress="",i%EmplCitySt="",i%EmplName="",i%EmplPh="",i%InjCause="",i%InjCauseIEN="",i%InjDt="",i%InjDtTm="",i%InjLocat="",i%InjSet="",i%InjTm="",i%InjuryDetails="",i%MVCLoc="",i%PtDFN="",i%SafetyEquip="",i%VIEN="",i%WrkRel="" QUIT ""
	QUIT $lb(i%AtFaultAddress,i%AtFaultInsAdd,i%AtFaultInsPolicy,i%AtFaultInsurance,i%AtFaultName,i%AtFaultOther,i%InjuryDetails,i%BusOffc,i%BusOffcCmp,i%BusOffcStat,i%EmplAddress,i%EmplCitySt,i%EmplName,i%EmplPh,i%InjLocat,i%InjDt,i%InjTm,i%VIEN,i%PtDFN,i%InjCause,i%InjSet,i%WrkRel,i%SafetyEquip,i%InjDtTm,i%MVCLoc,i%InjCauseIEN)
%GetSwizzleObject(force=0,oid) public {
	Set $ZTrap="%GetSwizzleObjectERR"
	New %objTX If '$data(%objTX2) New %objTX2 Set %objTX2=1
	If $get(%objTX2(+$this)) Set sc=..%BuildObjectGraph(1) Quit:('sc) sc Set intRef=+$this,objValue=$get(%objTX(1,intRef,1)),sc=..%SerializeObject(.objValue,1) Set:(''sc) %objTX(1,intRef,1)=objValue Set oid=objValue Quit sc
	Set related  = $select(force=2:1,1:0), oid = ""
	Set traninit=0 If +$g(%objtxSTATUS)=0 {
		Set traninit=1 Kill %objtxSTATUS,%objtxLIST,%objtxOIDASSIGNED,%objtxMODIFIED
		If '$zu(115,9) { Set %objtxSTATUS=1 } Else { Set %objtxSTATUS=2,%objtxLIST(+$this)="" TStart }
	}
	Set sc=..%BuildObjectGraph(related+2) Quit:('sc) sc
	Set %objTX2(+$this)=1
	If '$data(%objTX(2,+$this)) { Set %objTX(2,+$this)=2 }
	Set %objTX(3)=0,intRef="" For  Set intRef=$order(%objTX(2,intRef)) Quit:intRef=""  If '$data(%objTX(1,intRef,2)) Set %objTX(3,$increment(%objTX(3)))=%objTX(1,intRef) Kill %objTX(2,intRef)
	For  Quit:%objTX(3)<1  Set ptr=%objTX(3),objRef=%objTX(3,ptr),%objTX(3)=%objTX(3)-1 Kill %objTX(3,ptr) Set intRef=+objRef,objValue=$get(%objTX(1,intRef,1)),sc=objRef.%SerializeObject(.objValue) Do  Set %objTX(1,intRef,1)=objValue Kill %objTX(1,intRef,3) Do $system.CLS.SetModified(objRef,0)
	. If ('sc) Kill:$g(%objtxSTATUS)=2 %objtxLIST(+objRef),%objtxMODIFIED(+objRef) ZTrap "SG"
	. If $g(%objtxSTATUS)=2,objRef.%IsModified() Set %objtxMODIFIED(+objRef)=$system.CLS.GetModifiedBits(objRef)
	. Set intSucc="" For  Set intSucc=$order(%objTX(1,+objRef,3,intSucc)) Quit:intSucc=""  Kill %objTX(1,+objRef,3,intSucc),%objTX(1,intSucc,2,+objRef) If '$data(%objTX(1,intSucc,2)) Set %objTX(3,$i(%objTX(3)))=%objTX(1,intSucc) Kill %objTX(2,intSucc)
	For  Set pserial=0 Do  Quit:'pserial
	. Set intRef="" For  Set intRef=$order(%objTX(2,intRef)) Quit:intRef=""  Set intPred="" For  Set intPred=$order(%objTX(1,intRef,2,intPred)) Quit:intPred=""  If $get(%objTX(1,intPred,6))=1 Set objValue=$get(%objTX(1,intPred,1)),sc=(%objTX(1,intPred)).%SerializeObject(.objValue,1) If (''sc) Set pserial=1,%objTX(1,intPred,1)=objValue Do
	. . Set intSucc="" For  Set intSucc=$order(%objTX(1,intPred,3,intSucc)) Quit:intSucc=""  Kill %objTX(1,intPred,3,intSucc),%objTX(1,intSucc,2,intPred) If '$data(%objTX(1,intSucc,2)) Set %objTX(3,$i(%objTX(3)))=%objTX(1,intSucc) Kill %objTX(2,intSucc)
	. . For  Quit:%objTX(3)<1  Set ptr=%objTX(3),objSerialize=%objTX(3,ptr),%objTX(3)=%objTX(3)-1 Kill %objTX(3,ptr) Set intSerialize=+objSerialize,objValue=$get(%objTX(1,intSerialize,1)),sc=objSerialize.%SerializeObject(.objValue) Do  Set %objTX(1,intSerialize,1)=objValue Kill %objTX(1,intSerialize,3) Do $system.CLS.SetModified(objSerialize,0)
	. . . If ('sc) Kill:$g(%objtxSTATUS)=2 %objtxLIST(+objSerialize),%objtxMODIFIED(+objSerialize) ZTrap "SG"
	. . . If $g(%objtxSTATUS)=2,objSerialize.%IsModified() Set %objtxMODIFIED(+objSerialize)=$system.CLS.GetModifiedBits(objSerialize)
	. . . Set intSucc="" For  Set intSucc=$order(%objTX(1,intSerialize,3,intSucc)) Quit:intSucc=""  Kill %objTX(1,intSerialize,3,intSucc),%objTX(1,intSucc,2,intSerialize) If '$data(%objTX(1,intSucc,2)) Set %objTX(3,$i(%objTX(3)))=%objTX(1,intSucc) Kill %objTX(2,intSucc)
	If $data(%objTX(2))>2 Set sc=$$Error^%apiOBJ(5827,$classname()) ZTrap "SG"
	Set cmd="" For  Set cmd=$order(%objTX(9,cmd)) Quit:cmd=""  Xecute cmd
%GetSwizzleObjectCOMMIT	If traninit {
		If $g(%objtxSTATUS)=1 { Kill %objtxSTATUS } Else { TCommit  Kill %objtxSTATUS,%objtxLIST,%objtxOIDASSIGNED,%objtxMODIFIED }
	}
	Set oid = $get(%objTX(1,+$this,1))
	If $listget(oid) = "" Set oid = ""
	Set %objTX2(+$this)=0
	Quit sc
%GetSwizzleObjectERR	Set $ZTrap="" If $extract($ZError,1,5)'="<ZSG>" Set sc=$$Error^%apiOBJ(5002,$ZE)
	Set:traninit sc=$select(+sc:$$%TRollBack^%occTransaction(),1:$$AppendStatus^%occSystem(sc,$$%TRollBack^%occTransaction()))
	Set %objTX2(+$this)=0
	Quit sc }
%LoadInit(oid) public {
	Set i%"%%OID"=oid,r%AtFaultOther="",r%BusOffc="",r%InjuryDetails=""
	Quit 1 }
%NormalizeObject() public {
	If '$system.CLS.GetModified() Quit 1
	If m%AtFaultAddress Set:i%AtFaultAddress'="" i%AtFaultAddress=(..AtFaultAddressNormalize(i%AtFaultAddress))
	If m%AtFaultInsAdd Set:i%AtFaultInsAdd'="" i%AtFaultInsAdd=(..AtFaultInsAddNormalize(i%AtFaultInsAdd))
	If m%AtFaultInsPolicy Set:i%AtFaultInsPolicy'="" i%AtFaultInsPolicy=(..AtFaultInsPolicyNormalize(i%AtFaultInsPolicy))
	If m%AtFaultInsurance Set:i%AtFaultInsurance'="" i%AtFaultInsurance=(..AtFaultInsuranceNormalize(i%AtFaultInsurance))
	If m%AtFaultName Set:i%AtFaultName'="" i%AtFaultName=(..AtFaultNameNormalize(i%AtFaultName))
	If m%BusOffcCmp Set:i%BusOffcCmp'="" i%BusOffcCmp=(..BusOffcCmpNormalize(i%BusOffcCmp))
	If m%BusOffcStat Set:i%BusOffcStat'="" i%BusOffcStat=(..BusOffcStatNormalize(i%BusOffcStat))
	If m%EmplAddress Set:i%EmplAddress'="" i%EmplAddress=(..EmplAddressNormalize(i%EmplAddress))
	If m%EmplCitySt Set:i%EmplCitySt'="" i%EmplCitySt=(..EmplCityStNormalize(i%EmplCitySt))
	If m%EmplName Set:i%EmplName'="" i%EmplName=(..EmplNameNormalize(i%EmplName))
	If m%EmplPh Set:i%EmplPh'="" i%EmplPh=(..EmplPhNormalize(i%EmplPh))
	If m%InjCause Set:i%InjCause'="" i%InjCause=(..InjCauseNormalize(i%InjCause))
	If m%InjCauseIEN Set:i%InjCauseIEN'="" i%InjCauseIEN=(..InjCauseIENNormalize(i%InjCauseIEN))
	If m%InjDt Set:i%InjDt'="" i%InjDt=(..InjDtNormalize(i%InjDt))
	If m%InjDtTm Set:i%InjDtTm'="" i%InjDtTm=(..InjDtTmNormalize(i%InjDtTm))
	If m%InjLocat Set:i%InjLocat'="" i%InjLocat=(..InjLocatNormalize(i%InjLocat))
	If m%InjSet Set:i%InjSet'="" i%InjSet=(..InjSetNormalize(i%InjSet))
	If m%InjTm Set:i%InjTm'="" i%InjTm=(..InjTmNormalize(i%InjTm))
	If m%MVCLoc Set:i%MVCLoc'="" i%MVCLoc=(..MVCLocNormalize(i%MVCLoc))
	If m%PtDFN Set:i%PtDFN'="" i%PtDFN=(..PtDFNNormalize(i%PtDFN))
	If m%SafetyEquip Set:i%SafetyEquip'="" i%SafetyEquip=(..SafetyEquipNormalize(i%SafetyEquip))
	If m%VIEN Set:i%VIEN'="" i%VIEN=(..VIENNormalize(i%VIEN))
	If m%WrkRel Set:i%WrkRel'="" i%WrkRel=(..WrkRelNormalize(i%WrkRel))
	Quit 1 }
%ObjectModified() public {
	If $system.CLS.GetModified() Quit 1
	If r%AtFaultOther'="",..AtFaultOther.%ObjectModified() Quit 1
	If r%BusOffc'="",..BusOffc.%ObjectModified() Quit 1
	If r%InjuryDetails'="",..InjuryDetails.%ObjectModified() Quit 1
	Quit 0 }
%SerializeObject(serial,partial=0) public {
	Set $Ztrap = "%SerializeObjectERR"
	Set sc=..%ValidateObject() If ('sc) { Ztrap "SO" }
	Set sc=..%NormalizeObject() If ('sc) { Ztrap "SO" }
	If r%AtFaultOther'="" { Set:'$data(%objTX(1,+r%AtFaultOther,1)) %objTX(1,+r%AtFaultOther)=r%AtFaultOther,%objTX(1,+r%AtFaultOther,1)=..AtFaultOtherGetObject(1),%objTX(1,+r%AtFaultOther,6)=2 Set M%AtFaultOther=1,i%AtFaultOther=$list(%objTX(1,+r%AtFaultOther,1),1,2) }
	If r%BusOffc'="" { Set:'$data(%objTX(1,+r%BusOffc,1)) %objTX(1,+r%BusOffc)=r%BusOffc,%objTX(1,+r%BusOffc,1)=..BusOffcGetObject(1),%objTX(1,+r%BusOffc,6)=2 Set M%BusOffc=1,i%BusOffc=$list(%objTX(1,+r%BusOffc,1),1,2) }
	If r%InjuryDetails'="" { Set:'$data(%objTX(1,+r%InjuryDetails,1)) %objTX(1,+r%InjuryDetails)=r%InjuryDetails,%objTX(1,+r%InjuryDetails,1)=..InjuryDetailsGetObject(1),%objTX(1,+r%InjuryDetails,6)=2 Set M%InjuryDetails=1,i%InjuryDetails=$list(%objTX(1,+r%InjuryDetails,1),1,2) }
	Set serial=..%GetSerial(0),class=$classname(),class=$s($l(class,".")=2:$s($e(class,1,9)="%Library.":"%"_$p(class,".",2),1:class),1:class),serial=$select(serial="":"",1:$listbuild(serial_"",class)),i%"%%OID"=serial
	Quit sc
%SerializeObjectERR	Set $ZTrap="" If $extract($zerror,1,5)'="<ZSO>" Set sc=$$Error^%apiOBJ(5002,$ZE)
	Quit sc }
%AddToSaveSet(depth=3,refresh=0) public {
	If $data(%objTX(1,+$this)) && ('refresh) Quit 1
	Set sc=1,intOref=+$this
	If refresh Set intPoref="" For  Set intPoref=$order(%objTX(1,intOref,2,intPoref)) Quit:intPoref=""  Kill %objTX(1,intPoref,3,intOref),%objTX(1,intOref,2,intPoref)
	Set %objTX(1,intOref)=$this,%objTX(1,intOref,1)="",%objTX(7,intOref)=2
	Set Poref=r%AtFaultOther If Poref'="" Set:'$data(%objTX(1,+Poref)) %objTX(6,$i(%objTX(6)))=Poref Set %objTX(8,$i(%objTX(8)))=$lb(+Poref,intOref,3,$listget(i%AtFaultOther))
	Set Poref=r%BusOffc If Poref'="" Set:'$data(%objTX(1,+Poref)) %objTX(6,$i(%objTX(6)))=Poref Set %objTX(8,$i(%objTX(8)))=$lb(+Poref,intOref,3,$listget(i%BusOffc))
	Set Poref=r%InjuryDetails If Poref'="" Set:'$data(%objTX(1,+Poref)) %objTX(6,$i(%objTX(6)))=Poref Set %objTX(8,$i(%objTX(8)))=$lb(+Poref,intOref,3,$listget(i%InjuryDetails))
exit	Quit sc }
%SetSerial(val) public {
	i val="" { s i%AtFaultAddress="",i%AtFaultInsAdd="",i%AtFaultInsPolicy="",i%AtFaultInsurance="",i%AtFaultName="",i%AtFaultOther="",i%BusOffc="",i%BusOffcCmp="",i%BusOffcStat="",i%EmplAddress="",i%EmplCitySt="",i%EmplName="",i%EmplPh="",i%InjCause="",i%InjCauseIEN="",i%InjDt="",i%InjDtTm="",i%InjLocat="",i%InjSet="",i%InjTm="",i%InjuryDetails="",i%MVCLoc="",i%PtDFN="",i%SafetyEquip="",i%VIEN="",i%WrkRel="" }
	Else {
		s i%AtFaultAddress=$lg(val,1),i%AtFaultInsAdd=$lg(val,2),i%AtFaultInsPolicy=$lg(val,3),i%AtFaultInsurance=$lg(val,4),i%AtFaultName=$lg(val,5),i%AtFaultOther=$lg(val,6),i%InjuryDetails=$lg(val,7),i%BusOffc=$lg(val,8),i%BusOffcCmp=$lg(val,9),i%BusOffcStat=$lg(val,10),i%EmplAddress=$lg(val,11),i%EmplCitySt=$lg(val,12),i%EmplName=$lg(val,13),i%EmplPh=$lg(val,14),i%InjLocat=$lg(val,15),i%InjDt=$lg(val,16),i%InjTm=$lg(val,17),i%VIEN=$lg(val,18),i%PtDFN=$lg(val,19),i%InjCause=$lg(val,20),i%InjSet=$lg(val,21)
		s i%WrkRel=$lg(val,22),i%SafetyEquip=$lg(val,23),i%InjDtTm=$lg(val,24),i%MVCLoc=$lg(val,25),i%InjCauseIEN=$lg(val,26)
	}
	QUIT 1 }
%ValidateObject(force=0) public {
	Set sc=1
	If '$system.CLS.GetModified() Quit sc
	If m%AtFaultAddress Set iv=..AtFaultAddress If iv'="" Set rc=(..AtFaultAddressIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"AtFaultAddress",iv)
	If m%AtFaultInsAdd Set iv=..AtFaultInsAdd If iv'="" Set rc=(..AtFaultInsAddIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"AtFaultInsAdd",iv)
	If m%AtFaultInsPolicy Set iv=..AtFaultInsPolicy If iv'="" Set rc=(..AtFaultInsPolicyIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"AtFaultInsPolicy",iv)
	If m%AtFaultInsurance Set iv=..AtFaultInsurance If iv'="" Set rc=(..AtFaultInsuranceIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"AtFaultInsurance",iv)
	If m%AtFaultName Set iv=..AtFaultName If iv'="" Set rc=(..AtFaultNameIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"AtFaultName",iv)
	If m%BusOffcCmp Set iv=..BusOffcCmp If iv'="" Set rc=(..BusOffcCmpIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"BusOffcCmp",iv)
	If m%BusOffcStat Set iv=..BusOffcStat If iv'="" Set rc=(..BusOffcStatIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"BusOffcStat",iv)
	If m%EmplAddress Set iv=..EmplAddress If iv'="" Set rc=(..EmplAddressIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"EmplAddress",iv)
	If m%EmplCitySt Set iv=..EmplCitySt If iv'="" Set rc=(..EmplCityStIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"EmplCitySt",iv)
	If m%EmplName Set iv=..EmplName If iv'="" Set rc=(..EmplNameIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"EmplName",iv)
	If m%EmplPh Set iv=..EmplPh If iv'="" Set rc=(..EmplPhIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"EmplPh",iv)
	If m%InjCause Set iv=..InjCause If iv'="" Set rc=(..InjCauseIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"InjCause",iv)
	If m%InjCauseIEN Set iv=..InjCauseIEN If iv'="" Set rc=(..InjCauseIENIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"InjCauseIEN",iv)
	If m%InjDt Set iv=..InjDt If iv'="" Set rc=(..InjDtIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"InjDt",iv)
	If m%InjDtTm Set iv=..InjDtTm If iv'="" Set rc=(..InjDtTmIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"InjDtTm",iv)
	If m%InjLocat Set iv=..InjLocat If iv'="" Set rc=(..InjLocatIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"InjLocat",iv)
	If m%InjSet Set iv=..InjSet If iv'="" Set rc=(..InjSetIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"InjSet",iv)
	If m%InjTm Set iv=..InjTm If iv'="" Set rc=(..InjTmIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"InjTm",iv)
	If m%MVCLoc Set iv=..MVCLoc If iv'="" Set rc=(..MVCLocIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"MVCLoc",iv)
	If m%PtDFN Set iv=..PtDFN If iv'="" Set rc=(..PtDFNIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"PtDFN",iv)
	If m%SafetyEquip Set iv=..SafetyEquip If iv'="" Set rc=(..SafetyEquipIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"SafetyEquip",iv)
	If m%VIEN Set iv=..VIEN If iv'="" Set rc=(..VIENIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"VIEN",iv)
	If m%WrkRel Set iv=..WrkRel If iv'="" Set rc=(..WrkRelIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"WrkRel",iv)
	Quit sc }
zLogicalToOdbc(val="") public {
	Set odbc=$listget(val,1)_","_$listget(val,2)_","_$listget(val,3)_","_$listget(val,4)_","_$listget(val,5)_","_$listget(val,6)_","_$listget(val,7)_","_$listget(val,8)_","_$listget(val,9)_","_$listget(val,10)_","_$listget(val,11)_","_$listget(val,12)_","_$listget(val,13)_","_$listget(val,14)_","_$listget(val,15)_","_$listget(val,16)_","_$listget(val,17)_","_$listget(val,18)_","_$listget(val,19)_","_$listget(val,20)_","_$listget(val,21)_","_$listget(val,22)_","_$listget(val,23)_","_$listget(val,24)
	Set odbc=odbc_$listget(val,25)_","_$listget(val,26)
	Quit odbc }
zOdbcToLogical(val="") public {
	Quit $lb($piece(val,",",1),$piece(val,",",2),$piece(val,",",3),$piece(val,",",4),$piece(val,",",5),$piece(val,",",6),$piece(val,",",7),$piece(val,",",8),$piece(val,",",9),$piece(val,",",10),$piece(val,",",11),$piece(val,",",12),$piece(val,",",13),$piece(val,",",14),$piece(val,",",15),$piece(val,",",16),$piece(val,",",17),$piece(val,",",18),$piece(val,",",19),$piece(val,",",20),$piece(val,",",21),$piece(val,",",22),$piece(val,",",23),$piece(val,",",24),$piece(val,",",25),$piece(val,",",26)) }
zPopulateSerial()
	New i,obj,save
	Set obj=##class(BEDD.EDInjury).%New()
	Set obj.AtFaultAddress=##class(%Library.PopulateUtils).String(50)
	Set obj.AtFaultInsAdd=##class(%Library.PopulateUtils).String(50)
	Set obj.AtFaultInsPolicy=##class(%Library.PopulateUtils).String(50)
	Set obj.AtFaultInsurance=##class(%Library.PopulateUtils).String(50)
	Set obj.AtFaultName=##class(%Library.PopulateUtils).String(50)
	Set obj.AtFaultOther=""
	Set obj.BusOffc=""
	Set obj.BusOffcCmp=##class(%Library.PopulateUtils).String(50)
	Set obj.BusOffcStat=##class(%Library.PopulateUtils).String(50)
	Set obj.EmplAddress=##class(%Library.PopulateUtils).String(50)
	Set obj.EmplCitySt=##class(%Library.PopulateUtils).String(50)
	Set obj.EmplName=##class(%Library.PopulateUtils).String(50)
	Set obj.EmplPh=##class(%Library.PopulateUtils).String(50)
	Set obj.InjCause=##class(%Library.PopulateUtils).String(50)
	Set obj.InjCauseIEN=##class(%Library.PopulateUtils).String(50)
	Set obj.InjDt=##class(%Library.PopulateUtils).Date(,)
	Set obj.InjDtTm=##class(%Library.PopulateUtils).String(50)
	Set obj.InjLocat=##class(%Library.PopulateUtils).String(50)
	Set obj.InjSet=##class(%Library.PopulateUtils).String(50)
	Set obj.InjTm=##class(%Library.PopulateUtils).Integer(0,86399)
	Set obj.InjuryDetails=""
	Set obj.MVCLoc=##class(%Library.PopulateUtils).String(50)
	Set obj.PtDFN=##class(%Library.PopulateUtils).String(50)
	Set obj.SafetyEquip=##class(%Library.PopulateUtils).String(50)
	Set obj.VIEN=##class(%Library.PopulateUtils).String(50)
	Set obj.WrkRel=##class(%Library.PopulateUtils).String(50)
	If obj.%GetSwizzleObject(1,.save)
	Set obj=""
	Quit save
zXMLDTD(top,format,input,dtdlist)
 Quit ##class(%XML.Implementation).XMLDTD("BEDD.EDInjury",.top,.format,.input,.dtdlist)
zXMLExportInternal()
 New tag,summary,attrsVal,savelocal,aval,k,tmpPrefix,prefixDepth,hasNoContent,hasElement,topAttrs,beginprefix,endprefix,savexsiAttrs,initialxsiAttrs,initlist,initialCR,inlineFlag,popAtEnd,saveTopPrefix,saveTypesPrefix,saveAttrsPrefix,saveUsePrefix,initlist
 Set $ztrap="XMLExportInternalTrap",popAtEnd=0
 Set summary=summaryArg,initialxsiAttrs=xsiAttrs
 If group Quit $$Error^%apiOBJ(6386,"BEDD.EDInjury")
 If indentFlag Set initialCR=($extract(currentIndent,1,2)=$c(13,10))
 Set id=createId
 Set temp=""
 If id'="" {
   If $piece($get(idlist(+$this)),",",2)'="" Quit 1
   Set idlist(+$this)=id_",1"
 }
 If encoded Set initlist=$lb($get(oreflist),inlineFlagArg),oreflist=1,inlineFlag=inlineFlagArg
 Set tag=$get(topArg)
 Set tmpi=(($get(typeAttr)'="")&&(typeAttr'="BEDD.EDInjury"))
 If $IsObject(namespaces) {
     Set popAtEnd=1,saveTopPrefix=topPrefix,saveTypesPrefix=typesPrefix,saveAttrsPrefix=attrsPrefix,saveUsePrefix=usePrefix
     Set sc=namespaces.PushNodeForExport("",$get(local,0),(encoded||tmpi),"",,.topPrefix,.topAttrs,.typesPrefix,.attrsPrefix,.usePrefix)
     If 'sc Quit sc
   Set beginprefix=$select(namespaces.ElementQualified&&usePrefix:typesPrefix,1:"")
   If topAttrs'="" Set temp=temp_" "_topAttrs
   If tag="" Set tag="EDInjury"
   Set xsitype=namespaces.OutputTypeAttribute
 } Else {
   Set saveTopPrefix=topPrefix,saveTypesPrefix=typesPrefix,saveAttrsPrefix=attrsPrefix,saveUsePrefix=usePrefix
   Set typesPrefix=namespaces If (typesPrefix'=""),($extract(typesPrefix,*)'=":") Set typesPrefix=typesPrefix_":"
   If 'encoded Set namespaces=""
   Set (topPrefix,attrsPrefix,topAttrs,beginprefix)=""
   If tag="" Set tag=typesPrefix_"EDInjury"
   Set xsitype=0
 }
 Set local=+$get(local),savelocal=local
 Set endprefix="</"_beginprefix,beginprefix="<"_beginprefix
 If tmpi Set temp=temp_" "_xsiPrefix_"type="""_typesPrefix_"EDInjury"""_xsiAttrs,xsiAttrs=""
   If id'="" Set temp=" "_$select($get(soap12):soapPrefix_"id",1:"id")_"=""id"_id_""""_temp
 If encoded Set temp=temp_xsiAttrs,xsiAttrs=""
 If indentFlag Set %xmlmsg=currentIndent if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg } Set currentIndent=$select(initialCR:"",1:$c(13,10))_currentIndent_indentChars
 If tag[":" Set topPrefix=$piece(tag,":"),tag=$piece(tag,":",2)  If topPrefix'="" Set topPrefix=topPrefix_":"
 Set %xmlmsg="<"_topPrefix_tag_temp if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set attrsVal=attrsArg,attrsArg="" Set %xmlmsg=attrsVal if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set %xmlmsg=">" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set val=..AtFaultAddress
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"AtFaultAddress"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"string""",1:"")_">"_$select(val=$c(0):"",1:$select((val["<")||(val[">")||(val["&"):"<![CDATA["_$replace(val,"]]>","]]]]><![CDATA[>")_"]]>",1:val))_endprefix_"AtFaultAddress>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..AtFaultInsAdd
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"AtFaultInsAdd"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"string""",1:"")_">"_$select(val=$c(0):"",1:$select((val["<")||(val[">")||(val["&"):"<![CDATA["_$replace(val,"]]>","]]]]><![CDATA[>")_"]]>",1:val))_endprefix_"AtFaultInsAdd>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..AtFaultInsPolicy
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"AtFaultInsPolicy"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"string""",1:"")_">"_$select(val=$c(0):"",1:$select((val["<")||(val[">")||(val["&"):"<![CDATA["_$replace(val,"]]>","]]]]><![CDATA[>")_"]]>",1:val))_endprefix_"AtFaultInsPolicy>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..AtFaultInsurance
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"AtFaultInsurance"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"string""",1:"")_">"_$select(val=$c(0):"",1:$select((val["<")||(val[">")||(val["&"):"<![CDATA["_$replace(val,"]]>","]]]]><![CDATA[>")_"]]>",1:val))_endprefix_"AtFaultInsurance>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..AtFaultName
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"AtFaultName"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"string""",1:"")_">"_$select(val=$c(0):"",1:$select((val["<")||(val[">")||(val["&"):"<![CDATA["_$replace(val,"]]>","]]]]><![CDATA[>")_"]]>",1:val))_endprefix_"AtFaultName>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..AtFaultOther
 If (val'=""),('val.IsNull()) {
   If val.Size=0 {
     Set %xmlmsg=currentIndent_beginprefix_"AtFaultOther />" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
   } Else {
     Set %xmlmsg=currentIndent_beginprefix_"AtFaultOther"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"string""",1:"")_">" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     Set sc=$$WriteCDataCharStream^%occXMLInternal(val) If 'sc Goto XMLExportExit
     Set %xmlmsg=endprefix_"AtFaultOther>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
   }
 }
 Set val=..InjuryDetails
 If (val'=""),('val.IsNull()) {
   If val.Size=0 {
     Set %xmlmsg=currentIndent_beginprefix_"InjuryDetails />" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
   } Else {
     Set %xmlmsg=currentIndent_beginprefix_"InjuryDetails"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"string""",1:"")_">" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     Set sc=$$WriteCDataCharStream^%occXMLInternal(val) If 'sc Goto XMLExportExit
     Set %xmlmsg=endprefix_"InjuryDetails>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
   }
 }
 Set val=..BusOffc
 If (val'=""),('val.IsNull()) {
   If val.Size=0 {
     Set %xmlmsg=currentIndent_beginprefix_"BusOffc />" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
   } Else {
     Set %xmlmsg=currentIndent_beginprefix_"BusOffc"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"string""",1:"")_">" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
     Set sc=$$WriteCDataCharStream^%occXMLInternal(val) If 'sc Goto XMLExportExit
     Set %xmlmsg=endprefix_"BusOffc>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
   }
 }
 Set val=..BusOffcCmp
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"BusOffcCmp"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"string""",1:"")_">"_$select(val=$c(0):"",1:$select((val["<")||(val[">")||(val["&"):"<![CDATA["_$replace(val,"]]>","]]]]><![CDATA[>")_"]]>",1:val))_endprefix_"BusOffcCmp>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..BusOffcStat
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"BusOffcStat"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"string""",1:"")_">"_$select(val=$c(0):"",1:$select((val["<")||(val[">")||(val["&"):"<![CDATA["_$replace(val,"]]>","]]]]><![CDATA[>")_"]]>",1:val))_endprefix_"BusOffcStat>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..EmplAddress
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"EmplAddress"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"string""",1:"")_">"_$select(val=$c(0):"",1:$select((val["<")||(val[">")||(val["&"):"<![CDATA["_$replace(val,"]]>","]]]]><![CDATA[>")_"]]>",1:val))_endprefix_"EmplAddress>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..EmplCitySt
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"EmplCitySt"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"string""",1:"")_">"_$select(val=$c(0):"",1:$select((val["<")||(val[">")||(val["&"):"<![CDATA["_$replace(val,"]]>","]]]]><![CDATA[>")_"]]>",1:val))_endprefix_"EmplCitySt>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..EmplName
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"EmplName"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"string""",1:"")_">"_$select(val=$c(0):"",1:$select((val["<")||(val[">")||(val["&"):"<![CDATA["_$replace(val,"]]>","]]]]><![CDATA[>")_"]]>",1:val))_endprefix_"EmplName>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..EmplPh
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"EmplPh"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"string""",1:"")_">"_$select(val=$c(0):"",1:$select((val["<")||(val[">")||(val["&"):"<![CDATA["_$replace(val,"]]>","]]]]><![CDATA[>")_"]]>",1:val))_endprefix_"EmplPh>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..InjLocat
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"InjLocat"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"string""",1:"")_">"_$select(val=$c(0):"",1:$select((val["<")||(val[">")||(val["&"):"<![CDATA["_$replace(val,"]]>","]]]]><![CDATA[>")_"]]>",1:val))_endprefix_"InjLocat>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..InjDt
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"InjDt"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"date""",1:"")_">"_$select(val="":"",1:$zdate(val,3,,,,,))_endprefix_"InjDt>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..InjTm
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"InjTm"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"time""",1:"")_">"_$select(val="":"",1:$ztime(val,1)_"Z")_endprefix_"InjTm>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..InjDtTm
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"InjDtTm"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"string""",1:"")_">"_$select(val=$c(0):"",1:$select((val["<")||(val[">")||(val["&"):"<![CDATA["_$replace(val,"]]>","]]]]><![CDATA[>")_"]]>",1:val))_endprefix_"InjDtTm>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..VIEN
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"VIEN"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"string""",1:"")_">"_$select(val=$c(0):"",1:$select((val["<")||(val[">")||(val["&"):"<![CDATA["_$replace(val,"]]>","]]]]><![CDATA[>")_"]]>",1:val))_endprefix_"VIEN>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..PtDFN
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"PtDFN"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"string""",1:"")_">"_$select(val=$c(0):"",1:$select((val["<")||(val[">")||(val["&"):"<![CDATA["_$replace(val,"]]>","]]]]><![CDATA[>")_"]]>",1:val))_endprefix_"PtDFN>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..InjCause
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"InjCause"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"string""",1:"")_">"_$select(val=$c(0):"",1:$select((val["<")||(val[">")||(val["&"):"<![CDATA["_$replace(val,"]]>","]]]]><![CDATA[>")_"]]>",1:val))_endprefix_"InjCause>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..InjCauseIEN
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"InjCauseIEN"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"string""",1:"")_">"_$select(val=$c(0):"",1:$select((val["<")||(val[">")||(val["&"):"<![CDATA["_$replace(val,"]]>","]]]]><![CDATA[>")_"]]>",1:val))_endprefix_"InjCauseIEN>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..InjSet
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"InjSet"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"string""",1:"")_">"_$select(val=$c(0):"",1:$select((val["<")||(val[">")||(val["&"):"<![CDATA["_$replace(val,"]]>","]]]]><![CDATA[>")_"]]>",1:val))_endprefix_"InjSet>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..WrkRel
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"WrkRel"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"string""",1:"")_">"_$select(val=$c(0):"",1:$select((val["<")||(val[">")||(val["&"):"<![CDATA["_$replace(val,"]]>","]]]]><![CDATA[>")_"]]>",1:val))_endprefix_"WrkRel>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..SafetyEquip
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"SafetyEquip"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"string""",1:"")_">"_$select(val=$c(0):"",1:$select((val["<")||(val[">")||(val["&"):"<![CDATA["_$replace(val,"]]>","]]]]><![CDATA[>")_"]]>",1:val))_endprefix_"SafetyEquip>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 Set val=..MVCLoc
 If val'="" {
   Set %xmlmsg=currentIndent_beginprefix_"MVCLoc"_$select(xsitype:" "_xsiPrefix_"type="""_schemaPrefix_"string""",1:"")_">"_$select(val=$c(0):"",1:$select((val["<")||(val[">")||(val["&"):"<![CDATA["_$replace(val,"]]>","]]]]><![CDATA[>")_"]]>",1:val))_endprefix_"MVCLoc>" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 }
 If indentFlag Set currentIndent=$extract(currentIndent,1,*-$length(indentChars)) Set %xmlmsg=currentIndent if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg }
 Set %xmlmsg="</"_topPrefix_tag_">" if $data(%xmlBlock) { Do xeWrite^%occXMLInternal } else { write %xmlmsg } If indentFlag,'initialCR if $data(%xmlBlock) { Set %xmlmsg="" Do xeWriteLine^%occXMLInternal } else { write ! } Set $extract(currentIndent,1,2)=""
 If '$IsObject(namespaces) || (popAtEnd=1) Set topPrefix=saveTopPrefix,typesPrefix=saveTypesPrefix,attrsPrefix=saveAttrsPrefix,usePrefix=saveUsePrefix
 If popAtEnd Do namespaces.PopNode()
 If encoded Set oreflist=$list(initlist),inlineFlag=$list(initlist,2)
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
 Quit ##class(%XML.Implementation).XMLGetSchemaImports("BEDD.EDInjury",.imports,.classes)
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
 Set nsIndex=$select($get(namespace)="":"",1:$get(@(tree)@("ns",namespace)))
 Set (node,ref)=nodeArg
 If ($listget($get(@(tree)@(node,0)),1)'="e")||(tag'=@(tree)@(node)) Goto XMLImportMalformed
 If bareProjection Quit $$Error^%apiOBJ(6386,"BEDD.EDInjury")
 If encoded {
   If $data(@(tree)@(node,"a","id")) Set idlist(node)=$this
 }
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
 If tag="AtFaultAddress" {
   If ($get(namespace)'=""),'$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
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
             If data'="" Goto:('$s(($l(data)'>50):1,1:$$Error^%apiOBJ(7201,data,50))) XMLImportErr
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   Set ..AtFaultAddress=data
   Goto XMLLOOP }
 If tag="AtFaultInsAdd" {
   If ($get(namespace)'=""),'$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
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
             If data'="" Goto:('$s(($l(data)'>50):1,1:$$Error^%apiOBJ(7201,data,50))) XMLImportErr
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   Set ..AtFaultInsAdd=data
   Goto XMLLOOP }
 If tag="AtFaultInsPolicy" {
   If ($get(namespace)'=""),'$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
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
             If data'="" Goto:('$s(($l(data)'>50):1,1:$$Error^%apiOBJ(7201,data,50))) XMLImportErr
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   Set ..AtFaultInsPolicy=data
   Goto XMLLOOP }
 If tag="AtFaultInsurance" {
   If ($get(namespace)'=""),'$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
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
             If data'="" Goto:('$s(($l(data)'>50):1,1:$$Error^%apiOBJ(7201,data,50))) XMLImportErr
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   Set ..AtFaultInsurance=data
   Goto XMLLOOP }
 If tag="AtFaultName" {
   If ($get(namespace)'=""),'$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
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
             If data'="" Goto:('$s(($l(data)'>50):1,1:$$Error^%apiOBJ(7201,data,50))) XMLImportErr
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   Set ..AtFaultName=data
   Goto XMLLOOP }
 If tag="AtFaultOther" {
   If ($get(namespace)'=""),'$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
   If encoded,$$XMLImportId() {
     Set data=idlist(ref)
   } Else { Goto:'sc XMLImportExit
     If +$listget($get(@(tree)@(ref,0)),7,0) { Set data=""
     } Else {
       Set data=..AtFaultOther Do data.Rewind()
       Set tmp=##class(%XML.ImportHandler).SerializeNode(tree,ref,1,0,.data,0,0)
       If 'tmp Goto XMLImportErr
       If tmp=-1 Set sc=data.Write("") If 'sc Goto XMLImportExit
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   Goto XMLLOOP }
 If tag="InjuryDetails" {
   If ($get(namespace)'=""),'$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
   If encoded,$$XMLImportId() {
     Set data=idlist(ref)
   } Else { Goto:'sc XMLImportExit
     If +$listget($get(@(tree)@(ref,0)),7,0) { Set data=""
     } Else {
       Set data=..InjuryDetails Do data.Rewind()
       Set tmp=##class(%XML.ImportHandler).SerializeNode(tree,ref,1,0,.data,0,0)
       If 'tmp Goto XMLImportErr
       If tmp=-1 Set sc=data.Write("") If 'sc Goto XMLImportExit
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   Goto XMLLOOP }
 If tag="BusOffc" {
   If ($get(namespace)'=""),'$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
   If encoded,$$XMLImportId() {
     Set data=idlist(ref)
   } Else { Goto:'sc XMLImportExit
     If +$listget($get(@(tree)@(ref,0)),7,0) { Set data=""
     } Else {
       Set data=..BusOffc Do data.Rewind()
       Set tmp=##class(%XML.ImportHandler).SerializeNode(tree,ref,1,0,.data,0,0)
       If 'tmp Goto XMLImportErr
       If tmp=-1 Set sc=data.Write("") If 'sc Goto XMLImportExit
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   Goto XMLLOOP }
 If tag="BusOffcCmp" {
   If ($get(namespace)'=""),'$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
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
             If data'="" Goto:('$s(($l(data)'>50):1,1:$$Error^%apiOBJ(7201,data,50))) XMLImportErr
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   Set ..BusOffcCmp=data
   Goto XMLLOOP }
 If tag="BusOffcStat" {
   If ($get(namespace)'=""),'$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
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
             If data'="" Goto:('$s(($l(data)'>50):1,1:$$Error^%apiOBJ(7201,data,50))) XMLImportErr
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   Set ..BusOffcStat=data
   Goto XMLLOOP }
 If tag="EmplAddress" {
   If ($get(namespace)'=""),'$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
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
             If data'="" Goto:('$s(($l(data)'>50):1,1:$$Error^%apiOBJ(7201,data,50))) XMLImportErr
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   Set ..EmplAddress=data
   Goto XMLLOOP }
 If tag="EmplCitySt" {
   If ($get(namespace)'=""),'$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
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
             If data'="" Goto:('$s(($l(data)'>50):1,1:$$Error^%apiOBJ(7201,data,50))) XMLImportErr
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   Set ..EmplCitySt=data
   Goto XMLLOOP }
 If tag="EmplName" {
   If ($get(namespace)'=""),'$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
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
             If data'="" Goto:('$s(($l(data)'>50):1,1:$$Error^%apiOBJ(7201,data,50))) XMLImportErr
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   Set ..EmplName=data
   Goto XMLLOOP }
 If tag="EmplPh" {
   If ($get(namespace)'=""),'$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
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
             If data'="" Goto:('$s(($l(data)'>50):1,1:$$Error^%apiOBJ(7201,data,50))) XMLImportErr
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   Set ..EmplPh=data
   Goto XMLLOOP }
 If tag="InjLocat" {
   If ($get(namespace)'=""),'$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
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
             If data'="" Goto:('$s(($l(data)'>50):1,1:$$Error^%apiOBJ(7201,data,50))) XMLImportErr
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   Set ..InjLocat=data
   Goto XMLLOOP }
 If tag="InjDt" {
   If ($get(namespace)'=""),'$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
   If encoded,$$XMLImportId() {
     Set data=idlist(ref)
   } Else { Goto:'sc XMLImportExit
     If +$listget($get(@(tree)@(ref,0)),7,0) { Set data=""
     } Else {
             Set data=$order(@(tree)@(ref,"c",""))
             If $order(@(tree)@(ref,"c",data))'="" {
               Set data="" Goto XMLImportErr
             } ElseIf data'="" { Goto:$listget($get(@(tree)@(data,0)),1)="e" XMLImportErr Set data=@(tree)@(data) }
             Set data=$zstrip(data,"<>W",$c(13,10)) If data'="" Set data=..InjDtXSDToLogical(data) Goto:data="" XMLImportErr Goto:('$s($zu(115,13)&&(data=$c(0)):1,$isvalidnum(data,0,0,):1,'$isvalidnum(data):$$Error^%apiOBJ(7207,data),1:$$Error^%apiOBJ(7204,data,0))) XMLImportErr
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   Set ..InjDt=data
   Goto XMLLOOP }
 If tag="InjTm" {
   If ($get(namespace)'=""),'$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
   If encoded,$$XMLImportId() {
     Set data=idlist(ref)
   } Else { Goto:'sc XMLImportExit
     If +$listget($get(@(tree)@(ref,0)),7,0) { Set data=""
     } Else {
             Set data=$order(@(tree)@(ref,"c",""))
             If $order(@(tree)@(ref,"c",data))'="" {
               Set data="" Goto XMLImportErr
             } ElseIf data'="" { Goto:$listget($get(@(tree)@(data,0)),1)="e" XMLImportErr Set data=@(tree)@(data) }
             Set data=$zstrip(data,"<>W",$c(13,10)) If data'="" Set data=..InjTmXSDToLogical(data) Goto:data="" XMLImportErr Goto:('$select($zu(115,13)&&(data=$c(0)):1,$isvalidnum(data,,0,86400)&&(data'=86400):1,'$isvalidnum(data):$$Error^%apiOBJ(7207,data),data<0:$$Error^%apiOBJ(7204,data,0),1:$$Error^%apiOBJ(7203,data,86400))) XMLImportErr
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   Set ..InjTm=data
   Goto XMLLOOP }
 If tag="InjDtTm" {
   If ($get(namespace)'=""),'$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
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
             If data'="" Goto:('$s(($l(data)'>50):1,1:$$Error^%apiOBJ(7201,data,50))) XMLImportErr
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   Set ..InjDtTm=data
   Goto XMLLOOP }
 If tag="VIEN" {
   If ($get(namespace)'=""),'$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
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
             If data'="" Goto:('$s(($l(data)'>50):1,1:$$Error^%apiOBJ(7201,data,50))) XMLImportErr
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   Set ..VIEN=data
   Goto XMLLOOP }
 If tag="PtDFN" {
   If ($get(namespace)'=""),'$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
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
             If data'="" Goto:('$s(($l(data)'>50):1,1:$$Error^%apiOBJ(7201,data,50))) XMLImportErr
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   Set ..PtDFN=data
   Goto XMLLOOP }
 If tag="InjCause" {
   If ($get(namespace)'=""),'$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
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
             If data'="" Goto:('$s(($l(data)'>50):1,1:$$Error^%apiOBJ(7201,data,50))) XMLImportErr
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   Set ..InjCause=data
   Goto XMLLOOP }
 If tag="InjCauseIEN" {
   If ($get(namespace)'=""),'$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
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
             If data'="" Goto:('$s(($l(data)'>50):1,1:$$Error^%apiOBJ(7201,data,50))) XMLImportErr
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   Set ..InjCauseIEN=data
   Goto XMLLOOP }
 If tag="InjSet" {
   If ($get(namespace)'=""),'$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
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
             If data'="" Goto:('$s(($l(data)'>50):1,1:$$Error^%apiOBJ(7201,data,50))) XMLImportErr
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   Set ..InjSet=data
   Goto XMLLOOP }
 If tag="WrkRel" {
   If ($get(namespace)'=""),'$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
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
             If data'="" Goto:('$s(($l(data)'>50):1,1:$$Error^%apiOBJ(7201,data,50))) XMLImportErr
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   Set ..WrkRel=data
   Goto XMLLOOP }
 If tag="SafetyEquip" {
   If ($get(namespace)'=""),'$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
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
             If data'="" Goto:('$s(($l(data)'>50):1,1:$$Error^%apiOBJ(7201,data,50))) XMLImportErr
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   Set ..SafetyEquip=data
   Goto XMLLOOP }
 If tag="MVCLoc" {
   If ($get(namespace)'=""),'$case($listget($get(@(tree)@(ref,0)),3),"":1,nsIndex:1,:0) Goto XMLImportNS
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
             If data'="" Goto:('$s(($l(data)'>50):1,1:$$Error^%apiOBJ(7201,data,50))) XMLImportErr
     }
     If encoded,($data(@(tree)@(ref,"a","id"))) Set idlist(ref)=data
   }
   Set ..MVCLoc=data
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
 If ..AtFaultAddress'="" Quit 0
 If ..AtFaultInsAdd'="" Quit 0
 If ..AtFaultInsPolicy'="" Quit 0
 If ..AtFaultInsurance'="" Quit 0
 If ..AtFaultName'="" Quit 0
 If (..AtFaultOther'=""),('..AtFaultOther.IsNull()) Quit 0
 If (..InjuryDetails'=""),('..InjuryDetails.IsNull()) Quit 0
 If (..BusOffc'=""),('..BusOffc.IsNull()) Quit 0
 If ..BusOffcCmp'="" Quit 0
 If ..BusOffcStat'="" Quit 0
 If ..EmplAddress'="" Quit 0
 If ..EmplCitySt'="" Quit 0
 If ..EmplName'="" Quit 0
 If ..EmplPh'="" Quit 0
 If ..InjLocat'="" Quit 0
 If ..InjDt'="" Quit 0
 If ..InjTm'="" Quit 0
 If ..InjDtTm'="" Quit 0
 If ..VIEN'="" Quit 0
 If ..PtDFN'="" Quit 0
 If ..InjCause'="" Quit 0
 If ..InjCauseIEN'="" Quit 0
 If ..InjSet'="" Quit 0
 If ..WrkRel'="" Quit 0
 If ..SafetyEquip'="" Quit 0
 If ..MVCLoc'="" Quit 0
 Quit 1
zXMLNew(document,node,containerOref="")
	Quit (##class(BEDD.EDInjury).%New())
zXMLSchema(top="",format="",namespacePrefix="",input=0,refOnly=0,schema)
 Quit ##class(%XML.Implementation).XMLSchema("BEDD.EDInjury",top,format,namespacePrefix,input,refOnly,.schema)
zAtFaultOtherDelete(streamvalue) public {
	Set $ZTrap = "CatchError"
	Quit $select(streamvalue="":$$Error^%apiOBJ(5813,$classname()),1:##class(%Library.GlobalCharacterStream).%Delete($select(streamvalue="":"",1:$listbuild($listget(streamvalue),$listget(streamvalue,2),"^BEDD.EDInjuryS"))))
CatchError	Set $ZTrap=""
	Quit $$Error^%apiOBJ(5002,$zerror) }
zAtFaultOtherGetObject(force=0) public {
	Quit:r%AtFaultOther="" $select(i%AtFaultOther="":"",1:$listbuild($listget(i%AtFaultOther),$listget(i%AtFaultOther,2),"^BEDD.EDInjuryS")) Quit:(''..AtFaultOther.%GetSwizzleObject(force,.oid)) oid Quit "" }
zAtFaultOtherGetObjectId(force=0) public {
	Quit $listget(..AtFaultOtherGetObject(force)) }
zAtFaultOtherGetSwizzled() public {
	If i%AtFaultOther="" Set modstate=$system.CLS.GetSModifiedBits() Set oref=..AtFaultOtherNewObject("") Do $system.CLS.SetSModifiedBits(modstate) Set r%AtFaultOther=0,r%AtFaultOther=oref Quit oref
	Set oref=##class(%Library.GlobalCharacterStream).%Open($select(i%AtFaultOther="":"",1:$listbuild($listget(i%AtFaultOther),$listget(i%AtFaultOther,2),"^BEDD.EDInjuryS")),,.sc) If ('sc) Do:$get(^%SYS("ThrowSwizzleError"),0) $zutil(96,3,19,1) Quit ""
	Set modstate=$system.CLS.GetModifiedBits() Set r%AtFaultOther=oref Do $system.CLS.SetModifiedBits(modstate)
	Quit oref }
zAtFaultOtherNewObject(type="") public {
	Set $ZTrap = "CatchError"
	Set sc=1
	If type="" {
		Set type = "%Library.GlobalCharacterStream"
	} ElseIf '($classmethod(type,"%IsA","%Library.GlobalCharacterStream")) {
		Set sc=$$Error^%apiOBJ(5833,"BEDD.EDInjury","AtFaultOther") Quit ""
	}
	Set newobject=$classmethod(type,"%New","^BEDD.EDInjuryS") If newobject="" Quit ""
	Set r%AtFaultOther=0,i%AtFaultOther=0,r%AtFaultOther=newobject,i%AtFaultOther=""
	Quit newobject
CatchError	Set $ZTrap=""
	If (''sc) Set sc = $$Error^%apiOBJ(5002,$ze)
	Quit "" }
zAtFaultOtherOid(streamvalue) public {
	Quit $s($isobject(streamvalue):streamvalue.%Oid(),1:$select(streamvalue="":"",1:$listbuild($listget(streamvalue),$listget(streamvalue,2),"^BEDD.EDInjuryS"))) }
zAtFaultOtherOpen(streamvalue) public {
	If $get(streamvalue)="" {
		Set object=##class(%Library.GlobalCharacterStream).%New("^BEDD.EDInjuryS")
	} elseif $isobject(streamvalue)=1 { set object = streamvalue }
	else {
		Set object=##class(%Library.GlobalCharacterStream).%Open($select(streamvalue="":"",1:$listbuild($listget(streamvalue),$listget(streamvalue,2),"^BEDD.EDInjuryS")))
		If $isobject(object)=1,object.IsNull()=1 Quit ""
	}
	Quit object }
zAtFaultOtherSet(newvalue) public {
	If newvalue="" Set r%AtFaultOther=0,i%AtFaultOther=0,r%AtFaultOther="",i%AtFaultOther="" Quit 1
	If '$isobject(newvalue) Quit $$Error^%apiOBJ(5807,newvalue)
	If newvalue=r%AtFaultOther Quit 1
	If newvalue.%Extends("%AbstractStream") {
		Set r%AtFaultOther=0,i%AtFaultOther=0,r%AtFaultOther=newvalue,i%AtFaultOther=""
	} Else {
		Do ..AtFaultOther.Rewind()
		Quit ..AtFaultOther.CopyFrom(newvalue)
	}
	Quit 1 }
zAtFaultOtherSetObject(newvalue) public {
	Set i%AtFaultOther=0,r%AtFaultOther=0,i%AtFaultOther=newvalue,r%AtFaultOther=""
	Quit 1 }
zAtFaultOtherSetObjectId(newid) public {
	Quit ..AtFaultOtherSetObject($select(newid="":"",1:$listbuild(newid_""))) }
zAtFaultOtherUnSwizzle(force=0) public {
	If r%AtFaultOther="" Quit 1
	Set sc=..AtFaultOther.%GetSwizzleObject(force,.newvalue) Quit:('sc) sc
	Set modstate=$system.CLS.GetModifiedBits() Set r%AtFaultOther="" Do $system.CLS.SetModifiedBits(modstate)
	Set i%AtFaultOther=newvalue
	Quit 1 }
zBusOffcDelete(streamvalue) public {
	Set $ZTrap = "CatchError"
	Quit $select(streamvalue="":$$Error^%apiOBJ(5813,$classname()),1:##class(%Library.GlobalCharacterStream).%Delete($select(streamvalue="":"",1:$listbuild($listget(streamvalue),$listget(streamvalue,2),"^BEDD.EDInjuryS"))))
CatchError	Set $ZTrap=""
	Quit $$Error^%apiOBJ(5002,$zerror) }
zBusOffcGetObject(force=0) public {
	Quit:r%BusOffc="" $select(i%BusOffc="":"",1:$listbuild($listget(i%BusOffc),$listget(i%BusOffc,2),"^BEDD.EDInjuryS")) Quit:(''..BusOffc.%GetSwizzleObject(force,.oid)) oid Quit "" }
zBusOffcGetObjectId(force=0) public {
	Quit $listget(..BusOffcGetObject(force)) }
zBusOffcGetSwizzled() public {
	If i%BusOffc="" Set modstate=$system.CLS.GetSModifiedBits() Set oref=..BusOffcNewObject("") Do $system.CLS.SetSModifiedBits(modstate) Set r%BusOffc=0,r%BusOffc=oref Quit oref
	Set oref=##class(%Library.GlobalCharacterStream).%Open($select(i%BusOffc="":"",1:$listbuild($listget(i%BusOffc),$listget(i%BusOffc,2),"^BEDD.EDInjuryS")),,.sc) If ('sc) Do:$get(^%SYS("ThrowSwizzleError"),0) $zutil(96,3,19,1) Quit ""
	Set modstate=$system.CLS.GetModifiedBits() Set r%BusOffc=oref Do $system.CLS.SetModifiedBits(modstate)
	Quit oref }
zBusOffcNewObject(type="") public {
	Set $ZTrap = "CatchError"
	Set sc=1
	If type="" {
		Set type = "%Library.GlobalCharacterStream"
	} ElseIf '($classmethod(type,"%IsA","%Library.GlobalCharacterStream")) {
		Set sc=$$Error^%apiOBJ(5833,"BEDD.EDInjury","BusOffc") Quit ""
	}
	Set newobject=$classmethod(type,"%New","^BEDD.EDInjuryS") If newobject="" Quit ""
	Set r%BusOffc=0,i%BusOffc=0,r%BusOffc=newobject,i%BusOffc=""
	Quit newobject
CatchError	Set $ZTrap=""
	If (''sc) Set sc = $$Error^%apiOBJ(5002,$ze)
	Quit "" }
zBusOffcOid(streamvalue) public {
	Quit $s($isobject(streamvalue):streamvalue.%Oid(),1:$select(streamvalue="":"",1:$listbuild($listget(streamvalue),$listget(streamvalue,2),"^BEDD.EDInjuryS"))) }
zBusOffcOpen(streamvalue) public {
	If $get(streamvalue)="" {
		Set object=##class(%Library.GlobalCharacterStream).%New("^BEDD.EDInjuryS")
	} elseif $isobject(streamvalue)=1 { set object = streamvalue }
	else {
		Set object=##class(%Library.GlobalCharacterStream).%Open($select(streamvalue="":"",1:$listbuild($listget(streamvalue),$listget(streamvalue,2),"^BEDD.EDInjuryS")))
		If $isobject(object)=1,object.IsNull()=1 Quit ""
	}
	Quit object }
zBusOffcSet(newvalue) public {
	If newvalue="" Set r%BusOffc=0,i%BusOffc=0,r%BusOffc="",i%BusOffc="" Quit 1
	If '$isobject(newvalue) Quit $$Error^%apiOBJ(5807,newvalue)
	If newvalue=r%BusOffc Quit 1
	If newvalue.%Extends("%AbstractStream") {
		Set r%BusOffc=0,i%BusOffc=0,r%BusOffc=newvalue,i%BusOffc=""
	} Else {
		Do ..BusOffc.Rewind()
		Quit ..BusOffc.CopyFrom(newvalue)
	}
	Quit 1 }
zBusOffcSetObject(newvalue) public {
	Set i%BusOffc=0,r%BusOffc=0,i%BusOffc=newvalue,r%BusOffc=""
	Quit 1 }
zBusOffcSetObjectId(newid) public {
	Quit ..BusOffcSetObject($select(newid="":"",1:$listbuild(newid_""))) }
zBusOffcUnSwizzle(force=0) public {
	If r%BusOffc="" Quit 1
	Set sc=..BusOffc.%GetSwizzleObject(force,.newvalue) Quit:('sc) sc
	Set modstate=$system.CLS.GetModifiedBits() Set r%BusOffc="" Do $system.CLS.SetModifiedBits(modstate)
	Set i%BusOffc=newvalue
	Quit 1 }
zInjDtDisplayToLogical(%val) public {
 q:%val="" "" set %val=$zdh(%val,,,5,80,20,,,"Error: '"_%val_"' is an invalid DISPLAY Date value") q:%val||(%val=0) %val s %msg=%val ZTRAP "ODAT" }
zInjDtIsValid(%val) public {
	Q $s($zu(115,13)&&(%val=$c(0)):1,$isvalidnum(%val,0,0,):1,'$isvalidnum(%val):$$Error^%apiOBJ(7207,%val),1:$$Error^%apiOBJ(7204,%val,0)) }
zInjDtLogicalToDisplay(%val) public {
	quit $select(%val="":"",%val'["-":$zdate(%val,,,4),1:$$FormatJulian^%qarfunc(%val,-1)) }
zInjDtLogicalToOdbc(%val="") public {
	Quit $select(%val="":"",%val'["-":$zdate(%val,3),1:%val) }
zInjDtLogicalToXSD(%val) public {
	quit $select(%val="":"",1:$zdate(%val,3,,,,,)) }
zInjDtNormalize(%val) public {
	Quit $s($zu(115,13)&&(%val=$c(0)):"",1:%val\1) }
zInjDtOdbcToLogical(%val="") public {
 quit:%val=""||($zu(115,13)&&(%val=$c(0))) "" set %val=$zdh(%val,3,,,,,,,"Error: '"_%val_"' is an invalid ODBC/JDBC Date value") q:%val||(%val=0) %val s %msg=%val ZTRAP "ODAT" }
zInjDtXSDToLogical(%val) public {
	Set len=$length(%val)
	If len'=10 {
		If $extract(%val,len)="Z" {
			Set %val=$extract(%val,1,len-1),len=len-1
		} ElseIf $case($extract(%val,len-5),"+":1,"-":1,:0) {
			Set %val=$extract(%val,1,len-6),len=len-6
		}
	}
	If $extract(%val,11,19)="T00:00:00" {
	    If (len=19)||(($extract(%val,20,21)=".0")&&($translate($extract(%val,22,len),"0","")="")) {
	        Set %val=$extract(%val,1,10)
	    }
	}
	Quit $select(%val="":"",1:$zdateh(%val,3,,,,,,,"")) }
zInjTmDisplayToLogical(%val)
 quit:%val="" "" s %val=$ztimeh(%val,,"Error: '"_%val_"' is an invalid DISPLAY Time value") q:%val||(%val=0) %val s %msg=%val ZTRAP "OTIM"
	Quit
zInjTmIsValid(%val)
	Quit $select($zu(115,13)&&(%val=$c(0)):1,$isvalidnum(%val,,0,86400)&&(%val'=86400):1,'$isvalidnum(%val):$$Error^%apiOBJ(7207,%val),%val<0:$$Error^%apiOBJ(7204,%val,0),1:$$Error^%apiOBJ(7203,%val,86400))
zInjTmLogicalToDisplay(%val)
	Quit $select(%val="":"",1:$ztime(%val))
zInjTmLogicalToOdbc(%val="")
	Quit $select(%val="":"",1:$ztime(%val))
zInjTmLogicalToXSD(%val)
	Quit $select(%val="":"",1:$ztime(%val,1)_"Z")
zInjTmNormalize(%val)
	Quit $select($zu(115,13)&&(%val=$c(0)):"",1:%val)
zInjTmOdbcToLogical(%val="")
 quit:%val=""||($zu(115,13)&&(%val=$c(0))) "" s %val=$ztimeh(%val,,"Error: '"_%val_"' is an invalid ODBC/JDBC Time value") q:%val||(%val=0) %val s %msg=%val ZTRAP "OTIM"
	Quit
zInjTmXSDToLogical(%val)
 New len,s,z
 If $get(%val)="" Quit ""
 If $length(%val,"T")=2 Set %val=$piece(%val,"T",2)
 Set len=$length(%val)
 If $extract(%val,len)="Z" {
   Set %val=$extract(%val,1,len-1)
 } ElseIf $case($extract(%val,len-5),"+":1,"-":1,:0) {
   If $extract(%val,len-2)'=":" Quit ""
   Set s=$ztimeh($extract(%val,1,len-6),1,"") If s="" Quit ""
   Set z=($extract(%val,len-4,len-3)*60+$extract(%val,len-1,len))*60
   If $extract(%val,len-5)="-" {
     Set s=s+z
   } Else {
     Set s=s-z
   }
   Quit s#(24*60*60)
 }
 Quit $ztimeh(%val,1,"")
zInjuryDetailsDelete(streamvalue) public {
	Set $ZTrap = "CatchError"
	Quit $select(streamvalue="":$$Error^%apiOBJ(5813,$classname()),1:##class(%Library.GlobalCharacterStream).%Delete($select(streamvalue="":"",1:$listbuild($listget(streamvalue),$listget(streamvalue,2),"^BEDD.EDInjuryS"))))
CatchError	Set $ZTrap=""
	Quit $$Error^%apiOBJ(5002,$zerror) }
zInjuryDetailsGetObject(force=0) public {
	Quit:r%InjuryDetails="" $select(i%InjuryDetails="":"",1:$listbuild($listget(i%InjuryDetails),$listget(i%InjuryDetails,2),"^BEDD.EDInjuryS")) Quit:(''..InjuryDetails.%GetSwizzleObject(force,.oid)) oid Quit "" }
zInjuryDetailsGetObjectId(force=0) public {
	Quit $listget(..InjuryDetailsGetObject(force)) }
zInjuryDetailsGetSwizzled() public {
	If i%InjuryDetails="" Set modstate=$system.CLS.GetSModifiedBits() Set oref=..InjuryDetailsNewObject("") Do $system.CLS.SetSModifiedBits(modstate) Set r%InjuryDetails=0,r%InjuryDetails=oref Quit oref
	Set oref=##class(%Library.GlobalCharacterStream).%Open($select(i%InjuryDetails="":"",1:$listbuild($listget(i%InjuryDetails),$listget(i%InjuryDetails,2),"^BEDD.EDInjuryS")),,.sc) If ('sc) Do:$get(^%SYS("ThrowSwizzleError"),0) $zutil(96,3,19,1) Quit ""
	Set modstate=$system.CLS.GetModifiedBits() Set r%InjuryDetails=oref Do $system.CLS.SetModifiedBits(modstate)
	Quit oref }
zInjuryDetailsNewObject(type="") public {
	Set $ZTrap = "CatchError"
	Set sc=1
	If type="" {
		Set type = "%Library.GlobalCharacterStream"
	} ElseIf '($classmethod(type,"%IsA","%Library.GlobalCharacterStream")) {
		Set sc=$$Error^%apiOBJ(5833,"BEDD.EDInjury","InjuryDetails") Quit ""
	}
	Set newobject=$classmethod(type,"%New","^BEDD.EDInjuryS") If newobject="" Quit ""
	Set r%InjuryDetails=0,i%InjuryDetails=0,r%InjuryDetails=newobject,i%InjuryDetails=""
	Quit newobject
CatchError	Set $ZTrap=""
	If (''sc) Set sc = $$Error^%apiOBJ(5002,$ze)
	Quit "" }
zInjuryDetailsOid(streamvalue) public {
	Quit $s($isobject(streamvalue):streamvalue.%Oid(),1:$select(streamvalue="":"",1:$listbuild($listget(streamvalue),$listget(streamvalue,2),"^BEDD.EDInjuryS"))) }
zInjuryDetailsOpen(streamvalue) public {
	If $get(streamvalue)="" {
		Set object=##class(%Library.GlobalCharacterStream).%New("^BEDD.EDInjuryS")
	} elseif $isobject(streamvalue)=1 { set object = streamvalue }
	else {
		Set object=##class(%Library.GlobalCharacterStream).%Open($select(streamvalue="":"",1:$listbuild($listget(streamvalue),$listget(streamvalue,2),"^BEDD.EDInjuryS")))
		If $isobject(object)=1,object.IsNull()=1 Quit ""
	}
	Quit object }
zInjuryDetailsSet(newvalue) public {
	If newvalue="" Set r%InjuryDetails=0,i%InjuryDetails=0,r%InjuryDetails="",i%InjuryDetails="" Quit 1
	If '$isobject(newvalue) Quit $$Error^%apiOBJ(5807,newvalue)
	If newvalue=r%InjuryDetails Quit 1
	If newvalue.%Extends("%AbstractStream") {
		Set r%InjuryDetails=0,i%InjuryDetails=0,r%InjuryDetails=newvalue,i%InjuryDetails=""
	} Else {
		Do ..InjuryDetails.Rewind()
		Quit ..InjuryDetails.CopyFrom(newvalue)
	}
	Quit 1 }
zInjuryDetailsSetObject(newvalue) public {
	Set i%InjuryDetails=0,r%InjuryDetails=0,i%InjuryDetails=newvalue,r%InjuryDetails=""
	Quit 1 }
zInjuryDetailsSetObjectId(newid) public {
	Quit ..InjuryDetailsSetObject($select(newid="":"",1:$listbuild(newid_""))) }
zInjuryDetailsUnSwizzle(force=0) public {
	If r%InjuryDetails="" Quit 1
	Set sc=..InjuryDetails.%GetSwizzleObject(force,.newvalue) Quit:('sc) sc
	Set modstate=$system.CLS.GetModifiedBits() Set r%InjuryDetails="" Do $system.CLS.SetModifiedBits(modstate)
	Set i%InjuryDetails=newvalue
	Quit 1 }
