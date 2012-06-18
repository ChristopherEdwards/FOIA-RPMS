ACHSVAR ; IHS/ITSC/TPF/PMF - VARIABLES, OPTIONS ;     [ 06/15/2001  8:10 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**18**;JUN 11, 2001
 ;ACHS*3.1*18 7/16/2010;IHS/OIT/ABK;Change every occurrance of Deferred to Unmet Need
 ;
 ;this routine sets up certain basic vars for use in chs
 ;expected input:    DUZ array
 ;                   U
 ;                   DT
 ;
 ;a partial list of the output:
 ;ACHSACFY       the Active Current FY
 ;ACHSCFY        the Current FY
 ;ACHSERR        error flag default to off
 ;ACHSFC
 ;ACHSFYDT       the start of the nbext FY, i.e, 3001001
 ;ACHSFYWK       the workbook
 ;
 ;
 I $D(^ACHSUSE("EOBR")) D  Q:$D(XQUIT)
 . S XQUIT=""
 . W @IOF,!!!,*7,*7
 . W $$C^XBFUNC("The global flag indicates EOBRs Are Now Being Processed"),!
 . I '$D(^XUSEC("ACHSZMGR",DUZ)) W $$C^XBFUNC("Please Try Later"),!!!!!! D RTRN^ACHS Q
 . S Y=$$DIR^XBDIR("Y","Do you want to delete the global flag and continue","N","","","^W !!,""You must enter 'Y' to delete the global flag, and provide access.""",1)
 . Q:$D(DIRUT)!('Y)
 . I Y D
 .. S XQUIT="" F  S XQUIT=$O(^ACHSUSE(XQUIT)) Q:XQUIT=""  K ^ACHSUSE(XQUIT)
 .. K XQUIT
 .. Q
 . Q
 ;
 ;ACHS*3.1*16 IHS.OIT.FCJ MODIFIED NXT LINE BECAUSE OF LENGHT
 ;{ABK,7/16/10}I '$D(^ACHSF(DUZ(2),2)) D NOTSET("Node 2 of the 'CHS FACILITY' file is missing for this facility '$D(^ACHSF("_DUZ(2)_",2)). Editing this file via Fileman or use the 'Parameters' option in the CHS Denial/Deferred Services menu.")
 I '$D(^ACHSF(DUZ(2),2)) D NOTSET("Node 2 of the 'CHS FACILITY' file is missing for this facility '$D(^ACHSF("_DUZ(2)_",2)). Editing this file via Fileman or use the 'Parameters' option in the CHS Denial/Unmet Need menu.")
 ;
 ;5/29/01   pmf  add check for ISAO
 I $G(ACHSISAO) I $P($G(^ACHSAOP(DUZ(2),2)),U)="" D NOTSET("The 'EOBR IMPORT/SPLITOUT EXPORT' field of the 'CHS AREA OFFICE PARAMETERS' file must contain a directory pathname $P(^ACHSAOP("_DUZ(2)_",2),U)=NULL")
 ;
 D OPTS
 I '$D(ACHSY) G END
 K ACHSY,ACHSCHSS
 D ^ACHSUF
 I $G(ACHSERR)=1 S XQUIT=1 G END
 D VIDEO^ACHS
 I $P($G(^AUTTLOC(DUZ(2),0)),U,4)'="" D
 .I $E(($P($G(^AUTTAREA(($P(^AUTTLOC(DUZ(2),0),U,4)),0)),U,4)))'="J" D CANZ
 Q
 ;
END ;
 W *7
 I $$DIR^XBDIR("E","Press RETURN...","","","","",2)
 S ACHSXQT=1
 Q
 ;
OPTS ;
 ;
 S ACHSY=""
 F ACHS=2:1 Q:'$D(^DD(9002080,"GL",2,ACHS))  S ACHSY=$P($G(^ACHSF(DUZ(2),2)),U,ACHS)_ACHSY
 I ACHSY]"" Q
 D NOTSET("CHS Facility parameters not set")
 Q
 ;
NOTSET(ACHSMSG) ;
 D VIDEO^ACHS
 W !!,*7,"The " W $G(IORVON) W "DENIAL" W $G(IORVOFF) W " parameters for this site have "
 W $G(IORVON) W "not been properly set." W $G(IORVOFF)
 W !!,$$C^ACHS(ACHSMSG)
 W !!,"Print this screen to a printer."
 W *7,!!,$G(IOBON),$G(IORVON),"Contact your site manager immediately!",$G(IOBOFF),$G(IORVOFF)
 W !!,"Press RETURN..."
 D READ^ACHSFU S ACHS("NOTSET")="",ACHSXQT=1
 Q
 ;
CANZ ;
 S ACHSXARA=$P($G(^AUTTLOC(DUZ(2),0)),U,4)
 I ACHSXARA'="" S ACHSXPFX=$P($G(^AUTTAREA(ACHSXARA,0)),U,4),XCODE=$E(ACHSXPFX,1)
 E  S (ACHSXPFX,XCODE)=""
 G CAN2:XCODE="J"
 W *7,!!,"CAN NUMBER PREFIXES ARE BEING PROCESSED.........."
 D WAIT^DICD
 F R=0:0 S R=$O(^ACHS(2,R)) W "." Q:'R  I $P($G(^ACHS(2,R,0)),U,3)=DUZ(2) D
 . S ACHSXX=$P($G(^ACHS(2,R,0)),U),ACHSX3=$E(ACHSXX,1,3),ACHSX4=$E(ACHSXX,4,7) K ^ACHS(2,"B",ACHSXX,R) S ACHSX3="J"_$E(ACHSX3,2,3)
 . S $P(^ACHS(2,R,0),U)=ACHSX3_ACHSX4,^ACHS(2,"B",ACHSX3_ACHSX4,R)=""
 .Q
 S $P(^AUTTAREA(ACHSXARA,0),U,4)="J"_$E(ACHSXPFX,2,3)
CAN2 ;
 K R,X,ACHSXARA,ACHSXPFX,XCODE,ACHSXX,ACHSX3,ACHSX4
 Q
 ;
MGR ;EP - If options not set, user has mgr key, enter the options.
 I '$D(^XUSEC("ACHSZMGR",DUZ)) Q
 S ACHSSITE=$P($G(^DIC(4,DUZ(2),0)),U)
 D OPTIONS
 K ACHSSITE
 I $D(^ACHSF(DUZ(2),2)),$L(^(2)) S ACHSY=""
 Q
 ;
OPTIONS ;
 N DA,DIC,DIE,DR,DLAYGO
 W !!!,"Edit the CHS facility options for '",ACHSSITE,"'.",!!,"1 question mark (""?"") will get you help.",!!,"2 question marks (""??"") usually gets you more help.",!!
 W "For printed help, print out chapter 1 of the Tech Manual (D ^ACHSTM).",!
 ;ACHS*3.1*16 11.12.2009 IHS.OIT.FCJ ADDED DUNS TO NXT LINE
 S DIE="^ACHSF(",DR="11.03;11.05:14.08;14.11;14.12;14.13;14.14;14.14:14.18;14.2;14.22;14.24:14.27;14.31",DA=DUZ(2)
 D ^DIE
 Q:$P($G(^ACHSF(DUZ(2),0)),U,8)'="Y"  ; Quit if not a 638 facility.
 S DR="11.04;14.09"
 D ^DIE
 I $P($G(^ACHSF(DUZ(2),0)),U,6),$P($G(^(0)),U,7) Q
 W *7,!!,"THE NEXT 2 PARAMETERS DETERMINE WHEN YOUR FISCAL YEAR STARTS.",!!,"IF YOU HAVE ANY DOUBTS ABOUT HOW TO ANSWER THE QUESTIONS, PLEASE CALL",!!,"DSD AT 505-837-4189 AND ASK FOR THE CHS DEVELOPER.",!
 S DR="11.01;11.02"
 D ^DIE
 Q
 ;
FY(%) ;EP - Given a FY, return beg/end dates.
 N X,Y
 S X=$P($G(^ACHSF(DUZ(2),0)),U,6),Y=+$P($G(^(0)),U,7)
 S %=$S(%>50:2,1:3)_%-Y
 S X=%_X
 S %=$E(X,1,3)
 S Y=%+$S($E(X,4,7)="0101":0,1:1) ; Year
 S %=$E(X,4,5) I $E(X,6,7)="01" S %=%-1 I '% S %=12
 S %="0"_%,%=$E(%,$L(%)-1,$L(%)) ; Month
 S Y=$E(Y,1,3)_%_$P("31^28^31^30^31^30^31^31^30^31^30^31",U,%) ; Day
 I $E(Y,4,5)="02",'((1700+$E(Y,1,3))#4) S Y=$E(Y,1,5)_"29"
 I $E(X,4,5)=$E(Y,4,5) S %=$E(X,6,7),%=%-1,%="0"_%,%=$E(%,$L(%)-1,$L(%)),Y=$E(Y,1,5)_%
 Q X_U_Y
 ;
