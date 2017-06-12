 ;BEDD.EDVISIT.1
 ;(C)InterSystems, generated for class BEDD.EDVISIT.  Do NOT edit. 04/14/2017 08:47:49AM
 ;;35564378;BEDD.EDVISIT
 ;
SQLUPPER(v,l) { quit $zu(28,v,7,$g(l,32767)) }
ALPHAUP(v,r) { quit $zu(28,v,6) }
STRING(v,l) { quit $zu(28,v,9,$g(l,32767)) }
SQLSTRING(v,l) { quit $zu(28,v,8,$g(l,32767)) }
UPPER(v) { quit $zu(28,v,5) }
MVR(v) { quit $zu(28,v,2) }
TRUNCATE(v,l) { quit $e(v,1,$g(l,3641144)) }
%BindExport(dev,Seen,RegisterOref,AllowedDepth,AllowedCapacity) public {
   i $d(Seen(+$this)) q 1
   Set Seen(+$this)=$this
   s sc = 1
 s proporef=..Info
 s proporef=..PtInjury
   d:RegisterOref InitObjVar^%SYS.BINDSRV($this)
   i dev'="" s t=$io u dev i $zobjexport($this_"",3)+$zobjexport($this."%%OID",3)+$zobjexport($this,3)!1 u t
 If AllowedDepth>0 Set AllowedDepth = AllowedDepth - 1
 If AllowedCapacity>0 Set AllowedCapacity = AllowedCapacity - 1/2
 s proporef=..Info
 s proporef=..PtInjury
       i proporef'="" s sc=1 i AllowedDepth'=0,AllowedCapacity'=0 s sc=proporef.%BindExport(dev,.Seen,RegisterOref,AllowedDepth,AllowedCapacity) q:('sc) sc
   Quit sc }
%BuildIndices(idxlist="",autoPurge=0,lockExtent=0) public {
	set $ZTrap="CatchError",locked=0,sc=1,sHandle=1,sHandle($classname())=$c(0,0,0,0,0)
	for ptr=1:1:$listlength(idxlist) { if '$d(^oddCOM($classname(),"i",$list(idxlist,ptr))) { set sc=$$Error^%apiOBJ(5066,$classname()_"::"_$list(idxlist,ptr)) continue } } if ('sc) { quit sc }
	if lockExtent { s sc=..%LockExtent(0) i ('sc) { q sc } else { s locked=1 } }
	if $system.CLS.IsMthd($classname(),"%OnBeforeBuildIndices") { set sc=..%OnBeforeBuildIndices(.idxlist) i ('sc) { i locked { d ..%SQLReleaseTableLock(0) } quit sc } }
	if autoPurge { s sc = ..%PurgeIndices(idxlist) i ('sc) { quit sc }}
	if (idxlist="")||($listfind(idxlist,"ADIdx")) { set $Extract(sHandle($classname()),1)=$c(1) If $SortBegin(^BEDD.EDVISITI("ADIdx")) }
	if (idxlist="")||($listfind(idxlist,"ArrIdx")) { set $Extract(sHandle($classname()),2)=$c(1) If $SortBegin(^BEDD.EDVISITI("ArrIdx")) }
	if (idxlist="")||($listfind(idxlist,"CIDtIIdx")) { set $Extract(sHandle($classname()),3)=$c(1) If $SortBegin(^BEDD.EDVISITI("CIDtIIdx")) }
	if (idxlist="")||($listfind(idxlist,"DCDTIdx")) { set $Extract(sHandle($classname()),4)=$c(1) If $SortBegin(^BEDD.EDVISITI("DCDTIdx")) }
	if (idxlist="")||($listfind(idxlist,"DisIdx")) { set $Extract(sHandle($classname()),5)=$c(1) If $SortBegin(^BEDD.EDVISITI("DisIdx")) }
	set id=""
BSLoop	set id=$order(^BEDD.EDVISITD(id)) Goto:id="" BSLoopDun
	set sc = ..%FileIndices(id,.sHandle) if ('sc) { goto BSLoopDun }
	Goto BSLoop
BSLoopDun
	if $Ascii(sHandle($classname()),1) If $SortEnd(^BEDD.EDVISITI("ADIdx"))
	if $Ascii(sHandle($classname()),2) If $SortEnd(^BEDD.EDVISITI("ArrIdx"))
	if $Ascii(sHandle($classname()),3) If $SortEnd(^BEDD.EDVISITI("CIDtIIdx"))
	if $Ascii(sHandle($classname()),4) If $SortEnd(^BEDD.EDVISITI("DCDTIdx"))
	if $Ascii(sHandle($classname()),5) If $SortEnd(^BEDD.EDVISITI("DisIdx"))
	if $system.CLS.IsMthd($classname(),"%OnAfterBuildIndices") { set sc=..%OnAfterBuildIndices(.idxlist)}
	i locked { d ..%UnlockExtent(0) }
	QUIT sc
CatchError	s $ZTrap="" i $ZE'="" { s sc = $$Error^%apiOBJ(5002,$ZE) } i $g(locked) { d ..%UnlockExtent(0) } q sc }
%ComposeOid(id) public {
	set tCLASSNAME = $listget($g(^BEDD.EDVISITD(id)),1)
	if tCLASSNAME="" { quit $select(id="":"",1:$listbuild(id_"","BEDD.EDVISIT")) }
	set tClass=$piece(tCLASSNAME,$extract(tCLASSNAME),$length(tCLASSNAME,$extract(tCLASSNAME))-1)
	set:tClass'["." tClass="User."_tClass
	quit $select(id="":"",1:$listbuild(id_"",tClass)) }
%Construct(initvalue) public {
	Set i%%Concurrency=$zu(115,10)
	Kill i%PtInjury
	Quit 1 }
%ConstructCloneInit(object,deep=0,cloned,location) public {
	If i%Info'=""||($isobject(r%Info)=1) Set r%Info=..Info.%ConstructClone(deep,.cloned),i%Info=""
	Set i%"%%OID"=""
	If deep>0 {
		If $data(i%PtInjury),$isobject(..PtInjury)=1 Set r%PtInjury=r%PtInjury.%ConstructClone(1,.cloned),i%PtInjury=""
	}
	Quit 1 }
%Delete(oid="",concurrency=-1) public {
	Quit:oid="" $$Error^%apiOBJ(5813,$classname()) Set id=$listget(oid) Quit:id="" $$Error^%apiOBJ(5812,$classname()) set traninit=0
	set $ZTRAP="%DeleteERR"
	If concurrency = -1 Set concurrency=$zu(115,10)
	If (concurrency > 4) || (concurrency < 0) || (concurrency '= (concurrency\1)) Quit $$Error^%apiOBJ(5828)
	Set class=$listget(oid,2)
	If class="" { Set sc=..%OnDetermineClass(oid,.class) Quit:('sc) sc Set oid=$select(oid="":"",1:$listbuild($listget(oid),class)_$select($listget(oid,3)'="":$listbuild($list(oid,3)),1:"")) } Else { Set class=$s(class="":"",class[".":class,$e(class)'="%":"User."_class,1:"%Library."_$e(class,2,*)) }
	If $classname()'=class Quit $classmethod(class,"%Delete",oid,concurrency)
	If +$g(%objtxSTATUS)=0 { Set traninit=1 k %objtxSTATUS,%objtxLIST,%objtxOIDASSIGNED,%objtxOIDUNASSIGNED,%objtxMODIFIED k:'$TLevel %0CacheLock,%objtxTID,%objtxID i '$zu(115,9) { s %objtxSTATUS=1 } else { TStart  s %objtxSTATUS=2 } }
	Set oref=..%Open(oid,concurrency) If oref="" Set sc=$$Error^%apiOBJ(5810,$classname(),$listget(oid)) Goto %DeleteEnd
	Set stream=oref.InfoGetObject() If stream'="" set ^||%isc.strd($i(^||%isc.strd))=$lb(stream,"%Library.GlobalCharacterStream")
	Set sc = ##class("BEDD.EDInjury").%Delete(oref.PtInjuryGetObject(0),concurrency) Goto:('sc) %DeleteEnd
	Set oref=""
	Set oref=$zobjoid($listget(oid,2),$listget(oid)) If $isobject(oref)=1 Do oref.%DeleteOID()
	Set sc=..%DeleteData(id,concurrency)
	if (''sc) {
		set tPtr = "" For { set tPtr=$order(^||%isc.strd(tPtr),1,tStreamData) Quit:tPtr=""  Set stream=$li(tStreamData,1),cls=$li(tStreamData,2),sc=$classmethod(cls,"%Delete",stream,concurrency) If ('sc) Quit }
		Kill ^||%isc.strd
	}
%DeleteEnd if ('sc) { kill ^||%isc.strd } If traninit { If (''sc) { i $g(%objtxSTATUS)=1 { k %objtxSTATUS } else { If $Tlevel { TCommit  } k %objtxSTATUS,%objtxLIST,%objtxOIDASSIGNED,%objtxOIDUNASSIGNED,%objtxMODIFIED k:'$TLevel %0CacheLock,%objtxTID,%objtxID } } Else { i $g(%objtxSTATUS)=2 { k %0CacheLock s sc=$select(+sc:$$%TRollBack^%occTransaction(),1:$$AppendStatus^%occSystem(sc,$$%TRollBack^%occTransaction())) k %objtxTID,%objtxID } else { k %objtxSTATUS } } }
	Quit sc
%DeleteERR	Set $ZTrap="", sc=$$Error^%apiOBJ(5002,$ZE) goto %DeleteEnd }
%DeleteData(id,concurrency) public {
	Quit:id="" $$Error^%apiOBJ(5812)
	Set $Ztrap="DeleteDataERR" Set extentlock=0,sc=""
	If concurrency { If '$tlevel { Kill %0CacheLock } If $increment(%0CacheLock($classname()))>$zu(115,6) { Lock +(^BEDD.EDVISITD):$zu(115,4) Set extentlock=$test Lock:extentlock -(^BEDD.EDVISITD) } If 'extentlock { Lock +(^BEDD.EDVISITD(id)):$zu(115,4) } If '$test { QUIT $$Error^%apiOBJ(5803,$classname()) }}
	If ($Data(^BEDD.EDVISITD(id))) {
		Set bsv0N1=^BEDD.EDVISITD(id)
		Set bsv0N2=$listget(bsv0N1,2)
		If $data(^oddEXTR($classname())) {
			n %fc,%fk,%z
			Set %fc="" For  Set %fc=$order(^oddEXTR($classname(),"n","IDKEY","f",%fc)) Quit:%fc=""  Set %fk="" For  Set %fk=$order(^oddEXTR($classname(),"n","IDKEY","f",%fc,%fk)) Quit:%fk=""  Set %z=$get(^oddEXTR($classname(),"n","IDKEY","f",%fc,%fk,61)) If %z'="" Set sc=$classmethod(%fc,%fk_"Delete",id) If ('sc) Goto DeleteDataEXIT
		}
		Set bsv0N3=$listget(bsv0N1,31)
		Set bsv0N4=..CIDtCompute(id,bsv0N2,$listget(bsv0N1,27))
		Set bsv0N5=..DCDtCompute(id,bsv0N2)
		Kill ^BEDD.EDVISITI("ADIdx",$s(bsv0N3'="":bsv0N3,1:-1E14),id)
		Kill ^BEDD.EDVISITI("ArrIdx",$s(bsv0N4'="":bsv0N4,1:-1E14),id)
		Kill ^BEDD.EDVISITI("CIDtIIdx",$s(bsv0N4'="":bsv0N4,1:-1E14),id)
		Kill ^BEDD.EDVISITI("DCDTIdx",$zu(28,$listget(bsv0N1,7),7,32768),id)
		Kill ^BEDD.EDVISITI("DisIdx",$s(bsv0N5'="":bsv0N5,1:-1E14),id)
		Kill ^BEDD.EDVISITD(id)
		Set sc=1
	}
	else { set sc=$$Error^%apiOBJ(5810,$classname(),id) }
DeleteDataEXIT
	If (concurrency) && ('extentlock) { Lock -(^BEDD.EDVISITD(id)) }
DeleteDataRET	Set $Ztrap = ""
	QUIT sc
DeleteDataERR	Set $Ztrap = "DeleteDataRET"
	Set sc = $$Error^%apiOBJ(5002,$ZE)
	Goto DeleteDataEXIT }
%Exists(oid="") public {
	Quit ..%ExistsId($listget(oid)) }
%ExistsId(id) public {
	try { set tExists = $s(id="":0,$d(^BEDD.EDVISITD(id)):1,1:0) } catch tException { set tExists = 0 } quit tExists }
%FileIndices(id,pIndexHandle=0) public {
	s $ZTrap="CatchError",sc=1
	Set bsv0N2=$Get(^BEDD.EDVISITD(id))
	if $listget(bsv0N2,1)'="" { set bsv0N1=$piece($listget(bsv0N2,1),$extract($listget(bsv0N2,1)),$length($listget(bsv0N2,1),$extract($listget(bsv0N2,1)))-1) set:bsv0N1'["." bsv0N1="User."_bsv0N1 if bsv0N1'=$classname() { quit $classmethod(bsv0N1,"%FileIndices",id,.pIndexHandle) } }
	Set bsv0N3=$listget(bsv0N2,2)
	If ('pIndexHandle)||($Ascii($Get(pIndexHandle("BEDD.EDVISIT")),1)) {
		Set bsv0N4=$listget(bsv0N2,31)
		Set bsv0N5=$s(bsv0N4'="":bsv0N4,1:-1E14)
		Set ^BEDD.EDVISITI("ADIdx",bsv0N5,id)=$listget(bsv0N2,1)
	}
	If ('pIndexHandle)||($Ascii($Get(pIndexHandle("BEDD.EDVISIT")),2)) {
		Set bsv0N6=..CIDtCompute(id,bsv0N3,$listget(bsv0N2,27))
		Set bsv0N7=$s(bsv0N6'="":bsv0N6,1:-1E14)
		Set ^BEDD.EDVISITI("ArrIdx",bsv0N7,id)=$lb($listget(bsv0N2,1),bsv0N6)
	}
	If ('pIndexHandle)||($Ascii($Get(pIndexHandle("BEDD.EDVISIT")),3)) {
		Set bsv0N8=..CIDtCompute(id,bsv0N3,$listget(bsv0N2,27))
		Set bsv0N9=$s(bsv0N8'="":bsv0N8,1:-1E14)
		Set ^BEDD.EDVISITI("CIDtIIdx",bsv0N9,id)=$lb($listget(bsv0N2,1),bsv0N8)
	}
	If ('pIndexHandle)||($Ascii($Get(pIndexHandle("BEDD.EDVISIT")),4)) {
		Set bsv0N10=$zu(28,$listget(bsv0N2,7),7,32768)
		Set ^BEDD.EDVISITI("DCDTIdx",bsv0N10,id)=$listget(bsv0N2,1)
	}
	If ('pIndexHandle)||($Ascii($Get(pIndexHandle("BEDD.EDVISIT")),5)) {
		Set bsv0N11=..DCDtCompute(id,bsv0N3)
		Set bsv0N12=$s(bsv0N11'="":bsv0N11,1:-1E14)
		Set ^BEDD.EDVISITI("DisIdx",bsv0N12,id)=$listget(bsv0N2,1)
	}
	QUIT 1
CatchError	s $ZTrap="" i $ZE'="" { s sc = $$Error^%apiOBJ(5002,$ZE) } q sc }
%InsertBatch(objects,concurrency=0,useTransactions=0) public {
	s $ZTrap="InsertBatchERR"
	s numerrs=0,errs="",cnt=0,ptr=0
	while $listnext(objects,ptr,data) {
		Set bsv0N1=..DCDtCompute(id,$listget(data,2))
		Set bsv0N2=..CIDtCompute(id,$listget(data,2),$listget(data,27))
		Set bsv0N3=$listget(data,31)
		s cnt=cnt+1,sc=1
		do
 {
			if (useTransactions) tstart
			s id=$i(^BEDD.EDVISITD)
			Set lock=0,locku=""
			If '$Tlevel { Kill %0CacheLock }
			i concurrency { If $i(%0CacheLock($classname()))>$zu(115,6) { Lock +(^BEDD.EDVISITD):$zu(115,4) Set lock=$Select($test:2,1:0) Lock:lock -(^BEDD.EDVISITD) } Else { Lock +(^BEDD.EDVISITD(id)):$zu(115,4) Set lock=$Select($test:1,1:0) } If 'lock { Set sc=$$Error^%apiOBJ(5803,$classname()) Quit } }
			s ^BEDD.EDVISITD(id)=data
			s ^BEDD.EDVISITI("ADIdx",$s(bsv0N3'="":bsv0N3,1:-1E14),id)=$listget(data,1)
			s ^BEDD.EDVISITI("ArrIdx",$s(bsv0N2'="":bsv0N2,1:-1E14),id)=$lb($listget(data,1),bsv0N2)
			s ^BEDD.EDVISITI("CIDtIIdx",$s(bsv0N2'="":bsv0N2,1:-1E14),id)=$lb($listget(data,1),bsv0N2)
			s ^BEDD.EDVISITI("DCDTIdx",$zu(28,$listget(data,7),7,32768),id)=$listget(data,1)
			s ^BEDD.EDVISITI("DisIdx",$s(bsv0N1'="":bsv0N1,1:-1E14),id)=$listget(data,1)
		}
		while 0
		If lock=1 Lock -(^BEDD.EDVISITD(id))
		if (''sc) { if (useTransactions) { tcommit } }
		else {
			s newerr=$lb(cnt,sc)
			if '($length(errs)+$length(newerr)>32767) { s numerrs=numerrs+1, errs=errs_newerr }
			if (useTransactions) && ($Tlevel) trollback
		}
	}
InsertBatchRET	Set $Ztrap = ""
	q ($lb(numerrs))_errs
InsertBatchERR	Set $Ztrap = "InsertBatchRET"
	s newerr=$lb($g(cnt),$$Error^%apiOBJ(5002,$ZE))
	if '($length(errs)+$length(newerr)>32767) { s numerrs=numerrs+1, errs=errs_newerr }
	Goto InsertBatchRET }
%KillExtentData()
	Kill ^BEDD.EDVISITD
	Quit 1
%LoadData(id)
	New sc
	Set sc=""
	If ..%Concurrency=4 Lock +(^BEDD.EDVISITD(id)):$zu(115,4) If '$test QUIT $$Error^%apiOBJ(5803,$classname())
	If ..%Concurrency'=4,..%Concurrency>1 Lock +(^BEDD.EDVISITD(id)#"S"):$zu(115,4) If '$test QUIT $$Error^%apiOBJ(5804,$classname())
	i '$d(^BEDD.EDVISITD(id)) Do
	. s i%AMERVSIT="",i%AsgCln="",i%AsgNrs="",i%AsgPrv="",i%Clinic="",i%CodeBlue="",i%DCDPrvH="",i%DCDispH="",i%DCDocH="",i%DCDocHEDt="",i%DCDocHETm="",i%DCDocHSDt="",i%DCDocHSTm="",i%DCDtH="",i%DCFlag="",i%DCInstH="",i%DCMode="",i%DCModeN="",i%DCNrsH="",i%DCPrvH="",i%DCStat="",i%DCStatN="",i%DCTmH="",i%DCTrgH="",i%DCTrns="",i%DCTrnsN="",i%DecAdmDt="",i%EDConsult="",i%EDDx="",i%EDProcedure="",i%EDTrans="",i%Info="",i%Injury="",i%ORmDt="",i%ORmTm="",i%OrgRoom="",i%OrgRoomDt=""
	. Set i%OrgRoomTime="",i%PrimDx="",i%PrimDxH="",i%PrimDxNarr="",i%PrimICD="",i%PrimPrv="",i%PrimaryNurse="",i%PrmNurse="",i%PtDFN="",i%PtInjury="",i%PtStat="",i%PtStatV="",i%RClDt="",i%RClTm="",i%RecLock="",i%RecLockDT="",i%RecLockSite="",i%RecLockUser="",i%Room="",i%RoomClear="",i%RoomDt="",i%RoomDtTm="",i%RoomTime="",i%VIEN=""
	Else  Do
	. New %s1
	. Set sc=1
	. s %s1=$g(^BEDD.EDVISITD(id))
	. s i%AMERVSIT=$lg(%s1,2),i%AsgCln=$lg(%s1,3),i%AsgNrs=$lg(%s1,4),i%AsgPrv=$lg(%s1,5),i%CodeBlue=$lg(%s1,6),i%DCDtH=$lg(%s1,7),i%DCTmH=$lg(%s1,8),i%DCNrsH=$lg(%s1,9),i%DCPrvH=$lg(%s1,10),i%DCDPrvH=$lg(%s1,11),i%DCDispH=$lg(%s1,12),i%DCInstH=$lg(%s1,13),i%DCTrgH=$lg(%s1,14),i%DCStat=$lg(%s1,15),i%DCStatN=$lg(%s1,16),i%DCFlag=$lg(%s1,17),i%EDConsult=$lg(%s1,18),i%EDProcedure=$lg(%s1,19),i%EDTrans=$lg(%s1,20),i%EDDx=$lg(%s1,21),i%PrimDx=$lg(%s1,22),i%PrimICD=$lg(%s1,23),i%Info=$lg(%s1,24),i%Injury=$lg(%s1,25)
	. s i%PtInjury=$lg(%s1,26),i%PtDFN=$lg(%s1,27),i%Room=$lg(%s1,28),i%RoomDt=$lg(%s1,29),i%RoomTime=$lg(%s1,30),i%VIEN=$lg(%s1,31),i%PrimDxH=$lg(%s1,32),i%PrimPrv=$lg(%s1,33),i%DCTrns=$lg(%s1,34),i%DCTrnsN=$lg(%s1,35),i%DCMode=$lg(%s1,36),i%DCModeN=$lg(%s1,37),i%OrgRoom=$lg(%s1,38),i%OrgRoomDt=$lg(%s1,39),i%OrgRoomTime=$lg(%s1,40),i%Clinic=$lg(%s1,41),i%DCDocH=$lg(%s1,42),i%PtStat=$lg(%s1,43),i%RecLock=$lg(%s1,45),i%RecLockUser=$lg(%s1,46),i%RecLockDT=$lg(%s1,47),i%PtStatV=$lg(%s1,48),i%DCDocHSDt=$lg(%s1,51)
	. s i%DCDocHSTm=$lg(%s1,52),i%DCDocHEDt=$lg(%s1,53),i%DCDocHETm=$lg(%s1,54),i%PrimDxNarr=$lg(%s1,55),i%RoomDtTm=$lg(%s1,56),i%ORmDt=$lg(%s1,57),i%ORmTm=$lg(%s1,58),i%PrimaryNurse=$lg(%s1,59),i%RoomClear=$lg(%s1,60),i%RClDt=$lg(%s1,61),i%RClTm=$lg(%s1,62),i%PrmNurse=$lg(%s1,63),i%DecAdmDt=$lg(%s1,64),i%RecLockSite=$lg(%s1,65)
	If ..%Concurrency=2 Lock -(^BEDD.EDVISITD(id)#"SI")
	Quit $select(sc'="":sc,1:$$Error^%apiOBJ(5809,$classname(),id))
%LoadDataFromMemory(id,objstate,obj)
	New sc
	Set sc=""
	i '$d(objstate(id)) Do
	. Set i%AMERVSIT="",i%AsgCln="",i%AsgNrs="",i%AsgPrv="",i%Clinic="",i%CodeBlue="",i%DCDPrvH="",i%DCDispH="",i%DCDocH="",i%DCDocHEDt="",i%DCDocHETm="",i%DCDocHSDt="",i%DCDocHSTm="",i%DCDtH="",i%DCFlag="",i%DCInstH="",i%DCMode="",i%DCModeN="",i%DCNrsH="",i%DCPrvH="",i%DCStat="",i%DCStatN="",i%DCTmH="",i%DCTrgH="",i%DCTrns="",i%DCTrnsN="",i%DecAdmDt="",i%EDConsult="",i%EDDx="",i%EDProcedure="",i%EDTrans="",i%Info="",i%Injury="",i%ORmDt="",i%ORmTm="",i%OrgRoom="",i%OrgRoomDt="",i%OrgRoomTime=""
	. Set i%PrimDx="",i%PrimDxH="",i%PrimDxNarr="",i%PrimICD="",i%PrimPrv="",i%PrimaryNurse="",i%PrmNurse="",i%PtDFN="",i%PtInjury="",i%PtStat="",i%PtStatV="",i%RClDt="",i%RClTm="",i%RecLock="",i%RecLockDT="",i%RecLockSite="",i%RecLockUser="",i%Room="",i%RoomClear="",i%RoomDt="",i%RoomDtTm="",i%RoomTime="",i%VIEN=""
	Else  Do
	. New %s1
	. Set sc=1
	. s %s1=$g(objstate(id))
	. s i%AMERVSIT=$lg(%s1,2),i%AsgCln=$lg(%s1,3),i%AsgNrs=$lg(%s1,4),i%AsgPrv=$lg(%s1,5),i%CodeBlue=$lg(%s1,6),i%DCDtH=$lg(%s1,7),i%DCTmH=$lg(%s1,8),i%DCNrsH=$lg(%s1,9),i%DCPrvH=$lg(%s1,10),i%DCDPrvH=$lg(%s1,11),i%DCDispH=$lg(%s1,12),i%DCInstH=$lg(%s1,13),i%DCTrgH=$lg(%s1,14),i%DCStat=$lg(%s1,15),i%DCStatN=$lg(%s1,16),i%DCFlag=$lg(%s1,17),i%EDConsult=$lg(%s1,18),i%EDProcedure=$lg(%s1,19),i%EDTrans=$lg(%s1,20),i%EDDx=$lg(%s1,21),i%PrimDx=$lg(%s1,22),i%PrimICD=$lg(%s1,23),i%Info=$lg(%s1,24),i%Injury=$lg(%s1,25)
	. s i%PtInjury=$lg(%s1,26),i%PtDFN=$lg(%s1,27),i%Room=$lg(%s1,28),i%RoomDt=$lg(%s1,29),i%RoomTime=$lg(%s1,30),i%VIEN=$lg(%s1,31),i%PrimDxH=$lg(%s1,32),i%PrimPrv=$lg(%s1,33),i%DCTrns=$lg(%s1,34),i%DCTrnsN=$lg(%s1,35),i%DCMode=$lg(%s1,36),i%DCModeN=$lg(%s1,37),i%OrgRoom=$lg(%s1,38),i%OrgRoomDt=$lg(%s1,39),i%OrgRoomTime=$lg(%s1,40),i%Clinic=$lg(%s1,41),i%DCDocH=$lg(%s1,42),i%PtStat=$lg(%s1,43),i%RecLock=$lg(%s1,45),i%RecLockUser=$lg(%s1,46),i%RecLockDT=$lg(%s1,47),i%PtStatV=$lg(%s1,48),i%DCDocHSDt=$lg(%s1,51)
	. s i%DCDocHSTm=$lg(%s1,52),i%DCDocHEDt=$lg(%s1,53),i%DCDocHETm=$lg(%s1,54),i%PrimDxNarr=$lg(%s1,55),i%RoomDtTm=$lg(%s1,56),i%ORmDt=$lg(%s1,57),i%ORmTm=$lg(%s1,58),i%PrimaryNurse=$lg(%s1,59),i%RoomClear=$lg(%s1,60),i%RClDt=$lg(%s1,61),i%RClTm=$lg(%s1,62),i%PrmNurse=$lg(%s1,63),i%DecAdmDt=$lg(%s1,64),i%RecLockSite=$lg(%s1,65)
	Set sc = $select(sc'="":sc,1:$$Error^%apiOBJ(5809,$classname(),id))
	 Quit sc
%LoadInit(oid="",concurrency="",reset=0) public {
	If concurrency'="" Set i%%Concurrency=concurrency
	If reset {
		Kill i%Info,i%PtInjury
	}
	Set r%Info="",r%PtInjury=""
	If 'reset { Set i%"%%OID"=oid If oid'="" { Set $zobjoid("",$listget(oid))=$this } }
	Quit 1 }
%LockExtent(shared=0) public {
	if shared { l +(^BEDD.EDVISITD#"S"):$zu(115,4) if $t { q 1 } else { q $$Error^%apiOBJ(5799,$classname()) }} l +(^BEDD.EDVISITD):$zu(115,4) if $t { q 1 } else { q $$Error^%apiOBJ(5798,$classname()) }
}
%LockId(id,shared=0) public {
	if id'="" { set sc=1 } else { set sc=$$Error^%apiOBJ(5812) quit sc }
	if 'shared { Lock +(^BEDD.EDVISITD(id)):$zu(115,4) i $test { q 1 } else { q $$Error^%apiOBJ(5803,$classname()) } }
	else { Lock +(^BEDD.EDVISITD(id)#"S"):$zu(115,4) if $test { q 1 } else { q $$Error^%apiOBJ(5804,$classname()) } }
}
%NormalizeObject() public {
	If '$system.CLS.GetModified() Quit 1
	If m%AMERVSIT Set:i%AMERVSIT'="" i%AMERVSIT=(..AMERVSITNormalize(i%AMERVSIT))
	If m%AsgCln Set:i%AsgCln'="" i%AsgCln=(..AsgClnNormalize(i%AsgCln))
	If m%AsgNrs Set:i%AsgNrs'="" i%AsgNrs=(..AsgNrsNormalize(i%AsgNrs))
	If m%AsgPrv Set:i%AsgPrv'="" i%AsgPrv=(..AsgPrvNormalize(i%AsgPrv))
	If m%Clinic Set:i%Clinic'="" i%Clinic=(..ClinicNormalize(i%Clinic))
	If m%CodeBlue Set:i%CodeBlue'="" i%CodeBlue=(..CodeBlueNormalize(i%CodeBlue))
	If m%DCDPrvH Set:i%DCDPrvH'="" i%DCDPrvH=(..DCDPrvHNormalize(i%DCDPrvH))
	If m%DCDispH Set:i%DCDispH'="" i%DCDispH=(..DCDispHNormalize(i%DCDispH))
	If m%DCDocH Set:i%DCDocH'="" i%DCDocH=(..DCDocHNormalize(i%DCDocH))
	If m%DCDocHEDt Set:i%DCDocHEDt'="" i%DCDocHEDt=(..DCDocHEDtNormalize(i%DCDocHEDt))
	If m%DCDocHETm Set:i%DCDocHETm'="" i%DCDocHETm=(..DCDocHETmNormalize(i%DCDocHETm))
	If m%DCDocHSDt Set:i%DCDocHSDt'="" i%DCDocHSDt=(..DCDocHSDtNormalize(i%DCDocHSDt))
	If m%DCDocHSTm Set:i%DCDocHSTm'="" i%DCDocHSTm=(..DCDocHSTmNormalize(i%DCDocHSTm))
	If m%DCDtH Set:i%DCDtH'="" i%DCDtH=(..DCDtHNormalize(i%DCDtH))
	If m%DCFlag Set:i%DCFlag'="" i%DCFlag=(..DCFlagNormalize(i%DCFlag))
	If m%DCInstH Set:i%DCInstH'="" i%DCInstH=(..DCInstHNormalize(i%DCInstH))
	If m%DCMode Set:i%DCMode'="" i%DCMode=(..DCModeNormalize(i%DCMode))
	If m%DCModeN Set:i%DCModeN'="" i%DCModeN=(..DCModeNNormalize(i%DCModeN))
	If m%DCNrsH Set:i%DCNrsH'="" i%DCNrsH=(..DCNrsHNormalize(i%DCNrsH))
	If m%DCPrvH Set:i%DCPrvH'="" i%DCPrvH=(..DCPrvHNormalize(i%DCPrvH))
	If m%DCStat Set:i%DCStat'="" i%DCStat=(..DCStatNormalize(i%DCStat))
	If m%DCStatN Set:i%DCStatN'="" i%DCStatN=(..DCStatNNormalize(i%DCStatN))
	If m%DCTmH Set:i%DCTmH'="" i%DCTmH=(..DCTmHNormalize(i%DCTmH))
	If m%DCTrgH Set:i%DCTrgH'="" i%DCTrgH=(..DCTrgHNormalize(i%DCTrgH))
	If m%DCTrns Set:i%DCTrns'="" i%DCTrns=(..DCTrnsNormalize(i%DCTrns))
	If m%DCTrnsN Set:i%DCTrnsN'="" i%DCTrnsN=(..DCTrnsNNormalize(i%DCTrnsN))
	If m%DecAdmDt Set:i%DecAdmDt'="" i%DecAdmDt=(..DecAdmDtNormalize(i%DecAdmDt))
	If m%EDConsult Set:i%EDConsult'="" i%EDConsult=(..EDConsultNormalize(i%EDConsult))
	If m%EDDx Set:i%EDDx'="" i%EDDx=(..EDDxNormalize(i%EDDx))
	If m%EDProcedure Set:i%EDProcedure'="" i%EDProcedure=(..EDProcedureNormalize(i%EDProcedure))
	If m%EDTrans Set:i%EDTrans'="" i%EDTrans=(..EDTransNormalize(i%EDTrans))
	If m%Injury Set:i%Injury'="" i%Injury=(..InjuryNormalize(i%Injury))
	If m%ORmDt Set:i%ORmDt'="" i%ORmDt=(..ORmDtNormalize(i%ORmDt))
	If m%ORmTm Set:i%ORmTm'="" i%ORmTm=(..ORmTmNormalize(i%ORmTm))
	If m%OrgRoom Set:i%OrgRoom'="" i%OrgRoom=(..OrgRoomNormalize(i%OrgRoom))
	If m%OrgRoomDt Set:i%OrgRoomDt'="" i%OrgRoomDt=(..OrgRoomDtNormalize(i%OrgRoomDt))
	If m%OrgRoomTime Set:i%OrgRoomTime'="" i%OrgRoomTime=(..OrgRoomTimeNormalize(i%OrgRoomTime))
	If m%PrimDx Set:i%PrimDx'="" i%PrimDx=(..PrimDxNormalize(i%PrimDx))
	If m%PrimDxH Set:i%PrimDxH'="" i%PrimDxH=(..PrimDxHNormalize(i%PrimDxH))
	If m%PrimDxNarr Set:i%PrimDxNarr'="" i%PrimDxNarr=(..PrimDxNarrNormalize(i%PrimDxNarr))
	If m%PrimICD Set:i%PrimICD'="" i%PrimICD=(..PrimICDNormalize(i%PrimICD))
	If m%PrimPrv Set:i%PrimPrv'="" i%PrimPrv=(..PrimPrvNormalize(i%PrimPrv))
	If m%PrimaryNurse Set:i%PrimaryNurse'="" i%PrimaryNurse=(..PrimaryNurseNormalize(i%PrimaryNurse))
	If m%PrmNurse Set:i%PrmNurse'="" i%PrmNurse=(..PrmNurseNormalize(i%PrmNurse))
	If m%PtDFN Set:i%PtDFN'="" i%PtDFN=(..PtDFNNormalize(i%PtDFN))
	If m%PtStat Set:i%PtStat'="" i%PtStat=(..PtStatNormalize(i%PtStat))
	If m%PtStatV Set:i%PtStatV'="" i%PtStatV=(..PtStatVNormalize(i%PtStatV))
	If m%RClDt Set:i%RClDt'="" i%RClDt=(..RClDtNormalize(i%RClDt))
	If m%RClTm Set:i%RClTm'="" i%RClTm=(..RClTmNormalize(i%RClTm))
	If m%RecLock Set:i%RecLock'="" i%RecLock=(..RecLockNormalize(i%RecLock))
	If m%RecLockDT Set:i%RecLockDT'="" i%RecLockDT=(..RecLockDTNormalize(i%RecLockDT))
	If m%RecLockSite Set:i%RecLockSite'="" i%RecLockSite=(..RecLockSiteNormalize(i%RecLockSite))
	If m%RecLockUser Set:i%RecLockUser'="" i%RecLockUser=(..RecLockUserNormalize(i%RecLockUser))
	If m%Room Set:i%Room'="" i%Room=(..RoomNormalize(i%Room))
	If m%RoomClear Set:i%RoomClear'="" i%RoomClear=(..RoomClearNormalize(i%RoomClear))
	If m%RoomDt Set:i%RoomDt'="" i%RoomDt=(..RoomDtNormalize(i%RoomDt))
	If m%RoomDtTm Set:i%RoomDtTm'="" i%RoomDtTm=(..RoomDtTmNormalize(i%RoomDtTm))
	If m%RoomTime Set:i%RoomTime'="" i%RoomTime=(..RoomTimeNormalize(i%RoomTime))
	If m%VIEN Set:i%VIEN'="" i%VIEN=(..VIENNormalize(i%VIEN))
	Quit 1 }
%ObjectModified() public {
	If $system.CLS.GetModified() Quit 1
	If r%Info'="",..Info.%ObjectModified() Quit 1
	If r%PtInjury'="",..PtInjury.%ObjectModified() Quit 1
	Quit 0 }
%OnDetermineClass(oid,class)
	New id,idclass
	Set id=$listget($get(oid)) QUIT:id="" $$Error^%apiOBJ(5812)
	Set idclass=$lg($get(^BEDD.EDVISITD(id)),1)
	If idclass="" Set class="BEDD.EDVISIT" Quit 1
	Set class=$piece(idclass,$extract(idclass),$length(idclass,$extract(idclass))-1)
	Set:class'["." class="User."_class
	QUIT 1
%PhysicalAddress(id,paddr)
	if $Get(id)="" Quit $$Error^%apiOBJ(5813,$classname())
	if (id="") { quit $$Error^%apiOBJ(5832,$classname(),id) }
	s paddr(1)=$lb($Name(^BEDD.EDVISITD(id)),$classname(),"IDKEY","listnode",id)
	s paddr=1
	Quit 1
%PurgeIndices(idxlist="",lockExtent=0)
	n locked,ptr,sc
	s $ZTrap="CatchError",locked=0,sc=1
	for ptr=1:1:$listlength(idxlist) { if '($d(^oddCOM($classname(),"i",$list(idxlist,ptr)))) { set sc=$$Error^%apiOBJ(5066,$classname()_"::"_$list(idxlist,ptr)) continue } } if ('sc) { quit sc }
	i lockExtent { s sc=..%LockExtent(0) i ('sc) { q sc } else { s locked=1 } }
	if $system.CLS.IsMthd($classname(),"%OnBeforeBuildIndices") { set sc=..%OnBeforePurgeIndices(.idxlist) i ('sc) { i locked { d ..%SQLReleaseTableLock(0) } quit sc } }
	If $select($listfind(idxlist,"ADIdx"):1,idxlist="":1,1:0) Kill ^BEDD.EDVISITI("ADIdx")
	If $select($listfind(idxlist,"ArrIdx"):1,idxlist="":1,1:0) Kill ^BEDD.EDVISITI("ArrIdx")
	If $select($listfind(idxlist,"CIDtIIdx"):1,idxlist="":1,1:0) Kill ^BEDD.EDVISITI("CIDtIIdx")
	If $select($listfind(idxlist,"DCDTIdx"):1,idxlist="":1,1:0) Kill ^BEDD.EDVISITI("DCDTIdx")
	If $select($listfind(idxlist,"DisIdx"):1,idxlist="":1,1:0) Kill ^BEDD.EDVISITI("DisIdx")
	s sc=1
	if $system.CLS.IsMthd($classname(),"%OnAfterPurgeIndices") { set sc=..%OnAfterPurgeIndices(.idxlist) }
	i locked { d ..%UnlockExtent(0) }
	QUIT sc
CatchError	s $ZTrap="" i $ZE'="" { s sc = $$Error^%apiOBJ(5002,$ZE) } i locked { d ..%UnlockExtent(0) } q sc
	i locked { d ..%UnlockExtent(0) }
	QUIT sc
%SQLAcquireLock(%rowid,s=0,unlockref)
	new %d,gotlock set %d(1)=%rowid set s=$e("S",s) lock +^BEDD.EDVISITD(%d(1))#s:$zu(115,4) set gotlock=$t set:gotlock&&$g(unlockref) unlockref($i(unlockref))=$lb($name(^BEDD.EDVISITD(%d(1))),"BEDD.EDVISIT") QUIT gotlock
	Quit
%SQLAcquireTableLock(s=0,SQLCODE,to="")
	set s=$e("S",s) set:to="" to=$zu(115,4) lock +^BEDD.EDVISITD#s:to QUIT:$t 1 set SQLCODE=-110 if s="S" { set %msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler35",,"BEDD"_"."_"EDVISIT") } else { set %msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler36",,"BEDD"_"."_"EDVISIT") } QUIT 0
	Quit
%SQLBuildIndices(pIndices="")
	QUIT ..%BuildIndices(pIndices)
%SQLCopyIcolIntoName()
	if %oper="DELETE" {
		set:$d(%d(1)) %f("ID")=%d(1)
		QUIT
	}
	set:$d(%d(1)) %f("ID")=%d(1) set:$a(%e,2)&&$d(%d(2)) %f("AMERVSIT")=%d(2) set:$a(%e,3)&&$d(%d(3)) %f("AdPvDtm")=%d(3) set:$a(%e,4)&&$d(%d(4)) %f("AdmPrv")=%d(4) set:$a(%e,5)&&$d(%d(5)) %f("AdmPrvN")=%d(5) set:$a(%e,6)&&$d(%d(6)) %f("Age")=%d(6) set:$a(%e,7)&&$d(%d(7)) %f("ArrMode")=%d(7) set:$a(%e,8)&&$d(%d(8)) %f("AsgCln")=%d(8) set:$a(%e,9)&&$d(%d(9)) %f("AsgNrs")=%d(9) set:$a(%e,10)&&$d(%d(10)) %f("AsgNrsN")=%d(10) set:$a(%e,11)&&$d(%d(11)) %f("AsgPrv")=%d(11) set:$a(%e,12)&&$d(%d(12)) %f("AsgPrvN")=%d(12) set:$a(%e,13)&&$d(%d(13)) %f("CIDt")=%d(13) set:$a(%e,14)&&$d(%d(14)) %f("CITm")=%d(14) set:$a(%e,15)&&$d(%d(15)) %f("Chart")=%d(15) set:$a(%e,16)&&$d(%d(16)) %f("Clinic")=%d(16) set:$a(%e,17)&&$d(%d(17)) %f("CodeBlue")=%d(17) set:$a(%e,18)&&$d(%d(18)) %f("Complaint")=%d(18) set:$a(%e,19)&&$d(%d(19)) %f("DCDPrvH")=%d(19) set:$a(%e,20)&&$d(%d(20)) %f("DCDPrvHN")=%d(20) set:$a(%e,21)&&$d(%d(21)) %f("DCDispH")=%d(21) set:$a(%e,22)&&$d(%d(22)) %f("DCDocH")=%d(22) set:$a(%e,23)&&$d(%d(23)) %f("DCDocHEDt")=%d(23) set:$a(%e,24)&&$d(%d(24)) %f("DCDocHETm")=%d(24) set:$a(%e,25)&&$d(%d(25)) %f("DCDocHSDt")=%d(25) set:$a(%e,26)&&$d(%d(26)) %f("DCDocHSTm")=%d(26) set:$a(%e,27)&&$d(%d(27)) %f("DCDt")=%d(27) set:$a(%e,28)&&$d(%d(28)) %f("DCDtH")=%d(28) set:$a(%e,29)&&$d(%d(29)) %f("DCDtTm")=%d(29) set:$a(%e,30)&&$d(%d(30)) %f("DCFlag")=%d(30) set:$a(%e,31)&&$d(%d(31)) %f("DCInstH")=%d(31) set:$a(%e,32)&&$d(%d(32)) %f("DCInstHN")=%d(32) set:$a(%e,33)&&$d(%d(33)) %f("DCMode")=%d(33) set:$a(%e,34)&&$d(%d(34)) %f("DCModeN")=%d(34) set:$a(%e,35)&&$d(%d(35)) %f("DCNrs")=%d(35) set:$a(%e,36)&&$d(%d(36)) %f("DCNrsH")=%d(36) set:$a(%e,37)&&$d(%d(37)) %f("DCNrsN")=%d(37) set:$a(%e,38)&&$d(%d(38)) %f("DCPrv")=%d(38) set:$a(%e,39)&&$d(%d(39)) %f("DCPrvH")=%d(39) set:$a(%e,40)&&$d(%d(40)) %f("DCPrvN")=%d(40) set:$a(%e,41)&&$d(%d(41)) %f("DCStat")=%d(41) set:$a(%e,42)&&$d(%d(42)) %f("DCStatN")=%d(42) set:$a(%e,43)&&$d(%d(43)) %f("DCTm")=%d(43) set:$a(%e,44)&&$d(%d(44)) %f("DCTmH")=%d(44) set:$a(%e,45)&&$d(%d(45)) %f("DCTrgH")=%d(45) set:$a(%e,46)&&$d(%d(46)) %f("DCTrns")=%d(46) set:$a(%e,47)&&$d(%d(47)) %f("DCTrnsN")=%d(47) set:$a(%e,48)&&$d(%d(48)) %f("DOB")=%d(48) set:$a(%e,49)&&$d(%d(49)) %f("DecAdmDt")=%d(49) set:$a(%e,50)&&$d(%d(50)) %f("DispN")=%d(50) set:$a(%e,51)&&$d(%d(51)) %f("Disposition")=%d(51) set:$a(%e,52)&&$d(%d(52)) %f("EDConsult")=%d(52) set:$a(%e,53)&&$d(%d(53)) %f("EDDx")=%d(53) set:$a(%e,54)&&$d(%d(54)) %f("EDProcedure")=%d(54) set:$a(%e,55)&&$d(%d(55)) %f("EDTrans")=%d(55) set:$a(%e,56)&&$d(%d(56)) %f("FinA")=%d(56) set:$a(%e,57)&&$d(%d(57)) %f("Industry")=%d(57) set:$a(%e,58)&&$d(%d(58)) %f("Info")=%d(58) set:$a(%e,59)&&$d(%d(59)) %f("InjC")=%d(59) set:$a(%e,60)&&$d(%d(60)) %f("InjS")=%d(60) set:$a(%e,61)&&$d(%d(61)) %f("Injury")=%d(61) set:$a(%e,62)&&$d(%d(62)) %f("NewDecAdmit")=%d(62) set:$a(%e,63)&&$d(%d(63)) %f("ORmDt")=%d(63) set:$a(%e,64)&&$d(%d(64)) %f("ORmTm")=%d(64) set:$a(%e,65)&&$d(%d(65)) %f("Occupation")=%d(65) set:$a(%e,66)&&$d(%d(66)) %f("OrgRoom")=%d(66) set:$a(%e,67)&&$d(%d(67)) %f("OrgRoomDt")=%d(67) set:$a(%e,68)&&$d(%d(68)) %f("OrgRoomTime")=%d(68) set:$a(%e,69)&&$d(%d(69)) %f("PrimDx")=%d(69) set:$a(%e,70)&&$d(%d(70)) %f("PrimDxH")=%d(70) set:$a(%e,71)&&$d(%d(71)) %f("PrimDxN")=%d(71) set:$a(%e,72)&&$d(%d(72)) %f("PrimDxNarr")=%d(72) set:$a(%e,73)&&$d(%d(73)) %f("PrimICD")=%d(73) set:$a(%e,74)&&$d(%d(74)) %f("PrimICDN")=%d(74) set:$a(%e,75)&&$d(%d(75)) %f("PrimPrv")=%d(75) set:$a(%e,76)&&$d(%d(76)) %f("PrimPrvN")=%d(76) set:$a(%e,77)&&$d(%d(77)) %f("PrimaryNurse")=%d(77) set:$a(%e,78)&&$d(%d(78)) %f("PrmNurse")=%d(78) set:$a(%e,79)&&$d(%d(79)) %f("PtCIDT")=%d(79) set:$a(%e,80)&&$d(%d(80)) %f("PtDCDT")=%d(80) set:$a(%e,81)&&$d(%d(81)) %f("PtDFN")=%d(81) set:$a(%e,82)&&$d(%d(82)) %f("PtInjury")=%d(82) set:$a(%e,83)&&$d(%d(83)) %f("PtName")=%d(83) set:$a(%e,84)&&$d(%d(84)) %f("PtStat")=%d(84)
	set:$a(%e,85)&&$d(%d(85)) %f("PtStatI")=%d(85) set:$a(%e,86)&&$d(%d(86)) %f("PtStatN")=%d(86) set:$a(%e,87)&&$d(%d(87)) %f("PtStatV")=%d(87) set:$a(%e,88)&&$d(%d(88)) %f("PtTrgDT")=%d(88) set:$a(%e,89)&&$d(%d(89)) %f("RClDt")=%d(89) set:$a(%e,90)&&$d(%d(90)) %f("RClTm")=%d(90) set:$a(%e,91)&&$d(%d(91)) %f("RecLock")=%d(91) set:$a(%e,92)&&$d(%d(92)) %f("RecLockDT")=%d(92) set:$a(%e,93)&&$d(%d(93)) %f("RecLockSite")=%d(93) set:$a(%e,94)&&$d(%d(94)) %f("RecLockUser")=%d(94) set:$a(%e,95)&&$d(%d(95)) %f("Room")=%d(95) set:$a(%e,96)&&$d(%d(96)) %f("RoomClear")=%d(96) set:$a(%e,97)&&$d(%d(97)) %f("RoomDt")=%d(97) set:$a(%e,98)&&$d(%d(98)) %f("RoomDtTm")=%d(98) set:$a(%e,99)&&$d(%d(99)) %f("RoomTime")=%d(99) set:$a(%e,100)&&$d(%d(100)) %f("Sex")=%d(100) set:$a(%e,101)&&$d(%d(101)) %f("TrgA")=%d(101) set:$a(%e,102)&&$d(%d(102)) %f("TrgCln")=%d(102) set:$a(%e,103)&&$d(%d(103)) %f("TrgDt")=%d(103) set:$a(%e,104)&&$d(%d(104)) %f("TrgDtTm")=%d(104) set:$a(%e,105)&&$d(%d(105)) %f("TrgNrs")=%d(105) set:$a(%e,106)&&$d(%d(106)) %f("TrgTm")=%d(106) set:$a(%e,107)&&$d(%d(107)) %f("VIEN")=%d(107) set:$a(%e,108)&&$d(%d(108)) %f("VstDur")=%d(108) set:$a(%e,109)&&$d(%d(109)) %f("WtgTime")=%d(109) set:$a(%e,110)&&$d(%d(110)) %f("x__classname")=%d(110) set:$a(%e,111)&&$d(%d(111)) %f("PtInjury_AtFaultAddress")=%d(111) set:$a(%e,112)&&$d(%d(112)) %f("PtInjury_AtFaultInsAdd")=%d(112) set:$a(%e,113)&&$d(%d(113)) %f("PtInjury_AtFaultInsPolicy")=%d(113) set:$a(%e,114)&&$d(%d(114)) %f("PtInjury_AtFaultInsurance")=%d(114) set:$a(%e,115)&&$d(%d(115)) %f("PtInjury_AtFaultName")=%d(115) set:$a(%e,116)&&$d(%d(116)) %f("PtInjury_AtFaultOther")=%d(116) set:$a(%e,117)&&$d(%d(117)) %f("PtInjury_BusOffc")=%d(117) set:$a(%e,118)&&$d(%d(118)) %f("PtInjury_BusOffcCmp")=%d(118) set:$a(%e,119)&&$d(%d(119)) %f("PtInjury_BusOffcStat")=%d(119) set:$a(%e,120)&&$d(%d(120)) %f("PtInjury_EmplAddress")=%d(120) set:$a(%e,121)&&$d(%d(121)) %f("PtInjury_EmplCitySt")=%d(121) set:$a(%e,122)&&$d(%d(122)) %f("PtInjury_EmplName")=%d(122) set:$a(%e,123)&&$d(%d(123)) %f("PtInjury_EmplPh")=%d(123) set:$a(%e,124)&&$d(%d(124)) %f("PtInjury_InjCause")=%d(124) set:$a(%e,125)&&$d(%d(125)) %f("PtInjury_InjCauseIEN")=%d(125) set:$a(%e,126)&&$d(%d(126)) %f("PtInjury_InjDt")=%d(126) set:$a(%e,127)&&$d(%d(127)) %f("PtInjury_InjDtTm")=%d(127) set:$a(%e,128)&&$d(%d(128)) %f("PtInjury_InjLocat")=%d(128) set:$a(%e,129)&&$d(%d(129)) %f("PtInjury_InjSet")=%d(129) set:$a(%e,130)&&$d(%d(130)) %f("PtInjury_InjTm")=%d(130) set:$a(%e,131)&&$d(%d(131)) %f("PtInjury_InjuryDetails")=%d(131) set:$a(%e,132)&&$d(%d(132)) %f("PtInjury_MVCLoc")=%d(132) set:$a(%e,133)&&$d(%d(133)) %f("PtInjury_PtDFN")=%d(133) set:$a(%e,134)&&$d(%d(134)) %f("PtInjury_SafetyEquip")=%d(134) set:$a(%e,135)&&$d(%d(135)) %f("PtInjury_VIEN")=%d(135) set:$a(%e,136)&&$d(%d(136)) %f("PtInjury_WrkRel")=%d(136)
	QUIT
%SQLDefineiDjVars(%d,subs)
	QUIT
%SQLDelete(%rowid,%check,%tstart=1,%mv=0,%polymorphic=0)
	new bva,ce,%d,dc,%e,%ele,%itm,%key,%l,%nc,omcall,%oper,%pos,%s,sn,sqlcode,subs set %oper="DELETE",sqlcode=0,%ROWID=%rowid,%d(1)=%rowid,%e(1)=%rowid,%l=$c(0)
	if '$d(%0CacheSQLRA) new %0CacheSQLRA set omcall=1
	k:'$TLEVEL %0CacheLock if '$a(%check,2) { new %ls if $i(%0CacheLock("BEDD.EDVISIT"))>$zu(115,6) { lock +^BEDD.EDVISITD:$zu(115,4) lock:$t -^BEDD.EDVISITD set %ls=$s($t:2,1:0) } else { lock +^BEDD.EDVISITD(%d(1)):$zu(115,4) set %ls=$t } set:%ls=2 $e(%check,2)=$c(1) set:%ls=1 $e(%l)=$c(1) if '%ls set SQLCODE=-110,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler40",,%oper,"BEDD"_"."_"EDVISIT",$g(%d(1))) QUIT  } if %tstart { TSTART:($zu(115,1)=1)||('$TLEVEL&&($zu(115,1)=2))  } set $zt="ERRORDelete"
	do ..%SQLGetOld() if sqlcode set SQLCODE=-106 do ..%SQLEExit() QUIT  
	if %e(110)'="" set sn=$p(%e(110),$e(%e(110)),$l(%e(110),$e(%e(110)))-1) if "BEDD.EDVISIT"'=sn new %f do ..%SQLCopyIcolIntoName() do $classmethod(sn,"%SQLDelete",%rowid,%check,%tstart,%mv,1) QUIT  
	if '$a(%check),'$zu(115,7) do  if sqlcode set SQLCODE=sqlcode do ..%SQLEExit() QUIT  
	. new %fk,%k,%p,%st,%t,%z set %k="",%p("%1")="%d(1),",%p("IDKEY")="%d(1),"
	. for  quit:sqlcode<0  set %k=$o(^oddEXTR("BEDD.EDVISIT","n",%k)) quit:%k=""  set %t="" for  set %t=$o(^oddEXTR("BEDD.EDVISIT","n",%k,"f",%t)) quit:%t=""  set %st=(%t="BEDD.EDVISIT") set %fk="" for  set %fk=$order(^oddEXTR("BEDD.EDVISIT","n",%k,"f",%t,%fk)) quit:%fk=""  x "set %z=$classmethod(%t,%fk_""SQLFKeyRefAction"",%st,%k,"_%p(%k)_")" if %z set sqlcode=-124 quit  
	set ce="" for  { set ce=$order(^oddSQL("BEDD","EDVISIT","DC",ce)) quit:ce=""   do $classmethod(ce,"%SQLDeleteChildren",%d(1),%check,.sqlcode) quit:sqlcode<0  } if sqlcode<0 { set SQLCODE=sqlcode do ..%SQLEExit() QUIT } // Delete any children
	s sn(1)=%e(107) s:sn(1)="" sn(1)=-1E14 s sn(2)=%d(1) k ^BEDD.EDVISITI("ADIdx",sn(1),sn(2))
		s sn(1)=%e(13) s:sn(1)="" sn(1)=-1E14 s sn(2)=%d(1) k ^BEDD.EDVISITI("ArrIdx",sn(1),sn(2))
		s sn(1)=%e(13) s:sn(1)="" sn(1)=-1E14 s sn(2)=%d(1) k ^BEDD.EDVISITI("CIDtIIdx",sn(1),sn(2))
		s sn(1)=$zu(28,%e(28),7) s sn(2)=%d(1) k ^BEDD.EDVISITI("DCDTIdx",sn(1),sn(2))
		s sn(1)=%e(27) s:sn(1)="" sn(1)=-1E14 s sn(2)=%d(1) k ^BEDD.EDVISITI("DisIdx",sn(1),sn(2))
	new %rc if $g(%e(58))'="" set %rc=##class(%Stream.Object).%Delete(%e(58)) if '%rc set SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) set:%msg %msg=%msg(1) do ..%SQLEExit() QUIT
	if $g(%e(116))'="" set %rc=##class(%Stream.Object).%Delete(%e(116)) if '%rc set SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) set:%msg %msg=%msg(1) do ..%SQLEExit() QUIT
	if $g(%e(117))'="" set %rc=##class(%Stream.Object).%Delete(%e(117)) if '%rc set SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) set:%msg %msg=%msg(1) do ..%SQLEExit() QUIT
	if $g(%e(131))'="" set %rc=##class(%Stream.Object).%Delete(%e(131)) if '%rc set SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) set:%msg %msg=%msg(1) do ..%SQLEExit() QUIT
	k ^BEDD.EDVISITD(%d(1))
	do ..%SQLUnlock() TCOMMIT:%tstart&&($zu(115,1)=1)
	set SQLCODE=0 kill:$g(omcall) %0CacheSQLRA QUIT
ERRORDelete	set $zt="",SQLCODE=-415,%msg=$s($g(%msg)'="":%msg_" -- ",1:"")_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler51",,%oper,"BEDD"_"."_"EDVISIT",$ze) if $ze["<FRAMESTACK>" { set %msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler52",,$ze,%oper,"BEDD"_"."_"EDVISIT") do ##Class(%SYS.System).WriteToConsoleLog(%msg) if ($zu(67,10,$j)=1)||($zu(67,10,$j)=3) { write !,%msg h 3 } HALT  } do ..%SQLEExit() QUIT
	Quit
%SQLDeleteTempStreams()
	// Delete all temporary streams
	new %sid,%ts if $g(%d(58))?1.n1"@"1.e { if $d(%qstrhandle($g(%qacn,1),%d(58)),%ts) { set %sid=%ts.%Oid() do %ts.%Delete(%sid) k %ts }}
	if $g(%d(116))?1.n1"@"1.e { if $d(%qstrhandle($g(%qacn,1),%d(116)),%ts) { set %sid=%ts.%Oid() do %ts.%Delete(%sid) k %ts }}
	if $g(%d(117))?1.n1"@"1.e { if $d(%qstrhandle($g(%qacn,1),%d(117)),%ts) { set %sid=%ts.%Oid() do %ts.%Delete(%sid) k %ts }}
	if $g(%d(131))?1.n1"@"1.e { if $d(%qstrhandle($g(%qacn,1),%d(131)),%ts) { set %sid=%ts.%Oid() do %ts.%Delete(%sid) k %ts }}
	QUIT
%SQLEExit()
	do ..%SQLUnlock() 
	if %tstart,$zu(115,1)=1,$TLEVEL { set %tstart=0 TROLLBACK 1 } kill:$g(omcall) %0CacheSQLRA QUIT  
	Quit
%SQLExists(pLockOnly=0,pUnlockRef,%pVal...)
	// SQL Foreign Key validation entry point for Foreign Key %1.  Called by FKeys that reference this key to see if the row is defined
	new id set id=%pVal(1)
	if '..%SQLGetLock(id,1,.pUnlockRef) { set sqlcode=-114,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler39",,"BEDD"_"."_"EDVISIT"_":"_"%1") QUIT 0 }
	if 'pLockOnly { new qv set qv=$d(^BEDD.EDVISITD(%pVal(1))) do:'$g(pUnlockRef) ..%SQLReleaseLock(id,1) quit qv } else { do:'$g(pUnlockRef) ..%SQLReleaseLock(id,1) QUIT 1 }
	Quit
%SQLGetLock(pRowId,pShared=0,pUnlockRef)
	kill:'$TLEVEL %0CacheLock
	if $i(%0CacheLock("BEDD.EDVISIT"))>$zu(115,6) { lock +^BEDD.EDVISITD:$zu(115,4) lock:$t -^BEDD.EDVISITD QUIT $s($t:2,1:0) } 
	QUIT ..%SQLAcquireLock(pRowId,pShared,.pUnlockRef)
%SQLGetOld()
	// Get old data values
	 ;---&sql(SELECT x__classname,Info,PtInjury_AtFaultOther,PtInjury_BusOffc,PtInjury_InjuryDetails,VIEN,CIDt,AMERVSIT,PtDFN,DCDtH,DCDt,PtStat,Room,DCFlag,DCDocH,TrgA,PtInjury_AtFaultAddress,PtInjury,PtInjury_AtFaultInsAdd,PtInjury_AtFaultInsPolicy,PtInjury_AtFaultInsurance,PtInjury_AtFaultName,PtInjury_BusOffcCmp,PtInjury_BusOffcStat,PtInjury_EmplAddress,PtInjury_EmplCitySt,PtInjury_EmplName,PtInjury_EmplPh,PtInjury_InjCause,PtInjury_InjCauseIEN,PtInjury_InjDt,PtInjury_InjDtTm,PtInjury_InjLocat,PtInjury_InjSet,PtInjury_InjTm,PtInjury_MVCLoc,PtInjury_PtDFN,PtInjury_SafetyEquip,PtInjury_VIEN,PtInjury_WrkRel INTO :%e() FROM BEDD.EDVISIT WHERE ID=:%rowid) set sqlcode=SQLCODE quit
 	 ;--- ** SQL PUBLIC Variables: %ROWCOUNT, %ROWID, %msg, SQLCODE
	Do %0Ao set sqlcode=SQLCODE quit
	QUIT
 q
%0Ao 
 n %mmmsqlc,%mmmsqld,%mmmsqlE,%mmmsqll,%mmmsqln,%mmmsqlp,%mmmsqlR,%mmmsqls,%mmmsqlt,%mmmsqlZ s $zt="%0Aerr" s %mmmsqld(1)=0,%mmmsqld(2)="" d:$zu(115,15) $system.ECP.Sync()
 s %mmmsqld(3)=$g(%rowid),%mmmsqld(3)=$s(%mmmsqld(3)="":"",$isvalidnum(%mmmsqld(3)):+%mmmsqld(3),1:%mmmsqld(3))
 s SQLCODE=100
 ; asl MOD# 2
 s %mmmsqld(4)=%mmmsqld(3)
 i %mmmsqld(4)'="",$d(^BEDD.EDVISITD(%mmmsqld(4)))
 e  g %0AmBdun
 s %mmmsqld(5)=$g(^BEDD.EDVISITD(%mmmsqld(4))) s %e(110)=$lg(%mmmsqld(5),1) s %e(58)=##class(BEDD.EDVISIT).InfoOid($lg(%mmmsqld(5),24)) s %e(116)=##class(BEDD.EDInjury).AtFaultOtherOid($lg($lg(%mmmsqld(5),26),6)) s %e(117)=##class(BEDD.EDInjury).BusOffcOid($lg($lg(%mmmsqld(5),26),8)) s %e(131)=##class(BEDD.EDInjury).InjuryDetailsOid($lg($lg(%mmmsqld(5),26),7)) s %e(107)=$lg(%mmmsqld(5),31) s %e(2)=$lg(%mmmsqld(5),2) s %e(81)=$lg(%mmmsqld(5),27) s %e(28)=$lg(%mmmsqld(5),7) s %e(84)=$lg(%mmmsqld(5),43) s %e(95)=$lg(%mmmsqld(5),28) s %e(30)=$lg(%mmmsqld(5),17) s %e(22)=$lg(%mmmsqld(5),42) s %e(111)=$lg($lg(%mmmsqld(5),26),1) s %e(82)=$lg(%mmmsqld(5),26) s %e(112)=$lg($lg(%mmmsqld(5),26),2) s %e(113)=$lg($lg(%mmmsqld(5),26),3) s %e(114)=$lg($lg(%mmmsqld(5),26),4) s %e(115)=$lg($lg(%mmmsqld(5),26),5) s %e(118)=$lg($lg(%mmmsqld(5),26),9) s %e(119)=$lg($lg(%mmmsqld(5),26),10) s %e(120)=$lg($lg(%mmmsqld(5),26),11) s %e(121)=$lg($lg(%mmmsqld(5),26),12) s %e(122)=$lg($lg(%mmmsqld(5),26),13)
 s %e(123)=$lg($lg(%mmmsqld(5),26),14) s %e(124)=$lg($lg(%mmmsqld(5),26),20) s %e(125)=$lg($lg(%mmmsqld(5),26),26) s %e(126)=$lg($lg(%mmmsqld(5),26),16) s %e(127)=$lg($lg(%mmmsqld(5),26),24) s %e(128)=$lg($lg(%mmmsqld(5),26),15) s %e(129)=$lg($lg(%mmmsqld(5),26),21) s %e(130)=$lg($lg(%mmmsqld(5),26),17) s %e(132)=$lg($lg(%mmmsqld(5),26),25) s %e(133)=$lg($lg(%mmmsqld(5),26),19) s %e(134)=$lg($lg(%mmmsqld(5),26),23) s %e(135)=$lg($lg(%mmmsqld(5),26),18) s %e(136)=$lg($lg(%mmmsqld(5),26),22)
 d
 . Set %e(13)=##class(BEDD.EDVISIT).GetCIDt(%e(2),%e(81)) 
 d
 . Set %e(27)=##class(BEDD.EDVISIT).GetDCDt(%e(2))
 d
 . Set %e(101)=##class(BEDD.EDVISIT).GetTrgA(%e(2),%e(81))
 g:$zu(115,2)=0 %0AmBuncommitted i $zu(115,2)=1 l +^BEDD.EDVISITD($p(%mmmsqld(4),"||",1))#"S":$zu(115,4) i $t { s %mmmsqld(1)=1,%mmmsqld(2)=$name(^BEDD.EDVISITD($p(%mmmsqld(4),"||",1)))_"#""SI""" } else { s SQLCODE=-114,%msg="Unable to acquire shared lock on table BEDD.EDVISIT for RowID value: "_%mmmsqld(4) ztrap "LOCK"  }
 ; asl MOD# 3
 i %mmmsqld(4)'="",$d(^BEDD.EDVISITD(%mmmsqld(4)))
 e  g %0AmCdun
 s %mmmsqld(6)=$g(^BEDD.EDVISITD(%mmmsqld(4))) s %e(110)=$lg(%mmmsqld(6),1) s %e(58)=##class(BEDD.EDVISIT).InfoOid($lg(%mmmsqld(6),24)) s %e(116)=##class(BEDD.EDInjury).AtFaultOtherOid($lg($lg(%mmmsqld(6),26),6)) s %e(117)=##class(BEDD.EDInjury).BusOffcOid($lg($lg(%mmmsqld(6),26),8)) s %e(131)=##class(BEDD.EDInjury).InjuryDetailsOid($lg($lg(%mmmsqld(6),26),7)) s %e(107)=$lg(%mmmsqld(6),31) s %e(2)=$lg(%mmmsqld(6),2) s %e(81)=$lg(%mmmsqld(6),27) s %e(28)=$lg(%mmmsqld(6),7) s %e(84)=$lg(%mmmsqld(6),43) s %e(95)=$lg(%mmmsqld(6),28) s %e(30)=$lg(%mmmsqld(6),17) s %e(22)=$lg(%mmmsqld(6),42) s %e(111)=$lg($lg(%mmmsqld(6),26),1) s %e(82)=$lg(%mmmsqld(6),26) s %e(112)=$lg($lg(%mmmsqld(6),26),2) s %e(113)=$lg($lg(%mmmsqld(6),26),3) s %e(114)=$lg($lg(%mmmsqld(6),26),4) s %e(115)=$lg($lg(%mmmsqld(6),26),5) s %e(118)=$lg($lg(%mmmsqld(6),26),9) s %e(119)=$lg($lg(%mmmsqld(6),26),10) s %e(120)=$lg($lg(%mmmsqld(6),26),11) s %e(121)=$lg($lg(%mmmsqld(6),26),12) s %e(122)=$lg($lg(%mmmsqld(6),26),13)
 s %e(123)=$lg($lg(%mmmsqld(6),26),14) s %e(124)=$lg($lg(%mmmsqld(6),26),20) s %e(125)=$lg($lg(%mmmsqld(6),26),26) s %e(126)=$lg($lg(%mmmsqld(6),26),16) s %e(127)=$lg($lg(%mmmsqld(6),26),24) s %e(128)=$lg($lg(%mmmsqld(6),26),15) s %e(129)=$lg($lg(%mmmsqld(6),26),21) s %e(130)=$lg($lg(%mmmsqld(6),26),17) s %e(132)=$lg($lg(%mmmsqld(6),26),25) s %e(133)=$lg($lg(%mmmsqld(6),26),19) s %e(134)=$lg($lg(%mmmsqld(6),26),23) s %e(135)=$lg($lg(%mmmsqld(6),26),18) s %e(136)=$lg($lg(%mmmsqld(6),26),22)
 d
 . Set %e(13)=##class(BEDD.EDVISIT).GetCIDt(%e(2),%e(81)) 
 d
 . Set %e(27)=##class(BEDD.EDVISIT).GetDCDt(%e(2))
 d
 . Set %e(101)=##class(BEDD.EDVISIT).GetTrgA(%e(2),%e(81))
%0AmBuncommitted ;
 s SQLCODE=0 g %0Ac
%0AmCdun if $zu(115,2)=1 { if $g(%mmmsqld(1))=1 { l -@%mmmsqld(2) s %mmmsqld(1)=0 } elseif $g(%mmmsqld(1))=2 { do $classmethod($li(%mmmsqld(2)),"%UnlockId",$li(%mmmsqld(2),2),1,1)  s %mmmsqld(1)=0 } }
%0AmBdun 
%0AmAdun 
%0Ac s %ROWCOUNT='SQLCODE
 if $zu(115,2)=1 { if $g(%mmmsqld(1))=1 { l -@%mmmsqld(2) } elseif $g(%mmmsqld(1))=2 { do $classmethod($li(%mmmsqld(2)),"%UnlockId",$li(%mmmsqld(2),2),1,1)  } }
 q
%0Aerr s $zt="" d SQLRunTimeError^%apiSQL($ze,.SQLCODE,.%msg)
 g %0Ac
%SQLGetOldAll()
	// Get all old data values
	 ;---&sql(SELECT AMERVSIT,AdPvDtm,AdmPrv,AdmPrvN,Age,ArrMode,AsgCln,AsgNrs,AsgNrsN,AsgPrv,AsgPrvN,CIDt,CITm,Chart,Clinic,CodeBlue,Complaint,DCDPrvH,DCDPrvHN,DCDispH,DCDocH,DCDocHEDt,DCDocHETm,DCDocHSDt,DCDocHSTm,DCDt,DCDtH,DCDtTm,DCFlag,DCInstH,DCInstHN,DCMode,DCModeN,DCNrs,DCNrsH,DCNrsN,DCPrv,DCPrvH,DCPrvN,DCStat,DCStatN,DCTm,DCTmH,DCTrgH,DCTrns,DCTrnsN,DOB,DecAdmDt,DispN,Disposition,EDConsult,EDDx,EDProcedure,EDTrans,FinA,Industry,Info,InjC,InjS,Injury,NewDecAdmit,ORmDt,ORmTm,Occupation,OrgRoom,OrgRoomDt,OrgRoomTime,PrimDx,PrimDxH,PrimDxN,PrimDxNarr,PrimICD,PrimICDN,PrimPrv,PrimPrvN,PrimaryNurse,PrmNurse,PtCIDT,PtDCDT,PtDFN,PtInjury,PtName,PtStat,PtStatI,PtStatN,PtStatV,PtTrgDT,RClDt,RClTm,RecLock,RecLockDT,RecLockSite,RecLockUser,Room,RoomClear,RoomDt,RoomDtTm,RoomTime,Sex,TrgA,TrgCln,TrgDt,TrgDtTm,TrgNrs,TrgTm,VIEN,VstDur,WtgTime,x__classname,PtInjury_AtFaultAddress,PtInjury_AtFaultInsAdd,PtInjury_AtFaultInsPolicy,PtInjury_AtFaultInsurance,PtInjury_AtFaultName,PtInjury_AtFaultOther,PtInjury_BusOffc,PtInjury_BusOffcCmp,PtInjury_BusOffcStat,PtInjury_EmplAddress,PtInjury_EmplCitySt,PtInjury_EmplName,PtInjury_EmplPh,PtInjury_InjCause,PtInjury_InjCauseIEN,PtInjury_InjDt,PtInjury_InjDtTm,PtInjury_InjLocat,PtInjury_InjSet,PtInjury_InjTm,PtInjury_InjuryDetails,PtInjury_MVCLoc,PtInjury_PtDFN,PtInjury_SafetyEquip,PtInjury_VIEN,PtInjury_WrkRel INTO :%e() FROM BEDD.EDVISIT WHERE ID=:%rowid) set sqlcode=SQLCODE quit
 	 ;--- ** SQL PUBLIC Variables: %ROWCOUNT, %ROWID, %msg, SQLCODE
	Do %0Co set sqlcode=SQLCODE quit
	QUIT
 q
%0Co 
 n %mmmsqlc,%mmmsqld,%mmmsqlE,%mmmsqll,%mmmsqln,%mmmsqlp,%mmmsqlR,%mmmsqls,%mmmsqlt,%mmmsqlZ s $zt="%0Cerr" s %mmmsqld(1)=0,%mmmsqld(2)="" d:$zu(115,15) $system.ECP.Sync()
 s %mmmsqld(3)=$g(%rowid),%mmmsqld(3)=$s(%mmmsqld(3)="":"",$isvalidnum(%mmmsqld(3)):+%mmmsqld(3),1:%mmmsqld(3))
 s SQLCODE=100
 ; asl MOD# 2
 s %mmmsqld(4)=%mmmsqld(3)
 i %mmmsqld(4)'="",$d(^BEDD.EDVISITD(%mmmsqld(4)))
 e  g %0CmBdun
 s %mmmsqld(5)=$g(^BEDD.EDVISITD(%mmmsqld(4))) s %e(2)=$lg(%mmmsqld(5),2) s %e(8)=$lg(%mmmsqld(5),3) s %e(9)=$lg(%mmmsqld(5),4) s %e(11)=$lg(%mmmsqld(5),5) s %e(16)=$lg(%mmmsqld(5),41) s %e(17)=$lg(%mmmsqld(5),6) s %e(19)=$lg(%mmmsqld(5),11) s %e(21)=$lg(%mmmsqld(5),12) s %e(22)=$lg(%mmmsqld(5),42) s %e(23)=$lg(%mmmsqld(5),53) s %e(24)=$lg(%mmmsqld(5),54) s %e(25)=$lg(%mmmsqld(5),51) s %e(26)=$lg(%mmmsqld(5),52) s %e(28)=$lg(%mmmsqld(5),7) s %e(30)=$lg(%mmmsqld(5),17) s %e(31)=$lg(%mmmsqld(5),13) s %e(33)=$lg(%mmmsqld(5),36) s %e(34)=$lg(%mmmsqld(5),37) s %e(36)=$lg(%mmmsqld(5),9) s %e(39)=$lg(%mmmsqld(5),10) s %e(41)=$lg(%mmmsqld(5),15) s %e(42)=$lg(%mmmsqld(5),16) s %e(44)=$lg(%mmmsqld(5),8) s %e(45)=$lg(%mmmsqld(5),14) s %e(46)=$lg(%mmmsqld(5),34) s %e(47)=$lg(%mmmsqld(5),35) s %e(49)=$lg(%mmmsqld(5),64) s %e(52)=$lg(%mmmsqld(5),18) s %e(53)=$lg(%mmmsqld(5),21) s %e(54)=$lg(%mmmsqld(5),19) s %e(55)=$lg(%mmmsqld(5),20) s %e(58)=##class(BEDD.EDVISIT).InfoOid($lg(%mmmsqld(5),24))
 s %e(61)=$lg(%mmmsqld(5),25) s %e(63)=$lg(%mmmsqld(5),57) s %e(64)=$lg(%mmmsqld(5),58) s %e(66)=$lg(%mmmsqld(5),38) s %e(67)=$lg(%mmmsqld(5),39) s %e(68)=$lg(%mmmsqld(5),40) s %e(69)=$lg(%mmmsqld(5),22) s %e(70)=$lg(%mmmsqld(5),32) s %e(72)=$lg(%mmmsqld(5),55) s %e(73)=$lg(%mmmsqld(5),23) s %e(75)=$lg(%mmmsqld(5),33) s %e(77)=$lg(%mmmsqld(5),59) s %e(78)=$lg(%mmmsqld(5),63) s %e(81)=$lg(%mmmsqld(5),27) s %e(82)=$lg(%mmmsqld(5),26) s %e(84)=$lg(%mmmsqld(5),43) s %e(87)=$lg(%mmmsqld(5),48) s %e(89)=$lg(%mmmsqld(5),61) s %e(90)=$lg(%mmmsqld(5),62) s %e(91)=$lg(%mmmsqld(5),45) s %e(92)=$lg(%mmmsqld(5),47) s %e(93)=$lg(%mmmsqld(5),65) s %e(94)=$lg(%mmmsqld(5),46) s %e(95)=$lg(%mmmsqld(5),28) s %e(96)=$lg(%mmmsqld(5),60) s %e(97)=$lg(%mmmsqld(5),29) s %e(98)=$lg(%mmmsqld(5),56) s %e(99)=$lg(%mmmsqld(5),30) s %e(107)=$lg(%mmmsqld(5),31) s %e(110)=$lg(%mmmsqld(5),1) s %e(111)=$lg($lg(%mmmsqld(5),26),1) s %e(112)=$lg($lg(%mmmsqld(5),26),2)
 s %e(113)=$lg($lg(%mmmsqld(5),26),3) s %e(114)=$lg($lg(%mmmsqld(5),26),4) s %e(115)=$lg($lg(%mmmsqld(5),26),5) s %e(116)=##class(BEDD.EDInjury).AtFaultOtherOid($lg($lg(%mmmsqld(5),26),6)) s %e(117)=##class(BEDD.EDInjury).BusOffcOid($lg($lg(%mmmsqld(5),26),8)) s %e(118)=$lg($lg(%mmmsqld(5),26),9) s %e(119)=$lg($lg(%mmmsqld(5),26),10) s %e(120)=$lg($lg(%mmmsqld(5),26),11) s %e(121)=$lg($lg(%mmmsqld(5),26),12) s %e(122)=$lg($lg(%mmmsqld(5),26),13) s %e(123)=$lg($lg(%mmmsqld(5),26),14) s %e(124)=$lg($lg(%mmmsqld(5),26),20) s %e(125)=$lg($lg(%mmmsqld(5),26),26) s %e(126)=$lg($lg(%mmmsqld(5),26),16) s %e(127)=$lg($lg(%mmmsqld(5),26),24) s %e(128)=$lg($lg(%mmmsqld(5),26),15) s %e(129)=$lg($lg(%mmmsqld(5),26),21) s %e(130)=$lg($lg(%mmmsqld(5),26),17) s %e(131)=##class(BEDD.EDInjury).InjuryDetailsOid($lg($lg(%mmmsqld(5),26),7)) s %e(132)=$lg($lg(%mmmsqld(5),26),25) s %e(133)=$lg($lg(%mmmsqld(5),26),19) s %e(134)=$lg($lg(%mmmsqld(5),26),23) s %e(135)=$lg($lg(%mmmsqld(5),26),18)
 s %e(136)=$lg($lg(%mmmsqld(5),26),22)
 d
 . Set %e(3)=##class(BEDD.EDVISIT).GetAdPvDtm(%e(2),%e(81))
 d
 . Set %e(4)=##class(BEDD.EDVISIT).GetAdmPrv(%e(2),%e(81)) 
 d
 . Set %e(5)=##class(BEDD.EDVISIT).GetProvN(%e(4)) 
 d
 . Set %e(6)=##class(BEDD.EDVISIT).GetAge(%e(2),%e(81))
 d
 . Set %e(7)=##class(BEDD.EDVISIT).GetAM(%e(81),%e(2))
 d
 . Set %e(10)=##class(BEDD.EDVISIT).GetProvN(%e(9)) 
 d
 . Set %e(12)=##class(BEDD.EDVISIT).GetProvN(%e(11)) 
 d
 . Set %e(13)=##class(BEDD.EDVISIT).GetCIDt(%e(2),%e(81)) 
 d
 . Set %e(14)=##class(BEDD.EDVISIT).GetCITm(%e(2),%e(81)) 
 d
 . Set %e(15)=##class(BEDD.EDVISIT).GetChart(%e(2),%e(81)) 
 d
 . Set %e(18) = ##class(BEDD.EDVISIT).GetPtComplaint(%e(81),%e(2))
 d
 . Set %e(20)=##class(BEDD.EDVISIT).GetProvN(%e(19)) 
 d
 . Set %e(27)=##class(BEDD.EDVISIT).GetDCDt(%e(2))
 d
 . Set %e(29)=##class(BEDD.EDVISIT).GetDCDtTm(%e(2))
 d
 . Set %e(32)=##class(BEDD.EDVISIT).GetInstN(%e(31)) 
 d
 . Set %e(35)=##class(BEDD.EDVISIT).GetDCN(%e(2),%mmmsqld(4))
 d
 . Set %e(37)=##class(BEDD.EDVISIT).GetProvN(%e(35)) 
 d
 . Set %e(38)=##class(BEDD.EDVISIT).GetDCP(%e(2)) 
 d
 . Set %e(40)=##class(BEDD.EDVISIT).GetProvN(%e(38)) 
 d
 . Set %e(43)=##class(BEDD.EDVISIT).GetDCTm(%e(2))
 d
 . Set %e(48)=##class(BEDD.EDVISIT).GetDOB(%e(81))
 d
 . Set %e(51)=##class(BEDD.EDVISIT).GetDisp(%e(2))
 d
 . Set %e(50)=##class(BEDD.EDVISIT).GetDispN(%e(51))
 d
 . Set %e(56)=##class(BEDD.EDVISIT).GetFinA(%e(2))
 d
 . Set %e(57)=##class(BEDD.EDVISIT).GetInd(%mmmsqld(4))
 d
 . Set %e(59)=##class(BEDD.EDVISIT).GetInjC(%mmmsqld(4))
 d
 . Set %e(60)=##class(BEDD.EDVISIT).GetInjS(%mmmsqld(4))
 d
 . Set %e(62) = ##class(BEDD.EDVISIT).GetDecAdmit(%mmmsqld(4),%e(49))
 d
 . Set %e(65)=##class(BEDD.EDVISIT).GetOcc(%mmmsqld(4))
 d
 . Set %e(71)=##class(BEDD.EDVISIT).GetPrimN(%e(69))
 d
 . Set %e(74)=##class(BEDD.EDVISIT).GetICDN(%e(73))
 d
 . Set %e(76)=##class(BEDD.EDVISIT).GetProvN(%e(75)) 
 d
 . Set %e(79)=##class(BEDD.EDVISIT).CmbDt(%e(13),%e(14))
 d
 . Set %e(80)=##class(BEDD.EDVISIT).CmbDt(%e(27),%e(43))
 d
 . Set %e(83)=##class(BEDD.EDVISIT).GetName(%e(81))
 d
 . Set %e(101)=##class(BEDD.EDVISIT).GetTrgA(%e(2),%e(81))
 d
 . Set %e(85)=##class(BEDD.EDVISIT).GetPtStat(%mmmsqld(4),%e(81),%e(95),%e(30),%e(2),%e(22),%e(101))
 d
 . Set %e(86)=##class(BEDD.EDVISIT).GetPtStatN(%e(85))
 d
 . Set %e(103)=##class(BEDD.EDVISIT).GetTrgDt(%e(2),%e(81))
 d
 . Set %e(106)=##class(BEDD.EDVISIT).GetTrgTm(%e(2),%e(81))
 d
 . Set %e(88)=##class(BEDD.EDVISIT).CmbDt(%e(103),%e(106))
 d
 . Set %e(100)=##class(BEDD.EDVISIT).GetSex(%e(81))
 d
 . Set %e(102)=##class(BEDD.EDVISIT).GetTrgC(%e(2),%e(107)) 
 d
 . Set %e(104)=##class(BEDD.EDVISIT).GetTrgDtTm(%e(2),%e(81))
 d
 . Set %e(105)=##class(BEDD.EDVISIT).GetTrgN(%e(2),%e(81)) 
 d
 . Set %e(108)=##class(BEDD.EDVISIT).GetVD(%e(2)) 
 d
 . Set %e(109)=##class(BEDD.EDVISIT).GetWtg(%mmmsqld(4),%e(85),%e(13),%e(14),%e(103),%e(106),%e(63),%e(64),%e(89),%e(90)) 
 g:$zu(115,2)=0 %0CmBuncommitted i $zu(115,2)=1 l +^BEDD.EDVISITD($p(%mmmsqld(4),"||",1))#"S":$zu(115,4) i $t { s %mmmsqld(1)=1,%mmmsqld(2)=$name(^BEDD.EDVISITD($p(%mmmsqld(4),"||",1)))_"#""SI""" } else { s SQLCODE=-114,%msg="Unable to acquire shared lock on table BEDD.EDVISIT for RowID value: "_%mmmsqld(4) ztrap "LOCK"  }
 ; asl MOD# 3
 i %mmmsqld(4)'="",$d(^BEDD.EDVISITD(%mmmsqld(4)))
 e  g %0CmCdun
 s %mmmsqld(6)=$g(^BEDD.EDVISITD(%mmmsqld(4))) s %e(2)=$lg(%mmmsqld(6),2) s %e(8)=$lg(%mmmsqld(6),3) s %e(9)=$lg(%mmmsqld(6),4) s %e(11)=$lg(%mmmsqld(6),5) s %e(16)=$lg(%mmmsqld(6),41) s %e(17)=$lg(%mmmsqld(6),6) s %e(19)=$lg(%mmmsqld(6),11) s %e(21)=$lg(%mmmsqld(6),12) s %e(22)=$lg(%mmmsqld(6),42) s %e(23)=$lg(%mmmsqld(6),53) s %e(24)=$lg(%mmmsqld(6),54) s %e(25)=$lg(%mmmsqld(6),51) s %e(26)=$lg(%mmmsqld(6),52) s %e(28)=$lg(%mmmsqld(6),7) s %e(30)=$lg(%mmmsqld(6),17) s %e(31)=$lg(%mmmsqld(6),13) s %e(33)=$lg(%mmmsqld(6),36) s %e(34)=$lg(%mmmsqld(6),37) s %e(36)=$lg(%mmmsqld(6),9) s %e(39)=$lg(%mmmsqld(6),10) s %e(41)=$lg(%mmmsqld(6),15) s %e(42)=$lg(%mmmsqld(6),16) s %e(44)=$lg(%mmmsqld(6),8) s %e(45)=$lg(%mmmsqld(6),14) s %e(46)=$lg(%mmmsqld(6),34) s %e(47)=$lg(%mmmsqld(6),35) s %e(49)=$lg(%mmmsqld(6),64) s %e(52)=$lg(%mmmsqld(6),18) s %e(53)=$lg(%mmmsqld(6),21) s %e(54)=$lg(%mmmsqld(6),19) s %e(55)=$lg(%mmmsqld(6),20) s %e(58)=##class(BEDD.EDVISIT).InfoOid($lg(%mmmsqld(6),24))
 s %e(61)=$lg(%mmmsqld(6),25) s %e(63)=$lg(%mmmsqld(6),57) s %e(64)=$lg(%mmmsqld(6),58) s %e(66)=$lg(%mmmsqld(6),38) s %e(67)=$lg(%mmmsqld(6),39) s %e(68)=$lg(%mmmsqld(6),40) s %e(69)=$lg(%mmmsqld(6),22) s %e(70)=$lg(%mmmsqld(6),32) s %e(72)=$lg(%mmmsqld(6),55) s %e(73)=$lg(%mmmsqld(6),23) s %e(75)=$lg(%mmmsqld(6),33) s %e(77)=$lg(%mmmsqld(6),59) s %e(78)=$lg(%mmmsqld(6),63) s %e(81)=$lg(%mmmsqld(6),27) s %e(82)=$lg(%mmmsqld(6),26) s %e(84)=$lg(%mmmsqld(6),43) s %e(87)=$lg(%mmmsqld(6),48) s %e(89)=$lg(%mmmsqld(6),61) s %e(90)=$lg(%mmmsqld(6),62) s %e(91)=$lg(%mmmsqld(6),45) s %e(92)=$lg(%mmmsqld(6),47) s %e(93)=$lg(%mmmsqld(6),65) s %e(94)=$lg(%mmmsqld(6),46) s %e(95)=$lg(%mmmsqld(6),28) s %e(96)=$lg(%mmmsqld(6),60) s %e(97)=$lg(%mmmsqld(6),29) s %e(98)=$lg(%mmmsqld(6),56) s %e(99)=$lg(%mmmsqld(6),30) s %e(107)=$lg(%mmmsqld(6),31) s %e(110)=$lg(%mmmsqld(6),1) s %e(111)=$lg($lg(%mmmsqld(6),26),1) s %e(112)=$lg($lg(%mmmsqld(6),26),2)
 s %e(113)=$lg($lg(%mmmsqld(6),26),3) s %e(114)=$lg($lg(%mmmsqld(6),26),4) s %e(115)=$lg($lg(%mmmsqld(6),26),5) s %e(116)=##class(BEDD.EDInjury).AtFaultOtherOid($lg($lg(%mmmsqld(6),26),6)) s %e(117)=##class(BEDD.EDInjury).BusOffcOid($lg($lg(%mmmsqld(6),26),8)) s %e(118)=$lg($lg(%mmmsqld(6),26),9) s %e(119)=$lg($lg(%mmmsqld(6),26),10) s %e(120)=$lg($lg(%mmmsqld(6),26),11) s %e(121)=$lg($lg(%mmmsqld(6),26),12) s %e(122)=$lg($lg(%mmmsqld(6),26),13) s %e(123)=$lg($lg(%mmmsqld(6),26),14) s %e(124)=$lg($lg(%mmmsqld(6),26),20) s %e(125)=$lg($lg(%mmmsqld(6),26),26) s %e(126)=$lg($lg(%mmmsqld(6),26),16) s %e(127)=$lg($lg(%mmmsqld(6),26),24) s %e(128)=$lg($lg(%mmmsqld(6),26),15) s %e(129)=$lg($lg(%mmmsqld(6),26),21) s %e(130)=$lg($lg(%mmmsqld(6),26),17) s %e(131)=##class(BEDD.EDInjury).InjuryDetailsOid($lg($lg(%mmmsqld(6),26),7)) s %e(132)=$lg($lg(%mmmsqld(6),26),25) s %e(133)=$lg($lg(%mmmsqld(6),26),19) s %e(134)=$lg($lg(%mmmsqld(6),26),23) s %e(135)=$lg($lg(%mmmsqld(6),26),18)
 s %e(136)=$lg($lg(%mmmsqld(6),26),22)
 d
 . Set %e(3)=##class(BEDD.EDVISIT).GetAdPvDtm(%e(2),%e(81))
 d
 . Set %e(4)=##class(BEDD.EDVISIT).GetAdmPrv(%e(2),%e(81)) 
 d
 . Set %e(5)=##class(BEDD.EDVISIT).GetProvN(%e(4)) 
 d
 . Set %e(6)=##class(BEDD.EDVISIT).GetAge(%e(2),%e(81))
 d
 . Set %e(7)=##class(BEDD.EDVISIT).GetAM(%e(81),%e(2))
 d
 . Set %e(10)=##class(BEDD.EDVISIT).GetProvN(%e(9)) 
 d
 . Set %e(12)=##class(BEDD.EDVISIT).GetProvN(%e(11)) 
 d
 . Set %e(13)=##class(BEDD.EDVISIT).GetCIDt(%e(2),%e(81)) 
 d
 . Set %e(14)=##class(BEDD.EDVISIT).GetCITm(%e(2),%e(81)) 
 d
 . Set %e(15)=##class(BEDD.EDVISIT).GetChart(%e(2),%e(81)) 
 d
 . Set %e(18) = ##class(BEDD.EDVISIT).GetPtComplaint(%e(81),%e(2))
 d
 . Set %e(20)=##class(BEDD.EDVISIT).GetProvN(%e(19)) 
 d
 . Set %e(27)=##class(BEDD.EDVISIT).GetDCDt(%e(2))
 d
 . Set %e(29)=##class(BEDD.EDVISIT).GetDCDtTm(%e(2))
 d
 . Set %e(32)=##class(BEDD.EDVISIT).GetInstN(%e(31)) 
 d
 . Set %e(35)=##class(BEDD.EDVISIT).GetDCN(%e(2),%mmmsqld(4))
 d
 . Set %e(37)=##class(BEDD.EDVISIT).GetProvN(%e(35)) 
 d
 . Set %e(38)=##class(BEDD.EDVISIT).GetDCP(%e(2)) 
 d
 . Set %e(40)=##class(BEDD.EDVISIT).GetProvN(%e(38)) 
 d
 . Set %e(43)=##class(BEDD.EDVISIT).GetDCTm(%e(2))
 d
 . Set %e(48)=##class(BEDD.EDVISIT).GetDOB(%e(81))
 d
 . Set %e(51)=##class(BEDD.EDVISIT).GetDisp(%e(2))
 d
 . Set %e(50)=##class(BEDD.EDVISIT).GetDispN(%e(51))
 d
 . Set %e(56)=##class(BEDD.EDVISIT).GetFinA(%e(2))
 d
 . Set %e(57)=##class(BEDD.EDVISIT).GetInd(%mmmsqld(4))
 d
 . Set %e(59)=##class(BEDD.EDVISIT).GetInjC(%mmmsqld(4))
 d
 . Set %e(60)=##class(BEDD.EDVISIT).GetInjS(%mmmsqld(4))
 d
 . Set %e(62) = ##class(BEDD.EDVISIT).GetDecAdmit(%mmmsqld(4),%e(49))
 d
 . Set %e(65)=##class(BEDD.EDVISIT).GetOcc(%mmmsqld(4))
 d
 . Set %e(71)=##class(BEDD.EDVISIT).GetPrimN(%e(69))
 d
 . Set %e(74)=##class(BEDD.EDVISIT).GetICDN(%e(73))
 d
 . Set %e(76)=##class(BEDD.EDVISIT).GetProvN(%e(75)) 
 d
 . Set %e(79)=##class(BEDD.EDVISIT).CmbDt(%e(13),%e(14))
 d
 . Set %e(80)=##class(BEDD.EDVISIT).CmbDt(%e(27),%e(43))
 d
 . Set %e(83)=##class(BEDD.EDVISIT).GetName(%e(81))
 d
 . Set %e(101)=##class(BEDD.EDVISIT).GetTrgA(%e(2),%e(81))
 d
 . Set %e(85)=##class(BEDD.EDVISIT).GetPtStat(%mmmsqld(4),%e(81),%e(95),%e(30),%e(2),%e(22),%e(101))
 d
 . Set %e(86)=##class(BEDD.EDVISIT).GetPtStatN(%e(85))
 d
 . Set %e(103)=##class(BEDD.EDVISIT).GetTrgDt(%e(2),%e(81))
 d
 . Set %e(106)=##class(BEDD.EDVISIT).GetTrgTm(%e(2),%e(81))
 d
 . Set %e(88)=##class(BEDD.EDVISIT).CmbDt(%e(103),%e(106))
 d
 . Set %e(100)=##class(BEDD.EDVISIT).GetSex(%e(81))
 d
 . Set %e(102)=##class(BEDD.EDVISIT).GetTrgC(%e(2),%e(107)) 
 d
 . Set %e(104)=##class(BEDD.EDVISIT).GetTrgDtTm(%e(2),%e(81))
 d
 . Set %e(105)=##class(BEDD.EDVISIT).GetTrgN(%e(2),%e(81)) 
 d
 . Set %e(108)=##class(BEDD.EDVISIT).GetVD(%e(2)) 
 d
 . Set %e(109)=##class(BEDD.EDVISIT).GetWtg(%mmmsqld(4),%e(85),%e(13),%e(14),%e(103),%e(106),%e(63),%e(64),%e(89),%e(90)) 
%0CmBuncommitted ;
 s SQLCODE=0 g %0Cc
%0CmCdun if $zu(115,2)=1 { if $g(%mmmsqld(1))=1 { l -@%mmmsqld(2) s %mmmsqld(1)=0 } elseif $g(%mmmsqld(1))=2 { do $classmethod($li(%mmmsqld(2)),"%UnlockId",$li(%mmmsqld(2),2),1,1)  s %mmmsqld(1)=0 } }
%0CmBdun 
%0CmAdun 
%0Cc s %ROWCOUNT='SQLCODE
 if $zu(115,2)=1 { if $g(%mmmsqld(1))=1 { l -@%mmmsqld(2) } elseif $g(%mmmsqld(1))=2 { do $classmethod($li(%mmmsqld(2)),"%UnlockId",$li(%mmmsqld(2),2),1,1)  } }
 q
%0Cerr s $zt="" d SQLRunTimeError^%apiSQL($ze,.SQLCODE,.%msg)
 g %0Cc
%SQLInsert(%d,%check,%inssel,%vco,%tstart=1,%mv=0)
	new bva,%ele,%itm,%key,%l,%n,%nc,%oper,%pos,%s,sqlcode,sn,subs,icol set %oper="INSERT",sqlcode=0,%l=$c(0,0,0)
	if $d(%d(1)),'$zu(115,11) { if %d(1)'="" { set SQLCODE=-111,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler6",,"ID","BEDD"_"."_"EDVISIT") QUIT ""  } kill %d(1) } 
	if '$a(%check),'..%SQLValidateFields(.sqlcode) { set SQLCODE=sqlcode QUIT "" }
	do ..%SQLNormalizeFields()
	kill:'$TLEVEL %0CacheLock if %tstart { TSTART:($zu(115,1)=1)||('$TLEVEL&&($zu(115,1)=2))  } set $zt="ERRORInsert"
	if '$d(%d(1)) { set %d(1)=$i(^BEDD.EDVISITD) } elseif %d(1)>$g(^BEDD.EDVISITD) { if $i(^BEDD.EDVISITD,$zabs(%d(1)-$g(^BEDD.EDVISITD))) {}} elseif $d(^BEDD.EDVISITD(%d(1))) { set SQLCODE=-119,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler33",,"ID",%d(1),"BEDD"_"."_"EDVISIT"_"."_"ID") do ..%SQLDeleteTempStreams() do ..%SQLEExit() QUIT "" }
	do ..%SQLInsertComputes()
	if '$a(%check) do  if sqlcode<0 s SQLCODE=sqlcode do ..%SQLDeleteTempStreams() do ..%SQLEExit() QUIT ""
	. if $g(%vco)'="" do ..%SQLInsertComputes(1) d @%vco quit:sqlcode<0
	for icol=110,58,116,117,131,107,13,2,81,28,27,84,95,30,22,101,111,82,112,113,114,115,118,119,120,121,122,123,124,125,126,127,128,129,130,132,133,134,135,136 set:'$d(%d(icol)) %d(icol)=""
	if '$a(%check,2) { new %ls if $i(%0CacheLock("BEDD.EDVISIT"))>$zu(115,6) { lock +^BEDD.EDVISITD:$zu(115,4) lock:$t -^BEDD.EDVISITD set %ls=$s($t:2,1:0) } else { lock +^BEDD.EDVISITD(%d(1)):$zu(115,4) set %ls=$t } set:%ls=2 $e(%check,2)=$c(1) set:%ls=1 $e(%l)=$c(1) if '%ls set SQLCODE=-110,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler40",,%oper,"BEDD"_"."_"EDVISIT",$g(%d(1))) do ..%SQLEExit() QUIT ""  }
	if '$a(%check,5),'$a(%check,6) { n %node,%rc,%sid,%size,%stream,%tmp,%ts
		k %sid i %d(58)'="" { s %stream=##class(BEDD.EDVISIT).InfoOpen("") i %stream="" { s SQLCODE=-412,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler11",,"BEDD"_"."_"EDVISIT","Info") do ..%SQLEExit() QUIT "" } s %ts="" if $isobject(%d(58)) { s %ts=%d(58) } elseif (%d(58)?1.n1"@"1.e) { try { if $zobjref(%d(58))'="" { s %ts=$zobjref(%d(58)) }} catch { if $ze["<INVALID OREF>" { s $ze="" } else { GOTO ERRORInsert }}} elseif $ListValid(%d(58)) { s %ts=##class(%Stream.Object).%Open(%d(58)) } if $isobject(%ts) { if '%ts.IsNull() { s %rc=%stream.CopyFromAndSave(%ts) i '%rc { s SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) s:%msg %msg=%msg(1) k %stream,%ts do ..%SQLEExit() QUIT "" }} else { s %rc=%stream.%Save() i '%rc { k %stream s SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) s:%msg %msg=%msg(1) s %msg=$g(%msg)_"  "_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler12",,"BEDD"_"."_"EDVISIT","Info")_": "_$g(%d(58))_"'" k %ts do ..%SQLEExit() QUIT "" }} k %ts } elseif $d(%d(58)),%d(58)'=-1,%d(58)'="" { s %ts=%d(58) s:%ts=$c(0) %ts="" s %rc=%stream.Write(%ts) i '%rc { k %stream s SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) s:%msg %msg=%msg(1) s %msg=$g(%msg)_"  "_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler13",,"BEDD"_"."_"EDVISIT","Info") do ..%SQLEExit() QUIT ""}  s %rc=%stream.%Save() i '%rc { k %stream s SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) s:%msg %msg=%msg(1) s %msg=$g(%msg)_" "_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler12",,"BEDD"_"."_"EDVISIT","Info")_": '"_$g(%d(58))_"'" do ..%SQLEExit() QUIT "" }} else { s %rc=%stream.%Save() i '%rc { k %stream s SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) s:%msg %msg=%msg(1) s %msg=$g(%msg)_"  "_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler12",,"BEDD"_"."_"EDVISIT","Info")_": '"_$g(%d(58))_"'" do ..%SQLEExit() QUIT "" }} s %d(58)=%stream.%Oid() k %stream,%ts s %d(58)=$li(%d(58),1,2) }
		k %sid i %d(116)'="" { s %stream=##class(BEDD.EDInjury).AtFaultOtherOpen("") i %stream="" { s SQLCODE=-412,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler11",,"BEDD"_"."_"EDVISIT","PtInjury_AtFaultOther") do ..%SQLEExit() QUIT "" } s %ts="" if $isobject(%d(116)) { s %ts=%d(116) } elseif (%d(116)?1.n1"@"1.e) { try { if $zobjref(%d(116))'="" { s %ts=$zobjref(%d(116)) }} catch { if $ze["<INVALID OREF>" { s $ze="" } else { GOTO ERRORInsert }}} elseif $ListValid(%d(116)) { s %ts=##class(%Stream.Object).%Open(%d(116)) } if $isobject(%ts) { if '%ts.IsNull() { s %rc=%stream.CopyFromAndSave(%ts) i '%rc { s SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) s:%msg %msg=%msg(1) k %stream,%ts do ..%SQLEExit() QUIT "" }} else { s %rc=%stream.%Save() i '%rc { k %stream s SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) s:%msg %msg=%msg(1) s %msg=$g(%msg)_"  "_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler12",,"BEDD"_"."_"EDVISIT","PtInjury_AtFaultOther")_": "_$g(%d(116))_"'" k %ts do ..%SQLEExit() QUIT "" }} k %ts } elseif $d(%d(116)),%d(116)'=-1,%d(116)'="" { s %ts=%d(116) s:%ts=$c(0) %ts="" s %rc=%stream.Write(%ts) i '%rc { k %stream s SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) s:%msg %msg=%msg(1) s %msg=$g(%msg)_"  "_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler13",,"BEDD"_"."_"EDVISIT","PtInjury_AtFaultOther") do ..%SQLEExit() QUIT ""}  s %rc=%stream.%Save() i '%rc { k %stream s SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) s:%msg %msg=%msg(1) s %msg=$g(%msg)_" "_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler12",,"BEDD"_"."_"EDVISIT","PtInjury_AtFaultOther")_": '"_$g(%d(116))_"'" do ..%SQLEExit() QUIT "" }} else { s %rc=%stream.%Save() i '%rc { k %stream s SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) s:%msg %msg=%msg(1) s %msg=$g(%msg)_"  "_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler12",,"BEDD"_"."_"EDVISIT","PtInjury_AtFaultOther")_": '"_$g(%d(116))_"'" do ..%SQLEExit() QUIT "" }} s %d(116)=%stream.%Oid() k %stream,%ts s %d(116)=$li(%d(116),1,2) }
		k %sid i %d(117)'="" { s %stream=##class(BEDD.EDInjury).BusOffcOpen("") i %stream="" { s SQLCODE=-412,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler11",,"BEDD"_"."_"EDVISIT","PtInjury_BusOffc") do ..%SQLEExit() QUIT "" } s %ts="" if $isobject(%d(117)) { s %ts=%d(117) } elseif (%d(117)?1.n1"@"1.e) { try { if $zobjref(%d(117))'="" { s %ts=$zobjref(%d(117)) }} catch { if $ze["<INVALID OREF>" { s $ze="" } else { GOTO ERRORInsert }}} elseif $ListValid(%d(117)) { s %ts=##class(%Stream.Object).%Open(%d(117)) } if $isobject(%ts) { if '%ts.IsNull() { s %rc=%stream.CopyFromAndSave(%ts) i '%rc { s SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) s:%msg %msg=%msg(1) k %stream,%ts do ..%SQLEExit() QUIT "" }} else { s %rc=%stream.%Save() i '%rc { k %stream s SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) s:%msg %msg=%msg(1) s %msg=$g(%msg)_"  "_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler12",,"BEDD"_"."_"EDVISIT","PtInjury_BusOffc")_": "_$g(%d(117))_"'" k %ts do ..%SQLEExit() QUIT "" }} k %ts } elseif $d(%d(117)),%d(117)'=-1,%d(117)'="" { s %ts=%d(117) s:%ts=$c(0) %ts="" s %rc=%stream.Write(%ts) i '%rc { k %stream s SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) s:%msg %msg=%msg(1) s %msg=$g(%msg)_"  "_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler13",,"BEDD"_"."_"EDVISIT","PtInjury_BusOffc") do ..%SQLEExit() QUIT ""}  s %rc=%stream.%Save() i '%rc { k %stream s SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) s:%msg %msg=%msg(1) s %msg=$g(%msg)_" "_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler12",,"BEDD"_"."_"EDVISIT","PtInjury_BusOffc")_": '"_$g(%d(117))_"'" do ..%SQLEExit() QUIT "" }} else { s %rc=%stream.%Save() i '%rc { k %stream s SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) s:%msg %msg=%msg(1) s %msg=$g(%msg)_"  "_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler12",,"BEDD"_"."_"EDVISIT","PtInjury_BusOffc")_": '"_$g(%d(117))_"'" do ..%SQLEExit() QUIT "" }} s %d(117)=%stream.%Oid() k %stream,%ts s %d(117)=$li(%d(117),1,2) }
		k %sid i %d(131)'="" { s %stream=##class(BEDD.EDInjury).InjuryDetailsOpen("") i %stream="" { s SQLCODE=-412,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler11",,"BEDD"_"."_"EDVISIT","PtInjury_InjuryDetails") do ..%SQLEExit() QUIT "" } s %ts="" if $isobject(%d(131)) { s %ts=%d(131) } elseif (%d(131)?1.n1"@"1.e) { try { if $zobjref(%d(131))'="" { s %ts=$zobjref(%d(131)) }} catch { if $ze["<INVALID OREF>" { s $ze="" } else { GOTO ERRORInsert }}} elseif $ListValid(%d(131)) { s %ts=##class(%Stream.Object).%Open(%d(131)) } if $isobject(%ts) { if '%ts.IsNull() { s %rc=%stream.CopyFromAndSave(%ts) i '%rc { s SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) s:%msg %msg=%msg(1) k %stream,%ts do ..%SQLEExit() QUIT "" }} else { s %rc=%stream.%Save() i '%rc { k %stream s SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) s:%msg %msg=%msg(1) s %msg=$g(%msg)_"  "_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler12",,"BEDD"_"."_"EDVISIT","PtInjury_InjuryDetails")_": "_$g(%d(131))_"'" k %ts do ..%SQLEExit() QUIT "" }} k %ts } elseif $d(%d(131)),%d(131)'=-1,%d(131)'="" { s %ts=%d(131) s:%ts=$c(0) %ts="" s %rc=%stream.Write(%ts) i '%rc { k %stream s SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) s:%msg %msg=%msg(1) s %msg=$g(%msg)_"  "_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler13",,"BEDD"_"."_"EDVISIT","PtInjury_InjuryDetails") do ..%SQLEExit() QUIT ""}  s %rc=%stream.%Save() i '%rc { k %stream s SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) s:%msg %msg=%msg(1) s %msg=$g(%msg)_" "_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler12",,"BEDD"_"."_"EDVISIT","PtInjury_InjuryDetails")_": '"_$g(%d(131))_"'" do ..%SQLEExit() QUIT "" }} else { s %rc=%stream.%Save() i '%rc { k %stream s SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) s:%msg %msg=%msg(1) s %msg=$g(%msg)_"  "_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler12",,"BEDD"_"."_"EDVISIT","PtInjury_InjuryDetails")_": '"_$g(%d(131))_"'" do ..%SQLEExit() QUIT "" }} s %d(131)=%stream.%Oid() k %stream,%ts s %d(131)=$li(%d(131),1,2) }
	}
	set ^BEDD.EDVISITD(%d(1))=$lb(%d(110),%d(2),$g(%d(8)),$g(%d(9)),$g(%d(11)),$g(%d(17)),%d(28),$g(%d(44)),$g(%d(36)),$g(%d(39)),$g(%d(19)),$g(%d(21)),$g(%d(31)),$g(%d(45)),$g(%d(41)),$g(%d(42)),%d(30),$g(%d(52)),$g(%d(54)),$g(%d(55)),$g(%d(53)),$g(%d(69)),$g(%d(73)),%d(58),$g(%d(61)),$lb(%d(111),%d(112),%d(113),%d(114),%d(115),%d(116),%d(131),%d(117),%d(118),%d(119),%d(120),%d(121),%d(122),%d(123),%d(128),%d(126),%d(130),%d(135),%d(133),%d(124),%d(129),%d(136),%d(134),%d(127),%d(132),%d(125)),%d(81),%d(95),$g(%d(97)),$g(%d(99)),%d(107),$g(%d(70)),$g(%d(75)),$g(%d(46)),$g(%d(47)),$g(%d(33)),$g(%d(34)),$g(%d(66)),$g(%d(67)),$g(%d(68)),$g(%d(16)),%d(22),%d(84),,$g(%d(91)),$g(%d(94)),$g(%d(92)),$g(%d(87)),,,$g(%d(25)),$g(%d(26)),$g(%d(23)),$g(%d(24)),$g(%d(72)),$g(%d(98)),$g(%d(63)),$g(%d(64)),$g(%d(77)),$g(%d(96)),$g(%d(89)),$g(%d(90)),$g(%d(78)),$g(%d(49)),$g(%d(93)))
	i '$a(%check,3) { s sn(1)=%d(107) s:sn(1)="" sn(1)=-1E14 s sn(2)=%d(1) s ^BEDD.EDVISITI("ADIdx",sn(1),sn(2))=%d(110)
		s sn(1)=%d(13) s:sn(1)="" sn(1)=-1E14 s sn(2)=%d(1) s ^BEDD.EDVISITI("ArrIdx",sn(1),sn(2))=$lb(%d(110),%d(13))
		s sn(1)=%d(13) s:sn(1)="" sn(1)=-1E14 s sn(2)=%d(1) s ^BEDD.EDVISITI("CIDtIIdx",sn(1),sn(2))=$lb(%d(110),%d(13))
		s sn(1)=$zu(28,%d(28),7) s sn(2)=%d(1) s ^BEDD.EDVISITI("DCDTIdx",sn(1),sn(2))=%d(110)
		s sn(1)=%d(27) s:sn(1)="" sn(1)=-1E14 s sn(2)=%d(1) s ^BEDD.EDVISITI("DisIdx",sn(1),sn(2))=%d(110) }
	lock:$a(%l) -^BEDD.EDVISITD(%d(1))
	TCOMMIT:%tstart&&($zu(115,1)=1)
	set SQLCODE=0 QUIT %d(1) 			// %SQLInsert
ERRORInsert	set $zt="",SQLCODE=-415,%msg=$s($g(%msg)'="":%msg_" -- ",1:"")_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler51",,%oper,"BEDD"_"."_"EDVISIT",$ze) if $ze["<FRAMESTACK>" { set %msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler52",,$ze,%oper,"BEDD"_"."_"EDVISIT") do ##Class(%SYS.System).WriteToConsoleLog(%msg) if ($zu(67,10,$j)=1)||($zu(67,10,$j)=3) { write !,%msg h 3 } HALT  } do ..%SQLEExit() QUIT ""
	Quit
%SQLInsertComputes(view=0)
	if 'view {
	set %d(13)="" do ..CIDtSQLCompute()
	set %d(27)="" do ..DCDtSQLCompute()
	do SQLComputeIns111
	do SQLComputeIns112
	do SQLComputeIns113
	do SQLComputeIns114
	do SQLComputeIns115
	do SQLComputeIns116
	do SQLComputeIns117
	do SQLComputeIns118
	do SQLComputeIns119
	do SQLComputeIns120
	do SQLComputeIns121
	do SQLComputeIns122
	do SQLComputeIns123
	do SQLComputeIns124
	do SQLComputeIns125
	do SQLComputeIns126
	do SQLComputeIns127
	do SQLComputeIns128
	do SQLComputeIns129
	do SQLComputeIns130
	do SQLComputeIns131
	do SQLComputeIns132
	do SQLComputeIns133
	do SQLComputeIns134
	do SQLComputeIns135
	do SQLComputeIns136
	set %d(101)="" do ..TrgASQLCompute()
	if '$d(%d(84)) set %d(84)="" do ..PtStatSQLCompute()
	}
	else {
	set %d(3)="" do ..AdPvDtmSQLCompute()
	set %d(4)="" do ..AdmPrvSQLCompute()
	set %d(5)="" do ..AdmPrvNSQLCompute()
	set %d(6)="" do ..AgeSQLCompute()
	set %d(7)="" do ..ArrModeSQLCompute()
	set %d(10)="" do ..AsgNrsNSQLCompute()
	set %d(12)="" do ..AsgPrvNSQLCompute()
	set %d(13)="" do ..CIDtSQLCompute()
	set %d(14)="" do ..CITmSQLCompute()
	set %d(15)="" do ..ChartSQLCompute()
	set %d(18)="" do ..ComplaintSQLCompute()
	set %d(20)="" do ..DCDPrvHNSQLCompute()
	set %d(27)="" do ..DCDtSQLCompute()
	set %d(29)="" do ..DCDtTmSQLCompute()
	set %d(32)="" do ..DCInstHNSQLCompute()
	set %d(35)="" do ..DCNrsSQLCompute()
	set %d(37)="" do ..DCNrsNSQLCompute()
	set %d(38)="" do ..DCPrvSQLCompute()
	set %d(40)="" do ..DCPrvNSQLCompute()
	set %d(43)="" do ..DCTmSQLCompute()
	set %d(48)="" do ..DOBSQLCompute()
	set %d(51)="" do ..DispositionSQLCompute()
	set %d(50)="" do ..DispNSQLCompute()
	set %d(56)="" do ..FinASQLCompute()
	set %d(57)="" do ..IndustrySQLCompute()
	set %d(59)="" do ..InjCSQLCompute()
	set %d(60)="" do ..InjSSQLCompute()
	set %d(62)="" do ..NewDecAdmitSQLCompute()
	set %d(65)="" do ..OccupationSQLCompute()
	set %d(71)="" do ..PrimDxNSQLCompute()
	set %d(74)="" do ..PrimICDNSQLCompute()
	set %d(76)="" do ..PrimPrvNSQLCompute()
	set %d(79)="" do ..PtCIDTSQLCompute()
	set %d(80)="" do ..PtDCDTSQLCompute()
	set %d(83)="" do ..PtNameSQLCompute()
	set %d(101)="" do ..TrgASQLCompute()
	set %d(85)="" do ..PtStatISQLCompute()
	set %d(86)="" do ..PtStatNSQLCompute()
	set %d(103)="" do ..TrgDtSQLCompute()
	set %d(106)="" do ..TrgTmSQLCompute()
	set %d(88)="" do ..PtTrgDTSQLCompute()
	set %d(100)="" do ..SexSQLCompute()
	set %d(102)="" do ..TrgClnSQLCompute()
	set %d(104)="" do ..TrgDtTmSQLCompute()
	set %d(105)="" do ..TrgNrsSQLCompute()
	set %d(108)="" do ..VstDurSQLCompute()
	set %d(109)="" do ..WtgTimeSQLCompute()
	}
	QUIT
SQLComputeIns111		// Compute code for field PtInjury_AtFaultAddress
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(111)=$lg($g(%d(82)),1) q
SQLComputeIns112		// Compute code for field PtInjury_AtFaultInsAdd
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(112)=$lg($g(%d(82)),2) q
SQLComputeIns113		// Compute code for field PtInjury_AtFaultInsPolicy
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(113)=$lg($g(%d(82)),3) q
SQLComputeIns114		// Compute code for field PtInjury_AtFaultInsurance
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(114)=$lg($g(%d(82)),4) q
SQLComputeIns115		// Compute code for field PtInjury_AtFaultName
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(115)=$lg($g(%d(82)),5) q
SQLComputeIns116		// Compute code for field PtInjury_AtFaultOther
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(116)=$lg($g(%d(82)),6) q
SQLComputeIns117		// Compute code for field PtInjury_BusOffc
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(117)=$lg($g(%d(82)),8) q
SQLComputeIns118		// Compute code for field PtInjury_BusOffcCmp
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(118)=$lg($g(%d(82)),9) q
SQLComputeIns119		// Compute code for field PtInjury_BusOffcStat
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(119)=$lg($g(%d(82)),10) q
SQLComputeIns120		// Compute code for field PtInjury_EmplAddress
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(120)=$lg($g(%d(82)),11) q
SQLComputeIns121		// Compute code for field PtInjury_EmplCitySt
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(121)=$lg($g(%d(82)),12) q
SQLComputeIns122		// Compute code for field PtInjury_EmplName
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(122)=$lg($g(%d(82)),13) q
SQLComputeIns123		// Compute code for field PtInjury_EmplPh
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(123)=$lg($g(%d(82)),14) q
SQLComputeIns124		// Compute code for field PtInjury_InjCause
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(124)=$lg($g(%d(82)),20) q
SQLComputeIns125		// Compute code for field PtInjury_InjCauseIEN
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(125)=$lg($g(%d(82)),26) q
SQLComputeIns126		// Compute code for field PtInjury_InjDt
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(126)=$lg($g(%d(82)),16) q
SQLComputeIns127		// Compute code for field PtInjury_InjDtTm
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(127)=$lg($g(%d(82)),24) q
SQLComputeIns128		// Compute code for field PtInjury_InjLocat
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(128)=$lg($g(%d(82)),15) q
SQLComputeIns129		// Compute code for field PtInjury_InjSet
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(129)=$lg($g(%d(82)),21) q
SQLComputeIns130		// Compute code for field PtInjury_InjTm
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(130)=$lg($g(%d(82)),17) q
SQLComputeIns131		// Compute code for field PtInjury_InjuryDetails
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(131)=$lg($g(%d(82)),7) q
SQLComputeIns132		// Compute code for field PtInjury_MVCLoc
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(132)=$lg($g(%d(82)),25) q
SQLComputeIns133		// Compute code for field PtInjury_PtDFN
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(133)=$lg($g(%d(82)),19) q
SQLComputeIns134		// Compute code for field PtInjury_SafetyEquip
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(134)=$lg($g(%d(82)),23) q
SQLComputeIns135		// Compute code for field PtInjury_VIEN
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(135)=$lg($g(%d(82)),18) q
SQLComputeIns136		// Compute code for field PtInjury_WrkRel
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(136)=$lg($g(%d(82)),22) q
%SQLInvalid(pIcol,pVal) public {
	set:$l($g(pVal))>40 pVal=$e(pVal,1,40)_"..." do:'$d(%n) ..%SQLnBuild() set %msg=$s($g(%msg)'="":%msg_$c(13,10),1:"")_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler37",,"BEDD"_"."_"EDVISIT"_"."_$lg(%n,pIcol),$s($g(pVal)'="":$s(pVal="":"<NULL>",pVal=$c(0):"<EMPTY STRING>",1:"'"_pVal_"'"),1:"")),sqlcode=$s(%oper="INSERT":-104,1:-105)
	QUIT sqlcode }
%SQLMissing(fname)
	set sqlcode=-108,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler47",,fname,"BEDD"_"."_"EDVISIT") quit
%SQLNormalizeFields()
	set:$g(%d(126))'="" %d(126)=$$NormalizeField126(%d(126))
	set:$g(%d(130))'="" %d(130)=$$NormalizeField130(%d(130))
	set:$g(%d(107))'="" %d(107)=$e(%d(107),1,50)
	for %f=3,13,23,25,27,29,67,97,103,104 { set:$g(%d(%f))'="" %d(%f)=$s($zu(115,13)&&(%d(%f)=$c(0)):"",1:%d(%f)\1) }
	for %f=14,24,26,43,68,99,106 { set:$g(%d(%f))'="" %d(%f)=$select($zu(115,13)&&(%d(%f)=$c(0)):"",1:%d(%f)) }
	for %f=22,30,84,85,86,87,91,108,109 { set:$g(%d(%f))'="" %d(%f)=$select($zu(115,13)&&(%d(%f)=$c(0)):"",1:%d(%f)\1) }
	QUIT
NormalizeField126(%val)	Quit $s($zu(115,13)&&(%val=$c(0)):"",1:%val\1)
NormalizeField130(%val)	Quit $select($zu(115,13)&&(%val=$c(0)):"",1:%val)
	Quit
%SQLPurgeIndices(pIndices="")
	QUIT ..%PurgeIndices(pIndices)
%SQLQuickBulkInsert(%nolock=0)
	// Insert multiple new rows with values %qd(icol)
	new c,call,nc,nr,%qd,r,x set:%nolock=2 %nolock=0
	set nr=$zobjexport(12) for r=1:1:nr { set nc=$zobjexport(12) kill %qd for c=1:1:nc { set:$zobjexport(17) %qd(c+1)=$zobjexport(12) } do ..%SQLQuickInsert(.%qd,%nolock) set x=$zobjexport($s(%qrc:-1,1:%ROWID),18) } QUIT
%SQLQuickBulkLoad(%rowidlist,%nolock=0,pkey=0)
	// QuickLoad multiple rows
	new i,rc set:%nolock=2 %nolock=0 set rc=0
	for i=2:1:$lg(%rowidlist)+1 { do ..%SQLQuickLoad($lg(%rowidlist,i),%nolock) if SQLCODE=0 { set rc=rc+1 } else { QUIT  } } set %ROWCOUNT=rc QUIT
	Quit
%SQLQuickBulkSave(%nolock=0)
	// Insert and/or Update multiple [new] rows with values %qd(icol)
	set x=$zobjexport(-1,18),%qrc=400,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler44",,"BEDD"_"."_"EDVISIT") QUIT
%SQLQuickBulkUpdate(%nolock=0)
	// Update multiple new rows with values %qd(icol)
	new c,call,nc,nr,%qd,r,x set:%nolock=2 %nolock=0 set nr=$zobjexport(12) for r=1:1:nr { set %rowid=$zobjexport(12),nc=$zobjexport(12) kill %qd for c=1:1:nc { set:$zobjexport(17) %qd(c+1)=$zobjexport(12) } do ..%SQLQuickUpdate(%rowid,.%qd,%nolock) set x=$zobjexport($s(%qrc:-1,1:%ROWID),18) quit:%qrc  } QUIT  
%SQLQuickDelete(%rowid,%nolock=0,pkey=0)
	// Delete row where SQLRowID=%rowid
	set:%nolock=2 %nolock=0
	do ..%SQLDelete(%rowid,$c(0,%nolock=1,0,0,0,0))
	if SQLCODE<0 { set %qrc=-SQLCODE,%ROWCOUNT=0 } else { set %ROWCOUNT=1,%qrc=SQLCODE } QUIT
	Quit
%SQLQuickInsert(d,%nolock=0,pkey=0,parentpkey=0)
	// Insert new row with values d(icol)
	set:%nolock=2 %nolock=0
	do ..%SQLQuickOdbcToLogical(.d)
	set %ROWID=..%SQLInsert(.d,$c(0,%nolock=1,0,0,0,0)),%ROWCOUNT='SQLCODE,%qrc=SQLCODE kill d QUIT
%SQLQuickLoad(%rowid,%nolock=0,pkey=0,qq=0)
	// Get fields from row where SQLRowID=%rowid
	new d,i,il,subs,t set:%nolock=2 %nolock=1
	if %nolock=0 { if '..%SQLAcquireLock(%rowid) { set %qrc=114,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler45",,"BEDD"_"."_"EDVISIT",%rowid),%ROWCOUNT=0 QUIT  } set:$zu(115,2) il=$zu(115,2,0) }
	 ;---&sql(SELECT %INTERNAL(ID),AMERVSIT,AdPvDtm,AdmPrv,AdmPrvN,Age,ArrMode,AsgCln,AsgNrs,AsgNrsN,AsgPrv,AsgPrvN,CIDt,CITm,Chart,Clinic,CodeBlue,Complaint,DCDPrvH,DCDPrvHN,DCDispH,DCDocH,DCDocHEDt,DCDocHETm,DCDocHSDt,DCDocHSTm,DCDt,DCDtH,DCDtTm,DCFlag,DCInstH,DCInstHN,DCMode,DCModeN,DCNrs,DCNrsH,DCNrsN,DCPrv,DCPrvH,DCPrvN,DCStat,DCStatN,DCTm,DCTmH,DCTrgH,DCTrns,DCTrnsN,DOB,DecAdmDt,DispN,Disposition,EDConsult,EDDx,EDProcedure,EDTrans,FinA,Industry,Info,InjC,InjS,Injury,NewDecAdmit,ORmDt,ORmTm,Occupation,OrgRoom,OrgRoomDt,OrgRoomTime,PrimDx,PrimDxH,PrimDxN,PrimDxNarr,PrimICD,PrimICDN,PrimPrv,PrimPrvN,PrimaryNurse,PrmNurse,PtCIDT,PtDCDT,PtDFN,%INTERNAL(PtInjury),PtName,PtStat,PtStatI,PtStatN,PtStatV,PtTrgDT,RClDt,RClTm,RecLock,RecLockDT,RecLockSite,RecLockUser,Room,RoomClear,RoomDt,RoomDtTm,RoomTime,Sex,TrgA,TrgCln,TrgDt,TrgDtTm,TrgNrs,TrgTm,VIEN,VstDur,WtgTime,x__classname,PtInjury_AtFaultAddress,PtInjury_AtFaultInsAdd,PtInjury_AtFaultInsPolicy,PtInjury_AtFaultInsurance,PtInjury_AtFaultName,PtInjury_AtFaultOther,PtInjury_BusOffc,PtInjury_BusOffcCmp,PtInjury_BusOffcStat,PtInjury_EmplAddress,PtInjury_EmplCitySt,PtInjury_EmplName,PtInjury_EmplPh,PtInjury_InjCause,PtInjury_InjCauseIEN,PtInjury_InjDt,PtInjury_InjDtTm,PtInjury_InjLocat,PtInjury_InjSet,PtInjury_InjTm,PtInjury_InjuryDetails,PtInjury_MVCLoc,PtInjury_PtDFN,PtInjury_SafetyEquip,PtInjury_VIEN,PtInjury_WrkRel INTO :d(1),:d(2),:d(3),:d(4),:d(5),:d(6),:d(7),:d(8),:d(9),:d(10),:d(11),:d(12),:d(13),:d(14),:d(15),:d(16),:d(17),:d(18),:d(19),:d(20),:d(21),:d(22),:d(23),:d(24),:d(25),:d(26),:d(27),:d(28),:d(29),:d(30),:d(31),:d(32),:d(33),:d(34),:d(35),:d(36),:d(37),:d(38),:d(39),:d(40),:d(41),:d(42),:d(43),:d(44),:d(45),:d(46),:d(47),:d(48),:d(49),:d(50),:d(51),:d(52),:d(53),:d(54),:d(55),:d(56),:d(57),:d(58),:d(59),:d(60),:d(61),:d(62),:d(63),:d(64),:d(65),:d(66),:d(67),:d(68),:d(69),:d(70),:d(71),:d(72),:d(73),:d(74),:d(75),:d(76),:d(77),:d(78),:d(79),:d(80),:d(81),:d(82),:d(83),:d(84),:d(85),:d(86),:d(87),:d(88),:d(89),:d(90),:d(91),:d(92),:d(93),:d(94),:d(95),:d(96),:d(97),:d(98),:d(99),:d(100),:d(101),:d(102),:d(103),:d(104),:d(105),:d(106),:d(107),:d(108),:d(109),:d(110),:d(111),:d(112),:d(113),:d(114),:d(115),:d(116),:d(117),:d(118),:d(119),:d(120),:d(121),:d(122),:d(123),:d(124),:d(125),:d(126),:d(127),:d(128),:d(129),:d(130),:d(131),:d(132),:d(133),:d(134),:d(135),:d(136) FROM BEDD.EDVISIT WHERE %ID = :%rowid)
 	 ;--- ** SQL PUBLIC Variables: %ROWCOUNT, %ROWID, %msg, SQLCODE, d
	Do %0Eo
	if SQLCODE { if %nolock=0 { do ..%SQLReleaseLock(%rowid,0,1) do:$g(il) $zu(115,2,il) } set %ROWCOUNT=0 set:SQLCODE<0 SQLCODE=-SQLCODE set %qrc=SQLCODE QUIT  }
	if qq,d(110)'="" { new sn set sn=$p(d(110),$e(d(110)),$l(d(110),$e(d(110)))-1) if "BEDD.EDVISIT"'=sn { if %nolock=0 { do ..%SQLReleaseLock(%rowid,0,1) do:$g(il) $zu(115,2,il) } kill d set:sn'["." sn="User."_sn  do $classmethod(sn,"%SQLQuickLoad",%rowid,%nolock,0,1) QUIT  }}
	if %nolock=0 { if $zu(115,1)=1 { TSTART  } elseIf '$TLEVEL,$zu(115,1)=2 { TSTART  }}
	set:qq d=$zobjexport("BEDD.EDVISIT",18),d=$zobjexport(136,18) set i=-1 for  { set i=$o(d(i)) quit:i=""  set d=$zobjexport(d(i),18) } set %qrc=0,%ROWCOUNT=1 if %nolock=0 { d ..%SQLReleaseLock(%rowid,0,0) do:$g(il) $zu(115,2,il) } quit
	Quit
 q
%0EmBs1(%val="") ;
	Quit $select(%val="":"",%val'["-":$zdate(%val,3),1:%val)
%0EmBs2(%val="") ;
	Quit $select(%val="":"",1:$ztime(%val))
%0Eo 
 n %mmmsqlc,%mmmsqld,%mmmsqlE,%mmmsqll,%mmmsqln,%mmmsqlp,%mmmsqlR,%mmmsqls,%mmmsqlt,%mmmsqlZ s $zt="%0Eerr" s %mmmsqld(1)=0,%mmmsqld(2)="" d:$zu(115,15) $system.ECP.Sync()
 s %mmmsqld(3)=$g(%rowid),%mmmsqld(3)=$s(%mmmsqld(3)="":"",$isvalidnum(%mmmsqld(3)):+%mmmsqld(3),1:%mmmsqld(3))
 s SQLCODE=100
 ; asl MOD# 2
 s %mmmsqld(4)=%mmmsqld(3)
 i %mmmsqld(4)'="",$d(^BEDD.EDVISITD(%mmmsqld(4)))
 e  g %0EmBdun
 s d(1)=%mmmsqld(4)
 s %mmmsqld(5)=$g(^BEDD.EDVISITD(%mmmsqld(4))) s d(2)=$lg(%mmmsqld(5),2) s d(8)=$lg(%mmmsqld(5),3) s d(9)=$lg(%mmmsqld(5),4) s d(11)=$lg(%mmmsqld(5),5) s d(16)=$lg(%mmmsqld(5),41) s d(17)=$lg(%mmmsqld(5),6) s d(19)=$lg(%mmmsqld(5),11) s d(21)=$lg(%mmmsqld(5),12) s d(22)=$lg(%mmmsqld(5),42) s %mmmsqld(6)=$lg(%mmmsqld(5),53) s d(23)=$$%0EmBs1(%mmmsqld(6)) s %mmmsqld(7)=$lg(%mmmsqld(5),54) s d(24)=$$%0EmBs2(%mmmsqld(7)) s %mmmsqld(8)=$lg(%mmmsqld(5),51) s d(25)=$$%0EmBs1(%mmmsqld(8)) s %mmmsqld(9)=$lg(%mmmsqld(5),52) s d(26)=$$%0EmBs2(%mmmsqld(9)) s d(28)=$lg(%mmmsqld(5),7) s d(30)=$lg(%mmmsqld(5),17) s d(31)=$lg(%mmmsqld(5),13) s d(33)=$lg(%mmmsqld(5),36) s d(34)=$lg(%mmmsqld(5),37) s d(36)=$lg(%mmmsqld(5),9) s d(39)=$lg(%mmmsqld(5),10) s d(41)=$lg(%mmmsqld(5),15) s d(42)=$lg(%mmmsqld(5),16) s d(44)=$lg(%mmmsqld(5),8) s d(45)=$lg(%mmmsqld(5),14) s d(46)=$lg(%mmmsqld(5),34) s d(47)=$lg(%mmmsqld(5),35) s d(49)=$lg(%mmmsqld(5),64)
 s d(52)=$lg(%mmmsqld(5),18) s d(53)=$lg(%mmmsqld(5),21) s d(54)=$lg(%mmmsqld(5),19) s d(55)=$lg(%mmmsqld(5),20) s d(58)=##class(BEDD.EDVISIT).InfoOid($lg(%mmmsqld(5),24)) s d(61)=$lg(%mmmsqld(5),25) s d(63)=$lg(%mmmsqld(5),57) s d(64)=$lg(%mmmsqld(5),58) s d(66)=$lg(%mmmsqld(5),38) s %mmmsqld(10)=$lg(%mmmsqld(5),39) s d(67)=$$%0EmBs1(%mmmsqld(10)) s %mmmsqld(11)=$lg(%mmmsqld(5),40) s d(68)=$$%0EmBs2(%mmmsqld(11)) s d(69)=$lg(%mmmsqld(5),22) s d(70)=$lg(%mmmsqld(5),32) s d(72)=$lg(%mmmsqld(5),55) s d(73)=$lg(%mmmsqld(5),23) s d(75)=$lg(%mmmsqld(5),33) s d(77)=$lg(%mmmsqld(5),59) s d(78)=$lg(%mmmsqld(5),63) s d(81)=$lg(%mmmsqld(5),27) s %mmmsqld(12)=$lg(%mmmsqld(5),26) s d(82)=%mmmsqld(12) s d(84)=$lg(%mmmsqld(5),43) s d(87)=$lg(%mmmsqld(5),48) s d(89)=$lg(%mmmsqld(5),61) s d(90)=$lg(%mmmsqld(5),62) s d(91)=$lg(%mmmsqld(5),45) s d(92)=$lg(%mmmsqld(5),47) s d(93)=$lg(%mmmsqld(5),65) s d(94)=$lg(%mmmsqld(5),46) s d(95)=$lg(%mmmsqld(5),28)
 s d(96)=$lg(%mmmsqld(5),60) s %mmmsqld(13)=$lg(%mmmsqld(5),29) s d(97)=$$%0EmBs1(%mmmsqld(13)) s d(98)=$lg(%mmmsqld(5),56) s %mmmsqld(14)=$lg(%mmmsqld(5),30) s d(99)=$$%0EmBs2(%mmmsqld(14)) s d(107)=$lg(%mmmsqld(5),31) s d(110)=$lg(%mmmsqld(5),1) s d(111)=$lg($lg(%mmmsqld(5),26),1) s d(112)=$lg($lg(%mmmsqld(5),26),2) s d(113)=$lg($lg(%mmmsqld(5),26),3) s d(114)=$lg($lg(%mmmsqld(5),26),4) s d(115)=$lg($lg(%mmmsqld(5),26),5) s d(116)=##class(BEDD.EDInjury).AtFaultOtherOid($lg($lg(%mmmsqld(5),26),6)) s d(117)=##class(BEDD.EDInjury).BusOffcOid($lg($lg(%mmmsqld(5),26),8)) s d(118)=$lg($lg(%mmmsqld(5),26),9) s d(119)=$lg($lg(%mmmsqld(5),26),10) s d(120)=$lg($lg(%mmmsqld(5),26),11) s d(121)=$lg($lg(%mmmsqld(5),26),12) s d(122)=$lg($lg(%mmmsqld(5),26),13) s d(123)=$lg($lg(%mmmsqld(5),26),14) s d(124)=$lg($lg(%mmmsqld(5),26),20) s d(125)=$lg($lg(%mmmsqld(5),26),26) s %mmmsqld(15)=$lg($lg(%mmmsqld(5),26),16) s d(126)=$$%0EmBs1(%mmmsqld(15)) s d(127)=$lg($lg(%mmmsqld(5),26),24)
 s d(128)=$lg($lg(%mmmsqld(5),26),15) s d(129)=$lg($lg(%mmmsqld(5),26),21) s %mmmsqld(16)=$lg($lg(%mmmsqld(5),26),17) s d(130)=$$%0EmBs2(%mmmsqld(16)) s d(131)=##class(BEDD.EDInjury).InjuryDetailsOid($lg($lg(%mmmsqld(5),26),7)) s d(132)=$lg($lg(%mmmsqld(5),26),25) s d(133)=$lg($lg(%mmmsqld(5),26),19) s d(134)=$lg($lg(%mmmsqld(5),26),23) s d(135)=$lg($lg(%mmmsqld(5),26),18) s d(136)=$lg($lg(%mmmsqld(5),26),22)
 d
 . Set %mmmsqld(17)=##class(BEDD.EDVISIT).GetAdPvDtm(d(2),d(81))
 s d(3)=$$%0EmBs1(%mmmsqld(17)) d
 . Set d(4)=##class(BEDD.EDVISIT).GetAdmPrv(d(2),d(81)) 
 d
 . Set d(5)=##class(BEDD.EDVISIT).GetProvN(d(4)) 
 d
 . Set d(6)=##class(BEDD.EDVISIT).GetAge(d(2),d(81))
 d
 . Set d(7)=##class(BEDD.EDVISIT).GetAM(d(81),d(2))
 d
 . Set d(10)=##class(BEDD.EDVISIT).GetProvN(d(9)) 
 d
 . Set d(12)=##class(BEDD.EDVISIT).GetProvN(d(11)) 
 d
 . Set %mmmsqld(18)=##class(BEDD.EDVISIT).GetCIDt(d(2),d(81)) 
 s d(13)=$$%0EmBs1(%mmmsqld(18)) d
 . Set %mmmsqld(19)=##class(BEDD.EDVISIT).GetCITm(d(2),d(81)) 
 s d(14)=$$%0EmBs2(%mmmsqld(19)) d
 . Set d(15)=##class(BEDD.EDVISIT).GetChart(d(2),d(81)) 
 d
 . Set d(18) = ##class(BEDD.EDVISIT).GetPtComplaint(d(81),d(2))
 d
 . Set d(20)=##class(BEDD.EDVISIT).GetProvN(d(19)) 
 d
 . Set %mmmsqld(20)=##class(BEDD.EDVISIT).GetDCDt(d(2))
 s d(27)=$$%0EmBs1(%mmmsqld(20)) d
 . Set %mmmsqld(21)=##class(BEDD.EDVISIT).GetDCDtTm(d(2))
 s d(29)=$$%0EmBs1(%mmmsqld(21)) d
 . Set d(32)=##class(BEDD.EDVISIT).GetInstN(d(31)) 
 d
 . Set d(35)=##class(BEDD.EDVISIT).GetDCN(d(2),%mmmsqld(4))
 d
 . Set d(37)=##class(BEDD.EDVISIT).GetProvN(d(35)) 
 d
 . Set d(38)=##class(BEDD.EDVISIT).GetDCP(d(2)) 
 d
 . Set d(40)=##class(BEDD.EDVISIT).GetProvN(d(38)) 
 d
 . Set %mmmsqld(22)=##class(BEDD.EDVISIT).GetDCTm(d(2))
 s d(43)=$$%0EmBs2(%mmmsqld(22)) d
 . Set d(48)=##class(BEDD.EDVISIT).GetDOB(d(81))
 d
 . Set d(51)=##class(BEDD.EDVISIT).GetDisp(d(2))
 d
 . Set d(50)=##class(BEDD.EDVISIT).GetDispN(d(51))
 d
 . Set d(56)=##class(BEDD.EDVISIT).GetFinA(d(2))
 d
 . Set d(57)=##class(BEDD.EDVISIT).GetInd(%mmmsqld(4))
 d
 . Set d(59)=##class(BEDD.EDVISIT).GetInjC(%mmmsqld(4))
 d
 . Set d(60)=##class(BEDD.EDVISIT).GetInjS(%mmmsqld(4))
 d
 . Set d(62) = ##class(BEDD.EDVISIT).GetDecAdmit(%mmmsqld(4),d(49))
 d
 . Set d(65)=##class(BEDD.EDVISIT).GetOcc(%mmmsqld(4))
 d
 . Set d(71)=##class(BEDD.EDVISIT).GetPrimN(d(69))
 d
 . Set d(74)=##class(BEDD.EDVISIT).GetICDN(d(73))
 d
 . Set d(76)=##class(BEDD.EDVISIT).GetProvN(d(75)) 
 d
 . Set d(79)=##class(BEDD.EDVISIT).CmbDt(%mmmsqld(18),%mmmsqld(19))
 d
 . Set d(80)=##class(BEDD.EDVISIT).CmbDt(%mmmsqld(20),%mmmsqld(22))
 d
 . Set d(83)=##class(BEDD.EDVISIT).GetName(d(81))
 d
 . Set d(101)=##class(BEDD.EDVISIT).GetTrgA(d(2),d(81))
 d
 . Set d(85)=##class(BEDD.EDVISIT).GetPtStat(%mmmsqld(4),d(81),d(95),d(30),d(2),d(22),d(101))
 d
 . Set d(86)=##class(BEDD.EDVISIT).GetPtStatN(d(85))
 d
 . Set %mmmsqld(23)=##class(BEDD.EDVISIT).GetTrgDt(d(2),d(81))
 s d(103)=$$%0EmBs1(%mmmsqld(23)) d
 . Set %mmmsqld(24)=##class(BEDD.EDVISIT).GetTrgTm(d(2),d(81))
 s d(106)=$$%0EmBs2(%mmmsqld(24)) d
 . Set d(88)=##class(BEDD.EDVISIT).CmbDt(%mmmsqld(23),%mmmsqld(24))
 d
 . Set d(100)=##class(BEDD.EDVISIT).GetSex(d(81))
 d
 . Set d(102)=##class(BEDD.EDVISIT).GetTrgC(d(2),d(107)) 
 d
 . Set %mmmsqld(25)=##class(BEDD.EDVISIT).GetTrgDtTm(d(2),d(81))
 s d(104)=$$%0EmBs1(%mmmsqld(25)) d
 . Set d(105)=##class(BEDD.EDVISIT).GetTrgN(d(2),d(81)) 
 d
 . Set d(108)=##class(BEDD.EDVISIT).GetVD(d(2)) 
 d
 . Set d(109)=##class(BEDD.EDVISIT).GetWtg(%mmmsqld(4),d(85),%mmmsqld(18),%mmmsqld(19),%mmmsqld(23),%mmmsqld(24),d(63),d(64),d(89),d(90)) 
 g:$zu(115,2)=0 %0EmBuncommitted i $zu(115,2)=1 l +^BEDD.EDVISITD($p(%mmmsqld(4),"||",1))#"S":$zu(115,4) i $t { s %mmmsqld(1)=1,%mmmsqld(2)=$name(^BEDD.EDVISITD($p(%mmmsqld(4),"||",1)))_"#""SI""" } else { s SQLCODE=-114,%msg="Unable to acquire shared lock on table BEDD.EDVISIT for RowID value: "_%mmmsqld(4) ztrap "LOCK"  }
 ; asl MOD# 3
 i %mmmsqld(4)'="",$d(^BEDD.EDVISITD(%mmmsqld(4)))
 e  g %0EmCdun
 s d(1)=%mmmsqld(4)
 s %mmmsqld(26)=$g(^BEDD.EDVISITD(%mmmsqld(4))) s d(2)=$lg(%mmmsqld(26),2) s d(8)=$lg(%mmmsqld(26),3) s d(9)=$lg(%mmmsqld(26),4) s d(11)=$lg(%mmmsqld(26),5) s d(16)=$lg(%mmmsqld(26),41) s d(17)=$lg(%mmmsqld(26),6) s d(19)=$lg(%mmmsqld(26),11) s d(21)=$lg(%mmmsqld(26),12) s d(22)=$lg(%mmmsqld(26),42) s %mmmsqld(6)=$lg(%mmmsqld(26),53) s d(23)=$$%0EmBs1(%mmmsqld(6)) s %mmmsqld(7)=$lg(%mmmsqld(26),54) s d(24)=$$%0EmBs2(%mmmsqld(7)) s %mmmsqld(8)=$lg(%mmmsqld(26),51) s d(25)=$$%0EmBs1(%mmmsqld(8)) s %mmmsqld(9)=$lg(%mmmsqld(26),52) s d(26)=$$%0EmBs2(%mmmsqld(9)) s d(28)=$lg(%mmmsqld(26),7) s d(30)=$lg(%mmmsqld(26),17) s d(31)=$lg(%mmmsqld(26),13) s d(33)=$lg(%mmmsqld(26),36) s d(34)=$lg(%mmmsqld(26),37) s d(36)=$lg(%mmmsqld(26),9) s d(39)=$lg(%mmmsqld(26),10) s d(41)=$lg(%mmmsqld(26),15) s d(42)=$lg(%mmmsqld(26),16) s d(44)=$lg(%mmmsqld(26),8) s d(45)=$lg(%mmmsqld(26),14) s d(46)=$lg(%mmmsqld(26),34) s d(47)=$lg(%mmmsqld(26),35) s d(49)=$lg(%mmmsqld(26),64)
 s d(52)=$lg(%mmmsqld(26),18) s d(53)=$lg(%mmmsqld(26),21) s d(54)=$lg(%mmmsqld(26),19) s d(55)=$lg(%mmmsqld(26),20) s d(58)=##class(BEDD.EDVISIT).InfoOid($lg(%mmmsqld(26),24)) s d(61)=$lg(%mmmsqld(26),25) s d(63)=$lg(%mmmsqld(26),57) s d(64)=$lg(%mmmsqld(26),58) s d(66)=$lg(%mmmsqld(26),38) s %mmmsqld(10)=$lg(%mmmsqld(26),39) s d(67)=$$%0EmBs1(%mmmsqld(10)) s %mmmsqld(11)=$lg(%mmmsqld(26),40) s d(68)=$$%0EmBs2(%mmmsqld(11)) s d(69)=$lg(%mmmsqld(26),22) s d(70)=$lg(%mmmsqld(26),32) s d(72)=$lg(%mmmsqld(26),55) s d(73)=$lg(%mmmsqld(26),23) s d(75)=$lg(%mmmsqld(26),33) s d(77)=$lg(%mmmsqld(26),59) s d(78)=$lg(%mmmsqld(26),63) s d(81)=$lg(%mmmsqld(26),27) s %mmmsqld(12)=$lg(%mmmsqld(26),26) s d(82)=%mmmsqld(12) s d(84)=$lg(%mmmsqld(26),43) s d(87)=$lg(%mmmsqld(26),48) s d(89)=$lg(%mmmsqld(26),61) s d(90)=$lg(%mmmsqld(26),62) s d(91)=$lg(%mmmsqld(26),45) s d(92)=$lg(%mmmsqld(26),47) s d(93)=$lg(%mmmsqld(26),65) s d(94)=$lg(%mmmsqld(26),46) s d(95)=$lg(%mmmsqld(26),28)
 s d(96)=$lg(%mmmsqld(26),60) s %mmmsqld(13)=$lg(%mmmsqld(26),29) s d(97)=$$%0EmBs1(%mmmsqld(13)) s d(98)=$lg(%mmmsqld(26),56) s %mmmsqld(14)=$lg(%mmmsqld(26),30) s d(99)=$$%0EmBs2(%mmmsqld(14)) s d(107)=$lg(%mmmsqld(26),31) s d(110)=$lg(%mmmsqld(26),1) s d(111)=$lg($lg(%mmmsqld(26),26),1) s d(112)=$lg($lg(%mmmsqld(26),26),2) s d(113)=$lg($lg(%mmmsqld(26),26),3) s d(114)=$lg($lg(%mmmsqld(26),26),4) s d(115)=$lg($lg(%mmmsqld(26),26),5) s d(116)=##class(BEDD.EDInjury).AtFaultOtherOid($lg($lg(%mmmsqld(26),26),6)) s d(117)=##class(BEDD.EDInjury).BusOffcOid($lg($lg(%mmmsqld(26),26),8)) s d(118)=$lg($lg(%mmmsqld(26),26),9) s d(119)=$lg($lg(%mmmsqld(26),26),10) s d(120)=$lg($lg(%mmmsqld(26),26),11) s d(121)=$lg($lg(%mmmsqld(26),26),12) s d(122)=$lg($lg(%mmmsqld(26),26),13) s d(123)=$lg($lg(%mmmsqld(26),26),14) s d(124)=$lg($lg(%mmmsqld(26),26),20) s d(125)=$lg($lg(%mmmsqld(26),26),26) s %mmmsqld(15)=$lg($lg(%mmmsqld(26),26),16) s d(126)=$$%0EmBs1(%mmmsqld(15)) s d(127)=$lg($lg(%mmmsqld(26),26),24)
 s d(128)=$lg($lg(%mmmsqld(26),26),15) s d(129)=$lg($lg(%mmmsqld(26),26),21) s %mmmsqld(16)=$lg($lg(%mmmsqld(26),26),17) s d(130)=$$%0EmBs2(%mmmsqld(16)) s d(131)=##class(BEDD.EDInjury).InjuryDetailsOid($lg($lg(%mmmsqld(26),26),7)) s d(132)=$lg($lg(%mmmsqld(26),26),25) s d(133)=$lg($lg(%mmmsqld(26),26),19) s d(134)=$lg($lg(%mmmsqld(26),26),23) s d(135)=$lg($lg(%mmmsqld(26),26),18) s d(136)=$lg($lg(%mmmsqld(26),26),22)
 d
 . Set %mmmsqld(17)=##class(BEDD.EDVISIT).GetAdPvDtm(d(2),d(81))
 s d(3)=$$%0EmBs1(%mmmsqld(17)) d
 . Set d(4)=##class(BEDD.EDVISIT).GetAdmPrv(d(2),d(81)) 
 d
 . Set d(5)=##class(BEDD.EDVISIT).GetProvN(d(4)) 
 d
 . Set d(6)=##class(BEDD.EDVISIT).GetAge(d(2),d(81))
 d
 . Set d(7)=##class(BEDD.EDVISIT).GetAM(d(81),d(2))
 d
 . Set d(10)=##class(BEDD.EDVISIT).GetProvN(d(9)) 
 d
 . Set d(12)=##class(BEDD.EDVISIT).GetProvN(d(11)) 
 d
 . Set %mmmsqld(18)=##class(BEDD.EDVISIT).GetCIDt(d(2),d(81)) 
 s d(13)=$$%0EmBs1(%mmmsqld(18)) d
 . Set %mmmsqld(19)=##class(BEDD.EDVISIT).GetCITm(d(2),d(81)) 
 s d(14)=$$%0EmBs2(%mmmsqld(19)) d
 . Set d(15)=##class(BEDD.EDVISIT).GetChart(d(2),d(81)) 
 d
 . Set d(18) = ##class(BEDD.EDVISIT).GetPtComplaint(d(81),d(2))
 d
 . Set d(20)=##class(BEDD.EDVISIT).GetProvN(d(19)) 
 d
 . Set %mmmsqld(20)=##class(BEDD.EDVISIT).GetDCDt(d(2))
 s d(27)=$$%0EmBs1(%mmmsqld(20)) d
 . Set %mmmsqld(21)=##class(BEDD.EDVISIT).GetDCDtTm(d(2))
 s d(29)=$$%0EmBs1(%mmmsqld(21)) d
 . Set d(32)=##class(BEDD.EDVISIT).GetInstN(d(31)) 
 d
 . Set d(35)=##class(BEDD.EDVISIT).GetDCN(d(2),%mmmsqld(4))
 d
 . Set d(37)=##class(BEDD.EDVISIT).GetProvN(d(35)) 
 d
 . Set d(38)=##class(BEDD.EDVISIT).GetDCP(d(2)) 
 d
 . Set d(40)=##class(BEDD.EDVISIT).GetProvN(d(38)) 
 d
 . Set %mmmsqld(22)=##class(BEDD.EDVISIT).GetDCTm(d(2))
 s d(43)=$$%0EmBs2(%mmmsqld(22)) d
 . Set d(48)=##class(BEDD.EDVISIT).GetDOB(d(81))
 d
 . Set d(51)=##class(BEDD.EDVISIT).GetDisp(d(2))
 d
 . Set d(50)=##class(BEDD.EDVISIT).GetDispN(d(51))
 d
 . Set d(56)=##class(BEDD.EDVISIT).GetFinA(d(2))
 d
 . Set d(57)=##class(BEDD.EDVISIT).GetInd(%mmmsqld(4))
 d
 . Set d(59)=##class(BEDD.EDVISIT).GetInjC(%mmmsqld(4))
 d
 . Set d(60)=##class(BEDD.EDVISIT).GetInjS(%mmmsqld(4))
 d
 . Set d(62) = ##class(BEDD.EDVISIT).GetDecAdmit(%mmmsqld(4),d(49))
 d
 . Set d(65)=##class(BEDD.EDVISIT).GetOcc(%mmmsqld(4))
 d
 . Set d(71)=##class(BEDD.EDVISIT).GetPrimN(d(69))
 d
 . Set d(74)=##class(BEDD.EDVISIT).GetICDN(d(73))
 d
 . Set d(76)=##class(BEDD.EDVISIT).GetProvN(d(75)) 
 d
 . Set d(79)=##class(BEDD.EDVISIT).CmbDt(%mmmsqld(18),%mmmsqld(19))
 d
 . Set d(80)=##class(BEDD.EDVISIT).CmbDt(%mmmsqld(20),%mmmsqld(22))
 d
 . Set d(83)=##class(BEDD.EDVISIT).GetName(d(81))
 d
 . Set d(101)=##class(BEDD.EDVISIT).GetTrgA(d(2),d(81))
 d
 . Set d(85)=##class(BEDD.EDVISIT).GetPtStat(%mmmsqld(4),d(81),d(95),d(30),d(2),d(22),d(101))
 d
 . Set d(86)=##class(BEDD.EDVISIT).GetPtStatN(d(85))
 d
 . Set %mmmsqld(23)=##class(BEDD.EDVISIT).GetTrgDt(d(2),d(81))
 s d(103)=$$%0EmBs1(%mmmsqld(23)) d
 . Set %mmmsqld(24)=##class(BEDD.EDVISIT).GetTrgTm(d(2),d(81))
 s d(106)=$$%0EmBs2(%mmmsqld(24)) d
 . Set d(88)=##class(BEDD.EDVISIT).CmbDt(%mmmsqld(23),%mmmsqld(24))
 d
 . Set d(100)=##class(BEDD.EDVISIT).GetSex(d(81))
 d
 . Set d(102)=##class(BEDD.EDVISIT).GetTrgC(d(2),d(107)) 
 d
 . Set %mmmsqld(25)=##class(BEDD.EDVISIT).GetTrgDtTm(d(2),d(81))
 s d(104)=$$%0EmBs1(%mmmsqld(25)) d
 . Set d(105)=##class(BEDD.EDVISIT).GetTrgN(d(2),d(81)) 
 d
 . Set d(108)=##class(BEDD.EDVISIT).GetVD(d(2)) 
 d
 . Set d(109)=##class(BEDD.EDVISIT).GetWtg(%mmmsqld(4),d(85),%mmmsqld(18),%mmmsqld(19),%mmmsqld(23),%mmmsqld(24),d(63),d(64),d(89),d(90)) 
%0EmBuncommitted ;
 s d(1)=%mmmsqld(4)
 s d(82)=%mmmsqld(12)
 s SQLCODE=0 g %0Ec
%0EmCdun if $zu(115,2)=1 { if $g(%mmmsqld(1))=1 { l -@%mmmsqld(2) s %mmmsqld(1)=0 } elseif $g(%mmmsqld(1))=2 { do $classmethod($li(%mmmsqld(2)),"%UnlockId",$li(%mmmsqld(2),2),1,1)  s %mmmsqld(1)=0 } }
%0EmBdun 
%0EmAdun 
%0Ec s %ROWCOUNT='SQLCODE
 if $zu(115,2)=1 { if $g(%mmmsqld(1))=1 { l -@%mmmsqld(2) } elseif $g(%mmmsqld(1))=2 { do $classmethod($li(%mmmsqld(2)),"%UnlockId",$li(%mmmsqld(2),2),1,1)  } }
 q
%0Eerr s $zt="" d SQLRunTimeError^%apiSQL($ze,.SQLCODE,.%msg)
 g %0Ec
%SQLQuickLogicalToOdbc(%d)
	set:$g(%d(82))'="" %d(82)=$$LogicalToOdbcField82(%d(82))
	for %f=3,13,23,25,27,29,67,97,103,104,126 { set:$g(%d(%f))'="" %d(%f)=$select(%d(%f)="":"",%d(%f)'["-":$zdate(%d(%f),3),1:%d(%f)) }
	for %f=14,24,26,43,68,99,106,130 { set:$g(%d(%f))'="" %d(%f)=$select(%d(%f)="":"",1:$ztime(%d(%f))) }
	QUIT
LogicalToOdbcField82(val="") ;
	Set odbc=$listget(val,1)_","_$listget(val,2)_","_$listget(val,3)_","_$listget(val,4)_","_$listget(val,5)_","_$listget(val,6)_","_$listget(val,7)_","_$listget(val,8)_","_$listget(val,9)_","_$listget(val,10)_","_$listget(val,11)_","_$listget(val,12)_","_$listget(val,13)_","_$listget(val,14)_","_$listget(val,15)_","_$listget(val,16)_","_$listget(val,17)_","_$listget(val,18)_","_$listget(val,19)_","_$listget(val,20)_","_$listget(val,21)_","_$listget(val,22)_","_$listget(val,23)_","_$listget(val,24)
	Set odbc=odbc_$listget(val,25)_","_$listget(val,26)
	Quit odbc
%SQLQuickOdbcToLogical(%d)
	set:$g(%d(103))'="" %d(103)=$$OdbcToLogicalField103(%d(103))
	set:$g(%d(104))'="" %d(104)=$$OdbcToLogicalField104(%d(104))
	set:$g(%d(106))'="" %d(106)=$$OdbcToLogicalField106(%d(106))
	set:$g(%d(126))'="" %d(126)=$$OdbcToLogicalField126(%d(126))
	set:$g(%d(13))'="" %d(13)=$$OdbcToLogicalField13(%d(13))
	set:$g(%d(130))'="" %d(130)=$$OdbcToLogicalField130(%d(130))
	set:$g(%d(14))'="" %d(14)=$$OdbcToLogicalField14(%d(14))
	set:$g(%d(23))'="" %d(23)=$$OdbcToLogicalField23(%d(23))
	set:$g(%d(24))'="" %d(24)=$$OdbcToLogicalField24(%d(24))
	set:$g(%d(25))'="" %d(25)=$$OdbcToLogicalField25(%d(25))
	set:$g(%d(26))'="" %d(26)=$$OdbcToLogicalField26(%d(26))
	set:$g(%d(27))'="" %d(27)=$$OdbcToLogicalField27(%d(27))
	set:$g(%d(29))'="" %d(29)=$$OdbcToLogicalField29(%d(29))
	set:$g(%d(3))'="" %d(3)=$$OdbcToLogicalField3(%d(3))
	set:$g(%d(43))'="" %d(43)=$$OdbcToLogicalField43(%d(43))
	set:$g(%d(67))'="" %d(67)=$$OdbcToLogicalField67(%d(67))
	set:$g(%d(68))'="" %d(68)=$$OdbcToLogicalField68(%d(68))
	set:$g(%d(82))'="" %d(82)=$$OdbcToLogicalField82(%d(82))
	set:$g(%d(97))'="" %d(97)=$$OdbcToLogicalField97(%d(97))
	set:$g(%d(99))'="" %d(99)=$$OdbcToLogicalField99(%d(99))
	QUIT
OdbcToLogicalField3(%val="") ;
 quit:%val=""||($zu(115,13)&&(%val=$c(0))) "" set %val=$zdh(%val,3,,,,,,,"Error: '"_%val_"' is an invalid ODBC/JDBC Date value") q:%val||(%val=0) %val s %msg=%val ZTRAP "ODAT"
OdbcToLogicalField13(%val="") ;
 quit:%val=""||($zu(115,13)&&(%val=$c(0))) "" set %val=$zdh(%val,3,,,,,,,"Error: '"_%val_"' is an invalid ODBC/JDBC Date value") q:%val||(%val=0) %val s %msg=%val ZTRAP "ODAT"
OdbcToLogicalField14(%val="") ;
 quit:%val=""||($zu(115,13)&&(%val=$c(0))) "" s %val=$ztimeh(%val,,"Error: '"_%val_"' is an invalid ODBC/JDBC Time value") q:%val||(%val=0) %val s %msg=%val ZTRAP "OTIM"
OdbcToLogicalField23(%val="") ;
 quit:%val=""||($zu(115,13)&&(%val=$c(0))) "" set %val=$zdh(%val,3,,,,,,,"Error: '"_%val_"' is an invalid ODBC/JDBC Date value") q:%val||(%val=0) %val s %msg=%val ZTRAP "ODAT"
OdbcToLogicalField24(%val="") ;
 quit:%val=""||($zu(115,13)&&(%val=$c(0))) "" s %val=$ztimeh(%val,,"Error: '"_%val_"' is an invalid ODBC/JDBC Time value") q:%val||(%val=0) %val s %msg=%val ZTRAP "OTIM"
OdbcToLogicalField25(%val="") ;
 quit:%val=""||($zu(115,13)&&(%val=$c(0))) "" set %val=$zdh(%val,3,,,,,,,"Error: '"_%val_"' is an invalid ODBC/JDBC Date value") q:%val||(%val=0) %val s %msg=%val ZTRAP "ODAT"
OdbcToLogicalField26(%val="") ;
 quit:%val=""||($zu(115,13)&&(%val=$c(0))) "" s %val=$ztimeh(%val,,"Error: '"_%val_"' is an invalid ODBC/JDBC Time value") q:%val||(%val=0) %val s %msg=%val ZTRAP "OTIM"
OdbcToLogicalField27(%val="") ;
 quit:%val=""||($zu(115,13)&&(%val=$c(0))) "" set %val=$zdh(%val,3,,,,,,,"Error: '"_%val_"' is an invalid ODBC/JDBC Date value") q:%val||(%val=0) %val s %msg=%val ZTRAP "ODAT"
OdbcToLogicalField29(%val="") ;
 quit:%val=""||($zu(115,13)&&(%val=$c(0))) "" set %val=$zdh(%val,3,,,,,,,"Error: '"_%val_"' is an invalid ODBC/JDBC Date value") q:%val||(%val=0) %val s %msg=%val ZTRAP "ODAT"
OdbcToLogicalField43(%val="") ;
 quit:%val=""||($zu(115,13)&&(%val=$c(0))) "" s %val=$ztimeh(%val,,"Error: '"_%val_"' is an invalid ODBC/JDBC Time value") q:%val||(%val=0) %val s %msg=%val ZTRAP "OTIM"
OdbcToLogicalField67(%val="") ;
 quit:%val=""||($zu(115,13)&&(%val=$c(0))) "" set %val=$zdh(%val,3,,,,,,,"Error: '"_%val_"' is an invalid ODBC/JDBC Date value") q:%val||(%val=0) %val s %msg=%val ZTRAP "ODAT"
OdbcToLogicalField68(%val="") ;
 quit:%val=""||($zu(115,13)&&(%val=$c(0))) "" s %val=$ztimeh(%val,,"Error: '"_%val_"' is an invalid ODBC/JDBC Time value") q:%val||(%val=0) %val s %msg=%val ZTRAP "OTIM"
OdbcToLogicalField82(val="") ;
	Quit $lb($piece(val,",",1),$piece(val,",",2),$piece(val,",",3),$piece(val,",",4),$piece(val,",",5),$piece(val,",",6),$piece(val,",",7),$piece(val,",",8),$piece(val,",",9),$piece(val,",",10),$piece(val,",",11),$piece(val,",",12),$piece(val,",",13),$piece(val,",",14),$piece(val,",",15),$piece(val,",",16),$piece(val,",",17),$piece(val,",",18),$piece(val,",",19),$piece(val,",",20),$piece(val,",",21),$piece(val,",",22),$piece(val,",",23),$piece(val,",",24),$piece(val,",",25),$piece(val,",",26))
OdbcToLogicalField97(%val="") ;
 quit:%val=""||($zu(115,13)&&(%val=$c(0))) "" set %val=$zdh(%val,3,,,,,,,"Error: '"_%val_"' is an invalid ODBC/JDBC Date value") q:%val||(%val=0) %val s %msg=%val ZTRAP "ODAT"
OdbcToLogicalField99(%val="") ;
 quit:%val=""||($zu(115,13)&&(%val=$c(0))) "" s %val=$ztimeh(%val,,"Error: '"_%val_"' is an invalid ODBC/JDBC Time value") q:%val||(%val=0) %val s %msg=%val ZTRAP "OTIM"
OdbcToLogicalField103(%val="") ;
 quit:%val=""||($zu(115,13)&&(%val=$c(0))) "" set %val=$zdh(%val,3,,,,,,,"Error: '"_%val_"' is an invalid ODBC/JDBC Date value") q:%val||(%val=0) %val s %msg=%val ZTRAP "ODAT"
OdbcToLogicalField104(%val="") ;
 quit:%val=""||($zu(115,13)&&(%val=$c(0))) "" set %val=$zdh(%val,3,,,,,,,"Error: '"_%val_"' is an invalid ODBC/JDBC Date value") q:%val||(%val=0) %val s %msg=%val ZTRAP "ODAT"
OdbcToLogicalField106(%val="") ;
 quit:%val=""||($zu(115,13)&&(%val=$c(0))) "" s %val=$ztimeh(%val,,"Error: '"_%val_"' is an invalid ODBC/JDBC Time value") q:%val||(%val=0) %val s %msg=%val ZTRAP "OTIM"
OdbcToLogicalField126(%val="") ;
 quit:%val=""||($zu(115,13)&&(%val=$c(0))) "" set %val=$zdh(%val,3,,,,,,,"Error: '"_%val_"' is an invalid ODBC/JDBC Date value") q:%val||(%val=0) %val s %msg=%val ZTRAP "ODAT"
OdbcToLogicalField130(%val="") ;
 quit:%val=""||($zu(115,13)&&(%val=$c(0))) "" s %val=$ztimeh(%val,,"Error: '"_%val_"' is an invalid ODBC/JDBC Time value") q:%val||(%val=0) %val s %msg=%val ZTRAP "OTIM"
	Quit
%SQLQuickUpdate(%rowid,d,%nolock=0,pkey=0)
	// Update row with SQLRowID=%rowid with values d(icol)
	set:%nolock=2 %nolock=0
	do ..%SQLQuickOdbcToLogical(.d)
	do ..%SQLUpdate(%rowid,$c(0,%nolock=1,0,0,0,0),.d) set %ROWCOUNT='SQLCODE set:SQLCODE=100 SQLCODE=0 set %qrc=SQLCODE kill d QUIT
%SQLReleaseLock(%rowid,s=0,i=0)
	new %d set %d(1)=%rowid set s=$e("S",s)_$e("I",i) lock -^BEDD.EDVISITD(%d(1))#s set:i&&($g(%0CacheLock("BEDD.EDVISIT"))) %0CacheLock("BEDD.EDVISIT")=%0CacheLock("BEDD.EDVISIT")-1 QUIT
%SQLReleaseTableLock(s=0,i=0)
	set s=$e("S",s)_$e("I",i) lock -^BEDD.EDVISITD#s QUIT 1
	Quit
%SQLUnlock()
	do:$g(SQLCODE)<0&&(%oper="UPDATE") ..%SQLDeleteTempStreams()
	lock:$a(%l) -^BEDD.EDVISITD(%d(1))
	QUIT
%SQLUnlockError(cname)
	set sqlcode=-110 if %oper="DELETE" { set %msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler48",,"BEDD"_"."_"EDVISIT",cname) } else { set %msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler49",,"BEDD"_"."_"EDVISIT",cname) } quit
	Quit
%SQLUpdate(%rowid,%check,%d,%vco,%tstart=1,%mv=0,%polymorphic=0)
	new %e,bva,%ele,%itm,%key,%l,%n,%nc,%oper,%pos,%s,icol,s,sn,sqlcode,subs,t set %oper="UPDATE",sqlcode=0,%ROWID=%rowid,$e(%e,1)=$c(0),%l=$c(0,0,0) if '$a(%check),'..%SQLValidateFields(.sqlcode) set SQLCODE=sqlcode QUIT
	do ..%SQLNormalizeFields() if $d(%d(1)),%d(1)'=%rowid set SQLCODE=-107,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler16",,"ID","BEDD"_"."_"EDVISIT") QUIT
	for icol=2:1:136 set $e(%e,icol)=$c($d(%d(icol)))
	set %d(1)=%rowid,%e(1)=%rowid
	k:'$TLEVEL %0CacheLock if '$a(%check,2) { new %ls if $i(%0CacheLock("BEDD.EDVISIT"))>$zu(115,6) { lock +^BEDD.EDVISITD:$zu(115,4) lock:$t -^BEDD.EDVISITD set %ls=$s($t:2,1:0) } else { lock +^BEDD.EDVISITD(%d(1)):$zu(115,4) set %ls=$t } set:%ls=2 $e(%check,2)=$c(1) set:%ls=1 $e(%l)=$c(1) if '%ls set SQLCODE=-110,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler40",,%oper,"BEDD"_"."_"EDVISIT",$g(%d(1))) QUIT  } if %tstart { TSTART:($zu(115,1)=1)||('$TLEVEL&&($zu(115,1)=2))  } set $zt="ERRORUpdate"
	if $g(%vco)="" { do ..%SQLGetOld() i sqlcode { s SQLCODE=-109 do ..%SQLEExit() QUIT  } for icol=110,58,116,117,131,107,13,2,81,28,27,84,95,30,22,101,111,82,112,113,114,115,118,119,120,121,122,123,124,125,126,127,128,129,130,132,133,134,135,136 { set:'$d(%d(icol)) %d(icol)=%e(icol) set:%d(icol)=%e(icol) $e(%e,icol)=$c(0) }} else { do ..%SQLGetOldAll() if sqlcode { set SQLCODE=-109 do ..%SQLEExit() QUIT  } for icol=2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136 { set:'$d(%d(icol)) %d(icol)=%e(icol) set:%d(icol)=%e(icol) $e(%e,icol)=$c(0) }}
	if %e(110)'="" set sn=$p(%e(110),$e(%e(110)),$l(%e(110),$e(%e(110)))-1) if "BEDD.EDVISIT"'=sn new %f do ..%SQLCopyIcolIntoName() do $classmethod(sn,"%SQLUpdate",%rowid,%check,.%d,$g(%vco),%tstart,%mv,1) QUIT
	do ..%SQLUpdateComputes()
	do:'$a(%check)  if sqlcode set SQLCODE=sqlcode do ..%SQLEExit() QUIT
	. if $g(%vco)'="" do ..%SQLInsertComputes(1) d @%vco quit:sqlcode<0
	if '$a(%check,3) { 
	}
	if '$a(%check,5),'$a(%check,6) { new %rc,%stream,%ts
		i $a(%e,58) { i %d(58)'=-1,%d(58)'="" { s %stream=##class(%Stream.Object).%Open(%e(58)) i %stream="" { s %stream=##class(BEDD.EDVISIT).InfoOpen("") } i %stream="" { s SQLCODE=-412,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler22",,"BEDD"_"."_"EDVISIT","Info") do ..%SQLEExit() QUIT  } s %ts="" if $isobject(%d(58)) { s %ts=%d(58) } elseif (%d(58)?1.n1"@"1.e) { try { if $zobjref(%d(58))'="" { s %ts=$zobjref(%d(58)) }} catch { if $ze["<INVALID OREF>" { s $ze="" } else { GOTO ERRORUpdate }}} elseif $ListValid(%d(58)) { s %ts=##class(%Stream.Object).%Open(%d(58)) } if %ts'="" { s %rc=%stream.CopyFromAndSave(%ts) k %ts i '%rc { s SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) s:%msg %msg=%msg(1) k %stream do ..%SQLEExit() QUIT  } } else { s:%d(58)=$c(0) %d(58)="" s %rc=%stream.Write(%d(58)) i '%rc { k %stream s SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) s:%msg %msg=%msg(1) s %msg=$g(%msg)_"  "_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler24",,"BEDD"_"."_"EDVISIT","Info") do ..%SQLEExit() QUIT  } s %rc=%stream.%Save() i '%rc { k %stream s SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) s:%msg %msg=%msg(1) s %msg=$g(%msg)_"  "_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler23",,"BEDD"_"."_"EDVISIT","Info")_": '"_$e(%d(58),1,50)_"'" do ..%SQLEExit() QUIT  } } } else { i $g(%e(58))'="" { s %rc=##class(%Stream.Object).%Delete(%e(58)) i '%rc { s SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) s:%msg %msg=%msg(1) do ..%SQLEExit() QUIT  } } s %stream=##class(BEDD.EDVISIT).InfoOpen("") i %stream="" { s SQLCODE=-412,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler22",,"BEDD"_"."_"EDVISIT","Info") do ..%SQLEExit() QUIT  } s %rc=%stream.%Save() i '%rc { s SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) s:%msg %msg=%msg(1) s %msg=$g(%msg)_"  "_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler23",,"BEDD"_"."_"EDVISIT","Info")_": '"_%d(58)_"'" do ..%SQLEExit() QUIT  } } s %d(58)=%stream.%Oid() k %stream  s %d(58)=$li(%d(58),1,2) }
		i $a(%e,116) { i %d(116)'=-1,%d(116)'="" { s %stream=##class(%Stream.Object).%Open(%e(116)) i %stream="" { s %stream=##class(BEDD.EDInjury).AtFaultOtherOpen("") } i %stream="" { s SQLCODE=-412,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler22",,"BEDD"_"."_"EDVISIT","PtInjury_AtFaultOther") do ..%SQLEExit() QUIT  } s %ts="" if $isobject(%d(116)) { s %ts=%d(116) } elseif (%d(116)?1.n1"@"1.e) { try { if $zobjref(%d(116))'="" { s %ts=$zobjref(%d(116)) }} catch { if $ze["<INVALID OREF>" { s $ze="" } else { GOTO ERRORUpdate }}} elseif $ListValid(%d(116)) { s %ts=##class(%Stream.Object).%Open(%d(116)) } if %ts'="" { s %rc=%stream.CopyFromAndSave(%ts) k %ts i '%rc { s SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) s:%msg %msg=%msg(1) k %stream do ..%SQLEExit() QUIT  } } else { s:%d(116)=$c(0) %d(116)="" s %rc=%stream.Write(%d(116)) i '%rc { k %stream s SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) s:%msg %msg=%msg(1) s %msg=$g(%msg)_"  "_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler24",,"BEDD"_"."_"EDVISIT","PtInjury_AtFaultOther") do ..%SQLEExit() QUIT  } s %rc=%stream.%Save() i '%rc { k %stream s SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) s:%msg %msg=%msg(1) s %msg=$g(%msg)_"  "_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler23",,"BEDD"_"."_"EDVISIT","PtInjury_AtFaultOther")_": '"_$e(%d(116),1,50)_"'" do ..%SQLEExit() QUIT  } } } else { i $g(%e(116))'="" { s %rc=##class(%Stream.Object).%Delete(%e(116)) i '%rc { s SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) s:%msg %msg=%msg(1) do ..%SQLEExit() QUIT  } } s %stream=##class(BEDD.EDInjury).AtFaultOtherOpen("") i %stream="" { s SQLCODE=-412,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler22",,"BEDD"_"."_"EDVISIT","PtInjury_AtFaultOther") do ..%SQLEExit() QUIT  } s %rc=%stream.%Save() i '%rc { s SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) s:%msg %msg=%msg(1) s %msg=$g(%msg)_"  "_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler23",,"BEDD"_"."_"EDVISIT","PtInjury_AtFaultOther")_": '"_%d(116)_"'" do ..%SQLEExit() QUIT  } } s %d(116)=%stream.%Oid() k %stream  s %d(116)=$li(%d(116),1,2) }
		i $a(%e,117) { i %d(117)'=-1,%d(117)'="" { s %stream=##class(%Stream.Object).%Open(%e(117)) i %stream="" { s %stream=##class(BEDD.EDInjury).BusOffcOpen("") } i %stream="" { s SQLCODE=-412,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler22",,"BEDD"_"."_"EDVISIT","PtInjury_BusOffc") do ..%SQLEExit() QUIT  } s %ts="" if $isobject(%d(117)) { s %ts=%d(117) } elseif (%d(117)?1.n1"@"1.e) { try { if $zobjref(%d(117))'="" { s %ts=$zobjref(%d(117)) }} catch { if $ze["<INVALID OREF>" { s $ze="" } else { GOTO ERRORUpdate }}} elseif $ListValid(%d(117)) { s %ts=##class(%Stream.Object).%Open(%d(117)) } if %ts'="" { s %rc=%stream.CopyFromAndSave(%ts) k %ts i '%rc { s SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) s:%msg %msg=%msg(1) k %stream do ..%SQLEExit() QUIT  } } else { s:%d(117)=$c(0) %d(117)="" s %rc=%stream.Write(%d(117)) i '%rc { k %stream s SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) s:%msg %msg=%msg(1) s %msg=$g(%msg)_"  "_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler24",,"BEDD"_"."_"EDVISIT","PtInjury_BusOffc") do ..%SQLEExit() QUIT  } s %rc=%stream.%Save() i '%rc { k %stream s SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) s:%msg %msg=%msg(1) s %msg=$g(%msg)_"  "_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler23",,"BEDD"_"."_"EDVISIT","PtInjury_BusOffc")_": '"_$e(%d(117),1,50)_"'" do ..%SQLEExit() QUIT  } } } else { i $g(%e(117))'="" { s %rc=##class(%Stream.Object).%Delete(%e(117)) i '%rc { s SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) s:%msg %msg=%msg(1) do ..%SQLEExit() QUIT  } } s %stream=##class(BEDD.EDInjury).BusOffcOpen("") i %stream="" { s SQLCODE=-412,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler22",,"BEDD"_"."_"EDVISIT","PtInjury_BusOffc") do ..%SQLEExit() QUIT  } s %rc=%stream.%Save() i '%rc { s SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) s:%msg %msg=%msg(1) s %msg=$g(%msg)_"  "_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler23",,"BEDD"_"."_"EDVISIT","PtInjury_BusOffc")_": '"_%d(117)_"'" do ..%SQLEExit() QUIT  } } s %d(117)=%stream.%Oid() k %stream  s %d(117)=$li(%d(117),1,2) }
		i $a(%e,131) { i %d(131)'=-1,%d(131)'="" { s %stream=##class(%Stream.Object).%Open(%e(131)) i %stream="" { s %stream=##class(BEDD.EDInjury).InjuryDetailsOpen("") } i %stream="" { s SQLCODE=-412,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler22",,"BEDD"_"."_"EDVISIT","PtInjury_InjuryDetails") do ..%SQLEExit() QUIT  } s %ts="" if $isobject(%d(131)) { s %ts=%d(131) } elseif (%d(131)?1.n1"@"1.e) { try { if $zobjref(%d(131))'="" { s %ts=$zobjref(%d(131)) }} catch { if $ze["<INVALID OREF>" { s $ze="" } else { GOTO ERRORUpdate }}} elseif $ListValid(%d(131)) { s %ts=##class(%Stream.Object).%Open(%d(131)) } if %ts'="" { s %rc=%stream.CopyFromAndSave(%ts) k %ts i '%rc { s SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) s:%msg %msg=%msg(1) k %stream do ..%SQLEExit() QUIT  } } else { s:%d(131)=$c(0) %d(131)="" s %rc=%stream.Write(%d(131)) i '%rc { k %stream s SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) s:%msg %msg=%msg(1) s %msg=$g(%msg)_"  "_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler24",,"BEDD"_"."_"EDVISIT","PtInjury_InjuryDetails") do ..%SQLEExit() QUIT  } s %rc=%stream.%Save() i '%rc { k %stream s SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) s:%msg %msg=%msg(1) s %msg=$g(%msg)_"  "_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler23",,"BEDD"_"."_"EDVISIT","PtInjury_InjuryDetails")_": '"_$e(%d(131),1,50)_"'" do ..%SQLEExit() QUIT  } } } else { i $g(%e(131))'="" { s %rc=##class(%Stream.Object).%Delete(%e(131)) i '%rc { s SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) s:%msg %msg=%msg(1) do ..%SQLEExit() QUIT  } } s %stream=##class(BEDD.EDInjury).InjuryDetailsOpen("") i %stream="" { s SQLCODE=-412,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler22",,"BEDD"_"."_"EDVISIT","PtInjury_InjuryDetails") do ..%SQLEExit() QUIT  } s %rc=%stream.%Save() i '%rc { s SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) s:%msg %msg=%msg(1) s %msg=$g(%msg)_"  "_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler23",,"BEDD"_"."_"EDVISIT","PtInjury_InjuryDetails")_": '"_%d(131)_"'" do ..%SQLEExit() QUIT  } } s %d(131)=%stream.%Oid() k %stream  s %d(131)=$li(%d(131),1,2) }
	}
	if $s($a(%e,2):1,$a(%e,8):1,$a(%e,9):1,$a(%e,11):1,$a(%e,16):1,$a(%e,17):1,$a(%e,19):1,$a(%e,21):1,$a(%e,22):1,$a(%e,23):1,$a(%e,24):1,$a(%e,25):1,$a(%e,26):1,$a(%e,28):1,$a(%e,30):1,$a(%e,31):1,$a(%e,33):1,$a(%e,34):1,$a(%e,36):1,$a(%e,39):1,$a(%e,41):1,$a(%e,42):1,$a(%e,44):1,$a(%e,45):1,$a(%e,46):1,$a(%e,47):1,$a(%e,49):1,$a(%e,52):1,$a(%e,53):1,$a(%e,54):1,$a(%e,55):1,$a(%e,58):1,$a(%e,61):1,$a(%e,63):1,$a(%e,64):1,$a(%e,66):1,$a(%e,67):1,$a(%e,68):1,$a(%e,69):1,$a(%e,70):1,$a(%e,72):1,$a(%e,73):1,$a(%e,75):1,$a(%e,77):1,$a(%e,78):1,$a(%e,81):1,$a(%e,84):1,$a(%e,87):1,$a(%e,89):1,$a(%e,90):1,$a(%e,91):1,$a(%e,92):1,$a(%e,93):1,$a(%e,94):1,$a(%e,95):1,$a(%e,96):1,$a(%e,97):1,$a(%e,98):1,$a(%e,99):1,$a(%e,107):1,$a(%e,110):1,$a(%e,111):1,$a(%e,112):1,$a(%e,113):1,$a(%e,114):1,$a(%e,115):1,$a(%e,116):1,$a(%e,117):1,$a(%e,118):1,$a(%e,119):1,$a(%e,120):1,$a(%e,121):1,$a(%e,122):1,$a(%e,123):1,$a(%e,124):1,$a(%e,125):1,$a(%e,126):1,$a(%e,127):1,$a(%e,128):1,$a(%e,129):1,$a(%e,130):1,$a(%e,131):1,$a(%e,132):1,$a(%e,133):1,$a(%e,134):1,$a(%e,135):1,1:$a(%e,136)) set s=$g(^BEDD.EDVISITD(%d(1))),t=$lb($s($a(%e,110):%d(110),1:$lg(s)),$s($a(%e,2):%d(2),1:$lg(s,2)),$s($a(%e,8):%d(8),1:$lg(s,3)),$s($a(%e,9):%d(9),1:$lg(s,4)),$s($a(%e,11):%d(11),1:$lg(s,5)),$s($a(%e,17):%d(17),1:$lg(s,6)),$s($a(%e,28):%d(28),1:$lg(s,7)),$s($a(%e,44):%d(44),1:$lg(s,8)),$s($a(%e,36):%d(36),1:$lg(s,9)),$s($a(%e,39):%d(39),1:$lg(s,10)),$s($a(%e,19):%d(19),1:$lg(s,11)),$s($a(%e,21):%d(21),1:$lg(s,12)),$s($a(%e,31):%d(31),1:$lg(s,13)),$s($a(%e,45):%d(45),1:$lg(s,14)),$s($a(%e,41):%d(41),1:$lg(s,15)),$s($a(%e,42):%d(42),1:$lg(s,16)),$s($a(%e,30):%d(30),1:$lg(s,17)),$s($a(%e,52):%d(52),1:$lg(s,18)),$s($a(%e,54):%d(54),1:$lg(s,19)),$s($a(%e,55):%d(55),1:$lg(s,20)),$s($a(%e,53):%d(53),1:$lg(s,21)),$s($a(%e,69):%d(69),1:$lg(s,22)),$s($a(%e,73):%d(73),1:$lg(s,23)),$s($a(%e,58):%d(58),1:$lg(s,24)),$s($a(%e,61):%d(61),1:$lg(s,25)),$lb($s($a(%e,111):%d(111),1:$lg($lg(s,26))),$s($a(%e,112):%d(112),1:$lg($lg(s,26),2)),$s($a(%e,113):%d(113),1:$lg($lg(s,26),3)),$s($a(%e,114):%d(114),1:$lg($lg(s,26),4)),$s($a(%e,115):%d(115),1:$lg($lg(s,26),5)),$s($a(%e,116):%d(116),1:$lg($lg(s,26),6)),$s($a(%e,131):%d(131),1:$lg($lg(s,26),7)),$s($a(%e,117):%d(117),1:$lg($lg(s,26),8)),$s($a(%e,118):%d(118),1:$lg($lg(s,26),9)),$s($a(%e,119):%d(119),1:$lg($lg(s,26),10)),$s($a(%e,120):%d(120),1:$lg($lg(s,26),11)),$s($a(%e,121):%d(121),1:$lg($lg(s,26),12)),$s($a(%e,122):%d(122),1:$lg($lg(s,26),13)),$s($a(%e,123):%d(123),1:$lg($lg(s,26),14)),$s($a(%e,128):%d(128),1:$lg($lg(s,26),15)),$s($a(%e,126):%d(126),1:$lg($lg(s,26),16)),$s($a(%e,130):%d(130),1:$lg($lg(s,26),17)),$s($a(%e,135):%d(135),1:$lg($lg(s,26),18)),$s($a(%e,133):%d(133),1:$lg($lg(s,26),19)),$s($a(%e,124):%d(124),1:$lg($lg(s,26),20)),$s($a(%e,129):%d(129),1:$lg($lg(s,26),21)),$s($a(%e,136):%d(136),1:$lg($lg(s,26),22)),$s($a(%e,134):%d(134),1:$lg($lg(s,26),23)),$s($a(%e,127):%d(127),1:$lg($lg(s,26),24)),$s($a(%e,132):%d(132),1:$lg($lg(s,26),25)),$s($a(%e,125):%d(125),1:$lg($lg(s,26),26))),$s($a(%e,81):%d(81),1:$lg(s,27)),$s($a(%e,95):%d(95),1:$lg(s,28)),$s($a(%e,97):%d(97),1:$lg(s,29)),$s($a(%e,99):%d(99),1:$lg(s,30)),$s($a(%e,107):%d(107),1:$lg(s,31)),$s($a(%e,70):%d(70),1:$lg(s,32)),$s($a(%e,75):%d(75),1:$lg(s,33)))
	if  set ^BEDD.EDVISITD(%d(1))=t_$lb($s($a(%e,46):%d(46),1:$lg(s,34)),$s($a(%e,47):%d(47),1:$lg(s,35)),$s($a(%e,33):%d(33),1:$lg(s,36)),$s($a(%e,34):%d(34),1:$lg(s,37)),$s($a(%e,66):%d(66),1:$lg(s,38)),$s($a(%e,67):%d(67),1:$lg(s,39)),$s($a(%e,68):%d(68),1:$lg(s,40)),$s($a(%e,16):%d(16),1:$lg(s,41)),$s($a(%e,22):%d(22),1:$lg(s,42)),$s($a(%e,84):%d(84),1:$lg(s,43)),,$s($a(%e,91):%d(91),1:$lg(s,45)),$s($a(%e,94):%d(94),1:$lg(s,46)),$s($a(%e,92):%d(92),1:$lg(s,47)),$s($a(%e,87):%d(87),1:$lg(s,48)),,,$s($a(%e,25):%d(25),1:$lg(s,51)),$s($a(%e,26):%d(26),1:$lg(s,52)),$s($a(%e,23):%d(23),1:$lg(s,53)),$s($a(%e,24):%d(24),1:$lg(s,54)),$s($a(%e,72):%d(72),1:$lg(s,55)),$s($a(%e,98):%d(98),1:$lg(s,56)),$s($a(%e,63):%d(63),1:$lg(s,57)),$s($a(%e,64):%d(64),1:$lg(s,58)),$s($a(%e,77):%d(77),1:$lg(s,59)),$s($a(%e,96):%d(96),1:$lg(s,60)),$s($a(%e,89):%d(89),1:$lg(s,61)),$s($a(%e,90):%d(90),1:$lg(s,62)),$s($a(%e,78):%d(78),1:$lg(s,63)),$s($a(%e,49):%d(49),1:$lg(s,64)),$s($a(%e,93):%d(93),1:$lg(s,65)))
	if '$a(%check,3) { 
		if $a(%e,107)||$a(%e,110) {	// ADIdx index map
			if $a(%e,107) { s sn(1)=%e(107) s:sn(1)="" sn(1)=-1E14 s sn(2)=%d(1) k ^BEDD.EDVISITI("ADIdx",sn(1),sn(2)) }
			s sn(1)=%d(107) s:sn(1)="" sn(1)=-1E14 s sn(2)=%d(1) s ^BEDD.EDVISITI("ADIdx",sn(1),sn(2))=%d(110)
		}
		if $a(%e,13)||$a(%e,110) {	// ArrIdx index map
			if $a(%e,13) { s sn(1)=%e(13) s:sn(1)="" sn(1)=-1E14 s sn(2)=%d(1) k ^BEDD.EDVISITI("ArrIdx",sn(1),sn(2)) }
			s sn(1)=%d(13) s:sn(1)="" sn(1)=-1E14 s sn(2)=%d(1) s ^BEDD.EDVISITI("ArrIdx",sn(1),sn(2))=$lb(%d(110),%d(13))
		}
		if $a(%e,13)||$a(%e,110) {	// CIDtIIdx index map
			if $a(%e,13) { s sn(1)=%e(13) s:sn(1)="" sn(1)=-1E14 s sn(2)=%d(1) k ^BEDD.EDVISITI("CIDtIIdx",sn(1),sn(2)) }
			s sn(1)=%d(13) s:sn(1)="" sn(1)=-1E14 s sn(2)=%d(1) s ^BEDD.EDVISITI("CIDtIIdx",sn(1),sn(2))=$lb(%d(110),%d(13))
		}
		if $a(%e,28)||$a(%e,110) {	// DCDTIdx index map
			if $a(%e,28) { s sn(1)=$zu(28,%e(28),7) s sn(2)=%d(1) k ^BEDD.EDVISITI("DCDTIdx",sn(1),sn(2)) }
			s sn(1)=$zu(28,%d(28),7) s sn(2)=%d(1) s ^BEDD.EDVISITI("DCDTIdx",sn(1),sn(2))=%d(110)
		}
		if $a(%e,27)||$a(%e,110) {	// DisIdx index map
			if $a(%e,27) { s sn(1)=%e(27) s:sn(1)="" sn(1)=-1E14 s sn(2)=%d(1) k ^BEDD.EDVISITI("DisIdx",sn(1),sn(2)) }
			s sn(1)=%d(27) s:sn(1)="" sn(1)=-1E14 s sn(2)=%d(1) s ^BEDD.EDVISITI("DisIdx",sn(1),sn(2))=%d(110)
		}
	}
	do ..%SQLUnlock() TCOMMIT:%tstart&&($zu(115,1)=1)
	set SQLCODE=0
	QUIT
ERRORUpdate	set $zt="",SQLCODE=-415,%msg=$s($g(%msg)'="":%msg_" -- ",1:"")_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler51",,%oper,"BEDD"_"."_"EDVISIT",$ze) if $ze["<FRAMESTACK>" { set %msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler52",,$ze,%oper,"BEDD"_"."_"EDVISIT") do ##Class(%SYS.System).WriteToConsoleLog(%msg) if ($zu(67,10,$j)=1)||($zu(67,10,$j)=3) { write !,%msg h 3 } HALT  } do ..%SQLEExit() QUIT  
	Quit
%SQLUpdateComputes(view=0)
	if $a(%e,82) do SQLComputeUpd116 set:%d(116)'=$g(%e(116)) $e(%e,116)=$c(1)
	if $a(%e,82) do SQLComputeUpd117 set:%d(117)'=$g(%e(117)) $e(%e,117)=$c(1)
	if $a(%e,82) do SQLComputeUpd131 set:%d(131)'=$g(%e(131)) $e(%e,131)=$c(1)
	if $s($a(%e,13):1,$a(%e,2):1,1:$a(%e,81)) do ..CIDtSQLCompute() set:%d(13)'=%e(13) $e(%e,13)=$c(1)
	if $s($a(%e,27):1,$a(%e,2):1,1:$a(%e,2)) do ..DCDtSQLCompute() set:%d(27)'=%e(27) $e(%e,27)=$c(1)
	if $s($a(%e,101):1,$a(%e,2):1,$a(%e,81):1,$a(%e,95):1,$a(%e,30):1,$a(%e,2):1,$a(%e,22):1,1:$a(%e,101)) do ..TrgASQLCompute() set:%d(101)'=%e(101) $e(%e,101)=$c(1)
	if '$a(%e,84),%e(84)=""||($s($a(%e,95):1,$a(%e,30):1,$a(%e,22):1,1:$a(%e,101))) do ..PtStatSQLCompute() set:%d(84)'=%e(84) $e(%e,84)=$c(1)
	if $a(%e,82) do SQLComputeUpd111 set:%d(111)'=$g(%e(111)) $e(%e,111)=$c(1)
	if $a(%e,82) do SQLComputeUpd112 set:%d(112)'=$g(%e(112)) $e(%e,112)=$c(1)
	if $a(%e,82) do SQLComputeUpd113 set:%d(113)'=$g(%e(113)) $e(%e,113)=$c(1)
	if $a(%e,82) do SQLComputeUpd114 set:%d(114)'=$g(%e(114)) $e(%e,114)=$c(1)
	if $a(%e,82) do SQLComputeUpd115 set:%d(115)'=$g(%e(115)) $e(%e,115)=$c(1)
	if $a(%e,82) do SQLComputeUpd118 set:%d(118)'=$g(%e(118)) $e(%e,118)=$c(1)
	if $a(%e,82) do SQLComputeUpd119 set:%d(119)'=$g(%e(119)) $e(%e,119)=$c(1)
	if $a(%e,82) do SQLComputeUpd120 set:%d(120)'=$g(%e(120)) $e(%e,120)=$c(1)
	if $a(%e,82) do SQLComputeUpd121 set:%d(121)'=$g(%e(121)) $e(%e,121)=$c(1)
	if $a(%e,82) do SQLComputeUpd122 set:%d(122)'=$g(%e(122)) $e(%e,122)=$c(1)
	if $a(%e,82) do SQLComputeUpd123 set:%d(123)'=$g(%e(123)) $e(%e,123)=$c(1)
	if $a(%e,82) do SQLComputeUpd124 set:%d(124)'=$g(%e(124)) $e(%e,124)=$c(1)
	if $a(%e,82) do SQLComputeUpd125 set:%d(125)'=$g(%e(125)) $e(%e,125)=$c(1)
	if $a(%e,82) do SQLComputeUpd126 set:%d(126)'=$g(%e(126)) $e(%e,126)=$c(1)
	if $a(%e,82) do SQLComputeUpd127 set:%d(127)'=$g(%e(127)) $e(%e,127)=$c(1)
	if $a(%e,82) do SQLComputeUpd128 set:%d(128)'=$g(%e(128)) $e(%e,128)=$c(1)
	if $a(%e,82) do SQLComputeUpd129 set:%d(129)'=$g(%e(129)) $e(%e,129)=$c(1)
	if $a(%e,82) do SQLComputeUpd130 set:%d(130)'=$g(%e(130)) $e(%e,130)=$c(1)
	if $a(%e,82) do SQLComputeUpd132 set:%d(132)'=$g(%e(132)) $e(%e,132)=$c(1)
	if $a(%e,82) do SQLComputeUpd133 set:%d(133)'=$g(%e(133)) $e(%e,133)=$c(1)
	if $a(%e,82) do SQLComputeUpd134 set:%d(134)'=$g(%e(134)) $e(%e,134)=$c(1)
	if $a(%e,82) do SQLComputeUpd135 set:%d(135)'=$g(%e(135)) $e(%e,135)=$c(1)
	if $a(%e,82) do SQLComputeUpd136 set:%d(136)'=$g(%e(136)) $e(%e,136)=$c(1)
	QUIT
SQLComputeUpd116		// Compute code for field PtInjury_AtFaultOther
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(116)=$lg($g(%d(82)),6) q
SQLComputeUpd117		// Compute code for field PtInjury_BusOffc
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(117)=$lg($g(%d(82)),8) q
SQLComputeUpd131		// Compute code for field PtInjury_InjuryDetails
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(131)=$lg($g(%d(82)),7) q
SQLComputeUpd111		// Compute code for field PtInjury_AtFaultAddress
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(111)=$lg($g(%d(82)),1) q
SQLComputeUpd112		// Compute code for field PtInjury_AtFaultInsAdd
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(112)=$lg($g(%d(82)),2) q
SQLComputeUpd113		// Compute code for field PtInjury_AtFaultInsPolicy
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(113)=$lg($g(%d(82)),3) q
SQLComputeUpd114		// Compute code for field PtInjury_AtFaultInsurance
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(114)=$lg($g(%d(82)),4) q
SQLComputeUpd115		// Compute code for field PtInjury_AtFaultName
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(115)=$lg($g(%d(82)),5) q
SQLComputeUpd118		// Compute code for field PtInjury_BusOffcCmp
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(118)=$lg($g(%d(82)),9) q
SQLComputeUpd119		// Compute code for field PtInjury_BusOffcStat
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(119)=$lg($g(%d(82)),10) q
SQLComputeUpd120		// Compute code for field PtInjury_EmplAddress
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(120)=$lg($g(%d(82)),11) q
SQLComputeUpd121		// Compute code for field PtInjury_EmplCitySt
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(121)=$lg($g(%d(82)),12) q
SQLComputeUpd122		// Compute code for field PtInjury_EmplName
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(122)=$lg($g(%d(82)),13) q
SQLComputeUpd123		// Compute code for field PtInjury_EmplPh
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(123)=$lg($g(%d(82)),14) q
SQLComputeUpd124		// Compute code for field PtInjury_InjCause
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(124)=$lg($g(%d(82)),20) q
SQLComputeUpd125		// Compute code for field PtInjury_InjCauseIEN
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(125)=$lg($g(%d(82)),26) q
SQLComputeUpd126		// Compute code for field PtInjury_InjDt
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(126)=$lg($g(%d(82)),16) q
SQLComputeUpd127		// Compute code for field PtInjury_InjDtTm
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(127)=$lg($g(%d(82)),24) q
SQLComputeUpd128		// Compute code for field PtInjury_InjLocat
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(128)=$lg($g(%d(82)),15) q
SQLComputeUpd129		// Compute code for field PtInjury_InjSet
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(129)=$lg($g(%d(82)),21) q
SQLComputeUpd130		// Compute code for field PtInjury_InjTm
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(130)=$lg($g(%d(82)),17) q
SQLComputeUpd132		// Compute code for field PtInjury_MVCLoc
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(132)=$lg($g(%d(82)),25) q
SQLComputeUpd133		// Compute code for field PtInjury_PtDFN
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(133)=$lg($g(%d(82)),19) q
SQLComputeUpd134		// Compute code for field PtInjury_SafetyEquip
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(134)=$lg($g(%d(82)),23) q
SQLComputeUpd135		// Compute code for field PtInjury_VIEN
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(135)=$lg($g(%d(82)),18) q
SQLComputeUpd136		// Compute code for field PtInjury_WrkRel
 s:(%oper="INSERT"&&($g(%d(82))'=""))||(%oper="UPDATE") %d(136)=$lg($g(%d(82)),22) q
%SQLValidateFields(sqlcode)
	if $g(%d(14))'="",'($select($zu(115,13)&&(%d(14)=$c(0)):1,$isvalidnum(%d(14),,0,86400)&&(%d(14)'=86400):1,'$isvalidnum(%d(14)):$$Error^%apiOBJ(7207,%d(14)),%d(14)<0:$$Error^%apiOBJ(7204,%d(14),0),1:$$Error^%apiOBJ(7203,%d(14),86400))) { set sqlcode=..%SQLInvalid(14+1,%d(14)) } 
	if $g(%d(24))'="",'($select($zu(115,13)&&(%d(24)=$c(0)):1,$isvalidnum(%d(24),,0,86400)&&(%d(24)'=86400):1,'$isvalidnum(%d(24)):$$Error^%apiOBJ(7207,%d(24)),%d(24)<0:$$Error^%apiOBJ(7204,%d(24),0),1:$$Error^%apiOBJ(7203,%d(24),86400))) { set sqlcode=..%SQLInvalid(24+1,%d(24)) } 
	if $g(%d(26))'="",'($select($zu(115,13)&&(%d(26)=$c(0)):1,$isvalidnum(%d(26),,0,86400)&&(%d(26)'=86400):1,'$isvalidnum(%d(26)):$$Error^%apiOBJ(7207,%d(26)),%d(26)<0:$$Error^%apiOBJ(7204,%d(26),0),1:$$Error^%apiOBJ(7203,%d(26),86400))) { set sqlcode=..%SQLInvalid(26+1,%d(26)) } 
	if $g(%d(43))'="",'($select($zu(115,13)&&(%d(43)=$c(0)):1,$isvalidnum(%d(43),,0,86400)&&(%d(43)'=86400):1,'$isvalidnum(%d(43)):$$Error^%apiOBJ(7207,%d(43)),%d(43)<0:$$Error^%apiOBJ(7204,%d(43),0),1:$$Error^%apiOBJ(7203,%d(43),86400))) { set sqlcode=..%SQLInvalid(43+1,%d(43)) } 
	if $g(%d(68))'="",'($select($zu(115,13)&&(%d(68)=$c(0)):1,$isvalidnum(%d(68),,0,86400)&&(%d(68)'=86400):1,'$isvalidnum(%d(68)):$$Error^%apiOBJ(7207,%d(68)),%d(68)<0:$$Error^%apiOBJ(7204,%d(68),0),1:$$Error^%apiOBJ(7203,%d(68),86400))) { set sqlcode=..%SQLInvalid(68+1,%d(68)) } 
	if $g(%d(99))'="",'($select($zu(115,13)&&(%d(99)=$c(0)):1,$isvalidnum(%d(99),,0,86400)&&(%d(99)'=86400):1,'$isvalidnum(%d(99)):$$Error^%apiOBJ(7207,%d(99)),%d(99)<0:$$Error^%apiOBJ(7204,%d(99),0),1:$$Error^%apiOBJ(7203,%d(99),86400))) { set sqlcode=..%SQLInvalid(99+1,%d(99)) } 
	if $g(%d(106))'="",'($select($zu(115,13)&&(%d(106)=$c(0)):1,$isvalidnum(%d(106),,0,86400)&&(%d(106)'=86400):1,'$isvalidnum(%d(106)):$$Error^%apiOBJ(7207,%d(106)),%d(106)<0:$$Error^%apiOBJ(7204,%d(106),0),1:$$Error^%apiOBJ(7203,%d(106),86400))) { set sqlcode=..%SQLInvalid(106+1,%d(106)) } 
	if $g(%d(111))'="",'($$ValidateField111(%d(111))) { set sqlcode=..%SQLInvalid(111+1,%d(111)) } 
	if $g(%d(112))'="",'($$ValidateField112(%d(112))) { set sqlcode=..%SQLInvalid(112+1,%d(112)) } 
	if $g(%d(113))'="",'($$ValidateField113(%d(113))) { set sqlcode=..%SQLInvalid(113+1,%d(113)) } 
	if $g(%d(114))'="",'($$ValidateField114(%d(114))) { set sqlcode=..%SQLInvalid(114+1,%d(114)) } 
	if $g(%d(115))'="",'($$ValidateField115(%d(115))) { set sqlcode=..%SQLInvalid(115+1,%d(115)) } 
	if $g(%d(118))'="",'($$ValidateField118(%d(118))) { set sqlcode=..%SQLInvalid(118+1,%d(118)) } 
	if $g(%d(119))'="",'($$ValidateField119(%d(119))) { set sqlcode=..%SQLInvalid(119+1,%d(119)) } 
	if $g(%d(120))'="",'($$ValidateField120(%d(120))) { set sqlcode=..%SQLInvalid(120+1,%d(120)) } 
	if $g(%d(121))'="",'($$ValidateField121(%d(121))) { set sqlcode=..%SQLInvalid(121+1,%d(121)) } 
	if $g(%d(122))'="",'($$ValidateField122(%d(122))) { set sqlcode=..%SQLInvalid(122+1,%d(122)) } 
	if $g(%d(123))'="",'($$ValidateField123(%d(123))) { set sqlcode=..%SQLInvalid(123+1,%d(123)) } 
	if $g(%d(124))'="",'($$ValidateField124(%d(124))) { set sqlcode=..%SQLInvalid(124+1,%d(124)) } 
	if $g(%d(125))'="",'($$ValidateField125(%d(125))) { set sqlcode=..%SQLInvalid(125+1,%d(125)) } 
	if $g(%d(126))'="",'($$ValidateField126(%d(126))) { set sqlcode=..%SQLInvalid(126+1,%d(126)) } 
	if $g(%d(127))'="",'($$ValidateField127(%d(127))) { set sqlcode=..%SQLInvalid(127+1,%d(127)) } 
	if $g(%d(128))'="",'($$ValidateField128(%d(128))) { set sqlcode=..%SQLInvalid(128+1,%d(128)) } 
	if $g(%d(129))'="",'($$ValidateField129(%d(129))) { set sqlcode=..%SQLInvalid(129+1,%d(129)) } 
	if $g(%d(130))'="",'($$ValidateField130(%d(130))) { set sqlcode=..%SQLInvalid(130+1,%d(130)) } 
	if $g(%d(132))'="",'($$ValidateField132(%d(132))) { set sqlcode=..%SQLInvalid(132+1,%d(132)) } 
	if $g(%d(133))'="",'($$ValidateField133(%d(133))) { set sqlcode=..%SQLInvalid(133+1,%d(133)) } 
	if $g(%d(134))'="",'($$ValidateField134(%d(134))) { set sqlcode=..%SQLInvalid(134+1,%d(134)) } 
	if $g(%d(135))'="",'($$ValidateField135(%d(135))) { set sqlcode=..%SQLInvalid(135+1,%d(135)) } 
	if $g(%d(136))'="",'($$ValidateField136(%d(136))) { set sqlcode=..%SQLInvalid(136+1,%d(136)) } 
	new %f for %f=3,13,23,25,27,29,67,97,103,104 { if $g(%d(%f))'="",'($s($zu(115,13)&&(%d(%f)=$c(0)):1,$isvalidnum(%d(%f),0,0,):1,'$isvalidnum(%d(%f)):$$Error^%apiOBJ(7207,%d(%f)),1:$$Error^%apiOBJ(7204,%d(%f),0))) set sqlcode=..%SQLInvalid(%f+1,$g(%d(%f))) quit  } 
	new %f for %f=22,30,84,85,86,87,91,108,109 { if $g(%d(%f))'="",'($select($zu(115,13)&&(%d(%f)=$c(0)):1,$isvalidnum(%d(%f),0,,):1,1:$$Error^%apiOBJ(7207,%d(%f)))) set sqlcode=..%SQLInvalid(%f+1,$g(%d(%f))) quit  } 
	new %f for %f=2,4,5,6,7,8,9,10,11,12,15,16,17,18,19,20,21,28,31,32,33,34,35,36,37,38,39,40,41,42,44,45,46,47,48,49,50,51,52,53,54,55,56,57,59,60,61,62,63,64,65,66,69,70,71,72,73,74,75,76,77,78,79,80,81,83,88,89,90,92,93,94,95,96,98,100,101,102,105 { if $g(%d(%f))'="",'(($l(%d(%f))'>50)) set sqlcode=..%SQLInvalid(%f+1,$g(%d(%f))) quit  } 
	QUIT 'sqlcode
ValidateField111(%val)	Quit ($l(%val)'>50)
ValidateField112(%val)	Quit ($l(%val)'>50)
ValidateField113(%val)	Quit ($l(%val)'>50)
ValidateField114(%val)	Quit ($l(%val)'>50)
ValidateField115(%val)	Quit ($l(%val)'>50)
ValidateField118(%val)	Quit ($l(%val)'>50)
ValidateField119(%val)	Quit ($l(%val)'>50)
ValidateField120(%val)	Quit ($l(%val)'>50)
ValidateField121(%val)	Quit ($l(%val)'>50)
ValidateField122(%val)	Quit ($l(%val)'>50)
ValidateField123(%val)	Quit ($l(%val)'>50)
ValidateField124(%val)	Quit ($l(%val)'>50)
ValidateField125(%val)	Quit ($l(%val)'>50)
ValidateField126(%val)	Q $s($zu(115,13)&&(%val=$c(0)):1,$isvalidnum(%val,0,0,):1,'$isvalidnum(%val):$$Error^%apiOBJ(7207,%val),1:$$Error^%apiOBJ(7204,%val,0))
ValidateField127(%val)	Quit ($l(%val)'>50)
ValidateField128(%val)	Quit ($l(%val)'>50)
ValidateField129(%val)	Quit ($l(%val)'>50)
ValidateField130(%val)	Quit $select($zu(115,13)&&(%val=$c(0)):1,$isvalidnum(%val,,0,86400)&&(%val'=86400):1,'$isvalidnum(%val):$$Error^%apiOBJ(7207,%val),%val<0:$$Error^%apiOBJ(7204,%val,0),1:$$Error^%apiOBJ(7203,%val,86400))
ValidateField132(%val)	Quit ($l(%val)'>50)
ValidateField133(%val)	Quit ($l(%val)'>50)
ValidateField134(%val)	Quit ($l(%val)'>50)
ValidateField135(%val)	Quit ($l(%val)'>50)
ValidateField136(%val)	Quit ($l(%val)'>50)
	Quit
%SQLnBuild() public {
	set %n=$lb(,"ID","AMERVSIT","AdPvDtm","AdmPrv","AdmPrvN","Age","ArrMode","AsgCln","AsgNrs","AsgNrsN","AsgPrv","AsgPrvN","CIDt","CITm","Chart","Clinic","CodeBlue","Complaint","DCDPrvH","DCDPrvHN","DCDispH","DCDocH","DCDocHEDt","DCDocHETm","DCDocHSDt","DCDocHSTm","DCDt","DCDtH","DCDtTm","DCFlag","DCInstH","DCInstHN","DCMode","DCModeN","DCNrs","DCNrsH","DCNrsN","DCPrv","DCPrvH","DCPrvN","DCStat","DCStatN","DCTm","DCTmH","DCTrgH","DCTrns","DCTrnsN","DOB","DecAdmDt","DispN","Disposition","EDConsult","EDDx","EDProcedure","EDTrans","FinA","Industry","Info","InjC","InjS","Injury","NewDecAdmit","ORmDt","ORmTm","Occupation","OrgRoom","OrgRoomDt","OrgRoomTime","PrimDx","PrimDxH","PrimDxN","PrimDxNarr","PrimICD","PrimICDN","PrimPrv","PrimPrvN","PrimaryNurse","PrmNurse","PtCIDT","PtDCDT","PtDFN","PtInjury","PtName","PtStat","PtStatI","PtStatN","PtStatV","PtTrgDT","RClDt","RClTm","RecLock","RecLockDT","RecLockSite","RecLockUser","Room","RoomClear","RoomDt","RoomDtTm","RoomTime","Sex","TrgA","TrgCln","TrgDt","TrgDtTm","TrgNrs","TrgTm","VIEN","VstDur","WtgTime","x__classname","PtInjury_AtFaultAddress","PtInjury_AtFaultInsAdd","PtInjury_AtFaultInsPolicy","PtInjury_AtFaultInsurance","PtInjury_AtFaultName","PtInjury_AtFaultOther","PtInjury_BusOffc","PtInjury_BusOffcCmp","PtInjury_BusOffcStat","PtInjury_EmplAddress","PtInjury_EmplCitySt","PtInjury_EmplName","PtInjury_EmplPh","PtInjury_InjCause","PtInjury_InjCauseIEN","PtInjury_InjDt","PtInjury_InjDtTm","PtInjury_InjLocat","PtInjury_InjSet","PtInjury_InjTm","PtInjury_InjuryDetails","PtInjury_MVCLoc","PtInjury_PtDFN","PtInjury_SafetyEquip","PtInjury_VIEN","PtInjury_WrkRel")
	QUIT }
%Save(related=1) public {
	Set $ZTrap="%SaveERR"
	New %objTX Set sc=1,traninit=0 If '$data(%objTX2) New %objTX2 Set %objTX2=1
	If +$g(%objtxSTATUS)=0 { Set traninit=1 k %objtxSTATUS,%objtxLIST,%objtxOIDASSIGNED,%objtxOIDUNASSIGNED,%objtxMODIFIED k:'$TLevel %0CacheLock,%objtxTID,%objtxID i '$zu(115,9) { s %objtxSTATUS=1 } else { TStart  s %objtxSTATUS=2 } }
	If $get(%objTX2(+$this)) Set sc=..%BuildObjectGraph(1) Quit:('sc) sc Set intRef=+$this,objValue=$get(%objTX(1,intRef,1)),sc=..%SerializeObject(.objValue,1) Set:(''sc) %objTX(1,intRef,1)=objValue Quit sc
	Set sc=..%BuildObjectGraph(related+2) If ('sc) ZTrap "SG"
	If '$data(%objTX(2)) s sc=1 GoTo %SaveCOMMIT
	Set %objTX(3)=0,intRef="" For  Set intRef=$order(%objTX(2,intRef)) Quit:intRef=""  If '$data(%objTX(1,intRef,2)) Set %objTX(3,$increment(%objTX(3)))=%objTX(1,intRef) Kill %objTX(2,intRef)
	For  Quit:%objTX(3)<1  Set ptr=%objTX(3),objRef=%objTX(3,ptr),%objTX(3)=%objTX(3)-1 Kill %objTX(3,ptr) Set objValue=$get(%objTX(1,+objRef,1)),sc=objRef.%SerializeObject(.objValue) Do  Set %objTX(1,+objRef,1)=objValue Kill %objTX(1,+objRef,3) Do $system.CLS.SetModified(objRef,0)
	. If ('sc) k:$g(%objtxSTATUS)=2 %objtxLIST(+objRef),%objtxMODIFIED(+objRef) ZTrap "SG"
	. i $g(%objtxSTATUS)=2 { Set %objtxMODIFIED(+objRef)=$system.CLS.GetModifiedBits(objRef) }
	. Set intSucc="" For  Set intSucc=$order(%objTX(1,+objRef,3,intSucc)) Quit:intSucc=""  Kill %objTX(1,+objRef,3,intSucc),%objTX(1,intSucc,2,+objRef) If '$data(%objTX(1,intSucc,2)) Set %objTX(3,$increment(%objTX(3)))=%objTX(1,intSucc) Kill %objTX(2,intSucc)
	For  Set pserial=0 Do  Quit:'pserial
	. Set intRef="" For  Set intRef=$order(%objTX(2,intRef)) Quit:intRef=""  Set intPred="" For  Set intPred=$order(%objTX(1,intRef,2,intPred)) Quit:intPred=""  If $get(%objTX(1,intPred,6))=1 Set objValue=$get(%objTX(1,intPred,1)),sc=(%objTX(1,intPred)).%SerializeObject(.objValue,1) If (''sc) Set pserial=1,%objTX(1,intPred,1)=objValue Do
	. . Set intSucc="" For  Set intSucc=$order(%objTX(1,intPred,3,intSucc)) Quit:intSucc=""  Kill %objTX(1,intPred,3,intSucc),%objTX(1,intSucc,2,intPred) If '$data(%objTX(1,intSucc,2)) Set %objTX(3,$i(%objTX(3)))=%objTX(1,intSucc) Kill %objTX(2,intSucc)
	. . For  Quit:%objTX(3)<1  Set ptr=%objTX(3),objSerialize=%objTX(3,ptr),%objTX(3)=%objTX(3)-1 Kill %objTX(3,ptr) Set objValue=$get(%objTX(1,+objSerialize,1)),sc=objSerialize.%SerializeObject(.objValue) Do  Set %objTX(1,+objSerialize,1)=objValue Kill %objTX(1,+objSerialize,3) Do $system.CLS.SetModified(objSerialize,0)
	. . . If ('sc) k:$g(%objtxSTATUS)=2 %objtxLIST(+objSerialize),%objtxMODIFIED(+objSerialize) ZTrap "SG"
	. . . i $g(%objtxSTATUS)=2 { Set %objtxMODIFIED(+objSerialize)=$system.CLS.GetModifiedBits(objSerialize) }
	. . . Set intSucc="" For  Set intSucc=$order(%objTX(1,+objSerialize,3,intSucc)) Quit:intSucc=""  Kill %objTX(1,+objSerialize,3,intSucc),%objTX(1,intSucc,2,+objSerialize) If '$data(%objTX(1,intSucc,2)) Set %objTX(3,$i(%objTX(3)))=%objTX(1,intSucc) Kill %objTX(2,intSucc)
	If $data(%objTX(2))>2 Set sc=$$Error^%apiOBJ(5827,$classname()) ZTrap "SG"
	Set cmd="" For  Set cmd=$order(%objTX(9,cmd)) Quit:cmd=""  Xecute cmd
%SaveCOMMIT	If traninit { i $g(%objtxSTATUS)=1 { k %objtxSTATUS } else { If $Tlevel { TCommit  } k %objtxSTATUS,%objtxLIST,%objtxOIDASSIGNED,%objtxOIDUNASSIGNED,%objtxMODIFIED k:'$TLevel %0CacheLock,%objtxTID,%objtxID } }
	Do $system.CLS.SetModified(0) Quit sc
%SaveERR	Set $ZTrap="" If $extract($zerror,1,5)'="<ZSG>" Set sc=$$Error^%apiOBJ(5002,$ZE)
	If traninit { i $g(%objtxSTATUS)=2 { k %0CacheLock s sc=$select(+sc:$$%TRollBack^%occTransaction(),1:$$AppendStatus^%occSystem(sc,$$%TRollBack^%occTransaction())) k %objtxTID,%objtxID } else { k %objtxSTATUS } }
	Quit sc }
%SaveData(id) public {
	Set bsv0N1=..TrgTmCompute(id,i%AMERVSIT,i%PtDFN)
	Set bsv0N2=..TrgDtCompute(id,i%AMERVSIT,i%PtDFN)
	Set bsv0N3=..PtStatICompute(id,i%AMERVSIT,i%DCDocH,i%DCFlag,i%PtDFN,i%Room,..TrgACompute(id,i%AMERVSIT,i%PtDFN))
	Set bsv0N4=..CITmCompute(id,i%AMERVSIT,i%PtDFN)
	Set bsv0N5=..CIDtCompute(id,i%AMERVSIT,i%PtDFN)
	Set $ZTrap="SaveDataERR" Set sc=1,id=$listget(i%"%%OID") If id'="" { Set insert=0,idassigned=1 } Else { Set insert=1,idassigned=0 }
	Set lock=0,lockok=0,tSharedLock=0,locku=""
	if 'idassigned { set id=$i(^BEDD.EDVISITD) Set $zobjoid("BEDD.EDVISIT",id)=$this,.."%%OID"=$lb(id_"","BEDD.EDVISIT") set:$g(%objtxSTATUS)=2 %objtxOIDASSIGNED(+$this)="" }
	Set bsv0N6=..DCDtCompute(id,i%AMERVSIT)
	If 'insert && ('$Data(^BEDD.EDVISITD(id))) { Set insert=1 }
	If '$Tlevel { Kill %0CacheLock }
	If insert  {
		if (..%Concurrency&&$tlevel)||(..%Concurrency=4) { If (..%Concurrency < 4)&&($i(%0CacheLock($classname()))>$zu(115,6)) { Lock +(^BEDD.EDVISITD):$zu(115,4) Set lockok=$Select($test:2,1:0) Lock:lockok -(^BEDD.EDVISITD) } Else { Lock +(^BEDD.EDVISITD(id)):$zu(115,4) Set lockok=$Select($test:1,1:0) Set:..%Concurrency'=4 lock=lockok } If 'lockok { Set sc=$$Error^%apiOBJ(5803,$classname()) Goto SaveDataEXIT } }
		if ..%Concurrency=3 { Lock +(^BEDD.EDVISITD(id)#"S") set tSharedLock=1 }
		s ^BEDD.EDVISITD(id)=$lb("",i%AMERVSIT,i%AsgCln,i%AsgNrs,i%AsgPrv,i%CodeBlue,i%DCDtH,i%DCTmH,i%DCNrsH,i%DCPrvH,i%DCDPrvH,i%DCDispH,i%DCInstH,i%DCTrgH,i%DCStat,i%DCStatN,i%DCFlag,i%EDConsult,i%EDProcedure,i%EDTrans,i%EDDx,i%PrimDx,i%PrimICD,i%Info,i%Injury,i%PtInjury,i%PtDFN,i%Room,i%RoomDt,i%RoomTime,i%VIEN,i%PrimDxH,i%PrimPrv,i%DCTrns,i%DCTrnsN,i%DCMode,i%DCModeN,i%OrgRoom,i%OrgRoomDt,i%OrgRoomTime,i%Clinic,i%DCDocH,i%PtStat,,i%RecLock,i%RecLockUser,i%RecLockDT,i%PtStatV,,,i%DCDocHSDt,i%DCDocHSTm,i%DCDocHEDt,i%DCDocHETm,i%PrimDxNarr,i%RoomDtTm,i%ORmDt,i%ORmTm,i%PrimaryNurse,i%RoomClear,i%RClDt,i%RClTm,i%PrmNurse,i%DecAdmDt,i%RecLockSite)
		s ^BEDD.EDVISITI("ADIdx",$s(i%VIEN'="":i%VIEN,1:-1E14),id)=""
		s ^BEDD.EDVISITI("ArrIdx",$s(bsv0N5'="":bsv0N5,1:-1E14),id)=$lb("",bsv0N5)
		s ^BEDD.EDVISITI("CIDtIIdx",$s(bsv0N5'="":bsv0N5,1:-1E14),id)=$lb("",bsv0N5)
		s ^BEDD.EDVISITI("DCDTIdx",$zu(28,i%DCDtH,7,32768),id)=""
		s ^BEDD.EDVISITI("DisIdx",$s(bsv0N6'="":bsv0N6,1:-1E14),id)=""
	}
	Else  {
		If (..%Concurrency<4)&&(..%Concurrency) { If $i(%0CacheLock($classname()))>$zu(115,6) { Lock +(^BEDD.EDVISITD):$zu(115,4) Set lockok=$s($test:2,1:0) Lock:lockok -(^BEDD.EDVISITD) } Else { Lock +(^BEDD.EDVISITD(id)):$zu(115,4) Set lockok=$Select($test:1,1:0),lock=lockok } If 'lockok { Set sc=$$Error^%apiOBJ(5803,$classname()) Goto SaveDataEXIT } }
		Set bsv0N7=^BEDD.EDVISITD(id)
		Set bsv0N8=$listget(bsv0N7,2)
		Set bsv0N9=$listget(bsv0N7,31)
		If (i%VIEN'=$listget(bsv0N7,31)) {
			Kill ^BEDD.EDVISITI("ADIdx",$s(bsv0N9'="":bsv0N9,1:-1E14),id)
			s ^BEDD.EDVISITI("ADIdx",$s(i%VIEN'="":i%VIEN,1:-1E14),id)=""
		}
		Set bsv0N10=..CIDtCompute(id,bsv0N8,$listget(bsv0N7,27))
		If (i%AMERVSIT'=bsv0N8)||(bsv0N5'=..CIDtCompute(id,bsv0N8,$listget(bsv0N7,27)))||(i%PtDFN'=$listget(bsv0N7,27)) {
			Kill ^BEDD.EDVISITI("ArrIdx",$s(bsv0N10'="":bsv0N10,1:-1E14),id)
			s ^BEDD.EDVISITI("ArrIdx",$s(bsv0N5'="":bsv0N5,1:-1E14),id)=$lb("",bsv0N5)
		}
		Set bsv0N11=..CIDtCompute(id,bsv0N8,$listget(bsv0N7,27))
		If (i%AMERVSIT'=bsv0N8)||(bsv0N5'=..CIDtCompute(id,bsv0N8,$listget(bsv0N7,27)))||(i%PtDFN'=$listget(bsv0N7,27)) {
			Kill ^BEDD.EDVISITI("CIDtIIdx",$s(bsv0N11'="":bsv0N11,1:-1E14),id)
			s ^BEDD.EDVISITI("CIDtIIdx",$s(bsv0N5'="":bsv0N5,1:-1E14),id)=$lb("",bsv0N5)
		}
		If (i%DCDtH'=$listget(bsv0N7,7)) {
			Kill ^BEDD.EDVISITI("DCDTIdx",$zu(28,$listget(bsv0N7,7),7,32768),id)
			s ^BEDD.EDVISITI("DCDTIdx",$zu(28,i%DCDtH,7,32768),id)=""
		}
		Set bsv0N12=..DCDtCompute(id,bsv0N8)
		If (i%AMERVSIT'=bsv0N8)||(..DCDtCompute(id,i%AMERVSIT)'=..DCDtCompute(id,bsv0N8)) {
			Kill ^BEDD.EDVISITI("DisIdx",$s(bsv0N12'="":bsv0N12,1:-1E14),id)
			s ^BEDD.EDVISITI("DisIdx",$s(bsv0N6'="":bsv0N6,1:-1E14),id)=""
		}
		s ^BEDD.EDVISITD(id)=$lb("",i%AMERVSIT,i%AsgCln,i%AsgNrs,i%AsgPrv,i%CodeBlue,i%DCDtH,i%DCTmH,i%DCNrsH,i%DCPrvH,i%DCDPrvH,i%DCDispH,i%DCInstH,i%DCTrgH,i%DCStat,i%DCStatN,i%DCFlag,i%EDConsult,i%EDProcedure,i%EDTrans,i%EDDx,i%PrimDx,i%PrimICD,i%Info,i%Injury,i%PtInjury,i%PtDFN,i%Room,i%RoomDt,i%RoomTime,i%VIEN,i%PrimDxH,i%PrimPrv,i%DCTrns,i%DCTrnsN,i%DCMode,i%DCModeN,i%OrgRoom,i%OrgRoomDt,i%OrgRoomTime,i%Clinic,i%DCDocH,i%PtStat,,i%RecLock,i%RecLockUser,i%RecLockDT,i%PtStatV,,,i%DCDocHSDt,i%DCDocHSTm,i%DCDocHEDt,i%DCDocHETm,i%PrimDxNarr,i%RoomDtTm,i%ORmDt,i%ORmTm,i%PrimaryNurse,i%RoomClear,i%RClDt,i%RClTm,i%PrmNurse,i%DecAdmDt,i%RecLockSite)
	}
SaveDataEXIT
	if (('sc)) && ('idassigned) { Set $zobjoid("",$listget(i%"%%OID"))="" Set $this."%%OID" = "" kill:$g(%objtxSTATUS)=2 %objtxOIDASSIGNED(+$this) }
	If lock Lock -(^BEDD.EDVISITD(id))
	If (('sc)) { if (tSharedLock) {  Lock -(^BEDD.EDVISITD(id)#"S") } elseif (lockok=1)&&(insert)&&(..%Concurrency=4) {  Lock -(^BEDD.EDVISITD(id)) } }
SaveDataRET	Set $Ztrap = ""
	QUIT sc
SaveDataERR	Set $Ztrap = "SaveDataRET"
	Set sc = $$Error^%apiOBJ(5002,$ZE)
	Goto SaveDataEXIT }
%SaveDirect(id="",idList="",data,concurrency=-1) public {
	Set $ZTrap="SaveDirectERR" s sc=1 i id'="" { Set insert=0,idassigned=1 } Else { Set insert=1,idassigned=0 }
	if concurrency=-1 { Set concurrency=$zu(115,10) }
	If 'idassigned { set id=$i(^BEDD.EDVISITD) }
	Set bsv0N1=..DCDtCompute(id,$listget(data,2))
	Set bsv0N2=..CIDtCompute(id,$listget(data,2),$listget(data,27))
	Set bsv0N3=$listget(data,31)
	If 'insert && ('$Data(^BEDD.EDVISITD(id))) { Set insert=1 }
	Set lock=0,locku=""
	If '$Tlevel { Kill %0CacheLock }
	If insert  {
		i concurrency { If $i(%0CacheLock($classname()))>$zu(115,6) { Lock +(^BEDD.EDVISITD):$zu(115,4) Set lock=$Select($test:2,1:0) Lock:lock -(^BEDD.EDVISITD) } Else { Lock +(^BEDD.EDVISITD(id)):$zu(115,4) Set lock=$Select($test:1,1:0) } If 'lock { Set sc=$$Error^%apiOBJ(5803,$classname()) Goto SaveDirectEXIT } }
		s ^BEDD.EDVISITD(id)=data
		s ^BEDD.EDVISITI("ADIdx",$s(bsv0N3'="":bsv0N3,1:-1E14),id)=$listget(data,1)
		s ^BEDD.EDVISITI("ArrIdx",$s(bsv0N2'="":bsv0N2,1:-1E14),id)=$lb($listget(data,1),bsv0N2)
		s ^BEDD.EDVISITI("CIDtIIdx",$s(bsv0N2'="":bsv0N2,1:-1E14),id)=$lb($listget(data,1),bsv0N2)
		s ^BEDD.EDVISITI("DCDTIdx",$zu(28,$listget(data,7),7,32768),id)=$listget(data,1)
		s ^BEDD.EDVISITI("DisIdx",$s(bsv0N1'="":bsv0N1,1:-1E14),id)=$listget(data,1)
	}
	Else  {
		i concurrency { If $i(%0CacheLock($classname()))>$zu(115,6) { Lock +(^BEDD.EDVISITD):$zu(115,4) Set lock=$s($test:2,1:0) Lock:lock -(^BEDD.EDVISITD) } Else { Lock +(^BEDD.EDVISITD(id)):$zu(115,4) Set lock=$Select($test:1,1:0) } If 'lock { Set sc=$$Error^%apiOBJ(5803,$classname()) Goto SaveDirectEXIT } }
		Set bsv0N4=$li(idList,1)
		Set bsv0N5=^BEDD.EDVISITD(bsv0N4)
		Set bsv0N6=$listget(bsv0N5,2)
		Set bsv0N7=$listget(bsv0N5,31)
		If ($listget(data,31)'=$listget(bsv0N5,31)) {
			Kill ^BEDD.EDVISITI("ADIdx",$s(bsv0N7'="":bsv0N7,1:-1E14),$li(idList,1))
			s ^BEDD.EDVISITI("ADIdx",$s(bsv0N3'="":bsv0N3,1:-1E14),id)=$listget(data,1)
		}
		Set bsv0N8=..CIDtCompute(id,bsv0N6,$listget(bsv0N5,27))
		If ($listget(data,2)'=bsv0N6)||(bsv0N2'=..CIDtCompute(id,bsv0N6,$listget(bsv0N5,27)))||($listget(data,27)'=$listget(bsv0N5,27)) {
			Kill ^BEDD.EDVISITI("ArrIdx",$s(bsv0N8'="":bsv0N8,1:-1E14),$li(idList,1))
			s ^BEDD.EDVISITI("ArrIdx",$s(bsv0N2'="":bsv0N2,1:-1E14),id)=$lb($listget(data,1),bsv0N2)
		}
		Set bsv0N9=..CIDtCompute(id,bsv0N6,$listget(bsv0N5,27))
		If ($listget(data,2)'=bsv0N6)||(bsv0N2'=..CIDtCompute(id,bsv0N6,$listget(bsv0N5,27)))||($listget(data,27)'=$listget(bsv0N5,27)) {
			Kill ^BEDD.EDVISITI("CIDtIIdx",$s(bsv0N9'="":bsv0N9,1:-1E14),$li(idList,1))
			s ^BEDD.EDVISITI("CIDtIIdx",$s(bsv0N2'="":bsv0N2,1:-1E14),id)=$lb($listget(data,1),bsv0N2)
		}
		If ($listget(data,7)'=$listget(bsv0N5,7)) {
			Kill ^BEDD.EDVISITI("DCDTIdx",$zu(28,$listget(bsv0N5,7),7,32768),$li(idList,1))
			s ^BEDD.EDVISITI("DCDTIdx",$zu(28,$listget(data,7),7,32768),id)=$listget(data,1)
		}
		Set bsv0N10=..DCDtCompute(id,bsv0N6)
		If ($listget(data,2)'=bsv0N6)||(..DCDtCompute(id,$listget(data,2))'=..DCDtCompute(id,bsv0N6)) {
			Kill ^BEDD.EDVISITI("DisIdx",$s(bsv0N10'="":bsv0N10,1:-1E14),$li(idList,1))
			s ^BEDD.EDVISITI("DisIdx",$s(bsv0N1'="":bsv0N1,1:-1E14),id)=$listget(data,1)
		}
		s ^BEDD.EDVISITD(id)=data
	}
SaveDirectEXIT
	If lock=1 Lock -(^BEDD.EDVISITD(id))
SaveDirectRET	Set $Ztrap = ""
	QUIT sc
SaveDirectERR	Set $Ztrap = "SaveDirectRET"
	Set sc = $$Error^%apiOBJ(5002,$ZE)
	Goto SaveDirectEXIT }
%SaveIndices(pStartId="",pEndId="",lockExtent=0) public {
	i lockExtent { s sc=..%LockExtent(0) i ('sc) { q sc } }
	s id=$order(^BEDD.EDVISITD(pStartId),-1),tEndId=$S(pEndId'="":pEndId,1:pStartId)
BSLoop	s id=$O(^BEDD.EDVISITD(id)) g:(id="")||(id]]tEndId) BSLoopDun
	Set bsv0N1=$Get(^BEDD.EDVISITD(id))
	Set bsv0N2=$listget(bsv0N1,2)
	Set bsv0N3=$listget(bsv0N1,31)
	Set bsv0N4=$s(bsv0N3'="":bsv0N3,1:-1E14)
	Set ^BEDD.EDVISITI("ADIdx",bsv0N4,id)=$listget(bsv0N1,1)
	Set bsv0N5=..CIDtCompute(id,bsv0N2,$listget(bsv0N1,27))
	Set bsv0N6=$s(bsv0N5'="":bsv0N5,1:-1E14)
	Set ^BEDD.EDVISITI("ArrIdx",bsv0N6,id)=$lb($listget(bsv0N1,1),bsv0N5)
	Set bsv0N7=..CIDtCompute(id,bsv0N2,$listget(bsv0N1,27))
	Set bsv0N8=$s(bsv0N7'="":bsv0N7,1:-1E14)
	Set ^BEDD.EDVISITI("CIDtIIdx",bsv0N8,id)=$lb($listget(bsv0N1,1),bsv0N7)
	Set bsv0N9=$zu(28,$listget(bsv0N1,7),7,32768)
	Set ^BEDD.EDVISITI("DCDTIdx",bsv0N9,id)=$listget(bsv0N1,1)
	Set bsv0N10=..DCDtCompute(id,bsv0N2)
	Set bsv0N11=$s(bsv0N10'="":bsv0N10,1:-1E14)
	Set ^BEDD.EDVISITI("DisIdx",bsv0N11,id)=$listget(bsv0N1,1)
	g BSLoop
BSLoopDun
	i lockExtent { d ..%UnlockExtent(0) }
	QUIT 1
CatchError	s $ZTrap="" i $ZE'="" { s sc = $$Error^%apiOBJ(5002,$ZE) } i lockExtent { d ..%UnlockExtent(0) } q sc }
%SerializeObject(serial,partial=0) public {
	Set $Ztrap = "%SerializeObjectERR"
	If $get(%objTX2(+$this)) { Set partial = 1 } ElseIf ('partial) { Set %objTX2(+$this) = 1 }
	Set sc=..%ValidateObject() If ('sc) { Ztrap "SO" }
	Set sc=..%NormalizeObject() If ('sc) { Ztrap "SO" }
	If r%Info'="" { Set:'$data(%objTX(1,+r%Info,1)) %objTX(1,+r%Info)=r%Info,%objTX(1,+r%Info,1)=..InfoGetObject(1),%objTX(1,+r%Info,6)=2 Set M%Info=1,i%Info=$list(%objTX(1,+r%Info,1),1,2) }
	If r%PtInjury'="" { Set:'$data(%objTX(1,+r%PtInjury,1)) %objTX(1,+r%PtInjury)=r%PtInjury,%objTX(1,+r%PtInjury,1)=..PtInjuryGetObject(1),%objTX(1,+r%PtInjury,6)=2 Set M%PtInjury=1,i%PtInjury=$listget(%objTX(1,+r%PtInjury,1)) }
	s:$g(%objtxSTATUS)=2 %objtxLIST(+$this)=$this
	Set id=$listget(serial),sc=..%SaveData(.id) If ('sc) { Ztrap "SO" }
	Set serial=(..%Oid())
	if 'partial {
		Set %objTX2(+$this) = 0
	}
	Quit sc
%SerializeObjectERR	Set $ZTrap="" If $extract($zerror,1,5)'="<ZSO>" Set sc=$$Error^%apiOBJ(5002,$ZE)
	If 'partial { Set %objTX2(+$this) = 0 }
	Quit sc }
%AddToSaveSet(depth=3,refresh=0) public {
	If $data(%objTX(1,+$this)) && ('refresh) Quit 1
	Set sc=1,intOref=+$this
	If refresh Set intPoref="" For  Set intPoref=$order(%objTX(1,intOref,2,intPoref)) Quit:intPoref=""  Kill %objTX(1,intPoref,3,intOref),%objTX(1,intOref,2,intPoref)
	Set serial=..%Oid(),%objTX(1,intOref)=$this,%objTX(1,intOref,1)=serial,%objTX(1,intOref,6)=1 If (serial '= "") && (depth<2) { Quit 1 } Else { Set %objTX(7,intOref)=1 }
	Set Poref=r%Info If Poref'="" Set:'$data(%objTX(1,+Poref)) %objTX(6,$i(%objTX(6)))=Poref Set %objTX(8,$i(%objTX(8)))=$lb(+Poref,intOref,3,$listget(i%Info))
	Set Poref=r%PtInjury If Poref'="" Set:'$data(%objTX(1,+Poref)) %objTX(6,$i(%objTX(6)))=Poref Set %objTX(8,$i(%objTX(8)))=$lb(+Poref,intOref,3,i%PtInjury)
exit	Quit sc }
%SortBegin(idxlist="",excludeunique=0)
	if $select(idxlist="":1,$listfind(idxlist,"ADIdx"):1,1:0) If $SortBegin(^BEDD.EDVISITI("ADIdx"))
	if $select(idxlist="":1,$listfind(idxlist,"ArrIdx"):1,1:0) If $SortBegin(^BEDD.EDVISITI("ArrIdx"))
	if $select(idxlist="":1,$listfind(idxlist,"CIDtIIdx"):1,1:0) If $SortBegin(^BEDD.EDVISITI("CIDtIIdx"))
	if $select(idxlist="":1,$listfind(idxlist,"DCDTIdx"):1,1:0) If $SortBegin(^BEDD.EDVISITI("DCDTIdx"))
	if $select(idxlist="":1,$listfind(idxlist,"DisIdx"):1,1:0) If $SortBegin(^BEDD.EDVISITI("DisIdx"))
	Quit 1
%SortEnd(idxlist="",commit=1)
	if $select(idxlist="":1,$listfind(idxlist,"ADIdx"):1,1:0) If $SortEnd(^BEDD.EDVISITI("ADIdx"),commit)
	if $select(idxlist="":1,$listfind(idxlist,"ArrIdx"):1,1:0) If $SortEnd(^BEDD.EDVISITI("ArrIdx"),commit)
	if $select(idxlist="":1,$listfind(idxlist,"CIDtIIdx"):1,1:0) If $SortEnd(^BEDD.EDVISITI("CIDtIIdx"),commit)
	if $select(idxlist="":1,$listfind(idxlist,"DCDTIdx"):1,1:0) If $SortEnd(^BEDD.EDVISITI("DCDTIdx"),commit)
	if $select(idxlist="":1,$listfind(idxlist,"DisIdx"):1,1:0) If $SortEnd(^BEDD.EDVISITI("DisIdx"),commit)
	Quit 1
%UnlockExtent(shared=0,immediate=0) public {
	if ('immediate)&&('shared) { l -^BEDD.EDVISITD q 1 } elseif (immediate)&&('shared) { l -^BEDD.EDVISITD#"I" q 1 } elseif ('immediate)&&(shared) { l -^BEDD.EDVISITD#"S" q 1 } else { l -^BEDD.EDVISITD#"SI" q 1 }
}
%UnlockId(id,shared=0,immediate=0) public {
	if ('immediate)&&('shared) { Lock -(^BEDD.EDVISITD(id)) q 1 } elseif (immediate)&&('shared) { Lock -(^BEDD.EDVISITD(id)#"I") q 1 } elseif ('immediate)&&(shared) { Lock -(^BEDD.EDVISITD(id)#"S") q 1 } else { Lock -(^BEDD.EDVISITD(id)#"SI") q 1 }
}
%ValidateObject(force=0) public {
	Set sc=1
	If (r%PtInjury'="")||m%PtInjury Set rc=..PtInjury.%ValidateObject(force) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"PtInjury",..PtInjury)
	If '$system.CLS.GetModified() Quit sc
	If m%AMERVSIT Set iv=..AMERVSIT If iv'="" Set rc=(..AMERVSITIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"AMERVSIT",iv)
	If m%AsgCln Set iv=..AsgCln If iv'="" Set rc=(..AsgClnIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"AsgCln",iv)
	If m%AsgNrs Set iv=..AsgNrs If iv'="" Set rc=(..AsgNrsIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"AsgNrs",iv)
	If m%AsgPrv Set iv=..AsgPrv If iv'="" Set rc=(..AsgPrvIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"AsgPrv",iv)
	If m%Clinic Set iv=..Clinic If iv'="" Set rc=(..ClinicIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"Clinic",iv)
	If m%CodeBlue Set iv=..CodeBlue If iv'="" Set rc=(..CodeBlueIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"CodeBlue",iv)
	If m%DCDPrvH Set iv=..DCDPrvH If iv'="" Set rc=(..DCDPrvHIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"DCDPrvH",iv)
	If m%DCDispH Set iv=..DCDispH If iv'="" Set rc=(..DCDispHIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"DCDispH",iv)
	If m%DCDocH Set iv=..DCDocH If iv'="" Set rc=(..DCDocHIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"DCDocH",iv)
	If m%DCDocHEDt Set iv=..DCDocHEDt If iv'="" Set rc=(..DCDocHEDtIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"DCDocHEDt",iv)
	If m%DCDocHETm Set iv=..DCDocHETm If iv'="" Set rc=(..DCDocHETmIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"DCDocHETm",iv)
	If m%DCDocHSDt Set iv=..DCDocHSDt If iv'="" Set rc=(..DCDocHSDtIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"DCDocHSDt",iv)
	If m%DCDocHSTm Set iv=..DCDocHSTm If iv'="" Set rc=(..DCDocHSTmIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"DCDocHSTm",iv)
	If m%DCDtH Set iv=..DCDtH If iv'="" Set rc=(..DCDtHIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"DCDtH",iv)
	If m%DCFlag Set iv=..DCFlag If iv'="" Set rc=(..DCFlagIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"DCFlag",iv)
	If m%DCInstH Set iv=..DCInstH If iv'="" Set rc=(..DCInstHIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"DCInstH",iv)
	If m%DCMode Set iv=..DCMode If iv'="" Set rc=(..DCModeIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"DCMode",iv)
	If m%DCModeN Set iv=..DCModeN If iv'="" Set rc=(..DCModeNIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"DCModeN",iv)
	If m%DCNrsH Set iv=..DCNrsH If iv'="" Set rc=(..DCNrsHIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"DCNrsH",iv)
	If m%DCPrvH Set iv=..DCPrvH If iv'="" Set rc=(..DCPrvHIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"DCPrvH",iv)
	If m%DCStat Set iv=..DCStat If iv'="" Set rc=(..DCStatIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"DCStat",iv)
	If m%DCStatN Set iv=..DCStatN If iv'="" Set rc=(..DCStatNIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"DCStatN",iv)
	If m%DCTmH Set iv=..DCTmH If iv'="" Set rc=(..DCTmHIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"DCTmH",iv)
	If m%DCTrgH Set iv=..DCTrgH If iv'="" Set rc=(..DCTrgHIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"DCTrgH",iv)
	If m%DCTrns Set iv=..DCTrns If iv'="" Set rc=(..DCTrnsIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"DCTrns",iv)
	If m%DCTrnsN Set iv=..DCTrnsN If iv'="" Set rc=(..DCTrnsNIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"DCTrnsN",iv)
	If m%DecAdmDt Set iv=..DecAdmDt If iv'="" Set rc=(..DecAdmDtIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"DecAdmDt",iv)
	If m%EDConsult Set iv=..EDConsult If iv'="" Set rc=(..EDConsultIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"EDConsult",iv)
	If m%EDDx Set iv=..EDDx If iv'="" Set rc=(..EDDxIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"EDDx",iv)
	If m%EDProcedure Set iv=..EDProcedure If iv'="" Set rc=(..EDProcedureIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"EDProcedure",iv)
	If m%EDTrans Set iv=..EDTrans If iv'="" Set rc=(..EDTransIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"EDTrans",iv)
	If m%Injury Set iv=..Injury If iv'="" Set rc=(..InjuryIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"Injury",iv)
	If m%ORmDt Set iv=..ORmDt If iv'="" Set rc=(..ORmDtIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"ORmDt",iv)
	If m%ORmTm Set iv=..ORmTm If iv'="" Set rc=(..ORmTmIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"ORmTm",iv)
	If m%OrgRoom Set iv=..OrgRoom If iv'="" Set rc=(..OrgRoomIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"OrgRoom",iv)
	If m%OrgRoomDt Set iv=..OrgRoomDt If iv'="" Set rc=(..OrgRoomDtIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"OrgRoomDt",iv)
	If m%OrgRoomTime Set iv=..OrgRoomTime If iv'="" Set rc=(..OrgRoomTimeIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"OrgRoomTime",iv)
	If m%PrimDx Set iv=..PrimDx If iv'="" Set rc=(..PrimDxIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"PrimDx",iv)
	If m%PrimDxH Set iv=..PrimDxH If iv'="" Set rc=(..PrimDxHIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"PrimDxH",iv)
	If m%PrimDxNarr Set iv=..PrimDxNarr If iv'="" Set rc=(..PrimDxNarrIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"PrimDxNarr",iv)
	If m%PrimICD Set iv=..PrimICD If iv'="" Set rc=(..PrimICDIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"PrimICD",iv)
	If m%PrimPrv Set iv=..PrimPrv If iv'="" Set rc=(..PrimPrvIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"PrimPrv",iv)
	If m%PrimaryNurse Set iv=..PrimaryNurse If iv'="" Set rc=(..PrimaryNurseIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"PrimaryNurse",iv)
	If m%PrmNurse Set iv=..PrmNurse If iv'="" Set rc=(..PrmNurseIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"PrmNurse",iv)
	If m%PtDFN Set iv=..PtDFN If iv'="" Set rc=(..PtDFNIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"PtDFN",iv)
	If m%PtStat Set iv=..PtStat If iv'="" Set rc=(..PtStatIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"PtStat",iv)
	If m%PtStatV Set iv=..PtStatV If iv'="" Set rc=(..PtStatVIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"PtStatV",iv)
	If m%RClDt Set iv=..RClDt If iv'="" Set rc=(..RClDtIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"RClDt",iv)
	If m%RClTm Set iv=..RClTm If iv'="" Set rc=(..RClTmIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"RClTm",iv)
	If m%RecLock Set iv=..RecLock If iv'="" Set rc=(..RecLockIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"RecLock",iv)
	If m%RecLockDT Set iv=..RecLockDT If iv'="" Set rc=(..RecLockDTIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"RecLockDT",iv)
	If m%RecLockSite Set iv=..RecLockSite If iv'="" Set rc=(..RecLockSiteIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"RecLockSite",iv)
	If m%RecLockUser Set iv=..RecLockUser If iv'="" Set rc=(..RecLockUserIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"RecLockUser",iv)
	If m%Room Set iv=..Room If iv'="" Set rc=(..RoomIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"Room",iv)
	If m%RoomClear Set iv=..RoomClear If iv'="" Set rc=(..RoomClearIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"RoomClear",iv)
	If m%RoomDt Set iv=..RoomDt If iv'="" Set rc=(..RoomDtIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"RoomDt",iv)
	If m%RoomDtTm Set iv=..RoomDtTm If iv'="" Set rc=(..RoomDtTmIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"RoomDtTm",iv)
	If m%RoomTime Set iv=..RoomTime If iv'="" Set rc=(..RoomTimeIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"RoomTime",iv)
	If m%VIEN Set iv=..VIEN If iv'="" Set rc=(..VIENIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"VIEN",iv)
	Quit sc }
zCmbDt(cidt,citm) public {
	Set cdt="" I (cidt="")!(citm="") Q cdt
	I (cidt=0)!(citm=0) Q cdt
	I citm=86400 s citm=86299   ;;added 021611  RGB for midnight entry error
	s rpf1=cidt_","_citm s cdt=$TR($$HTE^XLFDT(rpf1,"5Z"),"@"," ") Q cdt }
zGetAM(ptdfn,amervsit) public {
	S arrmd="" I $G(amervsit)]"" S arrmd=$$GETF^BEDDUTIL(9009080,amervsit,.25,"E") Q:arrmd]"" arrmd
	I $G(ptdfn)]"" S arrmd=$$GETF^BEDDUTIL(9009081,ptdfn,6,"E")
	Q arrmd }
zGetAdPvDtm(amervsit,ptdfn) public {
	S fmdt=""
	I $G(ptdfn)]"" S fmdt=$$GETF^BEDDUTIL(9009081,ptdfn,22,"I") Q:fmdt'="" fmdt
	I $G(amervsit)]"" S fmdt=$$GETF^BEDDUTIL(9009080,amervsit,12.1,"I")
	Q fmdt }
zGetAdmPrv(amervsit,ptdfn) public {
	S apr="" I $G(amervsit)'="" S apr=$$GETF^BEDDUTIL(9009080,amervsit,.06,"I") Q:apr]"" apr
	I $G(ptdfn)'="" S apr=$$GETF^BEDDUTIL(9009081,ptdfn,18,"I")
	Q apr }
zGetAge(amervsit,ptdfn) public {
	Q $$AGE^BEDDUTID(ptdfn) }
zGetCC(amervsit,ptdfn) public {
	s ptCC="" I $G(amervsit)'="" S ptCC=$$GETF^BEDDUTIL(9009080,amervsit,1,"E") Q:ptCC]"" ptCC
	I $G(ptdfn)'="" S ptCC=$$GETF^BEDDUTIL(9009081,ptdfn,23,"E")
	Q ptCC }
zGetCIDt(amervsit,ptdfn) public {
	S (cidt,fmdt)="" I amervsit'="" S fmdt=$$GETF^BEDDUTIL(9009080,amervsit,.01,"I") I fmdt]"" S cidt=$$FMTH^XLFDT(fmdt,1)  Q:cidt]"" cidt
	I ptdfn'="" S fmdt=$$GETF^BEDDUTIL(9009081,ptdfn,1,"I") I fmdt]"" S cidt=$$FMTH^XLFDT(fmdt,1)
	Q cidt }
zGetCITm(amervsit,ptdfn) public {
	S (citm,fmdt)="" S fmdt=$$GETF^BEDDUTIL(9009080,amervsit,.01,"I") I fmdt]"" S citm=$P($$FMTH^XLFDT(fmdt),",",2) Q:citm]"" citm
	I ptdfn'="" S fmdt=$$GETF^BEDDUTIL(9009081,ptdfn,1,"I") I fmdt]"" S citm=$P($$FMTH^XLFDT(fmdt),",",2)
	Q citm }
zGetChart(amervsit,ptdfn) public {
	S ptChart="" I $G(ptdfn)'="" S ptChart=$$GETF^BEDDUTIL(9009081,ptdfn,.03,"I") Q:ptChart]"" ptChart
	I $G(amervsit)'="" S ptChart=$$GETF^BEDDUTIL(9009080,amervsit,.13,"I")
	Q ptChart }
zGetCln(amervsit,ptdfn,vien) public {
	S trgC="" I $G(amervsit)'="" S trgC=$$GETF^BEDDUTIL(9009080,amervsit,.04,"I") S:trgC]"" trgC=$$GET1^DIQ(40.7,trgC_",",1,"E") Q:trgC]"" trgC
	I $G(vien)'="" S trgC=$$GETF^BEDDUTIL(9000010,vien,.08,"I") S:trgC]"" trgC=$$GET1^DIQ(40.7,trgC_",",1,"E")
	Q trgC }
zGetDC(amervsit,ptdfn) public {
	s ptDC="" I $G(amervsit)'="" S ptDC1=$$GETF^BEDDUTIL(9009080,amervsit,6.1,"E")
	Q ptDC }
zGetDCDt(amervsit,ptdfn) public {
	Set (dcdt,fmdt)="" I $G(amervsit)'="" S fmdt=$$GETF^BEDDUTIL(9009080,amervsit,6.2,"I") S dcdt=$$FMTH^XLFDT(fmdt,1)
	Q dcdt }
zGetDCDtTm(amervsit,ptdfn) public {
	Set fmdt="" I $G(amervsit)'="" S fmdt=$$GETF^BEDDUTIL(9009080,amervsit,6.2,"I")
	Q fmdt }
zGetDCN(amervsit,ID) public {
	Set dcn="" I $G(amervsit)'="" S dcn=$$GETF^BEDDUTIL(9009080,amervsit,6.4,"I")
	Q dcn }
zGetDCP(amervsit) public {
	Set dcn="" I $G(amervsit)'="" S dcn=$$GETF^BEDDUTIL(9009080,amervsit,6.3,"I")
	Q dcn }
zGetDCTm(amervsit,ptdfn) public {
	Set (dctm,fmdt)="" I $G(amervsit)'="" S fmdt=$$GETF^BEDDUTIL(9009080,amervsit,6.2,"I") S dctm=$P($$FMTH^XLFDT(fmdt),",",2)
	Q dctm }
zGetDOB(ptdfn) public {
	S ptDOB="" I $G(ptdfn)'="" S ptDOB=$$GETF^BEDDUTIL(2,ptdfn,.03,"I")
	S:ptDOB]"" ptDOB=$$FMTE^XLFDT(ptDOB,"2ZD")
	Q ptDOB }
zGetDecAdmit(objid,oldDecAdmit) public {
	Q $$DECADM^BEDDUTL1(objid,oldDecAdmit) }
zGetDisp(amervsit) public {
	Set dcn="" I $G(amervsit)'="" S dcn=$$GETF^BEDDUTIL(9009080,amervsit,6.1,"I")
	Q dcn }
zGetDispN(disp) public {
	S dispName="" I $G(disp)="" Q dispName
	S dispName=$$GETF^BEDDUTIL(9009083,disp,.01,"I") S:dispName="" dispName="Unknown"
	Q dispName }
zGetERCC(amervsit,ptdfn) public {
	Set ercc="" I $G(amervsit)'="" S ercc=$$GETF^BEDDUTIL(9009080,amervsit,1,"E")
	Q ercc }
zGetFinA(amervsit) public {
	S trgA="" I amervsit'="" S trgA=$$GETF^BEDDUTIL(9009080,amervsit,5.4,"E")
	Q trgA }
zGetICDN(icd) public {
	S ICDN="" I $G(icd)'="" S ICDN=$$GETF^BEDDUTIL(80,icd,.01,"I")
	Q ICDN }
zGetInd(objid) public {
	Set ptind="" Set ptind=$$IND^BEDDUTIL(objid)
	Q ptind }
zGetInjC(objid) public {
	S ptinjury=$$INJCAUSE^BEDDUTL(objid)
	Q ptinjury }
zGetInjS(objid) public {
	S ptinjstg=$$INJSTG^BEDDUTL(objid)
	Q ptinjstg }
zGetInstN(ien) public {
	S instN="" I $G(ien)'="" S instN=$$GETF^BEDDUTIL(9009083,ien,.01,"I")
	Q instN }
zGetName(ptDFN) public {
	S PtName=""
	I $G(ptDFN)]"" S PtName=$$GETF^BEDDUTIL(2,ptDFN,.01,"E") I PtName="" S PtName="PATIENT NOT REGISTERED"
	Q PtName }
zGetOcc(objid) public {
	Set ptocc="" Set ptocc=$$OCC^BEDDUTIL(objid)
	Q ptocc }
zGetPrimN(dxn) public {
	S DXNm="" I $G(dxn)'="" S DXNm=$$GETF^BEDDUTIL(9999999.27,dxn,.01,"I")
	Q DXNm }
zGetProvN(prv) public {
	S prvName="" I +$G(prv)=0 Q prvName
	I prv>0 S prvName=$$GETF^BEDDUTIL(200,prv,.01,"E") I prvName="" S prvName="Unknown Provider name"
	Q prvName }
zGetPtComplaint(ptDFN,amervsit) public {
	S ptComplaint="" 
	I $G(ptDFN)]""  S ptComplaint=$$GETF^BEDDUTIL(9009081,ptDFN,23,"E") Q:ptComplaint]"" ptComplaint
	I $G(amervsit)]"" S ptComplaint=$$GETF^BEDDUTIL(9009080,amervsit,1,"E")
	Q ptComplaint }
zGetPtStat(id,ptDFN,room,dcflag,amervsit,dcdoch,trga) public {
	S ptstat=9 I dcflag=1 Q ptstat
	S ptstat=8 I dcdoch=1 Q ptstat
	I ptDFN="" S ptstat=9 Q ptstat
	I $$GETF^BEDDUTIL(9009081,ptDFN,.01,"I")]"" D
	. S ptstat=1
	. S:trga'="" ptstat=2
	. S:room'="" ptstat=3
	. I room="",$P($$RMLST^BEDDUTW(id),"^",2)]"" S ptstat=4
	Q ptstat }
zGetPtStatN(ptstat) public {
	s ptsn="" I ptstat=0 s ptsn="unknown"
	I ptstat=1 s ptsn="Check-in waiting on Triage"
	I ptstat=2 S ptsn="Triaged waiting on Room"
	I ptstat=3 S ptsn="Room"
	I ptstat=9 S ptsn="Discharged"
	Q ptsn }
zGetSex(ptdfn) public {
	S ptSex="" I $G(ptdfn)'="" S ptSex=$$GETF^BEDDUTIL(2,ptdfn,.02,"I")
	Q ptSex }
zGetTrgA(amervsit,ptdfn) public {
	S trgA="" I amervsit'="" S trgA=$$GETF^BEDDUTIL(9009080,amervsit,.24,"E") Q:trgA]"" trgA
	I ptdfn'="" S trgA=$$GETF^BEDDUTIL(9009081,ptdfn,20,"E")
	Q trgA }
zGetTrgC(amervsit,vien) public {
	S trgC="" I $G(amervsit)'="" S trgC=$$GETF^BEDDUTIL(9009080,amervsit,.04,"I") S:trgC]"" trgC=$$GETF^BEDDUTIL(9009083,trgC_",",5) Q:trgC]"" trgC
	I $G(vien)'="" S trgC=$$GETF^BEDDUTIL(9000010,vien,.08,"I")
	Q trgC }
zGetTrgDt(amervsit,ptdfn) public {
	S trgDt=""
	I $G(ptdfn)]"" S fmdt=$$GETF^BEDDUTIL(9009081,ptdfn,21,"I") I fmdt'="" S trgDt=$$FMTH^XLFDT(fmdt,1) Q:trgDt]"" trgDt
	I $G(amervsit)]"" S fmdt=$$GETF^BEDDUTIL(9009080,amervsit,12.2,"I") I fmdt'="" S trgDt=$$FMTH^XLFDT(fmdt,1)
	Q trgDt }
zGetTrgDtTm(amervsit,ptdfn) public {
	S trgdttm=""
	I $G(ptdfn)]"" S trgdttm=$$GETF^BEDDUTIL(9009081,ptdfn,21,"I") Q:trgdttm]"" trgdttm
	I $G(amervsit)]"" S trgdttm=$$GETF^BEDDUTIL(9009080,amervsit,12.2,"I")
	Q trgdttm }
zGetTrgN(amervsit,ptdfn) public {
	S trgN="" I $G(amervsit)'="" S trgN=$$GETF^BEDDUTIL(9009080,amervsit,.07,"I") Q:trgN]"" trgN
	I $G(ptdfn)'="" S trgN=$$GETF^BEDDUTIL(9009081,ptdfn,19,"I")
	Q trgN }
zGetTrgTm(amervsit,ptdfn) public {
	S trgT="" I $G(amervsit)'="" S fmdt=$$GETF^BEDDUTIL(9009080,amervsit,12.2,"I") I fmdt'="" S trgT=$P($$FMTH^XLFDT(fmdt),",",2) Q:trgT]"" trgT
	I $G(ptdfn)'="" S fmdt=$$GETF^BEDDUTIL(9009081,ptdfn,21,"I") I fmdt'="" S trgT=$P($$FMTH^XLFDT(fmdt),",",2)
	Q trgT }
zGetVD(amervsit) public {
	S ervd="" I $G(amervsit)'="" S ervd=$$GETF^BEDDUTIL(9009080,amervsit,12.5,"I")
	Q ervd }
zGetWtg(id,ptstat,cidt,citm,tdt,ttm,rdt,rtm,cldt,cltm) public {
	s ptwtg=0 Q:ptstat=9 ptwtg
	I ptstat=1 s ptwtg=$$MINWTG^BEDDUTIL(cidt,citm)
	I ptstat=2 S ptwtg=$$MINWTG^BEDDUTIL(tdt,ttm)
	I ptstat=3 S ptwtg=$$MINWTG^BEDDUTIL(rdt,rtm)
	I ptstat=4 S ptwtg=$$MINWTG^BEDDUTIL(cldt,cltm)
	Q ptwtg }
zAMERVSITGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),2),1:"") }
zAdPvDtmCompute(%id,%d1,%d2)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDVISIT).GetAdPvDtm(%d1,%d2)
	} catch %tException { throw %tException }
	Quit %val
zAdPvDtmDisplayToLogical(%val) public {
 q:%val="" "" set %val=$zdh(%val,,,5,80,20,,,"Error: '"_%val_"' is an invalid DISPLAY Date value") q:%val||(%val=0) %val s %msg=%val ZTRAP "ODAT" }
zAdPvDtmGet() public {
	Quit ..AdPvDtmCompute($listget(i%"%%OID"),..AMERVSIT,..PtDFN) }
zAdPvDtmIsValid(%val) public {
	Q $s($zu(115,13)&&(%val=$c(0)):1,$isvalidnum(%val,0,0,):1,'$isvalidnum(%val):$$Error^%apiOBJ(7207,%val),1:$$Error^%apiOBJ(7204,%val,0)) }
zAdPvDtmLogicalToDisplay(%val) public {
	quit $select(%val="":"",%val'["-":$zdate(%val,,,4),1:$$FormatJulian^%qarfunc(%val,-1)) }
zAdPvDtmLogicalToOdbc(%val="") public {
	Quit $select(%val="":"",%val'["-":$zdate(%val,3),1:%val) }
zAdPvDtmNormalize(%val) public {
	Quit $s($zu(115,13)&&(%val=$c(0)):"",1:%val\1) }
zAdPvDtmOdbcToLogical(%val="") public {
 quit:%val=""||($zu(115,13)&&(%val=$c(0))) "" set %val=$zdh(%val,3,,,,,,,"Error: '"_%val_"' is an invalid ODBC/JDBC Date value") q:%val||(%val=0) %val s %msg=%val ZTRAP "ODAT" }
zAdPvDtmSQLCompute()
	// Compute code for field AdPvDtm
 Set %d(3)=##class(BEDD.EDVISIT).GetAdPvDtm($g(%d(2)),$g(%d(81)))
 QUIT
zAdmPrvCompute(%id,%d1,%d2)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDVISIT).GetAdmPrv(%d1,%d2) 
	} catch %tException { throw %tException }
	Quit %val
zAdmPrvGet() public {
	Quit ..AdmPrvCompute($listget(i%"%%OID"),..AMERVSIT,..PtDFN) }
zAdmPrvSQLCompute()
	// Compute code for field AdmPrv
 Set %d(4)=##class(BEDD.EDVISIT).GetAdmPrv($g(%d(2)),$g(%d(81))) 
 QUIT
zAdmPrvNCompute(%id,%d1)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDVISIT).GetProvN(%d1) 
	} catch %tException { throw %tException }
	Quit %val
zAdmPrvNGet() public {
	Quit ..AdmPrvNCompute($listget(i%"%%OID"),..AdmPrv) }
zAdmPrvNSQLCompute()
	// Compute code for field AdmPrvN
 Set %d(5)=##class(BEDD.EDVISIT).GetProvN($g(%d(4))) 
 QUIT
zAgeCompute(%id,%d1,%d2)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDVISIT).GetAge(%d1,%d2)
	} catch %tException { throw %tException }
	Quit %val
zAgeGet() public {
	Quit ..AgeCompute($listget(i%"%%OID"),..AMERVSIT,..PtDFN) }
zAgeSQLCompute()
	// Compute code for field Age
 Set %d(6)=##class(BEDD.EDVISIT).GetAge($g(%d(2)),$g(%d(81)))
 QUIT
zArrModeCompute(%id,%d1,%d2)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDVISIT).GetAM(%d2,%d1)
	} catch %tException { throw %tException }
	Quit %val
zArrModeGet() public {
	Quit ..ArrModeCompute($listget(i%"%%OID"),..AMERVSIT,..PtDFN) }
zArrModeSQLCompute()
	// Compute code for field ArrMode
 Set %d(7)=##class(BEDD.EDVISIT).GetAM($g(%d(81)),$g(%d(2)))
 QUIT
zAsgClnGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),3),1:"") }
zAsgNrsGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),4),1:"") }
zAsgNrsNCompute(%id,%d1)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDVISIT).GetProvN(%d1) 
	} catch %tException { throw %tException }
	Quit %val
zAsgNrsNGet() public {
	Quit ..AsgNrsNCompute($listget(i%"%%OID"),..AsgNrs) }
zAsgNrsNSQLCompute()
	// Compute code for field AsgNrsN
 Set %d(10)=##class(BEDD.EDVISIT).GetProvN($g(%d(9))) 
 QUIT
zAsgPrvGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),5),1:"") }
zAsgPrvNCompute(%id,%d1)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDVISIT).GetProvN(%d1) 
	} catch %tException { throw %tException }
	Quit %val
zAsgPrvNGet() public {
	Quit ..AsgPrvNCompute($listget(i%"%%OID"),..AsgPrv) }
zAsgPrvNSQLCompute()
	// Compute code for field AsgPrvN
 Set %d(12)=##class(BEDD.EDVISIT).GetProvN($g(%d(11))) 
 QUIT
zCIDtCompute(%id,%d1,%d2)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDVISIT).GetCIDt(%d1,%d2) 
	} catch %tException { throw %tException }
	Quit %val
zCIDtGet() public {
	Quit ..CIDtCompute($listget(i%"%%OID"),..AMERVSIT,..PtDFN) }
zCIDtSQLCompute()
	// Compute code for field CIDt
 Set %d(13)=##class(BEDD.EDVISIT).GetCIDt($g(%d(2)),$g(%d(81))) 
 QUIT
zCITmCompute(%id,%d1,%d2)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDVISIT).GetCITm(%d1,%d2) 
	} catch %tException { throw %tException }
	Quit %val
zCITmDisplayToLogical(%val)
 quit:%val="" "" s %val=$ztimeh(%val,,"Error: '"_%val_"' is an invalid DISPLAY Time value") q:%val||(%val=0) %val s %msg=%val ZTRAP "OTIM"
	Quit
zCITmGet() public {
	Quit ..CITmCompute($listget(i%"%%OID"),..AMERVSIT,..PtDFN) }
zCITmIsValid(%val)
	Quit $select($zu(115,13)&&(%val=$c(0)):1,$isvalidnum(%val,,0,86400)&&(%val'=86400):1,'$isvalidnum(%val):$$Error^%apiOBJ(7207,%val),%val<0:$$Error^%apiOBJ(7204,%val,0),1:$$Error^%apiOBJ(7203,%val,86400))
zCITmLogicalToDisplay(%val)
	Quit $select(%val="":"",1:$ztime(%val))
zCITmLogicalToOdbc(%val="")
	Quit $select(%val="":"",1:$ztime(%val))
zCITmNormalize(%val)
	Quit $select($zu(115,13)&&(%val=$c(0)):"",1:%val)
zCITmOdbcToLogical(%val="")
 quit:%val=""||($zu(115,13)&&(%val=$c(0))) "" s %val=$ztimeh(%val,,"Error: '"_%val_"' is an invalid ODBC/JDBC Time value") q:%val||(%val=0) %val s %msg=%val ZTRAP "OTIM"
	Quit
zCITmSQLCompute()
	// Compute code for field CITm
 Set %d(14)=##class(BEDD.EDVISIT).GetCITm($g(%d(2)),$g(%d(81))) 
 QUIT
zChartCompute(%id,%d1,%d2)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDVISIT).GetChart(%d1,%d2) 
	} catch %tException { throw %tException }
	Quit %val
zChartGet() public {
	Quit ..ChartCompute($listget(i%"%%OID"),..AMERVSIT,..PtDFN) }
zChartSQLCompute()
	// Compute code for field Chart
 Set %d(15)=##class(BEDD.EDVISIT).GetChart($g(%d(2)),$g(%d(81))) 
 QUIT
zClinicGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),41),1:"") }
zCodeBlueGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),6),1:"") }
zComplaintCompute(%id,%d1,%d2)
	New %tException,%val set %val = ""
	try {
	 Set %val = ##class(BEDD.EDVISIT).GetPtComplaint(%d2,%d1)
	} catch %tException { throw %tException }
	Quit %val
zComplaintGet() public {
	Quit ..ComplaintCompute($listget(i%"%%OID"),..AMERVSIT,..PtDFN) }
zComplaintSQLCompute()
	// Compute code for field Complaint
 Set %d(18) = ##class(BEDD.EDVISIT).GetPtComplaint($g(%d(81)),$g(%d(2)))
 QUIT
zDCDPrvHGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),11),1:"") }
zDCDPrvHNCompute(%id,%d1)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDVISIT).GetProvN(%d1) 
	} catch %tException { throw %tException }
	Quit %val
zDCDPrvHNGet() public {
	Quit ..DCDPrvHNCompute($listget(i%"%%OID"),..DCDPrvH) }
zDCDPrvHNSQLCompute()
	// Compute code for field DCDPrvHN
 Set %d(20)=##class(BEDD.EDVISIT).GetProvN($g(%d(19))) 
 QUIT
zDCDispHGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),12),1:"") }
zDCDocHDisplayToLogical(%val) public {
	Q $s(%val="":"",$zu(115,13)&&(%val=$c(0)):"",1:+$in(%val,"",%val)) }
zDCDocHGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),42),1:"") }
zDCDocHIsValid(%val) public {
	Quit $select($zu(115,13)&&(%val=$c(0)):1,$isvalidnum(%val,0,,):1,1:$$Error^%apiOBJ(7207,%val)) }
zDCDocHNormalize(%val) public {
	Quit $select($zu(115,13)&&(%val=$c(0)):"",1:%val\1) }
zDCDocHSet(newvalue) public {
	If i%DCDocH'=newvalue {
		Set i%DCDocH=newvalue
		Set i%PtStat="" If ..PtStat
	}
	Quit 1 }
zDCDocHEDtGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),53),1:"") }
zDCDocHETmGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),54),1:"") }
zDCDocHSDtGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),51),1:"") }
zDCDocHSTmGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),52),1:"") }
zDCDtCompute(%id,%d1)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDVISIT).GetDCDt(%d1)
	} catch %tException { throw %tException }
	Quit %val
zDCDtGet() public {
	Quit ..DCDtCompute($listget(i%"%%OID"),..AMERVSIT) }
zDCDtSQLCompute()
	// Compute code for field DCDt
 Set %d(27)=##class(BEDD.EDVISIT).GetDCDt($g(%d(2)))
 QUIT
zDCDtHGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),7),1:"") }
zDCDtTmCompute(%id,%d1)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDVISIT).GetDCDtTm(%d1)
	} catch %tException { throw %tException }
	Quit %val
zDCDtTmGet() public {
	Quit ..DCDtTmCompute($listget(i%"%%OID"),..AMERVSIT) }
zDCDtTmSQLCompute()
	// Compute code for field DCDtTm
 Set %d(29)=##class(BEDD.EDVISIT).GetDCDtTm($g(%d(2)))
 QUIT
zDCFlagGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),17),1:"") }
zDCFlagSet(newvalue) public {
	If i%DCFlag'=newvalue {
		Set i%DCFlag=newvalue
		Set i%PtStat="" If ..PtStat
	}
	Quit 1 }
zDCInstHGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),13),1:"") }
zDCInstHNCompute(%id,%d1)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDVISIT).GetInstN(%d1) 
	} catch %tException { throw %tException }
	Quit %val
zDCInstHNGet() public {
	Quit ..DCInstHNCompute($listget(i%"%%OID"),..DCInstH) }
zDCInstHNSQLCompute()
	// Compute code for field DCInstHN
 Set %d(32)=##class(BEDD.EDVISIT).GetInstN($g(%d(31))) 
 QUIT
zDCModeGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),36),1:"") }
zDCModeNGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),37),1:"") }
zDCNrsCompute(%id,%d1)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDVISIT).GetDCN(%d1,%id)
	} catch %tException { throw %tException }
	Quit %val
zDCNrsGet() public {
	Quit ..DCNrsCompute($listget(i%"%%OID"),..AMERVSIT) }
zDCNrsSQLCompute()
	// Compute code for field DCNrs
 Set %d(35)=##class(BEDD.EDVISIT).GetDCN($g(%d(2)),%d(1))
 QUIT
zDCNrsHGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),9),1:"") }
zDCNrsNCompute(%id,%d1)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDVISIT).GetProvN(%d1) 
	} catch %tException { throw %tException }
	Quit %val
zDCNrsNGet() public {
	Quit ..DCNrsNCompute($listget(i%"%%OID"),..DCNrs) }
zDCNrsNSQLCompute()
	// Compute code for field DCNrsN
 Set %d(37)=##class(BEDD.EDVISIT).GetProvN($g(%d(35))) 
 QUIT
zDCPrvCompute(%id,%d1)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDVISIT).GetDCP(%d1) 
	} catch %tException { throw %tException }
	Quit %val
zDCPrvGet() public {
	Quit ..DCPrvCompute($listget(i%"%%OID"),..AMERVSIT) }
zDCPrvSQLCompute()
	// Compute code for field DCPrv
 Set %d(38)=##class(BEDD.EDVISIT).GetDCP($g(%d(2))) 
 QUIT
zDCPrvHGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),10),1:"") }
zDCPrvNCompute(%id,%d1)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDVISIT).GetProvN(%d1) 
	} catch %tException { throw %tException }
	Quit %val
zDCPrvNGet() public {
	Quit ..DCPrvNCompute($listget(i%"%%OID"),..DCPrv) }
zDCPrvNSQLCompute()
	// Compute code for field DCPrvN
 Set %d(40)=##class(BEDD.EDVISIT).GetProvN($g(%d(38))) 
 QUIT
zDCStatGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),15),1:"") }
zDCStatNGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),16),1:"") }
zDCTmCompute(%id,%d1)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDVISIT).GetDCTm(%d1)
	} catch %tException { throw %tException }
	Quit %val
zDCTmGet() public {
	Quit ..DCTmCompute($listget(i%"%%OID"),..AMERVSIT) }
zDCTmSQLCompute()
	// Compute code for field DCTm
 Set %d(43)=##class(BEDD.EDVISIT).GetDCTm($g(%d(2)))
 QUIT
zDCTmHGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),8),1:"") }
zDCTrgHGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),14),1:"") }
zDCTrnsGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),34),1:"") }
zDCTrnsNGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),35),1:"") }
zDOBCompute(%id,%d1)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDVISIT).GetDOB(%d1)
	} catch %tException { throw %tException }
	Quit %val
zDOBGet() public {
	Quit ..DOBCompute($listget(i%"%%OID"),..PtDFN) }
zDOBSQLCompute()
	// Compute code for field DOB
 Set %d(48)=##class(BEDD.EDVISIT).GetDOB($g(%d(81)))
 QUIT
zDecAdmDtGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),64),1:"") }
zDispNCompute(%id,%d1)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDVISIT).GetDispN(%d1)
	} catch %tException { throw %tException }
	Quit %val
zDispNGet() public {
	Quit ..DispNCompute($listget(i%"%%OID"),..Disposition) }
zDispNSQLCompute()
	// Compute code for field DispN
 Set %d(50)=##class(BEDD.EDVISIT).GetDispN($g(%d(51)))
 QUIT
zDispositionCompute(%id,%d1)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDVISIT).GetDisp(%d1)
	} catch %tException { throw %tException }
	Quit %val
zDispositionGet() public {
	Quit ..DispositionCompute($listget(i%"%%OID"),..AMERVSIT) }
zDispositionSQLCompute()
	// Compute code for field Disposition
 Set %d(51)=##class(BEDD.EDVISIT).GetDisp($g(%d(2)))
 QUIT
zEDConsultGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),18),1:"") }
zEDDxGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),21),1:"") }
zEDProcedureGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),19),1:"") }
zEDTransGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),20),1:"") }
zFinACompute(%id,%d1)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDVISIT).GetFinA(%d1)
	} catch %tException { throw %tException }
	Quit %val
zFinAGet() public {
	Quit ..FinACompute($listget(i%"%%OID"),..AMERVSIT) }
zFinASQLCompute()
	// Compute code for field FinA
 Set %d(56)=##class(BEDD.EDVISIT).GetFinA($g(%d(2)))
 QUIT
zIndustryCompute(%id)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDVISIT).GetInd(%id)
	} catch %tException { throw %tException }
	Quit %val
zIndustryGet() public {
	Quit ..IndustryCompute($listget(i%"%%OID")) }
zIndustrySQLCompute()
	// Compute code for field Industry
 Set %d(57)=##class(BEDD.EDVISIT).GetInd(%d(1))
 QUIT
zInfoDelete(streamvalue) public {
	Set $ZTrap = "CatchError"
	Quit $select(streamvalue="":$$Error^%apiOBJ(5813,$classname()),1:##class(%Library.GlobalCharacterStream).%Delete($select(streamvalue="":"",1:$listbuild($listget(streamvalue),$listget(streamvalue,2),"^BEDD.EDVISITS"))))
CatchError	Set $ZTrap=""
	Quit $$Error^%apiOBJ(5002,$zerror) }
zInfoGetObject(force=0) public {
	Quit:r%Info="" $select(i%Info="":"",1:$listbuild($listget(i%Info),$listget(i%Info,2),"^BEDD.EDVISITS")) Quit:(''..Info.%GetSwizzleObject(force,.oid)) oid Quit "" }
zInfoGetObjectId(force=0) public {
	Quit $listget(..InfoGetObject(force)) }
zInfoGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),24),1:"") }
zInfoGetSwizzled() public {
	If i%Info="" Set modstate=$system.CLS.GetSModifiedBits() Set oref=..InfoNewObject("") Do $system.CLS.SetSModifiedBits(modstate) Set r%Info=0,r%Info=oref Quit oref
	Set oref=##class(%Library.GlobalCharacterStream).%Open($select(i%Info="":"",1:$listbuild($listget(i%Info),$listget(i%Info,2),"^BEDD.EDVISITS")),,.sc) If ('sc) Do:$get(^%SYS("ThrowSwizzleError"),0) $zutil(96,3,19,1) Quit ""
	Set modstate=$system.CLS.GetModifiedBits() Set r%Info=oref Do $system.CLS.SetModifiedBits(modstate)
	Quit oref }
zInfoNewObject(type="") public {
	Set $ZTrap = "CatchError"
	Set sc=1
	If type="" {
		Set type = "%Library.GlobalCharacterStream"
	} ElseIf '($classmethod(type,"%IsA","%Library.GlobalCharacterStream")) {
		Set sc=$$Error^%apiOBJ(5833,"BEDD.EDVISIT","Info") Quit ""
	}
	Set newobject=$classmethod(type,"%New","^BEDD.EDVISITS") If newobject="" Quit ""
	Set r%Info=0,i%Info=0,r%Info=newobject,i%Info=""
	Quit newobject
CatchError	Set $ZTrap=""
	If (''sc) Set sc = $$Error^%apiOBJ(5002,$ze)
	Quit "" }
zInfoOid(streamvalue) public {
	Quit $s($isobject(streamvalue):streamvalue.%Oid(),1:$select(streamvalue="":"",1:$listbuild($listget(streamvalue),$listget(streamvalue,2),"^BEDD.EDVISITS"))) }
zInfoOpen(streamvalue) public {
	If $get(streamvalue)="" {
		Set object=##class(%Library.GlobalCharacterStream).%New("^BEDD.EDVISITS")
	} elseif $isobject(streamvalue)=1 { set object = streamvalue }
	else {
		Set object=##class(%Library.GlobalCharacterStream).%Open($select(streamvalue="":"",1:$listbuild($listget(streamvalue),$listget(streamvalue,2),"^BEDD.EDVISITS")))
		If $isobject(object)=1,object.IsNull()=1 Quit ""
	}
	Quit object }
zInfoSet(newvalue) public {
	If newvalue="" Set r%Info=0,i%Info=0,r%Info="",i%Info="" Quit 1
	If '$isobject(newvalue) Quit $$Error^%apiOBJ(5807,newvalue)
	If newvalue=r%Info Quit 1
	If newvalue.%Extends("%AbstractStream") {
		Set r%Info=0,i%Info=0,r%Info=newvalue,i%Info=""
	} Else {
		Do ..Info.Rewind()
		Quit ..Info.CopyFrom(newvalue)
	}
	Quit 1 }
zInfoSetObject(newvalue) public {
	Set i%Info=0,r%Info=0,i%Info=newvalue,r%Info=""
	Quit 1 }
zInfoSetObjectId(newid) public {
	Quit ..InfoSetObject($select(newid="":"",1:$listbuild(newid_""))) }
zInfoUnSwizzle(force=0) public {
	If r%Info="" Quit 1
	Set sc=..Info.%GetSwizzleObject(force,.newvalue) Quit:('sc) sc
	Set modstate=$system.CLS.GetModifiedBits() Set r%Info="" Do $system.CLS.SetModifiedBits(modstate)
	Set i%Info=newvalue
	Quit 1 }
zInjCCompute(%id)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDVISIT).GetInjC(%id)
	} catch %tException { throw %tException }
	Quit %val
zInjCGet() public {
	Quit ..InjCCompute($listget(i%"%%OID")) }
zInjCSQLCompute()
	// Compute code for field InjC
 Set %d(59)=##class(BEDD.EDVISIT).GetInjC(%d(1))
 QUIT
zInjSCompute(%id)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDVISIT).GetInjS(%id)
	} catch %tException { throw %tException }
	Quit %val
zInjSGet() public {
	Quit ..InjSCompute($listget(i%"%%OID")) }
zInjSSQLCompute()
	// Compute code for field InjS
 Set %d(60)=##class(BEDD.EDVISIT).GetInjS(%d(1))
 QUIT
zInjuryGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),25),1:"") }
zNewDecAdmitCompute(%id,%d1)
	New %tException,%val set %val = ""
	try {
	 Set %val = ##class(BEDD.EDVISIT).GetDecAdmit(%id,%d1)
	} catch %tException { throw %tException }
	Quit %val
zNewDecAdmitGet() public {
	Quit ..NewDecAdmitCompute($listget(i%"%%OID"),..DecAdmDt) }
zNewDecAdmitSQLCompute()
	// Compute code for field NewDecAdmit
 Set %d(62) = ##class(BEDD.EDVISIT).GetDecAdmit(%d(1),$g(%d(49)))
 QUIT
zORmDtGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),57),1:"") }
zORmTmGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),58),1:"") }
zOccupationCompute(%id)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDVISIT).GetOcc(%id)
	} catch %tException { throw %tException }
	Quit %val
zOccupationGet() public {
	Quit ..OccupationCompute($listget(i%"%%OID")) }
zOccupationSQLCompute()
	// Compute code for field Occupation
 Set %d(65)=##class(BEDD.EDVISIT).GetOcc(%d(1))
 QUIT
zOrgRoomGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),38),1:"") }
zOrgRoomDtGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),39),1:"") }
zOrgRoomTimeGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),40),1:"") }
zPrimDxGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),22),1:"") }
zPrimDxHGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),32),1:"") }
zPrimDxNCompute(%id,%d1)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDVISIT).GetPrimN(%d1)
	} catch %tException { throw %tException }
	Quit %val
zPrimDxNGet() public {
	Quit ..PrimDxNCompute($listget(i%"%%OID"),..PrimDx) }
zPrimDxNSQLCompute()
	// Compute code for field PrimDxN
 Set %d(71)=##class(BEDD.EDVISIT).GetPrimN($g(%d(69)))
 QUIT
zPrimDxNarrGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),55),1:"") }
zPrimICDGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),23),1:"") }
zPrimICDNCompute(%id,%d1)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDVISIT).GetICDN(%d1)
	} catch %tException { throw %tException }
	Quit %val
zPrimICDNGet() public {
	Quit ..PrimICDNCompute($listget(i%"%%OID"),..PrimICD) }
zPrimICDNSQLCompute()
	// Compute code for field PrimICDN
 Set %d(74)=##class(BEDD.EDVISIT).GetICDN($g(%d(73)))
 QUIT
zPrimPrvGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),33),1:"") }
zPrimPrvNCompute(%id,%d1)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDVISIT).GetProvN(%d1) 
	} catch %tException { throw %tException }
	Quit %val
zPrimPrvNGet() public {
	Quit ..PrimPrvNCompute($listget(i%"%%OID"),..PrimPrv) }
zPrimPrvNSQLCompute()
	// Compute code for field PrimPrvN
 Set %d(76)=##class(BEDD.EDVISIT).GetProvN($g(%d(75))) 
 QUIT
zPrimaryNurseGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),59),1:"") }
zPrmNurseGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),63),1:"") }
zPtCIDTCompute(%id,%d1,%d2)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDVISIT).CmbDt(%d1,%d2)
	} catch %tException { throw %tException }
	Quit %val
zPtCIDTGet() public {
	Quit ..PtCIDTCompute($listget(i%"%%OID"),..CIDt,..CITm) }
zPtCIDTSQLCompute()
	// Compute code for field PtCIDT
 Set %d(79)=##class(BEDD.EDVISIT).CmbDt($g(%d(13)),$g(%d(14)))
 QUIT
zPtDCDTCompute(%id,%d1,%d2)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDVISIT).CmbDt(%d1,%d2)
	} catch %tException { throw %tException }
	Quit %val
zPtDCDTGet() public {
	Quit ..PtDCDTCompute($listget(i%"%%OID"),..DCDt,..DCTm) }
zPtDCDTSQLCompute()
	// Compute code for field PtDCDT
 Set %d(80)=##class(BEDD.EDVISIT).CmbDt($g(%d(27)),$g(%d(43)))
 QUIT
zPtDFNGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),27),1:"") }
zPtInjuryGetObject(force=0) public {
	Quit $select(r%PtInjury=""&&($data(i%PtInjury)):$select(i%PtInjury="":"",1:$listbuild(i%PtInjury_"")),(''..PtInjury.%GetSwizzleObject(force,.oid)):oid,1:"") }
zPtInjuryGetObjectId(force=0) public {
	Quit $listget(..PtInjuryGetObject(force)) }
zPtInjuryGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),26),1:"") }
zPtInjuryGetSwizzled() public {
	If '$data(i%PtInjury) Set modstate=$system.CLS.GetSModifiedBits() Set oref=..PtInjuryNewObject() Do $system.CLS.SetSModifiedBits(modstate) Set r%PtInjury=0,r%PtInjury=oref Quit oref
	Set oref=##class(BEDD.EDInjury).%Open($select(i%PtInjury="":"",1:$listbuild(i%PtInjury_"")),,.sc) If ('sc) Do:$get(^%SYS("ThrowSwizzleError"),0) $zutil(96,3,19,1) Quit ""
	Set modstate=$system.CLS.GetModifiedBits() Set r%PtInjury=oref Do $system.CLS.SetModifiedBits(modstate)
	Quit oref }
zPtInjuryNewObject() public {
	Set newobject=##class(BEDD.EDInjury).%New() If newobject="" Quit ""
	Set ..PtInjury=newobject
	Quit newobject }
zPtInjurySet(newvalue) public {
	If newvalue="" {
		Kill i%PtInjury,r%PtInjury Set r%PtInjury=""
	} Else {
		If '$isobject(newvalue) { Quit $$Error^%apiOBJ(5807,newvalue) } If r%PtInjury=newvalue { Quit 1 }
		Set r%PtInjury=0,i%PtInjury=0,r%PtInjury=newvalue,i%PtInjury=""
	}
	Quit 1 }
zPtInjurySetObject(newvalue) public {
	Set i%PtInjury=0,r%PtInjury=0,i%PtInjury=$listget(newvalue),r%PtInjury=""
	Quit 1 }
zPtInjurySetObjectId(newid) public {
	Quit ..PtInjurySetObject($select(newid="":"",1:$listbuild(newid_""))) }
zPtInjuryUnSwizzle(force=0) public {
	If r%PtInjury="",$data(i%PtInjury) Quit 1
	Set sc=..PtInjury.%GetSwizzleObject(force,.newvalue) Quit:('sc) sc
	Set modstate=$system.CLS.GetModifiedBits() Set r%PtInjury="" Do $system.CLS.SetModifiedBits(modstate)
	Set i%PtInjury=$listget(newvalue)
	Quit 1 }
zPtNameCompute(%id,%d1)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDVISIT).GetName(%d1)
	} catch %tException { throw %tException }
	Quit %val
zPtNameGet() public {
	Quit ..PtNameCompute($listget(i%"%%OID"),..PtDFN) }
zPtNameSQLCompute()
	// Compute code for field PtName
 Set %d(83)=##class(BEDD.EDVISIT).GetName($g(%d(81)))
 QUIT
zPtStatCompute(%id,%d1,%d2,%d3,%d4,%d5,%d6,%d7)
	New %tException,%val set %val = %d5
	try {
	 Set %val=##class(BEDD.EDVISIT).GetPtStat(%id,%d4,%d6,%d3,%d1,%d2,%d7)
	} catch %tException { throw %tException }
	Quit %val
zPtStatGet() public {
	If i%PtStat = "" { Set ..PtStat=..PtStatCompute($listget(i%"%%OID"),..AMERVSIT,..DCDocH,..DCFlag,..PtDFN,i%PtStat,..Room,..TrgA) } Quit i%PtStat }
zPtStatGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),43),1:"") }
zPtStatSQLCompute()
	// Compute code for field PtStat
 Set %d(84)=##class(BEDD.EDVISIT).GetPtStat(%d(1),$g(%d(81)),$g(%d(95)),$g(%d(30)),$g(%d(2)),$g(%d(22)),$g(%d(101)))
 QUIT
zPtStatICompute(%id,%d1,%d2,%d3,%d4,%d5,%d6)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDVISIT).GetPtStat(%id,%d4,%d5,%d3,%d1,%d2,%d6)
	} catch %tException { throw %tException }
	Quit %val
zPtStatIGet() public {
	Quit ..PtStatICompute($listget(i%"%%OID"),..AMERVSIT,..DCDocH,..DCFlag,..PtDFN,..Room,..TrgA) }
zPtStatISQLCompute()
	// Compute code for field PtStatI
 Set %d(85)=##class(BEDD.EDVISIT).GetPtStat(%d(1),$g(%d(81)),$g(%d(95)),$g(%d(30)),$g(%d(2)),$g(%d(22)),$g(%d(101)))
 QUIT
zPtStatNCompute(%id,%d1)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDVISIT).GetPtStatN(%d1)
	} catch %tException { throw %tException }
	Quit %val
zPtStatNGet() public {
	Quit ..PtStatNCompute($listget(i%"%%OID"),..PtStatI) }
zPtStatNSQLCompute()
	// Compute code for field PtStatN
 Set %d(86)=##class(BEDD.EDVISIT).GetPtStatN($g(%d(85)))
 QUIT
zPtStatVGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),48),1:"") }
zPtTrgDTCompute(%id,%d1,%d2)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDVISIT).CmbDt(%d1,%d2)
	} catch %tException { throw %tException }
	Quit %val
zPtTrgDTGet() public {
	Quit ..PtTrgDTCompute($listget(i%"%%OID"),..TrgDt,..TrgTm) }
zPtTrgDTSQLCompute()
	// Compute code for field PtTrgDT
 Set %d(88)=##class(BEDD.EDVISIT).CmbDt($g(%d(103)),$g(%d(106)))
 QUIT
zRClDtGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),61),1:"") }
zRClTmGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),62),1:"") }
zRecLockGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),45),1:"") }
zRecLockDTGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),47),1:"") }
zRecLockSiteGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),65),1:"") }
zRecLockUserGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),46),1:"") }
zRoomGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),28),1:"") }
zRoomSet(newvalue) public {
	If i%Room'=newvalue {
		Set i%Room=newvalue
		Set i%PtStat="" If ..PtStat
	}
	Quit 1 }
zRoomClearGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),60),1:"") }
zRoomDtGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),29),1:"") }
zRoomDtTmGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),56),1:"") }
zRoomTimeGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),30),1:"") }
zSexCompute(%id,%d1)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDVISIT).GetSex(%d1)
	} catch %tException { throw %tException }
	Quit %val
zSexGet() public {
	Quit ..SexCompute($listget(i%"%%OID"),..PtDFN) }
zSexSQLCompute()
	// Compute code for field Sex
 Set %d(100)=##class(BEDD.EDVISIT).GetSex($g(%d(81)))
 QUIT
zTrgACompute(%id,%d1,%d2)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDVISIT).GetTrgA(%d1,%d2)
	} catch %tException { throw %tException }
	Quit %val
zTrgAGet() public {
	Quit ..TrgACompute($listget(i%"%%OID"),..AMERVSIT,..PtDFN) }
zTrgASQLCompute()
	// Compute code for field TrgA
 Set %d(101)=##class(BEDD.EDVISIT).GetTrgA($g(%d(2)),$g(%d(81)))
 QUIT
zTrgClnCompute(%id,%d1,%d2)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDVISIT).GetTrgC(%d1,%d2) 
	} catch %tException { throw %tException }
	Quit %val
zTrgClnGet() public {
	Quit ..TrgClnCompute($listget(i%"%%OID"),..AMERVSIT,..VIEN) }
zTrgClnSQLCompute()
	// Compute code for field TrgCln
 Set %d(102)=##class(BEDD.EDVISIT).GetTrgC($g(%d(2)),$g(%d(107))) 
 QUIT
zTrgDtCompute(%id,%d1,%d2)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDVISIT).GetTrgDt(%d1,%d2)
	} catch %tException { throw %tException }
	Quit %val
zTrgDtGet() public {
	Quit ..TrgDtCompute($listget(i%"%%OID"),..AMERVSIT,..PtDFN) }
zTrgDtSQLCompute()
	// Compute code for field TrgDt
 Set %d(103)=##class(BEDD.EDVISIT).GetTrgDt($g(%d(2)),$g(%d(81)))
 QUIT
zTrgDtTmCompute(%id,%d1,%d2)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDVISIT).GetTrgDtTm(%d1,%d2)
	} catch %tException { throw %tException }
	Quit %val
zTrgDtTmGet() public {
	Quit ..TrgDtTmCompute($listget(i%"%%OID"),..AMERVSIT,..PtDFN) }
zTrgDtTmSQLCompute()
	// Compute code for field TrgDtTm
 Set %d(104)=##class(BEDD.EDVISIT).GetTrgDtTm($g(%d(2)),$g(%d(81)))
 QUIT
zTrgNrsCompute(%id,%d1,%d2)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDVISIT).GetTrgN(%d1,%d2) 
	} catch %tException { throw %tException }
	Quit %val
zTrgNrsGet() public {
	Quit ..TrgNrsCompute($listget(i%"%%OID"),..AMERVSIT,..PtDFN) }
zTrgNrsSQLCompute()
	// Compute code for field TrgNrs
 Set %d(105)=##class(BEDD.EDVISIT).GetTrgN($g(%d(2)),$g(%d(81))) 
 QUIT
zTrgTmCompute(%id,%d1,%d2)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDVISIT).GetTrgTm(%d1,%d2)
	} catch %tException { throw %tException }
	Quit %val
zTrgTmGet() public {
	Quit ..TrgTmCompute($listget(i%"%%OID"),..AMERVSIT,..PtDFN) }
zTrgTmSQLCompute()
	// Compute code for field TrgTm
 Set %d(106)=##class(BEDD.EDVISIT).GetTrgTm($g(%d(2)),$g(%d(81)))
 QUIT
zVIENGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDVISITD(id)),31),1:"") }
zVIENNormalize(%val) public {
	Q $e(%val,1,50) }
zVstDurCompute(%id,%d1)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDVISIT).GetVD(%d1) 
	} catch %tException { throw %tException }
	Quit %val
zVstDurGet() public {
	Quit ..VstDurCompute($listget(i%"%%OID"),..AMERVSIT) }
zVstDurSQLCompute()
	// Compute code for field VstDur
 Set %d(108)=##class(BEDD.EDVISIT).GetVD($g(%d(2))) 
 QUIT
zWtgTimeCompute(%id,%d1,%d2,%d3,%d4,%d5,%d6,%d7,%d8,%d9)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDVISIT).GetWtg(%id,%d5,%d1,%d2,%d8,%d9,%d3,%d4,%d6,%d7) 
	} catch %tException { throw %tException }
	Quit %val
zWtgTimeGet() public {
	Quit ..WtgTimeCompute($listget(i%"%%OID"),..CIDt,..CITm,..ORmDt,..ORmTm,..PtStatI,..RClDt,..RClTm,..TrgDt,..TrgTm) }
zWtgTimeSQLCompute()
	// Compute code for field WtgTime
 Set %d(109)=##class(BEDD.EDVISIT).GetWtg(%d(1),$g(%d(85)),$g(%d(13)),$g(%d(14)),$g(%d(103)),$g(%d(106)),$g(%d(63)),$g(%d(64)),$g(%d(89)),$g(%d(90))) 
 QUIT
zExtentExecute(%qHandle) [ SQLCODE,c1 ] public { New %ROWCOUNT,%ROWID,%msg,SQLCODE,c1 
	Set sc=1
	s %qHandle=$i(%objcn)
	 ;---&sql(DECLARE QExtent CURSOR FOR
 	 ;---		 SELECT ID FROM BEDD.EDVISIT)
 	 ;--- ** SQL PUBLIC Variables: %ROWCOUNT, %ROWID, %msg, SQLCODE
	
	 ;---&sql(OPEN QExtent)
 	 ;--- ** SQL PUBLIC Variables: %ROWCOUNT, %ROWID, %msg, SQLCODE
	Do %QExtent0o
	If SQLCODE { Set:$isobject($g(%sqlcontext)) %sqlcontext.%SQLCODE=SQLCODE,%sqlcontext.%Message=$g(%msg) Set sc=$$Error^%apiOBJ(5821,"SQLCODE = "_SQLCODE) } Else { Set sc=1 }
	Quit sc }
zExtentClose(%qHandle) [ SQLCODE,c1 ] public { New %ROWCOUNT,%ROWID,%msg,SQLCODE,c1 
	 ;---&sql(CLOSE QExtent)
 	 ;--- ** SQL PUBLIC Variables: %ROWCOUNT, %ROWID, %msg, SQLCODE
	Do %QExtent0c
	If SQLCODE { Set:$isobject($g(%sqlcontext)) %sqlcontext.%SQLCODE=SQLCODE,%sqlcontext.%Message=$g(%msg) Set sc=$$Error^%apiOBJ(5540,SQLCODE,$get(%msg)) } Else { Set sc=1 }
	Kill %objcsc(%qHandle),%objcsp(%qHandle),%objcss(%qHandle),%objcst(%qHandle),%objcsl(%qHandle),%objcsR(%qHandle),%objcsZ(%qHandle),%objcsd(%qHandle)
	Quit sc }
zExtentFetch(%qHandle,Row,AtEnd=0) [ SQLCODE,c1 ] public { New %ROWCOUNT,%ROWID,%msg,SQLCODE,c1 
	Set Row="",AtEnd=0
	 ;---&sql(FETCH QExtent INTO :c1)
 	 ;--- ** SQL PUBLIC Variables: %ROWCOUNT, %ROWID, %msg, SQLCODE, c1
	Do %0Mo
	If 'SQLCODE { Set Row=$lb(c1) Set sc=1 } ElseIf SQLCODE=100 { Set AtEnd=1,sc=1 Set:$isobject($g(%sqlcontext)) %sqlcontext.%SQLCODE=SQLCODE,%sqlcontext.%ROWCOUNT=$g(%ROWCOUNT) } Else { Set:$isobject($g(%sqlcontext)) %sqlcontext.%SQLCODE=SQLCODE,%sqlcontext.Message=$g(%msg) Set AtEnd=1,sc=$$Error^%apiOBJ(5540,SQLCODE,$get(%msg)) }
	QUIT sc }
zExtentFetchRows(%qHandle,FetchCount=0,RowSet,ReturnCount,AtEnd) [ SQLCODE,c1 ] public { New %ROWCOUNT,%ROWID,%msg,SQLCODE,c1 
	Set RowSet="",ReturnCount=0,AtEnd=0
	For {
		 ;---&sql(FETCH QExtent INTO :c1)
 		 ;--- ** SQL PUBLIC Variables: %ROWCOUNT, %ROWID, %msg, SQLCODE, c1
		Do %0No
		If 'SQLCODE { Set RowSet=RowSet_$lb(c1),ReturnCount=ReturnCount+1 Quit:(ReturnCount=FetchCount)||(($l(RowSet)+($l(RowSet)\ReturnCount))>24000) } Else { Set AtEnd=1 Quit }
	}
	If 'SQLCODE { Set sc=1 } ElseIf SQLCODE=100 { Set sc=1 Set:$isobject($g(%sqlcontext)) %sqlcontext.%SQLCODE=SQLCODE,%sqlcontext.%ROWCOUNT=$g(%ROWCOUNT) } Else { Set:$isobject($g(%sqlcontext)) %sqlcontext.%SQLCODE=SQLCODE,%sqlcontext.Message=$g(%msg) Set sc=$$Error^%apiOBJ(5540,SQLCODE,$get(%msg)) }
	Quit sc }
 q
%QExtent0o 
 s $zt="%QExtent0E" s SQLCODE=$s($g(%objcsc(%qHandle)):-101,1:0) q:SQLCODE'=0  s %objcsd(%qHandle,1)=0 set:$d(%0CacheRowLimit)#2 %objcsd(%qHandle,2)=%0CacheRowLimit s %objcsd(%qHandle,3)=0,%objcsd(%qHandle,4)="" d:$zu(115,15) $system.ECP.Sync()
 s %objcsc(%qHandle)=1 q
%QExtent0E s $zt="" d SQLRunTimeError^%apiSQL($ze,.SQLCODE,.%msg) k %objcsd(%qHandle),%objcsc(%qHandle),%objcss(%qHandle),%objcst(%qHandle),%objcsp(%qHandle) q
%0Ifirst 
 ; asl MOD# 2
 s %objcsd(%qHandle,5)=""
%0ImBk1 s %objcsd(%qHandle,5)=$o(^BEDD.EDVISITI("DisIdx",%objcsd(%qHandle,5)))
 i %objcsd(%qHandle,5)="" g %0ImBdun
 s %objcsd(%qHandle,6)=""
%0ImBk2 s:%objcsd(%qHandle,5)="" %objcsd(%qHandle,5)=-1E14
 s %objcsd(%qHandle,6)=$o(^BEDD.EDVISITI("DisIdx",%objcsd(%qHandle,5),%objcsd(%qHandle,6)))
 i %objcsd(%qHandle,6)="" g %0ImBk1
 s:%objcsd(%qHandle,5)=-1E14 %objcsd(%qHandle,5)=""
 g:$zu(115,2)=0 %0ImBuncommitted i $zu(115,2)=1 l +^BEDD.EDVISITD($p(%objcsd(%qHandle,6),"||",1))#"S":$zu(115,4) i $t { s %objcsd(%qHandle,3)=1,%objcsd(%qHandle,4)=$name(^BEDD.EDVISITD($p(%objcsd(%qHandle,6),"||",1)))_"#""SI""" } else { s SQLCODE=-114,%msg="Unable to acquire shared lock on table BEDD.EDVISIT for RowID value: "_%objcsd(%qHandle,6) ztrap "LOCK"  }
 ; asl MOD# 3
 i %objcsd(%qHandle,6)'="",$d(^BEDD.EDVISITD(%objcsd(%qHandle,6)))
 e  g %0ImCdun
%0ImBuncommitted ;
 s:$g(SQLCODE)'<0 SQLCODE=0 s %objcsd(%qHandle,1)=%objcsd(%qHandle,1)+1,%ROWCOUNT=%objcsd(%qHandle,1),%ROWID=%objcsd(%qHandle,6),%objcsc(%qHandle)=10 q
%QExtent0f i '$g(%objcsc(%qHandle)) { s SQLCODE=-102 q  } i %objcsc(%qHandle)=100 { s SQLCODE=100 q  } s SQLCODE=0
 s $zt="%0Ierr"
 i $d(%objcsd(%qHandle,2))#2,$g(%objcsd(%qHandle,1))'<%objcsd(%qHandle,2) { s SQLCODE=100,%ROWCOUNT=%objcsd(%qHandle,1),%objcsc(%qHandle)=100 q }
 g %0Ifirst:%objcsc(%qHandle)=1
%0ImCdun if $zu(115,2)=1 { if $g(%objcsd(%qHandle,3))=1 { l -@%objcsd(%qHandle,4) s %objcsd(%qHandle,3)=0 } elseif $g(%objcsd(%qHandle,3))=2 { do $classmethod($li(%objcsd(%qHandle,4)),"%UnlockId",$li(%objcsd(%qHandle,4),2),1,1)  s %objcsd(%qHandle,3)=0 } }
 g %0ImBk2
%0ImBdun 
%0ImAdun 
 s %ROWCOUNT=%objcsd(%qHandle,1),SQLCODE=100,%objcsc(%qHandle)=100 q
%QExtent0c i '$g(%objcsc(%qHandle)) { s SQLCODE=-102 q  }
 s %ROWCOUNT=$s($g(SQLCODE)'<0:+$g(%objcsd(%qHandle,1)),1:0)
 if $zu(115,2)=1 { if $g(%objcsd(%qHandle,3))=1 { l -@%objcsd(%qHandle,4) } elseif $g(%objcsd(%qHandle,3))=2 { do $classmethod($li(%objcsd(%qHandle,4)),"%UnlockId",$li(%objcsd(%qHandle,4),2),1,1)  } }
 k %objcsd(%qHandle),%objcsc(%qHandle) s SQLCODE=0 q
%0Ierr s $zt="" d SQLRunTimeError^%apiSQL($ze,.SQLCODE,.%msg)
 s %objcsc(%qHandle)=100 q
%0Mo d %QExtent0f q:SQLCODE'=0
 s c1=%objcsd(%qHandle,6)
 q
%0No d %QExtent0f q:SQLCODE'=0
 s c1=%objcsd(%qHandle,6)
 q
zExtentFunc() public {
	try {
		set tSchemaPath = ##class(%SQL.Statement).%ClassPath($classname())
			set tStatement = ##class(%SQL.Statement).%New(,tSchemaPath)
			do tStatement.prepare(" SELECT ID FROM BEDD . EDVISIT")
		set tResult = tStatement.%Execute()
	}
	catch tException { if '$Isobject($Get(tResult)) { set tResult = ##class(%SQL.StatementResult).%New() } set tResult.%SQLCODE=tException.AsSQLCODE(),tResult.%Message=tException.SQLMessageString() }
	Quit tResult }
zExtentGetInfo(colinfo,parminfo,idinfo,%qHandle,extoption=0,extinfo) public {
 s parminfo=""
	s:'($d(^oddCOM($classname(),"q","Extent",21),clientinfo)#2)&&'$s($d(^(2),clientinfo)#2&&(clientinfo'=$classname()):$d(^oddCOM(clientinfo,"q","Extent",21),clientinfo)#2||($d(^oddDEF(clientinfo,"q","Extent",21),clientinfo)#2),1:$d(^oddDEF($classname(),"q","Extent",21),clientinfo)#2) clientinfo=$g(^%qCacheObjectKey(1,"q",21))
	Set:extoption extinfo=$s($d(^oddCOM($classname(),"q","Extent",38))#2:^(38),$d(^oddCOM($g(^(2),$classname()),"q","Extent",38))#2:^(38),1:$s($d(^oddDEF($g(^oddCOM($classname(),"q","Extent",2),$classname()),"q","Extent",38))#2:^(38),1:$g(^%qCacheObjectKey(1,"q",38))))
	If clientinfo'="" Set colinfo=$listget(clientinfo,1),parminfo=$listget(clientinfo,2),idinfo=$listget(clientinfo,3) Quit 1
	Set colinfo="",parminfo="",idinfo=$listbuild(0)
	Set sc=$$externaltype^%apiOLE("%Library.Integer",.exttypes,"0")
	Quit:('sc) sc
	s:'($d(^oddCOM($classname(),"q","Extent",23),names)#2)&&'$s($d(^(2),names)#2&&(names'=$classname()):$d(^oddCOM(names,"q","Extent",23),names)#2||($d(^oddDEF(names,"q","Extent",23),names)#2),1:$d(^oddDEF($classname(),"q","Extent",23),names)#2) names=$g(^%qCacheObjectKey(1,"q",23))
	s:'($d(^oddCOM($classname(),"q","Extent",22),captions)#2)&&'$s($d(^(2),captions)#2&&(captions'=$classname()):$d(^oddCOM(captions,"q","Extent",22),captions)#2||($d(^oddDEF(captions,"q","Extent",22),captions)#2),1:$d(^oddDEF($classname(),"q","Extent",22),captions)#2) captions=$g(^%qCacheObjectKey(1,"q",22))
	For i=1:1:1 Set colinfo=colinfo_$listbuild($listbuild($listget(names,i),$piece(exttypes,",",i),$listget(captions,i)))
	Set idinfo=$listbuild(1,$classname())
	s ^oddCOM($classname(),"q","Extent",21)=$listbuild(colinfo,parminfo,idinfo)
	Quit 1 }
zExtentGetODBCInfo(colinfo,parminfo,qHandle) public {
	set version = $Select($Get(%protocol,41)>40:4,1:3)
	If $Get(^oddPROC("BEDD","EDVISIT_EXTENT",21))'="" { Set sc = 1, metadata=$Select(version=4:^oddPROC("BEDD","EDVISIT_EXTENT",12),1:^oddPROC("BEDD","EDVISIT_EXTENT",12,version)) }
	ElseIf $Data(^oddPROC("BEDD","EDVISIT_EXTENT")) { Set sc = $$CompileSignature^%ourProcedure("BEDD","EDVISIT_EXTENT",.metadata,.signature) }
	Else { Set sc = $$Error^%apiOBJ(5068,$classname()_":Extent") }
	If (''sc) { Set colcount=$li(metadata,2),cmdlen=colcount*$Case(version,4:10,:9),colinfo=$li(metadata,2,2+cmdlen),parmcount=$li(metadata,cmdlen+3),pmdlen=parmcount*6,parminfo=$li(metadata,cmdlen+3,cmdlen+pmdlen+3) }
	Quit sc }
zExtentSendODBC(qHandle,array,qacn,%qrc,piece,ColumnCount) public {
	Kill array(qacn) Set %qrc=0
SPInnerLoop	Set rc=..ExtentFetch(.qHandle,.row,.atend)
	If ('rc) { Set %qrc=-400 Set:$isobject($get(%sqlcontext)) %sqlcontext.SQLCode=-400,%sqlcontext.Message=$g(%msg) Do ProcessError^%ourProcedure(rc,$get(%sqlcontext),.%qrc,.%msg) Do Logerr^%SYS.SQLSRV(%qrc,"","SP",.%msg) Set piece=0 Quit }
	If row="" Set %qrc=100,piece=0 Set:$isobject($get(%sqlcontext)) %sqlcontext.SQLCode=100 Quit 1
	If $get(%protocol)>46 { For piece=1:1:ColumnCount { Goto:$zobjexport($listget(row,piece),50) SPDone } }
	Else { For piece=1:1:ColumnCount { Goto:$zobjexport($listget(row,piece),7) SPDone } }
	Goto SPInnerLoop
SPDone	Set:$g(%protocol)>46 piece=piece+1 For i=piece:1:ColumnCount { Set array(qacn,i)=$listget(row,i) }
	Quit }
zADIdxExists(K1,id="")
	new %ROWCOUNT,SQLCODE,temp
	 ;---&sql(SELECT %ID INTO :id FROM BEDD.EDVISIT WHERE (:K1 is not null and VIEN = :K1) OR (:K1 IS NULL AND VIEN IS NULL))
 	 ;--- ** SQL PUBLIC Variables: %ROWCOUNT, %ROWID, %msg, K1, SQLCODE, id
	Do %0Oo
	Quit $select('SQLCODE:1,1:0)
 q
%0Oo 
 n %mmmsqlc,%mmmsqld,%mmmsqlE,%mmmsqll,%mmmsqln,%mmmsqlp,%mmmsqlR,%mmmsqls,%mmmsqlt,%mmmsqlZ s $zt="%0Oerr" s %mmmsqld(1)=0,%mmmsqld(2)="" d:$zu(115,15) $system.ECP.Sync()
 s %mmmsqld(3)=$g(K1),%mmmsqld(4)=$g(K1),%mmmsqld(5)=$g(K1)
 s SQLCODE=100
 s %mmmsqld(6)=$zu(28,%mmmsqld(4),7)
 ; asl MOD# 2
 s %mmmsqld(7)=""
%0OmBk1 s %mmmsqld(7)=$o(^BEDD.EDVISITI("ADIdx",%mmmsqld(7)))
 i %mmmsqld(7)="" g %0OmBdun
 s %mmmsqld(8)=$zu(28,$s(%mmmsqld(7)'=-1E14:%mmmsqld(7),1:""),7)
 s id=""
%0OmBk2 s:%mmmsqld(7)="" %mmmsqld(7)=-1E14
 s id=$o(^BEDD.EDVISITI("ADIdx",%mmmsqld(7),id))
 i id="" g %0OmBk1
 s:%mmmsqld(7)=-1E14 %mmmsqld(7)=""
 g:'(((%mmmsqld(8)'=" ")&&((%mmmsqld(3)'="")&&(%mmmsqld(8)=%mmmsqld(6))))||((%mmmsqld(5)="")&&(%mmmsqld(8)=" "))) %0OmBk2
 g:$zu(115,2)=0 %0OmBuncommitted i $zu(115,2)=1 l +^BEDD.EDVISITD($p(id,"||",1))#"S":$zu(115,4) i $t { s %mmmsqld(1)=1,%mmmsqld(2)=$name(^BEDD.EDVISITD($p(id,"||",1)))_"#""SI""" } else { s SQLCODE=-114,%msg="Unable to acquire shared lock on table BEDD.EDVISIT for RowID value: "_id ztrap "LOCK"  }
 ; asl MOD# 3
 s %mmmsqld(9)=$lb(""_%mmmsqld(8))
 i id'="",$d(^BEDD.EDVISITD(id))
 e  g %0OmCdun
 s %mmmsqld(10)=$g(^BEDD.EDVISITD(id)) s %mmmsqld(7)=$lg(%mmmsqld(10),31) s %mmmsqld(8)=$zu(28,%mmmsqld(7),7)
 s %mmmsqld(11)=$lb(""_%mmmsqld(8))
 g:%mmmsqld(9)'=%mmmsqld(11) %0OmCdun
%0OmBuncommitted ;
 s SQLCODE=0 g %0Oc
%0OmCdun if $zu(115,2)=1 { if $g(%mmmsqld(1))=1 { l -@%mmmsqld(2) s %mmmsqld(1)=0 } elseif $g(%mmmsqld(1))=2 { do $classmethod($li(%mmmsqld(2)),"%UnlockId",$li(%mmmsqld(2),2),1,1)  s %mmmsqld(1)=0 } }
 g %0OmBk2
%0OmBdun 
%0OmAdun 
%0Oc s %ROWCOUNT='SQLCODE
 if $zu(115,2)=1 { if $g(%mmmsqld(1))=1 { l -@%mmmsqld(2) } elseif $g(%mmmsqld(1))=2 { do $classmethod($li(%mmmsqld(2)),"%UnlockId",$li(%mmmsqld(2),2),1,1)  } }
 q
%0Oerr s $zt="" d SQLRunTimeError^%apiSQL($ze,.SQLCODE,.%msg)
 g %0Oc
zArrIdxExists(K1,id="")
	new %ROWCOUNT,SQLCODE,temp
	 ;---&sql(SELECT %ID INTO :id FROM BEDD.EDVISIT WHERE (:K1 is not null and CIDt = :K1) OR (:K1 IS NULL AND CIDt IS NULL))
 	 ;--- ** SQL PUBLIC Variables: %ROWCOUNT, %ROWID, %msg, K1, SQLCODE, id
	Do %0Qo
	Quit $select('SQLCODE:1,1:0)
 q
%0Qo 
 n %mmmsqlc,%mmmsqld,%mmmsqlE,%mmmsqll,%mmmsqln,%mmmsqlp,%mmmsqlR,%mmmsqls,%mmmsqlt,%mmmsqlZ s $zt="%0Qerr" s %mmmsqld(1)=0,%mmmsqld(2)="" d:$zu(115,15) $system.ECP.Sync()
 s %mmmsqld(3)=$g(K1),%mmmsqld(4)=$g(K1),%mmmsqld(5)=$g(K1),%mmmsqld(6)=""
 s SQLCODE=100
 ; asl MOD# 2
 s %mmmsqld(7)=%mmmsqld(4) s:%mmmsqld(7)="" %mmmsqld(7)=-1E14
 s %mmmsqld(8)="",%mmmsqld(9)=1,%mmmsqld(10)="",%mmmsqld(11)=1,%mmmsqld(12)=""
 g %0QmBk1
%0QmBqt1 s %mmmsqld(8)="" q
%0QmBpt1 s %mmmsqld(9)=0
 i '(%mmmsqld(3)'="") g %0QmBqt1
 s %mmmsqld(13)=%mmmsqld(4)
 s %mmmsqld(14)=$s(%mmmsqld(13)'="":%mmmsqld(13),1:-1E14)
 i '(%mmmsqld(13)'="") g %0QmBqt1
 g %0QmBft1:%mmmsqld(8)=""
%0QmBat1 g %0QmBpt1:%mmmsqld(9)
 g %0QmBgt1:$d(^BEDD.EDVISITI("ArrIdx",%mmmsqld(14),%mmmsqld(8)))
%0QmBft1 g %0QmBpt1:%mmmsqld(9)
 s %mmmsqld(8)=$o(^BEDD.EDVISITI("ArrIdx",%mmmsqld(14),%mmmsqld(8)))
 q:%mmmsqld(8)=""
%0QmBgt1 q
%0QmBqt2 s %mmmsqld(10)="" q
%0QmBpt2 s %mmmsqld(11)=0
 i '(%mmmsqld(5)="") g %0QmBqt2
 s %mmmsqld(15)=%mmmsqld(6)
 s %mmmsqld(16)=$s(%mmmsqld(15)'="":%mmmsqld(15),1:-1E14)
 g %0QmBft2:%mmmsqld(10)=""
%0QmBat2 g %0QmBpt2:%mmmsqld(11)
 g %0QmBgt2:$d(^BEDD.EDVISITI("ArrIdx",%mmmsqld(16),%mmmsqld(10)))
%0QmBft2 g %0QmBpt2:%mmmsqld(11)
 s %mmmsqld(10)=$o(^BEDD.EDVISITI("ArrIdx",%mmmsqld(16),%mmmsqld(10)))
 q:%mmmsqld(10)=""
%0QmBgt2 q
%0QmBat3 i %mmmsqld(8)="",%mmmsqld(10)="" s %mmmsqld(8)=%mmmsqld(12) d %0QmBat1 s %mmmsqld(10)=%mmmsqld(12) d %0QmBat2 g %0QmBgt3
 i %mmmsqld(8)'="",%mmmsqld(12)]]%mmmsqld(8) s %mmmsqld(8)=%mmmsqld(12) d %0QmBat1
 i %mmmsqld(10)'="",%mmmsqld(12)]]%mmmsqld(10) s %mmmsqld(10)=%mmmsqld(12) d %0QmBat2
 g %0QmBgt3
%0QmBft3 d %0QmBft1:%mmmsqld(8)=%mmmsqld(12),%0QmBft2:%mmmsqld(10)=%mmmsqld(12)
%0QmBgt3 s %mmmsqld(12)=$S(%mmmsqld(8)="":%mmmsqld(10),%mmmsqld(10)="":%mmmsqld(8),%mmmsqld(10)]]%mmmsqld(8):%mmmsqld(8),1:%mmmsqld(10)) q
%0QmBk1 d %0QmBft3
 i %mmmsqld(12)="" g %0QmBdun
 s id=%mmmsqld(12)
 g:$zu(115,2)=0 %0QmBuncommitted i $zu(115,2)=1 l +^BEDD.EDVISITD($p(id,"||",1))#"S":$zu(115,4) i $t { s %mmmsqld(1)=1,%mmmsqld(2)=$name(^BEDD.EDVISITD($p(id,"||",1)))_"#""SI""" } else { s SQLCODE=-114,%msg="Unable to acquire shared lock on table BEDD.EDVISIT for RowID value: "_id ztrap "LOCK"  }
 ; asl MOD# 3
 i id'="",$d(^BEDD.EDVISITD(id))
 e  g %0QmCdun
 s %mmmsqld(17)=$g(^BEDD.EDVISITD(id)) s %mmmsqld(18)=$lg(%mmmsqld(17),2) s %mmmsqld(19)=$lg(%mmmsqld(17),27) d
 . Set %mmmsqld(7)=##class(BEDD.EDVISIT).GetCIDt(%mmmsqld(18),%mmmsqld(19)) 
 g:'(((%mmmsqld(7)'="")&&((%mmmsqld(3)'="")&&(%mmmsqld(7)=%mmmsqld(4))))||((%mmmsqld(5)="")&&(%mmmsqld(7)=""))) %0QmCdun
%0QmBuncommitted ;
 s SQLCODE=0 g %0Qc
%0QmCdun if $zu(115,2)=1 { if $g(%mmmsqld(1))=1 { l -@%mmmsqld(2) s %mmmsqld(1)=0 } elseif $g(%mmmsqld(1))=2 { do $classmethod($li(%mmmsqld(2)),"%UnlockId",$li(%mmmsqld(2),2),1,1)  s %mmmsqld(1)=0 } }
 g %0QmBk1
%0QmBdun 
%0QmAdun 
%0Qc s %ROWCOUNT='SQLCODE
 if $zu(115,2)=1 { if $g(%mmmsqld(1))=1 { l -@%mmmsqld(2) } elseif $g(%mmmsqld(1))=2 { do $classmethod($li(%mmmsqld(2)),"%UnlockId",$li(%mmmsqld(2),2),1,1)  } }
 q
%0Qerr s $zt="" d SQLRunTimeError^%apiSQL($ze,.SQLCODE,.%msg)
 g %0Qc
zCIDtIIdxExists(K1,id="")
	new %ROWCOUNT,SQLCODE,temp
	 ;---&sql(SELECT %ID INTO :id FROM BEDD.EDVISIT WHERE (:K1 is not null and CIDt = :K1) OR (:K1 IS NULL AND CIDt IS NULL))
 	 ;--- ** SQL PUBLIC Variables: %ROWCOUNT, %ROWID, %msg, K1, SQLCODE, id
	Do %0So
	Quit $select('SQLCODE:1,1:0)
 q
%0So 
 n %mmmsqlc,%mmmsqld,%mmmsqlE,%mmmsqll,%mmmsqln,%mmmsqlp,%mmmsqlR,%mmmsqls,%mmmsqlt,%mmmsqlZ s $zt="%0Serr" s %mmmsqld(1)=0,%mmmsqld(2)="" d:$zu(115,15) $system.ECP.Sync()
 s %mmmsqld(3)=$g(K1),%mmmsqld(4)=$g(K1),%mmmsqld(5)=$g(K1),%mmmsqld(6)=""
 s SQLCODE=100
 ; asl MOD# 2
 s %mmmsqld(7)=%mmmsqld(4) s:%mmmsqld(7)="" %mmmsqld(7)=-1E14
 s %mmmsqld(8)="",%mmmsqld(9)=1,%mmmsqld(10)="",%mmmsqld(11)=1,%mmmsqld(12)=""
 g %0SmBk1
%0SmBqt1 s %mmmsqld(8)="" q
%0SmBpt1 s %mmmsqld(9)=0
 i '(%mmmsqld(3)'="") g %0SmBqt1
 s %mmmsqld(13)=%mmmsqld(4)
 s %mmmsqld(14)=$s(%mmmsqld(13)'="":%mmmsqld(13),1:-1E14)
 i '(%mmmsqld(13)'="") g %0SmBqt1
 g %0SmBft1:%mmmsqld(8)=""
%0SmBat1 g %0SmBpt1:%mmmsqld(9)
 g %0SmBgt1:$d(^BEDD.EDVISITI("ArrIdx",%mmmsqld(14),%mmmsqld(8)))
%0SmBft1 g %0SmBpt1:%mmmsqld(9)
 s %mmmsqld(8)=$o(^BEDD.EDVISITI("ArrIdx",%mmmsqld(14),%mmmsqld(8)))
 q:%mmmsqld(8)=""
%0SmBgt1 q
%0SmBqt2 s %mmmsqld(10)="" q
%0SmBpt2 s %mmmsqld(11)=0
 i '(%mmmsqld(5)="") g %0SmBqt2
 s %mmmsqld(15)=%mmmsqld(6)
 s %mmmsqld(16)=$s(%mmmsqld(15)'="":%mmmsqld(15),1:-1E14)
 g %0SmBft2:%mmmsqld(10)=""
%0SmBat2 g %0SmBpt2:%mmmsqld(11)
 g %0SmBgt2:$d(^BEDD.EDVISITI("ArrIdx",%mmmsqld(16),%mmmsqld(10)))
%0SmBft2 g %0SmBpt2:%mmmsqld(11)
 s %mmmsqld(10)=$o(^BEDD.EDVISITI("ArrIdx",%mmmsqld(16),%mmmsqld(10)))
 q:%mmmsqld(10)=""
%0SmBgt2 q
%0SmBat3 i %mmmsqld(8)="",%mmmsqld(10)="" s %mmmsqld(8)=%mmmsqld(12) d %0SmBat1 s %mmmsqld(10)=%mmmsqld(12) d %0SmBat2 g %0SmBgt3
 i %mmmsqld(8)'="",%mmmsqld(12)]]%mmmsqld(8) s %mmmsqld(8)=%mmmsqld(12) d %0SmBat1
 i %mmmsqld(10)'="",%mmmsqld(12)]]%mmmsqld(10) s %mmmsqld(10)=%mmmsqld(12) d %0SmBat2
 g %0SmBgt3
%0SmBft3 d %0SmBft1:%mmmsqld(8)=%mmmsqld(12),%0SmBft2:%mmmsqld(10)=%mmmsqld(12)
%0SmBgt3 s %mmmsqld(12)=$S(%mmmsqld(8)="":%mmmsqld(10),%mmmsqld(10)="":%mmmsqld(8),%mmmsqld(10)]]%mmmsqld(8):%mmmsqld(8),1:%mmmsqld(10)) q
%0SmBk1 d %0SmBft3
 i %mmmsqld(12)="" g %0SmBdun
 s id=%mmmsqld(12)
 g:$zu(115,2)=0 %0SmBuncommitted i $zu(115,2)=1 l +^BEDD.EDVISITD($p(id,"||",1))#"S":$zu(115,4) i $t { s %mmmsqld(1)=1,%mmmsqld(2)=$name(^BEDD.EDVISITD($p(id,"||",1)))_"#""SI""" } else { s SQLCODE=-114,%msg="Unable to acquire shared lock on table BEDD.EDVISIT for RowID value: "_id ztrap "LOCK"  }
 ; asl MOD# 3
 i id'="",$d(^BEDD.EDVISITD(id))
 e  g %0SmCdun
 s %mmmsqld(17)=$g(^BEDD.EDVISITD(id)) s %mmmsqld(18)=$lg(%mmmsqld(17),2) s %mmmsqld(19)=$lg(%mmmsqld(17),27) d
 . Set %mmmsqld(7)=##class(BEDD.EDVISIT).GetCIDt(%mmmsqld(18),%mmmsqld(19)) 
 g:'(((%mmmsqld(7)'="")&&((%mmmsqld(3)'="")&&(%mmmsqld(7)=%mmmsqld(4))))||((%mmmsqld(5)="")&&(%mmmsqld(7)=""))) %0SmCdun
%0SmBuncommitted ;
 s SQLCODE=0 g %0Sc
%0SmCdun if $zu(115,2)=1 { if $g(%mmmsqld(1))=1 { l -@%mmmsqld(2) s %mmmsqld(1)=0 } elseif $g(%mmmsqld(1))=2 { do $classmethod($li(%mmmsqld(2)),"%UnlockId",$li(%mmmsqld(2),2),1,1)  s %mmmsqld(1)=0 } }
 g %0SmBk1
%0SmBdun 
%0SmAdun 
%0Sc s %ROWCOUNT='SQLCODE
 if $zu(115,2)=1 { if $g(%mmmsqld(1))=1 { l -@%mmmsqld(2) } elseif $g(%mmmsqld(1))=2 { do $classmethod($li(%mmmsqld(2)),"%UnlockId",$li(%mmmsqld(2),2),1,1)  } }
 q
%0Serr s $zt="" d SQLRunTimeError^%apiSQL($ze,.SQLCODE,.%msg)
 g %0Sc
zDCDTIdxExists(K1,id="")
	new %ROWCOUNT,SQLCODE,temp
	 ;---&sql(SELECT %ID INTO :id FROM BEDD.EDVISIT WHERE (:K1 is not null and DCDtH = :K1) OR (:K1 IS NULL AND DCDtH IS NULL))
 	 ;--- ** SQL PUBLIC Variables: %ROWCOUNT, %ROWID, %msg, K1, SQLCODE, id
	Do %0Uo
	Quit $select('SQLCODE:1,1:0)
 q
%0Uo 
 n %mmmsqlc,%mmmsqld,%mmmsqlE,%mmmsqll,%mmmsqln,%mmmsqlp,%mmmsqlR,%mmmsqls,%mmmsqlt,%mmmsqlZ s $zt="%0Uerr" s %mmmsqld(1)=0,%mmmsqld(2)="" d:$zu(115,15) $system.ECP.Sync()
 s %mmmsqld(3)=$g(K1),%mmmsqld(4)=$g(K1),%mmmsqld(5)=$g(K1),%mmmsqld(6)=" "
 s SQLCODE=100
 s %mmmsqld(7)=$zu(28,%mmmsqld(4),7)
 ; asl MOD# 2
 s %mmmsqld(8)=%mmmsqld(7) s:%mmmsqld(8)="" %mmmsqld(8)=-1E14
 s %mmmsqld(9)="",%mmmsqld(10)=1,%mmmsqld(11)="",%mmmsqld(12)=1,%mmmsqld(13)=""
 g %0UmBk1
%0UmBqt1 s %mmmsqld(9)="" q
%0UmBpt1 s %mmmsqld(10)=0
 i '(%mmmsqld(3)'="") g %0UmBqt1
 s %mmmsqld(14)=%mmmsqld(7)
 g %0UmBqt1:%mmmsqld(14)=""
 i '(%mmmsqld(14)'=" ") g %0UmBqt1
 g %0UmBft1:%mmmsqld(9)=""
%0UmBat1 g %0UmBpt1:%mmmsqld(10)
 g %0UmBgt1:$d(^BEDD.EDVISITI("DCDTIdx",%mmmsqld(14),%mmmsqld(9)))
%0UmBft1 g %0UmBpt1:%mmmsqld(10)
 s %mmmsqld(9)=$o(^BEDD.EDVISITI("DCDTIdx",%mmmsqld(14),%mmmsqld(9)))
 q:%mmmsqld(9)=""
%0UmBgt1 q
%0UmBqt2 s %mmmsqld(11)="" q
%0UmBpt2 s %mmmsqld(12)=0
 i '(%mmmsqld(5)="") g %0UmBqt2
 s %mmmsqld(15)=%mmmsqld(6)
 g %0UmBqt2:%mmmsqld(15)=""
 g %0UmBft2:%mmmsqld(11)=""
%0UmBat2 g %0UmBpt2:%mmmsqld(12)
 g %0UmBgt2:$d(^BEDD.EDVISITI("DCDTIdx",%mmmsqld(15),%mmmsqld(11)))
%0UmBft2 g %0UmBpt2:%mmmsqld(12)
 s %mmmsqld(11)=$o(^BEDD.EDVISITI("DCDTIdx",%mmmsqld(15),%mmmsqld(11)))
 q:%mmmsqld(11)=""
%0UmBgt2 q
%0UmBat3 i %mmmsqld(9)="",%mmmsqld(11)="" s %mmmsqld(9)=%mmmsqld(13) d %0UmBat1 s %mmmsqld(11)=%mmmsqld(13) d %0UmBat2 g %0UmBgt3
 i %mmmsqld(9)'="",%mmmsqld(13)]]%mmmsqld(9) s %mmmsqld(9)=%mmmsqld(13) d %0UmBat1
 i %mmmsqld(11)'="",%mmmsqld(13)]]%mmmsqld(11) s %mmmsqld(11)=%mmmsqld(13) d %0UmBat2
 g %0UmBgt3
%0UmBft3 d %0UmBft1:%mmmsqld(9)=%mmmsqld(13),%0UmBft2:%mmmsqld(11)=%mmmsqld(13)
%0UmBgt3 s %mmmsqld(13)=$S(%mmmsqld(9)="":%mmmsqld(11),%mmmsqld(11)="":%mmmsqld(9),%mmmsqld(11)]]%mmmsqld(9):%mmmsqld(9),1:%mmmsqld(11)) q
%0UmBk1 d %0UmBft3
 i %mmmsqld(13)="" g %0UmBdun
 s id=%mmmsqld(13)
 g:$zu(115,2)=0 %0UmBuncommitted i $zu(115,2)=1 l +^BEDD.EDVISITD($p(id,"||",1))#"S":$zu(115,4) i $t { s %mmmsqld(1)=1,%mmmsqld(2)=$name(^BEDD.EDVISITD($p(id,"||",1)))_"#""SI""" } else { s SQLCODE=-114,%msg="Unable to acquire shared lock on table BEDD.EDVISIT for RowID value: "_id ztrap "LOCK"  }
 ; asl MOD# 3
 i id'="",$d(^BEDD.EDVISITD(id))
 e  g %0UmCdun
 s %mmmsqld(16)=$g(^BEDD.EDVISITD(id)) s %mmmsqld(17)=$lg(%mmmsqld(16),7) s %mmmsqld(8)=$zu(28,%mmmsqld(17),7)
 g:'(((%mmmsqld(8)'=" ")&&((%mmmsqld(3)'="")&&(%mmmsqld(8)=%mmmsqld(7))))||((%mmmsqld(5)="")&&(%mmmsqld(8)=" "))) %0UmCdun
%0UmBuncommitted ;
 s SQLCODE=0 g %0Uc
%0UmCdun if $zu(115,2)=1 { if $g(%mmmsqld(1))=1 { l -@%mmmsqld(2) s %mmmsqld(1)=0 } elseif $g(%mmmsqld(1))=2 { do $classmethod($li(%mmmsqld(2)),"%UnlockId",$li(%mmmsqld(2),2),1,1)  s %mmmsqld(1)=0 } }
 g %0UmBk1
%0UmBdun 
%0UmAdun 
%0Uc s %ROWCOUNT='SQLCODE
 if $zu(115,2)=1 { if $g(%mmmsqld(1))=1 { l -@%mmmsqld(2) } elseif $g(%mmmsqld(1))=2 { do $classmethod($li(%mmmsqld(2)),"%UnlockId",$li(%mmmsqld(2),2),1,1)  } }
 q
%0Uerr s $zt="" d SQLRunTimeError^%apiSQL($ze,.SQLCODE,.%msg)
 g %0Uc
zDisIdxExists(K1,id="")
	new %ROWCOUNT,SQLCODE,temp
	 ;---&sql(SELECT %ID INTO :id FROM BEDD.EDVISIT WHERE (:K1 is not null and DCDt = :K1) OR (:K1 IS NULL AND DCDt IS NULL))
 	 ;--- ** SQL PUBLIC Variables: %ROWCOUNT, %ROWID, %msg, K1, SQLCODE, id
	Do %0Wo
	Quit $select('SQLCODE:1,1:0)
 q
%0Wo 
 n %mmmsqlc,%mmmsqld,%mmmsqlE,%mmmsqll,%mmmsqln,%mmmsqlp,%mmmsqlR,%mmmsqls,%mmmsqlt,%mmmsqlZ s $zt="%0Werr" s %mmmsqld(1)=0,%mmmsqld(2)="" d:$zu(115,15) $system.ECP.Sync()
 s %mmmsqld(3)=$g(K1),%mmmsqld(4)=$g(K1),%mmmsqld(5)=$g(K1),%mmmsqld(6)=""
 s SQLCODE=100
 ; asl MOD# 2
 s %mmmsqld(7)=%mmmsqld(4) s:%mmmsqld(7)="" %mmmsqld(7)=-1E14
 s %mmmsqld(8)="",%mmmsqld(9)=1,%mmmsqld(10)="",%mmmsqld(11)=1,%mmmsqld(12)=""
 g %0WmBk1
%0WmBqt1 s %mmmsqld(8)="" q
%0WmBpt1 s %mmmsqld(9)=0
 i '(%mmmsqld(3)'="") g %0WmBqt1
 s %mmmsqld(13)=%mmmsqld(4)
 s %mmmsqld(14)=$s(%mmmsqld(13)'="":%mmmsqld(13),1:-1E14)
 i '(%mmmsqld(13)'="") g %0WmBqt1
 g %0WmBft1:%mmmsqld(8)=""
%0WmBat1 g %0WmBpt1:%mmmsqld(9)
 g %0WmBgt1:$d(^BEDD.EDVISITI("DisIdx",%mmmsqld(14),%mmmsqld(8)))
%0WmBft1 g %0WmBpt1:%mmmsqld(9)
 s %mmmsqld(8)=$o(^BEDD.EDVISITI("DisIdx",%mmmsqld(14),%mmmsqld(8)))
 q:%mmmsqld(8)=""
%0WmBgt1 q
%0WmBqt2 s %mmmsqld(10)="" q
%0WmBpt2 s %mmmsqld(11)=0
 i '(%mmmsqld(5)="") g %0WmBqt2
 s %mmmsqld(15)=%mmmsqld(6)
 s %mmmsqld(16)=$s(%mmmsqld(15)'="":%mmmsqld(15),1:-1E14)
 g %0WmBft2:%mmmsqld(10)=""
%0WmBat2 g %0WmBpt2:%mmmsqld(11)
 g %0WmBgt2:$d(^BEDD.EDVISITI("DisIdx",%mmmsqld(16),%mmmsqld(10)))
%0WmBft2 g %0WmBpt2:%mmmsqld(11)
 s %mmmsqld(10)=$o(^BEDD.EDVISITI("DisIdx",%mmmsqld(16),%mmmsqld(10)))
 q:%mmmsqld(10)=""
%0WmBgt2 q
%0WmBat3 i %mmmsqld(8)="",%mmmsqld(10)="" s %mmmsqld(8)=%mmmsqld(12) d %0WmBat1 s %mmmsqld(10)=%mmmsqld(12) d %0WmBat2 g %0WmBgt3
 i %mmmsqld(8)'="",%mmmsqld(12)]]%mmmsqld(8) s %mmmsqld(8)=%mmmsqld(12) d %0WmBat1
 i %mmmsqld(10)'="",%mmmsqld(12)]]%mmmsqld(10) s %mmmsqld(10)=%mmmsqld(12) d %0WmBat2
 g %0WmBgt3
%0WmBft3 d %0WmBft1:%mmmsqld(8)=%mmmsqld(12),%0WmBft2:%mmmsqld(10)=%mmmsqld(12)
%0WmBgt3 s %mmmsqld(12)=$S(%mmmsqld(8)="":%mmmsqld(10),%mmmsqld(10)="":%mmmsqld(8),%mmmsqld(10)]]%mmmsqld(8):%mmmsqld(8),1:%mmmsqld(10)) q
%0WmBk1 d %0WmBft3
 i %mmmsqld(12)="" g %0WmBdun
 s id=%mmmsqld(12)
 g:$zu(115,2)=0 %0WmBuncommitted i $zu(115,2)=1 l +^BEDD.EDVISITD($p(id,"||",1))#"S":$zu(115,4) i $t { s %mmmsqld(1)=1,%mmmsqld(2)=$name(^BEDD.EDVISITD($p(id,"||",1)))_"#""SI""" } else { s SQLCODE=-114,%msg="Unable to acquire shared lock on table BEDD.EDVISIT for RowID value: "_id ztrap "LOCK"  }
 ; asl MOD# 3
 i id'="",$d(^BEDD.EDVISITD(id))
 e  g %0WmCdun
 s %mmmsqld(17)=$g(^BEDD.EDVISITD(id)) s %mmmsqld(18)=$lg(%mmmsqld(17),2) d
 . Set %mmmsqld(7)=##class(BEDD.EDVISIT).GetDCDt(%mmmsqld(18))
 g:'(((%mmmsqld(7)'="")&&((%mmmsqld(3)'="")&&(%mmmsqld(7)=%mmmsqld(4))))||((%mmmsqld(5)="")&&(%mmmsqld(7)=""))) %0WmCdun
%0WmBuncommitted ;
 s SQLCODE=0 g %0Wc
%0WmCdun if $zu(115,2)=1 { if $g(%mmmsqld(1))=1 { l -@%mmmsqld(2) s %mmmsqld(1)=0 } elseif $g(%mmmsqld(1))=2 { do $classmethod($li(%mmmsqld(2)),"%UnlockId",$li(%mmmsqld(2),2),1,1)  s %mmmsqld(1)=0 } }
 g %0WmBk1
%0WmBdun 
%0WmAdun 
%0Wc s %ROWCOUNT='SQLCODE
 if $zu(115,2)=1 { if $g(%mmmsqld(1))=1 { l -@%mmmsqld(2) } elseif $g(%mmmsqld(1))=2 { do $classmethod($li(%mmmsqld(2)),"%UnlockId",$li(%mmmsqld(2),2),1,1)  } }
 q
%0Werr s $zt="" d SQLRunTimeError^%apiSQL($ze,.SQLCODE,.%msg)
 g %0Wc
zIDKEYCheck(K1,lockonly=0) public {
	s id=K1,exists=..%ExistsId(id) q:'exists $s('lockonly:$$Error^%apiOBJ(5797,$classname(),"IDKEY",id),1:1) s status=..%LockId(id,1) q:('status) status if 'lockonly { s exists=..%ExistsId(id) d ..%UnlockId(id,1,0) quit $s('exists:$$Error^%apiOBJ(5797,$classname(),"IDKEY",id),1:1) } else { d ..%UnlockId(id,1,0) q 1 } }
zIDKEYDelete(K1,concurrency=-1) public {
	Quit ..%DeleteId(.K1,concurrency) }
zIDKEYExists(K1,id="")
	s id=K1 q ..%ExistsId(K1)
	Quit
zIDKEYOpen(K1,concurrency=-1,sc) public { Set:'($data(sc)#2) sc=1
	Quit ..%OpenId(.K1,concurrency,.sc) }
zIDKEYSQLCheckUnique(pFromOrig=0,%pID,%pVals...)
 QUIT $$Error^%apiOBJ(5758,"%Persistent::IDKEYSQLCheckUnique")
zIDKEYSQLExists(pLockOnly=0,pUnlockRef,%pVal...)
	// SQL Foreign Key validation entry point for Foreign Key IDKEY.  Called by FKeys that reference this key to see if the row is defined
	new id set id=%pVal(1)
	if '..%SQLGetLock(id,1,.pUnlockRef) { set sqlcode=-114,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler39",,"BEDD"_"."_"EDVISIT"_":"_"IDKEY") QUIT 0 }
	if 'pLockOnly { new qv set qv=$d(^BEDD.EDVISITD(%pVal(1))) do:'$g(pUnlockRef) ..%SQLReleaseLock(id,1) quit qv } else { do:'$g(pUnlockRef) ..%SQLReleaseLock(id,1) QUIT 1 }
	Quit
zIDKEYSQLFindPKeyByConstraint(%con)
 QUIT $$Error^%apiOBJ(5758,"%Persistent::IDKEYSQLFindPKeyByConstraint")
zIDKEYSQLFindRowIDByConstraint(%con,pInternal=0)
 QUIT $$Error^%apiOBJ(5758,"%Persistent::IDKEYSQLFindRowIDByConstraint")
