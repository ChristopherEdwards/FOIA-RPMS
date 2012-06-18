SROAPRT6 ;BIR/MAM - PRINT OUTCOME INFO ; [ 08/25/99  1:18 PM ]
 ;;3.0; Surgery ;**38,47,88**;24 Jun 93
 K SRA S SRA(34)=$G(^SRF(SRTN,34)),X=$P(SRA(34),"^",2) S:X X=$P(^ICD9(X,0),"^")_"  "_$P(^(0),"^",3) S SRAO(1)=X_"^66"
 S SRA(205)=$G(^SRF(SRTN,205)),X=$P(SRA(205),"^") I X'="" S X=$S(X="NA":"NA",1:X_" DAYS")
 S SRAO(2)=X_"^247"
 S Y=$P($G(^DPT(DFN,.35)),"^"),SRDEAD=Y I Y D D^DIQ S SRDEAD=Y
 S SRAO(3)=SRDEAD,NYUK="N",SRET=0 K SRCPT
 F  S SRET=$O(^SRF(SRTN,29,SRET)) Q:'SRET  S CASE=$P(^SRF(SRTN,29,SRET,0),"^"),SRC=$P($G(^SRF(CASE,"OP")),"^",2) I $P($G(^SRF(CASE,.2)),"^",10),SRC D
 .S Y=$P($$CPT^ICPTCOD(SRC),"^",2) D MOD
 .S NYUK="Y",SRCPT(SRC)=Y
 S $P(^SRF(SRTN,205),"^",4)=NYUK D YN S SRAO(4)=SHEMP_"^262" F I="6A","6B","6C","6D","6E","6F","7A","7B","7C","7D","7E","7F" S SRAO(I)=""
DISP ;
 W !,?27,"OUTCOME INFORMATION"
 W !!,$J("Postoperative Diagnosis Code (ICD9): ",39)_$P(SRAO(1),"^"),!,$J("Length of Postoperative Hospital Stay: ",39)_$P(SRAO(2),"^")
 W !,$J("Date of Death: ",39)_$P(SRAO(3),"^")
 I SRAO(3)'="" S X1=$P(^SRF(SRTN,0),"^",9),X2=90 D C^%DTC D
 .I $P($G(^DPT(DFN,.35)),"^")'>X W !,$J("Death Unrelated/Related: ",39)_$S($P($G(^SRF(SRTN,.4)),"^",7)="R":"RELATED",$P($G(^SRF(SRTN,.4)),"^",7)="U":"UNRELATED",1:"")
 .I $P($G(^DPT(DFN,.35)),"^")>X W !,$J("Death Unrelated/Related: ",39)_"N/A"
 W !,$J("Return to OR Within 30 Days: ",39)_$P(SRAO(4),"^")
 D RET W:$E(IOST)="P" ! I $Y+24>IOSL D PAGE^SROAPAS I SRSOUT Q
 D ^SROAPRT7
 Q
MOD ;; append CPT modifiers to CPT code
 N SRTN S SRTN=CASE D SSPRIN^SROCPT
 Q
YN ;
 S SHEMP=$S(NYUK="NS":"NS",NYUK="N":"NO",NYUK="Y":"YES",1:"")
 Q
RET ; print returns
 S X=0 F  S X=$O(SRCPT(X)) Q:'X  W !,?15,"CPT Code: "_SRCPT(X)
 Q
