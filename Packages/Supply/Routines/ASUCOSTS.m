ASUCOSTS ; IHS/ITSC/LMH -CLOSEOUT STATUS FUNCTIONS ;  [ 07/26/2000  9:00 AM ]
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine provides entry points to store and print information
 ;concerning the status of an closeout.
 ;IHS/ITSC/MRS - Added lines 2 & 3 to HELP text so HELP+value will be correct 7/26/2000
 D:$G(IOF)']"" HOME^%ZIS,^XBKVAR W @IOF,?25,"R U N   S T A T U S   R E P O R T I N G",!!
 D EN2 W @IOF Q
EN2 ;EP ;
 I $G(ASUP("CKP"))']"" D
 .D SETCTRL
 E  D
 .S ASUP("LSTY")=$G(ASUP("TYP"))
 S ASUP("LSTN")=$S(ASUP("LSTY")=1:"monthly closeout",ASUP("LSTY")=2:"yearly closeout",1:"daily closeout")
 W !!,"The status of the last closeout which was a '",ASUP("LSTN"),"' was : "
 I ASUP("CKP")=0,ASUP("CKY")=0 D  G PAUSE
 .W !!?5,"Successfully completed."
 E  D
 .W !!?5,$P($T(HELP+ASUP("CKP")),";",4) ; update status switch in ^AUSITE
 .S ASUP=$P($T(HELP+ASUP("CKP")),";",5)
 .I ASUP']"" W $P($T(HELP),";",4) Q
 .I $G(ASUP(ASUP))']"" W $P($T(HELP),";",4) Q
 .I ASUP="CKM" D
 ..W !?5,"Processing ended as "
 ..S X=""""_$P($T(CKM+ASUP("CKM")+1),";",4)
 ..I ASUP(ASUP)<9 D
 ...S X=X_""","" was processing."""
 ..E  D
 ...S X=X_""","" was printing."""
 .I ASUP="CKY" D
 ..W !?5,"Processing ended as "
 ..S X=""""_$P($T(CKM+ASUP("CKY")+1),";",4)_""","" being cleared."""
 .I ASUP="CKX" D
 ..W !?5,"Processing ended as Report "
 ..S X=""""_$P($T(CKM+ASUP("CKX")+1),";",4)_""","" was sorting."""
 .I ASUP="CKI" D
 ..W !?5,"Processing ended as Report "
 ..S X=""""_$P($T(CKM+ASUP("CKI")+1),";",4)_""","" was printing."""
 .I ASUP="CKS" D
 ..I ASUP("CKS")=2!(ASUP("CKS")=3)!(ASUP("CKS")=17) D
 ...W !?5,"Processing ended as "
 ...S X=""""_$P($T(CKM+ASUP("CKS")+1),";",4)_""","" was processing"""
 ..E  D
 ...W !?5,"Processing ended as Report "
 ...S X=""""_$P($T(CKM+ASUP("CKS")+1),";",4)_""","" was printing."""
 .S X="W "_X X X
 D RPTS
 W !!,"If the problem causing processing to end has been addressed,"
 W !,"the UPDATE RESTART option will start at that point and continue."
PAUSE ;
 W !! N DIR S DIR(0)="E" D ^DIR Q
RPTS ;
 W !
 I ASUP("IVR")="Y" D
 . W !?5,"Invoice Reports Printed"
 E  D
 . W !?5,"Invoice Reports Did NOT Print"
 I ASUP("STR")="Y" D
 . W !?5,"Standard Reports Printed"
 E  D
 . W !?5,"Standard Reports Did NOT Print"
 Q
HELP ;;0;but NO FURTHUR HELP IS AVAILABLE.
 ;;1;Yearly Update was processing.;CKY
 ;;2;Report files cleared
 ;;3;Beginning balances obtained
 ;;4;Monthly Report Extracts were being created.;CKM
 ;;5;Report Extracts were being Sorted.;CKX
 ;;6;Invoices were printing.;CKI
 ;;7;Standard Reports were printing.;
 ;;8;Monthly Closeout was processing.;
 ;;9;Yearly Closeout was processing.;
 ;;10;Transacton count report was processing.;
 ;;11;Standard Monthly Reports were printing.;CKM
 ;;12;Standard Quarterly Reports were printing.;CKM
 ;;13;Standard Daily Reports were printing.;CKS
CKY ;;
 ;;1;Year to Date Issue data file was
 ;;2;Issue Book Master file was
 ;;3;Transaction History files were
 ;;4;Year to Date Counts in Report one were
CKM ;;
 ;;1;Extract for Data Center Processing
 ;;2;Extracting for Report 10V
 ;;3;Extracting for Report 12
 ;;4;Extracting for Report 13
 ;;5;Extracting for Report 15
 ;;6;Extracting for Report 16
 ;;7;Extracting for Report 17
 ;;8;Extracting for Report 23
 ;;9;Extracting for Report 24
 ;;10;Extracting for Report 74
 ;;11;Extracting for Report 77
 ;;12;Extracting for Report 78
 ;;13;Extracting for Report 79
 ;;14;Station Master PAMIQ and RPQ recalculating
 ;;15;Clear/Update YTD ISSUE DATA fields
 ;;16;Clear/Update ISSUE BOOK fields
 ;;17;Report 10V
 ;;18;Report 12
 ;;19;Report 13
 ;;20;Report 15
 ;;21;Report 16
 ;;22;Report 17
 ;;23;Report 23
 ;;24;Report 24
 ;;25;Report 74
 ;;26;Report 75
 ;;27;Report 77
 ;;28;Report 78
 ;;29;Report 79
 ;;30;Report 83
 ;;31;Report 25
 ;;32;Report 49
 ;;33;Report 81
 ;;34;Report 82
CKX ;;
 ;;1;01
 ;;2;03
 ;;3;04
 ;;4;05
 ;;5;06
 ;;6;07
 ;;7;7A
 ;;8;08
 ;;9;09
 ;;10;10A
 ;;11;10
 ;;12;11
 ;;13;13
 ;;14;70
 ;;15;71
 ;;16;72
 ;;17;73
 ;;18;74
 ;;19;76
 ;;20;79
 ;;21;83
CKI ;;
 ;;1;70
 ;;2;71
 ;;3;72
CKS ;;
 ;;1;1
 ;;2;as Monthly Closeout was processing.
 ;;3;as Yearly Closeout was processing.
 ;;4;3
 ;;5;4
 ;;6;5
 ;;7;6
 ;;8;7
 ;;9;7A
 ;;10;8
 ;;11;9
 ;;12;10A
 ;;13;10
 ;;14;11
 ;;15;13
 ;;16;73
 ;;17;as Monthly Reports were printing.
SETCTRL ;EP ;
 S ASUP("HLT")=+$G(ASUP("HLT"))
 F ASUP("LOOP")="7;MOE","8;MOW","9;MOL" D
 .S ASUP($P(ASUP("LOOP"),";",2))=$P(^ASUSITE(1,2),U,$P(ASUP("LOOP"),";"))
 F ASUP("LOOP")="2;LSTY","6;STD","7;IVD","10;AST","11;AIV","12;A13","13;LSDT","14;LSMO","15;LSYR" D
 .S ASUP($P(ASUP("LOOP"),";",2))=$P(^ASUSITE(1,0),U,$P(ASUP("LOOP"),";"))
 S X=$E(ASUP("LSMO"),1,2)*.01,X=X+.01,X=$P(X,".",2) S:X=1 X="10" S:X=13 X="01"
 S ASUP("UPLD")=$P(^ASUSITE(1,1),U)
 S ASUP("ARMS")=$P(^ASUSITE(1,3),U),ASUP("OLIB")=$P(^ASUSITE(1,3),U,5),ASUP("NXMO")=X,ASUP("MOW")=X_ASUP("MOW")
 I ASUP("A13")=2 D
 .S ASUD("R13","SEL")=$P(^ASUSITE(1,0),U,16)
 .S ASUD("R13","RNG")=$P(^ASUSITE(1,0),U,17)
 .I ASUD("R13","SEL")']"" K ASUD("R13","SEL") S ASUP("A13")=1
 .I ASUD("R13","RNG")']"" K ASUD("R13","RNG") S ASUP("A13")=1
 I ASUP("AST")<2,ASUP("STD")]"" D
 .S ASUK("SRPT","IOP")=$P(ASUP("STD"),":")
 .I ASUK("SRPT","IOP")="HFS" D
 ..S ASUP("STD","FIL")=$S($P(ASUP("STD"),":",2)]"":$P(ASUP("STD"),":",2),$G(ASUP("TYP"))=1:"ASUMR"_$G(ASUL(2,"STA","CD")),$G(ASUP("TYP"))=2:"ASUYR"_$G(ASUL(2,"STA","CD")),1:"ASUSR"_$G(ASUL(2,"STA","CD")))
 ..S ASUP("STD","EXT")=$S($P(ASUP("STD"),":",3)]"":$P(ASUP("STD"),":",3),1:$E(ASUK("DT","FM"),4,7))
 ..S ASUP("STD","DIR")=$S($P(ASUP("STD"),":",4)]"":$P(ASUP("STD"),":",4),1:"/usr/spool/uucppublic/")
 ..S X=""""_$G(ASUP("STD","DIR"))
 ..S X=X_$G(ASUP("STD","FIL"))
 ..S:$G(ASUP("STD","EXT"))]"" X=X_"."_ASUP("STD","EXT")
 ..S ASUK("SRPT","IOPAR")="("_X_""":""W"")"
 ..S ASUP("STD")=ASUK("SRPT","IOP")
 I ASUP("AIV")<2,ASUP("IVD")]"" D
 .S ASUK("IRPT","IOP")=$P(ASUP("IVD"),":")
 .I ASUK("IRPT","IOP")="HFS" D
 ..S ASUP("IVD","FIL")=$S($P(ASUP("IVD"),":",2)]"":$P(ASUP("IVD"),":",2),1:"ASUIR"_$G(ASUL(2,"STA","CD")))
 ..S ASUP("IVD","EXT")=$S($P(ASUP("IVD"),":",3)]"":$P(ASUP("IVD"),":",3),1:$E(ASUK("DT","FM"),4,7))
 ..S ASUP("IVD","DIR")=$S($P(ASUP("IVD"),":",4)]"":$P(ASUP("IVD"),":",4),1:"/usr/spool/uucppublic/")
 ..S X=""""_$G(ASUP("IVD","DIR"))
 ..S X=X_$G(ASUP("IVD","FIL"))
 ..S:$G(ASUP("IVD","EXT"))]"" X=X_"."_ASUP("IVD","EXT")
 ..S ASUK("IRPT","IOPAR")="("_X_""":""W"")"
 ..S ASUP("IVD")=ASUK("IRPT","IOP")
GETSTAT ;EP ;
 F ASUP("LOOP")="1;CKP","2;CKT","3;CKS","4;CKI","5;CKM","6;CKY","10;CKX" D
 .S ASUP($P(ASUP("LOOP"),";",2))=$P(^ASUSITE(1,2),U,$P(ASUP("LOOP"),";"))
 F ASUP("LOOP")="3;STR","4;IVR","5;STS" D
 .S ASUP($P(ASUP("LOOP"),";",2))=$P(^ASUSITE(1,0),U,$P(ASUP("LOOP"),";"))
 Q
SETSP ;EP ;UPDT
 S $P(^ASUSITE(1,2),U)=ASUP("CKP") Q
SETST ;EP ;TRNS
 S $P(^ASUSITE(1,2),U,2)=ASUP("CKT") Q
SETSS ;EP ;STNDRD
 S $P(^ASUSITE(1,2),U,3)=ASUP("CKS"),$P(^ASUSITE(1,0),U,3)=ASUP("STR") Q
SETSI ;EP ;INV
 S $P(^ASUSITE(1,2),U,4)=ASUP("CKI"),$P(^ASUSITE(1,0),U,4)=ASUP("IVR") Q
SETSM ;EP ;MTHLY
 S $P(^ASUSITE(1,2),U,5)=ASUP("CKM") Q
SETSX ;EP ;RPTXTR
 S $P(^ASUSITE(1,2),U,10)=ASUP("CKX") Q
SETSY ;EP ;YR
 S $P(^ASUSITE(1,2),U,6)=ASUP("CKY") Q
SETTY ;EP ;TYP
 S $P(^ASUSITE(1,0),U,2)=ASUP("TYP")
 S (ASUP("STR"),ASUP("STS"),ASUP("IVR"))="N"
SETS ;EP ;
 F ASUP("LOOP")="3;STR","4;IVR","5;STS" D
 .S $P(^ASUSITE(1,0),U,$P(ASUP("LOOP"),";"))=ASUP($P(ASUP("LOOP"),";",2))
 Q
SETSTA ;EP ;STAT
 S $P(^ASUSITE(1,0),U,5)=ASUP("STS") Q
SETLD ;EP ;LAST UPDATE
 S $P(^ASUSITE(1,0),U,13)=ASUP("LSDT") Q
SETLM ;EP ;LAST MTH
 S $P(^ASUSITE(1,0),U,14)=ASUP("LSMO") Q
SETLY ;EP ; LAST YR
 S $P(^ASUSITE(1,0),U,15)=ASUP("LSYR") Q
SETSTAT ;EP ;
 F ASUP("LOOP")="1;CKP","2;CKT","3;CKS","4;CKI","5;CKM","6;CKY","10;CKX" D
 .S $P(^ASUSITE(1,2),U,$P(ASUP("LOOP"),";"))=ASUP($P(ASUP("LOOP"),";",2))
 D SETS I $G(ASUP("HLT"))=1 Q
 S ASUP("LSDT")=ASUK("DT","FM")
 F ASUP("LOOP")="13;LSDT","14;LSMO","15;LSYR" D
 .S $P(^ASUSITE(1,0),U,$P(ASUP("LOOP"),";"))=ASUP($P(ASUP("LOOP"),";",2))
 Q
