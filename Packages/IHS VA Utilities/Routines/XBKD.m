XBKD ; IHS/ADC/GTH - KILLS DICs and GLOBALS ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 ; This routine deletes FileMan dictionaries, and optionally
 ; their globals, TEMPLATES and AUTHORITIES, by a range of
 ; dictionary numbers, or if called from another routine, by
 ; a predefined set of dictionaries.  The assumptions made
 ; by this routine are that ^UTILITY, ^DIC, and ^DD are not
 ; UCI TRANSLATED.  Any other globals may be translated, but
 ; the KILLs will take place in the current UCI only.
 ;
 ; This routine can be called from another routine by setting
 ; the variables XBKDLO, XBKDHI, XBKDDEL, XBKDTMP and then
 ; D EN1^XBKD, or by creating the array ^UTILITY("XBDSET",$J)
 ; and then D EN2^XBKD.
 ;
 ; The array ^UTILITY("XBDSET",$J) is subscripted by the file
 ; numbers and has a value of 'v1^v2' where v1 applies to the
 ; data global, and v2 applies to the TEMPLATES attached to
 ; the file. The allowable values of v1 and v2 are 'S' for
 ; save, 'D' for delete, 'A' for ask.
 ;
 ; This routine will execute ^XBRESID to delete any residual
 ; entries in ^DD if dictionaries are deleted by a range of
 ; numbers.
 ;
BEGIN ;
 D ^XBKVAR
 W !!,"This program deletes FileMan dictionaries, and optionally their"
 W !,"globals, TEMPLATES and AUTHORITIES, by a range of dictionary numbers.",!!
 ;
LO ;
 R !,"Enter first dictionary number to be deleted: ",XBKDLO:$G(DTIME,999)
 G:XBKDLO'=+XBKDLO EOJ
HI ;
 W !,"Enter last  dictionary number to be deleted: ",XBKDLO,"//"
 R XBKDHI:$G(DTIME,999)
 S:XBKDHI="" XBKDHI=XBKDLO
 G:XBKDHI'=+XBKDHI!(XBKDHI<XBKDLO) EOJ
DEL ;
 R !!,"Data globals? [D]elete, [A]sk, [S]ave S//",XBKDDEL:$G(DTIME,999)
 G:"DAS"'[XBKDDEL DEL
 S:XBKDDEL="" XBKDDEL="S"
 ;
TMP ;
 W !!,"TEMPLATES and AUTHORITIES? [D]elete, [A]sk, [S]ave ",XBKDDEL,"//"
 R XBKDTMP:$G(DTIME,999)
 G:"DAS"'[XBKDTMP TMP
 S:XBKDTMP="" XBKDTMP=XBKDDEL
 ;
