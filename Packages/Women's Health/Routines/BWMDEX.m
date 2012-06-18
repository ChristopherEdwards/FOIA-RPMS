BWMDEX ;IHS/CIA/DKM - EXPORT MDE'S FOR CDC.;06-Oct-2003 15:36;DKM
 ;;2.0;WOMEN'S HEALTH;**9,12**;MAY 16, 1996
 ;CIA/DKM     - patch 9 complete rewrite of MDE
EXPORT ; EP: Called by option BW CDC EXPORT DATA.
 D START(0,"MDE DATA EXTRACT FOR CDC",3,$$CDCFMT)
 Q
ADHOC ; EP: Adhoc extracts
 D START(1,"MDE DATA ADHOC EXTRACT",2)
 Q
 ;
 ; Common EP for all extracts.
START(BWADHOC,BWTITLE,BWSET,BWFMT) ;
 N BWPATH,BWFILE,BWPOP,BWSILENT,BWFLT,BWTASK,Y
 D SETVARS^BWUTL5
 D CHECKS^BWMDE4
 Q:BWPOP
 D TITLE^BWUTL5(BWTITLE),FILTER(.BWSET,.BWFLT)
 Q:BWPOP
 D FLTDSPL(BWSET,.BWFLT)
 S:'$G(BWFMT) BWFMT=$$GETIEN^BWUTLP(9002086.96,"Select an extract format: ")
 Q:BWPOP
 S BWTASK=$$DIRYN^BWUTLP("Queue extract to run in background","NO",,.BWPOP)
 Q:BWPOP
 I BWTASK D
 .Q:$$HFSOPEN^BWMDEX1(.BWFILE,.BWPATH,1)
 .S ZTRTN="START2^BWMDEX",ZTDESC=BWTITLE,ZTDTH=$H,ZTIO="",ZTSAVE("BW*")="",BWSILENT=""
 .D ^%ZTLOAD
 .K BWSILENT
 .D SHOWDLG^BWUTLP(-11_U_ZTSK_U_BWFILE_U_BWPATH)
 E  D SHOWDLG^BWUTLP(8),START2,COUNTS(.BWFLT)
 Q
 ; Entry point for background and foreground search.
START2 N BWGBL
 S BWGBL=$NA(^BWTMP($J))
 D SEARCH(.BWFLT,.BWFMT,BWGBL)
 D:'BWPOP OUTPUT^BWMDEX1(BWGBL,BWADHOC,.BWFILE)
 Q
 ; Called by RPC to perform extract
 ; BWADHOC = 1=Ad hoc extract, 0=CDC export (Make entry in Log File)
 ; BWBEGDT = Beginning date for export
 ; BWENDDT = Ending date for export
 ; BWLOC   = Array of locations to include
 ; BWHCF   = Array of facilities to include
 ; BWCC    = Array of communities to include
 ; BWPRV   = Array of providers to include
 ; BWCUTF  = Youngest age to include
 ; BWCUTO  = Oldest age to include
LOAD(BWADHOC,BWBEGDT,BWENDDT,BWLOC,BWHCF,BWCC,BWPRV,BWCUTF,BWCUTO) ;
 N BWFLT,BWGBL,BWSILENT,ZTRTN,ZTDESC,ZTDTH,ZTIO,ZTSAVE
 D FILTER(1,.BWFLT,1)
 S BWFLT(1,"V",BWCUTF)="",BWFLT(1,"V",BWCUTO)=""
 M BWFLT(2,"V")=BWLOC
 M BWFLT(3,"V")=BWHCF
 M BWFLT(4,"V")=BWCC
 S BWFLT(5,"V",BWBEGDT)="",BWFLT(5,"V",BWENDDT)=""
 M BWFLT(6,"V")=BWPRV
 S BWGBL=$NA(^BWTMP($J))
 S BWSILENT=1
 S ZTRTN="LOAD1^BWMDEX",ZTDESC=$G(BWTITLE,"EXPORT MDE DATA FOR CDC"),ZTDTH=$H,ZTIO="",ZTSAVE("BW*")=""
 D ^%ZTLOAD
 Q
 ; Taskman entry point for LOAD
LOAD1 D SEARCH(.BWFLT,$$CDCFMT,BWGBL)
 D OUTPUT^BWMDEX1(BWGBL,BWADHOC)
 Q
 ;
 ; Filter setup
 ; .BWSET = IEN of filter set (prompted if not given)
 ; .BWFLT = Filter array to build
 ;  BWSILENT = Suppresses prompt (optional)
 ;
