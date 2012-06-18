BDGIPL ; IHS/ANMC/LJF - CURRENT INPT LISTS ;  [ 11/01/2002  4:09 PM ]
 ;;5.3;PIMS;**1007**;APR 26, 2002
 ;
 ;cmi/anch/maw 2/21/2007 added code to 3 PATCH 1007 item 1007.38
 ;cmi/anch/maw 2/22/2007 added code to REPORT to ask for # of copies PATCH 1007 item 1007.39
 ;cmi/anch/maw 2/22/2007 added code to 7 to ask for sort var BSDSRT patch 1007 item 1007.40
 ;
REPORT ; -- choose which report to print
 NEW BDGRPT,BDGA,X,Y,BDGQUIT,BDGDESC
 W !! F X=1:1:10 S BDGA(X)=$J(X,3)_". "_$P($T(RPT+X),";;",2)
 S Y=$$READ^BDGF("NO^1:10","Choose Report from List","","","",.BDGA)
 Q:'Y  I Y=10 S XQH="BDG INPT LISTS" D EN^XQH G REPORT
 S BDGRPT=$P($T(RPT+Y),";;",3),BDGDESC=$P($T(RPT+Y),";;",2)
 ;
 D @Y I $G(BDGQUIT) D END Q  ;ask more questions based on report chosen
 ;
 S X=$$BROWSE^BDGF I X="B" D @BDGRPT,END Q
 I X=U Q
 ;
 S BDGCOP=$$READ^BDGF("N^1:99","How many copies of the report",1)  ;cmi/anch/maw 2/22/2007 added to print multiple copies of report
 ;
 D ZIS^BDGF("QP",BDGRPT,BDGDESC,"BDG*")
 ;
END ;
 I $G(BDGCOP) D ^%ZISC
 D HOME^%ZIS
 K BDGSRT,BDGSRT2,BDGCOP
 Q
 ;
1 ; alpha report questions
 Q
 ;
2 ; inpt roster (ward then name) questions
 D WARD Q:$G(BDGQUIT)
 ;
 S BDGSRT2=$$READ^BDGF("YO","Would you like the report DOUBLE SPACED","NO")
 I BDGSRT2=U S BDGQUIT=1
 Q
 ;
3 ; plw questions (ward then room)
 D WARD Q:$G(BDGQUIT)
 ;cmi/anch/maw 2/21/2007 added the following line to ask if they want to separate report by ward
 S BDGONE=$$READ^BDGF("Y","Print each ward on a separate piece of paper","YES")
 I $D(^XUSEC("DGZNOCLN",DUZ)) S BDGSRT2=2 Q  ;service if no clin access
 S BDGSRT2=$$READ^BDGF("SO^1:With Diagnosis;2:With Service;3:Nursing Notes;4:Brief Listing","Select Last Column Data","","^D HELP3^BDGIPL")
 I 'BDGSRT2 S BDGQUIT=1
 Q
 ;
HELP3 ;EP; help for last column question for report 3
 D MSG^BDGF("Please select the data you want contained in the last",2,0)
 D MSG^BDGF("column of this report.",1,1)
 D MSG^BDGF(" Choose 1 to print admitting diagnosis.",1,0)
 D MSG^BDGF(" Choose 2 to print patient's current service.",1,0)
 D MSG^BDGF(" Choose 3 to leave the column blank for notes.",1,0)
 Q
 ;
4 ; pls questions (by service)
 S Y=$$READ^BDGF("YO","Print for ALL Treating Specialties","NO")
 I Y=U S BDGQUIT=1 Q
 I Y=1 S BDGSRT="A" D  Q
 . S BDGSRT2=$$READ^BDGF("S^1:Inpatient Services Only;2:Observation Services Only;3:Both","Select Service Type","Both")
 ;
 ;11/1/2002 WAR - per LJF30, P37
 ;IHS/ANMC/LJF 10/31/2002 adding ability to choose >1 service
 ;S BDGSRT=$$READ^BDGF("PO^45.7:EMQZ","Select Treating Specialty")
 ;I BDGSRT<1 S BDGQUIT=1 Q
 S Y=1 F  Q:Y<1  D
 . S X="Select "_$S($D(BDGSRT):"Another ",1:"")_"Treating Specialty Name"
 . S Y=$$READ^BDGF("PO^45.7:EMQZ",X,"","","I $$ACTSRV^BDGPAR(+Y,DT)")
 . I Y>0 S BDGSRT(+Y)=$P(Y,U,2),BDGSRT=0
 I '$D(BDGSRT) S BDGQUIT=1
 ;IHS/ANMC/LJF 10/31/2002 end of mods
 Q
 ;
