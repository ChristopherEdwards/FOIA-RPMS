ACGS2 ;IHS/OIRM/DSD/THL,AEF - INPUT TRANSFORM FOR CONTRACT NUMBER; [ 03/27/2000   2:22 PM ]
 ;;2.0t1;CONTRACT INFORMATION SYSTEM;;FEB 16, 2000
 ;;ROUTINE TO CHECK THE INTEGRITY OF THE CONTRACT NUMBER
2 ;EP;INPUT TRANSFORM FOR CONTRACT NUMBER
 S:'$D(ACG4) ACG4=$P(^ACGPARA(ACGPODA,0),U,3)
 S ACG1=+^ACGS(DA,"DT")
 I 'ACG1 D TPA Q
 I '$D(^ACGTPA(ACG1,0)) D TPA Q
 S ACG1=$P(^ACGTPA(ACG1,0),U)
 I $E(ACG1)="P" W !!,"For 'P' actions use the appropriate PURCHASE ORDER number." Q
 I ACG1="G" D  Q
 .I $E(X)="G" D  Q
 ..I $E(X,1,2)'="GS" W !!,"Positions 1 & 2 of GSA contract number must be 'GS'." K X Q
 ..I $E(X,3,4)'?2N W !!,"Positions 3 & 4 of GSA contract number must be numeric." K X Q
 ..I "FK"'[$E(X,5) W !!,"Position 5 of GSA contract number must be 'F' or 'K'." K X Q
 ..I $E(X,5)="F",$L(X)'=10 W !!,"If position 5 of GSA contract number is 'F' the GSA contract number must be 10",!,"characters in length." K X Q
 ..I $E(X,5)="K",$L(X)'=14!($E(X,10)'="S") W !!,"If position 5 of GSA contract number is 'K' the GSA contract number must be 14",!,"characters in length and the 10th position must be an 'S'." K X Q
 .I $E(X)="V" Q
 .E  W !!,"You must enter the GSA or VA contract number for the Federal Supply Contract." K X Q
 I $E(ACG1)'="P" D  Q
 .I "OG"'[ACG1,$D(^ACGS("B",X)) W !!,"This contract number has already been assigned and duplicate numbers are not",!,"allowed." K X Q
 .I $E(X,1,3)'=ACG4 W !!,"The first 3 characters must be the same as the contract office number." K X Q
 .I X'?12N W !!,"The contract number must be 12 numeric characters in length." K X Q
 .I "ADILS"[ACG1,$E(X,10,12)'="000" W !!,"If Type of Procurement Action is A, D, I, L or S, positions 10-12 of the",!,"contract number must be '000'." K X Q
 .I "ADILS"'[ACG1,+$E(X,10,12)'>0 W !!,"If Type of Procurement Action is not A, D, I, L or S, positions 10-12 of the",!,"contract number must be greater than '000'." K X Q
 Q
TPA ;TPA MESSAGE
 W !!,"Enter the TYPE OF PROCUREMENT ACTION before entering the contract number." K X
 Q
