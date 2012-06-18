ACRFPPR ;IHS/OIRM/DSD/THL,AEF - PROMPT PAYMENT REPORT;  [ 10/27/2004   4:18 PM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;**13**;NOV 05, 2001
 ;;
EN D EXIT
 D PPR
EXIT K ACR,ACRQUIT,ACROUT,ACRFYDA,ACRBATDA,ACRSEQDA,ACRBEGIN,ACREND,ACRDATE,ACRFY,ACRIA,ACRIB,ACRIIA,ACRIIB,ACRIIC,ACRIIC1,ACRIIC2,ACRIIC3,ACRIIC4,ACROBJDA,ACRRTN,ACRIID,ACRIIE1,ACRIIE2,ACRIIF1,ACRIIF2,ACRIIF3,ACRIIIA,ACRIIIB,ACRIIIC
 K ACRIVA,ACRIVB,ACRVA,ACRVB,ACRVC,ACRVE1,ACRVE2,ACRVF,ACRVG,ACRIVA1,ACRIVA2,ACRIVB1,ACRIVB2,ACRNIIB
 Q
PPR ;EP;TO SETUP PRINT OF THE PROMPT PAYMENT REPORT
 D EXIT
 K ACRQUIT,ACROUT
 N ACRFYDA,ACRQT,ACRDC
 S DIC="^AFSLAFP("
 S DIC(0)="AEMQZ"
 S DIC("A")="Fiscal Year: "
 S DIC("B")=$E(DT,1,3)+1700
 S DIC("S")="I $P(^(0),U)=X"
 W !
 D DIC^ACRFDIC
 Q:Y<1
 S ACRFYDA=+Y
 S ACRFY=$P(^AFSLAFP(+Y,0),U)
 S DIR(0)="SO^1:First Quarter;2:Second Quarter;3:Third Quarter;4:Fourth Quarter;5:Fiscal Year"
 S DIR("A")="Which Quarter"
 D DIR^ACRFDIC
 Q:'Y
 S ACRQT=Y
 S ACRBEGIN=$$FYBEG^ACRFPPR(ACRFY,ACRQT)   ; ACR*2.1*13.03 IM11657
 S ACREND=$$FYEND^ACRFPPR(ACRFY,ACRQT)     ; ACR*2.1*13.03 IM11657
 S (ZTRTN,ACRRTN)="PPR1^ACRFPPR"
 S ZTDESC="Prompt Payment Report"
 D ZIS
 Q
PPR1 ;EP;TO PRINT PROMPT PAYMENT REPORT
 D GATHER^ACRFPPR1
 K ACRDC
 D PPRH
 W !!,"For ",$S(ACRQT'=5:"Quarter",1:"Fiscal Year")," ending: "
 W:ACRQT=1 "December 31, "
 W:ACRQT=2 "March 31, "
 W:ACRQT=3 "June 31, "
 W:ACRQT>3 "September 30, "
 W $E(ACREND,1,3)+1700
 W !!!,"I.  Invoices paid subject to the Prompt Payment Act and OMB Circular A-125:"
 W !!?4,"A.  Dollar value of invoices",?50,$J($FN($G(ACRIA),"P,",2),14)
 W !?4,"B.  Number of invoices",?50,$J($G(ACRIB),10)
 D PAUSE^ACRFWARN
 Q:$D(ACRQUIT)
 W !!!,"II.  Invoices paid after the due date:"
 W !!?4,"A.  Dollar value of invoices",?50,$J($FN($G(ACRIIA),"P,",2),14)
 W !?4,"B.  Number of invoices (sum C.2 and F.1.b)",?50,$J($G(ACRNIIB),10)
 W !!?4,"C.  Late Payment interest penalties paid:"
 W !!?9,"1.  Dollar amount",?50,$J($FN($G(ACRIIC1),"P,",2),14)
 W !?9,"2.  Number",?50,$J($G(ACRIIC2),10)
 W !?9,"3.  Relative Frequency (II.C.2/IB)"
 W:$G(ACRIB) ?52,$J($FN($G(ACRIIC2)/ACRIB,"P",4),14)
 D PAUSE^ACRFWARN
 Q:$D(ACRQUIT)
 W !?9,"4.  Frequency distribution of late payment interest penalties paid"
 W !?9,"    this year (as reported on line 1 and 2 of this seciton)."
 W !!?40,"Number of",?55,"Dollars"
 W !?4,"Amount of Penalty",?40,"Payments",?55,"Paid"
 W !!?4,"$   1.00 - $  25.00",?40,$J($G(ACRIIC4(1)),5),?55,$J($FN($G(ACRIIC4(11)),"P,",2),10)
 W !!?4,"$  25.01 - $ 500.00",?40,$J($G(ACRIIC4(2)),5),?55,$J($FN($G(ACRIIC4(22)),"P,",2),10)
 W !!?4,"$ 500.01 - $1000.00",?40,$J($G(ACRIIC4(3)),5),?55,$J($FN($G(ACRIIC4(33)),"P,",2),10)
 W !!?4,"$1000.01 - $2500.00",?40,$J($G(ACRIIC4(4)),5),?55,$J($FN($G(ACRIIC4(44)),"P,",2),10)
 W !!?4,"$2500.01 - $3000.00",?40,$J($G(ACRIIC4(5)),5),?55,$J($FN($G(ACRIIC4(55)),"P,",2),10)
 W !!?4,"$3000.01 - plus",?40,$J($G(ACRIIC4(6)),5),?55,$J($FN($G(ACRIIC4(66)),"P,",2),10)
 D PAUSE^ACRFWARN
 Q:$D(ACRQUIT)
 D PPRH
 W !!?4,"D.  Additional penalties paid for failure to pay interest penalties:"
 W !!?9,"1.  Dollar amount",?50,$J($FN($G(ACRIID(1)),"P,",2),14)
 W !?9,"2.  Number",?50,$J($G(ACRIID(2)),10)
 W !?9,"3.  Relative Frequency"
 W:$G(ACRIB) ?52,$J($FN($G(ACRIID(2))/ACRIB,"P,",4),14)
 W !?9,"4.  Number of minimum penalties",?50,$J($G(ACRIID(4)),14)
 W !?9,"5.  Number of maximum penalties",?50,$J($G(ACRIID(5)),14)
 D PAUSE^ACRFWARN
 Q:$D(ACRQUIT)
 W !!?4,"E.  Reasons why interest of other late payment penalties were incurred."
 W !?4,"    RANK from highest to lowest, according to frequency of occurences."
 W !!?9,"1.  Delay in paying offices' receipt of:"
 W !!?14,"a.  Receiving Report",?45,"( ",$J($G(ACRIIE1(1)),5)," )",?60,"( ",$J($G(ACRIIE1(11)),5)," )"
 W !?14,"b.  Proper invoice",?45,"( ",$J($G(ACRIIE1(2)),5)," )",?60,"( ",$J($G(ACRIIE1(22)),5)," )"
 W !?14,"c.  Purchase order or contract",?45,"( ",$J($G(ACRIIE1(3)),5)," )",?60,"( ",$J($G(ACRIIE1(33)),5)," )"
 W !!?9,"2.  Delay or error by paying office in:"
 W !!?14,"a.  Taking discount",?45,"( ",$J($G(ACRIIE2(1)),5)," )",?60,"( ",$J($G(ACRIIE2(11)),5)," )"
 W !?14,"b.  Notifying vendor of",?45,"( ",$J($G(ACRIIE2(2)),5)," )",?60,"( ",$J($G(ACRIIE2(22)),5)," )"
 W !?14,"    defective invoice"
 W !?14,"c.  Computer or other",?45,"( ",$J($G(ACRIIE2(3)),5)," )",?60,"( ",$J($G(ACRIIE2(33)),5)," )"
 W !?14,"    system processing"
 D PAUSE^ACRFWARN
 Q:$D(ACRQUIT)
 W !!?4,"F.  Interest and other late payment penalties which were due but not paid:"
 W !?4,"    (use interest rate in effect on the date the obligation accrues)"
 W !!?9,"1.  Total:"
 W !!?14,"a.  Interest dollars",?45,"( ",$J($FN($G(ACRIIF1(1)),"P",2),10)," )",?60,"( ",$J($FN($G(ACRIIF1(11)),"P",2),10)," )"
 W !?14,"b.  Number",?45,"( ",$J($G(ACRIIF1(2)),10)," )",?60,"( ",$J($G(ACRIIF1(2)),10)," )"
 W !!?9,"2.  Because payments were less than $1.00"
 W !!?14,"a.  Interest dollars",?45,"( ",$J($FN($G(ACRIIF2(1)),"P",2),10)," )",?60,"( ",$J($FN($G(ACRIIF2(11)),"P",2),10)," )"
 W !?14,"b.  Number",?45,"( ",$J($G(ACRIIF2(2)),10)," )",?60,"( ",$J($G(ACRIIF2(22)),10)," )"
 D PAUSE^ACRFWARN
 Q:$D(ACRQUIT)
 D PPRH
 W !!?9,"3.  For other reasons"
 W !!?14,"a.  Interest dollars",?45,"( ",$J($FN($G(ACRIIF3(1)),"P",2),10)," )",?60,"( ",$J($FN($G(ACRIIF3(11)),"P",2),10)," )"
 W !?14,"b.  Number",?45,"( ",$J($G(ACRIIF3(2)),10)," )",?60,"( ",$J($G(ACRIIF3(22)),10)," )"
 W !?14,"c.  Specify Reasons:"
 W !!?19,"__________________________________________________________"
 W !!?19,"__________________________________________________________"
 W !!?19,"__________________________________________________________"
 D PAUSE^ACRFWARN
 Q:$D(ACRQUIT)
 W !!!,"III.  Invoices paid 1 - 15 days after the due date:"
 W !!?4,"A.  Dollar amount",?50,$J($FN($G(ACRIIIA),"P,",2),14)
 W !?4,"B.  Number",?50,$J($G(ACRIIIB),14)
 W !?4,"C.  Relative Frequency:  Current Year"
 W:$G(ACRIB) ?52,$J($FN($G(ACRIIIC)/ACRIB,"P",4),14)
 W !?4,"                         Prior Year",?52,$J($FN($G(ACRIIC(2)),"P",4),14)
 D PAUSE^ACRFWARN
 Q:$D(ACRQUIT)
 W !!!,"IV.  Invoices paid 8 days or more before due date,"
 W !!!,"     except where cash discounts are taken:"
 W !!?4,"A.  Subject to a determination under section 4.1 of circular A-125:"
 W !!?9,"1.  Dollar amount",?50,$J($FN($G(ACRIVA1),"P,",2),14)
 W !?9,"2.  Number",?50,$J($G(ACRIVA2),14)
 W !?9,"3.  Relative Frequency"
 W:$G(ACRIB) ?52,$J($FN($G(ACRIVA2)/ACRIB,"P",4),14)
 W !!?4,"B.  Without a determinaiton under section 4.1:"
 W !!?9,"1.  Dollar amount",?50,$J($FN($G(ACRIVB1),"P,",2),14)
 W !?9,"2.  Number",?50,$J($G(ACRIVB2),14)
 W !?9,"3.  Relative Frequency"
 W:$G(ACRIB) ?52,$J($FN($G(ACRIVB2)/ACRIB,"P",4),14)
 D PAUSE^ACRFWARN
 Q:$D(ACRQUIT)
 D PPRH
 W !!!,"V.  Discounts"
 W !!?4,"A.  Number available",?50,$J($G(ACRVA(1)),10),?65,$J($FN($G(ACRVA(11)),"P,",2),14)
 W !?4,"B.  Number taken",?50,$J($G(ACRVB(2)),10),?65,$J($FN($G(ACRVA(22)),"P,",2),14)
 W !?4,"C.  Number not taken because not",?50,$J($G(ACRVB(3)),10),?65,$J($FN($G(ACRVB(33)),"P,",2),14)
 W !?4,"    economically justified"
 W !!?4,"D.  Reason for failing to take discounts, in order of importance:"
 W !!?9,"1.  ____________________________________"
 W !!?9,"2.  ____________________________________"
 W !!?9,"3.  ____________________________________"
 W !!?4,"E.  Total third party draft payments subject to Prompt Payment Act"
 W !!?9,"Dollar Amount: ",$J($FN($G(ACRVE1),"P,",2),10)
 W !!?9,"Number       : ",$J($G(ACRVE2),10)
 W !!?4,"F.  Third party drafts which included",?50,$J($G(ACRVF(1)),10),?65,$J($FN($G(ACRVF(11)),"P,",2),14)
 W !?4,"    interest"
 W !!?4,"G.  Amount of interest included in line F.",?50,$J($G(ACRVG(1)),10),?65,$J($FN($G(ACRVG(11)),"P,",2),14)
 D PAUSE^ACRFWARN
 Q
CENTER(X) ;CENTER HEADER INFO
 W !?80-$L(X)/2,X
 Q
PPRH ;PROMPT PAYMENT REPORT HEADER
 S ACRDC=$G(ACRDC)+1
 W @IOF
 S X=$P($G(^AUTTAREA(+$G(^ACRSYS(1,0)),0)),U)_" AREA INDIAN HEALTH SERVICE"
 D CENTER(X)
 F X="U.S. DEPARTMENT OF HEALTH AND HUMAN SERVICES","PROMPT PAYMENT REPORT" D CENTER(X)
 S Y=DT
 X ^DD("DD")
 S X="DATE OF REPORT: "_Y
 D CENTER(X)
 W !?65,"Page ",ACRDC
 Q
ZIS ;SELECT OUTPUT DEVICE
 S:'$D(ZTRTN) (ZTRTN,ACRRTN)="PORR1^ACRFPAYR"
 S:'$D(ZTDESC) ZTDESC="Print payment source document"
 D ^ACRFZIS
 Q
FYBEG(ACRFY,ACRQT)    ;EP; EXTRINSIC FUNCTION TO RETURN BEGIN DATES FOR LOOP ; ACR*2.1*13.03 IM11657
 ; ACRFY=4 digit fiscal year
 ; ACRQT=1,2,3,4 represents quarters of the Fiscal Year
 ; ACRQT=5  represents the full Fiscal Year
 N X,Y
 I ACRQT=1!(ACRQT=5) S Y=(ACRFY-1)-1700_1000
 I ACRQT=2 S Y=ACRFY-1700_"0100"
 I ACRQT=3 S Y=ACRFY-1700_"0400"
 I ACRQT=4 S Y=ACRFY-1700_"0700"
 Q Y
 ;
FYEND(ACRFY,ACRQT) ;EP; EXTRINSIC FUNCTION TO RETURN END DATE FOR LOOP ; ACR*2.1*13.03 IM11657
 ; ACRFY=4 digit fiscal year
 ; ACRQT=1,2,3,4 represents quarters of the Fiscal Year
 ; ACRQT=5  represents the full Fiscal Year
 N X,Y
 I ACRQT=1 S Y=(ACRFY-1)-1700_1231
 I ACRQT=2 S Y=ACRFY-1700_"0331"
 I ACRQT=3 S Y=ACRFY-1700_"0630"
 I ACRQT=4!(ACRQT=5) S Y=ACRFY-1700_"0930"
 Q Y
