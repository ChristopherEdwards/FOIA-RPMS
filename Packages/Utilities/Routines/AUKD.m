AUKD ; KILLS DICs and GLOBALS [ 08/17/88  4:55 PM ]
 ;
NOTES ; This routine deletes FileMan dictionaries, and optionally their
 ; globals, TEMPLATES and AUTHORITIES, by a range of dictionary
 ; numbers, or if called from another routine, by a predefined
 ; set of dictionaries.  The assumptions made by this routine
 ; are that ^UTILITY, ^DIC, and ^DD are not UCI TRANSLATED.
 ; Any other globals may be translated, but the KILLs will
 ; take place in the current UCI only.
 ;
 ; This routine can be called from another routine by setting the
 ; variables AUKDLO, AUKDHI, AUKDDEL, AUKDTMP and then D EN1^AUKD,
 ; or by creating the array ^UTILITY("AUDSET",$J) and then D EN2^AUKD.
 ;
 ; The array ^UTILITY("AUDSET",$J) is subscripted by the file numbers
 ; and has a value of 'v1^v2' where v1 applies to the data global,
 ; and v2 applies to the TEMPLATES attached to the file. The
 ; allowable values of v1 and v2 are 'S' for save, 'D' for delete,
 ; 'A' for ask.
 ;
 ; This routine will execute ^AURESID to delete any residual entries
 ; in ^DD if dictionaries are deleted by a range of numbers.
 ;
BEGIN S DUZ(0)="@",U="^"
 W !!,"This program deletes FileMan dictionaries, and optionally their"
 W !,"globals, TEMPLATES and AUTHORITIES, by a range of dictionary numbers.",!!
 ;
LO R !,"Enter first dictionary number to be deleted: ",AUKDLO G:AUKDLO'=+AUKDLO EOJ
HI W !,"Enter last  dictionary number to be deleted: ",AUKDLO,"//" R AUKDHI S:AUKDHI="" AUKDHI=AUKDLO G:AUKDHI'=+AUKDHI!(AUKDHI<AUKDLO) EOJ
DEL R !!,"Data globals? [D]elete, [A]sk, [S]ave S//",AUKDDEL G:"DAS"'[AUKDDEL DEL
 S:AUKDDEL="" AUKDDEL="S"
 ;
TMP W !!,"TEMPLATES and AUTHORITIES? [D]elete, [A]sk, [S]ave "_AUKDDEL_"//" R AUKDTMP G:"DAS"'[AUKDTMP TMP
 S:AUKDTMP="" AUKDTMP=AUKDDEL
 ;
