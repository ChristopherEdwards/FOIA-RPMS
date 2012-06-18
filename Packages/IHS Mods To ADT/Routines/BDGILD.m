BDGILD ; IHS/ANMC/LJF - INPT LISTS BY DATE ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
REPORT ; -- choose which report to print
 NEW BDGRPT,BDGA,X,Y,BDGQUIT,BDGDESC
 F X=1:1:9 S BDGA(X)=$J(X,3)_". "_$P($T(RPT+X),";;",2)
 S Y=$$READ^BDGF("NO^1:9","Choose Report from List","","","",.BDGA)
 Q:'Y  I Y=9 S XQH="BDG INPT LISTS BY DATE" D EN^XQH G REPORT
 S BDGRPT=$P($T(RPT+Y),";;",3),BDGDESC=$P($T(RPT+Y),";;",2)
 ;
 S BDGQUIT=0 K BDGSRT,BDGTYP,BDGMAX,BDGBD,BDGED,BDGINS
 D @Y I $G(BDGQUIT) D END Q  ;ask more questions based on report chosen
 ;
 S X=$$BROWSE^BDGF I X="B" D @BDGRPT,END Q
 I X=U Q
 ;
 D ZIS^BDGF("QP",BDGRPT,BDGDESC,"BDG*")
 ;
END ;
 D HOME^%ZIS
 K BDGTYP,BDGBD,BDGED,BDGSRT,BDGINS,BDGMAX
 Q
 ;
1 ; admissions questions
 NEW X
 ; set BDGBD and BDGED variables
 D DATES Q:BDGQUIT
 ;
 ; set sort criteria
 S X="1:By DATE Only;2:By WARD;3:By SERVICE;4:By ADMITTING Provider;5:By Provider's SERVICE;6:By Community;7:By Service Unit;8:By Patient Name"
 S BDGTYP=$$READ^BDGF("SO^"_X,"Select Admission Report to Run")
 I BDGTYP<1 S BDGQUIT=1 Q
 ;
 ; set sort range
 S X=$S(BDGTYP=2:"WARD",BDGTYP=3:"SERV",BDGTYP=4:"PROV",BDGTYP=5:"PRVSV",BDGTYP=6:"COMM",BDGTYP=7:"SU",1:"") I X]"" D @X
 ;
 S BDGINS=$$READ^BDGF("Y","Include Insurance Coverage on Report","NO")
 I BDGINS=U S BDGQUIT=1 Q
 ;
 Q
 ;
2 ; readmission questions
 NEW X
 W !!,"This includes admissions after release from Day Surgery.",!
 ;
 ; set BDGBD and BDGED variables
 D DATES Q:BDGQUIT
 ;
 ; set sort criteria
 S X="1:By DATE Only;2:By WARD;3:By SERVICE;4:By ADMITTING Provider;5:By Provider's SERVICE;6:BY Community;7:By Service Unit;8:By Patient Name"
 S BDGTYP=$$READ^BDGF("SO^"_X,"Select Readmission Report to Run")
 I BDGTYP<1 S BDGQUIT=1 Q
 ;
 ; set sort range
 S X=$S(BDGTYP=2:"WARD",BDGTYP=3:"SERV",BDGTYP=4:"PROV",BDGTYP=5:"PRVSV",BDGTYP=6:"COMM",BDGTYP=7:"SU",1:"") I X]"" D @X
 ;
 ; set BDGMAX variable
 S BDGMAX=$$READ^BDGF("N^1:365","MAXIMUM # of Days between admissions")
 I BDGMAX<1 S BDGQUIT=1
 ;
 S BDGINS=$$READ^BDGF("Y","Include Insurance Coverage on Report","NO")
 I BDGINS=U S BDGQUIT=1 Q
 Q
 ;
3 ; non-beneficiary admissions questions
 NEW X
 ; set BDGBD and BDGED variables
 D DATES Q:BDGQUIT
 ;
 ; set sort criteria
 S X="1:By DATE Only;2:By WARD;3:By SERVICE;4:By ADMITTING Provider;5:By Provider's SERVICE;6:By Community;7:By Service Unit;8:By Patient Name"
 S BDGTYP=$$READ^BDGF("SO^"_X,"Select Non-beneficiary Admission Report to Run")
 I BDGTYP<1 S BDGQUIT=1 Q
 ;
 ; set sort range
 S X=$S(BDGTYP=2:"WARD",BDGTYP=3:"SERV",BDGTYP=4:"PROV",BDGTYP=5:"PRVSV",BDGTYP=6:"COMM",BDGTYP=7:"SU",1:"") I X]"" D @X
 ;
 S BDGINS=$$READ^BDGF("Y","Include Insurance Coverage on Report","YES")
 I BDGINS=U S BDGQUIT=1 Q
 Q
 ;
