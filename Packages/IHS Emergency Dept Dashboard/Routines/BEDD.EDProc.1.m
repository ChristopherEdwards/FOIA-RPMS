 ;BEDD.EDProc.1
 ;(C)InterSystems, generated for class BEDD.EDProc.  Do NOT edit. 10/29/2015 07:58:19AM
 ;;63545354;BEDD.EDProc
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
 s proporef=..ProcNotes
   d:RegisterOref InitObjVar^%SYS.BINDSRV($this)
   i dev'="" s t=$io u dev i $zobjexport($this_"",3)+$zobjexport($this."%%OID",3)+$zobjexport($this,3)!1 u t
 If AllowedDepth>0 Set AllowedDepth = AllowedDepth - 1
 If AllowedCapacity>0 Set AllowedCapacity = AllowedCapacity - 1/1
 s proporef=..ProcNotes
   Quit sc }
%BuildIndices(idxlist="",autoPurge=0,lockExtent=0) public {
	if $ll(idxlist) { quit $$Error^%apiOBJ(5066,$classname()_"::"_$ListToString(idxlist)) } QUIT 1 }
%ComposeOid(id) public {
	set tCLASSNAME = $listget($g(^BEDD.EDProcD(id)),1)
	if tCLASSNAME="" { quit $select(id="":"",1:$listbuild(id_"","BEDD.EDProc")) }
	set tClass=$piece(tCLASSNAME,$extract(tCLASSNAME),$length(tCLASSNAME,$extract(tCLASSNAME))-1)
	set:tClass'["." tClass="User."_tClass
	quit $select(id="":"",1:$listbuild(id_"",tClass)) }
