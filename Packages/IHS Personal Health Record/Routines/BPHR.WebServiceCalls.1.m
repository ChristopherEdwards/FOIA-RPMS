 ;BPHR.WebServiceCalls.1
 ;(C)InterSystems, generated for class BPHR.WebServiceCalls.  Do NOT edit. 10/22/2016 08:43:38AM
 ;;6E55366F;BPHR.WebServiceCalls
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
	set tCLASSNAME = $listget($g(^BPHR.WebServiceCallsD(id)),1)
	if tCLASSNAME="" { quit $select(id="":"",1:$listbuild(id_"","BPHR.WebServiceCalls")) }
	set tClass=$piece(tCLASSNAME,$extract(tCLASSNAME),$length(tCLASSNAME,$extract(tCLASSNAME))-1)
	set:tClass'["." tClass="User."_tClass
	quit $select(id="":"",1:$listbuild(id_"",tClass)) }
%DeleteData(id,concurrency) public {
	Quit:id="" $$Error^%apiOBJ(5812)
	Set $Ztrap="DeleteDataERR" Set extentlock=0,sc=""
	If concurrency { If '$tlevel { Kill %0CacheLock } If $increment(%0CacheLock($classname()))>$zu(115,6) { Lock +(^BPHR.WebServiceCallsD):$zu(115,4) Set extentlock=$test Lock:extentlock -(^BPHR.WebServiceCallsD) } If 'extentlock { Lock +(^BPHR.WebServiceCallsD(id)):$zu(115,4) } If '$test { QUIT $$Error^%apiOBJ(5803,$classname()) }}
	If ($Data(^BPHR.WebServiceCallsD(id))) {
		If $data(^oddEXTR($classname())) {
			n %fc,%fk,%z
			Set %fc="" For  Set %fc=$order(^oddEXTR($classname(),"n","IDKEY","f",%fc)) Quit:%fc=""  Set %fk="" For  Set %fk=$order(^oddEXTR($classname(),"n","IDKEY","f",%fc,%fk)) Quit:%fk=""  Set %z=$get(^oddEXTR($classname(),"n","IDKEY","f",%fc,%fk,61)) If %z'="" Set sc=$classmethod(%fc,%fk_"Delete",id) If ('sc) Goto DeleteDataEXIT
		}
		Kill ^BPHR.WebServiceCallsD(id)
		Set sc=1
	}
	else { set sc=$$Error^%apiOBJ(5810,$classname(),id) }
DeleteDataEXIT
	If (concurrency) && ('extentlock) { Lock -(^BPHR.WebServiceCallsD(id)) }
DeleteDataRET	Set $Ztrap = ""
	QUIT sc
DeleteDataERR	Set $Ztrap = "DeleteDataRET"
	Set sc = $$Error^%apiOBJ(5002,$ZE)
	Goto DeleteDataEXIT }
%Exists(oid="") public {
	Quit ..%ExistsId($listget(oid)) }
%ExistsId(id) public {
	try { set tExists = $s(id="":0,$d(^BPHR.WebServiceCallsD(id)):1,1:0) } catch tException { set tExists = 0 } quit tExists }
%InsertBatch(objects,concurrency=0,useTransactions=0) public {
	s $ZTrap="InsertBatchERR"
	s numerrs=0,errs="",cnt=0,ptr=0
	while $listnext(objects,ptr,data) {
		s cnt=cnt+1,sc=1
		do
 {
			if (useTransactions) tstart
			s id=$i(^BPHR.WebServiceCallsD)
			Set lock=0,locku=""
			If '$Tlevel { Kill %0CacheLock }
			i concurrency { If $i(%0CacheLock($classname()))>$zu(115,6) { Lock +(^BPHR.WebServiceCallsD):$zu(115,4) Set lock=$Select($test:2,1:0) Lock:lock -(^BPHR.WebServiceCallsD) } Else { Lock +(^BPHR.WebServiceCallsD(id)):$zu(115,4) Set lock=$Select($test:1,1:0) } If 'lock { Set sc=$$Error^%apiOBJ(5803,$classname()) Quit } }
			s ^BPHR.WebServiceCallsD(id)=data
		}
		while 0
		If lock=1 Lock -(^BPHR.WebServiceCallsD(id))
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
	Kill ^BPHR.WebServiceCallsD
	Quit 1
%LoadData(id)
	New sc
	Set sc=""
	If ..%Concurrency=4 Lock +(^BPHR.WebServiceCallsD(id)):$zu(115,4) If '$test QUIT $$Error^%apiOBJ(5803,$classname())
	If ..%Concurrency'=4,..%Concurrency>1 Lock +(^BPHR.WebServiceCallsD(id)#"S"):$zu(115,4) If '$test QUIT $$Error^%apiOBJ(5804,$classname())
	i '$d(^BPHR.WebServiceCallsD(id)) 
	Else  Do
	. New %s1
	. Set sc=1
	. s %s1=$g(^BPHR.WebServiceCallsD(id))
	If ..%Concurrency=2 Lock -(^BPHR.WebServiceCallsD(id)#"SI")
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
	if shared { l +(^BPHR.WebServiceCallsD#"S"):$zu(115,4) if $t { q 1 } else { q $$Error^%apiOBJ(5799,$classname()) }} l +(^BPHR.WebServiceCallsD):$zu(115,4) if $t { q 1 } else { q $$Error^%apiOBJ(5798,$classname()) }
}
%LockId(id,shared=0) public {
	if id'="" { set sc=1 } else { set sc=$$Error^%apiOBJ(5812) quit sc }
	if 'shared { Lock +(^BPHR.WebServiceCallsD(id)):$zu(115,4) i $test { q 1 } else { q $$Error^%apiOBJ(5803,$classname()) } }
	else { Lock +(^BPHR.WebServiceCallsD(id)#"S"):$zu(115,4) if $test { q 1 } else { q $$Error^%apiOBJ(5804,$classname()) } }
}
%OnDetermineClass(oid,class)
	New id,idclass
	Set id=$listget($get(oid)) QUIT:id="" $$Error^%apiOBJ(5812)
	Set idclass=$lg($get(^BPHR.WebServiceCallsD(id)),1)
	If idclass="" Set class="BPHR.WebServiceCalls" Quit 1
	Set class=$piece(idclass,$extract(idclass),$length(idclass,$extract(idclass))-1)
	Set:class'["." class="User."_class
	QUIT 1
%PhysicalAddress(id,paddr)
	if $Get(id)="" Quit $$Error^%apiOBJ(5813,$classname())
	if (id="") { quit $$Error^%apiOBJ(5832,$classname(),id) }
	s paddr(1)=$lb($Name(^BPHR.WebServiceCallsD(id)),$classname(),"IDKEY","listnode",id)
	s paddr=1
	Quit 1
%PurgeIndices(idxlist="",lockExtent=0)
	if $ll(idxlist) { quit $$Error^%apiOBJ(5066,$classname()_"::"_$ListToString(idxlist)) } QUIT 1
	Quit
%SQLAcquireLock(%rowid,s=0,unlockref)
	new %d,gotlock set %d(1)=%rowid set s=$e("S",s) lock +^BPHR.WebServiceCallsD(%d(1))#s:$zu(115,4) set gotlock=$t set:gotlock&&$g(unlockref) unlockref($i(unlockref))=$lb($name(^BPHR.WebServiceCallsD(%d(1))),"BPHR.WebServiceCalls") QUIT gotlock
	Quit
%SQLAcquireTableLock(s=0,SQLCODE,to="")
	set s=$e("S",s) set:to="" to=$zu(115,4) lock +^BPHR.WebServiceCallsD#s:to QUIT:$t 1 set SQLCODE=-110 if s="S" { set %msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler35",,"BPHR"_"."_"WebServiceCalls") } else { set %msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler36",,"BPHR"_"."_"WebServiceCalls") } QUIT 0
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
	k:'$TLEVEL %0CacheLock if '$a(%check,2) { new %ls if $i(%0CacheLock("BPHR.WebServiceCalls"))>$zu(115,6) { lock +^BPHR.WebServiceCallsD:$zu(115,4) lock:$t -^BPHR.WebServiceCallsD set %ls=$s($t:2,1:0) } else { lock +^BPHR.WebServiceCallsD(%d(1)):$zu(115,4) set %ls=$t } set:%ls=2 $e(%check,2)=$c(1) set:%ls=1 $e(%l)=$c(1) if '%ls set SQLCODE=-110,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler40",,%oper,"BPHR"_"."_"WebServiceCalls",$g(%d(1))) QUIT  } if %tstart { TSTART:($zu(115,1)=1)||('$TLEVEL&&($zu(115,1)=2))  } set $zt="ERRORDelete"
	do ..%SQLGetOld() if sqlcode set SQLCODE=-106 do ..%SQLEExit() QUIT  
	if %e(2)'="" set sn=$p(%e(2),$e(%e(2)),$l(%e(2),$e(%e(2)))-1) if "BPHR.WebServiceCalls"'=sn new %f do ..%SQLCopyIcolIntoName() do $classmethod(sn,"%SQLDelete",%rowid,%check,%tstart,%mv,1) QUIT  
	if '$a(%check),'$zu(115,7) do  if sqlcode set SQLCODE=sqlcode do ..%SQLEExit() QUIT  
	. new %fk,%k,%p,%st,%t,%z set %k="",%p("%1")="%d(1),",%p("IDKEY")="%d(1),"
	. for  quit:sqlcode<0  set %k=$o(^oddEXTR("BPHR.WebServiceCalls","n",%k)) quit:%k=""  set %t="" for  set %t=$o(^oddEXTR("BPHR.WebServiceCalls","n",%k,"f",%t)) quit:%t=""  set %st=(%t="BPHR.WebServiceCalls") set %fk="" for  set %fk=$order(^oddEXTR("BPHR.WebServiceCalls","n",%k,"f",%t,%fk)) quit:%fk=""  x "set %z=$classmethod(%t,%fk_""SQLFKeyRefAction"",%st,%k,"_%p(%k)_")" if %z set sqlcode=-124 quit  
	set ce="" for  { set ce=$order(^oddSQL("BPHR","WebServiceCalls","DC",ce)) quit:ce=""   do $classmethod(ce,"%SQLDeleteChildren",%d(1),%check,.sqlcode) quit:sqlcode<0  } if sqlcode<0 { set SQLCODE=sqlcode do ..%SQLEExit() QUIT } // Delete any children
	k ^BPHR.WebServiceCallsD(%d(1))
	do ..%SQLUnlock() TCOMMIT:%tstart&&($zu(115,1)=1)
	set SQLCODE=0 kill:$g(omcall) %0CacheSQLRA QUIT
ERRORDelete	set $zt="",SQLCODE=-415,%msg=$s($g(%msg)'="":%msg_" -- ",1:"")_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler51",,%oper,"BPHR"_"."_"WebServiceCalls",$ze) if $ze["<FRAMESTACK>" { set %msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler52",,$ze,%oper,"BPHR"_"."_"WebServiceCalls") do ##Class(%SYS.System).WriteToConsoleLog(%msg) if ($zu(67,10,$j)=1)||($zu(67,10,$j)=3) { write !,%msg h 3 } HALT  } do ..%SQLEExit() QUIT
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
	if '..%SQLGetLock(id,1,.pUnlockRef) { set sqlcode=-114,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler39",,"BPHR"_"."_"WebServiceCalls"_":"_"%1") QUIT 0 }
	if 'pLockOnly { new qv set qv=$d(^BPHR.WebServiceCallsD(%pVal(1))) do:'$g(pUnlockRef) ..%SQLReleaseLock(id,1) quit qv } else { do:'$g(pUnlockRef) ..%SQLReleaseLock(id,1) QUIT 1 }
	Quit
%SQLGetLock(pRowId,pShared=0,pUnlockRef)
	kill:'$TLEVEL %0CacheLock
	if $i(%0CacheLock("BPHR.WebServiceCalls"))>$zu(115,6) { lock +^BPHR.WebServiceCallsD:$zu(115,4) lock:$t -^BPHR.WebServiceCallsD QUIT $s($t:2,1:0) } 
	QUIT ..%SQLAcquireLock(pRowId,pShared,.pUnlockRef)
%SQLGetOld()
	new s if '$d(^BPHR.WebServiceCallsD(%d(1)),s) { set sqlcode=100 quit  } set %e(2)=$lg(s)
	QUIT
%SQLGetOldAll()
	new s if '$d(^BPHR.WebServiceCallsD(%d(1)),s) { set sqlcode=100 quit  } set %e(2)=$lg(s)
	QUIT
%SQLInsert(%d,%check,%inssel,%vco,%tstart=1,%mv=0)
	new bva,%ele,%itm,%key,%l,%n,%nc,%oper,%pos,%s,sqlcode,sn,subs,icol set %oper="INSERT",sqlcode=0,%l=$c(0,0,0)
	if $d(%d(1)),'$zu(115,11) { if %d(1)'="" { set SQLCODE=-111,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler6",,"ID","BPHR"_"."_"WebServiceCalls") QUIT ""  } kill %d(1) } 
	do ..%SQLNormalizeFields()
	kill:'$TLEVEL %0CacheLock if %tstart { TSTART:($zu(115,1)=1)||('$TLEVEL&&($zu(115,1)=2))  } set $zt="ERRORInsert"
	if '$a(%check) do  if sqlcode<0 set SQLCODE=sqlcode do ..%SQLEExit() QUIT ""
	. if $g(%vco)'="" d @%vco quit:sqlcode<0
	if '$d(%d(1)) { set %d(1)=$i(^BPHR.WebServiceCallsD) } elseif %d(1)>$g(^BPHR.WebServiceCallsD) { if $i(^BPHR.WebServiceCallsD,$zabs(%d(1)-$g(^BPHR.WebServiceCallsD))) {}} elseif $d(^BPHR.WebServiceCallsD(%d(1))) { set SQLCODE=-119,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler33",,"ID",%d(1),"BPHR"_"."_"WebServiceCalls"_"."_"ID") do ..%SQLEExit() QUIT "" }
	for icol=2 set:'$d(%d(icol)) %d(icol)=""
	if '$a(%check,2) { new %ls if $i(%0CacheLock("BPHR.WebServiceCalls"))>$zu(115,6) { lock +^BPHR.WebServiceCallsD:$zu(115,4) lock:$t -^BPHR.WebServiceCallsD set %ls=$s($t:2,1:0) } else { lock +^BPHR.WebServiceCallsD(%d(1)):$zu(115,4) set %ls=$t } set:%ls=2 $e(%check,2)=$c(1) set:%ls=1 $e(%l)=$c(1) if '%ls set SQLCODE=-110,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler40",,%oper,"BPHR"_"."_"WebServiceCalls",$g(%d(1))) do ..%SQLEExit() QUIT ""  }
	set ^BPHR.WebServiceCallsD(%d(1))=$lb(%d(2))
	lock:$a(%l) -^BPHR.WebServiceCallsD(%d(1))
	TCOMMIT:%tstart&&($zu(115,1)=1)
	set SQLCODE=0 QUIT %d(1) 			// %SQLInsert
ERRORInsert	set $zt="",SQLCODE=-415,%msg=$s($g(%msg)'="":%msg_" -- ",1:"")_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler51",,%oper,"BPHR"_"."_"WebServiceCalls",$ze) if $ze["<FRAMESTACK>" { set %msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler52",,$ze,%oper,"BPHR"_"."_"WebServiceCalls") do ##Class(%SYS.System).WriteToConsoleLog(%msg) if ($zu(67,10,$j)=1)||($zu(67,10,$j)=3) { write !,%msg h 3 } HALT  } do ..%SQLEExit() QUIT ""
	Quit
%SQLMissing(fname)
	set sqlcode=-108,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler47",,fname,"BPHR"_"."_"WebServiceCalls") quit
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
	set x=$zobjexport(-1,18),%qrc=400,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler44",,"BPHR"_"."_"WebServiceCalls") QUIT
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
	if %nolock=0 { if '..%SQLAcquireLock(%rowid) { set %qrc=114,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler45",,"BPHR"_"."_"WebServiceCalls",%rowid),%ROWCOUNT=0 QUIT  } set:$zu(115,2) il=$zu(115,2,0) }
	new s,ul set ul=0,d(1)=%rowid if $zu(115,2)=1 { lock +^BPHR.WebServiceCallsD(d(1))#"S":$zu(115,4) if $t { set ul=1 } else { set %qrc=114,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler46",,"BPHR"_"."_"WebServiceCalls",%rowid),%ROWCOUNT=0 quit  } }
	if '$d(^BPHR.WebServiceCallsD(d(1)),s) { set SQLCODE=100,%qrc=100 if %nolock=0 { do:$g(il) $zu(115,2,il) }} else { set SQLCODE=0
	if qq { set d(2)=$lg(s) if d(2)'="" { new sn set sn=$p(d(2),$e(d(2)),$l(d(2),$e(d(2)))-1) if "BPHR.WebServiceCalls"'=sn { if %nolock=0 { do ..%SQLReleaseLock(%rowid,0,1) do:$g(il) $zu(115,2,il) } kill d set:sn'["." sn="User."_sn do $classmethod(sn,"%SQLQuickLoad",%rowid,%nolock,0,1) QUIT  }}}
	set d(2)=$lg(s)  }
	do ..%SQLQuickLogicalToOdbc(.d)
	if SQLCODE set %ROWCOUNT=0 set:SQLCODE<0 SQLCODE=-SQLCODE lock:ul -^BPHR.WebServiceCallsD(d(1))#"SI" set %qrc=SQLCODE QUIT
	set:qq d=$zobjexport("BPHR.WebServiceCalls",18),d=$zobjexport(2,18) set i=-1 for  { set i=$o(d(i)) quit:i=""  set d=$zobjexport(d(i),18) } set %qrc=0,%ROWCOUNT=1 lock:ul -^BPHR.WebServiceCallsD(d(1))#"SI" if %nolock=0 { do ..%SQLReleaseLock(%rowid,0,0) do:$g(il) $zu(115,2,il) } QUIT
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
	new %d set %d(1)=%rowid set s=$e("S",s)_$e("I",i) lock -^BPHR.WebServiceCallsD(%d(1))#s set:i&&($g(%0CacheLock("BPHR.WebServiceCalls"))) %0CacheLock("BPHR.WebServiceCalls")=%0CacheLock("BPHR.WebServiceCalls")-1 QUIT
%SQLReleaseTableLock(s=0,i=0)
	set s=$e("S",s)_$e("I",i) lock -^BPHR.WebServiceCallsD#s QUIT 1
	Quit
%SQLUnlock()
	lock:$a(%l) -^BPHR.WebServiceCallsD(%d(1))
	QUIT
%SQLUnlockError(cname)
	set sqlcode=-110 if %oper="DELETE" { set %msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler48",,"BPHR"_"."_"WebServiceCalls",cname) } else { set %msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler49",,"BPHR"_"."_"WebServiceCalls",cname) } quit
	Quit
%SQLUpdate(%rowid,%check,%d,%vco,%tstart=1,%mv=0,%polymorphic=0)
	new %e,bva,%ele,%itm,%key,%l,%n,%nc,%oper,%pos,%s,icol,s,sn,sqlcode,subs,t set %oper="UPDATE",sqlcode=0,%ROWID=%rowid,$e(%e,1)=$c(0),%l=$c(0,0,0) do ..%SQLNormalizeFields() if $d(%d(1)),%d(1)'=%rowid set SQLCODE=-107,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler16",,"ID","BPHR"_"."_"WebServiceCalls") QUIT
	for icol=2:1:2 set $e(%e,icol)=$c($d(%d(icol)))
	set %d(1)=%rowid,%e(1)=%rowid
	k:'$TLEVEL %0CacheLock if '$a(%check,2) { new %ls if $i(%0CacheLock("BPHR.WebServiceCalls"))>$zu(115,6) { lock +^BPHR.WebServiceCallsD:$zu(115,4) lock:$t -^BPHR.WebServiceCallsD set %ls=$s($t:2,1:0) } else { lock +^BPHR.WebServiceCallsD(%d(1)):$zu(115,4) set %ls=$t } set:%ls=2 $e(%check,2)=$c(1) set:%ls=1 $e(%l)=$c(1) if '%ls set SQLCODE=-110,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler40",,%oper,"BPHR"_"."_"WebServiceCalls",$g(%d(1))) QUIT  } if %tstart { TSTART:($zu(115,1)=1)||('$TLEVEL&&($zu(115,1)=2))  } set $zt="ERRORUpdate"
	if $g(%vco)="" { do ..%SQLGetOld() i sqlcode { s SQLCODE=-109 do ..%SQLEExit() QUIT  } set:'$d(%d(2)) %d(2)=%e(2) set:%d(2)=%e(2) $e(%e,2)=$c(0) } else { do ..%SQLGetOldAll() if sqlcode { set SQLCODE=-109 do ..%SQLEExit() QUIT  } set:'$d(%d(2)) %d(2)=%e(2) set:%d(2)=%e(2) $e(%e,2)=$c(0)}
	if %e(2)'="" set sn=$p(%e(2),$e(%e(2)),$l(%e(2),$e(%e(2)))-1) if "BPHR.WebServiceCalls"'=sn new %f do ..%SQLCopyIcolIntoName() do $classmethod(sn,"%SQLUpdate",%rowid,%check,.%d,$g(%vco),%tstart,%mv,1) QUIT
	do:'$a(%check)  if sqlcode set SQLCODE=sqlcode do ..%SQLEExit() QUIT
	. if $g(%vco)'="" d @%vco quit:sqlcode<0
	if '$a(%check,3) { 
	}
	set:$a(%e,2) ^BPHR.WebServiceCallsD(%d(1))=$lb(%d(2))
	if '$a(%check,3) { 
	}
	do ..%SQLUnlock() TCOMMIT:%tstart&&($zu(115,1)=1)
	set SQLCODE=0
	QUIT
ERRORUpdate	set $zt="",SQLCODE=-415,%msg=$s($g(%msg)'="":%msg_" -- ",1:"")_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler51",,%oper,"BPHR"_"."_"WebServiceCalls",$ze) if $ze["<FRAMESTACK>" { set %msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler52",,$ze,%oper,"BPHR"_"."_"WebServiceCalls") do ##Class(%SYS.System).WriteToConsoleLog(%msg) if ($zu(67,10,$j)=1)||($zu(67,10,$j)=3) { write !,%msg h 3 } HALT  } do ..%SQLEExit() QUIT  
	Quit
%SQLValidateFields(sqlcode)
	QUIT 'sqlcode
%SQLnBuild() public {
	set %n=$lb(,"ID","x__classname")
	QUIT }
%SaveData(id) public {
	Set $ZTrap="SaveDataERR" Set sc=1,id=$listget(i%"%%OID") If id'="" { Set insert=0,idassigned=1 } Else { Set insert=1,idassigned=0 }
	Set lock=0,lockok=0,tSharedLock=0,locku=""
	if 'idassigned { set id=$i(^BPHR.WebServiceCallsD) Set $zobjoid("BPHR.WebServiceCalls",id)=$this,.."%%OID"=$lb(id_"","BPHR.WebServiceCalls") set:$g(%objtxSTATUS)=2 %objtxOIDASSIGNED(+$this)="" }
	If 'insert && ('$Data(^BPHR.WebServiceCallsD(id))) { Set insert=1 }
	If '$Tlevel { Kill %0CacheLock }
	If insert  {
		if (..%Concurrency&&$tlevel)||(..%Concurrency=4) { If (..%Concurrency < 4)&&($i(%0CacheLock($classname()))>$zu(115,6)) { Lock +(^BPHR.WebServiceCallsD):$zu(115,4) Set lockok=$Select($test:2,1:0) Lock:lockok -(^BPHR.WebServiceCallsD) } Else { Lock +(^BPHR.WebServiceCallsD(id)):$zu(115,4) Set lockok=$Select($test:1,1:0) Set:..%Concurrency'=4 lock=lockok } If 'lockok { Set sc=$$Error^%apiOBJ(5803,$classname()) Goto SaveDataEXIT } }
		if ..%Concurrency=3 { Lock +(^BPHR.WebServiceCallsD(id)#"S") set tSharedLock=1 }
		s ^BPHR.WebServiceCallsD(id)=$lb("")
	}
	Else  {
		If (..%Concurrency<4)&&(..%Concurrency) { If $i(%0CacheLock($classname()))>$zu(115,6) { Lock +(^BPHR.WebServiceCallsD):$zu(115,4) Set lockok=$s($test:2,1:0) Lock:lockok -(^BPHR.WebServiceCallsD) } Else { Lock +(^BPHR.WebServiceCallsD(id)):$zu(115,4) Set lockok=$Select($test:1,1:0),lock=lockok } If 'lockok { Set sc=$$Error^%apiOBJ(5803,$classname()) Goto SaveDataEXIT } }
		s ^BPHR.WebServiceCallsD(id)=$lb("")
	}
SaveDataEXIT
	if (('sc)) && ('idassigned) { Set $zobjoid("",$listget(i%"%%OID"))="" Set $this."%%OID" = "" kill:$g(%objtxSTATUS)=2 %objtxOIDASSIGNED(+$this) }
	If lock Lock -(^BPHR.WebServiceCallsD(id))
	If (('sc)) { if (tSharedLock) {  Lock -(^BPHR.WebServiceCallsD(id)#"S") } elseif (lockok=1)&&(insert)&&(..%Concurrency=4) {  Lock -(^BPHR.WebServiceCallsD(id)) } }
SaveDataRET	Set $Ztrap = ""
	QUIT sc
SaveDataERR	Set $Ztrap = "SaveDataRET"
	Set sc = $$Error^%apiOBJ(5002,$ZE)
	Goto SaveDataEXIT }
%SaveDirect(id="",idList="",data,concurrency=-1) public {
	Set $ZTrap="SaveDirectERR" set sc=1
	if concurrency=-1 { Set concurrency=$zu(115,10) }
	if id="" { s id=$i(^BPHR.WebServiceCallsD), insert=1 } else { s insert=0 }
	Set lock=0
	If '$Tlevel { Kill %0CacheLock }
	i (insert)&&(concurrency) { If $i(%0CacheLock($classname()))>$zu(115,6) { Lock +(^BPHR.WebServiceCallsD):$zu(115,4) Set lock=$Select($test:2,1:0) Lock:lock -(^BPHR.WebServiceCallsD) } Else { Lock +(^BPHR.WebServiceCallsD(id)):$zu(115,4) Set lock=$Select($test:1,1:0) } If 'lock { Set sc=$$Error^%apiOBJ(5803,$classname()) Goto SaveDirectEXIT } }
	s ^BPHR.WebServiceCallsD(id)=data
SaveDirectEXIT
	If lock=1 Lock -(^BPHR.WebServiceCallsD(id))
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
	if ('immediate)&&('shared) { l -^BPHR.WebServiceCallsD q 1 } elseif (immediate)&&('shared) { l -^BPHR.WebServiceCallsD#"I" q 1 } elseif ('immediate)&&(shared) { l -^BPHR.WebServiceCallsD#"S" q 1 } else { l -^BPHR.WebServiceCallsD#"SI" q 1 }
}
%UnlockId(id,shared=0,immediate=0) public {
	if ('immediate)&&('shared) { Lock -(^BPHR.WebServiceCallsD(id)) q 1 } elseif (immediate)&&('shared) { Lock -(^BPHR.WebServiceCallsD(id)#"I") q 1 } elseif ('immediate)&&(shared) { Lock -(^BPHR.WebServiceCallsD(id)#"S") q 1 } else { Lock -(^BPHR.WebServiceCallsD(id)#"SI") q 1 }
}
zAddSecElements(client,pUser="",pPass="") public {
   Set utoken=##class(%SOAP.Security.UsernameToken).Create(pUser,pPass)
   Do client.SecurityOut.AddSecurityElement(utoken)
   Set ts=##class(%SOAP.Security.Timestamp).Create()
   Do client.SecurityOut.AddSecurityElement(ts) 
   Quit }
zGetElapsedTime(pStartDate="",pEndDate="") public {
	Quit:pStartDate="" ""
	Set pEndDate=$select(pEndDate="":$now(),1:pEndDate)	// Default $now() if no pEndDate passed
	Quit $Piece(pEndDate,",")-$Piece(pStartDate,",")*86000+$Piece(pEndDate,",",2)-$Piece(pStartDate,",",2) }
zPMQueryRequest(pParams="",pResult) public {
	Set tStatus=1
	//Data needed passed by pParams array required for call
	Set tDebug=$Get(pParams("DEBUG"))
	Set tWebServiceTimeout=$Get(pParams("TIMEOUT"))
	If tWebServiceTimeout="" {
		Set tWebServiceTimeout=30
	}
	//Set up location
	Set tLocation=$Get(pParams("URLROOT"))_":"_$Get(pParams("PORT"))_$Get(pParams("SERVICEPATH"))_"/PMQueryService.PMQueryServiceHttpsSoap12Endpoint/"
	//Initialize new web client to make the SOAP call
	Set tWebClient=##class(BPHR.PMQueryServiceHttpsSoap12Endpoint).%New()
	Set tWebClient.Location=tLocation
	Set tWebClient.Timeout=tWebServiceTimeout
	Set tWebClient.SSLConfiguration=$Get(pParams("SSL"))
	Do ..AddSecElements(.tWebClient,$Get(pParams("USER")),$Get(pParams("PASS")))
	Set tStartTime=$now()
	//Set up inputs
	Set PMRequest=##class(BPHR.ax21.PMRequest).%New()
	Set PMRequest.loginId=$Get(pParams("USER"))
	Set PMRequest.password=$Get(pParams("PASS"))
	Set PMQuery=##class(BPHR.ax21.Query).%New()
	Set PMQuery.euid=$Get(pParams("EUID"))
	Set PMQuery.from=$Get(pParams("FROM"))
	Set PMQuery.to=$Get(pParams("TO"))
	Set PMQuery.providerDomainAddress=$G(pParams("ADDR"))
	Set PMRequest.query=PMQuery
	// Setup response
	Set tResponse=##class(BPHR.ax21.PMQueryResponse).%New()
	try {
		Set tResponse=tWebClient.queryRequest(PMRequest)
		If (tDebug) {
			Do $System.OBJ.Dump(tWebClient)
			If $ISOBJECT(tWebClient.HttpResponse) {
				Set tHTTPResponse=##class(%Net.HttpResponse).%New()
				Set tHTTPResponse=tWebClient.HttpResponse
				Set pResponse("DEBUG","HTTP_RESPONSE_DATA")=tHTTPResponse.Data
				Set pResponse("DEBUG","HTTP_REASON_PHRASE")=tHTTPResponse.ReasonPhrase
				Set pResponse("DEBUG","HTTP_HEADERS_DATE")=tHTTPResponse.Headers("DATE")
				zw pResponse
			}								
		}		
	}
	Catch Exception
	{
		Set tError=""
		Set tErrorText=""
		If ($ZERROR["<ZSOAP>") {
			Set tError=$System.Status.DecomposeStatus(%objlasterror,.tError)
			Set tErrorText=$Get(tError(1))
		} 
		else {
			Set tErrorText=$$Error^%apiOBJ(5002,$ZERROR)
		}
		Set tHttpRetRsn=""
		If $ISOBJECT(tWebClient.HttpResponse) {
			Set tHTTPResponse=##class(%Net.HttpResponse).%New()
			Set tHTTPResponse=tWebClient.HttpResponse
			Set tHttpRetRsn=tHTTPResponse.ReasonPhrase
		}
		Set tStatus="0^"_tErrorText_tHttpRetRsn_"^"_..GetElapsedTime(tStartTime,$now())	
	}
	// If the result of the web call was an error - Quit now. 
	If ($Piece(tStatus,"^",1)=0) Quit tStatus
	//Determine results returned
	Set tPHRaccessDate=tResponse.PHRaccessDate
	Set tlastLoginDate=tResponse.lastLoginDate
	Set tlastSecureMessageDate=tResponse.lastSecureMessageDate
	Set tpatientDirectEmailAddress=tResponse.patientDirectEmailAddress
	//Display results
	If $Get(tDebug) {
		Write !,"PHRaccessDate: ",tPHRaccessDate
		Write !,"lastLoginDate: ",tlastLoginDate
		Write !,"lastSecureMessageDate: ",tlastSecureMessageDate
		Write !,"patientDirectEmailAddress: ",tpatientDirectEmailAddress
	}
	//Return responses
	Set pResult("ACCESS")=tPHRaccessDate
	Set pResult("LOGIN")=tlastLoginDate
	Set pResult("SMESSAGE")=tlastSecureMessageDate
	Set pResult("SDIRECT")=tpatientDirectEmailAddress
	//End Here - instead of parsing
	Quit 1_"^^"_..GetElapsedTime(tStartTime,$now()) }
zExtentExecute(%qHandle) [ SQLCODE,c1 ] public { New %ROWCOUNT,%ROWID,%msg,SQLCODE,c1 
	Set sc=1
	s %qHandle=$i(%objcn)
	 ;---&sql(DECLARE QExtent CURSOR FOR
 	 ;---		 SELECT ID FROM BPHR.WebServiceCalls)
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
%0AmBk1 s %objcsd(%qHandle,5)=$o(^BPHR.WebServiceCallsD(%objcsd(%qHandle,5)))
 i %objcsd(%qHandle,5)="" g %0AmBdun
 g:$zu(115,2)=0 %0AmBuncommitted i $zu(115,2)=1 l +^BPHR.WebServiceCallsD($p(%objcsd(%qHandle,5),"||",1))#"S":$zu(115,4) i $t { s %objcsd(%qHandle,3)=1,%objcsd(%qHandle,4)=$name(^BPHR.WebServiceCallsD($p(%objcsd(%qHandle,5),"||",1)))_"#""SI""" } else { s SQLCODE=-114,%msg="Unable to acquire shared lock on table BPHR.WebServiceCalls for RowID value: "_%objcsd(%qHandle,5) ztrap "LOCK"  }
 ; asl MOD# 3
 i %objcsd(%qHandle,5)'="",$d(^BPHR.WebServiceCallsD(%objcsd(%qHandle,5)))
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
			do tStatement.prepare(" SELECT ID FROM BPHR . WebServiceCalls")
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
	If $Get(^oddPROC("BPHR","WEBSERVICECALLS_EXTENT",21))'="" { Set sc = 1, metadata=$Select(version=4:^oddPROC("BPHR","WEBSERVICECALLS_EXTENT",12),1:^oddPROC("BPHR","WEBSERVICECALLS_EXTENT",12,version)) }
	ElseIf $Data(^oddPROC("BPHR","WEBSERVICECALLS_EXTENT")) { Set sc = $$CompileSignature^%ourProcedure("BPHR","WEBSERVICECALLS_EXTENT",.metadata,.signature) }
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
	if '..%SQLGetLock(id,1,.pUnlockRef) { set sqlcode=-114,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler39",,"BPHR"_"."_"WebServiceCalls"_":"_"IDKEY") QUIT 0 }
	if 'pLockOnly { new qv set qv=$d(^BPHR.WebServiceCallsD(%pVal(1))) do:'$g(pUnlockRef) ..%SQLReleaseLock(id,1) quit qv } else { do:'$g(pUnlockRef) ..%SQLReleaseLock(id,1) QUIT 1 }
	Quit
zIDKEYSQLFindPKeyByConstraint(%con)
 QUIT $$Error^%apiOBJ(5758,"%Persistent::IDKEYSQLFindPKeyByConstraint")
zIDKEYSQLFindRowIDByConstraint(%con,pInternal=0)
 QUIT $$Error^%apiOBJ(5758,"%Persistent::IDKEYSQLFindRowIDByConstraint")
