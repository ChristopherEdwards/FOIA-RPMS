DGVPT3 ;ALB/MTC - DG POST-INIT DRIVER CONTINUED ; 27 MAR 91
 ;;5.3;Registration;;Aug 13, 1993
 ;
COMP ;Reminder to recompile templates and cross-references on all CPU's
 W !!,">>> Remember to recompile the following templates on all CPU's..."
 W !!?4,"Template",?30,"Routine",?45,"Type",?55,"Routine Used to Recompile",!?4,"--------",?30,"-------",?45,"----",?55,"-------------------------"
 F I=1:1 S J=$P($T(TEMP+I),";;",2) Q:J="QUIT"  W !?4,$P(J,";",1),?30,$P(J,";",2),?45,$S($P(J,";",3)="I":"INPUT",1:"PRINT"),?64,$S($P(J,";",3)="I":"DIEZ",1:"DIPZ")
 ;
 W !!!,">>> Remember to recompile the cross-references for the following files",!?4,"on all CPU's..."
 W !!?4,"File",?30,"Routine",?45,"Type",?55,"Routine Used to Recompile",!?4,"----",?30,"-------",?45,"----",?55,"-------------------------"
 F I=1:1 S J=$P($T(FILE+I),";;",2) Q:J="QUIT"  W !?4,$P(J,";",1),?30,$P(J,";",2),?45,"X-REF",?64,"DIKZ"
 W !!,"NOTE:  To recompile all PIMS compiled templates and compiled ",!?7,"cross-references you can call ALL^DGUTL1."
 Q
 ;
TEMP ;
 ;;DGPM ADMIT;DGPMX1;I
 ;;DGPM TRANSFER;DGPMX2;I
 ;;DGPM DISCHARGE;DGPMX3;I
 ;;DGPM CHECK-IN LODGER;DGPMX4;I
 ;;DGPM LODGER CHECK-OUT;DGPMX5;I
 ;;DGPM SPECIALTY TRANSFER;DGPMX6;I
 ;;DGPM ASIH ADMIT;DGPMXAS;I
 ;;DG PTF ADD MESSAGE;DGPTXMS;I
 ;;DG PTF CREATE PTF ENTRY;DGPTXC;I
 ;;DG PTF POST CREATE;DGPTXCA;I
 ;;DG101;DGPTX1;I
 ;;DG401;DGPTX4;I
 ;;DG501;DGPTX5;I
 ;;DG501F;DGX5F;I
 ;;DG701;DGPTX7;I
 ;;DG CONSISTENCY CHECKER;DGRPXC;I
 ;;DG LOAD EDIT SCREEN 7;DGRPXX7;I
 ;;DGRP COLLATERAL REGISTER;DGRPXCR;I
 ;;DG PTF PT BRIEF LIST;DGPTXB;P
 ;;DGPT QUICK PROFILE;DGPTXCP;P
 ;;DGJ EDIT IRT RECORD;DGJXE;I
 ;;DGJ ENTER IRT RECORD;DGJXA;I
 ;;DGMT ENTER/EDIT ANNUAL INCOME;DGMTXI;I
 ;;DGMT ENTER/EDIT COMPLETION;DGMTXC;I
 ;;DGMT ENTER/EDIT DEPENDENTS;DGMTXD;I
 ;;DGMT ENTER/EDIT EXPENSES;DGMTXE;I
 ;;DGMT ENTER/EDIT MARITAL STATUS;DGMTXM;I
 ;;DGRP ENTER/EDIT ANNUAL INCOME;DGRPXIS;I
 ;;DGMT ENTER/EDIT NET WORTH;DGMTXN;I
 ;;DGTS;DGXTS;I
 ;;DVBHINQ UPDATE;DVBHCE;I
 ;;DVBC ADD 2507 PAT;DVBCDAT;I
 ;;QUIT
 ;
FILE ;
 ;;PTF (#45);DGPTXX
 ;;PATIENT MOVEMENT (#405);DGPMXX
 ;;INDIVIDUAL ANNUAL INCOME (#408.21);DGMTXX1
 ;;INCOME RELATION (#408.22);DGMTXX2
 ;;ANNUAL MEANS TEST (#408.31);DGMTXX3
 ;;QUIT