%ConstructCloneInit(object,deep=0,cloned,location) public {
	If i%ProcNotes'=""||($isobject(r%ProcNotes)=1) Set r%ProcNotes=..ProcNotes.%ConstructClone(deep,.cloned),i%ProcNotes=""
	Set i%"%%OID"=""
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
	Set stream=oref.ProcNotesGetObject() If stream'="" set ^||%isc.strd($i(^||%isc.strd))=$lb(stream,"%Library.GlobalCharacterStream")
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
	If concurrency { If '$tlevel { Kill %0CacheLock } If $increment(%0CacheLock($classname()))>$zu(115,6) { Lock +(^BEDD.EDProcD):$zu(115,4) Set extentlock=$test Lock:extentlock -(^BEDD.EDProcD) } If 'extentlock { Lock +(^BEDD.EDProcD(id)):$zu(115,4) } If '$test { QUIT $$Error^%apiOBJ(5803,$classname()) }}
	If ($Data(^BEDD.EDProcD(id))) {
		If $data(^oddEXTR($classname())) {
			n %fc,%fk,%z
			Set %fc="" For  Set %fc=$order(^oddEXTR($classname(),"n","IDKEY","f",%fc)) Quit:%fc=""  Set %fk="" For  Set %fk=$order(^oddEXTR($classname(),"n","IDKEY","f",%fc,%fk)) Quit:%fk=""  Set %z=$get(^oddEXTR($classname(),"n","IDKEY","f",%fc,%fk,61)) If %z'="" Set sc=$classmethod(%fc,%fk_"Delete",id) If ('sc) Goto DeleteDataEXIT
		}
		Kill ^BEDD.EDProcD(id)
		Set sc=1
	}
	else { set sc=$$Error^%apiOBJ(5810,$classname(),id) }
DeleteDataEXIT
	If (concurrency) && ('extentlock) { Lock -(^BEDD.EDProcD(id)) }
DeleteDataRET	Set $Ztrap = ""
	QUIT sc
DeleteDataERR	Set $Ztrap = "DeleteDataRET"
	Set sc = $$Error^%apiOBJ(5002,$ZE)
	Goto DeleteDataEXIT }
%Exists(oid="") public {
	Quit ..%ExistsId($listget(oid)) }
%ExistsId(id) public {
	try { set tExists = $s(id="":0,$d(^BEDD.EDProcD(id)):1,1:0) } catch tException { set tExists = 0 } quit tExists }
%InsertBatch(objects,concurrency=0,useTransactions=0) public {
	s $ZTrap="InsertBatchERR"
	s numerrs=0,errs="",cnt=0,ptr=0
	while $listnext(objects,ptr,data) {
		s cnt=cnt+1,sc=1
		do
 {
			if (useTransactions) tstart
			s id=$i(^BEDD.EDProcD)
			Set lock=0,locku=""
			If '$Tlevel { Kill %0CacheLock }
			i concurrency { If $i(%0CacheLock($classname()))>$zu(115,6) { Lock +(^BEDD.EDProcD):$zu(115,4) Set lock=$Select($test:2,1:0) Lock:lock -(^BEDD.EDProcD) } Else { Lock +(^BEDD.EDProcD(id)):$zu(115,4) Set lock=$Select($test:1,1:0) } If 'lock { Set sc=$$Error^%apiOBJ(5803,$classname()) Quit } }
			s ^BEDD.EDProcD(id)=data
		}
		while 0
		If lock=1 Lock -(^BEDD.EDProcD(id))
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
	Kill ^BEDD.EDProcD
	Quit 1
%LoadData(id)
	New sc
	Set sc=""
	If ..%Concurrency=4 Lock +(^BEDD.EDProcD(id)):$zu(115,4) If '$test QUIT $$Error^%apiOBJ(5803,$classname())
	If ..%Concurrency'=4,..%Concurrency>1 Lock +(^BEDD.EDProcD(id)#"S"):$zu(115,4) If '$test QUIT $$Error^%apiOBJ(5804,$classname())
	i '$d(^BEDD.EDProcD(id)) Set i%DFN="",i%EDProc="",i%EDVISITID="",i%ProcDt="",i%ProcEDt="",i%ProcETm="",i%ProcNotes="",i%ProcSTm="",i%ProcStf=""
	Else  Do
	. New %s1
	. Set sc=1
	. s %s1=$g(^BEDD.EDProcD(id))
	. s i%DFN=$lg(%s1,2),i%EDVISITID=$lg(%s1,3),i%EDProc=$lg(%s1,4),i%ProcStf=$lg(%s1,5),i%ProcDt=$lg(%s1,6),i%ProcSTm=$lg(%s1,7),i%ProcETm=$lg(%s1,8),i%ProcNotes=$lg(%s1,9),i%ProcEDt=$lg(%s1,10)
	If ..%Concurrency=2 Lock -(^BEDD.EDProcD(id)#"SI")
	Quit $select(sc'="":sc,1:$$Error^%apiOBJ(5809,$classname(),id))
%LoadDataFromMemory(id,objstate,obj)
	New sc
	Set sc=""
	i '$d(objstate(id)) Set i%DFN="",i%EDProc="",i%EDVISITID="",i%ProcDt="",i%ProcEDt="",i%ProcETm="",i%ProcNotes="",i%ProcSTm="",i%ProcStf=""
	Else  Do
	. New %s1
	. Set sc=1
	. s %s1=$g(objstate(id))
	. s i%DFN=$lg(%s1,2),i%EDVISITID=$lg(%s1,3),i%EDProc=$lg(%s1,4),i%ProcStf=$lg(%s1,5),i%ProcDt=$lg(%s1,6),i%ProcSTm=$lg(%s1,7),i%ProcETm=$lg(%s1,8),i%ProcNotes=$lg(%s1,9),i%ProcEDt=$lg(%s1,10)
	Set sc = $select(sc'="":sc,1:$$Error^%apiOBJ(5809,$classname(),id))
	 Quit sc
%LoadInit(oid="",concurrency="",reset=0) public {
	If concurrency'="" Set i%%Concurrency=concurrency
	If reset {
		Kill i%ProcNotes
	}
	Set r%ProcNotes=""
	If 'reset { Set i%"%%OID"=oid If oid'="" { Set $zobjoid("",$listget(oid))=$this } }
	Quit 1 }
%LockExtent(shared=0) public {
	if shared { l +(^BEDD.EDProcD#"S"):$zu(115,4) if $t { q 1 } else { q $$Error^%apiOBJ(5799,$classname()) }} l +(^BEDD.EDProcD):$zu(115,4) if $t { q 1 } else { q $$Error^%apiOBJ(5798,$classname()) }
}
%LockId(id,shared=0) public {
	if id'="" { set sc=1 } else { set sc=$$Error^%apiOBJ(5812) quit sc }
	if 'shared { Lock +(^BEDD.EDProcD(id)):$zu(115,4) i $test { q 1 } else { q $$Error^%apiOBJ(5803,$classname()) } }
	else { Lock +(^BEDD.EDProcD(id)#"S"):$zu(115,4) if $test { q 1 } else { q $$Error^%apiOBJ(5804,$classname()) } }
}
%NormalizeObject() public {
	If '$system.CLS.GetModified() Quit 1
	If m%DFN Set:i%DFN'="" i%DFN=(..DFNNormalize(i%DFN))
	If m%EDProc Set:i%EDProc'="" i%EDProc=(..EDProcNormalize(i%EDProc))
	If m%EDVISITID Set:i%EDVISITID'="" i%EDVISITID=(..EDVISITIDNormalize(i%EDVISITID))
	If m%ProcDt Set:i%ProcDt'="" i%ProcDt=(..ProcDtNormalize(i%ProcDt))
	If m%ProcEDt Set:i%ProcEDt'="" i%ProcEDt=(..ProcEDtNormalize(i%ProcEDt))
	If m%ProcETm Set:i%ProcETm'="" i%ProcETm=(..ProcETmNormalize(i%ProcETm))
	If m%ProcSTm Set:i%ProcSTm'="" i%ProcSTm=(..ProcSTmNormalize(i%ProcSTm))
	If m%ProcStf Set:i%ProcStf'="" i%ProcStf=(..ProcStfNormalize(i%ProcStf))
	Quit 1 }
%ObjectModified() public {
	If $system.CLS.GetModified() Quit 1
	If r%ProcNotes'="",..ProcNotes.%ObjectModified() Quit 1
	Quit 0 }
%OnDetermineClass(oid,class)
	New id,idclass
	Set id=$listget($get(oid)) QUIT:id="" $$Error^%apiOBJ(5812)
	Set idclass=$lg($get(^BEDD.EDProcD(id)),1)
	If idclass="" Set class="BEDD.EDProc" Quit 1
	Set class=$piece(idclass,$extract(idclass),$length(idclass,$extract(idclass))-1)
	Set:class'["." class="User."_class
	QUIT 1
%PhysicalAddress(id,paddr)
	if $Get(id)="" Quit $$Error^%apiOBJ(5813,$classname())
	if (id="") { quit $$Error^%apiOBJ(5832,$classname(),id) }
	s paddr(1)=$lb($Name(^BEDD.EDProcD(id)),$classname(),"IDKEY","listnode",id)
	s paddr=1
	Quit 1
%PurgeIndices(idxlist="",lockExtent=0)
	if $ll(idxlist) { quit $$Error^%apiOBJ(5066,$classname()_"::"_$ListToString(idxlist)) } QUIT 1
	Quit
%SQLAcquireLock(%rowid,s=0,unlockref)
	new %d,gotlock set %d(1)=%rowid set s=$e("S",s) lock +^BEDD.EDProcD(%d(1))#s:$zu(115,4) set gotlock=$t set:gotlock&&$g(unlockref) unlockref($i(unlockref))=$lb($name(^BEDD.EDProcD(%d(1))),"BEDD.EDProc") QUIT gotlock
	Quit
%SQLAcquireTableLock(s=0,SQLCODE,to="")
	set s=$e("S",s) set:to="" to=$zu(115,4) lock +^BEDD.EDProcD#s:to QUIT:$t 1 set SQLCODE=-110 if s="S" { set %msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler35",,"BEDD"_"."_"EDProc") } else { set %msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler36",,"BEDD"_"."_"EDProc") } QUIT 0
	Quit
%SQLBuildIndices(pIndices="")
	QUIT ..%BuildIndices(pIndices)
%SQLCopyIcolIntoName()
	if %oper="DELETE" {
		set:$d(%d(1)) %f("ID")=%d(1)
		QUIT
	}
	set:$d(%d(1)) %f("ID")=%d(1) set:$a(%e,2)&&$d(%d(2)) %f("Age")=%d(2) set:$a(%e,3)&&$d(%d(3)) %f("CIDt")=%d(3) set:$a(%e,4)&&$d(%d(4)) %f("CITm")=%d(4) set:$a(%e,5)&&$d(%d(5)) %f("Chart")=%d(5) set:$a(%e,6)&&$d(%d(6)) %f("DFN")=%d(6) set:$a(%e,7)&&$d(%d(7)) %f("DOB")=%d(7) set:$a(%e,8)&&$d(%d(8)) %f("EDProc")=%d(8) set:$a(%e,9)&&$d(%d(9)) %f("EDProcN")=%d(9) set:$a(%e,10)&&$d(%d(10)) %f("EDVISITID")=%d(10) set:$a(%e,11)&&$d(%d(11)) %f("ProcDt")=%d(11) set:$a(%e,12)&&$d(%d(12)) %f("ProcEDt")=%d(12) set:$a(%e,13)&&$d(%d(13)) %f("ProcETm")=%d(13) set:$a(%e,14)&&$d(%d(14)) %f("ProcNotes")=%d(14) set:$a(%e,15)&&$d(%d(15)) %f("ProcSTm")=%d(15) set:$a(%e,16)&&$d(%d(16)) %f("ProcStf")=%d(16) set:$a(%e,17)&&$d(%d(17)) %f("ProcStfN")=%d(17) set:$a(%e,18)&&$d(%d(18)) %f("ProcTime")=%d(18) set:$a(%e,19)&&$d(%d(19)) %f("PtCIDT")=%d(19) set:$a(%e,20)&&$d(%d(20)) %f("PtName")=%d(20) set:$a(%e,21)&&$d(%d(21)) %f("PtProcDT")=%d(21) set:$a(%e,22)&&$d(%d(22)) %f("Sex")=%d(22) set:$a(%e,23)&&$d(%d(23)) %f("x__classname")=%d(23)
	QUIT
%SQLDefineiDjVars(%d,subs)
	QUIT
%SQLDelete(%rowid,%check,%tstart=1,%mv=0,%polymorphic=0)
	new bva,ce,%d,dc,%e,%ele,%itm,%key,%l,%nc,omcall,%oper,%pos,%s,sn,sqlcode,subs set %oper="DELETE",sqlcode=0,%ROWID=%rowid,%d(1)=%rowid,%e(1)=%rowid,%l=$c(0)
	if '$d(%0CacheSQLRA) new %0CacheSQLRA set omcall=1
	k:'$TLEVEL %0CacheLock if '$a(%check,2) { new %ls if $i(%0CacheLock("BEDD.EDProc"))>$zu(115,6) { lock +^BEDD.EDProcD:$zu(115,4) lock:$t -^BEDD.EDProcD set %ls=$s($t:2,1:0) } else { lock +^BEDD.EDProcD(%d(1)):$zu(115,4) set %ls=$t } set:%ls=2 $e(%check,2)=$c(1) set:%ls=1 $e(%l)=$c(1) if '%ls set SQLCODE=-110,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler40",,%oper,"BEDD"_"."_"EDProc",$g(%d(1))) QUIT  } if %tstart { TSTART:($zu(115,1)=1)||('$TLEVEL&&($zu(115,1)=2))  } set $zt="ERRORDelete"
	do ..%SQLGetOld() if sqlcode set SQLCODE=-106 do ..%SQLEExit() QUIT  
	if %e(23)'="" set sn=$p(%e(23),$e(%e(23)),$l(%e(23),$e(%e(23)))-1) if "BEDD.EDProc"'=sn new %f do ..%SQLCopyIcolIntoName() do $classmethod(sn,"%SQLDelete",%rowid,%check,%tstart,%mv,1) QUIT  
	if '$a(%check),'$zu(115,7) do  if sqlcode set SQLCODE=sqlcode do ..%SQLEExit() QUIT  
	. new %fk,%k,%p,%st,%t,%z set %k="",%p("%1")="%d(1),",%p("IDKEY")="%d(1),"
	. for  quit:sqlcode<0  set %k=$o(^oddEXTR("BEDD.EDProc","n",%k)) quit:%k=""  set %t="" for  set %t=$o(^oddEXTR("BEDD.EDProc","n",%k,"f",%t)) quit:%t=""  set %st=(%t="BEDD.EDProc") set %fk="" for  set %fk=$order(^oddEXTR("BEDD.EDProc","n",%k,"f",%t,%fk)) quit:%fk=""  x "set %z=$classmethod(%t,%fk_""SQLFKeyRefAction"",%st,%k,"_%p(%k)_")" if %z set sqlcode=-124 quit  
	set ce="" for  { set ce=$order(^oddSQL("BEDD","EDProc","DC",ce)) quit:ce=""   do $classmethod(ce,"%SQLDeleteChildren",%d(1),%check,.sqlcode) quit:sqlcode<0  } if sqlcode<0 { set SQLCODE=sqlcode do ..%SQLEExit() QUIT } // Delete any children
	new %rc if $g(%e(14))'="" set %rc=##class(%Stream.Object).%Delete(%e(14)) if '%rc set SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) set:%msg %msg=%msg(1) do ..%SQLEExit() QUIT
	k ^BEDD.EDProcD(%d(1))
	do ..%SQLUnlock() TCOMMIT:%tstart&&($zu(115,1)=1)
	set SQLCODE=0 kill:$g(omcall) %0CacheSQLRA QUIT
ERRORDelete	set $zt="",SQLCODE=-415,%msg=$s($g(%msg)'="":%msg_" -- ",1:"")_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler51",,%oper,"BEDD"_"."_"EDProc",$ze) if $ze["<FRAMESTACK>" { set %msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler52",,$ze,%oper,"BEDD"_"."_"EDProc") do ##Class(%SYS.System).WriteToConsoleLog(%msg) if ($zu(67,10,$j)=1)||($zu(67,10,$j)=3) { write !,%msg h 3 } HALT  } do ..%SQLEExit() QUIT
	Quit
%SQLDeleteTempStreams()
	// Delete all temporary streams
	new %sid,%ts if $g(%d(14))?1.n1"@"1.e { if $d(%qstrhandle($g(%qacn,1),%d(14)),%ts) { set %sid=%ts.%Oid() do %ts.%Delete(%sid) k %ts }}
	QUIT
%SQLEExit()
	do ..%SQLUnlock() 
	if %tstart,$zu(115,1)=1,$TLEVEL { set %tstart=0 TROLLBACK 1 } kill:$g(omcall) %0CacheSQLRA QUIT  
	Quit
%SQLExists(pLockOnly=0,pUnlockRef,%pVal...)
	// SQL Foreign Key validation entry point for Foreign Key %1.  Called by FKeys that reference this key to see if the row is defined
	new id set id=%pVal(1)
	if '..%SQLGetLock(id,1,.pUnlockRef) { set sqlcode=-114,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler39",,"BEDD"_"."_"EDProc"_":"_"%1") QUIT 0 }
	if 'pLockOnly { new qv set qv=$d(^BEDD.EDProcD(%pVal(1))) do:'$g(pUnlockRef) ..%SQLReleaseLock(id,1) quit qv } else { do:'$g(pUnlockRef) ..%SQLReleaseLock(id,1) QUIT 1 }
	Quit
%SQLGetLock(pRowId,pShared=0,pUnlockRef)
	kill:'$TLEVEL %0CacheLock
	if $i(%0CacheLock("BEDD.EDProc"))>$zu(115,6) { lock +^BEDD.EDProcD:$zu(115,4) lock:$t -^BEDD.EDProcD QUIT $s($t:2,1:0) } 
	QUIT ..%SQLAcquireLock(pRowId,pShared,.pUnlockRef)
%SQLGetOld()
	new s if '$d(^BEDD.EDProcD(%d(1)),s) { set sqlcode=100 quit  } set %e(23)=$lg(s) set %e(14)=$lg(s,9) set:%e(14)'="" %e(14)=..ProcNotesOid(%e(14))
	QUIT
%SQLGetOldAll()
	// Get all old data values
	 ;---&sql(SELECT Age,CIDt,CITm,Chart,DFN,DOB,EDProc,EDProcN,EDVISITID,ProcDt,ProcEDt,ProcETm,ProcNotes,ProcSTm,ProcStf,ProcStfN,ProcTime,PtCIDT,PtName,PtProcDT,Sex,x__classname INTO :%e() FROM BEDD.EDProc WHERE ID=:%rowid) set sqlcode=SQLCODE quit
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
 i %mmmsqld(4)'="",$d(^BEDD.EDProcD(%mmmsqld(4)))
 e  g %0AmBdun
 s %mmmsqld(5)=$g(^BEDD.EDProcD(%mmmsqld(4))) s %e(6)=$lg(%mmmsqld(5),2) s %e(8)=$lg(%mmmsqld(5),4) s %e(10)=$lg(%mmmsqld(5),3) s %e(11)=$lg(%mmmsqld(5),6) s %e(12)=$lg(%mmmsqld(5),10) s %e(13)=$lg(%mmmsqld(5),8) s %e(14)=##class(BEDD.EDProc).ProcNotesOid($lg(%mmmsqld(5),9)) s %e(15)=$lg(%mmmsqld(5),7) s %e(16)=$lg(%mmmsqld(5),5) s %e(23)=$lg(%mmmsqld(5),1)
 d
 . Set %e(2)=##class(BEDD.EDProc).GetAge(%e(10))
 d
 . Set %e(3)=##class(BEDD.EDProc).GetCIDt(%e(10)) 
 d
 . Set %e(4)=##class(BEDD.EDProc).GetCITm(%e(10)) 
 d
 . Set %e(5)=##class(BEDD.EDProc).GetChart(%e(10)) 
 d
 . Set %e(7)=##class(BEDD.EDProc).GetDOB(%e(10))
 d
 . Set %e(9)=##class(BEDD.EDProc).GetProcN(%e(8))
 d
 . Set %e(17)=##class(BEDD.EDProc).GetStfN(%e(16))
 d
 . Set %e(18)=##class(BEDD.EDProc).CalcTime(%e(15),%e(13))
 d
 . Set %e(19)=##class(BEDD.EDProc).CmbDt(%e(3),%e(4))
 d
 . Set %e(20)=##class(BEDD.EDProc).GetName(%e(10))
 d
 . Set %e(21)=##class(BEDD.EDProc).CmbDtT(%e(11),%e(15),%e(13))
 d
 . Set %e(22)=##class(BEDD.EDProc).GetSex(%e(10))
 g:$zu(115,2)=0 %0AmBuncommitted i $zu(115,2)=1 l +^BEDD.EDProcD($p(%mmmsqld(4),"||",1))#"S":$zu(115,4) i $t { s %mmmsqld(1)=1,%mmmsqld(2)=$name(^BEDD.EDProcD($p(%mmmsqld(4),"||",1)))_"#""SI""" } else { s SQLCODE=-114,%msg="Unable to acquire shared lock on table BEDD.EDProc for RowID value: "_%mmmsqld(4) ztrap "LOCK"  }
 ; asl MOD# 3
 i %mmmsqld(4)'="",$d(^BEDD.EDProcD(%mmmsqld(4)))
 e  g %0AmCdun
 s %mmmsqld(6)=$g(^BEDD.EDProcD(%mmmsqld(4))) s %e(6)=$lg(%mmmsqld(6),2) s %e(8)=$lg(%mmmsqld(6),4) s %e(10)=$lg(%mmmsqld(6),3) s %e(11)=$lg(%mmmsqld(6),6) s %e(12)=$lg(%mmmsqld(6),10) s %e(13)=$lg(%mmmsqld(6),8) s %e(14)=##class(BEDD.EDProc).ProcNotesOid($lg(%mmmsqld(6),9)) s %e(15)=$lg(%mmmsqld(6),7) s %e(16)=$lg(%mmmsqld(6),5) s %e(23)=$lg(%mmmsqld(6),1)
 d
 . Set %e(2)=##class(BEDD.EDProc).GetAge(%e(10))
 d
 . Set %e(3)=##class(BEDD.EDProc).GetCIDt(%e(10)) 
 d
 . Set %e(4)=##class(BEDD.EDProc).GetCITm(%e(10)) 
 d
 . Set %e(5)=##class(BEDD.EDProc).GetChart(%e(10)) 
 d
 . Set %e(7)=##class(BEDD.EDProc).GetDOB(%e(10))
 d
 . Set %e(9)=##class(BEDD.EDProc).GetProcN(%e(8))
 d
 . Set %e(17)=##class(BEDD.EDProc).GetStfN(%e(16))
 d
 . Set %e(18)=##class(BEDD.EDProc).CalcTime(%e(15),%e(13))
 d
 . Set %e(19)=##class(BEDD.EDProc).CmbDt(%e(3),%e(4))
 d
 . Set %e(20)=##class(BEDD.EDProc).GetName(%e(10))
 d
 . Set %e(21)=##class(BEDD.EDProc).CmbDtT(%e(11),%e(15),%e(13))
 d
 . Set %e(22)=##class(BEDD.EDProc).GetSex(%e(10))
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
%SQLInsert(%d,%check,%inssel,%vco,%tstart=1,%mv=0)
	new bva,%ele,%itm,%key,%l,%n,%nc,%oper,%pos,%s,sqlcode,sn,subs,icol set %oper="INSERT",sqlcode=0,%l=$c(0,0,0)
	if $d(%d(1)),'$zu(115,11) { if %d(1)'="" { set SQLCODE=-111,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler6",,"ID","BEDD"_"."_"EDProc") QUIT ""  } kill %d(1) } 
	if '$a(%check),'..%SQLValidateFields(.sqlcode) { set SQLCODE=sqlcode QUIT "" }
	do ..%SQLNormalizeFields()
	kill:'$TLEVEL %0CacheLock if %tstart { TSTART:($zu(115,1)=1)||('$TLEVEL&&($zu(115,1)=2))  } set $zt="ERRORInsert"
	if '$a(%check) do  if sqlcode<0 s SQLCODE=sqlcode do ..%SQLDeleteTempStreams() do ..%SQLEExit() QUIT ""
	. if $g(%vco)'="" do ..%SQLInsertComputes(1) d @%vco quit:sqlcode<0
	if '$d(%d(1)) { set %d(1)=$i(^BEDD.EDProcD) } elseif %d(1)>$g(^BEDD.EDProcD) { if $i(^BEDD.EDProcD,$zabs(%d(1)-$g(^BEDD.EDProcD))) {}} elseif $d(^BEDD.EDProcD(%d(1))) { set SQLCODE=-119,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler33",,"ID",%d(1),"BEDD"_"."_"EDProc"_"."_"ID") do ..%SQLDeleteTempStreams() do ..%SQLEExit() QUIT "" }
	for icol=23,14 set:'$d(%d(icol)) %d(icol)=""
	if '$a(%check,2) { new %ls if $i(%0CacheLock("BEDD.EDProc"))>$zu(115,6) { lock +^BEDD.EDProcD:$zu(115,4) lock:$t -^BEDD.EDProcD set %ls=$s($t:2,1:0) } else { lock +^BEDD.EDProcD(%d(1)):$zu(115,4) set %ls=$t } set:%ls=2 $e(%check,2)=$c(1) set:%ls=1 $e(%l)=$c(1) if '%ls set SQLCODE=-110,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler40",,%oper,"BEDD"_"."_"EDProc",$g(%d(1))) do ..%SQLEExit() QUIT ""  }
	if '$a(%check,5),'$a(%check,6) { n %node,%rc,%sid,%size,%stream,%tmp,%ts
		k %sid i %d(14)'="" { s %stream=##class(BEDD.EDProc).ProcNotesOpen("") i %stream="" { s SQLCODE=-412,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler11",,"BEDD"_"."_"EDProc","ProcNotes") do ..%SQLEExit() QUIT "" } s %ts="" if $isobject(%d(14)) { s %ts=%d(14) } elseif (%d(14)?1.n1"@"1.e) { try { if $zobjref(%d(14))'="" { s %ts=$zobjref(%d(14)) }} catch { if $ze["<INVALID OREF>" { s $ze="" } else { GOTO ERRORInsert }}} elseif $ListValid(%d(14)) { s %ts=##class(%Stream.Object).%Open(%d(14)) } if $isobject(%ts) { if '%ts.IsNull() { s %rc=%stream.CopyFromAndSave(%ts) i '%rc { s SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) s:%msg %msg=%msg(1) k %stream,%ts do ..%SQLEExit() QUIT "" }} else { s %rc=%stream.%Save() i '%rc { k %stream s SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) s:%msg %msg=%msg(1) s %msg=$g(%msg)_"  "_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler12",,"BEDD"_"."_"EDProc","ProcNotes")_": "_$g(%d(14))_"'" k %ts do ..%SQLEExit() QUIT "" }} k %ts } elseif $d(%d(14)),%d(14)'=-1,%d(14)'="" { s %ts=%d(14) s:%ts=$c(0) %ts="" s %rc=%stream.Write(%ts) i '%rc { k %stream s SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) s:%msg %msg=%msg(1) s %msg=$g(%msg)_"  "_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler13",,"BEDD"_"."_"EDProc","ProcNotes") do ..%SQLEExit() QUIT ""}  s %rc=%stream.%Save() i '%rc { k %stream s SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) s:%msg %msg=%msg(1) s %msg=$g(%msg)_" "_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler12",,"BEDD"_"."_"EDProc","ProcNotes")_": '"_$g(%d(14))_"'" do ..%SQLEExit() QUIT "" }} else { s %rc=%stream.%Save() i '%rc { k %stream s SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) s:%msg %msg=%msg(1) s %msg=$g(%msg)_"  "_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler12",,"BEDD"_"."_"EDProc","ProcNotes")_": '"_$g(%d(14))_"'" do ..%SQLEExit() QUIT "" }} s %d(14)=%stream.%Oid() k %stream,%ts s %d(14)=$li(%d(14),1,2) }
	}
	set ^BEDD.EDProcD(%d(1))=$lb(%d(23),$g(%d(6)),$g(%d(10)),$g(%d(8)),$g(%d(16)),$g(%d(11)),$g(%d(15)),$g(%d(13)),%d(14),$g(%d(12)))
	lock:$a(%l) -^BEDD.EDProcD(%d(1))
	TCOMMIT:%tstart&&($zu(115,1)=1)
	set SQLCODE=0 QUIT %d(1) 			// %SQLInsert
ERRORInsert	set $zt="",SQLCODE=-415,%msg=$s($g(%msg)'="":%msg_" -- ",1:"")_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler51",,%oper,"BEDD"_"."_"EDProc",$ze) if $ze["<FRAMESTACK>" { set %msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler52",,$ze,%oper,"BEDD"_"."_"EDProc") do ##Class(%SYS.System).WriteToConsoleLog(%msg) if ($zu(67,10,$j)=1)||($zu(67,10,$j)=3) { write !,%msg h 3 } HALT  } do ..%SQLEExit() QUIT ""
	Quit
%SQLInsertComputes(view=0)
	if 'view {
	}
	else {
	set %d(2)="" do ..AgeSQLCompute()
	set %d(3)="" do ..CIDtSQLCompute()
	set %d(4)="" do ..CITmSQLCompute()
	set %d(5)="" do ..ChartSQLCompute()
	set %d(7)="" do ..DOBSQLCompute()
	set %d(9)="" do ..EDProcNSQLCompute()
	set %d(17)="" do ..ProcStfNSQLCompute()
	set %d(18)="" do ..ProcTimeSQLCompute()
	set %d(19)="" do ..PtCIDTSQLCompute()
	set %d(20)="" do ..PtNameSQLCompute()
	set %d(21)="" do ..PtProcDTSQLCompute()
	set %d(22)="" do ..SexSQLCompute()
	}
	QUIT
%SQLInvalid(pIcol,pVal) public {
	set:$l($g(pVal))>40 pVal=$e(pVal,1,40)_"..." do:'$d(%n) ..%SQLnBuild() set %msg=$s($g(%msg)'="":%msg_$c(13,10),1:"")_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler37",,"BEDD"_"."_"EDProc"_"."_$lg(%n,pIcol),$s($g(pVal)'="":$s(pVal="":"<NULL>",pVal=$c(0):"<EMPTY STRING>",1:"'"_pVal_"'"),1:"")),sqlcode=$s(%oper="INSERT":-104,1:-105)
	QUIT sqlcode }
%SQLMissing(fname)
	set sqlcode=-108,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler47",,fname,"BEDD"_"."_"EDProc") quit
%SQLNormalizeFields()
	for %f=3,11,12 { set:$g(%d(%f))'="" %d(%f)=$s($zu(115,13)&&(%d(%f)=$c(0)):"",1:%d(%f)\1) }
	for %f=4,13,15 { set:$g(%d(%f))'="" %d(%f)=$select($zu(115,13)&&(%d(%f)=$c(0)):"",1:%d(%f)) }
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
	set x=$zobjexport(-1,18),%qrc=400,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler44",,"BEDD"_"."_"EDProc") QUIT
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
	if %nolock=0 { if '..%SQLAcquireLock(%rowid) { set %qrc=114,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler45",,"BEDD"_"."_"EDProc",%rowid),%ROWCOUNT=0 QUIT  } set:$zu(115,2) il=$zu(115,2,0) }
	 ;---&sql(SELECT %INTERNAL(ID),Age,CIDt,CITm,Chart,DFN,DOB,EDProc,EDProcN,EDVISITID,ProcDt,ProcEDt,ProcETm,ProcNotes,ProcSTm,ProcStf,ProcStfN,ProcTime,PtCIDT,PtName,PtProcDT,Sex,x__classname INTO :d(1),:d(2),:d(3),:d(4),:d(5),:d(6),:d(7),:d(8),:d(9),:d(10),:d(11),:d(12),:d(13),:d(14),:d(15),:d(16),:d(17),:d(18),:d(19),:d(20),:d(21),:d(22),:d(23) FROM BEDD.EDProc WHERE %ID = :%rowid)
 	 ;--- ** SQL PUBLIC Variables: %ROWCOUNT, %ROWID, %msg, SQLCODE, d
	Do %0Co
	if SQLCODE { if %nolock=0 { do ..%SQLReleaseLock(%rowid,0,1) do:$g(il) $zu(115,2,il) } set %ROWCOUNT=0 set:SQLCODE<0 SQLCODE=-SQLCODE set %qrc=SQLCODE QUIT  }
	if qq,d(23)'="" { new sn set sn=$p(d(23),$e(d(23)),$l(d(23),$e(d(23)))-1) if "BEDD.EDProc"'=sn { if %nolock=0 { do ..%SQLReleaseLock(%rowid,0,1) do:$g(il) $zu(115,2,il) } kill d set:sn'["." sn="User."_sn  do $classmethod(sn,"%SQLQuickLoad",%rowid,%nolock,0,1) QUIT  }}
	if %nolock=0 { if $zu(115,1)=1 { TSTART  } elseIf '$TLEVEL,$zu(115,1)=2 { TSTART  }}
	set:qq d=$zobjexport("BEDD.EDProc",18),d=$zobjexport(23,18) set i=-1 for  { set i=$o(d(i)) quit:i=""  set d=$zobjexport(d(i),18) } set %qrc=0,%ROWCOUNT=1 if %nolock=0 { d ..%SQLReleaseLock(%rowid,0,0) do:$g(il) $zu(115,2,il) } quit
	Quit
 q
%0CmBs1(%val="") ;
	Quit $select(%val="":"",%val'["-":$zdate(%val,3),1:%val)
%0CmBs2(%val="") ;
	Quit $select(%val="":"",1:$ztime(%val))
%0Co 
 n %mmmsqlc,%mmmsqld,%mmmsqlE,%mmmsqll,%mmmsqln,%mmmsqlp,%mmmsqlR,%mmmsqls,%mmmsqlt,%mmmsqlZ s $zt="%0Cerr" s %mmmsqld(1)=0,%mmmsqld(2)="" d:$zu(115,15) $system.ECP.Sync()
 s %mmmsqld(3)=$g(%rowid),%mmmsqld(3)=$s(%mmmsqld(3)="":"",$isvalidnum(%mmmsqld(3)):+%mmmsqld(3),1:%mmmsqld(3))
 s SQLCODE=100
 ; asl MOD# 2
 s %mmmsqld(4)=%mmmsqld(3)
 i %mmmsqld(4)'="",$d(^BEDD.EDProcD(%mmmsqld(4)))
 e  g %0CmBdun
 s d(1)=%mmmsqld(4)
 s %mmmsqld(5)=$g(^BEDD.EDProcD(%mmmsqld(4))) s d(6)=$lg(%mmmsqld(5),2) s d(8)=$lg(%mmmsqld(5),4) s d(10)=$lg(%mmmsqld(5),3) s %mmmsqld(6)=$lg(%mmmsqld(5),6) s d(11)=$$%0CmBs1(%mmmsqld(6)) s %mmmsqld(7)=$lg(%mmmsqld(5),10) s d(12)=$$%0CmBs1(%mmmsqld(7)) s %mmmsqld(8)=$lg(%mmmsqld(5),8) s d(13)=$$%0CmBs2(%mmmsqld(8)) s d(14)=##class(BEDD.EDProc).ProcNotesOid($lg(%mmmsqld(5),9)) s %mmmsqld(9)=$lg(%mmmsqld(5),7) s d(15)=$$%0CmBs2(%mmmsqld(9)) s d(16)=$lg(%mmmsqld(5),5) s d(23)=$lg(%mmmsqld(5),1)
 d
 . Set d(2)=##class(BEDD.EDProc).GetAge(d(10))
 d
 . Set %mmmsqld(10)=##class(BEDD.EDProc).GetCIDt(d(10)) 
 s d(3)=$$%0CmBs1(%mmmsqld(10)) d
 . Set %mmmsqld(11)=##class(BEDD.EDProc).GetCITm(d(10)) 
 s d(4)=$$%0CmBs2(%mmmsqld(11)) d
 . Set d(5)=##class(BEDD.EDProc).GetChart(d(10)) 
 d
 . Set d(7)=##class(BEDD.EDProc).GetDOB(d(10))
 d
 . Set d(9)=##class(BEDD.EDProc).GetProcN(d(8))
 d
 . Set d(17)=##class(BEDD.EDProc).GetStfN(d(16))
 d
 . Set d(18)=##class(BEDD.EDProc).CalcTime(%mmmsqld(9),%mmmsqld(8))
 d
 . Set d(19)=##class(BEDD.EDProc).CmbDt(%mmmsqld(10),%mmmsqld(11))
 d
 . Set d(20)=##class(BEDD.EDProc).GetName(d(10))
 d
 . Set d(21)=##class(BEDD.EDProc).CmbDtT(%mmmsqld(6),%mmmsqld(9),%mmmsqld(8))
 d
 . Set d(22)=##class(BEDD.EDProc).GetSex(d(10))
 g:$zu(115,2)=0 %0CmBuncommitted i $zu(115,2)=1 l +^BEDD.EDProcD($p(%mmmsqld(4),"||",1))#"S":$zu(115,4) i $t { s %mmmsqld(1)=1,%mmmsqld(2)=$name(^BEDD.EDProcD($p(%mmmsqld(4),"||",1)))_"#""SI""" } else { s SQLCODE=-114,%msg="Unable to acquire shared lock on table BEDD.EDProc for RowID value: "_%mmmsqld(4) ztrap "LOCK"  }
 ; asl MOD# 3
 i %mmmsqld(4)'="",$d(^BEDD.EDProcD(%mmmsqld(4)))
 e  g %0CmCdun
 s d(1)=%mmmsqld(4)
 s %mmmsqld(12)=$g(^BEDD.EDProcD(%mmmsqld(4))) s d(6)=$lg(%mmmsqld(12),2) s d(8)=$lg(%mmmsqld(12),4) s d(10)=$lg(%mmmsqld(12),3) s %mmmsqld(6)=$lg(%mmmsqld(12),6) s d(11)=$$%0CmBs1(%mmmsqld(6)) s %mmmsqld(7)=$lg(%mmmsqld(12),10) s d(12)=$$%0CmBs1(%mmmsqld(7)) s %mmmsqld(8)=$lg(%mmmsqld(12),8) s d(13)=$$%0CmBs2(%mmmsqld(8)) s d(14)=##class(BEDD.EDProc).ProcNotesOid($lg(%mmmsqld(12),9)) s %mmmsqld(9)=$lg(%mmmsqld(12),7) s d(15)=$$%0CmBs2(%mmmsqld(9)) s d(16)=$lg(%mmmsqld(12),5) s d(23)=$lg(%mmmsqld(12),1)
 d
 . Set d(2)=##class(BEDD.EDProc).GetAge(d(10))
 d
 . Set %mmmsqld(10)=##class(BEDD.EDProc).GetCIDt(d(10)) 
 s d(3)=$$%0CmBs1(%mmmsqld(10)) d
 . Set %mmmsqld(11)=##class(BEDD.EDProc).GetCITm(d(10)) 
 s d(4)=$$%0CmBs2(%mmmsqld(11)) d
 . Set d(5)=##class(BEDD.EDProc).GetChart(d(10)) 
 d
 . Set d(7)=##class(BEDD.EDProc).GetDOB(d(10))
 d
 . Set d(9)=##class(BEDD.EDProc).GetProcN(d(8))
 d
 . Set d(17)=##class(BEDD.EDProc).GetStfN(d(16))
 d
 . Set d(18)=##class(BEDD.EDProc).CalcTime(%mmmsqld(9),%mmmsqld(8))
 d
 . Set d(19)=##class(BEDD.EDProc).CmbDt(%mmmsqld(10),%mmmsqld(11))
 d
 . Set d(20)=##class(BEDD.EDProc).GetName(d(10))
 d
 . Set d(21)=##class(BEDD.EDProc).CmbDtT(%mmmsqld(6),%mmmsqld(9),%mmmsqld(8))
 d
 . Set d(22)=##class(BEDD.EDProc).GetSex(d(10))
%0CmBuncommitted ;
 s d(1)=%mmmsqld(4)
 s SQLCODE=0 g %0Cc
%0CmCdun if $zu(115,2)=1 { if $g(%mmmsqld(1))=1 { l -@%mmmsqld(2) s %mmmsqld(1)=0 } elseif $g(%mmmsqld(1))=2 { do $classmethod($li(%mmmsqld(2)),"%UnlockId",$li(%mmmsqld(2),2),1,1)  s %mmmsqld(1)=0 } }
%0CmBdun 
%0CmAdun 
%0Cc s %ROWCOUNT='SQLCODE
 if $zu(115,2)=1 { if $g(%mmmsqld(1))=1 { l -@%mmmsqld(2) } elseif $g(%mmmsqld(1))=2 { do $classmethod($li(%mmmsqld(2)),"%UnlockId",$li(%mmmsqld(2),2),1,1)  } }
 q
%0Cerr s $zt="" d SQLRunTimeError^%apiSQL($ze,.SQLCODE,.%msg)
 g %0Cc
%SQLQuickLogicalToOdbc(%d)
	for %f=3,11,12 { set:$g(%d(%f))'="" %d(%f)=$select(%d(%f)="":"",%d(%f)'["-":$zdate(%d(%f),3),1:%d(%f)) }
	for %f=4,13,15 { set:$g(%d(%f))'="" %d(%f)=$select(%d(%f)="":"",1:$ztime(%d(%f))) }
	QUIT
%SQLQuickOdbcToLogical(%d)
	set:$g(%d(11))'="" %d(11)=$$OdbcToLogicalField11(%d(11))
	set:$g(%d(12))'="" %d(12)=$$OdbcToLogicalField12(%d(12))
	set:$g(%d(13))'="" %d(13)=$$OdbcToLogicalField13(%d(13))
	set:$g(%d(15))'="" %d(15)=$$OdbcToLogicalField15(%d(15))
	set:$g(%d(3))'="" %d(3)=$$OdbcToLogicalField3(%d(3))
	set:$g(%d(4))'="" %d(4)=$$OdbcToLogicalField4(%d(4))
	QUIT
OdbcToLogicalField3(%val="") ;
 quit:%val=""||($zu(115,13)&&(%val=$c(0))) "" set %val=$zdh(%val,3,,,,,,,"Error: '"_%val_"' is an invalid ODBC/JDBC Date value") q:%val||(%val=0) %val s %msg=%val ZTRAP "ODAT"
OdbcToLogicalField4(%val="") ;
 quit:%val=""||($zu(115,13)&&(%val=$c(0))) "" s %val=$ztimeh(%val,,"Error: '"_%val_"' is an invalid ODBC/JDBC Time value") q:%val||(%val=0) %val s %msg=%val ZTRAP "OTIM"
OdbcToLogicalField11(%val="") ;
 quit:%val=""||($zu(115,13)&&(%val=$c(0))) "" set %val=$zdh(%val,3,,,,,,,"Error: '"_%val_"' is an invalid ODBC/JDBC Date value") q:%val||(%val=0) %val s %msg=%val ZTRAP "ODAT"
OdbcToLogicalField12(%val="") ;
 quit:%val=""||($zu(115,13)&&(%val=$c(0))) "" set %val=$zdh(%val,3,,,,,,,"Error: '"_%val_"' is an invalid ODBC/JDBC Date value") q:%val||(%val=0) %val s %msg=%val ZTRAP "ODAT"
OdbcToLogicalField13(%val="") ;
 quit:%val=""||($zu(115,13)&&(%val=$c(0))) "" s %val=$ztimeh(%val,,"Error: '"_%val_"' is an invalid ODBC/JDBC Time value") q:%val||(%val=0) %val s %msg=%val ZTRAP "OTIM"
OdbcToLogicalField15(%val="") ;
 quit:%val=""||($zu(115,13)&&(%val=$c(0))) "" s %val=$ztimeh(%val,,"Error: '"_%val_"' is an invalid ODBC/JDBC Time value") q:%val||(%val=0) %val s %msg=%val ZTRAP "OTIM"
	Quit
%SQLQuickUpdate(%rowid,d,%nolock=0,pkey=0)
	// Update row with SQLRowID=%rowid with values d(icol)
	set:%nolock=2 %nolock=0
	do ..%SQLQuickOdbcToLogical(.d)
	do ..%SQLUpdate(%rowid,$c(0,%nolock=1,0,0,0,0),.d) set %ROWCOUNT='SQLCODE set:SQLCODE=100 SQLCODE=0 set %qrc=SQLCODE kill d QUIT
%SQLReleaseLock(%rowid,s=0,i=0)
	new %d set %d(1)=%rowid set s=$e("S",s)_$e("I",i) lock -^BEDD.EDProcD(%d(1))#s set:i&&($g(%0CacheLock("BEDD.EDProc"))) %0CacheLock("BEDD.EDProc")=%0CacheLock("BEDD.EDProc")-1 QUIT
%SQLReleaseTableLock(s=0,i=0)
	set s=$e("S",s)_$e("I",i) lock -^BEDD.EDProcD#s QUIT 1
	Quit
%SQLUnlock()
	do:$g(SQLCODE)<0&&(%oper="UPDATE") ..%SQLDeleteTempStreams()
	lock:$a(%l) -^BEDD.EDProcD(%d(1))
	QUIT
%SQLUnlockError(cname)
	set sqlcode=-110 if %oper="DELETE" { set %msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler48",,"BEDD"_"."_"EDProc",cname) } else { set %msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler49",,"BEDD"_"."_"EDProc",cname) } quit
	Quit
%SQLUpdate(%rowid,%check,%d,%vco,%tstart=1,%mv=0,%polymorphic=0)
	new %e,bva,%ele,%itm,%key,%l,%n,%nc,%oper,%pos,%s,icol,s,sn,sqlcode,subs,t set %oper="UPDATE",sqlcode=0,%ROWID=%rowid,$e(%e,1)=$c(0),%l=$c(0,0,0) if '$a(%check),'..%SQLValidateFields(.sqlcode) set SQLCODE=sqlcode QUIT
	do ..%SQLNormalizeFields() if $d(%d(1)),%d(1)'=%rowid set SQLCODE=-107,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler16",,"ID","BEDD"_"."_"EDProc") QUIT
	for icol=2:1:23 set $e(%e,icol)=$c($d(%d(icol)))
	set %d(1)=%rowid,%e(1)=%rowid
	k:'$TLEVEL %0CacheLock if '$a(%check,2) { new %ls if $i(%0CacheLock("BEDD.EDProc"))>$zu(115,6) { lock +^BEDD.EDProcD:$zu(115,4) lock:$t -^BEDD.EDProcD set %ls=$s($t:2,1:0) } else { lock +^BEDD.EDProcD(%d(1)):$zu(115,4) set %ls=$t } set:%ls=2 $e(%check,2)=$c(1) set:%ls=1 $e(%l)=$c(1) if '%ls set SQLCODE=-110,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler40",,%oper,"BEDD"_"."_"EDProc",$g(%d(1))) QUIT  } if %tstart { TSTART:($zu(115,1)=1)||('$TLEVEL&&($zu(115,1)=2))  } set $zt="ERRORUpdate"
	if $g(%vco)="" { do ..%SQLGetOld() i sqlcode { s SQLCODE=-109 do ..%SQLEExit() QUIT  } for icol=23,14 { set:'$d(%d(icol)) %d(icol)=%e(icol) set:%d(icol)=%e(icol) $e(%e,icol)=$c(0) }} else { do ..%SQLGetOldAll() if sqlcode { set SQLCODE=-109 do ..%SQLEExit() QUIT  } for icol=2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23 { set:'$d(%d(icol)) %d(icol)=%e(icol) set:%d(icol)=%e(icol) $e(%e,icol)=$c(0) }}
	if %e(23)'="" set sn=$p(%e(23),$e(%e(23)),$l(%e(23),$e(%e(23)))-1) if "BEDD.EDProc"'=sn new %f do ..%SQLCopyIcolIntoName() do $classmethod(sn,"%SQLUpdate",%rowid,%check,.%d,$g(%vco),%tstart,%mv,1) QUIT
	do:'$a(%check)  if sqlcode set SQLCODE=sqlcode do ..%SQLEExit() QUIT
	. if $g(%vco)'="" do ..%SQLInsertComputes(1) d @%vco quit:sqlcode<0
	if '$a(%check,3) { 
	}
	if '$a(%check,5),'$a(%check,6) { new %rc,%stream,%ts
		i $a(%e,14) { i %d(14)'=-1,%d(14)'="" { s %stream=##class(%Stream.Object).%Open(%e(14)) i %stream="" { s %stream=##class(BEDD.EDProc).ProcNotesOpen("") } i %stream="" { s SQLCODE=-412,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler22",,"BEDD"_"."_"EDProc","ProcNotes") do ..%SQLEExit() QUIT  } s %ts="" if $isobject(%d(14)) { s %ts=%d(14) } elseif (%d(14)?1.n1"@"1.e) { try { if $zobjref(%d(14))'="" { s %ts=$zobjref(%d(14)) }} catch { if $ze["<INVALID OREF>" { s $ze="" } else { GOTO ERRORUpdate }}} elseif $ListValid(%d(14)) { s %ts=##class(%Stream.Object).%Open(%d(14)) } if %ts'="" { s %rc=%stream.CopyFromAndSave(%ts) k %ts i '%rc { s SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) s:%msg %msg=%msg(1) k %stream do ..%SQLEExit() QUIT  } } else { s:%d(14)=$c(0) %d(14)="" s %rc=%stream.Write(%d(14)) i '%rc { k %stream s SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) s:%msg %msg=%msg(1) s %msg=$g(%msg)_"  "_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler24",,"BEDD"_"."_"EDProc","ProcNotes") do ..%SQLEExit() QUIT  } s %rc=%stream.%Save() i '%rc { k %stream s SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) s:%msg %msg=%msg(1) s %msg=$g(%msg)_"  "_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler23",,"BEDD"_"."_"EDProc","ProcNotes")_": '"_$e(%d(14),1,50)_"'" do ..%SQLEExit() QUIT  } } } else { i $g(%e(14))'="" { s %rc=##class(%Stream.Object).%Delete(%e(14)) i '%rc { s SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) s:%msg %msg=%msg(1) do ..%SQLEExit() QUIT  } } s %stream=##class(BEDD.EDProc).ProcNotesOpen("") i %stream="" { s SQLCODE=-412,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler22",,"BEDD"_"."_"EDProc","ProcNotes") do ..%SQLEExit() QUIT  } s %rc=%stream.%Save() i '%rc { s SQLCODE=-412,%msg=$$DecomposeStatus^%apiOBJ(%rc,.%msg) s:%msg %msg=%msg(1) s %msg=$g(%msg)_"  "_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler23",,"BEDD"_"."_"EDProc","ProcNotes")_": '"_%d(14)_"'" do ..%SQLEExit() QUIT  } } s %d(14)=%stream.%Oid() k %stream  s %d(14)=$li(%d(14),1,2) }
	}
	set:$s($a(%e,6):1,$a(%e,8):1,$a(%e,10):1,$a(%e,11):1,$a(%e,12):1,$a(%e,13):1,$a(%e,14):1,$a(%e,15):1,$a(%e,16):1,1:$a(%e,23)) s=$g(^BEDD.EDProcD(%d(1))),^BEDD.EDProcD(%d(1))=$lb($s($a(%e,23):%d(23),1:$lg(s)),$s($a(%e,6):%d(6),1:$lg(s,2)),$s($a(%e,10):%d(10),1:$lg(s,3)),$s($a(%e,8):%d(8),1:$lg(s,4)),$s($a(%e,16):%d(16),1:$lg(s,5)),$s($a(%e,11):%d(11),1:$lg(s,6)),$s($a(%e,15):%d(15),1:$lg(s,7)),$s($a(%e,13):%d(13),1:$lg(s,8)),$s($a(%e,14):%d(14),1:$lg(s,9)),$s($a(%e,12):%d(12),1:$lg(s,10)))
	if '$a(%check,3) { 
	}
	do ..%SQLUnlock() TCOMMIT:%tstart&&($zu(115,1)=1)
	set SQLCODE=0
	QUIT
ERRORUpdate	set $zt="",SQLCODE=-415,%msg=$s($g(%msg)'="":%msg_" -- ",1:"")_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler51",,%oper,"BEDD"_"."_"EDProc",$ze) if $ze["<FRAMESTACK>" { set %msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler52",,$ze,%oper,"BEDD"_"."_"EDProc") do ##Class(%SYS.System).WriteToConsoleLog(%msg) if ($zu(67,10,$j)=1)||($zu(67,10,$j)=3) { write !,%msg h 3 } HALT  } do ..%SQLEExit() QUIT  
	Quit
%SQLValidateFields(sqlcode)
	if $g(%d(4))'="",'($select($zu(115,13)&&(%d(4)=$c(0)):1,$isvalidnum(%d(4),,0,86400)&&(%d(4)'=86400):1,'$isvalidnum(%d(4)):$$Error^%apiOBJ(7207,%d(4)),%d(4)<0:$$Error^%apiOBJ(7204,%d(4),0),1:$$Error^%apiOBJ(7203,%d(4),86400))) { set sqlcode=..%SQLInvalid(4+1,%d(4)) } 
	if $g(%d(13))'="",'($select($zu(115,13)&&(%d(13)=$c(0)):1,$isvalidnum(%d(13),,0,86400)&&(%d(13)'=86400):1,'$isvalidnum(%d(13)):$$Error^%apiOBJ(7207,%d(13)),%d(13)<0:$$Error^%apiOBJ(7204,%d(13),0),1:$$Error^%apiOBJ(7203,%d(13),86400))) { set sqlcode=..%SQLInvalid(13+1,%d(13)) } 
	if $g(%d(15))'="",'($select($zu(115,13)&&(%d(15)=$c(0)):1,$isvalidnum(%d(15),,0,86400)&&(%d(15)'=86400):1,'$isvalidnum(%d(15)):$$Error^%apiOBJ(7207,%d(15)),%d(15)<0:$$Error^%apiOBJ(7204,%d(15),0),1:$$Error^%apiOBJ(7203,%d(15),86400))) { set sqlcode=..%SQLInvalid(15+1,%d(15)) } 
	new %f for %f=3,11,12 { if $g(%d(%f))'="",'($s($zu(115,13)&&(%d(%f)=$c(0)):1,$isvalidnum(%d(%f),0,0,):1,'$isvalidnum(%d(%f)):$$Error^%apiOBJ(7207,%d(%f)),1:$$Error^%apiOBJ(7204,%d(%f),0))) set sqlcode=..%SQLInvalid(%f+1,$g(%d(%f))) quit  } 
	new %f for %f=2,5,6,7,8,9,10,16,17,18,19,20,21,22 { if $g(%d(%f))'="",'(($l(%d(%f))'>50)) set sqlcode=..%SQLInvalid(%f+1,$g(%d(%f))) quit  } 
	QUIT 'sqlcode
%SQLnBuild() public {
	set %n=$lb(,"ID","Age","CIDt","CITm","Chart","DFN","DOB","EDProc","EDProcN","EDVISITID","ProcDt","ProcEDt","ProcETm","ProcNotes","ProcSTm","ProcStf","ProcStfN","ProcTime","PtCIDT","PtName","PtProcDT","Sex","x__classname")
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
	Set $ZTrap="SaveDataERR" Set sc=1,id=$listget(i%"%%OID") If id'="" { Set insert=0,idassigned=1 } Else { Set insert=1,idassigned=0 }
	Set lock=0,lockok=0,tSharedLock=0,locku=""
	if 'idassigned { set id=$i(^BEDD.EDProcD) Set $zobjoid("BEDD.EDProc",id)=$this,.."%%OID"=$lb(id_"","BEDD.EDProc") set:$g(%objtxSTATUS)=2 %objtxOIDASSIGNED(+$this)="" }
	If 'insert && ('$Data(^BEDD.EDProcD(id))) { Set insert=1 }
	If '$Tlevel { Kill %0CacheLock }
	If insert  {
		if (..%Concurrency&&$tlevel)||(..%Concurrency=4) { If (..%Concurrency < 4)&&($i(%0CacheLock($classname()))>$zu(115,6)) { Lock +(^BEDD.EDProcD):$zu(115,4) Set lockok=$Select($test:2,1:0) Lock:lockok -(^BEDD.EDProcD) } Else { Lock +(^BEDD.EDProcD(id)):$zu(115,4) Set lockok=$Select($test:1,1:0) Set:..%Concurrency'=4 lock=lockok } If 'lockok { Set sc=$$Error^%apiOBJ(5803,$classname()) Goto SaveDataEXIT } }
		if ..%Concurrency=3 { Lock +(^BEDD.EDProcD(id)#"S") set tSharedLock=1 }
		s ^BEDD.EDProcD(id)=$lb("",i%DFN,i%EDVISITID,i%EDProc,i%ProcStf,i%ProcDt,i%ProcSTm,i%ProcETm,i%ProcNotes,i%ProcEDt)
	}
	Else  {
		If (..%Concurrency<4)&&(..%Concurrency) { If $i(%0CacheLock($classname()))>$zu(115,6) { Lock +(^BEDD.EDProcD):$zu(115,4) Set lockok=$s($test:2,1:0) Lock:lockok -(^BEDD.EDProcD) } Else { Lock +(^BEDD.EDProcD(id)):$zu(115,4) Set lockok=$Select($test:1,1:0),lock=lockok } If 'lockok { Set sc=$$Error^%apiOBJ(5803,$classname()) Goto SaveDataEXIT } }
		s ^BEDD.EDProcD(id)=$lb("",i%DFN,i%EDVISITID,i%EDProc,i%ProcStf,i%ProcDt,i%ProcSTm,i%ProcETm,i%ProcNotes,i%ProcEDt)
	}
SaveDataEXIT
	if (('sc)) && ('idassigned) { Set $zobjoid("",$listget(i%"%%OID"))="" Set $this."%%OID" = "" kill:$g(%objtxSTATUS)=2 %objtxOIDASSIGNED(+$this) }
	If lock Lock -(^BEDD.EDProcD(id))
	If (('sc)) { if (tSharedLock) {  Lock -(^BEDD.EDProcD(id)#"S") } elseif (lockok=1)&&(insert)&&(..%Concurrency=4) {  Lock -(^BEDD.EDProcD(id)) } }
SaveDataRET	Set $Ztrap = ""
	QUIT sc
SaveDataERR	Set $Ztrap = "SaveDataRET"
	Set sc = $$Error^%apiOBJ(5002,$ZE)
	Goto SaveDataEXIT }
%SaveDirect(id="",idList="",data,concurrency=-1) public {
	Set $ZTrap="SaveDirectERR" set sc=1
	if concurrency=-1 { Set concurrency=$zu(115,10) }
	if id="" { s id=$i(^BEDD.EDProcD), insert=1 } else { s insert=0 }
	Set lock=0
	If '$Tlevel { Kill %0CacheLock }
	i (insert)&&(concurrency) { If $i(%0CacheLock($classname()))>$zu(115,6) { Lock +(^BEDD.EDProcD):$zu(115,4) Set lock=$Select($test:2,1:0) Lock:lock -(^BEDD.EDProcD) } Else { Lock +(^BEDD.EDProcD(id)):$zu(115,4) Set lock=$Select($test:1,1:0) } If 'lock { Set sc=$$Error^%apiOBJ(5803,$classname()) Goto SaveDirectEXIT } }
	s ^BEDD.EDProcD(id)=data
SaveDirectEXIT
	If lock=1 Lock -(^BEDD.EDProcD(id))
SaveDirectRET	Set $Ztrap = ""
	QUIT sc
SaveDirectERR	Set $Ztrap = "SaveDirectRET"
	Set sc = $$Error^%apiOBJ(5002,$ZE)
	Goto SaveDirectEXIT }
%SerializeObject(serial,partial=0) public {
	Set $Ztrap = "%SerializeObjectERR"
	If $get(%objTX2(+$this)) { Set partial = 1 } ElseIf ('partial) { Set %objTX2(+$this) = 1 }
	Set sc=..%ValidateObject() If ('sc) { Ztrap "SO" }
	Set sc=..%NormalizeObject() If ('sc) { Ztrap "SO" }
	If r%ProcNotes'="" { Set:'$data(%objTX(1,+r%ProcNotes,1)) %objTX(1,+r%ProcNotes)=r%ProcNotes,%objTX(1,+r%ProcNotes,1)=..ProcNotesGetObject(1),%objTX(1,+r%ProcNotes,6)=2 Set M%ProcNotes=1,i%ProcNotes=$list(%objTX(1,+r%ProcNotes,1),1,2) }
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
	Set Poref=r%ProcNotes If Poref'="" Set:'$data(%objTX(1,+Poref)) %objTX(6,$i(%objTX(6)))=Poref Set %objTX(8,$i(%objTX(8)))=$lb(+Poref,intOref,3,$listget(i%ProcNotes))
exit	Quit sc }
%SortBegin(idxlist="",excludeunique=0)
	if $ll(idxlist) { quit $$Error^%apiOBJ(5066,$classname()_"::"_$ListToString(idxlist)) } QUIT 1
	Quit
%SortEnd(idxlist="",commit=1)
	if $ll(idxlist) { quit $$Error^%apiOBJ(5066,$classname()_"::"_$ListToString(idxlist)) } QUIT 1
	Quit
%UnlockExtent(shared=0,immediate=0) public {
	if ('immediate)&&('shared) { l -^BEDD.EDProcD q 1 } elseif (immediate)&&('shared) { l -^BEDD.EDProcD#"I" q 1 } elseif ('immediate)&&(shared) { l -^BEDD.EDProcD#"S" q 1 } else { l -^BEDD.EDProcD#"SI" q 1 }
}
%UnlockId(id,shared=0,immediate=0) public {
	if ('immediate)&&('shared) { Lock -(^BEDD.EDProcD(id)) q 1 } elseif (immediate)&&('shared) { Lock -(^BEDD.EDProcD(id)#"I") q 1 } elseif ('immediate)&&(shared) { Lock -(^BEDD.EDProcD(id)#"S") q 1 } else { Lock -(^BEDD.EDProcD(id)#"SI") q 1 }
}
%ValidateObject(force=0) public {
	Set sc=1
	If '$system.CLS.GetModified() Quit sc
	If m%DFN Set iv=..DFN If iv'="" Set rc=(..DFNIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"DFN",iv)
	If m%EDProc Set iv=..EDProc If iv'="" Set rc=(..EDProcIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"EDProc",iv)
	If m%EDVISITID Set iv=..EDVISITID If iv'="" Set rc=(..EDVISITIDIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"EDVISITID",iv)
	If m%ProcDt Set iv=..ProcDt If iv'="" Set rc=(..ProcDtIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"ProcDt",iv)
	If m%ProcEDt Set iv=..ProcEDt If iv'="" Set rc=(..ProcEDtIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"ProcEDt",iv)
	If m%ProcETm Set iv=..ProcETm If iv'="" Set rc=(..ProcETmIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"ProcETm",iv)
	If m%ProcSTm Set iv=..ProcSTm If iv'="" Set rc=(..ProcSTmIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"ProcSTm",iv)
	If m%ProcStf Set iv=..ProcStf If iv'="" Set rc=(..ProcStfIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"ProcStf",iv)
	Quit sc }
zCalcTime(stm,etm) public {
	Set calctm=0
	If ((stm="")||(etm="")) {
		Quit calctm
	}
	Set calctm=((etm-stm)\60)
	Quit calctm }
zCmbDt(cidt,citm) public {
	Set cdt=""
	If ((cidt="")||(citm="")) {
		Quit cdt
	}
	Set rpf1=cidt_","_citm s cdt=$$HTE^XLFDT(rpf1,"5D")
	Quit cdt }
zCmbDtT(cidt,stm,etm) public {
	Set cdt=""
	If ((cidt="")||(stm="")) {
		Quit cdt
	}
	Set rpf1=cidt_","_stm
	Set cdt=$$HTE^XLFDT(rpf1,"5D")_" - "_$$HTIME^BEDDUTID(etm)
	Quit cdt }
zGetAge(edvisitid) public {
	Set ptAge=0
	If (edvisitid'="") {
		Set edref=##class(BEDD.EDVISIT).%OpenId(edvisitid)
		Set ptAge=edref.Age
		Set edref=""
	}
	Quit ptAge }
zGetCIDt(edvisitid) public {
	Set ptcidt=""
	If (edvisitid'="") {
		Set edref=##class(BEDD.EDVISIT).%OpenId(edvisitid)
		Set ptcidt=edref.CIDt
		Set edref=""
	}
	Quit ptcidt }
zGetCITm(edvisitid) public {
	Set ptcitm=""
	If (edvisitid'="") {
		Set edref=##class(BEDD.EDVISIT).%OpenId(edvisitid)
		Set ptcitm=edref.CITm
		Set edref=""
	}
	Quit ptcitm }
zGetChart(edvisitid) public {
	Set ptChart=""
	If (edvisitid'="") {
		Set edref=##class(BEDD.EDVISIT).%OpenId(edvisitid)
		Set ptChart=edref.Chart
		Set edref=""
	}
	Quit ptChart }
zGetDOB(edvisitid) public {
	Set ptDOB=""
	If (edvisitid'="") {
		Set edref=##class(BEDD.EDVISIT).%OpenId(edvisitid)
		Set ptDOB=edref.DOB
		Set edref=""
	}
	Quit ptDOB }
zGetName(edvisitid) public {
	Set ptName=""
	If (edvisitid'="") {
		Set edref=##class(BEDD.EDVISIT).%OpenId(edvisitid)
		Set ptName=edref.PtName
		Set edref=""
	}
	Quit ptName }
zGetProcN(ien) public {
	Set prn=""
	If ((ien'="")&&(+ien>0)) {
		Set prn=$$GETF^BEDDUTIL(9009083,ien,".01","I")
	}
	Quit prn }
zGetSex(edvisitid) public {
	Set ptSex=""
	If (edvisitid'="") {
		Set edref=##class(BEDD.EDVISIT).%OpenId(edvisitid)
		Set ptSex=edref.Sex
		Set edref=""
	}
	Quit ptSex }
zGetStfN(ien) public {
	Set stfName=""
	If (ien'="") {
		Set stfName=$$GETF^BEDDUTIL(200,ien,.01,"I")
	}
	Quit stfName }
zAgeCompute(%id,%d1)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDProc).GetAge(%d1)
	} catch %tException { throw %tException }
	Quit %val
zAgeGet() public {
	Quit ..AgeCompute($listget(i%"%%OID"),..EDVISITID) }
zAgeSQLCompute()
	// Compute code for field Age
 Set %d(2)=##class(BEDD.EDProc).GetAge($g(%d(10)))
 QUIT
zCIDtCompute(%id,%d1)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDProc).GetCIDt(%d1) 
	} catch %tException { throw %tException }
	Quit %val
zCIDtDisplayToLogical(%val) public {
 q:%val="" "" set %val=$zdh(%val,,,5,80,20,,,"Error: '"_%val_"' is an invalid DISPLAY Date value") q:%val||(%val=0) %val s %msg=%val ZTRAP "ODAT" }
zCIDtGet() public {
	Quit ..CIDtCompute($listget(i%"%%OID"),..EDVISITID) }
zCIDtIsValid(%val) public {
	Q $s($zu(115,13)&&(%val=$c(0)):1,$isvalidnum(%val,0,0,):1,'$isvalidnum(%val):$$Error^%apiOBJ(7207,%val),1:$$Error^%apiOBJ(7204,%val,0)) }
zCIDtLogicalToDisplay(%val) public {
	quit $select(%val="":"",%val'["-":$zdate(%val,,,4),1:$$FormatJulian^%qarfunc(%val,-1)) }
zCIDtLogicalToOdbc(%val="") public {
	Quit $select(%val="":"",%val'["-":$zdate(%val,3),1:%val) }
zCIDtNormalize(%val) public {
	Quit $s($zu(115,13)&&(%val=$c(0)):"",1:%val\1) }
zCIDtOdbcToLogical(%val="") public {
 quit:%val=""||($zu(115,13)&&(%val=$c(0))) "" set %val=$zdh(%val,3,,,,,,,"Error: '"_%val_"' is an invalid ODBC/JDBC Date value") q:%val||(%val=0) %val s %msg=%val ZTRAP "ODAT" }
zCIDtSQLCompute()
	// Compute code for field CIDt
 Set %d(3)=##class(BEDD.EDProc).GetCIDt($g(%d(10))) 
 QUIT
zCITmCompute(%id,%d1)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDProc).GetCITm(%d1) 
	} catch %tException { throw %tException }
	Quit %val
zCITmDisplayToLogical(%val)
 quit:%val="" "" s %val=$ztimeh(%val,,"Error: '"_%val_"' is an invalid DISPLAY Time value") q:%val||(%val=0) %val s %msg=%val ZTRAP "OTIM"
	Quit
zCITmGet() public {
	Quit ..CITmCompute($listget(i%"%%OID"),..EDVISITID) }
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
 Set %d(4)=##class(BEDD.EDProc).GetCITm($g(%d(10))) 
 QUIT
zChartCompute(%id,%d1)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDProc).GetChart(%d1) 
	} catch %tException { throw %tException }
	Quit %val
zChartGet() public {
	Quit ..ChartCompute($listget(i%"%%OID"),..EDVISITID) }
zChartSQLCompute()
	// Compute code for field Chart
 Set %d(5)=##class(BEDD.EDProc).GetChart($g(%d(10))) 
 QUIT
zDFNGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDProcD(id)),2),1:"") }
zDOBCompute(%id,%d1)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDProc).GetDOB(%d1)
	} catch %tException { throw %tException }
	Quit %val
zDOBGet() public {
	Quit ..DOBCompute($listget(i%"%%OID"),..EDVISITID) }
zDOBSQLCompute()
	// Compute code for field DOB
 Set %d(7)=##class(BEDD.EDProc).GetDOB($g(%d(10)))
 QUIT
zEDProcGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDProcD(id)),4),1:"") }
zEDProcNCompute(%id,%d1)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDProc).GetProcN(%d1)
	} catch %tException { throw %tException }
	Quit %val
zEDProcNGet() public {
	Quit ..EDProcNCompute($listget(i%"%%OID"),..EDProc) }
zEDProcNSQLCompute()
	// Compute code for field EDProcN
 Set %d(9)=##class(BEDD.EDProc).GetProcN($g(%d(8)))
 QUIT
zEDVISITIDGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDProcD(id)),3),1:"") }
zProcDtGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDProcD(id)),6),1:"") }
zProcEDtGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDProcD(id)),10),1:"") }
zProcETmGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDProcD(id)),8),1:"") }
zProcNotesDelete(streamvalue) public {
	Set $ZTrap = "CatchError"
	Quit $select(streamvalue="":$$Error^%apiOBJ(5813,$classname()),1:##class(%Library.GlobalCharacterStream).%Delete($select(streamvalue="":"",1:$listbuild($listget(streamvalue),$listget(streamvalue,2),"^BEDD.EDProcS"))))
CatchError	Set $ZTrap=""
	Quit $$Error^%apiOBJ(5002,$zerror) }
zProcNotesGetObject(force=0) public {
	Quit:r%ProcNotes="" $select(i%ProcNotes="":"",1:$listbuild($listget(i%ProcNotes),$listget(i%ProcNotes,2),"^BEDD.EDProcS")) Quit:(''..ProcNotes.%GetSwizzleObject(force,.oid)) oid Quit "" }
zProcNotesGetObjectId(force=0) public {
	Quit $listget(..ProcNotesGetObject(force)) }
zProcNotesGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDProcD(id)),9),1:"") }
zProcNotesGetSwizzled() public {
	If i%ProcNotes="" Set modstate=$system.CLS.GetSModifiedBits() Set oref=..ProcNotesNewObject("") Do $system.CLS.SetSModifiedBits(modstate) Set r%ProcNotes=0,r%ProcNotes=oref Quit oref
	Set oref=##class(%Library.GlobalCharacterStream).%Open($select(i%ProcNotes="":"",1:$listbuild($listget(i%ProcNotes),$listget(i%ProcNotes,2),"^BEDD.EDProcS")),,.sc) If ('sc) Do:$get(^%SYS("ThrowSwizzleError"),0) $zutil(96,3,19,1) Quit ""
	Set modstate=$system.CLS.GetModifiedBits() Set r%ProcNotes=oref Do $system.CLS.SetModifiedBits(modstate)
	Quit oref }
zProcNotesNewObject(type="") public {
	Set $ZTrap = "CatchError"
	Set sc=1
	If type="" {
		Set type = "%Library.GlobalCharacterStream"
	} ElseIf '($classmethod(type,"%IsA","%Library.GlobalCharacterStream")) {
		Set sc=$$Error^%apiOBJ(5833,"BEDD.EDProc","ProcNotes") Quit ""
	}
	Set newobject=$classmethod(type,"%New","^BEDD.EDProcS") If newobject="" Quit ""
	Set r%ProcNotes=0,i%ProcNotes=0,r%ProcNotes=newobject,i%ProcNotes=""
	Quit newobject
CatchError	Set $ZTrap=""
	If (''sc) Set sc = $$Error^%apiOBJ(5002,$ze)
	Quit "" }
zProcNotesOid(streamvalue) public {
	Quit $s($isobject(streamvalue):streamvalue.%Oid(),1:$select(streamvalue="":"",1:$listbuild($listget(streamvalue),$listget(streamvalue,2),"^BEDD.EDProcS"))) }
zProcNotesOpen(streamvalue) public {
	If $get(streamvalue)="" {
		Set object=##class(%Library.GlobalCharacterStream).%New("^BEDD.EDProcS")
	} elseif $isobject(streamvalue)=1 { set object = streamvalue }
	else {
		Set object=##class(%Library.GlobalCharacterStream).%Open($select(streamvalue="":"",1:$listbuild($listget(streamvalue),$listget(streamvalue,2),"^BEDD.EDProcS")))
		If $isobject(object)=1,object.IsNull()=1 Quit ""
	}
	Quit object }
zProcNotesSet(newvalue) public {
	If newvalue="" Set r%ProcNotes=0,i%ProcNotes=0,r%ProcNotes="",i%ProcNotes="" Quit 1
	If '$isobject(newvalue) Quit $$Error^%apiOBJ(5807,newvalue)
	If newvalue=r%ProcNotes Quit 1
	If newvalue.%Extends("%AbstractStream") {
		Set r%ProcNotes=0,i%ProcNotes=0,r%ProcNotes=newvalue,i%ProcNotes=""
	} Else {
		Do ..ProcNotes.Rewind()
		Quit ..ProcNotes.CopyFrom(newvalue)
	}
	Quit 1 }
zProcNotesSetObject(newvalue) public {
	Set i%ProcNotes=0,r%ProcNotes=0,i%ProcNotes=newvalue,r%ProcNotes=""
	Quit 1 }
zProcNotesSetObjectId(newid) public {
	Quit ..ProcNotesSetObject($select(newid="":"",1:$listbuild(newid_""))) }
zProcNotesUnSwizzle(force=0) public {
	If r%ProcNotes="" Quit 1
	Set sc=..ProcNotes.%GetSwizzleObject(force,.newvalue) Quit:('sc) sc
	Set modstate=$system.CLS.GetModifiedBits() Set r%ProcNotes="" Do $system.CLS.SetModifiedBits(modstate)
	Set i%ProcNotes=newvalue
	Quit 1 }
zProcSTmGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDProcD(id)),7),1:"") }
zProcStfGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDProcD(id)),5),1:"") }
zProcStfNCompute(%id,%d1)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDProc).GetStfN(%d1)
	} catch %tException { throw %tException }
	Quit %val
