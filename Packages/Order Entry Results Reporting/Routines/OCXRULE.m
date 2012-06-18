OCXRULE ;SLC/RJS,CLA - OCX PACKAGE RULE TRANSPORT ROUTINE (Delete after Install of OR*3*96) ;JAN 30,2001 at 11:16
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**96**;Dec 17,1997
 ;;  ;;ORDER CHECK EXPERT version 1.01 released OCT 29,1998
 ;
S ;
 ;
 N OCXDIER,QUIT,LINE,TEXT,REMOTE,LOCAL,D0,OPCODE,REF,OCXFLAG S QUIT=0
 N OCXAUTO,OCZSCR
 ;
 D DOT
 I $L($T(VERSION^OCXOCMP)),($$VERSION^OCXOCMP="ORDER CHECK EXPERT version 1.01 released OCT 29,1998"),1
 E  D  Q
 .W !
 .W !,"Rule Transport aborted, version mismatch."
 .W !,"Current Local version: ",$$VERSION^OCXOCMP
 .W !,"   Rule Transport Version: ORDER CHECK EXPERT version 1.01 released OCT 29,1998"
 I '$D(DTIME) W !!,"DTIME not defined !!",!! Q
 W !!,"Order Check Expert System Rule Transporter"
 W !," Created: JAN 30,2001 at 11:16  at  DEVCUR.ISC-SLC.VA.GOV"
 W !," Current Date: ",$$NOW^OCXRU0,"  at  ",$$NETNAME^OCXSEND,!!
 S LASTFILE=0 K ^TMP("OCXRULE",$J)
 S ^TMP("OCXRULE",$J)=($P($H,",",2)+($H*86400)+(1*60*60))_" <- ^TMP ENTRY EXPIRATION DATE FOR ^OCXOPURG"
 S OCXFLAG="O"
 ;
RUN ;
 ;
 W !,"Loading Data " D ^OCXRU001
 ;
 S LINE=0 F  S LINE=$O(^TMP("OCXRULE",$J,LINE)) Q:'LINE   D  Q:QUIT
 .D:'(LINE#50) STATUS^OCXOPOST(LINE,$O(^TMP("OCXRULE",$J," "),-1))
 .S TEXT=$G(^TMP("OCXRULE",$J,LINE)) I $L(TEXT) D  Q:QUIT
 ..S TEXT=$P(TEXT,";",2,999),OPCODE=$P(TEXT,U,1),TEXT=$P(TEXT,U,2,999)
 ..;
 ..I OPCODE="KEY" D DOT S LOCAL="",D0=$$GETFILE^OCXRU0(+$P(TEXT,U,1),$P(TEXT,U,2),.LOCAL) S QUIT=(D0=(-10)) Q
 ..I OPCODE="R" S REF="REMOTE("_$P(TEXT,":",1)_":"_D0_$P(TEXT,":",2,99)_")" Q
 ..I OPCODE="D",$D(REF) S @REF=$P(TEXT,U,1,999) K REF Q
 ..;
 ..I OPCODE="EOR" S QUIT=$$COMPARE^OCXRU1(.LOCAL,.REMOTE) K LOCAL,REMOTE Q
 ..I OPCODE="EOF" K LOCAL,REMOTE Q
 ..I OPCODE="SOF" W !,"  Installing '",TEXT,"' records... " Q
 ..I OPCODE="ROOT" D  Q
 ...N FILE,DATA
 ...S FILE=U_$P(TEXT,U,1),DATA=$P(TEXT,U,2,3)
 ...Q:$D(@FILE)
 ...S @FILE=DATA
 ...W !,"  Restoring file #",(+$P(DATA,U,2))," zero node"
 ..;
 ..W !,"Unknown OpCode: ",OPCODE,"  in: ",TEXT S QUIT=$$PAUSE^OCXRU0 W !
 ;
 K ^TMP("OCXRULE",$J)
 ;
 I $D(^OCXS) D
 .N FILE,DO,PD0,CNT
 .S FILE=0 F  S FILE=$O(^OCXS(FILE)) Q:'FILE  D
 ..S D0=0 F CNT=0:1 S PD0=D0,D0=$O(^OCXS(FILE,D0)) Q:'D0
 ..S $P(^OCXS(FILE,0),U,3,4)=CNT_U_PD0
 ;
 W !!,?5,+$G(OCXDIER)," data error",$S(($G(OCXDIER)=1):"",1:"s")
 W !!,"Transport Finished..."
 ;
 I '$G(ZTSK),($E($G(IOST),1,2)="C-") D  I 1
 .W !!,"These changes will not be implemented until the rules are recompiled."
 .I $$READ("Y"," Do you want to recompile now ?","YES") D ^OCXOCMP
 ;
 E  D
 .N OCXOETIM
 .D BMES^XPDUTL("---Creating Order Check Routines-----------------------------------")
 .D AUTO^OCXOCMP
 ;
 Q
 ;
DOT Q:$G(OCXAUTO)  W:($X>70) ! W " ." Q
 ;
READ(OCXZ0,OCXZA,OCXZB,OCXZL) ;
 N OCXLINE,DIR,DTOUT,DUOUT,DIRUT,DIROUT
 Q:'$L($G(OCXZ0)) U
 S DIR(0)=OCXZ0
 S:$L($G(OCXZA)) DIR("A")=OCXZA
 S:$L($G(OCXZB)) DIR("B")=OCXZB
 F OCXLINE=1:1:($G(OCXZL)-1) W !
 D ^DIR
 I $D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT) Q U
 Q Y
 ;
