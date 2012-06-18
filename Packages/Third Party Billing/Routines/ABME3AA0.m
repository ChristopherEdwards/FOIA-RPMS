ABME3AA0 ; IHS/ASDST/DMJ - HCFA-1500 NSF 3.01 EMC RECORD AA0 (Submitter Data) ;    
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/ASDS/DMJ - 09/06/01 - V2.4 Patch 7 - NOIS HQW-0701-100066
 ;      This is a new routine related to Medicare Part B.
 ;
 ; IHS/ASDS/DMJ - 01/03/02 - V2.4 Patch 10 - NOIS NDA-1201-180141
 ;     Modified code to calculate submission number differently as
 ;     Medicare saves the numbers for up to a year.
 ;
 ; *********************************************************************
 ;
START ;START HERE
 K ABMREC(1),ABMR(1)
 S ABME("RTYPE")=1
 D LOOP
 S ABMRT(99,"RTOT")=1
 K ABME,ABM
 Q
LOOP ;LOOP HERE
 F I=10:10:330 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),1,I)) D @(^(I))
 .I '$G(ABMP("NOFMT")) S ABMREC(1)=$G(ABMREC(1))_ABMR(1,I)
 Q
10 ;1-3 Record type
 S ABMR(1,10)="AA0"
 Q
20 ;4-19 Submitter ID
 S ABMR(1,20)=$P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),0)),"^",2)
 S:ABMR(1,20)="" ABMR(1,20)=$P($G(^ABMNINS(DUZ(2),ABMP("INS"),0)),"^",2)
 S:ABMR(1,20)="" ABMR(1,20)=$P($G(^AUTTLOC(DUZ(2),0)),"^",18)
 S ABMR(1,20)=$TR(ABMR(1,20),"-")
 S ABMR(1,20)=$$FMT^ABMERUTL(ABMR(1,20),16)
 S ABMP("SUBID")=ABMR(1,20)
 Q
30 ;20-28 Reserved 
 S ABMR(1,30)=""
 S ABMR(1,30)=$$FMT^ABMERUTL(ABMR(1,30),9)
 Q
40 ;29-34 Submission Type
 D SOP^ABMERUTL
 S ABMR(1,40)=ABMP("SOP")
 S ABMR(1,40)=$$FMT^ABMERUTL(ABMR(1,40),6)
 Q
50 ;35-40 Submission #
 S ABMR(1,50)=$P($G(^ABMDTXST(DUZ(2),+$G(ABMP("XMIT")),1)),"^",6)
 I ABMR(1,50)="" D
 .S ABMR(1,50)="0000"_$G(ABMP("XMIT"))
 .S ABMR(1,50)=$E(ABMR(1,50),$L(ABMR(1,50))-2,$L(ABMR(1,50)))
 .S ABMR(1,50)=$E(DUZ(2),$L(DUZ(2))-1,$L(DUZ(2)))_ABMR(1,50)
 .S ABMR(1,50)=ABMR(1,50)+100000
 S ABMR(1,50)=$$FMT^ABMERUTL(ABMR(1,50),6)
 Q
60 ;41-73 Submitter Name
 D DIQ2 S ABMR(1,60)=ABM(9999999.06,DUZ(2),.01,"E")
 S ABMR(1,60)=$$FMT^ABMERUTL(ABMR(1,60),33)
 Q
70 ;74-103 Submitter Address-1
 D DIQ2 S ABMR(1,70)=ABM(9999999.06,DUZ(2),.14,"E")
 S ABMR(1,70)=$$FMT^ABMERUTL(ABMR(1,70),30)
 Q
80 ;104-133 Submitter Address-2
 S ABMR(1,80)=""
 S ABMR(1,80)=$$FMT^ABMERUTL(ABMR(1,80),30)
 Q
90 ;134-153 Submitter City
 D DIQ2 S ABMR(1,90)=ABM(9999999.06,DUZ(2),.15,"E")
 S ABMR(1,90)=$$FMT^ABMERUTL(ABMR(1,90),20)
 Q
100 ;154-155 Submitter State
 D DIQ2 S ABMR(1,100)=ABM(9999999.06,DUZ(2),.16,"I")
 S ABMR(1,100)=$P($G(^DIC(5,+ABMR(1,100),0)),"^",2)
 S ABMR(1,100)=$$FMT^ABMERUTL(ABMR(1,100),2)
 Q