zProcStfNGet() public {
	Quit ..ProcStfNCompute($listget(i%"%%OID"),..ProcStf) }
zProcStfNSQLCompute()
	// Compute code for field ProcStfN
 Set %d(17)=##class(BEDD.EDProc).GetStfN($g(%d(16)))
 QUIT
zProcTimeCompute(%id,%d1,%d2)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDProc).CalcTime(%d2,%d1)
	} catch %tException { throw %tException }
	Quit %val
zProcTimeGet() public {
	Quit ..ProcTimeCompute($listget(i%"%%OID"),..ProcETm,..ProcSTm) }
zProcTimeSQLCompute()
	// Compute code for field ProcTime
 Set %d(18)=##class(BEDD.EDProc).CalcTime($g(%d(15)),$g(%d(13)))
 QUIT
zPtCIDTCompute(%id,%d1,%d2)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDProc).CmbDt(%d1,%d2)
	} catch %tException { throw %tException }
	Quit %val
zPtCIDTGet() public {
	Quit ..PtCIDTCompute($listget(i%"%%OID"),..CIDt,..CITm) }
zPtCIDTSQLCompute()
	// Compute code for field PtCIDT
 Set %d(19)=##class(BEDD.EDProc).CmbDt($g(%d(3)),$g(%d(4)))
 QUIT
