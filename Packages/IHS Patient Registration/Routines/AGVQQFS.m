AGVQQFS ;IHS/ASDS/SDH - SPLIT-OFF PRINT OF FACE SHEETS TO DISK FOR VERIQUEST ; [ 12/10/2001   7:39 AM ]
 ;;6.0;IHS PATIENT REGISTRATION;**15**;OCTOBER 11, 2000
 ;
 ; IHS/ASDS/SDH - AG*6*15 12/10/2001
 ;     DIR acknowledges and thanks Mr. Floyd Dennis, Nashville Area
 ;     Office, for the original routines and components.
 ;     VeriQuest, a product of Envoy, helps identify ineligible 
 ;     claimants prior to claim submittal.
 ;
 Q:'($$VERSION^%ZOSV(1)["MSM")  ; %HOSTCMD() used in SNDFILE.
 ;
 D INIT
 Q:AGVQQUIT
 ;
 D MAIN,^%ZISC,SNDFILE,EXIT
 Q
 ;
INIT ;Primary routine initialization module.
 ;
 NEW AGVQ3
 S AGVQQFS=""  ;Routine activity flag.
 S AGVQIL=6  ;Max length of filename index.
 S AGVQQUIT=1  ;QUIT flag.
 ;
 Q:'$D(^AGFAC(DUZ(2),3))  S AGVQ3=^(3)
 ;
 ; Target directory mandatory.
 S AGVQDIR=$P(AGVQ3,U,2)
 Q:'$L(AGVQDIR)
 ;
 ; VeriQuest target system ID mandatory.
 S AGVQID=$P(AGVQ3,U,6)
 Q:'$L(AGVQID)
 ;
 ; Communications protocol mandatory and not "NONE".
 S AGVQCP=$P(AGVQ3,U,7)
 Q:"N"[AGVQCP
 ;
 ; Number of days to wait between successive checks on a patient.
 S AGVQINTV=$S(+$P(AGVQ3,U,5)>0:$P(AGVQ3,U,5),1:30)
 ;
 ; Don't advance index/open file if Pat not recheck eligible.
 I $D(^AGVQP(DFN,0)) Q:$$FMDIFF^XLFDT(DT,$P(^AGVQP(DFN,0),U,2))<AGVQINTV
 ;
 ; Filename prefix.
 S AGVQPRE=$S($P(AGVQ3,U,4)]"":$P(AGVQ3,U,4),1:"VQ")
 ;
 ; VeriQuest target system logon.
 S AGVQUSR=$P(AGVQ3,U,8)
 ;
 ; VeriQuest target system password.
 S AGVQPWD=$P(AGVQ3,U,9)
 ;
 ;Get incremental file index number for file names.
 LOCK +^AGFAC(DUZ(2),3):5
 E  Q
 S AGVQIDX=$P(^AGFAC(DUZ(2),3),U,3)+1,$P(^(3),U,3)=AGVQIDX
 LOCK -^AGFAC(DUZ(2),3)
 ;
 ;Pad/Format index number for file name, if necessary.
 I $L(AGVQIDX)<AGVQIL NEW P S P=AGVQIL-$L(AGVQIDX),P=$E("000000",1,P),AGVQIDX=P_AGVQIDX
 S AGVQFILE=AGVQPRE_AGVQIDX
 ;
 ;Open HFS device.
 D OPEN^%ZISH("AGVQOUT",AGVQDIR,AGVQFILE,"W")
 Q:POP
 ;
 S AGVQQUIT=0
 Q
 ;
MAIN ;Primary execution module.
 ;
 U IO
 D START^AGFACE
 ; Ensure last line of file is complete.
 W !
 ;
 ;Update record of Patient's last Elig Check.
 ;
 ;If no previous entry, create one.
 I '$D(^AGVQP(DFN,0)) NEW DIC,X S DIC="^AGVQP(",X="`"_DFN,DIC(0)="LN",DIC("DR")=".02////"_DT D ^DIC Q
 ;
 ;Else update the previous entry.
 NEW DA,DIE,DR
 S DIE="^AGVQP(",DA=DFN,DR=".02////"_DT
 D ^DIE
 Q
 ;
SNDFILE ;Transmit file to VeriQuest receiving system.
 NEW AGCMD
 ;
 S AGCMD="sendto"
 I ^%ZOSF("OS")["UNIX" S AGCMD="/usr/bin/"_AGCMD
 I AGVQCP="F",$L(AGVQUSR) S AGCMD=AGCMD_" -l "_AGVQUSR I $L(AGVQPWD) S AGCMD=AGCMD_":"_AGVQPWD
 S AGCMD=AGCMD_" "_AGVQID_" "_AGVQDIR_AGVQFILE
 I $$JOBWAIT^%HOSTCMD(AGCMD),'$D(ZTQUEUED) W !,"""sendto"" of Face Sheet to VeriQuest FAILED." I $$DIR^XBDIR("E","Press RETURN")
 Q
 ;
EXIT ;Clean up before leaving.
 KILL AGVQDIR,AGVQFILE,AGVQIDX,AGVQIL,AGVQINTV,AGVQPRE,AGVQQUIT,AGVQID,AGVQUSR,AGVQPWD,AGVQQFS
 Q
 ;
