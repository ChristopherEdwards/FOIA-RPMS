BWPROF3 ;IHS/ANMC/MWR - DISPLAY PATIENT PROFILE; [ 09/17/2001  7:54 AM ]
 ;;2.0;WOMEN'S HEALTH;**5,8**;MAY 16, 1996
 ;IHS/CMI/LAB - Y2K
 ;;* MICHAEL REMILLARD, DDS * ALASKA NATIVE MEDICAL CENTER *
 ;;  DISPLAY CODE FOR PATIENT PROFILE.  CALLED BY BWPROF1.
 ;
NOMATCH ;EP
 ;---> QUIT IF NO RECORDS MATCH.
 I '$D(^TMP("BW",$J,1)) D  Q
 .D HEADER2^BWUTL7
 .K BWPRMT,BWPRMT1,BWPRMTQ,DIR
 .W !!?5,"No records match the selected criteria.",!
 .D:BWCRT DIRZ^BWUTL3 W @IOF D ^%ZISC:'$G(BWEXT) S BWPOP=1 ;IHS/CMI/THL PATCH 8 DON'T CLOSE WHEN EXTERNAL CALL
 ;
 ;---> BWD=1:DETAILED DISPLAY, BWD=0:BRIEF DISPLAY.
 I BWD D DISPLAY1 Q
 D DISPLAY2
 Q
 ;
 ;
DISPLAY1 ;EP
 ;---> IF A PROCEDURE IS EDITED ON THE LAST PAGE, GOTO HERE
 ;---> FROM LINELABEL "END" BELOW.
 D HEADER2^BWUTL7
 F  S N=$O(^TMP("BW",$J,2,N)) Q:'N!(BWPOP)  D
 .I $Y+9>IOSL D:BWCRT DIRPRMT^BWUTL3 Q:BWPOP  D
 ..S BWPAGE=BWPAGE+1
 ..D HEADER2^BWUTL7 S (BWACCP,Z)=0
 .S Y=^TMP("BW",$J,2,N),M=N
 .W !
 .;
 .;---> **********************
 .;---> DISPLAY PROCEDURES
 .;---> IF PIECE 1=1 DISPLAY AS A PROCEDURE.
 .I $P(Y,U)=1 D  Q
 ..W !,"------------------------------< "
 ..W "PROCEDURE: ",$P(Y,U,5)," >"            ;PROCEDURE ABBREVIATION
 ..F I=1:1:(6-$L($P(Y,U,5))) W "-"
 ..W "-----------------------------"
 ..W ! W:BWCRT $J(N,3),")" W ?BWTAB          ;BROWSE SELECTION#
 ..W $P(Y,U,6)                               ;ACCESSION#
 ..;begin Y2K
 ..W ?16,$P(Y,U,4)                           ;DATE OF PROCEDURE ;IHS/CMI/LAB 17 to 16 Y2000
 ..;end Y2K
 ..W ?27,"Res/Diag: ",$P(Y,U,7)              ;RESULTS/DIAGNOSIS
 ..W !?27,"Provider: ",$E($P(Y,U,8),1,14)    ;PROVIDER
 ..W ?62,"Status: ",$P(Y,U,9)                ;STATUS
 ..S BWACCP=$P(Y,U,6)                        ;STORE AS PREVIOUS ACCESS#
 .;
 .;---> **********************
 .;---> DISPLAY NOTIFICATIONS
 .;---> IF PIECE 1=2 DISPLAY AS A NOTIFICATION.
 .I $P(Y,U)=2 D  Q
 ..S BWACC=$P(Y,U,5)
 ..I BWACC'=Z D
 ...;begin Y2K
 ...W ! W:BWACC["NO ACC#" "-----------------" W ?16 ;IHS/CMI/LAB 17 to 16 Y2000
 ...;end Y2K
 ...W "-------------< NOTIFICATIONS >---------------------------------"
 ..W ! W:BWCRT $J(N,3),")" W ?BWTAB           ;BROWSE SELECTION#
 ..W:BWACC'=BWACCP!(BWACC["NO ACC#") BWACC    ;ACCESSION#
 ..;begin Y2K
 ..W ?16,$P(Y,U,4)                            ;DATE OF PROCEDURE;IHS/CMI/LAB 17 to 16 Y2000
 ..;end Y2K
 ..W ?27,$E($P(Y,U,6)_": "_$P(Y,U,7),1,53)    ;TYPE AND PURPOSE
 ..W !?27,"Outcome: ",$E($P(Y,U,8),1,23)      ;OUTCOME OF NOTIFICATION
 ..W ?62,"Status: ",$P(Y,U,9)                 ;STATUS
 ..S (BWACCP,Z)=BWACC                         ;STORE AS PREVIOUS ACC#
 ..;
 ..;---> TWO VARIABLES (BWACCP & Z) USED ABOVE: "Z" SAYS "IF THIS NOTIF
 ..;---> ACC# IS NOT THE SAME AS THE LAST ONE, DISPLAY --<NOT>-- BANNER.
 ..;---> "BWACCP" SAYS "IF THIS NOTIF ACC# MATCHES THE LAST PROCEDURE'S
 ..;---> ACC#, DON'T DISPLAY THE ACCESSION#."
 ..;---> BOTH VARIABLES ARE RESET AFTER A FORMFEED, IN ORDER TO DISPLAY
 ..;---> ON THE NEW PAGE.
 .;
 .;---> **********************
 .;---> DISPLAY PAP REGIMENS
 .;---> IF PIECE 1=3 DISPLAY AS A PAP REGIMEN.
 .I $P(Y,U)=3 D  Q
 ..W !,"------------------------------< PAP REGIMEN CHANGE"
 ..W " >----------------------------"
 ..;begin Y2K
 ..W !?9,"Began:" ;IHS/CMI/LAB - 10 to 9 Y2000
 ..W ?16,$P(Y,U,4)                           ;DATE OF REGIMEN ENTRY ;IHS/CMI/LAB 17 to 16 Y2000
 ..;end Y2K
 ..W ?27,"Regimen: ",$P(Y,U,5)               ;PAP REGIMEN
 .;
 .;---> **********************
 .;---> DISPLAY PREGNANCIES
 .;---> IF PIECE 1=4 DISPLAY AS A PREGNANCY.
 .I $P(Y,U)=4 D  Q
 ..W !,"------------------------------< PREGNANCY STATUS"
 ..W " >------------------------------"
 ..;begin Y2K
 ..W !?6,"Entered:" ;IHS/CMI/LAB - 8 to 6 patch 5 Y2000
 ..W ?15,$P(Y,U,4)                           ;DATE OF PREGNANCY EDIT. ;IHS/CMI/LAB - 17 to 15 Y2000
 ..;end Y2K
 ..W ?27,$P(Y,U,5)                           ;PREGNANT/NOT
 ..W:$P(Y,U,6)]"" ?50,"EDC: ",$P(Y,U,6)      ;EDC
 ;