FILTER(BWSET,BWFLT,BWSILENT) ;
 N BWSEQ,BWVAL,BWSEP,X,Y
 K BWFLT
 S:'$G(BWSET) BWSET=$$GETIEN^BWUTLP(9002086.95,"Choose a filter set: ")
 Q:BWPOP
 S BWSEQ=0,BWSEP=$$REPEAT^XLFSTR("-",80)
 F  S BWSEQ=$O(^BWFLT2(BWSET,1,"AC",BWSEQ)),BWFLT=0 Q:'BWSEQ!BWPOP  D
 .F  S BWFLT=$O(^BWFLT2(BWSET,1,"AC",BWSEQ,BWFLT)) Q:'BWFLT!BWPOP  D
 ..S BWFLT(BWFLT,"F")=$G(^BWFLT(BWFLT,1)),BWSEP(0)=1
 ..S BWFLT(BWFLT,"N")=''$P(^BWFLT2(BWSET,1,BWFLT,0),U,3)
 ..I '$D(BWSILENT),$P(^BWFLT2(BWSET,1,BWFLT,0),U,4),'$$FLTINC K BWFLT(BWFLT) Q
 ..I $O(^BWFLT2(BWSET,1,BWFLT,1,0)) D
 ...S BWVAL=0
 ...F  S BWVAL=$O(^BWFLT2(BWSET,1,BWFLT,1,BWVAL)) Q:'BWVAL  S BWFLT(BWFLT,"V",^(BWVAL,0))=""
 ..E  I '$D(BWSILENT),$L($G(^BWFLT(BWFLT,2))) D
 ...W !,$$SEP
 ...X ^BWFLT(BWFLT,2)
 ..S X=$G(^BWFLT(BWFLT,4))
 ..Q:'$L($P(X,U))
 ..I $D(BWFLT("I")),BWFLT("I",2)>$P(X,U,2) Q
 ..F Y=1:1:3 S BWFLT("I",Y)=$P(X,U,Y)
 ..S BWFLT("I",0)=BWFLT
 K:BWPOP BWFLT
 W:'$D(BWSILENT) !,BWSEP,!
 Q
 ; Returns "include" or "exclude" for filter
INCEXC(BWFLX,BWCAP) ;
 N X
 S X=$S(BWFLT(BWFLX,"N"):"ex",1:"in")_"clude "
 S:$G(BWCAP) $E(X)=$C($A(X)-32)
 Q X
 ; Prompt for inclusion of filter
FLTINC() W !!,$$SEP,$$INCEXC(BWFLT,1),$P(^BWFLT(BWFLT,0),U,2),"."
 Q $$DIRYN^BWUTLP(19,"NO",20,.BWPOP)
 ; Write separator if not already done
SEP() W:BWSEP(0) BWSEP,!
 S BWSEP(0)=0
 Q ""
 ; Display filter settings
FLTDSPL(BWSET,BWFLT) ;
 N BWSEQ
 S BWSEQ=0
 W !!,"Criteria settings for ",$$GET1^DIQ(9002086.95,BWSET,.01),":",!!
 F  S BWSEQ=$O(^BWFLT2(BWSET,1,"AC",BWSEQ)),BWFLT=0 Q:'BWSEQ  D
 .F  S BWFLT=$O(^BWFLT2(BWSET,1,"AC",BWSEQ,BWFLT)) Q:'BWFLT  D
 ..I $D(BWFLT(BWFLT)),$D(^BWFLT(BWFLT,3)) W "Will "_$$INCEXC(BWFLT) X ^(3)
 W !!
 Q
 ;
 ; Retrieve data and store in target global.
SEARCH(BWFLT,BWFMT,BWGBL) ;
 N BWIEN,BWDATA,BWPT,BWDFN,BWFAC,BWDT,BWPAP,BWMAM,BWCBE,BWDOT
 S (BWDOT,BWIEN)=0
 K @BWGBL
 D RESETCNT(.BWFLT)
 F  D NXTIEN Q:'BWIEN  D
 .I '$D(BWSILENT),'$D(ZTQUEUED) S BWDOT=BWDOT+1#100 W:'BWDOT "."
 .D LOADDATA(BWIEN)
 .Q:'BWPT         ; Ignore if no procedure type
 .Q:$$PC(3,2)     ; Ignore if not marked for export
 .Q:$$PC(0,5)=8   ; Ignore if marked as ERROR/DISREGARD.
 .Q:$E($G(^DPT(BWDFN,0)),1,5)="DEMO,"  ; Exclude demo patients
 .; Now check against active filter set
 .S BWFLT=0,BWFLT("C")=BWFLT("C")+1
 .F  S BWFLT=$O(BWFLT(BWFLT)) Q:'BWFLT  I 1 X BWFLT(BWFLT,"F") Q:'BWFLT(BWFLT,"N")-$T
 .I BWFLT S BWFLT(BWFLT,"C")=BWFLT(BWFLT,"C")+1 Q
 .S BWFLT(0,"C")=BWFLT(0,"C")+1
 .D EXPORT^BWMDEX1(.BWFMT,BWIEN,BWGBL)  ; Build the export record for this patient
 .S:BWPT'=1 ^TMP("BWTPCD",$J,BWIEN)="" ;IHS/CIM/THL PATCH 8
 Q
 ; Return next IEN in sequence
