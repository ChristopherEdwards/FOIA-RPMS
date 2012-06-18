ADGCRB5 ; IHS/ADC/PDW/ENM - A SHEET lines 8-11 ;  [ 08/25/2004  11:38 AM ]
 ;;5.3;PIMS;**1001,1008,1009**;APR 26, 2002
 ;IHS/ITSC/WAR 8/1/2004 Modified 2nd line to be consistent with version
 ;   number and IHS patch number. Need to copy this routine and rename
 ;  it to match current naming scheme for PIMS. Original 2nd line is 
 ;  listed below:
 ;5.0;ADMISSION/DISCHARGE/TRANSFER;**3**;MAR 25, 1999
 ;
 ;cmi/anch/maw 12/7/2007 patch 1008 added code set versioning VPOV,VPRC
 ;cmi/anch/maw 02/21/2008 PATCH 1009 mods to VPRC requirement 57
 ;
A ;EP -- driver
 D VSIT Q:'DGVSDA  K DGZN D H8,VPOV,H9,VPRC,H10,VINP Q
 ;
H8 ; -- sub heading 8
 W !,DGLIN,!,"26 ICD9   27 Hosp Acq",?24,"28 Established DX",!,DGLIN1 Q
 ;
VSIT ; -- visit DGFN
 ;IHS/DSD/ENM 10/18/99 A Break Cmd was removed from this line
 S DGVSDA=$$VISIT
 I DGDS,'DGVSDA W !!,"*** No visit for day surgery entry yet ***" Q
 W:'DGVSDA !!,"*** no visit created for this admission - incomplete ***"
 Q
 ;
VPOV ; -- diagnosis
 N X,Y,Z S X=0 F  S X=$O(^AUPNVPOV("AD",DGVSDA,X)) Q:'X  D
 . Q:'$D(^AUPNVPOV(X,0))  S Y=^(0) Q:'Y!('$D(^ICD9(+Y,0)))
 . ;W !?3,$P(^ICD9(+Y,0),U),?13,$S($P(Y,U,7)=1:"X",1:"")
 . W !?3,$P($$ICDDX^ICDCODE(+Y,0),U,2),?13,$S($P(Y,U,7)=1:"X",1:"")  ;cmi/anch/maw 12/7/2007 csv patch 1008
 . S:$P(Y,U,9)'="" DGPOVDA=X,DGPOVN0=Y
 . Q:'+$P(Y,U,4)!('$D(^AUTNPOV(+$P(Y,U,4),0)))
 . S Z=$P(^AUTNPOV(+$P(Y,U,4),0),U) I $L(Z)<53 W ?27,Z Q
 . D WRAP(Z,27,79,"")
 Q
 ;
H9 ; -- sub heading 9
 W !,DGLIN1,!,"29 ICD9  30 DX",?18,"31 Op & Selec Procedures"
 W ?55,"32 Post-Op 33   33a Op"
 W !?3,"Code",?58,"Infec   Date  Phy Code",!,DGLIN1 Q
 ;
VPRC ; -- procedures
 N DGX,DGY S DGX=0 F  S DGX=$O(^AUPNVPRC("AD",DGVSDA,DGX)) Q:'DGX  D
 . Q:'$D(^AUPNVPRC(DGX,0))  S DGY=^(0) Q:'DGY!('$D(^ICD0(+DGY,0)))
 . ;W !?3,$P(^ICD0(+DGY,0),U)
 . W !?3,$P($$ICDOP^ICDCODE(+DGY),U,2)
 . W ?11,$P($G(^ICD9($P(DGY,U,5),0)),U) ;cmi/maw 2/21/2008 PATCH 1009 requirement 57
 .; S X=$P(DGY,U,5) I X]"" W ?12,$P($G(^ICD9(X,0)),U) ;dx
 . S X=$P(DGY,U,4) I X]"" D  ;prov narr
 .. Q:'+$P(DGY,U,4)!('$D(^AUTNPOV(+$P(DGY,U,4),0)))
 .. S X=$P(^AUTNPOV(+$P(DGY,U,4),0),U) I $L(X)<38 W ?21,X Q
 .. D WRAP(X,21,58,"")
 . W ?60,$S($P(DGY,U,8)="Y":"YES",1:" NO"),?66,$E($P(DGY,U,6),4,7)
 . Q:'+$P(DGY,U,11)
 . I $P(^DD(9000010.06,.01,0),U,2)["200" D  Q
 .. W ?72,$$VAL^XBDIQ1(200,+$P(DGY,U,11),9999999.039)
 . W ?72,$$VAL^XBDIQ1(6,+$P(DGY,U,11),9999999.039)
 Q
 ;
H10 ; -- sub heading 10
 I DGDS W !,DGLIN1,!,"34 Post-op Comments",! Q
 W !,DGLIN1,!,"34 Discharge Type"
 W ?27,"35 Facility Transferred To",?63,"36 Facility Code",! Q
 ;
VINP ; -- hospitalization
 I DGDS D DSCMTS Q
 N X,X1,Y S X=$O(^AUPNVINP("AD",DGVSDA,0)) Q:'X
 Q:'$D(^AUPNVINP(X,0))  S Y=^(0)
 S X=$P(Y,U,6) I X]"" W ?3,$E($P(^DG(405.1,X,0),U),1,24) ;dsch type
 S X1=$P(Y,U,9) I +X1 D  ; -- facility & code
 . W ?30,$P(@(U_$P(X1,";",2)_+X1_",0)"),U)
 . I $P(X1,";",2)'="DIC(4," Q
 . W ?66,$P($G(^AUTTLOC(+X1,0)),U,10)
 ;
 ; -- sub heading 11
 W !,DGLIN1,!,"37 Disch Service",?24,"38 Disch Srv Code"
 W ?55,"39 # Consults",!
 ;
 S X1=$P(Y,U,5) I +X1 D  ; -- discharge service & code
 . Q:'$D(^DIC(45.7,+X1,0))  W ?3,$P(^(0),U)
 . Q:'$D(^DIC(45.7,X1,9999999))  W ?30,$P(^(9999999),U)
 W ?63,$P(Y,U,8)         ;# consults
 Q
 ;