4 ; IUC Transfer questions
 NEW X
 ; set BDGBD and BDGED variables
 D DATES Q:BDGQUIT
 ;
 S BDGTYP=$$READ^BDGF("SO^1:TRANSFERS to ICU;2:RETURNS to ICU","Select ICU Report to Run") I BDGTYP<1 S BDGQUIT=1 Q
 Q:BDGTYP=1
 ;
 ; set BDGMAX variable
 S BDGMAX=$$READ^BDGF("NO^1:30","MAXIMUM # of Days between ICU stays")
 I BDGMAX<1 S BDGQUIT=1
 Q
 ;
5 ; discharge questions
 NEW X
 ; set BDGBD and BDGED variables
 D DATES Q:BDGQUIT
 ;
 ; set sort criteria
 S X="1:By DATE Only;2:By WARD;3:By SERVICE;4:By ATTENDING Provider;5:By Provider's SERVICE;6:By Community;7:By Service Unit;8:By Patient Name"
 S BDGTYP=$$READ^BDGF("SO^"_X,"Select Discharges Report to Run")
 I BDGTYP<1 S BDGQUIT=1 Q
 ;
 ; set sort range
 S X=$S(BDGTYP=2:"WARD",BDGTYP=3:"SERV",BDGTYP=4:"PROV",BDGTYP=5:"PRVSV",BDGTYP=6:"COMM",BDGTYP=7:"SU",1:"") I X]"" D @X
 ;
 S BDGINS=$$READ^BDGF("Y","Include Insurance Coverage on Report","NO")
 I BDGINS=U S BDGQUIT=1
 Q
 ;
6 ; interfacility transfers quesions
 NEW X
 ; set BDGBD and BDGED variables
 D DATES Q:BDGQUIT=1
 ;
 S X="1:LISTING Only;2:STATISTICS Only;3:BOTH Listing and Stats"
 S BDGTYP=$$READ^BDGF("SO^"_X,"Select Report to Run")
 I BDGTYP<1 S BDGQUIT=1
 Q
 ;
7 ; inpatient deaths questions
 NEW X
 ; set BDGBD and BDGED variables
 D DATES Q:BDGQUIT
 ;
 ;set sort criteria
 S X="1:By DATE Only;2:By WARD;3:By SERVICE;4:By ATTENDING Provider;5:By Provider's SERVICE;6:By Community;7:By Service Unit;8:By Patient Name"
 S BDGTYP=$$READ^BDGF("SO^"_X,"Select Discharges Report to Run")
 I BDGTYP<1 S BDGQUIT=1 Q
 ;
 ; set sort range
 S X=$S(BDGTYP=2:"WARD",BDGTYP=3:"SERV",BDGTYP=4:"PROV",BDGTYP=5:"PRVSV",BDGTYP=6:"COMM",BDGTYP=7:"SU",1:"") I X]"" D @X
 ;
 S BDGINS=$$READ^BDGF("Y","Include Insurance Coverage on Report","YES")
 I BDGINS=U S BDGQUIT=1
 Q
 ;
8 ; los by discharge month questions
 D ^XBCLS W !!?10,"LENGTH OF STAY BY DISCHARGE MONTH AND WARD"
 W !!,"WARNING!!  This report takes a LONG time to run, no matter how"
 W !?11,"long a date range you select.  Please run after hours.",!!
 D DATES
 Q
 ;
DATES ; ask for date range   
 S BDGBD=$$READ^BDGF("DO^::EX","Select Beginning Date")
 I BDGBD<1 S BDGQUIT=1 Q
 S BDGED=$$READ^BDGF("DO^::EX","Select Ending Date")
 I BDGED<1 S BDGQUIT=1
 Q
 ;
WARD ; ask ward questions
 NEW Y,X
 S Y=$$READ^BDGF("YO","Print for ALL Wards","NO") I Y=U S BDGQUIT=1 Q
 I Y=1 S BDGSRT="A" Q
 S Y=1 F  Q:Y<1  D
 . S X="Select "_$S($D(BDGSRT):"Another ",1:"")_"Ward Name"
 . S Y=$$READ^BDGF("PO^42:EMQZ",X,"","","I $$ACTWD^BDGPAR(+Y)")
 . I Y>0 S BDGSRT(+Y)=$P(Y,U,2)
 I '$D(BDGSRT) S BDGQUIT=1
 Q
 ;
