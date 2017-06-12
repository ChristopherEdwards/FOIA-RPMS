 ;BEDD.EDUserPreferences.1
 ;(C)InterSystems, generated for class BEDD.EDUserPreferences.  Do NOT edit. 04/14/2017 08:47:49AM
 ;;7A7A3863;BEDD.EDUserPreferences
 ;
SQLUPPER(v,l) { quit $zu(28,v,7,$g(l,32767)) }
ALPHAUP(v,r) { quit $zu(28,v,6) }
STRING(v,l) { quit $zu(28,v,9,$g(l,32767)) }
SQLSTRING(v,l) { quit $zu(28,v,8,$g(l,32767)) }
UPPER(v) { quit $zu(28,v,5) }
MVR(v) { quit $zu(28,v,2) }
TRUNCATE(v,l) { quit $e(v,1,$g(l,3641144)) }
%BuildIndices(idxlist="",autoPurge=0,lockExtent=0) public {
	set $ZTrap="CatchError",locked=0,sc=1,sHandle=1,sHandle($classname())=$c(0,0)
	for ptr=1:1:$listlength(idxlist) { if '$d(^oddCOM($classname(),"i",$list(idxlist,ptr))) { set sc=$$Error^%apiOBJ(5066,$classname()_"::"_$list(idxlist,ptr)) continue } } if ('sc) { quit sc }
	if lockExtent { s sc=..%LockExtent(0) i ('sc) { q sc } else { s locked=1 } }
	if $system.CLS.IsMthd($classname(),"%OnBeforeBuildIndices") { set sc=..%OnBeforeBuildIndices(.idxlist) i ('sc) { i locked { d ..%SQLReleaseTableLock(0) } quit sc } }
	if autoPurge { s sc = ..%PurgeIndices(idxlist) i ('sc) { quit sc }}
	if (idxlist="")||($listfind(idxlist,"DUZIdx")) { set $Extract(sHandle($classname()),1)=$c(1) If $SortBegin(^BEDD.EDUserPreferencesI("DUZIdx")) }
	if (idxlist="")||($listfind(idxlist,"DUZSiteIdx")) { set $Extract(sHandle($classname()),2)=$c(1) If $SortBegin(^BEDD.EDUserPreferencesI("DUZSiteIdx")) }
	set id=""
BSLoop	set id=$order(^BEDD.EDUserPreferencesD(id)) Goto:id="" BSLoopDun
	set sc = ..%FileIndices(id,.sHandle) if ('sc) { goto BSLoopDun }
	Goto BSLoop
BSLoopDun
	if $Ascii(sHandle($classname()),1) If $SortEnd(^BEDD.EDUserPreferencesI("DUZIdx"))
	if $Ascii(sHandle($classname()),2) If $SortEnd(^BEDD.EDUserPreferencesI("DUZSiteIdx"))
	if $system.CLS.IsMthd($classname(),"%OnAfterBuildIndices") { set sc=..%OnAfterBuildIndices(.idxlist)}
	i locked { d ..%UnlockExtent(0) }
	QUIT sc
CatchError	s $ZTrap="" i $ZE'="" { s sc = $$Error^%apiOBJ(5002,$ZE) } i $g(locked) { d ..%UnlockExtent(0) } q sc }
%ComposeOid(id) public {
	set tCLASSNAME = $listget($g(^BEDD.EDUserPreferencesD(id)),1)
	if tCLASSNAME="" { quit $select(id="":"",1:$listbuild(id_"","BEDD.EDUserPreferences")) }
	set tClass=$piece(tCLASSNAME,$extract(tCLASSNAME),$length(tCLASSNAME,$extract(tCLASSNAME))-1)
	set:tClass'["." tClass="User."_tClass
	quit $select(id="":"",1:$listbuild(id_"",tClass)) }
%DeleteData(id,concurrency) public {
	Quit:id="" $$Error^%apiOBJ(5812)
	Set $Ztrap="DeleteDataERR" Set extentlock=0,sc=""
	If concurrency { If '$tlevel { Kill %0CacheLock } If $increment(%0CacheLock($classname()))>$zu(115,6) { Lock +(^BEDD.EDUserPreferencesD):$zu(115,4) Set extentlock=$test Lock:extentlock -(^BEDD.EDUserPreferencesD) } If 'extentlock { Lock +(^BEDD.EDUserPreferencesD(id)):$zu(115,4) } If '$test { QUIT $$Error^%apiOBJ(5803,$classname()) }}
	If ($Data(^BEDD.EDUserPreferencesD(id))) {
		Set bsv0N1=^BEDD.EDUserPreferencesD(id)
		If $data(^oddEXTR($classname())) {
			n %fc,%fk,%z
			Set %fc="" For  Set %fc=$order(^oddEXTR($classname(),"n","IDKEY","f",%fc)) Quit:%fc=""  Set %fk="" For  Set %fk=$order(^oddEXTR($classname(),"n","IDKEY","f",%fc,%fk)) Quit:%fk=""  Set %z=$get(^oddEXTR($classname(),"n","IDKEY","f",%fc,%fk,61)) If %z'="" Set sc=$classmethod(%fc,%fk_"Delete",id) If ('sc) Goto DeleteDataEXIT
		}
		Set bsv0N2=$listget(bsv0N1,3)
		Kill ^BEDD.EDUserPreferencesI("DUZIdx",$zu(28,bsv0N2,7,32768),id)
		Kill ^BEDD.EDUserPreferencesI("DUZSiteIdx",$zu(28,bsv0N2,7,32768),$zu(28,$listget(bsv0N1,4),7,32768),id)
		Kill ^BEDD.EDUserPreferencesD(id)
		Set sc=1
	}
	else { set sc=$$Error^%apiOBJ(5810,$classname(),id) }
DeleteDataEXIT
	If (concurrency) && ('extentlock) { Lock -(^BEDD.EDUserPreferencesD(id)) }
DeleteDataRET	Set $Ztrap = ""
	QUIT sc
DeleteDataERR	Set $Ztrap = "DeleteDataRET"
	Set sc = $$Error^%apiOBJ(5002,$ZE)
	Goto DeleteDataEXIT }
%Exists(oid="") public {
	Quit ..%ExistsId($listget(oid)) }
%ExistsId(id) public {
	try { set tExists = $s(id="":0,$d(^BEDD.EDUserPreferencesD(id)):1,1:0) } catch tException { set tExists = 0 } quit tExists }
%FileIndices(id,pIndexHandle=0) public {
	s $ZTrap="CatchError",sc=1
	Set bsv0N2=$Get(^BEDD.EDUserPreferencesD(id))
	if $listget(bsv0N2,1)'="" { set bsv0N1=$piece($listget(bsv0N2,1),$extract($listget(bsv0N2,1)),$length($listget(bsv0N2,1),$extract($listget(bsv0N2,1)))-1) set:bsv0N1'["." bsv0N1="User."_bsv0N1 if bsv0N1'=$classname() { quit $classmethod(bsv0N1,"%FileIndices",id,.pIndexHandle) } }
	If ('pIndexHandle)||($Ascii($Get(pIndexHandle("BEDD.EDUserPreferences")),1)) {
		Set bsv0N3=$zu(28,$listget(bsv0N2,3),7,32768)
		Set ^BEDD.EDUserPreferencesI("DUZIdx",bsv0N3,id)=$listget(bsv0N2,1)
	}
	If ('pIndexHandle)||($Ascii($Get(pIndexHandle("BEDD.EDUserPreferences")),2)) {
		Set bsv0N4=$zu(28,$listget(bsv0N2,4),7,32768)
		Set bsv0N5=$zu(28,$listget(bsv0N2,3),7,32768)
		Set ^BEDD.EDUserPreferencesI("DUZSiteIdx",bsv0N5,bsv0N4,id)=$listget(bsv0N2,1)
	}
	QUIT 1
CatchError	s $ZTrap="" i $ZE'="" { s sc = $$Error^%apiOBJ(5002,$ZE) } q sc }
%InsertBatch(objects,concurrency=0,useTransactions=0) public {
	s $ZTrap="InsertBatchERR"
	s numerrs=0,errs="",cnt=0,ptr=0
	while $listnext(objects,ptr,data) {
		s cnt=cnt+1,sc=1
		do
 {
			if (useTransactions) tstart
			s id=$i(^BEDD.EDUserPreferencesD)
			Set lock=0,locku=""
			If '$Tlevel { Kill %0CacheLock }
			i concurrency { If $i(%0CacheLock($classname()))>$zu(115,6) { Lock +(^BEDD.EDUserPreferencesD):$zu(115,4) Set lock=$Select($test:2,1:0) Lock:lock -(^BEDD.EDUserPreferencesD) } Else { Lock +(^BEDD.EDUserPreferencesD(id)):$zu(115,4) Set lock=$Select($test:1,1:0) } If 'lock { Set sc=$$Error^%apiOBJ(5803,$classname()) Quit } }
			s ^BEDD.EDUserPreferencesD(id)=data
			s ^BEDD.EDUserPreferencesI("DUZIdx",$zu(28,$listget(data,3),7,32768),id)=$listget(data,1)
			s ^BEDD.EDUserPreferencesI("DUZSiteIdx",$zu(28,$listget(data,3),7,32768),$zu(28,$listget(data,4),7,32768),id)=$listget(data,1)
		}
		while 0
		If lock=1 Lock -(^BEDD.EDUserPreferencesD(id))
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
	Kill ^BEDD.EDUserPreferencesD
	Quit 1
%LoadData(id)
	New sc
	Set sc=""
	If ..%Concurrency=4 Lock +(^BEDD.EDUserPreferencesD(id)):$zu(115,4) If '$test QUIT $$Error^%apiOBJ(5803,$classname())
	If ..%Concurrency'=4,..%Concurrency>1 Lock +(^BEDD.EDUserPreferencesD(id)#"S"):$zu(115,4) If '$test QUIT $$Error^%apiOBJ(5804,$classname())
	i '$d(^BEDD.EDUserPreferencesD(id)) Set i%DUZ="",i%HideComp="",i%HideDOB="",i%HideSex="",i%PatientNameFormat="",i%Site="",i%UserName="",i%UserPrefID=""
	Else  Do
	. New %s1
	. Set sc=1
	. s %s1=$g(^BEDD.EDUserPreferencesD(id))
	. s i%UserPrefID=$lg(%s1,2),i%DUZ=$lg(%s1,3),i%Site=$lg(%s1,4),i%PatientNameFormat=$lg(%s1,5),i%HideDOB=$lg(%s1,6),i%HideComp=$lg(%s1,7),i%HideSex=$lg(%s1,8),i%UserName=$lg(%s1,9)
	If ..%Concurrency=2 Lock -(^BEDD.EDUserPreferencesD(id)#"SI")
	Quit $select(sc'="":sc,1:$$Error^%apiOBJ(5809,$classname(),id))
%LoadDataFromMemory(id,objstate,obj)
	New sc
	Set sc=""
	i '$d(objstate(id)) Set i%DUZ="",i%HideComp="",i%HideDOB="",i%HideSex="",i%PatientNameFormat="",i%Site="",i%UserName="",i%UserPrefID=""
	Else  Do
	. New %s1
	. Set sc=1
	. s %s1=$g(objstate(id))
	. s i%UserPrefID=$lg(%s1,2),i%DUZ=$lg(%s1,3),i%Site=$lg(%s1,4),i%PatientNameFormat=$lg(%s1,5),i%HideDOB=$lg(%s1,6),i%HideComp=$lg(%s1,7),i%HideSex=$lg(%s1,8),i%UserName=$lg(%s1,9)
	Set sc = $select(sc'="":sc,1:$$Error^%apiOBJ(5809,$classname(),id))
	 Quit sc
%LockExtent(shared=0) public {
	if shared { l +(^BEDD.EDUserPreferencesD#"S"):$zu(115,4) if $t { q 1 } else { q $$Error^%apiOBJ(5799,$classname()) }} l +(^BEDD.EDUserPreferencesD):$zu(115,4) if $t { q 1 } else { q $$Error^%apiOBJ(5798,$classname()) }
}
%LockId(id,shared=0) public {
	if id'="" { set sc=1 } else { set sc=$$Error^%apiOBJ(5812) quit sc }
	if 'shared { Lock +(^BEDD.EDUserPreferencesD(id)):$zu(115,4) i $test { q 1 } else { q $$Error^%apiOBJ(5803,$classname()) } }
	else { Lock +(^BEDD.EDUserPreferencesD(id)#"S"):$zu(115,4) if $test { q 1 } else { q $$Error^%apiOBJ(5804,$classname()) } }
}
%NormalizeObject() public {
	If '$system.CLS.GetModified() Quit 1
	If m%DUZ Set:i%DUZ'="" i%DUZ=(..DUZNormalize(i%DUZ))
	If m%HideComp Set:i%HideComp'="" i%HideComp=(..HideCompNormalize(i%HideComp))
	If m%HideDOB Set:i%HideDOB'="" i%HideDOB=(..HideDOBNormalize(i%HideDOB))
	If m%HideSex Set:i%HideSex'="" i%HideSex=(..HideSexNormalize(i%HideSex))
	If m%PatientNameFormat Set:i%PatientNameFormat'="" i%PatientNameFormat=(..PatientNameFormatNormalize(i%PatientNameFormat))
	If m%Site Set:i%Site'="" i%Site=(..SiteNormalize(i%Site))
	If m%UserName Set:i%UserName'="" i%UserName=(..UserNameNormalize(i%UserName))
	If m%UserPrefID Set:i%UserPrefID'="" i%UserPrefID=(..UserPrefIDNormalize(i%UserPrefID))
	Quit 1 }
%OnDetermineClass(oid,class)
	New id,idclass
	Set id=$listget($get(oid)) QUIT:id="" $$Error^%apiOBJ(5812)
	Set idclass=$lg($get(^BEDD.EDUserPreferencesD(id)),1)
	If idclass="" Set class="BEDD.EDUserPreferences" Quit 1
	Set class=$piece(idclass,$extract(idclass),$length(idclass,$extract(idclass))-1)
	Set:class'["." class="User."_class
	QUIT 1
%PhysicalAddress(id,paddr)
	if $Get(id)="" Quit $$Error^%apiOBJ(5813,$classname())
	if (id="") { quit $$Error^%apiOBJ(5832,$classname(),id) }
	s paddr(1)=$lb($Name(^BEDD.EDUserPreferencesD(id)),$classname(),"IDKEY","listnode",id)
	s paddr=1
	Quit 1
%PurgeIndices(idxlist="",lockExtent=0)
	n locked,ptr,sc
	s $ZTrap="CatchError",locked=0,sc=1
	for ptr=1:1:$listlength(idxlist) { if '($d(^oddCOM($classname(),"i",$list(idxlist,ptr)))) { set sc=$$Error^%apiOBJ(5066,$classname()_"::"_$list(idxlist,ptr)) continue } } if ('sc) { quit sc }
	i lockExtent { s sc=..%LockExtent(0) i ('sc) { q sc } else { s locked=1 } }
	if $system.CLS.IsMthd($classname(),"%OnBeforeBuildIndices") { set sc=..%OnBeforePurgeIndices(.idxlist) i ('sc) { i locked { d ..%SQLReleaseTableLock(0) } quit sc } }
	If $select($listfind(idxlist,"DUZIdx"):1,idxlist="":1,1:0) Kill ^BEDD.EDUserPreferencesI("DUZIdx")
	If $select($listfind(idxlist,"DUZSiteIdx"):1,idxlist="":1,1:0) Kill ^BEDD.EDUserPreferencesI("DUZSiteIdx")
	s sc=1
	if $system.CLS.IsMthd($classname(),"%OnAfterPurgeIndices") { set sc=..%OnAfterPurgeIndices(.idxlist) }
	i locked { d ..%UnlockExtent(0) }
	QUIT sc
CatchError	s $ZTrap="" i $ZE'="" { s sc = $$Error^%apiOBJ(5002,$ZE) } i locked { d ..%UnlockExtent(0) } q sc
	i locked { d ..%UnlockExtent(0) }
	QUIT sc
%SQLAcquireLock(%rowid,s=0,unlockref)
	new %d,gotlock set %d(1)=%rowid set s=$e("S",s) lock +^BEDD.EDUserPreferencesD(%d(1))#s:$zu(115,4) set gotlock=$t set:gotlock&&$g(unlockref) unlockref($i(unlockref))=$lb($name(^BEDD.EDUserPreferencesD(%d(1))),"BEDD.EDUserPreferences") QUIT gotlock
	Quit
%SQLAcquireTableLock(s=0,SQLCODE,to="")
	set s=$e("S",s) set:to="" to=$zu(115,4) lock +^BEDD.EDUserPreferencesD#s:to QUIT:$t 1 set SQLCODE=-110 if s="S" { set %msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler35",,"BEDD"_"."_"EDUserPreferences") } else { set %msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler36",,"BEDD"_"."_"EDUserPreferences") } QUIT 0
	Quit
%SQLBuildIndices(pIndices="")
	QUIT ..%BuildIndices(pIndices)
%SQLCopyIcolIntoName()
	if %oper="DELETE" {
		set:$d(%d(1)) %f("ID")=%d(1)
		QUIT
	}
	set:$d(%d(1)) %f("ID")=%d(1) set:$a(%e,2)&&$d(%d(2)) %f("DUZ")=%d(2) set:$a(%e,3)&&$d(%d(3)) %f("HideComp")=%d(3) set:$a(%e,4)&&$d(%d(4)) %f("HideDOB")=%d(4) set:$a(%e,5)&&$d(%d(5)) %f("HideSex")=%d(5) set:$a(%e,6)&&$d(%d(6)) %f("PatientNameFormat")=%d(6) set:$a(%e,7)&&$d(%d(7)) %f("Site")=%d(7) set:$a(%e,8)&&$d(%d(8)) %f("UserName")=%d(8) set:$a(%e,9)&&$d(%d(9)) %f("UserPrefID")=%d(9) set:$a(%e,10)&&$d(%d(10)) %f("x__classname")=%d(10)
	QUIT
%SQLDefineiDjVars(%d,subs)
	QUIT
%SQLDelete(%rowid,%check,%tstart=1,%mv=0,%polymorphic=0)
	new bva,ce,%d,dc,%e,%ele,%itm,%key,%l,%nc,omcall,%oper,%pos,%s,sn,sqlcode,subs set %oper="DELETE",sqlcode=0,%ROWID=%rowid,%d(1)=%rowid,%e(1)=%rowid,%l=$c(0)
	if '$d(%0CacheSQLRA) new %0CacheSQLRA set omcall=1
	k:'$TLEVEL %0CacheLock if '$a(%check,2) { new %ls if $i(%0CacheLock("BEDD.EDUserPreferences"))>$zu(115,6) { lock +^BEDD.EDUserPreferencesD:$zu(115,4) lock:$t -^BEDD.EDUserPreferencesD set %ls=$s($t:2,1:0) } else { lock +^BEDD.EDUserPreferencesD(%d(1)):$zu(115,4) set %ls=$t } set:%ls=2 $e(%check,2)=$c(1) set:%ls=1 $e(%l)=$c(1) if '%ls set SQLCODE=-110,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler40",,%oper,"BEDD"_"."_"EDUserPreferences",$g(%d(1))) QUIT  } if %tstart { TSTART:($zu(115,1)=1)||('$TLEVEL&&($zu(115,1)=2))  } set $zt="ERRORDelete"
	do ..%SQLGetOld() if sqlcode set SQLCODE=-106 do ..%SQLEExit() QUIT  
	if %e(10)'="" set sn=$p(%e(10),$e(%e(10)),$l(%e(10),$e(%e(10)))-1) if "BEDD.EDUserPreferences"'=sn new %f do ..%SQLCopyIcolIntoName() do $classmethod(sn,"%SQLDelete",%rowid,%check,%tstart,%mv,1) QUIT  
	if '$a(%check),'$zu(115,7) do  if sqlcode set SQLCODE=sqlcode do ..%SQLEExit() QUIT  
	. new %fk,%k,%p,%st,%t,%z set %k="",%p("%1")="%d(1),",%p("IDKEY")="%d(1),"
	. for  quit:sqlcode<0  set %k=$o(^oddEXTR("BEDD.EDUserPreferences","n",%k)) quit:%k=""  set %t="" for  set %t=$o(^oddEXTR("BEDD.EDUserPreferences","n",%k,"f",%t)) quit:%t=""  set %st=(%t="BEDD.EDUserPreferences") set %fk="" for  set %fk=$order(^oddEXTR("BEDD.EDUserPreferences","n",%k,"f",%t,%fk)) quit:%fk=""  x "set %z=$classmethod(%t,%fk_""SQLFKeyRefAction"",%st,%k,"_%p(%k)_")" if %z set sqlcode=-124 quit  
	set ce="" for  { set ce=$order(^oddSQL("BEDD","EDUserPreferences","DC",ce)) quit:ce=""   do $classmethod(ce,"%SQLDeleteChildren",%d(1),%check,.sqlcode) quit:sqlcode<0  } if sqlcode<0 { set SQLCODE=sqlcode do ..%SQLEExit() QUIT } // Delete any children
	s sn(1)=$zu(28,%e(2),7) s sn(2)=%d(1) k ^BEDD.EDUserPreferencesI("DUZIdx",sn(1),sn(2))
		s sn(1)=$zu(28,%e(2),7) s sn(2)=$zu(28,%e(7),7) s sn(3)=%d(1) k ^BEDD.EDUserPreferencesI("DUZSiteIdx",sn(1),sn(2),sn(3))
	k ^BEDD.EDUserPreferencesD(%d(1))
	do ..%SQLUnlock() TCOMMIT:%tstart&&($zu(115,1)=1)
	set SQLCODE=0 kill:$g(omcall) %0CacheSQLRA QUIT
ERRORDelete	set $zt="",SQLCODE=-415,%msg=$s($g(%msg)'="":%msg_" -- ",1:"")_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler51",,%oper,"BEDD"_"."_"EDUserPreferences",$ze) if $ze["<FRAMESTACK>" { set %msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler52",,$ze,%oper,"BEDD"_"."_"EDUserPreferences") do ##Class(%SYS.System).WriteToConsoleLog(%msg) if ($zu(67,10,$j)=1)||($zu(67,10,$j)=3) { write !,%msg h 3 } HALT  } do ..%SQLEExit() QUIT
	Quit
%SQLDeleteTempStreams()
	// Delete all temporary streams
	QUIT
%SQLEExit()
	do ..%SQLUnlock() 
	if %tstart,$zu(115,1)=1,$TLEVEL { set %tstart=0 TROLLBACK 1 } kill:$g(omcall) %0CacheSQLRA QUIT  
	Quit
%SQLExists(pLockOnly=0,pUnlockRef,%pVal...)
	// SQL Foreign Key validation entry point for Foreign Key %1.  Called by FKeys that reference this key to see if the row is defined
	new id set id=%pVal(1)
	if '..%SQLGetLock(id,1,.pUnlockRef) { set sqlcode=-114,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler39",,"BEDD"_"."_"EDUserPreferences"_":"_"%1") QUIT 0 }
	if 'pLockOnly { new qv set qv=$d(^BEDD.EDUserPreferencesD(%pVal(1))) do:'$g(pUnlockRef) ..%SQLReleaseLock(id,1) quit qv } else { do:'$g(pUnlockRef) ..%SQLReleaseLock(id,1) QUIT 1 }
	Quit
%SQLGetLock(pRowId,pShared=0,pUnlockRef)
	kill:'$TLEVEL %0CacheLock
	if $i(%0CacheLock("BEDD.EDUserPreferences"))>$zu(115,6) { lock +^BEDD.EDUserPreferencesD:$zu(115,4) lock:$t -^BEDD.EDUserPreferencesD QUIT $s($t:2,1:0) } 
	QUIT ..%SQLAcquireLock(pRowId,pShared,.pUnlockRef)
%SQLGetOld()
	new s if '$d(^BEDD.EDUserPreferencesD(%d(1)),s) { set sqlcode=100 quit  } set %e(10)=$lg(s) set %e(2)=$lg(s,3) set %e(7)=$lg(s,4)
	QUIT
%SQLGetOldAll()
	new s if '$d(^BEDD.EDUserPreferencesD(%d(1)),s) { set sqlcode=100 quit  } set %e(2)=$lg(s,3) set %e(3)=$lg(s,7) set %e(4)=$lg(s,6) set %e(5)=$lg(s,8) set %e(6)=$lg(s,5) set %e(7)=$lg(s,4) set %e(8)=$lg(s,9) set %e(9)=$lg(s,2) set %e(10)=$lg(s)
	QUIT
%SQLInsert(%d,%check,%inssel,%vco,%tstart=1,%mv=0)
	new bva,%ele,%itm,%key,%l,%n,%nc,%oper,%pos,%s,sqlcode,sn,subs,icol set %oper="INSERT",sqlcode=0,%l=$c(0,0,0)
	if $d(%d(1)),'$zu(115,11) { if %d(1)'="" { set SQLCODE=-111,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler6",,"ID","BEDD"_"."_"EDUserPreferences") QUIT ""  } kill %d(1) } 
	if '$a(%check),'..%SQLValidateFields(.sqlcode) { set SQLCODE=sqlcode QUIT "" }
	do ..%SQLNormalizeFields()
	kill:'$TLEVEL %0CacheLock if %tstart { TSTART:($zu(115,1)=1)||('$TLEVEL&&($zu(115,1)=2))  } set $zt="ERRORInsert"
	if '$a(%check) do  if sqlcode<0 set SQLCODE=sqlcode do ..%SQLEExit() QUIT ""
	. if $g(%vco)'="" d @%vco quit:sqlcode<0
	if '$d(%d(1)) { set %d(1)=$i(^BEDD.EDUserPreferencesD) } elseif %d(1)>$g(^BEDD.EDUserPreferencesD) { if $i(^BEDD.EDUserPreferencesD,$zabs(%d(1)-$g(^BEDD.EDUserPreferencesD))) {}} elseif $d(^BEDD.EDUserPreferencesD(%d(1))) { set SQLCODE=-119,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler33",,"ID",%d(1),"BEDD"_"."_"EDUserPreferences"_"."_"ID") do ..%SQLEExit() QUIT "" }
	for icol=10,2,7 set:'$d(%d(icol)) %d(icol)=""
	if '$a(%check,2) { new %ls if $i(%0CacheLock("BEDD.EDUserPreferences"))>$zu(115,6) { lock +^BEDD.EDUserPreferencesD:$zu(115,4) lock:$t -^BEDD.EDUserPreferencesD set %ls=$s($t:2,1:0) } else { lock +^BEDD.EDUserPreferencesD(%d(1)):$zu(115,4) set %ls=$t } set:%ls=2 $e(%check,2)=$c(1) set:%ls=1 $e(%l)=$c(1) if '%ls set SQLCODE=-110,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler40",,%oper,"BEDD"_"."_"EDUserPreferences",$g(%d(1))) do ..%SQLEExit() QUIT ""  }
	set ^BEDD.EDUserPreferencesD(%d(1))=$lb(%d(10),$g(%d(9)),%d(2),%d(7),$g(%d(6)),$g(%d(4)),$g(%d(3)),$g(%d(5)),$g(%d(8)))
	i '$a(%check,3) { s sn(1)=$zu(28,%d(2),7) s sn(2)=%d(1) s ^BEDD.EDUserPreferencesI("DUZIdx",sn(1),sn(2))=%d(10)
		s sn(1)=$zu(28,%d(2),7) s sn(2)=$zu(28,%d(7),7) s sn(3)=%d(1) s ^BEDD.EDUserPreferencesI("DUZSiteIdx",sn(1),sn(2),sn(3))=%d(10) }
	lock:$a(%l) -^BEDD.EDUserPreferencesD(%d(1))
	TCOMMIT:%tstart&&($zu(115,1)=1)
	set SQLCODE=0 QUIT %d(1) 			// %SQLInsert
ERRORInsert	set $zt="",SQLCODE=-415,%msg=$s($g(%msg)'="":%msg_" -- ",1:"")_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler51",,%oper,"BEDD"_"."_"EDUserPreferences",$ze) if $ze["<FRAMESTACK>" { set %msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler52",,$ze,%oper,"BEDD"_"."_"EDUserPreferences") do ##Class(%SYS.System).WriteToConsoleLog(%msg) if ($zu(67,10,$j)=1)||($zu(67,10,$j)=3) { write !,%msg h 3 } HALT  } do ..%SQLEExit() QUIT ""
	Quit
%SQLInvalid(pIcol,pVal) public {
	set:$l($g(pVal))>40 pVal=$e(pVal,1,40)_"..." do:'$d(%n) ..%SQLnBuild() set %msg=$s($g(%msg)'="":%msg_$c(13,10),1:"")_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler37",,"BEDD"_"."_"EDUserPreferences"_"."_$lg(%n,pIcol),$s($g(pVal)'="":$s(pVal="":"<NULL>",pVal=$c(0):"<EMPTY STRING>",1:"'"_pVal_"'"),1:"")),sqlcode=$s(%oper="INSERT":-104,1:-105)
	QUIT sqlcode }
%SQLMissing(fname)
	set sqlcode=-108,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler47",,fname,"BEDD"_"."_"EDUserPreferences") quit
%SQLNormalizeFields()
	for %f=3,4,5 { set:$g(%d(%f))'="" %d(%f)=%d(%f)\1 }
	QUIT
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
	set x=$zobjexport(-1,18),%qrc=400,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler44",,"BEDD"_"."_"EDUserPreferences") QUIT
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
	if %nolock=0 { if '..%SQLAcquireLock(%rowid) { set %qrc=114,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler45",,"BEDD"_"."_"EDUserPreferences",%rowid),%ROWCOUNT=0 QUIT  } set:$zu(115,2) il=$zu(115,2,0) }
	new s,ul set ul=0,d(1)=%rowid if $zu(115,2)=1 { lock +^BEDD.EDUserPreferencesD(d(1))#"S":$zu(115,4) if $t { set ul=1 } else { set %qrc=114,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler46",,"BEDD"_"."_"EDUserPreferences",%rowid),%ROWCOUNT=0 quit  } }
	if '$d(^BEDD.EDUserPreferencesD(d(1)),s) { set SQLCODE=100,%qrc=100 if %nolock=0 { do:$g(il) $zu(115,2,il) }} else { set SQLCODE=0
	if qq { set d(10)=$lg(s) if d(10)'="" { new sn set sn=$p(d(10),$e(d(10)),$l(d(10),$e(d(10)))-1) if "BEDD.EDUserPreferences"'=sn { if %nolock=0 { do ..%SQLReleaseLock(%rowid,0,1) do:$g(il) $zu(115,2,il) } kill d set:sn'["." sn="User."_sn do $classmethod(sn,"%SQLQuickLoad",%rowid,%nolock,0,1) QUIT  }}}
	set d(2)=$lg(s,3) set d(3)=$lg(s,7) set d(4)=$lg(s,6) set d(5)=$lg(s,8) set d(6)=$lg(s,5) set d(7)=$lg(s,4) set d(8)=$lg(s,9) set d(9)=$lg(s,2) set d(10)=$lg(s)  }
	do ..%SQLQuickLogicalToOdbc(.d)
	if SQLCODE set %ROWCOUNT=0 set:SQLCODE<0 SQLCODE=-SQLCODE lock:ul -^BEDD.EDUserPreferencesD(d(1))#"SI" set %qrc=SQLCODE QUIT
	set:qq d=$zobjexport("BEDD.EDUserPreferences",18),d=$zobjexport(10,18) set i=-1 for  { set i=$o(d(i)) quit:i=""  set d=$zobjexport(d(i),18) } set %qrc=0,%ROWCOUNT=1 lock:ul -^BEDD.EDUserPreferencesD(d(1))#"SI" if %nolock=0 { do ..%SQLReleaseLock(%rowid,0,0) do:$g(il) $zu(115,2,il) } QUIT
	Quit
%SQLQuickLogicalToOdbc(%d)
	QUIT
%SQLQuickOdbcToLogical(%d)
	QUIT
%SQLQuickUpdate(%rowid,d,%nolock=0,pkey=0)
	// Update row with SQLRowID=%rowid with values d(icol)
	set:%nolock=2 %nolock=0
	do ..%SQLQuickOdbcToLogical(.d)
	do ..%SQLUpdate(%rowid,$c(0,%nolock=1,0,0,0,0),.d) set %ROWCOUNT='SQLCODE set:SQLCODE=100 SQLCODE=0 set %qrc=SQLCODE kill d QUIT
%SQLReleaseLock(%rowid,s=0,i=0)
	new %d set %d(1)=%rowid set s=$e("S",s)_$e("I",i) lock -^BEDD.EDUserPreferencesD(%d(1))#s set:i&&($g(%0CacheLock("BEDD.EDUserPreferences"))) %0CacheLock("BEDD.EDUserPreferences")=%0CacheLock("BEDD.EDUserPreferences")-1 QUIT
%SQLReleaseTableLock(s=0,i=0)
	set s=$e("S",s)_$e("I",i) lock -^BEDD.EDUserPreferencesD#s QUIT 1
	Quit
%SQLUnlock()
	lock:$a(%l) -^BEDD.EDUserPreferencesD(%d(1))
	QUIT
%SQLUnlockError(cname)
	set sqlcode=-110 if %oper="DELETE" { set %msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler48",,"BEDD"_"."_"EDUserPreferences",cname) } else { set %msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler49",,"BEDD"_"."_"EDUserPreferences",cname) } quit
	Quit
%SQLUpdate(%rowid,%check,%d,%vco,%tstart=1,%mv=0,%polymorphic=0)
	new %e,bva,%ele,%itm,%key,%l,%n,%nc,%oper,%pos,%s,icol,s,sn,sqlcode,subs,t set %oper="UPDATE",sqlcode=0,%ROWID=%rowid,$e(%e,1)=$c(0),%l=$c(0,0,0) if '$a(%check),'..%SQLValidateFields(.sqlcode) set SQLCODE=sqlcode QUIT
	do ..%SQLNormalizeFields() if $d(%d(1)),%d(1)'=%rowid set SQLCODE=-107,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler16",,"ID","BEDD"_"."_"EDUserPreferences") QUIT
	for icol=2:1:10 set $e(%e,icol)=$c($d(%d(icol)))
	set %d(1)=%rowid,%e(1)=%rowid
	k:'$TLEVEL %0CacheLock if '$a(%check,2) { new %ls if $i(%0CacheLock("BEDD.EDUserPreferences"))>$zu(115,6) { lock +^BEDD.EDUserPreferencesD:$zu(115,4) lock:$t -^BEDD.EDUserPreferencesD set %ls=$s($t:2,1:0) } else { lock +^BEDD.EDUserPreferencesD(%d(1)):$zu(115,4) set %ls=$t } set:%ls=2 $e(%check,2)=$c(1) set:%ls=1 $e(%l)=$c(1) if '%ls set SQLCODE=-110,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler40",,%oper,"BEDD"_"."_"EDUserPreferences",$g(%d(1))) QUIT  } if %tstart { TSTART:($zu(115,1)=1)||('$TLEVEL&&($zu(115,1)=2))  } set $zt="ERRORUpdate"
	if $g(%vco)="" { do ..%SQLGetOld() i sqlcode { s SQLCODE=-109 do ..%SQLEExit() QUIT  } for icol=10,2,7 { set:'$d(%d(icol)) %d(icol)=%e(icol) set:%d(icol)=%e(icol) $e(%e,icol)=$c(0) }} else { do ..%SQLGetOldAll() if sqlcode { set SQLCODE=-109 do ..%SQLEExit() QUIT  } for icol=2,3,4,5,6,7,8,9,10 { set:'$d(%d(icol)) %d(icol)=%e(icol) set:%d(icol)=%e(icol) $e(%e,icol)=$c(0) }}
	if %e(10)'="" set sn=$p(%e(10),$e(%e(10)),$l(%e(10),$e(%e(10)))-1) if "BEDD.EDUserPreferences"'=sn new %f do ..%SQLCopyIcolIntoName() do $classmethod(sn,"%SQLUpdate",%rowid,%check,.%d,$g(%vco),%tstart,%mv,1) QUIT
	do:'$a(%check)  if sqlcode set SQLCODE=sqlcode do ..%SQLEExit() QUIT
	. if $g(%vco)'="" d @%vco quit:sqlcode<0
	if '$a(%check,3) { 
	}
	set:$s($a(%e,2):1,$a(%e,3):1,$a(%e,4):1,$a(%e,5):1,$a(%e,6):1,$a(%e,7):1,$a(%e,8):1,$a(%e,9):1,1:$a(%e,10)) s=$g(^BEDD.EDUserPreferencesD(%d(1))),^BEDD.EDUserPreferencesD(%d(1))=$lb($s($a(%e,10):%d(10),1:$lg(s)),$s($a(%e,9):%d(9),1:$lg(s,2)),$s($a(%e,2):%d(2),1:$lg(s,3)),$s($a(%e,7):%d(7),1:$lg(s,4)),$s($a(%e,6):%d(6),1:$lg(s,5)),$s($a(%e,4):%d(4),1:$lg(s,6)),$s($a(%e,3):%d(3),1:$lg(s,7)),$s($a(%e,5):%d(5),1:$lg(s,8)),$s($a(%e,8):%d(8),1:$lg(s,9)))
	if '$a(%check,3) { 
		if $a(%e,2)||$a(%e,10) {	// DUZIdx index map
			if $a(%e,2) { s sn(1)=$zu(28,%e(2),7) s sn(2)=%d(1) k ^BEDD.EDUserPreferencesI("DUZIdx",sn(1),sn(2)) }
			s sn(1)=$zu(28,%d(2),7) s sn(2)=%d(1) s ^BEDD.EDUserPreferencesI("DUZIdx",sn(1),sn(2))=%d(10)
		}
		if $s($a(%e,2):1,$a(%e,7):1,1:$a(%e,10)) {	// DUZSiteIdx index map
			if $a(%e,2)||$a(%e,7) { s sn(1)=$zu(28,%e(2),7) s sn(2)=$zu(28,%e(7),7) s sn(3)=%d(1) k ^BEDD.EDUserPreferencesI("DUZSiteIdx",sn(1),sn(2),sn(3)) }
			s sn(1)=$zu(28,%d(2),7) s sn(2)=$zu(28,%d(7),7) s sn(3)=%d(1) s ^BEDD.EDUserPreferencesI("DUZSiteIdx",sn(1),sn(2),sn(3))=%d(10)
		}
	}
	do ..%SQLUnlock() TCOMMIT:%tstart&&($zu(115,1)=1)
	set SQLCODE=0
	QUIT
ERRORUpdate	set $zt="",SQLCODE=-415,%msg=$s($g(%msg)'="":%msg_" -- ",1:"")_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler51",,%oper,"BEDD"_"."_"EDUserPreferences",$ze) if $ze["<FRAMESTACK>" { set %msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler52",,$ze,%oper,"BEDD"_"."_"EDUserPreferences") do ##Class(%SYS.System).WriteToConsoleLog(%msg) if ($zu(67,10,$j)=1)||($zu(67,10,$j)=3) { write !,%msg h 3 } HALT  } do ..%SQLEExit() QUIT  
	Quit
%SQLValidateFields(sqlcode)
	if $g(%d(3))'="",'($$ValidateField3(%d(3))) { set sqlcode=..%SQLInvalid(3+1,%d(3)) } 
	if $g(%d(4))'="",'($$ValidateField4(%d(4))) { set sqlcode=..%SQLInvalid(4+1,%d(4)) } 
	if $g(%d(5))'="",'($$ValidateField5(%d(5))) { set sqlcode=..%SQLInvalid(5+1,%d(5)) } 
	if $g(%d(6))'="",'($s(%d(6)'[","&&(",FLFF,FLIF,ILIF,L3F2,"[(","_$select(%d(6)=$c(0):"",1:%d(6))_",")):1,1:$$Error^%apiOBJ(7205,%d(6),",FLFF,FLIF,ILIF,L3F2"))) { set sqlcode=..%SQLInvalid(6+1,%d(6)) } 
	new %f for %f=2,7,8,9 { if $g(%d(%f))'="",'(($l(%d(%f))'>50)) set sqlcode=..%SQLInvalid(%f+1,$g(%d(%f))) quit  } 
	QUIT 'sqlcode
ValidateField3(%val="")	Quit $isvalidnum(%val,0,0,2)&&(+%val'=2)
ValidateField4(%val="")	Quit $isvalidnum(%val,0,0,2)&&(+%val'=2)
ValidateField5(%val="")	Quit $isvalidnum(%val,0,0,2)&&(+%val'=2)
	Quit
%SQLnBuild() public {
	set %n=$lb(,"ID","DUZ","HideComp","HideDOB","HideSex","PatientNameFormat","Site","UserName","UserPrefID","x__classname")
	QUIT }
%SaveData(id) public {
	Set $ZTrap="SaveDataERR" Set sc=1,id=$listget(i%"%%OID") If id'="" { Set insert=0,idassigned=1 } Else { Set insert=1,idassigned=0 }
	Set lock=0,lockok=0,tSharedLock=0,locku=""
	if 'idassigned { set id=$i(^BEDD.EDUserPreferencesD) Set $zobjoid("BEDD.EDUserPreferences",id)=$this,.."%%OID"=$lb(id_"","BEDD.EDUserPreferences") set:$g(%objtxSTATUS)=2 %objtxOIDASSIGNED(+$this)="" }
	If 'insert && ('$Data(^BEDD.EDUserPreferencesD(id))) { Set insert=1 }
	If '$Tlevel { Kill %0CacheLock }
	If insert  {
		if (..%Concurrency&&$tlevel)||(..%Concurrency=4) { If (..%Concurrency < 4)&&($i(%0CacheLock($classname()))>$zu(115,6)) { Lock +(^BEDD.EDUserPreferencesD):$zu(115,4) Set lockok=$Select($test:2,1:0) Lock:lockok -(^BEDD.EDUserPreferencesD) } Else { Lock +(^BEDD.EDUserPreferencesD(id)):$zu(115,4) Set lockok=$Select($test:1,1:0) Set:..%Concurrency'=4 lock=lockok } If 'lockok { Set sc=$$Error^%apiOBJ(5803,$classname()) Goto SaveDataEXIT } }
		if ..%Concurrency=3 { Lock +(^BEDD.EDUserPreferencesD(id)#"S") set tSharedLock=1 }
		s ^BEDD.EDUserPreferencesD(id)=$lb("",i%UserPrefID,i%DUZ,i%Site,i%PatientNameFormat,i%HideDOB,i%HideComp,i%HideSex,i%UserName)
		s ^BEDD.EDUserPreferencesI("DUZIdx",$zu(28,i%DUZ,7,32768),id)=""
		s ^BEDD.EDUserPreferencesI("DUZSiteIdx",$zu(28,i%DUZ,7,32768),$zu(28,i%Site,7,32768),id)=""
	}
	Else  {
		If (..%Concurrency<4)&&(..%Concurrency) { If $i(%0CacheLock($classname()))>$zu(115,6) { Lock +(^BEDD.EDUserPreferencesD):$zu(115,4) Set lockok=$s($test:2,1:0) Lock:lockok -(^BEDD.EDUserPreferencesD) } Else { Lock +(^BEDD.EDUserPreferencesD(id)):$zu(115,4) Set lockok=$Select($test:1,1:0),lock=lockok } If 'lockok { Set sc=$$Error^%apiOBJ(5803,$classname()) Goto SaveDataEXIT } }
		Set bsv0N1=^BEDD.EDUserPreferencesD(id)
		If (i%DUZ'=$listget(bsv0N1,3)) {
			Kill ^BEDD.EDUserPreferencesI("DUZIdx",$zu(28,$listget(bsv0N1,3),7,32768),id)
			s ^BEDD.EDUserPreferencesI("DUZIdx",$zu(28,i%DUZ,7,32768),id)=""
		}
		If (i%DUZ'=$listget(bsv0N1,3))||(i%Site'=$listget(bsv0N1,4)) {
			Kill ^BEDD.EDUserPreferencesI("DUZSiteIdx",$zu(28,$listget(bsv0N1,3),7,32768),$zu(28,$listget(bsv0N1,4),7,32768),id)
			s ^BEDD.EDUserPreferencesI("DUZSiteIdx",$zu(28,i%DUZ,7,32768),$zu(28,i%Site,7,32768),id)=""
		}
		s ^BEDD.EDUserPreferencesD(id)=$lb("",i%UserPrefID,i%DUZ,i%Site,i%PatientNameFormat,i%HideDOB,i%HideComp,i%HideSex,i%UserName)
	}
SaveDataEXIT
	if (('sc)) && ('idassigned) { Set $zobjoid("",$listget(i%"%%OID"))="" Set $this."%%OID" = "" kill:$g(%objtxSTATUS)=2 %objtxOIDASSIGNED(+$this) }
	If lock Lock -(^BEDD.EDUserPreferencesD(id))
	If (('sc)) { if (tSharedLock) {  Lock -(^BEDD.EDUserPreferencesD(id)#"S") } elseif (lockok=1)&&(insert)&&(..%Concurrency=4) {  Lock -(^BEDD.EDUserPreferencesD(id)) } }
SaveDataRET	Set $Ztrap = ""
	QUIT sc
SaveDataERR	Set $Ztrap = "SaveDataRET"
	Set sc = $$Error^%apiOBJ(5002,$ZE)
	Goto SaveDataEXIT }
%SaveDirect(id="",idList="",data,concurrency=-1) public {
	Set $ZTrap="SaveDirectERR" s sc=1 i id'="" { Set insert=0,idassigned=1 } Else { Set insert=1,idassigned=0 }
	if concurrency=-1 { Set concurrency=$zu(115,10) }
	If 'idassigned { set id=$i(^BEDD.EDUserPreferencesD) }
	If 'insert && ('$Data(^BEDD.EDUserPreferencesD(id))) { Set insert=1 }
	Set lock=0,locku=""
	If '$Tlevel { Kill %0CacheLock }
	If insert  {
		i concurrency { If $i(%0CacheLock($classname()))>$zu(115,6) { Lock +(^BEDD.EDUserPreferencesD):$zu(115,4) Set lock=$Select($test:2,1:0) Lock:lock -(^BEDD.EDUserPreferencesD) } Else { Lock +(^BEDD.EDUserPreferencesD(id)):$zu(115,4) Set lock=$Select($test:1,1:0) } If 'lock { Set sc=$$Error^%apiOBJ(5803,$classname()) Goto SaveDirectEXIT } }
		s ^BEDD.EDUserPreferencesD(id)=data
		s ^BEDD.EDUserPreferencesI("DUZIdx",$zu(28,$listget(data,3),7,32768),id)=$listget(data,1)
		s ^BEDD.EDUserPreferencesI("DUZSiteIdx",$zu(28,$listget(data,3),7,32768),$zu(28,$listget(data,4),7,32768),id)=$listget(data,1)
	}
	Else  {
		i concurrency { If $i(%0CacheLock($classname()))>$zu(115,6) { Lock +(^BEDD.EDUserPreferencesD):$zu(115,4) Set lock=$s($test:2,1:0) Lock:lock -(^BEDD.EDUserPreferencesD) } Else { Lock +(^BEDD.EDUserPreferencesD(id)):$zu(115,4) Set lock=$Select($test:1,1:0) } If 'lock { Set sc=$$Error^%apiOBJ(5803,$classname()) Goto SaveDirectEXIT } }
		Set bsv0N1=$li(idList,1)
		Set bsv0N2=^BEDD.EDUserPreferencesD(bsv0N1)
		If ($listget(data,3)'=$listget(bsv0N2,3)) {
			Kill ^BEDD.EDUserPreferencesI("DUZIdx",$zu(28,$listget(bsv0N2,3),7,32768),$li(idList,1))
			s ^BEDD.EDUserPreferencesI("DUZIdx",$zu(28,$listget(data,3),7,32768),id)=$listget(data,1)
		}
		If ($listget(data,3)'=$listget(bsv0N2,3))||($listget(data,4)'=$listget(bsv0N2,4)) {
			Kill ^BEDD.EDUserPreferencesI("DUZSiteIdx",$zu(28,$listget(bsv0N2,3),7,32768),$zu(28,$listget(bsv0N2,4),7,32768),$li(idList,1))
			s ^BEDD.EDUserPreferencesI("DUZSiteIdx",$zu(28,$listget(data,3),7,32768),$zu(28,$listget(data,4),7,32768),id)=$listget(data,1)
		}
		s ^BEDD.EDUserPreferencesD(id)=data
	}
SaveDirectEXIT
	If lock=1 Lock -(^BEDD.EDUserPreferencesD(id))
SaveDirectRET	Set $Ztrap = ""
	QUIT sc
SaveDirectERR	Set $Ztrap = "SaveDirectRET"
	Set sc = $$Error^%apiOBJ(5002,$ZE)
	Goto SaveDirectEXIT }
%SaveIndices(pStartId="",pEndId="",lockExtent=0) public {
	i lockExtent { s sc=..%LockExtent(0) i ('sc) { q sc } }
	s id=$order(^BEDD.EDUserPreferencesD(pStartId),-1),tEndId=$S(pEndId'="":pEndId,1:pStartId)
BSLoop	s id=$O(^BEDD.EDUserPreferencesD(id)) g:(id="")||(id]]tEndId) BSLoopDun
	Set bsv0N1=$Get(^BEDD.EDUserPreferencesD(id))
	Set bsv0N2=$zu(28,$listget(bsv0N1,3),7,32768)
	Set ^BEDD.EDUserPreferencesI("DUZIdx",bsv0N2,id)=$listget(bsv0N1,1)
	Set bsv0N3=$zu(28,$listget(bsv0N1,4),7,32768)
	Set bsv0N4=$zu(28,$listget(bsv0N1,3),7,32768)
	Set ^BEDD.EDUserPreferencesI("DUZSiteIdx",bsv0N4,bsv0N3,id)=$listget(bsv0N1,1)
	g BSLoop
BSLoopDun
	i lockExtent { d ..%UnlockExtent(0) }
	QUIT 1
CatchError	s $ZTrap="" i $ZE'="" { s sc = $$Error^%apiOBJ(5002,$ZE) } i lockExtent { d ..%UnlockExtent(0) } q sc }
%SortBegin(idxlist="",excludeunique=0)
	if $select(idxlist="":1,$listfind(idxlist,"DUZIdx"):1,1:0) If $SortBegin(^BEDD.EDUserPreferencesI("DUZIdx"))
	if $select(idxlist="":1,$listfind(idxlist,"DUZSiteIdx"):1,1:0) If $SortBegin(^BEDD.EDUserPreferencesI("DUZSiteIdx"))
	Quit 1
%SortEnd(idxlist="",commit=1)
	if $select(idxlist="":1,$listfind(idxlist,"DUZIdx"):1,1:0) If $SortEnd(^BEDD.EDUserPreferencesI("DUZIdx"),commit)
	if $select(idxlist="":1,$listfind(idxlist,"DUZSiteIdx"):1,1:0) If $SortEnd(^BEDD.EDUserPreferencesI("DUZSiteIdx"),commit)
	Quit 1
%UnlockExtent(shared=0,immediate=0) public {
	if ('immediate)&&('shared) { l -^BEDD.EDUserPreferencesD q 1 } elseif (immediate)&&('shared) { l -^BEDD.EDUserPreferencesD#"I" q 1 } elseif ('immediate)&&(shared) { l -^BEDD.EDUserPreferencesD#"S" q 1 } else { l -^BEDD.EDUserPreferencesD#"SI" q 1 }
}
%UnlockId(id,shared=0,immediate=0) public {
	if ('immediate)&&('shared) { Lock -(^BEDD.EDUserPreferencesD(id)) q 1 } elseif (immediate)&&('shared) { Lock -(^BEDD.EDUserPreferencesD(id)#"I") q 1 } elseif ('immediate)&&(shared) { Lock -(^BEDD.EDUserPreferencesD(id)#"S") q 1 } else { Lock -(^BEDD.EDUserPreferencesD(id)#"SI") q 1 }
}
%ValidateObject(force=0) public {
	Set sc=1
	If '$system.CLS.GetModified() Quit sc
	If m%DUZ Set iv=..DUZ If iv'="" Set rc=(..DUZIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"DUZ",iv)
	If m%HideComp Set iv=..HideComp If iv'="" Set rc=(..HideCompIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"HideComp",iv)
	If m%HideDOB Set iv=..HideDOB If iv'="" Set rc=(..HideDOBIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"HideDOB",iv)
	If m%HideSex Set iv=..HideSex If iv'="" Set rc=(..HideSexIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"HideSex",iv)
	If m%PatientNameFormat Set iv=..PatientNameFormat If iv'="" Set rc=(..PatientNameFormatIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"PatientNameFormat",iv)
	If m%Site Set iv=..Site If iv'="" Set rc=(..SiteIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"Site",iv)
	If m%UserName Set iv=..UserName If iv'="" Set rc=(..UserNameIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"UserName",iv)
	If m%UserPrefID Set iv=..UserPrefID If iv'="" Set rc=(..UserPrefIDIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"UserPrefID",iv)
	Quit sc }
zDUZGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDUserPreferencesD(id)),3),1:"") }
zHideCompDisplayToLogical(%val) public {
	Quit ''%val }
zHideCompGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDUserPreferencesD(id)),7),1:"") }
zHideCompIsValid(%val="") public {
	Q $s($isvalidnum(%val,0,0,2)&&(+%val'=2):1,1:$$Error^%apiOBJ(7206,%val)) }
zHideCompNormalize(%val) public {
	Quit %val\1 }
zHideDOBGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDUserPreferencesD(id)),6),1:"") }
zHideSexGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDUserPreferencesD(id)),8),1:"") }
zPatientNameFormatGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDUserPreferencesD(id)),5),1:"") }
zPatientNameFormatIsValid(%val) public {
	Q $s(%val'[","&&(",FLFF,FLIF,ILIF,L3F2,"[(","_$select(%val=$c(0):"",1:%val)_",")):1,1:$$Error^%apiOBJ(7205,%val,",FLFF,FLIF,ILIF,L3F2")) }
zSiteGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDUserPreferencesD(id)),4),1:"") }
zUserNameGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDUserPreferencesD(id)),9),1:"") }
zUserPrefIDGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDUserPreferencesD(id)),2),1:"") }
zExtentExecute(%qHandle) [ SQLCODE,c1 ] public { New %ROWCOUNT,%ROWID,%msg,SQLCODE,c1 
	Set sc=1
	s %qHandle=$i(%objcn)
	 ;---&sql(DECLARE QExtent CURSOR FOR
 	 ;---		 SELECT ID FROM BEDD.EDUserPreferences)
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
	Do %0Eo
	If 'SQLCODE { Set Row=$lb(c1) Set sc=1 } ElseIf SQLCODE=100 { Set AtEnd=1,sc=1 Set:$isobject($g(%sqlcontext)) %sqlcontext.%SQLCODE=SQLCODE,%sqlcontext.%ROWCOUNT=$g(%ROWCOUNT) } Else { Set:$isobject($g(%sqlcontext)) %sqlcontext.%SQLCODE=SQLCODE,%sqlcontext.Message=$g(%msg) Set AtEnd=1,sc=$$Error^%apiOBJ(5540,SQLCODE,$get(%msg)) }
	QUIT sc }
zExtentFetchRows(%qHandle,FetchCount=0,RowSet,ReturnCount,AtEnd) [ SQLCODE,c1 ] public { New %ROWCOUNT,%ROWID,%msg,SQLCODE,c1 
	Set RowSet="",ReturnCount=0,AtEnd=0
	For {
		 ;---&sql(FETCH QExtent INTO :c1)
 		 ;--- ** SQL PUBLIC Variables: %ROWCOUNT, %ROWID, %msg, SQLCODE, c1
		Do %0Fo
		If 'SQLCODE { Set RowSet=RowSet_$lb(c1),ReturnCount=ReturnCount+1 Quit:(ReturnCount=FetchCount)||(($l(RowSet)+($l(RowSet)\ReturnCount))>24000) } Else { Set AtEnd=1 Quit }
	}
	If 'SQLCODE { Set sc=1 } ElseIf SQLCODE=100 { Set sc=1 Set:$isobject($g(%sqlcontext)) %sqlcontext.%SQLCODE=SQLCODE,%sqlcontext.%ROWCOUNT=$g(%ROWCOUNT) } Else { Set:$isobject($g(%sqlcontext)) %sqlcontext.%SQLCODE=SQLCODE,%sqlcontext.Message=$g(%msg) Set sc=$$Error^%apiOBJ(5540,SQLCODE,$get(%msg)) }
	Quit sc }
 q
%QExtent0o 
 s $zt="%QExtent0E" s SQLCODE=$s($g(%objcsc(%qHandle)):-101,1:0) q:SQLCODE'=0  s %objcsd(%qHandle,1)=0 set:$d(%0CacheRowLimit)#2 %objcsd(%qHandle,2)=%0CacheRowLimit s %objcsd(%qHandle,3)=0,%objcsd(%qHandle,4)="" d:$zu(115,15) $system.ECP.Sync()
 s %objcsc(%qHandle)=1 q
%QExtent0E s $zt="" d SQLRunTimeError^%apiSQL($ze,.SQLCODE,.%msg) k %objcsd(%qHandle),%objcsc(%qHandle),%objcss(%qHandle),%objcst(%qHandle),%objcsp(%qHandle) q
%0Afirst 
 ; asl MOD# 2
 s %objcsd(%qHandle,5)=""
%0AmBk1 s %objcsd(%qHandle,5)=$o(^BEDD.EDUserPreferencesI("DUZIdx",%objcsd(%qHandle,5)))
 i %objcsd(%qHandle,5)="" g %0AmBdun
 s %objcsd(%qHandle,6)=""
%0AmBk2 s:%objcsd(%qHandle,5)="" %objcsd(%qHandle,5)=-1E14
 s %objcsd(%qHandle,6)=$o(^BEDD.EDUserPreferencesI("DUZIdx",%objcsd(%qHandle,5),%objcsd(%qHandle,6)))
 i %objcsd(%qHandle,6)="" g %0AmBk1
 s:%objcsd(%qHandle,5)=-1E14 %objcsd(%qHandle,5)=""
 g:$zu(115,2)=0 %0AmBuncommitted i $zu(115,2)=1 l +^BEDD.EDUserPreferencesD($p(%objcsd(%qHandle,6),"||",1))#"S":$zu(115,4) i $t { s %objcsd(%qHandle,3)=1,%objcsd(%qHandle,4)=$name(^BEDD.EDUserPreferencesD($p(%objcsd(%qHandle,6),"||",1)))_"#""SI""" } else { s SQLCODE=-114,%msg="Unable to acquire shared lock on table BEDD.EDUserPreferences for RowID value: "_%objcsd(%qHandle,6) ztrap "LOCK"  }
 ; asl MOD# 3
 i %objcsd(%qHandle,6)'="",$d(^BEDD.EDUserPreferencesD(%objcsd(%qHandle,6)))
 e  g %0AmCdun
%0AmBuncommitted ;
 s:$g(SQLCODE)'<0 SQLCODE=0 s %objcsd(%qHandle,1)=%objcsd(%qHandle,1)+1,%ROWCOUNT=%objcsd(%qHandle,1),%ROWID=%objcsd(%qHandle,6),%objcsc(%qHandle)=10 q
%QExtent0f i '$g(%objcsc(%qHandle)) { s SQLCODE=-102 q  } i %objcsc(%qHandle)=100 { s SQLCODE=100 q  } s SQLCODE=0
 s $zt="%0Aerr"
 i $d(%objcsd(%qHandle,2))#2,$g(%objcsd(%qHandle,1))'<%objcsd(%qHandle,2) { s SQLCODE=100,%ROWCOUNT=%objcsd(%qHandle,1),%objcsc(%qHandle)=100 q }
 g %0Afirst:%objcsc(%qHandle)=1
%0AmCdun if $zu(115,2)=1 { if $g(%objcsd(%qHandle,3))=1 { l -@%objcsd(%qHandle,4) s %objcsd(%qHandle,3)=0 } elseif $g(%objcsd(%qHandle,3))=2 { do $classmethod($li(%objcsd(%qHandle,4)),"%UnlockId",$li(%objcsd(%qHandle,4),2),1,1)  s %objcsd(%qHandle,3)=0 } }
 g %0AmBk2
%0AmBdun 
%0AmAdun 
 s %ROWCOUNT=%objcsd(%qHandle,1),SQLCODE=100,%objcsc(%qHandle)=100 q
%QExtent0c i '$g(%objcsc(%qHandle)) { s SQLCODE=-102 q  }
 s %ROWCOUNT=$s($g(SQLCODE)'<0:+$g(%objcsd(%qHandle,1)),1:0)
 if $zu(115,2)=1 { if $g(%objcsd(%qHandle,3))=1 { l -@%objcsd(%qHandle,4) } elseif $g(%objcsd(%qHandle,3))=2 { do $classmethod($li(%objcsd(%qHandle,4)),"%UnlockId",$li(%objcsd(%qHandle,4),2),1,1)  } }
 k %objcsd(%qHandle),%objcsc(%qHandle) s SQLCODE=0 q
%0Aerr s $zt="" d SQLRunTimeError^%apiSQL($ze,.SQLCODE,.%msg)
 s %objcsc(%qHandle)=100 q
%0Eo d %QExtent0f q:SQLCODE'=0
 s c1=%objcsd(%qHandle,6)
 q
%0Fo d %QExtent0f q:SQLCODE'=0
 s c1=%objcsd(%qHandle,6)
 q
zExtentFunc() public {
	try {
		set tSchemaPath = ##class(%SQL.Statement).%ClassPath($classname())
			set tStatement = ##class(%SQL.Statement).%New(,tSchemaPath)
			do tStatement.prepare(" SELECT ID FROM BEDD . EDUserPreferences")
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
	If $Get(^oddPROC("BEDD","EDUSERPREFERENCES_EXTENT",21))'="" { Set sc = 1, metadata=$Select(version=4:^oddPROC("BEDD","EDUSERPREFERENCES_EXTENT",12),1:^oddPROC("BEDD","EDUSERPREFERENCES_EXTENT",12,version)) }
	ElseIf $Data(^oddPROC("BEDD","EDUSERPREFERENCES_EXTENT")) { Set sc = $$CompileSignature^%ourProcedure("BEDD","EDUSERPREFERENCES_EXTENT",.metadata,.signature) }
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
zDUZIdxExists(K1,id="")
	new %ROWCOUNT,SQLCODE,temp
	 ;---&sql(SELECT %ID INTO :id FROM BEDD.EDUserPreferences WHERE (:K1 is not null and DUZ = :K1) OR (:K1 IS NULL AND DUZ IS NULL))
 	 ;--- ** SQL PUBLIC Variables: %ROWCOUNT, %ROWID, %msg, K1, SQLCODE, id
	Do %0Go
	Quit $select('SQLCODE:1,1:0)
 q
%0Go 
 n %mmmsqlc,%mmmsqld,%mmmsqlE,%mmmsqll,%mmmsqln,%mmmsqlp,%mmmsqlR,%mmmsqls,%mmmsqlt,%mmmsqlZ s $zt="%0Gerr" s %mmmsqld(1)=0,%mmmsqld(2)="" d:$zu(115,15) $system.ECP.Sync()
 s %mmmsqld(3)=$g(K1),%mmmsqld(4)=$g(K1),%mmmsqld(5)=$g(K1),%mmmsqld(6)=" "
 s SQLCODE=100
 s %mmmsqld(7)=$zu(28,%mmmsqld(4),7)
 ; asl MOD# 2
 s %mmmsqld(8)=%mmmsqld(7) s:%mmmsqld(8)="" %mmmsqld(8)=-1E14
 s %mmmsqld(9)="",%mmmsqld(10)=1,%mmmsqld(11)="",%mmmsqld(12)=1,%mmmsqld(13)=""
 g %0GmBk1
%0GmBqt1 s %mmmsqld(9)="" q
%0GmBpt1 s %mmmsqld(10)=0
 i '(%mmmsqld(3)'="") g %0GmBqt1
 s %mmmsqld(14)=%mmmsqld(7)
 g %0GmBqt1:%mmmsqld(14)=""
 i '(%mmmsqld(14)'=" ") g %0GmBqt1
 g %0GmBft1:%mmmsqld(9)=""
%0GmBat1 g %0GmBpt1:%mmmsqld(10)
 g %0GmBgt1:$d(^BEDD.EDUserPreferencesI("DUZIdx",%mmmsqld(14),%mmmsqld(9)))
%0GmBft1 g %0GmBpt1:%mmmsqld(10)
 s %mmmsqld(9)=$o(^BEDD.EDUserPreferencesI("DUZIdx",%mmmsqld(14),%mmmsqld(9)))
 q:%mmmsqld(9)=""
%0GmBgt1 q
%0GmBqt2 s %mmmsqld(11)="" q
%0GmBpt2 s %mmmsqld(12)=0
 i '(%mmmsqld(5)="") g %0GmBqt2
 s %mmmsqld(15)=%mmmsqld(6)
 g %0GmBqt2:%mmmsqld(15)=""
 g %0GmBft2:%mmmsqld(11)=""
%0GmBat2 g %0GmBpt2:%mmmsqld(12)
 g %0GmBgt2:$d(^BEDD.EDUserPreferencesI("DUZIdx",%mmmsqld(15),%mmmsqld(11)))
%0GmBft2 g %0GmBpt2:%mmmsqld(12)
 s %mmmsqld(11)=$o(^BEDD.EDUserPreferencesI("DUZIdx",%mmmsqld(15),%mmmsqld(11)))
 q:%mmmsqld(11)=""
%0GmBgt2 q
%0GmBat3 i %mmmsqld(9)="",%mmmsqld(11)="" s %mmmsqld(9)=%mmmsqld(13) d %0GmBat1 s %mmmsqld(11)=%mmmsqld(13) d %0GmBat2 g %0GmBgt3
 i %mmmsqld(9)'="",%mmmsqld(13)]]%mmmsqld(9) s %mmmsqld(9)=%mmmsqld(13) d %0GmBat1
 i %mmmsqld(11)'="",%mmmsqld(13)]]%mmmsqld(11) s %mmmsqld(11)=%mmmsqld(13) d %0GmBat2
 g %0GmBgt3
%0GmBft3 d %0GmBft1:%mmmsqld(9)=%mmmsqld(13),%0GmBft2:%mmmsqld(11)=%mmmsqld(13)
%0GmBgt3 s %mmmsqld(13)=$S(%mmmsqld(9)="":%mmmsqld(11),%mmmsqld(11)="":%mmmsqld(9),%mmmsqld(11)]]%mmmsqld(9):%mmmsqld(9),1:%mmmsqld(11)) q
%0GmBk1 d %0GmBft3
 i %mmmsqld(13)="" g %0GmBdun
 s id=%mmmsqld(13)
 g:$zu(115,2)=0 %0GmBuncommitted i $zu(115,2)=1 l +^BEDD.EDUserPreferencesD($p(id,"||",1))#"S":$zu(115,4) i $t { s %mmmsqld(1)=1,%mmmsqld(2)=$name(^BEDD.EDUserPreferencesD($p(id,"||",1)))_"#""SI""" } else { s SQLCODE=-114,%msg="Unable to acquire shared lock on table BEDD.EDUserPreferences for RowID value: "_id ztrap "LOCK"  }
 ; asl MOD# 3
 i id'="",$d(^BEDD.EDUserPreferencesD(id))
 e  g %0GmCdun
 s %mmmsqld(16)=$g(^BEDD.EDUserPreferencesD(id)) s %mmmsqld(17)=$lg(%mmmsqld(16),3) s %mmmsqld(8)=$zu(28,%mmmsqld(17),7)
 g:'(((%mmmsqld(8)'=" ")&&((%mmmsqld(3)'="")&&(%mmmsqld(8)=%mmmsqld(7))))||((%mmmsqld(5)="")&&(%mmmsqld(8)=" "))) %0GmCdun
%0GmBuncommitted ;
 s SQLCODE=0 g %0Gc
%0GmCdun if $zu(115,2)=1 { if $g(%mmmsqld(1))=1 { l -@%mmmsqld(2) s %mmmsqld(1)=0 } elseif $g(%mmmsqld(1))=2 { do $classmethod($li(%mmmsqld(2)),"%UnlockId",$li(%mmmsqld(2),2),1,1)  s %mmmsqld(1)=0 } }
 g %0GmBk1
%0GmBdun 
%0GmAdun 
%0Gc s %ROWCOUNT='SQLCODE
 if $zu(115,2)=1 { if $g(%mmmsqld(1))=1 { l -@%mmmsqld(2) } elseif $g(%mmmsqld(1))=2 { do $classmethod($li(%mmmsqld(2)),"%UnlockId",$li(%mmmsqld(2),2),1,1)  } }
 q
%0Gerr s $zt="" d SQLRunTimeError^%apiSQL($ze,.SQLCODE,.%msg)
 g %0Gc
zDUZSiteIdxExists(K1,K2,id="")
	new %ROWCOUNT,SQLCODE,temp
	 ;---&sql(SELECT %ID INTO :id FROM BEDD.EDUserPreferences WHERE ((DUZ=:K1 OR DUZ IS NULL) AND (DUZ=:K1 or (:K1 IS NULL AND DUZ IS NULL))) AND ((Site=:K2 OR Site IS NULL) AND ((Site=:K2) OR (:K2 IS NULL AND Site IS NULL))))
 	 ;--- ** SQL PUBLIC Variables: %ROWCOUNT, %ROWID, %msg, K1, K2, SQLCODE, id
	Do %0Io
	Quit $select('SQLCODE:1,1:0)
 q
%0Io 
 n %mmmsqlc,%mmmsqld,%mmmsqlE,%mmmsqll,%mmmsqln,%mmmsqlp,%mmmsqlR,%mmmsqls,%mmmsqlt,%mmmsqlZ s $zt="%0Ierr" s %mmmsqld(1)=0,%mmmsqld(2)="" d:$zu(115,15) $system.ECP.Sync()
 s %mmmsqld(3)=$g(K1),%mmmsqld(4)=$g(K1),%mmmsqld(5)=$g(K1),%mmmsqld(6)=$g(K2),%mmmsqld(7)=$g(K2),%mmmsqld(8)=$g(K2),%mmmsqld(9)=" ",%mmmsqld(10)=" ",%mmmsqld(11)=" ",%mmmsqld(12)=" "
 s SQLCODE=100
 s %mmmsqld(13)=$zu(28,%mmmsqld(7),7)
 s %mmmsqld(14)=$zu(28,%mmmsqld(4),7)
 k %mmmsqld(15) s %mmmsqld(15,$s(%mmmsqld(12)'="":%mmmsqld(12),1:-1E14))=""
 k %mmmsqld(16) s %mmmsqld(16,$s($zu(28,%mmmsqld(6),7)'="":$zu(28,%mmmsqld(6),7),1:-1E14))="" s %mmmsqld(16,$s(%mmmsqld(10)'="":%mmmsqld(10),1:-1E14))=""
 k %mmmsqld(17) m %mmmsqld(17)=%mmmsqld(16) k %mmmsqld(17," ")
 k %mmmsqld(18) m %mmmsqld(18)=%mmmsqld(15),%mmmsqld(18)=%mmmsqld(17)
 k %mmmsqld(19) s %mmmsqld(19,$s(%mmmsqld(11)'="":%mmmsqld(11),1:-1E14))=""
 k %mmmsqld(20) s %mmmsqld(20,$s($zu(28,%mmmsqld(3),7)'="":$zu(28,%mmmsqld(3),7),1:-1E14))="" s %mmmsqld(20,$s(%mmmsqld(9)'="":%mmmsqld(9),1:-1E14))=""
 k %mmmsqld(21) m %mmmsqld(21)=%mmmsqld(20) k %mmmsqld(21," ")
 k %mmmsqld(22) m %mmmsqld(22)=%mmmsqld(19),%mmmsqld(22)=%mmmsqld(21)
 ; asl MOD# 2
 s %mmmsqld(23)=""
%0ImBk1 s %mmmsqld(23)=$o(%mmmsqld(22,%mmmsqld(23)))
 g:%mmmsqld(23)="" %0ImBdun
 s %mmmsqld(24)=$s(%mmmsqld(23)'=-1E14:%mmmsqld(23),1:"")
 s:%mmmsqld(24)="" %mmmsqld(24)=-1E14
 i '((($s(%mmmsqld(24)'=-1E14:%mmmsqld(24),1:"")'=" ")&&($s(%mmmsqld(24)'=-1E14:%mmmsqld(24),1:"")=%mmmsqld(14)))||((%mmmsqld(5)="")&&($s(%mmmsqld(24)'=-1E14:%mmmsqld(24),1:"")=" "))) g %0ImBk1
 s %mmmsqld(25)=""
%0ImBk2 s %mmmsqld(25)=$o(%mmmsqld(18,%mmmsqld(25)))
 g:%mmmsqld(25)="" %0ImBk1
 s %mmmsqld(26)=$s(%mmmsqld(25)'=-1E14:%mmmsqld(25),1:"")
 s:%mmmsqld(26)="" %mmmsqld(26)=-1E14
 i '((($s(%mmmsqld(26)'=-1E14:%mmmsqld(26),1:"")'=" ")&&($s(%mmmsqld(26)'=-1E14:%mmmsqld(26),1:"")=%mmmsqld(13)))||((%mmmsqld(8)="")&&($s(%mmmsqld(26)'=-1E14:%mmmsqld(26),1:"")=" "))) g %0ImBk2
 s id=""
%0ImBk3 s:%mmmsqld(24)="" %mmmsqld(24)=-1E14 s:%mmmsqld(26)="" %mmmsqld(26)=-1E14
 s id=$o(^BEDD.EDUserPreferencesI("DUZSiteIdx",%mmmsqld(24),%mmmsqld(26),id))
 i id="" g %0ImBk2
 s:%mmmsqld(24)=-1E14 %mmmsqld(24)="" s:%mmmsqld(26)=-1E14 %mmmsqld(26)=""
 g:$zu(115,2)=0 %0ImBuncommitted i $zu(115,2)=1 l +^BEDD.EDUserPreferencesD($p(id,"||",1))#"S":$zu(115,4) i $t { s %mmmsqld(1)=1,%mmmsqld(2)=$name(^BEDD.EDUserPreferencesD($p(id,"||",1)))_"#""SI""" } else { s SQLCODE=-114,%msg="Unable to acquire shared lock on table BEDD.EDUserPreferences for RowID value: "_id ztrap "LOCK"  }
 ; asl MOD# 3
 s %mmmsqld(27)=$lb(""_%mmmsqld(24),""_%mmmsqld(26))
 i id'="",$d(^BEDD.EDUserPreferencesD(id))
 e  g %0ImCdun
 s %mmmsqld(28)=$g(^BEDD.EDUserPreferencesD(id)) s %mmmsqld(29)=$lg(%mmmsqld(28),3) s %mmmsqld(24)=$zu(28,%mmmsqld(29),7) s %mmmsqld(30)=$lg(%mmmsqld(28),4) s %mmmsqld(26)=$zu(28,%mmmsqld(30),7)
 s %mmmsqld(31)=$lb(""_%mmmsqld(24),""_%mmmsqld(26))
 g:%mmmsqld(27)'=%mmmsqld(31) %0ImCdun
%0ImBuncommitted ;
 s SQLCODE=0 g %0Ic
%0ImCdun if $zu(115,2)=1 { if $g(%mmmsqld(1))=1 { l -@%mmmsqld(2) s %mmmsqld(1)=0 } elseif $g(%mmmsqld(1))=2 { do $classmethod($li(%mmmsqld(2)),"%UnlockId",$li(%mmmsqld(2),2),1,1)  s %mmmsqld(1)=0 } }
 g %0ImBk3
%0ImBdun  s:$g(%mmmsqld(24))=-1E14 %mmmsqld(24)="" s:$g(%mmmsqld(26))=-1E14 %mmmsqld(26)=""
%0ImAdun 
%0Ic s %ROWCOUNT='SQLCODE
 if $zu(115,2)=1 { if $g(%mmmsqld(1))=1 { l -@%mmmsqld(2) } elseif $g(%mmmsqld(1))=2 { do $classmethod($li(%mmmsqld(2)),"%UnlockId",$li(%mmmsqld(2),2),1,1)  } }
 q
%0Ierr s $zt="" d SQLRunTimeError^%apiSQL($ze,.SQLCODE,.%msg)
 g %0Ic
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
	if '..%SQLGetLock(id,1,.pUnlockRef) { set sqlcode=-114,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler39",,"BEDD"_"."_"EDUserPreferences"_":"_"IDKEY") QUIT 0 }
	if 'pLockOnly { new qv set qv=$d(^BEDD.EDUserPreferencesD(%pVal(1))) do:'$g(pUnlockRef) ..%SQLReleaseLock(id,1) quit qv } else { do:'$g(pUnlockRef) ..%SQLReleaseLock(id,1) QUIT 1 }
	Quit
zIDKEYSQLFindPKeyByConstraint(%con)
 QUIT $$Error^%apiOBJ(5758,"%Persistent::IDKEYSQLFindPKeyByConstraint")
zIDKEYSQLFindRowIDByConstraint(%con,pInternal=0)
 QUIT $$Error^%apiOBJ(5758,"%Persistent::IDKEYSQLFindRowIDByConstraint")