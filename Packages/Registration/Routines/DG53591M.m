DG53591M ;ALB/GN - DG*5.3*591 CLEANUP UTILITES ; 6/14/04 1:35pm
 ;;5.3;Registration;**591,1015**;Aug 13, 1993;Build 21
 ;
 ; Misc cleanup utilities
 ;
MAIL ; mail stats
 N ACT,LACT,DFN,BTIME,HTEXT,TEXT,NAMSPC,LIN,MSGNO,IVMBAD,IVMPUR,IVMTOT
 N LSSN,R40831,STS,STSNAM,STAT,MTIEN,STIME,TYPE,TYPNAM
 S MSGNO=0
 S NAMSPC=$$NAMSPC^DG53591
 S IVMTOT=$P($G(^XTMP(NAMSPC,0,0)),U,2)
 S IVMPUR=$P($G(^XTMP(NAMSPC,0,0)),U,3)
 S BTIME=$P($G(^XTMP(NAMSPC,0,0)),U,4)
 S STAT=$P($G(^XTMP(NAMSPC,0,0)),U,5)
 S STIME=$P($G(^XTMP(NAMSPC,0,0)),U,6)
 S IVMBAD=$P($G(^XTMP(NAMSPC,0,0)),U,7)
 ;
 D HDNG(.HTEXT,.MSGNO,.LIN)
 D SUMRY(.LIN)
 D MAILIT(HTEXT)
 ;
 D SNDDET
 Q
 ;
HDNG(HTEXT,MSGNO,LIN) ;build heading lines for mail message
 K ^TMP(NAMSPC,$J,"MSG")
 S LIN=0
 S HTEXT="Cleanup Bad Threshold Tests "_STAT_" on "
 S HTEXT=HTEXT_$$FMTE^XLFDT(STIME)
 D BLDLINE(HTEXT,.LIN)
 D BLDLINE("",.LIN)
 I TESTING S TEXT="** TESTING **" D BLDLINE(TEXT,.LIN)
 I MSGNO S TEXT="Message number: "_MSGNO D BLDLINE(TEXT,.LIN)
 D BLDLINE("",.LIN)
 S MSGNO=MSGNO+1
 Q
 ;
SUMRY(LIN) ;build summary lines for mail message
 S TEXT="     Total Records Processed: "_$J($FN(IVMTOT,","),11)
 D BLDLINE(TEXT,.LIN)
 S TEXT="  Bad Threshold Tests Purged: "_$J($FN(IVMPUR,","),11)
 D BLDLINE(TEXT,.LIN)
 D BLDLINE("",.LIN)
 D BLDLINE("",.LIN)
 D BLDLINE("",.LIN)
 ;
 I IVMPUR D
 . D BLDLINE("Detail changes to follow in subsequent mail messages.",.LIN)
 Q
 ;
SNDDET ;build and send detail messages limit under 2000 lines each
 N DATE,GL,MAXLIN,MORE,NAME,SSN
 S MAXLIN=1995,MORE=0
 D HDNG(.HTEXT,.MSGNO,.LIN)
 D BLDLINE("'*' = Delete, '**' = Delete Linked Test, '>' = Re-transmitted",.LIN)
 ;
 S GL=$NA(^XTMP(NAMSPC,1)),LSSN=""
 F  S GL=$Q(@GL) Q:GL=""  Q:$QS(GL,1)'=NAMSPC  D
 . S ACT=$QS(GL,3) Q:ACT="PNTLNK"
 . S R40831=$G(@GL)
 . S MORE=1                             ;at least 1 more line to send
 . S DFN=$QS(GL,2)
 . S MTIEN=$QS(GL,5)
 . S SSN=$P($G(^DPT(DFN,0)),"^",9),NAME=$P($G(^DPT(DFN,0)),"^")
 . S DATE=$$FMTE^XLFDT($P(R40831,"^"))
 . S STS=$P(R40831,"^",3),STSNAM=""
 . S:STS]"" STSNAM=$P($G(^DG(408.32,STS,0)),"^")
 . S TYPE=$P(R40831,"^",19),TYPNAM=""
 . S:TYPE]"" TYPNAM=$G(^DG(408.33,TYPE,0))
 . S TEXT=NAME_"  ssn: "_SSN
 . D:SSN'=LSSN BLDLINE(TEXT,.LIN)
 . S TEXT="    "
 . S:ACT="BAD" TEXT=" *  "
 . S:ACT="DELLNK" TEXT=" ** "
 . S:ACT="GOOD" TEXT=" >  "
 . S TEXT=TEXT_DATE_$J(TYPNAM,24)_" "_$J(STSNAM,20)_" ien: "_MTIEN
 . D BLDLINE(TEXT,.LIN)
 . S LSSN=SSN,LACT=ACT
 . ;max lines reached, print a msg
 . I LIN>MAXLIN D  S MORE=0
 . . D MAILIT(HTEXT),HDNG(.HTEXT,.MSGNO,.LIN)
 . . D BLDLINE("'*' = Delete, '**' = Delete Linked Test, '>' = Re-transmitted",.LIN)
 ;
 ;print final message if any to print
 D MAILIT(HTEXT):MORE
 Q
 ;
BLDLINE(TEXT,LIN) ;build a single line into TMP message global
 S LIN=LIN+1
 S ^TMP(NAMSPC,$J,"MSG",LIN)=TEXT
 Q
MAILIT(HTEXT) ; send the mail message
 N XMY,XMDUZ,XMSUB,XMTEXT
 S XMY(DUZ)="",XMDUZ=.5
 S XMSUB=HTEXT
 S XMTEXT="^TMP(NAMSPC,$J,""MSG"","
 D ^XMD
 Q