EN1 ;PEP - Variables XBKDLO, XBKDHI, XBKDDEL, XBKDTMP must be set when entering here.
 I '$D(XBKDLO)!('$D(XBKDHI)) W !!,"XBKDLO and/or XBKDHI does not exist!" G EOJ
 D ^XBKVAR
 S:'$D(XBKDDEL) XBKDDEL="A"
 S:XBKDDEL="K" XBKDDEL="S" ;***** BACKWARD COMPATABLE *****
 I "DAS"'[XBKDDEL W !!,"Invalid XBKDDEL --->",XBKDDEL,"<---" G EOJ
 S:'$D(XBKDTMP) XBKDTMP="A"
 S:XBKDTMP="K" XBKDTMP="S" ;***** UPWARD COMPATABLE *****
 I "DAS"'[XBKDTMP W !!,"Invalid XBKDTMP --->",XBKDTMP,"<---" G EOJ
 S XBDSLO=XBKDLO,XBDSHI=XBKDHI
 D EN1^XBDSET
 S XBKDFILE=(XBKDLO-.00000001)
 F XBKDL=0:0 S XBKDFILE=$O(^DD(XBKDFILE)) Q:XBKDFILE>XBKDHI!(XBKDFILE'=+XBKDFILE)  I '$D(^UTILITY("XBDSET",$J,XBKDFILE)) D CHECKDD
 I '$D(^UTILITY("XBDSET",$J)) W !!,"No dictionaries were selected." G EOJ
 S XBKDFILE=0
 F XBKDL=0:0 S XBKDFILE=$O(^UTILITY("XBDSET",$J,XBKDFILE)) Q:XBKDFILE=""  S ^(XBKDFILE)=XBKDDEL_U_XBKDTMP
 G EN2
 ;
CHECKDD ; CHECK ^DD FOR DANGLING ENTRIES
 Q:$D(^DD(XBKDFILE,0,"UP"))
 W "."
 S ^UTILITY("XBDSET",$J,XBKDFILE)=""
 Q
 ;
EN2 ;PEP - Array ^UTILITY("XBDSET",$J) must exist when entering here.
 I '$D(^UTILITY("XBDSET",$J)) W !!,"^UTILITY(""XBDSET"",$J) is not defined!" G EOJ
 I $O(^UTILITY("XBDSET",$J,""))<2 W !!,"*** Don't mess with files less than 2!! ***",*7 KILL XBKDLO,XBKDHI G EOJ
 D ^XBKVAR
 S (XBKDFILE,XBKDFLG)=0
 F XBKDL=0:0 S XBKDFILE=$O(^UTILITY("XBDSET",$J,XBKDFILE)) Q:XBKDFILE=""  S XBKDX=^(XBKDFILE) D CHKVAL
 I XBKDFLG W !!,"One or more invalid GLOBAL^TEMPLATE disposition values encountered!" G EOJ
 KILL XBKDDEL,XBKDERR,XBKDFLG,XBKDTMP,XBKDX
 D ^XBKD2
 S XBKDFLG=0
 D CONFIRM
 G:XBKDFLG EOJ
 KILL XBKDASK,XBKDFLG,XBKDX,XBKDY
 D ^XBKD3
 W !!,"Resetting ^DIC(0)  <WAIT>"
 S (XBKDC,XBKDFILE)=0,XBKDLAST=""
 F XBKDL=0:0 S XBKDFILE=$O(^DIC(XBKDFILE)) Q:XBKDFILE'=+XBKDFILE  S XBKDC=XBKDC+1,XBKDLAST=XBKDFILE
 S $P(^DIC(0),"^",3)=XBKDLAST,$P(^DIC(0),"^",4)=XBKDC
 G EOJ
 ;
CHKVAL ; CHECK G^T VALUES
 S XBKDERR=0
 I XBKDX'?1U1"^"1U S XBKDERR=1
 ;***** "K" TO "S" ADDED TO FOLLOWING LINE FOR UPWARD COMPABILITY *****
 I 'XBKDERR S XBKDDEL=$P(XBKDX,U,1),XBKDTMP=$P(XBKDX,U,2) S:XBKDDEL="K" XBKDDEL="S" S:XBKDTMP="K" XBKDTMP="S" S:"ADS"'[XBKDDEL XBKDERR=1 S:"ADS"'[XBKDTMP XBKDERR=1
 I XBKDERR S XBKDFLG=1 W !,"Invalid value ",XBKDFILE,"=",XBKDX
 Q
 ;
CONFIRM ; SHOW AND ASK
 I '$D(^UTILITY("XBDSET",$J)) S XBKDFLG=1 Q
 W !!," NUMBER",?14,"NAME",?45,"G^T",?50,"DATA GLOBAL",!
 S (XBKDFILE,XBKDASK)=0
 F XBKDL=0:0 S XBKDFILE=$O(^UTILITY("XBDSET",$J,XBKDFILE)) Q:XBKDFILE=""  S XBKDX=^(XBKDFILE) S:$E(XBKDX,1,3)["A" XBKDASK=1 D LIST
 W !!,"The above list of dictionaries will be deleted in UCI ",XBKDUCI,".  Data"
 W !,"globals, TEMPLATES and AUTHORITIES, will be kept, deleted, or asked depending"
 W !,"on flag.  '?' in G position indicates invalid data global."
 W !!,"[S]ave, [D]elete, [A]sk.  Globals to be deleted are also marked"
 W !,"                          by '*' in position 1."
 I $D(ADIFROM("IHS")) S XBKDX=""
 E  R !!,"[C]ontinue, [S]top, [M]odify? C//",XBKDX:$G(DTIME,999) S:XBKDX="^" XBKDX="S"
 I $E(XBKDX)="S" S XBKDFLG=1 Q
 I $E(XBKDX)="M" D MODIFY G CONFIRM
 Q:'XBKDASK
 W !
 S XBKDFILE=""
 F XBKDL=0:0 S XBKDFILE=$O(^UTILITY("XBDSET",$J,XBKDFILE)) Q:XBKDFILE=""  S XBKDX=^(XBKDFILE) D:$E(XBKDX,1,3)["A" ASK
 G CONFIRM
 ;
LIST ; LIST FILE INFO
 W !,$S($P(XBKDX,U,1)="D":"*",1:" "),XBKDFILE,?14,$E($P(^DIC(XBKDFILE,0),U,1),1,30),?45,$E(XBKDX,1,3),?50,$S($P(XBKDX,U,3)="":"<NONE>",1:$P(XBKDX,U,3))
 Q
 ;
MODIFY ;
 R !!,"Which file? ",XBKDFILE:$G(DTIME,999)
 Q:XBKDFILE'=+XBKDFILE
 I '$D(^UTILITY("XBDSET",$J,XBKDFILE)) W *7 G MODIFY
 R !,"    Delete file from list of files to be deleted (Y/N) N//",XBKDY:$G(DTIME,999)
 I $E(XBKDY)="Y" KILL ^UTILITY("XBDSET",$J,XBKDFILE) Q
 S $P(^UTILITY("XBDSET",$J,XBKDFILE),U,2)="A",$P(^(XBKDFILE),U,1)=$S($P(^(XBKDFILE),U,1)="?":"?",1:"A"),XBKDX=^(XBKDFILE)
 W !
 D ASK
 Q
 ;
ASK ;
 G:$P(XBKDX,U,1)'="A" ASK2
 W !,"Do you want to delete the data global for ",XBKDFILE,"  ",$P(^DIC(XBKDFILE,0),U,1),"  (Y/N) N//"
 R XBKDY:$G(DTIME,999)
 I $E(XBKDY)="Y" S $P(^UTILITY("XBDSET",$J,XBKDFILE),U,1)="D"
 E  S $P(^UTILITY("XBDSET",$J,XBKDFILE),U,1)="S"
ASK2 ;
 Q:$P(XBKDX,U,2)'="A"
 W !,"Do you want to delete the TEMPLATES and AUTHORITIES for ",XBKDFILE,"  ",$P(^DIC(XBKDFILE,0),U,1)," (Y/N) N//"
 R XBKDY:$G(DTIME,999)
 I $E(XBKDY)="Y" S $P(^UTILITY("XBDSET",$J,XBKDFILE),U,2)="D"
 E  S $P(^UTILITY("XBDSET",$J,XBKDFILE),U,2)="S"
 Q
 ;
EOJ ;
 I $D(XBKDLO),$D(XBKDHI),XBKDLO=+XBKDLO,XBKDHI=+XBKDHI,XBKDHI>XBKDLO S XBRLO=XBKDLO,XBRHI=XBKDHI D EN1^XBRESID
 I $D(^UTILITY("XBKD",$J)) W !,"Restoring saved ^DD nodes.  <WAIT>" S FROM="^UTILITY(""XBKD"",$J,",TO="^DD(" D ^XBGXFR
 KILL ^UTILITY("XBDSET",$J),^UTILITY("XBKD",$J)
 KILL %,DA,DIK,Y
 KILL XBKDASK,XBKDC,XBKDDEL,XBKDERR,XBKDFILE,XBKDFLD,XBKDFLG,XBKDG,XBKDHI,XBKDL,XBKDLAST,XBKDLO,XBKDNDIC,XBKDTMP,XBKDUCI,XBKDX,XBKDY
 KILL FROM,TO
 W !!,"DONE",!!
 Q
 ;
