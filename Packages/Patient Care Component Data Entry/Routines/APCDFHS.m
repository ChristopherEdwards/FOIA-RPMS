APCDFHS ;IHS/CMI/LAB - LIST MANAGER SNOMED SELECTION FOR FAMILY HISTORY AND API FOR REP FACTORS 
 ;;2.0;IHS PCC SUITE;**10,11,13,16**;MAY 14, 2009;Build 9
 ;; ;
EN ;EP -- main entry point for
 NEW APCDFHSN,APCDHIGH,APCDTCI,APCDTDI,I
 D EN^VALM("APCD FH SNOMED VIEW")
 D CLEAR^VALM1
 D FULL^VALM1
 W:$D(IOF) @IOF
 D EOJ
 Q
EOJ ;
 K ^TMP($J,"APCDFHSNOMED"),APCDFHSN
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)="SELECT FAMILY HISTORY SNOMED TERM"
 Q
 ;
INIT ;EP --
 NEW OUT,IN,C,J,Y,X,I
 K ^TMP($J,"APCDFHSNOMED")
 S OUT=$NA(^TMP($J,"APCDFHSNOMED")),IN="SRCH Family History"
 S X=$$SUBLST^BSTSAPI(OUT,IN)
 S APCDHIGH="",C=0,J=0
 F  S J=$O(^TMP($J,"APCDFHSNOMED",J)) Q:J=""  D
 .S Y=^TMP($J,"APCDFHSNOMED",J)
 .S C=C+1  ;counter
 .S APCDTCI=$P(Y,U,1),APCDTDI=$P(Y,U,2),APCDTPT=$P(Y,U,3)
 .S I=$P($P($$CONC^AUPNSICD(APCDTCI_"^^"_$S($G(APCDDATE):APCDDATE,1:DT)_"^1"),U,5),";")
 .S X=""
 .S X=C_")  ",$E(X,7)=APCDTCI,$E(X,23)=APCDTPT_" ("_I_")"
 .S APCDFHSN(C,0)=X
 .S APCDFHSN("IDX",C,C)=J_U_APCDTCI_U_APCDTDI
 .Q
 S (VALMCNT,APCDHIGH)=C
 Q
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 Q
 ;
EXPND ; -- expand code
 Q
 ;
BACK ;go back to listman
 D TERM^VALM0
 S VALMBCK="R"
 D INIT
 D HDR
 K DIR
 K X,Y,Z,I
 Q
 ;
SELECT ;EP - add an item to the selected list - called from a protocol
 W !
 S DIR(0)="NO^1:"_APCDHIGH,DIR("A")="Which SNOMED Term"
 D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No SNOMED selected." G DISPX
 I $D(DIRUT) W !,"No SNOMED selected." G DISPX
 S APCDCI=$P(APCDFHSN("IDX",Y,Y),U,2)
 S APCDDI=$P(APCDFHSN("IDX",Y,Y),U,3)
 ;W !!,$$CONC^AUPNSICD(APCDCI_"^^"_$S($G(APCDDATE):APCDDATE,1:DT)_"^1") H 10
 S APCDICD=$P($P($$CONC^AUPNSICD(APCDCI_"^^"_$S($G(APCDDATE):APCDDATE,1:DT)_"^1"),U,5),";")
 K ^TMP($J,"APCDFHSNOMED"),APCDFHSN
 Q
 ;
DISPX ;
 D BACK
 Q
GETNARR(APCDDEFV) ;EP - called to get a narrative
 ;because I have absolutely no idea where this call is coming from
 ;I am going to do an exclusive new to preserve the callers
 ;symbol table
 NEW APCDNQV
 S APCDNQV=""
 S APCDDEFV=$G(APCDDEFV)
 D EN^XBNEW("GETNARR1^APCDFHS","APCDNQV;APCDDEFV")
 Q APCDNQV
GETNARR1 ;EP
 ;if user enters "=" use T IF T is not null
 ;do not allow "|"
 ;do not allow "@"
 NEW DA,DIR
 S T=$G(T)
 S DIR(0)="FO^1:160",DIR("A")="PROVIDER NARRATIVE" S:APCDDEFV]"" DIR("B")=APCDDEFV KILL DA D ^DIR KILL DIR
 ;I $D(DIRUT),X="^" W !!," ^ is Not Allowed.  Response is required.",! G GETNARR1
 I $D(DIRUT) Q ""
 I X="" Q ""
 I $L(X)>160!($L(X)<2)!'((X'?1P.E)!(X?1"|".E))!(X'?.ANP)  W "  ????" G GETNARR1
 I X["|" W !!,"You cannot enter a narrative that contains a '|' (vertical bar).",! K X G GETNARR1
 S APCDNQV=X
 Q
