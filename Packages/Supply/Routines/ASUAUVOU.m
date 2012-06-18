ASUAUVOU ;DSD/DFM - UTILITY ENTER VOUCHER NUMBER;  [ 04/15/98  2:57 PM ]
 ;;3.0;SAMS;**1**;AUG 20, 1993
RDVOU ;
 S DIR("A")=ASUV("ITEM #")_". ENTER VOUCHER NUMBER"
 S DIR(0)="F^8:8^D EDIT^ASUAUVOU"
 S DIR("?")="^D HELP^ASUAUVOU"
 D ^DIR
 Q:$D(DUOUT)!($D(DIROUT))!($D(DTOUT))
 S ASUTRNS(ASUTRNS,"VOUCHER #")=X
EXIT ;RETURN TO CALLING ROUTINE
 K DIR,X,Y
 Q
HELP ;EP ;EXECUTABLE HELP FOR VOUCHER NUMBER
 W !!,"Voucher Number must be 8 numeric digits, not all zeros in format FYMMSER#"
 W !!,"Fiscal Year (FY) must be current fiscal year or previous fiscal year,"
 W !,"Month (MM) must be 01 through 12,"
 W !,"and Serial number (SER#) must be 0001 through 9999."
 Q
EDIT ;EP ;VOUCHER EDIT SUB ROUTINE
 I '$D(ASUK("DATE","FM")) N DN D DAYTIM^ASUAUTL1 S ASUF("DATE")=1
 S Y("EY")=$E(X,1,2)
 S Y("EM")=$E(X,3,4)
 S Y("ES")=$E(X,5,8),Y("SB")=1
 S Y("M1")="Voucher year not equal to current"
 S Y("M2")=" "
 S Y("M3")="or previous FY"
 I ASUK("DATE","MO")="09" D
 .S Y("SB")=2,Y("M2")=", next "
 I Y("EM")<1!(Y("EM")>12) D
 .W *7,!,"Month must be 01-12" K X
 E  D
 .S Y("DIF")=ASUK("DATE","CFY")-Y("EY")
 .I Y("DIF")>Y("SB")!(Y("DIF")<0) D
 ..W *7,!,Y("M1"),Y("M2"),Y("M3") K X
 .E  D
 ..I Y("ES")'>0 D
 ...W *7,!,"Voucher Serial Number may not be all zeros" K X
 ..E  D
 ...I $L(Y("ES"))<4!($L(Y("ES"))>4) D
 ....W *7,!,"Voucher Number must be a total of 8 digits" K X
 K:$D(ASUF("DATE")) ASUK("DATE")
 K Y
 Q
