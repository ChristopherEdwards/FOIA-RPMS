 ;BEDD.EDSYSTEM.1
 ;(C)InterSystems, generated for class BEDD.EDSYSTEM.  Do NOT edit. 04/14/2017 08:47:49AM
 ;;614D7672;BEDD.EDSYSTEM
 ;
SQLUPPER(v,l) { quit $zu(28,v,7,$g(l,32767)) }
ALPHAUP(v,r) { quit $zu(28,v,6) }
STRING(v,l) { quit $zu(28,v,9,$g(l,32767)) }
SQLSTRING(v,l) { quit $zu(28,v,8,$g(l,32767)) }
UPPER(v) { quit $zu(28,v,5) }
MVR(v) { quit $zu(28,v,2) }
TRUNCATE(v,l) { quit $e(v,1,$g(l,3641144)) }
%BuildIndices(idxlist="",autoPurge=0,lockExtent=0) public {
	set $ZTrap="CatchError",locked=0,sc=1,sHandle=1,sHandle($classname())=$c(0)
	for ptr=1:1:$listlength(idxlist) { if '$d(^oddCOM($classname(),"i",$list(idxlist,ptr))) { set sc=$$Error^%apiOBJ(5066,$classname()_"::"_$list(idxlist,ptr)) continue } } if ('sc) { quit sc }
	if lockExtent { s sc=..%LockExtent(0) i ('sc) { q sc } else { s locked=1 } }
	if $system.CLS.IsMthd($classname(),"%OnBeforeBuildIndices") { set sc=..%OnBeforeBuildIndices(.idxlist) i ('sc) { i locked { d ..%SQLReleaseTableLock(0) } quit sc } }
	if autoPurge { s sc = ..%PurgeIndices(idxlist) i ('sc) { quit sc }}
	if (idxlist="")||($listfind(idxlist,"SiteIdx")) { set $Extract(sHandle($classname()),1)=$c(1) If $SortBegin(^BEDD.EDSYSTEMI("SiteIdx")) }
	set id=""
BSLoop	set id=$order(^BEDD.EDSYSTEMD(id)) Goto:id="" BSLoopDun
	set sc = ..%FileIndices(id,.sHandle) if ('sc) { goto BSLoopDun }
	Goto BSLoop
BSLoopDun
	if $Ascii(sHandle($classname()),1) If $SortEnd(^BEDD.EDSYSTEMI("SiteIdx"))
	if $system.CLS.IsMthd($classname(),"%OnAfterBuildIndices") { set sc=..%OnAfterBuildIndices(.idxlist)}
	i locked { d ..%UnlockExtent(0) }
	QUIT sc
CatchError	s $ZTrap="" i $ZE'="" { s sc = $$Error^%apiOBJ(5002,$ZE) } i $g(locked) { d ..%UnlockExtent(0) } q sc }
%ComposeOid(id) public {
	set tCLASSNAME = $listget($g(^BEDD.EDSYSTEMD(id)),1)
	if tCLASSNAME="" { quit $select(id="":"",1:$listbuild(id_"","BEDD.EDSYSTEM")) }
	set tClass=$piece(tCLASSNAME,$extract(tCLASSNAME),$length(tCLASSNAME,$extract(tCLASSNAME))-1)
	set:tClass'["." tClass="User."_tClass
	quit $select(id="":"",1:$listbuild(id_"",tClass)) }
%DeleteData(id,concurrency) public {
	Quit:id="" $$Error^%apiOBJ(5812)
	Set $Ztrap="DeleteDataERR" Set extentlock=0,sc=""
	If concurrency { If '$tlevel { Kill %0CacheLock } If $increment(%0CacheLock($classname()))>$zu(115,6) { Lock +(^BEDD.EDSYSTEMD):$zu(115,4) Set extentlock=$test Lock:extentlock -(^BEDD.EDSYSTEMD) } If 'extentlock { Lock +(^BEDD.EDSYSTEMD(id)):$zu(115,4) } If '$test { QUIT $$Error^%apiOBJ(5803,$classname()) }}
	If ($Data(^BEDD.EDSYSTEMD(id))) {
		Set bsv0N1=^BEDD.EDSYSTEMD(id)
		If $data(^oddEXTR($classname())) {
			n %fc,%fk,%z
			Set %fc="" For  Set %fc=$order(^oddEXTR($classname(),"n","IDKEY","f",%fc)) Quit:%fc=""  Set %fk="" For  Set %fk=$order(^oddEXTR($classname(),"n","IDKEY","f",%fc,%fk)) Quit:%fk=""  Set %z=$get(^oddEXTR($classname(),"n","IDKEY","f",%fc,%fk,61)) If %z'="" Set sc=$classmethod(%fc,%fk_"Delete",id) If ('sc) Goto DeleteDataEXIT
		}
		Kill ^BEDD.EDSYSTEMI("SiteIdx",$zu(28,$listget(bsv0N1,8),7,32768),id)
		Kill ^BEDD.EDSYSTEMD(id)
		Set sc=1
	}
	else { set sc=$$Error^%apiOBJ(5810,$classname(),id) }
DeleteDataEXIT
	If (concurrency) && ('extentlock) { Lock -(^BEDD.EDSYSTEMD(id)) }
DeleteDataRET	Set $Ztrap = ""
	QUIT sc
DeleteDataERR	Set $Ztrap = "DeleteDataRET"
	Set sc = $$Error^%apiOBJ(5002,$ZE)
	Goto DeleteDataEXIT }
%Exists(oid="") public {
	Quit ..%ExistsId($listget(oid)) }
%ExistsId(id) public {
	try { set tExists = $s(id="":0,$d(^BEDD.EDSYSTEMD(id)):1,1:0) } catch tException { set tExists = 0 } quit tExists }
%FileIndices(id,pIndexHandle=0) public {
	s $ZTrap="CatchError",sc=1
	Set bsv0N2=$Get(^BEDD.EDSYSTEMD(id))
	if $listget(bsv0N2,1)'="" { set bsv0N1=$piece($listget(bsv0N2,1),$extract($listget(bsv0N2,1)),$length($listget(bsv0N2,1),$extract($listget(bsv0N2,1)))-1) set:bsv0N1'["." bsv0N1="User."_bsv0N1 if bsv0N1'=$classname() { quit $classmethod(bsv0N1,"%FileIndices",id,.pIndexHandle) } }
	If ('pIndexHandle)||($Ascii($Get(pIndexHandle("BEDD.EDSYSTEM")),1)) {
		Set bsv0N3=$zu(28,$listget(bsv0N2,8),7,32768)
		Set ^BEDD.EDSYSTEMI("SiteIdx",bsv0N3,id)=$listget(bsv0N2,1)
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
			s id=$i(^BEDD.EDSYSTEMD)
			Set lock=0,locku=""
			If '$Tlevel { Kill %0CacheLock }
			i concurrency { If $i(%0CacheLock($classname()))>$zu(115,6) { Lock +(^BEDD.EDSYSTEMD):$zu(115,4) Set lock=$Select($test:2,1:0) Lock:lock -(^BEDD.EDSYSTEMD) } Else { Lock +(^BEDD.EDSYSTEMD(id)):$zu(115,4) Set lock=$Select($test:1,1:0) } If 'lock { Set sc=$$Error^%apiOBJ(5803,$classname()) Quit } }
			s ^BEDD.EDSYSTEMD(id)=data
			s ^BEDD.EDSYSTEMI("SiteIdx",$zu(28,$listget(data,8),7,32768),id)=$listget(data,1)
		}
		while 0
		If lock=1 Lock -(^BEDD.EDSYSTEMD(id))
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
	Kill ^BEDD.EDSYSTEMD
	Quit 1
%LoadData(id)
	New sc
	Set sc=""
	If ..%Concurrency=4 Lock +(^BEDD.EDSYSTEMD(id)):$zu(115,4) If '$test QUIT $$Error^%apiOBJ(5803,$classname())
	If ..%Concurrency'=4,..%Concurrency>1 Lock +(^BEDD.EDSYSTEMD(id)#"S"):$zu(115,4) If '$test QUIT $$Error^%apiOBJ(5804,$classname())
	i '$d(^BEDD.EDSYSTEMD(id)) Do
	. s i%AMERMnu="",i%AutoNote="",i%ChargeNrseA="",i%ChargeNrseP="",i%ChiefofStaff="",i%CommBoard="",i%FlagInjury="",i%MedRec="",i%NrseMgr="",i%PCPFlag="",i%Pager="",i%PendingStsLookBack="",i%Phone="",i%Prnt1="",i%Prnt2="",i%PtArmBand="",i%PtLabels="",i%PtRtSheet="",i%RtSheet="",i%SMTPSERVER="",i%ShoCons="",i%ShoDlySum="",i%ShoNrse="",i%ShoPrv="",i%ShoUsedRm="",i%Site="",i%StandAlone="",i%Status="",i%SwitchEHRPat="",i%TimeOut="",i%TriageRpt="",i%TwoClinics="",i%Verify=""
	. Set i%WhiteboardShowAcuity="",i%WhiteboardShowAge="",i%WhiteboardShowChartNumber="",i%WhiteboardShowComplaint="",i%WhiteboardShowName="",i%WhiteboardShowNotes="",i%WhiteboardShowNurse="",i%WhiteboardShowOrders="",i%WhiteboardShowProvider="",i%WhiteboardShowRoom=""
	Else  Do
	. New %s1
	. Set sc=1
	. s %s1=$g(^BEDD.EDSYSTEMD(id))
	. s i%SMTPSERVER=$lg(%s1,2),i%ChiefofStaff=$lg(%s1,3),i%NrseMgr=$lg(%s1,4),i%Phone=$lg(%s1,5),i%Pager=$lg(%s1,6),i%Status=$lg(%s1,7),i%Site=$lg(%s1,8),i%TwoClinics=$lg(%s1,9),i%MedRec=$lg(%s1,10),i%RtSheet=$lg(%s1,11),i%PtRtSheet=$lg(%s1,12),i%PtLabels=$lg(%s1,13),i%PtArmBand=$lg(%s1,14),i%TriageRpt=$lg(%s1,15),i%StandAlone=$lg(%s1,16),i%ShoUsedRm=$lg(%s1,17),i%ShoNrse=$lg(%s1,18),i%ShoPrv=$lg(%s1,19),i%CommBoard=$lg(%s1,20),i%AMERMnu=$lg(%s1,21),i%AutoNote=$lg(%s1,22),i%PCPFlag=$lg(%s1,23)
	. s i%FlagInjury=$lg(%s1,24),i%Prnt1=$lg(%s1,25),i%Prnt2=$lg(%s1,26),i%ChargeNrseA=$lg(%s1,27),i%ChargeNrseP=$lg(%s1,28),i%ShoCons=$lg(%s1,29),i%ShoDlySum=$lg(%s1,30),i%TimeOut=$lg(%s1,31),i%SwitchEHRPat=$lg(%s1,33),i%PendingStsLookBack=$lg(%s1,34),i%Verify=$lg(%s1,35),i%WhiteboardShowProvider=$lg(%s1,42),i%WhiteboardShowNurse=$lg(%s1,43),i%WhiteboardShowOrders=$lg(%s1,44),i%WhiteboardShowNotes=$lg(%s1,45),i%WhiteboardShowAge=$lg(%s1,46),i%WhiteboardShowComplaint=$lg(%s1,47)
	. s i%WhiteboardShowChartNumber=$lg(%s1,48),i%WhiteboardShowRoom=$lg(%s1,49),i%WhiteboardShowName=$lg(%s1,50),i%WhiteboardShowAcuity=$lg(%s1,51)
	If ..%Concurrency=2 Lock -(^BEDD.EDSYSTEMD(id)#"SI")
	Quit $select(sc'="":sc,1:$$Error^%apiOBJ(5809,$classname(),id))
%LoadDataFromMemory(id,objstate,obj)
	New sc
	Set sc=""
	i '$d(objstate(id)) Do
	. Set i%AMERMnu="",i%AutoNote="",i%ChargeNrseA="",i%ChargeNrseP="",i%ChiefofStaff="",i%CommBoard="",i%FlagInjury="",i%MedRec="",i%NrseMgr="",i%PCPFlag="",i%Pager="",i%PendingStsLookBack="",i%Phone="",i%Prnt1="",i%Prnt2="",i%PtArmBand="",i%PtLabels="",i%PtRtSheet="",i%RtSheet="",i%SMTPSERVER="",i%ShoCons="",i%ShoDlySum="",i%ShoNrse="",i%ShoPrv="",i%ShoUsedRm="",i%Site="",i%StandAlone="",i%Status="",i%SwitchEHRPat="",i%TimeOut="",i%TriageRpt="",i%TwoClinics="",i%Verify="",i%WhiteboardShowAcuity=""
	. Set i%WhiteboardShowAge="",i%WhiteboardShowChartNumber="",i%WhiteboardShowComplaint="",i%WhiteboardShowName="",i%WhiteboardShowNotes="",i%WhiteboardShowNurse="",i%WhiteboardShowOrders="",i%WhiteboardShowProvider="",i%WhiteboardShowRoom=""
	Else  Do
	. New %s1
	. Set sc=1
	. s %s1=$g(objstate(id))
	. s i%SMTPSERVER=$lg(%s1,2),i%ChiefofStaff=$lg(%s1,3),i%NrseMgr=$lg(%s1,4),i%Phone=$lg(%s1,5),i%Pager=$lg(%s1,6),i%Status=$lg(%s1,7),i%Site=$lg(%s1,8),i%TwoClinics=$lg(%s1,9),i%MedRec=$lg(%s1,10),i%RtSheet=$lg(%s1,11),i%PtRtSheet=$lg(%s1,12),i%PtLabels=$lg(%s1,13),i%PtArmBand=$lg(%s1,14),i%TriageRpt=$lg(%s1,15),i%StandAlone=$lg(%s1,16),i%ShoUsedRm=$lg(%s1,17),i%ShoNrse=$lg(%s1,18),i%ShoPrv=$lg(%s1,19),i%CommBoard=$lg(%s1,20),i%AMERMnu=$lg(%s1,21),i%AutoNote=$lg(%s1,22),i%PCPFlag=$lg(%s1,23)
	. s i%FlagInjury=$lg(%s1,24),i%Prnt1=$lg(%s1,25),i%Prnt2=$lg(%s1,26),i%ChargeNrseA=$lg(%s1,27),i%ChargeNrseP=$lg(%s1,28),i%ShoCons=$lg(%s1,29),i%ShoDlySum=$lg(%s1,30),i%TimeOut=$lg(%s1,31),i%SwitchEHRPat=$lg(%s1,33),i%PendingStsLookBack=$lg(%s1,34),i%Verify=$lg(%s1,35),i%WhiteboardShowProvider=$lg(%s1,42),i%WhiteboardShowNurse=$lg(%s1,43),i%WhiteboardShowOrders=$lg(%s1,44),i%WhiteboardShowNotes=$lg(%s1,45),i%WhiteboardShowAge=$lg(%s1,46),i%WhiteboardShowComplaint=$lg(%s1,47)
	. s i%WhiteboardShowChartNumber=$lg(%s1,48),i%WhiteboardShowRoom=$lg(%s1,49),i%WhiteboardShowName=$lg(%s1,50),i%WhiteboardShowAcuity=$lg(%s1,51)
	Set sc = $select(sc'="":sc,1:$$Error^%apiOBJ(5809,$classname(),id))
	 Quit sc
%LockExtent(shared=0) public {
	if shared { l +(^BEDD.EDSYSTEMD#"S"):$zu(115,4) if $t { q 1 } else { q $$Error^%apiOBJ(5799,$classname()) }} l +(^BEDD.EDSYSTEMD):$zu(115,4) if $t { q 1 } else { q $$Error^%apiOBJ(5798,$classname()) }
}
%LockId(id,shared=0) public {
	if id'="" { set sc=1 } else { set sc=$$Error^%apiOBJ(5812) quit sc }
	if 'shared { Lock +(^BEDD.EDSYSTEMD(id)):$zu(115,4) i $test { q 1 } else { q $$Error^%apiOBJ(5803,$classname()) } }
	else { Lock +(^BEDD.EDSYSTEMD(id)#"S"):$zu(115,4) if $test { q 1 } else { q $$Error^%apiOBJ(5804,$classname()) } }
}
%NormalizeObject() public {
	If '$system.CLS.GetModified() Quit 1
	If m%AMERMnu Set:i%AMERMnu'="" i%AMERMnu=(..AMERMnuNormalize(i%AMERMnu))
	If m%AutoNote Set:i%AutoNote'="" i%AutoNote=(..AutoNoteNormalize(i%AutoNote))
	If m%ChargeNrseA Set:i%ChargeNrseA'="" i%ChargeNrseA=(..ChargeNrseANormalize(i%ChargeNrseA))
	If m%ChargeNrseP Set:i%ChargeNrseP'="" i%ChargeNrseP=(..ChargeNrsePNormalize(i%ChargeNrseP))
	If m%ChiefofStaff Set:i%ChiefofStaff'="" i%ChiefofStaff=(..ChiefofStaffNormalize(i%ChiefofStaff))
	If m%CommBoard Set:i%CommBoard'="" i%CommBoard=(..CommBoardNormalize(i%CommBoard))
	If m%FlagInjury Set:i%FlagInjury'="" i%FlagInjury=(..FlagInjuryNormalize(i%FlagInjury))
	If m%MedRec Set:i%MedRec'="" i%MedRec=(..MedRecNormalize(i%MedRec))
	If m%NrseMgr Set:i%NrseMgr'="" i%NrseMgr=(..NrseMgrNormalize(i%NrseMgr))
	If m%PCPFlag Set:i%PCPFlag'="" i%PCPFlag=(..PCPFlagNormalize(i%PCPFlag))
	If m%Pager Set:i%Pager'="" i%Pager=(..PagerNormalize(i%Pager))
	If m%PendingStsLookBack Set:i%PendingStsLookBack'="" i%PendingStsLookBack=(..PendingStsLookBackNormalize(i%PendingStsLookBack))
	If m%Phone Set:i%Phone'="" i%Phone=(..PhoneNormalize(i%Phone))
	If m%Prnt1 Set:i%Prnt1'="" i%Prnt1=(..Prnt1Normalize(i%Prnt1))
	If m%Prnt2 Set:i%Prnt2'="" i%Prnt2=(..Prnt2Normalize(i%Prnt2))
	If m%PtArmBand Set:i%PtArmBand'="" i%PtArmBand=(..PtArmBandNormalize(i%PtArmBand))
	If m%PtLabels Set:i%PtLabels'="" i%PtLabels=(..PtLabelsNormalize(i%PtLabels))
	If m%PtRtSheet Set:i%PtRtSheet'="" i%PtRtSheet=(..PtRtSheetNormalize(i%PtRtSheet))
	If m%RtSheet Set:i%RtSheet'="" i%RtSheet=(..RtSheetNormalize(i%RtSheet))
	If m%SMTPSERVER Set:i%SMTPSERVER'="" i%SMTPSERVER=(..SMTPSERVERNormalize(i%SMTPSERVER))
	If m%ShoCons Set:i%ShoCons'="" i%ShoCons=(..ShoConsNormalize(i%ShoCons))
	If m%ShoDlySum Set:i%ShoDlySum'="" i%ShoDlySum=(..ShoDlySumNormalize(i%ShoDlySum))
	If m%ShoNrse Set:i%ShoNrse'="" i%ShoNrse=(..ShoNrseNormalize(i%ShoNrse))
	If m%ShoPrv Set:i%ShoPrv'="" i%ShoPrv=(..ShoPrvNormalize(i%ShoPrv))
	If m%ShoUsedRm Set:i%ShoUsedRm'="" i%ShoUsedRm=(..ShoUsedRmNormalize(i%ShoUsedRm))
	If m%Site Set:i%Site'="" i%Site=(..SiteNormalize(i%Site))
	If m%StandAlone Set:i%StandAlone'="" i%StandAlone=(..StandAloneNormalize(i%StandAlone))
	If m%Status Set:i%Status'="" i%Status=(..StatusNormalize(i%Status))
	If m%SwitchEHRPat Set:i%SwitchEHRPat'="" i%SwitchEHRPat=(..SwitchEHRPatNormalize(i%SwitchEHRPat))
	If m%TimeOut Set:i%TimeOut'="" i%TimeOut=(..TimeOutNormalize(i%TimeOut))
	If m%TriageRpt Set:i%TriageRpt'="" i%TriageRpt=(..TriageRptNormalize(i%TriageRpt))
	If m%TwoClinics Set:i%TwoClinics'="" i%TwoClinics=(..TwoClinicsNormalize(i%TwoClinics))
	If m%Verify Set:i%Verify'="" i%Verify=(..VerifyNormalize(i%Verify))
	If m%WhiteboardShowAcuity Set:i%WhiteboardShowAcuity'="" i%WhiteboardShowAcuity=(..WhiteboardShowAcuityNormalize(i%WhiteboardShowAcuity))
	If m%WhiteboardShowAge Set:i%WhiteboardShowAge'="" i%WhiteboardShowAge=(..WhiteboardShowAgeNormalize(i%WhiteboardShowAge))
	If m%WhiteboardShowChartNumber Set:i%WhiteboardShowChartNumber'="" i%WhiteboardShowChartNumber=(..WhiteboardShowChartNumberNormalize(i%WhiteboardShowChartNumber))
	If m%WhiteboardShowComplaint Set:i%WhiteboardShowComplaint'="" i%WhiteboardShowComplaint=(..WhiteboardShowComplaintNormalize(i%WhiteboardShowComplaint))
	If m%WhiteboardShowName Set:i%WhiteboardShowName'="" i%WhiteboardShowName=(..WhiteboardShowNameNormalize(i%WhiteboardShowName))
	If m%WhiteboardShowNotes Set:i%WhiteboardShowNotes'="" i%WhiteboardShowNotes=(..WhiteboardShowNotesNormalize(i%WhiteboardShowNotes))
	If m%WhiteboardShowNurse Set:i%WhiteboardShowNurse'="" i%WhiteboardShowNurse=(..WhiteboardShowNurseNormalize(i%WhiteboardShowNurse))
	If m%WhiteboardShowOrders Set:i%WhiteboardShowOrders'="" i%WhiteboardShowOrders=(..WhiteboardShowOrdersNormalize(i%WhiteboardShowOrders))
	If m%WhiteboardShowProvider Set:i%WhiteboardShowProvider'="" i%WhiteboardShowProvider=(..WhiteboardShowProviderNormalize(i%WhiteboardShowProvider))
	If m%WhiteboardShowRoom Set:i%WhiteboardShowRoom'="" i%WhiteboardShowRoom=(..WhiteboardShowRoomNormalize(i%WhiteboardShowRoom))
	Quit 1 }
%OnDetermineClass(oid,class)
	New id,idclass
	Set id=$listget($get(oid)) QUIT:id="" $$Error^%apiOBJ(5812)
	Set idclass=$lg($get(^BEDD.EDSYSTEMD(id)),1)
	If idclass="" Set class="BEDD.EDSYSTEM" Quit 1
	Set class=$piece(idclass,$extract(idclass),$length(idclass,$extract(idclass))-1)
	Set:class'["." class="User."_class
	QUIT 1
%PhysicalAddress(id,paddr)
	if $Get(id)="" Quit $$Error^%apiOBJ(5813,$classname())
	if (id="") { quit $$Error^%apiOBJ(5832,$classname(),id) }
	s paddr(1)=$lb($Name(^BEDD.EDSYSTEMD(id)),$classname(),"IDKEY","listnode",id)
	s paddr=1
	Quit 1
%PurgeIndices(idxlist="",lockExtent=0)
	n locked,ptr,sc
	s $ZTrap="CatchError",locked=0,sc=1
	for ptr=1:1:$listlength(idxlist) { if '($d(^oddCOM($classname(),"i",$list(idxlist,ptr)))) { set sc=$$Error^%apiOBJ(5066,$classname()_"::"_$list(idxlist,ptr)) continue } } if ('sc) { quit sc }
	i lockExtent { s sc=..%LockExtent(0) i ('sc) { q sc } else { s locked=1 } }
	if $system.CLS.IsMthd($classname(),"%OnBeforeBuildIndices") { set sc=..%OnBeforePurgeIndices(.idxlist) i ('sc) { i locked { d ..%SQLReleaseTableLock(0) } quit sc } }
	If $select($listfind(idxlist,"SiteIdx"):1,idxlist="":1,1:0) Kill ^BEDD.EDSYSTEMI("SiteIdx")
	s sc=1
	if $system.CLS.IsMthd($classname(),"%OnAfterPurgeIndices") { set sc=..%OnAfterPurgeIndices(.idxlist) }
	i locked { d ..%UnlockExtent(0) }
	QUIT sc
CatchError	s $ZTrap="" i $ZE'="" { s sc = $$Error^%apiOBJ(5002,$ZE) } i locked { d ..%UnlockExtent(0) } q sc
	i locked { d ..%UnlockExtent(0) }
	QUIT sc
%SQLAcquireLock(%rowid,s=0,unlockref)
	new %d,gotlock set %d(1)=%rowid set s=$e("S",s) lock +^BEDD.EDSYSTEMD(%d(1))#s:$zu(115,4) set gotlock=$t set:gotlock&&$g(unlockref) unlockref($i(unlockref))=$lb($name(^BEDD.EDSYSTEMD(%d(1))),"BEDD.EDSYSTEM") QUIT gotlock
	Quit
%SQLAcquireTableLock(s=0,SQLCODE,to="")
	set s=$e("S",s) set:to="" to=$zu(115,4) lock +^BEDD.EDSYSTEMD#s:to QUIT:$t 1 set SQLCODE=-110 if s="S" { set %msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler35",,"BEDD"_"."_"EDSYSTEM") } else { set %msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler36",,"BEDD"_"."_"EDSYSTEM") } QUIT 0
	Quit
%SQLBuildIndices(pIndices="")
	QUIT ..%BuildIndices(pIndices)
%SQLCopyIcolIntoName()
	if %oper="DELETE" {
		set:$d(%d(1)) %f("ID")=%d(1)
		QUIT
	}
	set:$d(%d(1)) %f("ID")=%d(1) set:$a(%e,2)&&$d(%d(2)) %f("AMERMnu")=%d(2) set:$a(%e,3)&&$d(%d(3)) %f("AutoNote")=%d(3) set:$a(%e,4)&&$d(%d(4)) %f("ChargeNrseA")=%d(4) set:$a(%e,5)&&$d(%d(5)) %f("ChargeNrseP")=%d(5) set:$a(%e,6)&&$d(%d(6)) %f("ChiefofStaff")=%d(6) set:$a(%e,7)&&$d(%d(7)) %f("CommBoard")=%d(7) set:$a(%e,8)&&$d(%d(8)) %f("FlagInjury")=%d(8) set:$a(%e,9)&&$d(%d(9)) %f("LabelPrnt1")=%d(9) set:$a(%e,10)&&$d(%d(10)) %f("LabelPrnt2")=%d(10) set:$a(%e,11)&&$d(%d(11)) %f("MedRec")=%d(11) set:$a(%e,12)&&$d(%d(12)) %f("NrseMgr")=%d(12) set:$a(%e,13)&&$d(%d(13)) %f("PCPFlag")=%d(13) set:$a(%e,14)&&$d(%d(14)) %f("Pager")=%d(14) set:$a(%e,15)&&$d(%d(15)) %f("PendingStsLookBack")=%d(15) set:$a(%e,16)&&$d(%d(16)) %f("Phone")=%d(16) set:$a(%e,17)&&$d(%d(17)) %f("Prnt1")=%d(17) set:$a(%e,18)&&$d(%d(18)) %f("Prnt2")=%d(18) set:$a(%e,19)&&$d(%d(19)) %f("PtArmBand")=%d(19) set:$a(%e,20)&&$d(%d(20)) %f("PtLabels")=%d(20) set:$a(%e,21)&&$d(%d(21)) %f("PtRtSheet")=%d(21) set:$a(%e,22)&&$d(%d(22)) %f("RtSheet")=%d(22) set:$a(%e,23)&&$d(%d(23)) %f("SMTPSERVER")=%d(23) set:$a(%e,24)&&$d(%d(24)) %f("ShoCons")=%d(24) set:$a(%e,25)&&$d(%d(25)) %f("ShoDlySum")=%d(25) set:$a(%e,26)&&$d(%d(26)) %f("ShoNrse")=%d(26) set:$a(%e,27)&&$d(%d(27)) %f("ShoPrv")=%d(27) set:$a(%e,28)&&$d(%d(28)) %f("ShoUsedRm")=%d(28) set:$a(%e,29)&&$d(%d(29)) %f("Site")=%d(29) set:$a(%e,30)&&$d(%d(30)) %f("SiteName")=%d(30) set:$a(%e,31)&&$d(%d(31)) %f("StandAlone")=%d(31) set:$a(%e,32)&&$d(%d(32)) %f("Status")=%d(32) set:$a(%e,33)&&$d(%d(33)) %f("SwitchEHRPat")=%d(33) set:$a(%e,34)&&$d(%d(34)) %f("TimeOut")=%d(34) set:$a(%e,35)&&$d(%d(35)) %f("TriageRpt")=%d(35) set:$a(%e,36)&&$d(%d(36)) %f("TwoClinics")=%d(36) set:$a(%e,37)&&$d(%d(37)) %f("Verify")=%d(37) set:$a(%e,38)&&$d(%d(38)) %f("WhiteboardShowAcuity")=%d(38) set:$a(%e,39)&&$d(%d(39)) %f("WhiteboardShowAge")=%d(39) set:$a(%e,40)&&$d(%d(40)) %f("WhiteboardShowChartNumber")=%d(40) set:$a(%e,41)&&$d(%d(41)) %f("WhiteboardShowComplaint")=%d(41) set:$a(%e,42)&&$d(%d(42)) %f("WhiteboardShowName")=%d(42) set:$a(%e,43)&&$d(%d(43)) %f("WhiteboardShowNotes")=%d(43) set:$a(%e,44)&&$d(%d(44)) %f("WhiteboardShowNurse")=%d(44) set:$a(%e,45)&&$d(%d(45)) %f("WhiteboardShowOrders")=%d(45) set:$a(%e,46)&&$d(%d(46)) %f("WhiteboardShowProvider")=%d(46) set:$a(%e,47)&&$d(%d(47)) %f("WhiteboardShowRoom")=%d(47) set:$a(%e,48)&&$d(%d(48)) %f("x__classname")=%d(48)
	QUIT
%SQLDefineiDjVars(%d,subs)
	QUIT
%SQLDelete(%rowid,%check,%tstart=1,%mv=0,%polymorphic=0)
	new bva,ce,%d,dc,%e,%ele,%itm,%key,%l,%nc,omcall,%oper,%pos,%s,sn,sqlcode,subs set %oper="DELETE",sqlcode=0,%ROWID=%rowid,%d(1)=%rowid,%e(1)=%rowid,%l=$c(0)
	if '$d(%0CacheSQLRA) new %0CacheSQLRA set omcall=1
	k:'$TLEVEL %0CacheLock if '$a(%check,2) { new %ls if $i(%0CacheLock("BEDD.EDSYSTEM"))>$zu(115,6) { lock +^BEDD.EDSYSTEMD:$zu(115,4) lock:$t -^BEDD.EDSYSTEMD set %ls=$s($t:2,1:0) } else { lock +^BEDD.EDSYSTEMD(%d(1)):$zu(115,4) set %ls=$t } set:%ls=2 $e(%check,2)=$c(1) set:%ls=1 $e(%l)=$c(1) if '%ls set SQLCODE=-110,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler40",,%oper,"BEDD"_"."_"EDSYSTEM",$g(%d(1))) QUIT  } if %tstart { TSTART:($zu(115,1)=1)||('$TLEVEL&&($zu(115,1)=2))  } set $zt="ERRORDelete"
	do ..%SQLGetOld() if sqlcode set SQLCODE=-106 do ..%SQLEExit() QUIT  
	if %e(48)'="" set sn=$p(%e(48),$e(%e(48)),$l(%e(48),$e(%e(48)))-1) if "BEDD.EDSYSTEM"'=sn new %f do ..%SQLCopyIcolIntoName() do $classmethod(sn,"%SQLDelete",%rowid,%check,%tstart,%mv,1) QUIT  
	if '$a(%check),'$zu(115,7) do  if sqlcode set SQLCODE=sqlcode do ..%SQLEExit() QUIT  
	. new %fk,%k,%p,%st,%t,%z set %k="",%p("%1")="%d(1),",%p("IDKEY")="%d(1),"
	. for  quit:sqlcode<0  set %k=$o(^oddEXTR("BEDD.EDSYSTEM","n",%k)) quit:%k=""  set %t="" for  set %t=$o(^oddEXTR("BEDD.EDSYSTEM","n",%k,"f",%t)) quit:%t=""  set %st=(%t="BEDD.EDSYSTEM") set %fk="" for  set %fk=$order(^oddEXTR("BEDD.EDSYSTEM","n",%k,"f",%t,%fk)) quit:%fk=""  x "set %z=$classmethod(%t,%fk_""SQLFKeyRefAction"",%st,%k,"_%p(%k)_")" if %z set sqlcode=-124 quit  
	set ce="" for  { set ce=$order(^oddSQL("BEDD","EDSYSTEM","DC",ce)) quit:ce=""   do $classmethod(ce,"%SQLDeleteChildren",%d(1),%check,.sqlcode) quit:sqlcode<0  } if sqlcode<0 { set SQLCODE=sqlcode do ..%SQLEExit() QUIT } // Delete any children
	s sn(1)=$zu(28,%e(29),7) s sn(2)=%d(1) k ^BEDD.EDSYSTEMI("SiteIdx",sn(1),sn(2))
	k ^BEDD.EDSYSTEMD(%d(1))
	do ..%SQLUnlock() TCOMMIT:%tstart&&($zu(115,1)=1)
	set SQLCODE=0 kill:$g(omcall) %0CacheSQLRA QUIT
ERRORDelete	set $zt="",SQLCODE=-415,%msg=$s($g(%msg)'="":%msg_" -- ",1:"")_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler51",,%oper,"BEDD"_"."_"EDSYSTEM",$ze) if $ze["<FRAMESTACK>" { set %msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler52",,$ze,%oper,"BEDD"_"."_"EDSYSTEM") do ##Class(%SYS.System).WriteToConsoleLog(%msg) if ($zu(67,10,$j)=1)||($zu(67,10,$j)=3) { write !,%msg h 3 } HALT  } do ..%SQLEExit() QUIT
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
	if '..%SQLGetLock(id,1,.pUnlockRef) { set sqlcode=-114,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler39",,"BEDD"_"."_"EDSYSTEM"_":"_"%1") QUIT 0 }
	if 'pLockOnly { new qv set qv=$d(^BEDD.EDSYSTEMD(%pVal(1))) do:'$g(pUnlockRef) ..%SQLReleaseLock(id,1) quit qv } else { do:'$g(pUnlockRef) ..%SQLReleaseLock(id,1) QUIT 1 }
	Quit
%SQLGetLock(pRowId,pShared=0,pUnlockRef)
	kill:'$TLEVEL %0CacheLock
	if $i(%0CacheLock("BEDD.EDSYSTEM"))>$zu(115,6) { lock +^BEDD.EDSYSTEMD:$zu(115,4) lock:$t -^BEDD.EDSYSTEMD QUIT $s($t:2,1:0) } 
	QUIT ..%SQLAcquireLock(pRowId,pShared,.pUnlockRef)
%SQLGetOld()
	new s if '$d(^BEDD.EDSYSTEMD(%d(1)),s) { set sqlcode=100 quit  } set %e(48)=$lg(s) set %e(29)=$lg(s,8)
	QUIT
%SQLGetOldAll()
	// Get all old data values
	 ;---&sql(SELECT AMERMnu,AutoNote,ChargeNrseA,ChargeNrseP,ChiefofStaff,CommBoard,FlagInjury,LabelPrnt1,LabelPrnt2,MedRec,NrseMgr,PCPFlag,Pager,PendingStsLookBack,Phone,Prnt1,Prnt2,PtArmBand,PtLabels,PtRtSheet,RtSheet,SMTPSERVER,ShoCons,ShoDlySum,ShoNrse,ShoPrv,ShoUsedRm,Site,SiteName,StandAlone,Status,SwitchEHRPat,TimeOut,TriageRpt,TwoClinics,Verify,WhiteboardShowAcuity,WhiteboardShowAge,WhiteboardShowChartNumber,WhiteboardShowComplaint,WhiteboardShowName,WhiteboardShowNotes,WhiteboardShowNurse,WhiteboardShowOrders,WhiteboardShowProvider,WhiteboardShowRoom,x__classname INTO :%e() FROM BEDD.EDSYSTEM WHERE ID=:%rowid) set sqlcode=SQLCODE quit
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
 i %mmmsqld(4)'="",$d(^BEDD.EDSYSTEMD(%mmmsqld(4)))
 e  g %0AmBdun
 s %mmmsqld(5)=$g(^BEDD.EDSYSTEMD(%mmmsqld(4))) s %e(2)=$lg(%mmmsqld(5),21) s %e(3)=$lg(%mmmsqld(5),22) s %e(4)=$lg(%mmmsqld(5),27) s %e(5)=$lg(%mmmsqld(5),28) s %e(6)=$lg(%mmmsqld(5),3) s %e(7)=$lg(%mmmsqld(5),20) s %e(8)=$lg(%mmmsqld(5),24) s %e(11)=$lg(%mmmsqld(5),10) s %e(12)=$lg(%mmmsqld(5),4) s %e(13)=$lg(%mmmsqld(5),23) s %e(14)=$lg(%mmmsqld(5),6) s %e(15)=$lg(%mmmsqld(5),34) s %e(16)=$lg(%mmmsqld(5),5) s %e(17)=$lg(%mmmsqld(5),25) s %e(18)=$lg(%mmmsqld(5),26) s %e(19)=$lg(%mmmsqld(5),14) s %e(20)=$lg(%mmmsqld(5),13) s %e(21)=$lg(%mmmsqld(5),12) s %e(22)=$lg(%mmmsqld(5),11) s %e(23)=$lg(%mmmsqld(5),2) s %e(24)=$lg(%mmmsqld(5),29) s %e(25)=$lg(%mmmsqld(5),30) s %e(26)=$lg(%mmmsqld(5),18) s %e(27)=$lg(%mmmsqld(5),19) s %e(28)=$lg(%mmmsqld(5),17) s %e(29)=$lg(%mmmsqld(5),8) s %e(31)=$lg(%mmmsqld(5),16) s %e(32)=$lg(%mmmsqld(5),7) s %e(33)=$lg(%mmmsqld(5),33) s %e(34)=$lg(%mmmsqld(5),31) s %e(35)=$lg(%mmmsqld(5),15) s %e(36)=$lg(%mmmsqld(5),9) s %e(37)=$lg(%mmmsqld(5),35)
 s %e(38)=$lg(%mmmsqld(5),51) s %e(39)=$lg(%mmmsqld(5),46) s %e(40)=$lg(%mmmsqld(5),48) s %e(41)=$lg(%mmmsqld(5),47) s %e(42)=$lg(%mmmsqld(5),50) s %e(43)=$lg(%mmmsqld(5),45) s %e(44)=$lg(%mmmsqld(5),43) s %e(45)=$lg(%mmmsqld(5),44) s %e(46)=$lg(%mmmsqld(5),42) s %e(47)=$lg(%mmmsqld(5),49) s %e(48)=$lg(%mmmsqld(5),1)
 d
 . Set %e(9)=##class(CNDHED.EDSYSTEM).GetPName(%e(17))
 d
 . Set %e(10)=##class(CNDHED.EDSYSTEM).GetPName(%e(18))
 d
 . Set %e(30)=##class(BEDD.EDSYSTEM).GetName(%e(29))
 g:$zu(115,2)=0 %0AmBuncommitted i $zu(115,2)=1 l +^BEDD.EDSYSTEMD($p(%mmmsqld(4),"||",1))#"S":$zu(115,4) i $t { s %mmmsqld(1)=1,%mmmsqld(2)=$name(^BEDD.EDSYSTEMD($p(%mmmsqld(4),"||",1)))_"#""SI""" } else { s SQLCODE=-114,%msg="Unable to acquire shared lock on table BEDD.EDSYSTEM for RowID value: "_%mmmsqld(4) ztrap "LOCK"  }
 ; asl MOD# 3
 i %mmmsqld(4)'="",$d(^BEDD.EDSYSTEMD(%mmmsqld(4)))
 e  g %0AmCdun
 s %mmmsqld(6)=$g(^BEDD.EDSYSTEMD(%mmmsqld(4))) s %e(2)=$lg(%mmmsqld(6),21) s %e(3)=$lg(%mmmsqld(6),22) s %e(4)=$lg(%mmmsqld(6),27) s %e(5)=$lg(%mmmsqld(6),28) s %e(6)=$lg(%mmmsqld(6),3) s %e(7)=$lg(%mmmsqld(6),20) s %e(8)=$lg(%mmmsqld(6),24) s %e(11)=$lg(%mmmsqld(6),10) s %e(12)=$lg(%mmmsqld(6),4) s %e(13)=$lg(%mmmsqld(6),23) s %e(14)=$lg(%mmmsqld(6),6) s %e(15)=$lg(%mmmsqld(6),34) s %e(16)=$lg(%mmmsqld(6),5) s %e(17)=$lg(%mmmsqld(6),25) s %e(18)=$lg(%mmmsqld(6),26) s %e(19)=$lg(%mmmsqld(6),14) s %e(20)=$lg(%mmmsqld(6),13) s %e(21)=$lg(%mmmsqld(6),12) s %e(22)=$lg(%mmmsqld(6),11) s %e(23)=$lg(%mmmsqld(6),2) s %e(24)=$lg(%mmmsqld(6),29) s %e(25)=$lg(%mmmsqld(6),30) s %e(26)=$lg(%mmmsqld(6),18) s %e(27)=$lg(%mmmsqld(6),19) s %e(28)=$lg(%mmmsqld(6),17) s %e(29)=$lg(%mmmsqld(6),8) s %e(31)=$lg(%mmmsqld(6),16) s %e(32)=$lg(%mmmsqld(6),7) s %e(33)=$lg(%mmmsqld(6),33) s %e(34)=$lg(%mmmsqld(6),31) s %e(35)=$lg(%mmmsqld(6),15) s %e(36)=$lg(%mmmsqld(6),9) s %e(37)=$lg(%mmmsqld(6),35)
 s %e(38)=$lg(%mmmsqld(6),51) s %e(39)=$lg(%mmmsqld(6),46) s %e(40)=$lg(%mmmsqld(6),48) s %e(41)=$lg(%mmmsqld(6),47) s %e(42)=$lg(%mmmsqld(6),50) s %e(43)=$lg(%mmmsqld(6),45) s %e(44)=$lg(%mmmsqld(6),43) s %e(45)=$lg(%mmmsqld(6),44) s %e(46)=$lg(%mmmsqld(6),42) s %e(47)=$lg(%mmmsqld(6),49) s %e(48)=$lg(%mmmsqld(6),1)
 d
 . Set %e(9)=##class(CNDHED.EDSYSTEM).GetPName(%e(17))
 d
 . Set %e(10)=##class(CNDHED.EDSYSTEM).GetPName(%e(18))
 d
 . Set %e(30)=##class(BEDD.EDSYSTEM).GetName(%e(29))
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
	if $d(%d(1)),'$zu(115,11) { if %d(1)'="" { set SQLCODE=-111,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler6",,"ID","BEDD"_"."_"EDSYSTEM") QUIT ""  } kill %d(1) } 
	if '$a(%check),'..%SQLValidateFields(.sqlcode) { set SQLCODE=sqlcode QUIT "" }
	do ..%SQLNormalizeFields()
	kill:'$TLEVEL %0CacheLock if %tstart { TSTART:($zu(115,1)=1)||('$TLEVEL&&($zu(115,1)=2))  } set $zt="ERRORInsert"
	if '$a(%check) do  if sqlcode<0 set SQLCODE=sqlcode do ..%SQLEExit() QUIT ""
	. if $g(%vco)'="" do ..%SQLInsertComputes(1) d @%vco quit:sqlcode<0
	if '$d(%d(1)) { set %d(1)=$i(^BEDD.EDSYSTEMD) } elseif %d(1)>$g(^BEDD.EDSYSTEMD) { if $i(^BEDD.EDSYSTEMD,$zabs(%d(1)-$g(^BEDD.EDSYSTEMD))) {}} elseif $d(^BEDD.EDSYSTEMD(%d(1))) { set SQLCODE=-119,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler33",,"ID",%d(1),"BEDD"_"."_"EDSYSTEM"_"."_"ID") do ..%SQLEExit() QUIT "" }
	for icol=48,29 set:'$d(%d(icol)) %d(icol)=""
	if '$a(%check,2) { new %ls if $i(%0CacheLock("BEDD.EDSYSTEM"))>$zu(115,6) { lock +^BEDD.EDSYSTEMD:$zu(115,4) lock:$t -^BEDD.EDSYSTEMD set %ls=$s($t:2,1:0) } else { lock +^BEDD.EDSYSTEMD(%d(1)):$zu(115,4) set %ls=$t } set:%ls=2 $e(%check,2)=$c(1) set:%ls=1 $e(%l)=$c(1) if '%ls set SQLCODE=-110,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler40",,%oper,"BEDD"_"."_"EDSYSTEM",$g(%d(1))) do ..%SQLEExit() QUIT ""  }
	set ^BEDD.EDSYSTEMD(%d(1))=$lb(%d(48),$g(%d(23)),$g(%d(6)),$g(%d(12)),$g(%d(16)),$g(%d(14)),$g(%d(32)),%d(29),$g(%d(36)),$g(%d(11)),$g(%d(22)),$g(%d(21)),$g(%d(20)),$g(%d(19)),$g(%d(35)),$g(%d(31)),$g(%d(28)),$g(%d(26)),$g(%d(27)),$g(%d(7)),$g(%d(2)),$g(%d(3)),$g(%d(13)),$g(%d(8)),$g(%d(17)),$g(%d(18)),$g(%d(4)),$g(%d(5)),$g(%d(24)),$g(%d(25)),$g(%d(34)),,$g(%d(33)),$g(%d(15)),$g(%d(37)),,,,,,,$g(%d(46)),$g(%d(44)),$g(%d(45)),$g(%d(43)),$g(%d(39)),$g(%d(41)),$g(%d(40)),$g(%d(47)),$g(%d(42)),$g(%d(38)))
	i '$a(%check,3) { s sn(1)=$zu(28,%d(29),7) s sn(2)=%d(1) s ^BEDD.EDSYSTEMI("SiteIdx",sn(1),sn(2))=%d(48) }
	lock:$a(%l) -^BEDD.EDSYSTEMD(%d(1))
	TCOMMIT:%tstart&&($zu(115,1)=1)
	set SQLCODE=0 QUIT %d(1) 			// %SQLInsert
ERRORInsert	set $zt="",SQLCODE=-415,%msg=$s($g(%msg)'="":%msg_" -- ",1:"")_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler51",,%oper,"BEDD"_"."_"EDSYSTEM",$ze) if $ze["<FRAMESTACK>" { set %msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler52",,$ze,%oper,"BEDD"_"."_"EDSYSTEM") do ##Class(%SYS.System).WriteToConsoleLog(%msg) if ($zu(67,10,$j)=1)||($zu(67,10,$j)=3) { write !,%msg h 3 } HALT  } do ..%SQLEExit() QUIT ""
	Quit
%SQLInsertComputes(view=0)
	if 'view {
	}
	else {
	set %d(9)="" do ..LabelPrnt1SQLCompute()
	set %d(10)="" do ..LabelPrnt2SQLCompute()
	set %d(30)="" do ..SiteNameSQLCompute()
	}
	QUIT
%SQLInvalid(pIcol,pVal) public {
	set:$l($g(pVal))>40 pVal=$e(pVal,1,40)_"..." do:'$d(%n) ..%SQLnBuild() set %msg=$s($g(%msg)'="":%msg_$c(13,10),1:"")_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler37",,"BEDD"_"."_"EDSYSTEM"_"."_$lg(%n,pIcol),$s($g(pVal)'="":$s(pVal="":"<NULL>",pVal=$c(0):"<EMPTY STRING>",1:"'"_pVal_"'"),1:"")),sqlcode=$s(%oper="INSERT":-104,1:-105)
	QUIT sqlcode }
%SQLMissing(fname)
	set sqlcode=-108,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler47",,fname,"BEDD"_"."_"EDSYSTEM") quit
%SQLNormalizeFields()
	for %f=2,3,7,8,11,13,19,20,21,22,24,25,26,27,28,31,33,35,36,38,39,40,41,42,43,44,45,46,47 { set:$g(%d(%f))'="" %d(%f)=%d(%f)\1 }
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
	set x=$zobjexport(-1,18),%qrc=400,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler44",,"BEDD"_"."_"EDSYSTEM") QUIT
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
	if %nolock=0 { if '..%SQLAcquireLock(%rowid) { set %qrc=114,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler45",,"BEDD"_"."_"EDSYSTEM",%rowid),%ROWCOUNT=0 QUIT  } set:$zu(115,2) il=$zu(115,2,0) }
	 ;---&sql(SELECT %INTERNAL(ID),AMERMnu,AutoNote,ChargeNrseA,ChargeNrseP,ChiefofStaff,CommBoard,FlagInjury,LabelPrnt1,LabelPrnt2,MedRec,NrseMgr,PCPFlag,Pager,PendingStsLookBack,Phone,Prnt1,Prnt2,PtArmBand,PtLabels,PtRtSheet,RtSheet,SMTPSERVER,ShoCons,ShoDlySum,ShoNrse,ShoPrv,ShoUsedRm,Site,SiteName,StandAlone,Status,SwitchEHRPat,TimeOut,TriageRpt,TwoClinics,Verify,WhiteboardShowAcuity,WhiteboardShowAge,WhiteboardShowChartNumber,WhiteboardShowComplaint,WhiteboardShowName,WhiteboardShowNotes,WhiteboardShowNurse,WhiteboardShowOrders,WhiteboardShowProvider,WhiteboardShowRoom,x__classname INTO :d(1),:d(2),:d(3),:d(4),:d(5),:d(6),:d(7),:d(8),:d(9),:d(10),:d(11),:d(12),:d(13),:d(14),:d(15),:d(16),:d(17),:d(18),:d(19),:d(20),:d(21),:d(22),:d(23),:d(24),:d(25),:d(26),:d(27),:d(28),:d(29),:d(30),:d(31),:d(32),:d(33),:d(34),:d(35),:d(36),:d(37),:d(38),:d(39),:d(40),:d(41),:d(42),:d(43),:d(44),:d(45),:d(46),:d(47),:d(48) FROM BEDD.EDSYSTEM WHERE %ID = :%rowid)
 	 ;--- ** SQL PUBLIC Variables: %ROWCOUNT, %ROWID, %msg, SQLCODE, d
	Do %0Co
	if SQLCODE { if %nolock=0 { do ..%SQLReleaseLock(%rowid,0,1) do:$g(il) $zu(115,2,il) } set %ROWCOUNT=0 set:SQLCODE<0 SQLCODE=-SQLCODE set %qrc=SQLCODE QUIT  }
	if qq,d(48)'="" { new sn set sn=$p(d(48),$e(d(48)),$l(d(48),$e(d(48)))-1) if "BEDD.EDSYSTEM"'=sn { if %nolock=0 { do ..%SQLReleaseLock(%rowid,0,1) do:$g(il) $zu(115,2,il) } kill d set:sn'["." sn="User."_sn  do $classmethod(sn,"%SQLQuickLoad",%rowid,%nolock,0,1) QUIT  }}
	if %nolock=0 { if $zu(115,1)=1 { TSTART  } elseIf '$TLEVEL,$zu(115,1)=2 { TSTART  }}
	set:qq d=$zobjexport("BEDD.EDSYSTEM",18),d=$zobjexport(48,18) set i=-1 for  { set i=$o(d(i)) quit:i=""  set d=$zobjexport(d(i),18) } set %qrc=0,%ROWCOUNT=1 if %nolock=0 { d ..%SQLReleaseLock(%rowid,0,0) do:$g(il) $zu(115,2,il) } quit
	Quit
 q
%0Co 
 n %mmmsqlc,%mmmsqld,%mmmsqlE,%mmmsqll,%mmmsqln,%mmmsqlp,%mmmsqlR,%mmmsqls,%mmmsqlt,%mmmsqlZ s $zt="%0Cerr" s %mmmsqld(1)=0,%mmmsqld(2)="" d:$zu(115,15) $system.ECP.Sync()
 s %mmmsqld(3)=$g(%rowid),%mmmsqld(3)=$s(%mmmsqld(3)="":"",$isvalidnum(%mmmsqld(3)):+%mmmsqld(3),1:%mmmsqld(3))
 s SQLCODE=100
 ; asl MOD# 2
 s %mmmsqld(4)=%mmmsqld(3)
 i %mmmsqld(4)'="",$d(^BEDD.EDSYSTEMD(%mmmsqld(4)))
 e  g %0CmBdun
 s d(1)=%mmmsqld(4)
 s %mmmsqld(5)=$g(^BEDD.EDSYSTEMD(%mmmsqld(4))) s d(2)=$lg(%mmmsqld(5),21) s d(3)=$lg(%mmmsqld(5),22) s d(4)=$lg(%mmmsqld(5),27) s d(5)=$lg(%mmmsqld(5),28) s d(6)=$lg(%mmmsqld(5),3) s d(7)=$lg(%mmmsqld(5),20) s d(8)=$lg(%mmmsqld(5),24) s d(11)=$lg(%mmmsqld(5),10) s d(12)=$lg(%mmmsqld(5),4) s d(13)=$lg(%mmmsqld(5),23) s d(14)=$lg(%mmmsqld(5),6) s d(15)=$lg(%mmmsqld(5),34) s d(16)=$lg(%mmmsqld(5),5) s d(17)=$lg(%mmmsqld(5),25) s d(18)=$lg(%mmmsqld(5),26) s d(19)=$lg(%mmmsqld(5),14) s d(20)=$lg(%mmmsqld(5),13) s d(21)=$lg(%mmmsqld(5),12) s d(22)=$lg(%mmmsqld(5),11) s d(23)=$lg(%mmmsqld(5),2) s d(24)=$lg(%mmmsqld(5),29) s d(25)=$lg(%mmmsqld(5),30) s d(26)=$lg(%mmmsqld(5),18) s d(27)=$lg(%mmmsqld(5),19) s d(28)=$lg(%mmmsqld(5),17) s d(29)=$lg(%mmmsqld(5),8) s d(31)=$lg(%mmmsqld(5),16) s d(32)=$lg(%mmmsqld(5),7) s d(33)=$lg(%mmmsqld(5),33) s d(34)=$lg(%mmmsqld(5),31) s d(35)=$lg(%mmmsqld(5),15) s d(36)=$lg(%mmmsqld(5),9) s d(37)=$lg(%mmmsqld(5),35)
 s d(38)=$lg(%mmmsqld(5),51) s d(39)=$lg(%mmmsqld(5),46) s d(40)=$lg(%mmmsqld(5),48) s d(41)=$lg(%mmmsqld(5),47) s d(42)=$lg(%mmmsqld(5),50) s d(43)=$lg(%mmmsqld(5),45) s d(44)=$lg(%mmmsqld(5),43) s d(45)=$lg(%mmmsqld(5),44) s d(46)=$lg(%mmmsqld(5),42) s d(47)=$lg(%mmmsqld(5),49) s d(48)=$lg(%mmmsqld(5),1)
 d
 . Set d(9)=##class(CNDHED.EDSYSTEM).GetPName(d(17))
 d
 . Set d(10)=##class(CNDHED.EDSYSTEM).GetPName(d(18))
 d
 . Set d(30)=##class(BEDD.EDSYSTEM).GetName(d(29))
 g:$zu(115,2)=0 %0CmBuncommitted i $zu(115,2)=1 l +^BEDD.EDSYSTEMD($p(%mmmsqld(4),"||",1))#"S":$zu(115,4) i $t { s %mmmsqld(1)=1,%mmmsqld(2)=$name(^BEDD.EDSYSTEMD($p(%mmmsqld(4),"||",1)))_"#""SI""" } else { s SQLCODE=-114,%msg="Unable to acquire shared lock on table BEDD.EDSYSTEM for RowID value: "_%mmmsqld(4) ztrap "LOCK"  }
 ; asl MOD# 3
 i %mmmsqld(4)'="",$d(^BEDD.EDSYSTEMD(%mmmsqld(4)))
 e  g %0CmCdun
 s d(1)=%mmmsqld(4)
 s %mmmsqld(6)=$g(^BEDD.EDSYSTEMD(%mmmsqld(4))) s d(2)=$lg(%mmmsqld(6),21) s d(3)=$lg(%mmmsqld(6),22) s d(4)=$lg(%mmmsqld(6),27) s d(5)=$lg(%mmmsqld(6),28) s d(6)=$lg(%mmmsqld(6),3) s d(7)=$lg(%mmmsqld(6),20) s d(8)=$lg(%mmmsqld(6),24) s d(11)=$lg(%mmmsqld(6),10) s d(12)=$lg(%mmmsqld(6),4) s d(13)=$lg(%mmmsqld(6),23) s d(14)=$lg(%mmmsqld(6),6) s d(15)=$lg(%mmmsqld(6),34) s d(16)=$lg(%mmmsqld(6),5) s d(17)=$lg(%mmmsqld(6),25) s d(18)=$lg(%mmmsqld(6),26) s d(19)=$lg(%mmmsqld(6),14) s d(20)=$lg(%mmmsqld(6),13) s d(21)=$lg(%mmmsqld(6),12) s d(22)=$lg(%mmmsqld(6),11) s d(23)=$lg(%mmmsqld(6),2) s d(24)=$lg(%mmmsqld(6),29) s d(25)=$lg(%mmmsqld(6),30) s d(26)=$lg(%mmmsqld(6),18) s d(27)=$lg(%mmmsqld(6),19) s d(28)=$lg(%mmmsqld(6),17) s d(29)=$lg(%mmmsqld(6),8) s d(31)=$lg(%mmmsqld(6),16) s d(32)=$lg(%mmmsqld(6),7) s d(33)=$lg(%mmmsqld(6),33) s d(34)=$lg(%mmmsqld(6),31) s d(35)=$lg(%mmmsqld(6),15) s d(36)=$lg(%mmmsqld(6),9) s d(37)=$lg(%mmmsqld(6),35)
 s d(38)=$lg(%mmmsqld(6),51) s d(39)=$lg(%mmmsqld(6),46) s d(40)=$lg(%mmmsqld(6),48) s d(41)=$lg(%mmmsqld(6),47) s d(42)=$lg(%mmmsqld(6),50) s d(43)=$lg(%mmmsqld(6),45) s d(44)=$lg(%mmmsqld(6),43) s d(45)=$lg(%mmmsqld(6),44) s d(46)=$lg(%mmmsqld(6),42) s d(47)=$lg(%mmmsqld(6),49) s d(48)=$lg(%mmmsqld(6),1)
 d
 . Set d(9)=##class(CNDHED.EDSYSTEM).GetPName(d(17))
 d
 . Set d(10)=##class(CNDHED.EDSYSTEM).GetPName(d(18))
 d
 . Set d(30)=##class(BEDD.EDSYSTEM).GetName(d(29))
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
	QUIT
%SQLQuickOdbcToLogical(%d)
	QUIT
%SQLQuickUpdate(%rowid,d,%nolock=0,pkey=0)
	// Update row with SQLRowID=%rowid with values d(icol)
	set:%nolock=2 %nolock=0
	do ..%SQLQuickOdbcToLogical(.d)
	do ..%SQLUpdate(%rowid,$c(0,%nolock=1,0,0,0,0),.d) set %ROWCOUNT='SQLCODE set:SQLCODE=100 SQLCODE=0 set %qrc=SQLCODE kill d QUIT
%SQLReleaseLock(%rowid,s=0,i=0)
	new %d set %d(1)=%rowid set s=$e("S",s)_$e("I",i) lock -^BEDD.EDSYSTEMD(%d(1))#s set:i&&($g(%0CacheLock("BEDD.EDSYSTEM"))) %0CacheLock("BEDD.EDSYSTEM")=%0CacheLock("BEDD.EDSYSTEM")-1 QUIT
%SQLReleaseTableLock(s=0,i=0)
	set s=$e("S",s)_$e("I",i) lock -^BEDD.EDSYSTEMD#s QUIT 1
	Quit
%SQLUnlock()
	lock:$a(%l) -^BEDD.EDSYSTEMD(%d(1))
	QUIT
%SQLUnlockError(cname)
	set sqlcode=-110 if %oper="DELETE" { set %msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler48",,"BEDD"_"."_"EDSYSTEM",cname) } else { set %msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler49",,"BEDD"_"."_"EDSYSTEM",cname) } quit
	Quit
%SQLUpdate(%rowid,%check,%d,%vco,%tstart=1,%mv=0,%polymorphic=0)
	new %e,bva,%ele,%itm,%key,%l,%n,%nc,%oper,%pos,%s,icol,s,sn,sqlcode,subs,t set %oper="UPDATE",sqlcode=0,%ROWID=%rowid,$e(%e,1)=$c(0),%l=$c(0,0,0) if '$a(%check),'..%SQLValidateFields(.sqlcode) set SQLCODE=sqlcode QUIT
	do ..%SQLNormalizeFields() if $d(%d(1)),%d(1)'=%rowid set SQLCODE=-107,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler16",,"ID","BEDD"_"."_"EDSYSTEM") QUIT
	for icol=2:1:48 set $e(%e,icol)=$c($d(%d(icol)))
	set %d(1)=%rowid,%e(1)=%rowid
	k:'$TLEVEL %0CacheLock if '$a(%check,2) { new %ls if $i(%0CacheLock("BEDD.EDSYSTEM"))>$zu(115,6) { lock +^BEDD.EDSYSTEMD:$zu(115,4) lock:$t -^BEDD.EDSYSTEMD set %ls=$s($t:2,1:0) } else { lock +^BEDD.EDSYSTEMD(%d(1)):$zu(115,4) set %ls=$t } set:%ls=2 $e(%check,2)=$c(1) set:%ls=1 $e(%l)=$c(1) if '%ls set SQLCODE=-110,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler40",,%oper,"BEDD"_"."_"EDSYSTEM",$g(%d(1))) QUIT  } if %tstart { TSTART:($zu(115,1)=1)||('$TLEVEL&&($zu(115,1)=2))  } set $zt="ERRORUpdate"
	if $g(%vco)="" { do ..%SQLGetOld() i sqlcode { s SQLCODE=-109 do ..%SQLEExit() QUIT  } for icol=48,29 { set:'$d(%d(icol)) %d(icol)=%e(icol) set:%d(icol)=%e(icol) $e(%e,icol)=$c(0) }} else { do ..%SQLGetOldAll() if sqlcode { set SQLCODE=-109 do ..%SQLEExit() QUIT  } for icol=2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48 { set:'$d(%d(icol)) %d(icol)=%e(icol) set:%d(icol)=%e(icol) $e(%e,icol)=$c(0) }}
	if %e(48)'="" set sn=$p(%e(48),$e(%e(48)),$l(%e(48),$e(%e(48)))-1) if "BEDD.EDSYSTEM"'=sn new %f do ..%SQLCopyIcolIntoName() do $classmethod(sn,"%SQLUpdate",%rowid,%check,.%d,$g(%vco),%tstart,%mv,1) QUIT
	do:'$a(%check)  if sqlcode set SQLCODE=sqlcode do ..%SQLEExit() QUIT
	. if $g(%vco)'="" do ..%SQLInsertComputes(1) d @%vco quit:sqlcode<0
	if '$a(%check,3) { 
	}
	set:$s($a(%e,2):1,$a(%e,3):1,$a(%e,4):1,$a(%e,5):1,$a(%e,6):1,$a(%e,7):1,$a(%e,8):1,$a(%e,11):1,$a(%e,12):1,$a(%e,13):1,$a(%e,14):1,$a(%e,15):1,$a(%e,16):1,$a(%e,17):1,$a(%e,18):1,$a(%e,19):1,$a(%e,20):1,$a(%e,21):1,$a(%e,22):1,$a(%e,23):1,$a(%e,24):1,$a(%e,25):1,$a(%e,26):1,$a(%e,27):1,$a(%e,28):1,$a(%e,29):1,$a(%e,31):1,$a(%e,32):1,$a(%e,33):1,$a(%e,34):1,$a(%e,35):1,$a(%e,36):1,$a(%e,37):1,$a(%e,38):1,$a(%e,39):1,$a(%e,40):1,$a(%e,41):1,$a(%e,42):1,$a(%e,43):1,$a(%e,44):1,$a(%e,45):1,$a(%e,46):1,$a(%e,47):1,1:$a(%e,48)) s=$g(^BEDD.EDSYSTEMD(%d(1))),^BEDD.EDSYSTEMD(%d(1))=$lb($s($a(%e,48):%d(48),1:$lg(s)),$s($a(%e,23):%d(23),1:$lg(s,2)),$s($a(%e,6):%d(6),1:$lg(s,3)),$s($a(%e,12):%d(12),1:$lg(s,4)),$s($a(%e,16):%d(16),1:$lg(s,5)),$s($a(%e,14):%d(14),1:$lg(s,6)),$s($a(%e,32):%d(32),1:$lg(s,7)),$s($a(%e,29):%d(29),1:$lg(s,8)),$s($a(%e,36):%d(36),1:$lg(s,9)),$s($a(%e,11):%d(11),1:$lg(s,10)),$s($a(%e,22):%d(22),1:$lg(s,11)),$s($a(%e,21):%d(21),1:$lg(s,12)),$s($a(%e,20):%d(20),1:$lg(s,13)),$s($a(%e,19):%d(19),1:$lg(s,14)),$s($a(%e,35):%d(35),1:$lg(s,15)),$s($a(%e,31):%d(31),1:$lg(s,16)),$s($a(%e,28):%d(28),1:$lg(s,17)),$s($a(%e,26):%d(26),1:$lg(s,18)),$s($a(%e,27):%d(27),1:$lg(s,19)),$s($a(%e,7):%d(7),1:$lg(s,20)),$s($a(%e,2):%d(2),1:$lg(s,21)),$s($a(%e,3):%d(3),1:$lg(s,22)),$s($a(%e,13):%d(13),1:$lg(s,23)),$s($a(%e,8):%d(8),1:$lg(s,24)),$s($a(%e,17):%d(17),1:$lg(s,25)),$s($a(%e,18):%d(18),1:$lg(s,26)),$s($a(%e,4):%d(4),1:$lg(s,27)),$s($a(%e,5):%d(5),1:$lg(s,28)),$s($a(%e,24):%d(24),1:$lg(s,29)),$s($a(%e,25):%d(25),1:$lg(s,30)),$s($a(%e,34):%d(34),1:$lg(s,31)),,$s($a(%e,33):%d(33),1:$lg(s,33)),$s($a(%e,15):%d(15),1:$lg(s,34)),$s($a(%e,37):%d(37),1:$lg(s,35)),,,,,,,$s($a(%e,46):%d(46),1:$lg(s,42)),$s($a(%e,44):%d(44),1:$lg(s,43)),$s($a(%e,45):%d(45),1:$lg(s,44)),$s($a(%e,43):%d(43),1:$lg(s,45)),$s($a(%e,39):%d(39),1:$lg(s,46)),$s($a(%e,41):%d(41),1:$lg(s,47)),$s($a(%e,40):%d(40),1:$lg(s,48)),$s($a(%e,47):%d(47),1:$lg(s,49)),$s($a(%e,42):%d(42),1:$lg(s,50)),$s($a(%e,38):%d(38),1:$lg(s,51)))
	if '$a(%check,3) { 
		if $a(%e,29)||$a(%e,48) {	// SiteIdx index map
			if $a(%e,29) { s sn(1)=$zu(28,%e(29),7) s sn(2)=%d(1) k ^BEDD.EDSYSTEMI("SiteIdx",sn(1),sn(2)) }
			s sn(1)=$zu(28,%d(29),7) s sn(2)=%d(1) s ^BEDD.EDSYSTEMI("SiteIdx",sn(1),sn(2))=%d(48)
		}
	}
	do ..%SQLUnlock() TCOMMIT:%tstart&&($zu(115,1)=1)
	set SQLCODE=0
	QUIT
ERRORUpdate	set $zt="",SQLCODE=-415,%msg=$s($g(%msg)'="":%msg_" -- ",1:"")_$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler51",,%oper,"BEDD"_"."_"EDSYSTEM",$ze) if $ze["<FRAMESTACK>" { set %msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler52",,$ze,%oper,"BEDD"_"."_"EDSYSTEM") do ##Class(%SYS.System).WriteToConsoleLog(%msg) if ($zu(67,10,$j)=1)||($zu(67,10,$j)=3) { write !,%msg h 3 } HALT  } do ..%SQLEExit() QUIT  
	Quit
%SQLValidateFields(sqlcode)
	if $g(%d(11))'="",'($$ValidateField11(%d(11))) { set sqlcode=..%SQLInvalid(11+1,%d(11)) } 
	if $g(%d(13))'="",'($$ValidateField13(%d(13))) { set sqlcode=..%SQLInvalid(13+1,%d(13)) } 
	if $g(%d(19))'="",'($$ValidateField19(%d(19))) { set sqlcode=..%SQLInvalid(19+1,%d(19)) } 
	if $g(%d(2))'="",'($$ValidateField2(%d(2))) { set sqlcode=..%SQLInvalid(2+1,%d(2)) } 
	if $g(%d(20))'="",'($$ValidateField20(%d(20))) { set sqlcode=..%SQLInvalid(20+1,%d(20)) } 
	if $g(%d(21))'="",'($$ValidateField21(%d(21))) { set sqlcode=..%SQLInvalid(21+1,%d(21)) } 
	if $g(%d(22))'="",'($$ValidateField22(%d(22))) { set sqlcode=..%SQLInvalid(22+1,%d(22)) } 
	if $g(%d(24))'="",'($$ValidateField24(%d(24))) { set sqlcode=..%SQLInvalid(24+1,%d(24)) } 
	if $g(%d(25))'="",'($$ValidateField25(%d(25))) { set sqlcode=..%SQLInvalid(25+1,%d(25)) } 
	if $g(%d(26))'="",'($$ValidateField26(%d(26))) { set sqlcode=..%SQLInvalid(26+1,%d(26)) } 
	if $g(%d(27))'="",'($$ValidateField27(%d(27))) { set sqlcode=..%SQLInvalid(27+1,%d(27)) } 
	if $g(%d(28))'="",'($$ValidateField28(%d(28))) { set sqlcode=..%SQLInvalid(28+1,%d(28)) } 
	if $g(%d(3))'="",'($$ValidateField3(%d(3))) { set sqlcode=..%SQLInvalid(3+1,%d(3)) } 
	if $g(%d(31))'="",'($$ValidateField31(%d(31))) { set sqlcode=..%SQLInvalid(31+1,%d(31)) } 
	if $g(%d(33))'="",'($$ValidateField33(%d(33))) { set sqlcode=..%SQLInvalid(33+1,%d(33)) } 
	if $g(%d(35))'="",'($$ValidateField35(%d(35))) { set sqlcode=..%SQLInvalid(35+1,%d(35)) } 
	if $g(%d(36))'="",'($$ValidateField36(%d(36))) { set sqlcode=..%SQLInvalid(36+1,%d(36)) } 
	if $g(%d(38))'="",'($$ValidateField38(%d(38))) { set sqlcode=..%SQLInvalid(38+1,%d(38)) } 
	if $g(%d(39))'="",'($$ValidateField39(%d(39))) { set sqlcode=..%SQLInvalid(39+1,%d(39)) } 
	if $g(%d(40))'="",'($$ValidateField40(%d(40))) { set sqlcode=..%SQLInvalid(40+1,%d(40)) } 
	if $g(%d(41))'="",'($$ValidateField41(%d(41))) { set sqlcode=..%SQLInvalid(41+1,%d(41)) } 
	if $g(%d(42))'="",'($$ValidateField42(%d(42))) { set sqlcode=..%SQLInvalid(42+1,%d(42)) } 
	if $g(%d(43))'="",'($$ValidateField43(%d(43))) { set sqlcode=..%SQLInvalid(43+1,%d(43)) } 
	if $g(%d(44))'="",'($$ValidateField44(%d(44))) { set sqlcode=..%SQLInvalid(44+1,%d(44)) } 
	if $g(%d(45))'="",'($$ValidateField45(%d(45))) { set sqlcode=..%SQLInvalid(45+1,%d(45)) } 
	if $g(%d(46))'="",'($$ValidateField46(%d(46))) { set sqlcode=..%SQLInvalid(46+1,%d(46)) } 
	if $g(%d(47))'="",'($$ValidateField47(%d(47))) { set sqlcode=..%SQLInvalid(47+1,%d(47)) } 
	if $g(%d(7))'="",'($$ValidateField7(%d(7))) { set sqlcode=..%SQLInvalid(7+1,%d(7)) } 
	if $g(%d(8))'="",'($$ValidateField8(%d(8))) { set sqlcode=..%SQLInvalid(8+1,%d(8)) } 
	new %f for %f=4,5,6,9,10,12,14,15,16,17,18,23,29,30,32,34,37 { if $g(%d(%f))'="",'(($l(%d(%f))'>50)) set sqlcode=..%SQLInvalid(%f+1,$g(%d(%f))) quit  } 
	QUIT 'sqlcode
ValidateField2(%val="")	Quit $isvalidnum(%val,0,0,2)&&(+%val'=2)
ValidateField3(%val="")	Quit $isvalidnum(%val,0,0,2)&&(+%val'=2)
ValidateField7(%val="")	Quit $isvalidnum(%val,0,0,2)&&(+%val'=2)
ValidateField8(%val="")	Quit $isvalidnum(%val,0,0,2)&&(+%val'=2)
ValidateField11(%val="")	Quit $isvalidnum(%val,0,0,2)&&(+%val'=2)
ValidateField13(%val="")	Quit $isvalidnum(%val,0,0,2)&&(+%val'=2)
ValidateField19(%val="")	Quit $isvalidnum(%val,0,0,2)&&(+%val'=2)
ValidateField20(%val="")	Quit $isvalidnum(%val,0,0,2)&&(+%val'=2)
ValidateField21(%val="")	Quit $isvalidnum(%val,0,0,2)&&(+%val'=2)
ValidateField22(%val="")	Quit $isvalidnum(%val,0,0,2)&&(+%val'=2)
ValidateField24(%val="")	Quit $isvalidnum(%val,0,0,2)&&(+%val'=2)
ValidateField25(%val="")	Quit $isvalidnum(%val,0,0,2)&&(+%val'=2)
ValidateField26(%val="")	Quit $isvalidnum(%val,0,0,2)&&(+%val'=2)
ValidateField27(%val="")	Quit $isvalidnum(%val,0,0,2)&&(+%val'=2)
ValidateField28(%val="")	Quit $isvalidnum(%val,0,0,2)&&(+%val'=2)
ValidateField31(%val="")	Quit $isvalidnum(%val,0,0,2)&&(+%val'=2)
ValidateField33(%val="")	Quit $isvalidnum(%val,0,0,2)&&(+%val'=2)
ValidateField35(%val="")	Quit $isvalidnum(%val,0,0,2)&&(+%val'=2)
ValidateField36(%val="")	Quit $isvalidnum(%val,0,0,2)&&(+%val'=2)
ValidateField38(%val="")	Quit $isvalidnum(%val,0,0,2)&&(+%val'=2)
ValidateField39(%val="")	Quit $isvalidnum(%val,0,0,2)&&(+%val'=2)
ValidateField40(%val="")	Quit $isvalidnum(%val,0,0,2)&&(+%val'=2)
ValidateField41(%val="")	Quit $isvalidnum(%val,0,0,2)&&(+%val'=2)
ValidateField42(%val="")	Quit $isvalidnum(%val,0,0,2)&&(+%val'=2)
ValidateField43(%val="")	Quit $isvalidnum(%val,0,0,2)&&(+%val'=2)
ValidateField44(%val="")	Quit $isvalidnum(%val,0,0,2)&&(+%val'=2)
ValidateField45(%val="")	Quit $isvalidnum(%val,0,0,2)&&(+%val'=2)
ValidateField46(%val="")	Quit $isvalidnum(%val,0,0,2)&&(+%val'=2)
ValidateField47(%val="")	Quit $isvalidnum(%val,0,0,2)&&(+%val'=2)
	Quit
%SQLnBuild() public {
	set %n=$lb(,"ID","AMERMnu","AutoNote","ChargeNrseA","ChargeNrseP","ChiefofStaff","CommBoard","FlagInjury","LabelPrnt1","LabelPrnt2","MedRec","NrseMgr","PCPFlag","Pager","PendingStsLookBack","Phone","Prnt1","Prnt2","PtArmBand","PtLabels","PtRtSheet","RtSheet","SMTPSERVER","ShoCons","ShoDlySum","ShoNrse","ShoPrv","ShoUsedRm","Site","SiteName","StandAlone","Status","SwitchEHRPat","TimeOut","TriageRpt","TwoClinics","Verify","WhiteboardShowAcuity","WhiteboardShowAge","WhiteboardShowChartNumber","WhiteboardShowComplaint","WhiteboardShowName","WhiteboardShowNotes","WhiteboardShowNurse","WhiteboardShowOrders","WhiteboardShowProvider","WhiteboardShowRoom","x__classname")
	QUIT }
%SaveData(id) public {
	Set $ZTrap="SaveDataERR" Set sc=1,id=$listget(i%"%%OID") If id'="" { Set insert=0,idassigned=1 } Else { Set insert=1,idassigned=0 }
	Set lock=0,lockok=0,tSharedLock=0,locku=""
	if 'idassigned { set id=$i(^BEDD.EDSYSTEMD) Set $zobjoid("BEDD.EDSYSTEM",id)=$this,.."%%OID"=$lb(id_"","BEDD.EDSYSTEM") set:$g(%objtxSTATUS)=2 %objtxOIDASSIGNED(+$this)="" }
	If 'insert && ('$Data(^BEDD.EDSYSTEMD(id))) { Set insert=1 }
	If '$Tlevel { Kill %0CacheLock }
	If insert  {
		if (..%Concurrency&&$tlevel)||(..%Concurrency=4) { If (..%Concurrency < 4)&&($i(%0CacheLock($classname()))>$zu(115,6)) { Lock +(^BEDD.EDSYSTEMD):$zu(115,4) Set lockok=$Select($test:2,1:0) Lock:lockok -(^BEDD.EDSYSTEMD) } Else { Lock +(^BEDD.EDSYSTEMD(id)):$zu(115,4) Set lockok=$Select($test:1,1:0) Set:..%Concurrency'=4 lock=lockok } If 'lockok { Set sc=$$Error^%apiOBJ(5803,$classname()) Goto SaveDataEXIT } }
		if ..%Concurrency=3 { Lock +(^BEDD.EDSYSTEMD(id)#"S") set tSharedLock=1 }
		s ^BEDD.EDSYSTEMD(id)=$lb("",i%SMTPSERVER,i%ChiefofStaff,i%NrseMgr,i%Phone,i%Pager,i%Status,i%Site,i%TwoClinics,i%MedRec,i%RtSheet,i%PtRtSheet,i%PtLabels,i%PtArmBand,i%TriageRpt,i%StandAlone,i%ShoUsedRm,i%ShoNrse,i%ShoPrv,i%CommBoard,i%AMERMnu,i%AutoNote,i%PCPFlag,i%FlagInjury,i%Prnt1,i%Prnt2,i%ChargeNrseA,i%ChargeNrseP,i%ShoCons,i%ShoDlySum,i%TimeOut,,i%SwitchEHRPat,i%PendingStsLookBack,i%Verify,,,,,,,i%WhiteboardShowProvider,i%WhiteboardShowNurse,i%WhiteboardShowOrders,i%WhiteboardShowNotes,i%WhiteboardShowAge,i%WhiteboardShowComplaint,i%WhiteboardShowChartNumber,i%WhiteboardShowRoom,i%WhiteboardShowName,i%WhiteboardShowAcuity)
		s ^BEDD.EDSYSTEMI("SiteIdx",$zu(28,i%Site,7,32768),id)=""
	}
	Else  {
		If (..%Concurrency<4)&&(..%Concurrency) { If $i(%0CacheLock($classname()))>$zu(115,6) { Lock +(^BEDD.EDSYSTEMD):$zu(115,4) Set lockok=$s($test:2,1:0) Lock:lockok -(^BEDD.EDSYSTEMD) } Else { Lock +(^BEDD.EDSYSTEMD(id)):$zu(115,4) Set lockok=$Select($test:1,1:0),lock=lockok } If 'lockok { Set sc=$$Error^%apiOBJ(5803,$classname()) Goto SaveDataEXIT } }
		Set bsv0N1=^BEDD.EDSYSTEMD(id)
		If (i%Site'=$listget(bsv0N1,8)) {
			Kill ^BEDD.EDSYSTEMI("SiteIdx",$zu(28,$listget(bsv0N1,8),7,32768),id)
			s ^BEDD.EDSYSTEMI("SiteIdx",$zu(28,i%Site,7,32768),id)=""
		}
		s ^BEDD.EDSYSTEMD(id)=$lb("",i%SMTPSERVER,i%ChiefofStaff,i%NrseMgr,i%Phone,i%Pager,i%Status,i%Site,i%TwoClinics,i%MedRec,i%RtSheet,i%PtRtSheet,i%PtLabels,i%PtArmBand,i%TriageRpt,i%StandAlone,i%ShoUsedRm,i%ShoNrse,i%ShoPrv,i%CommBoard,i%AMERMnu,i%AutoNote,i%PCPFlag,i%FlagInjury,i%Prnt1,i%Prnt2,i%ChargeNrseA,i%ChargeNrseP,i%ShoCons,i%ShoDlySum,i%TimeOut,,i%SwitchEHRPat,i%PendingStsLookBack,i%Verify,,,,,,,i%WhiteboardShowProvider,i%WhiteboardShowNurse,i%WhiteboardShowOrders,i%WhiteboardShowNotes,i%WhiteboardShowAge,i%WhiteboardShowComplaint,i%WhiteboardShowChartNumber,i%WhiteboardShowRoom,i%WhiteboardShowName,i%WhiteboardShowAcuity)
	}
SaveDataEXIT
	if (('sc)) && ('idassigned) { Set $zobjoid("",$listget(i%"%%OID"))="" Set $this."%%OID" = "" kill:$g(%objtxSTATUS)=2 %objtxOIDASSIGNED(+$this) }
	If lock Lock -(^BEDD.EDSYSTEMD(id))
	If (('sc)) { if (tSharedLock) {  Lock -(^BEDD.EDSYSTEMD(id)#"S") } elseif (lockok=1)&&(insert)&&(..%Concurrency=4) {  Lock -(^BEDD.EDSYSTEMD(id)) } }
SaveDataRET	Set $Ztrap = ""
	QUIT sc
SaveDataERR	Set $Ztrap = "SaveDataRET"
	Set sc = $$Error^%apiOBJ(5002,$ZE)
	Goto SaveDataEXIT }
%SaveDirect(id="",idList="",data,concurrency=-1) public {
	Set $ZTrap="SaveDirectERR" s sc=1 i id'="" { Set insert=0,idassigned=1 } Else { Set insert=1,idassigned=0 }
	if concurrency=-1 { Set concurrency=$zu(115,10) }
	If 'idassigned { set id=$i(^BEDD.EDSYSTEMD) }
	If 'insert && ('$Data(^BEDD.EDSYSTEMD(id))) { Set insert=1 }
	Set lock=0,locku=""
	If '$Tlevel { Kill %0CacheLock }
	If insert  {
		i concurrency { If $i(%0CacheLock($classname()))>$zu(115,6) { Lock +(^BEDD.EDSYSTEMD):$zu(115,4) Set lock=$Select($test:2,1:0) Lock:lock -(^BEDD.EDSYSTEMD) } Else { Lock +(^BEDD.EDSYSTEMD(id)):$zu(115,4) Set lock=$Select($test:1,1:0) } If 'lock { Set sc=$$Error^%apiOBJ(5803,$classname()) Goto SaveDirectEXIT } }
		s ^BEDD.EDSYSTEMD(id)=data
		s ^BEDD.EDSYSTEMI("SiteIdx",$zu(28,$listget(data,8),7,32768),id)=$listget(data,1)
	}
	Else  {
		i concurrency { If $i(%0CacheLock($classname()))>$zu(115,6) { Lock +(^BEDD.EDSYSTEMD):$zu(115,4) Set lock=$s($test:2,1:0) Lock:lock -(^BEDD.EDSYSTEMD) } Else { Lock +(^BEDD.EDSYSTEMD(id)):$zu(115,4) Set lock=$Select($test:1,1:0) } If 'lock { Set sc=$$Error^%apiOBJ(5803,$classname()) Goto SaveDirectEXIT } }
		Set bsv0N1=$li(idList,1)
		Set bsv0N2=^BEDD.EDSYSTEMD(bsv0N1)
		If ($listget(data,8)'=$listget(bsv0N2,8)) {
			Kill ^BEDD.EDSYSTEMI("SiteIdx",$zu(28,$listget(bsv0N2,8),7,32768),$li(idList,1))
			s ^BEDD.EDSYSTEMI("SiteIdx",$zu(28,$listget(data,8),7,32768),id)=$listget(data,1)
		}
		s ^BEDD.EDSYSTEMD(id)=data
	}
SaveDirectEXIT
	If lock=1 Lock -(^BEDD.EDSYSTEMD(id))
SaveDirectRET	Set $Ztrap = ""
	QUIT sc
SaveDirectERR	Set $Ztrap = "SaveDirectRET"
	Set sc = $$Error^%apiOBJ(5002,$ZE)
	Goto SaveDirectEXIT }
%SaveIndices(pStartId="",pEndId="",lockExtent=0) public {
	i lockExtent { s sc=..%LockExtent(0) i ('sc) { q sc } }
	s id=$order(^BEDD.EDSYSTEMD(pStartId),-1),tEndId=$S(pEndId'="":pEndId,1:pStartId)
BSLoop	s id=$O(^BEDD.EDSYSTEMD(id)) g:(id="")||(id]]tEndId) BSLoopDun
	Set bsv0N1=$Get(^BEDD.EDSYSTEMD(id))
	Set bsv0N2=$zu(28,$listget(bsv0N1,8),7,32768)
	Set ^BEDD.EDSYSTEMI("SiteIdx",bsv0N2,id)=$listget(bsv0N1,1)
	g BSLoop
BSLoopDun
	i lockExtent { d ..%UnlockExtent(0) }
	QUIT 1
CatchError	s $ZTrap="" i $ZE'="" { s sc = $$Error^%apiOBJ(5002,$ZE) } i lockExtent { d ..%UnlockExtent(0) } q sc }
%SortBegin(idxlist="",excludeunique=0)
	if $select(idxlist="":1,$listfind(idxlist,"SiteIdx"):1,1:0) If $SortBegin(^BEDD.EDSYSTEMI("SiteIdx"))
	Quit 1
%SortEnd(idxlist="",commit=1)
	if $select(idxlist="":1,$listfind(idxlist,"SiteIdx"):1,1:0) If $SortEnd(^BEDD.EDSYSTEMI("SiteIdx"),commit)
	Quit 1
%UnlockExtent(shared=0,immediate=0) public {
	if ('immediate)&&('shared) { l -^BEDD.EDSYSTEMD q 1 } elseif (immediate)&&('shared) { l -^BEDD.EDSYSTEMD#"I" q 1 } elseif ('immediate)&&(shared) { l -^BEDD.EDSYSTEMD#"S" q 1 } else { l -^BEDD.EDSYSTEMD#"SI" q 1 }
}
%UnlockId(id,shared=0,immediate=0) public {
	if ('immediate)&&('shared) { Lock -(^BEDD.EDSYSTEMD(id)) q 1 } elseif (immediate)&&('shared) { Lock -(^BEDD.EDSYSTEMD(id)#"I") q 1 } elseif ('immediate)&&(shared) { Lock -(^BEDD.EDSYSTEMD(id)#"S") q 1 } else { Lock -(^BEDD.EDSYSTEMD(id)#"SI") q 1 }
}
%ValidateObject(force=0) public {
	Set sc=1
	If '$system.CLS.GetModified() Quit sc
	If m%AMERMnu Set iv=..AMERMnu If iv'="" Set rc=(..AMERMnuIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"AMERMnu",iv)
	If m%AutoNote Set iv=..AutoNote If iv'="" Set rc=(..AutoNoteIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"AutoNote",iv)
	If m%ChargeNrseA Set iv=..ChargeNrseA If iv'="" Set rc=(..ChargeNrseAIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"ChargeNrseA",iv)
	If m%ChargeNrseP Set iv=..ChargeNrseP If iv'="" Set rc=(..ChargeNrsePIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"ChargeNrseP",iv)
	If m%ChiefofStaff Set iv=..ChiefofStaff If iv'="" Set rc=(..ChiefofStaffIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"ChiefofStaff",iv)
	If m%CommBoard Set iv=..CommBoard If iv'="" Set rc=(..CommBoardIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"CommBoard",iv)
	If m%FlagInjury Set iv=..FlagInjury If iv'="" Set rc=(..FlagInjuryIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"FlagInjury",iv)
	If m%MedRec Set iv=..MedRec If iv'="" Set rc=(..MedRecIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"MedRec",iv)
	If m%NrseMgr Set iv=..NrseMgr If iv'="" Set rc=(..NrseMgrIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"NrseMgr",iv)
	If m%PCPFlag Set iv=..PCPFlag If iv'="" Set rc=(..PCPFlagIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"PCPFlag",iv)
	If m%Pager Set iv=..Pager If iv'="" Set rc=(..PagerIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"Pager",iv)
	If m%PendingStsLookBack Set iv=..PendingStsLookBack If iv'="" Set rc=(..PendingStsLookBackIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"PendingStsLookBack",iv)
	If m%Phone Set iv=..Phone If iv'="" Set rc=(..PhoneIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"Phone",iv)
	If m%Prnt1 Set iv=..Prnt1 If iv'="" Set rc=(..Prnt1IsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"Prnt1",iv)
	If m%Prnt2 Set iv=..Prnt2 If iv'="" Set rc=(..Prnt2IsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"Prnt2",iv)
	If m%PtArmBand Set iv=..PtArmBand If iv'="" Set rc=(..PtArmBandIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"PtArmBand",iv)
	If m%PtLabels Set iv=..PtLabels If iv'="" Set rc=(..PtLabelsIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"PtLabels",iv)
	If m%PtRtSheet Set iv=..PtRtSheet If iv'="" Set rc=(..PtRtSheetIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"PtRtSheet",iv)
	If m%RtSheet Set iv=..RtSheet If iv'="" Set rc=(..RtSheetIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"RtSheet",iv)
	If m%SMTPSERVER Set iv=..SMTPSERVER If iv'="" Set rc=(..SMTPSERVERIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"SMTPSERVER",iv)
	If m%ShoCons Set iv=..ShoCons If iv'="" Set rc=(..ShoConsIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"ShoCons",iv)
	If m%ShoDlySum Set iv=..ShoDlySum If iv'="" Set rc=(..ShoDlySumIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"ShoDlySum",iv)
	If m%ShoNrse Set iv=..ShoNrse If iv'="" Set rc=(..ShoNrseIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"ShoNrse",iv)
	If m%ShoPrv Set iv=..ShoPrv If iv'="" Set rc=(..ShoPrvIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"ShoPrv",iv)
	If m%ShoUsedRm Set iv=..ShoUsedRm If iv'="" Set rc=(..ShoUsedRmIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"ShoUsedRm",iv)
	If m%Site Set iv=..Site If iv'="" Set rc=(..SiteIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"Site",iv)
	If m%StandAlone Set iv=..StandAlone If iv'="" Set rc=(..StandAloneIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"StandAlone",iv)
	If m%Status Set iv=..Status If iv'="" Set rc=(..StatusIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"Status",iv)
	If m%SwitchEHRPat Set iv=..SwitchEHRPat If iv'="" Set rc=(..SwitchEHRPatIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"SwitchEHRPat",iv)
	If m%TimeOut Set iv=..TimeOut If iv'="" Set rc=(..TimeOutIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"TimeOut",iv)
	If m%TriageRpt Set iv=..TriageRpt If iv'="" Set rc=(..TriageRptIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"TriageRpt",iv)
	If m%TwoClinics Set iv=..TwoClinics If iv'="" Set rc=(..TwoClinicsIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"TwoClinics",iv)
	If m%Verify Set iv=..Verify If iv'="" Set rc=(..VerifyIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"Verify",iv)
	If m%WhiteboardShowAcuity Set iv=..WhiteboardShowAcuity If iv'="" Set rc=(..WhiteboardShowAcuityIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"WhiteboardShowAcuity",iv)
	If m%WhiteboardShowAge Set iv=..WhiteboardShowAge If iv'="" Set rc=(..WhiteboardShowAgeIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"WhiteboardShowAge",iv)
	If m%WhiteboardShowChartNumber Set iv=..WhiteboardShowChartNumber If iv'="" Set rc=(..WhiteboardShowChartNumberIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"WhiteboardShowChartNumber",iv)
	If m%WhiteboardShowComplaint Set iv=..WhiteboardShowComplaint If iv'="" Set rc=(..WhiteboardShowComplaintIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"WhiteboardShowComplaint",iv)
	If m%WhiteboardShowName Set iv=..WhiteboardShowName If iv'="" Set rc=(..WhiteboardShowNameIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"WhiteboardShowName",iv)
	If m%WhiteboardShowNotes Set iv=..WhiteboardShowNotes If iv'="" Set rc=(..WhiteboardShowNotesIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"WhiteboardShowNotes",iv)
	If m%WhiteboardShowNurse Set iv=..WhiteboardShowNurse If iv'="" Set rc=(..WhiteboardShowNurseIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"WhiteboardShowNurse",iv)
	If m%WhiteboardShowOrders Set iv=..WhiteboardShowOrders If iv'="" Set rc=(..WhiteboardShowOrdersIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"WhiteboardShowOrders",iv)
	If m%WhiteboardShowProvider Set iv=..WhiteboardShowProvider If iv'="" Set rc=(..WhiteboardShowProviderIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"WhiteboardShowProvider",iv)
	If m%WhiteboardShowRoom Set iv=..WhiteboardShowRoom If iv'="" Set rc=(..WhiteboardShowRoomIsValid(iv)) If ('rc) Set sc=$$EmbedErr^%occSystem(sc,rc,5802,"WhiteboardShowRoom",iv)
	Quit sc }
zGetName(site) public {
	If (site="") {
		Set sitename="" 
		Quit sitename
	}
	If (site="999999") {
		Quit "Whiteboard Display"
	}
	Set sitename=$$SNAME^BEDDUTIL(site)
	If (sitename="") {
		Set sitename=$$GETF^BEDDUTIL(4,site,.01,"I")
	}
	If (sitename="") {
		Set sitename="NO ENTRY IN INSTITUTION FILE"
	}
	Quit sitename }
zGetPName(labelprnt) public {
	If (labelprnt="") {
		Set labelname=""
		Quit labelname
	}
	Set labelname=""
	Set labelname=$$GETF^BEDDUTIL(4,site,.01,"I") 
	If (labelname="") {
		Set labelname="NO Label Printer"
	}
	Quit labelname }
zAMERMnuDisplayToLogical(%val) public {
	Quit ''%val }
zAMERMnuGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDSYSTEMD(id)),21),1:"") }
zAMERMnuIsValid(%val="") public {
	Q $s($isvalidnum(%val,0,0,2)&&(+%val'=2):1,1:$$Error^%apiOBJ(7206,%val)) }
zAMERMnuNormalize(%val) public {
	Quit %val\1 }
zAutoNoteGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDSYSTEMD(id)),22),1:"") }
zChargeNrseAGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDSYSTEMD(id)),27),1:"") }
zChargeNrsePGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDSYSTEMD(id)),28),1:"") }
zChiefofStaffGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDSYSTEMD(id)),3),1:"") }
zCommBoardGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDSYSTEMD(id)),20),1:"") }
zFlagInjuryGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDSYSTEMD(id)),24),1:"") }
zLabelPrnt1Compute(%id,%d1)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(CNDHED.EDSYSTEM).GetPName(%d1)
	} catch %tException { throw %tException }
	Quit %val
zLabelPrnt1Get() public {
	Quit ..LabelPrnt1Compute($listget(i%"%%OID"),..Prnt1) }
zLabelPrnt1SQLCompute()
	// Compute code for field LabelPrnt1
 Set %d(9)=##class(CNDHED.EDSYSTEM).GetPName($g(%d(17)))
 QUIT
zLabelPrnt2Compute(%id,%d1)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(CNDHED.EDSYSTEM).GetPName(%d1)
	} catch %tException { throw %tException }
	Quit %val
zLabelPrnt2Get() public {
	Quit ..LabelPrnt2Compute($listget(i%"%%OID"),..Prnt2) }
zLabelPrnt2SQLCompute()
	// Compute code for field LabelPrnt2
 Set %d(10)=##class(CNDHED.EDSYSTEM).GetPName($g(%d(18)))
 QUIT
zMedRecGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDSYSTEMD(id)),10),1:"") }
zNrseMgrGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDSYSTEMD(id)),4),1:"") }
zPCPFlagGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDSYSTEMD(id)),23),1:"") }
zPagerGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDSYSTEMD(id)),6),1:"") }
zPendingStsLookBackGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDSYSTEMD(id)),34),1:"") }
zPhoneGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDSYSTEMD(id)),5),1:"") }
zPrnt1GetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDSYSTEMD(id)),25),1:"") }
zPrnt2GetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDSYSTEMD(id)),26),1:"") }
zPtArmBandGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDSYSTEMD(id)),14),1:"") }
zPtLabelsGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDSYSTEMD(id)),13),1:"") }
zPtRtSheetGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDSYSTEMD(id)),12),1:"") }
zRtSheetGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDSYSTEMD(id)),11),1:"") }
zSMTPSERVERGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDSYSTEMD(id)),2),1:"") }
zShoConsGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDSYSTEMD(id)),29),1:"") }
zShoDlySumGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDSYSTEMD(id)),30),1:"") }
zShoNrseGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDSYSTEMD(id)),18),1:"") }
zShoPrvGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDSYSTEMD(id)),19),1:"") }
zShoUsedRmGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDSYSTEMD(id)),17),1:"") }
zSiteGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDSYSTEMD(id)),8),1:"") }
zSiteNameCompute(%id,%d1)
	New %tException,%val set %val = ""
	try {
	 Set %val=##class(BEDD.EDSYSTEM).GetName(%d1)
	} catch %tException { throw %tException }
	Quit %val