zPtNameCompute(%id,%d1)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDProc).GetName(%d1)
	} catch %tException { throw %tException }
	Quit %val
zPtNameGet() public {
	Quit ..PtNameCompute($listget(i%"%%OID"),..EDVISITID) }
zPtNameSQLCompute()
	// Compute code for field PtName
 Set %d(20)=##class(BEDD.EDProc).GetName($g(%d(10)))
 QUIT
zPtProcDTCompute(%id,%d1,%d2,%d3)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDProc).CmbDtT(%d1,%d3,%d2)
	} catch %tException { throw %tException }
	Quit %val
zPtProcDTGet() public {
	Quit ..PtProcDTCompute($listget(i%"%%OID"),..ProcDt,..ProcETm,..ProcSTm) }
zPtProcDTSQLCompute()
	// Compute code for field PtProcDT
 Set %d(21)=##class(BEDD.EDProc).CmbDtT($g(%d(11)),$g(%d(15)),$g(%d(13)))
 QUIT
zSexCompute(%id,%d1)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDProc).GetSex(%d1)
	} catch %tException { throw %tException }
	Quit %val
zSexGet() public {
	Quit ..SexCompute($listget(i%"%%OID"),..EDVISITID) }
zSexSQLCompute()
	// Compute code for field Sex
 Set %d(22)=##class(BEDD.EDProc).GetSex($g(%d(10)))
 QUIT
