DGMTDD1 ;ALB/MIR,JAN,AEG - DD calls from income screening files ; Jan 8, 2001
 ;;5.3;Registration;**180,313,345,401**;Aug 13, 1993
 ;
 ; This routine contains miscellaneous input transform and other DD
 ; calls from income screening files.
 ;
 ;
SSN ; called from the input transform of the SSN field in file 408.13
 N %,L,DGN,DGPAT,PATNAME,PREVX,KANS
 I X'?9N&(X'?3N1"-"2N1"-"4N) W !,"Response must be either nine numbers or in the format nnn-nn-nnnn!",!,"No pseudo SSNs allowed for relations."
 I X'?.AN F %=1:1:$L(X) I $E(X,%)?1P S X=$E(X,0,%-1)_$E(X,%+1,999),%=%-1
 I X'?9N K X Q
 I $D(X) S L=$E(X,1) I L=9 W !,*7,"The SSN must not begin with 9." K X Q
 I $D(X),$E(X,1,3)="000" W !,*7,"First three digits cannot be zeros." K X Q
 ;
 ; warning if the spouse's/dependent's SSN is found in the PATIENT file
 ; and spouse/dependent is not a veteran.  spouse/dependent is a veteran
 ; if name, sex, DOB match.
 ;
 ; input (OPTIONAL)
 ;    ANS(.01) = NAME,  ANS(.02) = SEX,  ANS(.03) = DOB
 ;
 ; if newly entered values (those not yet committed to dbase) not 
 ; supplied then pull current detail from the Person Income file
 ; (#408.13) for this dependent.
 I '$G(ANS(.01)),'$G(ANS(.02)),'$G(ANS(.03)) D
 . N REC,FLD
 . D GETS^DIQ(408.13,DA,".01;.02;.03","I","REC")
 . F FLD=".01",".02",".03" S ANS(FLD)=REC(408.13,DA_",",FLD,"I")
 . S KANS=1
 E  S KANS=0
 ;
 S DGN=$O(^DPT("SSN",X,0)) G:'DGN SSDEP S DGPAT=$G(^DPT(DGN,0))
 I $P(DGPAT,"^",3)=ANS(.03),($P(DGPAT,"^",2)=ANS(.02)),($P(DGPAT,"^")=ANS(.01)) G SSDEP
 S PATNAME=$P(DGPAT,"^") D WARN Q
 ;
SSDEP ; warning if spouse's/dependent's SSN is found in file 408.13 and
 ; name, sex, DOB don't match
 S DGN=$O(^DGPR(408.13,"SSN",X,0)) G:'DGN SSNQ S DGPAT=$G(^DGPR(408.13,DGN,0))
 I $P(DGPAT,"^",3)=ANS(.03),($P(DGPAT,"^",2)=ANS(.02)),($P(DGPAT,"^")=ANS(.01)) G SSNQ
 S PATNAME=$P($G(^DGPR(408.13,DGN,0)),"^") D WARN Q
 ;
SSNQ K:KANS ANS Q
 ;
 ;
 ;
WARN ; printed WARNING message to alert user that spouse/dependent SSN be
 ; that of a veteran in Patient/Income Person File.
 W !,*7,"Warning - ",X," belongs to patient ",PATNAME
 K DIR S PREVX=X,DIR(0)="YA",DIR("A")="Are you sure this is the correct SSN? ",DIR("B")="YES" D ^DIR
 I Y=1 S X=PREVX K PREVX,DIR("B") Q
 E  K DIR("B"),X Q
 ;
REL ; called from the input transform of the RELATIONSHIP field of file 408.12...sets DIC("S")
 N DGNODE,DGX,SEX
 S DGNODE=$G(^DGPR(408.12,DA,0)),DGX=$P(DGNODE,"^",2) Q:'DGNODE
 I DGX,(DGX<3) S DIC("S")="I Y="_DGX Q
 S DGX=$P(DGNODE,"^",3),SEX=$P($G(@("^"_$P(DGX,";",2)_+DGX_",0)")),"^",2)
 S DIC("S")="I Y>2,(""E"_SEX_"""[$P(^(0),""^"",3))"
 I $D(DGTYPE),DGTYPE="C" S DIC("S")=DIC("S")_",(Y<7)"
 Q