END ;EP
 W:'BWCRT @IOF
 ;---> IF A PROCEDURE HAS BEEN EDITED, SET N=N-5 AND START (GOTO)
 ;---> DISPLAY1 OVER AGAIN FROM 5 RECORDS PREVIOUS.
 I BWCRT&('$D(IO("S")))&('BWPOP) D DIRPRMT^BWUTL3 I N S N=N-1 G NOMATCH
 D ^%ZISC:'$G(BWEXT) ;IHS/CMI/THL PATCH 8 DON'T CLOSE WHEN EXTERNAL CALL
 K N,Z
 Q
 ;
 ;
 ;
DISPLAY2 ;EP
 ;---> IF A PROCEDURE IS EDITED ON THE LAST PAGE, GOTO HERE
 ;---> FROM LINELABEL "END" BELOW.
 S BWSUBH="SUBHEAD^BWPROF1"
 D HEADER2^BWUTL7
 F  S N=$O(^TMP("BW",$J,2,N)) Q:'N!(BWPOP)  D
 .I $Y+9>IOSL D:BWCRT DIRPRMT^BWUTL3 Q:BWPOP  D
 ..S BWPAGE=BWPAGE+1
 ..D HEADER2^BWUTL7 S (BWACCP,Z)=0
 .S Y=^TMP("BW",$J,2,N),M=N
 .;---> QUIT IF NOT A PROCEDURE (PIECE 1'=1).
 .Q:$P(Y,U)'=1
 .W ! W:BWCRT $J(N,3),")" W ?BWTAB          ;BROWSE SELECTION#
 .W $P(Y,U,4)                               ;DATE OF PROCEDURE
 .W ?17,$P(Y,U,5)                           ;PROCEDURE ABBREVIATION
 .W ?27,$P(Y,U,7)                           ;RESULT
 .W ?71,$P(Y,U,9)                           ;STATUS
 .S BWACCP=$P(Y,U,6)                        ;STORE AS PREVIOUS ACCESS#
END2 ;EP
 W:'BWCRT @IOF
 ;---> IF A PROCEDURE HAS BEEN EDITED, SET N=N-1 AND START (GOTO)
 ;---> DISPLAY2 OVER AGAIN FROM 5 RECORDS PREVIOUS.
 I BWCRT&('$D(IO("S")))&('BWPOP) D DIRPRMT^BWUTL3 I N S N=N-1 G NOMATCH
 D ^%ZISC:'$G(BWEXT) ;IHS/CMI/THL PATCH 8 DON'T CLOSE WHEN EXTERNAL CALL
 K N,Z
 Q
