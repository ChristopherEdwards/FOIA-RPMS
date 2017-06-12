BEDDPREF	;VNGT/HS/BEE-BEDD Utility Routine - Cache Calls ; 08 Nov 2011  12:00 PM
 ;;2.0;IHS EMERGENCY DEPT DASHBOARD;**1**;Apr 02, 2014
 ;
 ;New for BEDD*2.0*1
 ;
 ;This routine is included in the BEDD XML 2.0 Patch 1 install and is not in the KIDS
 ; 
 Q
 ;
WACCESS(DUZ)	;EP - Return whether user can edit the Whiteboard settings
 ;
 I +$G(DUZ)=0 Q 0
 I $$HASKEY^CIAVCXUS("BEDDZWHITEBOARD",DUZ) Q 1
 Q 0
 ;
LUPREF(SITE,PDUZ)	;EP - Return user preferences for a site/user
 ;
 NEW UPIEN,UPREF,RESULT
 ;
 I $G(SITE)="" Q "0^0^0^^^"  ;No site
 I $G(PDUZ)="" Q "0^0^0^^^"  ;No DUZ
 ;
 ;Look for existing entry
 S UPIEN=$O(^BEDD.EDUserPreferencesI("DUZSiteIdx"," "_PDUZ," "_SITE,""))
 ;
 ;Entry exists
 S RESULT="0^0^0^^^" I UPIEN]"" D
 . S UPREF=##class(BEDD.EDUserPreferences).%OpenId(UPIEN)
 . S $P(RESULT,"^")=$S(UPREF.HideDOB]"":UPREF.HideDOB,1:0)
 . S $P(RESULT,"^",2)=$S(UPREF.HideComp]"":UPREF.HideComp,1:0)
 . S $P(RESULT,"^",3)=$S(UPREF.HideSex]"":UPREF.HideSex,1:0)
 . S $P(RESULT,"^",4)=$S(UPREF.PatientNameFormat]"":UPREF.PatientNameFormat,1:"FLFF")
 . S $P(RESULT,"^",5)=UPREF.UserName
 . S $P(RESULT,"^",6)=PDUZ
 S UPREF=""
 ;
 Q RESULT
 ;
CHECKWB(ACVC)	;Check Whiteboard login credentials
 ;
 NEW AC,VC,SUCCESS,SiteIEN,SITE
 ;
 S AC=$P(ACVC,";")
 S VC=$P(ACVC,";",2)
 ;
 ;Check Access
 I AC'="Whiteboard" Q 0
 ;
 ;Locate verify on file
 S SiteIEN=$O(^BEDD.EDSYSTEMI("SiteIdx"," 999999",""))
 I SiteIEN]"",'$D(^BEDD.EDSYSTEMD(SiteIEN)) D
 . K ^BEDD.EDSYSTEMI("SiteIdx"," 999999")
 . S SiteIEN=""
 I SiteIEN="" Q 0
 S SITE=##CLASS(BEDD.EDSYSTEM).%OpenId(SiteIEN)
 I VC'=SITE.Verify Q 0
 ;
 Q 1
 ;
WBPREF(WVERIFY)	;EP - Save Whiteboard Information
 ;
 ;I $G(WVERIFY)="" Q 0
 ;
 NEW SiteIEN,EDSYS,STS
 ;
 ;Look for Whiteboard Entry
 S SiteIEN=$O(^BEDD.EDSYSTEMI("SiteIdx"," 999999",""))
 I SiteIEN]"",'$D(^BEDD.EDSYSTEMD(SiteIEN)) D
 . K ^BEDD.EDSYSTEMI("SiteIdx"," 999999")
 . S SiteIEN=""
 I SiteIEN="" D
 . NEW NID,RC
 . S NID=##CLASS(BEDD.EDSYSTEM).%New()
 . S NID.Site=999999
 . S NID.WhiteboardShowName=1
 . S NID.WhiteboardShowAge=1
 . S NID.WhiteboardShowProvider=1
 . S NID.WhiteboardShowNurse=1
 . S NID.WhiteboardShowOrders=1
 . S NID.WhiteboardShowNotes=1
 . S RC=NID.%Save()
 . S SiteIEN=$O(^BEDD.EDSYSTEMI("SiteIdx"," 999999",""))
 I SiteIEN="" Q 0
 ;
 ;Save the verify code
 S EDSYS=##CLASS(BEDD.EDSYSTEM).%OpenId(SiteIEN)
 S EDSYS.Verify=WVERIFY
 S STS=EDSYS.%Save()
 ;
 Q 1
 ;
SUPREF(SITE,PDUZ,HIDEDOB,HIDECOMP,HIDESEX,NAMEFRMT)	;EP - Save user preferences for a site/user
 ;
 NEW UserPref,UPIEN,STS,USER
 ;
 I $G(SITE)="" Q 0  ;No site
 I $G(PDUZ)="" Q 0  ;No DUZ
 ;
 ;Look for existing entry
 S UPIEN=$O(^BEDD.EDUserPreferencesI("DUZSiteIdx"," "_PDUZ," "_SITE,""))
 ;
 ;Get the patient name
 S USER=$P($G(^VA(200,PDUZ,0)),"^")
 ;
 ;Edits
 I UPIEN]"" D  Q 1
 . S UserPref=##class(BEDD.EDUserPreferences).%OpenId(UPIEN)
 . S UserPref.DUZ=PDUZ
 . S UserPref.HideDOB=HIDEDOB
 . S UserPref.HideComp=HIDECOMP
 . S UserPref.HideSex=HIDESEX
 . S UserPref.Site=SITE
 . S UserPref.PatientNameFormat=NAMEFRMT
 . S UserPref.UserName=USER
 . S STS=UserPref.%Save()
 . S UserPref=""
 ;
 ;Adds
 S UserPref=##class(BEDD.EDUserPreferences).%New()
 S UserPref.DUZ=PDUZ
 S UserPref.HideDOB=HIDEDOB
 S UserPref.HideComp=HIDECOMP
 S UserPref.HideSex=HIDESEX
 S UserPref.Site=SITE
 S UserPref.PatientNameFormat=NAMEFRMT
 S UserPref.UserName=USER
 S STS=UserPref.%Save()
 S UserPref=""
 ;
 Q 1
 ;
NMFRMT(PNAME,FRMT)	;Format Patient's Name
 ;
 I $G(PNAME)="" Q ""
 S:$G(FRMT)="" FRMT="FLFF"
 ;
 ;First Name Last Initial
 I FRMT="FNLI",PNAME["," Q $P($P(PNAME,",",2)," ")_" "_$E($P(PNAME,",",1),1)
 ;
 ;Full Last, First Initial
 I FRMT="FLIF",PNAME["," Q $P(PNAME,",")_", "_$E($P(PNAME,",",2),1)
 ;
 ;Last Initial, First Initial
 I FRMT="ILIF",PNAME["," Q $E($P(PNAME,",",1),1)_". "_$E($P(PNAME,",",2),1)_"."
 ;
 ;Last three, First two
 I FRMT="L3F2",PNAME["," Q $E($P(PNAME,",",1),1,3)_", "_$E($P(PNAME,",",2),1,2)
 ;
 ;Full (or messed up) Name
 I FRMT="FLFF",PNAME["," Q $P(PNAME,",")_", "_$P(PNAME,",",2)
 ;
 ;Last Name, No First
 I FRMT="LN" Q $P(PNAME,",")
 ;
 ;Messed up name
 Q PNAME
