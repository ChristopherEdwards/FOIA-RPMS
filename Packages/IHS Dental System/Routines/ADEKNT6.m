ADEKNT6 ; IHS/HQT/MJL - COMPILE DENTAL REPORTS ;  [ 03/24/1999   9:04 AM ]
 ;;6.0;ADE;;APRIL 1999
 ;
 ;Send mail message with California FY statistics.
 ;Enter at top to receive prompt for fiscal year.
 ;Enter at CFBULL for non-interactive creation of mailman
 ;message containing fiscal year statistics.
 ;
 N ADEYQ
 S ADEYQ=$$ASKFY^ADEKNT61()
 Q:'+ADEYQ
 D CFBULL(ADEYQ)
 W !!,"Message Created!"
 Q
 ;
 ;
CFBULL(ADEYQ)      ;EP
 ;Y2K - FHL 09/04/98 ADEYQ="YYYY.Q" and Q must = 3
 Q:$P(ADEYQ,".",2)'=3  ;FY Year-end only
 ;Y2K - FHL 09/04/98
 Q:$L($P(ADEYQ,".",1))'=4  ;Y2000
 ;
 N XMB,XMDUZ,ADEED,ADEBD,ADEPER,ADE,ADEBA,ADEAGE,ADEFY
 S ADEPER=$$PERIOD^ADEKNT5($P(ADEYQ,"."),$P(ADEYQ,".",2))
 S ADEBD=$P(ADEPER,U,4)
 S ADEED=$P(ADEPER,U,2)
 ;Y2K - FHL 09/04/98
 ;S ADEFY=$E(ADEED,2,3)
 ;Y2K - FHL 09/04/98
 S ADEFY=1700+$E(ADEED,1,3)  ;Y2000
 S Y=ADEBD X ^DD("DD") S ADEBD=Y
 S Y=ADEED X ^DD("DD") S ADEED=Y
 D CONST^ADEKRP5 ;Load ADE() array with constants
 S ADEAGE="0:125"
 ;
 S XMB="ADEK-CALIF"
 S XMDUZ="THE DENTAL REPORT BULLETIN"
 ;Set the XMB() array
 ;
 S XMB(10)="" ;RPMS Site
 S XMB(10)=$O(^ADEPARAM(0)),XMB(10)=$P(^ADEPARAM(XMB(10),0),U),XMB(10)=$P(^DIC(4,XMB(10),0),U)
 ;
 S XMB(20)=ADEFY ;Fiscal year corresponding to ADEYQ
 S XMB(30)=ADEBD,XMB(40)=ADEED
 S XMB(45)=$$FMAT("^Indian^Non-Indian^Total")
 ;
 S $P(XMB(50),U)="Total Individual Patients Seen (0000)"
 S $P(XMB(50),U,2)=$P($$GETCNT^ADEKRP(ADEYQ,ADE("PTS IND"),ADEAGE),U,2)
 S $P(XMB(50),U,3)=$P($$GETCNT^ADEKRP(ADEYQ,ADE("PTS NON-IND"),ADEAGE),U,2)
 S $P(XMB(50),U,4)=$P(XMB(50),U,2)+$P(XMB(50),U,3)
 S XMB(50)=$$FMAT(XMB(50))
 ;
 S $P(XMB(60),U)="Total Visits"
 S $P(XMB(60),U,2)=$P($$GETCNT^ADEKRP(ADEYQ,ADE("VIS IND"),ADEAGE),U,2)
 S $P(XMB(60),U,3)=$P($$GETCNT^ADEKRP(ADEYQ,ADE("VIS NON-IND"),ADEAGE),U,2)
 S $P(XMB(60),U,4)=$P(XMB(60),U,2)+$P(XMB(60),U,3)
 S XMB(60)=$$FMAT(XMB(60))
 ;
 S $P(XMB(70),U)="Total Clinical Services"
 S $P(XMB(70),U,2)=$P($$GETCNT^ADEKRP(ADEYQ,ADE("SVC IND"),ADEAGE),U,2)
 S $P(XMB(70),U,3)=$P($$GETCNT^ADEKRP(ADEYQ,ADE("SVC NON-IND"),ADEAGE),U,2)
 S $P(XMB(70),U,4)=$P(XMB(70),U,2)+$P(XMB(70),U,3)
 S XMB(70)=$$FMAT(XMB(70))
 ;
 S $P(XMB(80),U)="Total Clinical Service Minutes"
 S $P(XMB(80),U,2)=$P($$GETCNT^ADEKRP(ADEYQ,ADE("MIN IND"),ADEAGE),U,2)
 S $P(XMB(80),U,3)=$P($$GETCNT^ADEKRP(ADEYQ,ADE("MIN NON-IND"),ADEAGE),U,2)
 S $P(XMB(80),U,4)=$P(XMB(80),U,2)+$P(XMB(80),U,3)
 S XMB(80)=$$FMAT(XMB(80))
 ;
 S ADEBA=$P($$GETCNT^ADEKRP(ADEYQ,ADE("BA"),ADEAGE),U,2)
 S XMB(90)="Number of Broken Appointments for FY"_ADEFY_": "_ADEBA
 S XMB(90)=XMB(90)_" = "_(ADEBA/2)_" Hours"
 ;
 ;Call ^XMB
 D ^XMB
 Q
 ;
FMAT(ADELIN)       ;EP
 ;ADELIN is a 4-^ piece string where
 ;piece 1 is row label and pieces 2,3,4 are values
 ;
 ;This function returns row label padded to 40
 ;and values right justified in 13-column spaces
 ;
 N ADES,ADELBL,ADEV,J
 S $P(ADES," ",80)=""
 S ADELBL=$P(ADELIN,U)
 S ADELBL=ADELBL_ADES
 S ADELBL=$E(ADELBL,1,40)
 ;
 F J=2:1:4 D
 . S ADEV=$P(ADELIN,U,J)
 . S ADEV=$J(ADEV,13)
 . S ADELBL=ADELBL_ADEV
 ;
 Q ADELBL