zSiteNameGet() public {
	Quit ..SiteNameCompute($listget(i%"%%OID"),..Site) }
zSiteNameSQLCompute()
	// Compute code for field SiteName
 Set %d(30)=##class(BEDD.EDSYSTEM).GetName($g(%d(29)))
 QUIT
zStandAloneGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDSYSTEMD(id)),16),1:"") }
zStatusGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDSYSTEMD(id)),7),1:"") }
zSwitchEHRPatGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDSYSTEMD(id)),33),1:"") }
zTimeOutGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDSYSTEMD(id)),31),1:"") }
zTriageRptGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDSYSTEMD(id)),15),1:"") }
zTwoClinicsGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDSYSTEMD(id)),9),1:"") }
zVerifyGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDSYSTEMD(id)),35),1:"") }
zWhiteboardShowAcuityGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDSYSTEMD(id)),51),1:"") }
zWhiteboardShowAgeGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDSYSTEMD(id)),46),1:"") }
zWhiteboardShowChartNumberGetSt(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDSYSTEMD(id)),48),1:"") }
zWhiteboardShowComplaintGetStor(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDSYSTEMD(id)),47),1:"") }
zWhiteboardShowNameGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDSYSTEMD(id)),50),1:"") }
zWhiteboardShowNotesGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDSYSTEMD(id)),45),1:"") }
zWhiteboardShowNurseGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDSYSTEMD(id)),43),1:"") }
zWhiteboardShowOrdersGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDSYSTEMD(id)),44),1:"") }
zWhiteboardShowProviderGetStore(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDSYSTEMD(id)),42),1:"") }
zWhiteboardShowRoomGetStored(id) public {
	Quit $Select(id'="":$listget($g(^BEDD.EDSYSTEMD(id)),49),1:"") }
zExtentExecute(%qHandle) [ SQLCODE,c1 ] public { New %ROWCOUNT,%ROWID,%msg,SQLCODE,c1 
	Set sc=1
	s %qHandle=$i(%objcn)
	 ;---&sql(DECLARE QExtent CURSOR FOR
 	 ;---		 SELECT ID FROM BEDD.EDSYSTEM)
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
	Do %0Io
	If 'SQLCODE { Set Row=$lb(c1) Set sc=1 } ElseIf SQLCODE=100 { Set AtEnd=1,sc=1 Set:$isobject($g(%sqlcontext)) %sqlcontext.%SQLCODE=SQLCODE,%sqlcontext.%ROWCOUNT=$g(%ROWCOUNT) } Else { Set:$isobject($g(%sqlcontext)) %sqlcontext.%SQLCODE=SQLCODE,%sqlcontext.Message=$g(%msg) Set AtEnd=1,sc=$$Error^%apiOBJ(5540,SQLCODE,$get(%msg)) }
	QUIT sc }
zExtentFetchRows(%qHandle,FetchCount=0,RowSet,ReturnCount,AtEnd) [ SQLCODE,c1 ] public { New %ROWCOUNT,%ROWID,%msg,SQLCODE,c1 
	Set RowSet="",ReturnCount=0,AtEnd=0
	For {
		 ;---&sql(FETCH QExtent INTO :c1)
 		 ;--- ** SQL PUBLIC Variables: %ROWCOUNT, %ROWID, %msg, SQLCODE, c1
		Do %0Jo
		If 'SQLCODE { Set RowSet=RowSet_$lb(c1),ReturnCount=ReturnCount+1 Quit:(ReturnCount=FetchCount)||(($l(RowSet)+($l(RowSet)\ReturnCount))>24000) } Else { Set AtEnd=1 Quit }
	}
	If 'SQLCODE { Set sc=1 } ElseIf SQLCODE=100 { Set sc=1 Set:$isobject($g(%sqlcontext)) %sqlcontext.%SQLCODE=SQLCODE,%sqlcontext.%ROWCOUNT=$g(%ROWCOUNT) } Else { Set:$isobject($g(%sqlcontext)) %sqlcontext.%SQLCODE=SQLCODE,%sqlcontext.Message=$g(%msg) Set sc=$$Error^%apiOBJ(5540,SQLCODE,$get(%msg)) }
	Quit sc }
 q
%QExtent0o 
 s $zt="%QExtent0E" s SQLCODE=$s($g(%objcsc(%qHandle)):-101,1:0) q:SQLCODE'=0  s %objcsd(%qHandle,1)=0 set:$d(%0CacheRowLimit)#2 %objcsd(%qHandle,2)=%0CacheRowLimit s %objcsd(%qHandle,3)=0,%objcsd(%qHandle,4)="" d:$zu(115,15) $system.ECP.Sync()
 s %objcsc(%qHandle)=1 q
%QExtent0E s $zt="" d SQLRunTimeError^%apiSQL($ze,.SQLCODE,.%msg) k %objcsd(%qHandle),%objcsc(%qHandle),%objcss(%qHandle),%objcst(%qHandle),%objcsp(%qHandle) q
%0Efirst 
 ; asl MOD# 2
 s %objcsd(%qHandle,5)=""
%0EmBk1 s %objcsd(%qHandle,5)=$o(^BEDD.EDSYSTEMI("SiteIdx",%objcsd(%qHandle,5)))
 i %objcsd(%qHandle,5)="" g %0EmBdun
 s %objcsd(%qHandle,6)=""
%0EmBk2 s:%objcsd(%qHandle,5)="" %objcsd(%qHandle,5)=-1E14
 s %objcsd(%qHandle,6)=$o(^BEDD.EDSYSTEMI("SiteIdx",%objcsd(%qHandle,5),%objcsd(%qHandle,6)))
 i %objcsd(%qHandle,6)="" g %0EmBk1
 s:%objcsd(%qHandle,5)=-1E14 %objcsd(%qHandle,5)=""
 g:$zu(115,2)=0 %0EmBuncommitted i $zu(115,2)=1 l +^BEDD.EDSYSTEMD($p(%objcsd(%qHandle,6),"||",1))#"S":$zu(115,4) i $t { s %objcsd(%qHandle,3)=1,%objcsd(%qHandle,4)=$name(^BEDD.EDSYSTEMD($p(%objcsd(%qHandle,6),"||",1)))_"#""SI""" } else { s SQLCODE=-114,%msg="Unable to acquire shared lock on table BEDD.EDSYSTEM for RowID value: "_%objcsd(%qHandle,6) ztrap "LOCK"  }
 ; asl MOD# 3
 i %objcsd(%qHandle,6)'="",$d(^BEDD.EDSYSTEMD(%objcsd(%qHandle,6)))
 e  g %0EmCdun
%0EmBuncommitted ;
 s:$g(SQLCODE)'<0 SQLCODE=0 s %objcsd(%qHandle,1)=%objcsd(%qHandle,1)+1,%ROWCOUNT=%objcsd(%qHandle,1),%ROWID=%objcsd(%qHandle,6),%objcsc(%qHandle)=10 q
%QExtent0f i '$g(%objcsc(%qHandle)) { s SQLCODE=-102 q  } i %objcsc(%qHandle)=100 { s SQLCODE=100 q  } s SQLCODE=0
 s $zt="%0Eerr"
 i $d(%objcsd(%qHandle,2))#2,$g(%objcsd(%qHandle,1))'<%objcsd(%qHandle,2) { s SQLCODE=100,%ROWCOUNT=%objcsd(%qHandle,1),%objcsc(%qHandle)=100 q }
 g %0Efirst:%objcsc(%qHandle)=1
%0EmCdun if $zu(115,2)=1 { if $g(%objcsd(%qHandle,3))=1 { l -@%objcsd(%qHandle,4) s %objcsd(%qHandle,3)=0 } elseif $g(%objcsd(%qHandle,3))=2 { do $classmethod($li(%objcsd(%qHandle,4)),"%UnlockId",$li(%objcsd(%qHandle,4),2),1,1)  s %objcsd(%qHandle,3)=0 } }
 g %0EmBk2
%0EmBdun 
%0EmAdun 
 s %ROWCOUNT=%objcsd(%qHandle,1),SQLCODE=100,%objcsc(%qHandle)=100 q
%QExtent0c i '$g(%objcsc(%qHandle)) { s SQLCODE=-102 q  }
 s %ROWCOUNT=$s($g(SQLCODE)'<0:+$g(%objcsd(%qHandle,1)),1:0)
 if $zu(115,2)=1 { if $g(%objcsd(%qHandle,3))=1 { l -@%objcsd(%qHandle,4) } elseif $g(%objcsd(%qHandle,3))=2 { do $classmethod($li(%objcsd(%qHandle,4)),"%UnlockId",$li(%objcsd(%qHandle,4),2),1,1)  } }
 k %objcsd(%qHandle),%objcsc(%qHandle) s SQLCODE=0 q
%0Eerr s $zt="" d SQLRunTimeError^%apiSQL($ze,.SQLCODE,.%msg)
 s %objcsc(%qHandle)=100 q
%0Io d %QExtent0f q:SQLCODE'=0
 s c1=%objcsd(%qHandle,6)
 q
%0Jo d %QExtent0f q:SQLCODE'=0
 s c1=%objcsd(%qHandle,6)
 q
zExtentFunc() public {
	try {
		set tSchemaPath = ##class(%SQL.Statement).%ClassPath($classname())
			set tStatement = ##class(%SQL.Statement).%New(,tSchemaPath)
			do tStatement.prepare(" SELECT ID FROM BEDD . EDSYSTEM")
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
	If $Get(^oddPROC("BEDD","EDSYSTEM_EXTENT",21))'="" { Set sc = 1, metadata=$Select(version=4:^oddPROC("BEDD","EDSYSTEM_EXTENT",12),1:^oddPROC("BEDD","EDSYSTEM_EXTENT",12,version)) }
	ElseIf $Data(^oddPROC("BEDD","EDSYSTEM_EXTENT")) { Set sc = $$CompileSignature^%ourProcedure("BEDD","EDSYSTEM_EXTENT",.metadata,.signature) }
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
	if '..%SQLGetLock(id,1,.pUnlockRef) { set sqlcode=-114,%msg=$$FormatMessage^%occMessages(,"%SQL.Filer","SQLFiler39",,"BEDD"_"."_"EDSYSTEM"_":"_"IDKEY") QUIT 0 }
	if 'pLockOnly { new qv set qv=$d(^BEDD.EDSYSTEMD(%pVal(1))) do:'$g(pUnlockRef) ..%SQLReleaseLock(id,1) quit qv } else { do:'$g(pUnlockRef) ..%SQLReleaseLock(id,1) QUIT 1 }
	Quit
zIDKEYSQLFindPKeyByConstraint(%con)
 QUIT $$Error^%apiOBJ(5758,"%Persistent::IDKEYSQLFindPKeyByConstraint")
zIDKEYSQLFindRowIDByConstraint(%con,pInternal=0)
 QUIT $$Error^%apiOBJ(5758,"%Persistent::IDKEYSQLFindRowIDByConstraint")
zSiteIdxExists(K1,id="")
	new %ROWCOUNT,SQLCODE,temp
	 ;---&sql(SELECT %ID INTO :id FROM BEDD.EDSYSTEM WHERE (:K1 is not null and Site = :K1) OR (:K1 IS NULL AND Site IS NULL))
 	 ;--- ** SQL PUBLIC Variables: %ROWCOUNT, %ROWID, %msg, K1, SQLCODE, id
	Do %0Ko
	Quit $select('SQLCODE:1,1:0)
 q
%0Ko 
 n %mmmsqlc,%mmmsqld,%mmmsqlE,%mmmsqll,%mmmsqln,%mmmsqlp,%mmmsqlR,%mmmsqls,%mmmsqlt,%mmmsqlZ s $zt="%0Kerr" s %mmmsqld(1)=0,%mmmsqld(2)="" d:$zu(115,15) $system.ECP.Sync()
 s %mmmsqld(3)=$g(K1),%mmmsqld(4)=$g(K1),%mmmsqld(5)=$g(K1),%mmmsqld(6)=" "
 s SQLCODE=100
 s %mmmsqld(7)=$zu(28,%mmmsqld(4),7)
 ; asl MOD# 2
 s %mmmsqld(8)=%mmmsqld(7) s:%mmmsqld(8)="" %mmmsqld(8)=-1E14
 s %mmmsqld(9)="",%mmmsqld(10)=1,%mmmsqld(11)="",%mmmsqld(12)=1,%mmmsqld(13)=""
 g %0KmBk1
%0KmBqt1 s %mmmsqld(9)="" q
%0KmBpt1 s %mmmsqld(10)=0
 i '(%mmmsqld(3)'="") g %0KmBqt1
 s %mmmsqld(14)=%mmmsqld(7)
 g %0KmBqt1:%mmmsqld(14)=""
 i '(%mmmsqld(14)'=" ") g %0KmBqt1
 g %0KmBft1:%mmmsqld(9)=""
%0KmBat1 g %0KmBpt1:%mmmsqld(10)
 g %0KmBgt1:$d(^BEDD.EDSYSTEMI("SiteIdx",%mmmsqld(14),%mmmsqld(9)))
%0KmBft1 g %0KmBpt1:%mmmsqld(10)
 s %mmmsqld(9)=$o(^BEDD.EDSYSTEMI("SiteIdx",%mmmsqld(14),%mmmsqld(9)))
 q:%mmmsqld(9)=""
%0KmBgt1 q
%0KmBqt2 s %mmmsqld(11)="" q
%0KmBpt2 s %mmmsqld(12)=0
 i '(%mmmsqld(5)="") g %0KmBqt2
 s %mmmsqld(15)=%mmmsqld(6)
 g %0KmBqt2:%mmmsqld(15)=""
 g %0KmBft2:%mmmsqld(11)=""
%0KmBat2 g %0KmBpt2:%mmmsqld(12)
 g %0KmBgt2:$d(^BEDD.EDSYSTEMI("SiteIdx",%mmmsqld(15),%mmmsqld(11)))
%0KmBft2 g %0KmBpt2:%mmmsqld(12)
 s %mmmsqld(11)=$o(^BEDD.EDSYSTEMI("SiteIdx",%mmmsqld(15),%mmmsqld(11)))
 q:%mmmsqld(11)=""
%0KmBgt2 q
%0KmBat3 i %mmmsqld(9)="",%mmmsqld(11)="" s %mmmsqld(9)=%mmmsqld(13) d %0KmBat1 s %mmmsqld(11)=%mmmsqld(13) d %0KmBat2 g %0KmBgt3
 i %mmmsqld(9)'="",%mmmsqld(13)]]%mmmsqld(9) s %mmmsqld(9)=%mmmsqld(13) d %0KmBat1
 i %mmmsqld(11)'="",%mmmsqld(13)]]%mmmsqld(11) s %mmmsqld(11)=%mmmsqld(13) d %0KmBat2
 g %0KmBgt3
%0KmBft3 d %0KmBft1:%mmmsqld(9)=%mmmsqld(13),%0KmBft2:%mmmsqld(11)=%mmmsqld(13)
%0KmBgt3 s %mmmsqld(13)=$S(%mmmsqld(9)="":%mmmsqld(11),%mmmsqld(11)="":%mmmsqld(9),%mmmsqld(11)]]%mmmsqld(9):%mmmsqld(9),1:%mmmsqld(11)) q
%0KmBk1 d %0KmBft3
 i %mmmsqld(13)="" g %0KmBdun
 s id=%mmmsqld(13)
 g:$zu(115,2)=0 %0KmBuncommitted i $zu(115,2)=1 l +^BEDD.EDSYSTEMD($p(id,"||",1))#"S":$zu(115,4) i $t { s %mmmsqld(1)=1,%mmmsqld(2)=$name(^BEDD.EDSYSTEMD($p(id,"||",1)))_"#""SI""" } else { s SQLCODE=-114,%msg="Unable to acquire shared lock on table BEDD.EDSYSTEM for RowID value: "_id ztrap "LOCK"  }
 ; asl MOD# 3
 i id'="",$d(^BEDD.EDSYSTEMD(id))
 e  g %0KmCdun
 s %mmmsqld(16)=$g(^BEDD.EDSYSTEMD(id)) s %mmmsqld(17)=$lg(%mmmsqld(16),8) s %mmmsqld(8)=$zu(28,%mmmsqld(17),7)
 g:'(((%mmmsqld(8)'=" ")&&((%mmmsqld(3)'="")&&(%mmmsqld(8)=%mmmsqld(7))))||((%mmmsqld(5)="")&&(%mmmsqld(8)=" "))) %0KmCdun
%0KmBuncommitted ;
 s SQLCODE=0 g %0Kc
%0KmCdun if $zu(115,2)=1 { if $g(%mmmsqld(1))=1 { l -@%mmmsqld(2) s %mmmsqld(1)=0 } elseif $g(%mmmsqld(1))=2 { do $classmethod($li(%mmmsqld(2)),"%UnlockId",$li(%mmmsqld(2),2),1,1)  s %mmmsqld(1)=0 } }
 g %0KmBk1
%0KmBdun 
%0KmAdun 
%0Kc s %ROWCOUNT='SQLCODE
 if $zu(115,2)=1 { if $g(%mmmsqld(1))=1 { l -@%mmmsqld(2) } elseif $g(%mmmsqld(1))=2 { do $classmethod($li(%mmmsqld(2)),"%UnlockId",$li(%mmmsqld(2),2),1,1)  } }
 q
%0Kerr s $zt="" d SQLRunTimeError^%apiSQL($ze,.SQLCODE,.%msg)
 g %0Kc