DSCMTS ; -- day surgery comments
 NEW S0,S2,Y,LINE
 S S0=$G(^ADGDS(DFN,"DS",DGDS,0)),S2=$G(^(2)),LINE=""
 S Y=$P(S0,U,7) I Y]"" D DD^%DT S LINE=LINE_"Sent to Observation @ "_Y
 I $P(S2,U,5)="Y" S LINE=LINE_"  UNESCORTED"
 S LINE=LINE_$$ADMDS
 S LINE=LINE_"  "_$P(S2,U,6) W ?2,LINE
 Q
 ;
ADMDS() ; -- admit after ds
 NEW SDT,X1,X2,X,Y,SAV,LMT,ADT
 ;IHS/ITSC/WAR 6/10/2004 PATCH #1001 fix to address new location of data
 ;S (SDT,X1)=$P(DGN,U),X2=$P(DGOPT("QA1"),U,2) I X1=""!(X2="") Q ""
 S (SDT,X1)=$P(DGN,U),X2=$P(^BDGPAR(1,1),U,7) I X1=""!(X2="") Q ""
 D C^%DTC S Y=$O(^DGPM("APTT1",DFN,SDT)) I Y="" Q ""
 I Y>X Q ""
 S SAV=Y D DD^%DT S ADT=Y
 S X1=SAV,X2=SDT D ^%DTC S LMT=X
 Q "  Admitted on "_ADT_" ("_LMT_" days after surgery)"
 ;
VISIT() ; -- visit ifn
 I DGDS Q $$DSV
 N X,Y,Z S Y=(9999999-$P(+DGN,"."))_"."_$E($P(+DGN,".",2),1,4),Z=0 ;maw mod
 ;N X,Y,Z S Y=(9999999-$P(+DGN,"."))_"."_$P(+DGN,".",2),Z=0 ;maw orig
 S X=0 F  S X=$O(^AUPNVSIT("AA",DFN,Y,X)) Q:'X  D
 . Q:'$D(^AUPNVSIT(X,0))  Q:$P(^(0),U,11)=1  Q:$P(^(0),U,7)'="H"  S Z=X
 Q Z
 ;
DSV() ;EP -- ds visit ifn
 NEW REVDT,V,DATE,Y
 S DATE=$P(^ADGDS(DFN,"DS",DGDS,0),U) I DATE="" Q 0
 S REVDT=9999999-$P(DATE,"."),REVDT=REVDT_"."_$P(DATE,".",2)
 S (Y,V)=0 F  Q:Y=1  S V=$O(^AUPNVSIT("AA",DFN,REVDT,V)) Q:'V  D
 . Q:'$O(^AUPNVPOV("AD",V,0))  ;searhc maw coded visit 4/16/98
 . Q:'$O(^AUPNVPRV("AD",V,0))  ;searhc maw coded visit 4/16/98
 . I $P(^AUPNVSIT(V,0),U,7)="S" S Y=1
 Q $S(Y=1:V,1:0)
 ;
WRAP(X,DIWL,DIWR,DIWF) ; -- print text fields in word-wrap mode
 K ^UTILITY($J,"W") D ^DIWP
 S X=0 F  S X=$O(^UTILITY($J,"W",DIWL,X)) Q:X=""  D
 . W:$X>DIWL ! W ?DIWL,^UTILITY($J,"W",DIWL,X,0)
 K ^UTILITY($J,"W") Q
