BLRUTIL4 ;IHS/MSC/MKK - MISC IHS LAB UTILITIES (Cont)  [ 12/13/2007  8:25 AM ]
 ;;5.2;LR;**1031**;NOV 01, 1997
 ;
 ; Determines if MODULE exists on server
MODEXIST(MODULE) ; EP
 NEW HEREYAGO,NAME,PATCH,PTR,SYSVER,VERSION
 ;
 D FIND^DIC(9.4,"",,,MODULE,,"C",,,"HEREYAGO")
 S PTR=+$G(HEREYAGO("DILIST",2,1))
 ;
 Q:PTR<1 "0^NOT ON THIS SERVER^"
 ;
 ; Special logic for INTEGRATED BILLING
 I $G(HEREYAGO("DILIST",1,1))["INTEGRATED BILL" Q "0^NOT ON THIS SERVER^"
 I $G(HEREYAGO("DILIST",1,1))["IB ENCOUNTER" Q "0^NOT ON THIS SERVER^"
 ;
 S SYSVER=+$$VERSION^XPDUTL(MODULE)      ; Get Current Version #
 ;
 ; Special logic for VA Clinical Reminders
 Q:MODULE="PXRM"&(SYSVER<2) "0^NOT ON THIS SERVER^"
 ;
 ; Special logic for VA Patient Encounter module
 I MODULE="PCE"!(MODULE="PX") D
 . Q:MODULE="PXRM"                       ; Skip Clinical Reminders
 . S MODULE="PX"
 . S VERSION="1.0"
 . S PATCH=168       ; Latest VA Patch as of 5/1/2009
 . S SYSPATCH=$$PATCH^XPDUTL(MODULE_"*"_VERSION_"*"_PATCH)
 . S:SYSPATCH<1 SYSVER=0
 ;
 ; If PTR>0 but SYSVER<1, then Module is a stub.
 ; Full Module (with all of its routines) does not exist on the server.
 Q:SYSVER<1 "0^NOT ON THIS SERVER^"
 ;
 S NAME=$G(HEREYAGO("DILIST",1,1))
 ;
 Q PTR_"^"_NAME_"^"_SYSVER
 ;
 ; Get Health Record Number -- see LA7UID2 routine
GETHRCN(LRDFN,INHRCN) ; EP
 Q:+$G(INHRCN)>0 +$G(INHRCN)       ; If #, just return it
 ;
 ; If LRDFN not from VA Patient file, return passed variable (if it exists)
 I $P($G(^LR(LRDFN,0)),"^",2)'=2 Q $G(INHRCN)
 ;
 ; New variables
 NEW ACCINST,DFN,HRCN,LRIDT,LRSS
 ;
 ; Get Patient file IEN
 S DFN=+$P($G(^LR(LRDFN,0)),"^",3)
 ;
 ; Use IHS DICTIONARIES function call
 S HRCN=$$HRN^AUPNPAT(DFN,DUZ(2))
 ;
 Q:+HRCN HRCN
 ;
 ; DUZ(2) did not return the HRCN.
 ; Use the Lab Data File's ACCESSIONING INSTITUTION field.
 ;
 ; Get Lab Data File Subscript
 S LRSS=$P($G(^LRO(68,+$G(LRAA),0)),"^",2)
 ;
 ; If LRSS still null, try LA7UID accession variable
 S:LRSS="" LRSS=$P($G(^LRO(68,+$G(LA768),0)),"^",2)
 ;
 ; Could not retrieve Subscript, so return passed variable (if it exists)
 Q:$L(LRSS)<1 $G(INHRCN)
 ;
 ; Try to get LRIDT using LRAA,LRAD,LRAN variables
 S LRIDT=$P($G(^LRO(68,+$G(LRAA),1,+$G(LRAD),1,+$G(LRAN),3)),"^",5)
 ;
 ; If LRIDT still null, try LA7UID accession variables
 S:LRIDT="" LRIDT=$P($G(^LRO(68,+$G(LA768),1,+$G(LA76801),1,+$G(LA76802),3)),"^",5)
 ;
 ; If LRIDT still null, return passed variable (if it exists)
 Q:$L(LRIDT)<1 $G(INHRCN)
 ;
 ; Get ACCessioning INSTitution
 S ACCINST=+$P($G(^LR(LRDFN,LRSS,+$G(LRIDT),0)),"^",14)
 ; 
 S HRCN=$$HRN^AUPNPAT(DFN,ACCINST)
 ;
 Q:+HRCN HRCN
 ;
 D:+$P($G(^BLRSITE($G(DUZ(2)),0)),U,10) ENTRYAUD^BLRUTIL("GETHRCN^BLRUTIL4 8.5")
 ;
 ; Could not retrieve HRCN, so return passed variable (if it exists)
 Q $G(INHRCN)
 ;
 ; Generic "Find RPMS Module's Version and (perhaps) Patch number"
 ; The MODULE variable MUST be the PREFIX name from the PACKAGE file (9.4).
NEEDIT(MODULE,VERSION,PATCH)      ; EP
 NEW NAME                ; Name of PACKAGE
 NEW HEREYAGO,STR1,STR2  ; Scratch variables/arrays
 NEW SYSVER,SYSPATCH     ; System Version & System Patch variables
 ;
 D FIND^DIC(9.4,"","","",MODULE,"","C","","","HEREYAGO")
 S NAME=$G(HEREYAGO("DILIST",1,1))
 ;
 S SYSVER=$$VERSION^XPDUTL(MODULE)     ; Get the System's Version
 ;
 ; If System Version < Needed Version, write message and quit
 I SYSVER<VERSION D  Q
 . W !,?4,"Need "_NAME_" "_VERSION_" & "_NAME_" "_SYSVER_" found!",!!
 ;
 D OKAY^BLRKIDSU(NAME_" "_SYSVER_" found.")
 I VERSION<SYSVER Q     ; If Version needed is lower, skip Patch check
 ;
 I $G(PATCH)="" Q   ; If no Patch check, just exit
 ;
 D BMES^XPDUTL("     Need "_NAME_" "_VERSION_" Patch "_PATCH)
 S SYSPATCH=$$PATCH(MODULE_"*"_VERSION_"*"_PATCH)
 I SYSPATCH'=1 D  Q
 . S ERRARRAY(MODULE,NAME,VERSION)=$G(PATCH)
 . D MES^XPDUTL($J("",10)_" & Patch "_PATCH_" WAS NOT installed!")
 ;
 D OKAY^BLRKIDSU("& Patch "_PATCH_" found.",10)
 ;
 Q
 ;
PACKSTR(X) ; EP - Remove Extra Spaces from within string
 F  Q:X'["  "  S X=$P(X,"  ",1)_" "_$P(X,"  ",2,9999)
 Q X
 ;
 ; Code cloned from PATCH^XPDUTL
PATCH(X) ;EP - Return 1 if patch X was installed, X=aaaa*nn.nn*nnn
 Q:X'?1.4UN1"*"1.2N1"."1.2N.1(1"V",1"T").2N1"*"1.6N 0
 N %,I,J
 S I=$O(^DIC(9.4,"C",$P(X,"*"),0)) Q:'I 0
 S J=$O(^DIC(9.4,I,22,"B",$P(X,"*",2),0)),X=$P(X,"*",3) Q:'J 0
 ;check if patch is just a number
 ;
 Q:$O(^DIC(9.4,I,22,J,"PAH","B",X,0)) 1
 ;
 S %=$O(^DIC(9.4,I,22,J,"PAH","B",X_" SEQ"))
 Q (X=+%)
 ;
CURLABP() ; EP - Return current Lab Patch
 NEW LABPATCH,PTR,STATUS,WOTPATCH
 ;
 S LABPATCH="<UNK>",STATUS=0,WOTPATCH="LR*5.2*1099"
 F  S WOTPATCH=$O(^XPD(9.7,"B",WOTPATCH),-1)  Q:WOTPATCH=""!($E(WOTPATCH,1,2)'="LR")!(STATUS=3)  D
 . S PTR="AAA"
 . F  S PTR=$O(^XPD(9.7,"B",WOTPATCH,PTR),-1)  Q:PTR=""!(STATUS=3)  D
 .. S STATUS=$P($G(^XPD(9.7,PTR,0)),"^",9)
 .. S:STATUS=3 LABPATCH=WOTPATCH
 ;
 Q LABPATCH
 ;
 ; The following moved from LRRP1 because LRRP1 became > 15000 bytes
GETCOMPD() ; EP -- Get Completion Date for test
 NEW COMPD,D3,DATALN,LRAA,LRAD,LRAN,LRAS,LRAT,LRSS,LOG,STR,TESTIEN,TMPDT,VLABIEN
 ;
 S LRAS=$P(LR0,"^",6)
 Q:'$L(LRAS) " "
 ;
 ; If no Pointer to file 60, return null
 S TESTIEN=+$P($G(LRDATA),"^",1)
 Q:TESTIEN<1 " "
 ;
 ; If test PENDING, there is no complete date -- return null
 S DATALN=+$P($P($G(^LAB(60,+$G(LRTSTS),0)),"^",5),";",2)
 I $$UP^XLFSTR($P($G(^LR(LRDFN,"CH",LRIDT,DATALN)),"^",1))["PEND" Q " "
 ;
 ; Break out Accession variables
 I $$GETACCCP^BLRUTIL3(LRAS,.LRAA,.LRAD,.LRAN)<1 Q " "
 ;
 ; If Accession Date (LRAD) year not the same as the collection date year, set LRAD = 0
 I $E(LRAD,1,3)'=$E($P($G(LRCDT),"."),1,3) S LRAD=0
 ;
 ; Get COMPLETE DATE for the test from Accession file
 S COMPD=$P($G(^LRO(68,LRAA,1,LRAD,1,LRAN,4,TESTIEN,0)),"^",5)
 ;
 Q:+$G(COMPD)>2000000 $$FMTE^XLFDT(COMPD,"2MZ")
 ;
 ; Completed date is null in Accession file; will try to get date
 ; from the BLRTXLOG file
 S (COMPD,VLABIEN,LOG)=0
 F  S LOG=$O(^BLRTXLOG("D",LRAS,LOG))  Q:LOG<1!(COMPD>0)  D
 . I $P($G(^BLRTXLOG(LOG,1)),"^",2)'="R" Q        ; Not RESULTED
 . I $P($G(^BLRTXLOG(LOG,0)),"^",6)'=TESTIEN Q    ; Wrong test
 . I $E(LRAD,1,3)'=$E($P($P($G(^BLRTXLOG(LOG,12)),"^"),"."),1,3) Q   ; Wrong year
 . ;
 . S COMPD=+$P($G(^BLRTXLOG(LOG,13)),"^",9)
 ;
 Q:+$G(COMPD)>2000000 $$FMTE^XLFDT(COMPD,"2MZ")
 ;
 ; Still null. Try to find the test in the V LAB file and use test's
 ; Accession #, IEN, and Collection Date to match
 ;
 S VLABIEN=.9999999
 F  S VLABIEN=$O(^AUPNVLAB("ALR0",LRAS,VLABIEN))  Q:VLABIEN<1!(COMPD>0)  D
 . I $P($G(^AUPNVLAB(VLABIEN,0)),"^")'=TESTIEN Q      ; If TEST doesn't match, skip
 . ; Collection Date/Time match only down to minutes, not seconds
 . I $E($P($G(^AUPNVLAB(VLABIEN,12)),"^",1),1,12)'=$E($P(LR0,"^"),1,12) Q
 . ;
 . S COMPD=+$P($G(^AUPNVLAB(VLABIEN,12)),"^",12)      ; V LAB Result Date
 ;
 Q:+$G(COMPD)>2000000 $$FMTE^XLFDT(COMPD,"2MZ")
 ;
 ; If still null, use the Lab Data File's DATE REPORT COMPLETED Date
 ; that's stored in the LR0 variable
 S COMPD=$P(LR0,"^",3)
 Q:+$G(COMPD)>2000000 $$FMTE^XLFDT(COMPD,"2MZ")
 ;
 ; All results dates checked and nothing found, so quit with null
 Q " "
 ;
ENTRYAUD(LABEL,TMPNODE) ; EP - Audit ^TMP global
 NEW ENTRYNUM,NOW,NOWTIM
 ;
 S NOW=$$NOW^XLFDT
 S ENTRYNUM=$G(^BLRENTRY)+1
 S $P(^BLRENTRY,U)=ENTRYNUM
 M ^BLRENTRY(DUZ,NOW,ENTRYNUM,LABEL_" ^TMP")=^TMP(TMPNODE)
 Q
 ;
NOCOLLDT ; EP - "Quick & Dirty" Routine to determine if Accession file has no DRAW DATE but an Accession Number
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 S BLRVERN=$TR($P($T(+1),";")," ")
 K ^TMP("BLRUTIL4",$J,"NOCOLLDT")
 ;
 W !!,?4,"Compilation Begins"
 S LRAA=.9999999,(BADCNT,CNT)=0
 F  S LRAA=$O(^LRO(68,LRAA))  Q:LRAA<1  D
 . S LRAD=0
 . F  S LRAD=$O(^LRO(68,LRAA,1,LRAD))  Q:LRAD<1  D
 .. S LRAN=0
 .. F  S LRAN=$O(^LRO(68,LRAA,1,LRAD,1,LRAN))  Q:LRAN<1  D
 ... Q:+$G(^LRO(68,LRAA,1,LRAD,1,LRAN,0))<1        ; No Zero Node Data, skip
 ... ;
 ... S UID=+$G(^LRO(68,LRAA,1,LRAD,1,LRAN,.3))
 ... Q:UID<1                                       ; No UID, skip
 ... ;
 ... S CNT=CNT+1
 ... W:(CNT#100)=0 "."  W:$X>74 !,?4
 ... ;
 ... Q:+$G(^LRO(68,LRAA,1,LRAD,1,LRAN,3))          ; Draw Date Exists
 ... ;
 ... W:($L(UID)+$X)>74 !,?3
 ... W " >",UID,"< "
 ... W:$X>74 !,?4
 ... S ^TMP("BLRUTIL4",$J,"NOCOLLDT",LRAA,LRAD,LRAN)=UID
 ... S BADCNT=BADCNT+1
 ;
 S WOTCOL=$X
 W:WOTCOL<(IOM-17) "Compilation Ends"
 W:WOTCOL>(IOM-18) !,?4,"Compilation Ends"
 ;
 W !!,?4,"Number of Accessions Analyzed = ",CNT,!
 W:BADCNT<1 !,?9,"All Accessions have Draw Dates",!
 W:BADCNT !,?9,"# of Accessions with No Draw Date = ",BADCNT,!
 ;
 D PRESSKEY^BLRGMENU(9)
 ;
 D:BADCNT NOCOLRPT
 ;
 K ^TMP("BLRUTIL4",$J,"NOCOLLDT")	
 Q
 ;
NOCOLRPT ; EP - Report on ^TMP("BLRUTIL4",$J,"NOCOLLDT"
 S HEADER(1)="Accessions With No Draw Date"
 S HEADER(2)=" "
 S HEADER(3)="LRAA"
 S $E(HEADER(3),6)="LRAD"
 S $E(HEADER(3),15)="LRAN"
 S $E(HEADER(3),25)="UID"
 S $E(HEADER(3),40)="ARRIVAL TIME"
 S $E(HEADER(3),55)="LRDFN"
 S $E(HEADER(3),65)="INVERSE DATE"
 ;
 D HEADERDT^BLRGMENU
 ;
 S LRAA=0
 F  S LRAA=$O(^TMP("BLRUTIL4",$J,"NOCOLLDT",LRAA))  Q:LRAA<1  D
 . S LRAD=0
 . F  S LRAD=$O(^TMP("BLRUTIL4",$J,"NOCOLLDT",LRAA,LRAD))  Q:LRAD<1  D
 .. S LRAN=0
 .. F  S LRAN=$O(^TMP("BLRUTIL4",$J,"NOCOLLDT",LRAA,LRAD,LRAN))  Q:LRAN<1  D
 ... S UID=+$G(^TMP("BLRUTIL4",$J,"NOCOLLDT",LRAA,LRAD,LRAN))
 ... S LRDFN=+$G(^LRO(68,LRAA,1,LRAD,1,LRAN,0)),STR3=$G(^(3))
 ... S LABARRT=$P(STR3,"^",3)
 ... S LRIDT=$P(STR3,"^",5)
 ... ;
 ... W LRAA
 ... W ?5,LRAD
 ... W ?14,LRAN
 ... W ?24,UID
 ... W ?39,LABARRT
 ... W ?54,LRDFN
 ... W ?64,LRIDT
 ... W !
 ;
 D PRESSKEY^BLRGMENU(9)
 Q