SERV ; ask service questions
 NEW Y,X
 S Y=$$READ^BDGF("YO","Print for ALL Treating Specialties","NO")
 I Y=U S BDGQUIT=1 Q
 I Y=1 S BDGSRT="A" D  Q
 . S Y=$$READ^BDGF("S^1:Inpatient Services Only;2:Observations Only;3:Both","Select Service Type","Both") S $P(BDGSRT,U,2)=Y
 S Y=1 F  Q:Y<1  D
 . S X="Select "_$S($D(BDGSRT):"Another ",1:"")_"Treating Specialty Name"
 . S Y=$$READ^BDGF("PO^45.7:EMQZ",X,"","","I $$ACTSRV^BDGPAR(+Y,BDGBD)")
 . I Y>0 S BDGSRT(+Y)=$P(Y,U,2)
 I '$D(BDGSRT) S BDGQUIT=1
 Q
 ;
PROV ; ask provider questions
 NEW Y,X
 S Y=$$READ^BDGF("YO","Print for ALL Providers","NO")
 I Y=U S BDGQUIT=1 Q
 I Y=1 S BDGSRT="A" Q
 S Y=1 F  Q:Y<1  D
 . S X="Select "_$S($D(BDGSRT):"Another ",1:"")_"Provider Name"
 . S Y=$$READ^BDGF("PO^200:EMQZ",X,"","","I $D(^XUSEC(""PROVIDER"",+Y))")
 . I Y>0 S BDGSRT(+Y)=$P(Y,U,2)
 I '$D(BDGSRT) S BDGQUIT=1
 Q
 ;
PRVSV ; ask provider's service questions
 NEW Y,X
 S Y=$$READ^BDGF("YO","Print for ALL Hospital Services","NO")
 I Y=U S BDGQUIT=1 Q
 I Y=1 S BDGSRT="A" Q
 S Y=1 F  Q:Y<1  D
 . S X="Select "_$S($D(BDGSRT):"Another ",1:"")_"Hospital Service Name"
 . S Y=$$READ^BDGF("PO^49:EMQZ",X,"","","I $P(^DIC(49,+Y,0),U,9)=""C""")
 . I Y>0 S BDGSRT(+Y)=$P(Y,U,2)
 I '$D(BDGSRT) S BDGQUIT=1
 Q
 ;
COMM ; ask user for community choices
 NEW Y,X
 S Y=$$READ^BDGF("YO","Print for ALL Communities","NO")
 I Y=U S BDGQUIT=1 Q
 I Y=1 S BDGSRT="A" Q
 S Y=1 F  Q:Y<1  D
 . S X="Select "_$S($D(BDGSRT):"Another ",1:"")_"Community Name"
 . S Y=$$READ^BDGF("PO^9999999.05:EMQZ",X)
 . I Y>0 S BDGSRT(+Y)=$P(Y,U,2)
 I '$D(BDGSRT) S BDGQUIT=1
 Q
 ;
SU ; ask user for service unit choices
 NEW Y,X
 S Y=$$READ^BDGF("YO","Print for ALL Service Units","NO")
 I Y=U S BDGQUIT=1 Q
 I Y=1 S BDGSRT="A" Q
 S Y=1 F  Q:Y<1  D
 . S X="Select "_$S($D(BDGSRT):"Another ",1:"")_"Service Unit Name"
 . S Y=$$READ^BDGF("PO^9999999.22:EMQZ",X)
 . I Y>0 S BDGSRT(+Y)=$P(Y,U,2)
 I '$D(BDGSRT) S BDGQUIT=1
 Q
 ;
RPT ;;
 ;;Admissions;;^BDGILD1;;
 ;;Readmissions;;^BDGILD2;;
 ;;Non-Beneficiary Admissions;;^BDGILD3;;
 ;;ICU Transfers;;^BDGILD4;;
 ;;Discharges;;^BDGILD5;;
 ;;Inter-Facility Transfers;;^BDGILD6;;
 ;;Inpatient Deaths;;^BDGILD7;;
 ;;LOS by Discharge Month & Ward;;^BDGLOS1;;
 ;;On-line Help (Report Descriptions);;
