 ;BSTS.SOAP.WebFunctions.1
 ;(C)InterSystems, generated for class BSTS.SOAP.WebFunctions.  Do NOT edit. 10/22/2016 08:53:34AM
 ;;312F562F;BSTS.SOAP.WebFunctions
 ;
SQLUPPER(v,l) { quit $zu(28,v,7,$g(l,32767)) }
ALPHAUP(v,r) { quit $zu(28,v,6) }
STRING(v,l) { quit $zu(28,v,9,$g(l,32767)) }
SQLSTRING(v,l) { quit $zu(28,v,8,$g(l,32767)) }
UPPER(v) { quit $zu(28,v,5) }
MVR(v) { quit $zu(28,v,2) }
TRUNCATE(v,l) { quit $e(v,1,$g(l,3641144)) }
%BuildIndices(idxlist="",autoPurge=0,lockExtent=0) public {
	if $ll(idxlist) { quit $$Error^%apiOBJ(5066,$classname()_"::"_$ListToString(idxlist)) } QUIT 1 }
%ComposeOid(id) public {
	set tCLASSNAME = $listget($g(^BSTS.SOAP.WebFunctionsD(id)),1)
	if tCLASSNAME="" { quit $select(id="":"",1:$listbuild(id_"","BSTS.SOAP.WebFunctions")) }
	set tClass=$piece(tCLASSNAME,$extract(tCLASSNAME),$length(tCLASSNAME,$extract(tCLASSNAME))-1)
	set:tClass'["." tClass="User."_tClass
	quit $select(id="":"",1:$listbuild(id_"",tClass)) }