110 ;156-164 Submitter Zip
 D DIQ2 S ABMR(1,110)=ABM(9999999.06,DUZ(2),.17,"E")
 S ABMR(1,110)=$$FMT^ABMERUTL(ABMR(1,110),"9S")
 Q
120 ;165-169 Submitter Region
 S ABMR(1,120)=""
 S ABMR(1,120)=$$FMT^ABMERUTL(ABMR(1,120),5)
 Q
130 ;170-202 Submitter Contact
 S ABMR(1,130)="BUSINESS OFFICE MANAGER"
 S ABMR(1,130)=$$FMT^ABMERUTL(ABMR(1,130),33)
 Q
140 ;203-212 Submitter Telephone Number
 D DIQ2 S ABMR(1,140)=ABM(9999999.06,DUZ(2),.13,"E")
 S ABMR(1,140)=$TR(ABMR(1,140),"() -")
 S ABMR(1,140)=$$FMT^ABMERUTL(ABMR(1,140),10)
 Q
150 ;213-220 Creation Date
 S ABMR(1,150)=$$Y2KD2^ABMDUTL(DT)
 Q
160 ;221-226 Submission Time
 S ABMR(1,160)=""
 S ABMR(1,160)=$$FMT^ABMERUTL(ABMR(1,160),6)
 Q
170 ;227-242 Receiver ID
 S ABMR(1,170)=$$RCID^ABMERUTL(ABMP("INS"))
 S ABMR(1,170)=$$FMT^ABMERUTL(ABMR(1,170),16)
 Q
180 ;243-243 Receiver Type
 S ABMR(1,180)="C"
 Q
190 ;244-248 Version Code-National
 S ABMR(1,190)="00301"
 Q
200 ;249-253 Version Code-Local
 S ABMR(1,200)="00301"
 Q
210 ;254-257 Test/Prod Indicator
 S ABMR(1,210)=$P($G(^ABMNINS(DUZ(2),ABMP("INS"),0)),"^",4)
 S ABMR(1,210)=$S(ABMR(1,210)["T":"TEST",1:"PROD")
 S ABMR(1,210)=$$FMT^ABMERUTL(ABMR(1,210),4)
 Q
220 ;258-265 Password
 S ABMR(1,220)=$P($G(^ABMNINS(DUZ(2),ABMP("INS"),0)),"^",3)
 S ABMR(1,220)=$$FMT^ABMERUTL(ABMR(1,220),8)
 Q
230 ;266-266 Retransmission Status
 S ABMR(1,230)=" "
 Q
240 ;267-282 Original Submitter ID
 S ABMR(1,240)=""
 S ABMR(1,240)=$$FMT^ABMERUTL(ABMR(1,240),16)
 Q
250 ;283-283 Vendor Application Cat.
 S ABMR(1,250)=" "
 Q
260 ;284-288 Vendor Software Version
 S ABMR(1,260)="2.5  "
 Q
270 ;289-290 Vendor Software Update
 S ABMR(1,270)="P0"
 Q
280 ;291-291 Coordination of Benefits File Indicator
 S ABMR(1,280)=""
 S ABMR(1,280)=$$FMT^ABMERUTL(ABMR(1,280),1)
 Q
290 ;292-299 Process from Date
 S ABMR(1,290)=""
 S ABMR(1,290)=$$FMT^ABMERUTL(ABMR(1,290),8)
 Q
300 ;300-307 Process thru Date
 S ABMR(1,300)=""
 S ABMR(1,300)=$$FMT^ABMERUTL(ABMR(1,300),8)
 Q
310 ;308-308 Acknowledgement Requested
 S ABMR(1,310)=""
 S ABMR(1,310)=$$FMT^ABMERUTL(ABMR(1,310),1)
 Q
320 ;309-316 Date of Receipt
 S ABMR(1,320)=""
 S ABMR(1,320)=$$FMT^ABMERUTL(ABMR(1,320),8)
 Q
330 ;317-320 Filler - National
 S ABMR(1,330)=""
 S ABMR(1,330)=$$FMT^ABMERUTL(ABMR(1,330),4)
 Q
DIQ2 ;GET LOCATION INFORMATION
 Q:$D(ABM(9999999.06,DUZ(2)))
 N I S DIQ="ABM",DIQ(0)="IE",DIC="^AUTTLOC(",DA=DUZ(2)
 S DR=".01;.13;.14;.15;.16;.17;.21"
 D EN^DIQ1 K DIQ
 Q