EN1 ;
 I '$D(AUKDLO)!('$D(AUKDHI)) W !!,"AUKDLO and/or AUKDHI does not exist!" G EOJ
 S DUZ(0)="@",U="^"
 S:'$D(AUKDDEL) AUKDDEL="A"
 S:AUKDDEL="K" AUKDDEL="S" ;***** BACKWARD COMPATABLE *****
 I "DAS"'[AUKDDEL W !!,"Invalid AUKDDEL --->",AUKDDEL,"<---" G EOJ
 S:'$D(AUKDTMP) AUKDTMP="A"
 S:AUKDTMP="K" AUKDTMP="S" ;***** UPWARD COMPATABLE *****
 I "DAS"'[AUKDTMP W !!,"Invalid AUDKTMP --->",AUKDTMP,"<---" G EOJ
 S AUDSLO=AUKDLO,AUDSHI=AUKDHI D EN1^%AUDSET
 S AUKDFILE=(AUKDLO-.00000001) F AUKDL=0:0 S AUKDFILE=$O(^DD(AUKDFILE)) Q:AUKDFILE>AUKDHI!(AUKDFILE'=+AUKDFILE)  I '$D(^UTILITY("AUDSET",$J,AUKDFILE)) D CHECKDD
 I '$D(^UTILITY("AUDSET",$J)) W !!,"No dictionaries were selected." G EOJ
 S AUKDFILE=0 F AUKDL=0:0 S AUKDFILE=$O(^UTILITY("AUDSET",$J,AUKDFILE)) Q:AUKDFILE=""  S ^(AUKDFILE)=AUKDDEL_U_AUKDTMP
 G EN2
 ;
CHECKDD ; CHECK ^DD FOR DANGLING ENTRIES
 Q:$D(^DD(AUKDFILE,0,"UP"))
 W "." S ^UTILITY("AUDSET",$J,AUKDFILE)=""
 Q
 ;
EN2 ;
 I '$D(^UTILITY("AUDSET",$J)) W !!,"^UTILITY(""AUDSET"",$J) is not defined!" G EOJ
 I $O(^UTILITY("AUDSET",$J,""))<2 W !!,"*** Don't mess with files less than 2!! ***",*7 K AUKDLO,AUKDHI G EOJ
 S DUZ(0)="@",U="^"
 S (AUKDFILE,AUKDFLG)=0 F AUKDL=0:0 S AUKDFILE=$O(^UTILITY("AUDSET",$J,AUKDFILE)) Q:AUKDFILE=""  S AUKDX=^(AUKDFILE) D CHKVAL
 I AUKDFLG W !!,"One or more invalid GLOBAL^TEMPLATE disposition values encountered!" G EOJ
 K AUKDDEL,AUKDERR,AUKDFLG,AUKDTMP,AUKDX
 D ^%AUKD2
 S AUKDFLG=0 D CONFIRM
 G:AUKDFLG EOJ
 K AUKDASK,AUKDFLG,AUKDX,AUKDY
 D ^%AUKD3
 W !!,"Resetting ^DIC(0)  <WAIT>" S (AUKDC,AUKDFILE)=0,AUKDLAST="" F AUKDL=0:0 S AUKDFILE=$O(^DIC(AUKDFILE)) Q:AUKDFILE'=+AUKDFILE  S AUKDC=AUKDC+1,AUKDLAST=AUKDFILE
 S $P(^DIC(0),U,3)=AUKDLAST,$P(^DIC(0),U,4)=AUKDC
 G EOJ
 ;
CHKVAL ; CHECK G^T VALUES
 S AUKDERR=0
 I AUKDX'?1U1"^"1U S AUKDERR=1
 ;***** "K" TO "S" ADDED TO FOLLOWING LINE FOR UPWARD COMPABILITY *****
 I 'AUKDERR S AUKDDEL=$P(AUKDX,U,1),AUKDTMP=$P(AUKDX,U,2) S:AUKDDEL="K" AUKDDEL="S" S:AUKDTMP="K" AUKDTMP="S" S:"ADS"'[AUKDDEL AUKDERR=1 S:"ADS"'[AUKDTMP AUKDERR=1
 I AUKDERR S AUKDFLG=1 W !,"Invalid value ",AUKDFILE,"=",AUKDX
 Q
 ;
CONFIRM ; SHOW AND ASK
 I '$D(^UTILITY("AUDSET",$J)) S AUKDFLG=1 Q
 W !!," NUMBER",?14,"NAME",?45,"G^T",?50,"DATA GLOBAL",!
 S (AUKDFILE,AUKDASK)=0 F AUKDL=0:0 S AUKDFILE=$O(^UTILITY("AUDSET",$J,AUKDFILE)) Q:AUKDFILE=""  S AUKDX=^(AUKDFILE) S:$E(AUKDX,1,3)["A" AUKDASK=1 D LIST
 W !!,"The above list of dictionaries will be deleted in UCI ",AUKDUCI,".  Data"
 W !,"globals, TEMPLATES and AUTHORITIES, will be kept, deleted, or asked depending"
 W !,"on flag.  '?' in G position indicates invalid data global."
 W !!,"[S]ave, [D]elete, [A]sk.  Globals to be deleted are also marked"
 W !,"                          by '*' in position 1."
 R !!,"[C]ontinue, [S]top, [M]odify? C//",AUKDX S:AUKDX="^" AUKDX="S"
 I $E(AUKDX)="S" S AUKDFLG=1 Q
 I $E(AUKDX)="M" D MODIFY G CONFIRM
 Q:'AUKDASK
 W ! S AUKDFILE="" F AUKDL=0:0 S AUKDFILE=$O(^UTILITY("AUDSET",$J,AUKDFILE)) Q:AUKDFILE=""  S AUKDX=^(AUKDFILE) D:$E(AUKDX,1,3)["A" ASK
 G CONFIRM
 ;
LIST ; LIST FILE INFO
 W !,$S($P(AUKDX,U,1)="D":"*",1:" "),AUKDFILE,?14,$E($P(^DIC(AUKDFILE,0),U,1),1,30),?45,$E(AUKDX,1,3),?50,$S($P(AUKDX,U,3)="":"<NONE>",1:$P(AUKDX,U,3))
 Q
 ;
MODIFY ;
 R !!,"Which file? ",AUKDFILE I '$D(^UTILITY("AUDSET",$J,AUKDFILE)) W *7 G MODIFY
 R !,"    Delete file from list of files to be deleted (Y/N) N//",AUKDY
 I $E(AUKDY)="Y" K ^UTILITY("AUDSET",$J,AUKDFILE) Q
 S $P(^UTILITY("AUDSET",$J,AUKDFILE),U,2)="A",$P(^(AUKDFILE),U,1)=$S($P(^(AUKDFILE),U,1)="?":"?",1:"A")
 W ! S AUKDX=^(AUKDFILE) D ASK
 Q
 ;
ASK ;
 G:$P(AUKDX,U,1)'="A" ASK2
 W !,"Do you want to delete the data global for ",AUKDFILE,"  ",$P(^DIC(AUKDFILE,0),U,1),"  (Y/N) N//" R AUKDY
 I $E(AUKDY)="Y" S $P(^UTILITY("AUDSET",$J,AUKDFILE),U,1)="D"
 E  S $P(^UTILITY("AUDSET",$J,AUKDFILE),U,1)="S"
ASK2 Q:$P(AUKDX,U,2)'="A"
 W !,"Do you want to delete the TEMPLATES and AUTHORITIES for ",AUKDFILE,"  ",$P(^DIC(AUKDFILE,0),U,1)," (Y/N) N//" R AUKDY
 I $E(AUKDY)="Y" S $P(^UTILITY("AUDSET",$J,AUKDFILE),U,2)="D"
 E  S $P(^UTILITY("AUDSET",$J,AUKDFILE),U,2)="S"
 Q
 ;
EOJ ;
 I $D(AUKDLO),$D(AUKDHI),AUKDLO=+AUKDLO,AUKDHI=+AUKDHI,AUKDHI>AUKDLO S AURLO=AUKDLO,AURHI=AUKDHI D EN1^AURESID
 I $D(^UTILITY("AUKD",$J)) W !,"Restoring saved ^DD nodes.  <WAIT>" S FROM="^UTILITY(""AUKD"",$J,",TO="^DD(" D ^%AUGXFR
 K ^UTILITY("AUDSET",$J),^UTILITY("AUKD",$J)
 K AUKDASK,AUKDC,AUKDDEL,AUKDERR,AUKDFILE,AUKDFLD,AUKDFLG,AUKDG,AUKDHI,AUKDL,AUKDLAST,AUKDLO,AUKDNDIC,AUKDTMP,AUKDUCI,AUKDX,AUKDY
 K FROM,TO
 W !!,"DONE",!!
 Q
