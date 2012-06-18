ABMPUEXT ; IHS/SD/SDR - UFMS Re-extract of bills
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 Q
 ;Invoice file format:
 ;   1. Always D for Invoice (Bill)
 ;   2. <parent ASUFAC><satellite ASUFAC>3P BILL IEN
 ;   3. Date/Time Approved (MM/DD/YYYY) from 3P Bill file
 ;   4. TAX ID (.11) from Insurer file
 ;   5. <parent ASUFAC><satellite ASUFAC>3P BILL NUMBER
 ;   6. Bill Amount (.21) from 3P Bill file
 ;   7. CAN--for test set based on insurer type
 ;   8. Always (for now) 132 for HHS T-code
 ;   9. Always (for now) 61704 for object class
 ;
 ;Trailer record format:
 ;   1. Always T for trailer
 ;   2. Number of records
 ;   3. Total file amount
 ;
FROMDT ;EP
 S ABMFROM=3071001
TODT ;
 I $G(DT)="" D NOW^%DTC S DT=%
 S ABMTO=DT
 ;
 D FILENAME()
 D OPENLIST  ;compile list of bills in open sessions
 ;
EXTRACT ;
 D CREATBTH  ;create entry in 3P UFMS Export file
 ;
 K ^ABMTUFMS($J)
 S ABMTOT=0
 S ABMRECT="D"
 S ABMTCODE=132
 S ABMOCL=61704
 S ABMCNT=1
 D NOW^%DTC
 S ABMSTART=%
 S ABMDUZ2=0
 F  S ABMDUZ2=$O(^ABMDBILL(ABMDUZ2)) Q:+ABMDUZ2=0  D
 .Q:$D(^ABMDPARM(ABMDUZ2,1))'=10
 .S ABMADIEN=$O(^AUTTLOC(ABMDUZ2,11,9999999),-1)
 .Q:+ABMADIEN=0
 .Q:$P($G(^AUTTLOC(ABMDUZ2,11,ABMADIEN,0)),U,3)'=1  ;not IHS affiliation
 .S ABMLDT=(ABMFROM-.5)
 .F  S ABMLDT=$O(^ABMDBILL(ABMDUZ2,"AP",ABMLDT)) Q:ABMLDT=""!(($P(ABMLDT,"."))>ABMTO)  D
 ..S ABMP("BDFN")=0
 ..F  S ABMP("BDFN")=$O(^ABMDBILL(ABMDUZ2,"AP",ABMLDT,ABMP("BDFN"))) Q:+ABMP("BDFN")=0  D
 ...Q:$D(^TMP($J,"ABMUB",ABMDUZ2,ABMP("BDFN")))  ;quit if bill is on open list
 ...S ABMDTAPP=$P($G(^ABMDBILL(ABMDUZ2,ABMP("BDFN"),1)),U,5)  ;date/time approved
 ...S ABMP("INS")=$P($G(^ABMDBILL(ABMDUZ2,ABMP("BDFN"),0)),U,8)  ;active insurer
 ...Q:$P($G(^AUTNINS(ABMP("INS"),2)),U)="I"!($P($G(^AUTNINS(ABMP("INS"),2)),U)="T")  ;no Ben or Third Party Liab.
 ...S ABMDUZ=$P($G(^ABMDBILL(ABMDUZ2,ABMP("BDFN"),1)),U,4)  ;approving offical
 ...;
 ...S ABMTAXID=$TR($P($G(^AUTNINS(ABMP("INS"),0)),U,11),"-")  ;TAX ID
 ...;
 ...S ABMEXCLD=$$BILL^ABMUEAPI(ABMDUZ2,ABMP("BDFN"))  ;exclusion table entry?
 ...I ABMEXCLD<1 D BATCH,BILL Q  ;flag as excluded data in batch/on bill & quit
 ...;
 ...S ABMP("LDFN")=$P($G(^ABMDBILL(ABMDUZ2,ABMP("BDFN"),0)),U,3)  ;visit location
 ...S ABMPDOS=$P($G(^ABMDBILL(ABMDUZ2,ABMP("BDFN"),7)),U,1)  ;service date
 ...S ABMPRNTL=0
 ...S ABMPFLG=0
 ...F  S ABMPRNTL=$O(^BAR(90052.05,ABMPRNTL)) Q:+ABMPRNTL=0  D  Q:ABMPFLG=1
 ....I $D(^BAR(90052.05,ABMPRNTL,DUZ(2))) D
 .....I ABMPDOS<$P($G(^BAR(90052.05,ABMPRNTL,DUZ(2),0)),U,6) Q
 .....S ABMPFLG=1
 ...S ABMPASUF=$$ASUFAC($S(+$G(ABMPRNTL)'=0:ABMPRNTL,1:DUZ(2)),ABMPDOS)
 ...S ABMUAOF=$P($G(^ABMDPARM(ABMP("LDFN"),1,4)),U,17)  ;use asufac of
 ...S ABMSASUF=$$ASUFAC($S(+$G(ABMUAOF)'=0:ABMUAOF,1:ABMP("LDFN")),ABMPDOS)
 ...S ABMPBNUM=$P($G(^ABMDBILL(ABMDUZ2,ABMP("BDFN"),0)),U)  ;Bill Number
 ...S ABMP("BAMT")=$P($G(^ABMDBILL(ABMDUZ2,ABMP("BDFN"),2)),U)  ;bill amount
 ...S ABMP("ITYP")=$P($G(^AUTNINS(ABMP("INS"),2)),U)
 ...S ABMCLN=$P($G(^ABMDBILL(ABMDUZ2,ABMP("BDFN"),0)),U,10)
 ...;
 ...;CAN number
 ...S ABMCAN=$$EP^ABMUCAPI(ABMP("ITYP"),ABMCLN,ABMDTAPP,ABMSASUF)
 ...;
 ...S ABMCNT=ABMCNT+1
 ...S ABMP(ABMDUZ2)=+$G(ABMP(ABMDUZ2))+1
 ...;
 ...S ABMUAOF=$P($G(^ABMDPARM(ABMP("LDFN"),1,4)),U,17)  ;use asufac of
 ...;
 ...S ABMINV=$$FMT^ABMERUTL(ABMPASUF_$S(+$G(ABMUAOF)'=0:$$ASUFAC(ABMUAOF)_$E($P($G(^DIC(4,ABMP("LDFN"),0)),U),1),+$G(ABMUAOF)=0:ABMSASUF,1:"")_ABMP("BDFN"),20)
 ...S ABMREC=ABMRECT_ABMINV
 ...S ABMREC=ABMREC_$$SDT^ABMDUTL(ABMDTAPP)
 ...S ABMREC=ABMREC_$$FMT^ABMERUTL(ABMTAXID,10)
 ...S ABMDESC=ABMPASUF_$S(+$G(ABMUAOF)'=0:$$ASUFAC(ABMUAOF)_$E($P($G(^DIC(4,ABMP("LDFN"),0)),U),1),+$G(ABMUAOF)=0:ABMSASUF,1:"")_ABMPBNUM
 ...S ABMREC=ABMREC_$$FMT^ABMERUTL(ABMDESC,100)
 ...S ABMREC=ABMREC_$$FMT^ABMERUTL($TR($J(ABMP("BAMT"),".",2),"."),"20NR")
 ...S ABMREC=ABMREC_$$FMT^ABMERUTL("","10R")  ;no CAN
 ...S ABMREC=ABMREC_$$FMT^ABMERUTL(ABMTCODE,"10R")
 ...S ABMREC=ABMREC_ABMOCL
 ...S ABMREC=ABMREC_ABMCAN  ;ba/cc
 ...I "^R^MD^MH^"[("^"_ABMP("ITYP")_"^") S ABMPTIN="MCR"
 ...I "^D^K^"[("^"_ABMP("ITYP")_"^") S ABMPTIN="MCD"
 ...I "^H^M^P^F^"[("^"_ABMP("ITYP")_"^") S ABMPTIN="PRV"
 ...I "^W^C^N^"[("^"_ABMP("ITYP")_"^") S ABMPTIN="OTH"
 ...S ABMPTIN=ABMSASUF_ABMPTIN
 ...S ABMREC=ABMREC_ABMPTIN
 ...;
 ...S ^ABMTUFMS($J,ABMCNT)=ABMREC
 ...;set vars for BATCH tag
 ...S ABMDUZ=DUZ
 ...S ABMSDT=ABMSTART
 ...S ABMBAOUT=ABMP("ITYP")
 ...S ABMPREC=ABMPBNUM_"^"_ABMDUZ2_"^"_ABMP("BDFN")_"^"_ABMP("BAMT")
 ...D BATCH,BILL  ;put exported entry in batch/bill
 ...S ABMTOT=+$G(ABMTOT)+(ABMP("BAMT"))
 ...D DOTS(ABMCNT)
 ;
 Q:'$D(^ABMTUFMS($J))
 K ^TMP($J)
 D TRAILER
 D SENDFILE("ABMTUFMS(",ABMFILE)
 D NOW^%DTC
 S ABMEND=%
 W !,"START ",ABMSTART
 W !,"END ",ABMEND
  W !,"RECORD COUNTS"
 S ABMDUZ2=0
 F  S ABMDUZ2=$O(ABMP(ABMDUZ2)) Q:+ABMDUZ2=0  D
 .W !,ABMDUZ2,?6,+$G(ABMP(ABMDUZ2))
 S ^ABMUFEXP("EXPORT COMPLETE")=ABMEND
 Q
 ;
TRAILER ;EP
 S ABMREC="T"_$$FMT^ABMERUTL(ABMCNT,"10R")_$TR($$FMT^ABMERUTL(ABMTOT,"20NR"),".")
 S ^ABMTUFMS($J,(ABMCNT+1))=ABMREC
 Q
 ;
ASUFAC(X,Y) ;EP - get ASUFAC for DOS
 K ASUFAC
 S ASUFAC=0
 S ABMDT=0
 S ABMDTFLG=0
 S ASUFAC=$P($G(^AUTTLOC(X,0)),U,10)  ;ASUFAC index
 Q:+$G(ASUFAC)'=0 ASUFAC  ;ASUFAC found; stop here
 F  S ABMDT=$O(^AUTTLOC(X,11,ABMDT)) Q:ABMDT=""!(ABMDTFLG=1)  D
 .I Y>$P($G(^AUTTLOC(X,11,ABMDT,0)),U) D
 ..S ASUFAC=$P($G(^AUTTLOC(X,11,ABMDT,0)),U,6)
 ..S ABMDTFLG=1
 Q ASUFAC
 ;
FILENAME() ;
 S ABMLOC=$$FINDLOC^ABMUCUTL
 S ABMFILE=$$GETFILNM($$ASUFAC^ABMUCUTL(ABMLOC,DT))
 W !,"File will be created using the following name: ",!?5,ABMFILE
 I ABMFILE'="" Q 1
 Q 0
 ;
GETFILNM(ASUFACS) ;EP - create file name
 N FNROOT,FNEXT,FN,YR,DATE,TIME,DATETIME
 S FNROOT="IHS_TPB_RPMS_INV_POST_INIT_"
 S FNEXT="_"_$P($$VERSION^XPDUTL("ABM"),".")_"."_$$FMT^ABMERUTL($P($$VERSION^XPDUTL("ABM"),".",2),"2NR")_"."_+$$LAST^ABMENVCK("IHS 3P BILLING SYSTEM",$$VERSION^XPDUTL("ABM"))_"k.DAT"  ;version/patch in format 2.05.13
 S FN=FNROOT
 D NOW^%DTC
 S YR=1700+$E(%,1,3)
 S DATE=YR_$E(%,4,7)
 S Y=% X ^DD("DD")
 S TIME=$TR($P(Y,"@",2),":")
 S DATETIME=DATE_"_"_TIME
 S FN=FNROOT_ASUFACS_"_"_DATETIME
 S FN=FN_FNEXT
 Q FN
 ;
OPENLIST ;EP - compile list of bills in open sessions
 S ABMCL=0
 F  S ABMCL=$O(^ABMUCASH(ABMCL)) Q:+ABMCL=0  D  ;location loop
 .F ABMULP=10,20 D  ;user then POS entries
 ..S ABMUSER=0
 ..F  S ABMUSER=$O(^ABMUCASH(ABMCL,ABMULP,ABMUSER)) Q:+ABMUSER=0  D  ;user loop
 ...S ABMSDT=0
 ...F  S ABMSDT=$O(^ABMUCASH(ABMCL,ABMULP,ABMUSER,20,ABMSDT)) Q:+ABMSDT=0  D  ;sign-in dt loop
 ....Q:$P($G(^ABMUCASH(ABMCL,ABMULP,ABMUSER,20,ABMSDT,0)),U,8)'=""  ;has transmission date
 ....Q:$P($G(^ABMUCASH(ABMCL,ABMULP,ABMUSER,20,ABMSDT,0)),U,7)'=""  ;has reconciled date (tribal)
 ....S ABMBA=0
 ....F  S ABMBA=$O(^ABMUCASH(ABMCL,ABMULP,ABMUSER,20,ABMSDT,11,ABMBA)) Q:+ABMBA=0  D  ;budget act.loop
 .....S ABMABIL=0
 .....F  S ABMABIL=$O(^ABMUCASH(ABMCL,ABMULP,ABMUSER,20,ABMSDT,11,ABMBA,2,ABMABIL)) Q:+ABMABIL=0  D  ;appr. bill loop
 ......S ABMREC=$G(^ABMUCASH(ABMCL,ABMULP,ABMUSER,20,ABMSDT,11,ABMBA,2,ABMABIL,0))
 ......S ^TMP($J,"ABMUB",$P(ABMREC,U,2),$P(ABMREC,U,3))=$P(ABMREC,U)
 Q
 ;
CREATBTH ;EP - create UFMS export entry
 S DIC="^ABMUTXMT("
 S DIC("DR")=".02////"_ABMFILE_";.03////"_DUZ_";.04////"_ABMLOC
 S DIC(0)="L"
 D NOW^%DTC
 S X=%
 D ^DIC
 K DIC
 Q:Y<0
 S ABMPXMIT=+Y
 Q
 ;
BATCH ;EP - put bill in batch file
 D BATCH^ABMURCN1
 Q
BILL ;EP - put entry in bill mult for transmit dt & save UFMS inv#
 ;transmit dt
 ;
 ;remove all current entries
 K DIC,DIE,X,Y,DA
 S DA(1)=ABMP("BDFN")
 S DIK="^ABMDBILL("_ABMDUZ2_",DA(1),69,"
 S ABMDA=0
 F  S ABMDA=$O(^ABMDBILL(ABMDUZ2,DA(1),69,ABMDA)) Q:+ABMDA=0  D
 .S DA=ABMDA
 .D ^DIK
 ;
 ;creates entry
 K DIC,DIE,X,Y,DA
 S DIC(0)="L"
 S DA(1)=ABMP("BDFN")
 S DIC="^ABMDBILL("_ABMDUZ2_",DA(1),69,"
 S DIC("P")=$P(^DD(9002274.4,69,0),U,2)
 S X=ABMPXMIT  ;date from batch
 S DIC("DR")=".02////"_ABMPASUF_ABMSASUF_$S(+$G(ABMUAOF)'=0:$E($P($G(^DIC(4,ABMP("LDFN"),0)),U),1),1:"")_ABMP("BDFN")
 I ABMEXCLD<1 S DIC("DR")=DIC("DR")_";.03////1"  ;excluded data
 D ^DIC
 Q
 ;
SENDFILE(XBGL,XBFN) ;
 S:$G(XBFN)="" XBFN="UFMS.TST"
 S:$G(XBGL)="" XBGL="ABMTUFMS("
 S XBQSHO=""
 S XBF=$J    ; Beginning 1st level numeric subscript
 S XBE=$J    ; Ending 1st level numeric subscript
 S XBFLT=1  ; indicates flat file
 S XBMED="F"     ; Flag indicates file as media
 S XBCON=1    ; Q if non-cononic
 S XBS1="ABM UFMS F"   ;ZISH SEND PARAMETERS entry
 I $D(ZTQUEUED) S XBS1="ABM UFMS B"
 S XBQ="N"
 S XBUF=$P($G(^ABMDPARM(ABMLOC,1,4)),U,13)
 I XBUF="" D  Q
 .W !!,"Before UFMS files can be created a non-public directory must be created"
 .W !,"on the Host File System. This directory must be entered in to TPB Site Parameter"
 .W !,"field UFMS DIRECTORY using the 'SET  UFMS Setup' option"
 .K DIR
 .S DIR(0)="E"
 .D ^DIR
 S XBFLG=0
 ;
 I XBUF="" D  Q
 .S XBFLG=-1
 .S XBFLG(1)="Missing UFMS storage directory. Please check TPB UFMS Parameters"
 D ^XBGSAVE
 Q
DOTS(X) ;EP - WRITE OUT A DOT EVERY HUNDRED
 U IO(0)
 W:'(X#100) "."
 Q