NXTIEN I '$D(BWFLT("I")) S BWIEN=$O(^BWPCD(BWIEN)) Q
 S:'BWIEN BWFLT("I")=$O(BWFLT(BWFLT("I",0),"V",""))
 I '$L(BWFLT("I")) S BWIEN=0 Q
 I BWFLT("I",3) D
 .F  Q:'$L(BWFLT("I"))  D  Q:BWIEN
 ..S BWIEN=$O(^BWPCD(BWFLT("I",1),BWFLT("I"),BWIEN))
 ..S:'BWIEN BWFLT("I")=$O(BWFLT(BWFLT("I",0),"V",BWFLT("I")))
 E  D
 .S:'$D(BWFLT("I",-1)) BWFLT("I",-1)=$O(BWFLT(BWFLT("I",0),"V",""),-1)
 .F  Q:BWFLT("I")>BWFLT("I",-1)!'BWFLT("I")  D  Q:BWIEN
 ..S BWIEN=$O(^BWPCD(BWFLT("I",1),BWFLT("I"),BWIEN))
 ..S:'BWIEN BWFLT("I")=$O(^BWPCD(BWFLT("I",1),BWFLT("I")))
 Q
 ; Show results of search
COUNTS(BWFLT) ;
 W !!
 D DCNT("Records considered",BWFLT("C"))
 D DCNT("Records selected",BWFLT(0,"C"))
 D DCNT("Records rejected",BWFLT("C")-BWFLT(0,"C"))
 S BWFLT=0
 F  S BWFLT=$O(BWFLT(BWFLT)) Q:'BWFLT  D
 .Q:BWFLT=$G(BWFLT("I",0))
 .D DCNT($S(BWFLT(BWFLT,"N"):"~",1:" ")_$$GET1^DIQ(9002086.94,BWFLT,.01),BWFLT(BWFLT,"C"),5)
 W !!
 Q
 ; Display count
DCNT(BWLBL,BWCNT,BWIND) ;
 W ?$G(BWIND),BWLBL,?25,":",?30,$J(+BWCNT,6),!
 Q
 ; Reset counts
RESETCNT(BWFLT) ;
 S BWFLT("C")=0,BWFLT=0
 F  S BWFLT(BWFLT,"C")=0,BWFLT=$O(BWFLT(BWFLT)) Q:'BWFLT
 Q
 ; Load data from specified record
 ; Sets up the following data:
 ;   BWDATA = Merged from record identified by BWIEN
 ;   BWDFN  = Patient IEN
 ;   BWPT   = Procedure type
 ;   BWFAC  = Facility
 ;   BWDT   = Procedure date
 ;   BWPAP  = True if PAP
 ;   BWMAM  = True if Mammogram
 ;   BWCBE  = True if Standalone CBE
LOADDATA(BWIEN) ; EP
 K BWDATA
 M BWDATA=^BWPCD(BWIEN)
 S BWDFN=$$PC(0,2),BWPT=$$PC(0,4),BWFAC=$$PC(0,10),BWDT=$$PC(0,12)
 S BWPAP=BWPT=1,BWMAM="^25^26^28^"[(U_BWPT_U),BWCBE=BWPT=27
 Q
 ; Return IEN of export format for default CDC version
CDCFMT() Q +$O(^BWFMT("B","CDC"_$$CDCVER^BWMDEX2,0))
 ; Return data from specified node and piece
 ;  BWN = Node subscript
 ;  BWP = Data piece (defaults to 1)
 ;  BWT = If specified and zero, forces null return value
PC(BWN,BWP,BWT) ; EP
 Q $S($G(BWT)=0:"",1:$P($G(BWDATA(BWN)),U,$G(BWP,1)))
