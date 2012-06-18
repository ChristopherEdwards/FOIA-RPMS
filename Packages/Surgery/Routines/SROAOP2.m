SROAOP2 ;BIR/ADM - OPERATION INFO, PAGE 2 ; [ 05/28/99  10:05 AM ]
 ;;3.0; Surgery ;**81,88**;24 Jun 93
 ; called from SROAOP
EDIT Q:SRSOUT  S SRHDR(.5)=SRDOC,SRPAGE="PAGE: 2 OF 2" D HDR^SROAUTL
 K DR S SRQ=0,(DR,SRDR)=".205;.22;.23;.232;.21;.24;1.18"
 K DA,DIC,DIQ,SRY S DIC="^SRF(",DA=SRTN,DIQ="SRY",DIQ(0)="E",DR=SRDR D EN^DIQ1 K DA,DIC,DIQ,DR
 K SRX S SRX=0 F M=1:1 S I=$P(SRDR,";",M)  Q:'I  D
 .D TR,GET
 .S SRX=SRX+1,Y=$P(X,";;",2),SRFLD=$P(Y,"^"),(Z,SRX(SRX))=$P(Y,"^",2)_"^"_SRFLD,SREXT=SRY(130,SRTN,SRFLD,"E")
 .W !,SRX_". "_$P(Z,"^")_":" D EXT
 W !! F K=1:1:80 W "-"
 D SEL G EDIT
 Q
EXT I SREXT["@" S X=$P(SREXT,"@")_"  "_$P(SREXT,"@",2),SREXT=X
 W ?39,SREXT
 Q
SEL W !!,"Select Operative Information to Edit: " R X:DTIME I '$T!(X["^")!(X="") S SRSOUT=1 Q
 S:X="a" X="A" I '$D(SRFLG),'$D(SRX(X)),(X'?1.2N1":"1.2N),X'="A" D HELP Q
 I X?1.2N1":"1.2N S Y=$P(X,":"),Z=$P(X,":",2) I Y<1!(Z>SRX)!(Y>Z) D HELP Q
 I X="A" S X="1:"_SRX
 I X?1.2N1":"1.2N D RANGE Q
 I $D(SRX(X)),+X=X S EMILY=X D ONE
 Q
HELP W @IOF,!!!!,"Enter the number or range of numbers you want to edit.  Examples of proper",!,"responses are listed below."
 W !!,"1. Enter 'A' to update all items.",!!,"2. Enter a number (1-"_SRX_") to update an individual item.  (For example,",!,"   enter '1' to update "_$P(SRX(1),"^")_")"
 W !!,"3. Enter a range of numbers (1-"_SRX_") separated by a ':' to enter a range",!,"   of items.  (For example, enter '1:4' to update items 1, 2, 3 and 4.)",!
 I $D(SRFLG) W !,"4. Enter 'N' or 'NO' to enter negative response for all items.",!!,"5. Enter '@' to delete information from all items.",!
PRESS W ! K DIR S DIR("A")="Press the return key to continue or '^' to exit: ",DIR(0)="FOA" D ^DIR K DIR I $D(DTOUT)!$D(DUOUT) S SRSOUT=1
 Q
RANGE ; range of numbers
 S SHEMP=$P(X,":"),CURLEY=$P(X,":",2) F EMILY=SHEMP:1:CURLEY Q:SRSOUT  D ONE
 Q
ONE ; edit one item
 K DR,DA,DIE S DR=$P(SRX(EMILY),"^",2)_"T",DA=SRTN,DIE=130,SRDT=$P(SRX(EMILY),"^",3) S:SRDT DR=DR_";"_SRDT_"T" D ^DIE K DR,DA I $D(Y) S SRSOUT=1
 Q
TR S J=I,J=$TR(J,"1234567890.","ABCDEFGHIJP")
 Q
GET S X=$T(@J)
 Q
PBJE ;;.205^Date/Time Patient In OR
PBB ;;.22^Date/Time Operation Began
PBC ;;.23^Date/Time Operation Ended
PBCB ;;.232^Date/Time Patient Out OR
PBA ;;.21^Anesthesia Care Start Date/Time
PBD ;;.24^Anesthesia Care End Date/Time
APAH ;;1.18^PAC(U) Discharge Date/Time
