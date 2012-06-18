APCDEFP ; IHS/CMI/LAB - APCD Auto Print PCC Encounter Form ;
 ;;2.0;IHS PCC SUITE;**4**;MAY 14, 2009
 ;
 ;This routine will print out an automated PCC encounter form for
 ;a particular visit.
 ;
 ;
MAIN ;EP -- loop through temp and print out the data
 S APCDIOSL=IOSL
 S APCDLN="",$P(APCDLN,"-",79)="-"
 S APCLSTAR="",$P(APCLSTAR,"*",79)="*"
 S APCLUS="",$P(APCLUS,"_",79)="_"
 S APCDFF="I $Y>(IOSL-5) D FF^APCDEFU Q:APCDQ"
 D HEAD^APCDEFU
 I '$D(^XTMP(APCDJ,APCDH,"APCDEF")) W !!,"No visit information" Q
 D PRT
 D FOOT^APCDEFU
 D DONE^APCDEFU
 Q
 ;
PRT ;-- loop through and write the data     
 I APCDVCC]"" W !,"Chief Complaint: ",APCDVCC W !,APCDLN
 I APCDVFLG]""!(APCDVDP]"") W !,"Flag: ",APCDVFLG,?40,"Disposition: ",APCDVDP W !,APCDLN
 ;
 S APCDPDA=0 F  S APCDPDA=$O(@APCDATMP@(APCDPDA)) Q:'APCDPDA!($G(APCDQ))  D
 . S APCDPDFN=0 F  S APCDPDFN=$O(@APCDATMP@(APCDPDA,APCDPDFN)) Q:APCDPDFN=""!($G(APCDQ))  D
 .. S APCDP="W"_APCDPDFN
 .. Q:$T(@APCDP)=""
 .. D @APCDP
 .. Q:$G(APCDQ)
 Q
 ;
WVMSR ;-- write out v measurement
 X APCDFF
 S APCDPC=3,APCDC=0
 W !,"Measurements",!
 S APCDIEN="" F  S APCDIEN=$O(APCDMSR(APCDIEN)) Q:APCDIEN=""  D
 . S APCDTA=$P(APCDMSR(APCDIEN),U,1)
 . I APCDTA="AUD" W !?3,APCDTA_":"_$P($G(APCDMSR(APCDIEN)),U,2) S APCDPC=3,APCDC=0 Q
 . S APCDC=APCDC+1
 . I APCDC=1 W !
 . W ?APCDPC,APCDTA_": "_$S($L(APCDTA)=2:" ",1:"")_$P($G(APCDMSR(APCDIEN)),U,2) S J=$P(APCDMSR(APCDIEN),U,3) F I=1:1 S P=$P(J,"|",I) Q:P=""  W "  ",P
 . S APCDPC=APCDPC+40
 . I APCDC=2 S APCDC=0,APCDPC=3
 K APCDMSR,APCDT,APCDV,APCDPC
 W !,APCDLN
 Q
 ;
WVXAM ;-- write out v exam
 X APCDFF
 W !,"Examinations",!
 S APCDTA=0 F  S APCDTA=$O(APCDXAM(APCDTA)) Q:APCDTA=""  D
 . W !?3,APCDTA
 . I APCDXAM(APCDTA)]"" W ?35,"result: ",APCDXAM(APCDTA)
 K APCDXAM,APCDT,APCDV
 W !,APCDLN
 Q
 ;
WVPOV ;-- write out v pov
 X APCDFF
 W !,"Purpose of Visit",!
 S APCDTA=0 F  S APCDTA=$O(APCDPOV(APCDTA)) Q:APCDTA=""  D
 . W !?3,$P(APCDPOV(APCDTA),U,2),?60,$P($G(APCDPOV(APCDTA)),U,1)
 . I $P(APCDPOV(APCDTA),U,3)]"" W !?5,"Stage: ",$P(APCDPOV(APCDTA),U,3)
 . I $P(APCDPOV(APCDTA),U,4)]""!($P(APCDPOV(APCDTA),U,5)]"") W !?5,"Modifier: ",$P(APCDPOV(APCDTA),U,4),?45,"Cause of DX: ",$P(APCDPOV(APCDTA),U,5)
 . I $P(APCDPOV(APCDTA),U,6)]""!($P(APCDPOV(APCDTA),U,9)]"")!($P(APCDPOV(APCDTA),U,10)]"") W !?5,"E Code: ",$P(APCDPOV(APCDTA),U,6),?30,"E Code: ",$P(APCDPOV(APCDTA),U,9),?60,"E Code: ",$P(APCDPOV(APCDTA),U,10)
 . I $P(APCDPOV(APCDTA),U,11)]""!($P(APCDPOV(APCDTA),U,8)]"") W !?5,"Place of Occurence: ",$P(APCDPOV(APCDTA),U,11),?45,"Date of Injury: ",$P(APCDPOV(APCDTA),U,8)
 K APCDPOV,APCDTA
 W !,APCDLN
 Q
 ;
