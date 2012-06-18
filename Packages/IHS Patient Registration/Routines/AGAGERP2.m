AGAGERP2 ;VNGT/IHS/DLS - Patient Age Specific Report ; April 29, 2010
 ;;7.1;PATIENT REGISTRATION;**8,9**;AUG 25, 2005
 ;
PRINT ; Print the report
 I $D(^TMP("AGAGERP",$J))<11 W !,"No Records Found!" H 2 Q
 N RPTDT,POP,%H,X,Y,AGLOC,AGLINE
 S %H=$H D YX^%DTC S RPTDT=Y
 S $P(AGLINE("EQ"),"=",80)=""
 S $P(AGLINE("DASH"),"-",80)=""
 ;
START ; Begin the output process
 I $G(AGIO)="" U IO
 I $G(EXCL("Specific Patient"))'="" D PRTPNT Q
 I $G(EXCL("Alternate Resource"))["MEDICARE" D PRTMEDC^AGAGERP3 Q
 I $G(EXCL("Alternate Resource"))["MEDICAID" D PRTMEDD^AGAGERP3 Q
 I $G(EXCL("Alternate Resource"))["CHIP" D PRTPRVT^AGAGERP3 Q
 I $G(EXCL("Alternate Resource"))["PRIVATE INSURANCE" D PRTPRVT^AGAGERP3 Q
 I $G(EXCL("Alternate Resource"))["PRIVATE + WORK" D PRTPRVT^AGAGERP3 Q
 I $G(EXCL("Alternate Resource"))["SPECIFIC INSURER" D PRTPRVT^AGAGERP3 Q
 D PRTNOAR
 Q
 ;
PRTNOAR ; Print for selections without an Alternate Resource
 N PAGENO,PATNUM,PATIEN,LINECT,ESCAPE,PATNAM,AGTOTAL
 S (PAGENO,ESCAPE,AGTOTAL)=0
 D HDR
 S PATNAM=""
 F  S PATNAM=$O(^TMP("AGAGERP",$J,PATNAM)) Q:(PATNAM="")!(ESCAPE)  D
 . S PATIEN=""
 . F  S PATIEN=$O(^TMP("AGAGERP",$J,PATNAM,PATIEN)) Q:PATIEN=""  D
 . . N CHRTNO,PHONE,ADDR1,ADDR2,ADDR3,CITY,ST,ZIP,DOB,LASTUPD,APPSTAT,APPSTDT,APPNODE,STABB,AGE
 . . S CHRTNO=$P($G(^AUPNPAT(PATIEN,41,DUZ(2),0)),U,2)
 . . S PHONE=$$GET1^DIQ(2,PATIEN,.131)
 . . S ADDR1=$$GET1^DIQ(2,PATIEN,.111)
 . . S ADDR2=$$GET1^DIQ(2,PATIEN,.112)
 . . S ADDR3=$$GET1^DIQ(2,PATIEN,.113)
 . . S CITY=$$GET1^DIQ(2,PATIEN,.114)
 . . S STABB=$$GET1^DIQ(2,PATIEN,.115,"I")
 . . S ST=$$GET1^DIQ(5,STABB,1)
 . . S ZIP=$$GET1^DIQ(2,PATIEN,.116)
 . . N Y S Y=$$GET1^DIQ(2,PATIEN,.03,"I") D DD^%DT S DOB=Y
 . . S AGE=$$GET1^DIQ(9000001,PATIEN,1102.98)
 . . S LASTUPD=$$GET1^DIQ(9000001,PATIEN,.03)
 . . S APPNODE=$O(^AUPNAPPS("B",PATIEN,""))
 . . I APPNODE'="" D
 . . . S APPNOD2=""
 . . . F  S APPNOD2=$O(^AUPNAPPS(APPNODE,11,APPNOD2))  Q:($O(^AUPNAPPS(APPNODE,11,APPNOD2))="B")!(APPNOD2="")
 . . . I APPNOD2'="" D
 . . . . S APPSTDT=$$GET1^DIQ(9000045.11,APPNOD2_","_APPNODE,.01)
 . . . . S APPSTAT=$$GET1^DIQ(9000045.11,APPNOD2_","_APPNODE,.04)
 . . W !,PATNAM," (",CHRTNO,")",?51,PHONE
 . . W !,?10,ADDR1,?51,DOB," ("
 . . I AGE["MOS" W AGE,")"
 . . I AGE'["MOS" W +AGE,")"
 . . I $G(ADDR2)'="" W !,?10,ADDR2
 . . I $G(ADDR3)'="" W !,?10,ADDR3
 . . W !,?10,CITY," ",ST," ",ZIP
 . . W !,LASTUPD,?51,$G(APPSTAT)
 . . I $G(APPSTDT)'="" W "/",$G(APPSTDT)
 . . W !,AGLINE("DASH") S LINECT=LINECT+11
 . . S AGTOTAL=$G(AGTOTAL)+1
 . . I $E(IOST)="C",$Y>(IOSL-5) K DIR D RTRN^AG S ESCAPE=X=U D:'ESCAPE HDR
 . . I $E(IOST)'="C",$Y>(IOSL-17) W !! D HDR
 W !,"TOTAL RECORDS:",?20,$G(AGTOTAL),!!
 I $E(IOST)="C",PATNAM="" K DIR D RTRN^AG
 I $E(IOST)'="C" D CLOSE^%ZISH(IO)
 Q
 ;
PRTPNT ; Print Specific Patient
 N PAGENO,PATNUM,PATIEN,LINECT,ESCAPE,PATNAM,I
 S PAGENO=0,ESCAPE=0
 D HDRCHK
 I '$D(AGINS) D HDR
 I $D(AGINS) D HDR2
 S PATNAM=$P(EXCL("Specific Patient"),"^",2)
 S PATIEN=+EXCL("Specific Patient")
 N CHRTNO,PHONE,ADDR1,ADDR2,ADDR3,CITY,ST,ZIP,DOB,LASTUPD
 N APPSTAT,APPSTDT,APPIEN,APPSTAT1,APPNODE,STABB,APPNOD2,AGE,ARNO
 S CHRTNO=$P($G(^AUPNPAT(PATIEN,41,DUZ(2),0)),U,2)
 S PHONE=$$GET1^DIQ(2,PATIEN,.131)
 S ADDR1=$$GET1^DIQ(2,PATIEN,.111)
 S ADDR2=$$GET1^DIQ(2,PATIEN,.112)
 S ADDR3=$$GET1^DIQ(2,PATIEN,.113)
 S CITY=$$GET1^DIQ(2,PATIEN,.114)
 S STABB=$$GET1^DIQ(2,PATIEN,.115,"I")
 S ST=$$GET1^DIQ(5,STABB,1)
 S ZIP=$$GET1^DIQ(2,PATIEN,.116)
 N Y S Y=$$GET1^DIQ(2,PATIEN,.03,"I") D DD^%DT S DOB=Y
 S AGE=$$GET1^DIQ(9000001,PATIEN,1102.98)
 S LASTUPD=$$GET1^DIQ(9000001,PATIEN,.03)
 S APPNODE=$O(^AUPNAPPS("B",PATIEN,""))
 I APPNODE'="" D
 . S APPNOD2=""
 . F  S APPNOD2=$O(^AUPNAPPS(APPNODE,11,APPNOD2))  Q:($O(^AUPNAPPS(APPNODE,11,APPNOD2))="B")!(APPNOD2="")
 . I APPNOD2'="" D
 . . S APPSTDT=$$GET1^DIQ(9000045.11,APPNOD2_","_APPNODE,.01)
 . . S APPSTAT=$$GET1^DIQ(9000045.11,APPNOD2_","_APPNODE,.04)
 W !,PATNAM," (",CHRTNO,")"
 S ARNO=$O(AGINS(0))
 I ARNO'="",$D(AGINS) D
 . I AGE["MOS" W " (",AGE,")"
 . I AGE'["MOS" W " (",+AGE,")"
 . I ARNO'="",$D(AGINS(ARNO)) D
 . . D AGARNO
 I '$D(AGINS) W ?51,PHONE
 W !,?10,ADDR1
 I '$D(AGINS) D
 . W ?51,DOB
 . I AGE["MOS" W " (",AGE,")"
 . I AGE'["MOS" W " (",+AGE,")"
 I ARNO'="",$D(AGINS(ARNO)) D AGARNO
 I $G(ADDR2)'="" W !,?10,ADDR2 I ARNO'="",$D(AGINS(ARNO)) D AGARNO
 I $G(ADDR3)'="" W !,?10,ADDR3 I ARNO'="",$D(AGINS(ARNO)) D AGARNO
 W !,?10,CITY," ",ST," ",ZIP I ARNO'="",$D(AGINS(ARNO)) D AGARNO
 I '$D(AGINS) D
 . W !,LASTUPD,?51,$G(APPSTAT)
 . I $G(APPSTDT)'="" W "/",$G(APPSTDT)
 I $D(AGINS) D
 . W !,LASTUPD
 I ARNO'="",$D(AGINS(ARNO)) D AGARNO
 I ARNO'="",$D(AGINS(ARNO)) F I=ARNO:1 Q:'$D(AGINS(I))  W ! D AGARNO
 I $G(EXCL("Alternate Resource"))=""!($G(EXCL("Alternate Resource"))["NO RESOURCES") D
 . I '$D(AGINS),$G(APPSTAT)="" W ?51,"No Alternate Resources"
 . I '$D(AGINS),$G(APPSTAT)'="" W !,?51,"No Alternate Resources"
 I $G(EXCL("Alternate Resource"))'="",($G(EXCL("Alternate Resource"))'["NO RESOURCES") D
 . I '$D(AGINS),$G(APPSTAT)="" W ?51,"Resource Not Found"
 . I '$D(AGINS),$G(APPSTAT)'="" W !,?51,"Resource Not Found"
 W !,AGLINE("EQ") S LINECT=LINECT+7
 I $E(IOST)="C",$Y>(IOSL-5) K DIR D RTRN^AG S ESCAPE=X=U D:'ESCAPE HDR
 I $E(IOST)'="C",$Y>(IOSL-17) W !! D HDR
 I $E(IOST)="C" K DIR D RTRN^AG
 I $E(IOST)'="C" D CLOSE^%ZISH(IO)
 Q
 ;
HDRTOP ; Top of Header
 S LINECT=11
 I $E(IOST)'="C",PAGENO>0 W @IOF
 I $E(IOST)="C" W @IOF
 S PAGENO=PAGENO+1
 I $G(EXCL("Age Range"))="" S EXCL("Age Range")="^ALL"
 W !,$$GET1^DIQ(200,DUZ,.01)
 N HOMESIT S HOMESIT=$$GET1^DIQ(4,DUZ(2),.01)
 W ?(80-$L(HOMESIT))/2,HOMESIT
 W ?69,"Page ",PAGENO
 I $D(EXCL("Age Range")) W !,?(53-$L($P(EXCL("Age Range"),"^",2))/2),"Active Patients Age Range: ",$P(EXCL("Age Range"),"^",2)
 I $D(EXCL("Alternate Resource")) W !,?(60-$L($P(EXCL("Alternate Resource"),"^",2))/2),"Alternate Resource: ",$P(EXCL("Alternate Resource"),"^",2)
 I $D(EXCL("Location")) W !,?(70-$L($P($G(EXCL("Location")),"^",2))/2),"Location: ",$P($G(EXCL("Location")),"^",2)
 I $D(EXCL("Visit Date Range")) W !,?18,"Visit Date Range: ",$P($G(EXCL("Visit Date Range")),"^",2)," - ",$P($G(EXCL("Visit Date Range")),"^",4)
 I $D(EXCL("Elig Date Range")) W !,?18,"Elig Date Range: ",$P($G(EXCL("Elig Date Range")),"^",2)," - ",$P($G(EXCL("Elig Date Range")),"^",4)
 I $D(EXCL("Eligibility Status")) W !,?(60-$L($P($G(EXCL("Eligibility Status")),"^",2))/2),"Eligibility Status: ",$P($G(EXCL("Eligibility Status")),"^",2)
 I $D(EXCL("Specific Patient")) W !,?(65-$L($P($G(EXCL("Specific Patient")),"^",2))/2),"Specific Patient: ",$P($G(EXCL("Specific Patient")),"^",2)
 I $D(EXCL("Specific Insurer")) W !,?(65-$L($P($G(EXCL("Specific Insurer")),"^",2))/2),"Specific Insurer: ",$P($G(EXCL("Specific Insurer")),"^",2)
 W !,?23,"Report Date: ",RPTDT
 W !
 Q
 ;
HDR ; Report Header 
 D HDRTOP
 W !,"Name (CHART #)",?51,"HOME PHONE"
 W !,"ADDRESS",?51,"DATE OF BIRTH (AGE)"
 W !,"DATE OF LAST UPDATE",?51,"APPLICATION STATUS/DATE"
 W !,AGLINE("EQ")
 Q
 ;
HDR2 ; Report Header for Specific Patient with Qualifying Alt. Resources
 D HDRTOP
 W !,"Name (CHART #) (AGE)"
 W !,"ADDRESS"
 W !,"DATE OF LAST UPDATE",?40,"Alternate Resource",?62,"Policy #/Coverage"
 W !,AGLINE("EQ")
 Q
 ;
MRHDR ; MEDICARE Report Header
 D HDRTOP
 W !,"Name (CHART #)(AGE)",?47,"MEDICARE(M)"
 W !,"DATE OF LAST UPDATE",?47,"RAILROAD(R)",?69,"COVERAGE"
 W !,AGLINE("EQ")
 Q
 ;
MDHDR ; MEDICAID Report Header
 D HDRTOP
 W !,"Name (CHART #)(AGE)",?35,"MEDICAID (STATE)",?55,"PLAN NAME"
 W !,"DATE OF LAST UPDATE",?55,"COVERAGE TYPE"
 W !,AGLINE("EQ")
 Q
 ;
PRVTHDR ; Private Report Header
 D HDRTOP
 W !,"Name (CHART #)(AGE)",?35,"POLICY NUMBER",?53,"INSURER"
 W !,"DATE OF LAST UPDATE",?53,"COVERAGE TYPE"
 W !,AGLINE("EQ")
 Q
 ;
MCOV ; Get Medicare Coverage
 N IEN,NODE,FROMDT,TODT,COV,COV1,ELGFR,ELGTO
 S IEN=0,COVERAGE=""
 F  S IEN=$O(^AUPNMCR(MCRNUM,11,IEN)) Q:(IEN="B")!(IEN="")  D
 . S NODE=$G(^AUPNMCR(MCRNUM,11,IEN,0))
 . I NODE'="" D
 . . I '$D(EXCL("Elig Date Range")) D
 . . . S FROMDT=$P(NODE,U),TODT=$P(NODE,U,2)
 . . . I TODT="" S TODT=9999999
 . . . I '((TODT<DT)!(DT<FROMDT)) D
 . . . . S COV1=$P(NODE,U,3)
 . . . . I COV1'="" S COV(COV1)=""
 . . I $D(EXCL("Elig Date Range")) D
 . . . S ELGFR=$P($G(EXCL("Elig Date Range")),U),ELGTO=$P($G(EXCL("Elig Date Range")),U,3)
 . . . S FROMDT=$P(NODE,U),TODT=$P(NODE,U,2)
 . . . I TODT="" S TODT=9999999
 . . . I '((TODT<ELGFR)!(ELGTO<FROMDT)) D
 . . . . S COV1=$P(NODE,U,3)
 . . . . I COV1'="" S COV(COV1)=""
 S COV1=""
 F  S COV1=$O(COV(COV1)) Q:COV1=""  S COVERAGE=COVERAGE_"/"_COV1
 S COVERAGE=$E(COVERAGE,2,($L(COVERAGE)))
 Q
 ;
PCOV ; Get Private Insurance Coverage
 N FROMDT,TODT,COV,COV1,ELGFR,ELGTO
 S COVERAGE=""
 S NODE=$G(^AUPNPRVT(PATIEN,11,+PNODE,0))
 I NODE'="" D
 . I '$D(EXCL("Elig Date Range")) D
 . . S FROMDT=$P(NODE,U,6),TODT=$P(NODE,U,7)
 . . I TODT="" S TODT=9999999
 . . I '((TODT<DT)!(DT<FROMDT)) D
 . . . S COV1=$P(NODE,U,3)
 . . . I COV1'="" S COVERAGE=$$GET1^DIQ(9999999.65,COV1,.01)
 . I $D(EXCL("Elig Date Range")) D
 . . S ELGFR=$P($G(EXCL("Elig Date Range")),U),ELGTO=$P($G(EXCL("Elig Date Range")),U,3)
 . . S FROMDT=$P(NODE,U,6),TODT=$P(NODE,U,7)
 . . I TODT="" S TODT=9999999
 . . I '((TODT<ELGFR)!(ELGTO<FROMDT)) D
 . . . S COV1=$P(NODE,U,3)
 . . . I COV1'="" S COVERAGE=$$GET1^DIQ(9999999.65,COV1,.01)
 Q
 ;
DCOV ; Get Medicaid Coverage
 N IEN,NODE,FROMDT,TODT,COV,COV1,ELGFR,ELGTO
 S IEN=0,COVERAGE=""
 F  S IEN=$O(^AUPNMCD(MCDNUM,11,IEN)) Q:(IEN="B")!(IEN="")  D
 . S NODE=$G(^AUPNMCD(MCDNUM,11,IEN,0))
 . I NODE'="" D
 . . I '$D(EXCL("Elig Date Range")) D
 . . . S FROMDT=$P(NODE,U),TODT=$P(NODE,U,2)
 . . . I TODT="" S TODT=9999999
 . . . I '((TODT<DT)!(DT<FROMDT)) D
 . . . . S COV1=$P(NODE,U,3)
 . . . . I COV1'="" S COV(COV1)=""
 . . I $D(EXCL("Elig Date Range")) D
 . . . S ELGFR=$P($G(EXCL("Elig Date Range")),U),ELGTO=$P($G(EXCL("Elig Date Range")),U,3)
 . . . S FROMDT=$P(NODE,U),TODT=$P(NODE,U,2)
 . . . I TODT="" S TODT=9999999
 . . . I '((TODT<ELGFR)!(ELGTO<FROMDT)) D
 . . . . S COV1=$P(NODE,U,3)
 . . . . I COV1'="" S COV(COV1)=""
 S COV1=""
 F  S COV1=$O(COV(COV1)) Q:COV1=""  S COVERAGE=COVERAGE_"/"_COV1
 S COVERAGE=$E(COVERAGE,2,($L(COVERAGE)))
 Q
 ;
RCOV ; Get Railroad Coverage
 N IEN,NODE,FROMDT,TODT,COV,COV1,ELGFR,ELGTO,COVERAGE
 S IEN=0,COVERAGE=""
 F  S IEN=$O(^AUPNRRE(MCRNUM,11,IEN)) Q:(IEN="B")!(IEN="")  D
 . S NODE=$G(^AUPNRRE(MCRNUM,11,IEN,0))
 . I NODE'="" D
 . . I '$D(EXCL("Elig Date Range")) D
 . . . S FROMDT=$P(NODE,U),TODT=$P(NODE,U,2)
 . . . I TODT="" S TODT=9999999
 . . . I '((TODT<DT)!(DT<FROMDT)) D
 . . . . S COV1=$P(NODE,U,3)
 . . . . I COV1'="" S COV(COV1)=""
 . . I $D(EXCL("Elig Date Range")) D
 . . . S ELGFR=$P($G(EXCL("Elig Date Range")),U),ELGTO=$P($G(EXCL("Elig Date Range")),U,3)
 . . . S FROMDT=$P(NODE,U),TODT=$P(NODE,U,2)
 . . . I TODT="" S TODT=9999999
 . . . I '((TODT<ELGFR)!(ELGTO<FROMDT)) D
 . . . . S COV1=$P(NODE,U,3)
 . . . . I COV1'="" S COV(COV1)=""
 S COV1=""
 F  S COV1=$O(COV(COV1)) Q:COV1=""  S COVERAGE=COVERAGE_"/"_COV1
 S COVERAGE=$E(COVERAGE,2,($L(COVERAGE)))
 Q
 ;
HDRCHK ; Check AGINS agains the users selections
 Q:$G(EXCL("Alternate Resource"))=""!($G(EXCL("Alternate Resource"))["NO RESOURCES")
 N ARNO,ARVAL,ARNOTYP
 S ARNO=0
 S ARVAL=$P(EXCL("Alternate Resource"),U,2)
 F  S ARNO=$O(AGINS(ARNO)) Q:ARNO=""  D
 . S ARNOTYP=$P(AGINS(ARNO),U,10)
 . I (ARVAL["MEDICARE")&(ARNOTYP'="M")&(ARNOTYP'="R") K AGINS(ARNO)
 . I (ARVAL["MEDICAID")&(ARNOTYP'="D") K AGINS(ARNO)
 . I (ARVAL["PRIVATE")&(ARNOTYP'="P") K AGINS(ARNO)
 Q
 ;
AGARNO ;  Get Alternate Resource Information
 N ARINS,ARNAME,ARCOV,ARPOLNO,ARNOTYP,PLAN,ARPLNTYP,ARINS,AGMCD,AGST
 S ARINS=$P(AGINS(ARNO),U,2)
 S ARNAME=$$GET1^DIQ(9999999.18,ARINS,.01)
 S ARCOV=$P(AGINS(ARNO),U,4)
 S ARPOLNO=$P(AGINS(ARNO),U,9)
 S ARNOTYP=$P(AGINS(ARNO),U,10)
 I ARNOTYP="D" D
 . S PLAN=$P(AGINS(ARNO),U,12)
 . I PLAN'="" D
 . . S ARPLNTYP=$$GET1^DIQ(9999999.18,PLAN,.21,"I")
 . . I ARPLNTYP="K" D
 . . . S ARNAME=$$GET1^DIQ(9999999.18,PLAN,.01)
 . . . S ARNOTYP="K"
 . . . S AGMCD=$E($P($G(AGINS(ARNO)),U,7),2,99)
 . . . I AGMCD'="" S AGST=$P($G(^AUPNMCD(AGMCD,0)),U,4)
 . . . I $G(AGST)'="" S AGST=$P($G(^DIC(5,AGST,0)),U,2)
 . . . I $G(AGST)'="" S ARNAME=AGST_" "_ARNAME
 W ?40,$E(ARNAME,1,21)
 I ARNOTYP="R"!(ARNOTYP="M") W ?62,ARNOTYP,"-",$E(ARPOLNO,1,18)
 I (ARNOTYP'="R")&(ARNOTYP'="M") W ?62,$E(ARPOLNO,1,18)
 I $G(ARCOV)'="" D
 . W "/"
 . I $X>(80-$L(ARCOV)) W !
 . W ?62,$E(ARCOV,1,18)
 S ARNO=$O(AGINS(ARNO))
 Q
