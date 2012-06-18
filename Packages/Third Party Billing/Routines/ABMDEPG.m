ABMDEPG ; IHS/ASDST/DMJ - EDIT PAGE SELECTION ; 
 ;;2.6;IHS Third Party Billing;**1,6,8**;NOV 12, 2009
 ;
 ;IHS/DSD/MRS - 8/19/1999 - NOIS QBA-0299-130064 Patch 3 #10
 ;    Modified jump variable to remove illegal spaces.A space is used
 ;            as a delimiter for $piece executable
 ;
 ; IHS/SD/SDR - v2.5 p8 - task 6
 ;    Added code for pages 8K and 3A (ambulance billing)
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM20337 - Fixed jumping for page 9F if ADA
 ; IHS/SD/SDR - abm*2.6*1 - HEAT6439 - Added jump to page9G
 ; IHS/SD/SDR - abm*2.6*6 - 5010 - added page3B
 ; IHS/SD/SDR - abm*2.6*6 - NOHEAT - fix for jumping to 8-pages
 ;
SCRN ;EP for Edit Screen Controller
 W !!
 K %P,DIR S DIR(0)="FO^0:10"
 S DIR("A")="Desired SCREEN ("
 S DIR("?",1)=" Choose One of the Following Screens:"
 S DIR("?",2)=" "
 F ABMO("CTR")=1:1 S ABMO("TXT")=$P(ABMP("PAGE"),",",ABMO("CTR")) Q:ABMO("TXT")=""  D
 .S DIR("?",ABMO("CTR"))=$P($T(@ABMO("TXT")),";;",2)
 .S DIR("A")=DIR("A")_$P($T(@ABMO("TXT")),";;",3)_"/"
 S DIR("?",ABMO("CTR"))=" "
 S DIR("?")=" Enter the Number of the Desired Screen."
 S DIR("A")=$P(DIR("A"),"/",1,$L(DIR("A"),"/")-1)_")"
 D ^DIR K DIR
 S ABMO("OPT")=","_ABMP("PAGE")_",",ABMO("X")=","_X_"," G:ABMO("OPT")[ABMO("X")!$D(DTOUT)!$D(DUOUT)!$D(DIROUT) XIT
A3 I X="3A",ABMP("PAGE")["31" S ABMP("LABEL")="OPT" G XIT
B3 I X="3B",ABMP("PAGE")["32" S ABMP("LABEL")="OPT" G XIT  ;abm*2.6*6 5010
A5 I X="5A",ABMP("PAGE")["5" S ABMP("LABEL")="OPT" G XIT
B5 I X="5B",ABMP("PAGE")["5" S ABMP("LABEL")="OPT2" G XIT
A9 I X="9A",ABMP("PAGE")["9" S ABMP("LABEL")="OPT" G XIT
B9 I X="9B",ABMP("PAGE")["9" S ABMP("LABEL")="OPT2" G XIT
C9 I X="9C",ABMP("PAGE")["9" S ABMP("LABEL")="OPT3" G XIT
D9 I X="9D",ABMP("PAGE")["9" S ABMP("LABEL")="OPT4" G XIT
E9 I X="9E",ABMP("PAGE")["9" S ABMP("LABEL")="OPT5" G XIT
F9 I X="9F",ABMP("PAGE")["9" S ABMP("LABEL")="OPT6" G XIT
G9 I X="9G",ABMP("PAGE")["9" S ABMP("LABEL")="OPT7" G XIT  ;abm*2.6*1 HEAT6439
A8 I X="8A",ABMP("PAGE")["8" S ABMP("LABEL")="A" G XIT
B8 I X="8B",ABMP("PAGE")["8" S ABMP("LABEL")="B" G XIT
C8 I X="8C",ABMP("PAGE")["8" S ABMP("LABEL")="C" G XIT
D8 I X="8D",ABMP("PAGE")["8" S ABMP("LABEL")="D" G XIT
E8 I X="8E",ABMP("PAGE")["8" S ABMP("LABEL")="E" G XIT
F8 I X="8F",ABMP("PAGE")["8" S ABMP("LABEL")="F" G XIT
G8 I X="8G",ABMP("PAGE")["8" S ABMP("LABEL")="G" G XIT
H8 I X="8H",ABMP("PAGE")["8" S ABMP("LABEL")="H" G XIT
I8 I X="8I",ABMP("PAGE")["8" S ABMP("LABEL")="I" G XIT
J8 I X="8J",ABMP("PAGE")["8" S ABMP("LABEL")="J" G XIT
K8 I X="8K",ABMP("PAGE")["8" S ABMP("LABEL")="K" G XIT
 W *7 G SCRN
 ;
0 ;; 0 - Claim Summary;;0
1 ;; 1 - Claim Identifiers;;1
2 ;; 2 - Billing Entities;;2
3 ;; 3 - Questions;;3
4 ;; 4 - Provider Data;;4
5 ;; 5 - ICD Diagnosis/Procedures;;5
6 ;; 6 - Dental;;6
7 ;; 7 - Inpatient Data;;7
8 ;; 8 - Worksheet Data (CPT);;8
9 ;; 9 - UB-82 Info (Occurance, Condition, Sp. Prog, Remarks);;9
31 ;; 3A - Ambulance;;3A
 ;; added below line abm*2.6*6 5010
32 ;; 3B - Third Party Liability/Worker's Comp;;3B
 ;
XIT K ABMO,ABMP("OPT")
 I X["8" S (Y,ABMP("SCRN"))="8"  ;abm*2.6*6 NOHEAT
 Q
 ;
JUMP ;EP for Jumping to a Page
 S X=$TR(X," ")
 S ABM("EX")=$S("ABCDEFGHIJK"[$E(X,3):$E(X,3),1:"")_+$E(X,2)
 I $T(@ABM("EX"))]"" D
 .S ABMP("SCRN")=$S(X="J3A"&(ABMP("PAGE")[",31,"):"31",1:$E(X,2))
 .S ABMP("SCRN")=$S(X="J3B"&(ABMP("PAGE")[",32,"):"32",1:$E(X,2))  ;abm*2.6*6 5010
 .S ABM("EX")=$P($T(@ABM("EX")),$E(X,3)_$E(X,2)_" ",2)
 .S X=$E(X,2,3)
 .;I $P($G(^ABMDEXP(ABMP("EXP"),0)),U)["ADA",(X'["F"),(X["9") S ABM("EX")=";;",ABMP("SCRN")=0  ;ABM*2.6*8 NOHEAT
 .I $P($G(^ABMDEXP(ABMP("EXP"),0)),U)["ADA",((X'["F")&(X'["G")),(X["9") S ABM("EX")=";;",ABMP("SCRN")=0  ;ABM*2.6*8 NOHEAT
 .X ABM("EX")
 Q
