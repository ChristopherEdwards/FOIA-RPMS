LRCAPES1 ;DALOI/FHS-CONT MANUAL PCE CPT WORKLOAD CAPTURE ;5/1/99
 ;;5.2T9;LR;**274,1018**;Nov 17, 2004
 ;Continuation of LRCAPES
EN ;Setup the order of defined NLT codes
 ; ^ICPTCOD supported by DBIA 1995-A
 Q:$G(^TMP("LR",$J,"AK",0,1))=DUZ_U_DT
 N LRI,LRY,LRX,LRX2,LRX3,LRDES,LRCNT
 K ^TMP("LR",$J,"AK")
 S LRCNT=0
 S ^TMP("LR",$J,"AK",0)=$$FMADD^XLFDT(DT,2)_U_DT_U_"ES CPT code list"
 S ^TMP("LR",$J,"AK",0,1)=DUZ_U_DT
 S LRY="^LAM(""AK"")" F  S LRY=$Q(@LRY) Q:$QS(LRY,1)'="AK"  D
 . N LRDES
 . S LRX2=$QS(LRY,2),LRX3=$QS(LRY,3)
 . Q:'$G(LRX2)!('$G(LRX3))
 . S LRI=0 F  S LRI=$O(^LAM(LRX3,4,"AC","CPT",LRI)) Q:LRI<1  D
 . . S LRX=+$G(^LAM(LRX3,4,LRI,0)),LRX=$$CPT^ICPTCOD(LRX,DT)
 . . Q:'$P(LRX,U,7)
 . . K LRDES S LRDES=$$CPTD^ICPTCOD(+LRX,"LRDES")
 . . S LRCNT=LRCNT+1
 . . I $L(LRDES(1)) S ^TMP("LR",$J,"AK",LRX2,LRI,+LRX)=LRX3_U_$E(LRDES(1),1,55)_U_$$GET1^DIQ(64,LRX3_",",.01,"E")_U_$$GET1^DIQ(64,LRX3_",",1,"E") Q
 . . S ^TMP("LR",$J,"AK",LRX2,LRI,+LRX)=LRX3_U_$P(LRX,U,3)_U_$$GET1^DIQ(64,LRX3_",",.01,"E")_U_$$GET1^DIQ(64,LRX3_",",1,"E")
 Q
SET(DFN,LRPRO,LREDT,LRLOC,LRINS,LRCPT,LRAA,LRAD,LRAN) ; Call to check variable
 S (LREND,LROK)=0,LRAA=+$G(LRAA),LRAD=+$G(LRAD),LRAN=+$G(LRAN)
 I '$D(^DPT(DFN,0))#2 S LROK="1^Error Patient" Q LROK
 I $$GET^XUA4A72(LRPRO,DT)<1 S LROK="2^Inactive Provider" Q LROK
 I LREDT'?7N.E S LROK="3^Date Format" Q LROK
 I '$D(^SC(LRLOC,0))#2 S LROK="4^Location Error" Q LROK
 I "CMZ"'[$P($G(^SC(LRLOC,0)),U,3) S LROK="4.2^Not Inpatient Location" Q LROK
 I '$G(LRDSSID) S LROK="4.2^Not Inpatient Location" Q LROK
 I '$D(^DIC(4,LRINS,0))#2 S LROK="5^Institution Error" Q LROK
 I '$O(LRCPT(0)) S LROK="6^No CPT Codes Passed" Q LROK
 D EN^LRCAPES,READ^LRCAPES1
 D DIS I '$O(^TMP("LR",$J,"LRLST",0)) S LROK="-1" Q LROK
 D LOAD^LRCAPES,CLEAN^LRCAPES
 Q LROK
 ;
SEND ;Send data to PCE via DATA2PCE^PXAPI API
 I $$GET1^DIQ(63,+$G(LRDFN),.02,"I")=2,$G(LRDSSID),$O(^TMP("LRPXAPI",$J,"PROCEDURE",0)) D
 . I '$D(LRQUIET) W !,$$CJ^XLFSTR("Sending PCE Workload",IOM)
 . S:'$D(^LRO(68,LRAA,1,LRAD,1,LRAN,"PCE")) ^("PCE")="" S LRPCEN=^("PCE")
 . S LREDT=$S($G(LREDT):LREDT,1:$$NOW^XLFDT)
 . S:'$P(LREDT,".",2) $P(LREDT,".",2)="1201"
 . D SEND^LRCAPPH1
 . I '$D(LRQUIET) W $$CJ^XLFSTR("Visit # "_LRVSITN,80)
 . S ^LRO(68,LRAA,1,LRAD,1,LRAN,"PCE")=$E(LRPCEN_LRVSITN_";",1,80)
 D SETWKL(LRAA,LRAD,LRAN)
 Q