zExtentExecute(%qHandle) [ SQLCODE,c1 ] public { New %ROWCOUNT,%ROWID,%msg,SQLCODE,c1 
	Set sc=1
	s %qHandle=$i(%objcn)
	 ;---&sql(DECLARE QExtent CURSOR FOR
 	 ;---		 SELECT ID FROM BEDD.EDProc)
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
	Do %0Ko
	If 'SQLCODE { Set Row=$lb(c1) Set sc=1 } ElseIf SQLCODE=100 { Set AtEnd=1,sc=1 Set:$isobject($g(%sqlcontext)) %sqlcontext.%SQLCODE=SQLCODE,%sqlcontext.%ROWCOUNT=$g(%ROWCOUNT) } Else { Set:$isobject($g(%sqlcontext)) %sqlcontext.%SQLCODE=SQLCODE,%sqlcontext.Message=$g(%msg) Set AtEnd=1,sc=$$Error^%apiOBJ(5540,SQLCODE,$get(%msg)) }
	QUIT sc }
zExtentFetchRows(%qHandle,FetchCount=0,RowSet,ReturnCount,AtEnd) [ SQLCODE,c1 ] public { New %ROWCOUNT,%ROWID,%msg,SQLCODE,c1 
	Set RowSet="",ReturnCount=0,AtEnd=0
	For {
		 ;---&sql(FETCH QExtent INTO :c1)
 		 ;--- ** SQL PUBLIC Variables: %ROWCOUNT, %ROWID, %msg, SQLCODE, c1
		Do %0Lo
		If 'SQLCODE { Set RowSet=RowSet_$lb(c1),ReturnCount=ReturnCount+1 Quit:(ReturnCount=FetchCount)||(($l(RowSet)+($l(RowSet)\ReturnCount))>24000) } Else { Set AtEnd=1 Quit }
	}
	If 'SQLCODE { Set sc=1 } ElseIf SQLCODE=100 { Set sc=1 Set:$isobject($g(%sqlcontext)) %sqlcontext.%SQLCODE=SQLCODE,%sqlcontext.%ROWCOUNT=$g(%ROWCOUNT) } Else { Set:$isobject($g(%sqlcontext)) %sqlcontext.%SQLCODE=SQLCODE,%sqlcontext.Message=$g(%msg) Set sc=$$Error^%apiOBJ(5540,SQLCODE,$get(%msg)) }
	Quit sc }
 q