5 ; service then provider questions
 I $D(^XUSEC("DGZNOCLN",DUZ)) D  Q
 . S BDGQUIT=1
 . D MSG^BDGF("Sorry, you do not have access to this report.",2,0)
 . D PAUSE^BDGF
 ;
 D 4 Q:$G(BDGQUIT)
 S Y=$$READ^BDGF("YO","Print for ALL Attending Providers","NO")
 I Y=U S BDGQUIT=1 Q
 I Y=1 S BDGSRT1="A" Q
 S BDGSRT1=$$READ^BDGF("PO^200:EMQZ","Select Provider","","","I $D(^XUSEC(""PROVIDER"",+Y))")
 I BDGSRT1<1 S BDGQUIT=1 Q
 Q
 ;
6 ; chaplain's report questions
 NEW Y
 S Y=$$READ^BDGF("YO","Print ALL Religions","NO") I Y=U S BDGQUIT=1 Q
 I Y=1 S BDGSRT="A" Q
 S BDGSRT=$$READ^BDGF("P^13:EMQZ","Select RELIGION")
 I BDGSRT<1 S BDGQUIT=1
 Q
 ;
7 ; medicare/medicaid report questions
 I $D(^XUSEC("DGZNOCLN",DUZ)) D  Q
 . S BDGQUIT=1
 . D MSG^BDGF("Sorry, you do not have access to this report.",2,0)
 . D PAUSE^BDGF
 ;
 D WARD Q:$G(BDGQUIT)
 ;cmi/anch/maw 2/22/2007 PATCH 1007 item 1007.40
 S BDGSRT2=$$READ^BDGF("S^W:Ward;C:Coverage Type","Sort By","Ward")
 Q
 ;
8 ; LOS >n days report questions
 D WARD Q:$G(BDGQUIT)
 ;
 S BDGSRT2=$$READ^BDGF("NO","What is the minimun length of Stay for this report")
 I 'BDGSRT2 S BDGQUIT=1
 Q
 ;
9 ; seriously ill list questions
 I $D(^XUSEC("DGZNOCLN",DUZ)) D  Q
 . S BDGQUIT=1
 . D MSG^BDGF("Sorry, you do not have access to this report.",2,0)
 . D PAUSE^BDGF
 ;
 D WARD Q:$G(BDGQUIT)
 S BDGSRT2=$$READ^BDGF("YO","Include DNR Patients on List","YES")
 I BDGSRT2=U S BDGQUIT=1
 Q
 ;
WARD ; ask ward questions
 NEW Y
 S Y=$$READ^BDGF("YO","Print for ALL Wards","NO")
 I Y=U S BDGQUIT=1 Q
 I Y=1 S BDGSRT="A"
 E  D
 . S BDGSRT=$$READ^BDGF("PO^42:EMQZ","Select Ward Name","","","I $$ACTWD^BDGPAR(+Y)")
 . I BDGSRT<1 S BDGQUIT=1 Q
 Q
 ;
RPT ;;
 ;;Alphabetical Listing;;^BDGIPL1;;
 ;;List by Ward and Patient;;^BDGIPL2;;
 ;;List by Ward and Room;;^BDGIPL3;;
 ;;List by Service and Patient;;^BDGIPL4;;
 ;;List by Service and Provider;;^BDGIPL5;;
 ;;Chaplain's List;;^BDGIPL6;;
 ;;Insurance Coverage List;;^BDGIPL7;;
 ;;LOS >n Days Listing;;^BDGIPL8;;
 ;;Seriously Ill/DNR List;;^BDGIPL9;;
 ;;On-line Help (Report Descriptions);;
