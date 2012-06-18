ACDVSRV1 ;IHS/ADC/EDE/KML - READ SERVER MESSAGE BACK INTO GLOBAL;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;****************************************************************
 ;This routine is called by the server option and will take ^ACDVTMP
 ;out of the mail message and re-create it on the area or hq machine.
 ;ACDHEAD(3)=$P(^AUTTLOC($P(^AUTTSITE(1,0),U),0),U,10) and is
 ;used when ordering through ^ACDVTMP and allows all the servers to
 ;run at the same time, with each only ordering through its own data.
 ;*************************************************************
 ;
EN ;EP
 ;//[ACD SERVER]
 K ACDQUIT
 X XMREC Q:XMER'=0  S ACDHEAD(4)=$P(XMRG,U,1,2),ACDHEAD(2)=$P(XMRG,U,3),ACDHEAD(3)=$P(XMRG,U,4) I $P(XMRG,U,5)'="$P($G(ACDZIP),U)" S ACDGOOSE=1 D XMD Q
 F  Q:$D(ACDQUIT)  D
 .X XMREC S:XMER'=0 ACDQUIT=1 Q:$D(ACDQUIT)  S ACDGLO=XMRG
 .X XMREC S:XMER'=0 ACDQUIT=1 Q:$D(ACDQUIT)  S @ACDGLO=XMRG
 ;
 ;Build data files now that ^ACDVTMP has been imported
 D ^ACDVSRV2,XMD,K Q
 ;
XMD ;Audit trail
 S ACDFNA="SERVER (MESSAGE "_$S($D(XMZ):XMZ,1:"NF")_")"
 D EN^ACDVXMD(ACDFNA,.ACDHEAD)
K ;
 S XMSER="S.ACD SERVER"
 D REMSBMSG^XMA1C
 K ACDHEAD,ACDGOOSE,ACDGLO,ACDFNA ;   3/31/95 EDE
 Q
