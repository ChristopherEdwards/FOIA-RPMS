PSUCP2 ;BIR/TJH - CHECK COMPLETION OF MONTHLY PBM REPORT ;25 AUG 1998
 ;;3.0;PHARMACY BENEFITS MANAGEMENT;**5,10,19**;Oct 15, 1998
 ;
 ;DBIAs
 ; Reference to File #4    supported by DBIA 10090
 ; Reference to File #4.3  supported by DBIA 10091
 ; Reference to File #40.8 supported by DBIA 2438
 ; Reference to File #59.7 supported by DBIA 2854
MANUAL ; Entry point if tasked by PSU PBM MANUAL option
 S PSUWAY="Manual"
AUTO ; Entry point if tasked by PSU PBM AUTO option
 I '$D(PSUWAY) S PSUWAY="Automatic"
 D NOW^%DTC
 S PSUNOW=% K %,%H,%I,X
 S PSULRD=$$VALI^PSUTL(59.7,1,90) ; last run date
 D
 .I PSULRD="" S PSUOK=0 Q  ; it's 24 hours later and finish time is not set, may be a problem.
 .S X1=PSUNOW,X2=PSULRD D ^%DTC
 .I X>6 S PSUOK=0 Q  ; the last run date must be left over from a previous run, it's a problem.
 .S PSUOK=1
 G:PSUOK EXIT ; no message sent if OK.
 D XMY^PSUTL1
 M XMY=PSUXMYS1
 I $G(PSUMASF) M XMY=PSUXMYH
 S X=$$VALI^PSUTL(4.3,1,217),PSUDIV=+$$VAL^PSUTL(4,X,99)
 S X=PSUDIV,DIC=40.8,DIC(0)="XM" D ^DIC
 S X=+Y S PSUDIVNM=$$VAL^PSUTL(40.8,X,.01)
 S XMSUB="PBM "_PSUWAY_" Statistics Job "_PSUDIV_" "_PSUDIVNM
 S X(1)="The PBM "_PSUWAY_" Statistics background job did not run to completion."
 S X(2)="Please correct the problem and retransmit the data to the National PBM"
 S X(3)="section at Hines."
 S XMTEXT="X("
 S XMCHAN=1
 D ^XMD
EXIT ; normal exit point from PSUCP2
 K PSUWAY,PSUNOW,PSULRD,PSUOK,PSUDIV,PSUDIVNM
 Q