WVMED ;-- write out vmed
 X APCDFF
 W !,"Medications Prescribed",?30,"Sig",?68,"Qty",?76,"Days",!
 S APCDTA=0 F  S APCDTA=$O(APCDMED(APCDTA)) Q:APCDTA=""  D
 . S APCDTSIG=$P(APCDMED(APCDTA),U)
 . S APCDTQTY=$P(APCDMED(APCDTA),U,2)
 . S APCDTDP=$P(APCDMED(APCDTA),U,3)
 . W !,$E(APCDTA,1,28),?30,$E(APCDTSIG,1,35),?68,APCDTQTY,?76,APCDTDP
 K APCDMED,APCDSIG,APCDQTY,APCDDP,APCDTA,APCDTSIG,APCDTQTY,APCDTDP
 W !,APCDLN
 Q
 ;
WVEYE ;-- write out v eye
 X APCDFF
 W !,"Eye Glass",!
 W !,"Reading Only: ",APCDRO
 W ?22,"DRE Sphere: ",APCDRES
 W ?43,"DRE Cylinder: ",APCDREC
 W ?58,"DRE Axis: ",APCDREA
 W !,"DLE Sphere: ",APCDLES
 W ?22,"DLE Cylinder: ",APCDLEC
 W ?43,"DLE Axis: ",APCDLEA
 W ?58,"Reading Add R: ",APCDRAR
 W !,"Reading Add L: ",APCDRAL
 W ?22,"Eye Size: ",APCDES
 W ?43,"Bridge: ",APCDBR
 W ?58,"Temple: ",APCDTM
 W !,"Pupil Distance Near: ",APCDPDN
 W ?30,"Pupil Distance Far: ",APCDPDF
 K APCDRO,APCDRES,APCDREC,APCDREA,APCDLES,APCDLEC,APCDLEA,APCDRAR
 K APCDRAL,APCDES,APCDBR,APCDTM,APCDPDN,APCDPDF
 W !,APCDLN
 Q
 ;
WVDEN ;-- write out v dental
 X APCDFF
 W !,"Dental",!
 S APCDTA=0 F  S APCDTA=$O(APCDDEN(APCDTA)) Q:APCDTA=""  D
 . S APCDTNOU=$P(APCDDEN(APCDTA),U)
 . S APCDTOS=$P(APCDDEN(APCDTA),U,2)
 . S APCDTDTS=$P(APCDDEN(APCDTA),U,3)
 . W !,"Ada Code: ",APCDTA
 . W ?20,"Number of Units: ",APCDTNOU
 . I APCDTOS]"" W !,"Operative Site: ",APCDTOS
 . I APCDTDTS]"" W ?55,"Tooth Surface: ",APCDTDTS
 K APCDADA,APCDNOU,APCDOS,APCDTS,APCDTA,APCDTNOU,APCDTOS,APCDTDTS
 W !,APCDLN
 Q
 ;
WVPRC ;-- write out v procedure
 X APCDFF
 W !,"Procedures",!
 S APCDTA=0 F  S APCDTA=$O(APCDPRC(APCDTA)) Q:APCDTA=""  D
 . S APCDTPRN=$P(APCDPRC(APCDTA),U)
 . S APCDTPDT=$P(APCDPRC(APCDTA),U,2)
 . W !,"Procedure: ",APCDTA
 . W ?51,"Procedure Date: ",APCDTPDT
 . W !,"Provider Narrative: ",APCDTPRN
 K APCDPRC,APCDPRN,APCDPDT,APCDTA,APCDTPRN,APCDTPDT
 W !,APCDLN
 Q
 ;