SETWKL(LRAA,LRAD,LRAN) ;Set workload into 68 from CPT coding
 Q:'$P(LRPARAM,U,14)!('$P($G(^LRO(68,+$G(LRAA),0)),U,16))
 I '$G(^LRO(68,+$G(LRAA),1,+$G(LRAD),1,+$G(LRAN),0)) Q
 I '$O(^TMP("LR",$J,"LRLST",0)) K ^TMP("LR",$J,"LRLST") Q
 I '$D(LRQUIET) W !,$$CJ^XLFSTR("Storing LMIP Workload",IOM)
 N LRCNT,LRT,LRP,LRTIME,LRCDEF,LRURGW,LRI,LRADD
 S:'$G(LRURG) LRURG=9
 S (LRADD,LRCNT)=1,LRCDEF="3000",LRURGW=+$G(LRURG)
 S LRT("P")=$O(^LRO(68,LRAA,1,LRAD,1,LRAN,4,0))
 S LRI=0 F  S LRI=$O(^TMP("LR",$J,"LRLST",LRI)) Q:LRI<1  D
 . S LRP=$P(^TMP("LR",$J,"LRLST",LRI),U,2)
 . I 'LRP D  Q:'LRP
 . . S LRP=+$O(^LAM("AB",$P(^TMP("LR",$J,"LRLST",LRI),U)_";ICPT(",0))
 . Q:'$D(^LAM(LRP,0))#2
 . S LRT=+$O(^LAM(LRP,7,"B",0))
 . I 'LRT S LRT=$O(^LRO(68,LRAA,1,LRAD,1,LRAN,4,0))
 . Q:'LRT
 . D SET^LRCAPV1S,STUFI^LRCAPV1
 K ^TMP("LR",$J,"LRLST")
 Q
DIS ;
 N X9
 K X,LRLST,LRCNT,LRI,LRX,LRXY,LRXTST
 K ^TMP("LR",$J,"LRLST")
 I $G(LRANSX) D
 . S X=LRANSX D RANGE^LRWU2
 . X (X9_"S LRX=T1 D EX1^LRCAPES")
 I '$O(^TMP("LR",$J,"LRLST",0)) W !?5,"Nothing selected",! S LRANSY=0 Q
 D DEM
CHK ;User accepts CPT list
 N DIR
 S DIR("A")="Is this correct "
 S DIR(0)="Y",DIR("B")="Yes" D RD
 I $G(LRANSY)'=1 D
 . K ^TMP("LR",$J,"LRLST")
 . S ^TMP("LR",$J,"LRLST")=$$FMADD^XLFDT(DT,2)_U_DT_U_"LAB ES CPT"
 Q
RD ;DIR read
 N Y,X,DTOUT,DUOUT,DIRUT,DIROUT
 S (LRANSY,LRANSX)=0
 S LREND=0 W !
 D ^DIR I $D(DIRUT) S LREND=1 Q
 S LRANSY=$G(Y),LRANSX=$G(X)
 Q
READ ;Select CPT codes for accession
 ; Ask if want to see previously loaded CPT codes
 D LSTCPT^LRCAPES(LRAA,LRAD,LRAN)
 N DIR,LREND
 S DIR(0)="LO",LREND=0
 S DIR("A")="Select CPT codes"
 S DIR("?")="List or range e.g, 1,3,5-7,88000."
 S DIR("??")="^D HLP^LRCAPES"
 D RD
 Q
DEM ;
 N LRIENS,DA
 S LRIENS=LRAN_","_LRAD_","_LRAA_","
 W @IOF
 W !?3,PNM,?35,SSN,?55,"DOB: ",$$FMTE^XLFDT(DOB,1)
 W !?5,LRCDT
 W !?10,LRSPECID,?60,"Loc: ",$G(LRLLOCX)
 I $G(^LRO(68,LRAA,1,LRAD,1,LRAN,"PCE")) W !?15,"PCE ENC # "_^("PCE")
 W !?15,"Specimen: ",$$GET1^DIQ(68.05,"1,"_LRIENS,.01,"E")
 I $L($G(LRSS)),$O(^LR(LRDFN,LRSS,LRIDT,.1,0)) D
 . N LRX
 . W !?5,"Tissue Specimens: "
 . S LRX=0 F  S LRX=$O(^LR(LRDFN,LRSS,LRIDT,.1,LRX)) Q:LRX<1  W !,?15,$P($G(^(LRX,0)),U)
 W !?5,"Test(s); "
 S (LREND,LRX)=0 D
 . N LREND
 . F  S LRX=$O(^LRO(68,LRAA,1,LRAD,1,LRAN,4,LRX)) Q:LRX<1!($G(LREND))  D
 . . I $Y>(IOSL-5) D PG^LRCAPES Q:$G(LREND)
 . . W ?15,$P($G(^LAB(60,+LRX,0)),U)_"/ "
 Q:'$O(^TMP("LR",$J,"LRLST",0))
 W !,$$CJ^XLFSTR("Selected CPT Codes",IOM)
 W ! S (LREND,LRX)=0 D
 . N LREND
 . F  S LRX=+$O(^TMP("LR",$J,"LRLST",LRX)) Q:LRX<1!($G(LREND))  D
 . . I $Y>(IOSL-5) D PG^LRCAPES Q:$G(LREND)
 . . W !?5,"("_LRX_")  "_$P(^TMP("LR",$J,"LRLST",LRX),U)_" "_$E($P(^(LRX),U,3),1,50),!
 . . W:$P(^(LRX),U,5) ?10,$E($P(^(LRX),U,4),1,50)_"  {"_$P(^(LRX),U,5)_"}"
 Q
