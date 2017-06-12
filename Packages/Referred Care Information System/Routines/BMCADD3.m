BMCADD3 ;IHS/ITSC/FCJ - ADD SNOMED CODES TO REFERRAL;        [ 09/27/2006  1:31 PM ]
 ;;4.0;REFERRED CARE INFO SYSTEM;**8,9**;JAN 09, 2006;Build 51
 ;
 ; 4.0*8 NEW ROUTINE
 ; Routine will update the RCIS SNOMED field- V Referral file
 ;
START ;
 K ^XTMP("BMCSNO",$J)
 NEW DDS,DIR
 D:'$D(BMCPARM) PARMCHK^BMC
 W @IOF
 ;BMC*4.0*9 TST FOR SNOMED CD IN REF OR VREF
 ;I (BMCMODE="M")!(BMCMODE="E") D  Q:('BMCVREF)!(BMCRSTAT'="A")
 I (BMCMODE="M")!(BMCMODE="E") D  Q:('BMCSCOD)!(BMCRSTAT'="A")
 .;I 'BMCVREF W !!?5,"This field is not editable because original referral does not have",!,"a SNOMED code." H 3 Q  ;BMC*3.1*9
 .I 'BMCSCOD W !!?5,"This field is not editable because original referral does not have",!,"a SNOMED code." H 3 Q   ;BMC*3.1*9
 .I BMCRSTAT'="A" W !!,"This field is not editable because referral status is not ACTIVE." H 3 Q
 D MAIN
 D EXIT
 Q
 ;
MAIN ;
 S BMCQ=0
 I $G(BMCSCOD)>0 D  Q:'+Y
 .W !,"SNOMED Clinical Term selected: ",BMCSCOD,"  ",BMCSTRM,!
 .I (BMCMODE="M")!(BMCMODE="E") W !,"Editing the SNOMED Code will automatically update the Referral.",!
 .S DIR(0)="Y",DIR("A")="Edit the SNOMED Referral Clinical Term",DIR("B")="N"
 .D ^DIR
 .K DIR
 S (BMCSNO,BMCSTRM,BMCSCOD)=""
 ;
SNO ;REQUEST SNOMED
 W !
 S DIR(0)="F",DIR("A")="Enter the Referral Snomed code"
 S:BMCMODE="R" DIR(0)="FO"
 S DIR("?")="Enter a Snomed code or partial name, example 'PEDIA' will list all PEDIACTRIC Referral Snomed codes, enter a '??' for a list of codes"
 S DIR("??")="^D SNOLST^BMCADD3"
 D ^DIR
 I BMCMODE="R",$D(DUOUT) Q
 I BMCMODE="R",$D(DIRUT) S BMCSCOD="@" D VREF^BMCAERR Q
 I $D(DUOUT),$G(BMCRREF) Q
 I $D(DUOUT) W !!,"Snomed Clinical Term required." G SNO
 K ^XTMP("BMCSNO",$J)
 S SNOLST=$NA(^XTMP("BMCSNO",$J)),BMCSNO=X
 S OUT=SNOLST,IN=BMCSNO_"^F^^EHR REFERRAL TYPE^^^P^1^^^"
 S X=$$SEARCH^BSTSAPI(OUT,IN)
 I +X=0 W !,"INVALID RESPONSE" G SNO ; ERROR
 ;DISPLAY
 K DIR
 S (CT,L)=0
 F  S L=$O(^XTMP("BMCSNO",$J,L)) Q:L'?1N.N  S CT=L
 ;
 F L=1:1:CT D  Q:BMCQ  G:$D(DUOUT) SNO
 .;W !?4,L,".",?8,^XTMP("BMCSNO",$J,L,"PRB","DSC"),?20,^XTMP("BMCSNO",$J,L,"PRB","TRM")
 .W !?4,L,".",?8,^XTMP("BMCSNO",$J,L,"CON"),?20,^XTMP("BMCSNO",$J,L,"FSN","TRM")
 .I L=CT D  I 'BMCQ W !!,"Snomed Clinical Term required." G SNO
 ..W !
 ..S DIR(0)="L^1:"_L,DIR("A")="Enter the corresponding number" D ^DIR
 ..I +X>0 S BMCQ=1,BMCSNO=X
 .I L#20=0 D SEL
 ;I BMCSNO>0 S BMCSCOD=^XTMP("BMCSNO",$J,BMCSNO,"PRB","DSC"),BMCSTRM=^XTMP("BMCSNO",$J,BMCSNO,"PRB","TRM")
 I BMCSNO>0 S BMCSCOD=^XTMP("BMCSNO",$J,BMCSNO,"CON"),BMCSTRM=^XTMP("BMCSNO",$J,BMCSNO,"FSN","TRM")
 K DIR
 Q
SEL ;SELECT
 W !
 S DIR(0)="LO^1:"_L
 S DIR("A")="Enter the corresponding number or return to continue"
 D ^DIR
 I $D(DUOUT) W !!,"SNOMED Clinical Term required."
 I X>0 S BMCQ=1,BMCSNO=+X
 W !
 K DIR
 Q
 ;
SNOLST ;LIST THE SNOMED CODES
 NEW DIR
 S SNOLST=$NA(^XTMP("BMCSNO",$J))
 S X=$$SUBLST^BSTSAPI(SNOLST,"EHR REFERRAL TYPE"),L=0
 F  S L=$O(^XTMP("BMCSNO",$J,L)) Q:L'?1N.N  D  Q:$D(DUOUT)
 .W !?5,$P(^XTMP("BMCSNO",$J,L),U),?15,$P(^XTMP("BMCSNO",$J,L),U,3)
 .I L#20=0 W ! S DIR(0)="E",DIR("A")="Press return to continue or '^' to exit list" D ^DIR W @IOF
 Q
 ;
EXIT ;EXIT PROGRAM
 K X,L,^XTMP("BMCSNO",$J)
 S BMCQ=0
 I BMCMODE="R",'$G(BMCSCOD) S BMCSCOD=$P($G(^BMCRTNRF(BMCRREF,13)),U,3) S:BMCSCOD BMCSTRM=$P($$CONC^BSTSAPI(BMCSCOD_"^^^1"),U,2)
 Q
GETSNO ;EP FR BMCMOD AND BMCMODS;GET SNOMED TERM DESCRIPTION
 S BMCSCOD="",BMCSTRM="",BMCVREF=""
 S BMCVREF=$P($G(^BMCREF(BMCRIEN,13)),U,3)
 ;BMC*4.0*9 TEST FOR PCC V REF FIRST THEN REF FILE
 ;Q:'BMCVREF
 I 'BMCVREF D  Q
 .S BMCSCOD=$P($G(^BMCREF(BMCRIEN,22,1,0)),U)
 .S BMCSTRM=$P($$CONC^BSTSAPI(BMCSCOD_"^^^1"),U,2)
 S BMCSCOD=$P(^AUPNVREF(BMCVREF,0),U)
 S BMCSTRM=$P($$CONC^BSTSAPI(BMCSCOD_"^^^1"),U,2)
 ;S BMCSTRM=$P($$DESC^BSTSAPI(BMCSCOD),U,2)
 Q