%QExtent0o 
 s $zt="%QExtent0E" s SQLCODE=$s($g(%objcsc(%qHandle)):-101,1:0) q:SQLCODE'=0  s %objcsd(%qHandle,1)=0 set:$d(%0CacheRowLimit)#2 %objcsd(%qHandle,2)=%0CacheRowLimit s %objcsd(%qHandle,3)=0,%objcsd(%qHandle,4)="" d:$zu(115,15) $system.ECP.Sync()
 s %objcsc(%qHandle)=1 q
%QExtent0E s $zt="" d SQLRunTimeError^%apiSQL($ze,.SQLCODE,.%msg) k %objcsd(%qHandle),%objcsc(%qHandle),%objcss(%qHandle),%objcst(%qHandle),%objcsp(%qHandle) q
%0Gfirst 
 ; asl MOD# 2
 s %objcsd(%qHandle,5)=""
%0GmBk1 s %objcsd(%qHandle,5)=$o(^BEDD.EDProcD(%objcsd(%qHandle,5)))
 i %objcsd(%qHandle,5)="" g %0GmBdun
 g:$zu(115,2)=0 %0GmBuncommitted i $zu(115,2)=1 l +^BEDD.EDProcD($p(%objcsd(%qHandle,5),"||",1))#"S":$zu(115,4) i $t { s %objcsd(%qHandle,3)=1,%objcsd(%qHandle,4)=$name(^BEDD.EDProcD($p(%objcsd(%qHandle,5),"||",1)))_"#""SI""" } else { s SQLCODE=-114,%msg="Unable to acquire shared lock on table BEDD.EDProc for RowID value: "_%objcsd(%qHandle,5) ztrap "LOCK"  }
 ; asl MOD# 3
 i %objcsd(%qHandle,5)'="",$d(^BEDD.EDProcD(%objcsd(%qHandle,5)))
 e  g %0GmCdun
