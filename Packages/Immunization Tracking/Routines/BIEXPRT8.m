BIEXPRT8 ;IHS/CMI/MWR - EXPORT IMMUNIZATION RECORDS; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  EXPORT IMMUNIZATION RECORDS: HFS ACCESS, OTHER PROMPTS.
 ;
 ;
 ;----------
HFS(BIFLNM,BIPATH,BIOPEN,BIPOP) ;EP
 ;---> Return path, open Host File and test access.
 ;---> Parameters:
 ;     1 - BIFLNM (req) File name given by the user.
 ;     2 - BIPATH (ret) Path name set in Site Parameters.
 ;     3 - BIOPEN (opt) If BIOPEN=1, leave Device (Host File) open;
 ;                      otherwise, close Host File with %ZISC.
 ;     4 - BIPOP  (ret) BIPOP=1 if failed to open Host File.
 ;
 S BIPOP=0
 ;---> No file name.
 I $G(BIFLNM)']"" D ERRCD^BIUTL2(102,,1) S BIPOP=1 Q
 ;
 ;---> No site parameter entry.
 I $G(^BISITE(DUZ(2),0))']"" D ERRCD^BIUTL2(103,,1) S BIPOP=1 Q
 ;
 ;---> Path not set.
 S BIPATH=$P(^BISITE(DUZ(2),0),U,14)  N X S X="I"_"O(1)" K @X
 I BIPATH']"" D ERRCD^BIUTL2(104,,1) S BIPOP=1 Q
 ;
 ;---> Attempt to open Host File Server.
 S BIPOP=$$OPEN^%ZISH(BIPATH,BIFLNM,"W")
 ;
 ;---> If not valid PATH, will bomb with a <MODER>.
 ;---> Purpose here is to test Host File access before beginning search.
 I BIPOP D ^%ZISC,ERRCD^BIUTL2(101,,1) Q
 U IO W ""
 D:'$G(BIOPEN) ^%ZISC
 Q
 ;
 ;----------
OKAY(BIPOP) ;EP
 ;---> Get final okay to continue.
 ;---> Parameters:
 ;     1 - BIPOP   (ret) BIPOP=1 if DIRUT *or* if Not OK to proceed.
 ;
 D IO^BIO("Do you REALLY wish to export records now?")
 N A S BIPOP=0
 S A="     Enter YES to export records, enter NO to abort this process."
 D DIR^BIFMAN("Y",.Y,.BIPOP,"   Enter Yes or No","YES",A)
 I BIPOP!(Y=0) D  Q
 .D IO^BIO("* NO RECORDS EXPORTED. *","!!?25")
 .D DIRZ^BIUTL3(.BIPOP) S BIPOP=1  ;---> If Y=0 flag "not okay".
 ;
 S A="Please hold while records are scanned.  This may take awhile..."
 D IO^BIO(A,"!!?3")
 Q
