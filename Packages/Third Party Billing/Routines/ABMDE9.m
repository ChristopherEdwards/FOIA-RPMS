ABMDE9 ; IHS/ASDST/DMJ - Edit Page 9 - UB-82 CODES ;
 ;;2.6;IHS Third Party Billing;**1,6,9,13**;NOV 12, 2009;Build 213
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM20337 - Added code for BACK if ADA
 ; IHS/SD/SDR - abm*2.6*1 - HEAT6439 - Added page9G for clm attchments
 ; IHS/SD/SDR - abm*2.6*6 - NOHEAT - Can't jump to page 5
 ;IHS/SD/SDR - 2/6*13 - Updated paging for exp mode 35; should go to page 9A, then 9E
 ;
 I $D(ABMP("WORKSHEET")) S ABMP("QUIT")="" Q
OPT ; Page 9A Occurrence Description
 K ABM,ABME
 I $D(ABMP("DDL")),'+$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),51,0)) G OPT2
 D A^ABMDE9X
 D DISP^ABMDE9C W !! S ABM="",ABMP("OPT")="ADEVNJBQ" D SEL^ABMDEOPT I "ADVEN"'[$E(Y) G XIT
 ;G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT),OPT2:$E(Y)="N"  ;abm*2.6*13 exp mode 35
 G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT),OPT5:(($E(Y)="N")&($P(^ABMDEXP(ABMP("EXP"),0),U)["HCFA")),OPT2:$E(Y)="N"  ;abm*2.6*13 exp mode 35
 S ABM("DO")=$S($E(Y)="A":"A1^ABMDEML",$E(Y)="V":"V1^ABMDE9B",$E(Y)="E":"E1^ABMDEMLE",1:"D1^ABMDEMLB") D @ABM("DO")
 G OPT
 ;
OPT2 ;Page 9B Occurrence Span
 K ABM,ABME
 I $D(ABMP("DDL")),'+$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),57,0)) G OPT3
 D B^ABMDE9X
 D DISP2^ABMDE9C W !! S ABM="",ABMP("OPT")="ADEVNJBQ" D SEL^ABMDEOPT I "AVNDEB"'[$E(Y) G XIT
 G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT),OPT:$E(Y)="B",OPT3:$E(Y)="N"
 S ABM("DO")=$S($E(Y)="A":"A1^ABMDEML",$E(Y)="V":"V1^ABMDE9B",$E(Y)="E":"E1^ABMDEMLE",1:"D1^ABMDEMLB") D @ABM("DO")
 G OPT2
 ;
OPT3 ; Page 9C Condition Codes
 K ABM,ABME
 I $D(ABMP("DDL")),'+$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),53,0)) G OPT4
 D C^ABMDE9X
 D DISP3^ABMDE9A W !! S ABM="",ABMP("OPT")="ADNJBQ" D SEL^ABMDEOPT I "ANDB"'[$E(Y) G XIT
 G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT),OPT2:$E(Y)="B",OPT4:$E(Y)="N"
 S ABM("DO")=$S($E(Y)="A":"A1^ABMDEML",1:"D1^ABMDEMLB") D @ABM("DO")
 G OPT3
 ;
OPT4 ; Page 9D Value Codes
 K ABM,ABME
 I $D(ABMP("DDL")),'+$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),55,0)) G OPT5
 D D^ABMDE9X
 D DISP4^ABMDE9A W !! S ABM="",ABMP("OPT")="ADEVNJBQ" D SEL^ABMDEOPT I "ANEVDB"'[$E(Y) G XIT
 G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT),OPT3:$E(Y)="B",OPT5:$E(Y)="N"
 S ABM("DO")=$S($E(Y)="A":"A1^ABMDEML",$E(Y)="V":"V1^ABMDE9B",$E(Y)="E":"E1^ABMDEMLE",1:"D1^ABMDEMLB") D @ABM("DO")
 G OPT4
 ;