%0GmBuncommitted ;
 s:$g(SQLCODE)'<0 SQLCODE=0 s %objcsd(%qHandle,1)=%objcsd(%qHandle,1)+1,%ROWCOUNT=%objcsd(%qHandle,1),%ROWID=%objcsd(%qHandle,5),%objcsc(%qHandle)=10 q
%QExtent0f i '$g(%objcsc(%qHandle)) { s SQLCODE=-102 q  } i %objcsc(%qHandle)=100 { s SQLCODE=100 q  } s SQLCODE=0
 s $zt="%0Gerr"
 i $d(%objcsd(%qHandle,2))#2,$g(%objcsd(%qHandle,1))'<%objcsd(%qHandle,2) { s SQLCODE=100,%ROWCOUNT=%objcsd(%qHandle,1),%objcsc(%qHandle)=100 q }
 g %0Gfirst:%objcsc(%qHandle)=1
%0GmCdun if $zu(115,2)=1 { if $g(%objcsd(%qHandle,3))=1 { l -@%objcsd(%qHandle,4) s %objcsd(%qHandle,3)=0 } elseif $g(%objcsd(%qHandle,3))=2 { do $classmethod($li(%objcsd(%qHandle,4)),"%UnlockId",$li(%objcsd(%qHandle,4),2),1,1)  s %objcsd(%qHandle,3)=0 } }
 g %0GmBk1
%0GmBdun 
%0GmAdun 
 s %ROWCOUNT=%objcsd(%qHandle,1),SQLCODE=100,%objcsc(%qHandle)=100 q
