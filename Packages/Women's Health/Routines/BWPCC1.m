BWPCC1 ;IHS/ANMC/MWR - WOMEN'S HEALTH PCC LINK;15-Feb-2003 22:06;PLS
 ;;2.0;WOMEN'S HEALTH;**8**;MAY 16, 1996
 ;;* MICHAEL REMILLARD, DDS * ALASKA NATIVE MEDICAL CENTER *
 ;;  SUBROUTINES FOR BWPCC (CREATE/EDIT A VISIT & V FILE ENTRIES).
 ;;  CHECK ON PASSING A PROCEDURE.  CHECK ON PCC SET UP CORRECTLY.
 ;
 ;
CHECK(BW0,BWDUZ0,BWDUZ2,BWPCDN,BWSITE,BWVFIL) ;EP
 ;---> CHECK TO SEE IF THIS PROCEDURE CAN BE PASSED TO PCC.
 N BWPCCP,DIC,Y
 ;---> QUIT IF THERE IS NO PROCEDURE TYPE, NO SITE WHERE PERFORMED,
 ;---> OR NO V FILE# FOR THIS PROCEDURE.
 Q:'BWPCDN!('BWSITE)!('BWVFIL) 1
 ;
 ;---> QUIT IF THE RESULT OF THE PROCEDURE IS "ERROR/DISREGARD".
 Q:$P(BW0,U,5)=8 2
 ;
 ;---> QUIT IF RPMS SITE FILE IS NOT PRESENT AT THIS SITE.
 Q:'$D(^AUTTSITE(1,0)) 3
 ;
 ;---> QUIT IF PCC IS NOT PRESENT AT THIS SITE (RPMS SITE FILE).
 Q:$P(^AUTTSITE(1,0),U,8)'="Y" 4
 ;
 ;---> QUIT IF NO PCC MASTER CONTROL FILE FOR THIS SITE.
 Q:'$D(^APCCCTRL(BWDUZ2)) 5
 ;
 ;---> QUIT IF WOMEN'S HEALTH IS NOT IN THE PACKAGE FILE.
 D DIC^BWFMAN(9.4,"Q",.Y,"","","","WOMEN'S HEALTH")
 Q:Y<0 6
 ;
 ;---> QUIT IF WOMEN'S HEALTH IS NOT IN PCC MASTER CONTROL FILE OR IF
 ;---> "PASS DATA TO PCC" IS "NO".
 Q:'$D(^APCCCTRL(BWDUZ2,11,+Y,0)) 7
 Q:'$P(^APCCCTRL(BWDUZ2,11,+Y,0),U,2) 8
 ;
 ;---> QUIT IF VISIT TYPE ISN'T DEFINED IN PCC MASTER CONTROL FILE.
 Q:$P(^APCCCTRL(BWDUZ2,0),U,4)']"" 9
 ;
 ;---> QUIT IF PCC DATE/TIME FIELD IS NULL.
 Q:'$P(BW0,U,3) 10
 ;
 ;---> QUIT IF THIS SITE DOES NOT HAVE THE PCC PARAMETER SET FOR
 ;---> THIS PROCEDURE TYPE.
 S BWPCCP=$P($G(^BWSITE(BWDUZ2,BWPCDN)),U,2)
 Q:BWPCCP']"" 11
 ;
 ;---> QUIT IF THIS PROC WAS ON-SITE AND SHOULD NOT BE PASSED.
 Q:BWSITE=BWDUZ2&("fn"[BWPCCP) 12
 ;
 ;---> QUIT IF THIS PROC WAS OFF-SITE AND SHOULD NOT BE PASSED.
 Q:BWSITE'=BWDUZ2&("on"[BWPCCP) 13
 ;
 ;---> QUIT IF THIS PROCEDURE TYPE DOES NOT HAVE A .01 VALUE TO PASS.
 Q:((BWVFIL=9000010.08)&('$P(^BWPN(BWPCDN,0),U,14))) 14
 Q:((BWVFIL=9000010.09)&('$P(^BWPN(BWPCDN,0),U,15))) 15
 Q:((BWVFIL=9000010.13)&('$P(^BWPN(BWPCDN,0),U,16))) 16
 Q:((BWVFIL=9000010.22)&('$P(^BWPN(BWPCDN,0),U,17))) 17
 ;
 ;---> QUIT IF PROBLEMS POINTING TO THE RADIOLOGY PROCEDURES FILE #71.
 I BWVFIL=9000010.22 D  I Y Q Y
 .N Z S Y=0,Z=+$P($P(^DD(BWVFIL,.01,0),U,2),"P",2)
 .I 'Z S Y=19 Q
 .S P=^DIC(Z,0,"GL")_$P(^BWPN(BWPCDN,0),U,17)_",0)"
 .I '$D(@P) S Y=20 Q
 ;
 ;---> QUIT IF USER DOES NOT HAVE PROPER PERMISSIONS.
 I BWDUZ0'["M"&(BWDUZ0'["@") D  Q 18
 .W !?5,"* You do not have the required permission for the PCC Link."
 .W !?7,"Please contact your site manager."  D DIRZ^BWUTL3
 Q 0
 ;
 ;
LINK ;EP
 ;---> DISPLAY PCC-WOMEN'S HEALTH LINK STATUS
 N X D SETVARS^BWUTL5
 S:'$D(IOF) IOF="!!!"
 W @IOF
 W !?21,"WOMEN'S HEALTH-PCC LINK ENVIRONMENT"
 W !?18,"------------------------------------------",!?8
 W "(All parameters must be ""YES"" for PCC link to be operational.)",!
 ;
 D
 .I '$D(^AUTTSITE(1,0)) D  Q
 ..W !!?5,"1) RPMS SITE file is present:" D DOTS W "NO"
 .W !!?5,"1) PCC is running at this site (RPMS SITE file):" D DOTS
 .W $S($P(^AUTTSITE(1,0),U,8)="Y":"YES",1:"NO")
 ;
 W !!?5,"2) PCC MASTER CONTROL file is defined for this site:" D DOTS
 S X=$D(^APCCCTRL(DUZ(2))) W $S(X:"YES",1:"NO")
 ;
 W !!?5,"3) VISIT TYPE is defined in the PCC MASTER CONTROL file:"
 D DOTS
 W $S('X:"NO",$P(^APCCCTRL(DUZ(2),0),U,4)]"":"YES",1:"NO") K X
 ;
 W !!?5,"4) WOMEN'S HEALTH is defined in the PACKAGE file:" D DOTS
 D DIC^BWFMAN(9.4,"Q",.Y,"","","","WOMEN'S HEALTH")
 W $S(Y:"YES",1:"NO")
 ;
 W !!?5,"5) WOMEN'S HEALTH entry exists in the PCC MASTER CONTROL file:"
 D DOTS
 W $S($D(^APCCCTRL(DUZ(2),11,+Y,0)):"YES",1:"NO")
 ;
 I $D(^APCCCTRL(DUZ(2),11,+Y,0)) D
 .W !!?5,"6) WOMEN'S HEALTH entry in PCC MASTER CONTROL file has"
 .W !?8,"""PASS DATA TO PCC"" set to:" D DOTS
 .W $S('Y:"NO",$P(^APCCCTRL(DUZ(2),11,+Y,0),U,2):"YES",1:"NO")
 ;
 D DIRZ^BWUTL3
 Q
 ;
DOTS ;
 F I=1:1:(69-$X) W "."
 Q
 ;
 ;
DISPLAY1 ;EP
 ;---> DISPLAY VISIT IEN.
 I $D(APCDALVR("APCDVSIT")) D
 .W !,"APCDVSIT DEFINED: ",APCDALVR("APCDVSIT")
 I $D(APCDALVR("APCDVSIT","NEW")) D
 .W !,"NEW VISIT: ",APCDALVR("APCDVSIT","NEW")
 ;---> SHOW FLAG IF VISIT WAS NOT CREATED.
 I $D(APCDALVR("APCDAFLG")) D
 .W !,"APCDAFLG DEFINED, FAILED: ",APCDALVR("APCDAFLG")
 D DIRZ^BWUTL3
 Q
 ;
DISPLAY2 ;EP
 ;---> DISPLAY V FILE IEN.
 I $D(APCDALVR("APCDADFN")) D
 .W !,"APCDADFN DEFINED: ",APCDALVR("APCDADFN")
 ;---> SHOW FLAG IF VISIT WAS NOT CREATED.
 I $D(APCDALVR("APCDAFLG")) D
 .W !,"APCDAFLG DEFINED, FAILED: ",APCDALVR("APCDAFLG")
 D DIRZ^BWUTL3
 Q
 ;
DISPLAY3 ;EP
 ;---> DISPLAY VISIT AND V FILE GLOBAL NODES AND FILE#70 IENS.
 W !!,"VISIT FILE: "
 S N=APCDALVR("APCDVSIT")-3 S:N<0 N=0
 F  S N=$O(^AUPNVSIT(N)) Q:'N  D
 .W !,N,": ",^AUPNVSIT(N,0)
 ;
 W !!,"V FILE: "
 S BWVGBL=^DIC(BWVFIL,0,"GL")
 S N=APCDALVR("APCDADFN")-3,M=N+10 S:N<0 N=0
 F  S N=$O(@(BWVGBL_"N)")) Q:'N  Q:N>M  D
 .W !,N,": ",@(BWVGBL_"N,0)")
 D DIRZ^BWUTL3
 Q