%DeleteData(id,concurrency) public {
	Quit:id="" $$Error^%apiOBJ(5812)
	Set $Ztrap="DeleteDataERR" Set extentlock=0,sc=""
	If concurrency { If '$tlevel { Kill %0CacheLock } If $increment(%0CacheLock($classname()))>$zu(115,6) { Lock +(^BSTS.SOAP.WebFunctionsD):$zu(115,4) Set extentlock=$test Lock:extentlock -(^BSTS.SOAP.WebFunctionsD) } If 'extentlock { Lock +(^BSTS.SOAP.WebFunctionsD(id)):$zu(115,4) } If '$test { QUIT $$Error^%apiOBJ(5803,$classname()) }}
	If ($Data(^BSTS.SOAP.WebFunctionsD(id))) {
		If $data(^oddEXTR($classname())) {
			n %fc,%fk,%z
			Set %fc="" For  Set %fc=$order(^oddEXTR($classname(),"n","IDKEY","f",%fc)) Quit:%fc=""  Set %fk="" For  Set %fk=$order(^oddEXTR($classname(),"n","IDKEY","f",%fc,%fk)) Quit:%fk=""  Set %z=$get(^oddEXTR($classname(),"n","IDKEY","f",%fc,%fk,61)) If %z'="" Set sc=$classmethod(%fc,%fk_"Delete",id) If ('sc) Goto DeleteDataEXIT
		}
		Kill ^BSTS.SOAP.WebFunctionsD(id)
		Set sc=1
	}
	else { set sc=$$Error^%apiOBJ(5810,$classname(),id) }
DeleteDataEXIT
	If (concurrency) && ('extentlock) { Lock -(^BSTS.SOAP.WebFunctionsD(id)) }
DeleteDataRET	Set $Ztrap = ""
	QUIT sc
DeleteDataERR	Set $Ztrap = "DeleteDataRET"
	Set sc = $$Error^%apiOBJ(5002,$ZE)
	Goto DeleteDataEXIT }
%Exists(oid="") public {
	Quit ..%ExistsId($listget(oid)) }
%ExistsId(id) public {
	try { set tExists = $s(id="":0,$d(^BSTS.SOAP.WebFunctionsD(id)):1,1:0) } catch tException { set tExists = 0 } quit tExists }
%InsertBatch(objects,concurrency=0,useTransactions=0) public {
	s $ZTrap="InsertBatchERR"
	s numerrs=0,errs="",cnt=0,ptr=0
	while $listnext(objects,ptr,data) {
		s cnt=cnt+1,sc=1
		do
 {
			if (useTransactions) tstart
			s id=$i(^BSTS.SOAP.WebFunctionsD)
			Set lock=0,locku=""
			If '$Tlevel { Kill %0CacheLock }
			i concurrency { If $i(%0CacheLock($classname()))>$zu(115,6) { Lock +(^BSTS.SOAP.WebFunctionsD):$zu(115,4) Set lock=$Select($test:2,1:0) Lock:lock -(^BSTS.SOAP.WebFunctionsD) } Else { Lock +(^BSTS.SOAP.WebFunctionsD(id)):$zu(115,4) Set lock=$Select($test:1,1:0) } If 'lock { Set sc=$$Error^%apiOBJ(5803,$classname()) Quit } }
			s ^BSTS.SOAP.WebFunctionsD(id)=data
		}
		while 0
		If lock=1 Lock -(^BSTS.SOAP.WebFunctionsD(id))
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
	Kill ^BSTS.SOAP.WebFunctionsD
	Quit 1
%LoadData(id)
	New sc
	Set sc=""
	If ..%Concurrency=4 Lock +(^BSTS.SOAP.WebFunctionsD(id)):$zu(115,4) If '$test QUIT $$Error^%apiOBJ(5803,$classname())
	If ..%Concurrency'=4,..%Concurrency>1 Lock +(^BSTS.SOAP.WebFunctionsD(id)#"S"):$zu(115,4) If '$test QUIT $$Error^%apiOBJ(5804,$classname())
	i '$d(^BSTS.SOAP.WebFunctionsD(id)) 
	Else  Do
	. New %s1
	. Set sc=1
	. s %s1=$g(^BSTS.SOAP.WebFunctionsD(id))
	If ..%Concurrency=2 Lock -(^BSTS.SOAP.WebFunctionsD(id)#"SI")
	Quit $select(sc'="":sc,1:$$Error^%apiOBJ(5809,$classname(),id))
%LoadDataFromMemory(id,objstate,obj)
	New sc
	Set sc=""
	i '$d(objstate(id)) 
	Else  Do
	. New %s1
	. Set sc=1
	. s %s1=$g(objstate(id))
	Set sc = $select(sc'="":sc,1:$$Error^%apiOBJ(5809,$classname(),id))
	 Quit sc
%LockExtent(shared=0) public {
	if shared { l +(^BSTS.SOAP.WebFunctionsD#"S"):$zu(115,4) if $t { q 1 } else { q $$Error^%apiOBJ(5799,$classname()) }} l +(^BSTS.SOAP.WebFunctionsD):$zu(115,4) if $t { q 1 } else { q $$Error^%apiOBJ(5798,$classname()) }
}
%LockId(id,shared=0) public {
	if id'="" { set sc=1 } else { set sc=$$Error^%apiOBJ(5812) quit sc }
	if 'shared { Lock +(^BSTS.SOAP.WebFunctionsD(id)):$zu(115,4) i $test { q 1 } else { q $$Error^%apiOBJ(5803,$classname()) } }
	else { Lock +(^BSTS.SOAP.WebFunctionsD(id)#"S"):$zu(115,4) if $test { q 1 } else { q $$Error^%apiOBJ(5804,$classname()) } }
}
%OnDetermineClass(oid,class)
	New id,idclass
	Set id=$listget($get(oid)) QUIT:id="" $$Error^%apiOBJ(5812)
	Set idclass=$lg($get(^BSTS.SOAP.WebFunctionsD(id)),1)
	If idclass="" Set class="BSTS.SOAP.WebFunctions" Quit 1
	Set class=$piece(idclass,$extract(idclass),$length(idclass,$extract(idclass))-1)
	Set:class'["." class="User."_class
	QUIT 1
%PhysicalAddress(id,paddr)
	if $Get(id)="" Quit $$Error^%apiOBJ(5813,$classname())
	if (id="") { quit $$Error^%apiOBJ(5832,$classname(),id) }
	s paddr(1)=$lb($Name(^BSTS.SOAP.WebFunctionsD(id)),$classname(),"IDKEY","listnode",id)
	s paddr=1
	Quit 1
%PurgeIndices(idxlist="",lockExtent=0)
	if $ll(idxlist) { quit $$Error^%apiOBJ(5066,$classname()_"::"_$ListToString(idxlist)) } QUIT 1
	Quit
%SQLAcquireLock(%rowid,s=0,unlockref)
	new %d,gotlock set %d(1)=%rowid set s=$e("S",s) lock +^BSTS.SOAP.WebFunctionsD(%d(1))#s:$zu(115,4) set gotlock=$t set:gotlock&&$g(unlockref) unlockref($i(unlockref))=$lb($name(^BSTS.SOAP.WebFunctionsD(%d(1))),"BSTS.SOAP.WebFunctions") QUIT gotlock
	Quit
%SQLAcquireTableLock(s=0,SQLCODE,to="")
	set s=$e("S",s) set:to="" to=$zu(115,4) lock +^BSTS.SOAP.WebFunctionsD#s:to QUIT:$t 1 set SQLCODE=-110 if s="S" { set %msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler35",,"BSTS_SOAP"_"."_"WebFunctions") } else { set %msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler36",,"BSTS_SOAP"_"."_"WebFunctions") } QUIT 0
	Quit
%SQLBuildIndices(pIndices="")
	QUIT ..%BuildIndices(pIndices)
%SQLCopyIcolIntoName()
	if %oper="DELETE" {
		set:$d(%d(1)) %f("ID")=%d(1)
		QUIT
	}
	set:$d(%d(1)) %f("ID")=%d(1) set:$a(%e,2)&&$d(%d(2)) %f("x__classname")=%d(2)
	QUIT
%SQLDefineiDjVars(%d,subs)
	QUIT
%SQLDelete(%rowid,%check,%tstart=1,%mv=0,%polymorphic=0)
	new bva,ce,%d,dc,%e,%ele,%itm,%key,%l,%nc,omcall,%oper,%pos,%s,sn,sqlcode,subs set %oper="DELETE",sqlcode=0,%ROWID=%rowid,%d(1)=%rowid,%e(1)=%rowid,%l=$c(0)
	if '$d(%0CacheSQLRA) new %0CacheSQLRA set omcall=1
	k:'$TLEVEL %0CacheLock if '$a(%check,2) { new %ls if $i(%0CacheLock("BSTS.SOAP.WebFunctions"))>$zu(115,6) { lock +^BSTS.SOAP.WebFunctionsD:$zu(115,4) lock:$t -^BSTS.SOAP.WebFunctionsD set %ls=$s($t:2,1:0) } else { lock +^BSTS.SOAP.WebFunctionsD(%d(1)):$zu(115,4) set %ls=$t } set:%ls=2 $e(%check,2)=$c(1) set:%ls=1 $e(%l)=$c(1) if '%ls set SQLCODE=-110,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler40",,%oper,"BSTS_SOAP"_"."_"WebFunctions",$g(%d(1))) QUIT  } if %tstart { TSTART:($zu(115,1)=1)||('$TLEVEL&&($zu(115,1)=2))  } set $zt="ERRORDelete"
	do ..%SQLGetOld() if sqlcode set SQLCODE=-106 do ..%SQLEExit() QUIT  
	if %e(2)'="" set sn=$p(%e(2),$e(%e(2)),$l(%e(2),$e(%e(2)))-1) if "BSTS.SOAP.WebFunctions"'=sn new %f do ..%SQLCopyIcolIntoName() do $classmethod(sn,"%SQLDelete",%rowid,%check,%tstart,%mv,1) QUIT  
	if '$a(%check),'$zu(115,7) do  if sqlcode set SQLCODE=sqlcode do ..%SQLEExit() QUIT  
	. new %fk,%k,%p,%st,%t,%z set %k="",%p("%1")="%d(1),",%p("IDKEY")="%d(1),"
	. for  quit:sqlcode<0  set %k=$o(^oddEXTR("BSTS.SOAP.WebFunctions","n",%k)) quit:%k=""  set %t="" for  set %t=$o(^oddEXTR("BSTS.SOAP.WebFunctions","n",%k,"f",%t)) quit:%t=""  set %st=(%t="BSTS.SOAP.WebFunctions") set %fk="" for  set %fk=$order(^oddEXTR("BSTS.SOAP.WebFunctions","n",%k,"f",%t,%fk)) quit:%fk=""  x "set %z=$classmethod(%t,%fk_""SQLFKeyRefAction"",%st,%k,"_%p(%k)_")" if %z set sqlcode=-124 quit  
	set ce="" for  { set ce=$order(^oddSQL("BSTS_SOAP","WebFunctions","DC",ce)) quit:ce=""   do $classmethod(ce,"%SQLDeleteChildren",%d(1),%check,.sqlcode) quit:sqlcode<0  } if sqlcode<0 { set SQLCODE=sqlcode do ..%SQLEExit() QUIT } // Delete any children
	k ^BSTS.SOAP.WebFunctionsD(%d(1))
	do ..%SQLUnlock() TCOMMIT:%tstart&&($zu(115,1)=1)
	set SQLCODE=0 kill:$g(omcall) %0CacheSQLRA QUIT
ERRORDelete	set $zt="",SQLCODE=-415,%msg=$s($g(%msg)'="":%msg_" -- ",1:"")_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler51",,%oper,"BSTS_SOAP"_"."_"WebFunctions",$ze) if $ze["<FRAMESTACK>" { set %msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler52",,$ze,%oper,"BSTS_SOAP"_"."_"WebFunctions") do ##Class(%SYS.System).WriteToConsoleLog(%msg) if ($zu(67,10,$j)=1)||($zu(67,10,$j)=3) { write !,%msg h 3 } HALT  } do ..%SQLEExit() QUIT
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
	if '..%SQLGetLock(id,1,.pUnlockRef) { set sqlcode=-114,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler39",,"BSTS_SOAP"_"."_"WebFunctions"_":"_"%1") QUIT 0 }
	if 'pLockOnly { new qv set qv=$d(^BSTS.SOAP.WebFunctionsD(%pVal(1))) do:'$g(pUnlockRef) ..%SQLReleaseLock(id,1) quit qv } else { do:'$g(pUnlockRef) ..%SQLReleaseLock(id,1) QUIT 1 }
	Quit
%SQLGetLock(pRowId,pShared=0,pUnlockRef)
	kill:'$TLEVEL %0CacheLock
	if $i(%0CacheLock("BSTS.SOAP.WebFunctions"))>$zu(115,6) { lock +^BSTS.SOAP.WebFunctionsD:$zu(115,4) lock:$t -^BSTS.SOAP.WebFunctionsD QUIT $s($t:2,1:0) } 
	QUIT ..%SQLAcquireLock(pRowId,pShared,.pUnlockRef)
%SQLGetOld()
	new s if '$d(^BSTS.SOAP.WebFunctionsD(%d(1)),s) { set sqlcode=100 quit  } set %e(2)=$lg(s)
	QUIT
%SQLGetOldAll()
	new s if '$d(^BSTS.SOAP.WebFunctionsD(%d(1)),s) { set sqlcode=100 quit  } set %e(2)=$lg(s)
	QUIT
%SQLInsert(%d,%check,%inssel,%vco,%tstart=1,%mv=0)
	new bva,%ele,%itm,%key,%l,%n,%nc,%oper,%pos,%s,sqlcode,sn,subs,icol set %oper="INSERT",sqlcode=0,%l=$c(0,0,0)
	if $d(%d(1)),'$zu(115,11) { if %d(1)'="" { set SQLCODE=-111,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler6",,"ID","BSTS_SOAP"_"."_"WebFunctions") QUIT ""  } kill %d(1) } 
	do ..%SQLNormalizeFields()
	kill:'$TLEVEL %0CacheLock if %tstart { TSTART:($zu(115,1)=1)||('$TLEVEL&&($zu(115,1)=2))  } set $zt="ERRORInsert"
	if '$a(%check) do  if sqlcode<0 set SQLCODE=sqlcode do ..%SQLEExit() QUIT ""
	. if $g(%vco)'="" d @%vco quit:sqlcode<0
	if '$d(%d(1)) { set %d(1)=$i(^BSTS.SOAP.WebFunctionsD) } elseif %d(1)>$g(^BSTS.SOAP.WebFunctionsD) { if $i(^BSTS.SOAP.WebFunctionsD,$zabs(%d(1)-$g(^BSTS.SOAP.WebFunctionsD))) {}} elseif $d(^BSTS.SOAP.WebFunctionsD(%d(1))) { set SQLCODE=-119,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler33",,"ID",%d(1),"BSTS_SOAP"_"."_"WebFunctions"_"."_"ID") do ..%SQLEExit() QUIT "" }
	for icol=2 set:'$d(%d(icol)) %d(icol)=""
	if '$a(%check,2) { new %ls if $i(%0CacheLock("BSTS.SOAP.WebFunctions"))>$zu(115,6) { lock +^BSTS.SOAP.WebFunctionsD:$zu(115,4) lock:$t -^BSTS.SOAP.WebFunctionsD set %ls=$s($t:2,1:0) } else { lock +^BSTS.SOAP.WebFunctionsD(%d(1)):$zu(115,4) set %ls=$t } set:%ls=2 $e(%check,2)=$c(1) set:%ls=1 $e(%l)=$c(1) if '%ls set SQLCODE=-110,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler40",,%oper,"BSTS_SOAP"_"."_"WebFunctions",$g(%d(1))) do ..%SQLEExit() QUIT ""  }
	set ^BSTS.SOAP.WebFunctionsD(%d(1))=$lb(%d(2))
	lock:$a(%l) -^BSTS.SOAP.WebFunctionsD(%d(1))
	TCOMMIT:%tstart&&($zu(115,1)=1)
	set SQLCODE=0 QUIT %d(1) 			// %SQLInsert
ERRORInsert	set $zt="",SQLCODE=-415,%msg=$s($g(%msg)'="":%msg_" -- ",1:"")_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler51",,%oper,"BSTS_SOAP"_"."_"WebFunctions",$ze) if $ze["<FRAMESTACK>" { set %msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler52",,$ze,%oper,"BSTS_SOAP"_"."_"WebFunctions") do ##Class(%SYS.System).WriteToConsoleLog(%msg) if ($zu(67,10,$j)=1)||($zu(67,10,$j)=3) { write !,%msg h 3 } HALT  } do ..%SQLEExit() QUIT ""
	Quit
%SQLMissing(fname)
	set sqlcode=-108,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler47",,fname,"BSTS_SOAP"_"."_"WebFunctions") quit
%SQLNormalizeFields()
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
	set x=$zobjexport(-1,18),%qrc=400,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler44",,"BSTS_SOAP"_"."_"WebFunctions") QUIT
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
	if %nolock=0 { if '..%SQLAcquireLock(%rowid) { set %qrc=114,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler45",,"BSTS_SOAP"_"."_"WebFunctions",%rowid),%ROWCOUNT=0 QUIT  } set:$zu(115,2) il=$zu(115,2,0) }
	new s,ul set ul=0,d(1)=%rowid if $zu(115,2)=1 { lock +^BSTS.SOAP.WebFunctionsD(d(1))#"S":$zu(115,4) if $t { set ul=1 } else { set %qrc=114,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler46",,"BSTS_SOAP"_"."_"WebFunctions",%rowid),%ROWCOUNT=0 quit  } }
	if '$d(^BSTS.SOAP.WebFunctionsD(d(1)),s) { set SQLCODE=100,%qrc=100 if %nolock=0 { do:$g(il) $zu(115,2,il) }} else { set SQLCODE=0
	if qq { set d(2)=$lg(s) if d(2)'="" { new sn set sn=$p(d(2),$e(d(2)),$l(d(2),$e(d(2)))-1) if "BSTS.SOAP.WebFunctions"'=sn { if %nolock=0 { do ..%SQLReleaseLock(%rowid,0,1) do:$g(il) $zu(115,2,il) } kill d set:sn'["." sn="User."_sn do $classmethod(sn,"%SQLQuickLoad",%rowid,%nolock,0,1) QUIT  }}}
	set d(2)=$lg(s)  }
	do ..%SQLQuickLogicalToOdbc(.d)
	if SQLCODE set %ROWCOUNT=0 set:SQLCODE<0 SQLCODE=-SQLCODE lock:ul -^BSTS.SOAP.WebFunctionsD(d(1))#"SI" set %qrc=SQLCODE QUIT
	set:qq d=$zobjexport("BSTS.SOAP.WebFunctions",18),d=$zobjexport(2,18) set i=-1 for  { set i=$o(d(i)) quit:i=""  set d=$zobjexport(d(i),18) } set %qrc=0,%ROWCOUNT=1 lock:ul -^BSTS.SOAP.WebFunctionsD(d(1))#"SI" if %nolock=0 { do ..%SQLReleaseLock(%rowid,0,0) do:$g(il) $zu(115,2,il) } QUIT
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
	new %d set %d(1)=%rowid set s=$e("S",s)_$e("I",i) lock -^BSTS.SOAP.WebFunctionsD(%d(1))#s set:i&&($g(%0CacheLock("BSTS.SOAP.WebFunctions"))) %0CacheLock("BSTS.SOAP.WebFunctions")=%0CacheLock("BSTS.SOAP.WebFunctions")-1 QUIT
%SQLReleaseTableLock(s=0,i=0)
	set s=$e("S",s)_$e("I",i) lock -^BSTS.SOAP.WebFunctionsD#s QUIT 1
	Quit
%SQLUnlock()
	lock:$a(%l) -^BSTS.SOAP.WebFunctionsD(%d(1))
	QUIT
%SQLUnlockError(cname)
	set sqlcode=-110 if %oper="DELETE" { set %msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler48",,"BSTS_SOAP"_"."_"WebFunctions",cname) } else { set %msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler49",,"BSTS_SOAP"_"."_"WebFunctions",cname) } quit
	Quit
%SQLUpdate(%rowid,%check,%d,%vco,%tstart=1,%mv=0,%polymorphic=0)
	new %e,bva,%ele,%itm,%key,%l,%n,%nc,%oper,%pos,%s,icol,s,sn,sqlcode,subs,t set %oper="UPDATE",sqlcode=0,%ROWID=%rowid,$e(%e,1)=$c(0),%l=$c(0,0,0) do ..%SQLNormalizeFields() if $d(%d(1)),%d(1)'=%rowid set SQLCODE=-107,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler16",,"ID","BSTS_SOAP"_"."_"WebFunctions") QUIT
	for icol=2:1:2 set $e(%e,icol)=$c($d(%d(icol)))
	set %d(1)=%rowid,%e(1)=%rowid
	k:'$TLEVEL %0CacheLock if '$a(%check,2) { new %ls if $i(%0CacheLock("BSTS.SOAP.WebFunctions"))>$zu(115,6) { lock +^BSTS.SOAP.WebFunctionsD:$zu(115,4) lock:$t -^BSTS.SOAP.WebFunctionsD set %ls=$s($t:2,1:0) } else { lock +^BSTS.SOAP.WebFunctionsD(%d(1)):$zu(115,4) set %ls=$t } set:%ls=2 $e(%check,2)=$c(1) set:%ls=1 $e(%l)=$c(1) if '%ls set SQLCODE=-110,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler40",,%oper,"BSTS_SOAP"_"."_"WebFunctions",$g(%d(1))) QUIT  } if %tstart { TSTART:($zu(115,1)=1)||('$TLEVEL&&($zu(115,1)=2))  } set $zt="ERRORUpdate"
	if $g(%vco)="" { do ..%SQLGetOld() i sqlcode { s SQLCODE=-109 do ..%SQLEExit() QUIT  } set:'$d(%d(2)) %d(2)=%e(2) set:%d(2)=%e(2) $e(%e,2)=$c(0) } else { do ..%SQLGetOldAll() if sqlcode { set SQLCODE=-109 do ..%SQLEExit() QUIT  } set:'$d(%d(2)) %d(2)=%e(2) set:%d(2)=%e(2) $e(%e,2)=$c(0)}
	if %e(2)'="" set sn=$p(%e(2),$e(%e(2)),$l(%e(2),$e(%e(2)))-1) if "BSTS.SOAP.WebFunctions"'=sn new %f do ..%SQLCopyIcolIntoName() do $classmethod(sn,"%SQLUpdate",%rowid,%check,.%d,$g(%vco),%tstart,%mv,1) QUIT
	do:'$a(%check)  if sqlcode set SQLCODE=sqlcode do ..%SQLEExit() QUIT
	. if $g(%vco)'="" d @%vco quit:sqlcode<0
	if '$a(%check,3) { 
	}
	set:$a(%e,2) ^BSTS.SOAP.WebFunctionsD(%d(1))=$lb(%d(2))
	if '$a(%check,3) { 
	}
	do ..%SQLUnlock() TCOMMIT:%tstart&&($zu(115,1)=1)
	set SQLCODE=0
	QUIT
ERRORUpdate	set $zt="",SQLCODE=-415,%msg=$s($g(%msg)'="":%msg_" -- ",1:"")_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler51",,%oper,"BSTS_SOAP"_"."_"WebFunctions",$ze) if $ze["<FRAMESTACK>" { set %msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler52",,$ze,%oper,"BSTS_SOAP"_"."_"WebFunctions") do ##Class(%SYS.System).WriteToConsoleLog(%msg) if ($zu(67,10,$j)=1)||($zu(67,10,$j)=3) { write !,%msg h 3 } HALT  } do ..%SQLEExit() QUIT  
	Quit
%SQLValidateFields(sqlcode)
	QUIT 'sqlcode
%SQLnBuild() public {
	set %n=$lb(,"ID","x__classname")
	QUIT }
%SaveData(id) public {
	Set $ZTrap="SaveDataERR" Set sc=1,id=$listget(i%"%%OID") If id'="" { Set insert=0,idassigned=1 } Else { Set insert=1,idassigned=0 }
	Set lock=0,lockok=0,tSharedLock=0,locku=""
	if 'idassigned { set id=$i(^BSTS.SOAP.WebFunctionsD) Set $zobjoid("BSTS.SOAP.WebFunctions",id)=$this,.."%%OID"=$lb(id_"","BSTS.SOAP.WebFunctions") set:$g(%objtxSTATUS)=2 %objtxOIDASSIGNED(+$this)="" }
	If 'insert && ('$Data(^BSTS.SOAP.WebFunctionsD(id))) { Set insert=1 }
	If '$Tlevel { Kill %0CacheLock }
	If insert  {
		if (..%Concurrency&&$tlevel)||(..%Concurrency=4) { If (..%Concurrency < 4)&&($i(%0CacheLock($classname()))>$zu(115,6)) { Lock +(^BSTS.SOAP.WebFunctionsD):$zu(115,4) Set lockok=$Select($test:2,1:0) Lock:lockok -(^BSTS.SOAP.WebFunctionsD) } Else { Lock +(^BSTS.SOAP.WebFunctionsD(id)):$zu(115,4) Set lockok=$Select($test:1,1:0) Set:..%Concurrency'=4 lock=lockok } If 'lockok { Set sc=$$Error^%apiOBJ(5803,$classname()) Goto SaveDataEXIT } }
		if ..%Concurrency=3 { Lock +(^BSTS.SOAP.WebFunctionsD(id)#"S") set tSharedLock=1 }
		s ^BSTS.SOAP.WebFunctionsD(id)=$lb("")
	}
	Else  {
		If (..%Concurrency<4)&&(..%Concurrency) { If $i(%0CacheLock($classname()))>$zu(115,6) { Lock +(^BSTS.SOAP.WebFunctionsD):$zu(115,4) Set lockok=$s($test:2,1:0) Lock:lockok -(^BSTS.SOAP.WebFunctionsD) } Else { Lock +(^BSTS.SOAP.WebFunctionsD(id)):$zu(115,4) Set lockok=$Select($test:1,1:0),lock=lockok } If 'lockok { Set sc=$$Error^%apiOBJ(5803,$classname()) Goto SaveDataEXIT } }
		s ^BSTS.SOAP.WebFunctionsD(id)=$lb("")
	}
SaveDataEXIT
	if (('sc)) && ('idassigned) { Set $zobjoid("",$listget(i%"%%OID"))="" Set $this."%%OID" = "" kill:$g(%objtxSTATUS)=2 %objtxOIDASSIGNED(+$this) }
	If lock Lock -(^BSTS.SOAP.WebFunctionsD(id))
	If (('sc)) { if (tSharedLock) {  Lock -(^BSTS.SOAP.WebFunctionsD(id)#"S") } elseif (lockok=1)&&(insert)&&(..%Concurrency=4) {  Lock -(^BSTS.SOAP.WebFunctionsD(id)) } }
SaveDataRET	Set $Ztrap = ""
	QUIT sc
SaveDataERR	Set $Ztrap = "SaveDataRET"
	Set sc = $$Error^%apiOBJ(5002,$ZE)
	Goto SaveDataEXIT }
%SaveDirect(id="",idList="",data,concurrency=-1) public {
	Set $ZTrap="SaveDirectERR" set sc=1
	if concurrency=-1 { Set concurrency=$zu(115,10) }
	if id="" { s id=$i(^BSTS.SOAP.WebFunctionsD), insert=1 } else { s insert=0 }
	Set lock=0
	If '$Tlevel { Kill %0CacheLock }
	i (insert)&&(concurrency) { If $i(%0CacheLock($classname()))>$zu(115,6) { Lock +(^BSTS.SOAP.WebFunctionsD):$zu(115,4) Set lock=$Select($test:2,1:0) Lock:lock -(^BSTS.SOAP.WebFunctionsD) } Else { Lock +(^BSTS.SOAP.WebFunctionsD(id)):$zu(115,4) Set lock=$Select($test:1,1:0) } If 'lock { Set sc=$$Error^%apiOBJ(5803,$classname()) Goto SaveDirectEXIT } }
	s ^BSTS.SOAP.WebFunctionsD(id)=data
SaveDirectEXIT
	If lock=1 Lock -(^BSTS.SOAP.WebFunctionsD(id))
SaveDirectRET	Set $Ztrap = ""
	QUIT sc
SaveDirectERR	Set $Ztrap = "SaveDirectRET"
	Set sc = $$Error^%apiOBJ(5002,$ZE)
	Goto SaveDirectEXIT }
%SortBegin(idxlist="",excludeunique=0)
	if $ll(idxlist) { quit $$Error^%apiOBJ(5066,$classname()_"::"_$ListToString(idxlist)) } QUIT 1
	Quit
%SortEnd(idxlist="",commit=1)
	if $ll(idxlist) { quit $$Error^%apiOBJ(5066,$classname()_"::"_$ListToString(idxlist)) } QUIT 1
	Quit
%UnlockExtent(shared=0,immediate=0) public {
	if ('immediate)&&('shared) { l -^BSTS.SOAP.WebFunctionsD q 1 } elseif (immediate)&&('shared) { l -^BSTS.SOAP.WebFunctionsD#"I" q 1 } elseif ('immediate)&&(shared) { l -^BSTS.SOAP.WebFunctionsD#"S" q 1 } else { l -^BSTS.SOAP.WebFunctionsD#"SI" q 1 }
}
%UnlockId(id,shared=0,immediate=0) public {
	if ('immediate)&&('shared) { Lock -(^BSTS.SOAP.WebFunctionsD(id)) q 1 } elseif (immediate)&&('shared) { Lock -(^BSTS.SOAP.WebFunctionsD(id)#"I") q 1 } elseif ('immediate)&&(shared) { Lock -(^BSTS.SOAP.WebFunctionsD(id)#"S") q 1 } else { Lock -(^BSTS.SOAP.WebFunctionsD(id)#"SI") q 1 }
}
zFindConcById(pParams="",pResult) public {
	// Data needed passed by BSTSWS array required for call
	Set tDebug=$Get(pParams("DEBUG"))
	Set tURLRoot=$Get(pParams("URLROOT"))
	Set tServiceURLPath=$Get(pParams("SERVICEPATH"))
	Set tServicePort=$Get(pParams("PORT"))
	Set tWebServiceTimeout=$Get(pParams("TIMEOUT"))
	Set tUserName=$Get(pParams("USER"))
	Set tPassword=$Get(pParams("PASS"))
	Set tSSLConfiguration=$Get(pParams("SSL"))
	Set tNamespaceID=$Get(pParams("NAMESPACEID"))
	Set tConceptID=$Get(pParams("CONCEPTID"))
	Set tDefaultLimit=+$Get(pParams("DEFAULTLIMIT"))
	Set tConnectionTimeout=$Get(pParams("CTIME"))
	//Get location
	//BEE;BSTS*1.0*2;Changed location logic
	//Set tLocation=tURLRoot_":"_tServicePort_tServiceURLPath_"/DtsQueryDaoService/DtsQueryDaoWS"
	Set tLocation=tURLRoot_":"_tServicePort_tServiceURLPath_"/DtsQueryDaoWS"
	Set tStatus=0
	Set tConceptAttributeSet=##class(BSTS.ns1.TConceptAttributeSetDescriptor).%New()
	Set tConceptAttributeSet.DEFAULTLIMIT=tDefaultLimit
	// Loop through and drill down the propertyType values to create individual instances of BSTS.ns1.TPropertyType
	// and add to the tConceptAttributeSet
	Set tSC=##class(BSTS.ns1.TOntylogConcept).%New()
	// Initialize new web client to make the SOAP call
	Set tWebClient=##class(BSTS.DtsQueryDaoPort).%New()
	Set tWebClient.Location=tLocation
	Set tWebClient.HttpUsername=tUserName
	Set tWebClient.HttpPassword=tPassword
	Set tWebClient.Timeout=tWebServiceTimeout
	Set tWebClient.OpenTimeout=tConnectionTimeout
	If ((tLocation["https://")&(tSSLConfiguration]"")) {	
		Set tWebClient.SSLConfiguration=tSSLConfiguration
    	Set tWebClient.HttpProxySSLConnect=0
	}
	Set tStartTime=$now()
	try {
		Set tSC=tWebClient.findConceptById(tConceptID,tNamespaceID,tConceptAttributeSet)
		If (tDebug) {
			// Write tWebClient.HttpResult,!
			Do $System.OBJ.Dump(tWebClient)
			If $ISOBJECT(tWebClient.HttpResponse) {
				Set tHTTPResponse=##class(%Net.HttpResponse).%New()
				Set tHTTPResponse=tWebClient.HttpResponse
				Set pResult("DEBUG","HTTP_RESPONSE_DATA")=tHTTPResponse.Data
				Set pResult("DEBUG","HTTP_REASON_PHRASE")=tHTTPResponse.ReasonPhrase
				Set pResult("DEBUG","HTTP_HEADERS_DATE")=$Get(tHTTPResponse.Headers("DATE"))
			}
		}
		If (tDebug) {
				Do $SYSTEM.OBJ.Dump(tSC)
		}
		Set pResult="1^^"_..GetElapsedTime(tStartTime,$now())
		Set tStatus=pResult
	}
	Catch Exception
	{
		Set tError=""
		Set tErrorText=""
		If ($ZERROR["<ZSOAP>") {
			Set pResult("ERROR","SOAPFAULT","CODE")=tWebClient.SoapFault.faultcode
			Set pResult("ERROR","SOAPFAULT","FAULTSTRING")=tWebClient.SoapFault.faultstring
			Set tError=$System.Status.DecomposeStatus(%objlasterror,.tError)
			Set pResult("ERROR","SOAPFAULT","ERRORSTRING")=$Get(tError(1))
			Set tErrorText=$Get(tError(1))
		} else {
			Set tErrorText=$$Error^%apiOBJ(5002,$ZERROR)
			Set pResult("ERROR","ERRORSTRING")=tErrorText
		}
		If $ISOBJECT(tWebClient.HttpResponse) {
			Set tHTTPResponse=##class(%Net.HttpResponse).%New()
			Set tHTTPResponse=tWebClient.HttpResponse
			Set pResult("ERROR","HTTP_RESPONSE_DATA")=tHTTPResponse.Data
			Set pResult("ERROR","HTTP_REASON_PHRASE")=tHTTPResponse.ReasonPhrase
			Set pResult("ERROR","HTTP_HEADERS_DATE")=$Get(tHTTPResponse.Headers("DATE"))
		}
		Set pResult="0^"_tErrorText_$get(pResult("ERROR","HTTP_REASON_PHRASE"))_"^"_..GetElapsedTime(tStartTime,$now())	
		Set tStatus=pResult
	}
	Quit tStatus }
zFindConceptsWithNameMatching(pParams="",pResult) public {
	// Data needed passed by BSTSWS array required for call
	Set tDebug=$Get(pParams("DEBUG"))
	Set tWebServiceTimeout=$Get(pParams("TIMEOUT"))
	Set tUserName=$Get(pParams("USER"))
	Set tPassword=$Get(pParams("PASS"))
	Set tSSLConfiguration=$Get(pParams("SSL"))
	Set tNamespaceID=$Get(pParams("NAMESPACEID"))
	Set tSearchPattern=$Get(pParams("SEARCH"))
	Set tSnapshotDate=$Get(pParams("SNAPDT"))
	Set tMaxResults=$Get(pParams("MAXRECS")) S tMaxResults=100
	//Get location
	//BEE;BSTS*1.0*2;Changed location logic
	//Set tLocation=$Get(pParams("URLROOT"))_":"_$Get(pParams("PORT"))_$Get(pParams("SERVICEPATH"))_"/DtsQueryDaoService/DtsQueryDaoWS"
	Set tLocation=$Get(pParams("URLROOT"))_":"_$Get(pParams("PORT"))_$Get(pParams("SERVICEPATH"))_"/DtsQueryDaoWS"
	Set tConnectionTimeout=$Get(pParams("CTIME"))
	Set tStatus=0
	Set pResult=1
	// Setup request for search options and attribute set descriptors for initial call
	Set tSearchOptions=##class(BSTS.ns1.TConceptSearchOptions).%New()
	Set tAttributeSetDesc=##class(BSTS.ns1.TConceptAttributeSetDescriptor).%New()
	Set tSearchOptions.snapshotDate=tSnapshotDate	
	Set tAttributeSetDesc.DEFAULTLIMIT=0
	Set tAttributeSetDesc.allPropertyTypes="false"
	Set tAttributeSetDesc.allConceptAssociationTypes="false"
	Set tAttributeSetDesc.allSynonymTypes="false"
	Set tAttributeSetDesc.allInverseRoleTypes="false"
	Set tAttributeSetDesc.allRoleTypes="false"
	Set tAttributeSetDesc.attributesLimit="1000"
	Set tAttributeSetDesc.definedViewAttributes="false"
	Set tAttributeSetDesc.queryHasSubs="0"
	Set tAttributeSetDesc.queryHasSups="0"
	Set tAttributeSetDesc.subconcepts="0"
	Set tAttributeSetDesc.superconcepts="false"
	Set tSearchOptions.attributeSetDescriptor=tAttributeSetDesc
	Set tSearchOptions.firstResult="0"
	Set tSearchOptions.limit=tMaxResults
	Set tSearchOptions.namespaceId=tNamespaceID
	Set tSearchOptions.status="A"
	// Initialize new web client to make the SOAP call
	Set tWebClient=##class(BSTS.DtsQueryDaoPort).%New()
	Set tWebClient.Location=tLocation
	Set tWebClient.HttpUsername=tUserName
	Set tWebClient.HttpPassword=tPassword
	Set tWebClient.Timeout=tWebServiceTimeout
	Set tWebClient.OpenTimeout=tConnectionTimeout
	If ((tLocation["https://")&(tSSLConfiguration]"")) {	
		Set tWebClient.SSLConfiguration=tSSLConfiguration
    	Set tWebClient.HttpProxySSLConnect=0
	}
	Set tStartTime=$now()
	// Setup response
	Set tSC=##class(%Library.ListOfObjects).%New()
	try {
		Set tSC=tWebClient.findConceptsWithNameMatching(tSearchPattern,tSearchOptions)
		If (tDebug) {
			Do $System.OBJ.Dump(tWebClient)
			If $ISOBJECT(tWebClient.HttpResponse) {
				Set tHTTPResponse=##class(%Net.HttpResponse).%New()
				Set tHTTPResponse=tWebClient.HttpResponse
				Set pResult("DEBUG","HTTP_RESPONSE_DATA")=tHTTPResponse.Data
				Set pResult("DEBUG","HTTP_REASON_PHRASE")=tHTTPResponse.ReasonPhrase
				Set pResult("DEBUG","HTTP_HEADERS_DATE")=$Get(tHTTPResponse.Headers("DATE"))
			}
			Set tHttpHeadersOut=##class(%Library.ArrayOfObjects).%New()
			Set tHttpHeadersOut=tWebClient.HeadersOut
			For key=1:1:tHttpHeadersOut.Count() {
			}
		}
	}
	Catch Exception
	{
		Set tError=""
		Set tErrorText=""
		If ($ZERROR["<ZSOAP>") {
			Set pResult("ERROR","SOAPFAULT","findConceptsWithNameMatching","CODE")=tWebClient.SoapFault.faultcode
			Set pResult("ERROR","SOAPFAULT","findConceptsWithNameMatching","FAULTSTRING")=tWebClient.SoapFault.faultstring
			Set tError=$System.Status.DecomposeStatus(%objlasterror,.tError)
			Set pResult("ERROR","SOAPFAULT","findConceptsWithNameMatching","ERRORSTRING")=$Get(tError(1))
			Set tErrorText=$Get(tError(1))
		} else {
			Set tErrorText=$$Error^%apiOBJ(5002,$ZERROR)
			Set pResult("ERROR","ERRORSTRING")=tErrorText
		}
		If $ISOBJECT(tWebClient.HttpResponse) {
			Set tHTTPResponse=##class(%Net.HttpResponse).%New()
			Set tHTTPResponse=tWebClient.HttpResponse
			Set pResult("ERROR","findConceptsWithNameMatching","HTTP_RESPONSE_DATA")=tHTTPResponse.Data
			Set pResult("ERROR","findConceptsWithNameMatching","HTTP_REASON_PHRASE")=tHTTPResponse.ReasonPhrase
			Set pResult("ERROR","findConceptsWithNameMatching","HTTP_HEADERS_DATE")=$Get(tHTTPResponse.Headers("DATE"))
		}
		Set pResult="0^"_tErrorText_$get(pResult("ERROR","HTTP_REASON_PHRASE"))_"^"_..GetElapsedTime(tStartTime,$now())	
		Set tStatus=pResult
	}
	// If the result of the web call was an error - Quit now. 
	If ($Piece(pResult,"^",1)=0) Quit tStatus
	If (tDebug) {
		Write !,$tr(tSearchPattern,"*")," results returned: ",tSC.Count()
	}
	// Web call completed. Parse response...
	Set tCount=tSC.Count()
	Set tCounter=0
	For tKey=1:1:tCount {
		Set tObject=##class(BSTS.ns1.TOntylogConcept).%New()
		Set tObject=tSC.GetAt(tKey)
		Set tConceptID=tObject.id
		Set tRIn=tObject.revisionIn
		Set tROut=tObject.revisionOut
		If tConceptID>0 {
			Set tCounter=tCounter+1
			Set ^TMP("BSTSCMCL",$job,tConceptID)=($p($g(^TMP("BSTSCMCL",$job,tConceptID)),"^")+1)_"^"_tRIn_"^"_tROut
		}
		If (tDebug) {
			Write !,$tr(tSearchPattern,"*"),?30,tCounter,?40,tConceptID
		}
	}
	//End Here - instead of parsing
	Quit 1_"^^"_..GetElapsedTime(tStartTime,$now()) }
zFindTermsWithNameMatching(pParams="",pResult) public {
	// Data needed passed by BSTSWS array required for call	
	Set tDebug=$Get(pParams("DEBUG"))
	Set tWebServiceTimeout=$Get(pParams("TIMEOUT"))
	Set tUserName=$Get(pParams("USER"))
	Set tPassword=$Get(pParams("PASS"))
	Set tSSLConfiguration=$Get(pParams("SSL"))
	Set tNamespaceID=$Get(pParams("NAMESPACEID"))
	Set tSearchPattern=$Get(pParams("SEARCH"))
	Set tSnapshotDate=$Get(pParams("SNAPDT"))
	Set tMaxResults=$Get(pParams("MAXRECS")) S tMaxResults=100
	//Get location
	//BEE;BSTS*1.0*2;Changed location logic
	//Set tLocation=$Get(pParams("URLROOT"))_":"_$Get(pParams("PORT"))_$Get(pParams("SERVICEPATH"))_"/DtsQueryDaoService/DtsQueryDaoWS"
	Set tLocation=$Get(pParams("URLROOT"))_":"_$Get(pParams("PORT"))_$Get(pParams("SERVICEPATH"))_"/DtsQueryDaoWS"
	Set tConnectionTimeout=$Get(pParams("CTIME"))
	Set tStatus=0
	Set pResult=1
	// Setup request for search options and attribute set descriptors for initial call
	Set tSearchOptions=##class(BSTS.ns1.TTermSearchOptions).%New()
	Set tAttributeSetDesc=##class(BSTS.ns1.TTermAttributeSetDescriptor).%New()
	//Set tSearchOptions.attributeSetDescriptor.name="ASD Test 5"
	Set tSearchOptions.snapshotDate=tSnapshotDate	
	Set tAttributeSetDesc.DEFAULTLIMIT=0
	Set tAttributeSetDesc.allPropertyTypes="false"
	Set tAttributeSetDesc.allSynonymTypes="1"
	Set tAttributeSetDesc.allTermAssociationTypes="false"
	Set tAttributeSetDesc.allInverseTermAssociationTypes="false"
	Set tAttributeSetDesc.attributesLimit="1000"
	Set tSearchOptions.attributeSetDescriptor=tAttributeSetDesc
	Set tSearchOptions.firstResult="0"
	Set tSearchOptions.limit=tMaxResults
	Set tSearchOptions.namespaceId=tNamespaceID
	Set tSearchOptions.status="A"
	// Initialize new web client to make the SOAP call
	Set tWebClient=##class(BSTS.DtsQueryDaoPort).%New()
	Set tWebClient.Location=tLocation
	Set tWebClient.HttpUsername=tUserName
	Set tWebClient.HttpPassword=tPassword
	Set tWebClient.Timeout=tWebServiceTimeout
	Set tWebClient.OpenTimeout=tConnectionTimeout
	If ((tLocation["https://")&(tSSLConfiguration]"")) {	
		Set tWebClient.SSLConfiguration=tSSLConfiguration
    	Set tWebClient.HttpProxySSLConnect=0
	}
	Set tStartTime=$now()
	// Setup response
	Set tSC=##class(%Library.ListOfObjects).%New()
	try {
		Set tSC=tWebClient.findTermsWithNameMatching(tSearchPattern,tSearchOptions)
		If (tDebug) {
			Do $System.OBJ.Dump(tWebClient)
			If $ISOBJECT(tWebClient.HttpResponse) {
				Set tHTTPResponse=##class(%Net.HttpResponse).%New()
				Set tHTTPResponse=tWebClient.HttpResponse
				Set pResult("DEBUG","HTTP_RESPONSE_DATA")=tHTTPResponse.Data
				Set pResult("DEBUG","HTTP_REASON_PHRASE")=tHTTPResponse.ReasonPhrase
				Set pResult("DEBUG","HTTP_HEADERS_DATE")=$Get(tHTTPResponse.Headers("DATE"))
			}
			Set tHttpHeadersOut=##class(%Library.ArrayOfObjects).%New()
			Set tHttpHeadersOut=tWebClient.HeadersOut
			For key=1:1:tHttpHeadersOut.Count() {
			}
		}
	}
	Catch Exception
	{
		Set tError=""
		Set tErrorText=""
		If ($ZERROR["<ZSOAP>") {
			Set pResult("ERROR","SOAPFAULT","findTermsWithNameMatching","CODE")=tWebClient.SoapFault.faultcode
			Set pResult("ERROR","SOAPFAULT","findTermsWithNameMatching","FAULTSTRING")=tWebClient.SoapFault.faultstring
			Set tError=$System.Status.DecomposeStatus(%objlasterror,.tError)
			Set pResult("ERROR","SOAPFAULT","findTermsWithNameMatching","ERRORSTRING")=$Get(tError(1))
			Set tErrorText=$Get(tError(1))
		} else {
			Set tErrorText=$$Error^%apiOBJ(5002,$ZERROR)
			Set pResult("ERROR","ERRORSTRING")=tErrorText
		}
		If $ISOBJECT(tWebClient.HttpResponse) {
			Set tHTTPResponse=##class(%Net.HttpResponse).%New()
			Set tHTTPResponse=tWebClient.HttpResponse
			Set pResult("ERROR","findTermsWithNameMatching","HTTP_RESPONSE_DATA")=tHTTPResponse.Data
			Set pResult("ERROR","findTermsWithNameMatching","HTTP_REASON_PHRASE")=tHTTPResponse.ReasonPhrase
			Set pResult("ERROR","findTermsWithNameMatching","HTTP_HEADERS_DATE")=$Get(tHTTPResponse.Headers("DATE"))
		}
		Set pResult="0^"_tErrorText_$get(pResult("ERROR","HTTP_REASON_PHRASE"))_"^"_..GetElapsedTime(tStartTime,$now())	
		Set tStatus=pResult
	}
	// If the result of the web call was an error - Quit now. 
	If ($Piece(pResult,"^",1)=0) Quit tStatus
	If (tDebug) {
		Write !,$tr(tSearchPattern,"*")," results returned: ",tSC.Count()
	}
	// Web call completed. Parse response...
	Set tCount=tSC.Count()
	Set tCounter=0
	For tKey=1:1:tCount {
		Set tObject=##class(BSTS.ns1.TTerm).%New()
		Set tObject=tSC.GetAt(tKey)
		Set tsnap=tObject.snapshotDate
		Set tName=tObject.name
		Set tCode=tObject.code
		If tName="Acute nasal catarrh" {
			Do $SYSTEM.OBJ.Dump(tObject)
		}
		Set tSynonymList=##class(%Library.ListOfObjects).%New()
		Set tSynonymList=tObject.synonyms
		Set synct=tSynonymList.Count()
		Set tSynonym=##class(BSTS.ns1.TSynonym).%New()
		Set tSYNCount=0
		For tSynonymKey=1:1:tSynonymList.Count() {
			Set tSynonym=tSynonymList.GetAt(tSynonymKey)
			Set tConcept=##class(BSTS.ns1.TOntylogConcept).%New()
			Set tConcept=tSynonym.concept
			Set tConc=tConcept.code
			Set tId=tConcept.id
		}
	}
	//End Here - instead of parsing
	Quit 1_"^^"_..GetElapsedTime(tStartTime,$now()) }
zFullTextSearch(pParams="",pResult) public {
	// Data needed passed by BSTSWS array required for call
	Set tDebug=$Get(pParams("DEBUG"))
	Set tWebServiceTimeout=$Get(pParams("TIMEOUT"))
	Set tUserName=$Get(pParams("USER"))
	Set tPassword=$Get(pParams("PASS"))
	Set tSSLConfiguration=$Get(pParams("SSL"))
	Set tNamespaceID=$Get(pParams("NAMESPACEID"))
	Set tSearchPattern=$Get(pParams("SEARCH"))
	Set SearchConvert=""
	For piece=1:1:$L(tSearchPattern,"'") {
		Set string=$Piece(tSearchPattern,"'",piece)
		Set SearchConvert=SearchConvert_$Select(piece>1:"''",1:"")_string
	}
	Set tSearchPattern=SearchConvert
	Set tSnapshotDate=$Get(pParams("SNAPDT"))
	Set tSType=$Get(pParams("STYPE"))
	Set tSubset=$Get(pParams("SUBSET"))
	Set tExactMatch=$Get(pParams("EXACTMATCH"))
	Set tConnectionTimeout=$Get(pParams("CTIME"))
	//Assemble subset
	Set SubsetList=""
	For piece=1:1:$L(tSubset,"~") {
		Set sub=$Piece(tSubset,"~",piece)
		If sub]"" {
			Set SubsetList = SubsetList_$Select(SubsetList]"":",",1:"")_"'"_sub_"'"
		}	
	}
	//Handle maximum records
	Set tMaxResults=$Get(pParams("MAXRECS")) If tMaxResults="" Set tMaxResults=25
	//Set up location
	//BEE;BSTS*1.0*2;Changed location logic
	//Set tLocation=$Get(pParams("URLROOT"))_":"_$Get(pParams("PORT"))_$Get(pParams("SERVICEPATH"))_"/DtsQueryDaoService/DtsQueryDaoWS"
	Set tLocation=$Get(pParams("URLROOT"))_":"_$Get(pParams("PORT"))_$Get(pParams("SERVICEPATH"))_"/DtsQueryDaoWS"
	Set tStatus=0
	Set pResult=1	
    //New search definition
    Set SQLSearch="DECLARE @RC int"
	Set SQLSearch=SQLSearch_" DECLARE @Searchtext varchar(200) = '"_tSearchPattern_"',"
	Set SQLSearch=SQLSearch_" @NumRecs int = "_tMaxResults_","
    Set SQLSearch=SQLSearch_" @Namespace varchar(10) = '"_tNamespaceID_"',"
    Set SQLSearch=SQLSearch_" @Exactmatch varchar(2) = '"_tExactMatch_"',"
    Set SQLSearch=SQLSearch_" @Subsets nvarchar(2000) = "
    //Put in subsets
    If (tNamespaceID=36)!(tNamespaceID=1552) {
	    Set SQLSearch=SQLSearch_"'"_$TR(SubsetList,"'")_"',"
    }
    If (tNamespaceID'=36),(tNamespaceID'=1552) {
	    Set SQLSearch=SQLSearch_"'',"
    }
	Set SQLSearch=SQLSearch_" @Status varchar(2) = 'A',"
    Set SQLSearch=SQLSearch_" @Revision_In datetime = '"_tSnapshotDate_"'"
	Set SQLSearch=SQLSearch_" EXECUTE @RC = [dbo].[dts_searchterms_cond]"
   	Set SQLSearch=SQLSearch_" @Searchtext,"
   	Set SQLSearch=SQLSearch_" @NumRecs,"
   	Set SQLSearch=SQLSearch_" @Namespace,"
   	Set SQLSearch=SQLSearch_" @Subsets,"
   	Set SQLSearch=SQLSearch_" @Status,"
   	Set SQLSearch=SQLSearch_" @Revision_In,"
   	Set SQLSearch=SQLSearch_" @Exactmatch"
	If $Get(tDebug) {
		Write !!,"SQL Call: ",SQLSearch,!
	}
	// Initialize new web client to make the SOAP call
	Set tWebClient=##class(BSTS.DtsQueryDaoPort).%New()
	Set tWebClient.Location=tLocation
	Set tWebClient.HttpUsername=tUserName
	Set tWebClient.HttpPassword=tPassword
	Set tWebClient.Timeout=tWebServiceTimeout
	Set tWebClient.OpenTimeout=tConnectionTimeout
	If ((tLocation["https://")&(tSSLConfiguration]"")) {	
		Set tWebClient.SSLConfiguration=tSSLConfiguration
    	Set tWebClient.HttpProxySSLConnect=0
	}
	Set tStartTime=$now()
	// Setup response
	Set tSC=##class(%Library.ListOfObjects).%New()
	try {
		Set tSC=tWebClient.executeSQL(SQLSearch)
		If (tDebug) {
			Do $System.OBJ.Dump(tWebClient)
			If $ISOBJECT(tWebClient.HttpResponse) {
				Set tHTTPResponse=##class(%Net.HttpResponse).%New()
				Set tHTTPResponse=tWebClient.HttpResponse
				Set pResult("DEBUG","HTTP_RESPONSE_DATA")=tHTTPResponse.Data
				Set pResult("DEBUG","HTTP_REASON_PHRASE")=tHTTPResponse.ReasonPhrase
				Set pResult("DEBUG","HTTP_HEADERS_DATE")=$Get(tHTTPResponse.Headers("DATE"))
			}
			Set tHttpHeadersOut=##class(%Library.ArrayOfObjects).%New()
			Set tHttpHeadersOut=tWebClient.HeadersOut
			For key=1:1:tHttpHeadersOut.Count() {
			}
		}
	}
	Catch Exception
	{
		Set tError=""
		Set tErrorText=""
		If ($ZERROR["<ZSOAP>") {
			Set pResult("ERROR","SOAPFAULT","executeSQL","CODE")=tWebClient.SoapFault.faultcode
			Set pResult("ERROR","SOAPFAULT","executeSQL","FAULTSTRING")=tWebClient.SoapFault.faultstring
			Set tError=$System.Status.DecomposeStatus(%objlasterror,.tError)
			Set pResult("ERROR","SOAPFAULT","executeSQL","ERRORSTRING")=$Get(tError(1))
			Set tErrorText=$Get(tError(1))
		} else {
			Set tErrorText=$$Error^%apiOBJ(5002,$ZERROR)
			Set pResult("ERROR","ERRORSTRING")=tErrorText
		}
		If $ISOBJECT(tWebClient.HttpResponse) {
			Set tHTTPResponse=##class(%Net.HttpResponse).%New()
			Set tHTTPResponse=tWebClient.HttpResponse
			Set pResult("ERROR","executeSQL","HTTP_RESPONSE_DATA")=tHTTPResponse.Data
			Set pResult("ERROR","executeSQL","HTTP_REASON_PHRASE")=tHTTPResponse.ReasonPhrase
			Set pResult("ERROR","executeSQL","HTTP_HEADERS_DATE")=$Get(tHTTPResponse.Headers("DATE"))
		}
		Set pResult="0^"_tErrorText_$get(pResult("ERROR","HTTP_REASON_PHRASE"))_"^"_..GetElapsedTime(tStartTime,$now())	
		Set tStatus=pResult
	}
	// If the result of the web call was an error - Quit now. 
	If ($Piece(pResult,"^",1)=0) Quit tStatus
	//Display results returned
	If $Get(tDebug) {
		Write !,tSearchPattern," results returned: ",tSC.Count()
	}
	// Web call completed. Parse response...
	Set tCount=tSC.Count()
	Set tCounter=0
	For tKey=1:1:tCount {
		Set tResult=##class(BSTS.ns2.stringArray).%New()
		Set tResult=tSC.GetAt(tKey)
		Set DescId=tResult.item.GetAt(3)
		Set Term=tResult.item.GetAt(4)
		Set DTSId=tResult.item.GetAt(6)
		If $Get(tDebug) {
			W !!,"#: ",tKey
			W !,"DescId: ",DescId
			W !,"Term: ",Term
			W !,"DTSId: ",DTSId
		}
		//Save entry
		If DTSId>0 {
			Set tCounter=tCounter+1
			Set ^TMP("BSTSCMCL",$job,tCounter)=DTSId_"^"_DescId_"^"_Term
		}
	}
	//End Here - instead of parsing
	Quit 1_"^^"_..GetElapsedTime(tStartTime,$now()) }
zGetConceptDetail(pParams="",pResult) public {
	// Data needed passed by BSTSWS array required for call	
	Set tDebug=$Get(pParams("DEBUG"))
	Set tWebServiceTimeout=$Get(pParams("TIMEOUT"))
	Set tUserName=$Get(pParams("USER"))
	Set tPassword=$Get(pParams("PASS"))
	Set tSSLConfiguration=$Get(pParams("SSL"))
	Set tNamespaceID=$Get(pParams("NAMESPACEID"))
	Set tSearchPattern=$Get(pParams("SEARCH"))
	Set tSnapshotDate=$Get(pParams("SNAPDT"))
	Set tConnectionTimeout=$Get(pParams("CTIME"))
	If tSnapshotDate]"" {
		Set tSnapshotDate=$$SQL2XML^BSTSUTIL(tSnapshotDate)
	}
	Set tMaxResults=$Get(pParams("MAXRECS")) S tMaxResults=100
	//Get location
	//BEE;BSTS*1.0*2;Changed location logic
	//Set tLocation=$Get(pParams("URLROOT"))_":"_$Get(pParams("PORT"))_$Get(pParams("SERVICEPATH"))_"/DtsQueryDaoService/DtsQueryDaoWS"
	Set tLocation=$Get(pParams("URLROOT"))_":"_$Get(pParams("PORT"))_$Get(pParams("SERVICEPATH"))_"/DtsQueryDaoWS"
	Set tStatus=0
	Set pResult=1
	Set tStartTime=$now()
	Set tConceptID=$Get(pParams("DTSID"))
	// Initialize new web client to make the SOAP call
	Set tWebClient=##class(BSTS.DtsQueryDaoPort).%New()
	Set tWebClient.Location=tLocation
	Set tWebClient.HttpUsername=tUserName
	Set tWebClient.HttpPassword=tPassword
	Set tWebClient.Timeout=tWebServiceTimeout
	Set tWebClient.OpenTimeout=tConnectionTimeout
	If ((tLocation["https://")&(tSSLConfiguration]"")) {	
		Set tWebClient.SSLConfiguration=tSSLConfiguration
    	Set tWebClient.HttpProxySSLConnect=0
	}
	Set tStartTime=$now()
	// Do the sub call to findConceptById()
	Set tAttSetDescForID=##class(BSTS.ns1.TConceptAttributeSetDescriptor).%New()
	Set tAttSetDescForID.DEFAULTLIMIT=0
	Set tAttSetDescForID.allPropertyTypes="false"
	Set tAttSetDescForID.name="ASD Concept ID"
	Set tAttSetDescForID.snapshotDate=tSnapshotDate
	Set tAttSetDescForID.superconcepts="1"
	Set tPropType1=##class(BSTS.ns1.TPropertyType).%New()
	Set tPropType1.namespaceId=tNamespaceID
	Set tPropType1.id="12"
	Do tAttSetDescForID.propertyTypes.Insert(tPropType1)
	Set tPropType2=##class(BSTS.ns1.TPropertyType).%New()
	Set tPropType2.namespaceId=tNamespaceID
	Set tPropType2.id="101"
	Do tAttSetDescForID.propertyTypes.Insert(tPropType2)
	Set tPropType3=##class(BSTS.ns1.TPropertyType).%New()
	Set tPropType3.namespaceId=tNamespaceID
	Set tPropType3.id="6"
	Do tAttSetDescForID.propertyTypes.Insert(tPropType3)
	Set tPropType4=##class(BSTS.ns1.TPropertyType).%New()
	Set tPropType4.namespaceId=tNamespaceID
	Set tPropType4.id="993"
	Do tAttSetDescForID.propertyTypes.Insert(tPropType4)
	Set tPropType5=##class(BSTS.ns1.TPropertyType).%New()
	Set tPropType5.namespaceId=35290
	Set tPropType5.id="2"
	Do tAttSetDescForID.propertyTypes.Insert(tPropType5)
	Set tPropType6=##class(BSTS.ns1.TPropertyType).%New()
	Set tPropType6.namespaceId=32768
	If tNamespaceID=1552 {
			Set tPropType6.namespaceId=32769		
	}
	If tNamespaceID=36 {
	Set tPropType6.namespaceId=32768
	}
	Set tPropType6.code="IHS"
	Set tPropType6.id="1"
	Do tAttSetDescForID.propertyTypes.Insert(tPropType6)
	/*//IHS Med Route
	If tNamespaceID=32774 {
		Set tPropTypeS=##class(BSTS.ns1.TPropertyType).%New()
		Set tPropTypeS.namespaceId=tNamespaceID
		Set tPropTypeS.id="1"
		Set tPropTypeS.name="Code in Source"
		Do tAttSetDescForID.propertyTypes.Insert(tPropTypeS)
	}*/
	//SIGNS/SYMPTOMS
	If tNamespaceID=32772 {
		Set tPropTypeS=##class(BSTS.ns1.TPropertyType).%New()
		Set tPropTypeS.namespaceId=tNamespaceID
		Set tPropTypeS.id="1"
		Set tPropTypeS.name="Code in Source"
		Do tAttSetDescForID.propertyTypes.Insert(tPropTypeS)
		If (tDebug) {
			W !!,"PROPERTY S: ",!
			Do $SYSTEM.OBJ.Dump(tPropTypeS)
			w !!
		}
	}
	//GMRA Allergies with Maps
	If tNamespaceID=32773 {
		Set tPropTypeA=##class(BSTS.ns1.TPropertyType).%New()
		Set tPropTypeA.namespaceId=tNamespaceID
		Set tPropTypeA.id="1"
		Set tPropTypeA.name="Code in Source"
		Do tAttSetDescForID.propertyTypes.Insert(tPropTypeA)
	}
	//ECLIDS
	If tNamespaceID=32770 {
		Set tPropTypeE=##class(BSTS.ns1.TPropertyType).%New()
		Set tPropTypeE.namespaceId=32770
		Set tPropTypeE.id="1"
		Set tPropTypeE.name="Code in Source"
		Do tAttSetDescForID.propertyTypes.Insert(tPropTypeE)
	}
	//CPT Meds with Maps
	If tNamespaceID=32775 {
		Set tPropTypeC=##class(BSTS.ns1.TPropertyType).%New()
		Set tPropTypeC.namespaceId=32775
		Set tPropTypeC.id="2"
		Set tPropTypeC.name="Code in Source"
		Do tAttSetDescForID.propertyTypes.Insert(tPropTypeC)
	}
	//IHS VANDF
	If tNamespaceID=32771 {
		Set tPropTypeI=##class(BSTS.ns1.TPropertyType).%New()
		Set tPropTypeI.namespaceId=tNamespaceID
		Set tPropTypeI.id="2"
		Set tPropTypeI.name="Code in Source"
		Do tAttSetDescForID.propertyTypes.Insert(tPropTypeI)
	}
	//UNII
	If tNamespaceID=5180 {
		Set tPropType7=##class(BSTS.ns1.TPropertyType).%New()
		Set tPropType7.namespaceId=tNamespaceID
		Set tPropType7.id="1"
		Set tPropType7.name="Code in Source"
		Do tAttSetDescForID.propertyTypes.Insert(tPropType7)
	}
	//RXNORM
	If tNamespaceID=1552 {
		Set tPropType8=##class(BSTS.ns1.TPropertyType).%New()
		Set tPropType8.namespaceId=tNamespaceID
		Set tPropType8.id="10"
		Set tPropType8.name="Code in Source"
		Do tAttSetDescForID.propertyTypes.Insert(tPropType8)
		//NDC
		Set tPropTypeN=##class(BSTS.ns1.TPropertyType).%New()
		Set tPropTypeN.namespaceId=tNamespaceID
		Set tPropTypeN.id="110"
		Set tPropTypeN.name="NDC"
		Set tPropTypeN.attachesTo="C"
		Do tAttSetDescForID.propertyTypes.Insert(tPropTypeN)
		//VUID
		Set tPropTypeV=##class(BSTS.ns1.TPropertyType).%New()
		Set tPropTypeV.namespaceId=tNamespaceID
		Set tPropTypeV.id="209"
		Set tPropTypeV.name="VUID"
		Set tPropTypeV.attachesTo="C"
		Do tAttSetDescForID.propertyTypes.Insert(tPropTypeV)
		Set tPropTypeTT=##class(BSTS.ns1.TPropertyType).%New()
		Set tPropTypeTT.namespaceId=tNamespaceID
		Set tPropTypeTT.id="120"
		Set tPropTypeTT.name="TTY"
		Set tPropTypeTT.attachesTo="C"
		Do tAttSetDescForID.propertyTypes.Insert(tPropTypeTT)		
	}
	Set tPropType9=##class(BSTS.ns1.TPropertyType).%New()
	Set tPropType9.namespaceId=tNamespaceID
	Set tPropType9.id="14"
	Do tAttSetDescForID.propertyTypes.Insert(tPropType9)
	//BSTS*1.0*7;Return all inverse associations to get equivalencies	
	//Set tAttSetDescForID.allInverseAssociationTypes="0"
	//Set tInvAsscTyp=##class(BSTS.ns1.TAssociationType).%New()
	//Set tInvAsscTyp.namespaceId=tNamespaceID
	//Set tInvAsscTyp.id="106"
	//Set tInvAsscTyp.name="has_tradename"
	//Do tAttSetDescForID.inverseAssociationTypes.Insert(tInvAsscTyp)
	Set tAttSetDescForID.allInverseAssociationTypes="1"
	Set tAttSetDescForID.allAssociationTypes="1"
	Set tAttSetDescForID.allSynonymTypes="1"
	Set tAttSetDescForID.allRoleTypes="1"
	Set tAttSetDescForID.allInverseRoleTypes="0"
	Set tAttSetDescForID.definedViewAttributes="0"
	Set tAttSetDescForID.queryHasSubs="0"
	Set tAttSetDescForID.queryHasSups="0"
	Set tAttSetDescForID.subconcepts="1"
	Set tAttSetDescForID.superconcepts="1"
	Set tAttSetDescForID.attributesLimit=1000
	Set tConceptByIdResult=##class(BSTS.ns1.TOntylogConcept).%New()
	If (tDebug) {
		Do $SYSTEM.OBJ.Dump(tAttSetDescForID)
		W !!,"tConceptID: ",$G(tConceptID)
		W !,"tNamespaceID: ",$G(tNamespaceID)
	}
	try {
		Set tConceptByIdResult=tWebClient.findConceptById(tConceptID,tNamespaceID,tAttSetDescForID)
		If (tDebug) {
			W !!
			If $ISOBJECT(tWebClient.HttpResponse) {
				Set tHTTPResponse=##class(%Net.HttpResponse).%New()
				Set tHTTPResponse=tWebClient.HttpResponse
				Set pResult("DEBUG","findConceptById",tConceptByIdResult.id,"HTTP_RESPONSE_DATA")=tHTTPResponse.Data
				Set pResult("DEBUG","findConceptById",tConceptByIdResult.id,"HTTP_REASON_PHRASE")=tHTTPResponse.ReasonPhrase
				Set pResult("DEBUG","findConceptById",tConceptByIdResult.id,"HTTP_HEADERS_DATE")=$Get(tHTTPResponse.Headers("DATE"))
			}
		}		
	}
	Catch Exception {
		Set tError=""
		Set tErrorText=""
		If ($ZERROR["<ZSOAP>") {
			Set pResult("ERROR","SOAPFAULT","CODE")=tWebClient.SoapFault.faultcode
			Set pResult("ERROR","SOAPFAULT","FAULTSTRING")=tWebClient.SoapFault.faultstring
			Set tError=$System.Status.DecomposeStatus(%objlasterror,.tError)
			Set pResult("ERROR","SOAPFAULT","ERRORSTRING")=$Get(tError(1))
			Set tErrorText=$Get(tError(1))
		}
		else {
			Set tErrorText=$$Error^%apiOBJ(5002,$ZERROR)
			Set pResult("ERROR","ERRORSTRING")=tErrorText
		}
		//BSTS*1.0*6;Handle invalid DTSID
		if tErrorText["<INVALID OREF>" {
			Set pResult="1^Invalid DTSID"_"^"_..GetElapsedTime(tStartTime,$now())	
		}
		else {
			Set pResult="0^"_tErrorText_$get(pResult("ERROR","HTTP_REASON_PHRASE"))_"^"_..GetElapsedTime(tStartTime,$now())	
		}
		Set tStatus=pResult
	}
	//Set Return Values
	if pResult=1 {
		if '$IsObject(tConceptByIdResult) {
			//BSTS*1.0*6;If not an error they just passed in an invalid entry
			//Set pResult="0^Invalid Response Format"
			Set pResult="1^Invalid DTSID or Response Format"
		}
		if $IsObject(tConceptByIdResult) {	
			Set ^TMP("BSTSCMCL",$job,1,"DTSID")=tConceptByIdResult.id
			Set ^TMP("BSTSCMCL",$job,1,"NAMESP")=tNamespaceID
			Set ^TMP("BSTSCMCL",$job,1,"FSN",0)=tConceptByIdResult.revisionIn_"^"_tConceptByIdResult.revisionOut
			Set ^TMP("BSTSCMCL",$job,1,"FSN",1)=tConceptByIdResult.name
			Set ^TMP("BSTSCMCL",$job,1,"STS")=tConceptByIdResult.status
			Set tProperties=##class(%Library.ListOfObjects).%New()
			Set tPropertyObject=##class(BSTS.ns1.TProperty).%New()
			Set tPropertyType=##class(BSTS.ns1.TPropertyType).%New()
			Set tProperties=tConceptByIdResult.properties
			Set tPropertyCount=0
			Set tSUBCount=0
			Set tICDCount=0
			Set tRICDCount=0
			Set tICDMCount=0
			Set tnsubCount=0
			Set tVUIDCount=0
			Set tNDCCount=0
			Set tTTYCount=0
			//Grab the name for use by 32774 - has to be handled different
			//from the other ones because it has no properties
			If (tNamespaceID=32774) {
				Set tCncName=tConceptByIdResult.name
				if tCncName]"" {
					Set ^TMP("BSTSCMCL",$job,1,"CONCEPTID")=tCncName_"^"_tConceptByIdResult.revisionIn_"^"_tConceptByIdResult.revisionOut
				}					
			}
			For tPropKey=1:1:tProperties.Count() {
				Set tPropertyObject=tProperties.GetAt(tPropKey)
				Set tRin=tPropertyObject.revisionIn
				Set tRout=tPropertyObject.revisionOut
				Set tPropertyType=tPropertyObject.propertyType
				If (tDebug) {
					Write "Property Type is "_tPropertyType.id,!
					Do $SYSTEM.OBJ.Dump(tPropertyObject)
				}
				//CURRENT STATUS
				If (tPropertyType.id)="14" {
						Set ^TMP("BSTSCMCL",$job,1,"CURRENT")=tPropertyObject.revisionIn_"^"_tPropertyObject.revisionOut_"^"_tPropertyObject.value
						Set ^TMP("BSTSCMCL",$job,1,"RVAL")=tRin_"^"_tRout
				}
				//Look for concept id
				//ECLID
				If (tNamespaceID=32770) { 
					If (tPropertyType.name="Code in Source") {
						Set ^TMP("BSTSCMCL",$job,1,"CONCEPTID")=tPropertyObject.value_"^"_tPropertyObject.revisionIn_"^"_tPropertyObject.revisionOut
					}
				}
				//CPT Meds with Maps
				If (tNamespaceID=32775) { 
					If (tPropertyType.name="Code in Source") {
						Set ^TMP("BSTSCMCL",$job,1,"CONCEPTID")=tPropertyObject.value_"^"_tPropertyObject.revisionIn_"^"_tPropertyObject.revisionOut
					}
				}
				//SNOMED
				If (tNamespaceID=36) { 
					If (tPropertyType.id="12") {
						Set ^TMP("BSTSCMCL",$job,1,"CONCEPTID")=tPropertyObject.value_"^"_tPropertyObject.revisionIn_"^"_tPropertyObject.revisionOut
					}
				}
				//UNII
				If (tNamespaceID=5180) {
					If (tPropertyType.id="1") {
						Set ^TMP("BSTSCMCL",$job,1,"CONCEPTID")=tPropertyObject.value_"^"_tPropertyObject.revisionIn_"^"_tPropertyObject.revisionOut
					}
				}
				//RXNORM
				If (tNamespaceID=1552) {
					If (tPropertyType.id="10") {
						Set ^TMP("BSTSCMCL",$job,1,"CONCEPTID")=tPropertyObject.value_"^"_tPropertyObject.revisionIn_"^"_tPropertyObject.revisionOut
					}
					If (tPropertyType.id="120") {
						Set tTTYCount=tTTYCount+1
						Set ^TMP("BSTSCMCL",$job,1,"TTY",tTTYCount)=tPropertyObject.value_"^"_tPropertyObject.revisionIn_"^"_tPropertyObject.revisionOut	
					}
				}
				//SPECIAL CODESETS
				//SIGNS/SYMPTOMS
				If (tNamespaceID=32772) {
					If (tPropertyType.id="1") {
						Set ^TMP("BSTSCMCL",$job,1,"CONCEPTID")=tPropertyObject.value_"^"_tPropertyObject.revisionIn_"^"_tPropertyObject.revisionOut				
					}
				}
				//ALLERGIES
				If (tNamespaceID=32773) {
					If (tPropertyType.id="1") {
						Set ^TMP("BSTSCMCL",$job,1,"CONCEPTID")=tPropertyObject.value_"^"_tPropertyObject.revisionIn_"^"_tPropertyObject.revisionOut				
					}
				}
				//INGREDIENTS
				If (tNamespaceID=32771) {
					If (tPropertyType.id="2") {
						Set ^TMP("BSTSCMCL",$job,1,"CONCEPTID")=tPropertyObject.value_"^"_tPropertyObject.revisionIn_"^"_tPropertyObject.revisionOut				
					}
				}
				//VUID
				If (tPropertyType.id="209") {
					Set tVUIDCount=tVUIDCount+1
					Set ^TMP("BSTSCMCL",$job,1,"VUID",tVUIDCount)=tPropertyObject.value_"^"_tPropertyObject.revisionIn_"^"_tPropertyObject.revisionOut
				}
				//NDC
				If (tPropertyType.id="110") {
					Set tNDCCount=tNDCCount+1
					Set ^TMP("BSTSCMCL",$job,1,"NDC",tNDCCount)=tPropertyObject.value_"^"_tPropertyObject.revisionIn_"^"_tPropertyObject.revisionOut
				}
				//ICD9 to SNOMED reverse mapping
				If ((tNamespaceID=36)&(tPropertyType.id="6")) {
					Set tRICDCount=tRICDCount+1
					Set ^TMP("BSTSCMCL",$job,1,"RICD9",tRICDCount)=tPropertyObject.value_"^"_tPropertyObject.revisionIn_"^"_tPropertyObject.revisionOut
				}
				//New subsets
				If (tNamespaceID=36)!(tNamespaceID=1552) { 
					If (tPropertyType.id="1") {
						Set tSUBCount=tSUBCount+1
						Set ^TMP("BSTSCMCL",$job,1,"SUB",tSUBCount)=tPropertyObject.value_"^"_tPropertyObject.revisionIn_"^"_tPropertyObject.revisionOut
					}
				}
				//ECLID Subset
				If (tNamespaceID=32770) { 
					If (tPropertyType.id="6") {
						Set tSUBCount=tSUBCount+1
						Set ^TMP("BSTSCMCL",$job,1,"SUB",tSUBCount)=tPropertyObject.value_"^"_tPropertyObject.revisionIn_"^"_tPropertyObject.revisionOut
					}
				}
				//CPT Meds with Maps
				If (tNamespaceID=32775) { 
					If (tPropertyType.id="1") {
						Set tSUBCount=tSUBCount+1
						Set ^TMP("BSTSCMCL",$job,1,"SUB",tSUBCount)=tPropertyObject.value_"^"_tPropertyObject.revisionIn_"^"_tPropertyObject.revisionOut
					}
				}
				If (tPropertyType.id="2") {
					Set tICDMCount=tICDMCount+1
					Set tQualifier=##class(BSTS.ns1.TQualifier).%New()
					Set mapadvice=tPropertyObject.value
					Set tQualifier=tPropertyObject.qualifiers
					Set tQTCount=tPropertyObject.qualifiers.Count()
					If mapadvice]"" {
						//Save map advice
						Set tRin=tPropertyObject.revisionIn
						Set tRout=tPropertyObject.revisionOut
						For tQualT=1:1:tQTCount {
							Set tqual=##class(BSTS.ns1.TQualifier).%New()
							Set tqual=tPropertyObject.qualifiers.GetAt(tQualT)
							Set val=tqual.value	
							Set tQualType=##class(BSTS.ns1.TQualifierType).%New()
							Set tQualType=tqual.qualifierType.name
							Set tQualId=##class(BSTS.ns1.TQualifierType).%New()
							Set tQualId=tqual.qualifierType.id
							Set tRin=tqual.revisionIn
							Set tRout=tqual.revisionOut
							//Save other map info
							If tQualType]"" {
								Set ^TMP("BSTSCMCL",$job,1,"ICDM",tICDMCount,tQualType)=val_"^"_tRin_"^"_tRout
							}
						}
					}
				}
			}
			// SYN level of TMP
			Set tSynonymList=""
			Set tSynonymList=##class(%Library.ListOfObjects).%New()
			Set tSynonymList=tConceptByIdResult.synonyms
			Set tSynonym=##class(BSTS.ns1.TSynonym).%New()
			Set tTerm=##class(BSTS.ns1.TTerm).%New()
			Set tAssocType=##class(BSTS.ns1.TAssociationType).%New()
			Set tConcept=##class(BSTS.ns1.TOntylogConcept).%New()
				Set tSYNCount=0
				For tSynonymKey=1:1:tSynonymList.Count() {
					Set tSynonym=tSynonymList.GetAt(tSynonymKey)
					If (tDebug) {
						Do $SYSTEM.OBJ.Dump(tSynonym)
					}
					Set tTerm=tSynonym.term
					Set tAssocType=tSynonym.associationType
					Set tConcept=tSynonym.concept
					Set tSYNCount=tSYNCount+1
					//Handle synonym types
					Set tSYNType=tAssocType.name
					Set tSType=5
					If tSYNType="Synonym" {
						Set tSType=2
					}
					If tSYNType="Clinician Term" {
						Set tSType=3
					}
					If tSYNType="Consumer Term" {
						Set tSType=4
					}
					If tSynonym.preferred=1 {
						Set tSType=1
					}
					Set ^TMP("BSTSCMCL",$job,1,"SYN",tSType,tSYNCount,0)=tTerm.code_"^"_tSynonym.preferred_"^"_tTerm.revisionIn_"^"_tTerm.revisionOut
					Set ^TMP("BSTSCMCL",$job,1,"SYN",tSType,tSYNCount,1)=tTerm.name
				}
			// ISA level of TMP
			Set tISACount=0
			Set tSuperConceptsList=##class(%Library.ListOfObjects).%New()
			Set tSuperConceptsList=tConceptByIdResult.superconcepts
			Set tSuperConcept=##class(BSTS.ns1.TConceptNav).%New()
			Set tSuperConceptObj=##class(BSTS.ns1.TOntylogConcept).%New()
			Set tSuperConceptKey=0
			If (tDebug) {
				Write "SUPER CONCEPTS LIST COUNT="_tSuperConceptsList.Count(),!
			}
			For tSuperConceptKey=1:1:tSuperConceptsList.Count() {
				Set tSuperConcept=tSuperConceptsList.GetAt(tSuperConceptKey)
				If (tDebug) {
					Do $SYSTEM.OBJ.Dump(tSuperConcept)
				}
				Set tSuperConceptObj=tSuperConcept.concept
				Set tISACount=tISACount+1
				Set ^TMP("BSTSCMCL",$job,1,"ISA",tISACount,0)=tSuperConceptObj.id_"^"_tSuperConceptObj.revisionIn_"^"_tSuperConceptObj.revisionOut
				Set ^TMP("BSTSCMCL",$job,1,"ISA",tISACount,1)=tSuperConceptObj.name
			}	
			// Concept Children of TMP
			Set tSubCCount=0
			Set tSubCConceptsList=##class(%Library.ListOfObjects).%New()
			Set tSubCConceptsList=tConceptByIdResult.subconcepts
			Set tSubCConcept=##class(BSTS.ns1.TConceptNav).%New()
			Set tSubCConceptObj=##class(BSTS.ns1.TOntylogConcept).%New()
			Set tSubCConceptKey=0
			If (tDebug) {
				Write "SUB CONCEPTS LIST COUNT="_tSubCConceptsList.Count(),!
			}
			For tSubCConceptKey=1:1:tSubCConceptsList.Count() {
				Set tSubCConcept=tSubCConceptsList.GetAt(tSubCConceptKey)
				If (tDebug) {
					Do $SYSTEM.OBJ.Dump(tSubCConcept)
				}
				Set tSubCConceptObj=tSubCConcept.concept
				Set tSubCCount=tSubCCount+1
				Set ^TMP("BSTSCMCL",$job,1,"SUBC",tSubCCount,0)=tSubCConceptObj.id_"^"_tSubCConceptObj.revisionIn_"^"_tSubCConceptObj.revisionOut
				Set ^TMP("BSTSCMCL",$job,1,"SUBC",tSubCCount,1)=tSubCConceptObj.name
			}	
			// Load in Inverse Associations
			Set tIAssociations=##class(%Library.ListOfObjects).%New()
			Set tIAssocObject=##class(BSTS.ns1.TConceptAssociation).%New()
			Set tIAssocType=##class(BSTS.ns1.TAssociationType).%New()
			Set tIAssociations=tConceptByIdResult.inverseAssociations
			Set tIAssocCount=0
			Set tAssocILEquiv=0
			For tIAssocKey=1:1:tIAssociations.Count() {
				Set tIAssocObject=tIAssociations.GetAt(tIAssocKey)
				Set tIAssocType=tIAssocObject.associationType
				//BSTS*1.0*7;Include equivalent concepts
				//Include Equivalent Concepts to this Concept
				if tIAssocObject.associationType.namespaceId=32780 {
					Set tLatVariant=tIAssocObject.associationType.name
					Set tLatDTSId=tIAssocObject.fromConcept.id
					Set tLatConcId=tIAssocObject.fromConcept.code
					Set tLatRevIn=tIAssocObject.revisionIn
					Set tLatRevOut=tIAssocObject.revisionOut
					Set tAssocILEquiv=tAssocILEquiv+1
					Set ^TMP("BSTSCMCL",$job,1,"AIEQ",tAssocILEquiv)=tLatVariant_"^"_tLatDTSId_"^"_tLatConcId_"^"_tLatRevIn_"^"_tLatRevOut
				}
				//Only include trade name entries
				Set ttrade=tIAssocType.name
				if ttrade["has_tradename" {
					Set tCode=tIAssocObject.fromConcept.code
					Set tDTSId=tIAssocObject.fromConcept.id
					Set tNameId=tIAssocObject.fromConcept.namespaceId
					Set tName=tIAssocObject.fromConcept.name
					Set tIAssocCount=tIAssocCount+1
					Set ^TMP("BSTSCMCL",$job,1,"IAS",tIAssocCount)=tCode_"^"_tNameId_"^"_tDTSId_"^"_tName
					//Save the associations
					If (tDebug) {
						Do $SYSTEM.OBJ.Dump(tIAssocObject)
					}
				}
			}			
			// Load in Roles
			Set tRoles=##class(%Library.ListOfObjects).%New()
			Set tRoleObject=##class(BSTS.ns1.TRole).%New()
			Set tRoleType=##class(BSTS.ns1.TRoleType).%New()
			Set tRoles=tConceptByIdResult.roles
			Set tRolesCount=0
			For tRolesKey=1:1:tRoles.Count() {
				Set tRoleObject=tRoles.GetAt(tRolesKey)
				Set tRoleType=tRoleObject.roleType
				//Only include map to entries
				Set tRoleName=tRoleType.name
				if tRoleName["Clinical course" {
					Set tName=tRoleObject.valueConcept.name
					//Acute
					If tName["Sudden onset AND/OR short duration" {
						Set tRolesCount=tRolesCount+1
						Set ^TMP("BSTSCMCL",$job,1,"CSTS",tRolesCount)="A^"_tRoleName
					}
					//Chronic
					If tName["Chronic" {
						Set tRolesCount=tRolesCount+1
						Set ^TMP("BSTSCMCL",$job,1,"CSTS",tRolesCount)="C^"_tRoleName
					}
				}
			}			
			// Load in Associations
			Set tAssociations=##class(%Library.ListOfObjects).%New()
			Set tAssocObject=##class(BSTS.ns1.TConceptAssociation).%New()
			Set tAssocType=##class(BSTS.ns1.TAssociationType).%New()
			Set tAssociations=tConceptByIdResult.associations
			Set tQualifiers=##class(BSTS.ns1.TQualifier).%New()
			Set tQualifierType=##class(BSTS.ns1.TQualifierType).%New()
			Set tAssocCount=0
			Set tAssoc10Cnt=0
			Set tAssoc9Cnt=0
			Set tAssoc10PCnt=0
			Set tAssocLEquiv=0
			Set tAssocRepCnt=0
			For tAssocKey=1:1:tAssociations.Count() {
				Set tAssocObject=tAssociations.GetAt(tAssocKey)
				Set tAssocType=tAssocObject.associationType
				//BSTS*1.0*7;Include equivalent concepts
				//Include Equivalent Concepts to this Concept
				if tAssocObject.associationType.namespaceId=32780 {
					Set tLatVariant=tAssocObject.associationType.name
					Set tLatDTSId=tAssocObject.toConcept.id
					Set tLatConcId=tAssocObject.toConcept.code
					Set tLatRevIn=tAssocObject.revisionIn
					Set tLatRevOut=tAssocObject.revisionOut
					Set tAssocLEquiv=tAssocLEquiv+1
					Set ^TMP("BSTSCMCL",$job,1,"AEQ",tAssocLEquiv)=tLatVariant_"^"_tLatDTSId_"^"_tLatConcId_"^"_tLatRevIn_"^"_tLatRevOut
				}
				//Only include map to entries
				Set tMapTo=tAssocType.name
				//Only include map to entries
				if tMapTo["Map to" {
					Set tCode=tAssocObject.toConcept.code
					Set tDTSId=tAssocObject.toConcept.id
					Set tNameId=tAssocObject.toConcept.namespaceId
					Set tName=tAssocObject.toConcept.name
					Set tAssocCount=tAssocCount+1
					Set ^TMP("BSTSCMCL",$job,1,"ASC",tAssocCount)=tCode_"^"_tNameId_"^"_tDTSId_"^"_tName
					//Save the associations
					If (tDebug) {
						Do $SYSTEM.OBJ.Dump(tAssocObject)
					}
				}
				//BSTS*1.0*8;Include Replacements
				if tAssocObject.associationType.namespaceId=32780 {
					Set tLatVariant=tAssocObject.associationType.name
					Set tLatDTSId=tAssocObject.toConcept.id
					Set tLatConcId=tAssocObject.toConcept.code
					Set tLatRevIn=tAssocObject.revisionIn
					Set tLatRevOut=tAssocObject.revisionOut
					Set tAssocLEquiv=tAssocLEquiv+1
					Set ^TMP("BSTSCMCL",$job,1,"AEQ",tAssocLEquiv)=tLatVariant_"^"_tLatDTSId_"^"_tLatConcId_"^"_tLatRevIn_"^"_tLatRevOut
				}
				if (tMapTo["REPLACED BY")!(tMapTo["SAME AS")!(tMapTo["MAY BE") {
					Set tCode=tAssocObject.toConcept.code
					Set tDTSId=tAssocObject.toConcept.id
					Set tNameId=tAssocObject.toConcept.namespaceId
					Set tName=tAssocObject.toConcept.name
					Set tRevisionIn=tAssocObject.revisionIn
					Set tRevisionOut=tAssocObject.revisionOut
					Set tAssocRepCnt=tAssocRepCnt+1
					Set ^TMP("BSTSCMCL",$job,1,"REP",tAssocRepCnt)=tCode_"^"_tNameId_"^"_tDTSId_"^^"_tRevisionIn_"^"_tRevisionOut_"^"_tMapTo
					//Save the associations
					If (tDebug) {
						Do $SYSTEM.OBJ.Dump(tAssocObject)
					}
				}
				//Include ICD-10 Autocodables
				if tMapTo["SCTUS-ICD10CM" {
					Set tCode=tAssocObject.toConcept.code
					Set tDTSId=tAssocObject.toConcept.id
					Set tNameId=tAssocObject.toConcept.namespaceId
					Set tName=tAssocObject.toConcept.name
					Set tRevisionIn=tAssocObject.revisionIn
					Set tRevisionOut=tAssocObject.revisionOut
					Set tAssoc10Cnt=tAssoc10Cnt+1
					Set ^TMP("BSTSCMCL",$job,1,"A10",tAssoc10Cnt)=tCode_"^"_tNameId_"^"_tDTSId_"^"_tName_"^"_tRevisionIn_"^"_tRevisionOut
				}
				//Retrieve ICD-10 Conditionals
				if tMapTo["SCTUS-ICD10-CM" {
					Set tCode=tAssocObject.toConcept.code
					Set tDTSId=tAssocObject.toConcept.id
					Set tNameId=tAssocObject.toConcept.namespaceId
					Set tName=tAssocObject.toConcept.name
					Set tRevisionIn=tAssocObject.revisionIn
					Set tRevisionOut=tAssocObject.revisionOut
					Set QualifierCount=tAssocObject.qualifiers.Count()
					For tQualifierKey=1:1:tAssocObject.qualifiers.Count() {
						Set tQualifier=tAssocObject.qualifiers.GetAt(tQualifierKey)
						Set tQualifierValue=tQualifier.value
						Set tMapGroup=$p(tQualifierValue,"|")
						Set tMapPriority=$p(tQualifierValue,"|",2)
						Set tMapCondition=$p(tQualifierValue,"|",3)
						If (tMapGroup>0)&&(tMapPriority]"") {
							Set tAssoc10PCnt=tAssoc10PCnt+1
							Set ^TMP("BSTSCMCL",$job,1,"A10C",tMapGroup,tMapPriority,tAssoc10PCnt)=tCode_"^"_tMapCondition_"^"_tNameId_"^"_tDTSId_"^"_tName_"^"_tRevisionIn_"^"_tRevisionOut
						}
					}
				}
				//Include ICD-9 Autocodables
				if tMapTo["SCTUS-ICD9CM" {
					Set tCode=tAssocObject.toConcept.code
					Set tDTSId=tAssocObject.toConcept.id
					Set tNameId=tAssocObject.toConcept.namespaceId
					Set tName=tAssocObject.toConcept.name
					Set tRevisionIn=tAssocObject.revisionIn
					Set tRevisionOut=tAssocObject.revisionOut
					//Filter out E-Codes and save entry
					If $E(tCode,1)'="E" {
						Set tAssoc9Cnt=tAssoc9Cnt+1
						Set ^TMP("BSTSCMCL",$job,1,"ICD9",tAssoc9Cnt)=tCode_"^"_tNameId_"^"_tDTSId_"^"_tName_"^"_tRevisionIn_"^"_tRevisionOut
					}
				}
			}			
			Set tEndTime=$now(),tElapsedTime=..GetElapsedTime(tStartTime,tEndTime),pResult="1^^"_tElapsedTime
		}
	}
	Set tStatus=pResult
	Quit tStatus }
zGetElapsedTime(pStartDate="",pEndDate="") public {
	Quit:pStartDate="" ""
	Set pEndDate=$select(pEndDate="":$now(),1:pEndDate)	// Default $now() if no pEndDate passed
	Quit $Piece(pEndDate,",")-$Piece(pStartDate,",")*86000+$Piece(pEndDate,",",2)-$Piece(pStartDate,",",2) }
zGetNamespaces(pParams="",pResult="") public {
	// Data needed passed by BSTSWS array required for call	
	Set tDebug=$Get(pParams("DEBUG"))
	Set tURLRoot=$Get(pParams("URLROOT"))
	Set tServiceURLPath=$Get(pParams("SERVICEPATH"))
	Set tServicePort=$Get(pParams("PORT"))
	Set tWebServiceTimeout=$Get(pParams("TIMEOUT"))
	Set tUserName=$Get(pParams("USER"))
	Set tPassword=$Get(pParams("PASS"))
	Set tSSLConfiguration=$Get(pParams("SSL"))
	Set tConnectionTimeout=$Get(pParams("CTIME"))
	//Get location
	//BEE;BSTS*1.0*2;Changed location logic
	//Set tLocation=tURLRoot_":"_tServicePort_tServiceURLPath_"/DtsQueryDaoService/DtsQueryDaoWS"
	Set tLocation=tURLRoot_":"_tServicePort_tServiceURLPath_"/DtsQueryDaoWS"
	Set tStatus=0
	Set tSC=##class(%Library.ListOfObjects).%New()
	// Initialize new web client to make the SOAP call
	Set tWebClient=##class(BSTS.DtsQueryDaoPort).%New()
	Set tWebClient.Location=tLocation
	Set tWebClient.HttpUsername=tUserName
	Set tWebClient.HttpPassword=tPassword
	Set tWebClient.Timeout=tWebServiceTimeout
	Set tWebClient.OpenTimeout=tConnectionTimeout
	If ((tLocation["https://")&(tSSLConfiguration]"")) {	
		Set tWebClient.SSLConfiguration=tSSLConfiguration
    	Set tWebClient.HttpProxySSLConnect=0
	}
	Set tStartTime=$now()
	try {
		Set tSC=tWebClient.getNamespaces()
		If (tDebug) {
			Do $System.OBJ.Dump(tWebClient)
			If $ISOBJECT(tWebClient.HttpResponse) {
				Set tHTTPResponse=##class(%Net.HttpResponse).%New()
				Set tHTTPResponse=tWebClient.HttpResponse
				Set pResult("DEBUG","HTTP_RESPONSE_DATA")=tHTTPResponse.Data
				Set pResult("DEBUG","HTTP_REASON_PHRASE")=tHTTPResponse.ReasonPhrase
				Set pResult("DEBUG","HTTP_HEADERS_DATE")=$Get(tHTTPResponse.Headers("DATE"))
			}
		}
		Set tCounter=0
		For tKey=1:1:tSC.Count() {
			Set tCounter=tCounter+1
			Set tObject=##class(BSTS.ns1.TNamespace).%New()
			Set tObject=tSC.GetAt(tKey)
			If (tDebug) {
				Do $SYSTEM.OBJ.Dump(tObject)
			}
			// Populate the array with some of that data	
			Set pResult(tCounter,"NAMESPACE","NAME")=tObject.name
			Set pResult(tCounter,"NAMESPACE","CODE")=tObject.code
			Set pResult(tCounter,"NAMESPACE","ID")=tObject.id
		}
		Set pResult="1^^"_..GetElapsedTime(tStartTime,$now())
		Set tStatus=pResult
	}
	Catch Exception
	{
		Set tError=""
		Set tErrorText=""
		If ($ZERROR["<ZSOAP>") {
			Set pResult("ERROR","SOAPFAULT","CODE")=tWebClient.SoapFault.faultcode
			Set pResult("ERROR","SOAPFAULT","FAULTSTRING")=tWebClient.SoapFault.faultstring
			Set tError=$System.Status.DecomposeStatus(%objlasterror,.tError)
			Set pResult("ERROR","SOAPFAULT","ERRORSTRING")=$Get(tError(1))
			Set tErrorText=$Get(tError(1))
		} else {
			Set tErrorText=$$Error^%apiOBJ(5002,$ZERROR)
			Set pResult("ERROR","ERRORSTRING")=tErrorText
		}
		If $ISOBJECT(tWebClient.HttpResponse) {
			Set tHTTPResponse=##class(%Net.HttpResponse).%New()
			Set tHTTPResponse=tWebClient.HttpResponse
			Set pResult("ERROR","HTTP_RESPONSE_DATA")=tHTTPResponse.Data
			Set pResult("ERROR","HTTP_REASON_PHRASE")=tHTTPResponse.ReasonPhrase
			Set pResult("ERROR","HTTP_HEADERS_DATE")=$Get(tHTTPResponse.Headers("DATE"))
		}
		Set pResult="0^"_tErrorText_$get(pResult("ERROR","HTTP_REASON_PHRASE"))_"^"_..GetElapsedTime(tStartTime,$now())	
		Set tStatus=pResult
	}
	Quit tStatus }
zGetVersions(pParams) public {
	// Data needed passed by BSTSWS array required for call	
	Set tDebug=$Get(pParams("DEBUG"))
	Set tURLRoot=$Get(pParams("URLROOT"))
	Set tServiceURLPath=$Get(pParams("SERVICEPATH"))
	Set tServicePort=$Get(pParams("PORT"))
	Set tWebServiceTimeout=2    //Hardset to 2 seconds // $Get(pParams("TIMEOUT"))
	Set tUserName=$Get(pParams("USER"))
	Set tPassword=$Get(pParams("PASS"))
	Set tSSLConfiguration=$Get(pParams("SSL"))
	Set tNamespaceID=$Get(pParams("NAMESPACEID"))
	Set tConnectionTimeout=$Get(pParams("CTIME"))
	//Get location
	//BEE;BSTS*1.0*2;Changed location logic
	//Set tLocation=tURLRoot_":"_tServicePort_tServiceURLPath_"/NamespaceDaoService/NamespaceDaoWS"
	//Set tLocation=tURLRoot_":"_tServicePort_tServiceURLPath_"/DtsQueryDaoService/DtsQueryDaoWS"
	Set tLocation=tURLRoot_":"_tServicePort_tServiceURLPath_"/DtsQueryDaoWS"
	Set tStatus=0
	Set tSC=##class(%Library.ListOfObjects).%New()
	// Initialize new web client to make the SOAP call
	Set tWebClient=##class(BSTS.DtsQueryDaoPort).%New()
	Set tWebClient.Location=tLocation
	Set tWebClient.HttpUsername=tUserName
	Set tWebClient.HttpPassword=tPassword
	Set tWebClient.Timeout=tWebServiceTimeout
	Set tWebClient.OpenTimeout=tConnectionTimeout
	If ((tLocation["https://")&(tSSLConfiguration]"")) {	
		Set tWebClient.SSLConfiguration=tSSLConfiguration
    	Set tWebClient.HttpProxySSLConnect=0
	}
	Set tStartTime=$now()
	try {
		Set tSC=tWebClient.getVersions(tNamespaceID)
		If (tDebug) {
			// Write tWebClient.HttpResult,!
			Do $System.OBJ.Dump(tWebClient)
			If $ISOBJECT(tWebClient.HttpResponse) {
				Set tHTTPResponse=##class(%Net.HttpResponse).%New()
				Set tHTTPResponse=tWebClient.HttpResponse
				Set pResult("DEBUG","HTTP_RESPONSE_DATA")=tHTTPResponse.Data
				Set pResult("DEBUG","HTTP_REASON_PHRASE")=tHTTPResponse.ReasonPhrase
				Set pResult("DEBUG","HTTP_HEADERS_DATE")=$Get(tHTTPResponse.Headers("DATE"))
			}
		}
		Set tCounter=0
		For tKey=1:1:tSC.Count() {
			Set tCounter=tCounter+1
			Set tObject=##class(BSTS.ns1.TContentVersion).%New()
			Set tObject=tSC.GetAt(tKey)
			If (tDebug) {
				Do $SYSTEM.OBJ.Dump(tObject)
			}
			// Populate the array with some of that data	
			If ((tObject.id)]"") {
				Set ^TMP("BSTSCMCL",$job,tCounter,"VERSION",tObject.id,"NAME")=tObject.name
				Set ^TMP("BSTSCMCL",$job,tCounter,"VERSION",tObject.id,"RELEASEDATE")=tObject.releaseDate
				Set ^TMP("BSTSCMCL",$job,tCounter,"VERSION",tObject.id,"NAMESPACEID")=tNamespaceID
			}
		}
		Set pResult="1^^"_..GetElapsedTime(tStartTime,$now())
		Set tStatus=pResult
	}
	Catch Exception
	{
		Set tError=""
		Set tErrorText=""
		If ($ZERROR["<ZSOAP>") {
			Set pResult("ERROR","SOAPFAULT","CODE")=tWebClient.SoapFault.faultcode
			Set pResult("ERROR","SOAPFAULT","FAULTSTRING")=tWebClient.SoapFault.faultstring
			Set tError=$System.Status.DecomposeStatus(%objlasterror,.tError)
			Set pResult("ERROR","SOAPFAULT","ERRORSTRING")=$Get(tError(1))
			Set tErrorText=$Get(tError(1))
		} else {
			Set tErrorText=$$Error^%apiOBJ(5002,$ZERROR)
			Set pResult("ERROR","ERRORSTRING")=tErrorText
		}
		If $ISOBJECT(tWebClient.HttpResponse) {
			Set tHTTPResponse=##class(%Net.HttpResponse).%New()
			Set tHTTPResponse=tWebClient.HttpResponse
			Set pResult("ERROR","HTTP_RESPONSE_DATA")=tHTTPResponse.Data
			Set pResult("ERROR","HTTP_REASON_PHRASE")=tHTTPResponse.ReasonPhrase
			Set pResult("ERROR","HTTP_HEADERS_DATE")=$Get(tHTTPResponse.Headers("DATE"))
		}
		Set pResult="0^"_tErrorText_$get(pResult("ERROR","HTTP_REASON_PHRASE"))_"^"_..GetElapsedTime(tStartTime,$now())	
		Set tStatus=pResult
	}
	Quit tStatus }
zexecuteConceptTextSearch(pParams="",pResult) public {
	// Data needed passed by BSTSWS array required for call
	Set tDebug=$Get(pParams("DEBUG"))
	Set tWebServiceTimeout=$Get(pParams("TIMEOUT"))
	Set tUserName=$Get(pParams("USER"))
	Set tPassword=$Get(pParams("PASS"))
	Set tSSLConfiguration=$Get(pParams("SSL"))
	Set tNamespaceID=$Get(pParams("NAMESPACEID"))
	Set tSearchPattern=$Get(pParams("SEARCH"))
	Set SearchConvert=""
	For piece=1:1:$L(tSearchPattern,"'") {
		Set string=$Piece(tSearchPattern,"'",piece)
		Set SearchConvert=SearchConvert_$Select(piece>1:"''",1:"")_string
	}
	Set tSearchPattern=SearchConvert
	Set tSnapshotDate=$Get(pParams("SNAPDT"))
	Set tEpochDt=$$EXDT2EP^BSTSUTIL($P(tSnapshotDate," ",1,2))
	Set tSType=$Get(pParams("STYPE"))
	Set tSubset=$Get(pParams("SUBSET"))
	Set tExactMatch=$Get(pParams("EXACTMATCH"))
	Set tConnectionTimeout=$Get(pParams("CTIME"))
	//Assemble subset
	Set SubsetList=""
	For piece=1:1:$L(tSubset,"~") {
		Set sub=$Piece(tSubset,"~",piece)
		If sub]"" {
			Set SubsetList = SubsetList_$Select(SubsetList]"":",",1:"")_"'"_sub_"'"
		}	
	}
	//Handle maximum records - need to increase for FSN searches due to duplicates returned
	Set tMaxResults=$Get(pParams("MAXRECS")) If tMaxResults="" Set tMaxResults=25
	//Set up location
	//BEE;BSTS*1.0*2;Changed location logic
	//Set tLocation=$Get(pParams("URLROOT"))_":"_$Get(pParams("PORT"))_$Get(pParams("SERVICEPATH"))_"/DtsQueryDaoService/DtsQueryDaoWS"
	Set tLocation=$Get(pParams("URLROOT"))_":"_$Get(pParams("PORT"))_$Get(pParams("SERVICEPATH"))_"/DtsQueryDaoWS"
	Set tStatus=0
	Set pResult=1	
    //New search definition
    Set SQLSearch="DECLARE @RC int,"
    Set SQLSearch=SQLSearch_" @Searchtext nvarchar(2000) = '"_tSearchPattern_"',"    
	Set SQLSearch=SQLSearch_" @NumRecs int = "_tMaxResults_","
    Set SQLSearch=SQLSearch_" @Namespace varchar(10) = '"_tNamespaceID_"',"
    Set SQLSearch=SQLSearch_" @Exactmatch varchar(2) = '"_tExactMatch_"',"
    Set SQLSearch=SQLSearch_" @Subsets nvarchar(2000) = "
    //Put in subsets
    If (tNamespaceID=36)!(tNamespaceID=1552) {
	    Set SQLSearch=SQLSearch_"'"_$TR(SubsetList,"'")_"',"
    }
    If (tNamespaceID'=36),(tNamespaceID'=1552) {
	    Set SQLSearch=SQLSearch_"'',"
    }
	Set SQLSearch=SQLSearch_" @Status varchar(2) = 'A',"
    Set SQLSearch=SQLSearch_" @Revision_In datetime = '"_tSnapshotDate_"'"
	Set SQLSearch=SQLSearch_" EXECUTE @RC = [dbo].[dts_searchconcepts_cond]"
   	Set SQLSearch=SQLSearch_" @Searchtext,"
   	Set SQLSearch=SQLSearch_" @NumRecs,"
   	Set SQLSearch=SQLSearch_" @Namespace,"
   	Set SQLSearch=SQLSearch_" @Subsets,"
   	Set SQLSearch=SQLSearch_" @Status,"
   	Set SQLSearch=SQLSearch_" @Revision_In,"
   	Set SQLSearch=SQLSearch_" @Exactmatch"
	I $Get(tDebug) {
		Write !!,"SQL Call: ",SQLSearch,!
	}
	/*
	//BEE;BSTS*1.0*2;Old web service call no longer available with p4.2
	//               Switching to different call
    //---------------------------------------------------------------------------	
	Set tAttributeSetDesc=##class(BSTS.ns1.TConceptAttributeSetDescriptor).%New()
	Set tAttributeSetDesc.DEFAULTLIMIT=0
	Set tAttributeSetDesc.allPropertyTypes="false"
	Set tAttributeSetDesc.allSynonymTypes="false"
	Set tAttributeSetDesc.allInverseRoleTypes="false"
	Set tAttributeSetDesc.allRoleTypes="false"
	Set tAttributeSetDesc.attributesLimit="100"
	Set tAttributeSetDesc.definedViewAttributes="false"
	Set tAttributeSetDesc.queryHasSubs="0"
	Set tAttributeSetDesc.queryHasSups="0"
	Set tAttributeSetDesc.subconcepts="0"
	Set tAttributeSetDesc.superconcepts="false"
	// Initialize new web client to make the SOAP call
	Set tWebClient=##class(BSTS.DtsQueryDaoPort).%New()
	Set tWebClient.Location=tLocation
	Set tWebClient.HttpUsername=tUserName
	Set tWebClient.HttpPassword=tPassword
	Set tWebClient.Timeout=tWebServiceTimeout
	Set tWebClient.OpenTimeout=tConnectionTimeout
	If ((tLocation["https://")&(tSSLConfiguration]"")) {	
		Set tWebClient.SSLConfiguration=tSSLConfiguration
    	Set tWebClient.HttpProxySSLConnect=0
	}
	Set tStartTime=$now()
	// Setup response
	Set tSC=##class(%ListOfObjects).%New()
	try {
		Set tSC=tWebClient.executeConceptTextSearch(SQLSearch,tAttributeSetDesc)
		If (tDebug) {
			Do $System.OBJ.Dump(tWebClient)
			If $ISOBJECT(tWebClient.HttpResponse) {
				Set tHTTPResponse=##class(%Net.HttpResponse).%New()
				Set tHTTPResponse=tWebClient.HttpResponse
				Set pResult("DEBUG","HTTP_RESPONSE_DATA")=tHTTPResponse.Data
				Set pResult("DEBUG","HTTP_REASON_PHRASE")=tHTTPResponse.ReasonPhrase
				Set pResult("DEBUG","HTTP_HEADERS_DATE")=$Get(tHTTPResponse.Headers("DATE"))
			}
			Set tHttpHeadersOut=##class(%ArrayOfObjects).%New()
			Set tHttpHeadersOut=tWebClient.HeadersOut
			For key=1:1:tHttpHeadersOut.Count() {
			}
		}
	}
	Catch Exception
	{
		Set tError=""
		Set tErrorText=""
		If ($ZERROR["<ZSOAP>") {
			Set pResult("ERROR","SOAPFAULT","executeConceptTextSearch","CODE")=tWebClient.SoapFault.faultcode
			Set pResult("ERROR","SOAPFAULT","executeConceptTextSearch","FAULTSTRING")=tWebClient.SoapFault.faultstring
			Set tError=$System.Status.DecomposeStatus(%objlasterror,.tError)
			Set pResult("ERROR","SOAPFAULT","executeConceptTextSearch","ERRORSTRING")=$Get(tError(1))
			Set tErrorText=$Get(tError(1))
		} else {
			Set tErrorText=$$$ERROR($$$CacheError,$ZERROR)
			Set pResult("ERROR","ERRORSTRING")=tErrorText
		}
		If $ISOBJECT(tWebClient.HttpResponse) {
			Set tHTTPResponse=##class(%Net.HttpResponse).%New()
			Set tHTTPResponse=tWebClient.HttpResponse
			Set pResult("ERROR","executeConceptTextSearch","HTTP_RESPONSE_DATA")=tHTTPResponse.Data
			Set pResult("ERROR","executeConceptTextSearch","HTTP_REASON_PHRASE")=tHTTPResponse.ReasonPhrase
			Set pResult("ERROR","executeConceptTextSearch","HTTP_HEADERS_DATE")=$Get(tHTTPResponse.Headers("DATE"))
		}
		Set pResult="0^"_tErrorText_$get(pResult("ERROR","HTTP_REASON_PHRASE"))_"^"_..GetElapsedTime(tStartTime,$now())	
		Set tStatus=pResult
	}
	// If the result of the web call was an error - Quit now. 
	If ($Piece(pResult,"^",1)=0) Quit tStatus
	//Display results returned
	If $Get(tDebug) {
		Write !,tSearchPattern," results returned: ",tSC.Count()
	}
	// Web call completed. Parse response...
	Set tCount=tSC.Count()
	//Reset array to screen out duplicates
	Kill ConceptList
	Set tCounter=0
	For tKey=1:1:tCount {
		Set tResult=##class(BSTS.ns1.TConceptSearchResult).%New()
		Set tResult=tSC.GetAt(tKey)
		Set tInfo=##class(BSTS.ns1.TOntylogConcept).%New()
		Set tInfo=tResult.ontylogConcept
		Set Term=tInfo.name
		Set DTSId=tInfo.id
		If DTSId>0 {
			If '$D(ConceptList(DTSId)) {
				Set tCounter=tCounter+1
				Set ^TMP("BSTSCMCL",$job,tCounter)=DTSId_"^^"_Term
				Set ConceptList(DTSId)=""
			}
		}
	}
	*/
	// Initialize new web client to make the SOAP call
	Set tWebClient=##class(BSTS.DtsQueryDaoPort).%New()
	Set tWebClient.Location=tLocation
	Set tWebClient.HttpUsername=tUserName
	Set tWebClient.HttpPassword=tPassword
	Set tWebClient.Timeout=tWebServiceTimeout
	Set tWebClient.OpenTimeout=tConnectionTimeout
	If ((tLocation["https://")&(tSSLConfiguration]"")) {	
		Set tWebClient.SSLConfiguration=tSSLConfiguration
    	Set tWebClient.HttpProxySSLConnect=0
	}
	Set tStartTime=$now()
	// Setup response
	Set tSC=##class(%Library.ListOfObjects).%New()
	try {
		Set tSC=tWebClient.executeSQL(SQLSearch)
		If (tDebug) {
			Do $System.OBJ.Dump(tWebClient)
			If $ISOBJECT(tWebClient.HttpResponse) {
				Set tHTTPResponse=##class(%Net.HttpResponse).%New()
				Set tHTTPResponse=tWebClient.HttpResponse
				Set pResult("DEBUG","HTTP_RESPONSE_DATA")=tHTTPResponse.Data
				Set pResult("DEBUG","HTTP_REASON_PHRASE")=tHTTPResponse.ReasonPhrase
				Set pResult("DEBUG","HTTP_HEADERS_DATE")=$Get(tHTTPResponse.Headers("DATE"))
			}
			Set tHttpHeadersOut=##class(%Library.ArrayOfObjects).%New()
			Set tHttpHeadersOut=tWebClient.HeadersOut
			For key=1:1:tHttpHeadersOut.Count() {
			}
		}
	}
	Catch Exception
	{
		Set tError=""
		Set tErrorText=""
		If ($ZERROR["<ZSOAP>") {
			Set pResult("ERROR","SOAPFAULT","executeSQL","CODE")=tWebClient.SoapFault.faultcode
			Set pResult("ERROR","SOAPFAULT","executeSQL","FAULTSTRING")=tWebClient.SoapFault.faultstring
			Set tError=$System.Status.DecomposeStatus(%objlasterror,.tError)
			Set pResult("ERROR","SOAPFAULT","executeSQL","ERRORSTRING")=$Get(tError(1))
			Set tErrorText=$Get(tError(1))
		} else {
			Set tErrorText=$$Error^%apiOBJ(5002,$ZERROR)
			Set pResult("ERROR","ERRORSTRING")=tErrorText
		}
		If $ISOBJECT(tWebClient.HttpResponse) {
			Set tHTTPResponse=##class(%Net.HttpResponse).%New()
			Set tHTTPResponse=tWebClient.HttpResponse
			Set pResult("ERROR","executeSQL","HTTP_RESPONSE_DATA")=tHTTPResponse.Data
			Set pResult("ERROR","executeSQL","HTTP_REASON_PHRASE")=tHTTPResponse.ReasonPhrase
			Set pResult("ERROR","executeSQL","HTTP_HEADERS_DATE")=$Get(tHTTPResponse.Headers("DATE"))
		}
		Set pResult="0^"_tErrorText_$get(pResult("ERROR","HTTP_REASON_PHRASE"))_"^"_..GetElapsedTime(tStartTime,$now())	
		Set tStatus=pResult
	}
	// If the result of the web call was an error - Quit now. 
	If ($Piece(pResult,"^",1)=0) Quit tStatus
	//Display results returned
	If $Get(tDebug) {
		Write !,tSearchPattern," results returned: ",tSC.Count()
	}
	// Web call completed. Parse response...
	Set tCount=tSC.Count()
	Set tCounter=0
	For tKey=1:1:tCount {
		Set tResult=##class(BSTS.ns2.stringArray).%New()
		Set tResult=tSC.GetAt(tKey)
		Set ConcId=tResult.item.GetAt(6)
		Set Term=tResult.item.GetAt(5)
		Set DTSId=tResult.item.GetAt(4)
		If $Get(tDebug) {
			W !!,"#: ",tKey
			W !,"ConcId: ",ConcId
			W !,"Term: ",Term
			W !,"DTSId: ",DTSId
		}
		//Save entry
		If DTSId>0 {
			Set tCounter=tCounter+1
			Set ^TMP("BSTSCMCL",$job,tCounter)=DTSId_"^"_Term_"^"
		}
	}
	//End Here - instead of parsing
	Quit 1_"^^"_..GetElapsedTime(tStartTime,$now()) }
zfindConceptsWithPropMatch(pParams="",pResult) public {
	// Data passed into pParams via the BSTSWS array
	Set tDebug=$Get(pParams("DEBUG"))
	Set tWebServiceTimeout=$Get(pParams("TIMEOUT"))
	Set tUserName=$Get(pParams("USER"))
	Set tPassword=$Get(pParams("PASS"))
	Set tSSLConfiguration=$Get(pParams("SSL"))
	Set tNamespaceID=$Get(pParams("NAMESPACEID"))
	Set tSearchPattern=$Get(pParams("SEARCH"))
	Set tSnapshotDate=$Get(pParams("SNAPDT"))
	Set tMaxResults=$Get(pParams("MAXRECS")) S tMaxResults=100
	//Get location
	//BEE;BSTS*1.0*2;Changed location logic
	//Set tLocation=$Get(pParams("URLROOT"))_":"_$Get(pParams("PORT"))_$Get(pParams("SERVICEPATH"))_"/DtsQueryDaoService/DtsQueryDaoWS"
	Set tLocation=$Get(pParams("URLROOT"))_":"_$Get(pParams("PORT"))_$Get(pParams("SERVICEPATH"))_"/DtsQueryDaoWS"
	Set tConnectionTimeout=$Get(pParams("CTIME"))
	Set tStartTime=$now()
	Set tStatus=0
	Set pResult=1
	// Setup request for search options and attribute set descriptors for initial call
	Set tSearchOptions=##class(BSTS.ns1.TConceptSearchOptions).%New()
	Set tAttributeSetDesc=##class(BSTS.ns1.TConceptAttributeSetDescriptor).%New()
	Set tPropType1=##class(BSTS.ns1.TPropertyType).%New()
	Set tPropType1.namespaceId=tNamespaceID
	Set tPropType1.name="Code in Source"
	Set tPropType1.attachesTo="C"
	Set tSearchOptions.ALLCONTENT="0"
	Set tSearchOptions.DEFAULTLIMIT="0"
	Set tAttributeSetDesc.DEFAULTLIMIT="0"
	Set tAttributeSetDesc.name="ASD Test"
	Set tAttributeSetDesc.attributesLimit="100"
	Set tAttributeSetDesc.allPropertyTypes="false"
	Set tAttributeSetDesc.allAssociationTypes="false"
	Set tAttributeSetDesc.allInverseAssociationTypes="false"
	Set tAttributeSetDesc.allSynonymTypes="false"
	Set tAttributeSetDesc.allRoleTypes="false"
	Set tAttributeSetDesc.allInverseRoleTypes="false"
	Set tAttributeSetDesc.definedViewAttributes="false"
	Set tAttributeSetDesc.queryHasSubs="false"
	Set tAttributeSetDesc.queryHasSups="false"
	Set tAttributeSetDesc.subconcepts="false"
	Set tAttributeSetDesc.superconcepts="false"
	Set tAttributeSetDesc.snapshotDate=tSnapshotDate
	Set tSearchOptions.snapshotDate=tSnapshotDate
	Set tSearchOptions.firstResult="0"
	Set tSearchOptions.limit=tMaxResults
	Set tSearchOptions.subsetSearch="false"
	Set tSearchOptions.contentId=tNamespaceID
	Set tSearchOptions.status=""
	//SNOMED
	if tNamespaceID=36 {
		Set tPropType1.id="12"
	}
	//UNII
	if tNamespaceID=5180 {
		set tPropType1.id="1"
	}
	//RXNORM
	if tNamespaceID=1552 {
		set tPropType1.id="10"
	}
	//ECLID
	if tNamespaceID=32770 {
		set tPropType1.id="1"
	}
	//CPT to RxNorm
	if tNamespaceID=32775 {
		set tPropType1.id="2"
	}
	//32773
	if tNamespaceID=32773 {
		set tPropType1.id="1"
	}
	//32771
	if tNamespaceID=32771 {
		set tPropType1.id="1"
	}
	//32772
	if tNamespaceID=32772 {
		set tPropType1.id="1"
	}
	//32774
	if tNamespaceID=32774 {
		set tPropType1.id="1"
	}
	//32775
	if tNamespaceID=32775 {
		set tPropType1.id="1"
	}
	Do tAttributeSetDesc.propertyTypes.Insert(tPropType1)
	// Initialize new web client to make the SOAP call
	Set tWebClient=##class(BSTS.DtsQueryDaoPort).%New()
	Set tWebClient.Location=tLocation
	Set tWebClient.HttpUsername=tUserName
	Set tWebClient.HttpPassword=tPassword
	Set tWebClient.Timeout=tWebServiceTimeout
	Set tWebClient.OpenTimeout=tConnectionTimeout
	If ((tLocation["https://")&(tSSLConfiguration]"")) {	
		Set tWebClient.SSLConfiguration=tSSLConfiguration
    	Set tWebClient.HttpProxySSLConnect=0
	}
	Set tStartTime=$now()
	If tDebug {
		W !!
		Do $SYSTEM.OBJ.Dump(tAttributeSetDesc)
		Do $SYSTEM.OBJ.Dump(tPropType1)
		Do $SYSTEM.OBJ.Dump(tSearchOptions)
		Do $SYSTEM.OBJ.Dump(tWebClient)
		W !!,"Search Pattern: ",tSearchPattern
	}
	// Setup response
	Set tSC=##class(%Library.ListOfObjects).%New()
	try {
		Set tSC=tWebClient.findConceptsWithPropertyMatching(tPropType1,tSearchPattern,tSearchOptions)
		If tDebug {
			W !!
			Do $SYSTEM.OBJ.Dump(tSC)
		}
		//Assemble return status
		Set tStatus="1^^"_..GetElapsedTime(tStartTime,$now())	
	}
	Catch Exception {
		Set tError=""
		Set tErrorText=""
		If ($ZERROR["<ZSOAP>") {
			Set pResult("ERROR","SOAPFAULT","CODE")=tWebClient.SoapFault.faultcode
			Set pResult("ERROR","SOAPFAULT","FAULTSTRING")=tWebClient.SoapFault.faultstring
			Set tError=$System.Status.DecomposeStatus(%objlasterror,.tError)
			Set pResult("ERROR","SOAPFAULT","ERRORSTRING")=$Get(tError(1))
			Set tErrorText=$Get(tError(1))
		}
		else {
			Set tErrorText=$$Error^%apiOBJ(5002,$ZERROR)
			Set pResult("ERROR","ERRORSTRING")=tErrorText
		}
		Set pResult="0^"_tErrorText_$get(pResult("ERROR","HTTP_REASON_PHRASE"))_"^"_..GetElapsedTime(tStartTime,$now())	
		Set tStatus=pResult
	}
	// Web call completed. Parse response...
	Set tCount=tSC.Count()
	Set tCounter=0
	For tKey=1:1:tCount {
		Set tObject=##class(BSTS.ns1.TOntylogConcept).%New()
		Set tObject=tSC.GetAt(tKey)
		Set tDTSId=tObject.id
		If tDTSId>0 {
			Set tCounter=tCounter+1
			Set ^TMP("BSTSCMCL",$job,tDTSId)=$g(^TMP("BSTSCMCL",$job,tDTSId))+1
		}
		If (tDebug) {
			Write !,$tr(tSearchPattern,"*"),?30,tCounter,?40,tDTSId
		}
	}
	//Assemble return status
	If tCounter>0 {
		Set tStatus="1^^"_..GetElapsedTime(tStartTime,$now())	
	}
	Quit tStatus }
zfindDescWithIdMatch(pParams="",pResult) public {
	// Data passed into pParams via the BSTSWS array
	Set tDebug=$Get(pParams("DEBUG"))
	Set tWebServiceTimeout=$Get(pParams("TIMEOUT"))
	Set tUserName=$Get(pParams("USER"))
	Set tPassword=$Get(pParams("PASS"))
	Set tSSLConfiguration=$Get(pParams("SSL"))
	Set tNamespaceID=$Get(pParams("NAMESPACEID"))
	Set tSearchPattern=$Get(pParams("SEARCH"))
	Set tSnapshotDate=$Get(pParams("SNAPDT"))
	Set tMaxResults=$Get(pParams("MAXRECS")) S tMaxResults=100
	//Get location
	//BEE;BSTS*1.0*2;Changed location logic
	//Set tLocation=$Get(pParams("URLROOT"))_":"_$Get(pParams("PORT"))_$Get(pParams("SERVICEPATH"))_"/DtsQueryDaoService/DtsQueryDaoWS"
	Set tLocation=$Get(pParams("URLROOT"))_":"_$Get(pParams("PORT"))_$Get(pParams("SERVICEPATH"))_"/DtsQueryDaoWS"
	Set tConnectionTimeout=$Get(pParams("CTIME"))
	Set tStartTime=$now()
	Set tStatus=0
	Set pResult=1	
	/*
	//BEE;BSTS*1.0*2;Switching to stored procedure call because DTS v4.2 has a bug
	//               in the call that we were using
	Set tAttributeSetDesc=##class(BSTS.ns1.TTermAttributeSetDescriptor).%New()
	Set tAttributeSetDesc.DEFAULTLIMIT="0"
	Set tAttributeSetDesc.name="asd"
	Set tAttributeSetDesc.snapshotDate=tSnapshotDate
	Set tAttributeSetDesc.allPropertyTypes="false"
	Set tAttributeSetDesc.allSynonymTypes="1"
	Set tAttributeSetDesc.allAssociationTypes="false"
	Set tAttributeSetDesc.allInverseAssociationTypes="false"
	Set tAttributeSetDesc.attributesLimit=100
	If tDebug {
		Do $System.OBJ.Dump(tAttributeSetDesc)
	}
	// Initialize new web client to make the SOAP call
	Set tWebClient=##class(BSTS.DtsQueryDaoPort).%New()
	Set tWebClient.Location=tLocation
	Set tWebClient.HttpUsername=tUserName
	Set tWebClient.HttpPassword=tPassword
	Set tWebClient.Timeout=tWebServiceTimeout
	Set tWebClient.OpenTimeout=tConnectionTimeout
	If ((tLocation["https://")&(tSSLConfiguration]"")) {	
		Set tWebClient.SSLConfiguration=tSSLConfiguration
    	Set tWebClient.HttpProxySSLConnect=0
	}
	Set tStartTime=$now()
	// Setup response
	Set tSC=##class(BSTS.ns1.TTerm).%New()
	try {
		Set tSC=tWebClient.findTermByCode(tSearchPattern, tNamespaceID, tAttributeSetDesc)
		If tDebug {
			W !!
			Do $SYSTEM.OBJ.Dump(tSC)
		}		
	}
	Catch Exception {
		Set tError=""
		Set tErrorText=""
		If ($ZERROR["<ZSOAP>") {
			Set pResult("ERROR","SOAPFAULT","CODE")=tWebClient.SoapFault.faultcode
			Set pResult("ERROR","SOAPFAULT","FAULTSTRING")=tWebClient.SoapFault.faultstring
			Set tError=$System.Status.DecomposeStatus(%objlasterror,.tError)
			Set pResult("ERROR","SOAPFAULT","ERRORSTRING")=$Get(tError(1))
			Set tErrorText=$Get(tError(1))
		}
		else {
			Set tErrorText=$$$ERROR($$$CacheError,$ZERROR)
			Set pResult("ERROR","ERRORSTRING")=tErrorText
		}
		Set pResult="0^"_tErrorText_$get(pResult("ERROR","HTTP_REASON_PHRASE"))_"^"_..GetElapsedTime(tStartTime,$now())	
		Set tStatus=pResult
	}
	If $IsObject(tSC) {
		Set sCount=tSC.synonyms.Count()
		If sCount>0 {
			Set tSynonym=##class(BSTS.ns1.TSynonym).%New()
			Set tSynonym=tSC.synonyms.GetAt(1)
			If tDebug>0 {
				Do $SYSTEM.OBJ.Dump(tSynonym)
			}
			//Get concept info
			Set tConcept=##class(BSTS.ns1.TOntylogConcept).%New()
			Set tConcept=tSynonym.concept
			If tDebug>0 {
				Do $SYSTEM.OBJ.Dump(tConcept)
			}
			Set tId=tConcept.id
			If tId>0 {
				Set ^TMP("BSTSCMCL",$job,1)=tId
				Set tStatus="1^^"_..GetElapsedTime(tStartTime,$now())	
			}
		}
	}
	//End of old lookup logic
	*/	
	//Set up code for Description Id store procedure call
	Set SQLSearch="DECLARE @RC int DECLARE @Namespace varchar(10) = '"
	Set SQLSearch=SQLSearch_tNamespaceID_"'"
	Set SQLSearch=SQLSearch_" DECLARE @DescID varchar(20) = '"
	Set SQLSearch=SQLSearch_tSearchPattern_"' EXEC"
	Set SQLSearch=SQLSearch_" @RC = [dbo].[dts_getDTSIdfromDescId]"
	Set SQLSearch=SQLSearch_" @Namespace, @DescID"
	If $Get(tDebug) {
		Write !!,"SQL Call: ",SQLSearch,!
	}
	// Initialize new web client to make the SOAP call
	Set tWebClient=##class(BSTS.DtsQueryDaoPort).%New()
	Set tWebClient.Location=tLocation
	Set tWebClient.HttpUsername=tUserName
	Set tWebClient.HttpPassword=tPassword
	Set tWebClient.Timeout=tWebServiceTimeout
	Set tWebClient.OpenTimeout=tConnectionTimeout
	If ((tLocation["https://")&(tSSLConfiguration]"")) {	
		Set tWebClient.SSLConfiguration=tSSLConfiguration
    	Set tWebClient.HttpProxySSLConnect=0
	}
	Set tStartTime=$now()
	// Setup response
	Set tSC=##class(%Library.ListOfObjects).%New()
	try {
		Set tSC=tWebClient.executeSQL(SQLSearch)
		If (tDebug) {
			Do $System.OBJ.Dump(tWebClient)
			If $ISOBJECT(tWebClient.HttpResponse) {
				Set tHTTPResponse=##class(%Net.HttpResponse).%New()
				Set tHTTPResponse=tWebClient.HttpResponse
				Set pResult("DEBUG","HTTP_RESPONSE_DATA")=tHTTPResponse.Data
				Set pResult("DEBUG","HTTP_REASON_PHRASE")=tHTTPResponse.ReasonPhrase
				Set pResult("DEBUG","HTTP_HEADERS_DATE")=$Get(tHTTPResponse.Headers("DATE"))
			}
			Set tHttpHeadersOut=##class(%Library.ArrayOfObjects).%New()
			Set tHttpHeadersOut=tWebClient.HeadersOut
			For key=1:1:tHttpHeadersOut.Count() {
			}
		}
		//Assemble return status
		Set tStatus="1^^"_..GetElapsedTime(tStartTime,$now())	
	}
	Catch Exception
	{
		Set tError=""
		Set tErrorText=""
		If ($ZERROR["<ZSOAP>") {
			Set pResult("ERROR","SOAPFAULT","executeSQL","CODE")=tWebClient.SoapFault.faultcode
			Set pResult("ERROR","SOAPFAULT","executeSQL","FAULTSTRING")=tWebClient.SoapFault.faultstring
			Set tError=$System.Status.DecomposeStatus(%objlasterror,.tError)
			Set pResult("ERROR","SOAPFAULT","executeSQL","ERRORSTRING")=$Get(tError(1))
			Set tErrorText=$Get(tError(1))
		} else {
			Set tErrorText=$$Error^%apiOBJ(5002,$ZERROR)
			Set pResult("ERROR","ERRORSTRING")=tErrorText
		}
		If $ISOBJECT(tWebClient.HttpResponse) {
			Set tHTTPResponse=##class(%Net.HttpResponse).%New()
			Set tHTTPResponse=tWebClient.HttpResponse
			Set pResult("ERROR","executeSQL","HTTP_RESPONSE_DATA")=tHTTPResponse.Data
			Set pResult("ERROR","executeSQL","HTTP_REASON_PHRASE")=tHTTPResponse.ReasonPhrase
			Set pResult("ERROR","executeSQL","HTTP_HEADERS_DATE")=$Get(tHTTPResponse.Headers("DATE"))
		}
		Set pResult="0^"_tErrorText_$get(pResult("ERROR","HTTP_REASON_PHRASE"))_"^"_..GetElapsedTime(tStartTime,$now())	
		Set tStatus=pResult
	}
	// If the result of the web call was an error - Quit now. 
	If ($Piece(pResult,"^",1)=0) Quit tStatus
	//Display results returned
	If $Get(tDebug) {
		Write !,tSearchPattern," results returned: ",tSC.Count()
	}
	// Web call completed. Parse response...
	Set tCount=tSC.Count()
	Set tCounter=0
	For tKey=1:1:tCount {
		Set tResult=##class(BSTS.ns2.stringArray).%New()
		Set tResult=tSC.GetAt(tKey)
		Set DTSId=tResult.item.GetAt(1)
		If $Get(tDebug) {
			W !!,"#: ",tKey
			W !,"DTSId: ",DTSId
		}
		//Save entry
		If DTSId>0 {
			Set ^TMP("BSTSCMCL",$job,1)=DTSId
			Set tStatus="1^^"_..GetElapsedTime(tStartTime,$now())
		}
	}
	Quit tStatus }
zfindTermsByName(pParams="",pResult) public {
	// Data passed into pParams via the BSTSWS array
	Set tDebug=$Get(pParams("DEBUG"))
	Set tWebServiceTimeout=$Get(pParams("TIMEOUT"))
	Set tUserName=$Get(pParams("USER"))
	Set tPassword=$Get(pParams("PASS"))
	Set tSSLConfiguration=$Get(pParams("SSL"))
	Set tNamespaceID=$Get(pParams("NAMESPACEID"))
	Set tSearchPattern=$Get(pParams("SEARCH"))
	Set tSnapshotDate=$Get(pParams("SNAPDT"))
	Set tMaxResults=$Get(pParams("MAXRECS")) S tMaxResults=100
	//Get location
	//BEE;BSTS*1.0*2;Changed location logic
	//Set tLocation=$Get(pParams("URLROOT"))_":"_$Get(pParams("PORT"))_$Get(pParams("SERVICEPATH"))_"/DtsQueryDaoService/DtsQueryDaoWS"
	Set tLocation=$Get(pParams("URLROOT"))_":"_$Get(pParams("PORT"))_$Get(pParams("SERVICEPATH"))_"/DtsQueryDaoWS"
	Set tConnectionTimeout=$Get(pParams("CTIME"))
	Set tStartTime=$now()
	Set tStatus=0
	Set pResult=1
	// Setup request for search options and attribute set descriptors for initial call
	Set tSearchOptions=##class(BSTS.ns1.TTermSearchOptions).%New()
	Set tAttributeSetDesc=##class(BSTS.ns1.TTermAttributeSetDescriptor).%New()
	Set tSearchOptions.snapshotDate=tSnapshotDate	
	Set tAttributeSetDesc.name="Asd7"
	Set tAttributeSetDesc.allPropertyTypes="1"
	Set tAttributeSetDesc.allSynonymTypes="1"
	Set tAttributeSetDesc.allTermAssociationTypes="1"
	Set tAttributeSetDesc.inverseTermAssociationTypes="1"
	Set tAttributeSetDesc.DEFAULTLIMIT=0
	Set tAttributeSetDesc.attributesLimit=10000
	Set tSearchOptions.firstResult="0"
	Set tSearchOptions.limit=100
	Set tSearchOptions.namespaceId=tNamespaceID
	Set tSearchOptions.status="A"
	Set tSearchOptions.firstResult="0"
	Set tSearchOptions.limit=tMaxResults
	Set tSearchOptions.namespaceId=tNamespaceID
	Set tSearchOptions.status="A"
	// Initialize new web client to make the SOAP call
	Set tWebClient=##class(BSTS.DtsQueryDaoPort).%New()
	Set tWebClient.Location=tLocation
	Set tWebClient.HttpUsername=tUserName
	Set tWebClient.HttpPassword=tPassword
	Set tWebClient.Timeout=tWebServiceTimeout
	Set tWebClient.OpenTimeout=tConnectionTimeout
	If ((tLocation["https://")&(tSSLConfiguration]"")) {	
		Set tWebClient.SSLConfiguration=tSSLConfiguration
    	Set tWebClient.HttpProxySSLConnect=0
	}
	Set tStartTime=$now()
	// Setup response
	Set tSC=##class(%Library.ListOfObjects).%New()
	try {
		Set tSC=tWebClient.findTermsWithNameMatching(tSearchPattern,tSearchOptions)
		If tDebug {
			W !!
			Do $SYSTEM.OBJ.Dump(tSC)
		}
		//Assemble return status
		Set tStatus="1^^"_..GetElapsedTime(tStartTime,$now())			
	}
	Catch Exception {
		Set tError=""
		Set tErrorText=""
		If ($ZERROR["<ZSOAP>") {
			Set pResult("ERROR","SOAPFAULT","CODE")=tWebClient.SoapFault.faultcode
			Set pResult("ERROR","SOAPFAULT","FAULTSTRING")=tWebClient.SoapFault.faultstring
			Set tError=$System.Status.DecomposeStatus(%objlasterror,.tError)
			Set pResult("ERROR","SOAPFAULT","ERRORSTRING")=$Get(tError(1))
			Set tErrorText=$Get(tError(1))
		}
		else {
			Set tErrorText=$$Error^%apiOBJ(5002,$ZERROR)
			Set pResult("ERROR","ERRORSTRING")=tErrorText
		}
		Set pResult="0^"_tErrorText_$get(pResult("ERROR","HTTP_REASON_PHRASE"))_"^"_..GetElapsedTime(tStartTime,$now())	
		Set tStatus=pResult
	}
	// Web call completed. Parse response...
	Set tCount=tSC.Count()
	Set tCounter=0
	For tKey=1:1:tCount {
		Set tObject=##class(BSTS.ns1.TTerm).%New()
		Set tObject=tSC.GetAt(tKey)
		If tDebug {
			Do $SYSTEM.OBJ.Dump(tObject)
		}
		Set code=tObject.code
		Set rin=tObject.revisionIn
		Set rout=tObject.revisionOut
		if tDebug {
			W !!,"Code: ",code,?20,"Add date: ",rin,?48,"Retire date: ",rout
		}
		If code]"" {
			Set tCounter=tCounter+1
			Set ^TMP("BSTSCMCL",$job,tCounter)=code_"^"_rin_"^"_rout
		}
	}
	//Assemble return status
	If tCounter>0 {
		Set tStatus="1^^"_..GetElapsedTime(tStartTime,$now())	
	}
	Quit tStatus }
zgetAllRxNormSubsetConcepts(pParams="",pResult) public {
	//BSTS*1.0*8;Get list of all concepts that are in subsets besides RXNO SRCH Drug Ingredients All
	// Data needed passed by BSTSWS array required for call
	Set tDebug=$Get(pParams("DEBUG"))
	Set tWebServiceTimeout=600   //Override default
	Set tUserName=$Get(pParams("USER"))
	Set tPassword=$Get(pParams("PASS"))
	Set tSSLConfiguration=$Get(pParams("SSL"))
	Set tNamespaceID=1552
	Set tRevIn=$Get(pParams("REVIN"))
	Set tSearchPattern=$Get(pParams("SEARCH"))
	Set tSnapshotDate=$Get(pParams("SNAPDT"))
	Set tSType=$Get(pParams("STYPE"))
	Set tSubset=$Get(pParams("SUBSET"))
	Set tExactMatch=$Get(pParams("EXACTMATCH"))
	Set tConnectionTimeout=$Get(pParams("CTIME"))
	//Reset scratch global
	Kill ^TMP("BSTSCMCL",$job)
	//Set up location
	//Set tLocation=$Get(pParams("URLROOT"))_":"_$Get(pParams("PORT"))_$Get(pParams("SERVICEPATH"))_"/DtsQueryDaoService/DtsQueryDaoWS"
	Set tLocation=$Get(pParams("URLROOT"))_":"_$Get(pParams("PORT"))_$Get(pParams("SERVICEPATH"))_"/DtsQueryDaoWS"
	Set tStatus=0
	Set pResult=1	
	//Put together the definition	
	Set SQLSearch="DECLARE @return_value int "
	Set SQLSearch=SQLSearch_"EXEC    @return_value = [dbo].[dts_all_concepts_with_property_not_in_value_option]"
    Set SQLSearch=SQLSearch_" @Property_Name = N'IHS Subsets', @Property_Value = N'RXNO SRCH Drug Ingredients All',"
    Set SQLSearch=SQLSearch_" @ReturnNotInValue = N'T', @Namespace = N'"_tNamespaceID_"', @Status = N'A', @Revision_In = N'"
	Set SQLSearch=SQLSearch_tRevIn_"' SELECT 'Return Value' = @return_value"	
	If $Get(tDebug) {
		Write !!,"SQL Call: ",SQLSearch,!
	}
	// Initialize new web client to make the SOAP call
	Set tWebClient=##class(BSTS.DtsQueryDaoPort).%New()
	Set tWebClient.Location=tLocation
	Set tWebClient.HttpUsername=tUserName
	Set tWebClient.HttpPassword=tPassword
	Set tWebClient.Timeout=tWebServiceTimeout
	Set tWebClient.OpenTimeout=tConnectionTimeout
	If ((tLocation["https://")&(tSSLConfiguration]"")) {	
		Set tWebClient.SSLConfiguration=tSSLConfiguration
    	Set tWebClient.HttpProxySSLConnect=0
	}
	Set tStartTime=$now()
	// Setup response
	Set tSC=##class(%Library.ListOfObjects).%New()
	try {
		Set tSC=tWebClient.executeSQL(SQLSearch)
		If (tDebug) {
			Do $System.OBJ.Dump(tWebClient)
			If $ISOBJECT(tWebClient.HttpResponse) {
				Set tHTTPResponse=##class(%Net.HttpResponse).%New()
				Set tHTTPResponse=tWebClient.HttpResponse
				Set pResult("DEBUG","HTTP_RESPONSE_DATA")=tHTTPResponse.Data
				Set pResult("DEBUG","HTTP_REASON_PHRASE")=tHTTPResponse.ReasonPhrase
				Set pResult("DEBUG","HTTP_HEADERS_DATE")=$Get(tHTTPResponse.Headers("DATE"))
			}
			Set tHttpHeadersOut=##class(%Library.ArrayOfObjects).%New()
			Set tHttpHeadersOut=tWebClient.HeadersOut
			For key=1:1:tHttpHeadersOut.Count() {
			}
		}
	}
	Catch Exception
	{
		Set tError=""
		Set tErrorText=""
		If ($ZERROR["<ZSOAP>") {
			Set pResult("ERROR","SOAPFAULT","executeSQL","CODE")=tWebClient.SoapFault.faultcode
			Set pResult("ERROR","SOAPFAULT","executeSQL","FAULTSTRING")=tWebClient.SoapFault.faultstring
			Set tError=$System.Status.DecomposeStatus(%objlasterror,.tError)
			Set pResult("ERROR","SOAPFAULT","executeSQL","ERRORSTRING")=$Get(tError(1))
			Set tErrorText=$Get(tError(1))
		} else {
			Set tErrorText=$$Error^%apiOBJ(5002,$ZERROR)
			Set pResult("ERROR","ERRORSTRING")=tErrorText
		}
		If $ISOBJECT(tWebClient.HttpResponse) {
			Set tHTTPResponse=##class(%Net.HttpResponse).%New()
			Set tHTTPResponse=tWebClient.HttpResponse
			Set pResult("ERROR","executeSQL","HTTP_RESPONSE_DATA")=tHTTPResponse.Data
			Set pResult("ERROR","executeSQL","HTTP_REASON_PHRASE")=tHTTPResponse.ReasonPhrase
			Set pResult("ERROR","executeSQL","HTTP_HEADERS_DATE")=$Get(tHTTPResponse.Headers("DATE"))
		}
		Set pResult="0^"_tErrorText_$get(pResult("ERROR","HTTP_REASON_PHRASE"))_"^"_..GetElapsedTime(tStartTime,$now())	
		Set tStatus=pResult
	}
	// If the result of the web call was an error - Quit now. 
	If ($Piece(pResult,"^",1)=0) Quit tStatus
	//Display results returned
	If $Get(tDebug) {
		Write !,tSearchPattern," results returned: ",tSC.Count()
	}
	// Web call completed. Parse response...
	Set tCount=tSC.Count()
	Set tCounter=0
	For tKey=1:1:tCount {
		Set tResult=##class(BSTS.ns2.stringArray).%New()
		Set tResult=tSC.GetAt(tKey)
		Set ItemList=tResult.item.GetAt(1)
		If $Get(tDebug) {
			W !,"Items#: ",ItemList
		}
		//Save entries
		For Item=1:1:$L(ItemList,",") {
			Set DTSId=$P(ItemList,",",Item)
			If DTSId]"" {
				Set tCounter=tCounter+1
				Set ^TMP("BSTSCMCL",$job,tCounter)=DTSId
				Set ^TMP("BSTSCMCL",$job,"DTS",DTSId)=tCounter
			}	
		}
	}
	//End Here - instead of parsing
	Quit 1_"^^"_..GetElapsedTime(tStartTime,$now()) }
zgetAllSubsetConcepts(pParams="",pResult) public {
	//BSTS*1.0*7;Get list of all concepts that are in subsets besides IHS PROBLEM ALL SNOMED
	// Data needed passed by BSTSWS array required for call
	Set tDebug=$Get(pParams("DEBUG"))
	Set tWebServiceTimeout=600   //Override default
	Set tUserName=$Get(pParams("USER"))
	Set tPassword=$Get(pParams("PASS"))
	Set tSSLConfiguration=$Get(pParams("SSL"))
	Set tNamespaceID=36
	Set tRevIn=$Get(pParams("REVIN"))
	Set tSearchPattern=$Get(pParams("SEARCH"))
	Set tSnapshotDate=$Get(pParams("SNAPDT"))
	Set tSType=$Get(pParams("STYPE"))
	Set tSubset=$Get(pParams("SUBSET"))
	Set tExactMatch=$Get(pParams("EXACTMATCH"))
	Set tConnectionTimeout=$Get(pParams("CTIME"))
	//Reset scratch global
	Kill ^TMP("BSTSCMCL",$job)
	//Set up location
	//Set tLocation=$Get(pParams("URLROOT"))_":"_$Get(pParams("PORT"))_$Get(pParams("SERVICEPATH"))_"/DtsQueryDaoService/DtsQueryDaoWS"
	Set tLocation=$Get(pParams("URLROOT"))_":"_$Get(pParams("PORT"))_$Get(pParams("SERVICEPATH"))_"/DtsQueryDaoWS"
	Set tStatus=0
	Set pResult=1	
	//Put together the definition	
	Set SQLSearch="DECLARE @return_value int "
	Set SQLSearch=SQLSearch_"EXEC    @return_value = [dbo].[dts_all_concepts_with_property_not_in_value_option]"
    Set SQLSearch=SQLSearch_" @Property_Name = N'IHS Subsets', @Property_Value = N'IHS PROBLEM ALL SNOMED',"
    Set SQLSearch=SQLSearch_" @ReturnNotInValue = N'T', @Namespace = N'36', @Status = N'A', @Revision_In = N'"
	Set SQLSearch=SQLSearch_tRevIn_"' SELECT 'Return Value' = @return_value"	
	If $Get(tDebug) {
		Write !!,"SQL Call: ",SQLSearch,!
	}
	// Initialize new web client to make the SOAP call
	Set tWebClient=##class(BSTS.DtsQueryDaoPort).%New()
	Set tWebClient.Location=tLocation
	Set tWebClient.HttpUsername=tUserName
	Set tWebClient.HttpPassword=tPassword
	Set tWebClient.Timeout=tWebServiceTimeout
	Set tWebClient.OpenTimeout=tConnectionTimeout
	If ((tLocation["https://")&(tSSLConfiguration]"")) {	
		Set tWebClient.SSLConfiguration=tSSLConfiguration
    	Set tWebClient.HttpProxySSLConnect=0
	}
	Set tStartTime=$now()
	// Setup response
	Set tSC=##class(%Library.ListOfObjects).%New()
	try {
		Set tSC=tWebClient.executeSQL(SQLSearch)
		If (tDebug) {
			Do $System.OBJ.Dump(tWebClient)
			If $ISOBJECT(tWebClient.HttpResponse) {
				Set tHTTPResponse=##class(%Net.HttpResponse).%New()
				Set tHTTPResponse=tWebClient.HttpResponse
				Set pResult("DEBUG","HTTP_RESPONSE_DATA")=tHTTPResponse.Data
				Set pResult("DEBUG","HTTP_REASON_PHRASE")=tHTTPResponse.ReasonPhrase
				Set pResult("DEBUG","HTTP_HEADERS_DATE")=$Get(tHTTPResponse.Headers("DATE"))
			}
			Set tHttpHeadersOut=##class(%Library.ArrayOfObjects).%New()
			Set tHttpHeadersOut=tWebClient.HeadersOut
			For key=1:1:tHttpHeadersOut.Count() {
			}
		}
	}
	Catch Exception
	{
		Set tError=""
		Set tErrorText=""
		If ($ZERROR["<ZSOAP>") {
			Set pResult("ERROR","SOAPFAULT","executeSQL","CODE")=tWebClient.SoapFault.faultcode
			Set pResult("ERROR","SOAPFAULT","executeSQL","FAULTSTRING")=tWebClient.SoapFault.faultstring
			Set tError=$System.Status.DecomposeStatus(%objlasterror,.tError)
			Set pResult("ERROR","SOAPFAULT","executeSQL","ERRORSTRING")=$Get(tError(1))
			Set tErrorText=$Get(tError(1))
		} else {
			Set tErrorText=$$Error^%apiOBJ(5002,$ZERROR)
			Set pResult("ERROR","ERRORSTRING")=tErrorText
		}
		If $ISOBJECT(tWebClient.HttpResponse) {
			Set tHTTPResponse=##class(%Net.HttpResponse).%New()
			Set tHTTPResponse=tWebClient.HttpResponse
			Set pResult("ERROR","executeSQL","HTTP_RESPONSE_DATA")=tHTTPResponse.Data
			Set pResult("ERROR","executeSQL","HTTP_REASON_PHRASE")=tHTTPResponse.ReasonPhrase
			Set pResult("ERROR","executeSQL","HTTP_HEADERS_DATE")=$Get(tHTTPResponse.Headers("DATE"))
		}
		Set pResult="0^"_tErrorText_$get(pResult("ERROR","HTTP_REASON_PHRASE"))_"^"_..GetElapsedTime(tStartTime,$now())	
		Set tStatus=pResult
	}
	// If the result of the web call was an error - Quit now. 
	If ($Piece(pResult,"^",1)=0) Quit tStatus
	//Display results returned
	If $Get(tDebug) {
		Write !,tSearchPattern," results returned: ",tSC.Count()
	}
	// Web call completed. Parse response...
	Set tCount=tSC.Count()
	Set tCounter=0
	For tKey=1:1:tCount {
		Set tResult=##class(BSTS.ns2.stringArray).%New()
		Set tResult=tSC.GetAt(tKey)
		Set ItemList=tResult.item.GetAt(1)
		If $Get(tDebug) {
			W !,"Items#: ",ItemList
		}
		//Save entries
		For Item=1:1:$L(ItemList,",") {
			Set DTSId=$P(ItemList,",",Item)
			If DTSId]"" {
				Set tCounter=tCounter+1
				Set ^TMP("BSTSCMCL",$job,tCounter)=DTSId
				Set ^TMP("BSTSCMCL",$job,"DTS",DTSId)=tCounter
			}	
		}
	}
	//End Here - instead of parsing
	Quit 1_"^^"_..GetElapsedTime(tStartTime,$now()) }
zgetCustomCodeset(pParams="",pResult) public {
	// Data needed passed by BSTSWS array required for call
	Set tDebug=$Get(pParams("DEBUG")) Set tDebug=1
	Set tWebServiceTimeout=600   //Override default
	Set tUserName=$Get(pParams("USER"))
	Set tPassword=$Get(pParams("PASS"))
	Set tSSLConfiguration=$Get(pParams("SSL"))
	Set tNamespaceID=$Get(pParams("NAMESPACEID"))
	Set tRevIn=$Get(pParams("REVIN"))
	Set tSearchPattern=$Get(pParams("SEARCH"))
	Set tSnapshotDate=$Get(pParams("SNAPDT"))
	Set tSType=$Get(pParams("STYPE"))
	Set tSubset=$Get(pParams("SUBSET"))
	Set tExactMatch=$Get(pParams("EXACTMATCH"))
	Set tConnectionTimeout=$Get(pParams("CTIME"))
	//Reset scratch global
	Kill ^TMP("BSTSCMCL",$job)
	//Handle maximum records
	Set tMaxResults=$Get(pParams("MAXRECS")) If tMaxResults="" Set tMaxResults=25
	//Set up location
	//BEE;BSTS*1.0*2;Changed location logic
	//Set tLocation=$Get(pParams("URLROOT"))_":"_$Get(pParams("PORT"))_$Get(pParams("SERVICEPATH"))_"/DtsQueryDaoService/DtsQueryDaoWS"
	Set tLocation=$Get(pParams("URLROOT"))_":"_$Get(pParams("PORT"))_$Get(pParams("SERVICEPATH"))_"/DtsQueryDaoWS"	
	Set tStatus=0
	Set pResult=1	
	//Put together the definition
	Set SQLSearch="DECLARE @return_value int"
	Set SQLSearch=SQLSearch_" EXEC @return_value = [dbo].[dts_searchconcepts_cond_all]"
    Set SQLSearch=SQLSearch_" @Namespace = N'"_tNamespaceID_"', @Status = N'A', @Revision_In = N'"
    Set SQLSearch=SQLSearch_tRevIn_"' SELECT  'Return Value' = @return_value"
	If $Get(tDebug) {
		Write !!,"SQL Call: ",SQLSearch,!
	}
	// Initialize new web client to make the SOAP call
	Set tWebClient=##class(BSTS.DtsQueryDaoPort).%New()
	Set tWebClient.Location=tLocation
	Set tWebClient.HttpUsername=tUserName
	Set tWebClient.HttpPassword=tPassword
	Set tWebClient.Timeout=tWebServiceTimeout
	Set tWebClient.OpenTimeout=tConnectionTimeout
	If ((tLocation["https://")&(tSSLConfiguration]"")) {	
		Set tWebClient.SSLConfiguration=tSSLConfiguration
    	Set tWebClient.HttpProxySSLConnect=0
	}
	Set tStartTime=$now()
	// Setup response
	Set tSC=##class(%Library.ListOfObjects).%New()
	try {
		Set tSC=tWebClient.executeSQL(SQLSearch)
		If (tDebug) {
			Do $System.OBJ.Dump(tWebClient)
			If $ISOBJECT(tWebClient.HttpResponse) {
				Set tHTTPResponse=##class(%Net.HttpResponse).%New()
				Set tHTTPResponse=tWebClient.HttpResponse
				Set pResult("DEBUG","HTTP_RESPONSE_DATA")=tHTTPResponse.Data
				Set pResult("DEBUG","HTTP_REASON_PHRASE")=tHTTPResponse.ReasonPhrase
				Set pResult("DEBUG","HTTP_HEADERS_DATE")=$Get(tHTTPResponse.Headers("DATE"))
			}
			Set tHttpHeadersOut=##class(%Library.ArrayOfObjects).%New()
			Set tHttpHeadersOut=tWebClient.HeadersOut
			For key=1:1:tHttpHeadersOut.Count() {
			}
		}
	}
	Catch Exception
	{
		Set tError=""
		Set tErrorText=""
		If ($ZERROR["<ZSOAP>") {
			Set pResult("ERROR","SOAPFAULT","executeSQL","CODE")=tWebClient.SoapFault.faultcode
			Set pResult("ERROR","SOAPFAULT","executeSQL","FAULTSTRING")=tWebClient.SoapFault.faultstring
			Set tError=$System.Status.DecomposeStatus(%objlasterror,.tError)
			Set pResult("ERROR","SOAPFAULT","executeSQL","ERRORSTRING")=$Get(tError(1))
			Set tErrorText=$Get(tError(1))
		} else {
			Set tErrorText=$$Error^%apiOBJ(5002,$ZERROR)
			Set pResult("ERROR","ERRORSTRING")=tErrorText
		}
		If $ISOBJECT(tWebClient.HttpResponse) {
			Set tHTTPResponse=##class(%Net.HttpResponse).%New()
			Set tHTTPResponse=tWebClient.HttpResponse
			Set pResult("ERROR","executeSQL","HTTP_RESPONSE_DATA")=tHTTPResponse.Data
			Set pResult("ERROR","executeSQL","HTTP_REASON_PHRASE")=tHTTPResponse.ReasonPhrase
			Set pResult("ERROR","executeSQL","HTTP_HEADERS_DATE")=$Get(tHTTPResponse.Headers("DATE"))
		}
		Set pResult="0^"_tErrorText_$get(pResult("ERROR","HTTP_REASON_PHRASE"))_"^"_..GetElapsedTime(tStartTime,$now())	
		Set tStatus=pResult
	}
	// If the result of the web call was an error - Quit now. 
	If ($Piece(pResult,"^",1)=0) Quit tStatus
	//Display results returned
	If $Get(tDebug) {
		Write !,tSearchPattern," results returned: ",tSC.Count()
	}
	// Web call completed. Parse response...
	Set tCount=tSC.Count()
	Set tCounter=0
	For tKey=1:1:tCount {
		Set tResult=##class(BSTS.ns2.stringArray).%New()
		Set tResult=tSC.GetAt(tKey)
		Set DTSId=tResult.item.GetAt(1)
		If $Get(tDebug) {
			W !!,"#: ",tKey
			W !,"DTSId: ",DTSId
		}
		//Save entry
		If DTSId>0 {
			Set tCounter=tCounter+1
			Set ^TMP("BSTSCMCL",$job,tCounter)=DTSId_"^^"
		}
	}
	//End Here - instead of parsing
	Quit 1_"^^"_..GetElapsedTime(tStartTime,$now()) }
zgetEquivalencyConcepts(pParams="",pResult) public {
	//BSTS*1.0*7;Get list of equivalency concepts
	// Data needed passed by BSTSWS array required for call
	Set tDebug=$Get(pParams("DEBUG"))
	Set tWebServiceTimeout=600   //Override default
	Set tUserName=$Get(pParams("USER"))
	Set tPassword=$Get(pParams("PASS"))
	Set tSSLConfiguration=$Get(pParams("SSL"))
	Set tNamespaceID=32780
	Set tRevIn=$Get(pParams("REVIN"))
	Set tSearchPattern=$Get(pParams("SEARCH"))
	Set tSnapshotDate=$Get(pParams("SNAPDT"))
	Set tSType=$Get(pParams("STYPE"))
	Set tSubset=$Get(pParams("SUBSET"))
	Set tExactMatch=$Get(pParams("EXACTMATCH"))
	Set tConnectionTimeout=$Get(pParams("CTIME"))
	//Reset scratch global
	Kill ^TMP("BSTSCMCL",$job)
	//Set up location
	//Set tLocation=$Get(pParams("URLROOT"))_":"_$Get(pParams("PORT"))_$Get(pParams("SERVICEPATH"))_"/DtsQueryDaoService/DtsQueryDaoWS"
	Set tLocation=$Get(pParams("URLROOT"))_":"_$Get(pParams("PORT"))_$Get(pParams("SERVICEPATH"))_"/DtsQueryDaoWS"
	Set tStatus=0
	Set pResult=1	
	//Put together the definition	
	Set SQLSearch="DECLARE @return_value int"
	Set SQLSearch=SQLSearch_" EXEC    @return_value = [dbo].[dts_all_concepts_with_associations_in_list]" 
	Set SQLSearch=SQLSearch_" @Association_Name = N'RightVariant,LeftVariant,RightAndLeftVariant'," 
	Set SQLSearch=SQLSearch_" @Namespace = N'36', @Status = N'A', @Revision_In = N'"
	Set SQLSearch=SQLSearch_tRevIn_"' SELECT 'Return Value' = @return_value"	
	If $Get(tDebug) {
		Write !!,"SQL Call: ",SQLSearch,!
	}
	// Initialize new web client to make the SOAP call
	Set tWebClient=##class(BSTS.DtsQueryDaoPort).%New()
	Set tWebClient.Location=tLocation
	Set tWebClient.HttpUsername=tUserName
	Set tWebClient.HttpPassword=tPassword
	Set tWebClient.Timeout=tWebServiceTimeout
	Set tWebClient.OpenTimeout=tConnectionTimeout
	If ((tLocation["https://")&(tSSLConfiguration]"")) {	
		Set tWebClient.SSLConfiguration=tSSLConfiguration
    	Set tWebClient.HttpProxySSLConnect=0
	}
	Set tStartTime=$now()
	// Setup response
	Set tSC=##class(%Library.ListOfObjects).%New()
	try {
		Set tSC=tWebClient.executeSQL(SQLSearch)
		If (tDebug) {
			Do $System.OBJ.Dump(tWebClient)
			If $ISOBJECT(tWebClient.HttpResponse) {
				Set tHTTPResponse=##class(%Net.HttpResponse).%New()
				Set tHTTPResponse=tWebClient.HttpResponse
				Set pResult("DEBUG","HTTP_RESPONSE_DATA")=tHTTPResponse.Data
				Set pResult("DEBUG","HTTP_REASON_PHRASE")=tHTTPResponse.ReasonPhrase
				Set pResult("DEBUG","HTTP_HEADERS_DATE")=$Get(tHTTPResponse.Headers("DATE"))
			}
			Set tHttpHeadersOut=##class(%Library.ArrayOfObjects).%New()
			Set tHttpHeadersOut=tWebClient.HeadersOut
			For key=1:1:tHttpHeadersOut.Count() {
			}
		}
	}
	Catch Exception
	{
		Set tError=""
		Set tErrorText=""
		If ($ZERROR["<ZSOAP>") {
			Set pResult("ERROR","SOAPFAULT","executeSQL","CODE")=tWebClient.SoapFault.faultcode
			Set pResult("ERROR","SOAPFAULT","executeSQL","FAULTSTRING")=tWebClient.SoapFault.faultstring
			Set tError=$System.Status.DecomposeStatus(%objlasterror,.tError)
			Set pResult("ERROR","SOAPFAULT","executeSQL","ERRORSTRING")=$Get(tError(1))
			Set tErrorText=$Get(tError(1))
		} else {
			Set tErrorText=$$Error^%apiOBJ(5002,$ZERROR)
			Set pResult("ERROR","ERRORSTRING")=tErrorText
		}
		If $ISOBJECT(tWebClient.HttpResponse) {
			Set tHTTPResponse=##class(%Net.HttpResponse).%New()
			Set tHTTPResponse=tWebClient.HttpResponse
			Set pResult("ERROR","executeSQL","HTTP_RESPONSE_DATA")=tHTTPResponse.Data
			Set pResult("ERROR","executeSQL","HTTP_REASON_PHRASE")=tHTTPResponse.ReasonPhrase
			Set pResult("ERROR","executeSQL","HTTP_HEADERS_DATE")=$Get(tHTTPResponse.Headers("DATE"))
		}
		Set pResult="0^"_tErrorText_$get(pResult("ERROR","HTTP_REASON_PHRASE"))_"^"_..GetElapsedTime(tStartTime,$now())	
		Set tStatus=pResult
	}
	// If the result of the web call was an error - Quit now. 
	If ($Piece(pResult,"^",1)=0) Quit tStatus
	//Display results returned
	If $Get(tDebug) {
		Write !,tSearchPattern," results returned: ",tSC.Count()
	}
	// Web call completed. Parse response...
	Set tCount=tSC.Count()
	Set tCounter=0
	For tKey=1:1:tCount {
		Set tResult=##class(BSTS.ns2.stringArray).%New()
		Set tResult=tSC.GetAt(tKey)
		Set DTSId=tResult.item.GetAt(1)
		If $Get(tDebug) {
			W !,"#: ",tKey
			W ?10,"DTSId: ",DTSId
		}
		//Save entry
		If DTSId>0 {
			Set tCounter=tCounter+1
			Set ^TMP("BSTSCMCL",$job,tCounter)=DTSId
			Set ^TMP("BSTSCMCL",$job,"DTS",DTSId)=tCounter
		}
	}
	//End Here - instead of parsing
	Quit 1_"^^"_..GetElapsedTime(tStartTime,$now()) }
zgetICD10AutoCodePreds(pParams="",pResult) public {
	//BSTS*1.0*6;Added method to retrieve conditional maps
	// Data needed passed by BSTSWS array required for call
	Set tDebug=$Get(pParams("DEBUG"))
	Set tWebServiceTimeout=600   //Override default
	Set tUserName=$Get(pParams("USER"))
	Set tPassword=$Get(pParams("PASS"))
	Set tSSLConfiguration=$Get(pParams("SSL"))
	Set tNamespaceID=32779
	Set tRevIn=$Get(pParams("REVIN"))
	Set tSearchPattern=$Get(pParams("SEARCH"))
	Set tSnapshotDate=$Get(pParams("SNAPDT"))
	Set tSType=$Get(pParams("STYPE"))
	Set tSubset=$Get(pParams("SUBSET"))
	Set tExactMatch=$Get(pParams("EXACTMATCH"))
	Set tConnectionTimeout=$Get(pParams("CTIME"))
	//Reset scratch global
	Kill ^TMP("BSTSCMCL",$job)
	//Set up location
	//Set tLocation=$Get(pParams("URLROOT"))_":"_$Get(pParams("PORT"))_$Get(pParams("SERVICEPATH"))_"/DtsQueryDaoService/DtsQueryDaoWS"
	Set tLocation=$Get(pParams("URLROOT"))_":"_$Get(pParams("PORT"))_$Get(pParams("SERVICEPATH"))_"/DtsQueryDaoWS"
	Set tStatus=0
	Set pResult=1	
	//Put together the definition
    Set SQLSearch="DECLARE @return_value int"
	Set SQLSearch=SQLSearch_" EXEC @return_value = [dbo].[dts_all_concepts_with_assocations]"
	Set SQLSearch=SQLSearch_" @Association_Name = N'SCTUS-ICD10-CM Autocodeable with Group-Prio-Predicate',"
	Set SQLSearch=SQLSearch_" @Namespace = N'36', @Status = N'A', @Revision_In = N'"
	Set SQLSearch=SQLSearch_tRevIn_"' SELECT 'Return Value' = @return_value"
	If $Get(tDebug) {
		Write !!,"SQL Call: ",SQLSearch,!
	}
	// Initialize new web client to make the SOAP call
	Set tWebClient=##class(BSTS.DtsQueryDaoPort).%New()
	Set tWebClient.Location=tLocation
	Set tWebClient.HttpUsername=tUserName
	Set tWebClient.HttpPassword=tPassword
	Set tWebClient.Timeout=tWebServiceTimeout
	Set tWebClient.OpenTimeout=tConnectionTimeout
	If ((tLocation["https://")&(tSSLConfiguration]"")) {	
		Set tWebClient.SSLConfiguration=tSSLConfiguration
    	Set tWebClient.HttpProxySSLConnect=0
	}
	Set tStartTime=$now()
	// Setup response
	Set tSC=##class(%Library.ListOfObjects).%New()
	try {
		Set tSC=tWebClient.executeSQL(SQLSearch)
		If (tDebug) {
			Do $System.OBJ.Dump(tWebClient)
			If $ISOBJECT(tWebClient.HttpResponse) {
				Set tHTTPResponse=##class(%Net.HttpResponse).%New()
				Set tHTTPResponse=tWebClient.HttpResponse
				Set pResult("DEBUG","HTTP_RESPONSE_DATA")=tHTTPResponse.Data
				Set pResult("DEBUG","HTTP_REASON_PHRASE")=tHTTPResponse.ReasonPhrase
				Set pResult("DEBUG","HTTP_HEADERS_DATE")=$Get(tHTTPResponse.Headers("DATE"))
			}
			Set tHttpHeadersOut=##class(%Library.ArrayOfObjects).%New()
			Set tHttpHeadersOut=tWebClient.HeadersOut
			For key=1:1:tHttpHeadersOut.Count() {
			}
		}
	}
	Catch Exception
	{
		Set tError=""
		Set tErrorText=""
		If ($ZERROR["<ZSOAP>") {
			Set pResult("ERROR","SOAPFAULT","executeSQL","CODE")=tWebClient.SoapFault.faultcode
			Set pResult("ERROR","SOAPFAULT","executeSQL","FAULTSTRING")=tWebClient.SoapFault.faultstring
			Set tError=$System.Status.DecomposeStatus(%objlasterror,.tError)
			Set pResult("ERROR","SOAPFAULT","executeSQL","ERRORSTRING")=$Get(tError(1))
			Set tErrorText=$Get(tError(1))
		} else {
			Set tErrorText=$$Error^%apiOBJ(5002,$ZERROR)
			Set pResult("ERROR","ERRORSTRING")=tErrorText
		}
		If $ISOBJECT(tWebClient.HttpResponse) {
			Set tHTTPResponse=##class(%Net.HttpResponse).%New()
			Set tHTTPResponse=tWebClient.HttpResponse
			Set pResult("ERROR","executeSQL","HTTP_RESPONSE_DATA")=tHTTPResponse.Data
			Set pResult("ERROR","executeSQL","HTTP_REASON_PHRASE")=tHTTPResponse.ReasonPhrase
			Set pResult("ERROR","executeSQL","HTTP_HEADERS_DATE")=$Get(tHTTPResponse.Headers("DATE"))
		}
		Set pResult="0^"_tErrorText_$get(pResult("ERROR","HTTP_REASON_PHRASE"))_"^"_..GetElapsedTime(tStartTime,$now())	
		Set tStatus=pResult
	}
	// If the result of the web call was an error - Quit now. 
	If ($Piece(pResult,"^",1)=0) Quit tStatus
	//Display results returned
	If $Get(tDebug) {
		Write !,tSearchPattern," results returned: ",tSC.Count()
	}
	// Web call completed. Parse response...
	Set tCount=tSC.Count()
	Set tCounter=0
	For tKey=1:1:tCount {
		Set tResult=##class(BSTS.ns2.stringArray).%New()
		Set tResult=tSC.GetAt(tKey)
		Set DTSId=tResult.item.GetAt(1)
		If $Get(tDebug) {
			W !,"#: ",tKey
			W ?10,"DTSId: ",DTSId
		}
		//Save entry
		If DTSId>0 {
			Set tCounter=tCounter+1
			Set ^TMP("BSTSCMCL",$job,tCounter)=DTSId
			Set ^TMP("BSTSCMCL",$job,"DTS",DTSId)=tCounter
		}
	}
	//End Here - instead of parsing
	Quit 1_"^^"_..GetElapsedTime(tStartTime,$now()) }
zgetICD10AutoCodes(pParams="",pResult) public {
	// Data needed passed by BSTSWS array required for call
	Set tDebug=$Get(pParams("DEBUG"))
	Set tWebServiceTimeout=600   //Override default
	Set tUserName=$Get(pParams("USER"))
	Set tPassword=$Get(pParams("PASS"))
	Set tSSLConfiguration=$Get(pParams("SSL"))
	Set tNamespaceID=32777
	Set tRevIn=$Get(pParams("REVIN"))
	Set tSearchPattern=$Get(pParams("SEARCH"))
	Set tSnapshotDate=$Get(pParams("SNAPDT"))
	Set tSType=$Get(pParams("STYPE"))
	Set tSubset=$Get(pParams("SUBSET"))
	Set tExactMatch=$Get(pParams("EXACTMATCH"))
	Set tConnectionTimeout=$Get(pParams("CTIME"))
	//Reset scratch global
	Kill ^TMP("BSTSCMCL",$job)
	//Set up location
	//BEE;BSTS*1.0*2;Changed location logic
	//Set tLocation=$Get(pParams("URLROOT"))_":"_$Get(pParams("PORT"))_$Get(pParams("SERVICEPATH"))_"/DtsQueryDaoService/DtsQueryDaoWS"
	Set tLocation=$Get(pParams("URLROOT"))_":"_$Get(pParams("PORT"))_$Get(pParams("SERVICEPATH"))_"/DtsQueryDaoWS"
	Set tStatus=0
	Set pResult=1	
	//Put together the definition
    Set SQLSearch="DECLARE @return_value int"
	Set SQLSearch=SQLSearch_" EXEC @return_value = [dbo].[dts_all_concepts_with_assocations]"
	Set SQLSearch=SQLSearch_" @Association_Name = N'SCTUS-ICD10CM Autocodeable',"
	Set SQLSearch=SQLSearch_" @Namespace = N'36', @Status = N'A', @Revision_In = N'"
	Set SQLSearch=SQLSearch_tRevIn_"' SELECT 'Return Value' = @return_value"
	If $Get(tDebug) {
		Write !!,"SQL Call: ",SQLSearch,!
	}
	// Initialize new web client to make the SOAP call
	Set tWebClient=##class(BSTS.DtsQueryDaoPort).%New()
	Set tWebClient.Location=tLocation
	Set tWebClient.HttpUsername=tUserName
	Set tWebClient.HttpPassword=tPassword
	Set tWebClient.Timeout=tWebServiceTimeout
	Set tWebClient.OpenTimeout=tConnectionTimeout
	If ((tLocation["https://")&(tSSLConfiguration]"")) {	
		Set tWebClient.SSLConfiguration=tSSLConfiguration
    	Set tWebClient.HttpProxySSLConnect=0
	}
	Set tStartTime=$now()
	// Setup response
	Set tSC=##class(%Library.ListOfObjects).%New()
	try {
		Set tSC=tWebClient.executeSQL(SQLSearch)
		If (tDebug) {
			Do $System.OBJ.Dump(tWebClient)
			If $ISOBJECT(tWebClient.HttpResponse) {
				Set tHTTPResponse=##class(%Net.HttpResponse).%New()
				Set tHTTPResponse=tWebClient.HttpResponse
				Set pResult("DEBUG","HTTP_RESPONSE_DATA")=tHTTPResponse.Data
				Set pResult("DEBUG","HTTP_REASON_PHRASE")=tHTTPResponse.ReasonPhrase
				Set pResult("DEBUG","HTTP_HEADERS_DATE")=$Get(tHTTPResponse.Headers("DATE"))
			}
			Set tHttpHeadersOut=##class(%Library.ArrayOfObjects).%New()
			Set tHttpHeadersOut=tWebClient.HeadersOut
			For key=1:1:tHttpHeadersOut.Count() {
			}
		}
	}
	Catch Exception
	{
		Set tError=""
		Set tErrorText=""
		If ($ZERROR["<ZSOAP>") {
			Set pResult("ERROR","SOAPFAULT","executeSQL","CODE")=tWebClient.SoapFault.faultcode
			Set pResult("ERROR","SOAPFAULT","executeSQL","FAULTSTRING")=tWebClient.SoapFault.faultstring
			Set tError=$System.Status.DecomposeStatus(%objlasterror,.tError)
			Set pResult("ERROR","SOAPFAULT","executeSQL","ERRORSTRING")=$Get(tError(1))
			Set tErrorText=$Get(tError(1))
		} else {
			Set tErrorText=$$Error^%apiOBJ(5002,$ZERROR)
			Set pResult("ERROR","ERRORSTRING")=tErrorText
		}
		If $ISOBJECT(tWebClient.HttpResponse) {
			Set tHTTPResponse=##class(%Net.HttpResponse).%New()
			Set tHTTPResponse=tWebClient.HttpResponse
			Set pResult("ERROR","executeSQL","HTTP_RESPONSE_DATA")=tHTTPResponse.Data
			Set pResult("ERROR","executeSQL","HTTP_REASON_PHRASE")=tHTTPResponse.ReasonPhrase
			Set pResult("ERROR","executeSQL","HTTP_HEADERS_DATE")=$Get(tHTTPResponse.Headers("DATE"))
		}
		Set pResult="0^"_tErrorText_$get(pResult("ERROR","HTTP_REASON_PHRASE"))_"^"_..GetElapsedTime(tStartTime,$now())	
		Set tStatus=pResult
	}
	// If the result of the web call was an error - Quit now. 
	If ($Piece(pResult,"^",1)=0) Quit tStatus
	//Display results returned
	If $Get(tDebug) {
		Write !,tSearchPattern," results returned: ",tSC.Count()
	}
	// Web call completed. Parse response...
	Set tCount=tSC.Count()
	Set tCounter=0
	For tKey=1:1:tCount {
		Set tResult=##class(BSTS.ns2.stringArray).%New()
		Set tResult=tSC.GetAt(tKey)
		Set DTSId=tResult.item.GetAt(1)
		If $Get(tDebug) {
			W !,"#: ",tKey
			W ?10,"DTSId: ",DTSId
		}
		//Save entry
		If DTSId>0 {
			Set tCounter=tCounter+1
			Set ^TMP("BSTSCMCL",$job,tCounter)=DTSId
			Set ^TMP("BSTSCMCL",$job,"DTS",DTSId)=tCounter
		}
	}
	//End Here - instead of parsing
	Quit 1_"^^"_..GetElapsedTime(tStartTime,$now()) }
zgetICD9AutoCodes(pParams="",pResult) public {
	// Data needed passed by BSTSWS array required for call
	Set tDebug=$Get(pParams("DEBUG"))
	Set tWebServiceTimeout=600   //Override default
	Set tUserName=$Get(pParams("USER"))
	Set tPassword=$Get(pParams("PASS"))
	Set tSSLConfiguration=$Get(pParams("SSL"))
	Set tNamespaceID=32778
	Set tRevIn=$Get(pParams("REVIN"))
	Set tSearchPattern=$Get(pParams("SEARCH"))
	Set tSnapshotDate=$Get(pParams("SNAPDT"))
	Set tSType=$Get(pParams("STYPE"))
	Set tSubset=$Get(pParams("SUBSET"))
	Set tExactMatch=$Get(pParams("EXACTMATCH"))
	Set tConnectionTimeout=$Get(pParams("CTIME"))
	//Reset scratch global
	Kill ^TMP("BSTSCMCL",$job)
	//Set up location
	//BEE;BSTS*1.0*2;Changed location logic
	//Set tLocation=$Get(pParams("URLROOT"))_":"_$Get(pParams("PORT"))_$Get(pParams("SERVICEPATH"))_"/DtsQueryDaoService/DtsQueryDaoWS"
	Set tLocation=$Get(pParams("URLROOT"))_":"_$Get(pParams("PORT"))_$Get(pParams("SERVICEPATH"))_"/DtsQueryDaoWS"
	Set tStatus=0
	Set pResult=1	
	//Put together the definition
    Set SQLSearch="DECLARE @return_value int"
	Set SQLSearch=SQLSearch_" EXEC @return_value = [dbo].[dts_all_concepts_with_assocations]"
	Set SQLSearch=SQLSearch_" @Association_Name = N'SCTUS-ICD9CM Autocodeable',"
	Set SQLSearch=SQLSearch_" @Namespace = N'36', @Status = N'A', @Revision_In = N'"
	Set SQLSearch=SQLSearch_tRevIn_"' SELECT 'Return Value' = @return_value"
	If $Get(tDebug) {
		Write !!,"SQL Call: ",SQLSearch,!
	}
	// Initialize new web client to make the SOAP call
	Set tWebClient=##class(BSTS.DtsQueryDaoPort).%New()
	Set tWebClient.Location=tLocation
	Set tWebClient.HttpUsername=tUserName
	Set tWebClient.HttpPassword=tPassword
	Set tWebClient.Timeout=tWebServiceTimeout
	Set tWebClient.OpenTimeout=tConnectionTimeout
	If ((tLocation["https://")&(tSSLConfiguration]"")) {	
		Set tWebClient.SSLConfiguration=tSSLConfiguration
    	Set tWebClient.HttpProxySSLConnect=0
	}
	Set tStartTime=$now()
	// Setup response
	Set tSC=##class(%Library.ListOfObjects).%New()
	try {
		Set tSC=tWebClient.executeSQL(SQLSearch)
		If (tDebug) {
			Do $System.OBJ.Dump(tWebClient)
			If $ISOBJECT(tWebClient.HttpResponse) {
				Set tHTTPResponse=##class(%Net.HttpResponse).%New()
				Set tHTTPResponse=tWebClient.HttpResponse
				Set pResult("DEBUG","HTTP_RESPONSE_DATA")=tHTTPResponse.Data
				Set pResult("DEBUG","HTTP_REASON_PHRASE")=tHTTPResponse.ReasonPhrase
				Set pResult("DEBUG","HTTP_HEADERS_DATE")=$Get(tHTTPResponse.Headers("DATE"))
			}
			Set tHttpHeadersOut=##class(%Library.ArrayOfObjects).%New()
			Set tHttpHeadersOut=tWebClient.HeadersOut
			For key=1:1:tHttpHeadersOut.Count() {
			}
		}
	}
	Catch Exception
	{
		Set tError=""
		Set tErrorText=""
		If ($ZERROR["<ZSOAP>") {
			Set pResult("ERROR","SOAPFAULT","executeSQL","CODE")=tWebClient.SoapFault.faultcode
			Set pResult("ERROR","SOAPFAULT","executeSQL","FAULTSTRING")=tWebClient.SoapFault.faultstring
			Set tError=$System.Status.DecomposeStatus(%objlasterror,.tError)
			Set pResult("ERROR","SOAPFAULT","executeSQL","ERRORSTRING")=$Get(tError(1))
			Set tErrorText=$Get(tError(1))
		} else {
			Set tErrorText=$$Error^%apiOBJ(5002,$ZERROR)
			Set pResult("ERROR","ERRORSTRING")=tErrorText
		}
		If $ISOBJECT(tWebClient.HttpResponse) {
			Set tHTTPResponse=##class(%Net.HttpResponse).%New()
			Set tHTTPResponse=tWebClient.HttpResponse
			Set pResult("ERROR","executeSQL","HTTP_RESPONSE_DATA")=tHTTPResponse.Data
			Set pResult("ERROR","executeSQL","HTTP_REASON_PHRASE")=tHTTPResponse.ReasonPhrase
			Set pResult("ERROR","executeSQL","HTTP_HEADERS_DATE")=$Get(tHTTPResponse.Headers("DATE"))
		}
		Set pResult="0^"_tErrorText_$get(pResult("ERROR","HTTP_REASON_PHRASE"))_"^"_..GetElapsedTime(tStartTime,$now())	
		Set tStatus=pResult
	}
	// If the result of the web call was an error - Quit now. 
	If ($Piece(pResult,"^",1)=0) Quit tStatus
	//Display results returned
	If $Get(tDebug) {
		Write !,tSearchPattern," results returned: ",tSC.Count()
	}
	// Web call completed. Parse response...
	Set tCount=tSC.Count()
	Set tCounter=0
	For tKey=1:1:tCount {
		Set tResult=##class(BSTS.ns2.stringArray).%New()
		Set tResult=tSC.GetAt(tKey)
		Set DTSId=tResult.item.GetAt(1)
		If $Get(tDebug) {
			W !,"#: ",tKey
			W ?10,"DTSId: ",DTSId
		}
		//Save entry
		If DTSId>0 {
			Set tCounter=tCounter+1
			Set ^TMP("BSTSCMCL",$job,tCounter)=DTSId
		}
	}
	//End Here - instead of parsing
	Quit 1_"^^"_..GetElapsedTime(tStartTime,$now()) }
zgetICD9toSNOMED(pParams="",pResult) public {
	// Data passed into pParams via the BSTSWS array
	Set tDebug=$Get(pParams("DEBUG"))
	Set tWebServiceTimeout=$Get(pParams("TIMEOUT"))
	Set tUserName=$Get(pParams("USER"))
	Set tPassword=$Get(pParams("PASS"))
	Set tSSLConfiguration=$Get(pParams("SSL"))
	Set tNamespaceID=$Get(pParams("NAMESPACEID"))
	Set tSearchPattern=$Get(pParams("SEARCH"))
	Set tSnapshotDate=$Get(pParams("SNAPDT"))
	Set tMaxResults=$Get(pParams("MAXRECS")) S:tMaxResults="" tMaxResults=10000
	Set tReturnLimit=10000
	//Get location
	//BEE;BSTS*1.0*2;Changed location logic
	//Set tLocation=$Get(pParams("URLROOT"))_":"_$Get(pParams("PORT"))_$Get(pParams("SERVICEPATH"))_"/DtsQueryDaoService/DtsQueryDaoWS"
	Set tLocation=$Get(pParams("URLROOT"))_":"_$Get(pParams("PORT"))_$Get(pParams("SERVICEPATH"))_"/DtsQueryDaoWS"
	Set tConnectionTimeout=$Get(pParams("CTIME"))
	Set tStartTime=$now()
	Set tStatus=0
	Set pResult=1
	Set tCounter=0
	// Setup request for search options and attribute set descriptors for initial call
	Set tSearchOptions=""
	Set tSearchOptions=##class(BSTS.ns1.TConceptSearchOptions).%New()
	Set tAttributeSetDesc=""
	Set tAttributeSetDesc=##class(BSTS.ns1.TConceptAttributeSetDescriptor).%New()
	Set tPropType1=""
	Set tPropType1=##class(BSTS.ns1.TPropertyType).%New()
	Set tPropType1=##class(BSTS.ns1.TPropertyType).%New()
	Set tPropType1.namespaceId=36
	Set tPropType1.id="6"
	Set tPropType1.name="SNOMED_ICD9_MAP"
	Set tPropType1.attachesTo="C"
	Set tSearchOptions.DEFAULTLIMIT="0"
	Set tSearchOptions.ALLCONTENT="0"
	Set tAttributeSetDesc.DEFAULTLIMIT=0
	Set tAttributeSetDesc.name="ASD Test"
	Set tAttributeSetDesc.allAssociationTypes="false"
	Set tAttributeSetDesc.allInverseAssociationTypes="false"
	Set tAttributeSetDesc.allPropertyTypes="false"
	Set tAttributeSetDesc.allSynonymTypes="false"
	Set tAttributeSetDesc.allRoleTypes="false"
	Set tAttributeSetDesc.attributesLimit="100"
	Set tAttributeSetDesc.definedViewAttributes="false"
	Set tAttributeSetDesc.queryHasSubs="false"
	Set tAttributeSetDesc.queryHasSups="false"
	Set tAttributeSetDesc.subconcepts="false"
	Set tAttributeSetDesc.superconcepts="false"
	Set tAttributeSetDesc.allInverseRoleTypes="false"
	Set tSearchOptions.snapshotDate=tSnapshotDate
	Set tSearchOptions.firstResult=0
	Set tSearchOptions.limit=tReturnLimit
	Set tSearchOptions.subsetSearch="false"
	Set tSearchOptions.contentId=tNamespaceID
	Set tSearchOptions.status="A"
	Do tAttributeSetDesc.propertyTypes.Insert(tPropType1)
	// Initialize new web client to make the SOAP call
	Set tWebClient=##class(BSTS.DtsQueryDaoPort).%New()
	Set tWebClient.Location=tLocation
	Set tWebClient.HttpUsername=tUserName
	Set tWebClient.HttpPassword=tPassword
	Set tWebClient.Timeout=tWebServiceTimeout
	Set tWebClient.OpenTimeout=tConnectionTimeout
	If ((tLocation["https://")&(tSSLConfiguration]"")) {	
		Set tWebClient.SSLConfiguration=tSSLConfiguration
	 	Set tWebClient.HttpProxySSLConnect=0
	}
	Set tStartTime=$now()
	// Setup response
	If $Get(tDebug) {
		W !!,"treturnlimit: ",tReturnLimit
		W !,"tfirstresult: ",tCounter
	}
	Set tSC="",tSC=##class(%Library.ListOfObjects).%New()
	try {
		Set tSC=tWebClient.findConceptsWithPropertyMatching(tPropType1,tSearchPattern,tSearchOptions)
		If tDebug {
			W !!
			Do $SYSTEM.OBJ.Dump(tSC)
		}
		//Assemble return status
		Set tStatus="1^^"_..GetElapsedTime(tStartTime,$now())	
	}
	Catch Exception {
		Set tError=""
		Set tErrorText=""
		If ($ZERROR["<ZSOAP>") {
			Set pResult("ERROR","SOAPFAULT","CODE")=tWebClient.SoapFault.faultcode
			Set pResult("ERROR","SOAPFAULT","FAULTSTRING")=tWebClient.SoapFault.faultstring
			Set tError=$System.Status.DecomposeStatus(%objlasterror,.tError)
			Set pResult("ERROR","SOAPFAULT","ERRORSTRING")=$Get(tError(1))
			Set tErrorText=$Get(tError(1))
		}
		else {
			Set tErrorText=$$Error^%apiOBJ(5002,$ZERROR)
			Set pResult("ERROR","ERRORSTRING")=tErrorText
		}
		Set pResult="0^"_tErrorText_$get(pResult("ERROR","HTTP_REASON_PHRASE"))_"^"_..GetElapsedTime(tStartTime,$now())	
		Set tStatus=pResult
	}
	// Web call completed. Parse response...
	Set tCount=tSC.Count()
	If $Get(tDebug) {
		W !,"tCount: ",tCount
	}
	For tKey=1:1:tCount {
		Set tObject=##class(BSTS.ns1.TOntylogConcept).%New()
		Set tObject=tSC.GetAt(tKey)
		Set tDTSId=tObject.id
		If tDTSId>0 {
			Set tCounter=tCounter+1
			Set ^TMP("BSTSCMCL",$job,tCounter)=tDTSId
		}
		If (tDebug) {
			Write !,$tr(tSearchPattern,"*"),?30,tCounter,?40,tDTSId
		}
	}
	//Assemble return status
	If tCounter>0 {
		Set tStatus="1^^"_..GetElapsedTime(tStartTime,$now())	
	}
	Quit tStatus }
zgetListofSubsets(pParams="",pResult) public {
	// Data needed passed by BSTSWS array required for call
	Set tDebug=$Get(pParams("DEBUG"))
	Set tWebServiceTimeout=$Get(pParams("TIMEOUT"))
	Set tUserName=$Get(pParams("USER"))
	Set tPassword=$Get(pParams("PASS"))
	Set tSSLConfiguration=$Get(pParams("SSL"))
	Set tNamespaceID=$Get(pParams("NAMESPACEID"))
	Set tConnectionTimeout=$Get(pParams("CTIME"))
	//Set up location
	//BEE;BSTS*1.0*2;Changed location logic
	//Set tLocation=$Get(pParams("URLROOT"))_":"_$Get(pParams("PORT"))_$Get(pParams("SERVICEPATH"))_"/DtsQueryDaoService/DtsQueryDaoWS"
	Set tLocation=$Get(pParams("URLROOT"))_":"_$Get(pParams("PORT"))_$Get(pParams("SERVICEPATH"))_"/DtsQueryDaoWS"
	Set tStatus=0
	Set pResult=1
    //New search definition
	Set SQLSearch="DECLARE @return_value int"
	Set SQLSearch=SQLSearch_" EXEC @return_value = [dbo].[dts_getsubsets]"
	Set SQLSearch=SQLSearch_" @Namespace = N'"_tNamespaceID_"'"
    I $Get(tDebug) {
		Write !!,"SQL Call: ",SQLSearch,!
	}
	// Initialize new web client to make the SOAP call
	Set tWebClient=##class(BSTS.DtsQueryDaoPort).%New()
	Set tWebClient.Location=tLocation
	Set tWebClient.HttpUsername=tUserName
	Set tWebClient.HttpPassword=tPassword
	Set tWebClient.Timeout=tWebServiceTimeout
	Set tWebClient.OpenTimeout=tConnectionTimeout
	If ((tLocation["https://")&(tSSLConfiguration]"")) {	
		Set tWebClient.SSLConfiguration=tSSLConfiguration
    	Set tWebClient.HttpProxySSLConnect=0
	}
	Set tStartTime=$now()
	// Setup response
	Set tSC=##class(%Library.ListOfObjects).%New()
	try {
		Set tSC=tWebClient.executeSQL(SQLSearch)
		If (tDebug) {
			Do $System.OBJ.Dump(tWebClient)
			If $ISOBJECT(tWebClient.HttpResponse) {
				Set tHTTPResponse=##class(%Net.HttpResponse).%New()
				Set tHTTPResponse=tWebClient.HttpResponse
				Set pResult("DEBUG","HTTP_RESPONSE_DATA")=tHTTPResponse.Data
				Set pResult("DEBUG","HTTP_REASON_PHRASE")=tHTTPResponse.ReasonPhrase
				Set pResult("DEBUG","HTTP_HEADERS_DATE")=$Get(tHTTPResponse.Headers("DATE"))
			}
			Set tHttpHeadersOut=##class(%Library.ArrayOfObjects).%New()
			Set tHttpHeadersOut=tWebClient.HeadersOut
			For key=1:1:tHttpHeadersOut.Count() {
			}
		}
	}
	Catch Exception
	{
		Set tError=""
		Set tErrorText=""
		If ($ZERROR["<ZSOAP>") {
			Set pResult("ERROR","SOAPFAULT","executeSQL","CODE")=tWebClient.SoapFault.faultcode
			Set pResult("ERROR","SOAPFAULT","executeSQL","FAULTSTRING")=tWebClient.SoapFault.faultstring
			Set tError=$System.Status.DecomposeStatus(%objlasterror,.tError)
			Set pResult("ERROR","SOAPFAULT","executeSQL","ERRORSTRING")=$Get(tError(1))
			Set tErrorText=$Get(tError(1))
		} else {
			Set tErrorText=$$Error^%apiOBJ(5002,$ZERROR)
			Set pResult("ERROR","ERRORSTRING")=tErrorText
		}
		If $ISOBJECT(tWebClient.HttpResponse) {
			Set tHTTPResponse=##class(%Net.HttpResponse).%New()
			Set tHTTPResponse=tWebClient.HttpResponse
			Set pResult("ERROR","executeSQL","HTTP_RESPONSE_DATA")=tHTTPResponse.Data
			Set pResult("ERROR","executeSQL","HTTP_REASON_PHRASE")=tHTTPResponse.ReasonPhrase
			Set pResult("ERROR","executeSQL","HTTP_HEADERS_DATE")=$Get(tHTTPResponse.Headers("DATE"))
		}
		Set pResult="0^"_tErrorText_$get(pResult("ERROR","HTTP_REASON_PHRASE"))_"^"_..GetElapsedTime(tStartTime,$now())	
		Set tStatus=pResult
	}
	// If the result of the web call was an error - Quit now. 
	If ($Piece(pResult,"^",1)=0) Quit tStatus
	//Display results returned
	If $Get(tDebug) {
		Write !," Subsets returned: ",tSC.Count()
	}
	// Web call completed. Parse response...
	Set tCount=tSC.Count()
	Set tCounter=0
	For tKey=1:1:tCount {
		Set tResult=##class(BSTS.ns2.stringArray).%New()
		Set tResult=tSC.GetAt(tKey)
		Set tSubset=tResult.item.GetAt(1)
		If $Get(tDebug) {
			W !!,"#: ",tKey
			W !,"Subset: ",tSubset
		}
		//Save entry
		If tSubset]"" {
			Set tCounter=tCounter+1
			Set ^TMP("BSTSCMCL",$job,tCounter)=tSubset
		}
	}
	//End Here - instead of parsing
	Quit 1_"^^"_..GetElapsedTime(tStartTime,$now()) }
zgetSubsetList(pParams="",pResult) public {
	// Data passed into pParams via the BSTSWS array
	Set tDebug=$Get(pParams("DEBUG"))
	Set tWebServiceTimeout=300   //Override default
	Set tUserName=$Get(pParams("USER"))
	Set tPassword=$Get(pParams("PASS"))
	Set tSSLConfiguration=$Get(pParams("SSL"))
	Set tNamespaceID=$Get(pParams("NAMESPACEID"))
	Set tSearchPattern=$Get(pParams("SUBSET"))
	Set tSnapshotDate=$Get(pParams("SNAPDT"))
	Set tMaxResults=$Get(pParams("MAXRECS")) S tMaxResults=300000
	Set tReturnLimit=300000
	//Get location
	//BEE;BSTS*1.0*2;Changed location logic
	//Set tLocation=$Get(pParams("URLROOT"))_":"_$Get(pParams("PORT"))_$Get(pParams("SERVICEPATH"))_"/DtsQueryDaoService/DtsQueryDaoWS"
	Set tLocation=$Get(pParams("URLROOT"))_":"_$Get(pParams("PORT"))_$Get(pParams("SERVICEPATH"))_"/DtsQueryDaoWS"
	Set tConnectionTimeout=$Get(pParams("CTIME"))
	Set tStartTime=$now()
	Set tStatus=0
	Set pResult=1
	Set tCounter=0
	Set Continue=1
	While Continue=1 {	
		// Setup request for search options and attribute set descriptors for initial call
		Set tSearchOptions=""
		Set tSearchOptions=##class(BSTS.ns1.TConceptSearchOptions).%New()
		Set tAttributeSetDesc=""
		Set tAttributeSetDesc=##class(BSTS.ns1.TConceptAttributeSetDescriptor).%New()
		Set tPropType1=""		
		Set tPropType1=##class(BSTS.ns1.TPropertyType).%New()
		Set tPropType1.name="IHS"
		If tNamespaceID=36 {
			Set tPropType1.namespaceId=32768
		}
		If tNamespaceID=1552 {
			Set tPropType1.namespaceId=32769
		}
		//Set tPropType1.code="N32768"
		Set tPropType1.id="1"
		Set tSearchOptions.ALLCONTENT="0"
		Set tSearchOptions.DEFAULTLIMIT="0"
		Set tAttributeSetDesc.DEFAULTLIMIT="0"
		Set tAttributeSetDesc.name="ASD Test"
		Set tAttributeSetDesc.attributesLimit="100"
		Set tAttributeSetDesc.allPropertyTypes="false"
		Set tAttributeSetDesc.allAssociationTypes="false"
		Set tAttributeSetDesc.allInverseAssociationTypes="false"
		Set tAttributeSetDesc.allSynonymTypes="false"
		Set tAttributeSetDesc.allRoleTypes="false"
		Set tAttributeSetDesc.allInverseRoleTypes="false"
		Set tAttributeSetDesc.definedViewAttributes="false"
		Set tAttributeSetDesc.queryHasSubs="false"
		Set tAttributeSetDesc.queryHasSups="false"
		Set tAttributeSetDesc.subconcepts="false"
		Set tAttributeSetDesc.superconcepts="false"
		Set tSearchOptions.snapshotDate=tSnapshotDate
		Set tSearchOptions.firstResult="0"
		Set tSearchOptions.limit=tMaxResults
		Set tSearchOptions.subsetSearch="false"
		Set tSearchOptions.contentId=tNamespaceID
		Set tSearchOptions.status="A"
		Do tAttributeSetDesc.propertyTypes.Insert(tPropType1)
		// Initialize new web client to make the SOAP call
		Set tWebClient=##class(BSTS.DtsQueryDaoPort).%New()
		Set tWebClient.Location=tLocation
		Set tWebClient.HttpUsername=tUserName
		Set tWebClient.HttpPassword=tPassword
		Set tWebClient.Timeout=tWebServiceTimeout
		Set tWebClient.OpenTimeout=tConnectionTimeout
		If ((tLocation["https://")&(tSSLConfiguration]"")) {	
			Set tWebClient.SSLConfiguration=tSSLConfiguration
    		Set tWebClient.HttpProxySSLConnect=0
		}
		Set tStartTime=$now()
		// Setup response
		If $Get(tDebug) {
			W !!,"treturnlimit: ",tReturnLimit
			W !,"tfirstresult: ",tCounter
			W !,"sub: ",tSearchPattern
		}
		Set tSC="",tSC=##class(%Library.ListOfObjects).%New()
		try {
			Set tSC=tWebClient.findConceptsWithPropertyMatching(tPropType1,tSearchPattern,tSearchOptions)
			If tDebug {
				W !!
				Do $SYSTEM.OBJ.Dump(tSC)
			}
			//Assemble return status
			Set tStatus="1^^"_..GetElapsedTime(tStartTime,$now())	
		}
		Catch Exception {
			Set tError=""
			Set tErrorText=""
			If ($ZERROR["<ZSOAP>") {
				Set pResult("ERROR","SOAPFAULT","CODE")=tWebClient.SoapFault.faultcode
				Set pResult("ERROR","SOAPFAULT","FAULTSTRING")=tWebClient.SoapFault.faultstring
				Set tError=$System.Status.DecomposeStatus(%objlasterror,.tError)
				Set pResult("ERROR","SOAPFAULT","ERRORSTRING")=$Get(tError(1))
				Set tErrorText=$Get(tError(1))
			}
			else {
				Set tErrorText=$$Error^%apiOBJ(5002,$ZERROR)
				Set pResult("ERROR","ERRORSTRING")=tErrorText
			}
			Set pResult="0^"_tErrorText_$get(pResult("ERROR","HTTP_REASON_PHRASE"))_"^"_..GetElapsedTime(tStartTime,$now())	
			Set tStatus=pResult
		}
		// Web call completed. Parse response...
		Set tCount=tSC.Count()
		If $Get(tDebug) {
			W !,"tCount: ",tCount
		}
		For tKey=1:1:tCount {
			Set tObject=##class(BSTS.ns1.TOntylogConcept).%New()
			Set tObject=tSC.GetAt(tKey)
			Set tDTSId=tObject.id
			If tDTSId>0 {
				Set tCounter=tCounter+1
				Set ^TMP("BSTSCMCL",$job,tCounter)=tDTSId
			}
			If (tDebug) {
				Write !,$tr(tSearchPattern,"*"),?30,tCounter,?40,tDTSId
			}
		}
		//Loop end
		If tReturnLimit>tCount {
			Set Continue=0
		}
	}
	//Assemble return status
	If tCounter>0 {
		Set tStatus="1^^"_..GetElapsedTime(tStartTime,$now())	
	}
	Quit tStatus }
zpropertyLookup(pParams="",pResult) public {
	// Data passed into pParams via the BSTSWS array
	Set tDebug=$Get(pParams("DEBUG"))
	Set tWebServiceTimeout=$Get(pParams("TIMEOUT"))
	Set tSearchPattern=$Get(pParams("SEARCH"))
	Set tUserName=$Get(pParams("USER"))
	Set tPassword=$Get(pParams("PASS"))
	Set tSSLConfiguration=$Get(pParams("SSL"))
	Set tNamespaceID=$Get(pParams("NAMESPACEID"))
	Set tSnapshotDate=$Get(pParams("SNAPDT"))
	Set tMaxResults=$Get(pParams("MAXRECS"))
	Set tConnectionTimeout=$Get(pParams("CTIME"))
	If tMaxResults="" {
		Set tMaxResults=100
	}
	Set tReturnLimit=10000
	Set tPropVal=$Get(pParams("PROPERTY"))
	//Get location
	//BEE;BSTS*1.0*2;Changed location logic
	//Set tLocation=$Get(pParams("URLROOT"))_":"_$Get(pParams("PORT"))_$Get(pParams("SERVICEPATH"))_"/DtsQueryDaoService/DtsQueryDaoWS"
	Set tLocation=$Get(pParams("URLROOT"))_":"_$Get(pParams("PORT"))_$Get(pParams("SERVICEPATH"))_"/DtsQueryDaoWS"
	Set tStartTime=$now()
	Set tStatus=1
	Set pResult=1
	//Set up property name
	Set tPropNam=""
	If tPropVal=110 {
		Set tPropNam="NDC"
	}
	If tPropVal=209 {
		Set tPropNam="VUID"
	}
	Set tCounter=0
	Set Continue=1
	While Continue=1 {	
		// Setup request for search options and attribute set descriptors for initial call
		Set tSearchOptions=""
		Set tSearchOptions=##class(BSTS.ns1.TConceptSearchOptions).%New()
		Set tAttributeSetDesc=""
		Set tAttributeSetDesc=##class(BSTS.ns1.TConceptAttributeSetDescriptor).%New()
		Set tPropType1=""		
		Set tPropType1=##class(BSTS.ns1.TPropertyType).%New()
		Set tPropType1.namespaceId=tNamespaceID
		Set tPropType1.name=tPropNam
		Set tPropType1.id=tPropVal
		Set tPropType1.attachesTo="C"
		Set tSearchOptions.ALLCONTENT="0"
		Set tSearchOptions.DEFAULTLIMIT="0"
		Set tAttributeSetDesc.DEFAULTLIMIT="0"
		Set tAttributeSetDesc.name="ASD 1"
		Set tAttributeSetDesc.attributesLimit="100"
		Set tAttributeSetDesc.allPropertyTypes="false"
		Set tAttributeSetDesc.allAssociationTypes="false"
		Set tAttributeSetDesc.allInverseAssociationTypes="false"
		Set tAttributeSetDesc.allSynonymTypes="false"
		Set tAttributeSetDesc.allRoleTypes="false"
		Set tAttributeSetDesc.allInverseRoleTypes="false"
		Set tAttributeSetDesc.definedViewAttributes="false"
		Set tAttributeSetDesc.queryHasSubs="false"
		Set tAttributeSetDesc.queryHasSups="false"
		Set tAttributeSetDesc.subconcepts="false"
		Set tAttributeSetDesc.superconcepts="false"			
		Set tSearchOptions.snapshotDate=tSnapshotDate
		Set tSearchOptions.firstResult="0"
		Set tSearchOptions.limit=tMaxResults
		Set tSearchOptions.subsetSearch="false"
		Set tSearchOptions.contentId=tNamespaceID
		Set tSearchOptions.status=""
		Do tAttributeSetDesc.propertyTypes.Insert(tPropType1)
		// Initialize new web client to make the SOAP call
		Set tWebClient=##class(BSTS.DtsQueryDaoPort).%New()
		Set tWebClient.Location=tLocation
		Set tWebClient.HttpUsername=tUserName
		Set tWebClient.HttpPassword=tPassword
		Set tWebClient.Timeout=tWebServiceTimeout
		Set tWebClient.OpenTimeout=tConnectionTimeout
		If ((tLocation["https://")&(tSSLConfiguration]"")) {	
			Set tWebClient.SSLConfiguration=tSSLConfiguration
   		 	Set tWebClient.HttpProxySSLConnect=0
		}
		Set tStartTime=$now()
		// Setup response
		If $Get(tDebug) {
			W !!,"treturnlimit: ",tReturnLimit
			W !,"tfirstresult: ",tCounter
			W !,"sub: ",tSearchPattern
		}
		Set tSC="",tSC=##class(%Library.ListOfObjects).%New()
		try {
			Set tSC=tWebClient.findConceptsWithPropertyMatching(tPropType1,tSearchPattern,tSearchOptions)
			If tDebug {
				W !!
				Do $SYSTEM.OBJ.Dump(tSC)
			}		
		}
		Catch Exception {
			Set tError=""
			Set tErrorText=""
			If ($ZERROR["<ZSOAP>") {
				Set pResult("ERROR","SOAPFAULT","CODE")=tWebClient.SoapFault.faultcode
				Set pResult("ERROR","SOAPFAULT","FAULTSTRING")=tWebClient.SoapFault.faultstring
				Set tError=$System.Status.DecomposeStatus(%objlasterror,.tError)
				Set pResult("ERROR","SOAPFAULT","ERRORSTRING")=$Get(tError(1))
				Set tErrorText=$Get(tError(1))
			}
			else {
				Set tErrorText=$$Error^%apiOBJ(5002,$ZERROR)
				Set pResult("ERROR","ERRORSTRING")=tErrorText
			}
			Set pResult="0^"_tErrorText_$get(pResult("ERROR","HTTP_REASON_PHRASE"))_"^"_..GetElapsedTime(tStartTime,$now())	
			Set tStatus=pResult
		}
		// Web call completed. Parse response...
		Set tCount=tSC.Count()
		If $Get(tDebug) {
			W !,"tCount: ",tCount
		}
		For tKey=1:1:tCount {
			Set tObject=##class(BSTS.ns1.TOntylogConcept).%New()
			Set tObject=tSC.GetAt(tKey)
			Set tDTSId=tObject.id
			If tDTSId>0 {
				Set tCounter=tCounter+1
				Set ^TMP("BSTSCMCL",$job,tDTSId)=$g(^TMP("BSTSCMCL",$job,tDTSId))+1
			}
			If (tDebug) {
				Write !,$tr(tSearchPattern,"*"),?30,tCounter,?40,tDTSId
			}
		}
		//Loop end
		If tReturnLimit>tCount {
			Set Continue=0
		}
	}
	//Assemble return status
	If tStatus=1 {
		Set tStatus="1^^"_..GetElapsedTime(tStartTime,$now())	
	}
	Quit tStatus }
zExtentExecute(%qHandle) [ SQLCODE,c1 ] public { New %ROWCOUNT,%ROWID,%msg,SQLCODE,c1 
	Set sc=1
	s %qHandle=$i(%objcn)
	 ;---&sql(DECLARE QExtent CURSOR FOR
 	 ;---		 SELECT ID FROM BSTS_SOAP.WebFunctions)
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
%0AmBk1 s %objcsd(%qHandle,5)=$o(^BSTS.SOAP.WebFunctionsD(%objcsd(%qHandle,5)))
 i %objcsd(%qHandle,5)="" g %0AmBdun
 g:$zu(115,2)=0 %0AmBuncommitted i $zu(115,2)=1 l +^BSTS.SOAP.WebFunctionsD($p(%objcsd(%qHandle,5),"||",1))#"S":$zu(115,4) i $t { s %objcsd(%qHandle,3)=1,%objcsd(%qHandle,4)=$name(^BSTS.SOAP.WebFunctionsD($p(%objcsd(%qHandle,5),"||",1)))_"#""SI""" } else { s SQLCODE=-114,%msg="Unable to acquire shared lock on table BSTS_SOAP.WebFunctions for RowID value: "_%objcsd(%qHandle,5) ztrap "LOCK"  }
 ; asl MOD# 3
 i %objcsd(%qHandle,5)'="",$d(^BSTS.SOAP.WebFunctionsD(%objcsd(%qHandle,5)))
 e  g %0AmCdun
%0AmBuncommitted ;
 s:$g(SQLCODE)'<0 SQLCODE=0 s %objcsd(%qHandle,1)=%objcsd(%qHandle,1)+1,%ROWCOUNT=%objcsd(%qHandle,1),%ROWID=%objcsd(%qHandle,5),%objcsc(%qHandle)=10 q
%QExtent0f i '$g(%objcsc(%qHandle)) { s SQLCODE=-102 q  } i %objcsc(%qHandle)=100 { s SQLCODE=100 q  } s SQLCODE=0
 s $zt="%0Aerr"
 i $d(%objcsd(%qHandle,2))#2,$g(%objcsd(%qHandle,1))'<%objcsd(%qHandle,2) { s SQLCODE=100,%ROWCOUNT=%objcsd(%qHandle,1),%objcsc(%qHandle)=100 q }
 g %0Afirst:%objcsc(%qHandle)=1
%0AmCdun if $zu(115,2)=1 { if $g(%objcsd(%qHandle,3))=1 { l -@%objcsd(%qHandle,4) s %objcsd(%qHandle,3)=0 } elseif $g(%objcsd(%qHandle,3))=2 { do $classmethod($li(%objcsd(%qHandle,4)),"%UnlockId",$li(%objcsd(%qHandle,4),2),1,1)  s %objcsd(%qHandle,3)=0 } }
 g %0AmBk1
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
 s c1=%objcsd(%qHandle,5)
 q
%0Fo d %QExtent0f q:SQLCODE'=0
 s c1=%objcsd(%qHandle,5)
 q
zExtentFunc() public {
	try {
		set tSchemaPath = ##class(%SQL.Statement).%ClassPath($classname())
			set tStatement = ##class(%SQL.Statement).%New(,tSchemaPath)
			do tStatement.prepare(" SELECT ID FROM BSTS_SOAP . WebFunctions")
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
	If $Get(^oddPROC("BSTS_SOAP","WEBFUNCTIONS_EXTENT",21))'="" { Set sc = 1, metadata=$Select(version=4:^oddPROC("BSTS_SOAP","WEBFUNCTIONS_EXTENT",12),1:^oddPROC("BSTS_SOAP","WEBFUNCTIONS_EXTENT",12,version)) }
	ElseIf $Data(^oddPROC("BSTS_SOAP","WEBFUNCTIONS_EXTENT")) { Set sc = $$CompileSignature^%ourProcedure("BSTS_SOAP","WEBFUNCTIONS_EXTENT",.metadata,.signature) }
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
	if '..%SQLGetLock(id,1,.pUnlockRef) { set sqlcode=-114,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler39",,"BSTS_SOAP"_"."_"WebFunctions"_":"_"IDKEY") QUIT 0 }
	if 'pLockOnly { new qv set qv=$d(^BSTS.SOAP.WebFunctionsD(%pVal(1))) do:'$g(pUnlockRef) ..%SQLReleaseLock(id,1) quit qv } else { do:'$g(pUnlockRef) ..%SQLReleaseLock(id,1) QUIT 1 }
	Quit
zIDKEYSQLFindPKeyByConstraint(%con)
 QUIT $$Error^%apiOBJ(5758,"%Persistent::IDKEYSQLFindPKeyByConstraint")
zIDKEYSQLFindRowIDByConstraint(%con,pInternal=0)
 QUIT $$Error^%apiOBJ(5758,"%Persistent::IDKEYSQLFindRowIDByConstraint")