WVLAB ;-- write out v lab
 X APCDFF
 W !,"Laboratory Tests",!
 S APCDTA=0 F  S APCDTA=$O(APCDLAB(APCDTA)) Q:APCDTA=""  D
 . S APCDTRES=$P(APCDLAB(APCDTA),U)
 . S APCDTABN=$P(APCDLAB(APCDTA),U,2)
 . W !,"Lab Test: ",APCDTA
 . W ?50,"Result: ",APCDTRES
 . W ?70,$S($G(APCDTABN):"Abnormal",1:"")
 K APCDLAB,APCDRES,APCDABN,APCDTA,APCDTRES,APCDTABN
 W !,APCDLN
 Q
 ;
WVIMM ;-- write out v immunization
 X APCDFF
 W !,"Immunizations",!
 S APCDTA=0 F  S APCDTA=$O(APCDIMM(APCDTA)) Q:APCDTA=""  D
 . S APCDTSER=$P(APCDIMM(APCDTA),U)
 . S APCDTLOT=$P(APCDIMM(APCDTA),U,2)
 . S APCDTREA=$P(APCDIMM(APCDTA),U,3)
 . S APCDDOSE=$P(APCDIMM(APCDTA),U,4)
 . S APCDINJ=$P(APCDIMM(APCDTA),U,5)
 . S APCDVOL=$P(APCDIMM(APCDTA),U,6)
 . S APCDVDAT=$P(APCDIMM(APCDTA),U,7)
 . W !?3,"Immunization: ",APCDTA
 . W ?60,"Series: ",APCDTSER
 . I APCDTLOT]""!(APCDTREA]"") W !?3,"Lot: ",APCDTLOT,?30,"Reaction: ",APCDTREA
 . I APCDDOSE]""!(APCDINJ]"") D
 . . W !?3,"Dose Override: ",APCDDOSE,?40,"Injection Site: ",APCDINJ
 . I APCDVOL]""!(APCDVDAT]"") D
 . . W !?3,"Volume: ",APCDVOL I APCDVDAT]"" W ?20,"Date of Vaccine Information Statement: ",APCDVDAT
 K APCDIMM,APCDSER,APCDLOT,APCDREA,APCDTSER,APCDTA,APCDTLOT,APCDTREA,APCDVDAT,APCDVOL,APCDDOSE,APCDINJ
 W !,APCDLN
 Q
 ;
WVSK ;-- write out v skin test
 X APCDFF
 D WVSK^APCDEFP1
 Q
 ;
WVTRT ;-- write out v treatment
 X APCDFF
 D WVTRT^APCDEFP1
 Q
 ;
WVPED ;-- write out v patient education
 X APCDFF
 D WVPED^APCDEFP1
 Q
 ;
WVPT ;-- write out v physical therapy
 X APCDFF
 D WVPT^APCDEFP1
 Q
 ;
WVACT ;-- write out v activity time
 X APCDFF
 D WVACT^APCDEFP1
 Q
 ;
WVDXP ;-- write out v diagnostic procedure result
 X APCDFF
 D WVDXP^APCDEFP1
 Q
 ;
WVRAD ;-- write out v radiology
 X APCDFF
 D WVRAD^APCDEFP1
 Q
 ;
WVHF ;-- write out v health factors
 X APCDFF
 D WVHF^APCDEFP1
 Q
 ;
WVMIC ;-- write out v microbiology
 X APCDFF
 D WVMIC^APCDEFP1
 Q
 ;
WVBB ;-- write out v blood bank
 X APCDFF
 D WVBB^APCDEFP1
 Q
 ;
WVPHN ;-- write out v public health nurse
 X APCDFF
 D WVPHN^APCDEFP1
 Q
 ;
WVNT ;-- write out v narrative text
 X APCDFF
 D WVNT^APCDEFP1
 Q
 ;
WVCPT ;-- write out v cpt
 X APCDFF
 D WVCPT^APCDEFP1
 Q
 ;
WVIF ;-- write out infant feeding
 X APCDFF
 D WVIF^APCDEFP1
 Q