OPT5 ; Page 9E Special Program Codes
 K ABM,ABME
 I $D(ABMP("DDL")),'+$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),59,0)) G OPT6
 D E^ABMDE9X
 D DISP5^ABMDE9B W !! S ABM="",ABMP("OPT")="ADNJBQ" D SEL^ABMDEOPT I "ANDB"'[$E(Y) G XIT
 ;G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT),OPT4:$E(Y)="B",OPT6:$E(Y)="N"  ;abm*2.6*13 exp mode 35
 G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT),OPT:(($E(Y)="B")&($P(^ABMDEXP(ABMP("EXP"),0),U)["HCFA")),OPT4:$E(Y)="B",OPT6:$E(Y)="N"  ;abm*2.6*13 exp mode 35
 S ABM("DO")=$S($E(Y)="A":"A1^ABMDEML",1:"D1^ABMDEMLB") D @ABM("DO")
 G OPT5
 ;
OPT6 ; Page 9F Remarks
 K ABM,ABME
 ;I $D(ABMP("DDL")),'+$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),61,0)) S ABMP("QUIT")="" G XIT  ;abm*2.6*1 HEAT6439
 I $D(ABMP("DDL")),'+$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),61,0)) S ABMP("QUIT")="" G OPT7  ;abm*2.6*1 HEAT6439
 D F^ABMDE9X
 ;if unbillable/complete don't allow editing of remarks
 I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),0)),U,4)="U"!($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),0)),U,4)="C") S ABMQUIET=1
 D DISP6^ABMDE9B
 W !!
 S ABM="",ABMP("OPT")="NJBQ"
 I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),0)),U,4)'="U",($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),0)),U,4)'="C") S ABMP("OPT")=ABMP("OPT")_"E"
 D SEL^ABMDEOPT
 ;I "EB"'[$E(Y) S:$D(ABMP("DDL")) ABMP("QUIT")="" G XIT  ;abm*2.6*1 HEAT6439
 ;I "EB"'[$E(Y) S:$D(ABMP("DDL")) ABMP("QUIT")="" G OPT7  ;abm*2.6*1 HEAT6439  ;abm*2.6*6 NOHEAT
 I "ANDB"'[$E(Y) G XIT  ;abm*2.6*6 NOHEAT
 I $D(DTOUT)!$D(DUOUT)!$D(DIROUT) G XIT
 ;G OPT5:$E(Y)="B",OPT7:$E(Y)="N"  ;abm*2.6*6 NOHEAT  ;abm*2.6*9 NOHEAT
 G OPT5:$E(Y)="B"
 I $E(Y)="N",($P($G(^ABMDEXP(ABMP("EXP"),0)),U)'["837") G XIT  ;abm*2.6*6 NOHEAT  ;abm*2.6*9 NOHEAT
 I $E(Y)="N",($P($G(^ABMDEXP(ABMP("EXP"),0)),U)["837") G OPT7  ;abm*2.6*6 NOHEAT  ;abm*2.6*9 NOHEAT
 ;I $E(Y)="B",($P($G(^ABMDEXP(ABMP("EXP"),0)),U)["ADA") S ABMP("SCRN")=9 G XIT  ;abm*2.6*1 HEAT6439
 I $E(Y)="B",($P($G(^ABMDEXP(ABMP("EXP"),0)),U)["ADA") S ABMP("SCRN")=9 G OPT7  ;abm*2.6*1 HEAT6439
 I $E(Y)="B" G OPT5
 D:$E(Y)'="E" D1^ABMDEMLB
 G OPT6
 ;start new code abm*2.6*1 HEAT6439
OPT7 ; Page 9G Claim Attachments
 K ABM,ABME
 I $D(ABMP("DDL")),'+$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),71,0)) S ABMP("QUIT")="" G XIT
 D G^ABMDE9X
 D DISP7^ABMDE9B W !! S ABM="",ABMP("OPT")="ADENJBQ" D SEL^ABMDEOPT I "ANEDB"'[$E(Y) G XIT
 G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)!($E(Y)="N"),OPT6:$E(Y)="B"
 S ABM("DO")=$S($E(Y)="A":"A1^ABMDEML",$E(Y)="E":"E1^ABMDEMLE",1:"D1^ABMDEMLB") D @ABM("DO")
 G OPT7
 ;end new code HEAT6439
 ;
XIT K ABM,ABMZ
 Q
