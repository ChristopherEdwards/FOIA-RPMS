LA7CSHL ;ihs/cmi/maw - Send outbound ambulatory or public health message ; 22-Oct-2013 09:22 ; MAW
 ;;5.2;BLR IHS REFERENCE LAB;**1033**;NOV 01, 1997
 ;
MAIN ;-- this is the main routine driver
 S ACC=$$ACC()
 Q:'ACC
 I '$O(^LRO(68,"C",ACC,0)) D  Q
 . W !,"Accession not on file"
 D GET(ACC)
 D UYEXPORT^BLRCCPED(ACC)  ;mark as exported
 K LA76249
 Q
 ;
ACC() ;-- ask for the accession
 S DIR(0)="F0^1:10",DIR("A")="Please enter the UID"
 D ^DIR
 Q:$D(DIRUT) ""
 Q $G(Y)
 ;
GET(AC) ;-- get the data needed for the call
 ;need LRAA,LRAD,LRAN,LRIDT,LRSS,LRDFN,LRSPEC, array of tests
 N LA7RT,LDA,CNT,AA,AD,AN,LDFN,IDT,SPEC,SB,SAMP
 S CNT=1
 S LA7RT=$Q(^LRO(68,"C",AC))
 S AA=$QS(LA7RT,4)
 S AD=$QS(LA7RT,5)
 S AN=$QS(LA7RT,6)
 S LDFN=$P($G(^LRO(68,AA,1,AD,1,AN,0)),U)
 S IDT=$P($G(^LRO(68,AA,1,AD,1,AN,3)),U,5)
 S SPEC=$P($G(^LR(LDFN,"CH",IDT,0)),U,5)
 S SAMP=$$SAMP(AA,AD,AN,SPEC)
 S LDA=0 F  S LDA=$O(^LR(LDFN,"CH",IDT,LDA)) Q:'LDA  D
 . S SB(CNT)=LDA
 . S CNT=CNT+1
 D QUEMU2^LA7CHDR(AC,AA,AD,AN,IDT,"",LDFN,SPEC,SAMP,.SB)
 N LA7DIR,LA7FILE
 S LA7DIR=$P($G(^BLRSITE(DUZ(2),"RL")),U,5)
 I $G(LA7DIR)="" S LA7DIR=$P($G(^XTV(8989.3,DUZ(2),"DEV")),U)
 I $G(LA7DIR)="" W !,"No Export Directory Set" H 3 Q
 ;S LA7DIR="e:\ehr\temp\"
 ;S LA7DIR="Q:\reflab\"
 S LA7FILE="RefLabExport"_AC_DT_LA76249_".txt"
 D WRITE(LA76249,LA7DIR,LA7FILE)
 W !,"Message exported to "_LA7DIR_LA7FILE H 2
 Q
 ;
SAMP(A,D,N,SPC) ;-- get collection sample
 N SAM,SDA
 S SAM=""
 S SDA=0 F  S SDA=$O(^LRO(68,A,1,D,1,N,5,SDA)) Q:'SDA!($G(SAM))  D
 . I $P($G(^LRO(68,A,1,D,1,N,5,SDA,0)),U)=SPC D  Q
 .. S SAM=$P($G(^LRO(68,A,1,D,1,N,5,SDA,0)),U,2)
 Q SAM
 ;
WRITE(LA76249,DIR,FILE) ;-- write out the file
 S Y=$$OPEN^%ZISH(DIR,FILE,"W")
 N BDA,SEG,SEGA
 S SEG="",SEGA=""
 S BDA=0 F  S BDA=$O(^LAHM(62.49,LA76249,150,BDA)) Q:'BDA  D
 . S SEG=$G(^LAHM(62.49,LA76249,150,BDA,0))
 . I SEG="" D  Q
 . .I SEGA]"" U IO W SEGA,!
 . .S SEGA=""
 . S SEGA=SEGA_SEG
 D ^%ZISC
 Q
 ;