%QExtent0c i '$g(%objcsc(%qHandle)) { s SQLCODE=-102 q  }
 s %ROWCOUNT=$s($g(SQLCODE)'<0:+$g(%objcsd(%qHandle,1)),1:0)
 if $zu(115,2)=1 { if $g(%objcsd(%qHandle,3))=1 { l -@%objcsd(%qHandle,4) } elseif $g(%objcsd(%qHandle,3))=2 { do $classmethod($li(%objcsd(%qHandle,4)),"%UnlockId",$li(%objcsd(%qHandle,4),2),1,1)  } }
 k %objcsd(%qHandle),%objcsc(%qHandle) s SQLCODE=0 q
%0Gerr s $zt="" d SQLRunTimeError^%apiSQL($ze,.SQLCODE,.%msg)
 s %objcsc(%qHandle)=100 q
%0Ko d %QExtent0f q:SQLCODE'=0
 s c1=%objcsd(%qHandle,5)
 q
%0Lo d %QExtent0f q:SQLCODE'=0
 s c1=%objcsd(%qHandle,5)
 q
zExtentFunc() public {
	try {
		set tSchemaPath = ##class(%SQL.Statement).%ClassPath($classname())
			set tStatement = ##class(%SQL.Statement).%New(,tSchemaPath)
			do tStatement.prepare(" SELECT ID FROM BEDD . EDProc")
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
	If $Get(^oddPROC("BEDD","EDPROC_EXTENT",21))'="" { Set sc = 1, metadata=$Select(version=4:^oddPROC("BEDD","EDPROC_EXTENT",12),1:^oddPROC("BEDD","EDPROC_EXTENT",12,version)) }
	ElseIf $Data(^oddPROC("BEDD","EDPROC_EXTENT")) { Set sc = $$CompileSignature^%ourProcedure("BEDD","EDPROC_EXTENT",.metadata,.signature) }
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
zprocPrintExecute(%qHandle,edvisitid) [ Row,SQLCODE,edvisitid ] public { New %ROWCOUNT,%ROWID,%msg,Row,SQLCODE 
	s %qHandle=$i(%objcn)
	 ;---&sql(DECLARE Q2 CURSOR FOR
 	 ;---		SELECT EDProc as EDProc, EDProcN as EDProcN, ProcStf as ProcStf, ProcDt as ProcDt, ProcSTm as ProcSTm, ProcEDt as ProcEDt, ProcETm as ProcETm
 	 ;---		FROM BEDD.EDProc
 	 ;---		WHERE EDVISITID=:edvisitid
 	 ;---		)
 	 ;--- ** SQL PUBLIC Variables: %ROWCOUNT, %ROWID, %msg, SQLCODE, edvisitid
	
	 ;---&sql(OPEN Q2)
 	 ;--- ** SQL PUBLIC Variables: %ROWCOUNT, %ROWID, %msg, SQLCODE
	Do %Q20o
	If SQLCODE { Set:$isobject($g(%sqlcontext)) %sqlcontext.%SQLCODE=SQLCODE,%sqlcontext.%Message=$g(%msg) Set sc=$$Error^%apiOBJ(5821,"SQLCODE = "_SQLCODE) } Else { Set sc=1 }
	Quit sc }
zprocPrintClose(%qHandle) [ Row,SQLCODE,edvisitid ] public { New %ROWCOUNT,%ROWID,%msg,Row,SQLCODE,edvisitid 
	 ;---&sql(CLOSE Q2)
 	 ;--- ** SQL PUBLIC Variables: %ROWCOUNT, %ROWID, %msg, SQLCODE
	Do %Q20c
	If SQLCODE { Set:$isobject($g(%sqlcontext)) %sqlcontext.%SQLCODE=SQLCODE,%sqlcontext.%Message=$g(%msg) Set sc=$$Error^%apiOBJ(5540,SQLCODE,$get(%msg)) } Else { Set sc=1 }
	Kill %objcsc(%qHandle),%objcsp(%qHandle),%objcss(%qHandle),%objcst(%qHandle),%objcsl(%qHandle),%objcsR(%qHandle),%objcsZ(%qHandle),%objcsd(%qHandle)
	Quit sc }
zprocPrintFetch(%qHandle,Row,AtEnd=0) [ Row,SQLCODE,edvisitid ] public { New %ROWCOUNT,%ROWID,%msg,SQLCODE,edvisitid 
	kill Row Set Row="",AtEnd=0
	 ;---&sql(FETCH Q2 INTO :Row(0,1),:Row(0,2),:Row(0,3),:Row(0,4),:Row(0,5),:Row(0,6),:Row(0,7))
 	 ;--- ** SQL PUBLIC Variables: %ROWCOUNT, %ROWID, %msg, Row, SQLCODE
	Do %0Vo
	If 'SQLCODE { Set sc=1,Row=$lb(Row(0,1),Row(0,2),Row(0,3),Row(0,4),Row(0,5),Row(0,6),Row(0,7)) } ElseIf SQLCODE=100 { Set AtEnd=1,sc=1 Set:$isobject($g(%sqlcontext)) %sqlcontext.%SQLCODE=SQLCODE,%sqlcontext.%ROWCOUNT=$g(%ROWCOUNT) } Else { Set:$isobject($g(%sqlcontext)) %sqlcontext.%SQLCODE=SQLCODE,%sqlcontext.Message=$g(%msg) Set AtEnd=1,sc=$$Error^%apiOBJ(5540,SQLCODE,$get(%msg)) }
	QUIT sc }
zprocPrintFetchRows(%qHandle,FetchCount=0,RowSet,ReturnCount,AtEnd) [ Row,SQLCODE,edvisitid ] public { New %ROWCOUNT,%ROWID,%msg,Row,SQLCODE,edvisitid 
	Set RowSet="",ReturnCount=0,AtEnd=0
	For {
		Set sc=..procPrintFetch(.%qHandle,.Row,.AtEnd)
		If (''sc) { Set RowSet=RowSet_Row,ReturnCount=ReturnCount+1 Quit:(ReturnCount=FetchCount)||(($l(RowSet)+($l(RowSet)\ReturnCount))>24000)||(AtEnd) } Else { Set AtEnd=1 Quit }
	}
	Quit sc }
 q
%0MmBs1(%val) ;
	Q $tr(%val,$c(0),"")
%0MmBs2(%val="") ;
	Quit $select(%val="":"",%val'["-":$zdate(%val,3),1:%val)
%0MmBs3(%val) ;
	quit $select(%val="":"",%val'["-":$zdate(%val,,,4),1:$$FormatJulian^%qarfunc(%val,-1))
%0MmBs4(%val="") ;
	Quit $select(%val="":"",1:$ztime(%val))
%0MmBs5(%val) ;
	Quit $select(%val="":"",1:$ztime(%val))
%Q20o 
 s $zt="%Q20E" s SQLCODE=$s($g(%objcsc(%qHandle)):-101,1:0) q:SQLCODE'=0  s %objcsd(%qHandle,1)=0 set:$d(%0CacheRowLimit)#2 %objcsd(%qHandle,2)=%0CacheRowLimit s %objcsd(%qHandle,3)=0,%objcsd(%qHandle,4)="" d:$zu(115,15) $system.ECP.Sync()
 s %objcsd(%qHandle,5)=$g(edvisitid)
 s %objcsd(%qHandle,6)=$zu(28,%objcsd(%qHandle,5),7)
 s %objcsc(%qHandle)=1 q
%Q20E s $zt="" d SQLRunTimeError^%apiSQL($ze,.SQLCODE,.%msg) k %objcsd(%qHandle),%objcsc(%qHandle),%objcss(%qHandle),%objcst(%qHandle),%objcsp(%qHandle) q
%0Mfirst 
 ; asl MOD# 2
 s %objcsd(%qHandle,7)=""
%0MmBk1 s %objcsd(%qHandle,7)=$o(^BEDD.EDProcD(%objcsd(%qHandle,7)))
 i %objcsd(%qHandle,7)="" g %0MmBdun
 s %objcsd(%qHandle,8)=$g(^BEDD.EDProcD(%objcsd(%qHandle,7))) s %objcsd(%qHandle,9)=$lg(%objcsd(%qHandle,8),3) s %objcsd(%qHandle,10)=$zu(28,%objcsd(%qHandle,9),7)
 g:'(%objcsd(%qHandle,10)=%objcsd(%qHandle,6)) %0MmBk1
 g:'(%objcsd(%qHandle,10)'=" ") %0MmBk1
 s %objcsd(%qHandle,11)=$lg(%objcsd(%qHandle,8),4) s %objcsd(%qHandle,12)=$s($zu(115,5)=2:$$%0MmBs1(%objcsd(%qHandle,11)),1:%objcsd(%qHandle,11)) s %objcsd(%qHandle,13)=$lg(%objcsd(%qHandle,8),5) s %objcsd(%qHandle,14)=$s($zu(115,5)=2:$$%0MmBs1(%objcsd(%qHandle,13)),1:%objcsd(%qHandle,13)) s %objcsd(%qHandle,15)=$lg(%objcsd(%qHandle,8),6) s %objcsd(%qHandle,16)=$s($zu(115,5)=1:$$%0MmBs2(%objcsd(%qHandle,15)),$zu(115,5)=2:$$%0MmBs3(%objcsd(%qHandle,15)),1:%objcsd(%qHandle,15)) s %objcsd(%qHandle,17)=$lg(%objcsd(%qHandle,8),7) s %objcsd(%qHandle,18)=$s($zu(115,5)=1:$$%0MmBs4(%objcsd(%qHandle,17)),$zu(115,5)=2:$$%0MmBs5(%objcsd(%qHandle,17)),1:%objcsd(%qHandle,17)) s %objcsd(%qHandle,19)=$lg(%objcsd(%qHandle,8),10) s %objcsd(%qHandle,20)=$s($zu(115,5)=1:$$%0MmBs2(%objcsd(%qHandle,19)),$zu(115,5)=2:$$%0MmBs3(%objcsd(%qHandle,19)),1:%objcsd(%qHandle,19)) s %objcsd(%qHandle,21)=$lg(%objcsd(%qHandle,8),8) s %objcsd(%qHandle,22)=$s($zu(115,5)=1:$$%0MmBs4(%objcsd(%qHandle,21)),$zu(115,5)=2:$$%0MmBs5(%objcsd(%qHandle,21)),1:%objcsd(%qHandle,21))
 d
 . Set %objcsd(%qHandle,23)=##class(BEDD.EDProc).GetProcN(%objcsd(%qHandle,11))
 s %objcsd(%qHandle,24)=$s($zu(115,5)=2:$$%0MmBs1(%objcsd(%qHandle,23)),1:%objcsd(%qHandle,23))
 g:$zu(115,2)=0 %0MmBuncommitted i $zu(115,2)=1 l +^BEDD.EDProcD($p(%objcsd(%qHandle,7),"||",1))#"S":$zu(115,4) i $t { s %objcsd(%qHandle,3)=1,%objcsd(%qHandle,4)=$name(^BEDD.EDProcD($p(%objcsd(%qHandle,7),"||",1)))_"#""SI""" } else { s SQLCODE=-114,%msg="Unable to acquire shared lock on table BEDD.EDProc for RowID value: "_%objcsd(%qHandle,7) ztrap "LOCK"  }
 ; asl MOD# 3
 s %objcsd(%qHandle,25)=$lb(""_%objcsd(%qHandle,10))
 i %objcsd(%qHandle,7)'="",$d(^BEDD.EDProcD(%objcsd(%qHandle,7)))
 e  g %0MmCdun
 s %objcsd(%qHandle,26)=$g(^BEDD.EDProcD(%objcsd(%qHandle,7))) s %objcsd(%qHandle,11)=$lg(%objcsd(%qHandle,26),4) s %objcsd(%qHandle,12)=$s($zu(115,5)=2:$$%0MmBs1(%objcsd(%qHandle,11)),1:%objcsd(%qHandle,11)) s %objcsd(%qHandle,13)=$lg(%objcsd(%qHandle,26),5) s %objcsd(%qHandle,14)=$s($zu(115,5)=2:$$%0MmBs1(%objcsd(%qHandle,13)),1:%objcsd(%qHandle,13)) s %objcsd(%qHandle,15)=$lg(%objcsd(%qHandle,26),6) s %objcsd(%qHandle,16)=$s($zu(115,5)=1:$$%0MmBs2(%objcsd(%qHandle,15)),$zu(115,5)=2:$$%0MmBs3(%objcsd(%qHandle,15)),1:%objcsd(%qHandle,15)) s %objcsd(%qHandle,17)=$lg(%objcsd(%qHandle,26),7) s %objcsd(%qHandle,18)=$s($zu(115,5)=1:$$%0MmBs4(%objcsd(%qHandle,17)),$zu(115,5)=2:$$%0MmBs5(%objcsd(%qHandle,17)),1:%objcsd(%qHandle,17)) s %objcsd(%qHandle,19)=$lg(%objcsd(%qHandle,26),10) s %objcsd(%qHandle,20)=$s($zu(115,5)=1:$$%0MmBs2(%objcsd(%qHandle,19)),$zu(115,5)=2:$$%0MmBs3(%objcsd(%qHandle,19)),1:%objcsd(%qHandle,19)) s %objcsd(%qHandle,21)=$lg(%objcsd(%qHandle,26),8) s %objcsd(%qHandle,22)=$s($zu(115,5)=1:$$%0MmBs4(%objcsd(%qHandle,21)),$zu(115,5)=2:$$%0MmBs5(%objcsd(%qHandle,21)),1:%objcsd(%qHandle,21))
 s %objcsd(%qHandle,9)=$lg(%objcsd(%qHandle,26),3) s %objcsd(%qHandle,10)=$zu(28,%objcsd(%qHandle,9),7)
 d
 . Set %objcsd(%qHandle,23)=##class(BEDD.EDProc).GetProcN(%objcsd(%qHandle,11))
 s %objcsd(%qHandle,24)=$s($zu(115,5)=2:$$%0MmBs1(%objcsd(%qHandle,23)),1:%objcsd(%qHandle,23))
 s %objcsd(%qHandle,27)=$lb(""_%objcsd(%qHandle,10))
 g:%objcsd(%qHandle,25)'=%objcsd(%qHandle,27) %0MmCdun
%0MmBuncommitted ;
 s:$g(SQLCODE)'<0 SQLCODE=0 s %objcsd(%qHandle,1)=%objcsd(%qHandle,1)+1,%ROWCOUNT=%objcsd(%qHandle,1),%ROWID=%objcsd(%qHandle,7),%objcsc(%qHandle)=10 q
%Q20f i '$g(%objcsc(%qHandle)) { s SQLCODE=-102 q  } i %objcsc(%qHandle)=100 { s SQLCODE=100 q  } s SQLCODE=0
 s $zt="%0Merr"
 i $d(%objcsd(%qHandle,2))#2,$g(%objcsd(%qHandle,1))'<%objcsd(%qHandle,2) { s SQLCODE=100,%ROWCOUNT=%objcsd(%qHandle,1),%objcsc(%qHandle)=100 q }
 g %0Mfirst:%objcsc(%qHandle)=1
%0MmCdun if $zu(115,2)=1 { if $g(%objcsd(%qHandle,3))=1 { l -@%objcsd(%qHandle,4) s %objcsd(%qHandle,3)=0 } elseif $g(%objcsd(%qHandle,3))=2 { do $classmethod($li(%objcsd(%qHandle,4)),"%UnlockId",$li(%objcsd(%qHandle,4),2),1,1)  s %objcsd(%qHandle,3)=0 } }
 g %0MmBk1
%0MmBdun 
%0MmAdun 
 s %ROWCOUNT=%objcsd(%qHandle,1),SQLCODE=100,%objcsc(%qHandle)=100 q
%Q20c i '$g(%objcsc(%qHandle)) { s SQLCODE=-102 q  }
 s %ROWCOUNT=$s($g(SQLCODE)'<0:+$g(%objcsd(%qHandle,1)),1:0)
 if $zu(115,2)=1 { if $g(%objcsd(%qHandle,3))=1 { l -@%objcsd(%qHandle,4) } elseif $g(%objcsd(%qHandle,3))=2 { do $classmethod($li(%objcsd(%qHandle,4)),"%UnlockId",$li(%objcsd(%qHandle,4),2),1,1)  } }
 k %objcsd(%qHandle),%objcsc(%qHandle) s SQLCODE=0 q
%0Merr s $zt="" d SQLRunTimeError^%apiSQL($ze,.SQLCODE,.%msg)
 s %objcsc(%qHandle)=100 q
%0Vo d %Q20f q:SQLCODE'=0
 s Row(0,1)=%objcsd(%qHandle,12),Row(0,2)=%objcsd(%qHandle,24),Row(0,3)=%objcsd(%qHandle,14),Row(0,4)=%objcsd(%qHandle,16),Row(0,5)=%objcsd(%qHandle,18),Row(0,6)=%objcsd(%qHandle,20),Row(0,7)=%objcsd(%qHandle,22)
 q
zprocPrintFunc(edvisitid) public {
	try {
		set tSchemaPath = ##class(%SQL.Statement).%ClassPath($classname())
			set tStatement = ##class(%SQL.Statement).%New(,tSchemaPath)
			do tStatement.prepare(" SELECT EDProc AS EDProc , EDProcN AS EDProcN , ProcStf AS ProcStf , ProcDt AS ProcDt , ProcSTm AS ProcSTm , ProcEDt AS ProcEDt , ProcETm AS ProcETm FROM BEDD . EDProc WHERE EDVISITID = ?")
		set tResult = tStatement.%Execute($g(edvisitid))
	}
	catch tException { if '$Isobject($Get(tResult)) { set tResult = ##class(%SQL.StatementResult).%New() } set tResult.%SQLCODE=tException.AsSQLCODE(),tResult.%Message=tException.SQLMessageString() }
	Quit tResult }
zprocPrintGetInfo(colinfo,parminfo,idinfo,%qHandle,extoption=0,extinfo) public {
	s:'($d(^oddCOM($classname(),"q","procPrint",21),clientinfo)#2)&&'$s($d(^(2),clientinfo)#2&&(clientinfo'=$classname()):$d(^oddCOM(clientinfo,"q","procPrint",21),clientinfo)#2||($d(^oddDEF(clientinfo,"q","procPrint",21),clientinfo)#2),1:$d(^oddDEF($classname(),"q","procPrint",21),clientinfo)#2) clientinfo=$g(^%qCacheObjectKey(1,"q",21))
	If clientinfo'="" Set colinfo=$listget(clientinfo,1),parminfo=$listget(clientinfo,2),idinfo=$listget(clientinfo,3),extent=$listget(clientinfo,4) Set:extoption extinfo=$s($d(^oddCOM($classname(),"q","procPrint",38))#2:^(38),$d(^oddCOM($g(^(2),$classname()),"q","procPrint",38))#2:^(38),1:$s($d(^oddDEF($g(^oddCOM($classname(),"q","procPrint",2),$classname()),"q","procPrint",38))#2:^(38),1:$g(^%qCacheObjectKey(1,"q",38)))) Quit 1
	Quit $$GetInfoSQL^%SYS.DynamicQuery($classname(),"procPrint",.colinfo,.parminfo,.idinfo,.%qHandle,extoption,.extinfo) }
zprocPrintGetODBCInfo(colinfo,parminfo,qHandle) public {
	set version = $Select($Get(%protocol,41)>40:4,1:3)
	If $Get(^oddPROC("BEDD","EDPROC_PROCPRINT",21))'="" { Set sc = 1, metadata=$Select(version=4:^oddPROC("BEDD","EDPROC_PROCPRINT",12),1:^oddPROC("BEDD","EDPROC_PROCPRINT",12,version)) }
	ElseIf $Data(^oddPROC("BEDD","EDPROC_PROCPRINT")) { Set sc = $$CompileSignature^%ourProcedure("BEDD","EDPROC_PROCPRINT",.metadata,.signature) }
	Else { Set sc = $$Error^%apiOBJ(5068,$classname()_":procPrint") }
	If (''sc) { Set colcount=$li(metadata,2),cmdlen=colcount*$Case(version,4:10,:9),colinfo=$li(metadata,2,2+cmdlen),parmcount=$li(metadata,cmdlen+3),pmdlen=parmcount*6,parminfo=$li(metadata,cmdlen+3,cmdlen+pmdlen+3) }
	Quit sc }
zprocPrintSendODBC(qHandle,array,qacn,%qrc,piece,ColumnCount) public {
	Kill array(qacn) Set %qrc=0
SPInnerLoop	Set rc=..procPrintFetch(.qHandle,.row,.atend)
	If ('rc) { Set %qrc=-400 Set:$isobject($get(%sqlcontext)) %sqlcontext.SQLCode=-400,%sqlcontext.Message=$g(%msg) Do ProcessError^%ourProcedure(rc,$get(%sqlcontext),.%qrc,.%msg) Do Logerr^%SYS.SQLSRV(%qrc,"","SP",.%msg) Set piece=0 Quit }
	If row="" Set %qrc=100,piece=0 Set:$isobject($get(%sqlcontext)) %sqlcontext.SQLCode=100 Quit 1
	If $get(%protocol)>46 { For piece=1:1:ColumnCount { Goto:$zobjexport($listget(row,piece),50) SPDone } }
	Else { For piece=1:1:ColumnCount { Goto:$zobjexport($listget(row,piece),7) SPDone } }
	Goto SPInnerLoop
SPDone	Set:$g(%protocol)>46 piece=piece+1 For i=piece:1:ColumnCount { Set array(qacn,i)=$listget(row,i) }
	Quit }
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
	if '..%SQLGetLock(id,1,.pUnlockRef) { set sqlcode=-114,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler39",,"BEDD"_"."_"EDProc"_":"_"IDKEY") QUIT 0 }
	if 'pLockOnly { new qv set qv=$d(^BEDD.EDProcD(%pVal(1))) do:'$g(pUnlockRef) ..%SQLReleaseLock(id,1) quit qv } else { do:'$g(pUnlockRef) ..%SQLReleaseLock(id,1) QUIT 1 }
	Quit
zIDKEYSQLFindPKeyByConstraint(%con)
 QUIT $$Error^%apiOBJ(5758,"%Persistent::IDKEYSQLFindPKeyByConstraint")
zIDKEYSQLFindRowIDByConstraint(%con,pInternal=0)
 QUIT $$Error^%apiOBJ(5758,"%Persistent::IDKEYSQLFindRowIDByConstraint")
