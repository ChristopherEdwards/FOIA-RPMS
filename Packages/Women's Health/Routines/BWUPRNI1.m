BWUPRNI1 ;IHS/ANMC/MWR - UPLOAD: RESULTS FROM CORNING;15-Feb-2003 22:13;PLS
 ;;2.0;WOMEN'S HEALTH;**8**;MAY 16, 1996
 ;;* MICHAEL REMILLARD, DDS * ALASKA NATIVE MEDICAL CENTER *
 ;;  FORMATS TEXT OF RESULTS REPORT INTO LOCAL ARRAY.
 ;;  CALLED BY BWUPRNI.
 ;
 ;
 ;---> CALLED BY BWUPRNI.  PUTS ENTIRE TEXT OF RESULTS REPORT INTO
 ;---> BW1(N) LOCAL ARRAY, FORMATTED.
 ;---> REQUIRED VARIABLES: BWY=IEN IN NICHOL'S TEMP FILE.
 ;
FORMAT(BWY) ;EP
 Q:'BWY
 N I,X,Y,Z K BW1
 ;---> SET DATA NODES (0,1,2) FOR THIS LAB REPORT EQUAL TO X,Y,Z.
 S X=^BWRNI(BWY,0),Y=^BWRNI(BWY,1),Z=^BWRNI(BWY,2)
 ;
 S BW1(1)="CORNING Clinical Laboratories                SSN: "_$P(X,U,3)
 S BW1(2)="16 Concord Street"
 S BW1(3)="El Paso, Texas 79906                     Patient: "_$P(X,U,2)
 S BW1(4)="915/775-2622 or 800/999-7284              Chart#: "_$P(X,U,7)
 S BW1(5)="Account No. "_$P(X,U,9)
 S BW1(5)=BW1(5)_$E("                      ",1,(22-$L($P(X,U,9))))
 S BW1(5)=BW1(5)_"Date Collected: "_$P(X,U,11)
 S BW1(6)=" "
 S BW1(7)="Accession#: "_$P(X,U)
 S BW1(7)=BW1(7)_$E("                           ",1,(27-$L($P(X,U))))
 S BW1(7)=BW1(7)_"Req/ID No: "_$P(X,U,4)
 S BW1(8)="Physician : "_$P(X,U,8)
 S BW1(8)=BW1(8)_$E("                            ",1,(28-$L($P(X,U,8))))
 S BW1(8)=BW1(8)_"Location: "_$P(X,U,12)
 S BW1(9)="------------------------------------------------------------"
 S BW1(10)="TEST NAME NOT REPORTED BY LAB."
 S:$P(X,U,10)]"" BW1(10)=$P(X,U,10)
 S I=12
 S BW1(I)="Source",I=I+1
 S BWABBVS=$P(Y,U) D GETEXT
 S BW1(I)="Specimen Adequacy",I=I+1
 S BWABBVS=$P(Y,U,2) D GETEXT
 S BW1(I)="Gen Categorization",I=I+1
 S BWABBVS=$P(Y,U,3) D GETEXT
 S BW1(I)="Descript Diagnosis",I=I+1
 I $P(Y,U,4)]"" S BWABBVS=$P(Y,U,4) D GETEXT
 I $P(Y,U,5)]""!($P(Y,U,6)]"") D
 .S BW1(I)="  Epithelial Abnormalities",I=I+1
 .I $P(Y,U,5)]"" D
 ..S BW1(I)="    Squamous Cells",I=I+1
 ..S BWABBVS=$P(Y,U,5) D GETEXT
 .I $P(Y,U,6)]"" D
 ..S BW1(I)="    Glandular Cells",I=I+1
 ..S BWABBVS=$P(Y,U,6) D GETEXT
 I $P(Z,U)]"" D
 .S BW1(I)="  React/Reparative",I=I+1
 .S BWABBVS=$P(Z,U) D GETEXT
 I $P(Z,U,2)]"" D
 .S BW1(I)="  Infection",I=I+1
 .S BWABBVS=$P(Z,U,2) D GETEXT
 I $P(Z,U,3)]"" D
 .S BW1(I)="  Infection Notation",I=I+1
 .S BWABBVS=$P(Z,U,3) D GETEXT
 I $P(Z,U,4)]"" D
 .S BW1(I)="Hormonal Evaluation",I=I+1
 .S BWABBVS=$P(Z,U,4) D GETEXT
 I $P(Z,U,5)]"" D
 .S BW1(I)="Hormonal Eval Notation",I=I+1
 .S BWABBVS=$P(Z,U,5) D GETEXT
 I $P(Z,U,6)]"" D
 .S BW1(I)="Comment",I=I+1
 .S BWABBVS=$P(Z,U,6) D GETEXT
 S BW1(I)=" ",I=I+1
 I $P(Z,U,7)]"" S BW1(I)="Reviewer:  "_$P(Z,U,7),I=I+1
 Q
 ;
GETEXT ;EP
 N J,N,Y
 I BWABBVS="" S BW1(I)=BWTAB_"Not reported by lab." Q
 F J=2:1:10 S BWABBV=$P(BWABBVS,"\",J) D
 .Q:BWABBV=""
 .S Y=$O(^BWTFNI("B",BWABBV,0))
 .I Y="" D  Q
 ..S BW1(I)=BWTAB_"The abbreviation "_BWABBV_" is not in the ",I=I+1
 ..S BW1(I)=BWTAB_"""BW LAB TABLE"" file.  Contact your site manager."
 ..S I=I+1
 .S N=0
 .F  S N=$O(^BWTFNI(Y,1,N)) Q:'N  D
 ..S BW1(I)=BWTAB_^BWTFNI(Y,1,N,0),I=I+1
 Q
